Return-Path: <kvm+bounces-68813-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJExNa5RcWkXCwAAu9opvQ
	(envelope-from <kvm+bounces-68813-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:22:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 703905EBAF
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CB29382234C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AB1449EB4;
	Wed, 21 Jan 2026 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lVzelwO5"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AA033BBC0;
	Wed, 21 Jan 2026 22:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033672; cv=fail; b=eTZgAlOKgGEPI1flJwIshFAvveVZIlInnWVX6CX+d/Py1ZnqJMFwo4l1RrKYXs/ku2Rm+dQQdUy32Cw0z+us177GdWVSkHAI1C4u9vsjOAvHCB956/gnT+L1VJ59Zlmxs2Iq5pUaWmHxM+DSP97/UEeXGISM0sz3hW0vtOw/Ia8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033672; c=relaxed/simple;
	bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fOqO6VAO501yKLl+kF9TTouGfAup6KMXfcqcln0FIxNoF5P7Hu5nqv0smKwkCMmqGJWRaqojGTpZdBjI0ciR3hakJZre03mUbMmvO9tC/a2UftBHvcOQC8CRuPhBG1R99LIshC6FypIh1b9L2KVvnKR2h9zmHs+YzNB++h4abCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lVzelwO5; arc=fail smtp.client-ip=52.101.48.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaI5KhloZHLCNps0e6rsZZUG/fJJzGHC8Z/b2QJEVm92Ww1NXQnFGR/KxavG+huzaIUFiwQANuTcPmpz2Cs50hFnOGOuboKuakQnYkn8tY29EhDyGEzsyXLJMUEVv/bSBPqZ9s5hyvNcDNFPvd/LHnUeFB73JQt7zQWCK2GG44aAvwAClwgvmYGlWWyb9652ySdKc9WOEn3H8ijoy3F4ssyqCJe2MK+KvooNIUB4MJJBYndQ9tOy9hdf3iZcdxpAP695FMgmjc0bX3S36IgrfLOdLB6C/+vGMC2Gg+/DG2EVoSL9duVSHJ0xIM/oqR++rqHg7GHWB1GO++W8favF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
 b=Z/c9rolqA+N4kcyHBnxgWHU2A+QBkvDRvcrDbWXqKoAEiorrfFXWQfDhRHOmaPeGWcNxtfvQP60p/EUNAa3j6GZuclC/G+/BlAF1zqz+3Rg1WLVz/IiJPlpH4s8/YlqyDB+pL2cv4AdEGHJ56e8/OiAzWmACiWq3KUkWSM7vcYBRCMK5DJZyBDxNmBBsoxj6nuhNLOKVyROrhHivdBgu/XYlrHm3fq7ekwMp1eDRDfttqIzzZdkSzm5TcmJn23dYIcu0XJVUhPxLh+b5mzkAPuCcdy6LfWptXmqTVfHXzVqwgTX5ShSq5ygxYqa0gJlgdcHJTn/JLck5U0ilZ0nLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Frif6f5nPpXYErZo2xLHdOQllGt6qYRyu2MVMyt5X/Q=;
 b=lVzelwO5wkAy+r08AAtBbGyd0+ldp3Dpzny3c4AUjAxq9a2QSxclUu3N7ukDm9poRI8NhoAnJ4Outczfcnirca7+KW6J8ad1SQHn1c+YyV2Bz79Vx1/J3BASBxV4iknxQZzgSRkHuS1jQraQp1zG1Wndf7RFsABZR7G9MPaWyA7DG1XAGnWuh5UTbOtwcuK5NklHKfcTYvMTjNoJQj+/hEUIoet0e5F4oYKYc2iWjEqMV682fy2F3TQJdUJgDCcP+3Ka7MEbej53c8ysjRTukP9ZutiBCcETPM7WFR72EYKDIsmj2AYZBqUx67xBSv0SjEuL4EUNHKiKv0sSf/IMlA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB8601.namprd12.prod.outlook.com (2603:10b6:806:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 22:14:26 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9542.009; Wed, 21 Jan 2026
 22:14:26 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Topic: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct
 page
Thread-Index: AQHcTCjI0pjrCheBKUOiFkE7k4wQB7VWDd6AgAASNA+ABZtFAIAA4DaAgAERvDw=
Date: Wed, 21 Jan 2026 22:14:25 +0000
Message-ID:
 <SA1PR12MB7199E04FC278F6F8D2CD81A9B096A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
 <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
 <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
 <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
In-Reply-To:
 <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB8601:EE_
x-ms-office365-filtering-correlation-id: 6e5f48b2-d763-47d5-c6f4-08de593a703f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?MLPmup9LIlG9nTY2rmLTbFjwQFO/QjMqNfScA7zGubLUPXsbTwPEB3Pql6?=
 =?iso-8859-1?Q?DkPdSBTEClo91p+0v0caNy3JKF/HE4pxrHVYNtXlMtAYYnSzE4WOw7BF49?=
 =?iso-8859-1?Q?yzdVr8bV4GptgYUe2Hfkr+WO7WLz00nxdHz5VPmmRXxaWZsUzXpvJc0sV4?=
 =?iso-8859-1?Q?6Aqkd2S37xhIitoBHqdCJ08bx1LS7nAZDW61x2L1/h4zDsJ2W8IaWNpxSz?=
 =?iso-8859-1?Q?tL8JttJfMlTAEDSOSS+hpTU+rpxoZpUQ/BpEEEH35ihBwIxiTU6EFJ9nDI?=
 =?iso-8859-1?Q?W4oCCDXOc47kpK4EzjbemJueUmQCKtYH3kUZJQyhAz6Gs0Z9QhKlIC8qB0?=
 =?iso-8859-1?Q?hmYLJtP/xYquHciUDo7plkdQh28SsaHl5EmVPQvcmArsGmW0b6uh40SNcK?=
 =?iso-8859-1?Q?S8bX0N1uV3sCrS7wSHIb3F9uWzLQUXpixKZfZcLhJdqvofakOdGwtQiNdQ?=
 =?iso-8859-1?Q?7AML1v1sAM3d5lzku9CVH+oRz7otixzt0BzQs8JrHvJgr83OZSknXdLbSa?=
 =?iso-8859-1?Q?fPaCPDHbJqNEDE4P4A10VRWtWRsI/W3L8FiM48fDJvdFC4EBZ++pqGcqaG?=
 =?iso-8859-1?Q?woC6FMdVg7WKD/P+eH2B/s3jrHQ3VgscUY0HeydZr1dOe01aarCtE7y+Ka?=
 =?iso-8859-1?Q?kh1iENdHS8yT1fmdHOzA/92RrVzu9ZavGRusxV8cWjoCrIZKO4WKq1VKc9?=
 =?iso-8859-1?Q?2r7Ba8BRr6h3JodN4TdUJFSj8TH20XZkKLBR7HUax8ObSPHJQuJDysA/3v?=
 =?iso-8859-1?Q?QOmlhDnfQOGb1YGaMPNFbSE5Yyxto4Me9Wy26sUsNxZPRWDv642csS1aeP?=
 =?iso-8859-1?Q?uhzLA4Dq634eNUgUcLwmVzJNaXXkBIcItlhoLh6FcxV2HIDR8Xm3uJN279?=
 =?iso-8859-1?Q?SZmJASrCyiPpeU39JW68tpPP82OrYga3NQOGIbuQe5v3oXTFcP1oZj/GK+?=
 =?iso-8859-1?Q?paVPrOuWG1eyp7Bqi6h3afn3otiZqkxOhZx5CCnXggdSqYEoe4vVpxt5SM?=
 =?iso-8859-1?Q?OiTiiSMoNde7KK046g2EsXIPB8zq0btXlas8ER0rV8eCmeY5l0kFTWBgFl?=
 =?iso-8859-1?Q?CXU2x58YJixphAR9nFsSPkkJmmk8ua/qsGxWKXJW5PrqVy/x/rXf+NyjYZ?=
 =?iso-8859-1?Q?Tf7CRphFvjFJjDxY7/wzJDZrtVQ7o2c6kbxJu1xI9RIpYa4tKXV+W00zMP?=
 =?iso-8859-1?Q?divlRa1RTiJi+vBPdJoShgnjhQH7RkySMBwqrG4zVAB3Zn2UQkaNCu0sJA?=
 =?iso-8859-1?Q?EN4QT3vAviOa2vz6d8gi2s6gb8L7CffTYsanG/Q5fQyOvo/v4kjt4ySdW6?=
 =?iso-8859-1?Q?SWWapIfQTlPqwqA6+e91T2EQZNtiRYbpstaiioOfADSNLWj+oB9iKZnV8/?=
 =?iso-8859-1?Q?5X60QB8b3oVoHq/q9kSWxsXKxTdYKwmDdm30uEud+ZTX+kecRPdN0UQ4Ef?=
 =?iso-8859-1?Q?Sh6DX1Cq0FTfZZzCpvYkKFySY2UE81AyN9U/CnX0gDwjKpZBQC5WluJ4TM?=
 =?iso-8859-1?Q?e88ov+YduiiM6tQ56PxuPTonVzjkFKEoHVPZyQQF+af9YvwcK8XsA5eYHS?=
 =?iso-8859-1?Q?I4XVa4G55A1XB9EAaFfu4zVaW0hVdfPUSjPhPCkr8FLRpwWLj+bcUhkU8I?=
 =?iso-8859-1?Q?EsAbLt8I4xx55btZf2EO0XVHI5CRtr0HeLG+P2Tm4F1/2oWWFbDxWNvl9o?=
 =?iso-8859-1?Q?waM0tRUbC0+VdgDpjFE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7jIPlu92DGXxNI/QFIM9jagWq1TMeQg4xCXoqXs1G8KUxIGghhjUxfwcOT?=
 =?iso-8859-1?Q?qNCQ+Zo8wUniBzWSew6nOfrQsIQOr6+tdZ6qFuIvMfXGFtdb3POvW9qJmD?=
 =?iso-8859-1?Q?uTgwGQgJhk9vU7ZrhxA1Wu+9zGBM5sy8QZEYnvqV3GHp7SyKk8nHg6wYHl?=
 =?iso-8859-1?Q?O6eaF7qq3e9OesDaJeH4FHIHbHg39WZS0F7HDYSMiUh4n8b0b+fvOMUpzM?=
 =?iso-8859-1?Q?jGBuvrT16sZxbD2RRymmpkCJqMBq/2Wge9jDxmcJqUvv49y+2/CmFaKQyM?=
 =?iso-8859-1?Q?raT9GsIeEnGXIV+lHt474o+nfYvymgM+7ycv5zp+L0+FVOOhfo52ptbRn0?=
 =?iso-8859-1?Q?33otVIb6IlyxQrXZ0q04YpRTRBu778t3zdiS1scrK1bU2c+EeLr6PomTv9?=
 =?iso-8859-1?Q?voTDnXKDKUE9xRgY4sIawwk/ZiVRVRKtB2OzwiOlQuxwQsivfnQVOOO9fX?=
 =?iso-8859-1?Q?zCSTr9m48AauXyrBRQHvvdILkHYq5q9iwQfe/yesfARXB9w/R86xP7PQ9s?=
 =?iso-8859-1?Q?njtD+kOmgtJzLzELzGiznSvNVGCnPjC1hdFx0SD7gvKZuzrY53aKLe2DPX?=
 =?iso-8859-1?Q?7QzIJEdiidMTWiklVEdVGVxr9Msb7abx0IBv4h3oN9TDPJ8wCI1arLeWT+?=
 =?iso-8859-1?Q?BwPsg45ULLfDQebPtoDmCJ4WsSYOb0DcsY+Ss7RlPDx4BCeXNa4pIXDjOc?=
 =?iso-8859-1?Q?v5DGCvjfxj9kxgC+PNwsmIos4EhEglAe4XyvUcoaVGaoVoZaLCg7tAUw96?=
 =?iso-8859-1?Q?ZhOQOiY3MC+hJBPcuvuWZPhQU3ajRwGQ8AB/MIQItug19kI9OEkbnmBVHR?=
 =?iso-8859-1?Q?Ka0jGBfG1HUR51PmobcSoqdeujp5GFPyvVm0Fq1el57AQ2aLGldTgm42MG?=
 =?iso-8859-1?Q?skk5yIvBqD6nsS61H6lGzxuoopTMvLYtvGwx6wdKJ24TuZjIPMnX3Pv3p3?=
 =?iso-8859-1?Q?EG4rJBe8uRS/O609qK5nZu6TcLxZmzOkWPxsZZUvgK0MO6Qb2YomsxTtzO?=
 =?iso-8859-1?Q?xsk2sez4sz+yCSv8MiXvT+so3DaM5gKA0CxPr+bRqCisDO8674FmNTSeXF?=
 =?iso-8859-1?Q?ApqhM1G1XYtI7Jq3QgfAvGQ079qK3spL3/+rcZPiQQOS7RodbHGcgwbDXb?=
 =?iso-8859-1?Q?hSDx3RgB5Rxein/PUvZIfmb3gBspU+nSGzNnb99ei5DBTQlM+9agCMXjGx?=
 =?iso-8859-1?Q?MqJ1TFmQGrD75KwPE/6LbIKp7Scg0v2swpA4OX98hJDm55XHsPBxpME81q?=
 =?iso-8859-1?Q?p245/s0CscRKKKAJNTqkobYg/O84a7rq76FrHegReqiygcj3SlBZg+PRwt?=
 =?iso-8859-1?Q?UiH5WrkpAw0U2AcXavPkGcOHXpFkCqfJ7PEP9mgwjty4t7jj5UGlY+xjdw?=
 =?iso-8859-1?Q?w/v0/5n3XShmpaNGcj1P5j3nOSGwxITvdSZ9xmukT02hyuUtJs5xSJa81C?=
 =?iso-8859-1?Q?sw16yfpjMi2HKcJcxnKZZTXv0ctwy3Wt+2NXwpXF9iwLxhDxOLYnb27Xpo?=
 =?iso-8859-1?Q?jicHZYFeRHo4dgU/WsSEvWqVYJ4Rh61Mgq/hNidMIBciRtg5yS6IfI3LyT?=
 =?iso-8859-1?Q?xOGbBOFGnM2IwuFihTZ6yChxTzPeTIBdnWKAwbqIiGx5CTnve6i2VQ2CXh?=
 =?iso-8859-1?Q?ta8A3wj3lF9CKV3yhvA7jrtrKESvXaa+AYWUIGuJr9VP525thOQMd0xcNE?=
 =?iso-8859-1?Q?dtJcyfcSKkvS4aGMhtmOAl3WKvaVE4vmLJ1Xp1kCbaQU3T9J0TdOlMQB9U?=
 =?iso-8859-1?Q?miGpnYtJb0wN/Qkku6krTIO1VjeyLtcwzIPeoxZq3M+tsF?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5f48b2-d763-47d5-c6f4-08de593a703f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 22:14:25.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ynuh29DfTPe3M/qPHhhfv1tqzZlHS6jmOoPaVIl+bKQSx5AlgBNH9x2WAYin/q7aiynLAwCDr/OHpXloxmGZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8601
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68813-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[41];
	FREEMAIL_CC(0.00)[nvidia.com,huawei.com,gmail.com,linux-foundation.org,redhat.com,oracle.com,suse.cz,kernel.org,google.com,suse.com,intel.com,alien8.de,shazbot.org,vger.kernel.org,kvack.org,amd.com,baylibre.com,infradead.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[nvidia.com,reject];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,SA1PR12MB7199.namprd12.prod.outlook.com:mid]
X-Rspamd-Queue-Id: 703905EBAF
X-Rspamd-Action: no action

> Sorry, one more quesiton. I saw [3] implemented pfn_to_vma_pgoff=0A=
> callback in nvgrace gpu driver. Is EGM driver's callback posted=0A=
> somewhere?=0A=
>=0A=
> [3] https://lore.kernel.org/all/20251211070603.338701-2-ankita@nvidia.com=
/T/#mcc9ccec90b1ca755ad9af0a821f5ce524fed0ffc=0A=
=0A=
Hi Jiaqi, the EGM change refresh is currently in the works that will=0A=
make use of the new callback. It has not been posted yet.=

