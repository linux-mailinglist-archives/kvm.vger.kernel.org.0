Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533DB48C554
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 14:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241565AbiALN61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 08:58:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241197AbiALN60 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 08:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641995905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u92yA883SjiA8RmcsqvmgxkfZYspTwlEn6ow9YD5DEM=;
        b=Wt2a4mqNBokJuVhpVwChdixFBtclZD1bNT5/kmxyvSeWYrNfk7Jp32+t5Nej/+toNtxVBE
        kX7i+1MhDMtpc1sUuSxt/8hzZ7PxQRg/9LF0JPRCYhy77Qb8XTz1xDsUa1LxAPDl4/WpLE
        obt1zhN0G8qOS6JyvVo1R3QDw4NrP1g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-InQKPk0fNmean9YMHlg1nw-1; Wed, 12 Jan 2022 08:58:23 -0500
X-MC-Unique: InQKPk0fNmean9YMHlg1nw-1
Received: by mail-ed1-f70.google.com with SMTP id j10-20020a05640211ca00b003ff0e234fdfso2379707edw.0
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 05:58:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=u92yA883SjiA8RmcsqvmgxkfZYspTwlEn6ow9YD5DEM=;
        b=e75fV/XdGrEqXpaCPHar6VRNaEjH1KL+79Tod3H7LidtPjHz1hElkrADcNQ7ns3/E9
         k5r8lR5Yu8bnRYcrVEe15//ObcW9bFo/ZvYtieGhwiXIDkivGWOw8HmB0S4MziiwGNFF
         r6Fj01xf4PJFPSqDivRxfthjLncieM9a+Td1rLavIKMkPiq7DqXCxivWCUW4WU4cDPr+
         kOTElN/vqFltAkK8sT9+LBxA+IzbRQpsHlA4TnAb/CXqLWaoSjuR/J/SvH0HoWQidOp4
         qU4h+q8hH95mWL86Tim1ME5OQGGMmFCc4HiIMUTWso/XTu7mPOy0fUnWpR0U0g1k3EdB
         W35w==
X-Gm-Message-State: AOAM533hx5AzFqqAotQ2N57OsFFfif9m/n9jDmbzRWgcX1BSs2ry9B90
        j/YU56JdVh56rBr3Wf4pySLJt+fnOCMSqCPYh1AuacUDbafDwI9EJoW15ZJLDgWXm4yvo3Stoap
        aSsBPZQ0tvA+4
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr7547993ejc.39.1641995902102;
        Wed, 12 Jan 2022 05:58:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQWCCq3M0i6JXw8e8/d6zE68bpCKlO/E128Sxu1xmkY7DvL2COwCFZkw0bskJ47bnhDkzIrQ==
X-Received: by 2002:a17:906:478a:: with SMTP id cw10mr7547984ejc.39.1641995901935;
        Wed, 12 Jan 2022 05:58:21 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id kw14sm4525869ejc.68.2022.01.12.05.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 05:58:20 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <20220111090022.1125ffb5@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
 <87o84qpk7d.fsf@redhat.com> <877dbbq5om.fsf@redhat.com>
 <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
 <20220111090022.1125ffb5@redhat.com>
Date:   Wed, 12 Jan 2022 14:58:19 +0100
Message-ID: <87fsptnjic.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Igor Mammedov <imammedo@redhat.com> writes:

> On Fri, 7 Jan 2022 19:15:43 +0100
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>> On 1/7/22 10:02, Vitaly Kuznetsov wrote:
>> > 
>> > I'm again leaning towards an allowlist and currently I see only two
>> > candidates:
>> > 
>> > CPUID.01H.EBX bits 31:24 (initial LAPIC id)
>> > CPUID.0BH.EDX (x2APIC id)
>> > 
>> > Anything else I'm missing?  
>> 
>> I would also ignore completely CPUID leaves 03H, 04H, 0BH, 80000005h, 
>> 80000006h, 8000001Dh, 8000001Eh (cache and processor topology), just to 
>> err on the safe side.
>
> on top of that,
>
> 1Fh
>

The implementation turned out to be a bit more complex as kvm also
mangles CPUIDs so we need to account for that. Could you give the
attached series a spin to see if it works?

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-x86-Fix-indentation-in-kvm_set_cpuid.patch

From 9b7d89c0a86f52e404278a5dfd86521bff278d17 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 12 Jan 2022 14:41:24 +0100
Subject: [PATCH RFC 1/3] KVM: x86: Fix indentation in kvm_set_cpuid()

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..89af3c7390d3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -276,21 +276,21 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
-    int r;
+	int r;
 
-    r = kvm_check_cpuid(e2, nent);
-    if (r)
-        return r;
+	r = kvm_check_cpuid(e2, nent);
+	if (r)
+		return r;
 
-    kvfree(vcpu->arch.cpuid_entries);
-    vcpu->arch.cpuid_entries = e2;
-    vcpu->arch.cpuid_nent = nent;
+	kvfree(vcpu->arch.cpuid_entries);
+	vcpu->arch.cpuid_entries = e2;
+	vcpu->arch.cpuid_nent = nent;
 
-    kvm_update_kvm_cpuid_base(vcpu);
-    kvm_update_cpuid_runtime(vcpu);
-    kvm_vcpu_after_set_cpuid(vcpu);
+	kvm_update_kvm_cpuid_base(vcpu);
+	kvm_update_cpuid_runtime(vcpu);
+	kvm_vcpu_after_set_cpuid(vcpu);
 
-    return 0;
+	return 0;
 }
 
 /* when an old userspace process fills a new kernel module */
-- 
2.34.1


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0002-KVM-x86-Do-runtime-CPUID-update-before-updating-vcpu.patch

