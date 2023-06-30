Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACB9743D7B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjF3O2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjF3O2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:28:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BF03AAB
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 07:28:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb0d11a56abso1664917276.2
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 07:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688135312; x=1690727312;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FRMN0RaJzHYAyXMyga4ctoKFK0XbdFwKMcCpI/juWEU=;
        b=am0dqL8tuDa5C5eAHIW+joInjR/a055ifnjo+XJOjG+qcVcc7ILCAG4uVycrP+mFcK
         FAn7/4Eq65Dj34v0YTkD597Txnxmc+yQPxISjWUK0rVlT9d0BVlp9L1X8s3nUnCLaM5/
         gouPMfh60JcbsvPSV6U19hQ1Yf139QyGWx9RbOfUmcfTgQVSrgUU6K2AbQpJnLu9iLO7
         fJs1jOtYs29gobQ1SfpvZJE3vM8gac16O3IHANQE9D6y/hF72mLvpEzVgIxJRx/Kz32Q
         xEJ560pfJvDmiswQ/NIhDKt5VHKXP+GaRT/ApbOWVkNFq+RXhECgD5nn/0xPbotUDJsA
         nUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688135312; x=1690727312;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRMN0RaJzHYAyXMyga4ctoKFK0XbdFwKMcCpI/juWEU=;
        b=FdzLNnteOsAZczLFMlGca58KVOCDtGQbToxUALurxKd6SH/79v7j1naw8cMVXxuCKo
         cJYsmiE/sMmvcuWjtc6nzQRSDiXZoBCUfJoh+5fACiNM+47WH9Slbe9HP1d9FeU5EoMZ
         JJ0ZaeEjQ4QxwHUoB+eThJKn7/rCLQi0r8FB66WzudkOo3oeGDALNF5V8Iiaz1uYu7TO
         sOVG5l/0mosGGPFJGPdwwQEE92JlLKvRVAPYNUja8ICPkPWT4X+Ms9ZKvASnWkkQiBZi
         o+/SvtnkTaB5FC1y7LEQVfUt0tZ+dBtnvGlBkNQaSrtAlTB2VzHpz2Pak1ahd/118ugp
         1aCA==
X-Gm-Message-State: ABy/qLZeXwKWXIqVo1K3t1BhlRu4QlAx5sxy2XirTYdjpgXp5uV7FAxK
        mqEHrn9sNAjb3alcGWJ9wJb7Hh0FLuM=
X-Google-Smtp-Source: APBJJlHOOLORAgt37+VIRI8/WOvT0fj13Al51joe6mbUicQPhnu539E1jFNneO9sew/vI5ZTflnm86W+tdM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f602:0:b0:c11:bb8d:75f4 with SMTP id
 t2-20020a25f602000000b00c11bb8d75f4mr17391ybd.8.1688135312230; Fri, 30 Jun
 2023 07:28:32 -0700 (PDT)
Date:   Fri, 30 Jun 2023 07:28:29 -0700
In-Reply-To: <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
Mime-Version: 1.0
References: <20230504120042.785651-1-rkagan@amazon.de> <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com> <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
Message-ID: <ZJ7mjdZ8h/RSilFX@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
From:   Sean Christopherson <seanjc@google.com>
To:     Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
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

On Fri, Jun 30, 2023, Roman Kagan wrote:
> On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> >         return counter & pmc_bitmask(pmc);
> >  }
> > 
> > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > +{
> > +       if (pmc->perf_event && !pmc->is_paused)
> > +               perf_event_set_count(pmc->perf_event, val);
> > +
> > +       pmc->counter = val;
> 
> Doesn't this still have the original problem of storing wider value than
> allowed?

Yes, this was just to fix the counter offset weirdness.  My plan is to apply your
patch on top.  Sorry for not making that clear.  
