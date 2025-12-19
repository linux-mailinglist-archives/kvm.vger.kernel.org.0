Return-Path: <kvm+bounces-66331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 895DACCFB4F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2447730DCF6E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50532E175F;
	Fri, 19 Dec 2025 11:53:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5EC9460;
	Fri, 19 Dec 2025 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766145194; cv=none; b=By85Ze1rVLgRmFZKppdR5rENFuIzoDdoVJ3xGtRM4ScF/m8qx5WBrbDAId4FR2mHLueuI3U5i22dMliM5rUtsxRHKLnsl2w2OI5PcsMsnQdlYxsh/uSyBRtYhBRVbd2YXSiSjUwxfwcaZ2po5YDk8HM3lp6RK3cOARbjlwaHwKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766145194; c=relaxed/simple;
	bh=n3mxc6dsnKLRUrukcePiJscL8WJWxCUCCqHUWA5QFkY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qG+Er3Dm1lMAys3Znxg19bGzVTsgWcDF7LLcBHCMHjAgRBQNLjjKne3q3FNK6QUXcgtrEvnFqUXkAr3ihfB5RT5rxa539HaXNMdFdwOovKkIOkoxNgMyJGLXwM9OD8X6m6r4U9aL50yMKs8n9L+drm0Jxp9lqJCXgymoI5qod+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXm9z05mBzJ46cH;
	Fri, 19 Dec 2025 19:52:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D1334056B;
	Fri, 19 Dec 2025 19:53:11 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:53:10 +0000
Date: Fri, 19 Dec 2025 11:53:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 11/26] iommu/vt-d: Cache max domain ID to avoid
 redundant calculation
Message-ID: <20251219115309.00001727@huawei.com>
In-Reply-To: <20251117022311.2443900-12-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-12-yilun.xu@linux.intel.com>
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

On Mon, 17 Nov 2025 10:22:55 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> The cap_ndoms() helper calculates the maximum available domain ID from
> the value of capability register, which can be inefficient if called
> repeatedly. Cache the maximum supported domain ID in max_domain_id field
> during initialization to avoid redundant calls to cap_ndoms() throughout
> the IOMMU driver.
> 
> No functionality change.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Missing sign off of the last person to handle the patch. Xu Yilun.
That makes this unmergeable :(

