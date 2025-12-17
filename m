Return-Path: <kvm+bounces-66196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5F4CC9BB2
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 23:46:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CDCE302C206
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 22:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C081932E15B;
	Wed, 17 Dec 2025 22:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oyrYMwIB"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CEB32D43E;
	Wed, 17 Dec 2025 22:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766011551; cv=fail; b=IuIzIp3bP5UzSgMM8shevYP/zsIiZ1dlOab4FLWORsNJMOHukZQxNf53DRn2dDGRewObmhiaED4Husf5gxgD/NmsGFireKR3r7vvRkxe9VlR/dHnXP7/QoPpcikUDoAK/bHoAsAfTljT18UIy4E5FmlswuDc/RJvZZ9drTD+bzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766011551; c=relaxed/simple;
	bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=skXcWomumSe3dduMVXA1v+VtP64i82azhJpFNqpiJy4WETV4TU4KU4HmH4pJD51tlMua8q0WLGHvA7DVN6KKDarABpsB5HaymTfETc7eDgVLDnV83H4zmp5gu4DAYZRG0opDshrbsIbddlWFJ/4Lv4/d66T0y546nTquDOBqalA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oyrYMwIB; arc=fail smtp.client-ip=52.101.46.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AF9H4Mv4C5yYvY4HXdX7j980smUKnOBUIkVI9jFf5xB94VmdQFUsKlMJNI3g6m3v1d1136LmTOpd8Q67lXX7baWJe6gF8nKwharXvxPaAEa1RSW3R9lDdGAqLe3C50BtaGci359YQtGqpAcPBnlzR7oIVr4pU+SrTYzgX++BYXOScqvooSZpW4zHFGSUzDx9wSHXU+mimWlyGw7HnOQSnQJFC4fUC2xM99gMCDzFhHiH/AWxQ3ICD/JsyPMCwMKZfJCdZKEgHCBlNjz8dphA17Kdy4THeCAEDMUY4MmGVXvdLX1T/jSTQdzbfxkIJKKeHYNoRUTJ277LQk5BxHgfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
 b=A8Fv7A0XYvkFngnrpMoRduUlrmIJPTl6iEaIqrqZfziN8iNxRnFp5phcdGMFcE1v6b7TNruo1x0QBoaxXWhQJbaZu7Lv0rbWUKS6ih3dVppn2IhMEJ1l2yIAUCxNVWoHPqRUruPd2vkikLhk/2wl27l4aZH3lxDNpHcO6T3PENBOKLCV2b0l3B98bGbM4YkNnkTQgKsyU/14HV3Io+RocwUVAwa3if3xklCuZpky/rDVvsY+h7zF9Seoij8Lki3C8HnPE2IMAp3yDQAmDzvEr61MtGl7ZGJuJ3tSktROUHyZHOXmJ4t9gi7tArM/d7biW/zIurzvaVtXKECTz1MQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmjOY8YZbZbWQ9GMKtdXdPlPz3rK6FGqYrMeiUdhqw8=;
 b=oyrYMwIBDItEVdTKp+omXEtMZcIEwl1YiAmD/4ndoWlGXYKxKHYOvZtVJ4ftwalejhDJcTxefdN++iqmAwOI83AdRvTfluM6NS2hTrDnAzqmSlppjn9ZG0MCGO+q3/fuLOqdM0tXBng1H6YETjqUoJ3Esr8ab22IVO/zofX7taDLkFZiWTQdhaPRVpptMn5qn8r7bRGfJJ3bh2qtIuYWYCvaZOWqXn1nRHKwZCjp09Yf95Gi+tZ5/iiyh9WXeyvmC+bhghmXr1ykfQ1CgxYPRv8qHoP928SF4DT0A8ZIFyHGcdQra0ZPNYc6FlLgul+YJfrxEWoC+8qT4Kb06w4mjw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 18:10:34 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 18:10:34 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Miaohe Lin <linmiaohe@huawei.com>
