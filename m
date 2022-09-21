Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA05C0028
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiIUOno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 10:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIUOnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 10:43:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10807AC16
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 07:43:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so14470833pja.5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=heq5rZvN+EGrohBVywR7F1I7ftprT9BYNJxsW17y0KY=;
        b=rYBMgx5nswumYwHQUxh+1K6W4hl24VU/Fk4UTcaSstDM96c9h4fkTscWCjyzxh6O3t
         roXwV4/5sWRNvGPK9pcd7G2+cOoz8GaULC8N006oVRc350gLMZiOir6/JD2+LVa24p1s
         Ob3BNRK0X6IOeNk7olwtfV/TPwjWNoJEMMQqBRFoZQTGKndNTMtsUlr/6UdkP9wNfmFM
         AtcPRNgcgWr2tKQclrDqpi2lAX3GW6dC6EzKVJINLiBM9/2yMQ1v2CvWJJ5ikv8wpTKU
         +ZnB9HNoMJ8sVveuAp1S6+qVpLzHUGh9FkLaUQwCrO6XRgBFvEJslunQTmy+S0XSAsy6
         PE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=heq5rZvN+EGrohBVywR7F1I7ftprT9BYNJxsW17y0KY=;
        b=nFEKwDQUHs1nqqLp9CB+QG6HY1rcwK6iRtS2x6ooUw/y+1TgQolIDCL2R1jcNKuzfJ
         /N6Pb9zDHIser9GgdtmeX2FO5KI67mKiEuXqDgGskOBiSnRx+YANK1bk56Dv1oYfFUKg
         2FpLiGIA1NOYwSbUsyyvkMd1O7ON7/8t6Nz4hX95ayRTReaA22vTjXU+cWETuQSjHy+Z
         HJDkIb3kh+DnPBmXuwOKTfgDLFE93oRcOUf2wA4IpYkRM0GllempOUQ0wSlETqir1Nd/
         RfJz/gorLjc1NFPlOXQHowtsamB/J6j4ef+bAM/McU/1GikF9GUWdUkggxzAE6WmAq1K
         15Rg==
X-Gm-Message-State: ACrzQf2Oi5hk1Ix4M7JHTIHSZjkWpcKJYpEfI0XeB86gg1f8cLJMY+P1
        9B4XtweTPhb+4bvMH2yEIVFprQ==
X-Google-Smtp-Source: AMsMyM7vQ4/4kLsDWDAJPeVcMIDBkxnvRfId89fUwqrhRVB2PeGE/UKBJESUL+Ka8bxnlYKjNI6hUA==
X-Received: by 2002:a17:902:8f81:b0:178:1276:59e6 with SMTP id z1-20020a1709028f8100b00178127659e6mr5175534plo.94.1663771420094;
        Wed, 21 Sep 2022 07:43:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c10400b00168dadc7354sm2143296pli.78.2022.09.21.07.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 07:43:39 -0700 (PDT)
Date:   Wed, 21 Sep 2022 14:43:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 1/9] KVM: x86/mmu: Bug the VM if KVM attempts to
 double count an NX huge page
Message-ID: <YysjGNtYJbbPuxSN@google.com>
References: <20220830235537.4004585-1-seanjc@google.com>
 <20220830235537.4004585-2-seanjc@google.com>
 <87tu50oohn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu50oohn.fsf@redhat.com>
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

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > WARN and kill the VM if KVM attempts to double count an NX huge page,
> > i.e. attempts to re-tag a shadow page with "NX huge page disallowed".
> > KVM does NX huge page accounting only when linking a new shadow page, and
> > it should be impossible for a new shadow page to be already accounted.
> > E.g. even in the TDP MMU case, where vCPUs can race to install a new
> > shadow page, only the "winner" will account the installed page.
> >
> > Kill the VM instead of continuing on as either KVM has an egregious bug,
> > e.g. didn't zero-initialize the data, or there's host data corruption, in
> > which carrying on is dangerous, e.g. could cause silent data corruption
> > in the guest.
> >
> > Reported-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 32b60a6b83bd..74afee3f2476 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -804,7 +804,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  
> >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  {
> > -	if (sp->lpage_disallowed)
> > +	if (KVM_BUG_ON(sp->lpage_disallowed, kvm))
> >  		return;
> >  
> >  	++kvm->stat.nx_lpage_splits;
> 
> This patch (now in sean/for_paolo/6.1) causes nested Hyper-V guests to
> break early in the boot sequence but the fault is not
> Hyper-V-enlightenments related, e.g. even without them I see:

...

> [  962.257992]  ept_fetch+0x504/0x5a0 [kvm]
> [  962.261959]  ept_page_fault+0x2d7/0x300 [kvm]
> [  962.287701]  kvm_mmu_page_fault+0x258/0x290 [kvm]
> [  962.292451]  vmx_handle_exit+0xe/0x40 [kvm_intel]
> [  962.297173]  vcpu_enter_guest+0x665/0xfc0 [kvm]
> [  962.307580]  vcpu_run+0x33/0x250 [kvm]
> [  962.311367]  kvm_arch_vcpu_ioctl_run+0xf7/0x460 [kvm]
> [  962.316456]  kvm_vcpu_ioctl+0x271/0x670 [kvm]
> [  962.320843]  __x64_sys_ioctl+0x87/0xc0
> [  962.324602]  do_syscall_64+0x38/0x90
> [  962.328192]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Ugh, past me completely forgot the basics of shadow paging[*].  The shadow MMU
can reuse existing shadow pages, whereas the TDP MMU always links in new pages.

I got turned around by the "doesn't exist" check, which only means "is there
already a _SPTE_ here", not "is there an existing SP for the target gfn+role that
can be used".

I'll drop the series from the queue, send a new pull request, and spin a v5
targeting 6.2, which amusing will look a lot like v1...

Thanks for catching this!

[*] https://lore.kernel.org/all/Yt8uwMt%2F3JPrSWM9@google.com
