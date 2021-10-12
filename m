Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364E142A716
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 16:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhJLOYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 10:24:31 -0400
Received: from foss.arm.com ([217.140.110.172]:44944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhJLOYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 10:24:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C19CCED1;
        Tue, 12 Oct 2021 07:22:28 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB6D53F66F;
        Tue, 12 Oct 2021 07:22:27 -0700 (PDT)
Date:   Tue, 12 Oct 2021 15:24:00 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: Re: [PATCH kvmtool 08/10] Add --nocompat option to disable compat
 warnings
Message-ID: <YWWagPVuugVaTD59@monolith.localdoman>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
 <20210923144505.60776-9-alexandru.elisei@arm.com>
 <20211012083452.GC5156@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012083452.GC5156@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Tue, Oct 12, 2021 at 09:34:53AM +0100, Will Deacon wrote:
> On Thu, Sep 23, 2021 at 03:45:03PM +0100, Alexandru Elisei wrote:
> > Commit e66942073035 ("kvm tools: Guest kernel compatability") added the
> > functionality that enables devices to print a warning message if the device
> > hasn't been initialized by the time the VM is destroyed. The purpose of
> > these messages is to let the user know if the kernel hasn't been built with
> > the correct Kconfig options to take advantage of the said devices (all
> > using virtio).
> > 
> > Since then, kvmtool has evolved and now supports loading different payloads
> > (like firmware images), and having those warnings even when it is entirely
> > intentional for the payload not to touch the devices can be confusing for
> > the user and makes the output unnecessarily verbose in those cases.
> > 
> > Add the --nocompat option to disable the warnings; the warnings are still
> > enabled by default.
> > 
> > Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  builtin-run.c            | 5 ++++-
> >  guest_compat.c           | 1 +
> >  include/kvm/kvm-config.h | 1 +
> >  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> Sorry, bikeshed moment here, but why don't we just have a '--quiet' option
> that shuts everything up unless it's fatal?

I can't figure out what is the criteria for deciding what is silenced by --quiet
and what is still shown. I chose --nocompat because it is clear what is supposed
to disable.

One possibility would be to hide pr_info() and the compat warnings. But that
still doesn't feel right to me - why hide *only* the compat warnings and leave
the other warnings unchanged? I could see having a --nocompat that hides the
compat warningis *and* a quiet option that hides pr_info() output (grepping for
pr_info reveals a number of places where it is used).

What do you think? Do you have something else in mind?

Thanks,
Alex

> 
> Will
