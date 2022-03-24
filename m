Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1273B4E65EC
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351267AbiCXPVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350724AbiCXPVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 11:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45AF2716FA
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648135209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2o3gAHoYUZWdzPuaqszpGnV2w4I+J5CWL2jDynP5vs=;
        b=G5kmXPhNGYjTa58eQBlfQwt9kqhIjp8M3nZXWQGpyVrv5AIEFkB+23J1UBq57MbHi72Ggc
        +MFKO1wCc7IW/TF7WIqRAt0PJWxUQhZ/1NvZY2KUGNx8aXhcDluvYG0XIp9WWLZwRhlZg+
        FqkY+8/XN7CPSJfEJkGbOMpxRQimNR0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-MrmLxTShM8a7PapBdMNDPg-1; Thu, 24 Mar 2022 11:20:05 -0400
X-MC-Unique: MrmLxTShM8a7PapBdMNDPg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72108AE9AB;
        Thu, 24 Mar 2022 15:19:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C40FD417E36;
        Thu, 24 Mar 2022 15:19:33 +0000 (UTC)
Message-ID: <426b70a407b774627187e64b011a64bfb7214b36.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 08/12] KVM: SVM: Adding support for configuring
 x2APIC MSRs interception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 17:19:32 +0200
In-Reply-To: <20220308163926.563994-9-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-9-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> When enabling x2APIC virtualization (x2AVIC), the interception of
> x2APIC MSRs must be disabled to let the hardware virtualize guest
> MSR accesses.
> 
> Current implementation keeps track of MSR interception state
> for generic MSRs in the svm_direct_access_msrs array.
> For x2APIC MSRs, introduce direct_access_x2apic_msrs array.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 67 +++++++++++++++++++++++++++++++-----------
>  arch/x86/kvm/svm/svm.h |  7 +++++
>  2 files changed, 57 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3048f4b758d6..ce3c68a785cf 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -89,7 +89,7 @@ static uint64_t osvw_len = 4, osvw_status;
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  #define TSC_RATIO_DEFAULT	0x0100000000ULL
>  
> -static const struct svm_direct_access_msrs {
> +static struct svm_direct_access_msrs {
>  	u32 index;   /* Index of the MSR */
>  	bool always; /* True if intercept is initially cleared */
>  } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> @@ -117,6 +117,9 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> +static struct svm_direct_access_msrs
> +direct_access_x2apic_msrs[NUM_DIRECT_ACCESS_X2APIC_MSRS + 1];
> +
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * pause_filter_count: On processors that support Pause filtering(indicated
> @@ -609,41 +612,42 @@ static int svm_cpu_init(int cpu)
>  
>  }
>  
> -static int direct_access_msr_slot(u32 msr)
> +static int direct_access_msr_slot(u32 msr, struct svm_direct_access_msrs *msrs)
>  {
>  	u32 i;
>  
> -	for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++)
> -		if (direct_access_msrs[i].index == msr)
> +	for (i = 0; msrs[i].index != MSR_INVALID; i++)
> +		if (msrs[i].index == msr)
>  			return i;
>  
>  	return -ENOENT;
>  }
>  
> -static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
> -				     int write)
> +static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu,
> +				     struct svm_direct_access_msrs *msrs, u32 msr,
> +				     int read, void *read_bits,
> +				     int write, void *write_bits)
>  {
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -	int slot = direct_access_msr_slot(msr);direct_access_msrs
> +	int slot = direct_access_msr_slot(msr, msrs);
>  
>  	if (slot == -ENOENT)
>  		return;
>  
>  	/* Set the shadow bitmaps to the desired intercept states */
>  	if (read)
> -		set_bit(slot, svm->shadow_msr_intercept.read);
> +		set_bit(slot, read_bits);
>  	else
> -		clear_bit(slot, svm->shadow_msr_intercept.read);
> +		clear_bit(slot, read_bits);
>  
>  	if (write)
> -		set_bit(slot, svm->shadow_msr_intercept.write);
> +		set_bit(slot, write_bits);
>  	else
> -		clear_bit(slot, svm->shadow_msr_intercept.write);
> +		clear_bit(slot, write_bits);
>  }
>  
> -static bool valid_msr_intercept(u32 index)
> +static bool valid_msr_intercept(u32 index, struct svm_direct_access_msrs *msrs)
>  {
> -	return direct_access_msr_slot(index) != -ENOENT;
> +	return direct_access_msr_slot(index, msrs) != -ENOENT;
>  }
>  
>  static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> @@ -674,9 +678,12 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
>  
>  	/*
>  	 * If this warning triggers extend the direct_access_msrs list at the
> -	 * beginning of the file
> +	 * beginning of the file. The direct_access_x2apic_msrs is only for
> +	 * x2apic MSRs.
>  	 */
> -	WARN_ON(!valid_msr_intercept(msr));
> +	WARN_ON(!valid_msr_intercept(msr, direct_access_msrs) &&
> +		(boot_cpu_has(X86_FEATURE_X2AVIC) &&
> +		 !valid_msr_intercept(msr, direct_access_x2apic_msrs)));
>  
>  	/* Enforce non allowed MSRs to trap */
>  	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
> @@ -704,7 +711,16 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
>  void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
>  			  int read, int write)
>  {
> -	set_shadow_msr_intercept(vcpu, msr, read, write);
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (msr < 0x800 || msr > 0x8ff)
> +		set_shadow_msr_intercept(vcpu, direct_access_msrs, msr,
> +					 read, svm->shadow_msr_intercept.read,
> +					 write, svm->shadow_msr_intercept.write);
> +	else
> +		set_shadow_msr_intercept(vcpu, direct_access_x2apic_msrs, msr,
> +					 read, svm->shadow_x2apic_msr_intercept.read,
> +					 write, svm->shadow_x2apic_msr_intercept.write);
>  	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
>  }
>  
> @@ -786,6 +802,22 @@ static void add_msr_offset(u32 offset)
>  	BUG();
>  }
>  
> +static void init_direct_access_x2apic_msrs(void)
> +{
> +	int i;
> +
> +	/* Initialize x2APIC direct_access_x2apic_msrs entries */
> +	for (i = 0; i < NUM_DIRECT_ACCESS_X2APIC_MSRS; i++) {
> +		direct_access_x2apic_msrs[i].index = boot_cpu_has(X86_FEATURE_X2AVIC) ?
> +						  (0x800 + i) : MSR_INVALID;
> +		direct_access_x2apic_msrs[i].always = false;
> +	}
> +
> +	/* Initialize last entry */
> +	direct_access_x2apic_msrs[i].index = MSR_INVALID;
> +	direct_access_x2apic_msrs[i].always = false;
> +}
> +
>  static void init_msrpm_offsets(void)
>  {
>  	int i;
> @@ -4750,6 +4782,7 @@ static __init int svm_hardware_setup(void)
>  	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
>  	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
>  
> +	init_direct_access_x2apic_msrs();
>  	init_msrpm_offsets();
>  
>  	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b53c83a44ec2..19ad40b8383b 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -29,6 +29,8 @@
>  
>  #define MAX_DIRECT_ACCESS_MSRS	20
>  #define MSRPM_OFFSETS	16
> +#define NUM_DIRECT_ACCESS_X2APIC_MSRS	0x100
> +
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern bool intercept_smi;
> @@ -241,6 +243,11 @@ struct vcpu_svm {
>  		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
>  	} shadow_msr_intercept;
>  
> +	struct {
> +		DECLARE_BITMAP(read, NUM_DIRECT_ACCESS_X2APIC_MSRS);
> +		DECLARE_BITMAP(write, NUM_DIRECT_ACCESS_X2APIC_MSRS);
> +	} shadow_x2apic_msr_intercept;
> +
>  	struct vcpu_sev_es_state sev_es;
>  
>  	bool guest_state_loaded;


I did some homework on this, and it looks mostly correct.

However I do wonder if we need that separation of svm_direct_access_msrs and 
direct_access_x2apic_msrs. I understand the peformance wise, the  
direct_access_msrs will get longer otherwise (but we don't have to allow
all x2apic msr range, but only known x2apic registers which aren't that many).

One of the things that I see that *is* broken (at least in theory) is nesting.

init_msrpm_offsets goes over direct_access_msrs and puts the offsets of corresponding
bits in the hardware msr bitmap into the 'msrpm_offsets'

Then on nested VM entry the nested_svm_vmrun_msrpm uses this list to merge the nested
and host MSR bitmaps.
Without x2apic msrs, this means that if L1 chooses to allow L2 to access its x2apic msrs
it won't work. It is not something that L1 would do often but still allowed to overall.

Honestly we need to write track the nested MSR bitmap to avoid updating it on each VM entry,
then with this hot path eliminated, I don't think there are other places which update
the msr interception often, and thus we could just put the x2apic msrs into the 
direct_access_msrs.

Best regards,
	Maxim Levitsky



