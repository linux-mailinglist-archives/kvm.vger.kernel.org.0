Return-Path: <kvm+bounces-8802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90664856917
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D31028B2F3
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7FB134CE7;
	Thu, 15 Feb 2024 16:06:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9508129A9D
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013165; cv=none; b=DEPLmpKhGdB6LNR0KFvkWu+MWSa0bTUrTATZvY/hcfJWZAFMM3JJmEK7CBrV/sTtwKCPN83PRNg9/61vijM64a+9VZuRe2bPOnXql6lAewsDU76lwIOs3hLgrqvIBJQcxb+47mD2Ay0bAmNUZWe0zMBZ7UpOxIPXzLP4fZiLLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013165; c=relaxed/simple;
	bh=XaPBG0pjaE8UAvSa1cvBd8Q5DWmnq3k42psc6vJNDYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vB+7Le3kSXj55lpKkVTjfn8FpbyKD7WE5pncbBbPhRmncEm9MoPG7dxoOjV9qRDHXrv92GzrQ1xJhVrD7FXWw9XQK7aTDmJyFp/REnA+bnoANvu68UndokviCM6kWXcW/B5DwiTHrR/2ZK/S8ETvf76kmmBNeb/6UGf9UgzNgMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 164911FB;
	Thu, 15 Feb 2024 08:06:43 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5BBA3F766;
	Thu, 15 Feb 2024 08:05:59 -0800 (PST)
Date: Thu, 15 Feb 2024 16:05:56 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Nico Boehr <nrb@linux.ibm.com>, David Woodhouse <dwmw@amazon.co.uk>,
	Nadav Amit <namit@vmware.com>, kvm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH v1 01/18] Makefile: Define __ASSEMBLY__
 for assembly files
Message-ID: <Zc42ZJYMFpXpM4mD@raptor>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <20231130090722.2897974-2-shahuang@redhat.com>
 <20240115-0c41f7d4aa09b7b82613faa8@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115-0c41f7d4aa09b7b82613faa8@orel>

Hi Drew,

On Mon, Jan 15, 2024 at 01:44:17PM +0100, Andrew Jones wrote:
> On Thu, Nov 30, 2023 at 04:07:03AM -0500, Shaoqin Huang wrote:
> > From: Alexandru Elisei <alexandru.elisei@arm.com>
> > 
> > There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> > with functionality relies on the __ASSEMBLY__ prepocessor constant being
> > correctly defined to work correctly. So far, kvm-unit-tests has relied on
> > the assembly files to define the constant before including any header
> > files which depend on it.
> > 
> > Let's make sure that nobody gets this wrong and define it as a compiler
> > constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> > .S files, even those that didn't set it explicitely before.
> > 
> > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  Makefile           | 5 ++++-
> >  arm/cstart.S       | 1 -
> >  arm/cstart64.S     | 1 -
> >  powerpc/cstart64.S | 1 -
> >  4 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 602910dd..27ed14e6 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> >  
> >  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
> >  
> > +AFLAGS  = $(CFLAGS)
> > +AFLAGS += -D__ASSEMBLY__
> > +
> >  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
> >  
> >  $(libcflat): $(cflatobjs)
> > @@ -113,7 +116,7 @@ directories:
> >  	@mkdir -p $(OBJDIRS)
> >  
> >  %.o: %.S
> > -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> > +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<
> 
> I think we can drop the two hunks above from this patch and just rely on
> the compiler to add __ASSEMBLY__ for us when compiling assembly files.

I think the precompiler adds __ASSEMBLER__, not __ASSEMBLY__ [1]. Am I
missing something?

[1] https://gcc.gnu.org/onlinedocs/cpp/macros/predefined-macros.html#c.__ASSEMBLER__

Thanks,
Alex

> 
> Thanks,
> drew
> 
> >  
> >  -include */.*.d */*/.*.d
> >  
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index 3dd71ed9..b24ecabc 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -5,7 +5,6 @@
> >   *
> >   * This work is licensed under the terms of the GNU LGPL, version 2.
> >   */
> > -#define __ASSEMBLY__
> >  #include <auxinfo.h>
> >  #include <asm/assembler.h>
> >  #include <asm/thread_info.h>
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index bc2be45a..a8ad6dc8 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -5,7 +5,6 @@
> >   *
> >   * This work is licensed under the terms of the GNU GPL, version 2.
> >   */
> > -#define __ASSEMBLY__
> >  #include <auxinfo.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/assembler.h>
> > diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> > index 34e39341..fa32ef24 100644
> > --- a/powerpc/cstart64.S
> > +++ b/powerpc/cstart64.S
> > @@ -5,7 +5,6 @@
> >   *
> >   * This work is licensed under the terms of the GNU LGPL, version 2.
> >   */
> > -#define __ASSEMBLY__
> >  #include <asm/hcall.h>
> >  #include <asm/ppc_asm.h>
> >  #include <asm/rtas.h>
> > -- 
> > 2.40.1
> > 

