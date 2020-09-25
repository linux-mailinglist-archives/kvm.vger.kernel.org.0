Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED62E2793DF
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgIYWBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 18:01:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgIYWBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 18:01:47 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601071305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2mtU+l23qdpdF/soGPUwQLNSza8gowsjn0XDmKpFbs=;
        b=MVVjN1H7WG3w9glt8UN1DRHoYdomrNtGFFlmps62s9Th5UkqYnYGSJfADBc9bATzssxhWp
        WLUFniVjsYcLtX01p2xTjw129asYA2LSX8euYHjd+iaBAyflJ9hWs4IFkypkvTuDIH4ml5
        dbj3HswBxj2aQLZNhuJpZeHHwCByKrY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-EX9EfhWRPKW1rXiw0Ix7og-1; Fri, 25 Sep 2020 18:01:42 -0400
X-MC-Unique: EX9EfhWRPKW1rXiw0Ix7og-1
Received: by mail-wr1-f71.google.com with SMTP id b7so1619222wrn.6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 15:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O2mtU+l23qdpdF/soGPUwQLNSza8gowsjn0XDmKpFbs=;
        b=pTDFrJUETWc0V2ZIGPe+vJIH2Jh8CnWa4gvnmBxfEcV+GCcBENj0qmwTTo6tNhalBX
         E9gcmyio2n/ipq3wU2eznBS8EZjV84Tpz++KdACUVUJtcCYFjtjVmchTRTd/qxU1DixQ
         KvaZZWj5bFpSe43/n/UYSarnuqtjUCLXLxA3BLsA7rhDqPE0qsoiOZavIYKB+7odg9L2
         r6z9zkLXIjSoSq7I9ToDpYebacHjXnmEzFDMjlGS3kX1euX3635eKMoFaxlFosa7jf0p
         Oc0UNonBOK/eH6qV5He9H11LB5fBWe7YapOXLaYajHYFu5l4HVRZt1BNEHHyU8ZKDuP8
         n+eg==
X-Gm-Message-State: AOAM532ASaOpUnvWvEZ7ej53NoMUSprdIZJCMDh7YTW8zBcItAQogAph
        Ec/bQVjSagQfQe2eEbaodbTFwTwBa4/wowxuwNu/fPeQlrpSWBqHWxxPSzvCJ9E5Yfk+VojA9zj
        sNOZnLKE2TO8q
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr571083wmi.135.1601071300939;
        Fri, 25 Sep 2020 15:01:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywlGkb1JCiU4aBTldw7f2kJM+w+qDbxO0od18FUu5Obh0pjN9QwAD3Hko+9BY7vXVuiAy63g==
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr571059wmi.135.1601071300630;
        Fri, 25 Sep 2020 15:01:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id z8sm4169592wrl.11.2020.09.25.15.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 15:01:40 -0700 (PDT)
Subject: Re: [PATCH v8 5/8] KVM: x86: SVM: Prevent MSR passthrough when MSR
 access is denied
To:     Alexander Graf <graf@amazon.com>, kvm list <kvm@vger.kernel.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200925143422.21718-1-graf@amazon.com>
 <20200925143422.21718-6-graf@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf5c6a97-6aed-ee23-56c8-14f6e0cce27b@redhat.com>
Date:   Sat, 26 Sep 2020 00:01:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925143422.21718-6-graf@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 16:34, Alexander Graf wrote:
> We will introduce the concept of MSRs that may not be handled in kernel
> space soon. Some MSRs are directly passed through to the guest, effectively
> making them handled by KVM from user space's point of view.
> 
> This patch introduces all logic required to ensure that MSRs that
> user space wants trapped are not marked as direct access for guests.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>

VMX and SVM agree about the awful naming of MSR functions...  There is
some confusion between msrs and indexes in msrpm_offsets.  I'll revisit
this after looking at Sean's pending series that cleans up VMX.

Paolo

