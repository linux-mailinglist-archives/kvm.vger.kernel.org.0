Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C6E47FCBF
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhL0MtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 07:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbhL0Ms7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 07:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84612C06173E
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 04:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F16F60FF9
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3380C36AE7;
        Mon, 27 Dec 2021 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640609338;
        bh=Xlmzd6uUTWdOSWaStHp5yLqb3jDTsl7a86GMPfk49ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lewsgRhXWiM5UUf0n6VtXuv+3u5kfPbr3WV9z4NI3Rde+pJaAl/7FUymwHjzdkXKC
         p2CYGNGKLi/Nrczv+viJScw+QyXe87MWmMP6h1mRVZkrlDLE4+oGY6leNceTk8/NFQ
         UB+lSa0S9kmAXxksrZxWOffp2CsAq55fW5kpyxosWsLFI4dzt6g2ty3HR4B4laDZrC
         sS3NAAmOFurSwYyyyBBkeUhTwTGM/B/5rNLOhaJeL3+GkIkh+995phSsl5nQ4yEwDI
         rtqeAV2M32P6a1phEp6J/Mt7EEQUjJTw63p2ZkEA7VJUIqvswJFkOLUL8N1GaRrCPf
         V9JKYqkc9+Mvg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1pQu-00EYBY-4Z; Mon, 27 Dec 2021 12:48:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH v2 1/6] KVM: selftests: arm64: Initialise default guest mode at test startup time
Date:   Mon, 27 Dec 2021 12:48:04 +0000
Message-Id: <20211227124809.1335409-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227124809.1335409-1-maz@kernel.org>
References: <20211227124809.1335409-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we are going to add support for a variable default mode on arm64,
let's make sure it is setup first by using a constructor that gets
called before the actual test runs.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index b4eeeafd2a70..b509341b8411 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -432,3 +432,12 @@ uint32_t guest_get_vcpuid(void)
 {
 	return read_sysreg(tpidr_el1);
 }
+
+/*
+ * arm64 doesn't have a true default mode, so start by computing the
+ * available IPA space and page sizes early.
+ */
+void __attribute__((constructor)) init_guest_modes(void)
+{
+       guest_modes_append_default();
+}
-- 
2.30.2

