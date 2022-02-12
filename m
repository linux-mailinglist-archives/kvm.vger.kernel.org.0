Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4C34B38A8
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 00:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiBLXcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 18:32:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiBLXcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 18:32:50 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1DD5FF27
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:32:46 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id o128-20020a4a4486000000b003181707ed40so14894830ooa.11
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 15:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vmaSptng9jreS1XXMbr6KSYdnJ6+9nuFAm8sfmi6BQE=;
        b=T84POPRan5/lU9yCOzviw+LOlorxyZIrfQqfsOAJjsfkEiSLm3LpMSQRs5ae6Lb7Jc
         82X+0xh8ZABAho8YYHYlBDZrqbP3TZakeCnsoXgGif18g42KJ0RhHwKTEy8LlnSrPhIi
         nf9tzZLJCIhxR29e8hXScHtnxc9j8tUZCc1snPxjqIJKEf+Ys7wRfT+aauvGD9lGUTZF
         tm8Yj8MEWokKzwZOx2QYeHswuo2pARy2IEpF/OCkZdQwmPTa741IiZoIB67ZYQAo8XJQ
         VP1irJOvWdLwQ37BYLmwoDgEyDFvZYKRFuhxup4qsKOGjYzGyDSLh1/3VrwgJYi7Dfg9
         +AHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vmaSptng9jreS1XXMbr6KSYdnJ6+9nuFAm8sfmi6BQE=;
        b=7ZZj3XxzPseFysvIJUAF++rIBKXwfjB1UwNUvjGfS8f98AqFTic0xKH5muuKWwfPma
         E3z7kefdJf4uKCN1D7K12EPK//6/7osFvelGo1/7ZSBk1pkjYbQyXQdS5vTAbfPadIkA
         /tht6JSYIYZrwdVTgdJ+vYZ5RFNa6mCSumJSry4BPGfVXgZepxMwVuN8RM7k8eDB3xed
         KbYvhuXD2XO/4eHfYMYx45lG4X0ssatP65OiE8Cf4f07QGxg8rWxiVTL2jRXGsvbaiZF
         GEgiLcYHRAyrT+SGXn73Q43jBdlwjXV9yACEC8wCPq8tDLB6Qu9hOclzxD93+11q24Mi
         nufA==
X-Gm-Message-State: AOAM531tg2WCSZgjwhV8Nj2+CcwL7j76YUzATAdl/15Feg8X0yXMb8yK
        TYlNFQWHkusfZwR1ngkCPaPC6dwSI0cuBguctWBM7w==
X-Google-Smtp-Source: ABdhPJyoQOtsaws9OAJx+h1f1VrsgKqQm5BCWA6ItvT/d8OJ70TWXOyhJMtmV5Ssp7XFZApO052VF/6vooyEZ0RrDK0=
X-Received: by 2002:a05:6871:581:: with SMTP id u1mr2068039oan.139.1644708765547;
 Sat, 12 Feb 2022 15:32:45 -0800 (PST)
MIME-Version: 1.0
References: <20220117085307.93030-1-likexu@tencent.com> <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net> <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com> <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
In-Reply-To: <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 12 Feb 2022 15:32:34 -0800
Message-ID: <CALMp9eRX3nTLs4gcy3wnSUSOPO7xzDpMvDLGauue9o0PwBAmbA@mail.gmail.com>
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        David Dunn <daviddunn@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:

> Does SGX cause problem for these people?  It can create some of the same
> collection gaps:
>
>         performance monitoring activities are suppressed when entering
>         an opt-out (of performance monitoring) enclave.

There's our precedent!
