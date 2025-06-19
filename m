Return-Path: <kvm+bounces-49977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA23AE0608
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 14:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D04D61BC2B68
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 12:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD864242D6B;
	Thu, 19 Jun 2025 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Y8o2u/DL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603FB23D2A0
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 12:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750336508; cv=none; b=D6BoiRtM0kyyFTSHHcbH/42wHsACWtqZ/1SzQg8ZI8Eo3I4K4le8AmlmIfB5UHBwatvjNCz7kqyFJPr4exPVYUy9Zi2cZ12Emkm9C/CmtyIJF/M88IXWwRGhqqPXPrhbyhUF/RR3/gCLcdrhNpF3V8bRNeMv15lfsfZbtAc1OEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750336508; c=relaxed/simple;
	bh=WjdsIi+G5XBXNyHZUuYu5bl9fEH438XZmC6V2xW/tbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oh1kigRvhxv9K7m/63aM7gSmOembKC9cxCdYXHo1iWQanTQD5y3rCLbtuUHuPjIoIAMo/0n2RQOOeY9WxfTkto0oPfW88OuVpE0zOALRZpnOi4ETvIsY9rzmrc1nkCkMz4s6nqFT3vvGZUheLPMKPnORW5VArGlpYYMaiStIhn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Y8o2u/DL; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7d38d1eae03so57632285a.2
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 05:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1750336505; x=1750941305; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nGeLPnPcEKHJ2UTkFmEAzCnzbAa63HR34D5qxwVpPx4=;
        b=Y8o2u/DL6rINOXOGCQNqrOBd5glayOKlVYhHaoTcp4v+ebTGQQVFGz/NEUcj8rAQ0G
         ejMwuIFQT1q8rGmL5QRny/3TgytvQybRP8Dgn1AKj3yVwdpd5RTzpXGFq/H2lE1KKNHz
         F4giBz0LajOSWnlOzdg+Xk8DQiNHdgwN6EV4UOjrEcsGOCIGc61FstCwaTRlJ6I+huyB
         WF5+DW4vaHvarAG5BqIHu4eBOY3Ad3+pyZrx4yoK+HoCtrp8SY/ZjXyXA36p/zXoW/qh
         fPN56wKGatdadK4JEQYjju9eC69tenO9jIYOtqvHyrfQKIxKnBv7okxwwezm0TO9H6t7
         PJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750336505; x=1750941305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGeLPnPcEKHJ2UTkFmEAzCnzbAa63HR34D5qxwVpPx4=;
        b=D9hI9eDoSbBUFHoRFvr9659SHE3fz2Mv+nm8YbFnrAOc4t7hg+Jn+TlQh62b8A/nvn
         igesQGZKYA33TgsRh2E7VxNaSsG6vYOvNLa0HukMY/hUDADTjfqRUaRaYbr7zxYHdnL5
         DUb1k0EzhFEA2ueHhLbtjMScOeUx6MxJsnD20ilx34ibeN8hTrpOIO06huVijX5GpOGZ
         pLqO1cPbHMTYKK7eC4VkODtn/xFvwKHCS82dL1QPZGQJf76QxgmvAV2Iyco738/AnB6q
         1Quv+7iSUK+jVsxu/NzIM+Pd+8VyZI7qMc3hbT2vd5+T2EHav1yxsQKkAc+jc+xz1R+Z
         YNSg==
X-Forwarded-Encrypted: i=1; AJvYcCUda2kKAfppm+3YrVCdONqpmpz+JI4qKkTMsUzkwY8kW7zlxj61dqGjr3EDE0+vgOno8Fg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5xXEhaJtgDXn4IJ8tyD4yYKM5slfCI1+wlGtp7KC/9Nk0yTng
	jymxgD14RnxG/UbFDrUlklHLuHX9lpACIzip14WC7meOuzicLcYPP3fuAk5b9W0pcOU=
X-Gm-Gg: ASbGncumsq159U85OEpgmiHZKQfj6becUWU/WkBQcwnYIjjdGVmAFDXtGiMXDQoPg/R
	cAqrzT1O8gQe0qO1HylRq3wbeX3+PB1GOQf9GBzJyZJW6tfOPkU2cv5pjKXjyBGl/q1L/X1hd2N
	OUKh6nBYjxaPJsexkFStNdfeBWYWChYTxFl5AEuQbaOb/5UcVR3YBGZn6cbj6gDVgpxkAADU1i/
	4ylEU2765U7r4E/5FDBXuRqFURp38ZXv8O4TLkX3n6P7jNswbq3BryFcaEQqmOFhhYre3wZ1kt9
	1BkFuXYmn/+zWsTg87YzcKeGYdAzzYSDLYWUGE5Q0FqWv2CP2g9dcN7vF2Ec4tI7DBzc89w9jzv
	RgsOyWCdDoq5Yzh0GgT0+/kE81NDjIzy+TC5ulA==
X-Google-Smtp-Source: AGHT+IFtAzqq2Fu5GuVgOUj/d61P9ZIrRTWdTIfqS29I/fFKuDckrmDGU3li1DAgHyAbFg6OSuPLrA==
X-Received: by 2002:a05:620a:4486:b0:7d3:e710:1d3 with SMTP id af79cd13be357-7d3e71008admr1128571785a.7.1750336505250;
        Thu, 19 Jun 2025 05:35:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8effa47sm876704385a.101.2025.06.19.05.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:35:04 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uSETw-0000000796Y-0nGl;
	Thu, 19 Jun 2025 09:35:04 -0300
Date: Thu, 19 Jun 2025 09:35:04 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, akpm@linux-foundation.org, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/3] gup: introduce unpin_user_folio_dirty_locked()
Message-ID: <20250619123504.GA1643390@ziepe.ca>
References: <20250618132350.GN1376515@ziepe.ca>
 <20250619090542.29974-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619090542.29974-1-lizhe.67@bytedance.com>

On Thu, Jun 19, 2025 at 05:05:42PM +0800, lizhe.67@bytedance.com wrote:

> As I understand it, there seem to be some issues with this
> implementation. How can we obtain the value of dma->has_reserved
> (acquiring it within vfio_pin_pages_remote() might be a good option)

Yes, you record it during vfio_pin_pages operations. If VFIO call
iommu_map on something that went down the non-GUP path then it sets
the flag.

> and ensure that this value remains unchanged from the time of
> assignment until we perform the unpin operation? 

Map/unmap are paired and not allowed to race so that isn't an issue.

> I've searched through the code and it appears that there are
> instances where SetPageReserved() is called outside of the
> initialization phase.  Please correct me if I am wrong.

It should not be relevant here, pages under use by VFIO are not
permitted to change it will break things.

Jason

