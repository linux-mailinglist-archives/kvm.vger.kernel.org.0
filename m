Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26D85FCCCB
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 23:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJLVKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 17:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJLVKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 17:10:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB0F5E64C
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 14:10:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d24so35090pls.4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 14:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjaTEfJW5Bp0cQ1SgqTjNeIGFXK/pZcyrdaMaR+Pa9k=;
        b=VL2awohoutj1yH/bSjK02iCcRXB1F+Uyl/PBoTnn92KaWqwAjytTQXjB0yJFTij60T
         CE9SdcPfR/FgTAJ3lf5kHS4GOp9EUfcwk0ekcdwOxYkJJfzaV+q9SvS00M1cripbMq6J
         K+QfHkx2H07aCvO2qwT3caw3ME5HN+rTUN8x0p5sAIfdtmLpyUy8DlfHP9DDB5NO7P0Z
         ahxQxYFUdIK1kS1/K7Quz5P1/3DcOJtaHNGhBVyKgrOdPfb0rR1Vsxty96tFPnKgsShj
         SsmspqcD7OCL4c+k6C6GZG0FsHr+nJvAhnCeFmvachLNmC+8ISwHICBa6DMzbxIhZjsd
         2ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjaTEfJW5Bp0cQ1SgqTjNeIGFXK/pZcyrdaMaR+Pa9k=;
        b=lIqv34kE0pmZqEbbPpTQDFKx2SGm8zBVsoAu448bFQ2+AyVEUjqxC6ePhiAbhQKLkv
         6tvA2kQEX5mwBGtzoHQjbLzuh150+0aLVs3c6vCubZ2RTeeGovEYgcwcjFb9qIMxrhMm
         2DbZOipkqoWOTKp/0zKOhbN7r6uxrPiCMA6nSZmbvHHqtkyV5tF3/KQfh2mu7fMDwS1w
         m9nsaF7RlGbzkkwXdYREjHHR//wVXpPP1f/N4SHN948r1DWXxsDhxrzSVfjevIzksFXr
         KEzVIB8qbHRLnTCu7k25GnPgunIy4GaHQV/fXZF7rcB8BEnG5oo5hFLg9whXKxM7krEQ
         SPFQ==
X-Gm-Message-State: ACrzQf32RmZ+gtBd+KREqGkRoHYKWhchjaAjc9eO3Le8Kq0wQ5hTfjCk
        AZ6HG5SKr0nRZ3HR7BoKYXAIuCPiko1viQ==
X-Google-Smtp-Source: AMsMyM442BMSD5mIJngvPBzBEq79NZQgzFi1rf7LeT0pHARAlXsrIPhEuYTeCKZHlFZzLVEQX9nrDA==
X-Received: by 2002:a17:903:244c:b0:183:afb6:e803 with SMTP id l12-20020a170903244c00b00183afb6e803mr10356683pls.164.1665609006386;
        Wed, 12 Oct 2022 14:10:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h19-20020aa796d3000000b0056126b79072sm337513pfq.21.2022.10.12.14.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 14:10:05 -0700 (PDT)
Date:   Wed, 12 Oct 2022 21:10:02 +0000
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
Subject: Re: [PATCH v5 17/30] KVM: Move out KVM arch PM hooks and hardware
 enable/disable logic
Message-ID: <Y0ctKrMAmX8WvWRA@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <245445b7326fb86cdae11ad2709d5f3dac3c9e53.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <245445b7326fb86cdae11ad2709d5f3dac3c9e53.1663869838.git.isaku.yamahata@intel.com>
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

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To make clear that those files are default implementation

Heh, this is debatable, I was quite confused/surprised by seeing kvm_arch.c.  It's
also incomplete, which is further confusing, since there are a lot of default hooks
that are left behind.  And we most definitely don't want to move all of them, since
many of those hooks are pure nops, i.e. get completely compiled out.

Given that we want this code to go away sooner than later, I don't think adding
a temporarily to-be-deleted file makes sense.
