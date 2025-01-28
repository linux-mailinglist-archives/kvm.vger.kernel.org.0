Return-Path: <kvm+bounces-36757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0F60A209B7
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 12:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C143A24B8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB4E1A08B8;
	Tue, 28 Jan 2025 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="kVuQMZIn"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011071.outbound.protection.outlook.com [52.101.70.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2E11A0711
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738063764; cv=fail; b=ZNE4RBKlL8Mz61Xx12hiJbkKfYwjbKHEefgGrCrCk8EjS1zBVcWW2l2x2l68CR/GGsD53qEUfnmoTP5dxDR9HfF9qotvrlmgt1HOEmEMA0x8MGMqmmwYU+5cRDJkMGPSgPVQYKSjPdTPXW4IBv9G/sKVrKDitH+X2Bs/xN580Lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738063764; c=relaxed/simple;
	bh=uKkVK8F7Fxomc9+INF6WAskwdNdE6YH8xLIYx51Q5Ng=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JpBl2utUQzpabO1dE/ALsX7cIqW24XNkjyZjP1/DRyd0WctIGNP7zDCG945N035LY3d7p2YKmNzbNBnfrCYjIDMzNdSUZHey5rIfg5w4m/sunRpXJGRa9ynldZIXMVIqtCNcw573XidNEVUmfviiRbwXG4i+xOLd0R214qd5nUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=kVuQMZIn; arc=fail smtp.client-ip=52.101.70.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+b5uxlaPnY9QJRP99V+tj6w/NcgtRqJg3VejJereMyoTz2tVHGXBipigbMRAE2lt2gRAqtA+WfpdSa/6UZ/jPdU4vIL/V78R3XOlHv4ScZncbICVVGWsJooHYp+44K9tFfJEYbzPiNaZsr+Rw7pBOeYs6JknYZX+OV389Kz5qrfv94T5TsHgOOPFG1DdVsm+odvLvf5oMGEY7gkmC7xnxyju5DGKMw+ob+BdUOBLDqudTggeA5TkewncpNtf73kcP2rSwlEgQHocz4FmpkDiOBbF3TXmqCcMX0F1knwIfSUsqzVpO3FTPgJKp1Kx7WubwSa5DblvnK1t8ftixUi9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CP0x8mN0i8NMaTdrqmLpRj+1swfy1Xuh3gJV3hfyQ+g=;
 b=sOHqaN8RuYpzbMwc1M9W+lngZd2KlPzo7M0eVCj2pAMM0WgDtwXLuD+2H50owQEuomrowHUJBBHqf/EfL/Qkb8A23Y4c2ubMxOJ0MdiS4w+iUm5EDJJiMBSKya+n7ijx52HDMaGHJet+4/NMTMAzj71XPz1XXJWZ2h94Pn3CIQ3WQnIYq5tkb2MxNYND7/k2XcaXfsRzUxdz2kkDJkUu4wdBI4rdUxlnovSFQ8897jZ/K0HeAg+d8ucq8E4BUeCB1UR0gjjwdrFBVxPqc/gBFRuKMBl85WDZg8v7ispdLckCVwAdp/R/ocCL3HNnP4qdGgUYdivd6bohA77o1lb/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CP0x8mN0i8NMaTdrqmLpRj+1swfy1Xuh3gJV3hfyQ+g=;
 b=kVuQMZInsESu4l5Jtb/H89j8vSGq+VsDrYgK+zzHLl2BufGnlMAEGzRsOA1XzbxWHjTG7nRal+6xf2Ua+eVeJX/rPz4MdrQJspQiv2hDJ30m9S3LuBtFS93QOdmBxebpWJb7SpaoSDzfh5Bv7TjDOpSZ6EUT3krVFZf537CtEd6bxmAhi3kEWs6oKd8jQ0qi1oQ2Cn377LA3PDbGv+p/nQcKh7swYZSCTGpweJtsbyRUu70tkgSRZqoc5prdc0jVMZ57BM7mxZ+4aLBN25qVtYf+2i3prJlsZkHmjN9HNSz2JRVNYBM1QPcMeyIWwZ7LuyRVOi729+BgtUezaBZDrQ==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by AM9PR03MB7773.eurprd03.prod.outlook.com
 (2603:10a6:20b:3dd::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Tue, 28 Jan
 2025 11:29:18 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%6]) with mapi id 15.20.8377.021; Tue, 28 Jan 2025
 11:29:18 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, Christoffer
 Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni
	<gankulkarni@os.amperecomputing.com>, Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>, Dmytro Terletskyi
	<Dmytro_Terletskyi@epam.com>, Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: Re: [PATCH v2 02/12] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Thread-Topic: [PATCH v2 02/12] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Thread-Index: AQHbcAaOrTBbbSLpA0ukEQZvbJQCdQ==
