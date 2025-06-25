Return-Path: <kvm+bounces-50683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16347AE84A6
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 998D71896ACC
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 13:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916DE25EF9F;
	Wed, 25 Jun 2025 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuWzZJeN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1588026529A
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750857720; cv=none; b=bLUCJWZfxtzyrfKFrC2qpzaJULChQP95pEtXh6zfLOFP6R/64Zpsjgi0f+ycB67LPpwYvvn11QWMYOofe67+2fPTEzZ9zS8mtBanJxWXDGR4Z2sAym2BExH3kx/PrDrRZTznLFy8g0JAyANrmJr6ccKby/b95hjYB0g6o71mwfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750857720; c=relaxed/simple;
	bh=1Q/pAr4sY9lLv5EGc/bvaQUMj8H/x06Su0+uEZZPQXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REaatnQhHS0rHZoAHHClZD12N1k+FNrRnFq9cQYFYW73DYkWF2XFCjo/LAIDwm6gZrQCzCnkhNkpRCCmulXh0l/TPIhw2VKPwLMc6cAkGT4ne80FqDyR0RooC/zO5aEfyZEeffbxeoMKS4ZL0h3leXmrMeCAHEtg3HgNxKR9nEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UuWzZJeN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750857718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EMRp8rT+/1qIGfANxZLNkeUT+Jcn0lDcU42QUGT4t1Y=;
	b=UuWzZJeNOHQ6OnX1QKYkdVaD4kCW5GqyeTr8eA99CyPnLQLh6+ixCfB/cSq9ce4yhCzyVB
	6Wx7deoPoriT2PI8Np1fvHGfLAv3nU6xyN8wWAscxWfI/1BFsxuSiopCcnZSGzYsrCXXkB
	h8/HIllyhb8JXiZtZDJrx43/P3Phs4M=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-ZgeIcD_lMIa2bepv8Yrm9w-1; Wed,
 25 Jun 2025 09:21:53 -0400
X-MC-Unique: ZgeIcD_lMIa2bepv8Yrm9w-1
X-Mimecast-MFC-AGG-ID: ZgeIcD_lMIa2bepv8Yrm9w_1750857711
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 173111956089;
	Wed, 25 Jun 2025 13:21:51 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.44.32.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 677F119560A3;
	Wed, 25 Jun 2025 13:21:49 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 395C118000A3; Wed, 25 Jun 2025 15:21:47 +0200 (CEST)
Date: Wed, 25 Jun 2025 15:21:47 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ard Biesheuvel <ardb@kernel.org>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, 
	"open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] x86/sev: let sev_es_efi_map_ghcbs map the caa
 pages too
Message-ID: <4kk67edghl7wvqzuyubgr45mhols37yqsorbxxvkypm3xwnuvc@2oek5mladprs>
References: <20250602105050.1535272-1-kraxel@redhat.com>
 <20250602105050.1535272-3-kraxel@redhat.com>
 <20250624130158.GIaFqhxjE8-lQqq7mt@fat_crate.local>
 <rite3te5udzekwbbujmga5kyyjjm5gfphhqoxlhtsncgckq6rm@7m7owl5jgubz>
 <20250625124016.GCaFvuMA9oApInTVyI@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625124016.GCaFvuMA9oApInTVyI@fat_crate.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jun 25, 2025 at 02:40:16PM +0200, Borislav Petkov wrote:
> On Wed, Jun 25, 2025 at 01:52:58PM +0200, Gerd Hoffmann wrote:
> > The kernel allocates the caa page(s) only when running under svsm, see
> > alloc_runtime_data(), so this is not correct.  I think we either have to
> > return to the original behavior of only doing something in case address
> > is not NULL
> 
> Yes, we're doing something only when the address is not NULL.

This is inside a loop, so returning in case the caa address is NULL will
skip ghcb setup for all but the first CPU.

take care,
  Gerd


