Return-Path: <kvm+bounces-55275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD50FB2FA65
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09F01768A5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B92334723;
	Thu, 21 Aug 2025 13:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="g8TqqRXR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00A322524;
	Thu, 21 Aug 2025 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782760; cv=none; b=NjCeUlIIvWd5od/qZM2NmYdTgEkwBYLC+noGodkDGZeoBgWxsmEvVHG4QWTu76T6OoXRsCrnOnNGj8/gGc1A8TbRIvJFXX3/ssrNBO0sySkMmSMJYE1sV/W+go888hwwtutWoxPVuEmIhu6AKRLHp4QSDTdGA8bCYmMCxgFbthA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782760; c=relaxed/simple;
	bh=Rg5a1kJfGoabeZ2AYyBKOqRJiGb41QX8UOGF3Viz9ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=borp+//IVzlXoVc9fvp/XqaYh9SWOZy8snwqcP5IG/b19B6oF366OTGEw8X0chdgZSaGnabrhTZ8ICKV3lCxscAsKGS7t+r3Scli3ZG8/g13o1PwxDXS4fGQhIpptMhGl7v0WyM0+ahqp3Ivzyl6BdMAnUbYKX2h3PRKQDn4jo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=g8TqqRXR; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 09B4040E0286;
	Thu, 21 Aug 2025 13:25:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 2LhyNk0ikMba; Thu, 21 Aug 2025 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755782751; bh=5Lp6My2Nv5fTSYseXVUYjemxdJizOCrp8obIux+qbJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8TqqRXRuU6G/uGOlbh1gNC/Ae+O7WNeabaPx+H+OIhGZV8Vjad5GoROpacKanfxH
	 6udiTJH6yHRR9CoEurfLAgEi/aK84Mz/HQuCMomtyDu6/QRMOrMi6dunYmF7KcVxIh
	 VoOl9iDaXYiY8XaMlFvGygV3Z7msjekWAjVu8qnrXzuIRwhs1yRfQ2/bu0eV5bid5M
	 NtKMh8Hu8mfUoTSfOB4NIX8nZS9XpLOZLSn6zGM5PvXGkmSg9ygf+fLUhvVDLfi07I
	 G9nlbXVzEUXgld6AomqmAOGaOpNRf7sHOuS8Q72g4YrNQa3ce14bjl1vXKtsidiprQ
	 Il4k7P8qS/2JhojTXRb3LNJlEOTLv1kJBYsGlXgAgL8VBR8FnPqmyIdpHccCBce2ru
	 vLhj8+T+aL5UQyWhPJlRvKhq97b4u08EWT88H12mYOYN1KZfG6PalKs9/X+znblwwS
	 6Hpnt2Wmq0Z6KFB/FHjbEJBaqJ7c5YenbEUGTIqCXO4HxLpWY7W6KB4nzH+OES2lTn
	 i1mKDHVghTSP30l51GoakbAAQMPxYHn2GJZLW2qKweihqOp6zoZx+BctnL/uUCUP9x
	 05sbuOgFvfoNovO5XNiKTa33+3W16ldp7EnJ8NpMBMe7A8tYkQGUYnTNGWR0MSxsXG
	 3oQd56hlgXYuJzExmU3eG+R4=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7628140E022E;
	Thu, 21 Aug 2025 13:25:26 +0000 (UTC)
Date: Thu, 21 Aug 2025 15:25:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, vannapurve@google.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, kai.huang@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com,
	Fan Du <fan.du@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>,
	yan.y.zhao@intel.com, chao.gao@intel.com
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Message-ID: <20250821132521.GDaKceQXfEWHVwrlxV@fat_crate.local>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
 <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>

On Thu, Aug 21, 2025 at 10:24:22AM +0300, Adrian Hunter wrote:
> Something like below would work, but doesn't answer Dave's question
> of why not do it in mce_read_aux()

So, let me see what I understand from all this bla: you want to zap the KeyID
from mci_addr because it is completely useless there. So zap it.

You can't make any other changes to mci_addr because that goes to luserspace.

So far so good.

Now, all that other bla leads me to believe that there might be some need to
dump the raw mci_addr value after all.

If so, your patch is not needed.

Which makes me think, all yall folks need to make up your mind here.

And you need to get rid of all that extraneous information in your commit
message:

"Investigation of user space expectations has concluded it..."

No investigation needed - this is exported to userspace so you can't touch it.

The one and only question you need to answer is, do you really need KeyID in
it or not. And whatever you do, once you do it, we're stuck with it because it
goes out to userspace.

Especially if you want this backported to stable.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

