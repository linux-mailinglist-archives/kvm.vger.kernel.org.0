Return-Path: <kvm+bounces-32763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 829339DBD63
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 22:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC846B21CFE
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 21:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0E81C4A34;
	Thu, 28 Nov 2024 21:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="sQH8Rsku"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2094.outbound.protection.outlook.com [40.92.40.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40ED1C3F39;
	Thu, 28 Nov 2024 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.40.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732830580; cv=fail; b=sLGBaaOXsyP729KsvQ4FguGQHVXBPHglzpjoU38E7YZgTiPCZ0esheLee0A6M7BTxAhrfGI1wGwK2TzY0zP3B+V/8SQH7i0Wp4gvh7wbA1f+rKGXIu7t89q8TSOmIjLKzn7tk7c1dCnHQrOb1KZfIGsHl227gWIkAFvECU7YLgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732830580; c=relaxed/simple;
	bh=LmNKVfnoZBVLLpYKRTcw94py6/yYeQFnhG/BpEXAXeM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HBUBl5oDgJTdilY0t5rj00NGIJb0DWLCb0V+n79hA0DgkvVrhmmfnaxZi4wbb6m6+xdqQuRvKEUj0OhutKWoG1OEja+4wgNKkdSL3mVkXyu1GXTz9RzHWKI5au4JBj4d42OouZr26XoXeng5y4wer2W/G7nN6GW5r3AfeSXs6BM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=sQH8Rsku; arc=fail smtp.client-ip=40.92.40.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGKJbio5Xd/tC6g30nhdgMuRRnnk+8MPTJaqRaxqMP/8lKNQMJ2YWrDak8bGPzCpE+6WriGkdrExWOj+xQYJ4OrAncUUk/9IcYF7vUoOm6+B4kFNTFjnzzjUxgR+M+D6ag3Jk3Mk6VlpEdXr5IxJKiF2XEYqn+h4EisNa3UWehMObTLetKK0SMx5ovihKBJ1JpWvv7/uSpyESChXEWh6kwE+ygVbUCFnOXdfCHVLKSSeZJPriFhEzSqDtSgEn1CXL9s6MV5R/gwyGEWTAGSylwOe36PZ2ReVkA+ejpS9Ro0CasPThewm9KL7xPJW+hpJABRO+/vm0iN5aqt5Y8yihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3poJF3PcoXZs3j/1Y4GFM+T3wxPIav+3BnlaxXWkY6E=;
 b=WSvIKDOnR2AznvO4DCGRgYO6lRL5Lvlgdkghqv2DlyQc3U65XhWVUfEkk1RzCam3rw9hxZdWkUah7YGO2cgT2soDTnN2Idi9AYkowsRpD/pwFRBirFThU0lIjDvQnAojNnc6hJOe6kLZUh/E7uVsa5Z2m0D7zZxbANVPqwCacYjkxIgzNl/GtA0XtFvATvNOB8/U5BSg5SUMAI//M0QUtpae8W71PwTvHg36tNS+ur299pV9f9HNaspYBa0Mm1L6OLYw2SXNZnh0DQkMn/CekfaPSX8dHq2G9mUf/oylCqEBoU6Eek1dMhjhosqRaXufAynfq9L7xzQjlT4UkB7yaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3poJF3PcoXZs3j/1Y4GFM+T3wxPIav+3BnlaxXWkY6E=;
 b=sQH8RskuXzhtKtqw8C2M1kejcgqMUzu0/Zj8zmkgIRXRwQIZALByeeAvg5chcDoMEi4H/WXaOMHwWxxCz9/lVRb7y/3CvSvxNCawgfOlXEtNw4sl1BtqeFgi1piBr9c59epma7tLbjpYgrl6nO6MRDu4Ofbzt22CDj/O0nnK9nVyax6+rdq8VUyWkuzx3wKzajM5xv60N/kaVhTCaLpO5vm5fRF5d/LQz5X7o0UNfSep6yBLyksnhonn9xInmhckjhEmeyaoA0AzXgAgsnbhyAQ7KKM99xJCfgH+dU+dlsNmuiOV8sRtYQayOyhuWVRVQvwoRMmUjkpf+m0sMMTadA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Thu, 28 Nov
 2024 21:49:36 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%7]) with mapi id 15.20.8182.018; Thu, 28 Nov 2024
 21:49:35 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Maxim Levitsky <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: Shradha Gupta <shradhagupta@linux.microsoft.com>, Wei Liu
	<wei.liu@kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, Konstantin
 Taranov <kotaranov@microsoft.com>, Yury Norov <yury.norov@gmail.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Eric Dumazet <edumazet@google.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, Long Li
	<longli@microsoft.com>, Jakub Kicinski <kuba@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Leon Romanovsky <leon@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Souradeep
 Chakrabarti <schakrabarti@linux.microsoft.com>, Dexuan Cui
	<decui@microsoft.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Thread-Topic: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Thread-Index: AQHbQc3Mdna1oSNuLkOsmR0jS/whpbLNOfDA
