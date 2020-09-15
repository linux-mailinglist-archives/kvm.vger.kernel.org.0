Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A916F26A396
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIOKtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 06:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgIOKmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 06:42:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5163720735;
        Tue, 15 Sep 2020 10:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600166561;
        bh=+f+XJhOhIVIVtwBYBolA4BBiPSB/0HpuyUUu4Y/SScw=;
        h=From:To:Cc:Subject:Date:From;
        b=OhQNwqQjsQqHgf+XtrZADhkQ8kIaELoQHZIkKRxF/yTjNoFhYellzfFrT7KdU/cVH
         g3SV4OLUKvTnoR9MRA3SymLaLC1wz4qhd5QNkf5jSJZ6ABi2rnhXEazzR0rFMeBSqi
         XegQfYfquryYLFgl1cEq67QW7a/CQ1R66jKqwpeA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kI8Q3-00ByDU-Ci; Tue, 15 Sep 2020 11:42:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: Fix handling of S1PTW
Date:   Tue, 15 Sep 2020 11:42:16 +0100
Message-Id: <20200915104218.1284701-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I recently managed to trigger an interesting failure mode, where a
guest would be stuck on an instruction abort due to a permission
fault. Interestingly enough, this IABT had S1PTW set in the ESR,
indicating that it was trying to *write* to the PT. We fix it by
adding the execute permission (it's an IABT, after all...), and going
nowhere fast.

Note that it can only happen on a system that can perform automatic
updates of the page table flags.

This small series fixes the issue by revamping the S1PTW handling in
the context of execution faults. The first patch fixes the bug, and is
definitely a stable candidate. The second patch is merely a cleanup,
which can wait.

Tested on an A55-based board.

* From v1:
  - Rename kvm_vcpu_dabt_iss1tw() to kvm_vcpu_abt_iss1tw()
  - Don't overload kvm_vcpu_trap_is_iabt()
  - Introduce kvm_vcpu_trap_is_exec_fault()

Marc Zyngier (2):
  KVM: arm64: Assume write fault on S1PTW permission fault on
    instruction fetch
  KVM: arm64: Remove S1PTW check from kvm_vcpu_dabt_iswrite()

 arch/arm64/include/asm/kvm_emulate.h    | 14 +++++++++++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    |  4 ++--
 3 files changed, 14 insertions(+), 6 deletions(-)

-- 
2.28.0

