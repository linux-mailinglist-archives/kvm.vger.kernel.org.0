Return-Path: <kvm+bounces-51085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0732AED81D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDE6E7A2650
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F832253AB;
	Mon, 30 Jun 2025 09:04:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BBA211CAF
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751274246; cv=none; b=Fv/r08kcSiBDWRfML1rE6T+k54KZOmPia0B9Ssx1eU+0q8UZiTQsMcVOu2um75RuBbpzssG0c0EcG2yvq9lZmbVAuqxW5wBnAGOdKisnfSm1VSejUTeupgbirgQmEzDdjt2rx/f9Ew1ljfKkwLIjDYzZoQrVSHiwWb6KR/a0AiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751274246; c=relaxed/simple;
	bh=tmYe6xCNZobdziWAbRNdGh6HEhuJxkehlrmqbtkXiGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzziN8nVNVc1uansd0vty8bY+4owk6n0zI+QKO4ualpgF0rMdKqZyp1iGjgGX5Ca7POV22QEjcCBNEVhMcvEPDIIiQTUA19XdHfTBMi2FcvZ0lIdzEUaFi9xK6AYfE/w+HIhWU0kTS+nyrkrRoLKT4navrs6H6ByuVOZKjDOu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D2571D34;
	Mon, 30 Jun 2025 02:03:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A3143F6A8;
	Mon, 30 Jun 2025 02:04:03 -0700 (PDT)
Date: Mon, 30 Jun 2025 10:04:00 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com
Cc: kvm@vger.kernel.org, thomas.perale@mind.be
Subject: Re: [PATCH kvmtool] vfio: include libgen.h (for musl compatibility)
Message-ID: <aGJTAC-qDsYzPygS@raptor>
References: <20250629202221.893360-1-thomas.perale@mind.be>
 <aGJSwh8CqUUF2CgZ@raptor>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aGJSwh8CqUUF2CgZ@raptor>

Hi,

Adding the maintainers.

On Mon, Jun 30, 2025 at 10:02:58AM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Sun, Jun 29, 2025 at 10:22:21PM +0200, Thomas Perale wrote:
> > Starting GCC14 'implicit-function-declaration' are treated as errors by
> > default. When building kvmtool with musl libc, the following error
> > occurs due to missing declaration of 'basename':
> > 
> > vfio/core.c:537:22: error: implicit declaration of function ‘basename’ [-Wimplicit-function-declaration]
> >   537 |         group_name = basename(group_path);
> >       |                      ^~~~~~~~
> > vfio/core.c:537:22: warning: nested extern declaration of ‘basename’ [-Wnested-externs]
> > vfio/core.c:537:20: error: assignment to ‘char *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
> >   537 |         group_name = basename(group_path);
> >       |                    ^
> > 
> > This patch fixes the issue by including the appropriate header, ensuring
> > compatibility with musl and GCC14.
> > 
> > Signed-off-by: Thomas Perale <thomas.perale@mind.be>
> > Signed-off-by: Thomas Perale <perale.thomas@gmail.com>
> > ---
> >  vfio/core.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/vfio/core.c b/vfio/core.c
> > index 3ff2c0b..8f88489 100644
> > --- a/vfio/core.c
> > +++ b/vfio/core.c
> > @@ -3,6 +3,7 @@
> >  #include "kvm/ioport.h"
> >  
> >  #include <linux/list.h>
> > +#include <libgen.h>
> 
> Looking at man 3 basename, there are two version of basename, one is the POSIX
> version (this is the one you get by including libgen.h), the other one is the
> GNU version.  I don't think kvmtool cares about the differences (group_path is
> never '/', and it's not a static string), so if the POSIX version makes
> compilation with musl possible:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Also checked that this is the only occurence of basename in the sources.
> 
> Thanks,
> Alex
> 
> >  
> >  #define VFIO_DEV_DIR		"/dev/vfio"
> >  #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
> > -- 
> > 2.50.0
> > 
> > 
> 

