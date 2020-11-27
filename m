Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE42C63D9
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 12:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgK0LVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 06:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbgK0LVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 06:21:21 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B10A2222A;
        Fri, 27 Nov 2020 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606476081;
        bh=uSWDwx9Mf1mz4a4sUj9aoF18Ki8K132MbX4ipSnTuaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSdQ4/SiMbCkHZxxf4Xs9Ns/mlpYP1T71glovqQ0NVcxhqtksVhVYpdTLzXNhgxZv
         vxegoO+0yoZaQO+E1WUMzUy6gw3GLPoQWV/C2mTN1/jNxJWk44z60pdoSM8Y8O6IOi
         Clu/4rn5Cy8XBMNSox/QlksFtx2LpU1VnU5t6Xvg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiboV-00E2fR-EV; Fri, 27 Nov 2020 11:21:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jamie Iles <jamie@nuviainc.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Correctly align nVHE percpu data
Date:   Fri, 27 Nov 2020 11:21:00 +0000
Message-Id: <20201127112101.658224-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201127112101.658224-1-maz@kernel.org>
References: <20201127112101.658224-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, eric.auger@redhat.com, jamie@nuviainc.com, zhukeqian1@huawei.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

The nVHE percpu data is partially linked but the nVHE linker script did
not align the percpu section.  The PERCPU_INPUT macro would then align
the data to a page boundary:

  #define PERCPU_INPUT(cacheline)					\
  	__per_cpu_start = .;						\
  	*(.data..percpu..first)						\
  	. = ALIGN(PAGE_SIZE);						\
  	*(.data..percpu..page_aligned)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu..read_mostly)					\
  	. = ALIGN(cacheline);						\
  	*(.data..percpu)						\
  	*(.data..percpu..shared_aligned)				\
  	PERCPU_DECRYPTED_SECTION					\
  	__per_cpu_end = .;

but then when the final vmlinux linking happens the hypervisor percpu
data is included after page alignment and so the offsets potentially
don't match.  On my build I saw that the .hyp.data..percpu section was
at address 0x20 and then the percpu data would begin at 0x1000 (because
of the page alignment in PERCPU_INPUT), but when linked into vmlinux,
everything would be shifted down by 0x20 bytes.

This manifests as one of the CPUs getting lost when running
kvm-unit-tests or starting any VM and subsequent soft lockup on a Cortex
A72 device.

Fixes: 30c953911c43 ("kvm: arm64: Set up hyp percpu data for nVHE")
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: David Brazdil <dbrazdil@google.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201113150406.14314-1-jamie@nuviainc.com
---
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index bb2d986ff696..a797abace13f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -13,6 +13,11 @@
 
 SECTIONS {
 	HYP_SECTION(.text)
+	/*
+	 * .hyp..data..percpu needs to be page aligned to maintain the same
+	 * alignment for when linking into vmlinux.
+	 */
+	. = ALIGN(PAGE_SIZE);
 	HYP_SECTION_NAME(.data..percpu) : {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
-- 
2.28.0

