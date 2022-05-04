Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD3519F12
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349368AbiEDMSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbiEDMSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:18:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCCF22317D
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651666506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBRyJXLztH87HDqVQ7jOiNiao+kchEB62aGeLVwy9Q4=;
        b=KcOjNmYpGT2MVQrpU9Uv4fSNQKHavZaw74fgVcI/A0K5W9z13vnnFyQWO3jhfggT8AhMsk
        tFXfYKGN399R2AwDqfGGz2rPDjth1qJ4ZvWBBsWjVQbj4IPd9A4SIz/9pWlP658rX8VpuO
        J5o0gVD7y/VINnvtye9xHXmaRnxyQqM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-t65CNjJgNHyo1FKz6cqmIw-1; Wed, 04 May 2022 08:15:00 -0400
X-MC-Unique: t65CNjJgNHyo1FKz6cqmIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B9BB3C021A3;
        Wed,  4 May 2022 12:15:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 270F5400F75F;
        Wed,  4 May 2022 12:14:57 +0000 (UTC)
Message-ID: <0f17a0151f575434cf26579de05f102d51b41605.camel@redhat.com>
Subject: Re: [PATCH v3 07/14] KVM: SVM: Adding support for configuring
 x2APIC MSRs interception
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 04 May 2022 15:14:57 +0300
In-Reply-To: <20220504073128.12031-8-suravee.suthikulpanit@amd.com>
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
         <20220504073128.12031-8-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
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
>  arch/x86/kvm/svm/svm.c | 25 +++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h |  4 ++--
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74e6f86f5dc3..314628b6bff4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -100,6 +100,31 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_IA32_CR_PAT,			.always = false },
>  	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
>  	{ .index = MSR_TSC_AUX,				.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ID),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_TASKPRI),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ARBPRI),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_PROCPRI),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_EOI),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_RRR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LDR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_DFR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_SPIV),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ISR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_TMR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_IRR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ESR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ICR),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_ICR2),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVTT),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVTTHMR),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVTPC),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVT0),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVT1),		.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_LVTERR),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_TMICT),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_TMCCT),	.always = false },
> +	{ .index = (APIC_BASE_MSR + APIC_TDCR),		.always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 678fc7757fe4..5ed958863b81 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -29,8 +29,8 @@
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	21
> -#define MSRPM_OFFSETS	16
> +#define MAX_DIRECT_ACCESS_MSRS	46
> +#define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
>  extern int vgif;


Looks good.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

