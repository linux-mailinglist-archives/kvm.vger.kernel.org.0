Return-Path: <kvm+bounces-20796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E4E91DF98
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4AA51F22680
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6BD158D9F;
	Mon,  1 Jul 2024 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="V7/LQUFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F411A77115;
	Mon,  1 Jul 2024 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719837712; cv=none; b=Z16S3gSGKtGETCnpHj3VgmDzWhylGfQhCoFg5vb8+xpU50fuPjvDeAzci2oQy1QkTRV/l00gjR6aR4GTweXCF1qR87zUK02QfJLfOpYA+3nCtrL5W8rxJydEmTNUglMRP52F7/lXsmUQMbxG7v2wy2SQRjTJXEmIl7aA/XBllnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719837712; c=relaxed/simple;
	bh=n2Akp2Idb1d0HTDcFmSTnModP6C6eg6G16lrbMqXhiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/GuZf04DBVgxLl7ahxT++TE8IHrrLgfxSmKug0UikEzLR1eKENbqQHg0r5BCD+lbu4d8X9wOhTXoLfmyYiI2uNDIlLyifWTh/RF2sJ92HMmtddUuQ5jVA6wIP50gv6EjN8pEBklsUyAMOXxFOTmRNt16sg1Y7UFvALGd2F0nZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=V7/LQUFu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D19F40E019D;
	Mon,  1 Jul 2024 12:41:47 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id P6SIRr1ORBM5; Mon,  1 Jul 2024 12:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719837703; bh=ZLTDYuOs8tE8GwUaXahINWut6HDEMBxJJps3o6JtEhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V7/LQUFuuOjfu6j/1ZZc7jh2gLHVXg3AT1ZwGGE5EI80fCzLhyILvZ0CO7EbZjvxc
	 PkQfpzypo5F15C//zUTTZmxUz/X7FqFO6zT717Ao6xoNB+ypPyz4lgPCbmsiJZlTdO
	 TO5NK2UiO14upnZjkcFBsDVeUCbg2r564xAY/71T2V6rDtWHjmrfk7Ip2C5KosY8aH
	 dNBrOwae2ny/LSELye6T/ukYY+CrItNupO8LmjEfAm41c8eWlY3phNcwUrGN9+Wv/a
	 OCfLRDQnkAZTQWoF4T2FnyNwGbBKL8vYc/HQaMVKgwAbu5bcWbHcySK4huBYNmSroA
	 QBYfgXFDSYyUmgVb0gpK1ExgHrB4muzAY0Tqe+CJcAQ3WPDwI99fga55YaRzDc5J4C
	 ygpcEloZMhr5zOm6i3F9nszwPqJMTcfVnbBLI56EZS0Wju6JBS8HyJ0sOFPYbnfOJ6
	 kKGW7LPoxbifBZAIlaUL9xK87Lj6waw3yJitmW+Yxk64ROmrRLPrVnzmLrE8hs1B7p
	 9cZaSai+0VaN/DXWN31ldTaaAIBOlGehxxGmfYFc1QnrcvvylLotapmKopl9x5M8Om
	 JEwt0nichrKHYLpRAg4prbhagZtMOm4Oon6lVwcO5PH5vGHRwQt/gyZ0Y0yFQzxXc9
	 z0qru6AHfwltaT0ikiE7xRaI=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4E70440E021E;
	Mon,  1 Jul 2024 12:41:32 +0000 (UTC)
Date: Mon, 1 Jul 2024 14:41:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v10 07/24] virt: sev-guest: Store VMPCK index to SNP
 guest device structure
Message-ID: <20240701124127.GEZoKj952TjNCZ8NiN@fat_crate.local>
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-8-nikunj@amd.com>
 <20240628035217.GAZn4zcWMZy3mgCKky@fat_crate.local>
 <007c2e93-d5cd-7f7e-bd29-bfc0da4c18ba@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <007c2e93-d5cd-7f7e-bd29-bfc0da4c18ba@amd.com>

On Mon, Jul 01, 2024 at 04:15:31PM +0530, Nikunj A. Dadhania wrote:
> In my v8 [1] and earlier series, I had dropped secrets pages pointer from
> snp_guest_dev structure. But with newer changes in v9 secrets pages pointer
> is retained so all these APIs will still be fine. 

So I think you should step back, get a pen and paper and think about the
design of what is going to be exported from sev.c to sev-guest, write it down
and run it by folks first before you go code.

Because right now it feels like a waste of time for everybody involved.
I still have no clue what is going on - just a rough idea.

Also, looking forward:

Subject: [PATCH v10 13/24] x86/sev: Make sev-guest driver functional again

That's a no-no.

You can't have a broken kernel at some point in the patch series. Unless you
can't really avoid it. And I don't think there's a problem here: you define
the interfaces and switch sev-guest to them in one last patch.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

