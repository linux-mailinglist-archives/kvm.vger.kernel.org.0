Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294A06D9D3C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbjDFQJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 12:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbjDFQJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 12:09:00 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E48AD2A
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 09:08:35 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54bfe7a161eso43034447b3.8
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 09:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680797315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYDmhXi/TjFwHMmzA8N0vuTfzAZMCED+yyDglZvkbXU=;
        b=KCEfdgD9PzOOYg+KvucgqQrQE1hNaq/3VolOyaJJyZ4TXDo0pzMnDJ6L0fiXzXU4c5
         AabzTTX931ruQLDUIfjr+miI4EfyKvittVJVcvTaFKM3jn20r41MG3qt/CVeB+iSB2m1
         FNKo+Fwii5R8zOE2ycvd3DZH2TY5sBz4pYJg9YC5Qafe1nJLjhWEo3gSjt4Ly2ayYBOv
         z4oXzJJlu81bGcabjFWON9+GFMttEQ398tfN9N9rBo0LgA/5S6kHOY6ugcfVUUiIW7gG
         83vNktHVX8vDk6w7C5Dyhxew92/Y30LLmdHiYCNuUubULBevhi9YlnNDUIukMBO1xYfN
         kBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYDmhXi/TjFwHMmzA8N0vuTfzAZMCED+yyDglZvkbXU=;
        b=G0SYjxeo3DNRWeWV8j+y6/nLT8dJ9N0jJdG5ST+E9mO66MvdUxWzZCTlUSWaqcPfbn
         m0fYtHj4N7H71XpeuytBJ++5ePs9fSWe/u5rnurckEKVWLCzyS2TeFDFSB1ePgyjKSrf
         ApqyQilA4j33TvZYfjDE3AoIxTH4g6QZHAkySy9LjOOMYvwJ3ikCD7AaVIESRIybBYG3
         l4lvzpEy6AWMns7U0uOciobXclmtraaakP7VV9PJKqsm89PWvtOaZXhCpEFMvepmWTQ+
         n1SMPlgOCBYknscGwf0Jjr1StdHnsGVx1TLzvmAzi9dkl5ZofSOIvs+UTXTTopgmip3S
         SjHw==
X-Gm-Message-State: AAQBX9cBAa9BI++/TDRZrNpL+jo1m/ivJ53/SVe8ccgEBrwPX0byO6/y
        mZk1C44Z957vZBnhA+FyWcVfAnxG7+E=
X-Google-Smtp-Source: AKy350ZEYpasxDWhqFvJ/5zzOHtQu4My3fps0PjBEgaIISod28ND+cj65xFgu7Ib1ex6wQUjRtYjtnbKs+U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d186:0:b0:b1d:5061:98e3 with SMTP id
 i128-20020a25d186000000b00b1d506198e3mr2363694ybg.6.1680797314872; Thu, 06
 Apr 2023 09:08:34 -0700 (PDT)
Date:   Thu, 6 Apr 2023 09:08:33 -0700
In-Reply-To: <20230406095711.GH386572@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <1680766393-46220-1-git-send-email-lirongqing@baidu.com> <20230406095711.GH386572@hirez.programming.kicks-ass.net>
Message-ID: <ZC7ugeST1OOdNANg@google.com>
Subject: Re: [PATCH][v2] x86/kvm: Don't check vCPU preempted if vCPU has
 dedicated pCPU and non-trap HLT
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     lirongqing@baidu.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Peter Zijlstra wrote:
> On Thu, Apr 06, 2023 at 03:33:13PM +0800, lirongqing@baidu.com wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> > 
> > Check whether vCPU is preempted or not only when HLT is trapped or
> > there is not realtime hint. In other words, it is unnecessary to check
> > preemption when vCPU has realtime hint (which means vCPU has dedicated
> > pCP) and has not PV_UNHALT (which means unintercepted HLT), because
> > vCPU should not to be marked as preempted in this setup.
> 
> To what benefit?
> 
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff with v1: rewrite changelog and indentation

This also fails to mention my objection to querying PV_UNHALT[*].  When I said
"this needs Paolo's attention no matter what", I did not mean "post a v2 and hope
Paolo applies it", I meant we need Paolo (and others) to weigh in on the ongoing
discussion.

[*] https://lore.kernel.org/all/ZBEOK6ws9wGqof3O@google.com
