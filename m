Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F97158EE99
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 16:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiHJOlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 10:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiHJOku (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 10:40:50 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA30F45F54
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:40:48 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z187so13861669pfb.12
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=SgzYODjrDYCskLdG6hpmiZvMCNisxWBgbV3pqTl+Q3I=;
        b=tR4LTLDaKnYu7vXgPCt1xTcNJVSrSkp+qCds6DvARInYrePEvwlVzeSABqKkuX/0qn
         RKJ9ldM8CaVPNT8otnyjeDFsvEZA3+u4QnnFe4yL4dUxLFY+BQpaO1KTCMengJksk9sF
         XZ4pz/SaPlfUCD3zXaa1t8DiDEeJmF9ccwUiqlKGeliZy4JMdLOlvcYGWOIy9c08YRPf
         9T43ZAXRH+wUSJ3npEUoQpPl8dOv971Bj5nOFFFHi3n5QavN1GWnH4FfTrY+PUUVovxD
         fG72zR0J7SxVFZSlnDMkAJyDcARsfKdMF7QwMFJkLkB4WA1ks9worvXdm/fgHiJ1CCRW
         JcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=SgzYODjrDYCskLdG6hpmiZvMCNisxWBgbV3pqTl+Q3I=;
        b=anICte6deTvRA+lIjgiah3iT3XWeLr8/tFPUHvEC8PxHN60M/4lafhuHJmLBdUMHfE
         tltYfUtb2vjpcRXjIErc1ymyPrNhQi6szPKnB2JVrpFX5EPGGNUxsCmcJ0k9mC6fhXLf
         FDqPQruZfwPQh4dXKnn6ERPZg9xtMZ7SSdzmFQbU5UGM80FaFSx0f/+mA+HYvAoE8jqj
         CFu9Ic4tbAC+893UYQOxcduhHET1JlybFe2zgq+p+vjBr0v9RFR/TAwZIOkGngF41tgX
         O+YBVgtOondYBKBvyKRUn07tOHPmBO5ywVzjDJAg5Ceq5u7DMGnJOk0FhNQQqIEUCCl0
         OqvA==
X-Gm-Message-State: ACgBeo3lJ1Tc8dBpR8DTZngiIPVMU0lEyyGyF3cBn4cgkaMfSG2iHk5h
        1fsjTvTDXEXO61RSyk/PCBM1VJQ1UdRqXg==
X-Google-Smtp-Source: AA6agR6jOWMcobS3Xodlp42vExYLB2zU9HfOs/YPcr6IQfkaN7pUZsgmrFpITTy9xrKtOtal35Ipqw==
X-Received: by 2002:a65:49c8:0:b0:41a:eb36:d1a7 with SMTP id t8-20020a6549c8000000b0041aeb36d1a7mr23394997pgs.66.1660142437995;
        Wed, 10 Aug 2022 07:40:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j12-20020a170903024c00b0016ee26224a4sm13033266plh.305.2022.08.10.07.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:40:37 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:40:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 2/3] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
Message-ID: <YvPDYVPgrLCRlYuH@google.com>
References: <20220805172945.35412-1-seanjc@google.com>
 <20220805172945.35412-3-seanjc@google.com>
 <29150d3f-36fb-516d-55d0-a9aebe23cdcf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29150d3f-36fb-516d-55d0-a9aebe23cdcf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 10, 2022, Paolo Bonzini wrote:
> On 8/5/22 19:29, Sean Christopherson wrote:
> > +static void kvm_proble_feature_msr(u32 msr_index)
> > +{
> > +	struct kvm_msr_entry msr = {
> > +		.index = msr_index,
> > +	};
> > +
> > +	if (kvm_get_msr_feature(&msr))
> > +		return;
> > +
> > +	msr_based_features[num_msr_based_features++] = msr_index;
> > +}
> > +
> >   static void kvm_init_msr_list(void)
> >   {
> >   	u32 dummy[2];
> > @@ -6954,15 +6949,11 @@ static void kvm_init_msr_list(void)
> >   		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
> >   	}
> > -	for (i = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
> > -		struct kvm_msr_entry msr;
> > +	for (i = KVM_FIRST_EMULATED_VMX_MSR; i <= KVM_LAST_EMULATED_VMX_MSR; i++)
> > +		kvm_proble_feature_msr(i);
> > -		msr.index = msr_based_features_all[i];
> > -		if (kvm_get_msr_feature(&msr))
> > -			continue;
> > -
> > -		msr_based_features[num_msr_based_features++] = msr_based_features_all[i];
> > -	}
> > +	for (i = 0; i < ARRAY_SIZE(msr_based_features_all_except_vmx); i++)
> > +		kvm_proble_feature_msr(msr_based_features_all_except_vmx[i]);
> 
> I'd rather move all the code to a new function kvm_init_feature_msr_list()
> instead, and call it from kvm_arch_hardware_setup().

Would it make sense to also split out kvm_init_emulated_msr_list()?  Hmm, and
rename this to kvm_init_virtualized_msr_list()?  I can't tell if that would be
helpful or confusing.
