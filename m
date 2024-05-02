Return-Path: <kvm+bounces-16407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4518B9808
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 11:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 625D21F24A0D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 09:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE89B5676F;
	Thu,  2 May 2024 09:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pkUHD+bq"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D675674B
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 09:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714643308; cv=none; b=N270B3K00nYIVVevF07SH4WwoiuNcw2fpFkk0lBP5B1a7j660HG7HNr5ZqEli1Inw2i36Hb8ottVu74I97avOeFOys0Ga+jggpTUHzmeohshS8HAYDBbhQz8JTV/QOesHMtr5a6leHy08eDvX1WqGHnHMR9c057zZiwVbPkuaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714643308; c=relaxed/simple;
	bh=44l1ES/GC41LDaqW/vD4FfplSTIg/yflcuc7Qevpol8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTcJlahheGRfB7oX3wqJEppLRXQvhNvc4GtPDKp9DoH/BpvDC4b8FY6NuyD6aBn0/WQQIiDFtNoNOocFuMsCSIHx8HghnplpSsSKq/Dm8IG57DViT/zGWBVNVEnVIJedIB63jqHdvCelt7TfcsIJVZs+P7LCIlvJfsu6AccaSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pkUHD+bq; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 11:48:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714643304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g3/eCojjRSYbLzKAuE22K9IMO6ejAN3/VhCrjzCXp/4=;
	b=pkUHD+bqL5bTxyAEiymUtrrHtsafL458kL7riaiMWNaNpKJp8qeLE5T1Djat/H7QzZMDgz
	2KopBySDUO/MdCRajPxDaLDZlz/3evpiFdb/WdksTxzqGYJ5d5zyucfrO1ZTQDu8DISl7V
	Ug+9aqtmf3c4wwLpAkp1kouy9QFCqUQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Ricardo Koller <ricarkol@google.com>, rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>, 
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
Message-ID: <20240502-e54e484145fc4c6963a0bdea@orel>
References: <20240501112938.931452-1-npiggin@gmail.com>
 <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
 <20240502-d231f770256b3ed812eb4246@orel>
 <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28975cc5-ef8f-4471-baca-0bb792a62084@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 11:34:24AM GMT, Thomas Huth wrote:
> On 02/05/2024 10.56, Andrew Jones wrote:
> > On Thu, May 02, 2024 at 10:23:22AM GMT, Thomas Huth wrote:
> > > On 01/05/2024 13.29, Nicholas Piggin wrote:
> > > > This is based on upstream directly now, not ahead of the powerpc
> > > > series.
> > > 
> > > Thanks! ... maybe you could also rebase the powerpc series on this now? (I
> > > haven't forgotten about it, just did not find enough spare time for more
> > > reviewing yet)
> > > 
> > > > Since v2:
> > > > - Rebased to upstream with some patches merged.
> > > > - Just a few comment typos and small issues (e.g., quoting
> > > >     `make shellcheck` in docs) that people picked up from the
> > > >     last round.
> > > 
> > > When I now run "make shellcheck", I'm still getting an error:
> > > 
> > > In config.mak line 16:
> > > AR=ar
> > > ^-- SC2209 (warning): Use var=$(command) to assign output (or quote to
> > > assign string).
> > 
> > I didn't see this one when testing. I have shellcheck version 0.9.0.
> 
> I'm also using 0.9.0 (from Fedora). Maybe we've got a different default config?

Yeah, I tested with AArch64, which sets AR to aarch64-linux-gnu-ar. I just
tried x86 and see the warning.

> 
> Anyway, I'm in favor of turning this warning of in the config file, it does
> not seem to be really helpful in my eyes. What do you think?

I agree. The 2209 description says this warning will only appear for
commands that are in a hard coded list, so it's an odd check anyway.

Thanks,
drew

