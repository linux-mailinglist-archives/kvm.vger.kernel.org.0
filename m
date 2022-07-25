Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C69B5803E4
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 20:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiGYSSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 14:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiGYSSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 14:18:50 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9671EEF2
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 11:18:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id p8so11124876plq.13
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 11:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e+T1nQOK8xq7qgx+g5Uf2BJLYM3ox7zT+AoQWOo8zKM=;
        b=roorjMRJcc5+f3RG1zAdpZktDXEFjruRroEJC7Bti/beYh8gUR9IgK5Z+QkSoxJLWy
         GiNKkpLdsBrnbOJC31l2b0NhDGagcqlbVfedN+odp4+q589Q8ZLQDYZ59uGR+n0qux0G
         OcKGINwRLYy6d1q2+fwH7DT/+vAcujv2PL6Iq5mpTBFTTBvcazKFR45OXkJzuBDZVK8R
         JKjcRb6tWiYvi++YbMSVsygdSK9ZH/aZ0ZEPaZYAU9q40VZ/64Jj5fX+GV5EbDVn+wnn
         Ysa41VaiVRW0w7S93MU7LE0azM+moMrY9TAibuSROq8IUiztksRM/sBspoVCWKm9t43n
         q3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e+T1nQOK8xq7qgx+g5Uf2BJLYM3ox7zT+AoQWOo8zKM=;
        b=y73Ofcp6GXsLDruOZolXqh2HLw0vD++6Tds0QHiNnWaULcv3OSJZoSv2qan1Y3Nl24
         0AOO1iz8kQi6upfQf7+VfPGLxi8iWH6VrcFPRP8F/MKOiKCBy1hgRVf8Y9pA8zUIH3h8
         KbWJuEIUMJ8UM95cr/LXCKjqmJns+WliXo7tkmSb6ceH56Dd8BlAQTomNh3cWuxE10oR
         G3kM/9F9AcwXkLmkQeZWjQMiXCCqjTVnjfWECFhsKmxPDChO+VnJ5OPtD8qnTm1/AK3S
         +Q4Qn+hcSU4yW4lwdCg+KojUv0uwZwq5FnPa0h6cC20yEQ7Hhn+EvEJg/q3cztGV3eqo
         r6PQ==
X-Gm-Message-State: AJIora98oVxPWDypo3N1SL2niqPwfEJOPPVAyYex+YGhhoGlfsB/7drB
        seYygpBiAUEBxntgcJGmLRUztONBMqPQnA==
X-Google-Smtp-Source: AGRyM1vwKOJmrBpdWNxBVJU/qSP2DuiVWi8Ii8m8oRkZzGVQVi9SCMhxcykFwcuuP+1BLUpYNNB8xg==
X-Received: by 2002:a17:90b:1e4f:b0:1f2:b482:bab9 with SMTP id pi15-20020a17090b1e4f00b001f2b482bab9mr7068771pjb.9.1658773128732;
        Mon, 25 Jul 2022 11:18:48 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902684e00b0016ce31d1d97sm9527604pln.114.2022.07.25.11.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 11:18:48 -0700 (PDT)
Date:   Mon, 25 Jul 2022 18:18:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 09/25] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <Yt7ehL0HfR3b97FQ@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-10-vkuznets@redhat.com>
 <YtnMIkFI469Ub9vB@google.com>
 <48de7ea7-fc1a-6a83-3d6f-e04d26ea2f05@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48de7ea7-fc1a-6a83-3d6f-e04d26ea2f05@redhat.com>
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

On Mon, Jul 25, 2022, Paolo Bonzini wrote:
> On 7/21/22 23:58, Sean Christopherson wrote:
> > 
> > diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> > index b5cfbf7d487b..7b348a03e096 100644
> > --- a/arch/x86/kvm/vmx/evmcs.c
> > +++ b/arch/x86/kvm/vmx/evmcs.c
> > @@ -355,11 +355,6 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
> >          return 0;
> >   }
> > 
> > -enum evmcs_v1_revision {
> > -       EVMCSv1_2016,
> > -       EVMCSv1_2022,
> > -};
> > -
> >   enum evmcs_unsupported_ctrl_type {
> >          EVMCS_EXIT_CTLS,
> >          EVMCS_ENTRY_CTLS,
> > @@ -372,29 +367,29 @@ static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
> >                                        enum evmcs_unsupported_ctrl_type ctrl_type)
> >   {
> >          struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> > -       enum evmcs_v1_revision evmcs_rev = EVMCSv1_2016;
> > +       bool has_evmcs_2022_features;
> > 
> >          if (!hv_vcpu)
> >                  return 0;
> > 
> > -       if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
> > -               evmcs_rev = EVMCSv1_2022;
> > +       has_evmcs_2022_features = hv_vcpu->cpuid_cache.nested_ebx &
> > +                                 HV_X64_NESTED_EVMCS1_2022_UPDATE;
> > 
> >          switch (ctrl_type) {
> >          case EVMCS_EXIT_CTLS:
> > -               if (evmcs_rev == EVMCSv1_2016)
> > +               if (!has_evmcs_2022_features)
> >                          return EVMCS1_UNSUPPORTED_VMEXIT_CTRL |
> >                                  VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> >                  else
> >                          return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> >          case EVMCS_ENTRY_CTLS:
> > -               if (evmcs_rev == EVMCSv1_2016)
> > +               if (!has_evmcs_2022_features)
> >                          return EVMCS1_UNSUPPORTED_VMENTRY_CTRL |
> >                                  VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> >                  else
> >                          return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> >          case EVMCS_2NDEXEC:
> > -               if (evmcs_rev == EVMCSv1_2016)
> > +               if (!has_evmcs_2022_features)
> >                          return EVMCS1_UNSUPPORTED_2NDEXEC |
> >                                  SECONDARY_EXEC_TSC_SCALING;
> >                  else
> > 
> 
> I kind of like the idea of having a two-dimensional array based on the enums
> instead of switch statements, so for now I'll keep Vitaly's enums.

I don't have a strong opinion on using a 2d array, but unless I'm missing something,
that's nowhere to be found in this patch.  IMO, having the enums without them
providing any unique value is silly and obfuscates the code.
