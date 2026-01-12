Return-Path: <kvm+bounces-67713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6275CD11A49
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6947C30D8AFE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0ED277C86;
	Mon, 12 Jan 2026 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3mEwv/7"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111E274B28;
	Mon, 12 Jan 2026 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211601; cv=fail; b=U3Mj3MF6RepiMLIuwsyw/T8MoWnPrrlN6JfTVhEJJFXwW4mFBLz4tdYWCliorg2bROitr7By9uWhVGzevbvPZlIttVr9dUlPBEqCcdjHyopqpjQyPJmSYSOJLf9JlibpfYBZVyplDYlEm4gPlTCG0bcQ7BZI3VAmk4mDsNC6meo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211601; c=relaxed/simple;
	bh=7hxSzTB/qElonrxkL11gku5kTduUW710uvQ/4BU1vIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T0TzWJXdnp7RSiF80Fny3O4KM4ZTYj9xw2GOQMx4dOkhAi1k+vYeIDhQxS+IMpZU8n+zjMW0rVbU1/jB3fPCqb2g3y4pDyupwN51+cNqD+TAN804zQ1pwXI6SVjLwS32X9kYwes3C6llxfwB6/iChQv8DfYGDZTTg6KM6bChPyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3mEwv/7; arc=fail smtp.client-ip=40.107.208.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+nvZMNYhbF7s7iqjJJnHJWe4t9Ubusx8VLhlEPlt/Zt14JwvE0hPGFxbh8aGEsLuoPh7GGcvSjdLvPOIz3anDWgEXvo3kg3B/cxNhqFaZj37Zn6BW/HCMa6Gu9xLeETW/7LtjSOzRU4I9ezW9mAX+rSDsPHCiC5aC7qxEY+AKvzoplYJNdwvT9leaZafznLVlCv5Hz1AXmQWJEIJ6qM6pZAaqiE9TaetTsX0iY6cFxYmZQRyqJUjQhUP4EBmdtkeIfKfkWTfnU0BgNIlkjptRxvCbZqqpC3txaoyh5MspcgfefmsX/e9O0RxoQzEJy52SZEVgY2wgQ2w+Q6YwqGWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwYLYVd4dCu497MuV+CbLqupp42NRiRQkk399ewT404=;
 b=he/h5yjLRES+MdFlLXcuOdg9vsk0k40ffg3hqOq2ChmYEeNvwt0KjzFYD2M/9bXKFp0AWjMoMrdeLDdgogfhDpHbcpnnLWiPcL+J+1MwHK4ANYfZV0KuIItuqpULTLyoHgN2iCLHYIDbSyvbVAeUKgBxkUd9rb0imtPgUVgbT5idi85iGGrXAmSKreMo4+zK0N9AchYmC94k8ab1XtToAOmA9hq1dJRymZtmZD4tBcukczMG3aYXLT62ZyZJDcpMsEyBecuBwSb7SDQo9iM8jiahlvAxy/ZWzgs/QFFkwls/qpuXy28oJ9760SzPSpnjHqmpSd3NBfJkwyYeIfVQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwYLYVd4dCu497MuV+CbLqupp42NRiRQkk399ewT404=;
 b=l3mEwv/7YKuHQIJrcpY6SiSwaJGN/4IJfU+cTiNYZdPKSBIVgBm1SI3+vwaBUKZ6HCsCNVStf7kLkUgoyEidnOEGNIOZ1Gs3+fm1CwefFBZaz7lKn+Z27gGMP0+cnoMt5snzcu+exiE+aJlsk+La56ze24D9btC3xzdeCKYAru9umKFam+wNp3KrXeV+dablvaBRDPUBtngmBefned9QL3ss4rWkG7nmvdQt7nes8kpR0wOerli80QUJMk9BvkW8LHWMD70wlGJAt1cQv10y5vxVoWlB4bb10OrKQhrsaDazt2iF7yvff+oYWYxjypO5qE+2M1jENgLvrP0oKY+l+A==
