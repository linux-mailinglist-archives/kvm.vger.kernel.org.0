Return-Path: <kvm+bounces-50636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05469AE795F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 10:03:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E3DE16AAF7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0125620F08E;
	Wed, 25 Jun 2025 08:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="gHZnIYX/"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020125.outbound.protection.outlook.com [52.101.56.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590F20B1F5;
	Wed, 25 Jun 2025 08:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838585; cv=fail; b=o39+Pk/UIxfoLCavbM6JJMc7BSQKyssUJ8l26Gtz/yYKaSmNbi3p6BJuu4jBwosw66pX07/AIJr1MWjerKbse+qq3A748WjRgaBGLC2FO4mOfDt7m/2bnsIeD30HAgRBTl0GFOabs3GgBOVrBT7oLH1xuvsRn7poHW29eNVxOAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838585; c=relaxed/simple;
	bh=5FGi3XQ3D7A8xrG7lZ344QXrju+fr6QHEkDGwGSmyqg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AWUBjOLNRQ34oTrKVYZhF7mUqXQ8q8iVSYgAjgRTHbWYb9NkLKQPS3A6wxpc1bCN40898wpMCrLkBuylgzhwScsTujNvV0SXCn+Z0zhT9TDaMTYl7y2+Sld3wHSmYLoAB/Skls59GP6zIyiXZ+wM6EPWIQrTTsCPoD8uAORsfNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=gHZnIYX/; arc=fail smtp.client-ip=52.101.56.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AAC+X20xVXdMP+Qf1iErs3a42y9R+fOI3NI0C0OXersBAOodNQlAd1xcFcARBGmgFCudUB7s7OWekyeF+/3SQfq2AUGGhYPE7FVhDUL8nDkqeHtQNBQ/mS5p9YccgrhuRzIaap1Z0+JZEhUSyNCzm6D2c4p8rdKz2Aw7ef8O+zWLHoWo56i5cUjGYQn1VqqZ5qVLRjyff7EIMi+RnxyzwP71GP7oeIbK2Zl5bc6qPCjQ8p/Tm2OPZqzNIBwhauCdkD/Gy/JCUNS395Uq5N/GZN8a2NN2kgL0xtd58JU7qq1bBVr05ohlUtP/YZvoeW0ZdbPSRqBctSPKFagwxlDp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BBQ3ggOo7Wjr02gaiuUVKO+fO3G/9NsNux3g20tgujU=;
 b=l7Z55FWjltQRQshfyKPrfdjxrpwKrpgL1whKaf5AJxGIfqKOpXIGnTjqA2dbNl/Fdnj51IPBIO0z2PhbVu+XL6+lQ5TmSHh0hG6tW7J9YsoUXhZloyHFmESdRQlLNAbYaSHvYGG/vNwhWdVNoYIA5xEX/0VMnCNYdPGnNEhLMipjV2lw/o7ZiVpv5GNcoUzIxOuIMW7liHjN+xp9WVEF1HjnH3z8/Rhs5G/CP/XGapC1Ng0M+m6MWb1EDKLpPpCV2yYW17xB6bXToT5eXDxiMAOKY83PAP/kKIIAvXRhXeXfRmhk7XYtnR4dF61JFZptkO5o2Q4571NVHSlb1/jIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBQ3ggOo7Wjr02gaiuUVKO+fO3G/9NsNux3g20tgujU=;
 b=gHZnIYX/GNPEACqSZLwffHXqKLjxp5zgQphMHz0DrOb+sst4V9/AS63PS9vlJPEt6d2JJ0ywgchpfopzVhEBpfe+Lhw98snDbW9uAMVyE75ZYrW6DrAGzNunz7+fm8XG2midV62Z+eJ2JIxEleypv2LSDHAvDbRe6Cl/v1il3l4=
Received: from BL1PR21MB3115.namprd21.prod.outlook.com (2603:10b6:208:393::15)
 by MN0PR21MB3098.namprd21.prod.outlook.com (2603:10b6:208:376::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.17; Wed, 25 Jun
 2025 08:03:01 +0000
Received: from BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79]) by BL1PR21MB3115.namprd21.prod.outlook.com
 ([fe80::7a38:17a2:3054:8d79%3]) with mapi id 15.20.8901.001; Wed, 25 Jun 2025
 08:03:01 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Xuewei Niu
	<niuxuewei97@gmail.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang
	<haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC: "mst@redhat.com" <mst@redhat.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "stefanha@redhat.com" <stefanha@redhat.com>,
	"leonardi@redhat.com" <leonardi@redhat.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "fupan.lfp@antgroup.com"
	<fupan.lfp@antgroup.com>, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: RE: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Topic: [EXTERNAL] Re: [PATCH net-next v3 1/3] vsock: Add support for
 SIOCINQ ioctl
