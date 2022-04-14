Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4D501E33
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 00:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbiDNWZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 18:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiDNWZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 18:25:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820C1B6E56
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 15:22:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ll10so6315104pjb.5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 15:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1xa1ESBDSGyY8UU/qWjOzGPkAfpQhGYww95crIFFhNY=;
        b=IVUMC9lb1svE5Tw8hyaLGHwkuwA7fdLycjSCgs+AWEmUtQZenl7Qzuak0s9q66Cb5a
         xEp/t6vPItaijnlLQKssysDfm5J+OlfoeFz+j1Yycn8ye6yZ/UzHR9hT4ocDgnznuqeu
         iiJruovja3Usd+RzAOfD2AcCH6B/sIFa/+JBV4QgN9LE84nIUC90I6P5ZnwtvuWOzT1A
         nLnMrMrWaglqr/a2egUm0E8Ed6cG0Rkw027+VBNItakIVq5uEoNpvc5FL2zINryNPtS6
         2Ep50k6nWeLycIGhMkDr3kE83HL7IVMI4x8o97zG26vBcsIQsmsSeRq+TS3u9VWxpAlW
         OqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1xa1ESBDSGyY8UU/qWjOzGPkAfpQhGYww95crIFFhNY=;
        b=EFVNQqwmXV3Cx2sG6vze6AVjdfed1Wob3y8kijWgWcZ0Kzlgv4gwM2kxCHEpsiZk+m
         OaZIMspjCWlAgIg3gpd1eH22b7+bEzXZmORszq+zdCSWr4OfneUYQvyQYSDjMmc8evTj
         nGhWr4Imvm4GY4+u9pY66YUCxMnVLXEFyIUt50WURaXHmsJMk+o718DchKNM6vMWA7+U
         ZqQasJ6I7oBlWsOw46PoSx7Jf0iHQNOsiryJToXqCHDRpwt/fpN9JN+2EA1on8pj8qUs
         wVm3BvVoPxA4cMhVqtqR/TAtKwHItMWVsHWDupE1PY7TS78Rzm4eC5eHw70Jp8JJKUDA
         yuGg==
X-Gm-Message-State: AOAM530mxQjqloACVXkX2J1Q/KUzi6Dxl9c7Qu+F9Da3cYwnI2q/nGrR
        Aag8icXq9QuekQxQa0OmTnISyQ==
X-Google-Smtp-Source: ABdhPJzYCSbPc54jK7KfEz8+YtotBqRuxRvWz87K/s48F7eth012LaSR/BtMJ/5apTfh4uT+TojgmQ==
X-Received: by 2002:a17:902:6b8b:b0:14d:66c4:f704 with SMTP id p11-20020a1709026b8b00b0014d66c4f704mr49974054plk.53.1649974967844;
        Thu, 14 Apr 2022 15:22:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c138-20020a624e90000000b005081f92826dsm849249pfb.99.2022.04.14.15.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 15:22:47 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:22:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Ylies1A6K2zVpoM6@google.com>
References: <20220414183127.4080873-1-romanton@google.com>
 <Ylh3HNlcJd8+P+em@google.com>
 <CAHFSQMhwsMEOFeMuMrvvveeN=skqA-DLM_r3EqU+dei-jXUkUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFSQMhwsMEOFeMuMrvvveeN=skqA-DLM_r3EqU+dei-jXUkUA@mail.gmail.com>
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

On Thu, Apr 14, 2022, Anton Romanov wrote:
> On Thu, Apr 14, 2022 at 12:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > On Thu, Apr 14, 2022, Anton Romanov wrote:
> > >  /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
> > >  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
> > >  {
> > > @@ -2917,7 +2930,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
> > >       get_cpu();
> > >
> > >       data->flags = 0;
> > > -     if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
> > > +     if (ka->use_master_clock && get_cpu_tsc_khz()) {
> >
> > It might make sense to open code this to make it more obvious why the "else" path
> > exists.  That'd also eliminate a condition branch on CPUs with a constant TSC,
> > though I don't know if we care that much about the performance here.
> >
> >         if (ka->use_master_clock &&
> >             (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
> >
> > And/or add a comment about cpu_tsc_khz being zero when the CPU is being offlined?
> 
> It looks like cpu_tsc_khz being zero is used as an indicator of CPU
> being unplugged here.

That's ok, the unplug issue was that kvm_get_time_scale() got stuck in an infinite
loop due to cpu_tsc_khz being zero.  Using tsc_khz is ok even though the CPU is
about to go offline, the CPU going offline doesn't make the calculation wrong.

> I don't think your proposed change is right in this case either.
> How about we still keep tsc_khz_changed untouched as well as this line?
> Potentially adding here a comment that on this line we only read it to
> see if CPU is not being unplugged yet