Received: from CH2PR12MB9543.namprd12.prod.outlook.com (2603:10b6:610:27f::22)
 by CY3PR12MB9606.namprd12.prod.outlook.com (2603:10b6:930:102::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:53:17 +0000
Received: from CH2PR12MB9543.namprd12.prod.outlook.com
 ([fe80::2e2:eb52:7dac:82ce]) by CH2PR12MB9543.namprd12.prod.outlook.com
 ([fe80::2e2:eb52:7dac:82ce%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:53:17 +0000
From: Kirti Wankhede <kwankhede@nvidia.com>
To: Julia Lawall <Julia.Lawall@inria.fr>
CC: "yunbolyu@smu.edu.sg" <yunbolyu@smu.edu.sg>, "kexinsun@smail.nju.edu.cn"
	<kexinsun@smail.nju.edu.cn>, "ratnadiraw@smu.edu.sg" <ratnadiraw@smu.edu.sg>,
	"xutong.ma@inria.fr" <xutong.ma@inria.fr>, Alex Williamson
	<alex@shazbot.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/mdev: update outdated comment
Thread-Topic: [PATCH] vfio/mdev: update outdated comment
Thread-Index: AQHceaskLiquktmLqEyuhnjF6BCc+rVOXwKA
Date: Mon, 12 Jan 2026 09:53:17 +0000
Message-ID:
 <CH2PR12MB95431AFC698BFB2618A84F27DC81A@CH2PR12MB9543.namprd12.prod.outlook.com>
References: <20251230164113.102604-1-Julia.Lawall@inria.fr>
In-Reply-To: <20251230164113.102604-1-Julia.Lawall@inria.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR12MB9543:EE_|CY3PR12MB9606:EE_
x-ms-office365-filtering-correlation-id: 39f2ba50-890e-4f0c-6729-08de51c06918
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?kUV+fK1cQdfR3r6++0gY5PIOC2gpveQpr935ByDEYBJ/UjuIkDyfO2FXCusQ?=
 =?us-ascii?Q?IlrjzrhjY5eCA0pVa1TMdvvgBFwVD8kRqSC4ReJ/vMVmgRvkOe/SI+eY7xSb?=
 =?us-ascii?Q?Xfn3jsDe6h/vgLMX5KemZx5uBbS+u5Bd7nhxj27sc+kAUeeBxZMv9d8+waUP?=
 =?us-ascii?Q?UAahZF/W+upnas9K5IVokEebl1Zv+34fAOflJ8vksQAqXN/xnGnG4T6Ph5ip?=
 =?us-ascii?Q?5bq9PrcYbt17MZySADkYFbqC4Y4n0ps6A/HedL1a7iCF17mvGRIYZxzsTRvF?=
 =?us-ascii?Q?Ys+LOmT+FkirjgHvZbrLcS53Vf2wxpsKEU5c8k9eWxEvZ7ZCj5kq1HKaeTYY?=
 =?us-ascii?Q?qZwh9ZokGofQkp14CNQQks2M0i/xYL4+VcPfJFtJ1A+AEmyx2Yx3ePB1/e/Y?=
 =?us-ascii?Q?Y577+M6hDf114T5/+OPjTRvDRleuU0YZFPWDtDyO3d0HHNTEI1rJDwQ2saRO?=
 =?us-ascii?Q?z+cnhEq0OKbHIpfZOjuffj/cAovFRvqRyxDyXiGQhGp5iTp5jRD7NosGOQSC?=
 =?us-ascii?Q?o0Yp8XRcxxUuhF0zf8J7bplrMxvASfDxB+WI99r4a2L8SxzUVsSd2TXXJRXj?=
 =?us-ascii?Q?isjaC98jfQP2YKSew+9CGuWTDE0b99ukVyTBC8fuamCCpUxWtkGLwSGJWd0A?=
 =?us-ascii?Q?cBOQs1kS5a3eU0rYGdt8d2kjQl/G3s7J/y9ensrnDQBoYpoHh3usvZIW7/Vs?=
 =?us-ascii?Q?tah7ys9tjH+zgJXHZ/2brn19wagIg1T5O4Zxjkv5urDgxjC49gSr0Mq/sjYA?=
 =?us-ascii?Q?1u/8kCvpxQ06Vi3oa7FUXSoWhTdZkBk/tK6iG5xzre+bZkmIXkGNeYeM46ai?=
 =?us-ascii?Q?NEbEhHCbrBZDsD2caLoM8d0ikLs1qSEW6uoaNSU9yFnicE3iyWn4mTJKfpF9?=
 =?us-ascii?Q?scASVTO8sTML9oDHvJUwIRqg/gAGArR4jm6HjEDRoKbCDAWJiZIc5YcdAYCo?=
 =?us-ascii?Q?f/kgkL9Gypv5OEi+a+4U7iylleQ2xyuJgwotOBJMqebnEhwuMmfowHzUQatQ?=
 =?us-ascii?Q?qtkDCutUZwFbULCnSL4+ezB8hTKpqrJ8Ed4JeA86JsWZHwI27mc6kqItML/w?=
 =?us-ascii?Q?3YTVVuBfRRbliUW2Seub7avUxaP41KcW2DMda3BeMIyauwI25/bhM9VmVpOr?=
 =?us-ascii?Q?RX1roeZVmqvBAfJiutTVL9ject+yvSNuavguyfdtIOz4Z6YU5DDp/B0RyFHq?=
 =?us-ascii?Q?cWMHONwhde7R8luIdGpFZWmh9ICeDLT4PuwRgJD3EmxGbshKgsE/FQrxaYR/?=
 =?us-ascii?Q?GCTk5bHM8IcvMSR6i15SgZ543NpFHNeGm6bURGT35vpxQo0t4pXEzuHPSVn/?=
 =?us-ascii?Q?ceRrLnF3GiZ+gllVoVHG+ecgqhtoyVVTEzsG1RkDe7tACeYbROErRteocJ4b?=
 =?us-ascii?Q?czr7w/wT9G8UU65/LbBx3PNqZMtVGneu//n03TdbKx33FjBDDuRpPm6YRd3x?=
 =?us-ascii?Q?XPjA7gjHlLKQ9jbdj1aQ7TVKCjtg2+eT02u9y7+NV3e/XdqXyT8DcE/yJ0D0?=
 =?us-ascii?Q?GK04b+7bt9nowZWgV5U5hqhLhNhJeVvNSpwG?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB9543.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0JnvlQYeFFZYKHpF8Hz5/TDl2Q/vhkqzDWpuymdoJyMgTtI/iQgaehlfQZLa?=
 =?us-ascii?Q?tRWi6ryZbGXXPznWhsk1j7uc6w80/VeIAKaR8qZws4rCpYCm+6bZMm+mD9i5?=
 =?us-ascii?Q?kFvXhEjrcPyb1zEwMQpMjoosBLsvUrOIX/e4Ae2TMqHjxVN98hwoleaU+LDF?=
 =?us-ascii?Q?Bpgpc10Pyj4gSzfljGfPbmYp9orkQG495ch5BFUdBxgIauM00gcUC5VgGOo7?=
 =?us-ascii?Q?qLqORySG/CW8+DWCk0ftwmygfKLI11mtlyYcJycLXoy/zmegIieDtnHgOva+?=
 =?us-ascii?Q?qV71ezB6fzEmaMxTD41SuIj7LLMauESl1h4f5T0/S/BOI74J+9YaR3mxy+Wg?=
 =?us-ascii?Q?kmkePCrYJXPEOwwHj4yyqWIQoWOv+UUBHpCWUw8YoM5hl2mOw5hzqv5kOtZJ?=
 =?us-ascii?Q?NZPvMjXPdzhOK4ZYWDZ/KQIx8MXuwWSWHCxStAgrhojITZp9bJDWwv4Bvbw0?=
 =?us-ascii?Q?QlNylZ99QY20+KD/oSbQmCrHuHKNFAk3K5vix7BHdx6m1lr651ZnPBsB2b7C?=
 =?us-ascii?Q?5ONHwc2NzaejSMkv/8FeR/keGpt73m8HoE/gwY1OPym/uzlcBsb6Ta4v6YfD?=
 =?us-ascii?Q?rTUNRMRCAwaZO2sLKn1jTyNbXI4KIcfVb0UsDHvHd3AY8Mob+czwsRLRucJD?=
 =?us-ascii?Q?sOU/dcyTBkE2LuRHnQtKQ88LdVnfyZ+WkrIGjrK/AJKlp7GrTwA8oGk7s87P?=
 =?us-ascii?Q?4UbwRbU/CK4kKb6+mKKSO8nNvgj4ZRTplHMut+cGllmd397159K6TDQuSYBT?=
 =?us-ascii?Q?8bqREL7HeUxHv+lVgVYpXcLhd8EaJNTqPwICD3cNknK1RsK+ehYmjgM6/IYj?=
 =?us-ascii?Q?sSgxLfheEPqZ3fEfxvhQVbAcB8mPDy2Eg+tWUgrmA7qH/jOHFVBdgygU41rb?=
 =?us-ascii?Q?1L91dI1JY0ReSy/3YCWk19dxK7axCp7B8J1u8cBXVtD4tSX8euVQorslfNoL?=
 =?us-ascii?Q?8B1CqFghr5Efq2cZKdLIpCZxcLEJfRBckll/kz4vlWWKyLuLY0WIVJifD2qM?=
 =?us-ascii?Q?HvHDeSDfb22DoeX8JTHY0095hPqC6m0bp0Yv0cVhdQ5ded31tzUicoHixw71?=
 =?us-ascii?Q?ImoBjwhuVB/wyf5uWNk3tyYqA1SCLdMamrGQ2xJ/vH3Ag7NpZGbTBBwcS5CT?=
 =?us-ascii?Q?a3GJplnp2ytsdrIwefUPS6NVNcxI/UnDa6u8SDFvXQW6uHjlXkHtX2Siz4hO?=
 =?us-ascii?Q?Qvs3VRYJdUz1TrnqK2Utz6/3jK8Dg8ucoSGxGUoIN6prorC6PAOEm0tbSxPa?=
 =?us-ascii?Q?Ge26jTekwXouZpfLZGAEUnupKmYLfryblbgUKdGXD+ub0IJDfjxNMAJewOV/?=
 =?us-ascii?Q?8L5F2NORxaU78QX+nWXXSWdD0uWis6IXkmVWIVVvkXvPnhRBljJEWpOSpMUs?=
 =?us-ascii?Q?wJcJD8SVTlL9LTEUJyf/eWdHxyhgOzoDvIvMoxQaikzpj239tuQvsIrVrGwi?=
 =?us-ascii?Q?QKSrgpTGCmyILaScu3kFM5qBlOpxPZqZ5Om23JPCLLjPbu4x7zBE9UFa/Q/P?=
 =?us-ascii?Q?2JC6b8Wr1kqah5vgojTzXZWDKE+efR65iaP6gfDckKftfUbPfHTU5pGtZLOh?=
 =?us-ascii?Q?akwPglYOERB8agEn3S4f4nGgepub73XlqsUQhEMCBbWyWkHd5Z8YnYic4un6?=
 =?us-ascii?Q?8V4wKEMP2xn6j9yz8Zb9czWuidvp8NuRLgKvXDEDrs+EQ7wBJc3Cxw3dUfVH?=
 =?us-ascii?Q?r0lMyX2Yq3cwFQvDUtVoa5cEtEAk5v99JSEasJ3l9FMrezi7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB9543.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f2ba50-890e-4f0c-6729-08de51c06918
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 09:53:17.1347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 66tFBCp7DvgZxJ50dRAajMVVF1F0B91fZ/YwjKbke1df6BkVvB3kbOfLJLpk5zN919re6PozGG2xaHifHRXKxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9606


> -----Original Message-----
> From: Julia Lawall <Julia.Lawall@inria.fr>
> Sent: 30 December 2025 10:11 PM
> To: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: yunbolyu@smu.edu.sg; kexinsun@smail.nju.edu.cn;
> ratnadiraw@smu.edu.sg; xutong.ma@inria.fr; Alex Williamson
> <alex@shazbot.org>; kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] vfio/mdev: update outdated comment
>=20
> The function add_mdev_supported_type() was renamed mdev_type_add() in
> commit da44c340c4fe ("vfio/mdev: simplify mdev_type handling").
> Update the comment accordingly.
>=20
> Note that just as mdev_type_release() now states that its put pairs
> with the get in mdev_type_add(), mdev_type_add() already stated that
> its get pairs with the put in mdev_type_release().
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
>=20
> ---
>  drivers/vfio/mdev/mdev_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>



