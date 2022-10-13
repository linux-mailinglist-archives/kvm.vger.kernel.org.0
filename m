Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780DD5FD1C2
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 02:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiJMAqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 20:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiJMApd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 20:45:33 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485D9F6C26
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 17:37:55 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so3473332pjq.3
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 17:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sLhr5UEdODqNRx69fxh3jRb3tIUO59cTzeH/dk/N40Q=;
        b=lbMVFVWkt0+AkHPs/B78S0AxNXAwt0BHhEEleMCC13XefRbkjVr/zYJa9cIA4U+1Tn
         Kh5KCDMTEwuzJSOdivAYr3z7C3LqHtKfsLndTo1O/FVZClyqgq0ce2ewl/4DflH1y0Fj
         PGFrZ0rmvQwRyrTNjYRgQv+WvCDyHNrNnf+KVZBNclaBDoavl3ru6CnrLs0vyD5ikGhO
         X5MlfW4tzv7iriza1GkwYh3wgkJW+Q8Pd3pC1y0IfONIe/Tku4HNWhdmWu6yyER4e2Zh
         swD9TclYa0nG9MGMttykmy85WrLUn4q2z0w5xKDUcjN03H9MQ4u5xR1XVA4te818+LYR
         Gxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLhr5UEdODqNRx69fxh3jRb3tIUO59cTzeH/dk/N40Q=;
        b=WQ929olHE8fT8fYA+uEBHswsG7Am5Wg7FHpfd9ckcqSM+1/zIl49+3VnbM6uXahh5s
         K9Vs7wwYFa7Bvts43Hw0f9IswnEYDOy44JAADOSUornbjjrXdPgIDm7EyVe4ijy0ZD3V
         VvAn/+yim3BnlHACS2MlT1qAmbzxKY7NvOUMtiKx0VSE8+f1SGpodSEMcVmBr8o7bLK0
         kOGjfbi4cCLckctqJKTv0sK6lC9iuLN8pk9nOa9c36q6M+SdWz0KIjRbRqkN7ipys845
         fbKM+zETOetfpyhYTyEKgkjH+pcvNDaKCkB7t4ao4BbbrszTk6RtGOiEFQjPk41+COqE
         PoeQ==
X-Gm-Message-State: ACrzQf3fnhVFnedFQ2BAosBEabqzbRbosO6VBNtHV2HK0yS6B6PV8GoJ
        MZAwBWSm3URb4qKiJQbVNGS8Jm0fk4O3Hg==
X-Google-Smtp-Source: AMsMyM4WKigvoVxiMMu10g2VZ2ng5TIMKMfZh/e73wzbvqLvNPoDk+tQGo8Z7ow8byi/dCkgCUpK5Q==
X-Received: by 2002:a05:6a00:bc7:b0:562:d2e5:adfd with SMTP id x7-20020a056a000bc700b00562d2e5adfdmr30000973pfu.4.1665620733630;
        Wed, 12 Oct 2022 17:25:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902d48100b00182a9c27acfsm6287423plg.227.2022.10.12.17.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 17:25:33 -0700 (PDT)
Date:   Thu, 13 Oct 2022 00:25:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 00/30] KVM: hardware enable/disable reorganize
Message-ID: <Y0da+Sj3BjYnMoh3@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series is to implement the suggestion by Sean Christopherson [1]
> to reorganize enable/disable cpu virtualization feature by replacing
> the arch-generic current enable/disable logic with PM related hooks. And
> convert kvm/x86 to use new hooks.

Thanks for putting this together, actually seeing code is super helpful!

Unfortunately, after seeing the code, I think my suggestion was a bad one.  At
the end of this series, there's a rather gross amount of duplicate code between
x86 and common KVM, and no clear line of sight to improving things.

Even if we move ARM, s390, and PPC away from the generic hooks, MIPS and RISC-V
still need the generic implementation, i.e. we'll still have duplicate code.

Rather than force arch code to implement most/all power management hooks, I think
we can achieve a similar outcome (let ARM do its own thing, turn s390 and PPC into
nops) by wrapping the hardware enable/disable (and thus PM code) in a Kconfig,
e.g. KVM_GENERIC_HARDWARE_ENABLING.

I'll throw together a rough prototype tomorrow (got partway through and then got
distracted by other stuff) and hopefully post an RFC series.

Thanks again!