Thread-Index: AQHb35WpeVM5DgeyJkaZiqfinVY+c7QTd1ew
Date: Wed, 25 Jun 2025 08:03:00 +0000
Message-ID:
 <BL1PR21MB31158AE6980AF18E769A4E65BF7BA@BL1PR21MB3115.namprd21.prod.outlook.com>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
 <20250617045347.1233128-2-niuxuewei.nxw@antgroup.com>
 <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
In-Reply-To: <y465uw5phymt3gbgdxsxlopeyhcbbherjri6b6etl64qhsc4ud@vc2c45mo5zxw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6d0664f7-99ba-4f67-b653-392e8982ca79;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-06-25T06:34:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR21MB3115:EE_|MN0PR21MB3098:EE_
x-ms-office365-filtering-correlation-id: 4f61f81f-b492-4ff2-fe86-08ddb3beb483
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?t9ruyRgNNhsbLGKPzJNqTymBYI0CaF90TgG+EOl/93xK+TKPWHE4Wm5c6anc?=
 =?us-ascii?Q?McM8oTeo7hW668+MnJFRpNqaYHnY8cdaKQqWzaqLnZn8Vmm8uQQfm8vv+Yev?=
 =?us-ascii?Q?NGY0Wh76tVRe6RZ0ZUvO37l+zEmdV+AbYyWEljBVJ9EO1+L7w7keFy8qpaHl?=
 =?us-ascii?Q?fkH/rk87xoVYosPV4VBW2KganMICi4GdzKe0+v6cd/+8AkrZGxnj3heg2StA?=
 =?us-ascii?Q?UPhM16yf1Xjxwl9XQ0feJa0EOkNBivHMAtkSjNXQcs7Ns7uHmEB9I9bK/A/9?=
 =?us-ascii?Q?8w43M/bRKpgXqTy6F8QQ9P3r3bprOIl6zFNlqw9Z0EQivnv0n0yYcXZo8ahS?=
 =?us-ascii?Q?S4mSlBdiCeXvMjdgACR8qGQM4TtHsEfaaCBmkVOfRt0OjhUpaR6kS0b/GGn1?=
 =?us-ascii?Q?1MSAZnqSC5Hk0xqs8YQz5irB8swfORinyrYHlAdp9kP4WaIachcApmO9khtW?=
 =?us-ascii?Q?jXSAN2I5qhmO6tT7tOYGwkuo69PLArDAthGwjIZ+264pSMYwMz0+4dTabYZk?=
 =?us-ascii?Q?H9OcCUPrBxvMbZ+SLmG1rPVdCKO0hwcmhggNsXlQMeOaT+roozUbGWDg3WWd?=
 =?us-ascii?Q?1DVNHXqEK7ZMORlijQy34dHttn13xzO5qjcmHu8anKC78CLd2VIu5z1L8Zfx?=
 =?us-ascii?Q?Ppbl13b2kzu5cYtZ8eGmSmGBiC2+b7tmyJOgmvA3Fvx4Lz2YUDPz7ALG05/w?=
 =?us-ascii?Q?OF0pGVCk9NA0prR+VNvI8vRNmIodemo13TuLPDvpRGSsKyKpJG7QyEd02H7/?=
 =?us-ascii?Q?1+8wwjTvhw1+Kur5pdwtpgVXzwqHFY5bDwq/o89Rgt9KOH0Lxyx8TjqqmMYn?=
 =?us-ascii?Q?CSW4SS2k1+V9TE1o278W2z8zt9+nTamvieD/SxEnijQf1XAaknzWz3bhGyL9?=
 =?us-ascii?Q?FtBs+qlgsh4nYq8b6z/7ffbHF431I23MtBdrejpbpoJgScwA4SYhwBdc7deP?=
 =?us-ascii?Q?ODI/1OXvXME6lvTlHZRaHI2lsIRgFU/0cBMfq8/k45CWHi5FeYlXjCwvAcxJ?=
 =?us-ascii?Q?qgzsJk6omEhGqXLk0J8BFtzT3E8B90Sxi3kgvLm3z2QB6MzWa6Z0Yiuarcij?=
 =?us-ascii?Q?e0ufLLOlazMsoBFN4dvm2UnHCiDPj5meW124kcHcVMO8YyuQK9AFwMgKUaNa?=
 =?us-ascii?Q?iU5xYIeCz1vvaIp29QUO3sDVpw2e7im2lx7pvp2O6/XXLMqvv/4bJPt5hm28?=
 =?us-ascii?Q?COxMiAtfAfyCxoSclU9Nb4bSLYyLWdMEPCiDbKNRwsDnXxaroC0ujRmfe3d9?=
 =?us-ascii?Q?WmwFm42BmWZM6MUp/C+FPRrx5VitD5jlaxLbmkwRrikAgzwTih6KLH1TwDcP?=
 =?us-ascii?Q?jZUmc2UFAVfn5sEc3yr9jUQdILeMkTt1Q0OHPJbuGoVQpYa+2t3iufYXEZfn?=
 =?us-ascii?Q?Cp0cUVR5Voy1L/EOhyVX1BUx02toXyB4TDUTmk20lAMiEIWCG+o0TwavFXVt?=
 =?us-ascii?Q?K1HAKjGHgovujvEPHZGNxabPTtIPmQbyiIy5UODCWt/Qzt/ORvqdTQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR21MB3115.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rSZU4F+vrK144m4IHkKdKDKYtUbXsd+8Kt21koEn/6IJlev+6ltfjp7qL/wp?=
 =?us-ascii?Q?Wzi6XfWDFMmRg9/V4pas/xsHvBxVumF8OpQ/xI+yo/wFwwHQ7pMg6+/Yn0Rr?=
 =?us-ascii?Q?KzaQ2Hfue1uvvWl1hWNQWtPiMPeFex9hu2/6D8tm+SukbtYFNlrR7ngDtAOd?=
 =?us-ascii?Q?Mw25fVv7l917NpFVpVUzZyfLC1Awkkla5nKH8b4jyT9GHJ6acTOsl6S1ZR81?=
 =?us-ascii?Q?VUHgILG2ue+49AAertaW5FaAS+Kw+F4YHdoovEkhKD+UgQ6rqJqyJXHir4jl?=
 =?us-ascii?Q?USi1tF5WEerIEPvAUA54F8AlxZSKC/6whyw3v/tvjccbkjHe3PHoA/zk/udf?=
 =?us-ascii?Q?yllVBUW4/QfAFrGKCI+UM/jzPdsGTYY1OaMn0gkCsCRwJQthjGvsOl7BMBqB?=
 =?us-ascii?Q?bY1YS2dy77waAh9nvZtvnBvaBhT/hNjQHB8Hd5IGWBC/uQMpIlT8CFyKJ5o+?=
 =?us-ascii?Q?zqcuSnPI09FIEg4k7kMSxV+f6dWuSWEJh6JrDYYDofUG3V5/ktZ/JOXRS5oE?=
 =?us-ascii?Q?BlLgNkTPVHeD5vuwqoY6cdzGw2WJuflBTpEIhucHtbVwp6mg1gSlcuAgtGR2?=
 =?us-ascii?Q?tB72gF6uedVQ60wLNzSV6naZ5zNj49SWBLd+Zz3xppb7PeE8+fVR/GTlNxde?=
 =?us-ascii?Q?S+HknfPz4+AK/mvKBaW4RLpNY7MMaiyvPKgvQprnzbOzSPIDD71ntvZC/dlu?=
 =?us-ascii?Q?zYnOJJkgsw0FFNQayutu5NoWPgHQGh2ppZT335vQ3P7jmXLqK5/76C2YRrGG?=
 =?us-ascii?Q?m/WBMROLKFgjRZAy7rmA2Bus8LvyJxwp5kV21hL5jmr5R4zzARrMCft5HUuW?=
 =?us-ascii?Q?pT1u2ezAfSyu3PLBDO3QALsRfdC2yMJQZG3JOuTBxP4OcVM+hkmgeI4DSswW?=
 =?us-ascii?Q?/47RUzMQjXe3LkS6qF0u12O1SrHd6u/hGE1OVU8/wMLvnYFlQazTzdAodTwx?=
 =?us-ascii?Q?bClHLPeGSXgYn+fBi0KoEpbAWJ2LBoAQRARl+qgTxz9Gkn+HDh6vP+J95z3c?=
 =?us-ascii?Q?+2BeATdv7PiJPCEZs4BHzN1HkFVgYsdhyhd1IHTS8nQZh8nZBOXDrKPibvD7?=
 =?us-ascii?Q?s+BCLyANzbqLY1CfwpYmeC30d9EJ3TIwT6uwihWodLOV/4ZWhLsq62jIQ5rf?=
 =?us-ascii?Q?PBfVy4ZNAw6xOf5hUcwQ02fuz7VnEX4s5VXRaZBFglo6tXIvN5T3dKt5JcX5?=
 =?us-ascii?Q?yWUAN7nMozasj1KgAUtbIqcAFrMml7DG7sdTXW52BHQ+CWxvMTbWPXENSreQ?=
 =?us-ascii?Q?j0fvmuCYmCvOrRuOXxiTHM74zODhINWXvUWhKboCpQ/NdcuCEilwzNAWQt/b?=
 =?us-ascii?Q?Ud9/6cngWnGXPEUEEHGAcrdlbDQKI0gvfMwHzyvDkCgA1tB2qC1GofflfX3n?=
 =?us-ascii?Q?2QPEYOQ+/jmlpX16Flc3ZEKtATEaFpBUxAxYCYEy0Ii2BLQzWjntgPW6Io5F?=
 =?us-ascii?Q?NEGFa4rjb8k6ZHYexETZwtEDo5sTkiEbtDdR3gRftBMjiREa74NB379P8qkb?=
 =?us-ascii?Q?vdvnAywF/Eqms+iRyAFzjbC1PP+FBtxoDXTzEg7NQf7HCEo7NvUhvKV0EBO0?=
 =?us-ascii?Q?Pxj5BnOFVZY1ufiLTYjY/SQtqhqv0ENFmQ6t6Soq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR21MB3115.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f61f81f-b492-4ff2-fe86-08ddb3beb483
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 08:03:01.0145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7OEagnsCIvQkqymk9ZcLZuXj4S26bYkGUvonGTbPxUMWHGsEX7SbgRShaB6YXkX8zzmhBAMD/OEEDFAoJDS4XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3098

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Tuesday, June 17, 2025 7:39 AM
>  ...
> Now looks better to me, I just checked transports: vmci and virtio/vhost
> returns what we want, but for hyperv we have:
>=20
> 	static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> 	{
> 		struct hvsock *hvs =3D vsk->trans;
> 		s64 ret;
>=20
> 		if (hvs->recv_data_len > 0)
> 			return 1;
>=20
> @Hyper-v maintainers: do you know why we don't return `recv_data_len`?

Sorry for the late response!  This is the complete code of the function:

static s64 hvs_stream_has_data(struct vsock_sock *vsk)
{
        struct hvsock *hvs =3D vsk->trans;
        s64 ret;

        if (hvs->recv_data_len > 0)
                return 1;

        switch (hvs_channel_readable_payload(hvs->chan)) {
        case 1:
                ret =3D 1;
                break;
        case 0:
                vsk->peer_shutdown |=3D SEND_SHUTDOWN;
                ret =3D 0;
                break;
        default: /* -1 */
                ret =3D 0;
                break;
        }

        return ret;
}

If (hvs->recv_data_len > 0), I think we can return hvs->recv_data_len here.

If hvs->recv_data_len is 0, and hvs_channel_readable_payload(hvs->chan)
returns 1, we should not return hvs->recv_data_len (which is 0 here), and i=
t's
not very easy to find how many bytes of payload in total is available right=
 now:
each host-to-guest "packet" in the VMBus channel ringbuffer has a header
(which is not part of the payload data) and a trailing padding field, and w=
e
would have to iterate on all the "packets" (or at least the next
"packet"?) to find the exact bytes of pending payload. Please see
hvs_stream_dequeue() for details.

Ideally hvs_stream_has_data() should return the exact length of pending
readable payload, but when the hv_sock code was written in 2017,=20
vsock_stream_has_data() -> ... -> hvs_stream_has_data() basically only need=
s
to know whether there is any data or not, i.e. it's kind of a boolean varia=
ble, so
hvs_stream_has_data() was written to return 1 or 0 for simplicity. :-)

I can post the patch below (not tested yet) to fix hvs_stream_has_data() by
returning the payload length of the next single "packet".  Does it look goo=
d
to you?

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *=
vsk, struct msghdr *msg,
 static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 {
        struct hvsock *hvs =3D vsk->trans;
+       bool need_refill =3D !hvs->recv_desc;
        s64 ret;

        if (hvs->recv_data_len > 0)
-               return 1;
+               return hvs->recv_data_len;

        switch (hvs_channel_readable_payload(hvs->chan)) {
        case 1:
-               ret =3D 1;
-               break;
+               if (!need_refill)
+                       return -EIO;
+
+               hvs->recv_desc =3D hv_pkt_iter_first(hvs->chan);
+               if (!hvs->recv_desc)
+                       return -ENOBUFS;
+
+               ret =3D hvs_update_recv_data(hvs);
+               if (ret)
+                       return ret;
+               return hvs->recv_data_len;
        case 0:
                vsk->peer_shutdown |=3D SEND_SHUTDOWN;
                ret =3D 0;

Thanks,
Dexuan


