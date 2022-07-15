Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2311C57659A
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiGOQ4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiGOQ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E40F79EF7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657904192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VId34yl/iR/ldmsUkXfM6F0oMcoc7+mcKyjPxBlxDTk=;
        b=J4cGjFY0j2GHYDSebIzHmGdTd32bbZLtVQicPgAGbG9BBZudhdmhiWcYZXTaURjIPQ2gsU
        a+diDEQXsZRbG/ivywY4/Plcq7qPhqt6CExeOL8GcyF2bL4kqYWyuCfEdYLAPpRtO6wc81
        lCLhc+hWT/TYM2CDFcoBP03KjlBWaIE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-x1LsRArYNcuEUrDTEAKJSg-1; Fri, 15 Jul 2022 12:56:30 -0400
X-MC-Unique: x1LsRArYNcuEUrDTEAKJSg-1
Received: by mail-qk1-f199.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so3814482qkp.7
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VId34yl/iR/ldmsUkXfM6F0oMcoc7+mcKyjPxBlxDTk=;
        b=uiCq3t2FvWd9Qev1HN9+PyfSG8sn8OfNDKVwQvmQENFZDrVu1YyQpK/9fek5ldPdsG
         kNaSuHFs9xAwm5AuAuO+bu/+6zDHXTvzX+NDtLlf5Ypm1P1NtUPgQpt4w+qVAXTHqSB5
         DV7aL1iD4e8C1beZW1EdHYNkfGAiJzEHl4huGjT2GfqF96cEcWmcryHHOz3+L3ZqhUXe
         qe68PeSe85p8hAO7FDtKPzk26fWfqZ05rlUe1D7ZI6Bap0eR+Q1ckgOVPTymx9UllG9D
         t+eCd0wHRWaC+uNe8QDDfU//I4wNINnF+HQIc1hurapurbFbDw2wuPFWgpn2A8rxYmK6
         2yTA==
X-Gm-Message-State: AJIora/b0Bc4wXhSuWvtoGgkGT49ZELwj+7RB30tR5ECF52LDB+JvO9R
        uXzt/m7wpNFUupV3iGgZdAmp6XIsYYydP4m8ZMXD4EZ569eWR6QhdHIUoSV7isBnUBsyiTCjvW7
        0q7393Hc644uf
X-Received: by 2002:a05:6214:1c0e:b0:473:812a:bf6c with SMTP id u14-20020a0562141c0e00b00473812abf6cmr12839995qvc.78.1657904188880;
        Fri, 15 Jul 2022 09:56:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ulcSJeyfFSl7DspuztIQ8YYxxwgHZrdH9F5ZZLHhJyAZ6RUHuZHAEcJJHUBAXTcgt3k4ITzw==
X-Received: by 2002:a05:6214:1c0e:b0:473:812a:bf6c with SMTP id u14-20020a0562141c0e00b00473812abf6cmr12839976qvc.78.1657904188612;
        Fri, 15 Jul 2022 09:56:28 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id q47-20020a05620a2a6f00b006a6c552736asm4677061qkp.119.2022.07.15.09.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:56:27 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:56:25 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>,
        Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YtGcOSo9xDsWxuCj@xz-m1.local>
References: <878rqomnfr.wl-maz@kernel.org>
 <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org>
 <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
 <YtCWW2OfbI4+r1L3@xz-m1.local>
 <YtGUmsavkoTBjQTU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtGUmsavkoTBjQTU@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 15, 2022 at 04:23:54PM +0000, Sean Christopherson wrote:
