Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4904F6F34
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 02:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiDGAa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 20:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiDGAaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 20:30:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A66D95F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 17:28:55 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w7so3972951pfu.11
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 17:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vqS1m/IH9ttZDToEhWuRy6HzBTkV/dxcTphdjhUeXNs=;
        b=bEx0Ea+QqiL/+iw8tktWp8aLIB++31btJoMFw8KBXszdh85N/EeM0BTlb5RZ9L2j7O
         I97jAvfh2gtEDnRP17Nh2w3Ol1+AuV0wv2J9ccQEH+DdaKPtYDsqEyy6/ioOkqBfBDeO
         LErRhqzE85mLpBsQPkXBdZrXi1XUcrMh2gKlGZqmoTHbPOduPIfcuLblopmH7zlXBsWj
         gIM2kKXcF5z+VBaLWiHRbSpzKGhjwQ3KnZCxEYvH1Ibrf4HrRUDc91fAEykcJsfzmWYw
         z1FE2JK2luooNK4FPi9ZhJkxMkLqbJN4Fdh+0RBuxIE6hPvPvv3wP7eAEIcpv600D9xn
         Wejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vqS1m/IH9ttZDToEhWuRy6HzBTkV/dxcTphdjhUeXNs=;
        b=j2dhWQPACs4cqtIEnRsGgglNvvrtPGXkhxXeeqwnuTjLFDPAPoFBZ1raeh5PddRR94
         pRssbrPiDIr28WsKq6efxihTIJdnWIssk36N7QewDsIB4GiNFz1tyoeaR3llfpLAe3E6
         jbGFg/VCZP/8hZk8eEsb/e77Fwxfxq/2Ov9K+HIErRCm66xVOV/kBD5PBC7m3UcPXaxP
         F3nR0uBqO2rFIK6FSR1Ik4cDCIWenwKmtY2o68YR7y6bSsEBToyo0e9LO7w7h+rJ3i8b
         6qXm69jRA+p5iJXqindhxHya1EsM9mXhUQML/UcX0MeH1TwpsH0aQX8RE8Vl9TEeB88N
         iKSg==
X-Gm-Message-State: AOAM530F0VDls6CKYKiA6vBCMw6fqzr5hCXpXKRL/5+sbDTTvLv/OA9t
        flXFUiIHiuVH5APLpWhOqAkzsQ==
X-Google-Smtp-Source: ABdhPJx0IkyEOOc6Ubdav5XeHiivjOusSXBlgIM5WYUqCbe7zysv0jtVWVz7t6l8zhWAgq5kJEAl4g==
X-Received: by 2002:a05:6a00:182a:b0:4fd:dee2:6371 with SMTP id y42-20020a056a00182a00b004fddee26371mr11646718pfa.8.1649291334331;
        Wed, 06 Apr 2022 17:28:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b7-20020a056a00114700b004f7be3231d6sm20172609pfm.7.2022.04.06.17.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:28:53 -0700 (PDT)
Date:   Thu, 7 Apr 2022 00:28:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 5/8] KVM: nVMX: Add a quirk for KVM tweaks to VMX
 control MSRs
Message-ID: <Yk4wQtThcQl8toyC@google.com>
References: <20220301060351.442881-1-oupton@google.com>
 <20220301060351.442881-6-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301060351.442881-6-oupton@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Oliver Upton wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 224ef4c19a5d..21b98bad1319 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7250,6 +7250,9 @@ void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS))
> +		return;
> +
>  	if (kvm_mpx_supported()) {
>  		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);

Assuming the proposed L2 CR4 checking changes don't throw a wrench in things, I'd
I'd prefer we include the CR4 fixed1 massaging in the quirk:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce0000202c5e..17b19946d6cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7367,7 +7367,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
                        ~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
                          FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);

-       if (nested_vmx_allowed(vcpu)) {
+       if (nested_vmx_allowed(vcpu) &&
+           !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS)) {
                nested_vmx_cr_fixed1_bits_update(vcpu);
                nested_vmx_entry_exit_ctls_update(vcpu);
        }
