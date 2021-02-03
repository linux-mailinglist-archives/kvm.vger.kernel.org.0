Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D481330E76A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhBCXdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhBCXdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 18:33:44 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9F2C061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 15:33:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z9so638652pjl.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 15:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FpbgW7rtmmjCscKdb8waMS+fqmFonfo2h3bIyix3u8k=;
        b=HseEMzGwBjHS63hjA97s5FrMFHD49OI7KZPGOrs1GtGF0cPZBTiR66Lg19Zt12L+FF
         V2O3SpOfg2ottdMeRQXBdO6nOaka/q8HpK1lP8BHDOhaQ+bNSoY+YzXJqlBhEnL8OMts
         9zCZx48hM/y/eyNi8C2k6sPonwuXBRfYpgpVYXUIbyjiqgU+HFviQ5sXIfz6wc5tlI0U
         bNipc+b02aabH1RdA8QGiOI3qHOQaDQZ7RsOWZGV856Rw/Ae+VqGHhWo9f10T9DYD2xj
         SMAbn5o7+z2FibC8xa4X/jRML9/Aj2EClLlGyMEUV1MygjJiv3LXaJnzdUQLEjUMv2ub
         sGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FpbgW7rtmmjCscKdb8waMS+fqmFonfo2h3bIyix3u8k=;
        b=HXqWIg7G7ukNfjmR4GnAw0DpGx0lcfc/wjkGk1LAFfW2Mc/wMrAKWTKv/m4Dmr1Zgk
         7BodAeF1wbbiRgBKZQYvxd6kwYi3GHmTGe984hQJwUbyvXU63JAXn4TeTjNYlRiD2DSN
         MW+vr8qNRVbpp27J+CbVsNCSgzEcGxygJpkDDjvsKIlLIFt4wPIRiMw2r7LbBm57RGH2
         UlRC7SNs+UAXJr404VmUJb3f1jK4Lu/dO20rOPpbsfm8JES913B8oHaPjxbpXoHdOW2j
         5yxFe3mo9redK4g3YnQSk6Hz0jPpVBK69L7iXoAcnWAtPFjGlvyopSzASThNS0NSILxT
         VNkg==
X-Gm-Message-State: AOAM530btlJIQBkPfJ7HdqQ4tmTdbq/TJfosdRZQZt527gJE9q4xIn1H
        IhcBCM7M59asmR0EtQ5rwAD0QA==
X-Google-Smtp-Source: ABdhPJxTt0ohgIKYmq5hgmBxJWbTXdf6Kzz4ZYjcKi/ColjjVbo9TrXxQ8jTBI4gpRuuHuyxAyTDpQ==
X-Received: by 2002:a17:90a:fc4:: with SMTP id 62mr5523521pjz.181.1612395183887;
        Wed, 03 Feb 2021 15:33:03 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id y21sm3474132pfp.208.2021.02.03.15.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:33:03 -0800 (PST)
Date:   Wed, 3 Feb 2021 15:32:56 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Message-ID: <YBsyqLHPtYOpqeW4@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
 <YBnTPmbPCAUS6XNl@google.com>
 <99135352-8e10-fe81-f0dc-8d552d73e3d3@intel.com>
 <YBnmow4e8WUkRl2H@google.com>
 <f50ac476-71f2-60d4-5008-672365f4d554@intel.com>
 <YBrfF0XQvzQf9PhR@google.com>
 <475c5f8b-efb7-629d-b8d2-2916ee150e4f@redhat.com>
 <c827fed1-d7af-a94a-b69e-114d4a2ec988@intel.com>
 <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d044ccde68171dc319d77917c8ab9f83e9a98645.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Kai Huang wrote:
> On Wed, 2021-02-03 at 09:46 -0800, Dave Hansen wrote:
> > On 2/3/21 9:43 AM, Paolo Bonzini wrote:
> > > On 03/02/21 18:36, Sean Christopherson wrote:
> > > > I'm not at all opposed to preventing KVM from accessing EPC, but I
> > > > really don't want to add a special check in KVM to avoid reading EPC.
> > > > KVM generally isn't aware of physical backings, and the relevant KVM
> > > > code is shared between all architectures.
> > > 
> > > Yeah, special casing KVM is almost always the wrong thing to do.
> > > Anything that KVM can do, other subsystems will do as well.
> > 
> > Agreed.  Thwarting ioremap itself seems like the right way to go.
> 
> This sounds irrelevant to KVM SGX, thus I won't include it to KVM SGX series.

I would say it's relevant, but a pre-existing bug.  Same net effect on what's
needed for this series..

I say it's a pre-existing bug, because I'm pretty sure KVM can be coerced into
accessing the EPC by handing KVM a memslot that's backed by an enclave that was
created by host userspace (via /dev/sgx_enclave).
