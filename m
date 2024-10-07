Return-Path: <kvm+bounces-28078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBBD993397
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 18:39:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92BC51F247A7
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 16:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76991DC1B2;
	Mon,  7 Oct 2024 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="puvWEuKS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E71DB937;
	Mon,  7 Oct 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728319038; cv=fail; b=Ug8CwtLsh2IjnLMjDdJfMlfShcCJeCY4fYi737yb+JsuehHuaHGjH59YrjNal5B7O5QaDA0edfcAQjJGx31cXZP8cBdOpBpTHkFpTo+WIMbJuYVqKxREfEmMNXyK4XVLKHZqmf4VNJGr8NIffu9FchLovj1tEcS7BPlS2wGsiak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728319038; c=relaxed/simple;
	bh=VNvqq20JB2y4WX/OkC28qC1Y84eSXTAL8/GWT1nWC9A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AeA+9Kn0A7C4JrkJ9THKcx3nllASIpOgUD9Cqe96QIBNaDRaJM9mftoKooFjK6+8vXgdpV5CRa6zZU1wT7g9Ip38f9RslXfxJXamYM4b+Pt1tz+q26zWzua3kGT3L+jQ6eq7snQkUm7m+Zw2yiNMQ3TQDGTJ7mVcrmKM/+M2ICc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=puvWEuKS; arc=fail smtp.client-ip=40.107.212.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0UOXOnR2kXpbAcXZm7RXG8MBdLu0lUlvZsFmYaRALOLrZ5nR/OHS0BxCPH3dklzra1x3mAd3Wh1tTlnzmeKLNbGD1FBqSX1yUEsHzhJRaX9wsIpowg5LppvMQeLVBVov85xLAMZsBPnRziywbgcz2o2hA+2DDIlw0eIOWqDb3WSDyLPx1HQIGu5i8Lm3+ztlYE9TFX8NAlOCEgY3sJf3LlKCUsoAWtj3KMAwdKMM2IZgJtQIdkDNRUuJ2T02Xkjv1e3HP61QsrNGDCntad4dgXv026kZ6rC7KeHJ1awDeVfR7DodmixfrikfOABMsw8UTRrQlBFMtQR9Onj1Sg38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNvqq20JB2y4WX/OkC28qC1Y84eSXTAL8/GWT1nWC9A=;
 b=XQVW4dM8l8miW8RUQdsNPu+K5S62AWvkPsX9wZmkPaJyusXcBlVi9vBrFKnCpW/BtIU8qN9mE17UtpziQQhfhNGiWFTrzfz30pZZMpgYW0uufj7zDPv5mAPkho+CF3RR7MFRe6iTCrQcR2408ZklxopHvocxMr/u+f87WmEp1Nd4yRb9gm7hSyB3INOuu07wphWsraqnIYINcOcTefq5WHakDfOb+3s+kCD8Gxyrz8+jZD7ty/V1gIXxYtvQburLdDaK3GD7OpphwwPZYNNaonlq5C352MTyxhZ3wKGJ4hfjwl3DjNKDud7CS0q/GDsZYRsZP1L910BExbNtxMaiiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNvqq20JB2y4WX/OkC28qC1Y84eSXTAL8/GWT1nWC9A=;
 b=puvWEuKS5tC2Wc0Hy6nL2QJvaQ42H/oR6gEXjzZ8MIblbSTSQHM7tbpBDikiTY86ib+bsvmGCUROfhqPuYNKBX2BLdC2CXNmo3uu4z5Lthhy2jMjpyRZdBr7zTiJ9gaTO7uAeEPhqIwNx7UXbD+QRiI6XvfPIZbmhQt1IAnpYmscl2hsAVikBFpPP6wPa606+u2O/F7JkvSRl11smasqVEdUN1QW+aDCBuEFm+lDSPp8ExuZciFVo55BTG4xveMGUkNSxvYpbB8RSpEhShQxbP6ObdFmvMc9SLiZgA4D+oZxicOA5MBBiR9pXlYvLTLKlb0C8NCk+7wPvHe68zYVDw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH0PR12MB8150.namprd12.prod.outlook.com (2603:10b6:510:293::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.22; Mon, 7 Oct
 2024 16:37:12 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8026.020; Mon, 7 Oct 2024
 16:37:12 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Topic: [PATCH v1 0/3] vfio/nvgrace-gpu: Enable grace blackwell boards
Thread-Index: AQHbF9pjAi8Jnph6QEiEFMHiFwbtvLJ7WA+AgAAe2kw=
Date: Mon, 7 Oct 2024 16:37:12 +0000
Message-ID:
 <SA1PR12MB719900B3D33516703874CF11B07D2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
 <20241007081913.74b3deed.alex.williamson@redhat.com>
In-Reply-To: <20241007081913.74b3deed.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH0PR12MB8150:EE_
x-ms-office365-filtering-correlation-id: 154891dc-83da-4878-2149-08dce6ee4b7a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?T92xR7RkjyOO42DcXBS7bx2+YTtJsPUf207rB2BTLqiLeu9ZHK2ZN/wQhG?=
 =?iso-8859-1?Q?vvar7GVxSekK40odMxGs3UJu/JhF7EaC4V7JrBlu7ED2hJeKTAE5vi9yRe?=
 =?iso-8859-1?Q?m4/eH/RJo8CARik/Y92samTVBlq0o8P8UyKLxO7yqQedDYxbCRI1/DsPlY?=
 =?iso-8859-1?Q?TriyDjrDKKegukgAbrtZtvRY2fxN337tNFfLTmCOsBXnOL2OMX6Sqdeglu?=
 =?iso-8859-1?Q?2jJsqbh01UhFNXu+KNRblh9tQ8Op2TUMeSqdDyBMWCwB5Ek52AtWX4Kxih?=
 =?iso-8859-1?Q?X5U2jO2xJELjes3ZfIJO18AEfwe440vmPwnLG23YSNznrUnoQivSnvrVDQ?=
 =?iso-8859-1?Q?deWQAXZ4UbwerqPQszHQZTBN3cf83VEIYQiQY2fE6RLuV6jH24YZ3X1Zhj?=
 =?iso-8859-1?Q?NnGTnvX5sMXm3bUBQxcfPtj0q6NXfovLNrpTbC3xO9j3pbPJNAjbuqgWA0?=
 =?iso-8859-1?Q?7bIYzNGMKE45JAc62RrJdzu9K0jZUbIcjc+kghiCXonXdk4I8SS6+SAlJf?=
 =?iso-8859-1?Q?gqusyUIK7OUurFyzQdZlPyxkCNoNlSVtP2OyhAJaBSmEOeIPkyabG84FPo?=
 =?iso-8859-1?Q?1ijmuJCRINvxlu2soE/VrQ2pF/xHUXKpq2tvNHQkt/YOp8w7RkvRHGny5g?=
 =?iso-8859-1?Q?QgnfU7JWdPvHclWAssxkR3QvzXSX8ATsnvXzZpbO9zx4dWy4dVFcCY446K?=
 =?iso-8859-1?Q?ru3OKtN1RvMVSKvqC/un9KFlWloOIGELxKHUq9u2fFrNO4J33ag6zOlLc2?=
 =?iso-8859-1?Q?4/w+wP9tnKfzTxKdrDWTQzZCxaPi4w+rZd8nnB64luZP5QGBCmd71VOzpG?=
 =?iso-8859-1?Q?jQKI3H/5tkxaYRR1s7xG8KFXmhh9ARetHcDSKvUOXfrspFMZ6ZwPxfX10C?=
 =?iso-8859-1?Q?abDUH1pUrRXPkcKLL6j2mNUZTor43o+6tkCO3LtIN79wUdOAVhCFN6nANS?=
 =?iso-8859-1?Q?KVCyB58/Wfp3687H+Xb5wfUrSTgyiGGR0BJ9nBz+YltPAMOQ6473okcpxH?=
 =?iso-8859-1?Q?qgzaB7PlP4oKBaVlbuxYLl7NJGYmFyHnc+nUPlKdZ/wVXohnyvA5AqoUfm?=
 =?iso-8859-1?Q?Pz8+NNZRS9vlYFArhn8uY+n1OWLl9STsF4g5DOVculVsqQcwY6sQMDx3im?=
 =?iso-8859-1?Q?PxyVchsD76kE1a4ylxjvWj9WwIhi6/K4AHaJ4BeTvaHfFiIlpAXZocrm+u?=
 =?iso-8859-1?Q?3MeG6xwTLW+Auyo92QLkztzf1KfZmSQPl1hAR1q+wJIbsOgpT5EhtIOayt?=
 =?iso-8859-1?Q?1ZKIZ2oTb/tRzY/COdhyvqHJvZXqbO+eLfVM6HJRD1kOZ8NYXxzHWYvkts?=
 =?iso-8859-1?Q?kgLP/tc9d9YQLOfEdx6g8Kz/CHO+hWBInIOzrWQpznY+h4ZIl7crBFERLp?=
 =?iso-8859-1?Q?HW2ri0HguHpmpFZzIQn5LG7ZxyA4FyMg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?IcCxAfx6SWFx4HfJ5f8+rVJ99oZWAtaU7bDAvucyIY55hxGvVLyS0pkcVV?=
 =?iso-8859-1?Q?bLiv48sqTFGRjiPFQjyn+36x4A4bG6HL9MplZ1f0S+aKYffZTOWP7OQ06Z?=
 =?iso-8859-1?Q?KWf0M9iV9aIXlFyfexycvPsNLreKNz4hOte+UYyvUQNzYZhv5BXTm9pE36?=
 =?iso-8859-1?Q?gD4BDoGpnEWW8eFfGFiBET3GVkenZHswznI+y5PRLup1UZJy5vs508piPh?=
 =?iso-8859-1?Q?K3v5ecmCLQmL4gh4p6rw+jHSSLCI7s8YZf+qb4CSTcg6V0qJjWIfx6BeIC?=
 =?iso-8859-1?Q?5Ez1aWIQEmfzCBByJUB6lhIzhcRLmkAPiCpAFWRdH/4b3GT6AsLUvoQVmD?=
 =?iso-8859-1?Q?uvflTZNHxBJQ4LKrNLRRdSbEiRwKu8W1dSn81ISgVTvIwk+hliKSeyMp8K?=
 =?iso-8859-1?Q?wwh6hC68SoIxH8EwcnKXf3D7IvgJm/B3nr2fe44JQgabAmDE7omiD7O4h3?=
 =?iso-8859-1?Q?WxVH8ykyp0WMfLj1b9CTOMvwAqLTZG7/Kn2ypNyStC50nlmeETclK98JjT?=
 =?iso-8859-1?Q?ATM/B+wp05Z9YFmrXku5IDJZ0QU/nYvV4mTrPU3C/wJFBLUIM3KMJ2lEX7?=
 =?iso-8859-1?Q?kgtVsLGONkRbnA9YC4LRFx/e92TuzCQwLepVyIR0Hq+52qppYoR4qzSTzc?=
 =?iso-8859-1?Q?OgEse4A2iQ3fAzGqR0pmpo4fvtrjGl8bHWUnlSmO/4bds0t6xVyGov7vVk?=
 =?iso-8859-1?Q?q1vKNfqck5jKObCf280/ru6CU7XuObhq5GnTOe/IFlItP8mWJSCLZ7+712?=
 =?iso-8859-1?Q?ieIrGM/UiAm0ccS3kV3rpMCe8BzlfXROvAxDYBUNZFoJGy0NcH32oB1a6L?=
 =?iso-8859-1?Q?Rr/lhIVnke0lVnSWFOOiOLALe9KdPVld3V8T0BaN1gB93IB5qpga0gJOgq?=
 =?iso-8859-1?Q?gDn3PaTZiPyGNUdpCzM8x7PCv+GQKqO0twCwm/WdYr1vxCUu5RLrPOzO1c?=
 =?iso-8859-1?Q?g/eXG+EAmXrsDfF5oJ8R1+0Zr7O/7Xq7umlQiteG/UCxgdvqi76KjOOdaQ?=
 =?iso-8859-1?Q?DoOqF4suOo5nHTng2AtDx1/F7Aj3ztPaqfx4LqXAz8Zsks9LBWgH/svb/6?=
 =?iso-8859-1?Q?7vTOlWONHq/z1We2OwTg6GRHPrHa8LpOLsl/RQM0U6mpSwaGiTV9FncuVx?=
 =?iso-8859-1?Q?Z99tlpxDXS8opuaKviwExjSWdrK20DgImqYsabRuLVkUJtiHbhf4ZjS8Fq?=
 =?iso-8859-1?Q?vjxYcfbNvq4uVCL0NMlqDpatNSuPCB6dJDWPaWpL9b2GppNs5fCpW65fQb?=
 =?iso-8859-1?Q?ssTGq0XUqE36LB77ruKlh7HDuomyj4PlJMXKz/pbv0rNGfkqRZOJoI8Elb?=
 =?iso-8859-1?Q?y87toVBpsfR7PXk8Kka9c9AGgMB4EtlS4Dc0WySx07BGL9fFyxgfBldu5c?=
 =?iso-8859-1?Q?tZ0oZYkC846FyahOctPkuROH4tLCOCrxhpTZX+q2cTQvIFCZU6Tp0loZiD?=
 =?iso-8859-1?Q?7/NZZm8AtElM6ZZBVQofEj07SwYhmb0/sOIO/fnEw2JrZaXsOJl5eq/aqQ?=
 =?iso-8859-1?Q?Q3uqtX+Yur57SvMMm4iN2TKLLknFq3oFdjR3ZPVJ393S/V0Xi1KIV1wZ/Q?=
 =?iso-8859-1?Q?XMBqlRetkEYv6pBW2YMoWrPjUUuFBLbl7JHX/pG4NyeKC5xvBR85J+WG8p?=
 =?iso-8859-1?Q?/7FbY21fNVShM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 154891dc-83da-4878-2149-08dce6ee4b7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2024 16:37:12.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1o/lSmJQ/N3ErXSi5nudSozFDKaC70z38pjtTn9Ax8UDgui7G03YAitkVCnORHsDk5+ZPtuo/06bYfjwT/9Z8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8150

>>=0A=
>> NVIDIA's recently introduced Grace Blackwell (GB) Superchip in=0A=
>> continuation with the Grace Hopper (GH) superchip that provides a=0A=
>> cache coherent access to CPU and GPU to each other's memory with=0A=
>> an internal proprietary chip-to-chip (C2C) cache coherent interconnect.=
=0A=
>> The in-tree nvgrace-gpu driver manages the GH devices. The intention=0A=
>> is to extend the support to the new Grace Blackwell boards.=0A=
>=0A=
> Where do we stand on QEMU enablement of GH, or the GB support here?=0A=
> IIRC, the nvgrace-gpu variant driver was initially proposed with QEMU=0A=
> being the means through which the community could make use of this=0A=
> driver, but there seem to be a number of pieces missing for that=0A=
> support.=A0 Thanks,=0A=
> =0A=
> Alex=0A=
=0A=
Hi Alex, the Qemu enablement changes for GH is already in Qemu 9.0.=0A=
This is the Generic initiator change that got merged:=0A=
https://lore.kernel.org/all/20240308145525.10886-1-ankita@nvidia.com/=0A=
=0A=
The missing pieces are actually in the kvm/kernel viz:=0A=
1. KVM need to map the device memory as Normal. The KVM patch was=0A=
proposed here. This patch need refresh to address the suggestions:=0A=
https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/=0A=
2. ECC handling series for the GPU device memory that is remap_pfn_range()=
=0A=
mapped: https://lore.kernel.org/all/20231123003513.24292-1-ankita@nvidia.co=
m/=0A=
=0A=
With those changes, the GH would be functional with the Qemu 9.0.=0A=
We discovered a separate Qemu issue while doing verification of Grace Black=
well,=0A=
where the 512G of highmem proved short here:=0A=
https://github.com/qemu/qemu/blob/v9.0.0/hw/arm/virt.c#L211=0A=
We are planning to have a proposal for the fix floated for that.=0A=
=0A=
Thanks=0A=
Ankit Agrawal=

