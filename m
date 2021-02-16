Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B794C31D300
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 00:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhBPXVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 18:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhBPXVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 18:21:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507E7C061756
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 15:20:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id t2so342770pjq.2
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 15:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYd6nr0oGbgIL8iQOd6SiixzxgNKcGzXb50I/fmD3eU=;
        b=RvcQn0UaCGpSOi5+yzxNur/u9DlQYOzZ+HkU2lu/kIIiDAv+SgnkWjtfKmywpqUmMX
         kaHU31hoqSpJnQfRVSmyeSJ5p0mFr9cYsP1T39R9lpH8ARz21vxFGyWIkE9h4wGpSC5I
         ehyzgkvDRzUvfhktDiPiISzsMeCYOilyzQIYAE+3h0+uOTK9uXVZXSzN4YyAy9bFJSgW
         hs1iBwn051J/a2bilJw3I+cffdasOMJeBFqMrmYGXD1UwOjYns3R8piSDvjTmOj19ClK
         BIPii6FueRopEm2P/znTNvd7DuW0xqhPkVjCiCjDSBIS69RnA1wBLb9EZWXLhg8oi4b2
         g1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eYd6nr0oGbgIL8iQOd6SiixzxgNKcGzXb50I/fmD3eU=;
        b=jpcIqyfqZMXoFlB5unKLNL3XxtKCBXJ5zF5qnMj4H/nSDNxrK8XPgqC6FdnAgOdji+
         VKxGNUFzQm69Ya5oEnty7AjRfaRHoxTbezViBBPXTAbgYBWuM1imKb2meLnz2fw+V/j7
         UHIqvMbYGVat31hqd9DER4qmvPYfjt+YtpELxxuuL8x7h7DaqCeTN4pYujws3qdPJLW4
         6zS/RdHUjAAA5/fD66aGYelGPHX8Zj58JuvLJPA4tIrk0qOHe/QF1oDFJVNlf0E5AwZw
         WXDmUwKLXCQigCF+wRJd1fdOpX2kxGTLxEVbKvxzxbPYePYCmVLkqxavb0MrC+wrlN7q
         vLog==
X-Gm-Message-State: AOAM531+JG3Vtb9L6rWlaZ+ns3artnFifgkT44+a1XiHpVEN48FCA+pB
        2BGKOkxkG8vufBT4s116bFc6xw==
X-Google-Smtp-Source: ABdhPJzNPACEnkId77zBhKhZ9j/Q8qwkJ+LN882PrYB1hh/e/AgoYRFviVwzhnKTSZrdyJHTtfdjfA==
X-Received: by 2002:a17:902:bb90:b029:df:bdbb:be99 with SMTP id m16-20020a170902bb90b02900dfbdbbbe99mr21643804pls.52.1613517622171;
        Tue, 16 Feb 2021 15:20:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id e185sm40770pfe.117.2021.02.16.15.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 15:20:21 -0800 (PST)
Date:   Tue, 16 Feb 2021 15:20:15 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v10 12/16] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <YCxTL+FYLbM0qk88@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb86eda2963d7bef0c469c1ef8d7b32222e3a145.1612398155.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Ashish Kalra wrote:
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..f6bfa138874f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
>  #define KVM_FEATURE_ASYNC_PF_INT	14
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -54,6 +55,7 @@
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>  
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> +
>  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b0d324aed515..93f42b3d3e33 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1627,6 +1627,16 @@ int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
>  	return ret;
>  }
>  
> +void sev_update_migration_flags(struct kvm *kvm, u64 data)
> +{

I don't see the point for a helper.  It's actually going to make the code
less readable once proper error handling is added.  Given that it's not static
and exposed via svm.h, without an external user, I assume this got left behind
when the implicit enabling was removed.

> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	if (!sev_guest(kvm))

I 100% agree with Steve, this needs to check guest_cpuid_has() in addition to
sev_guest().  And it should return '1', i.e. signal #GP to the guest, not
silently eat the bad WRMSR.

> +		return;
> +
> +	sev->live_migration_enabled = !!(data & KVM_SEV_LIVE_MIGRATION_ENABLED);

The value needs to be checked as well, i.e. all bits except LIVE_MIGRATION...
should to be reserved to zero.

> +}
> +
>  int svm_get_shared_pages_list(struct kvm *kvm,
>  			      struct kvm_shared_pages_list *list)
>  {
> @@ -1639,6 +1649,9 @@ int svm_get_shared_pages_list(struct kvm *kvm,
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> +	if (!sev->live_migration_enabled)
> +		return -EINVAL;

EINVAL is a weird return value for something that is controlled by the guest,
especially since it's possible for the guest to support migration, just not
yet.  EBUSY maybe?  EOPNOTSUPP?

> +
>  	if (!list->size)
>  		return -EINVAL;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58f89f83caab..43ea5061926f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2903,6 +2903,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->msr_decfg = data;
>  		break;
>  	}
> +	case MSR_KVM_SEV_LIVE_MIGRATION:
> +		sev_update_migration_flags(vcpu->kvm, data);
> +		break;

There shuld be a svm_get_msr() entry as well, I don't see any reason to prevent
the guest from reading the MSR.

>  	case MSR_IA32_APICBASE:
>  		if (kvm_vcpu_apicv_active(vcpu))
>  			avic_update_vapic_bar(to_svm(vcpu), data);
> @@ -3976,6 +3979,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
>  	}
>  
> +	/*
> +	 * If SEV guest then enable the Live migration feature.
> +	 */
> +	if (sev_guest(vcpu->kvm)) {
> +		struct kvm_cpuid_entry2 *best;
> +
> +		best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> +		if (!best)
> +			return;
> +
> +		best->eax |= (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);

Again echoing Steve's concern, userspace is the ultimate authority on what
features are exposed to the VM.  I don't see any motivation for forcing live
migration to be enabled.

And as I believe was pointed out elsewhere, this bit needs to be advertised to
userspace via kvm_cpu_caps.

> +	}
> +
>  	if (!kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 066ca2a9f1e6..e1bffc11e425 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -79,6 +79,7 @@ struct kvm_sev_info {
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +	bool live_migration_enabled;
>  	/* List and count of shared pages */
>  	int shared_pages_list_count;
>  	struct list_head shared_pages_list;
> @@ -592,6 +593,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
>  void pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_teardown(void);
> +void sev_update_migration_flags(struct kvm *kvm, u64 data);
>  void sev_free_vcpu(struct kvm_vcpu *vcpu);
>  int sev_handle_vmgexit(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
> -- 
> 2.17.1
> 