Date: Thu, 28 Nov 2024 21:49:35 +0000
Message-ID:
 <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20241128194300.87605-1-mlevitsk@redhat.com>
In-Reply-To: <20241128194300.87605-1-mlevitsk@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CH0PR02MB7964:EE_
x-ms-office365-filtering-correlation-id: 775b164e-4e62-4872-a17c-08dd0ff68d03
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|15080799006|8062599003|461199028|19110799003|3412199025|440099028|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Mm94WYMu3/FUhZpf6h/gEmr1nkAN2KKHCmcbAX6WoPx3sz/RrVPOBnA4lPa6?=
 =?us-ascii?Q?WGfQZFRBr4HjES8djSS0+0OR8sWety+TWBGESiiQeaihOvITzyOtfy9itkzL?=
 =?us-ascii?Q?3d9CMqYkuN0hfk0npndU1w7TjRi9SwmS5R1DvzVxFulpx8DgMGMEeTspAQI7?=
 =?us-ascii?Q?+45qQov9jk9BV0bJjhFEI99LJ/bPqFlMtN7uk5pVY77LmCbubaeJW47jDV7T?=
 =?us-ascii?Q?E32vi0xFVlTzO9M5YLbiXf4SvIbMgcijox7rQwoqsbDCKfXt+2LT+9LTR0xS?=
 =?us-ascii?Q?VLMjOFaD5uSk6BVUmyeQi8EqCyVVYh3a80Y7LVNdT52EjJPbXsrJgvdAh6Na?=
 =?us-ascii?Q?GIu0vVwGFaLAMz4w1CCi/cEkVumIwVurBi7PDzCSV6H39eiZCIg48TSg95BG?=
 =?us-ascii?Q?bmQ/6ChRwrMUfVP7Jce9Dn+wBtZysh4MFNEDQuB3Wcfb1lRv0Yber5B7I0f/?=
 =?us-ascii?Q?/2ZvgWpxKCQRfGBVLJmpXZA5iNrc/9H8glcvdp7dYW48wiw3BeZjQPoXLvQ8?=
 =?us-ascii?Q?TWXPh49sPgRdTINvGHlnmfmW8/W7KAw5w/PLzlRupIGiHw9wrWitSnvVoZzL?=
 =?us-ascii?Q?fGpDzK50+hyprYe6yWKGDfHasRhXPuaX2RuZH2myDbAmN0G06I7B8GnDBQPb?=
 =?us-ascii?Q?GO4lVHg0OadTwoPigWxPn+iVKqEJigu4jmTPBwuAhJgavoDvZCfa9UH9fBNO?=
 =?us-ascii?Q?j0F85WUjfpJXsVg/I2+oYo7sN/7n7d8n44VyH7qsF30tUD8r2Z53BK0jdq2w?=
 =?us-ascii?Q?CNahbQib6eKBk1hLfI+ejkLasJN5RBe50jgKYtcH0U930t3pN2gzK/XM2uaX?=
 =?us-ascii?Q?YatDQDXuo/WYNMEUeQOGe+03retNhBA369z7vO7V+YHBYumC7Td/yijTJ6Rm?=
 =?us-ascii?Q?da39c6S6aHw/aZUwwdE+ZadgrVOcv7by5sr3FQikRoxeSEwoegCiM9vPoxiH?=
 =?us-ascii?Q?Y/d1UOeX2Y/dbPJB60vWsz/4+AorDQ1L1nsr8UBzbeUfT7fzCuO+nPJSWlbu?=
 =?us-ascii?Q?8H4VPT9tQUOQp2JFzNMFxa3Jvw=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RM7jcsejNJRKThmzbnhmDT3KjyxHZiMopVo5kzjwpE72LXjxME/RBRiOwGEm?=
 =?us-ascii?Q?OyaTLZqtO56oDGOjs/yOuRe0R8xQzhwDajHNUfd37g+TOMMFL3Z5fQ6S6DF4?=
 =?us-ascii?Q?w3j3z8T3+q57SkwZnFAAEyWg7KZhhGKmuYoBEzm2ClkKQN5xWgDbMlPpEAxm?=
 =?us-ascii?Q?eJf163lFrK9R+kUh9BxhT1xHAt358fs2aqvHI+zg/2bsqiOeQBipTLEn9skz?=
 =?us-ascii?Q?quMl7GP2RDNRWptODtINt80Yl/Dl+RgQf7Ig8iu3mMOuyC4gzxA0cYHJCALz?=
 =?us-ascii?Q?+HQYYA9pmacgdMl3msI+D7V7Q7wMnPnxkDFK0iSJJP2bdY0alDBJecYDFDZA?=
 =?us-ascii?Q?Gj6Gbs/+2fLmH5RFdX04O7SbyrzbwTNb4lbOEmkndRRdjCfyx+3ed7CwQw6c?=
 =?us-ascii?Q?7RkOCGXrIghb3R11WhdzNjetWBAG6OaTbXzkiSwd2VjSNxGBEy8lGRV24vyH?=
 =?us-ascii?Q?xD2ixnujjbebs8ZHAOsa0jJHpC9eOVLEuUvyPJmlbh1J5+hb9wJtRMwsN+4x?=
 =?us-ascii?Q?Y5ln45Q1IbMMHrMQOjGBom2k/AzoyPwnvNlq8TGDuM+AR+rMP4lEu7A5hXI/?=
 =?us-ascii?Q?LCyXnrT853hgCcxNqd232fL6XcXVgfuHWKohnEDMuS5YO35UTuxPg/SEvGg6?=
 =?us-ascii?Q?4DU5tezKnAq7uuZg500LWnHsfpMg8/Ihd10/1CoS+18/+oQyoDkyAmuu8T89?=
 =?us-ascii?Q?JZdFIE4Y45VnyT2fFRItkJdMfLRUYHi5U7HsxBvMAK8KBl/m52NGnv+rwGKt?=
 =?us-ascii?Q?9EzJIFogRCnKcPhDlC+E/3D1++2RsUQ07CVeOkE8yCJFsRi0QM7PkFarzxVJ?=
 =?us-ascii?Q?Lj5xo8xd/YNR48sLmWEjf8/Sx/3oem78KCGHMArIbJbdU0M0CyIZ3nkjJaa3?=
 =?us-ascii?Q?DmYlVwtStg0JY8o7NKdtArSNkZqipLig82AvrvxhMobBYfKHO3Aecv5c8msN?=
 =?us-ascii?Q?8IhkBjN5A9iJevotdhAZ8QhO6mY3U3ydTcHlGsUlhzJHeuZ7z+J+rFn9q8kt?=
 =?us-ascii?Q?n2rmQJOMbt0QGCP7Wa4uC8aoG1Qfn1PbL+PJw2uBTV1HxHnqs9p2bhA80jm/?=
 =?us-ascii?Q?5J5pWFCCMbFdOM71kCGEnJgzsDKL4lag5U4KSKEP8L6M0qWjbh4OLdh0d0sx?=
 =?us-ascii?Q?R5+ow95tp/aQqUoTeblG9SxkgsUfaPxh708ZANI33kdOYSuNm01sqTkvmA+w?=
 =?us-ascii?Q?eFrvANzjLqyFnP6wnmm6DK9o1TZrftIGlevy9vpqtgrOPz9u0+gBxCyWL58?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 775b164e-4e62-4872-a17c-08dd0ff68d03
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2024 21:49:35.8449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7964

From: Maxim Levitsky <mlevitsk@redhat.com> Sent: Thursday, November 28, 202=
4 11:43 AM
>=20
> Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> doesn't free this temporary array in the success path.
>=20
> This was caught by kmemleak.
>=20
> Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> index e97af7ac2bb2..aba188f9f10f 100644
> --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
>  	gc->max_num_msix =3D nvec;
>  	gc->num_msix_usable =3D nvec;
>  	cpus_read_unlock();
> +	kfree(irqs);
>  	return 0;
>=20
>  free_irq:

FWIW, there's a related error path leak. If the kcalloc() to populate
gc->irq_contexts fails, the irqs array is not freed. Probably could
extend this patch to fix that leak as well.

Michael

