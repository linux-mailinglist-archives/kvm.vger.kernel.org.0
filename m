Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74EF576534
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiGOQYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiGOQYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:24:00 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C6518E2A
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:23:59 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id f65so4810054pgc.12
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AkNS9VjkDM9iJkZW9AUNvrRa0KBpcWyilEmv6y4S+sM=;
        b=nflMI1NG4jg1HLe/9WW9EHQgZFxk/7qxAorz2aRcjEcFfyi/tt1GwW/3LYWzWkBYCB
         0MN4PScK2mLGO53rxwmmz7UqqYz4qykuWr8sh970X3LT1ymnSdDXWKPbPpli2XeWx2XM
         jMhzEoZ/JgKfV0f0NREDvy9wlGWizesrdHO7PC/o8NRC459aI52XCkZIcafBCNyDF3Af
         p0QG0UKpPkyClrAmByFKWQ0w/mHOEO81WCH58jJhAJY4v65XsvItydOm4G7RxFiznRyo
         EOLMWXyavtcxEBh22tLeBtNltreGGtC5LsMjd5h346uoh83btr1iD78Bed0uyxQsS2qY
         9RMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AkNS9VjkDM9iJkZW9AUNvrRa0KBpcWyilEmv6y4S+sM=;
        b=NfoVLpQpBREvmhWmNi9Vif08DtUVZdOci/D5n2Eb4QR52Ocq06EZHs5xxChzIvKnK0
         KlycTSpEZyHyxU8ybM1mtMqZGu/AJHTn0neNJfJ4RFYpwiXUqO3wvPYhrxD40br+EO77
         /IbGbor+HmGnKgWOH0J2GFf9s2LJN3RB6es4+KM8PWmVCOrnvvwXOZVO1QoXqfA6SKB8
         j6MFU5kPLIfC9bM6WhVV/HlAixGbagdD61u8HZVvxYBAE0Jd7kpz7h9spn2pY0Yo9bsg
         uyTH/1zZQEunb0XGmPJCmUABV4hckSlgjvivDvIDldXzhoSKPBtotfk7l8Lypp9vfVCW
         XgZg==
X-Gm-Message-State: AJIora+9Mq389fgnAFNq15z+h+nXWGP4x639yP2yA3T+vGJ2DDR/ngnE
        obbwiwDxHS7nE06S7G/oGdDVWA==
X-Google-Smtp-Source: AGRyM1twyk6TGTeksIzZSBwTGlFxy3DNWQYRQFoB/GgvqMbLoh1eqvpBPiL7F72F4TrdaOdNmJ72+g==
X-Received: by 2002:a63:db41:0:b0:40d:e79f:8334 with SMTP id x1-20020a63db41000000b0040de79f8334mr12614942pgi.565.1657902239042;
        Fri, 15 Jul 2022 09:23:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id e15-20020a056a0000cf00b005255489187fsm4037087pfj.135.2022.07.15.09.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:23:58 -0700 (PDT)
Date:   Fri, 15 Jul 2022 16:23:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtGUmsavkoTBjQTU@google.com>
References: <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
 <YtCWW2OfbI4+r1L3@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtCWW2OfbI4+r1L3@xz-m1.local>
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

On Thu, Jul 14, 2022, Peter Xu wrote:
> On Thu, Jul 14, 2022 at 08:48:04PM +0000, Sean Christopherson wrote:
> > On Thu, Jul 14, 2022, Peter Xu wrote:
> > > Hi, Shivam,
> > > 
> > > On Tue, Jul 05, 2022 at 12:51:01PM +0530, Shivam Kumar wrote:
> > > > Hi, here's a summary of what needs to be changed and what should be kept as
> > > > it is (purely my opinion based on the discussions we have had so far):
> > > > 
> > > > i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm requests
> > > > in dirty quota check. I hope that the ceiling-based approach, with proper
> > > > documentation and an ioctl exposed for resetting 'dirty_quota' and
> > > > 'pages_dirtied', is good enough. Please post your suggestions if you think
> > > > otherwise.
> > > 
> > > An ioctl just for this could be an overkill to me.
> > >
> > > Currently you exposes only "quota" to kvm_run, then when vmexit you have
> > > exit fields contain both "quota" and "count".  I always think it's a bit
> > > redundant.
> > > 
> > > What I'm thinking is:
> > > 
> > >   (1) Expose both "quota" and "count" in kvm_run, then:
> > > 
> > >       "quota" should only be written by userspace and read by kernel.
> > >       "count" should only be written by kernel and read by the userspace. [*]
> > > 
> > >       [*] One special case is when the userspace found that there's risk of
> > >       quota & count overflow, then the userspace:
> > > 
> > >         - Kick the vcpu out (so the kernel won't write to "count" anymore)
> > >         - Update both "quota" and "count" to safe values
> > >         - Resume the KVM_RUN
> > > 
> > >   (2) When quota reached, we don't need to copy quota/count in vmexit
> > >       fields, since the userspace can read the realtime values in kvm_run.
> > > 
> > > Would this work?
> > 
> > Technically, yes, practically speaking, no.  If KVM doesn't provide the quota
> > that _KVM_ saw at the time of exit, then there's no sane way to audit KVM exits
> > due to KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.  Providing the quota ensure userspace sees
> > sane, coherent data if there's a race between KVM checking the quota and userspace
> > updating the quota.  If KVM doesn't provide the quota, then userspace can see an
> > exit with "count < quota".
> 
> This is rare false positive which should be acceptable in this case (the
> same as vmexit with count==quota but we just planned to boost the quota),
> IMHO it's better than always kicking the vcpu, since the overhead for such
> false is only a vmexit but nothing else.

Oh, we're in complete agreement on that front.  I'm only objecting to forcing
userspace to read the realtime quota+count.  I want KVM to provide a snapshot of
the quota+count so that if there's a KVM bug, e.g. KVM spuriously exits, then
there is zero ambiguity as the quota+count in the kvm_run exit field will hold
invalid/garbage data.  Without a snapshot, if there were a bug where KVM spuriously
exited, root causing or even detecting the bug would be difficult if userspace is
dynamically updating the quota as changing the quota would have destroyed the
evidence of KVM's bug.

It's unlikely we'll eever have such a bug, but filling the exits fields is cheap, and
because it's a union, the "redundant" fields don't consume extra space in kvm_run.

And the reasoning behind not having kvm_run.dirty_count is that it's fully
redundant if KVM provides a stat, and IMO such a stat will be quite helpful for
things beyond dirty quotas, e.g. being able to see which vCPUs are dirtying memory
from the command line for debug purposes.

> > Even if userspace is ok with such races, it will be extremely difficult to detect
> > KVM issues if we mess something up because such behavior would have to be allowed
> > by KVM's ABI.
> 
> Could you elaborate?  We have quite a few places sharing these between
> user/kernel on kvm_run, no?

I think I answered this above, let me know if I didn't.
