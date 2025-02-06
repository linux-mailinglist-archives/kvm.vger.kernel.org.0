Return-Path: <kvm+bounces-37524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B33BA2B20D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6542D188B62C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFED1A5B93;
	Thu,  6 Feb 2025 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T8/T7vcR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24828157A5C
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738869297; cv=none; b=LXb+41G2PKyXCWmpM/vJDdS+VE3YKwJr0F6pAgwiK+9d8SBQKYA87NenjMJCDWtuCo0vsDY+YpxBKpmZglJYvRFgKtHQAqV60QTxfh0RQNdPJH1ONa/wp4HggKulSEfO1vwIy27LlcGuHNEMJJljZIucHBZsNIWDnD+KwqN0XnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738869297; c=relaxed/simple;
	bh=Xl9SaPsukgYCfo2wBQzYjH4LLOgDdQPNRuuZESDuzb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBd24Wim9owXoP0Z85Em/qzmxSDSusvFkdAC+YuZuz6kLUVukEYBcaWTuN3ZtfXufm4O+mG7ZqlcrPn12DwkDY76RbNEPMYRMBIlnh39jMqOZ3Ejuqov5CxXuNp44mPCPhv6wLx2buz5HIvp6H3zLPOKY9LlqJdgBVkd1DzFFps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T8/T7vcR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738869293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+F8Mn89b0OdrghV9tYd0P21FtLLxAlCu0Zd7fsJXe8g=;
	b=T8/T7vcRMNhKbmZ6Ceh/o2v24ZbRDyXNfCpxKatuQXMJWplLXe3blPes7ep+eRWv60gpJg
	/GWxq3AC+SvxSl3MhcqvHV/8bRdmDkuBoCyIcqaMtNg6Wy9rOFnTzCgjN6hqKxr6huXhBu
	qUGyjw34/iohDpAAjNSAdp+hu8W4ubQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-Ot66Xm09PmyIKm-sJl4LvA-1; Thu, 06 Feb 2025 14:14:52 -0500
X-MC-Unique: Ot66Xm09PmyIKm-sJl4LvA-1
X-Mimecast-MFC-AGG-ID: Ot66Xm09PmyIKm-sJl4LvA
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6c51069f5so218561685a.3
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 11:14:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738869292; x=1739474092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+F8Mn89b0OdrghV9tYd0P21FtLLxAlCu0Zd7fsJXe8g=;
        b=W73QqsbcS/VUtQtJPmjNXBLYUVq56w5JiA+7ptw331OqgLM4xJ4L5BsZdB32Awqptk
         zhmY6lqt/6DjkqfYX1NC/1FLTowiCf6D34gqXTPoLVwwgnt84n36VhBlfrzyfSjvzFrn
         WhPEbCNYvXLst61u7xFitEGSe1J2zYvwYy+thWaDGC7seQBhB+DmqfcRm53yXYOK9WuB
         oJi6lPbfVoqcj+SyLTug5MWm7ZwzvFDl5hiv9BdHRi/Lc2e/dCWNMQL4NCk9+Ss+6Wtb
         /IQcqMd0q2LXRkd5BGc+k6Kymtx1A3LRvyEDPe1P55AGcrfT+TzWYQYClODYbQ9thFOC
         GVlA==
X-Gm-Message-State: AOJu0YzA1FWq+Lk7s0G/4XCtdEvv5bgjNZNE31+eA14AlDdxXSgHEDCk
	E+GdnMd2SRrX2uWbwkk9VFSfosZJM/da2spywbzASYOqoF6GgWy0WwfTOaWmdLi4VhPp8bTxfa4
	ctsUV7/5Cw7dEOwsFeyn70I7PSXj3XmiRUsDvcjJJpVyS9QBVnw==
X-Gm-Gg: ASbGnctObni5onUqHwM/vdnVG2+kUN8/CSrN1hBWsLFjFKVN3LM+B5liJWH1gHB0s32
	lXRna6DhglaMKf+rVjk5s/qycp2f3DqeUlEpuvOo4/196v9NyBw0SJwomgYo50LvGcxZJ9Xf1BJ
	MzIlq5TOxGzgoNSSZEE98W9KfowAscZjpXeBgpiVjLkQ9BhH9N/auHTViDByaEhwUiCIMzIyLMc
	gUWgt0rDYYP7u692146HLGvwQbSxk99RbnHS6iAtt2F4QYHk9EsNTf1871o+1m5NbSVmefOxMnO
	pOGhlLc6C64FK6En+z11K5GRURNqS1QPOEWXH1v5yKuVhpaf
X-Received: by 2002:a05:620a:25d0:b0:7b6:d4a2:f123 with SMTP id af79cd13be357-7c047ba50e6mr43436985a.2.1738869292200;
        Thu, 06 Feb 2025 11:14:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEe9Zvk86HxhKs+COosIxGv3oUlSB9oKcrcLV0AUOxRdp3FalJ6v6z6IavQ7kZESBaVcNxunw==
X-Received: by 2002:a05:620a:25d0:b0:7b6:d4a2:f123 with SMTP id af79cd13be357-7c047ba50e6mr43434385a.2.1738869291903;
        Thu, 06 Feb 2025 11:14:51 -0800 (PST)
Received: from x1.local (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c041dfb976sm92254985a.43.2025.02.06.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2025 11:14:50 -0800 (PST)
Date: Thu, 6 Feb 2025 14:14:49 -0500
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	mitchell.augustin@canonical.com, clg@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] vfio: Improve DMA mapping performance for huge
 pfnmaps
Message-ID: <Z6UKKUS0Yc-dKPoz@x1.local>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>

On Wed, Feb 05, 2025 at 04:17:16PM -0700, Alex Williamson wrote:
> As GPU BAR sizes increase, the overhead of DMA mapping pfnmap ranges has
> become a significant overhead for VMs making use of device assignment.
> Not only does each mapping require upwards of a few seconds, but BARs
> are mapped in and out of the VM address space multiple times during
> guest boot.  Also factor in that multi-GPU configurations are
> increasingly commonplace and BAR sizes are continuing to increase.
> Configurations today can already be delayed minutes during guest boot.
> 
> We've taken steps to make Linux a better guest by batching PCI BAR
> sizing operations[1], but it only provides and incremental improvement.
> 
> This series attempts to fully address the issue by leveraging the huge
> pfnmap support added in v6.12.  When we insert pfnmaps using pud and pmd
> mappings, we can later take advantage of the knowledge of the mapping
> level page mask to iterate on the relevant mapping stride.  In the
> commonly achieved optimal case, this results in a reduction of pfn
> lookups by a factor of 256k.  For a local test system, an overhead of
> ~1s for DMA mapping a 32GB PCI BAR is reduced to sub-millisecond (8M
> page sized operations reduced to 32 pud sized operations).
> 
> Please review, test, and provide feedback.  I hope that mm folks can
> ack the trivial follow_pfnmap_args update to provide the mapping level
> page mask.  Naming is hard, so any preference other than pgmask is
> welcome.  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/all/20250120182202.1878581-1-alex.williamson@redhat.com/
> 
> 
> Alex Williamson (5):
>   vfio/type1: Catch zero from pin_user_pages_remote()
>   vfio/type1: Convert all vaddr_get_pfns() callers to use vfio_batch
>   vfio/type1: Use vfio_batch for vaddr_get_pfns()
>   mm: Provide page mask in struct follow_pfnmap_args
>   vfio/type1: Use mapping page mask for pfnmaps

FWIW:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu


