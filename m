Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB973ABA7
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 23:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjFVVc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 17:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjFVVc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 17:32:56 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED6E1BFA
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:32:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-260cb94f585so749408a91.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 14:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687469574; x=1690061574;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=McrWPEMdcY8Ijo4mXTjWSWYCRblXWzlaJqW9ZS43WxU=;
        b=2qEuhBwk+Gyb8ChECzhA/azJHwfTPgAVY6tHxt5F1W+qkNOe/U/psq7KIDxNXJ41SD
         OS+AloMu2DO72wgYGScX4hPoptWUn8Pi8B7/dvhEMYhzfyJY53HRHCo6JNnXH8umfNIW
         2Er3vtqKWy/95Dy1tsG7z3pMeG278VNA4GcpT5roGprYLXeGpmtki9sJgWGj+wLlx7r5
         B/i+MohRq8+obwAfE7Ne0GQwVw9A92PJDNVI2XC+FTq3ATZ21wpO/iPYPpBNOB6p2Do6
         7wZA0R7lTp4R1S8csy5Hc9Wy7BInlOu+XUddBBX33x/+TJ2q2EZZO3p6l39FMy/aPN0Z
         kWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687469575; x=1690061575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McrWPEMdcY8Ijo4mXTjWSWYCRblXWzlaJqW9ZS43WxU=;
        b=HqLehU4pqSilafw8jlqd3GVMdR1r5YWxLVNI2eGj5dPFikHQYnw4HtVIwvOw1GpVhE
         LfRxEASVkdF4HwD6rtU7KNDKq6/d5m8dhS8Wtu2rVniiLlXkpLZ3VIDaGgwI2vX5B6Ej
         m+yqeXRc+5gp88b9KG63NYbodAn9IkKkQ7tEc4V1AQNBCGDKHwYFyk8zvH5bnRMYsLD6
         9yiDAPFydbawkshSiJvTm9rMM2Z/CNvE3cJ2NxdCOlDpIn3oKP2lUmVz2JDwWargeNB2
         EOchv9rT60s4bT7Ad1tcc3nom3tFoRp2CHRNDixfTI7NiPf66UvUmz5W5d6wGppVX3ml
         VbJA==
X-Gm-Message-State: AC+VfDxt/MVhRrt5PkYjCchb4UwnedUvix4XWZwHRhH9fhxNpV0W76MJ
        0Or/KAxPMstbV27cFHvMPQ0jvJ1xX1g=
X-Google-Smtp-Source: ACHHUZ6Wam0yuN4axfKLcIxsgHLl7cpPes08rLhF/Y32UXt5K7JEn6xRcyrUnXfHr+YEaf/SvnuGrio/h7w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ca8a:b0:25e:d506:593e with SMTP id
 y10-20020a17090aca8a00b0025ed506593emr2256361pjt.2.1687469574636; Thu, 22 Jun
 2023 14:32:54 -0700 (PDT)
Date:   Thu, 22 Jun 2023 14:32:53 -0700
In-Reply-To: <20230622081953.jc4tw6cwczl7bc6j@linux.intel.com>
Mime-Version: 1.0
References: <20230613203037.1968489-1-seanjc@google.com> <20230613203037.1968489-2-seanjc@google.com>
 <20230622081953.jc4tw6cwczl7bc6j@linux.intel.com>
Message-ID: <ZJS+BdDFg+qd1SyA@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Disallow KVM_SET_SREGS{2} if incoming CR0
 is invalid
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023, Yu Zhang wrote:
> On Tue, Jun 13, 2023 at 01:30:35PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 0ecf4be2c6af..355b0e8c9b00 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -3037,6 +3037,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> >  
> > +	/*
> > +	 * KVM should never use VM86 to virtualize Real Mode when L2 is active,
> > +	 * as using VM86 is unnecessary if unrestricted guest is enabled, and
> > +	 * if unrestricted guest is disabled, VM-Enter (from L1) with CR0.PG=0
> > +	 * should VM-Fail and KVM should reject userspace attempts to stuff
> 
> VM Enry shall fail(with CR0.PG=0), because SECONDARY_EXEC_UNRESTRICTED_GUEST
> will be cleared in L1's secondary_ctls_high MSR, and hence in its VMCS12?

Yep.

> 
> When will an unrestricted L1 run L2 as a restricted one? Shadow on EPT(L0
> uses EPT for L1 and L1 uses shadow for L2)?

Ya, the L1 VMM/hypervisor disabling EPT is the most likely scenario, i.e. the only
thing I would expect to encounter outside of testing.  Other than testing, e.g. to
ensure compatibility with Nehalem CPUs (the only Intel CPUs with EPT but not URG),
I don't know of any reason to disable URG but not EPT.
