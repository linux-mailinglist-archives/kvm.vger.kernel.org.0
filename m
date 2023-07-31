Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0F76A426
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjGaW3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGaW3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 18:29:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCFAEC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 15:29:04 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso3779364a12.1
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 15:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690842544; x=1691447344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ2LktP96v4dfRE8Vwz3CbzB0RzxRif3DX7AM2KfeLU=;
        b=W5Y/ZFO8fcDmdLpJ87+PfI5fOmpc9vEwXzyecBfLbCyZ0GTM8w90J+3zAzdpy6NJz7
         oN75grQ8eQDlRNXh9m0FTorlSFzI02DfJXMBs6hCwfOOPf1uibjhip1NDYHp2c+VaZrL
         Kww8XaqG/kSwDmcjbe//sAJ6As/LvmM7RqnYitr3QxxIAxvCtbZsksmiCzbKAlErBl5K
         842P4ApJ1ZtrFKthlx9CGhxRDI3Is4wJDpo6xtaG/OXydEHZQjVOem8BQc4b/XqjtChc
         69KezMVWzShyQzD07638xV5dcSLgLLH8IxOyNDvTi6yNRWD7hUlknbb7Lz54Pq0X8u5z
         eFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690842544; x=1691447344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZ2LktP96v4dfRE8Vwz3CbzB0RzxRif3DX7AM2KfeLU=;
        b=MCuVIKMvZ1JDqRVxv8Fl+wtlUqIWxEs4D5LeW+9lvJa1hoFeDRtBCfJvwy3Hu+Ks1J
         0KWkjw9YoRcIu1GZhj6r34WyW3U0oP76mGHNBlRfFlFMYdEHcimXji7CgLj6TfSX+4DN
         2lJLu4snRF3TKvykWQ47x70JJrO6ctr2TabOij302PMpffuHn4IsBiY8ziSSBuO1a7FR
         rgWgQyBkPW4Ii2dDUOYmR7fgLxBCqbpxiS33zzZgy6+T1TcqhzXhHL+t35+U2x5GUkKZ
         Uc+vHuujzFD6RCLtsd8HI3XZagv3HVm+MIcYlMwmCBr0JlqOZmGGVNm/0xwOD0piQKxt
         J4Cg==
X-Gm-Message-State: ABy/qLb4IinaSV+JOlxUsQtOjEGVkM0ZglHk22pT+KbEe2mcFrvVgWP8
        83EnYZTajpuACPNLSjhlkkRK/g==
X-Google-Smtp-Source: APBJJlEUVR4VzSj0cl+vQ2Tn5yIlGKmK3ZbTpxqa/RsOvz61oB7ESg7499A8aoE+8LjqoQ/Hs4qsdA==
X-Received: by 2002:a17:90a:a683:b0:268:6339:318 with SMTP id d3-20020a17090aa68300b0026863390318mr10058262pjq.30.1690842543576;
        Mon, 31 Jul 2023 15:29:03 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id a15-20020a17090a70cf00b00267fbd521dbsm8239085pjm.5.2023.07.31.15.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 15:29:03 -0700 (PDT)
Date:   Mon, 31 Jul 2023 22:28:59 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Xu Yilun <yilun.xu@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v2 6/6] KVM: Documentation: Add the missing description
 for tdp_mmu_page into kvm_mmu_page
Message-ID: <ZMg1q59MV7/iQayd@google.com>
References: <20230626182016.4127366-1-mizhang@google.com>
 <20230626182016.4127366-7-mizhang@google.com>
 <ZJsLV+urA0Yrw6Wn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJsLV+urA0Yrw6Wn@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Mingwei Zhang wrote:
> > Add the description for tdp_mmu_page into kvm_mmu_page description.
> > tdp_mmu_page is a field to differentiate shadow pages from TDP MMU and
> > non-TDP MMU. When TDP MMU is enabled, sp->tdp_mmu_page=1 indicates a shadow
> > page for L1, while sp->tdp_mmu_page=0 indicates a shadow page for an L2.
> > When TDP MMU is disabled, sp->tdp_mmu_page is always 0. So update the doc
> > to reflect the information.
> > 
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  Documentation/virt/kvm/x86/mmu.rst | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/x86/mmu.rst b/Documentation/virt/kvm/x86/mmu.rst
> > index cc4bd190c93d..678dc0260a54 100644
> > --- a/Documentation/virt/kvm/x86/mmu.rst
> > +++ b/Documentation/virt/kvm/x86/mmu.rst
> > @@ -278,6 +278,8 @@ Shadow pages contain the following information:
> >      since the last time the page table was actually used; if emulation
> >      is triggered too frequently on this page, KVM will unmap the page
> >      to avoid emulation in the future.
> > +  tdp_mmu_page:
> > +    Is 1 if the shadow page is a TDP MMU page.
> 
> Maybe add a short blurb explaining that it's used for control flow when starting
> from a common entry point?  E.g. walking page tables given a root, and walking
> lists that can hold both shadow MMU and TDP MMU pages.

will do. Thanks.
