Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613B4109BED
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 11:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfKZKJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 05:09:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfKZKJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 05:09:52 -0500
Received: from localhost (unknown [84.241.194.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B17422089D;
        Tue, 26 Nov 2019 10:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574762991;
        bh=W8z6/CvP89Pad21EqU9fSyCJstx4Pa0nSnFzYyzFJ/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHQX1/KJxc1aHFQUhFjWoMTDjvGa/2EEkdZ7jgfwJeYOrdNNA4VquithjBM+YN+0V
         xHodewXPd2hT6rkc/2jVWlilTC8NBw3XvLaksbMdEUFE0vbSN1Cv6CgKKdU5rjQTiK
         y2fOTscxAWzspJfrsuqCJApvtFHjFeO7pbg7/F18=
Date:   Tue, 26 Nov 2019 11:09:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: "statsfs" API design
Message-ID: <20191126100948.GB1416107@kroah.com>
References: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
 <20191109154952.GA1365674@kroah.com>
 <cb52053e-eac0-cbb9-1633-646c7f71b8b3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb52053e-eac0-cbb9-1633-646c7f71b8b3@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 10, 2019 at 02:04:58PM +0100, Paolo Bonzini wrote:
> On 09/11/19 16:49, Greg Kroah-Hartman wrote:
> > On Wed, Nov 06, 2019 at 04:56:25PM +0100, Paolo Bonzini wrote:
> >> Hi all,
> >>
> >> statsfs is a proposal for a new Linux kernel synthetic filesystem, to be
> >> mounted in /sys/kernel/stats, which exposes subsystem-level statistics
> >> in sysfs.  Reading need not be particularly lightweight, but writing
> >> must be fast.  Therefore, statistics are gathered at a fine-grain level
> >> in order to avoid locking or atomic operations, and then aggregated by
> >> statsfs until the desired granularity.
> > 
> > Wait, reading a statistic from userspace can be slow, but writing to it
> > from userspace has to be fast?  Or do you mean the speed is all for
> > reading/writing the value within the kernel?
> 
> Reading/writing from the kernel.  Reads from a userspace are a superset
> of reading from the kernel, writes from userspace are irrelevant.
> 
> [...]
> 
> >> As you can see, values are basically integers stored somewhere in a
> >> struct.   The statsfs_value struct also includes information on which
> >> operations (for example sum, min, max, average, count nonzero) it makes
> >> sense to expose when the values are aggregated.
> > 
> > What can userspace do with that info?
> 
> The basic usage is logging.  A turbostat-like tool that is able to use
> both debugfs and tracepoints is already in tools/kvm/kvm_stat.
> 
> > I have some old notes somewhere about what people really want when it
> > comes to a good "statistics" datatype, that I was thinking of building
> > off of, but that seems independant of what you are doing here, right?
> > This is just exporting existing values to userspace in a semi-sane way?
> 
> For KVM yes.  But while I'm at it, I'd like the subsystem to be useful
> for others so if you can dig out those notes I can integrate that.
> 
> > Anyway, I like the idea, but what about how this is exposed to
> > userspace?  The criticism of sysfs for statistics is that it is too slow
> > to open/read/close lots of files and tough to get "at this moment in
> > time these are all the different values" snapshots easily.  How will
> > this be addressed here?
> 
> Individual files in sysfs *should* be the first format to export
> statsfs, since quick scripts are an important usecase.  However, another
> advantage of having a higher-level API is that other ways to access the
> stats can be added transparently.
> 
> The main requirement for that is self-descriptiveness, blindly passing
> structs to userspace is certainly the worst format of all.  But I don't
> like the idea of JSON or anything ASCII; that adds overhead to both
> production and parsing, for no particular reason.   Tracepoints already
> do something like that to export arguments, so perhaps there is room to
> reuse code or at least some ideas.  It could be binary sysfs files
> (again like tracing) or netlink, I haven't thought about it at all.

So I think there are two different things here:
	- a simple data structure for in-kernel users of statistics
	- a way to export statistics to userspace

Now if they both can be solved with the same "solution", wonderful!  But
don't think that you have to do both of these at the same time.

Which one are you trying to solve here, I can't figure it out.  Is it
the second one?

thanks,

greg k-h
