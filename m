Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA043C7798
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 21:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbhGMUCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhGMUCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:02:24 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31799C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:59:34 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id w15so22511800pgk.13
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 12:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9SPgIXBvjkfAbqOot3l6wN5sOGVWN6nhha+7R377UfE=;
        b=JQhqPF7//EXTXCduetcHMVlJhMLHgrbGPjeudiWjYHkiAsdbjzsH05Vm9vIaGTvCUI
         vfik0jHFgmmWlnBBem0oUT0VXvXjOBJfKypI5DIyDFZOqHIXDC09rs9Jx/eZ+uMIC2wn
         27ZzlL6Dfe+IS0bfEMfO3RvmZfhgd2awr8Y61oMacP97e6DxHKxKC1qMLJuqsQkIiF7H
         P9Fws229mOuxA4IhDexwpR60/WFDwlNJ76IFEbacXcwul6NHM4gVJjJCRyD7LL0029Z4
         121ZCDtdiYpX0tzKjXKFMSpMiaEw/u5XqqHwXo15SD1F1uqS2FD+/v4cl5eX9Kq9TXpp
         1R+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9SPgIXBvjkfAbqOot3l6wN5sOGVWN6nhha+7R377UfE=;
        b=BStw6P3kH0lzWGippcStsW4H7ZjGwFlZ0+mkuWtfsQ61Ru8CWoeUbR53VaBnZYaefs
         +vOybycfz9BndLTFMyDcQkuNyX9B7I0wzjqtGmxDGLiBD8BjJ09r8X+CzDXCnxA9GuDa
         93tQ6YIezEdvS9e9VVoZwS0B4190dthPmjOYXRnTOAJT5c45VSBojVApe3ceLZKShvoM
         WeVQug2g+Ygan4exIiQZ8jKOnOr9qzltmXB0BxPFLUlhVk+oNFwndFODigxlo6pHBrR9
         OOlmk802ZxXHIJK9eruTh6xCzluFlVNmCPsoYNtif/0p0FYQF57G7Z1LGqinXE+SV8py
         T3sw==
X-Gm-Message-State: AOAM530LSKIrE8Zq6JAxuewhglrPzJT0ZDlvBGdENJtyC25sKSxXRsuW
        MQ0H78QKhSW4/jIdPSC6jOfJcQ==
X-Google-Smtp-Source: ABdhPJxMglAaACW1oWqveOVZakLQI9MwJUjxgo3hoJTXj52HjMNPmQWHTYs9OEyDUNmvsCKGkgesJg==
X-Received: by 2002:a65:6658:: with SMTP id z24mr5794920pgv.266.1626206373599;
        Tue, 13 Jul 2021 12:59:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x19sm20234905pfa.104.2021.07.13.12.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 12:59:33 -0700 (PDT)
Date:   Tue, 13 Jul 2021 19:59:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v2 09/69] KVM: TDX: Add C wrapper functions for TDX
 SEAMCALLs
Message-ID: <YO3wobKNmi/o8aSo@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <96e4e50feee62f476f2dcf170d20f9267c7d7d6a.1625186503.git.isaku.yamahata@intel.com>
 <597dcaf4-19c0-3507-ebfa-e07cb32f784c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <597dcaf4-19c0-3507-ebfa-e07cb32f784c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> > +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> > +{
> > +	return seamcall(TDH_MNG_ADDCX, addr, tdr, 0, 0, 0, NULL);
> > +}
> > +
> 
> Since you have wrappers anyway, I don't like having an extra macro level
> just to remove the SEAMCALL_ prefix.  It messes up editors that look up the
> symbols.

True.  On the other hand, prefixing SEAMCALL_ over and over is tedious and adds
a lot of noise.  What if we drop SEAMCALL_ from the #defines?  The prefix made
sense when there was no additional namespace, e.g. instead of having a bare
TDCREATE, but that's mostly a non-issue now that all the SEAMCALLs are namespaced
with TDH_.
