Return-Path: <kvm+bounces-47851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 125A2AC6330
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9DDD16CD64
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 07:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6462459C4;
	Wed, 28 May 2025 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rr4la10C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BFF244678
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748417917; cv=none; b=HRp4G5oa825dfbuneEGtYNwA2X/7GblbQiXf0IBiGTfNPK50OOALsWe76uNWB6QxV5V5pxMvnp6/adSqPnXhH+k5TQT7ZA/76RA6sTqoVbghqZfCygDerYm9iXfmyiRwWMX75dpqQwdem54J8BLcLzC3jkv8COfJXLx43aXdvk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748417917; c=relaxed/simple;
	bh=EH+F4iRJI7anYHX3NynlYUSDaVIlMgqBZ6Ur6WFXNAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YrdT7rsBRrPdWeuliMV68rxUDrKkTG2z43njVCiZfbmoE9fnLzSqc78aU+VzRESuklkBLs8g5u280pP9SiNvW7T5afc5GPcf8ew1Sd9CIkftj0/SBrEKA4H4JBhcN2Vc4adsiZ7yWnYwrFtfwC/DK+MGLI3fNksWxN4r9z/nxmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rr4la10C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748417914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nIttIbYMTmu8/eguOayC3dSJD20KFYU/EvDlBxz1bX8=;
	b=Rr4la10CtJneAF19D8vtUN4PLCnI9xIN9Bk4//BRlDMOGhcs4KTG7DJNO3yII+IXPpFqfS
	l8uSeSdugvqsqI+uk+N+T5FGHvQJ9PKFmYDKMWyLowLO86BhcXXWItPxXIwMViCzHlupAx
	DmKrFYEE1LSKbOd2fQDuC0Sg/qUqgPU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-qlHoU7GUPsGgzsvwWcraWw-1; Wed,
 28 May 2025 03:38:31 -0400
X-MC-Unique: qlHoU7GUPsGgzsvwWcraWw-1
X-Mimecast-MFC-AGG-ID: qlHoU7GUPsGgzsvwWcraWw_1748417909
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EC6A1956086;
	Wed, 28 May 2025 07:38:28 +0000 (UTC)
Received: from dobby.home.kraxel.org (unknown [10.45.224.91])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07335180049D;
	Wed, 28 May 2025 07:38:27 +0000 (UTC)
Received: by dobby.home.kraxel.org (Postfix, from userid 1000)
	id D532F4507BC; Wed, 28 May 2025 09:38:24 +0200 (CEST)
Date: Wed, 28 May 2025 09:38:24 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <77hywpberfkulac3q3hpupdmdpw2xbmlvzin4ks7xypikravkj@xjpi7gqscs6a>
References: <20250527144546.42981-1-kraxel@redhat.com>
 <20250527162151.GAaDXmn8O3f_HYgRju@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527162151.GAaDXmn8O3f_HYgRju@fat_crate.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, May 27, 2025 at 06:21:51PM +0200, Borislav Petkov wrote:
> On Tue, May 27, 2025 at 04:45:44PM +0200, Gerd Hoffmann wrote:
> > In case efi_mm is active go use the userspace instruction decoder which
> > supports fetching instructions from active_mm.  This is needed to make
> > instruction emulation work for EFI runtime code, so it can use cpuid
> > and rdmsr.
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >  arch/x86/coco/sev/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Can you pls explain what the use cases for this and your next patch are?

Use case is coconut-svsm providing an uefi variable store and edk2
runtime code doing svsm protocol calls to send requests to the svsm
variable store.  edk2 needs a caa page mapping and a working rdmsr
instruction for that.

Another less critical but useful case is edk2 debug logging to qemu
debugcon port.  That needs a working cpuid instruction because edk2
uses that to figure whenever sev is active and adapt ioport access
accordingly.

> We'd like to add them to our test pile.

That is a bit difficult right now because there are a number of pieces
which need to fall into place before this is easily testable.  You need:

 * host kernel with vmplanes patch series (for snp vmpl support).
 * coconut svsm with uefi variable store patches.
 * edk2 patches so it talks to svsm for variable access.
 * igvm support patches for qemu.

Hope I didn't forgot something ...

take care,
  Gerd


