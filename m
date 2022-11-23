Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC774636882
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiKWSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239582AbiKWSRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:17:49 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDF810FC7
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:16:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id a1-20020a17090abe0100b00218a7df7789so2822806pjs.5
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tPtG6fZZhKtGLftjAJCGFWjxf1W8gNx6BzHO8wa+RDY=;
        b=n+sWxH04gAVH9IaWSdVXB27EzzqDQRv8kExFSiEKcT/FrhFpF50phN8ImDhmJjB4Uv
         kLVYklIplhJ3RCJF7H8no9ZuJVCwTld3OhYEX4hs0wfgSNV/MP4XRBJ+9PhSC4R/6qZW
         PFSNjcyPB37Ptq4ag1XKo7AGQfOtow9z//E56zdRBaXkhnCag1TONnxCPjoXwW2l6SPv
         uf55CgnmFO2WsWyC7X4DUjUIZ3duz/52XwqlR1mINLUkK08KOjUZf3ruyQIZOWHPG+Qs
         cx2jA/vp+oFdP8dzoQdaa1GoTM+IIkTy85vbEFTYIvqBa928XvNCwe1zZzTGvY16kHmb
         0WpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPtG6fZZhKtGLftjAJCGFWjxf1W8gNx6BzHO8wa+RDY=;
        b=u68kinL3IpDeleEnKnW7ml2CJxG7/0VzcLjMn7DmzzonC5/6y5jez1mbrYFKePo0XM
         U0AhZKRr5R0ezUwtZ6qp0/6ovMlzf8ksCop8XLFOrYrE06VLhlNLtRqY2vu7RETdvX8I
         5/Is76Llqch4EN66VRgqttzCr80f1NF/wM/bxh0ST7nSyUm5+VQOVzTDdUOWPm6Q4GbN
         xzFDCe8nFxZ8vNgGuF+/7G9JcCm+3E0coNWWJHR+vjZrYODVEMZNNd7dtwcPWi3tqsdN
         ZTu30kIU87apdvHEOV7FoYeCu7T05KM/3N/PFc1J/It7NMClFBITmJrZYMRUnQ6pLpPP
         +WiA==
X-Gm-Message-State: ANoB5pltfA1mFdb8h/0/0F2euab0lEMeq5LIoISeHkFL3Ml3cpGmpjEG
        33LDxxycKTBriZiKsl2WBuUqww+oZdo1VQ==
X-Google-Smtp-Source: AA0mqf6Jkkz3t5x4GuMqI9rJ34J/1T1JWKCv1jVDMNDLXHs8MC687fBC20R4tLNWisJ8eXlpfFFfJA==
X-Received: by 2002:a17:90a:cb11:b0:218:d772:ec60 with SMTP id z17-20020a17090acb1100b00218d772ec60mr6982300pjt.143.1669227385878;
        Wed, 23 Nov 2022 10:16:25 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902780a00b0017ec1b1bf9fsm8845536pll.217.2022.11.23.10.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 10:16:25 -0800 (PST)
Date:   Wed, 23 Nov 2022 18:16:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        mhal@rbox.co
Subject: Re: [PATCH 2/4] KVM: x86/xen: Compatibility fixes for shared
 runstate area
Message-ID: <Y35jdRxK27o96r//@google.com>
References: <20221119094659.11868-1-dwmw2@infradead.org>
 <20221119094659.11868-2-dwmw2@infradead.org>
 <Y30XVDXmkAIlRX4N@google.com>
 <a12c8e6123cf702bc882988f9da3be7bd096a2e3.camel@infradead.org>
 <Y35VxflJBVjzloaj@google.com>
 <ff2c3f2ea7286e78bb2cfb1fdb218401e87cef1e.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ff2c3f2ea7286e78bb2cfb1fdb218401e87cef1e.camel@infradead.org>
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

On Wed, Nov 23, 2022, David Woodhouse wrote:
> On Wed, 2022-11-23 at 17:17 +0000, Sean Christopherson wrote:
> And with or without that cache, we can *still* end up doing a partial
> update if the page goes away. The byte with the XEN_RUNSTATE_UPDATE bit
> might still be accessible, but bets are off about what state the rest
> of the structure is in — and those runtimes are supposed to add up, or
> the guest is going to get unhappy.

Ugh.  What a terrible ABI.  

> I'm actually OK with locking two GPCs. It wasn't my first choice, but
> it's reasonable enough IMO given that none of the alternatives jump out
> as being particularly attractive either.

I detest the two GPCs, but since KVM apparently needs to provide "all or nothing"
updates, I don't see a better option.
