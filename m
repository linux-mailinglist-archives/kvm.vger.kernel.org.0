Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D732A57BFC1
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiGTVlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiGTVlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:41:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F79C3FA1D
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:41:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b10so7989923pjq.5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sNJo6iXQuvV8cglo7IL0/pP2Vv/TLnGTbGzY9DjcgW8=;
        b=LtV52w47Sj6ashVK3TG7rUxvgE0jXHmvOyYCMTzkvG4WFCyoABbaM+vArMrB5ccNeL
         Zfu7OG5b08KPiD5XHHe4BBkBk1ZM/CsUbvx0ozWJPcU8/kbhfdgmiBNuLTsa4bZF7beI
         +s9x6/EQ5shOxLWq1s4jfb0CvvmMeD+O2IVTBVAHTQS26pBs8c1okrodw40FGPf4i60Z
         G245DKapJ5zOQAadVaoUPiedhW/AA9+DPab1Orwksn+YAWMMlebcmLk8CReFG4f59gzO
         UvDNKF9ImNRom0wC+a3RatHMN+ZkOHKAcxBOHTT7Tti4RqWd8SDGYHUH8MDPJOTQ6164
         LKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sNJo6iXQuvV8cglo7IL0/pP2Vv/TLnGTbGzY9DjcgW8=;
        b=IvroazEZDiosQ9l83FnBybfAHsLDvwGQYD0TqgIlTsnp4LdavUKI8hqdsuFgXtT3k+
         AjyqHeB82H56Qw/BsBNntw4MALpiRrEKt6RK2TLS//QGJ9/y9c1VQnUyN5MHwQdOU/UE
         4RUceo+GR04xCbdazHq6hp3YfEWG5A9I0oGGw2f6g6gw7UQjMEHYVlz4n2Ygspz1lNBF
         ZV7QHFZcSMBxjPrnPZLrrgTRIxnUmo1RAPg/BTI4G4iQ0XeQYQjgTQ95I2OnFzR2gRaK
         xObPV18GhlZL6ogTYPwqPXNpBadNgbCAb0NSg6BNaT69SWeX0ABcwKfnGofXI5YzzN3N
         IDYA==
X-Gm-Message-State: AJIora8e42CPfNfWQnSVzjPHtt8T62sQU2cpyiF2haT17k/d1QljipSH
        kOtd9QLn20s/BTbLe5SRQoYYtHPCyZJpnQ==
X-Google-Smtp-Source: AGRyM1sdtU+WLCcFlFhUJcQlfCE3g8fyBgFIVy7DQUiNpRLNPmw05EZNEbmUk+FWd2bO7vV40Byfjw==
X-Received: by 2002:a17:902:aa98:b0:16c:d74d:fe6c with SMTP id d24-20020a170902aa9800b0016cd74dfe6cmr26831677plr.134.1658353278744;
        Wed, 20 Jul 2022 14:41:18 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k15-20020a170902d58f00b0016ce9b735dcsm48248plh.40.2022.07.20.14.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:41:18 -0700 (PDT)
Date:   Wed, 20 Jul 2022 21:41:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 5/7] KVM: SVM: Add VNMI support in inject_nmi
Message-ID: <Yth2eik6usFvC4vW@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-6-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709134230.2397-6-santosh.shukla@amd.com>
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

On Sat, Jul 09, 2022, Santosh Shukla wrote:
> Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
> will clear V_NMI to acknowledge processing has started and will keep the
> V_NMI_MASK set until the processor is done with processing the NMI event.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
> v2:
> - Added WARN_ON check for vnmi pending.
> - use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.
> 
>  arch/x86/kvm/svm/svm.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 44c1f2317b45..c73a1809a7c7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3375,12 +3375,20 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb *vmcb = NULL;
> +
> +	++vcpu->stat.nmi_injections;
> +	if (is_vnmi_enabled(svm)) {
> +		vmcb = get_vnmi_vmcb(svm);
> +		WARN_ON(vmcb->control.int_ctl & V_NMI_PENDING);

Haven't read the spec, but based on the changelog I assume the flag doesn't get
cleared until the NMI is fully delivered.  That means this WARN will fire if a
VM-Exit occurs during delivery as KVM will re-inject the event, e.g. if KVM is
using shadow paging and a #PF handle by KVM occurs during delivery.

> +		vmcb->control.int_ctl |= V_NMI_PENDING;
> +		return;
> +	}
>  
>  	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
>  	vcpu->arch.hflags |= HF_NMI_MASK;
>  	if (!sev_es_guest(vcpu->kvm))
>  		svm_set_intercept(svm, INTERCEPT_IRET);
> -	++vcpu->stat.nmi_injections;
>  }
>  
>  static void svm_inject_irq(struct kvm_vcpu *vcpu)
> -- 
> 2.25.1
> 
