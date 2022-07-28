Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1E58430D
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiG1P1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 11:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiG1P1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 11:27:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9247454CAE
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:27:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso5629212pjr.2
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 08:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=csSpCZse6HkYpD0alLhYtbnpKIryDbXXSRH4Zixe2I0=;
        b=DkCdzxLK5NMyhbrRcX2IZyC+qb3fASA7xm+FklYTyIR9i/BtuJCrGtnZ+AdUf0X0wm
         hGWnJ2oNm7620mgjU+M3EsIbnX9EOpgInxnyAH4HoQucT4UJh+HDjoWAUyeJ+WsbPayP
         jWsjtVh/hMHN7ORsq0XS+MXrT4EbO9ByEAyycoW2W6ogA76kfiecl+tobRog/ZwdtR2/
         ZUKCtjOm4My2QJZRlWG8SmorApa8fR3ZFp9TTfOaJgn7R78s1zs/vAHZzkhtK8vr7Q5g
         b15cKKmG3mRaTCY3npAWbsJ0rBfv8LLQAzK9L8QPC/UxuKQr6Xu/7Ssu/zmG2oXqHLEn
         WVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=csSpCZse6HkYpD0alLhYtbnpKIryDbXXSRH4Zixe2I0=;
        b=KJyxBLcbUHjLpMLUwKl6Dnyi+ObbetwjxsO4RopoTOqSCCqCIG/GpuZFUA/L8AJJBt
         M7tZyUzBqShM3ZBH7NWXfefzSrm6YW/cmRL70dsjtD6U+F1IH87asue2s1ULhGlGH2io
         VvQauLadu699AFCwlzqdz8akbCaHwE1riCtfulByPm98mwAd3UfpOfZbiZXAXlIH0CeA
         sSKO1BvhlbDi8ay++Dpvj63DnK26AfVTbBTGHYBbw2Hh+QA+m9EGnjTwzrk1gUHn5b03
         HpCW5N0xF3NvYia5K6e6OLAappP00mfI5tkyTsrL+5W29gGBLCaMsfIzNFHkF/qZ2PIK
         8Ntg==
X-Gm-Message-State: AJIora88iRbiOFd9NZVLx/vBwMbnfKgj072uVsOcZzZdLq+0h0iXeuXY
        XcWDIwOxjh6l3gxS8zSxwwamjw==
X-Google-Smtp-Source: AGRyM1sSrhEeTcGBug/hRwN/UzMJ5vxfJ6sRHheRoPfJs89jT56gNZ6MA6i+bGEizG7IcFl0eZ8aig==
X-Received: by 2002:a17:902:ea07:b0:16c:1efb:916e with SMTP id s7-20020a170902ea0700b0016c1efb916emr26478459plg.25.1659022029899;
        Thu, 28 Jul 2022 08:27:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h14-20020a056a00000e00b005255263a864sm881752pfk.169.2022.07.28.08.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 08:27:09 -0700 (PDT)
Date:   Thu, 28 Jul 2022 15:27:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Message-ID: <YuKqyTvbVx2UyP2w@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
 <271bddfa-9e48-d5f6-6147-af346d7946bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <271bddfa-9e48-d5f6-6147-af346d7946bf@gmail.com>
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

On Thu, Jul 28, 2022, Like Xu wrote:
> On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
> > consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
> > relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
> > thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.
> 
> Unwise userspace should reap its consequences if it does not break KVM or host.

I don't think this is a case of userspace being weird or unwise.  IMO, setting
CPUID before MSRs is perfectly logical and intuitive.

> When a guest feature can be defined/controlled by multiple KVM APIs entries,
> (such as SET_CPUID2, msr_feature, KVM_CAP, module_para), should KVM
> define the priority of these APIs (e.g. whether they can override each other) ?

KVM does have "rules" in the sense that it has an established ABI for things
like KVM_CAP and module params, though documentation may be lacking in some cases.
The CPUID and MSR ioctls don't have a prescribe ordering though.

> Removing this ambiguity ensures consistency in the architecture and behavior
> of all KVM features.

Agreed, but the CPUID and MSR ioctls (among many others) have existed for quite
some time.  KVM likely can't retroactively force a specific order without breaking
one userspace or another.

> Any further performance optimizations can be based on these finalized values
> as you do.
> 
> > 
> > Opportunistically fix a curly-brace indentation.
> > 
> > Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
> > Cc: Like Xu <like.xu.linux@gmail.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5366f884e9a7..362c538285db 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3543,9 +3543,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >   			return 1;
> >   		vcpu->arch.perf_capabilities = data;
> > -
> > +		kvm_pmu_refresh(vcpu);
> 
> I had proposed this diff but was met with silence.

My apologies, I either missed it or didn't connect the dots.
