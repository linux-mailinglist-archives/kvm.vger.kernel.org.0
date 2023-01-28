Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A0367F384
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 02:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjA1BKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 20:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjA1BKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 20:10:10 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E41790AB
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 17:09:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso6281203pjb.4
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 17:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BvDAtcWxpw0OO9CIbwxN2UD8Ft4Fj6lH34EVPxrgfKI=;
        b=s2HEceqQte7E79aunBrwqCeshew83p+7aDGZJpBTU9d3SEvowWG1QvkqukX5MGJc0N
         7GxvnRV2Lx8I0XEcnLSHabBKqJrOsrU7l5sjossB4RhNHui1n79vUqHdeUSkP+6VJXaV
         XFLzeQVK6CFCTI4FAN2N0ZkhXHY+JinRNQg+VxEgvBvmu7pjU2Jxb8f4vob6ywSY9Se9
         wbWwa1IFuRJqKt5V84quH+FScywvcrWi0iED+OWBsWwAv8Mt+ZMXMMCNNXTba2fq8Hv/
         1FrJmPyhTi3tuAF5K+lshEUsArssDdeWLN6Y3P2hjCAex0ZcHxEs9pCLKwcsQuzg24mW
         yKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvDAtcWxpw0OO9CIbwxN2UD8Ft4Fj6lH34EVPxrgfKI=;
        b=IiOFsDmU8b7V6hu9KGc1zqkALJy1+KDgNtSWm9R93/04WkS0wr1F9ahdQhcQ/a3Ums
         zpnxaAerwgEUWlTlfpKtydYi+kqQgR3/l8d/BcnybOAf6GdaHEnlXReshrv8CohU27SC
         bdfGvbUO4MY+56wPh4E4drL8t6ovtpzsPZeQFgFCj5J34BkRVUz17Uw7zPvTpyBHUOSz
         PvgGc0MWMI1Sx0Z+qvbvRT4q4Fho7N6HtayTJT7GxHwi1iX03Cw0A32bdZ4OGD2XNya9
         dV4qPWnjfaybHQQ6QiP7M7goW/EIkj3ow5gI9r5AEom4fiUGNrsDo6mdXEwH0q0yOFcg
         wdiA==
X-Gm-Message-State: AO0yUKUY8QX+50CGVLQQKVpYuOLyx1UIBMwjtwbjJKC3pKg37t3pbQwp
        0sa0d8FFLYaZ5RdeWpxpB8+KSw==
X-Google-Smtp-Source: AK7set9V1nbyj5JVvia8fyiXGTwoku2mOKuKfBs6aPc6BS5JnYNaBgvYF5vFd/2yoJGtQtix32pXIg==
X-Received: by 2002:a17:902:d70a:b0:193:256d:8afe with SMTP id w10-20020a170902d70a00b00193256d8afemr208955ply.2.1674868167288;
        Fri, 27 Jan 2023 17:09:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e5c800b00194bf875ed8sm3453070plf.139.2023.01.27.17.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 17:09:26 -0800 (PST)
Date:   Sat, 28 Jan 2023 01:09:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: add a delayed hardware NMI injection
 interface
Message-ID: <Y9R1w8kfQjCNnEfl@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-8-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-8-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> This patch adds two new vendor callbacks:

No "this patch" please, just say what it does.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 684a5519812fb2..46993ce61c92db 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -871,8 +871,13 @@ struct kvm_vcpu_arch {
>  	u64 tsc_scaling_ratio; /* current scaling ratio */
>  
>  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
> -	unsigned nmi_pending; /* NMI queued after currently running handler */
> +
> +	unsigned int nmi_pending; /*
> +				   * NMI queued after currently running handler
> +				   * (not including a hardware pending NMI (e.g vNMI))
> +				   */

Put the block comment above.  I'd say collapse all of the comments about NMIs into
a single big block comment.

>  	bool nmi_injected;    /* Trying to inject an NMI this entry */
> +
>  	bool smi_pending;    /* SMI queued after currently running handler */
>  	u8 handling_intr_from_guest;
>  
> @@ -10015,13 +10022,34 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>  	 */
>  	if (static_call(kvm_x86_get_nmi_mask)(vcpu) || vcpu->arch.nmi_injected)
> -		limit = 1;
> +		limit--;
> +
> +	/* Also if there is already a NMI hardware queued to be injected,
> +	 * decrease the limit again
> +	 */

	/*
	 * Block comment ...
	 */

> +	if (static_call(kvm_x86_get_hw_nmi_pending)(vcpu))

I'd prefer "is_hw_nmi_pending()" over "get", even if it means not pairing with
"set".  Though I think that's a good thing since they aren't perfect pairs.

> +		limit--;
>  
> -	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
> +	if (limit <= 0)
> +		return;
> +
> +	/* Attempt to use hardware NMI queueing */
> +	if (static_call(kvm_x86_set_hw_nmi_pending)(vcpu)) {
> +		limit--;
> +		nmi_to_queue--;
> +	}
> +
> +	vcpu->arch.nmi_pending += nmi_to_queue;
>  	vcpu->arch.nmi_pending = min(vcpu->arch.nmi_pending, limit);
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
>  
> +/* Return total number of NMIs pending injection to the VM */
> +int kvm_get_total_nmi_pending(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.nmi_pending + static_call(kvm_x86_get_hw_nmi_pending)(vcpu);

Nothing cares about the total count, this can just be;


	bool kvm_is_nmi_pending(struct kvm_vcpu *vcpu)
	{
		return vcpu->arch.nmi_pending ||
		       static_call(kvm_x86_is_hw_nmi_pending)(vcpu);
	}


> +}
> +
>  void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>  				       unsigned long *vcpu_bitmap)
>  {
> -- 
> 2.26.3
> 
