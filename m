Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2AF5301D5
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiEVIZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241381AbiEVIZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 04:25:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 326AE2FFEA
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 01:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653207911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=szAUKKH9xMkRATj2GZMW6t9r5YJHNSX8m10DwWFv7CI=;
        b=b/LCChNforRxvrr5QhHBy+wLPTHmTYlv3fV4yv8Ci6PyCdv6w0xia0x7amYybvFIhk6+B/
        SuwoMprD9sV4hYHVC4rsQpC9XdqnLWC0Jl2iGiOUxE/PYrM8hDHrT8hWyurv6HGeoD/o5l
        p+UoK3kPq4zUif5h2TuuBzajsoQ1R6o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-nWP7kcY9OJ6VrqtqxhOy6g-1; Sun, 22 May 2022 04:25:05 -0400
X-MC-Unique: nWP7kcY9OJ6VrqtqxhOy6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 118AC802A5B;
        Sun, 22 May 2022 08:25:05 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DB2540CFD00;
        Sun, 22 May 2022 08:25:00 +0000 (UTC)
Message-ID: <67ff4a7b7f5c920c370efc11e7190a61a075ec1b.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: SVM: fix nested PAUSE filtering
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date:   Sun, 22 May 2022 11:24:59 +0300
In-Reply-To: <fb4a9151-e56c-d16c-f09c-ac098e41a791@redhat.com>
References: <20220518072709.730031-1-mlevitsk@redhat.com>
         <fb4a9151-e56c-d16c-f09c-ac098e41a791@redhat.com>
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

On Fri, 2022-05-20 at 16:05 +0200, Paolo Bonzini wrote:
> On 5/18/22 09:27, Maxim Levitsky wrote:
> > To fix this, change the fallback strategy - ignore the guest threshold
> > values, but use/update the host threshold values, instead of using zeros.
> 
> Hmm, now I remember why it was using the guest values.  It's because, if
> the L1 hypervisor specifies COUNT=0 or does not have filtering enabled,
> we need to obey and inject a vmexit on every PAUSE.  So something like this:
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f209c1ca540c..e6153fd3ae47 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -616,6 +616,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
>   	struct vmcb *vmcb01 = svm->vmcb01.ptr;
>   	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> +	u32 pause_count12;
> +	u32 pause_thresh12;
>   
>   	/*
>   	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
> @@ -671,20 +673,25 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>   	if (!nested_vmcb_needs_vls_intercept(svm))
>   		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>   
> +	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
> +	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
>   	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
> -		/* use guest values since host doesn't use them */
> -		vmcb02->control.pause_filter_count =
> -				svm->pause_filter_enabled ?
> -				svm->nested.ctl.pause_filter_count : 0;
> -
> -		vmcb02->control.pause_filter_thresh =
> -				svm->pause_threshold_enabled ?
> -				svm->nested.ctl.pause_filter_thresh : 0;
> +		/* use guest values since host doesn't intercept PAUSE */
> +		vmcb02->control.pause_filter_count = pause_count12;
> +		vmcb02->control.pause_filter_thresh = pause_thresh12;
>   
>   	} else {
> -		/* use host values otherwise */
> +		/* start from host values otherwise */
>   		vmcb02->control.pause_filter_count = vmcb01->control.pause_filter_count;
>   		vmcb02->control.pause_filter_thresh = vmcb01->control.pause_filter_thresh;
> +
> +		/* ... but ensure filtering is disabled if so requested.  */
> +		if (vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_PAUSE)) {
> +			if (!pause_count12)
> +				vmcb02->control.pause_filter_count = 0;
> +			if (!pause_thresh12)
> +				vmcb02->control.pause_filter_thresh = 0;
> +		}

Makes sense!

I also need to remember to return the '!old' check to the shrink_ple_window,
otherwise it will once again convert 0 to the minimum value.

I'll send a patch soon with this.

Thanks!

>   	}
>   
>   	nested_svm_transition_tlb_flush(vcpu);
> 
> 
> What do you think?
> 


Best regards,
	Maxim Levitsky

