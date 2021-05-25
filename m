Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB6C38F692
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhEYACj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhEYACe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 20:02:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CEC061574
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:01:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 27so20000143pgy.3
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1oIG+9BASGpsf3Bf/dJPV1Xs0ktBXU7PyErfIXd1OBU=;
        b=XhDYLFBSj77yLVK2AEnggOwigL5hVenSiwlLh7FS77nesW0zcpqk3g/75KJaRn1WnE
         KHxilb8GkQrRO29jTTK8XQVvjNuddAR9c+W2bRXqAjGoNxayvIR/RydJv5jYZNC9MP2U
         ocMJ0j9Umd9AHls+vzSLNt4svGMDqo8q6dJy7PlCWO64kXkV88eQYro4MBxe4yzKvYru
         kQ64hORTTt+RBhPgfURON+3EiZhwJ0Clqf/teSS6FJVZGfmeA1nzB8Qauzz5/xQiFWly
         F45VzoIJ2rBPmdB1FdSFl5PKvwxDEI6KDkpzR++nMoSGuC/l5lb7ONUYK/P6sFjMCeKN
         Bt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1oIG+9BASGpsf3Bf/dJPV1Xs0ktBXU7PyErfIXd1OBU=;
        b=Zt+s8M6QrdNHWb2cHnbKod75H+A9UbISVwroOl5lVvnYxlh0ZWk7+dBMRj+sfLC4V8
         6FcIVbrqXlqHU2q9dOhP26WemU/wZdbKPns/LPhsk44RXbKPlvAY2/FA87Dr/hoNh/Uc
         3OGuasT5glib0CcLz1cs6CCsIL8jC/52swqsTNMc0Zsi+cSB9QCwl9QZdDT+o8baUMJE
         xqE+dUa585N4fxZ0eCJ3e/gpNoyigiRF5MdYrQX8XgY8XxwsObCfBPopztjACGZuED7C
         +KVJGO+83ptbLosN/CzEYziR/W40LzzykEgUbcCEmW2FvCYm2be3golxb97M165LsKEW
         V+Qg==
X-Gm-Message-State: AOAM533mgbZBRBtEP3CSkEe0n7detv+g6KBn1CSJ7+BvR3FZWgHOOuqT
        5iI6m5zLGjvqSrzmBI1+3G3/LQ==
X-Google-Smtp-Source: ABdhPJzwVmNSVpudD1GEVWwFUKdQSqbt6qSZwM5S8ejlHDA4eAgaLxQEEkFIzBsmXYbPXSEsRN+saw==
X-Received: by 2002:aa7:9533:0:b029:2de:3b90:57a7 with SMTP id c19-20020aa795330000b02902de3b9057a7mr27227236pfp.15.1621900862027;
        Mon, 24 May 2021 17:01:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a26sm11843722pff.149.2021.05.24.17.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 17:01:01 -0700 (PDT)
Date:   Tue, 25 May 2021 00:00:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Orr <marcorr@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [kvm PATCH v6 0/2] shrink vcpu_vmx down to order 2
Message-ID: <YKw+OenKB/X0amvm@google.com>
References: <20181031234928.144206-1-marcorr@google.com>
 <CALMp9eT-tKmt2nFy4eQ0bfLqHrZd9EruQ45p=AsR2aPWnj97gA@mail.gmail.com>
 <34bf7026-4f83-067e-f3d8-aad76f9cf624@redhat.com>
 <YKwsRhDWi3LZNSai@google.com>
 <CALMp9eQsTBp8D_Vtv4CFPzhb+QODDHjTH2aG8s-YSM_cgCEtVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQsTBp8D_Vtv4CFPzhb+QODDHjTH2aG8s-YSM_cgCEtVQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 24, 2021, Jim Mattson wrote:
> On Mon, May 24, 2021 at 3:44 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 24, 2021, Paolo Bonzini wrote:
> > > On 21/05/21 22:58, Jim Mattson wrote:
> > > > On Wed, Oct 31, 2018 at 4:49 PM Marc Orr <marcorr@google.com> wrote:
> > > > >
> > > > > Compared to the last version, I've:
> > > > > (1) dropped the vmalloc patches
> > > > > (2) updated the kmem cache for the guest_fpu field in the kvm_vcpu_arch
> > > > >      struct to be sized according to fpu_kernel_xstate_size
> > > > > (3) Added minimum FPU checks in KVM's x86 init logic to avoid memory
> > > > >      corruption issues.
> > > > >
> > > > > Marc Orr (2):
> > > > >    kvm: x86: Use task structs fpu field for user
> > > > >    kvm: x86: Dynamically allocate guest_fpu
> > > > >
> > > > >   arch/x86/include/asm/kvm_host.h | 10 +++---
> > > > >   arch/x86/kvm/svm.c              | 10 ++++++
> > > > >   arch/x86/kvm/vmx.c              | 10 ++++++
> > > > >   arch/x86/kvm/x86.c              | 55 ++++++++++++++++++++++++---------
> > > > >   4 files changed, 65 insertions(+), 20 deletions(-)
> > > > >
> > > > > --
> > > >
> > > > Whatever happened to this series?
> > >
> > > There was a question about the usage of kmem_cache_create_usercopy, and a v7
> > > was never sent.
> >
> > What's that go to do with anything? :-D
> >
> >   b666a4b69739 ("kvm: x86: Dynamically allocate guest_fpu")
> >   240c35a3783a ("kvm: x86: Use task structs fpu field for user")
> 
> So, that's what the series was trimmed down to. Thanks!
> 
> Did we still manage to get down to order 2?

Yep, almost made it to order-1!

Current size (without 8 bytes from CONFIG_HYPERV=y) is 9728.
