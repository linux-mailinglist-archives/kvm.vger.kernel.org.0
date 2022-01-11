Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DC748B203
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 17:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349935AbiAKQXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 11:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243864AbiAKQXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 11:23:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554A6C06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:23:20 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id hv15so12047976pjb.5
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 08:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nkLRpbKby3eggFnq2ckBUr+cWYQE3aUaRvpDEEdeddI=;
        b=rXF1bsZl1FSWkz+Ytg6Yh2n77l2hvZE+TP6QErcGfWQQq8xLAtyEXA2ZkLLMFjkTsi
         jo1Z3NidnhYZFtovXBVeQ4ewwZGvGif6MO1AHzJvnJWaaQ//WxUGdjPWfJ1m/vxXJWPP
         rDfdXJaEKipVbLriY1V/J39rgzgdfrIVgUgzlJ3paTp5nC7lPW2v9la3KrDDFf+0mcH1
         iYkRA5bTnN7gGeRGUkes4L8Ju5PmKzA+jsmvp7WvAml9uTPJkv07pSLi1erR0B17hUd7
         P0GdUtddJYceD2gUZub/DCtEsh71zs5T/n1AMG+nHL9GeYcW98UtDSeWKkxk8qxrKwO9
         7Fzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nkLRpbKby3eggFnq2ckBUr+cWYQE3aUaRvpDEEdeddI=;
        b=oRip8i4SjznghcG9/N4MsmAhemGdSiG4E4eZou/RYW0tQZ6d4xXVA4PyUI9P3yk3p9
         lDTd21Ct94vwraVjjLVPcpU96hzMJT2BYJK+S73U9mSu3qY9wlOkCUC1jhd4VqcBBmsM
         f3YgvvxiG0l1/mauatf1Esabr8ptG9ZT4SsnrY5KNLB8JrBv9Nro+jR+6tk5otDvb8TV
         Usm0hbLx48vGfQ9VqCHOcV/Rpp9dfvAF8/HjOYFGPXtq7CxrYxUIaJwWq74KMo847IWx
         g1W8PUF5bC3OMogi33yP3ExR6RsKXLK6KKw2VQMjlOABjRVbQU3NIzopIwN5ml2eQPRU
         aMyg==
X-Gm-Message-State: AOAM5316HBmNFT4fRt5oFfcQhOreUT6y4kKnX3eonA0ssTmabSeyziB/
        gHIBWAlCxVbgZh+2UYr6c/oOdQ==
X-Google-Smtp-Source: ABdhPJzJwLLOQwbttHinaExQUkb1diQ35QUrMzTcLE4ClFRytwfRl2mEUKYKQvSPFmzw5xmOOB6VAQ==
X-Received: by 2002:a17:903:191:b0:14a:59cb:3199 with SMTP id z17-20020a170903019100b0014a59cb3199mr2373718plg.139.1641918199671;
        Tue, 11 Jan 2022 08:23:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n5sm7660296pfo.39.2022.01.11.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 08:23:19 -0800 (PST)
Date:   Tue, 11 Jan 2022 16:23:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Assign a canonical address before
 execute invpcid
Message-ID: <Yd2u8rb2Z7yeFTBV@google.com>
References: <20211230101452.380581-1-zhenzhong.duan@intel.com>
 <Yc3VryxgJbXXwyy3@google.com>
 <Yc3xVIo8x+4DtQwx@google.com>
 <BN6PR11MB0003E1AD91178BA8CD226D1392519@BN6PR11MB0003.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB0003E1AD91178BA8CD226D1392519@BN6PR11MB0003.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022, Duan, Zhenzhong wrote:
> >From: Sean Christopherson <seanjc@google.com>
> >I take that back, "struct invpcid_desc" is the one that's "wrong".  Again,
> >doesn't truly matter as attempting to build on 32-bit would fail due to the
> >bitfield values exceeding the storage capacity of an unsigned long.  But to be
> >pedantic, maybe this?
> 
> Sorry for late response. Not clear why the mail went into junk box automatically.

No worries, I know that pain all too well.

> Yea, I think your change is better. Will you send formal patch with your change
> or you want me to do that?

No preference.  If you get to it, great, if not I'll send a patch in a day or two.
