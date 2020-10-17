Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9424F290F15
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 07:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411552AbgJQFZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 01:25:52 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43826 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411543AbgJQFZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 01:25:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09H3a6p1014024;
        Sat, 17 Oct 2020 05:36:06 +0200
Date:   Sat, 17 Oct 2020 05:36:06 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jann Horn <jannh@google.com>
Cc:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jason Donenfeld <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201017033606.GA14014@1wt.eu>
References: <AQHWo8lIfZnFKGe8nkGmhTCXwq5R3w==>
 <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 03:40:08AM +0200, Jann Horn wrote:
> [adding some more people who are interested in RNG stuff: Andy, Jason,
> Theodore, Willy Tarreau, Eric Biggers. also linux-api@, because this
> concerns some pretty fundamental API stuff related to RNG usage]
> 
> On Fri, Oct 16, 2020 at 4:33 PM Catangiu, Adrian Costin
> <acatan@amazon.com> wrote:
> > This patch is a driver which exposes the Virtual Machine Generation ID
> > via a char-dev FS interface that provides ID update sync and async
> > notification, retrieval and confirmation mechanisms:
> >
> > When the device is 'open()'ed a copy of the current vm UUID is
> > associated with the file handle. 'read()' operations block until the
> > associated UUID is no longer up to date - until HW vm gen id changes -
> > at which point the new UUID is provided/returned. Nonblocking 'read()'
> > uses EWOULDBLOCK to signal that there is no _new_ UUID available.
> >
> > 'poll()' is implemented to allow polling for UUID updates. Such
> > updates result in 'EPOLLIN' events.
> >
> > Subsequent read()s following a UUID update no longer block, but return
> > the updated UUID. The application needs to acknowledge the UUID update
> > by confirming it through a 'write()'.
> > Only on writing back to the driver the right/latest UUID, will the
> > driver mark this "watcher" as up to date and remove EPOLLIN status.
> >
> > 'mmap()' support allows mapping a single read-only shared page which
> > will always contain the latest UUID value at offset 0.
> 
> It would be nicer if that page just contained an incrementing counter,
> instead of a UUID. It's not like the application cares *what* the UUID
> changed to, just that it *did* change and all RNGs state now needs to
> be reseeded from the kernel, right? And an application can't reliably
> read the entire UUID from the memory mapping anyway, because the VM
> might be forked in the middle.
> 
> So I think your kernel driver should detect UUID changes and then turn
> those into a monotonically incrementing counter. (Probably 64 bits
> wide?) (That's probably also a little bit faster than comparing an
> entire UUID.)

I agree with this. Further, I'm observing there is a very common
confusion between "universally unique" and "random". Randoms are
needed when seeking unpredictability. A random number generator
*must* be able to return the same value multiple times in a row
(though this is rare), otherwise it's not random.

To illustrate this, a die has less than 3 bits of randomness and
is sufficient to play games with friends where a counter would allow
everyone to cheat. Conversely if you want to assign IDs to members
of your family you'd rather use a counter than a die for this or
you risk collisions and/or long series of retries to pick unique
IDs.

RFC4122 explains in great length how to produce guaranteed unique
IDs, and this only involves space, time and counters. There's
indeed a lazy variant that probably everyone uses nowadays,
consisting in picking random numbers, but this is not guaranteed
unique anymore.

If the UUIDs used there are real UUIDs, it could be as simple as
updating them according to their format, i.e. updating the timestamp,
and if the timestamp is already the same, just increase the seq counter.
Doing this doesn't require entropy, doesn't need to block and doesn't
needlessly leak randoms that sometimes make people feel nervous.

Just my two cents,
Willy
