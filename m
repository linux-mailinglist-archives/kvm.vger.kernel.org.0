Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E41D5EFF57
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 23:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiI2VjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 17:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiI2VjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 17:39:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0BB11C15B
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 14:39:12 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cv6so2511086pjb.5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 14:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=3hQ7SGJEZlP1CEol/y6HCHbPMZs8/OdDFKjhXRwDL+E=;
        b=M5/tVjQIq53b8YbF4ge3X+SW7LFZCESqkl8vgJeLLOS3bQwej53zv2h+Iu9lPMtJIB
         EAD0WMFdwHk/Bq26B6hXTuHMW3S5Po3n8ZmcO2vTs8NAFmERV9+z9GKJ1SYmdDwVAkF2
         THjxRyPavOyKs8I9cgzYdUJoXaHlWj037esBTrWCTqN5G+sVxcJhTb7FDXrx3OZxU1to
         ULCMhYvkQBBFndR5bvpQhfxROgMWKjgbmJqe44mnNFOwosoFQnqP08HM779HAXCrTXZr
         DuR7Rl4TgKBcwU1+6dcda5Nlq6BceyGKf0PnA3TTLVb8GWMwYtxuojTt1+2LYevcMPfs
         qIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=3hQ7SGJEZlP1CEol/y6HCHbPMZs8/OdDFKjhXRwDL+E=;
        b=ONxRpp3kjRZJu7fyqoFBwwdAhumuufcDWaR+PYhHpctip/MM3tJwCChhZnsd14A5Ax
         OV3bSvWaKsFlYoPk8bywXwOxNPp7AQ/4u1IhwwpTU5Ehub6X5AYvTTVolRhuPnCF14s5
         Wa7lIDqRDRHYVriuO5FrE+xvU11Mg/B9AIb8avGeUziWN/QZ3WOaWcWQrnQ/TeuBxlBO
         juP4oyjBTrH26nUaPvvDU2Vl4g1sUwU3T5P9IygZZqr9qTWaLR6yQPVrQM4D7EHqw7E6
         OZZJvKu65e469Z7pZbk9qADncd2yc++K56YAwKiLZBiqRBz/Ct7vUqDDItfqhaPRZrn9
         8pYw==
X-Gm-Message-State: ACrzQf2jjc3rM/AoN9YVFgPFtppPbkqSGAxcfzBXVpMj0UYGvDv187to
        00s1eExqP+p9X2rRsWvHHRBMFg==
X-Google-Smtp-Source: AMsMyM7cXxLvb4TpPFTigbeIS4a7MGeSV8Zz5sOkWoY31J6VKzO2wply6JZgoEIfrVzEh3T8XpxoGg==
X-Received: by 2002:a17:902:d88a:b0:178:e0ba:da21 with SMTP id b10-20020a170902d88a00b00178e0bada21mr5400056plz.139.1664487551926;
        Thu, 29 Sep 2022 14:39:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v124-20020a622f82000000b005365aee486bsm132021pfv.192.2022.09.29.14.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 14:39:10 -0700 (PDT)
Date:   Thu, 29 Sep 2022 21:39:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Message-ID: <YzYQe2Lc+l2KpLBl@google.com>
References: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
 <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
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

On Thu, Sep 29, 2022, Paolo Bonzini wrote:
> 
> On 9/28/22 22:41, Sean Christopherson wrote:
> If you think we should overhaul it even more than just providing atomic
> batched updates, that's fine.

Or maybe solve the problem(s) with more precision?  What I don't like about the
batching is that it's not "atomic", and AFAICT doesn't have line of sight to truly
becoming atomic.  When I hear "atomic" updates, I think "all transactions are
commited at once".  That is not what this proposed API does, and due to the TLB
flushing requirements, I don't see how it can be implemented.

> But still, the impossibility to perform
> atomic updates in batches *is* a suboptimal part of the KVM API.

I don't disagree, but I honestly don't see the difference between "batching" and
providing a KVM_MEM_USER_EXIT flag.  The batch API will provide better performance,
but I would be surprised if it's significant enough to matter.  I'm not saying
that KVM_MEM_USER_EXIT provides novel functionality, e.g. I think we're in
agreement that handling memslot metadata will suck regardless.  My point is that
it's simpler to implement in KVM, much easier to document, and for all intents and
purposes provides the same desired functionality: vCPUs that access in-flux memslots
are stalled and so userspace doesn't have to pause and rendezvous all vCPUs to
provide "atomic" updates.

> The main cases are:
> 
> - for the boot case, splitting and merging existing memslots.  QEMU likes to
> merge adjacent memory regions into a single memslot, so if something goes
> from read-write to read-only it has to be split and vice versa.  I guess a
> "don't merge this memory region" flag would be the less hideous way to solve
> it in userspace.
> 
> - however, there is also the case of resizing an existing memslot which is
> what David would like to have for virtio-mem.  This is not really fixable
> because part of the appeal of virtio-mem is to have a single huge memslot
> instead of many smaller ones, in order to reduce the granularity of
> add/remove (David, correct me if I'm wrong).
> 
> (The latter _would_ be needed by other VMMs).

If we really want to provide a better experience for userspace, why not provide
more primitives to address those specific use cases?  E.g. fix KVM's historic wart
of disallowing toggling of KVM_MEM_READONLY, and then add one or more ioctls to:

  - Merge 2+ memory regions that are contiguous in GPA and HVA
  - Split a memory region into 2+ memory regions
  - Truncate a memory region
  - Grow a memory region

That would probably require more KVM code overall, but each operation would be more
tightly bounded and thus simpler to define.  And I think more precise APIs would
provide other benefits, e.g. growing a region wouldn't require first deleting the
current region, and so could avoid zapping SPTEs and destroying metadata.  Merge,
split, and truncate would have similar benefits, though they might be more
difficult to realize in practice.

What I really don't like about the "batch" API, aside from the "atomic" name, is
that it's too open ended and creates conflicts.  E.g. to allow "atomic" merging
after converting from RO=>RW, KVM needs to allow DELETE=>DELETE=>CREATE, and that
implies that each operation in the batch operates on the working state created by
the previous operations.

But if userspace provides a batch that does DELETE=>CREATE=>DELETE, naively hoisting
all "invalidations" to the front half of the "atomic" operations breaks the
ordering.  And there's a ridiculous amount of potential weirdness with MOVE=>MOVE
operations.  

KVM could solve those issues by disallowing MOVE and disallowing DELETE after
CREATE or FLAGS_ONLY, but then userspace is effectively restricted to operating
on a single contiguous chunk of memslots.  At that point, it seems that providing
primitives to do each macro operation is an even better experience for userspace.

In other words, make memslots a bit more CISC ;-)
