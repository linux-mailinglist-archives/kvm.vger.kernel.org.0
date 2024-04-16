Return-Path: <kvm+bounces-14745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A1B8A66BA
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87B7C1C221DC
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C52284DE4;
	Tue, 16 Apr 2024 09:07:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8392205E10;
	Tue, 16 Apr 2024 09:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713258444; cv=none; b=N3mctHES3loc/bbPZWsW4QEmLkbX8d80DmPNZNqYuzB7GM5IU2puXN/IwBvZGLrmuhXD7XGqrNZefGjS7P8wg5YLiQ+TxatHpBzakbA38DRHbq4SdTaAarQ2fxp/zVqTwl7uDl6WF4F7razPg2RpQXenzDJEShZiWj6YkM7vQJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713258444; c=relaxed/simple;
	bh=97ik4e/S5ukhXV777YOpud/igojzwgRb194g8vhMsqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q2Tu36j2HJa3KMeIste1GdSB4ZRIHWS//xetW+cWmBUGjlYDkAnpZJqNfSysg55/uRQ1SvG8HqtEhjrpkNIKchCDx5ZGdPh3E+/zYIcF4bIWz8G3soX22h6DfExqJoCFBtr7SWnTLPHl4uvHi16736p2BP7aDb/yV0MUhMeOEfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5957B40E024C;
	Tue, 16 Apr 2024 09:07:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rbVODRSbSlku; Tue, 16 Apr 2024 09:07:15 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BBDC740E00B2;
	Tue, 16 Apr 2024 09:07:03 +0000 (UTC)
Date: Tue, 16 Apr 2024 11:06:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 04/16] virt: sev-guest: Add vmpck_id to snp_guest_dev
 struct
Message-ID: <20240416090658.GBZh4_sj7ursRtzijI@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-5-nikunj@amd.com>
 <20240409102348.GBZhUXND0CDk7tGv8a@fat_crate.local>
 <74f17321-42ed-417c-ad24-8bc4e7207117@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <74f17321-42ed-417c-ad24-8bc4e7207117@amd.com>

On Tue, Apr 16, 2024 at 11:27:24AM +0530, Nikunj A. Dadhania wrote:
> > Why does that snp_get_os_area_msg_seqno() returns a pointer when you
> > deref it here again?
> > 
> > A function which returns a sequence number should return that number
> > - not a pointer to it.
> > 
> > Which then makes that u32 *os_area_msg_seqno redundant and you can use
> > the function directly.
> > 
> > IOW:
> > 
> > static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
> > {
> >         return snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
> 
> This patch removes setting of layour page in snp_dev structure.

So?

> static inline u32 snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
> {
>         if (!platform_data)
>                 return NULL;
> 
>         return *(&platform_data->layout->os_area.msg_seqno_0 + vmpck_id);
> }

What?!

This snp_get_os_area_msg_seqno() is a new function added by this patch.

> I had a getter for getting the os_area_msg_seqno pointer, probably not
> a good function name.

Probably you need to go back to the drawing board and think about how
this thing should look like.

> > Do you see the imbalance in the APIs?
> 
> The msg_seqno should only be incremented by 2 (always), that was the reason to avoid a setter.

And what's wrong with the setter doing the incrementation so that
callers can't even get it wrong?

It sounds to me like you should redesign this sequence number handling
in a *separate* patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