CC: Neo Jia <cjia@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum <skolothumtho@nvidia.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
Thread-Topic: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
Thread-Index: AQHca+uU78WraO9/5EOAmO3/L1n94LUlLXGAgAD5j7Y=
Date: Wed, 17 Dec 2025 18:10:34 +0000
Message-ID:
 <SA1PR12MB7199065CD785B5FD0BFE6FB9B0ABA@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
 <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
In-Reply-To: <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SN7PR12MB7934:EE_
x-ms-office365-filtering-correlation-id: 14b4d720-0a22-4b04-321d-08de3d9792eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?5CU3YVifES8PK01TdzXZz90Uz/wG1dpGfhanHjmGwg/RXOUxsLh046AQZC?=
 =?iso-8859-1?Q?0C5iG/uOxzfvlF5x1PgWPxIVK229Xp+qe5eC93yUj0P7eJRIUSzjqnWp2d?=
 =?iso-8859-1?Q?oUGMv1eo3n1EEdn8e+bxdvZTwFWwSyDzGjTDbois7Eav8RVbDd0xUR4vg1?=
 =?iso-8859-1?Q?Xpdcs2s4QlNMaaOOX6RytTj4hJc4asqdDxdxqWmoMi+6iMoMifYQ2DwTB+?=
 =?iso-8859-1?Q?gDYSmFPF5oLIgqARGskGSVrXJexxzfVzxxnyiv7Ho5FElroo7qFwIsePot?=
 =?iso-8859-1?Q?4DVCHAUqb7GvKNR1Mcwde6SJTAioGkGIVMlAWHGOvJ8fOBrjWlvKJw5dLa?=
 =?iso-8859-1?Q?wPrKbwCM4bLk1WJLUkw5oAI4MMhAsDZlOvAVp7Z5QcyDA6xl9jbltz/wKP?=
 =?iso-8859-1?Q?nQMSJcluTsbxYAudZffU2FCoXJyoBasSNPiIxhhpxZKJkKZtNzCz+V7FeI?=
 =?iso-8859-1?Q?m7kFEj4ToTkkiAOsqES6CRON/igBfcZ7mkeiV4kgangnePOUHPZLvMtQqG?=
 =?iso-8859-1?Q?BlU/wS2zpmIyogLOjMuGcrXQYE/WFMFe76mRpCnfqB9PTGcDgtmDE0PNVK?=
 =?iso-8859-1?Q?QZ1m3ez/YMLL78ve1nuJWrYlZqCNZLGphfsQ3cQI4jcQ/Hdl0CIedHczI0?=
 =?iso-8859-1?Q?pszRfZOlHTt+bdNw/F81k+GgD3tBrj+p2rITbOAaOgXVpUVgsIT/PlKp3c?=
 =?iso-8859-1?Q?IU4HR17XLTjZsBsQTqqzmidoU5UL3Bvek1qDlt6FeflZDPRxy1122OZUoz?=
 =?iso-8859-1?Q?2kn0EOygT8b+lhhLnz/GfW2TTLdmX2+ephERG9vqmLIOsfqvwegLVP58tL?=
 =?iso-8859-1?Q?MhixaY7ptB7hjr3hDOCttqgGzxr9rLRcTgfBMtfq417PNR6XoUwiQlmkAG?=
 =?iso-8859-1?Q?67tdMyxW7XVZ+hxT991LhOu2lFLBEHk1Ru4Y62mmXc5Qopzk1svzqKOUd3?=
 =?iso-8859-1?Q?ryP56c4TcF0pVGhpWUEkQ5wIpaS4dJoFOU0iV/d4DJ8lQ9wrV0wCuFQLdo?=
 =?iso-8859-1?Q?hQub3HUfrD/3BYTl42FYzeLpClwuwclFYa85VzHO5PDsYGVWPRDScmM0FK?=
 =?iso-8859-1?Q?5R/SlJ0sCIjVJpCrZVo9L6n5JerOlBSzWcojFTb/PLL/mJjFDYCQ9hctW6?=
 =?iso-8859-1?Q?PYrVXV+pYpYX+iCOZ4SziOQgeJo0aaK43p9TjrCV+Fgn7AlAeFFRJZG2rQ?=
 =?iso-8859-1?Q?QK0Y7ZkOno0Z7EcMAzCraWvDdAK7adJJxJ26c+6kt02BYKycOwTHjjJcBf?=
 =?iso-8859-1?Q?uBlG2LUuuKaq2kzOqKrUE0hFf7eWbvcdNPfaEqIS1Yj0s4rqC+/7lzVlSr?=
 =?iso-8859-1?Q?vGhHGLDU1aC3Q01Sr3nnXNjU06MV8zGAbd2eRNRv1lpkNbEPewERk/kAvU?=
 =?iso-8859-1?Q?wzHl34eN66UoDdrlF/FRgzaT6im9hoa90N+LpMyA6AGtHJ3sLQtiug5u1F?=
 =?iso-8859-1?Q?3pab/bUlToPCvQYhv6jzYT3OImEzeTPkWi1rTk0jirkRfpnr42GSFrLROt?=
 =?iso-8859-1?Q?4YQQwrcziF0J8YXr+dogLR4zGoYnMtBk4D45smT8U46IHr8ytPBAUdN/1v?=
 =?iso-8859-1?Q?AWaEvs0boDE3lG4X/6d1NRe5RpzX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?8skR0hDqJc8nwYANzixzHKCb4F2kgyftYJJgWLqS/m62jWjiPLGyuch10Q?=
 =?iso-8859-1?Q?wME55kcMovxOq/Xo7ifXZ/xp/KljHqpnmOJUyCZQBW8Ws99yf4TzK+cJH3?=
 =?iso-8859-1?Q?UK7c1qyxO5sm2qgNO5Ns2sbbzMWerl/Ycksg2oohUpynw9sOMktPQODMnV?=
 =?iso-8859-1?Q?OjioEIFudIZt44dDjD62bIEn75WSPvFMhY9dsoXCqEHkE6atVDAKFaYM7d?=
 =?iso-8859-1?Q?H20s1FvvWnQrAMPp3lK3suQEHQelSFrEO5kuEsm4szBQVprzOYokFMKzTV?=
 =?iso-8859-1?Q?Jzca3tnxPWr0FraxRcNmn1Jn1WLEKZfkRymiHjsMYA6uM9qIVJmP9jpYff?=
 =?iso-8859-1?Q?8g7FGNNEsjY35SZzKtBHIoA4nUHxpxOBJJkHvOftwbcDCt74iD4b5t22dD?=
 =?iso-8859-1?Q?5+G72XWMlaZ5HQiwX8f6mEq9zPdW2igfEhBT9xScPwSEvNOkqlSFhbsT8U?=
 =?iso-8859-1?Q?WHo2sQ8fFHeGCv+5dk4/WAHZj5I4CCimU2G4RRKtEgpNXxJlItUM/uVLAh?=
 =?iso-8859-1?Q?0+Tq2WXAEqtFiVwZVYo0Am16U4nD2uiBNXsyRyJmRGr6dGSCb78VHl7reV?=
 =?iso-8859-1?Q?v/tzI3gKnVZdVYXwJa+9KtHbeKzUpRkaDGK4ocHufJEAQu+hM9hdXZpetm?=
 =?iso-8859-1?Q?+uJ0Hl9ttpmefEXTkTjeG1IOUZlebEksUXTzhKWA+0+v6d+CdmVmcK3IO8?=
 =?iso-8859-1?Q?LvzlgEJzhPV3jNUnkvM47kleUdY6gPpQszUJsBxtSpBjyglfsGywfnqM8y?=
 =?iso-8859-1?Q?UiI6628+HW1kglSQz16Ta+clB4Lcn+LcRDHyK5pTwHX01ZcuJqLXBBhmai?=
 =?iso-8859-1?Q?NOBqjzb54vRfaN6cj9b0Bd1jyFnMeCTtKL2eUXn49YfT8z4n+mthymRdE4?=
 =?iso-8859-1?Q?F9pRNmVSSKoESc5xd6HiukhgIWZP0/cJzNAuoDNU1mwXjKAr88C8m9hHg1?=
 =?iso-8859-1?Q?z2CxnGksg8XXOCcKMhvihpkxwmTH5wbSGuKbToxlHwzfAr0PbBqfyVww9n?=
 =?iso-8859-1?Q?tvzi5KdRN1HPOwgIym7GpTwyD422iQaHWL8k9K2r936eSMTwl1wJW4zW+w?=
 =?iso-8859-1?Q?CwEmpr8VNe8iuDgRVALNmp4QmZ7gmDfaH5Wjz0Dl3xltPDeSwVAHMFdA7X?=
 =?iso-8859-1?Q?rLqwuLqRy3JejFzLc23fITcb1v4/ccsbaCRYVnLTGoeO781RkJJSkN3zHd?=
 =?iso-8859-1?Q?sitHzyLMgZ9W/GI6+8luwAPHy6owh8xlon/D+SZkgC19xNzPJ9RdMzqm7T?=
 =?iso-8859-1?Q?pVUPWTCdfiJrVCuiMKQfnwfAaPQqILGt1pul/WDIvpaq2vkjgFzql2TztG?=
 =?iso-8859-1?Q?PPynC1Wz3hstVt6lROnZygU9ViLanjKaKETN+ni+qpuSiIU/08sGDP78tm?=
 =?iso-8859-1?Q?zK4lpDVL3RJqE895cwh0EoPaxyYXNLIF/zA0WhJt9/qYqvoLsaTFP+W/Xl?=
 =?iso-8859-1?Q?CRSJWU5Lcs7zCSUH73tH77WY2ebBVzwengvyGsWNpTx/Tns0FQsLptriv5?=
 =?iso-8859-1?Q?A+geYovN26m64KEsAcJ8lo7TsrzqzSsVi7O0XDg8R33AyCrxCfm8ZF/g0z?=
 =?iso-8859-1?Q?xf9B1B0ka3ikUGJ9ATXGscFNdVvA0EUpPFTr9gFB1Dij66UIWEYo8uxM9U?=
 =?iso-8859-1?Q?CG9XH9Viu3dmk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b4d720-0a22-4b04-321d-08de3d9792eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 18:10:34.7369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rhAyYvEM/UW7hsw02rGD2neCJllsJEfMhMaGrSepYSWdZDhRikGMFhY8NrJtOmZzVBjIP7r580nvGukawvnBLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934

>>=A0=A0=A0=A0=A0=A0 i_mmap_lock_read(mapping);=0A=
>>=A0=A0=A0=A0=A0=A0 rcu_read_lock();=0A=
>> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_spac=
e *mapping,=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 t =3D task_early_kill(tsk, tru=
e);=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!t)=0A=
>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 contin=
ue;=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vma_interval_tree_foreach(vma, &ma=
pping->i_mmap, pfn, pfn) {=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (vma->v=
m_mm =3D=3D t->mm)=0A=
>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 add_to_kill_pfn(t, vma, to_kill, pfn);=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 vma_interval_tree_foreach(vma, &ma=
pping->i_mmap, 0, ULONG_MAX) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pgoff_t pg=
off;=0A=
>=0A=
> IIUC, all vma will be traversed to find the final pgoff. This might not b=
e a good idea=0A=
> because rcu lock is held and this traversal might take a really long time=
. Or am I miss=0A=
> something?=0A=
=0A=
Hi Miaohe, the VMAs on the registered address space will be checked. For th=
e nvgrace-gpu=0A=
user of this API in 3/3, there are only 3 VMAs on the registered address sp=
ace (that are=0A=
associated with the vfio file).=0A=

