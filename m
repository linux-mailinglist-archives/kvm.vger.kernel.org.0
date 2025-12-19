Return-Path: <kvm+bounces-66332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DE956CCFB49
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6345C306C70E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B04B3246F4;
	Fri, 19 Dec 2025 11:55:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936643242BD;
	Fri, 19 Dec 2025 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145314; cv=none; b=YodO8GbUXNTidK+zQAsqLn/jM9EmUl0PvGIvJcltjCSmupyCMmSOqYZTizLkWni6cyEPsF4QlF7A9GLl6EuJaM6v2msY7X6JfLsJr5HIS55yV8pHY3L7ndgxyc6xwfmTTC1rJrH5E6sH3qLzHb9zpPIPhUUfJORSbqQsCAJe5OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145314; c=relaxed/simple;
	bh=qdsIfP3rhtlcfrL/q5w5Do8GagNJHRjh1aiBrYjK6ig=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hwQV25IEqeptAL1vjY3xr8pMHkB6LhZIjdIgDqpYnQAkK2cWh7wR0X5BIlXKzEZe5sRqCEWR/nvm+9w5bR8pvNx6yfeW55by2XEjatTL2Eb5wKYpyB+rwDwziHke2P9Ug78fM4ID4aLYbEqcPergjonRnmyBS9sZ3BaXnOM9vXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXmDF31XnzJ46Dt;
	Fri, 19 Dec 2025 19:54:37 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F11D440571;
	Fri, 19 Dec 2025 19:55:09 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:55:09 +0000
Date: Fri, 19 Dec 2025 11:55:07 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 14/26] mm: Add __free() support for folio_put()
Message-ID: <20251219115507.00002848@huawei.com>
In-Reply-To: <20251117022311.2443900-15-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-15-yilun.xu@linux.intel.com>
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

On Mon, 17 Nov 2025 10:22:58 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> Allow for the declaration of struct folio * variables that trigger
> folio_put() when they go out of scope.
> 
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> ---
>  include/linux/mm.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32..2456bb775e27 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1425,6 +1425,8 @@ static inline void folio_put(struct folio *folio)
>  		__folio_put(folio);
>  }
>  
> +DEFINE_FREE(folio_put, struct folio *, if (_T) folio_put(_T))

Seems like a reasonable addition to me.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> +
>  /**
>   * folio_put_refs - Reduce the reference count on a folio.
>   * @folio: The folio.


