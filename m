Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30A530F7D1
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhBDQ1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:27:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35860 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236785AbhBDPCi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 10:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612450871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9gK1Pdb/0h2vLmTqYpq1sQpYPCSiH92GZ3Ke1/3BGcA=;
        b=eKxXGQWoXkjy9yoPLv9kzTNJ1h4rJzJ4bZkEa5IrSkSOe8xKAC/1jaE0UI/Xf3l07AwffK
        XnCf/CmmY8ctBHf6kq94/XcTv1dTr/j6jiaJRidkXt5YCKw0MiKwm1ytGAvxhK4WLXdvY/
        FApGFj3vjpO997b58QZWtjn5pjt2zaQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-YzOvgIb0NHW1fiyb6-9yEw-1; Thu, 04 Feb 2021 10:01:09 -0500
X-MC-Unique: YzOvgIb0NHW1fiyb6-9yEw-1
Received: by mail-ed1-f71.google.com with SMTP id p18so2992327edr.20
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 07:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9gK1Pdb/0h2vLmTqYpq1sQpYPCSiH92GZ3Ke1/3BGcA=;
        b=e+w/rWcOUvKzAwvlkcWwDxabi7OT7mKnQA5/D7xlEW3orXAPf3//HqPu+Xs7dqD4RY
         tZwsnSWvUgJ0OdgCNdJw20Ct8ktwdsqaQkZUv/dj2xYM+q7bvq4OnpEOwikNKvGgNTRV
         sx52nt8NBVFOY7UcpPwIDsieIPKLTEAgZgDj8xXkp5PnZOwQAsvu6/CZ8OrYtFm/g/p0
         pkAuPJUidQaNMzYkgJceq+iGVSbRG/mKoJAGHJBqdeAQgC4wIWbOJb9oiJf31xzyu8cx
         YjOryPUOfrt0bdSsgBA8A4uJMU82prS5gmlkFmlr1A8dfC5GZjWyz73VcnRNcdKFHiDn
         Xq3g==
X-Gm-Message-State: AOAM531AG8MAESt+HzVzSyA/mWqxc3MhL4GDNywUR2Jm2ynzjTjYo5Q9
        fAi9BVVZCpx29bc8USf6URXBNjY8SkziuWaO5+zcCAcDIK5zy1zDArWxUikBHe7Lvp4vrgzvxku
        MVqGr7EsRpyLh
X-Received: by 2002:a17:906:7ca:: with SMTP id m10mr8071785ejc.257.1612450868234;
        Thu, 04 Feb 2021 07:01:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEaWT0o1hWB4+1nac6Aa6iiKGmPOzlTvUao/Bz9pCPOi6qDVeB86bEACXQYUe+NzdZuPDqOg==
X-Received: by 2002:a17:906:7ca:: with SMTP id m10mr8071723ejc.257.1612450867653;
        Thu, 04 Feb 2021 07:01:07 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bm2sm2566518ejb.87.2021.02.04.07.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 07:01:06 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Kechen Lu <kechenl@nvidia.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
In-Reply-To: <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
 <878s85pl4o.fsf@vitty.brq.redhat.com>
 <DM6PR12MB35006123BF3E9D8B67042CC9CAB39@DM6PR12MB3500.namprd12.prod.outlook.com>
 <87zh0knhqb.fsf@vitty.brq.redhat.com>
 <721b7075-6931-80f1-7b28-fc723ad14c13@redhat.com>
Date:   Thu, 04 Feb 2021 16:01:06 +0100
Message-ID: <87wnvnop1p.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 04/02/21 13:24, Vitaly Kuznetsov wrote:
>> I checked Linux VMs on genuine Hyper-V and surprisingly
>> 'HV_DEPRECATING_AEOI_RECOMMENDED' is not exposed.
>
> Did the host have APICv/AVIC (and can Hyper-V use AVIC)?  AutoEOI is 
> still a useful optimization on hosts that don't have 
> hardware-accelerated EOI or interrupt injection.

I was under the impression that for Intel I need IvyBridge, I was
testing with Xeon E5-2420 v2. I don't have an AMD host with Hyper-V
handy so I spun a VM on Azure which has modern enough AMD EPYC 7452,
still no luck.

Surprisingly, Linux on KVM has code to handle AutoEOI recommendation
since 2017 (6c248aad81c89) so I assume it's possible to meet this bit in
the wild.

Anyway, I've smoke tested the attached patch (poorly tested and
hackish!) on Intel/AMD and WS2016 and nothing blew up
immediately. Kechen Lu, could you give it a spin in your 
environment? No userspace changes needed (will change if we decide to go
ahead with it).

-- 
Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-KVM-x86-Deactivate-APICv-only-when-auto_eoi-feature-.patch

From cb129501199f1f3ab6f0ade81b11eb76d08b6b5b Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 4 Feb 2021 13:31:41 +0100
Subject: [PATCH] KVM: x86: Deactivate APICv only when auto_eoi feature is in
 use

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/cpuid.c            |  5 +++++
 arch/x86/kvm/hyperv.c           | 26 ++++++++++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d6616f6f6ef..539fbb505d77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -877,6 +877,9 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
+	/* How many SynICs use 'auto_eoi' feature */
+	atomic_t synic_auto_eoi_used;
+
 	struct hv_partition_assist_pg *hv_pa_pg;
 	struct kvm_hv_syndbg hv_syndbg;
 };
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 13036cf0b912..8df2dff37a5c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -138,6 +138,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
+	/* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
+	best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
+	if (best)
+		best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
+
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
 		if (best)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 922c69dcca4d..7c9bc060889a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -83,6 +83,11 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
 static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 				int vector)
 {
+	struct kvm_vcpu *vcpu = synic_to_vcpu(synic);
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+	int auto_eoi_old, auto_eoi_new;
+
 	if (vector < HV_SYNIC_FIRST_VALID_VECTOR)
 		return;
 
@@ -91,10 +96,25 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	else
 		__clear_bit(vector, synic->vec_bitmap);
 
+	auto_eoi_old = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
 	if (synic_has_vector_auto_eoi(synic, vector))
 		__set_bit(vector, synic->auto_eoi_bitmap);
 	else
 		__clear_bit(vector, synic->auto_eoi_bitmap);
+
+	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
+
+	/* Hyper-V SynIC auto EOI SINT's are not compatible with APICV */
+	if (!auto_eoi_old && auto_eoi_new) {
+		if (atomic_inc_return(&hv->synic_auto_eoi_used) == 1)
+			kvm_request_apicv_update(vcpu->kvm, false,
+						 APICV_INHIBIT_REASON_HYPERV);
+	} else if (!auto_eoi_old && auto_eoi_new) {
+		if (atomic_dec_return(&hv->synic_auto_eoi_used) == 0)
+			kvm_request_apicv_update(vcpu->kvm, true,
+						 APICV_INHIBIT_REASON_HYPERV);
+	}
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
@@ -903,12 +923,6 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 {
 	struct kvm_vcpu_hv_synic *synic = vcpu_to_synic(vcpu);
 
-	/*
-	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so request
-	 * to deactivate APICV permanently.
-	 */
-	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	synic->control = HV_SYNIC_CONTROL_ENABLE;
-- 
2.29.2


--=-=-=--

