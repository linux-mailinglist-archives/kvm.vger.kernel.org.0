Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6CA1C8A2C
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 14:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgEGML3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 08:11:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40696 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGML2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 08:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588853486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EANwWfRY2fmMo9bV62Nn6bc92cfkBW2MVPtmjYJC3NY=;
        b=HNomeiOJtqTVbiOLA4UXekR3XTtr3cfUntr6A8ckrTOMFQw0ALbbtLI4BjqxOq0EMI+LEt
        raPSJt374CsoYAGHSxw4Cs/yjZxoP3hK4IaHNYZycLBSSOjtpNl83RPsWJJJkU53AG5NmA
        AvC1SP2d2igjad1h/bPRW7OqmWd7XNA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-L3lZ-9GfPpWwth8UQxFZAw-1; Thu, 07 May 2020 08:11:25 -0400
X-MC-Unique: L3lZ-9GfPpWwth8UQxFZAw-1
Received: by mail-wm1-f71.google.com with SMTP id n127so2416008wme.4
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 05:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EANwWfRY2fmMo9bV62Nn6bc92cfkBW2MVPtmjYJC3NY=;
        b=iB9sqIifUvz0mId5TqUJQgUc2lUjbF7kcuJx6rsq8uDTPHPAe0LbTU+bFSGA47Jvom
         NJ10M0l/Eos7e+5mKJ/L6lGIRF67jOBkUxhjFzWHlDyUWU470Q3E2q47DQSy5QsRelEl
         WT+19JctOVud8agMXiLgnAR8xqYEwh8BcWa42cF3hZjN/uILSlMJYB6xnYcRM+Zc0u0r
         rxBnzIFRmrMHPM/JS0YbFN/4A8XBNK1R2rX5BzKYHIKyxYEF4hwUTEOMx8OaWfgRF/v0
         wvxu430G/owCxXIVbXXL+yFjuhXQ6CmdVr/nP55q5KfzY2SoIHIi7e5CkrosAXbf9b80
         MIuw==
X-Gm-Message-State: AGi0PuZM8zHUj63HXXUibZ+B8rEXCabWngoO0tX0XNRDKTP6q2JFJM77
        5pE5XFtof9DEe47utMjf1gEh2nPSl4sObt8EQnTs4HeYn/uGHjVLAnWjQjskrN44eJs1MSkAzBk
        bzLs+HDGwxjZ1
X-Received: by 2002:a5d:4389:: with SMTP id i9mr15945335wrq.374.1588853484091;
        Thu, 07 May 2020 05:11:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ7D0RkcqeXu3YBCPljtvjPEqgvhppTkrE0OvAuBlPYmp89z6WlX+VSiChRymh96iq6D4Ha+A==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr15945306wrq.374.1588853483876;
        Thu, 07 May 2020 05:11:23 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id v2sm8092084wrn.21.2020.05.07.05.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 05:11:23 -0700 (PDT)
Date:   Thu, 7 May 2020 08:11:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Oscar Salvador <osalvador@suse.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v3 07/15] mm/memory_hotplug: Introduce
 offline_and_remove_memory()
Message-ID: <20200507080849-mutt-send-email-mst@kernel.org>
References: <20200507103119.11219-1-david@redhat.com>
 <20200507103119.11219-8-david@redhat.com>
 <20200507064558-mutt-send-email-mst@kernel.org>
 <a915653f-232e-aa13-68f7-f988704fa84c@redhat.com>
 <441bfb92-ecfa-f54e-3661-b219ea166e55@redhat.com>
 <20200507073408-mutt-send-email-mst@kernel.org>
 <3bed2d1d-d94a-45ca-afe3-5e6ee660b0fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bed2d1d-d94a-45ca-afe3-5e6ee660b0fc@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 01:37:30PM +0200, David Hildenbrand wrote:
> On 07.05.20 13:34, Michael S. Tsirkin wrote:
> > On Thu, May 07, 2020 at 01:33:23PM +0200, David Hildenbrand wrote:
> >>>> I get:
> >>>>
> >>>> error: sha1 information is lacking or useless (mm/memory_hotplug.c).
> >>>> error: could not build fake ancestor
> >>>>
> >>>> which version is this against? Pls post patches on top of some tag
> >>>> in Linus' tree if possible.
> >>>
> >>> As the cover states, latest linux-next. To be precise
> >>>
> >>> commit 6b43f715b6379433e8eb30aa9bcc99bd6a585f77 (tag: next-20200507,
> >>> next/master)
> >>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> >>> Date:   Thu May 7 18:11:31 2020 +1000
> >>>
> >>>     Add linux-next specific files for 20200507
> >>>
> >>
> >> The patches seem to apply cleanly on top of
> >>
> >> commit a811c1fa0a02c062555b54651065899437bacdbe (linus/master)
> >> Merge: b9388959ba50 16f8036086a9
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Wed May 6 20:53:22 2020 -0700
> >>
> >>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
> > 
> > Because you have the relevant hashes in your git tree not pruned yet.
> > Do a new clone and they won't apply.
> > 
> 
> Yeah, most probably, it knows how to merge. I'm used to sending all my
> -mm stuff based on -next, so this here is different.


Documentation/process/5.Posting.rst addresses this:


Patches must be prepared against a specific version of the kernel.  As a
general rule, a patch should be based on the current mainline as found in
Linus's git tree.  When basing on mainline, start with a well-known release
point - a stable or -rc release - rather than branching off the mainline at
an arbitrary spot.

It may become necessary to make versions against -mm, linux-next, or a
subsystem tree, though, to facilitate wider testing and review.  Depending
on the area of your patch and what is going on elsewhere, basing a patch
against these other trees can require a significant amount of work
resolving conflicts and dealing with API changes.





> I'll wait a bit and then send v4 based on latest linus/master, adding
> the two acks and reshuffling the MAINTAINERS patch. Thanks.
> 
> -- 
> Thanks,
> 
> David / dhildenb

