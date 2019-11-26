Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C96510A024
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 15:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfKZOSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 09:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbfKZOSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 09:18:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9431F2071A;
        Tue, 26 Nov 2019 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574777913;
        bh=wrE2RjXzZRTQc4KFr/A9HyeYqBQOvi0ZbFQRhajMLII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rq02gByNlgBPJZRP0IGg0aQgJ8NAjnQ5Gg3+5hHE0YrOZWtuON+/9QbasHfstawKz
         lrnr2C7TRJ50Mla+3fyGI82Zn1+NO9lhDsqoDpZkiwBD419840SKXv7YWE3I9W+yIl
         4I3DCzgBxvHkja3mly+xwdotHQ5SQejMua7c3fbA=
Date:   Tue, 26 Nov 2019 15:18:30 +0100
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
Message-ID: <20191126141830.GA1446708@kroah.com>
References: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
 <20191109154952.GA1365674@kroah.com>
 <cb52053e-eac0-cbb9-1633-646c7f71b8b3@redhat.com>
 <20191126100948.GB1416107@kroah.com>
 <75dc4403-cc07-0f99-00ec-86f61092fff9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75dc4403-cc07-0f99-00ec-86f61092fff9@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 11:50:29AM +0100, Paolo Bonzini wrote:
> On 26/11/19 11:09, Greg Kroah-Hartman wrote:
> > So I think there are two different things here:
> > 	- a simple data structure for in-kernel users of statistics
> > 	- a way to export statistics to userspace
> > 
> > Now if they both can be solved with the same "solution", wonderful!  But
> > don't think that you have to do both of these at the same time.
> > 
> > Which one are you trying to solve here, I can't figure it out.  Is it
> > the second one?
> 
> I already have the second in KVM using debugfs, but that's not good.  So
> I want to do:
> 
> - a simple data structure for in-kernel *publishers* of statistics
> 
> - a sysfs-based interface to export it to userspace, which looks a lot
> like KVM's debugfs-based statistics.
> 
> What we don't have to do at the same time, is a new interface to
> userspace, one that is more efficient while keeping the self-describing
> property that we agree is needed.  That is also planned, but would come
> later.

Ok, I have no objection to tying these to sysfs entries for now, but we
should be careful in how you handle the sysfs hierarchy to not make it
too complex or difficult to parse from userspace (lots of little files
does not make gathering stats easy as was already pointed out.)

for in-kernel stats, here's a note that I had that I finally found from
a different kernel developer saying what they wanted to see in something
like this:
	(Accurate) statistics counters need RMW ops, don't need memory
	ordering, usually can't be locked against writes, and may not
	care about wrapping.

thanks,

greg k-h
