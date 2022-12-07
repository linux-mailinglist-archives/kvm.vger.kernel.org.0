Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC37C6461E4
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 20:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLGTxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 14:53:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGTxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 14:53:14 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2CB5E3CD
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 11:53:13 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id m4so11101183pls.4
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 11:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iLXb8eH4xeLW8i3JEbZAK7VslIoMfjoqfSRwfWr0uWw=;
        b=dSYeSTuyz9iQY4MlxbW7V2G8oJ3hdnzpBgp7lG/NWp2i1tm3D/hjaT5brY+VT3oKta
         G5opHp5dfPAmP5e3LPWTIL9k+MkhRmVie5mzM7fshcvF5GrEt+XYeb/KXxDzBJU76eFJ
         gKVQeS2V0NuSont9GXWIwDozONmNQxNuABdFKmtkVQi9bRSVvhCY3iladhuPGcpC6gsE
         mpNoitJeEbIw7K0eI2etj56jwSVlgk3ORaXNKVxuqXed4FsH3ISOmF/d2KOmP4xZHd/O
         qnTUvtL3sTl/N3rR/mLhQa0WsDc5C8PKQEvNMlBTLicds5i4q8v68L5p51EWAHoEEyTJ
         P72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLXb8eH4xeLW8i3JEbZAK7VslIoMfjoqfSRwfWr0uWw=;
        b=FxoP/eXtkQF5m8d/+3JqeFP8ahweMzyhPKfSe7DkMSZUZAOzFGZPgGtFB9VHLAZInf
         fuhFvykEipZePaMgZunwb9Df8WUWfZJx1YQJBp6SGhtXnnFmOudONWC5D5E497vjA8V/
         mwE1Rm3g0+0bAlf3YuBbecrd8PiZ14AkPcucHAwAi6XZ81XYGe7cJMz2CO29G5uFSI0i
         f75iG/u7B6XniGv+LXrY0qvKjhASwLuJ5pt5uZzWId58GiCTAt8LvJ3Y9ZrWTIBpotPd
         8oNPxmXmj5B7E5liWkv6tVFJcZ1uq5B2N3B3dgqpx8llP75pwljeIl/6CKmy5reS17To
         zujQ==
X-Gm-Message-State: ANoB5pn29qVM3UWiQCA4kGUseqyic4BryGvwLXVZaAq1MUs52PG/2a5P
        yDi5+hOKK5Etgrpb49bRm/SPJA==
X-Google-Smtp-Source: AA0mqf7my0994vE2wTnkLyhFUqB6ZpugRo5PwFnO63gVULmldGPGL0x76QBDiSSiWfIF4MARq4HqZQ==
X-Received: by 2002:a17:902:be01:b0:189:6624:58c0 with SMTP id r1-20020a170902be0100b00189662458c0mr1202730pls.3.1670442792815;
        Wed, 07 Dec 2022 11:53:12 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u13-20020a17090341cd00b00186f81bb3f0sm15080563ple.122.2022.12.07.11.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 11:53:12 -0800 (PST)
Date:   Wed, 7 Dec 2022 19:53:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y5DvJQWGwYRvlhZz@google.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ilinqi3l.wl-maz@kernel.org>
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

On Wed, Dec 07, 2022, Marc Zyngier wrote:
> On Tue, 06 Dec 2022 06:22:45 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
> You need to define the granularity of the counter, and account for
> each fault according to its mapping size. If an architecture has 16kB
> as the base page size, a 32MB fault (the size of the smallest block
> mapping) must bump the counter by 2048. That's the only way userspace
> can figure out what is going on.

I don't think that's true for the dirty logging case.  IIUC, when a memslot is
being dirty logged, KVM forces the memory to be mapped with PAGE_SIZE granularity,
and that base PAGE_SIZE is fixed and known to userspace.  I.e. accuracy is naturally
provided for this primary use case where accuracy really matters, and so this is
effectively a documentation issue and not a functional issue.

> Without that, you may as well add a random number to the counter, it
> won't be any worse.

The stat will be wildly inaccurate when dirty logging isn't enabled, but that doesn't
necessarily make the stat useless, e.g. it might be useful as a very rough guage
of which vCPUs are likely to be writing memory.  I do agree though that the value
provided is questionable and/or highly speculative.

> [...]
> 
> > >>> If you introduce additional #ifdefery here, why are the additional
> > >>> fields in the vcpu structure unconditional?
> > >> 
> > >> pages_dirtied can be a useful information even if dirty quota
> > >> throttling is not used. So, I kept it unconditional based on
> > >> feedback.
> > > 
> > > Useful for whom? This creates an ABI for all architectures, and this
> > > needs buy-in from everyone. Personally, I think it is a pretty useless
> > > stat.
> > 
> > When we started this patch series, it was a member of the kvm_run
> > struct. I made this a stat based on the feedback I received from the
> > reviews. If you think otherwise, I can move it back to where it was.
> 
> I'm certainly totally opposed to stats that don't have a clear use
> case. People keep piling random stats that satisfy their pet usage,
> and this only bloats the various structures for no overall benefit
> other than "hey, it might be useful". This is death by a thousand cut.

I don't have a strong opinion on putting the counter into kvm_run as an "out"
fields vs. making it a state.  I originally suggested making it a stat because
KVM needs to capture the information somewhere, so why not make it a stat?  But
I am definitely much more cavalier when it comes to adding stats, so I've no
objection to dropping the stat side of things.
