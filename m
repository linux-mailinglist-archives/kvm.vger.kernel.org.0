Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ADB372FA0
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhEDSSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 14:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhEDSSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 14:18:07 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E198C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 11:17:11 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e15so8679909pfv.10
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 11:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=14b7XgnhSuRkX7Ox309zfy7AdpkEzaYxX119We4gjnY=;
        b=pLnD59w1zG5K84HrnD/SSxkOwRZPxyLv242DpXFHJly55QqhlDdJ1PMllReMOfJEmL
         cba5bErynjsfVQV6HO8F1MhNdxTkmmo8nMu2NgBzyeL1zC8ZWZIBfAd+62Qwfb2M/c5k
         bE/4Bcg8gRCNChwxM4cEKidlL2aDXh2DLgsPnvm9W6O2yQddakyBBnJDBdVz659B10YJ
         Y0tux2aKSJbJci8XBo9GE4+v2tw45KC46kodx/ZaH6SqTbpYk9gSBLU/T577ODC0Hddq
         ThpeqdJELRHjEVO4sDs3PLOTkilWJmdoxF09ZTutJoHlgV+As8IGt6e5MGZB54R9Ml3P
         bTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=14b7XgnhSuRkX7Ox309zfy7AdpkEzaYxX119We4gjnY=;
        b=hfbw9AJP5yDT822HjZHGlxPnyx89fHV8LVB+QZzcETnchYIfcKEEp4M4CcqwwzGesM
         LKTvgfcodITJHrp72Qsnem58ae6BZ49yoZ5x9u1lcnkiCP48NBlxGV3rlZqZ3uvd3xm+
         PfWauyRQiEPo9osn12yCG0jSYiC9gYJBQ6v/bvidNtOVKMyAtj9v22oMxtyTr4FhgYb7
         1YXmLXjranT+ybGA5X6YeulY9qA/VVgY3WlK12eASu36fHevGHtYVcLn5PxiVx59m6x4
         LyKUKDSvEzWPmdS7bvyMfWHdISGLqkVfwowC02PfcPKvhRocdhPCcwxpRCtpqC/+jn2j
         F3AQ==
X-Gm-Message-State: AOAM533NthdzZhOfviyd20nGBEhYmgvmo1lcNP4R8mHVuUga6g4UwBW/
        nICvzV2oRyvobJqLbp+8o0rw1Q==
X-Google-Smtp-Source: ABdhPJxfvDZm5IlG3fikLP6ejiZTWjCh5Zo2BWDsG6bH3EAtMHHvBGctDXw3Rng1YEbtrLvZBr6NOw==
X-Received: by 2002:a17:90a:55c5:: with SMTP id o5mr6051105pjm.169.1620152230643;
        Tue, 04 May 2021 11:17:10 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k14sm15051948pjg.0.2021.05.04.11.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:17:09 -0700 (PDT)
Date:   Tue, 4 May 2021 18:17:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 0/7] Lazily allocate memslot rmaps
Message-ID: <YJGPotr2X9fHAQqq@google.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <a3279647-fb30-4033-2a9d-75d473bd8f8e@redhat.com>
 <CANgfPd-fD33hJkQP_MVb2a4CadKQbkpwwtP9r5rMrC_Mripeqg@mail.gmail.com>
 <4d27e9d6-42db-3aa1-053a-552e1643f46d@redhat.com>
 <CANgfPd_EvGg2N19HJs0nEq_rbaDJQQ9cUWS9wEsJ5wajNW_s7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_EvGg2N19HJs0nEq_rbaDJQQ9cUWS9wEsJ5wajNW_s7Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021, Ben Gardon wrote:
> On Tue, May 4, 2021 at 12:21 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 03/05/21 19:31, Ben Gardon wrote:
> > > On Mon, May 3, 2021 at 6:45 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >>
> > >> On 29/04/21 23:18, Ben Gardon wrote:
> > >>> This series enables KVM to save memory when using the TDP MMU by waiting
> > >>> to allocate memslot rmaps until they are needed. To do this, KVM tracks
> > >>> whether or not a shadow root has been allocated. In order to get away
> > >>> with not allocating the rmaps, KVM must also be sure to skip operations
> > >>> which iterate over the rmaps. If the TDP MMU is in use and we have not
> > >>> allocated a shadow root, these operations would essentially be op-ops
> > >>> anyway. Skipping the rmap operations has a secondary benefit of avoiding
> > >>> acquiring the MMU lock in write mode in many cases, substantially
> > >>> reducing MMU lock contention.
> > >>>
> > >>> This series was tested on an Intel Skylake machine. With the TDP MMU off
> > >>> and on, this introduced no new failures on kvm-unit-tests or KVM selftests.
> > >>
> > >> Thanks, I only reported some technicalities in the ordering of loads
> > >> (which matter since the loads happen with SRCU protection only).  Apart
> > >> from this, this looks fine!
> > >
> > > Awesome to hear, thank you for the reviews. Should I send a v3
> > > addressing those comments, or did you already make those changes when
> > > applying to your tree?
> >
> > No, I didn't (I wanted some oversight, and this is 5.14 stuff anyway).
> 
> Ah, okay I'll send out a v3 soon, discussion on the other patches settles.

I'll look through v2 this afternoon, now that I've mostly dug myself out of
RDPID hell.
