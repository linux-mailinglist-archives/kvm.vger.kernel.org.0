Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C1607E56
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 20:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiJUSfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 14:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJUSfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 14:35:10 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6FF66122
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:35:08 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id i3so3333225pfc.11
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RbVgeTtCM02kPqYNtbeyhsWp7ZqZ9UH42EzNv221eVU=;
        b=g0K9So0kuv+lWZGKTwvhP1SbKVRRXuLtb1ArR2RJYXdBTW5aCKVTxK0iF4QVJCm3Bf
         qK64Ftc6YjlDZBrzedI4YyCJEMxu2UyjXWTZB5izZLP9kUjgXWH5zfJuTKgmhl+omQTj
         mEXZBxu6FtPtC7qSwgVabW2/YrD8LywRi2k6w7MOryDz6vqsHb3lZ+HPrf6gDILUq1h3
         PQV6Y0E72RYSDWNyToJwtAa+Qo1iuaZQo9xGMDu9pb14teVljAi4n8wEjsrqyw2/a3IE
         5FPKP9b5HePpdKctATwnSN6DY7SjnorowxmRlNakfXZzTgCvL8D8LZOXgSF4/86GuyXe
         FAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbVgeTtCM02kPqYNtbeyhsWp7ZqZ9UH42EzNv221eVU=;
        b=wfG3WXiff70H7zmaXEpSulthtsQBxhq0yVSY1ct1A0jfEWGmy2MbExaoRmxC8s7L5P
         2P6dui2/YFoHXn64vJonLuMD+wzg+GxyVVkiRsXc5/F7aO0vEsIV6ySb7yHYbgfT//H2
         j/htRlm2VgMoroyujHgwX0cr972oRr4xhnDyt4TqHs/NBeOCGeo1MorT6o/zSIr2E35X
         lGZEe+zIQcouBa56xQV+wy4VCrmkNhk5JrwZguSLicclyPrNt0g4a41fXa3Z/3O853Ei
         jy9wCkmDslmJ5KJeOM8j6JR0vhiLmAmjfV2XKQrcuHrLKVqCNaGhUAVwizlxndsbCGgi
         vY2A==
X-Gm-Message-State: ACrzQf00bzrpnp6qX4v+BvUUapQeivJzfWFXBMSyDS9PlfSAxxcG20Ou
        jQjwIh/mBb+pPq/Nt3/QDnyi+g==
X-Google-Smtp-Source: AMsMyM6CFrI3TebUqw8G9APsnCJTcyJ3UhnwN87wo5TFxtbiPLBJNPKF37qhEOe3JPnCYdSoF+9UGw==
X-Received: by 2002:a05:6a00:16c4:b0:535:890:d52 with SMTP id l4-20020a056a0016c400b0053508900d52mr20707625pfc.9.1666377307899;
        Fri, 21 Oct 2022 11:35:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902c94d00b001754064ac31sm15122073pla.280.2022.10.21.11.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 11:35:07 -0700 (PDT)
Date:   Fri, 21 Oct 2022 18:35:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix the initial value of mcg_cap
Message-ID: <Y1LmWAyG7S4bgzBs@google.com>
References: <20221020031615.890400-1-xiaoyao.li@intel.com>
 <Y1FatU6Yf9n5pWB+@google.com>
 <092dc961-76f6-331a-6f91-a77a58f6732d@intel.com>
 <Y1F4AoeOhNFQnHnJ@google.com>
 <b40fd338-cb3b-b602-0059-39f775e77ad6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b40fd338-cb3b-b602-0059-39f775e77ad6@intel.com>
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

On Fri, Oct 21, 2022, Xiaoyao Li wrote:
> On 10/21/2022 12:32 AM, Sean Christopherson wrote:
> > If we really want to clean up this code, I think the correct approach would be to
> > inject #GP on all relevant MSRs if CPUID.MCA==0, e.g.
> 
> It's what I thought of as well. But I didn't find any statement in SDM of
> "Accessing Machine Check MSRs gets #GP if no CPUID.MCA"

Ugh, stupid SDM.  Really old SDMs, e.g. circa 1997, explicity state in the
CPUID.MCA entry that:

  Processor supports the MCG_CAP MSR.

But, when Intel introduced the "Architectural MSRs" section (2001 or so), the
wording was changed to be less explicit:

  The Machine Check Architecture, which provides a compatible mechanism for error
  reporting in P6 family, Pentium 4, and Intel Xeon processors, and future processors,
  is supported. The MCG_CAP MSR contains feature bits describing how many banks of
  error reporting MSRs are supported.

and the entry in the MSR index just lists P6 as the dependency:

  IA32_MCG_CAP (MCG_CAP) Global Machine Check Capability (R/O) 06_01H

So I think it's technically true that MCG_CAP is supposed to exist iff CPUID.MCA=1,
but we'd probably need an SDM change to really be able to enforce that :-(
