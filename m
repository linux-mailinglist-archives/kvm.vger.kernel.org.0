Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5C130E880
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhBDA3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbhBDA3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:29:35 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A964FC0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:28:54 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id c132so928582pga.3
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BvFluTlIkULOLaKl7jy+jl1lM3clNsaQR0cSWQQ2zJ4=;
        b=JZ7DGnacARYdo++T6lycBEhG1C7K/fY71j15lWIzXbSHTx5zr+RbWnmrDmkpQCqQwE
         gBgVrMqbJ6GXzlGaRD+8TFA5z3NL68+s3zGPEwGimPV9j3sm4yQfl3mWH7uy4Y9kw9zD
         01XKdiEDeDxYUlIfAkrRgELoQxj6xjrzy7UrHpsIvQSEEHr4NWeWiGoKxQJGdKCKa/hq
         XHgSesWx93nQ9BSclRQF31HaL/dfxO1bWl9oP/BVxtwbCMVAT+xQ7tpKldQvrcN+9Xy2
         BSboMti41CQpFr9m1SRJewqmzb7jW/PrEPuP4+qz3/LNwflYtDDrASNf2kU4Kof7feC9
         n+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BvFluTlIkULOLaKl7jy+jl1lM3clNsaQR0cSWQQ2zJ4=;
        b=i0FYphX66Q6yDbD7+Llrf0p+6MOKllDebBtWxJhQg09z/avsm7GTiELrSsjIuGcl2y
         u9ucoQJLlQu04AkQ40NI5DCJuJEScWeLdC+m2azY39Tmfo8o+eg4L06sjFYDw1EaQqpS
         4VKPdMYQj4fzyqt20yUMAP64UpOLGo2TfsmvQXrKf3C1a5/vwwn4EREc9BvWdCFAIap0
         b2ISdaYDmjF6G68OshpGY/YShlhgmD5xNzMenUregHgmX3DSdzpDF/g3bk9Itbu7EIjG
         n5Nvyr57zTMxShYLgsehw+rS0896nQyW8g8n91QmTruVJZ6LEp8xFgKpVYRXEpbooVlI
         KFxA==
X-Gm-Message-State: AOAM531Q0x7c8NNdLnnLJqbZrb1eV97gJWVSuFQTM48TkM5nRqNPH6yS
        Ik5lBBJ1wU8vjzAr+R7m2blcag==
X-Google-Smtp-Source: ABdhPJyha8BVOyP6qluWrIDyhCiYq3xjf+nd6smVEzEQqGIyxChsmUs5hPa7Pi9rlm8VECQnbARC3Q==
X-Received: by 2002:a05:6a00:1702:b029:1b5:1121:729a with SMTP id h2-20020a056a001702b02901b51121729amr5320745pfc.57.1612398533920;
        Wed, 03 Feb 2021 16:28:53 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id n73sm3410970pfd.109.2021.02.03.16.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 16:28:53 -0800 (PST)
Date:   Wed, 3 Feb 2021 16:28:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBs/vveIBg00Im0U@google.com>
References: <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
 <YBnmow4e8WUkRl2H@google.com>
 <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
 <YBrfF0XQvzQf9PhR@google.com>
 <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
 <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
 <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
 <YBsyqLHPtYOpqeW4@google.com>
 <b6e0a32f-0070-f97e-5d94-d12f7972d474@intel.com>
 <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44b5a747aaf1d42fb8ef388bd28f49614d42cd50.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 15:37 -0800, Dave Hansen wrote:
> > On 2/3/21 3:32 PM, Sean Christopherson wrote:
> > > > > > Yeah, special casing KVM is almost always the wrong thing to do.
> > > > > > Anything that KVM can do, other subsystems will do as well.
> > > > > Agreed.  Thwarting ioremap itself seems like the right way to go.
> > > > This sounds irrelevant to KVM SGX, thus I won't include it to KVM SGX series.
> > > I would say it's relevant, but a pre-existing bug.  Same net effect on what's
> > > needed for this series..
> > > 
> > > I say it's a pre-existing bug, because I'm pretty sure KVM can be coerced into
> > > accessing the EPC by handing KVM a memslot that's backed by an enclave that was
> > > created by host userspace (via /dev/sgx_enclave).
> > 
> > Dang, you beat me to it.  I was composing another email that said the
> > exact same thing.
> > 
> > I guess we need to take a closer look at the KVM fallout from this.
> > It's a few spots where it KVM knew it might be consuming garbage.  It
> > just get extra weird stinky garbage now.
> 
> I don't quite understand how KVM will need to access EPC memslot. It is *guest*, but
> not KVM, who can read EPC from non-enclave. And if I understand correctly, there will
> be no place for KVM to use kernel address of EPC to access it. To KVM, there's no
> difference, whether EPC backend is from /dev/sgx_enclave, or /dev/sgx_vepc. And we
> really cannot prevent guest from doing anything.
> 
> So how memremap() of EPC section is related to KVM SGX? For instance, the
> implementation of this series needs to be modified due to this?

See kvm_vcpu_map() -> __kvm_map_gfn(), which blindly uses memremap() when the
resulting pfn isn't a "valid" pfn.  KVM doesn't need access to an EPC memslot,
we're talking the case where a malicious userspace/guest hands KVM a GPA that
resolves to the EPC.  E.g. nested VM-Enter with the L1->L2 MSR bitmap pointing
at EPC.  L0 KVM will intercept VM-Enter and then read L1's bitmap to merge it's
desires with L0 KVM's requirements.  That read will hit the EPC, and thankfully
for KVM, return garbage.
