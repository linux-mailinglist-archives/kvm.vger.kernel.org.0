Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C7252D4E3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiESNrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiESNrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BA549F37
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB748617C1
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EACC34116;
        Thu, 19 May 2022 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968003;
        bh=kgENcXfDAe+sx9c87Cb7w5AnDvemeP3zb9MSHnnKeBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjfvBwcxc0CDVBgdK0cyBAv6bmGMIHmagBvNXm4nsCVvV/4S9A2KI2m7z8GSuMvpQ
         Rc0VMktQzoYDV2sZiXyyXBlvnNtvx0cTN9efsjsu+nYGxV8jcIjHQHNqHajcYYiSFE
         WC314ABABqOrRIxHdLjedC9YyaWuZGddgKjG+iYk1Au0rUd5ylD3sePHHk37X3poMC
         vubMdvlScVWTH8KodKsajSjSqb1BUxqMnCoV9EIE/MDUU43Ky7S62wEvMoRJUrLnrL
         qib+yVWT4mkisVq6/govseqNN4Pw+B4/ftWZkhR+b9CJv9iOJqDLwxLGSbMBGKWma/
         Zmzh2pZGRGCPw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 65/89] KVM: arm64: Force injection of a data abort on NISV MMIO exit
Date:   Thu, 19 May 2022 14:41:40 +0100
Message-Id: <20220519134204.5379-66-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

If a vcpu exits for a data abort with an invalid syndrome, the
expectations are that userspace has a chance to save the day if
it has requested to see such exits.

However, this is completely futile in the case of a protected VM,
as none of the state is available. In this particular case, inject
a data abort directly into the vcpu, consistent with what userspace
could do.

This also helps with pKVM, which discards all syndrome information when
forwarding data aborts that are not known to be MMIO.

Finally, hide the RETURN_NISV_IO_ABORT_TO_USER cap from userspace on
protected VMs, and document this tweak to the API.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst |  7 +++++++
 arch/arm64/kvm/arm.c           | 14 ++++++++++----
 arch/arm64/kvm/mmio.c          |  9 +++++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d13fa6600467..207706260f67 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6115,6 +6115,13 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+This feature isn't available to protected VMs, as userspace does not
+have access to the state that is required to perform the emulation.
+Instead, a data abort exception is directly injected in the guest.
+Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
+queried outside of a protected VM context, the feature will not be
+exposed if queried on a protected VM file descriptor.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 65af1757e73a..9c5a935a9a73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -84,9 +84,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
-		r = 0;
-		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
-			&kvm->arch.flags);
+		if (kvm_vm_is_protected(kvm)) {
+			r = -EINVAL;
+		} else {
+			r = 0;
+			set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+				&kvm->arch.flags);
+		}
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -217,13 +221,15 @@ static int kvm_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
-	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
 		r = 1;
 		break;
+	case KVM_CAP_ARM_NISV_TO_USER:
+		r = !kvm || !kvm_vm_is_protected(kvm);
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..db6630c70f8b 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,8 +133,17 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
+	 *
+	 * In the protected VM case, there isn't much userspace can do
+	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+		if (is_protected_kvm_enabled() &&
+		    kvm_vm_is_protected(vcpu->kvm)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.36.1.124.g0e6072fb45-goog

