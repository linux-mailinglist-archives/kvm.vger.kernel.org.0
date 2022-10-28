Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924E0611D7C
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 00:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJ1Wnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 18:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJ1Wnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 18:43:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0115C1BA1EF
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 15:43:48 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so5782545pji.0
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 15:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cHR45kjH2znHWnFmIGNkJ/cSlv9LgRb4S3Wf/CHTVok=;
        b=r15GPLT621sSCoeuICTdvZtS4e+kfBOLAlK79IwHbbKc3Xs0fEiEb7Ksdt9ZVIn9G+
         x37ibpU3eJpN+UFiRBBWfIQ+skymrJfbHByqAEFyJtp0Oy+0m+a1dw3Imn0sTKo3AASS
         vwFkVD2+0di/TqkCK6UbytLXk9Xn7HB+Sh9QvcbjknAXC37ySYrfdx0UJr39gdjK71Og
         Z7Pb+RscQ2Xi5TRivctFe65WJcl7vae87gYMu57db5d0kcE9GXd6cbAkbb4vffzO7Mi+
         Do2F5Wp3VhIxqwEeLeHeGH/krPQyvkUtLR2heAsNZpiM4XrlLpbL04xe6Et45AXWCenM
         X4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHR45kjH2znHWnFmIGNkJ/cSlv9LgRb4S3Wf/CHTVok=;
        b=hGh9lFq9nWFqhpmbHHr6xdweQWCiFqHlK7UpGUNrbVSzitTQ8yqaEiOJ6yzlo9tU7J
         UiUIqFGvUKyWV0I30FT/pCAl7u0tZf5gAtKPAhldir8t5aO4yYsK0L/u9IbPDwoW2bIo
         raspkjw+grTtRnO/Bxjk5hpBT8qZuIHEXlyqgiEY5wCNOcd4xGl6m3l4XndxZ//lQDhy
         hTeR2zhmi5l10+2BNAckn6TGL1+6YTErW/bWrRJsRRFWUKzSDbzDkdFzqIjnM23Is4aP
         n9oJO2vC0MNIsIjgRni1NrfoOwHL/1ub+F6opVRCDxGG5plFJSFYO7Ld+MgzI7Xj4Y4a
         I8Rg==
X-Gm-Message-State: ACrzQf0y+cPkr0ul1Zy8QJlYDVEsLjTS1DeZArKVc6ZwKLL1BkZOJIGc
        XzERaS3ooB+TbzB8ub+cM//RJ/MUAHzCZg==
X-Google-Smtp-Source: AMsMyM6JeYeaTej9dClKxvUI5YjEFcJMyB+RUzO/TgK6XyL88smXVuR5N9OvBUbb3vmVXZyUs1Dqcw==
X-Received: by 2002:a17:90b:33d0:b0:213:137b:1343 with SMTP id lk16-20020a17090b33d000b00213137b1343mr1645497pjb.128.1666997028410;
        Fri, 28 Oct 2022 15:43:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902d18b00b0016d4f05eb95sm3460938plb.272.2022.10.28.15.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 15:43:47 -0700 (PDT)
Date:   Fri, 28 Oct 2022 22:43:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Fix a stall when KVM_SET_MSRS is called on the
 pmu counters
Message-ID: <Y1xbINshcICWxxfa@google.com>
References: <20221028130035.1550068-1-aaronlewis@google.com>
 <Y1wCqAzJwvz4s8OR@google.com>
 <CAAAPnDEda-FBz+3suqtA868Szwp-YCoLEmK1c=UynibTWCU1hw@mail.gmail.com>
 <Y1xOvenzUxFIS0iz@google.com>
 <CALMp9eT9S4_k9cFR26idssjV+Yz4VH23hXA10PVTGJwNALKeWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT9S4_k9cFR26idssjV+Yz4VH23hXA10PVTGJwNALKeWw@mail.gmail.com>
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

On Fri, Oct 28, 2022, Jim Mattson wrote:
> On Fri, Oct 28, 2022 at 2:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > > On Fri, Oct 28, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Fri, Oct 28, 2022, Aaron Lewis wrote:
> > > > @@ -3778,16 +3775,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > > >
> > > >     case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> > > >     case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> > > > -        pr = true;
> > > > -        fallthrough;
> > > >     case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
> > > >     case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> > > >         if (kvm_pmu_is_valid_msr(vcpu, msr))
> > > >             return kvm_pmu_set_msr(vcpu, msr_info);
> > > >
> > > > -        if (pr || data != 0)
> > > > -            vcpu_unimpl(vcpu, "disabled perfctr wrmsr: "
> > > > -                  "0x%x data 0x%llx\n", msr, data);
> > > > +        if (data)
> > > > +            kvm_pr_unimpl_wrmsr(vcpu, msr, data);
> > >
> > > Any reason to keep the check for 'data' around?  Now that it's
> > > checking for 'report_ignored_msrs' maybe we don't need that check as
> > > well.  I'm not sure what the harm is in removing it, and with this
> > > change we are additionally restricting pmu counter == 0 from printing.
> >
> > Checking 'dat' doesn't restrict counter 0, it skips printing if the guest (or host)
> > is writing '0', e.g. it would also skip the case you encountered where the host is
> > blindly "restoring" unused MSRs.
> 
> The VMM is only blind because KVM_GET_MSR_INDEX_LIST poked it in the
> eye. It would be nice to have an API that the VMM could query for the
> list of supported MSRs.

That should be a fairly easy bug fix, kvm_init_msr_list() can and should omit PMU
MSRs if enable_pmu==false.
