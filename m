Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCCE60B401
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 19:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiJXRYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 13:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiJXRXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 13:23:41 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5F115B301
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:58:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q71so9008045pgq.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xhVPQ5+dIkT7H8GzdC1Hj5D+mUwjV/3EIBqX7ahZJb8=;
        b=sjFIyI04vx0cs1gow2DpqtMCKQ1Fs6ci3APl7zmnC44CID+qImSeekKnM09/9ngi5K
         683BoV0Kalu9yMxA7YsaVtFT17INOHozoSMzJTxq9+hAV6CNM6+9asP22bEfbjsNcPP1
         SEjxOnCcGo3s0Ha11T1Avy+NtACEquBAhRrd6tq5JOWQ5vX9BL+ZGLycubJP0K8duS3F
         Jo0VOABsoSAiJr1HU2iUz1HH2Cqm+Z3J7UgSAyX0IXVjDNYCJ93u/kzML6yNMToNJwem
         D8iHdbb4wa/mzPqwCzGIIVVn8FUHOuW5N35Xl3MVOOGw7B1hm7Ybu763Tf09iRs6MMI8
         F0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xhVPQ5+dIkT7H8GzdC1Hj5D+mUwjV/3EIBqX7ahZJb8=;
        b=jmzDwUt+AxtL904gjRogzEWQzhf2An85px+eLU6YyMFsogEaxrRZvA9Ik+uO6/w5cc
         kNHaD4mLxuE0jB1Ojq/LDWSltUZ4RBmnrpw/R9UiYS5vyiCzFx1QpCZ3mC+FdZCNXYjT
         tyPPFqf+33fP8+mCgTLXfDKtSevbX5n3V3VBVX2wq0Ok2v8lDQcIyMTM75OO1+H5rfvA
         5jGh6l38P2qAtZ85w/Dj0la7lt2bGeRpEdiwNoPcfPsiI2sSAC1g6aWRLu+Pb43jgf+P
         9djZ6SnoWoDZRDrCnwRbWrXgxXg/bNGtMYr6tzSorvBsj7NShjb+iTISG5/u2fmIu8VX
         CP5g==
X-Gm-Message-State: ACrzQf1oaqvbJbMLD97qRUPPpzLnntRNcssmTRdza0LoZrXb456xs0sE
        7shpHYhqPzg+sQMfp1inRzWQEkOwPxRb4w==
X-Google-Smtp-Source: AMsMyM7+Fsu8MVnZ+tCPi/6N4EEvflkwRny391GAU8Z6YL4QyjvxyPpKdzi0o7WrJrFkqQRLRZrHWQ==
X-Received: by 2002:a63:a06:0:b0:458:2853:45e4 with SMTP id 6-20020a630a06000000b00458285345e4mr27995688pgk.20.1666626959009;
        Mon, 24 Oct 2022 08:55:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w6-20020a170902e88600b00186a6b6350esm1880380plg.268.2022.10.24.08.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 08:55:58 -0700 (PDT)
Date:   Mon, 24 Oct 2022 15:55:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <Y1a1i9vbJ/pVmV9r@google.com>
References: <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
 <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
 <Y1GxnGo3A8UF3iTt@google.com>
 <cdaf34bc-b2ab-1a9d-22d0-3d9dc3364bf2@amazon.com>
 <Y1L1t6Qw2CaLwJk3@google.com>
 <490509f6-ae1a-4fc8-42a1-b037d6bffada@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490509f6-ae1a-4fc8-42a1-b037d6bffada@amazon.com>
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

