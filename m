Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EE05769FD
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiGOWin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGOWim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:38:42 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2892197
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:38:41 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g4so5623618pgc.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c8HBz31f4PNHrgqtzObZqq1cvzAd+5t6e56eP2uyEtw=;
        b=WvhhrEPXtr3dUK77jkQ9ruWjyC67u+tNicuq6LrO7hxSsxvadyiXDK4sQf+YOsw5yk
         S1CWvAgKECzn21Iv8LZosxQtsAmnVs3rcmmHv2xwtZop8TER3V7jb3NYHc8xbKn3ENMJ
         l61qsIDsx74M093uFGPrRJwrGB3OTN5s5ggCDjobTBE0WdmJRbA4Tvg1Wc/8frPF3Cho
         Evxd6cpjNyG7F1VpyLGzFD06JQHmc7dbFO8kNXTiyFYYRlrJBpqpLarNngDfIreNwS2O
         n0cYoG6TR2JGOIdxC/0tGZ3F1VIwn/N2U94VmthMAZc98IWKvrho1g2EqcPuFJf4Yzwj
         UIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c8HBz31f4PNHrgqtzObZqq1cvzAd+5t6e56eP2uyEtw=;
        b=2wWw6Iv5CdaOayaR974qgK+A68AGj2Q25plhmFTBxKWLiXGqtPB9Ir6aSev3bEeNqV
         wKq0y+ae20grzABpghmI67ZFxwtDasOq+4QnwzGumZC2eyhGFtvhAeL6Q5BPGpeL705E
         RxscMg4KdH8HnhFhR+awHGYyurczqsUw7SOB0ohPSKm97+MVX6ofr4JvfOQ3aAqNBUz4
         lZzAjMjIHNZUXI36yGJqpdwYpTGMSViwnX7zxeTigwQXhfBXz1LJkS7l/txvuBPvbcb/
         flP9q5+CGiUDwigPMEpveGYalSn18jixlOEUrMoobs15/CnGfH1STAJPXtabY7SfT6IN
         jthQ==
X-Gm-Message-State: AJIora9cbgnEEj1bPsxIanXkibGmWqO1fC1MT0bTmegKW0slywR1o7rp
        AGtHGDmnNMpXvUWb7hsvGzSbEQ==
X-Google-Smtp-Source: AGRyM1uE5gunnFfy+bt4xXvGccFnTPeSVg6XpE67vKg9rO802/mnjufsBDBpqNu/EE5Bqk1wPii5hQ==
X-Received: by 2002:a63:91c3:0:b0:419:b004:a99e with SMTP id l186-20020a6391c3000000b00419b004a99emr10157964pge.393.1657924720703;
        Fri, 15 Jul 2022 15:38:40 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a3-20020a634d03000000b00419b66846fcsm3600415pgb.91.2022.07.15.15.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 15:38:40 -0700 (PDT)
Date:   Fri, 15 Jul 2022 22:38:36 +0000
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
Message-ID: <YtHsbBbwE4iAsfG5@google.com>
References: <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
 <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
 <YtBanRozLuP9qoWs@xz-m1.local>
 <YtCBBI+rU+UQNm4p@google.com>
 <YtCWW2OfbI4+r1L3@xz-m1.local>
 <YtGUmsavkoTBjQTU@google.com>
 <YtGcOSo9xDsWxuCj@xz-m1.local>
 <YtGe4SPbSI6RQLJ1@google.com>
 <YtGjQNyQcN3GiVgS@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtGjQNyQcN3GiVgS@xz-m1.local>
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

On Fri, Jul 15, 2022, Peter Xu wrote:
> On Fri, Jul 15, 2022 at 05:07:45PM +0000, Sean Christopherson wrote:
> > On Fri, Jul 15, 2022, Peter Xu wrote:
> > > On Fri, Jul 15, 2022 at 04:23:54PM +0000, Sean Christopherson wrote:
> > > > And the reasoning behind not having kvm_run.dirty_count is that it's fully
> > > > redundant if KVM provides a stat, and IMO such a stat will be quite helpful for
> > > > things beyond dirty quotas, e.g. being able to see which vCPUs are dirtying memory
> > > > from the command line for debug purposes.
> > > 
> > > Not if with overflow in mind?  Note that I totally agree the overflow may
> > > not even happen, but I think it makes sense to consider as a complete
> > > design of ceiling-based approach.  Think the Millennium bug, we never know
> > > what will happen in the future..
> > > 
> > > So no objection too on having stats for dirty pages, it's just that if we
> > > still want to cover the overflow issue we'd make dirty_count writable, then
> > > it'd still better be in kvm_run, imho.
> > 
> > Yeah, never say never, but unless my math is wrong, overflow isn't happening anytime
> > soon.  And if future CPUs can overflow the number of dirty pages, then they'll be
> > able to overflow a number of stats, at which point I think we'll want a generic
> > ioctl() to reset _all_ stats.
> 
> It's slightly different as this affects functionality, unlike most stats.

Now that KVM exposes stats via ioctls, I don't think we should assume _anything_
about how userspace consumes stats.  I.e. KVM should guarantee sane behavior and
correctness for all stats.

In other words, this different in that it _directly_ affects KVM functionality,
but I think at this point we should assume that any and all stats can indirectly
affect KVM functionality.

> I'll leave that to Shivam to see his preference.  If to go that way, I hope
> we can at least have some WARN_ON_ONCE() on detecting overflows of "count".

I still think it's silly, but I definitely won't object to:

	WARN_ON_ONCE(!++vcpu->stat.generic.pages_dirtied);
