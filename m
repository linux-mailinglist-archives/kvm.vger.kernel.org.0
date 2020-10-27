Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15229CCF3
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgJ1BiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:19 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:42595 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832972AbgJ0XLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:11:09 -0400
Received: by mail-yb1-f202.google.com with SMTP id u13so3114030ybk.9
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Naifs7owNcfj47yxgHsuvjNi7Wp+K1Q0X17CuMJUCEM=;
        b=QDOcwvFMVzLTVHuE0DRFkyoDUJyELxZngbiCC1qWUugFXcHraJQj6WBNzdsus+EkcC
         H4/RTFX4HV6iQwDfRkM3qbXUSwPspy7yY6miYlmcGw5XPhV7xRv++Msezbxsl0ocGKlD
         2IZ6pkXtDVx5CgtBYhkZef7/q8mKR/SxZ7GxFwCe8claU4hM/CYv+O7lx4vWi/VLeaO0
         mnxQgLj6sl2rm3g11wCm9tNfhqy/urZgiMWAn25Ww7TH9hj2xpmHKdt2TttL/XRNULBR
         xBEfPIdcFm+1wzUIgrc8JD06F7Sio+103663xJAF0PBtBMW5oxFGjHtEH+utd5VPO20+
         ySzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Naifs7owNcfj47yxgHsuvjNi7Wp+K1Q0X17CuMJUCEM=;
        b=s6wslj/o2PHsaMLWl0uB8CJk6uSKpw/X7jOMuyA4MxyrH/uEmbHG4mNnkmnQDcmGYr
         g1eZ6lRbxuve/qJSywr4lomBlJ4izHvv3w/33mpfKGUi7g/hhBw9rkiD/nkygCAgckcY
         Ap4K1PLDht+BoK77RRI0YIFYQAgcaX0csO6/EZWrR/vUlpFK8cn6XaPtoNU64Ts+Tj8q
         UlfPmpFZQmdwRYsq/uh6U9sHgutDQ+OHd71VxCmaLIeYIxSI+s+UR1bXC55LI++oyE4x
         mfdg1XPphCJaa89h6GeolkX3ETwv/2Iv1gJqqNjMqNvCR4fNs52iLhOioTbMNF7y4c7J
         nNdg==
X-Gm-Message-State: AOAM5325rrGlF2F/ooKzDU7rSQwv60ZB9NOmugyTY6Tryg+0dGd9Xahh
        PHmC4evcJuAoKZh8/i/n0C0E6WfBi4TXTxzTKxmEi4PMpPpyoP5cu+bijdgtukcBz7xoxbVk8Kp
        BLWEK1bmyLo2PbttqrpKhNVaij9J7Gc3P59w7WRVcZoOxy4prXWaDTd/Yaw==
X-Google-Smtp-Source: ABdhPJy9N5eK8EGvGi6gXjq44vGiSqpfpXS8l5TRQj4KnYmTwhOwX/D8rmDdhTx6ClCemTDda2GjGxTXJbU=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a25:f210:: with SMTP id i16mr6696758ybe.139.1603840267141;
 Tue, 27 Oct 2020 16:11:07 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:42 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-5-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 4/6] kvm: x86: ensure pv_cpuid.features is initialized when
 enabling cap
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the paravirtual cpuid enforcement mechanism idempotent to ioctl()
ordering by updating pv_cpuid.features whenever userspace requests the
capability. Extract this update out of kvm_update_cpuid_runtime() into a
new helper function and move its other call site into
kvm_vcpu_after_set_cpuid() where it more likely belongs.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/cpuid.c | 23 ++++++++++++++++-------
 arch/x86/kvm/cpuid.h |  1 +
 arch/x86/kvm/x86.c   |  2 ++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06a278b3701d..d50041f570e8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -90,6 +90,20 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 	return 0;
 }
 
+void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+
+	/*
+	 * save the feature bitmap to avoid cpuid lookup for every PV
+	 * operation
+	 */
+	if (best)
+		vcpu->arch.pv_cpuid.features = best->eax;
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -124,13 +138,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
-	/*
-	 * save the feature bitmap to avoid cpuid lookup for every PV
-	 * operation
-	 */
-	if (best)
-		vcpu->arch.pv_cpuid.features = best->eax;
-
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
 		if (best)
@@ -162,6 +169,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
 
+	kvm_update_pv_runtime(vcpu);
+
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index bf8577947ed2..f7a6e8f83783 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -11,6 +11,7 @@ extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
+void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4016c07c8920..2970045a885e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4609,6 +4609,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		vcpu->arch.pv_cpuid.enforce = cap->args[0];
+		if (vcpu->arch.pv_cpuid.enforce)
+			kvm_update_pv_runtime(vcpu);
 
 		return 0;
 
-- 
2.29.0.rc2.309.g374f81d7ae-goog