Date: Tue, 28 Jan 2025 11:29:18 +0000
Message-ID: <87a5bb18j7.fsf@epam.com>
References: <20241217142321.763801-1-maz@kernel.org>
	<20241217142321.763801-3-maz@kernel.org> <87frl51tse.fsf@epam.com>
	<86h65kuqia.wl-maz@kernel.org>
In-Reply-To: <86h65kuqia.wl-maz@kernel.org> (Marc Zyngier's message of "Mon,
	27 Jan 2025 17:15:57 +0000")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|AM9PR03MB7773:EE_
x-ms-office365-filtering-correlation-id: 274ec27f-e2ad-4e7a-7a16-08dd3f8f00b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?mzZogxK9nbwIdmjPRdUcTnk03tPX9Xi4IIljKEybJsJKXDb9a2tnJxX4sI?=
 =?iso-8859-1?Q?D5MnrSACQxgw6GL3wNAEX+zEp6XtJqz6c9aM328oT4LsfWd2Jz7fBraR5v?=
 =?iso-8859-1?Q?qlHZebQlDB4nD8FewmpuuBtino8GHxaPS4xWpK0FrWQ3bbm0PpfLPteXtV?=
 =?iso-8859-1?Q?Y8rLWcmNYIYgcERqEFHcIuZxTm3AQ4N+4YvBpG4ZfrNGL7U6M3VL6mKc9T?=
 =?iso-8859-1?Q?WOGw/bGg8Yp2r6CnVIGoMYY/MNgeMER+jAL9MbxKJ3aLSj2cqoVvtUIXph?=
 =?iso-8859-1?Q?mew0+6vk/BHeHtjoUUfCDFvXCMxt/RpLtC/tG7zHq2ehqyKKB1GBB3mBT2?=
 =?iso-8859-1?Q?GiXz0qJYK1W3JsoccVEJ9P0bvsM2Gq8poyePqo/wjBNrhBWQpcADq0/cW8?=
 =?iso-8859-1?Q?XUycDZNNuTOdwoypcwDBfnLG/OTAR/y8sf86cnwCynXazpsTkntIlqkth1?=
 =?iso-8859-1?Q?9EVuXkegMso5yvBdinufqcrMgKuIFt6BJq1vqzgN5lk9QY7YRK//uZaVnO?=
 =?iso-8859-1?Q?0DpwH9Fjouv9jx84R4t9NA5AxgNCWfiiqv9wI+97UjGbdyfL4t/yXWq7Yr?=
 =?iso-8859-1?Q?ewD+l+gDNp1xxhkBZCIE5lZSREh/nAXVVX8P/uiNJi0mAkVetmSnuerRZN?=
 =?iso-8859-1?Q?Mg9SVGUeaNkeSgp+KmL8lL/2ynq0cSwgS6osnW6cxkCFsJGg4yhGcMJ4xS?=
 =?iso-8859-1?Q?hgHRcgzr+1ViKJNg0sznbzSilzNXaz8Ls4zeddaf0YhTlKlbN9tAwdFr7p?=
 =?iso-8859-1?Q?n2gDdfKJb0oZPPbKXyRC+a25n408FsQSCZvysKPLCQBwA5PdjkFo6B297A?=
 =?iso-8859-1?Q?JxyFoFCGTE+jTkgPoQJHsS9M7IF6DLVMXFt6f5BkKgvA+C2nd/jHL7XVoi?=
 =?iso-8859-1?Q?6Hu82mKU/+MaHiUBMgSHuC49D54ZxRuSbjPOj2eA1JxiWmAZC562eT1A4g?=
 =?iso-8859-1?Q?gZX5BViJWmK0KYuzbNWIqnde3jj44WclSzPSFx6Zh6Khy99Bbol168LVGT?=
 =?iso-8859-1?Q?d+ONIVjK6koV+fJwHTwBxqFg3qwqPEM2WvImTj6asmZ0UNXr6HotDukbZU?=
 =?iso-8859-1?Q?9/YG7woGYDCNT8kyXGLosSBSctWGyEZQ+vrwIOwO0GcNp9YGK88GZSea2r?=
 =?iso-8859-1?Q?KkkUOExNK5/dRYSNih/WS9YzdteFNjDDF1xnlY4JgoKd1HSoszdwcZdOyD?=
 =?iso-8859-1?Q?KY3mSkuSRP7FJ8Ebnern0IZH4IzALlt+nvXikO6lsH5vFVdt+Rab/LNyV+?=
 =?iso-8859-1?Q?8e+Or1k9J77314XCtLvwv/P7MusBIM0dwtmFBfLfpvK9e6OES5rW5HI3Zr?=
 =?iso-8859-1?Q?sBkIRIVse1ppqkN71VKDntKmrahWsgStzCyP0uiZOOE/hUStFktHckDsGa?=
 =?iso-8859-1?Q?lqECpFroQjxDA90JkdLvUgrUOcsonakDx6oDqKrl4xhwLG8jFGQxM2+RYV?=
 =?iso-8859-1?Q?5X+ng/3mleRyYMCRvp0H0bh6kNMBNAxWHVTlGX3D42F3xGPNQZ8zzR2ZqA?=
 =?iso-8859-1?Q?ZGgcW9a05RqrVDXytmPGB2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?3rGpVmRV0zQnZpzM2oR+jltfD4O4dRBTQQl+tlToyiZiQACFRcHm0+nyS9?=
 =?iso-8859-1?Q?cQHOfjy5/mhunK2CE29dUoyZO098A0TQrNNVGc5Y7lt2BwSOjqqom6FO0N?=
 =?iso-8859-1?Q?4biZPtwD0IzW3oS2rI+p0e/AuMWN18iyXeVxPHZ9wVZp4/cd91K7NXu3gS?=
 =?iso-8859-1?Q?JAK87rnfvEPQ71GzSs34vTlbmjX5tgdty9HQmDnLeJdwDb+211qTvesHwk?=
 =?iso-8859-1?Q?YxycQdy6XEXaTG4BxE6sl9PNqh2fYjn5p6iOqzPtxB+gksjfmgRYm9SEjd?=
 =?iso-8859-1?Q?B92Tt/a9cDOGlqE8kHkvoLLd2r+MO1LYGA8fQl0EBSyS6o3MGnznd49mgh?=
 =?iso-8859-1?Q?XQ9U4MeXtl9Pv/oYwhf0PeVMOf0m4B44aopNtKpfYlvM/GLNEAYFnbUTmv?=
 =?iso-8859-1?Q?u0aQrUPk+MS+HizfFTYvPLQGJSLIdF12SOdoEIHPmNCD8gJ0RlZVigGwmP?=
 =?iso-8859-1?Q?x9+EL631F15pMzc6/d2HJiW7/GoDq2Pk8UwtUxRcafp7fO89IJJimaFZJJ?=
 =?iso-8859-1?Q?4qAxUv2vveI58gtnJk/xanJjlZxK0vmVxFKjPP8GU+1ZbC9zY5GZVFseTS?=
 =?iso-8859-1?Q?bIL3nl+tyAKkbtycyab2x5JTGakAXsWNDokCtYdvmM4YUVPnI5P5vLkxcH?=
 =?iso-8859-1?Q?ej6By5QvTMzvHW74qVZNtAeqb1l6hxowkDXARcq7kBbT/yQ1APoX1ZA0dd?=
 =?iso-8859-1?Q?btQ3ExwyFtivDyvNwNt5A8NWaJb0xtu6+zA7In/Wou2OdP0MeZlzPVhApV?=
 =?iso-8859-1?Q?k1gafpwj5oOnXBQ9YGZiVyBNuhn2IR5MaIDbWvodPTksGk0KSN4SgUPMj+?=
 =?iso-8859-1?Q?L+LLXP2u16iQzHdyQR4IZI9bVksr2LfZrcDcXl3UzlyBXZM1/e337jiZxA?=
 =?iso-8859-1?Q?/iIL3IWTL41QWXZtSI312qVsG+iUsXVDoITycA4A0fopm0q0PqJ5oIx3D0?=
 =?iso-8859-1?Q?3Wg7Lx3XsCrh/HdQWBgsE50Hk45xq3oMkBog9PX2rU7HKPfVTNdUCAGotg?=
 =?iso-8859-1?Q?ezMlLvfbmySFiWVmAO71nSqLCxWv63j81zg0j4+PEBOMqB9oFzDQQGVn9v?=
 =?iso-8859-1?Q?ovqz6ifnT2Bew8uKTv0mpaQUp/FNyN+gncV4xMp0rbWoHm5fJ+Lv3vrJsO?=
 =?iso-8859-1?Q?TrheHIckB3GvS9oQ+NBd2zLMl8WUrgZ0Jbngbudbixpt1QtPysZPUQVkiP?=
 =?iso-8859-1?Q?fIHz/opb5P6m+PCI0fUcYwF98PPf9HxJIimOC1UKwPQXWML8c55DSepGaW?=
 =?iso-8859-1?Q?QPO1zS/Wozy5oxcPl9OBg9XaK0basIeaXw0VkgS1Z3xL8Jft+l4SFdo40l?=
 =?iso-8859-1?Q?rRRD1W/4W4WDYpJMoqFIHxr023CsEQiWKyBvoKgpk/li8qJakL4LzuNGqj?=
 =?iso-8859-1?Q?Jf9EAjSCP7OD16O4l5Rfc9EbAcJ8sW5nDx65tGm7B1837RxtvlCqBGlWg3?=
 =?iso-8859-1?Q?cUQpN0bAcHt7EKZ6+jwOQ8Gr+QLoILedS6QZTKEzmEMQ9la6sACX8DKyP6?=
 =?iso-8859-1?Q?nuy0T7RcbWiSBma2QYplb6Y9IpjqTM/YTYZDcWd7PTzWtT+ICBbbhd39Nw?=
 =?iso-8859-1?Q?X3OsPHvMIMbzuljGHJt0puK7d+gkCAWrjEZZ8L8+hgeOnGiJc7OC70eBHY?=
 =?iso-8859-1?Q?f0UXZc4ZQrBumOrcnqsLiYIlwCHTk0CkuJgaKHlxgBcerZL9nVLoZamA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274ec27f-e2ad-4e7a-7a16-08dd3f8f00b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2025 11:29:18.0756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DDRPeYjNf6Y4Hqp6pYMAwSfyLQubh7wGCG9rEd75APPfIYQJbt1rAOF8gSt8lsk5KGod+Q7zYqLbTJduady988wBUrgl8f1ulL5gn97Q4I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7773


Hi Marc,


Marc Zyngier <maz@kernel.org> writes:

> + Wei-Lin Chang, who spotted something similar 3 weeks ago, that I
> didn't manage to investigate in time.
>
> On Sun, 26 Jan 2025 15:25:39 +0000,
> Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:
>>=20
>>=20
>> Hi Marc,
>>=20
>> Thank you for these patches. We (myself and Dmytro Terletskyi) are
>> trying to use this series to launch up Xen on Amazon Graviton 4 platform=
.
>> Graviton 4 is built on Neoverse V2 cores and does **not** support
>> FEAT_ECV. Looks like we have found issue in this particular patch on
>> this particular setup.
>>=20
>> Marc Zyngier <maz@kernel.org> writes:
>>=20
>> > Emulating the timers with FEAT_NV2 is a bit odd, as the timers
>> > can be reconfigured behind our back without the hypervisor even
>> > noticing. In the VHE case, that's an actual regression in the
>> > architecture...
>> >
>> > Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
>> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > ---
>> >  arch/arm64/kvm/arch_timer.c  | 44 +++++++++++++++++++++++++++++++++++=
+
>> >  arch/arm64/kvm/arm.c         |  3 +++
>> >  include/kvm/arm_arch_timer.h |  1 +
>> >  3 files changed, 48 insertions(+)
>> >
>> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> > index 1215df5904185..ee5f732fbbece 100644
>> > --- a/arch/arm64/kvm/arch_timer.c
>> > +++ b/arch/arm64/kvm/arch_timer.c
>> > @@ -905,6 +905,50 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>> >  		kvm_timer_blocking(vcpu);
>> >  }
>> > =20
>> > +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
>> > +{
>> > +	/*
>> > +	 * When NV2 is on, guest hypervisors have their EL1 timer register
>> > +	 * accesses redirected to the VNCR page. Any guest action taken on
>> > +	 * the timer is postponed until the next exit, leading to a very
>> > +	 * poor quality of emulation.
>> > +	 */
>> > +	if (!is_hyp_ctxt(vcpu))
>> > +		return;
>> > +
>> > +	if (!vcpu_el2_e2h_is_set(vcpu)) {
>> > +		/*
>> > +		 * A non-VHE guest hypervisor doesn't have any direct access
>> > +		 * to its timers: the EL2 registers trap (and the HW is
>> > +		 * fully emulated), while the EL0 registers access memory
>> > +		 * despite the access being notionally direct. Boo.
>> > +		 *
>> > +		 * We update the hardware timer registers with the
>> > +		 * latest value written by the guest to the VNCR page
>> > +		 * and let the hardware take care of the rest.
>> > +		 */
>> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_CTL)=
;
>> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_CVAL=
);
>> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_CTL)=
;
>> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_CVAL=
);
>>=20
>>=20
>> Here you are overwriting trapped/emulated state of  EL2 vtimer with EL0
>> vtimer, which renders all writes to EL2 timer registers useless.
>>=20
>> This is the behavior we observed:
>>=20
>>  1. Xen writes to CNTHP_CVAL_EL2, which is trapped and handled in
>>     kvm_arm_timer_write_sysreg().
>>=20
>>  2. timer_set_cval() updates __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2)
>>=20
>>  3. timer_restore_state() updates real CNTP_CVAL_EL0 with value from
>>    __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2)
>>=20
>>  (so far so good)
>>=20
>>  4. kvm_timer_sync_nested() is called and it updates real CNTP_CVAL_EL0
>>  with __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), overwriting value that we got
>>  from Xen.
>>=20
>> The same stands for other hypervisor timer registers of course.
>>=20
>> I am wondering, what is the correct fix for this issue?
>>=20
>> Also, we are observing issues with timers in Dom0, which seems related
>> to this, but we didn't pinpoint exact problem yet.
>
> Thanks for the great debug above, much appreciated.
>
> As Wei-Lin pointed out in their email[1], there is a copious amount of
> nonsense here. This is due to leftovers from the mix of NV+NV2 that
> KVM was initially trying to handle before switching to NV2 only.
>
> The whole VHE vs nVHE makes no sense at all, and both should have the
> same behaviour. The only difference is around what gets trapped, and
> what doesn't.
>
> Finally, this crap is masking a subtle bug in timer_emulate(), where
> we return too early on updating the IRQ state, hence failing to
> publish the interrupt state.
>
> Could you please give the hack below a go with your setup and report
> whether it solves this particular issue?

Thanks! This is exactly what we needed. Your suggested changes fixed
both issues: in Xen and in Dom0.

[...]

--=20
WBR, Volodymyr=