From c735aa9b4375d37dbd61c7c655d6b007d7d1962c Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 12 Jan 2022 14:27:54 +0100
Subject: [PATCH RFC 2/3] KVM: x86: Do runtime CPUID update before updating
 vcpu->arch.cpuid_entries

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89af3c7390d3..16f4083edeeb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -125,14 +125,21 @@ static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
 	}
 }
 
-static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
+					      struct kvm_cpuid_entry2 *entries, int nent)
 {
 	u32 base = vcpu->arch.kvm_cpuid_base;
 
 	if (!base)
 		return NULL;
 
-	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
+	return cpuid_entry2_find(entries, nent, base | KVM_CPUID_FEATURES, 0);
+}
+
+static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu)
+{
+	return __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
+					     vcpu->arch.cpuid_nent);
 }
 
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
@@ -147,11 +154,12 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
 
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
+	best = cpuid_entry2_find(entries, nent, 1, 0);
 	if (best) {
 		/* Update OSXSAVE bit */
 		if (boot_cpu_has(X86_FEATURE_XSAVE))
@@ -162,33 +170,39 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 	}
 
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
+	best = cpuid_entry2_find(entries, nent, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
+	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
 
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = kvm_find_kvm_cpuid_features(vcpu);
+	best = __kvm_find_kvm_cpuid_features(vcpu, vcpu->arch.cpuid_entries,
+					     vcpu->arch.cpuid_nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
+		best = cpuid_entry2_find(entries, nent, 0x1, 0);
 		if (best)
 			cpuid_entry_change(best, X86_FEATURE_MWAIT,
 					   vcpu->arch.ia32_misc_enable_msr &
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 }
+
+void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
+{
+	__kvm_update_cpuid_runtime(vcpu, vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+}
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -278,6 +292,8 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 {
 	int r;
 
+	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+
 	r = kvm_check_cpuid(e2, nent);
 	if (r)
 		return r;
@@ -287,7 +303,6 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	kvm_update_kvm_cpuid_base(vcpu);
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
-- 
2.34.1


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0003-KVM-x86-Partially-allow-KVM_SET_CPUID-2-after-KVM_RU.patch

From f29f2c4e48540f3e1214a6ecdd49510465d2d234 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Wed, 12 Jan 2022 12:51:01 +0100
Subject: [PATCH RFC 3/3] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/cpuid.c | 69 +++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c   | 19 ------------
 2 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 16f4083edeeb..0f130d686323 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -80,9 +80,11 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	return NULL;
 }
 
-static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
+static int kvm_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+			   int nent, bool is_update)
 {
-	struct kvm_cpuid_entry2 *best;
+	struct kvm_cpuid_entry2 *best, *e;
+	int i;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -96,6 +98,58 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
+	if (!is_update)
+		return 0;
+
+	/*
+	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
+	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
+	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
+	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
+	 * the core vCPU model on the fly. It would've been better to forbid any
+	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
+	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and they
+	 * need to set CPUID to e.g. change [x2]APIC id. Implement an allowlist
+	 * of CPUIDs which are allowed to change.
+	 */
+	for (i = 0; i < nent; i++) {
+		e = &entries[i];
+
+		best = kvm_find_cpuid_entry(vcpu, e->function, e->index);
+		if (!best)
+			return -EINVAL;
+
+		switch (e->function) {
+		case 0x1:
+			/* Only initial LAPIC id is allowed to change */
+			if (e->eax ^ best->eax || ((e->ebx ^ best->ebx) >> 24) ||
+			    e->ecx ^ best->ecx || e->edx ^ best->edx)
+				return -EINVAL;
+			break;
+		case 0x3:
+			/* processor serial number */
+		case 0x4:
+			/* cache parameters */
+		case 0xb:
+		case 0x1f:
+			/* x2APIC id and CPU topology */
+		case 0x80000005:
+			/* AMD l1 cache information */
+		case 0x80000006:
+			/* l2 cache information */
+		case 0x8000001d:
+			/* AMD cache topology */
+		case 0x8000001e:
+			/* AMD processor topology */
+			break;
+		default:
+			if (e->eax ^ best->eax || e->ebx ^ best->ebx ||
+			    e->ecx ^ best->ecx || e->edx ^ best->edx)
+				return -EINVAL;
+			break;
+		}
+	}
+
 	return 0;
 }
 
@@ -291,10 +345,11 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
 	int r;
+	bool is_update = vcpu->arch.last_vmentry_cpu != -1;
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
 
-	r = kvm_check_cpuid(e2, nent);
+	r = kvm_check_cpuid(vcpu, e2, nent, is_update);
 	if (r)
 		return r;
 
@@ -303,7 +358,13 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	kvm_update_kvm_cpuid_base(vcpu);
-	kvm_vcpu_after_set_cpuid(vcpu);
+
+	/*
+	 * KVM_SET_CPUID{,2} after KVM_RUN is not allowed to change vCPU features, see
+	 * kvm_check_cpuid().
+	 */
+	if (!is_update)
+		kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e50e97ac4408..285d563af856 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5148,17 +5148,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid __user *cpuid_arg = argp;
 		struct kvm_cpuid cpuid;
 
-		/*
-		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
-		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
-		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
-		 * the core vCPU model on the fly, so fail.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
@@ -5169,14 +5158,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_cpuid2 __user *cpuid_arg = argp;
 		struct kvm_cpuid2 cpuid;
 
-		/*
-		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
-		 * KVM_SET_CPUID case above.
-		 */
-		r = -EINVAL;
-		if (vcpu->arch.last_vmentry_cpu != -1)
-			goto out;
-
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
 			goto out;
-- 
2.34.1


--=-=-=--

