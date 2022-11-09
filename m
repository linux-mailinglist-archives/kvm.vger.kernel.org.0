Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073796231A6
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 18:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiKIRlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 12:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiKIRld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 12:41:33 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73C824BF6
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 09:41:31 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a14so26877104wru.5
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 09:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FNYds1f9ZL8XgnZzTxl56q0EBnMAgb+3F/vcLxdiyjY=;
        b=HmmYyp3Qgno4anKoP7Tf7q7d/WISnuBlr7BJ0D915Z10LN0M1vE/dszOUSQgaNAVNE
         RKITKmFOgwtCpHDaED8lfP1ZxKBICMVarUiG3p5Pl7LMe2VUv3MCdu/7k8zo/82mHJ9r
         nlNsD8K/sAdmL87VMjC2kb8HpC7mmXsu8+7WprnrK/J06z3WHg2BFQ3sLROPqXyg0JI4
         If05iCBexuX8MSRjCYuypIhofqtgBQgo/qijG6nK4LO6odKCpgf/7mtAIwJCy7fVpBXh
         hb/rBWawNDPHZZpGf/7vDmD170a95FAoDCE68DIdmz/JvWnpr/97hW6lvb8kyIvFR0Sd
         QV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNYds1f9ZL8XgnZzTxl56q0EBnMAgb+3F/vcLxdiyjY=;
        b=GEDilkVQgyrj99tsjcuCQ5tX1MEoUKY9IdqHXE6aBm+L4UAtunEIHwW8yaevyqDgKA
         lKg4SOYgskQVqrQYy7ZRim9gFmGMKBqNYcq8fTpicVEMec+F5YkuaylIEJgVNponR+M2
         t1EDG3yqDDOIFU+40fLxU7l+o+FgiTUDy9GHPd+c0+6O/mcUuSGrv/ov0TEAz8LKuoL7
         vdlHxN8Z2M7Xi5N0brGvM/oPr4pbHdjP1XSz32kQcy57ymUzdJhKP3Mf9NmySvdfoLFJ
         fDnLFvIeXLCYMUxWBA1WlR5JXEsrXHFN7YR/PsrOcu5APjNT+vv0PL7sy6/2ZtJ3+Enw
         3img==
X-Gm-Message-State: ACrzQf1sCfpAgo7g3uvGt7N8shHS8OrCg5kfUtu17GPDI93fkquN43MU
        wtcOM/TmRBawBelwE4NvZVwYwfQcGpw9ks/NpWWMnYSqC6w=
X-Google-Smtp-Source: AMsMyM6huWkt2OecZYhRv3lX19RTINP7yOdkpcvfpTxSimbMiYM0nhjhj9WtCSFAhcBpR3zCAEjNqLwPyqP+aFYw2bc=
X-Received: by 2002:a5d:604c:0:b0:236:6deb:6d31 with SMTP id
 j12-20020a5d604c000000b002366deb6d31mr38775518wrt.282.1668015690097; Wed, 09
 Nov 2022 09:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
 <Y1sAB0LlTPwnWjZp@google.com> <ed069cc3-bd0b-8d21-50b3-202e6e823ad2@gmail.com>
In-Reply-To: <ed069cc3-bd0b-8d21-50b3-202e6e823ad2@gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 9 Nov 2022 17:41:18 +0000
Message-ID: <CAAAPnDFa2Udnv0-L2CxWNWXChs8dX1sugmJwf4TrnNy-hwaqjg@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] Introduce and test masked events
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Nov 9, 2022 at 11:28 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 28/10/2022 6:02 am, Sean Christopherson wrote:
> >> Aaron Lewis (7):
> >>    kvm: x86/pmu: Correct the mask used in a pmu event filter lookup
> >>    kvm: x86/pmu: Remove impossible events from the pmu event filter
> >>    kvm: x86/pmu: prepare the pmu event filter for masked events
> >>    kvm: x86/pmu: Introduce masked events to the pmu event filter
> >>    selftests: kvm/x86: Add flags when creating a pmu event filter
> >>    selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
> >>    selftests: kvm/x86: Test masked events
> > One comment request in the last patch, but it's not the end of the world if it
> > doesn't get added right away.
> >
> > An extra set of eyeballs from Paolo, Jim, and/or Like would be welcome as I don't
> > consider myself trustworthy when it comes to PMU code...
> >
> > Reviewed-by: Sean Christopherson<seanjc@google.com>
> >
>
> I'm not going to block these changes just because I don't use the
> pmu-event-filter feature very heavily.
> One of my concern is the relatively lower test coverage of pmu-event-filter
> involved code, despite its predictable performance optimizations.

Is there something else you are hoping to see as far as testing goes
other than the selftest?  Or is something missing in it?

>
> Maybe a rebase version would attract more attention (or at least mine).

Sure, I'll send out v7 rebased on top of kvm/queue.

>
> Thanks,
> Like Xu
