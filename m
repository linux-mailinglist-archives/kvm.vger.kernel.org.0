Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8205F5D9E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJFAUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJFAUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:20:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36365EE32
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:19:59 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q63-20020a632a42000000b0045724b1dfb9so174642pgq.3
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9WEcnWLMKxZwMtTodHX4q5GvyqiEbURiuxhFWhQzg8=;
        b=oXcxSA13acU4as0darZJViHLiCmfX3PuNH4O6iD4Nq/xd+SJ+wzTcP6WlXT/RT/+1d
         fXaaeZAh3ahLxBdHOYbF7PWcgwLTFUDMjHR/Q8aauABnQj9g8i57nLbp5yHlx8E9Y7lB
         F8U688GPCwmmeiulMv3REbxAkVbsXuw7yu74Mz9p4NrnZbOnUVxp2La2XxqGkUwZ6Xkx
         58Id57mZwVVQ/gcGpBDt/bF4zGoehjIRV2ksLaKJ4QUDTh3kUpTMWgwgJ/f+NWKii8j/
         TD/iSPOVb4cMA1zjFBvLI88uFDxEv9EEi7BL17OIHA/F0JhFBn1iYW95GB41ajc3Zu0p
         OR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o9WEcnWLMKxZwMtTodHX4q5GvyqiEbURiuxhFWhQzg8=;
        b=Qqu+m8wksPdDCBlY4/ktf22k9vPx1F6PFWiFy4VKh4XAkmZca5YCQR30U7YsGvgSuV
         NCGXxcaLcOlQ9QUrUf+bCEhlLbBXkEASgu6CAW4kTFRshFlMnqaqz+nnq5I17jktIHfx
         J+nKsavgIJh3bfUR2RQ13nHRoR0hi8znbA2g8UMWmx06cvRzdFG6TzhJ+e/c3xh4myRJ
         AUY6HCAFZyLW1dTp569UbtjZJtjPjbEpYgeMzuc8bBP2SrayciSmIB4EWdkeI/d7vTEz
         mj7SE1pKKs7A3qtXY0dmrlzffA6WpOAmrQge5DWKV7X8rzJ7CrDmZWOrCOXp45A75dOy
         Mmdg==
X-Gm-Message-State: ACrzQf2Z13yxLMB/Mxfdz9WOFl+PqZkcS+KL6wPXsPYCjKqEmwVg+YES
        2rMMl6E+Ln3bzqQsf8OZvyHmoeCNvIU=
X-Google-Smtp-Source: AMsMyM6VAC7yrcpRHro1NEZgo4Ciub9t/u7KEYjsP9iAd9sy6LEpCHIC3zj3L32DIRDw/0n7URyCJTFd3n0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:584:0:b0:55a:a7a5:b597 with SMTP id
 126-20020a620584000000b0055aa7a5b597mr2331554pff.71.1665015598823; Wed, 05
 Oct 2022 17:19:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:19:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006001956.329314-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4
 check fails
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Li <ercli@ucdavis.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject #GP for if VMXON is attempting with a CR0/CR4 that fails the
generic "is CRx valid" check, but passes the CR4.VMXE check, and do the
generic checks _after_ handling the post-VMXON VM-Fail.

The CR4.VMXE check, and all other #UD cases, are special pre-conditions
that are enforced prior to pivoting on the current VMX mode, i.e. occur
before interception if VMXON is attempted in VMX non-root mode.

All other CR0/CR4 checks generate #GP and effectively have lower priority
than the post-VMXON check.

Per the SDM:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD;
    ELSIF not in VMX operation
        THEN
            IF (CPL > 0) or (in A20M mode) or
            (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);
    ELSIF in VMX non-root operation
        THEN VMexit;
    ELSIF CPL > 0
        THEN #GP(0);
    ELSE VMfail("VMXON executed in VMX root operation");
    FI;

which, if re-written without ELSIF, yields:

    IF (register operand) or (CR0.PE = 0) or (CR4.VMXE = 0) or ...
        THEN #UD

    IF in VMX non-root operation
        THEN VMexit;

    IF CPL > 0
        THEN #GP(0)

    IF in VMX operation
        THEN VMfail("VMXON executed in VMX root operation");

    IF (in A20M mode) or
       (the values of CR0 and CR4 are not supported in VMX operation)
                THEN #GP(0);

Note, KVM unconditionally forwards VMXON VM-Exits that occur in L2 to L1,
i.e. there is no need to check the vCPU is not in VMX non-root mode.  Add
a comment to explain why unconditionally forwarding such exits is
functionally correct.

Reported-by: Eric Li <ercli@ucdavis.edu>
Fixes: c7d855c2aff2 ("KVM: nVMX: Inject #UD if VMXON is attempted with incompatible CR0/CR4")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Eric, any testing you can provide would be very welcome.  It took me an
embarassingly long time to wrap my head around the SDM's pseucode.  I
_think_ I got it right this time...

 arch/x86/kvm/vmx/nested.c | 60 ++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8f67a9c4a287..19b2f55e7666 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5099,33 +5099,55 @@ static int handle_vmxon(struct kvm_vcpu *vcpu)
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
-	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
-	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
-	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 * Manually check CR4.VMXE checks, KVM must force CR4.VMXE=1 to enter
+	 * the guest and so cannot rely on hardware to perform the check,
+	 * which has higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON).
 	 *
-	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
-	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
-	 * Mode, but KVM will never take the guest out of those modes.
+	 * Rely on hardware for the other pre-VM-Exit checks, CR0.PE=1, !VM86
+	 * and !COMPATIBILITY modes.  For an unrestricted guest, KVM doesn't
+	 * force any of the relevant guest state.  For a restricted guest, KVM
+	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
+	 * Real Mode, and so there's no need to check CR0.PE manually.
+	 */
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
+	}
+
+	/*
+	 * The CPL is checked for "not in VMX operation" and for "in VMX root",
+	 * and has higher priority than the VM-Fail due to being post-VMXON,
+	 * i.e. VMXON #GPs outside of VMX non-root if CPL!=0.  In VMX non-root,
+	 * VMXON causes VM-Exit and KVM unconditionally forwards VMXON VM-Exits
+	 * from L2 to L1, i.e. there's no need to check for the vCPU being in
+	 * VMX non-root.
+	 *
+	 * Forwarding the VM-Exit unconditionally, i.e. without performing the
+	 * #UD checks (see above), is functionally ok because KVM doesn't allow
+	 * L1 to run L2 without CR4.VMXE=0, and because KVM never modifies L2's
+	 * CR0 or CR4, i.e. it's L2's responsibility to emulate #UDs that are
+	 * missed by hardware due to shadowing CR0 and/or CR4.
+	 */
+	if (vmx_get_cpl(vcpu)) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	if (vmx->nested.vmxon)
+		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
+
+	/*
+	 * Invalid CR0/CR4 generates #GP.  These checks are performed if and
+	 * only if the vCPU isn't already in VMX operation, i.e. effectively
+	 * have lower priority than the VM-Fail above.
 	 */
 	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
 	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
-		return 1;
-	}
-
-	/*
-	 * CPL=0 and all other checks that are lower priority than VM-Exit must
-	 * be checked manually.
-	 */
-	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
-	if (vmx->nested.vmxon)
-		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
-
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
 		kvm_inject_gp(vcpu, 0);

base-commit: e779ce9d17c44a338b4fa3be8715e3b7eb9706f0
-- 
2.38.0.rc1.362.ged0d419d3c-goog

