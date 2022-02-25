Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8024C4B0B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbiBYQl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 11:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbiBYQlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 11:41:25 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B1C218CE0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:40:53 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y5so5151314pfe.4
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 08:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LOzx1/1N7j/VHBirbjJ/dukmD8Mv3Gu9xYCoow9KxH0=;
        b=sP6/wWn5Rt+NzeQShD4TUqG0VMxxRrtUpSglEEhW3zYXUGZgBE6gT8tHBL5pWZwyUJ
         CLznrRYdUNQILkg1MCJaayNAW3w/OD30r5frhrGrfpyFL+65kNtUwRdnFtYaRjRkDA36
         aZtASawYrpXcEzcCm6pl3Elcfh9xp5RK+e7LkB1OWSFb2B7O65OnWvr3gHZlp6MD8OkR
         llt4uxaQ+EsjeE8SZ9yfDsofx+WPgh8saaQkRAlz7gK0i2YeQ7FwMIU3rg5uf7klvgIj
         rOmVc09LquQLQhyeYOYbYtqEX/PeOcXqCQLmAmc+WyDq+9XLXh83xL1srhXY1NeH5uvP
         LcvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LOzx1/1N7j/VHBirbjJ/dukmD8Mv3Gu9xYCoow9KxH0=;
        b=X+LTLJK21PGNBn9reqEld5ULLnqVTeVcfZMO2aj4stl6uxuVab6PDDLTK8F6qsC7kG
         py76JMMD+lIkmiEN83nD1Yf6/is/8FKMgH0WjlBVFTYfpCpAVK/nB0A0OxHiREH1ErI6
         hIoWthqlTnexUJQMjl2XP1efrL+Bo9R+krD/Q6u8Buq8tRhvfFNW1PpqjPu+qtlFCYU2
         82a6S4NVCDvS0Oreg9xgos5eqB+3FR9NLqIMLEK3DsDaQByroU8ZSjlFeYJEKGZNFmCN
         i1vf3vnq7YN8ni6+JTtJ/Om91cziF/En2soiJPLTAgBC+1Dz2BzwsxiJ/Q1Gc9ORzLK2
         Gh4Q==
X-Gm-Message-State: AOAM531VIp5SZY3k+xrl80nlMN6qvSMoDyWP1nZQFTTUkGnJW+xyBpZG
        moB/gCleJyDIR2x3cLcov7le4g==
X-Google-Smtp-Source: ABdhPJwIBGXNdggpuheOxLyfH7NwjiL6DzLmuNUj1w/+Y5ijV18kW3kXAA9KfhXeWTceTocEUSXaLg==
X-Received: by 2002:a63:1651:0:b0:342:b566:57c4 with SMTP id 17-20020a631651000000b00342b56657c4mr6605303pgw.258.1645807252698;
        Fri, 25 Feb 2022 08:40:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pj12-20020a17090b4f4c00b001bc97c5b255sm3060349pjb.44.2022.02.25.08.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 08:40:52 -0800 (PST)
Date:   Fri, 25 Feb 2022 16:40:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
Subject: Re: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is
 constant
Message-ID: <YhkGkAJtMu0epKiT@google.com>
References: <20220225013929.3577699-1-seanjc@google.com>
 <5b9e5a3f3d3c40afea0bc953e3967505251f3143.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b9e5a3f3d3c40afea0bc953e3967505251f3143.camel@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022, David Woodhouse wrote:
> On Fri, 2022-02-25 at 01:39 +0000, Sean Christopherson wrote:
> > @@ -11160,7 +11162,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >         vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
> >         kvm_vcpu_mtrr_init(vcpu);
> >         vcpu_load(vcpu);
> > -       kvm_set_tsc_khz(vcpu, max_tsc_khz);
> > +       kvm_set_tsc_khz(vcpu, max_tsc_khz ? : tsc_khz);
> >         kvm_vcpu_reset(vcpu, false);
> >         kvm_init_mmu(vcpu);
> >         vcpu_put(vcpu);
> > 
> 
> Hm, now if you hit that race you end up potentially giving *different*
> frequencies to different vCPUs in a single guest, depending on when
> they were created.

Yep.  Though the race is much harder to hit (userspace vs TSC refinement).  The
existing race being hit is essentially do_initcalls() vs. TSC refinement.  

> How about this... (and as noted, I think I want to add an explicit KVM
> ioctl to set kvm->arch.default_tsc_khz for subsequently created vCPUs).

This wouldn't necessarily help.  E.g. assuming userspace knows the actual TSC
frequency, creating a vCPU before refinement completes might put the vCPU in
"always catchup" purgatory.

To really fix the race, KVM needs a notification that refinement completed (or
failed).  KVM could simply refuse to create vCPUs until it got the notification.
In the non-constant case, KVM would also need to refresh max_tsc_khz.
