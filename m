Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A15EF947
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236011AbiI2Pli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234916AbiI2Pkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F93FA0F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664466015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJBPjaoygV226ugYGvuBnTt19erm59o8C2parEHLZRs=;
        b=Rz0UYeB36Bqm82VWHmp8cOClqg4RXX7d0N+xB4QUz0FUEM5a7iM9AGRwXCVwWumr9bsbJZ
        JdJNmO5lUZY4AGNiWXd+5cb1wshJGQ3rXfGtCoNHy2pFMMJsTMzMFL+HjvIY7tsxCPkFLd
        vy5tH+8vJDbdmCVGFKDSwBbMwJ5zqCo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-iHr5RjBZNKiVdGCURU0WFg-1; Thu, 29 Sep 2022 11:40:12 -0400
X-MC-Unique: iHr5RjBZNKiVdGCURU0WFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 625B281172B;
        Thu, 29 Sep 2022 15:40:10 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A01BB1121314;
        Thu, 29 Sep 2022 15:40:05 +0000 (UTC)
Message-ID: <58e0053747406a88310ad3d232d021f4ae01a687.camel@redhat.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Date:   Thu, 29 Sep 2022 18:40:04 +0300
In-Reply-To: <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
References: <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
         <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
         <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
         <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
         <YzIZhn47brWBfQah@google.com>
         <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
         <YzMdjSkKaJ8HyWXh@google.com>
         <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
         <YzRvMZDoukMbeaxR@google.com>
         <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
         <YzSxhHzgNKHL3Cvm@google.com>
         <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-29 at 17:28 +0200, Paolo Bonzini wrote:
> On 9/28/22 22:41, Sean Christopherson wrote:
> > On Wed, Sep 28, 2022, Paolo Bonzini wrote:
> > > On 9/28/22 17:58, Sean Christopherson wrote:
> > > > I don't disagree that the memslots API is lacking, but IMO that is somewhat
> > > > orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
> > > > should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
> > > > like to have the luxury of being able to explore ideas beyond "let userspace
> > > > batch memslot updates", and I really don't want to feel pressured to get this
> > > > code reviewed and merge.
> > > 
> > > I absolutely agree that this is not a bugfix.  Most new features for KVM can
> > > be seen as bug fixes if you squint hard enough, but they're still features.
> > 
> > I guess I'm complaining that there isn't sufficient justification for this new
> > feature.  The cover letter provides a bug that would be fixed by having batched
> > updates, but as above, that's really due to deficiencies in a different KVM ABI.
> 
> I disagree.  Failure to fetch should be fixed but is otherwise a red 
> herring.  It's the whole memslot API (including dirty logging) that is a 
> mess.
> 
> If you think we should overhaul it even more than just providing atomic 
> batched updates, that's fine.  But still, the impossibility to perform 
> atomic updates in batches *is* a suboptimal part of the KVM API.
> 
> >    - Why can't this be solved in userspace?
> 
> I don't think *can't* is the right word.  If the metric of choice was 
> "what can be solved in userspace", we'd all be using microkernels.  The 
> question is why userspace would be a better place to solve it.
> 
> The only reason to do it in userspace would be if failure to fetch is 
> something that is interesting to userspace, other than between two 
> KVM_SET_USER_MEMORY_REGION.  Unless you provide an API to pass failures 
> to fetch down to userspace, the locking in userspace is going to be 
> inferior, because it would have to be unconditional.  This means worse 
> performance and more complication, not to mention having to do it N 
> times instead of 1 for N implementations.
> 
> Not forcing userspace to do "tricks" is in my opinion a strong part of 
> deciding whether an API belongs in KVM.
> 
> >    - What operations does userspace truly need?  E.g. if the only use case is to
> >      split/truncate/hole punch an existing memslot, can KVM instead provide a
> >      memslot flag and exit reason that allows kicking vCPUs to userspace if the
> >      memslot is accessed?  E.g. KVM_MEM_DISABLED that acts like an invalid memslot,
> >      but KVM exists with a dedicated exit reason instead of generating MMIO semantics.
> 
> The main cases are:
> 
> - for the boot case, splitting and merging existing memslots.  QEMU 
> likes to merge adjacent memory regions into a single memslot, so if 
> something goes from read-write to read-only it has to be split and vice 
> versa.  I guess a "don't merge this memory region" flag would be the 
> less hideous way to solve it in userspace.
> 
> - however, there is also the case of resizing an existing memslot which 
> is what David would like to have for virtio-mem.  This is not really 
> fixable because part of the appeal of virtio-mem is to have a single 
> huge memslot instead of many smaller ones, in order to reduce the 
> granularity of add/remove (David, correct me if I'm wrong).
> 
> (The latter _would_ be needed by other VMMs).
> 
> > If updates only need to be "atomic" for an address space, does the API allowing
> > mixing non-SMM and SMM memslots?
> 
> I agree that the address space should be moved out of the single entries 
> and into the header if we follow through with this approach.
> 
> > The update needs to be "atomic", i.e. vCPUs
> > must never see an invalid/deleted memslot, but if the memslot is writable,
> > how does KVM prevent some writes from hitting the old HVA and some from hitting
> > the new HVA without a quiescent period?
> 
> (Heh, and I forgot likewise that non-x86 does not retry on 
> KVM_MEMSLOT_INVALID.  Yes, that would be treated as a bug on other 
> architectures).
> 
> > > Wholesale replacement was my first idea when I looked at the issue, I think
> > > at the end of 2020.  I never got to a full implementation, but my impression
> > > was that allocating/deallocating dirty bitmaps, rmaps etc. would make it any
> > > easier than arbitrary batch updates.
> > 
> > It's not obvious to me that the memslot metadata is going to be easy to handle
> > regardless of what we do.  E.g. I'm pretty sure that batching updates will "corrupt"
> > the dirty bitmap if a hole is punched in a memslot that's being dirty logged.
> 
> Indeed; I would have thought that it is clear with the batch updates API 
> (which requires the update to be split into delete and insert), but 
> apparently it's not and it's by no means optimal.


I 100% agree with everything Paolo said.


Best regards,
	Maxim Levitsky
> 
> Paolo
> 


