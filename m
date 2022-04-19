Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B445072BD
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354456AbiDSQQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiDSQQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:16:36 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55B9344F3
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:13:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t12so16215134pll.7
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 09:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qecgchbQpkC8VFWLfXJz9CabOj/wn5VuftBSrEpwYy0=;
        b=kkxzMeagB+WC1288SzkQy989axvDanR/Sqn1kQdtL+KdDCeMZe6BBsF1gRHW0XFzhz
         NKnwm0ce+rrTETEc34sJDtgEf+R0dekqx8cB1JGXidtJ4SABvYsMvWl9kY1ew2nA48D4
         3n8+DCmzMiU45Zs4pAQ3+8JfJGBAFcgyVzHjf4IILvl/453+EwS4+A3YCLE6W64VA/x/
         LlpLSUFG7AWWGJEgL0iid3JBuksYpQrm2UHtbYEI3GvDXYXupKyyxcXM08qm9JCKvBdY
         LTpnZgH483Tawy5rzY5dGps1hocBLY0AjhqgKdF7sYIEL3PwtRvot/oFuiw6pmBtXWpd
         +A9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qecgchbQpkC8VFWLfXJz9CabOj/wn5VuftBSrEpwYy0=;
        b=3mow5SIkdYQvd1P0chXgeIHVZTc8a97Rpt4ndZSvvTvM/Xn7JHaNkYAtPyNyGIvBu7
         aHiD9SBj4aeOXTraSd82YYKhxY8Je7UlqTzxnB8LohJ/IiBGxk1o6l9hJxy/FS0UwMr0
         iI2r36z5Nx62CShxt03REMGuyqIn0zqXiSQowABUmSnfKqrkTviCzn/9dplm4nVPc9zr
         p83O71CoDgKfBxEEwx8a0+vGoY0/km+Fr6uq7Z62dG1kdGXEt6ffoXOoLJEKJiIbTEj1
         tHg9Om6LW8LmvvLj4qnpt7viZ8ttvLq1Y1NdDleSLGbCBZ6NuPpV5fZGWI96rXL+c+r4
         NLCQ==
X-Gm-Message-State: AOAM533P3oGIyyjkmMa0jadA34IjAB65lpXCuoPjfuRtowvE+Vek8cgG
        cCimyJXCeAmKlZz6VTh8JlIZv1RVEpTr9Q==
X-Google-Smtp-Source: ABdhPJzfoR59jYWSSDA1ZskwmKf856pFmJ5wZXsaTyTgkBG82Z/RG/CwPo/haNI2IzjDq3nqETUiIQ==
X-Received: by 2002:a17:90a:a4e:b0:1cb:58a9:af2a with SMTP id o72-20020a17090a0a4e00b001cb58a9af2amr19553023pjo.101.1650384833110;
        Tue, 19 Apr 2022 09:13:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y21-20020a631815000000b0039fcedd7bedsm17596567pgl.41.2022.04.19.09.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 09:13:52 -0700 (PDT)
Date:   Tue, 19 Apr 2022 16:13:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Yl7fvbDz+ckj/psQ@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
 <Ylh3HNlcJd8+P+em@google.com>
 <877d7l5xdc.fsf@redhat.com>
 <Yl7XmmmuAZzNYiKq@google.com>
 <87o80x3vkx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o80x3vkx.fsf@redhat.com>
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

On Tue, Apr 19, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Apr 19, 2022, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> > The Hyper-V guest code also sets cpu_tsc_khz, should we WARN if that notifier is
> >> > invoked and Hyper-V told us there's a constant TSC?

...

> >> (apologies for the delayed reply)
> >> 
> >> No, I think Hyper-V's "Reenlightenment" feature overrides (re-defines?)
> >> X86_FEATURE_CONSTANT_TSC. E.g. I've checked a VM on E5-2667 v4
> >> (Broadwell) CPU with no TSC scaling. This VM has 'constant_tsc' and will
> >> certainly get reenlightenment irq on migration.
> >
> > Ooh, so that a VM with a constant TSC be live migrated to another system with a
> > constant, but different, TSC.  Does the below look correct as fixup for this patch?
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ab336f7c82e4..a944e4ba5532 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8708,10 +8708,18 @@ static void kvm_hyperv_tsc_notifier(void)
> >         /* no guest entries from this point */
> >         hyperv_stop_tsc_emulation();
> >
> > -       /* TSC frequency always matches when on Hyper-V */
> > -       for_each_present_cpu(cpu)
> > -               per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> > -       kvm_max_guest_tsc_khz = tsc_khz;
> > +       /*
> > +        * TSC frequency always matches when on Hyper-V.  Skip the updates if
> > +        * the TSC is "officially" constant, in which case KVM doesn't use the
> > +        * per-CPU and max variables.  Note, the notifier can still fire with
> > +        * a constant TSC, e.g. if this VM (KVM is a Hyper-V guest) is migrated
> > +        * to a system with a different TSC frequency.
> > +        */
> > +       if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> > +               for_each_present_cpu(cpu)
> > +                       per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
> > +               kvm_max_guest_tsc_khz = tsc_khz;
> > +       }
> 
> Looks good for cpu_tsc_khz but I'm not particularly sure about
> kvm_max_guest_tsc_khz.

Doh, ignore that, I got kvm_max_guest_tsc_khz confused with max_tsc_khz.
