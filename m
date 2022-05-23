Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B3A5319F2
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiEWRH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 13:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbiEWRHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 13:07:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E48FB6B665
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 10:07:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11D07106F;
        Mon, 23 May 2022 10:07:33 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F19FC3F73D;
        Mon, 23 May 2022 10:07:31 -0700 (PDT)
Date:   Mon, 23 May 2022 18:07:41 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Keir Fraser <keirf@google.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        catalin.marinas@arm.com, kernel-team@android.com
Subject: Re: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
Message-ID: <You/XQP0hc5e9BJd@monolith.localdoman>
References: <20220520143706.550169-1-keirf@google.com>
 <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
 <20220523154249.2fa6db09@donnerap.cambridge.arm.com>
 <Youi7+T1+YG/6ed9@google.com>
 <20220523161323.0e7df3d5@donnerap.cambridge.arm.com>
 <YoutGZHrgweh6pgm@monolith.localdoman>
 <You30lZiaDIlTAsF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <You30lZiaDIlTAsF@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, May 23, 2022 at 04:35:30PM +0000, Keir Fraser wrote:
> On Mon, May 23, 2022 at 04:49:45PM +0100, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, May 23, 2022 at 04:13:23PM +0100, Andre Przywara wrote:
> > > On Mon, 23 May 2022 15:06:23 +0000
> > > Keir Fraser <keirf@google.com> wrote:
> > > 
> > > > On Mon, May 23, 2022 at 03:42:49PM +0100, Andre Przywara wrote:
> > > > > On Fri, 20 May 2022 21:51:07 +0100
> > > > > Will Deacon <will@kernel.org> wrote:
> > > > > 
> > > > > Hi,
> > > > >   
> > > > > > On Fri, 20 May 2022 14:37:04 +0000, Keir Fraser wrote:  
> > > > > > > While playing with kvmtool's virtio_balloon device I found a couple of
> > > > > > > niggling issues with the printing of memory stats. Please consider
> > > > > > > these fairly trivial fixes.  
> > > > > 
> > > > > Unfortunately patch 2/2 breaks compilation on userland with older kernel
> > > > > headers, like Ubuntu 18.04:
> > > > > ...
> > > > >   CC       builtin-stat.o
> > > > > builtin-stat.c: In function 'do_memstat':
> > > > > builtin-stat.c:86:8: error: 'VIRTIO_BALLOON_S_HTLB_PGALLOC' undeclared (first use in this function); did you mean 'VIRTIO_BALLOON_S_AVAIL'?
> > > > >    case VIRTIO_BALLOON_S_HTLB_PGALLOC:
> > > > >         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >         VIRTIO_BALLOON_S_AVAIL
> > > > > (repeated for VIRTIO_BALLOON_S_HTLB_PGFAIL and VIRTIO_BALLOON_S_CACHES).
> > > > > 
> > > > > I don't quite remember what we did here in the past in those cases,
> > > > > conditionally redefine the symbols in a local header, or protect the
> > > > > new code with an #ifdef?  
> > > > 
> > > > For what it's worth, my opinion is that the sensible options are to:
> > > > 1. Build against the latest stable, or a specified version of, kernel
> > > > headers; or 2. Protect with ifdef'ery until new definitions are
> > > > considered "common enough".
> > > > 
> > > > Supporting older headers by grafting or even modifying required newer
> > > > definitions on top seems a horrid middle ground, albeit I can
> > > > appreciate the pragmatism of it.
> > > 
> > > Fair enough, although I don't think option 1) is really viable for users,
> > > as upgrading the distro provided kernel headers is often not an option for
> > > the casual user. And even more versed users would probably shy away from
> > > staining their /usr/include directory just for kvmtool.
> > > 
> > > Which just leaves option 2? If no one hollers, I will send a patch to that
> > > regard.
> > 
> > How about copying the required headers to kvmtool, under include/linux?
> > That would remove any dependency on a specific kernel or distro version.
> 
> Maintaining just the required headers sounds a bit of a pain. Getting

Isn't the Linux mantra "don't break userspace"? So in that case, even if
kvmtool uses an older version of a header, that won't cause any issues,
right?

> it wrong ends up copying too many headers (and there's nearly 200kLOC

We could mandate that the kernel header file is copied only when new
features are added to kvmtool. I don't think there's any need to do it
retroactively.

What do you think?

Thanks,
Alex

> of them) or a confusing split between copied and system-installed
> headers.
> 
> How about requiring headers at include/linux and if the required
> version tag isn't found there, download the kernel tree and "make
> headers_install" with customised INSTALL_HDR_PATH? The cost is a
> big(ish) download: time, bandwidth, disk space.
> 
>  -- Keir
> 
> > Thanks,
> > Alex
> > 
> > > 
> > > Cheers,
> > > Andre
> > > 
> > > 
> > > > 
> > > >  Regards,
> > > >  Keir
> > > > 
> > > > 
> > > > > I would lean towards the former (and hacking this in works), but then we
> > > > > would need to redefine VIRTIO_BALLOON_S_NR, to encompass the new symbols,
> > > > > which sounds fragile.
> > > > > 
> > > > > Happy to send a patch if we agree on an approach.
> > > > > 
> > > > > Cheers,
> > > > > Andre
> > > > >   
> > > > > > > 
> > > > > > > Keir Fraser (2):
> > > > > > >   virtio/balloon: Fix a crash when collecting stats
> > > > > > >   stat: Add descriptions for new virtio_balloon stat types
> > > > > > > 
> > > > > > > [...]    
> > > > > > 
> > > > > > Applied to kvmtool (master), thanks!
> > > > > > 
> > > > > > [1/2] virtio/balloon: Fix a crash when collecting stats
> > > > > >       https://git.kernel.org/will/kvmtool/c/3a13530ae99a
> > > > > > [2/2] stat: Add descriptions for new virtio_balloon stat types
> > > > > >       https://git.kernel.org/will/kvmtool/c/bc77bf49df6e
> > > > > > 
> > > > > > Cheers,  
> > > > >   
> > > 
