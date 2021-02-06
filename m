Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3111E31188B
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 03:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhBFCk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 21:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhBFCh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 21:37:58 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE39FC08EE27
        for <kvm@vger.kernel.org>; Fri,  5 Feb 2021 16:27:04 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d26so4171618pfn.5
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 16:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EH3HRE/ibAwzd4o+wOpnfLPBD+oAmovzGutqmDQDCIg=;
        b=lc8Qw0kNFzTtqe6BIDMx231cY0gFUoT9MZSiM+wnbBFQlaHgTDDk6kcV1GHTXnJhQo
         KBTF79P9Zaax+amNTdEv9MGPTyOugyxRV0Q5NFBKrlcvwJfktwrS/ldssoNeQgbimTEA
         jA6mRYrrznUQS/0osskEWOnkfXEy1vzRAHwS33kbFdujVkNmnu95KK/k/AVVIkNXrjzr
         7xdyMk4EWNbkJbmrEbEFIZOGYEareyNfyJjDKkJVqqPAmKpZEoCiVh5gsY1Jy/k/f6i+
         81AwnITy97MEdorNUdiRVxCQ7RNaQ47ohBhgoZSqaiA7tfwJsxTRld5l7EjscB4Qa6EB
         nuSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EH3HRE/ibAwzd4o+wOpnfLPBD+oAmovzGutqmDQDCIg=;
        b=ZB6Vh/++b5D2krMRlMN+95zSPBfAnj4K2Xxx9MOE6/0QCNVPWUBmanIvFcYFri23ku
         vyd044kQKmHJk7bmUFkBtX6H8iKKMD0BQAzDeAE13YU0AvAYLYp8LrRV7c4+/rgVv59n
         /uwdOX8vhVpfuUw/FaEZa7DulhCbVpH0/BY+H5pT53IYam+LbZXJf+yLdA5zqBzS3jJ5
         RfLFaTBr78pDhSNzF9IE+LiGYYVQK2d8MGWd6lLxfPxzTDvULVBnH9ql7OvfemmiHJ+X
         lBWK3qU+X8hSX7STLkELe9Sf0boZRQVDs8pWcxngSrMMYUgEr9ZX/jL/9OmfHzXIpWxp
         Ok9w==
X-Gm-Message-State: AOAM533XyOHbH2EBk/SAcu2P3DTqERVlVADX8I1hT/f1ZjqMr6l9IThs
        dExtvh4tGP4iu3J7ZXjakDKybA==
X-Google-Smtp-Source: ABdhPJwFPakzZi7F4YXbdMIn58tmOenc4WF1friZt/+b0HiEN1gqMvgZgMvx8X1RrcdLO6JKGXn7qw==
X-Received: by 2002:aa7:92c6:0:b029:1cb:1c6f:c605 with SMTP id k6-20020aa792c60000b02901cb1c6fc605mr7100209pfa.4.1612571224287;
        Fri, 05 Feb 2021 16:27:04 -0800 (PST)
Received: from google.com ([2620:15c:f:10:d169:a9f7:513:e5])
        by smtp.gmail.com with ESMTPSA id t6sm10993068pfe.177.2021.02.05.16.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:27:03 -0800 (PST)
Date:   Fri, 5 Feb 2021 16:26:57 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 20/28] KVM: x86/mmu: Use atomic ops to set SPTEs in
 TDP MMU map
Message-ID: <YB3iUde728MPiuo9@google.com>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-21-bgardon@google.com>
 <81f13e36-b2f9-a4bc-ab8e-75cedb88bbb1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81f13e36-b2f9-a4bc-ab8e-75cedb88bbb1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Paolo Bonzini wrote:
> On 02/02/21 19:57, Ben Gardon wrote:
> > To prepare for handling page faults in parallel, change the TDP MMU
> > page fault handler to use atomic operations to set SPTEs so that changes
> > are not lost if multiple threads attempt to modify the same SPTE.
> > 
> > Reviewed-by: Peter Feiner <pfeiner@google.com>
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > 
> > ---
> > 
> > v1 -> v2
> > - Rename "atomic" arg to "shared" in multiple functions
> > - Merged the commit that protects the lists of TDP MMU pages with a new
> >    lock
> > - Merged the commits to add an atomic option for setting SPTEs and to
> >    use that option in the TDP MMU page fault handler
> 
> I'll look at the kernel test robot report if nobody beats me to it.

It's just a vanilla i386 compilation issue, the xchg() is on an 8-byte value.

We could fudge around it via #ifdef around the xchg().  Making all of tdp_mmu.c
x86-64 only would be nice to avoid future annoyance, though the number of stubs
required would be painful...
