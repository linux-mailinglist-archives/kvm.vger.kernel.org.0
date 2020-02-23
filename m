Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42EB1696FB
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2020 10:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBWJKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 04:10:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727133AbgBWJKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 04:10:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582449001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5u9lZhYXCor5qc5s/5dsnw8k8VPf7dy2XjENhSGZ88=;
        b=aGRkL9mOIqq/m4tFzPPumxDSAQyv139QAHL/BCb79nv2j3JQ2UaSNZTBHgQ5c0kNMysHhY
        Eo58RtcH2s8sRjK95XOmHpRrsW0h4wXqHrHshWFO0OhqqR7Ohom2UpJUWmFlEMrHRWwb8b
        jOi11355PlZ7P/pbhfhL29HAgLhHR2I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-cEKQLvA3PniDp2sm-XZyvg-1; Sun, 23 Feb 2020 04:10:00 -0500
X-MC-Unique: cEKQLvA3PniDp2sm-XZyvg-1
Received: by mail-wm1-f71.google.com with SMTP id g138so1789615wmg.8
        for <kvm@vger.kernel.org>; Sun, 23 Feb 2020 01:09:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5u9lZhYXCor5qc5s/5dsnw8k8VPf7dy2XjENhSGZ88=;
        b=c+Jzr8TT24UnsajjIhmvCxI1+cIe8nYJPghmRMdQXrdgHE4wt+tDtnKXQx+G6Yq1Qv
         c3ZGDy4d/3lw71UqnAlPw7aUryif+pCFLEoHW7wZNHAFVMZ5E0HS0BZ24hoyq2av32cO
         h1E/iRjk98QoLZOsHSvr/r6sId+YIXoSazGlP32d9bZO1iCEqJyGHHxcs88xbv7StvHC
         rleWSXTOwU6GrCpefqQo8RcWUwMRvO2jaiaSVo0hFNRnTHB0vK6w5eXssnbzAVrCMkcd
         uJz5+dEjtdIq/QPZnRSbJImpgnvNKdHETMfkcire+rKMKMpewavPFdtvy8IjeL06Ykj4
         JMZw==
X-Gm-Message-State: APjAAAVQ6On6uYB17vCdrT0mAvpE6qem66qsVgMd6PBxAyCAItrC0wM2
        zh2WbXBmE4Cfz+tYMnw4g/T521leHz5jnyNXTlG4sbJyOcSvGqqhoaxByvl13ZR/HZAVnzkApjS
        DAm3m7rO5R6hG
X-Received: by 2002:adf:8b59:: with SMTP id v25mr62051329wra.419.1582448998512;
        Sun, 23 Feb 2020 01:09:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNds4DcHlwFGH8Lw7xXBjoHii4BBdCqzSBTbqdxD6ttgusuomPkCfdZozm9MlyBa9FnM3YRg==
X-Received: by 2002:adf:8b59:: with SMTP id v25mr62051295wra.419.1582448998235;
        Sun, 23 Feb 2020 01:09:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ec41:5e57:ff4d:8e51? ([2001:b07:6468:f312:ec41:5e57:ff4d:8e51])
        by smtp.gmail.com with ESMTPSA id i16sm12298469wrr.71.2020.02.23.01.09.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 01:09:57 -0800 (PST)
Subject: Re: [PATCH 3/3] KVM: x86: Consolidate VM allocation and free for VMX
 and SVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200127004113.25615-1-sean.j.christopherson@intel.com>
 <20200127004113.25615-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4b2ff641-ae4c-be5b-f598-5a0fc2052235@redhat.com>
Date:   Sun, 23 Feb 2020 10:09:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200127004113.25615-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/20 01:41, Sean Christopherson wrote:
> Move the VM allocation and free code to common x86 as the logic is
> more or less identical across SVM and VMX.
> 
> Note, although hyperv.hv_pa_pg is part of the common kvm->arch, it's
> (currently) only allocated by VMX VMs.  But, since kfree() plays nice
> when passed a NULL pointer, the superfluous call for SVM is harmless
> and avoids future churn if SVM gains support for HyperV's direct TLB
> flush.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Queued, thanks.  Might as well make vm_size a field instead of a pointer 
to function, sacrificing the BUILD_BUG_ONs:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24b87e2691c5..f8b45cc0bf49 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1059,7 +1059,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
-	unsigned int (*vm_size)(void);
+	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
 
@@ -1276,7 +1276,7 @@ struct kvm_arch_async_pf {
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops->vm_size(),
+	return __vmalloc(kvm_x86_ops->vm_size,
 			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
 }
 void kvm_arch_free_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a5a136e986e9..660387d6caf0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1955,13 +1955,6 @@ static void __unregister_enc_region_locked(struct kvm *kvm,
 	kfree(region);
 }
 
-static unsigned int svm_vm_size(void)
-{
-	BUILD_BUG_ON(offsetof(struct kvm_svm, kvm) != 0);
-
-	return sizeof(struct kvm_svm);
-}
-
 static void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -7399,7 +7392,7 @@ static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
 	.vcpu_free = svm_free_vcpu,
 	.vcpu_reset = svm_vcpu_reset,
 
-	.vm_size = svm_vm_size,
+	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 39a4fea03df5..57ac585394b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6645,13 +6645,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_complete_interrupts(vmx);
 }
 
-static unsigned int vmx_vm_size(void)
-{
-	BUILD_BUG_ON(offsetof(struct kvm_vmx, kvm) != 0);
-
-	return sizeof(struct kvm_vmx);
-}
-
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7749,7 +7742,7 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.vm_size = vmx_vm_size,
+	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
 	.vcpu_create = vmx_create_vcpu,

