Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3798357316C
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 10:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiGMIqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbiGMIp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 04:45:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BE9BCAF22
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 01:45:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CC4C1424;
        Wed, 13 Jul 2022 01:45:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D6BD83F792;
        Wed, 13 Jul 2022 01:45:56 -0700 (PDT)
Date:   Wed, 13 Jul 2022 09:46:27 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 25/27] arm64: Add support for efi in
 Makefile
Message-ID: <Ys6GVrYLpM8Yu2Ip@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-26-nikos.nikoleris@arm.com>
 <Ys15pk9rhYr3BS7i@monolith.localdoman>
 <7e3810f6-5fc9-3a29-71c7-1610b8300c1e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e3810f6-5fc9-3a29-71c7-1610b8300c1e@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Jul 12, 2022 at 09:50:51PM +0100, Nikos Nikoleris wrote:
> Hi Alex,
> 
> On 12/07/2022 14:39, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Thu, Jun 30, 2022 at 11:03:22AM +0100, Nikos Nikoleris wrote:
> > > Users can now build kvm-unit-tests as efi apps by supplying an extra
> > > argument when invoking configure:
> > > 
> > > $> ./configure --enable-efi
> > > 
> > > This patch is based on an earlier version by
> > > Andrew Jones <drjones@redhat.com>
> > > 
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >   configure           | 15 ++++++++++++---
> > >   arm/Makefile.arm    |  6 ++++++
> > >   arm/Makefile.arm64  | 18 ++++++++++++++----
> > >   arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
> > >   4 files changed, 66 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/configure b/configure
> > > index 5b7daac..2ff9881 100755
> > > --- a/configure
> > > +++ b/configure
> > [..]
> > > @@ -218,6 +223,10 @@ else
> > >           echo "arm64 doesn't support page size of $page_size"
> > >           usage
> > >       fi
> > > +    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> > > +        echo "efi must use 4K pages"
> > > +        exit 1
> > 
> > Why this restriction?
> > 
> > The Makefile compiles kvm-unit-tests to run as an UEFI app, it doesn't
> > compile UEFI itself. As far as I can tell, UEFI is designed to run payloads
> > with larger page size (it would be pretty silly to not be able to boot a
> > kernel built for 16k or 64k pages with UEFI).
> > 
> > Is there some limitation that I'm missing?
> > 
> 
> Technically, we could allow 16k or 64k granules. But to do that we would
> have to handle cases where the memory map we get from EFI cannot be remapped
> with the new granules. For example, a region might be 12kB and mapping it
> with 16k or 64k granules without moving it is impossible.

Hm... From UEFI Specification, Version 2.8, page 35:

"The ARM architecture allows mapping pages at a variety of granularities,
including 4KiB and 64KiB. If a 64KiB physical page contains any 4KiB page
with any of the following types listed below, then all 4KiB pages in the
64KiB page must use identical ARM Memory Page Attributes (as described in
Table 7):

— EfiRuntimeServicesCode
— EfiRuntimeServicesData
— EfiReserved
— EfiACPIMemoryNVS

Mixed attribute mappings within a larger page are not allowed.

Note: This constraint allows a 64K paged based Operating System to safely
map runtime services memory."

Looking at Table 30. Memory Type Usage after ExitBootServices(), on page
160 (I am going to assume that EfiReservedMemoryType is the same as
EfiReserved), the only region that is required to be mapped for runtime
services, but isn't mentioned above, is EfiPalCode. The bit about mixed
attribute mappings within a larger page not being allowed makes me think
that EfiPalCode can be mapped even if isn't mapped at the start of a 64KiB
page, as no other memory type can be withing a 64KiB granule. What do you
think?

There's no pressing need to have support for all page sizes, from my point
of view, it's fine if it's missing from the initial UEFI support. But I
would appreciate a comment in the code or an explanation in the commit
message (or both), because it looks very arbitrary as it is right now. At
the very least this will serve as a nice reminder of what still needs to be
done for full UEFI support.

Thanks,
Alex

> 
> Thanks,
> 
> Nikos
> 
> > Thanks,
> > Alex
