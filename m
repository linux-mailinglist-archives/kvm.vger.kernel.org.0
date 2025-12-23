Return-Path: <kvm+bounces-66628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0035BCDAD16
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 847DB30285A5
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 23:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5590530F92D;
	Tue, 23 Dec 2025 23:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QaIM1bfD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1F2E0934
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766531672; cv=none; b=qqUya6Uy1v+3adVhTCHf+bxovREdo2+21ChjaCq/Z+2hPULY6ZHt/JKGz55HBubThkOFdBRLR589vQLOR83vy3zi6BMbG5YIT3eDrO9WJrXItBJfXhx74hU9/eqyJ3X5TTDkx4V6FUezbm2W8L08U35a4IRj9UpNxmwLyzdnvQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766531672; c=relaxed/simple;
	bh=UrsIwKhUPBhmvmWc3UQpPHhueBpLXUS35lBbM53gH4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bq+goX1qILSES7iJ0iwmFsJrNcZlXOSzE2anwlD8+uyd4F441GM7+xNAxjjet0U1DqoK/OqOVSyNMHAxf13HsurEZK3njbLjUug0h/xbkBkQqOOim1fo1AAPNKTxcEQuK/pr/eKwYZ1vZaBHGPB3CbJcdRuNucxl6vEUFXZj7Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QaIM1bfD; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso10154336b3a.0
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 15:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766531670; x=1767136470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XtFRCy5e+ZCbCj52LzETs4Ka0dGCXxZoU50vkAKruY=;
        b=QaIM1bfDkTAAso7rcCuPvburrleEGhNJuVaMUpZz1C+siJamLZxJfmXbzQ6BQ7IQVc
         fewN27od9fUMEcP5suZulZ2XUgO4DhT7T3nK/717wGT6IAFBWDrdPCw/2AbaZ0AdQUU3
         dO1XKlSNvwHcA7nWxFDwY5yHUqMObPKyCFg/JYsX54v11ExJiiN93stuiBpxtVEOUq4e
         ZN2wwGfmL8yPrCmB9eOlYqNnkNRu0+0JrirA6azvSaEgj2TxvmVEGW4WZIvdPaXuNo46
         tQyJAWO6R/StRNp1yPuM3xzvGsjjXB51ffrWRyqr+lRHwgMumQ6t4uKqgJXQV9jTtl8h
         39uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766531670; x=1767136470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XtFRCy5e+ZCbCj52LzETs4Ka0dGCXxZoU50vkAKruY=;
        b=C9ICJAdUYog614WGQqOe93l8EdD/xl7Ekohgv0gUF5Zp8Rm/CgILI82uuFHCBn23iQ
         t8XMW1tNlgw0Gq5U96aUxXj4RTbKqbBmi/IUiCS5cG+m0oHO/x/By8KMZZBsiri4zXUW
         PEFCIHN53EpSRjoNTqqxouuDCHvsLpjecDxFf14vAN1M0SVm7K+WwJsRKVNA19GoedVB
         gDJUJuGnkX0rSXSp3NTWrVjGM8Tz6M1yGo/VeI8CBnrRwg0jAMmxy57Uxk8gcYKtp5yn
         E9r2CyYLRn4woxJvGVF1JlmBk8/7BSx1QMWi0dQZDIsWp53QAFwxJg9ESz6NyQvNOtLF
         bvBw==
X-Forwarded-Encrypted: i=1; AJvYcCU6BOX8TiaxJdoeg+nkY7gFp4QuHqVOnStR2L5aFP8srPfNJYsVN79agyVy2E5VTtnhLJg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5psWxsSC4q//pXsC2TmOzM4fuckL/bcxe3+4hJG+Wm0p1/0Hl
	y4mqQ1zgChAOVAub3CkFuWBiWZOicvqv/yAdxXQ2BbdHu8popstntkTJc/cGGGH3ZXyrHMYgueq
	ZRYZTRw==
X-Google-Smtp-Source: AGHT+IE72KL7Fs4kH8TAJsRritpRi4P6A23yuo5MirvNZPXXN7oVXycrHTxEf12GMrJMdS3t0+q52Idg3nE=
X-Received: from pfbgo25.prod.google.com ([2002:a05:6a00:3b19:b0:7fc:5185:dd1c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4307:b0:7e8:4398:b35c
 with SMTP id d2e1a72fcca58-7ff66672928mr13349683b3a.47.1766531670383; Tue, 23
 Dec 2025 15:14:30 -0800 (PST)
Date: Tue, 23 Dec 2025 15:14:28 -0800
In-Reply-To: <20251127013440.3324671-11-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev> <20251127013440.3324671-11-yosry.ahmed@linux.dev>
Message-ID: <aUsiVDjIrj6szEWt@google.com>
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions for
 nested EPTs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> +	/*
> +	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
> +	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
> +	 * is present but not readable. However, for the purposes of testing we
> +	 * assume 'present' == 'user' == 'readable' for simplicity.
> +	 */
> +	pte_masks = (struct pte_masks){
> +		.present	=	BIT_ULL(0),
> +		.user		=	BIT_ULL(0),
> +		.writable	=	BIT_ULL(1),
> +		.x		=	BIT_ULL(2),
> +		.accessed	=	BIT_ULL(5),
> +		.dirty		=	BIT_ULL(6),

Almost forgot, the Accessed and Dirty bits are wrong.  They are bits 8 and 9
respectively, not 5 and 6.  Amusingly (well, it's amusing *now*, it wasn't so
amusing at the time), I found that out when I couldn't get KVM to create a writable
SPTE on a read fault in the nested dirty log test :-)

