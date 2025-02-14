Return-Path: <kvm+bounces-38190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA22A36613
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 20:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33AA618959FC
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 19:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A611AA1E0;
	Fri, 14 Feb 2025 19:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Mt2nO6ae"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4332AF16
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561229; cv=none; b=uPuB8Rp78SVttJsu+MgCeXG/DQ4sfssJBjkEnj5Y+ZcGOBeSsutiYHXFxxfYo7RjnZXJqePIuFBKUTYRwsznbqTiToLED7fpU800aSYisqA23Sl84ELjDyynBSaiKN8lPt2pLNEnDk6hy9AtjuOo7JV/cWBvaDdtvoMU+UhJ9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561229; c=relaxed/simple;
	bh=55jqhg240yOgqtQp2hkMhDJI7bwzW3oaSKWgrwuFEsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZhD/Lm5ZsQ/2bM6NuGRhkzn3O/rj3fS7Kno5WqggFID8ADJRX/ww2cy+oAe91plcumcZEr8fAtvzddsKMeydxTp8ssW5YNqWJwWt3/gwrNXlfNaBePbpo2WaRBaMTJbHOGlKE0hmJW8VPwdS4H0aq9BDIieqmxX2nMc0SxTYbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Mt2nO6ae; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7c079026860so277159785a.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1739561226; x=1740166026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q54C682wupKw2fn+9hJZ17sdX89XEBbDkpwzhueywsk=;
        b=Mt2nO6aeycPPfnCy1bujlM1UYhiHUIljw6VZR48g1zYy7uo5waceIvFPpk457M4jeQ
         FOLSEXC7Hzeh6OwOdFmQzrYp4eLRyNG03hDEOcKA6hb5r84Y4RemgNUr/Rw/1I69DkGi
         bZl3hdwcRsRh1TXisDohs3AKG3ClrGD0URCCyifSMD3lkvIE+E1BOQiqLHfjQxv96qJ9
         xKfCmih7c0TR+QhlljWIycxTyDfuXUg7kU1dfzeCrFJinSf1nB7baunhUFi/VANVk+yW
         2ZEmZSxVfELs3RRUPokNWrEZNfrWhY9sG/EPQEGHP+WylhLWxZq9ffmzkRYPZN411bZY
         BThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739561226; x=1740166026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q54C682wupKw2fn+9hJZ17sdX89XEBbDkpwzhueywsk=;
        b=i0h9bozYDC0uQ/iJ0CzEQQ4fII5NQhCsJyVL9Ax454u7QJivuZ94NS+T/OerK3tppE
         8bSul4JDdxysN8HMhtmFRxvHsXJpNviVzpGRBaD5Jux0/pxykSSHNUHWSUSmSfru876E
         nhScXWnkJBnOw4KPE1r7Ss8tGqavSmkrI9y1FHbI454jm/5nWu6yY/j2NUb102PtjLc9
         O39zkeAa0zJxnoOM0XaebHf5O/uiXwo5Ujk43J9jV3jgcoB9bxZIaKviCDGIflpV85MV
         Ezucxt2ivyO6gWUm/lRXUeopP8/xlPq5CnnveHT5gvGbjaaY+/r6MtwSwldwCklyLUki
         /7rQ==
X-Gm-Message-State: AOJu0YwWIYCTAJt5jTsY5YoHwMjyaTJ2DzMLTZ/3gZvQxoTfxMQ9K8NY
	TmUcxwIG2C30hNuL5SWmaJAziwbfmx3yAif3BK7zzgKrOoCs7wMKUEkHqAJ4HI8=
X-Gm-Gg: ASbGncu0utrCP6Wyis0Uwp4lcLsIwGb0bVjenxYM/PB6qVoMiauvC8+0bR47M2xtM4I
	jAOwmFSq7HN2YvtTJemnUjDhhbQINim2Ochi7U3FtUTAUaRbdal7ZiOUDqTcMgLVRpktcMbdhcF
	/IiSbW9pA/ZWgMgVlySaK8lJJwW/GaVx9L86hjSDkHTTC9BvgIx5KC0mw2gJ0s+PwzcWNCYCN59
	UsPG37v65liDkxzYjCNMsw/JsPsZiinmFTvJhlxXXv6foSaYZo/aWTNlkxfFBHRx8gXwdoVjC8h
	fjpa80whuCCV2OuvrraLcgbHc1wzeQqEoYLZAXkrM9/JXaPxGTkudnranCsUtegQ
X-Google-Smtp-Source: AGHT+IGP6EIu6D5/X4T1lXUP3TqCWP6QCFadGFyDUhKfkvIRhoG4FICvPgxc52H21XaC8VTPwxK1CA==
X-Received: by 2002:a05:620a:2691:b0:7bc:df55:2cd0 with SMTP id af79cd13be357-7c08aa9f850mr103218785a.48.1739561225699;
        Fri, 14 Feb 2025 11:27:05 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c07c86155dsm235281185a.87.2025.02.14.11.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 11:27:05 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tj1L6-0000000GmO1-2uwa;
	Fri, 14 Feb 2025 15:27:04 -0400
Date: Fri, 14 Feb 2025 15:27:04 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	mitchell.augustin@canonical.com, clg@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250214192704.GD3696814@ziepe.ca>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
 <20250205231728.2527186-6-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205231728.2527186-6-alex.williamson@redhat.com>

On Wed, Feb 05, 2025 at 04:17:21PM -0700, Alex Williamson wrote:
> @@ -590,15 +592,23 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>  	vma = vma_lookup(mm, vaddr);
>  
>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> -		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> +		unsigned long pgmask;
> +
> +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &pgmask,
> +				       prot & IOMMU_WRITE);
>  		if (ret == -EAGAIN)
>  			goto retry;
>  
>  		if (!ret) {
> -			if (is_invalid_reserved_pfn(*pfn))
> -				ret = 1;
> -			else
> +			if (is_invalid_reserved_pfn(*pfn)) {
> +				unsigned long epfn;
> +
> +				epfn = (((*pfn << PAGE_SHIFT) + ~pgmask + 1)
> +					& pgmask) >> PAGE_SHIFT;

That seems a bit indirect

 epfn = ((*pfn) | (~pgmask >> PAGE_SHIFT)) + 1;

?

> +				ret = min_t(int, npages, epfn - *pfn);

It is nitty but the int's here should be long, and npages should be
unsigned long..

Jason

