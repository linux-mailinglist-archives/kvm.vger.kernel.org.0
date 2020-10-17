Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFF29103A
	for <lists+kvm@lfdr.de>; Sat, 17 Oct 2020 08:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437190AbgJQGpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Oct 2020 02:45:21 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:43853 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437182AbgJQGpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Oct 2020 02:45:21 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 09H6ignu014122;
        Sat, 17 Oct 2020 08:44:42 +0200
Date:   Sat, 17 Oct 2020 08:44:42 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jann Horn <jannh@google.com>
Cc:     Colm MacCarthaigh <colmmacc@amazon.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jason Donenfeld <Jason@zx2c4.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:VIRTIO GPU DRIVER" 
        <virtualization@lists.linux-foundation.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, bonzini@gnu.org,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>, oridgar@gmail.com,
        ghammer@redhat.com, Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] drivers/virt: vmgenid: add vm generation id driver
Message-ID: <20201017064442.GA14117@1wt.eu>
References: <788878CE-2578-4991-A5A6-669DCABAC2F2@amazon.com>
 <CAG48ez0EanBvDyfthe+hAP0OC8iGLNSq2e5wJVz-=ENNGF97_w@mail.gmail.com>
 <20201017033606.GA14014@1wt.eu>
 <CAG48ez0x2S9XuCrANAQbXNi8Jjwm822-fnQSmr-Zr07JgrEs1g@mail.gmail.com>
 <6CC3DB03-27BA-4F5E-8ADA-BE605D83A85C@amazon.com>
 <CAG48ez1ZtvjOs2CEq8-EMosPCd_o7WQ3Mz_+1mDe7OrH2arxFA@mail.gmail.com>
 <20201017053712.GA14105@1wt.eu>
 <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1h0ynXfGap_KiHiPVTfcB8NBQJ-2dnj08ZNfuhrW0jWA@mail.gmail.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 17, 2020 at 07:52:48AM +0200, Jann Horn wrote:
> On Sat, Oct 17, 2020 at 7:37 AM Willy Tarreau <w@1wt.eu> wrote:
> > On Sat, Oct 17, 2020 at 07:01:31AM +0200, Jann Horn wrote:
> > > Microsoft's documentation
> > > (http://go.microsoft.com/fwlink/?LinkId=260709) says that the VM
> > > Generation ID that we get after a fork "is a 128-bit,
> > > cryptographically random integer value". If multiple people use the
> > > same image, it guarantees that each use of the image gets its own,
> > > fresh ID:
> >
> > No. It cannot be more unique than the source that feeds that cryptographic
> > transformation. All it guarantees is that the entropy source is protected
> > from being guessed based on the output. Applying cryptography on a simple
> > counter provides apparently random numbers that will be unique for a long
> > period for the same source, but as soon as you duplicate that code between
> > users and they start from the same counter they'll get the same IDs.
> >
> > This is why I think that using a counter is better if you really need something
> > unique. Randoms only reduce predictability which helps avoiding collisions.
> 
> Microsoft's spec tells us that they're giving us cryptographically
> random numbers. Where they're getting those from is not our problem.
> (And if even the hypervisor is not able to collect enough entropy to
> securely generate random numbers, worrying about RNG reseeding in the
> guest would be kinda pointless, we'd be fairly screwed anyway.)

Sorry if I sound annoying, but it's a matter of terminology and needs.

Cryptograhically random means safe for use with cryptography in that it
is unguessable enough so that you can use it for encryption keys that
nobody will be able to guess. It in no ways guarantees uniqueness, just
like you don't really care if the symmetric crypto key of you VPN has
already been used once somewhere else as long as there's no way to know.
However with the good enough distribution that a CSPRNG provides,
collisions within a *same* generator are bound to a very low, predictable
rate which is by generally considered as acceptable for all use cases.

Something random (cryptographically or not) *cannot* be unique by
definition, otherwise it's not random anymore, since each draw has an
influence on the remaining list of possible draws, which is contrary to
randomness. And conversely something unique cannot be completely random
because if you know it's unique, you can already rule out all other known
values from the candidates, thus it's more predictable than random.

With this in mind, picking randoms from a same RNG is often highly
sufficient to consider they're highly likely unique within a long
period. But it's not a guarantee. And it's even less one between two
RNGs (e.g. if uniqueness is required between multiple hypervisors in
case VMs are migrated or centrally managed, which I don't know).

If what is sought here is a strong guarantee of uniqueness, using a
counter as you first suggested is better. If what is sought is pure
randomness (in the sense that it's unpredictable, which I don't think
is needed here), then randoms are better. If both are required, just
concatenate a counter and a random. And if you need them to be spatially
unique, just include a node identifier.

Now the initial needs in the forwarded message are not entirely clear
to me but I wanted to rule out the apparent mismatch between the expressed
needs for uniqueness and the proposed solutions solely based on randomness.

Cheers,
Willy
