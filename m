Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BB64C3631
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiBXTwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiBXTwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:52:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB8DE1B71A3
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645732322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q2zY9nW3JSGkVakGPdaOHjkL7gRWAKVqi4jlLr2HJiI=;
        b=QOoq4jIVkAR3FIZciVhzhtahE8Jyr4dbmJ/185iyX+0ZvqOFqMl754yx+4NjcKDioT6aNS
        3S9YxMEKwkDO+zTJUxn7Ady1kqDiYBzaGW1sCdGtJF/sQb2kZ0YCNU3nRWyiLmISu5CKjc
        ohSTQTXvxmyvPZzhOiiJjUSZ5GD2AFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-iw_z2fXGOiefATfcu2U8zw-1; Thu, 24 Feb 2022 14:51:56 -0500
X-MC-Unique: iw_z2fXGOiefATfcu2U8zw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B60D1091DA0;
        Thu, 24 Feb 2022 19:51:55 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD5E01971F;
        Thu, 24 Feb 2022 19:51:52 +0000 (UTC)
Message-ID: <70922149247cfe2bfd59d27d45bbf5d0966c2dcd.camel@redhat.com>
Subject: Re: [RFC PATCH 10/13] KVM: SVM: Adding support for configuring
 x2APIC MSRs interception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Feb 2022 21:51:51 +0200
In-Reply-To: <20220221021922.733373-11-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
         <20220221021922.733373-11-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
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
> index 4e6dc1feeac7..afca26aa1f40 100644
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
> -	int slot = direct_access_msr_slot(msr);
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
> @@ -4752,6 +4784,7 @@ static __init int svm_hardware_setup(void)
>  	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
>  	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
>  
> +	init_direct_access_x2apic_msrs();
>  	init_msrpm_offsets();
>  
>  	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index bfbebb933da2..41514df5107e 100644
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
> @@ -242,6 +244,11 @@ struct vcpu_svm {
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

I only gave this a cursory look, the whole thing is a bit ugly (not your fault),
I feel like it should be refactored a bit.


Best regards,
	Maxim Levitsky

