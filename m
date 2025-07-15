Return-Path: <kvm+bounces-52506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 230DDB05F63
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A42714A6545
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490782ED14E;
	Tue, 15 Jul 2025 13:48:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84212E266C;
	Tue, 15 Jul 2025 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587312; cv=none; b=Zbau1ZzSaurFsTfK+bJ0m284UM13M8j4wz3imwUMu1/7ADEBIds6SInI8E6SELmU60p9jyCS/hRHiVf8y2qKHUpxtdjqYg05AdG7W65F7A6shcSc1TR6Yxt6O+bkLbYu4zcorUo3aHKC/cJo9t3DtDENYo5ltJp/QqRlG8MS1Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587312; c=relaxed/simple;
	bh=bxFF8xXnRj/qbdJtG1Sq0YERT3ln8lonNLu9XL31+hY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsjTlusU/KHB8Td49FOYnKysZLfe22WWYBmb70wdftuUfwSAf3jaURuN890HmDdUaSbZVTdNVkxaJ2hAPgOCobdGu6UDRrW/UmbHWnXOQ8LIr8oEAukq2lShQerXzwRYCkOJOXrDDE5eDL1BM65XUle0+8cwcJ6kEMof14JL5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bhL8k2J7Tz67KXb;
	Tue, 15 Jul 2025 21:47:18 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2579A1402EB;
	Tue, 15 Jul 2025 21:48:26 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 15 Jul
 2025 15:48:23 +0200
Date: Tue, 15 Jul 2025 14:48:22 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: WangYuli <wangyuli@uniontech.com>
CC: <airlied@gmail.com>, <akpm@linux-foundation.org>,
	<alison.schofield@intel.com>, <andrew+netdev@lunn.ch>,
	<andriy.shevchenko@linux.intel.com>, <arend.vanspriel@broadcom.com>,
	<bp@alien8.de>, <brcm80211-dev-list.pdl@broadcom.com>,
	<brcm80211@lists.linux.dev>, <colin.i.king@gmail.com>, <cvam0000@gmail.com>,
	<dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <davem@davemloft.net>,
	<dri-devel@lists.freedesktop.org>, <edumazet@google.com>,
	<gregkh@linuxfoundation.org>, <guanwentao@uniontech.com>, <hpa@zytor.com>,
	<ilpo.jarvinen@linux.intel.com>, <intel-xe@lists.freedesktop.org>,
	<ira.weiny@intel.com>, <j@jannau.net>, <jeff.johnson@oss.qualcomm.com>,
	<jgross@suse.com>, <jirislaby@kernel.org>, <johannes.berg@intel.com>,
	<kuba@kernel.org>, <kvalo@kernel.org>, <kvm@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux@treblig.org>, <lucas.demarchi@intel.com>, <marcin.s.wojtas@gmail.com>,
	<ming.li@zohomail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<netdev@vger.kernel.org>, <niecheng1@uniontech.com>,
	<oleksandr_tyshchenko@epam.com>, <pabeni@redhat.com>, <pbonzini@redhat.com>,
	<quic_ramess@quicinc.com>, <ragazenta@gmail.com>, <rodrigo.vivi@intel.com>,
	<seanjc@google.com>, <shenlichuan@vivo.com>, <simona@ffwll.ch>,
	<sstabellini@kernel.org>, <tglx@linutronix.de>,
	<thomas.hellstrom@linux.intel.com>, <vishal.l.verma@intel.com>,
	<x86@kernel.org>, <xen-devel@lists.xenproject.org>, <yujiaoliang@vivo.com>,
	<zhanjun@uniontech.com>
Subject: Re: [PATCH v2 2/8] cxl: mce: Fix typo "notifer"
Message-ID: <20250715144822.000006b9@huawei.com>
In-Reply-To: <65FC7B96ECBDB052+20250715134407.540483-2-wangyuli@uniontech.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
	<65FC7B96ECBDB052+20250715134407.540483-2-wangyuli@uniontech.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 15 Jul 2025 21:44:01 +0800
WangYuli <wangyuli@uniontech.com> wrote:

> According to the context, "mce_notifer" should be "mce_notifier".
> 
> Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
> Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/cxl/core/mce.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/mce.h b/drivers/cxl/core/mce.h
> index ace73424eeb6..ca272e8db6c7 100644
> --- a/drivers/cxl/core/mce.h
> +++ b/drivers/cxl/core/mce.h
> @@ -7,7 +7,7 @@
>  
>  #ifdef CONFIG_CXL_MCE
>  int devm_cxl_register_mce_notifier(struct device *dev,
> -				   struct notifier_block *mce_notifer);
> +				   struct notifier_block *mce_notifier);
>  #else
>  static inline int
>  devm_cxl_register_mce_notifier(struct device *dev,


