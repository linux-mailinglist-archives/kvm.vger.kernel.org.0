Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2885556911C
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiGFRwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiGFRws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:52:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7B06459
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:52:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g4so14604317pgc.1
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 10:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=3eyJEdBzFu1fGOqq23lTWJQZdhZMM8HyIhz/8acbGII=;
        b=osbs35RmPZ+9VszHQ+FczPth3vyIqnf3OB0itULW8v6dUm8l6LqPkqNZvPPDz+p//r
         6Tg6/1cfqNfDbbVOiE8JOJLvZoaSzlek9mLi2zJj8F/dGhXizIwZwQpSjjgpmS3bAi+R
         LTQg1yL9Nse4n+zU3qT6pd3JjktDNFHTixi+F6CEac1M7LYV1/Ocfrj1xtQmD6Vq77gO
         QHmJn96/j3jn5jkX1bUQwN8wEJcfZ1AtpgHWe7UYbXPYw3nWsqi9JvGoCWffk+nZzg8V
         EvV4+OT7sCc/h4iFzxD0b4ISw3WLtTO5COzZ4tFIa1gSLsz3/abzOpYdRrii4v1jL1Vl
         2/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3eyJEdBzFu1fGOqq23lTWJQZdhZMM8HyIhz/8acbGII=;
        b=z9rcAtEk5WkrPjJG7Qkjaoyo0CBgoU6iQ4dYF5KF15xUmgO9Ve79ZASComNtXthP+1
         7gDaFnHdvPhYjiXwkRpgwoGWkxcKTeSnO1EtIVxHFvdwJCifqpMoL+pPtSzex5hrssiS
         EbCP7rQfGSeZnQGvj63Jnj/B/mJK4ubW+GqUyO8sA4OD58goyCfvioe0Wf8I8Z89AQ7y
         9mhMYbZaJFxNQO3W4282gLMvYMrAOmJbJNXPUUljs27E6GlpyjKuL8lRLxIymZIQxYIZ
         bL+fCbRh/qURjRMWBVr1RtrGcz8UOtc7KS+TOoPckzhjCZQPuulSi3UZ/LG87Qs/cQrI
         U7MA==
X-Gm-Message-State: AJIora8KtwDEt9Gr4w29SEDP781v9z7RhbZQ3DwD9xaqeX8iE76MQBLx
        Fr2crp/amAWpFmn3XqZsHMuS1Q==
X-Google-Smtp-Source: AGRyM1u2cF1dXHXr3kEx7bhBClx7KSO7PJsoLfjJ1cmILW686cMPPGtpTnDD3R0oRIEF5gGH9o4Iaw==
X-Received: by 2002:aa7:94ad:0:b0:525:265b:991f with SMTP id a13-20020aa794ad000000b00525265b991fmr49042989pfl.30.1657129966693;
        Wed, 06 Jul 2022 10:52:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b9-20020a631b49000000b00411bbcdfbf7sm11659410pgm.87.2022.07.06.10.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 10:52:46 -0700 (PDT)
Date:   Wed, 6 Jul 2022 17:52:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
Message-ID: <YsXL6qfSMHc0ENz8@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
 <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
 <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
 <cab59dcca8490cbedda3c7cf5f93e579b96a362e.camel@redhat.com>
 <CALMp9eT_C3tixwK_aZMd-0jQHBSsdrzhYvWk6ZrYkxcC8Pe=CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eT_C3tixwK_aZMd-0jQHBSsdrzhYvWk6ZrYkxcC8Pe=CQ@mail.gmail.com>
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

On Wed, Jul 06, 2022, Jim Mattson wrote:
> On Wed, Jul 6, 2022 at 4:55 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > 1. Since #SMI is higher priority than the #MTF, that means that unless dual monitor treatment is used,
> >    and the dual monitor handler figures out that #MTF was pending and re-injects it when it
> >    VMRESUME's the 'host', the MTF gets lost, and there is no way for a normal hypervisor to
> >    do anything about it.
> >
> >    Or maybe pending MTF is saved to SMRAM somewhere.
> >
> >    In case you will say that I am inventing this again, I am saying now that the above is
> >    just a guess.
> 
> This is covered in the SDM, volume 3, section 31.14.1: "Default
> Treatment of SMI Delivery:"
> 
> The pseudocode above makes reference to the saving of VMX-critical
> state. This state consists of the following:
> (1) SS.DPL (the current privilege level); (2) RFLAGS.VM2; (3) the
> state of blocking by STI and by MOV SS (see
> Table 24-3 in Section 24.4.2); (4) the state of virtual-NMI blocking
> (only if the processor is in VMX non-root oper-
> ation and the “virtual NMIs” VM-execution control is 1); and (5) an
> indication of whether an MTF VM exit is pending
> (see Section 25.5.2). These data may be saved internal to the
> processor or in the VMCS region of the current
> VMCS. Processors that do not support SMI recognition while there is
> blocking by STI or by MOV SS need not save
> the state of such blocking.
> 
> Saving VMX-critical state to SMRAM is not documented as an option.

Hmm, I'm not entirely convinced that Intel doesn't interpret "internal to the
processor" as "undocumented SMRAM fields".  But I could also be misremembering
the SMI flows.

Regardless, I do like the idea of using vmcs12 instead of SMRAM.  That would provide
some extra motivation for moving away from KVM's broken pseudo VM-Exit implementation.
