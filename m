Return-Path: <kvm+bounces-68237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A28D281A9
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 11299301701C
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41902ED17C;
	Thu, 15 Jan 2026 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sU0vN5+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6552ED846
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 19:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768504643; cv=none; b=pIq1rfT/jGHIKz8r/VEQgWlHH9C24tQnP+h4jm6B+JA9EDBiAQ6/bbF6vE9j6kscd0zo5Ku9XeI3aDxL64FjjoiYLi9niqlE7kvyoGdzsGgQ80hkWYs5hFs5UWGRetZ3UVFD4YVgmcpm+jbXR/nikMcOSZP1VN14ip85VUr8Xxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768504643; c=relaxed/simple;
	bh=8EsIAojX7izm3eUG0OWRmU4nt+cjKhAtCc3Rt+DkVVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DJmlkqL9TKm2Iy1O1y9H2SedCQ8w9CnYOxheeHRv2scUdiQxBGB2vfXaHoUGKIpmaeQW2eIuotsqN4I9jcjbdPmET7gX/ISsoTgPzna+7GN3S98F43wSRdtWyQ35yBFURNR53EtOZU8GauoxOccG37qo6SX4mCjH0EiA3KuzZnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sU0vN5+S; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81dd077ca65so962462b3a.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 11:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768504640; x=1769109440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xTgcZS4Su6Azzs6FTl7APd5b9i+AMlUEP5Ldeqc7RbI=;
        b=sU0vN5+SfipEjWBaEJV+YK9LkHmRtHPwHIppGqnyfwu3ts41DMceTiOcGL2gnXAG3Z
         wiLGHb31GZIekO9KpfinnIRsXcQlwMyQ6h7erXP/3TgiwNwSRwvlHk5EXubnCn/inKD3
         4WNWTA0djf0D+79q22b83+7UhV1CWlZ4wuEDFAyf3Y+letOLd/XQLm69qYEDkDEyhHlS
         JodPLIXSG7+yoWUEMQsjF6xhF+vKnhKEmFBxQcdZrhC5/E3IF7DuSmX/QuF0FeoX6pBZ
         w7YWdL/iboe65sUD4iYRNy6COQ8Y2yC6QXztgSxCrjuRvk/EIAysBRvtb6iSR6CL7CA9
         9D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768504640; x=1769109440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTgcZS4Su6Azzs6FTl7APd5b9i+AMlUEP5Ldeqc7RbI=;
        b=YI5hgKz8Lmrzg9bfCsPU2YwXchkGPiJsjDgUKC4ZMdSUI0yBhdSLLcFhLi3nCpj06P
         VzVTXEnqNynOeSfsCDkWqH/G+ebOaqUwc0hUHTzGW605iwdNaMy9pL6xzx6z4wo3l4mu
         +V2aKWG/eVDuGQSf2XrEiCs3X195uJCnuSKehOI3eGrixdS5MT7Senz7dIA6MMGXu0Hu
         33EIhl6APwftitGyddi4Ih9K7008MkqFfrAvgSprw2+hpC+v83aj/aWLqBZARNrVX7be
         xVP8c1+hE4sQ6QgjNfOiOwiBNE84B3bJ1k/lPdZZuBaVGCfoNnleWUrMDbV990KVulQF
         l2BA==
X-Gm-Message-State: AOJu0Yxu0yz7FNZgnLSRwXvfLh2juMvGCbkOGMpNvbA9K9q3BdTIiVn3
	zFrl8yswpYyoxPcvTmht9jjBm0w65LKeNenLx0f7fcl/su9NJ9wi4+5OZUSkcA8eXdwiPk7CKSV
	mErLCfg==
X-Received: from pfbbj16.prod.google.com ([2002:a05:6a00:3190:b0:7b8:922c:725d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2ea0:b0:81f:3d13:e070
 with SMTP id d2e1a72fcca58-81fa17729e5mr189167b3a.12.1768504640018; Thu, 15
 Jan 2026 11:17:20 -0800 (PST)
Date: Thu, 15 Jan 2026 11:17:18 -0800
In-Reply-To: <20260108214622.1084057-3-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com> <20260108214622.1084057-3-michael.roth@amd.com>
Message-ID: <aWk9PusYNW0iADuD@google.com>
Subject: Re: [PATCH v3 2/6] KVM: guest_memfd: Remove partial hugepage handling
 from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Michael Roth wrote:
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..9dafa44838fe 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  					 mapping_gfp_mask(inode->i_mapping), policy);
>  	mpol_cond_put(policy);
>  
> +	/*
> +	 * External interfaces like kvm_gmem_get_pfn() support dealing
> +	 * with hugepages to a degree, but internally, guest_memfd currently
> +	 * assumes that all folios are order-0 and handling would need
> +	 * to be updated for anything otherwise (e.g. page-clearing
> +	 * operations).
> +	 */
> +	WARN_ON_ONCE(folio_order(folio));

Gah, this is buggy.  __filemap_get_folio_mpol() can return an ERR_PTR().  If that
happens, this WARN will dereference garbage and explode.

And of course I find it _just_ after sending thank yous, *sigh*.

I'll squash to this (after testing):

	WARN_ON_ONCE(!IS_ERR(folio) && folio_order(folio));

avoiding a few emails isn't worth having a lurking bug.

