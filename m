Return-Path: <kvm+bounces-48159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CB6ACAC3A
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 322407A6A37
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C843E1F8751;
	Mon,  2 Jun 2025 10:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ehp23+Sj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAAE1DD889
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748858706; cv=none; b=acCupABf7C3RBzMEj2PBVc5X6YQpKs/ViIg8JdF+6lbRxxZojFZ+NZAV66436ePnAslNALvvG3U2XQzYI7NQMiGjD7TMYhjRj4b1v+xikeX2EZmmAlP0KfWIdpzIJoKiaHrHbAkGxm2DLlB3/0jrOzXLJw8nkPznrZrFN28KO2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748858706; c=relaxed/simple;
	bh=Bk83LNbALxmPewRbnvWWB1M1iYIqeINndHZy9xJXc2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBH3newh8kzKWNgp3qElybv02Pjti1UMN9asf6BbXEfkAT9rU6ayYCXLgf/5q/I0K7OqHSaR1Dva31ErWppH9O5ceN+N7ZRWRenJ/rYFAWry1XhJU/tB4btw/0hA29BsQxnSnKZMun+VMK9mLiMeXydFx/uSNiElJIz6BOEQG4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ehp23+Sj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748858703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fep9/GB0cJfqKQgmfJB5i+bPko2YtosdytfWWu6bHc0=;
	b=Ehp23+SjjuDmf1yLykzad/dv6dMrfffR3WYhsBGK4L4WAtF1ZQx10oihiQYPanamYay1QR
	+zh9Dz2tjkt0e9kXgmc6VrCN8T5dxFg7nnc/Smcnxlzy9PmAZ1Z3uMmotJMVeO6jfT3L5W
	7tq0QdXrptQFHo4aZDD163R/8kPUBBw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-_suG_kkxPXeNbI9vYQ_TtQ-1; Mon,
 02 Jun 2025 06:05:00 -0400
X-MC-Unique: _suG_kkxPXeNbI9vYQ_TtQ-1
X-Mimecast-MFC-AGG-ID: _suG_kkxPXeNbI9vYQ_TtQ_1748858698
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFA7F18003FC;
	Mon,  2 Jun 2025 10:04:57 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.45.224.29])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA4DB19560A3;
	Mon,  2 Jun 2025 10:04:56 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 0A07C1800609; Mon, 02 Jun 2025 12:04:54 +0200 (CEST)
Date: Mon, 2 Jun 2025 12:04:53 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/sev/vc: fix efi runtime instruction emulation
Message-ID: <763uanqowqaxiv3dzi7kndwpd3s2fxa3sm2fruynqsj5elld2e@lxk7v7bksyjw>
References: <20250527144546.42981-1-kraxel@redhat.com>
 <20250527162151.GAaDXmn8O3f_HYgRju@fat_crate.local>
 <77hywpberfkulac3q3hpupdmdpw2xbmlvzin4ks7xypikravkj@xjpi7gqscs6a>
 <20250529230233.GEaDjniaXGlxAU0NzA@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529230233.GEaDjniaXGlxAU0NzA@fat_crate.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, May 30, 2025 at 01:02:33AM +0200, Borislav Petkov wrote:
> On Wed, May 28, 2025 at 09:38:24AM +0200, Gerd Hoffmann wrote:
> > Use case is coconut-svsm providing an uefi variable store and edk2
> > runtime code doing svsm protocol calls to send requests to the svsm
> > variable store.  edk2 needs a caa page mapping and a working rdmsr
> > instruction for that.
> > 
> > Another less critical but useful case is edk2 debug logging to qemu
> > debugcon port.  That needs a working cpuid instruction because edk2
> > uses that to figure whenever sev is active and adapt ioport access
> > accordingly.
> 
> Yeah, I'd like for those justifications be in the commit messages please.

Ok

> > > We'd like to add them to our test pile.
> > 
> > That is a bit difficult right now because there are a number of pieces
> > which need to fall into place before this is easily testable.  You need:
> > 
> >  * host kernel with vmplanes patch series (for snp vmpl support).
> >  * coconut svsm with uefi variable store patches.
> >  * edk2 patches so it talks to svsm for variable access.
> >  * igvm support patches for qemu.
> > 
> > Hope I didn't forgot something ...
> 
> So why are you sending those for the kernel now is so many other things are
> still moving?
> 
> What if something in those things change? Then you need to touch those
> again...

Well, the need for instruction emulation to work for uefi runtime code
and the need to have access to the caa page is not going to change even
if details of edk2 <=> svsm protocol communication will be updated.

take care,
  Gerd


