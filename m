Return-Path: <kvm+bounces-66319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B8437CCF8F9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FC1E301BCC6
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45CD30F554;
	Fri, 19 Dec 2025 11:22:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D3D2FFF9C;
	Fri, 19 Dec 2025 11:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766143346; cv=none; b=uY0+P2ep1fdo6GIYOFCDvrViMFlIJbiyojMDNyMNozLNOIXXaTCwZgKML7PIJNvlVe0p/Kmght/uVb2XZdspX1s9BnXf50mwmWrXRDuistuXlpSNYLgytKwEBIp//uGpYyEokFVuzi5kMY4jZWMWZl7tGW15rNdEya1utA3JNCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766143346; c=relaxed/simple;
	bh=AJDW0TM3eQopIRfI635fLbpCORiDOUKeKS8FF9a7gDw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qb1Jz62w5k3uc/D+/I4hE+IT8k6ieCI+qLHDnhgjhO2oiUFE6YMCDIzNAH4dAwxIhyh9P115Nz0Y9fDnwL/H1fGYSNcZgCnYj8eDfkpxeM7SeIKkTW7WGHdMz9kiCtCuDtewkMROFsWVoJ7hLBcPKGoBOgNTCcKO5FSORFRLNO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXlVT0CTbzHnGgl;
	Fri, 19 Dec 2025 19:21:53 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E94B40086;
	Fri, 19 Dec 2025 19:22:22 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:22:21 +0000
Date: Fri, 19 Dec 2025 11:22:20 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 05/26] mm: Add __free() support for __free_page()
Message-ID: <20251219112220.00003adc@huawei.com>
In-Reply-To: <20251117022311.2443900-6-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-6-yilun.xu@linux.intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 10:22:49 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> Allow for the declaration of struct page * variables that trigger
> __free_page() when they go out of scope.
> 
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  include/linux/gfp.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 0ceb4e09306c..dc61fa63a3b9 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -383,6 +383,7 @@ extern void free_pages_nolock(struct page *page, unsigned int order);
>  extern void free_pages(unsigned long addr, unsigned int order);
>  
>  #define __free_page(page) __free_pages((page), 0)
> +DEFINE_FREE(__free_page, struct page *, if (_T) __free_page(_T))
>  #define free_page(addr) free_pages((addr), 0)
>  
>  void page_alloc_init_cpuhp(void);