On Mon, Oct 24, 2022, Alexander Graf wrote:
> Hey Sean,
> 
> On 21.10.22 21:40, Sean Christopherson wrote:
> > 
> > On Thu, Oct 20, 2022, Alexander Graf wrote:
> > > On 20.10.22 22:37, Sean Christopherson wrote:
> > > > On Thu, Oct 20, 2022, Alexander Graf wrote:
> > > > > On 26.06.20 19:32, Sean Christopherson wrote:
> > > > > > /cast <thread necromancy>
> > > > > > 
> > > > > > On Tue, Aug 20, 2019 at 01:03:19PM -0700, Sean Christopherson wrote:
> > > > > [...]
> > > > > 
> > > > > > I don't think any of this explains the pass-through GPU issue.  But, we
> > > > > > have a few use cases where zapping the entire MMU is undesirable, so I'm
> > > > > > going to retry upstreaming this patch as with per-VM opt-in.  I wanted to
> > > > > > set the record straight for posterity before doing so.
> > > > > Hey Sean,
> > > > > 
> > > > > Did you ever get around to upstream or rework the zap optimization? The way
> > > > > I read current upstream, a memslot change still always wipes all SPTEs, not
> > > > > only the ones that were changed.
> > > > Nope, I've more or less given up hope on zapping only the deleted/moved memslot.
> > > > TDX (and SNP?) will preserve SPTEs for guest private memory, but they're very
> > > > much a special case.
> > > > 
> > > > Do you have use case and/or issue that doesn't play nice with the "zap all" behavior?
> > > 
> > > Yeah, we're looking at adding support for the Hyper-V VSM extensions which
> > > Windows uses to implement Credential Guard. With that, the guest gets access
> > > to hypercalls that allow it to set reduced permissions for arbitrary gfns.
> > > To ensure that user space has full visibility into those for live migration,
> > > memory slots to model access would be a great fit. But it means we'd do
> > > ~100k memslot modifications on boot.
> > Oof.  100k memslot updates is going to be painful irrespective of flushing.  And
> > memslots (in their current form) won't work if the guest can drop executable
> > permissions.
> > 
> > Assuming KVM needs to support a KVM_MEM_NO_EXEC flag, rather than trying to solve
> > the "KVM flushes everything on memslot deletion", I think we should instead
> > properly support toggling KVM_MEM_READONLY (and KVM_MEM_NO_EXEC) without forcing
> > userspace to delete the memslot.  Commit 75d61fbcf563 ("KVM: set_memory_region:
> 
> 
> That would be a cute acceleration for the case where we have to change
> permissions for a full slot. Unfortunately, the bulk of the changes are slot
> splits.

Ah, right, the guest will be operating on per-page granularity.

> We already built a prototype implementation of an atomic memslot update
> ioctl that allows us to keep other vCPUs running while we do the
> delete/create/create/create operation.

Please weigh in with your use case on a relevant upstream discussion regarding
"atomic" memslot updates[*].  I suspect we'll end up with a different solution
for this use case (see below), but we should at least capture all potential use
cases and ideas for modifying memslots without pausing vCPUs.

[*] https://lore.kernel.org/all/20220909104506.738478-1-eesposit@redhat.com

> But even with that, we see up to 30 min boot times for larger guests that
> most of the time are stuck in zapping pages.

Out of curiosity, did you measure runtime performance?  I would expect some amount
of runtime overhead as well dut to fragmenting memslots to that degree.

> I guess we have 2 options to make this viable:
> 
>   1) Optimize memslot splits + modifications to a point where they're fast
> enough
>   2) Add a different, faster mechanism on top of memslots for page granular
> permission bits

#2 crossed my mind as well.  This is actually nearly identical to the confidential
VM use case, where KVM needs to handle guest-initiated conversions of memory between
"private" and "shared" on a per-page granularity.  The proposed solution for that
is indeed a layer on top of memslots[*], which we arrived at in no small part because
splitting memslots was going to be a bottleneck.

Extending the proposed mem_attr_array to support additional state should be quite
easy.  The framework is all there, KVM just needs a few extra flags values, e.g.

	KVM_MEM_ATTR_SHARED	BIT(0)
	KVM_MEM_ATTR_READONLY	BIT(1)
	KVM_MEM_ATTR_NOEXEC	BIT(2)

and then new ioctls to expose the functionality to userspace.  Actually, if we
want to go this route, it might even make sense to define new a generic MEM_ATTR
ioctl() right away instead of repurposing KVM_MEMORY_ENCRYPT_(UN)REG_REGION for
the private vs. shared use case.

[*] https://lore.kernel.org/all/20220915142913.2213336-6-chao.p.peng@linux.intel.com
