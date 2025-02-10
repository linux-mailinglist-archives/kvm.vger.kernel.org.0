Return-Path: <kvm+bounces-37694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E76A2EF05
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 14:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 714BA1651C6
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 13:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FB014B08C;
	Mon, 10 Feb 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dIuJ8mBP"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923DD23099D
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739195808; cv=none; b=CuX22JceH42X43F7TY6YhLxlX6qLxK9XPnbPc06B+gFjbfcFRV42bN4fKK9Bdpv4oP2NtEwDW7vmp5hCHQt3dEl3VRrOlpPL+dC/ULXk21Rb38ve48rLfnGc9+Th+iZxV3AfuY6lUfihg1oY+ASMKiAZDSDindvlFwP7L5l4Kiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739195808; c=relaxed/simple;
	bh=L3c+pkpXw+gXIF9C7FZIKafYnFt2uPDJMIqArs/uIoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZzDriZnEPNWdzG0BnD2mKxiDXOBF0hM+cvNYGqTszEdN/eT8hIeUFiCqtVfIQeTARrB4za6M0vAJKGtZ+AyKGTBQZDti6AEuzwrivVxAsDyNvxIzLEPPJnQKm6Agf1KOW+j+TfXNjtMuwc7dvCThRMm0oIsS0R09ZTBEkbi7RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dIuJ8mBP; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 10 Feb 2025 14:56:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739195793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6QxzYCLsT1iF2vEH4te1D9LwJ9LeHeBIIOwbWx7d42w=;
	b=dIuJ8mBPN9XRylpd0pPPFZlnRPzIyaQDOvW0+7vWIUtPOd2ArfJa0ls/kBVEdV/3K7OzxY
	+z4sIcp3tfj6ipAoTidGAq1+R2gNDZyi7Hqj9GfQB/u73/sfLMykVg9BonbVXgeJjsK9Ck
	4n33sBQo2Qlb3R1Ld27i0JM9Q6o2hus=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, joey.gouly@arm.com, 
	andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/18] scripts: Refuse to run the tests
 if not configured for qemu
Message-ID: <20250210-640ff37c16a0dbccb69f08ea@orel>
References: <20250120164316.31473-1-alexandru.elisei@arm.com>
 <20250120164316.31473-4-alexandru.elisei@arm.com>
 <20250121-45faf6a9a9681c7c9ece5f44@orel>
 <Z6nX8YC8ZX9jFiLb@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6nX8YC8ZX9jFiLb@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 10, 2025 at 10:41:53AM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Tue, Jan 21, 2025 at 03:48:55PM +0100, Andrew Jones wrote:
> > On Mon, Jan 20, 2025 at 04:43:01PM +0000, Alexandru Elisei wrote:
> <snip>
> > > ---
> > >  arm/efi/run             | 8 ++++++++
> > >  arm/run                 | 9 +++++++++
> > >  run_tests.sh            | 8 ++++++++
> > >  scripts/mkstandalone.sh | 8 ++++++++
> > >  4 files changed, 33 insertions(+)
> <snip>
> > > +case "$TARGET" in
> > > +qemu)
> > > +    ;;
> > > +*)
> > > +    echo "'$TARGET' not supported for standlone tests"
> > > +    exit 2
> > > +esac
> > 
> > I think we could put the check in a function in scripts/arch-run.bash and
> > just use the same error message for all cases.
> 
> Coming back to the series.
> 
> arm/efi/run and arm/run source scripts/arch-run.bash; run_tests.sh and
> scripts/mkstandalone.sh don't source scripts/arch-run.bash. There doesn't
> seem to be a common file that is sourced by all of them.

scripts/mkstandalone.sh uses arch-run.bash, see generate_test().
run_tests.sh doesn't, but I'm not sure it needs to validate TARGET
since it can leave that to the lower-level scripts.

> 
> How about creating a new file in scripts (vmm.bash?) with only this
> function?

If we need a new file, then we can add one, but I'd try using
arch-run.bash or common.bash first.

Thanks,
drew

