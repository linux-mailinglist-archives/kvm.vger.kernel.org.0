Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ACD4165D0
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbhIWTRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242823AbhIWTRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73037C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m16-20020a25d410000000b005ab243aaaf4so300568ybf.20
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YX6wLWSIJTG38D0JCJDYsCJb2+sCdnlZJoLOpE40P6M=;
        b=Igy6VVMKWdhPbPXq1S7BSk4Zo0tnmp6XkOd5OoVhvbxZfpbMMdSjLKLrVZQfDwkijt
         Gid6Wob2mCp9b9SwnyLnbx06l3w1bICa2ctn4n6NANLSLTQSfnclob8KsMXrr5CL7F/D
         J0NefWfn8S8LKdSN+qJJgpBc5NH36yiRxOp85vnJChbIFKT7LcWaX7GP26tnUU3CtKyK
         avfHaoIlf2XKDDeBLpSQhEQrrc/eZ0OjtOGpFnqD7LyWSexSfd/IUPHQWjv2Uxjsik/L
         0rxFMjqae0jVCJEdLx+HqyPqqpTs839lVDhapYnYePAoM79WsF90TOhK/RrMmzA4+Czl
         LyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YX6wLWSIJTG38D0JCJDYsCJb2+sCdnlZJoLOpE40P6M=;
        b=Z5/wkiKpkjDK0/lLQYusk5PHbLJeyQ7U+7QI16z/MozAo56MPdAQmin7BkSu8reF0Q
         WXsnnuTt29T2zqYXX6sA0AeMsnFR2VSKW8MfC3YerDN1KcVxxgHOSmOFsWLmdl04GUpj
         ywdwdBr/z01betW8O8yem5FVOBfdlEHXT7sqoAmtadkeeK+mO9qNuE9/J+0XbjqoN3kf
         GQVJj4CgFpypwZAUvgwWAAKbmTzWsFVO3OIOu/qkoSAz7IAP5IdXHS3I/mufKIl6D3iU
         S21Jxr2aVmRoxpY/KXXrxzAkwjYp9aA5joc3tNoJ8k7va8dfP+K9Yia/fQbuIsWZVAN5
         KdCw==
X-Gm-Message-State: AOAM5317zzqYs9GpwnddpWGVdgeyZFvOy9Vaw9o13ld1t42roKcbvrsH
        KqbGNPSMgFIC1ExNonCPiE54Q0QBbc0=
X-Google-Smtp-Source: ABdhPJz1tbWEEs1Gv4kYcRNWO/op3Eino71+uPo4QLG2oDpchkCrTFHJgIB2O8EyPAJDVKVyWcqX4trvHyo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:12d6:: with SMTP id 205mr8004600ybs.441.1632424581627;
 Thu, 23 Sep 2021 12:16:21 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:04 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-6-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested event
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The emulation of WFI-like instructions (WFI, PSCI CPU_SUSPEND) is done
by calling kvm_vcpu_block() directly from the respective exit handlers.
A subsequent change to KVM will allow userspace to request a vCPU be
suspended on the next KVM_RUN, necessitating a deferral mechanism for
WFI emulation.

Refactor such that there is a single WFI implementation which may be
requested with KVM_REQ_SUSPEND. Request WFI emulation from the
aforementioned handlers by making this request.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 9 +++++++++
 arch/arm64/kvm/handle_exit.c      | 3 +--
 arch/arm64/kvm/psci.c             | 4 +---
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..1beda1189a15 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -47,6 +47,7 @@
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3d4acd354f94..f1a375648e25 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -670,6 +670,12 @@ static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 	smp_rmb();
 }
 
+static void kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_block(vcpu);
+	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+}
+
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.target >= 0;
@@ -681,6 +687,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			kvm_vcpu_sleep(vcpu);
 
+		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
+			kvm_vcpu_suspend(vcpu);
+
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 275a27368a04..5e5ef9ff4fba 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -95,8 +95,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
-		kvm_vcpu_block(vcpu);
-		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	}
 
 	kvm_incr_pc(vcpu);
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index bb59b692998b..d453666ddb83 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -46,9 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * specification (ARM DEN 0022A). This means all suspend states
 	 * for KVM will preserve the register state.
 	 */
-	kvm_vcpu_block(vcpu);
-	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
-
+	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	return PSCI_RET_SUCCESS;
 }
 
-- 
2.33.0.685.g46640cef36-goog