> ---
> 
> v7 -> v8:
> 
>   - s/KVM_MSR_ALLOW/KVM_MSR_FILTER/g
> ---
>  arch/x86/kvm/svm/svm.c | 77 +++++++++++++++++++++++++++++++++++++-----
>  arch/x86/kvm/svm/svm.h |  7 ++++
>  2 files changed, 76 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 41aaee666751..45b0c180f42c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -91,7 +91,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  static const struct svm_direct_access_msrs {
>  	u32 index;   /* Index of the MSR */
>  	bool always; /* True if intercept is always on */
> -} direct_access_msrs[] = {
> +} direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
>  	{ .index = MSR_STAR,				.always = true  },
>  	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
>  #ifdef CONFIG_X86_64
> @@ -553,15 +553,41 @@ static int svm_cpu_init(int cpu)
>  
>  }
>  
> -static bool valid_msr_intercept(u32 index)
> +static int direct_access_msr_idx(u32 msr)
>  {
> -	int i;
> +	u32 i;
>  
>  	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
> -		if (direct_access_msrs[i].index == index)
> -			return true;
> +		if (direct_access_msrs[i].index == msr)
> +			return i;
>  
> -	return false;
> +	return -EINVAL;
> +}
> +
> +static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
> +				     int write)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	int idx = direct_access_msr_idx(msr);
> +
> +	if (idx == -EINVAL)
> +		return;
> +
> +	/* Set the shadow bitmaps to the desired intercept states */
> +	if (read)
> +		set_bit(idx, svm->shadow_msr_intercept.read);
> +	else
> +		clear_bit(idx, svm->shadow_msr_intercept.read);
> +
> +	if (write)
> +		set_bit(idx, svm->shadow_msr_intercept.write);
> +	else
> +		clear_bit(idx, svm->shadow_msr_intercept.write);
> +}
> +
> +static bool valid_msr_intercept(u32 index)
> +{
> +	return direct_access_msr_idx(index) != -EINVAL;
>  }
>  
>  static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> @@ -583,8 +609,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
>  	return !!test_bit(bit_write,  &tmp);
>  }
>  
> -static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
> -				 int read, int write)
> +static void set_msr_interception_nosync(struct kvm_vcpu *vcpu, u32 *msrpm,
> +					u32 msr, int read, int write)
>  {
>  	u8 bit_read, bit_write;
>  	unsigned long tmp;
> @@ -596,6 +622,13 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
>  	 */
>  	WARN_ON(!valid_msr_intercept(msr));
>  
> +	/* Enforce non allowed MSRs to trap */
> +	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> +		read = 0;
> +
> +	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
> +		write = 0;
> +
>  	offset    = svm_msrpm_offset(msr);
>  	bit_read  = 2 * (msr & 0x0f);
>  	bit_write = 2 * (msr & 0x0f) + 1;
> @@ -609,6 +642,13 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
>  	msrpm[offset] = tmp;
>  }
>  
> +static void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
> +				 int read, int write)
> +{
> +	set_shadow_msr_intercept(vcpu, msr, read, write);
> +	set_msr_interception_nosync(vcpu, msrpm, msr, read, write);
> +}
> +
>  static u32 *svm_vcpu_alloc_msrpm(void)
>  {
>  	struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> @@ -639,6 +679,25 @@ static void svm_vcpu_free_msrpm(u32 *msrpm)
>  	__free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
>  }
>  
> +static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 i;
> +
> +	/*
> +	 * Set intercept permissions for all direct access MSRs again. They
> +	 * will automatically get filtered through the MSR filter, so we are
> +	 * back in sync after this.
> +	 */
> +	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
> +		u32 msr = direct_access_msrs[i].index;
> +		u32 read = test_bit(i, svm->shadow_msr_intercept.read);
> +		u32 write = test_bit(i, svm->shadow_msr_intercept.write);
> +
> +		set_msr_interception_nosync(vcpu, svm->msrpm, msr, read, write);
> +	}
> +}
> +
>  static void add_msr_offset(u32 offset)
>  {
>  	int i;
> @@ -4212,6 +4271,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>  
>  	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
> +
> +	.msr_filter_changed = svm_msr_filter_changed,
>  };
>  
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 45496775f0db..07bec0d5aad4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -31,6 +31,7 @@ static const u32 host_save_user_msrs[] = {
>  
>  #define NR_HOST_SAVE_USER_MSRS ARRAY_SIZE(host_save_user_msrs)
>  
> +#define MAX_DIRECT_ACCESS_MSRS	15
>  #define MSRPM_OFFSETS	16
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> @@ -157,6 +158,12 @@ struct vcpu_svm {
>  	 */
>  	struct list_head ir_list;
>  	spinlock_t ir_list_lock;
> +
> +	/* Save desired MSR intercept (read: pass-through) state */
> +	struct {
> +		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
> +		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
> +	} shadow_msr_intercept;
>  };
>  
>  struct svm_cpu_data {
> 

