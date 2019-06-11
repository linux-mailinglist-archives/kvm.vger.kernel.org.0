Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D407B3C9E7
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 13:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfFKLWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 07:22:01 -0400
Received: from foss.arm.com ([217.140.110.172]:58890 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbfFKLWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 07:22:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EDEC344;
        Tue, 11 Jun 2019 04:22:00 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28CEC3F557;
        Tue, 11 Jun 2019 04:23:42 -0700 (PDT)
Date:   Tue, 11 Jun 2019 13:21:58 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, aarcange@redhat.com,
        kvmarm@lists.cs.columbia.edu
Subject: Re: Reference count on pages held in secondary MMUs
Message-ID: <20190611112158.GA5318@e113682-lin.lund.arm.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jun 09, 2019 at 11:37:19AM +0200, Paolo Bonzini wrote:
> On 09/06/19 10:18, Christoffer Dall wrote:
> > In some sense, we are thus maintaining a 'hidden', or internal,
> > reference to the page, which is not counted anywhere.
> > 
> > I am wondering if it would be equally valid to take a reference on the
> > page, and remove that reference when unmapping via MMU notifiers, and if
> > so, if there would be any advantages/drawbacks in doing so?
> 
> If I understand correctly, I think the MMU notifier would not fire if
> you took an actual reference; the page would be pinned in memory and
> could not be swapped out.
> 

That was my understanding too, but I can't find the code path that would
support this theory.

The closest thing I could find was is_page_cache_freeable(), and as far
as I'm able to understand that code, that is called (via pageout()) later in
shrink_page_list() than try_to_unmap() which fires the MMU notifiers
through the rmap code.

It is entirely possible that I'm looking at the wrong place and missing
something overall though?


Thanks,

    Christoffer
