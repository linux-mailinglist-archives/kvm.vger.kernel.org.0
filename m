Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191CB466EF4
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 02:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhLCBLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 20:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhLCBLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 20:11:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB2DC06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 17:07:40 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so4134248pjb.1
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 17:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1FroYL/7OxigjXf/H986VZtowyDZCpHGSc16HkU3dPc=;
        b=rz5fh5PY0aD00PdMp9/+i8j6yXTNunT5aHUEvCbOFdsd9mx5+8ImHIxnYZmJg9mbS4
         6zzIRn0heO9g2mZ+cRiZXjPDyzZl3uby8VD3R8JpR+AtiMK/gwQrOIE54cfWmhB26rVU
         AjKkFknbaKGsnZVCbMmKKa0i0/ww0ApwGjNM0k15/JYXDrhdF4/alhTkB9PbCZJhrE92
         IrAcCuX1VTzzUl5kO5aMEiNJNV7tRl6z0J42G+bOw+gpwusdcxzJZUpo8K5pP8ZTwpQv
         kMSer+MiNh9Q4A3vcb2QjILn7DHigoGGrQkYAbIbCfaTz12lXRDBunqYfmCe9ftEK2yq
         Ovyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1FroYL/7OxigjXf/H986VZtowyDZCpHGSc16HkU3dPc=;
        b=uHZ5BeRPfhDRETq+S+Gw7HeN8A27K7tSYgOQlRur0McCjfK5bTUXmKteHs3EDQSH/f
         QLAy+REqcd/goADcvCGMLYI6Cwo712FVc4HCbljVBHWePcXES7iAFsH3Wn3AIhm6ixjc
         mbXn0GxANxVVoCr7DEfucbYBxA4MpSsAcaF81lOGa9lWPhkZF97YEGNeYCpwJOuuPp2q
         +e5hOE9CjaawbJpnBXZFkvGTvUxcIMKEqdJGAUqPF1T1ElM1Pf4f4iXWhQF2ASbOQiDs
         NlqpjMJgxTS6PMw4linvKUuXqftBUMY00D63Afk2wxWEqzLF2rba4pBLNGzIe56mj0He
         acDg==
X-Gm-Message-State: AOAM531CdX4aoQldz9EOanNnSo/MMkb0FJsMFHiMmloHifnYNrig/NTz
        J0WXd7H95Q7HJqMQUo0rHPnxwA==
X-Google-Smtp-Source: ABdhPJx2P0BgXBcl/jyoHG0WFB2tfN0zaRzPVXmKrggyXCkmdpZnocJKHrjqtZY26w74fqEPUYmy7w==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr9861738pjb.157.1638493659534;
        Thu, 02 Dec 2021 17:07:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nm13sm593349pjb.56.2021.12.02.17.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 17:07:38 -0800 (PST)
Date:   Fri, 3 Dec 2021 01:07:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <Yalt19BcT6pcnRX8@google.com>
References: <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
 <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
 <YabeFZxWqPAuoEtZ@xz-m1.local>
 <Yae+8Oshu9sVrrvd@google.com>
 <CALzav=c9F+f=UqBjQD9sotNC72j2Gq1Fa=cdLoz2xOjRd5hypg@mail.gmail.com>
 <YagHRESjukJoS7NQ@google.com>
 <CALzav=dDEhU3uN9CofYQqCukT3QJUm+pjRz2WTr-Ss9TNVBgLg@mail.gmail.com>
 <YakTrkA6xzD5dzyN@google.com>
 <CALzav=et40yLPOWsbx7iGjW3c8CR-88xRQ46rGU=1XDVEjVwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=et40yLPOWsbx7iGjW3c8CR-88xRQ46rGU=1XDVEjVwWA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 02, 2021, David Matlack wrote:
> On Thu, Dec 2, 2021 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > Because they're two different things.  Lock contention is already handled by
> > tdp_mmu_iter_cond_resched().  If mmu_lock is not contended, holding it for a long
> > duration is a complete non-issue.
> 
> So I think you are positing that disabling reclaim will make the
> allocations fast enough that the time between
> tdp_mmu_iter_cond_resched checks will be acceptable.

Yep.

> Is there really no risk of long tail latency in kmem_cache_alloc() or
> __get_free_page()? Even if it's rare, they will be common at scale.

If there is a potentially long latency in __get_free_page(), then we're hosed no
matter what because per alloc_pages(), it's allowed in any context, including NMI,
IRQ, and Soft-IRQ.  I've no idea how often those contexts allocate, but I assume
it's not _that_ rare given the amount of stuff that networking does in Soft-IRQ
context, e.g. see the stack trace from commit 2620fe268e80, the use of PF_MEMALLOC,
the use of GFP_ATOMIC in napi_alloc_skb, etc...  Anb it's not just direct
allocations, e.g. anything that uses a radix tree or XArray will potentially
trigger allocation on insertion.

But I would be very, very surprised if alloc_pages() without GFP_DIRECT_RECLAIM
has a long tail latency, otherwise allocating from any atomic context would be
doomed.

> This is why I'm being so hesitant, and prefer to avoid the problem
> entirely by doing all allocations outside the lock. But I'm honestly
> more than happy to be convinced otherwise and go with your approach.