> On Thu, Jul 14, 2022, Peter Xu wrote:
> > On Thu, Jul 14, 2022 at 08:48:04PM +0000, Sean Christopherson wrote:
> > > On Thu, Jul 14, 2022, Peter Xu wrote:
> > > > Hi, Shivam,
> > > > 
> > > > On Tue, Jul 05, 2022 at 12:51:01PM +0530, Shivam Kumar wrote:
> > > > > Hi, here's a summary of what needs to be changed and what should be kept as
> > > > > it is (purely my opinion based on the discussions we have had so far):
> > > > > 
> > > > > i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm requests
> > > > > in dirty quota check. I hope that the ceiling-based approach, with proper
> > > > > documentation and an ioctl exposed for resetting 'dirty_quota' and
> > > > > 'pages_dirtied', is good enough. Please post your suggestions if you think
> > > > > otherwise.
> > > > 
> > > > An ioctl just for this could be an overkill to me.
> > > >
> > > > Currently you exposes only "quota" to kvm_run, then when vmexit you have
> > > > exit fields contain both "quota" and "count".  I always think it's a bit
> > > > redundant.
> > > > 
> > > > What I'm thinking is:
> > > > 
> > > >   (1) Expose both "quota" and "count" in kvm_run, then:
> > > > 
> > > >       "quota" should only be written by userspace and read by kernel.
> > > >       "count" should only be written by kernel and read by the userspace. [*]
> > > > 
> > > >       [*] One special case is when the userspace found that there's risk of
> > > >       quota & count overflow, then the userspace:
> > > > 
> > > >         - Kick the vcpu out (so the kernel won't write to "count" anymore)
> > > >         - Update both "quota" and "count" to safe values
> > > >         - Resume the KVM_RUN
> > > > 
> > > >   (2) When quota reached, we don't need to copy quota/count in vmexit
> > > >       fields, since the userspace can read the realtime values in kvm_run.
> > > > 
> > > > Would this work?
> > > 
> > > Technically, yes, practically speaking, no.  If KVM doesn't provide the quota
> > > that _KVM_ saw at the time of exit, then there's no sane way to audit KVM exits
> > > due to KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.  Providing the quota ensure userspace sees
> > > sane, coherent data if there's a race between KVM checking the quota and userspace
> > > updating the quota.  If KVM doesn't provide the quota, then userspace can see an
> > > exit with "count < quota".
> > 
> > This is rare false positive which should be acceptable in this case (the
> > same as vmexit with count==quota but we just planned to boost the quota),
> > IMHO it's better than always kicking the vcpu, since the overhead for such
> > false is only a vmexit but nothing else.
> 
> Oh, we're in complete agreement on that front.  I'm only objecting to forcing
> userspace to read the realtime quota+count.  I want KVM to provide a snapshot of
> the quota+count so that if there's a KVM bug, e.g. KVM spuriously exits, then
> there is zero ambiguity as the quota+count in the kvm_run exit field will hold
> invalid/garbage data.

That'll need to be a super accident of both: an accident of spurious exit,
and another accident to set vm exit reason exactly to QUOTA_FULL. :) But I
see what you meant.

> Without a snapshot, if there were a bug where KVM spuriously
> exited, root causing or even detecting the bug would be difficult if userspace is
> dynamically updating the quota as changing the quota would have destroyed the
> evidence of KVM's bug.
> 
> It's unlikely we'll eever have such a bug, but filling the exits fields is cheap, and
> because it's a union, the "redundant" fields don't consume extra space in kvm_run.

Yes no objection if you think that's better, the overhead is pretty trivial
indeed.

> 
> And the reasoning behind not having kvm_run.dirty_count is that it's fully
> redundant if KVM provides a stat, and IMO such a stat will be quite helpful for
> things beyond dirty quotas, e.g. being able to see which vCPUs are dirtying memory
> from the command line for debug purposes.

Not if with overflow in mind?  Note that I totally agree the overflow may
not even happen, but I think it makes sense to consider as a complete
design of ceiling-based approach.  Think the Millennium bug, we never know
what will happen in the future..

So no objection too on having stats for dirty pages, it's just that if we
still want to cover the overflow issue we'd make dirty_count writable, then
it'd still better be in kvm_run, imho.

-- 
Peter Xu

