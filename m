Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99220504F4F
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 13:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiDRLUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 07:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiDRLUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 07:20:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6815BE36
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650280642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=44kdO0O6qMKLwL+JUGZd9+81cd+e3YbuHIPiaqy8ItU=;
        b=F/kaZHbSHtrRZ1K9tJ8rEAhVDKMUG4JU+Jhb7JhvmeETAoonJ7O3kIZ1+tb8OHtQdgLGlH
        u8EcERCvqI1Z8uo3lEaZo00NSfqGrsmDbEDuwYcAbsmCHK8w+QvUf/XxYaq06pJFsLzrO8
        i/Ie/5ZZR4dhVhwCnSPKsLQY+v+VLu0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-KOd_YMOcPUio8lV30C32bw-1; Mon, 18 Apr 2022 07:17:19 -0400
X-MC-Unique: KOd_YMOcPUio8lV30C32bw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 178B0185A7A4;
        Mon, 18 Apr 2022 11:17:19 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1A2AC50975;
        Mon, 18 Apr 2022 11:17:16 +0000 (UTC)
Message-ID: <4ba971ad8df11732ab5da7a65166ac349427fbec.camel@redhat.com>
Subject: Re: [PATCH v2 07/12] KVM: SVM: Adding support for configuring
 x2APIC MSRs interception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 14:17:15 +0300
In-Reply-To: <20220412115822.14351-8-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-8-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> When enabling x2APIC virtualization (x2AVIC), the interception of
> x2APIC MSRs must be disabled to let the hardware virtualize guest
> MSR accesses.
> 
> Current implementation keeps track of list of MSR interception state
> in the svm_direct_access_msrs array. Therefore, extends the array to
> include x2APIC MSRs.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 29 ++++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.h |  5 +++--
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5ec770a1b4e8..c85663b62d4e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -76,7 +76,7 @@ static uint64_t osvw_len = 4, osvw_status;
>  
>  static DEFINE_PER_CPU(u64, current_tsc_ratio);
>  
> -static const struct svm_direct_access_msrs {
> +static struct svm_direct_access_msrs {
>  	u32 index;   /* Index of the MSR */
>  	bool always; /* True if intercept is initially cleared */
>  } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> @@ -774,6 +774,32 @@ static void add_msr_offset(u32 offset)
>  	BUG();
>  }
>  
> +static void init_direct_access_msrs(void)
> +{
> +	int i, j;
> +
> +	/* Find first MSR_INVALID */
> +	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
> +		if (direct_access_msrs[i].index == MSR_INVALID)
> +			break;
> +	}
> +	BUG_ON(i >= MAX_DIRECT_ACCESS_MSRS);
> +
> +	/*
> +	 * Initialize direct_access_msrs entries to intercept X2APIC MSRs
> +	 * (range 0x800 to 0x8ff)
> +	 */
> +	for (j = 0; j < 0x100; j++) {
> +		direct_access_msrs[i + j].index = APIC_BASE_MSR + j;
> +		direct_access_msrs[i + j].always = false;
> +	}

That looks *much cleaner* code wise even though it is slower 
because now we have 256 more msrs in this list.

So the best of the two worlds I think would be to add only APIC msrs that AVIC
actually handles to the list.

SDM has a table of these registers in 

"15.29.3.1 Virtual APIC Register Accesses"

I would add the registers that are either read/write allowed 
or at least cause traps.

Besides this, the patch looks fine.

Best regards,
	Maxim Levitsky


> +	BUG_ON(i + j >= MAX_DIRECT_ACCESS_MSRS);
> +
> +	/* Initialize last entry */
> +	direct_access_msrs[i + j].index = MSR_INVALID;
> +	direct_access_msrs[i + j].always = true;
> +}
> +
>  static void init_msrpm_offsets(void)
>  {
>  	int i;
> @@ -4739,6 +4765,7 @@ static __init int svm_hardware_setup(void)
>  	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
>  	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
>  
> +	init_direct_access_msrs();
>  	init_msrpm_offsets();
>  
>  	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index c44326eeb3f2..e340c86941be 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -29,8 +29,9 @@
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	20
> -#define MSRPM_OFFSETS	16
> +#define MAX_DIRECT_ACCESS_MSRS	(20 + 0x100)
> +#define MSRPM_OFFSETS	30
> +
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern bool intercept_smi;


