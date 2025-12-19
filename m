Return-Path: <kvm+bounces-66366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BBCCD12C2
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 94A8F3018741
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437E1363C7C;
	Fri, 19 Dec 2025 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UdC/fYSd";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UdC/fYSd"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010063.outbound.protection.outlook.com [52.101.69.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B486361DC4
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159641; cv=fail; b=EcvoiHwE/lUfyzY/XhSBRqLqEtZrUCqWCrhyNVXjNwSOm8DJeMeka3JS4eJ7MfcEyFOqOspSOyCoQz8Mj2mS3NdHNkh+u61DJklruUtZc8Yfd5DqNKxpHX476bxgxCHWX4TEMPuWyF+02yiQH9475qTdEvFNn+oZlWZ3XyyPQvA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159641; c=relaxed/simple;
	bh=b37jhhG13K0zUswQGbvxm2zleS3jXjfNL7hMownT0EM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k50cn8u6FnKRr3FSXNMJv6TY6HnPZ+uBWfy2M2dAlpeVAPdju68/2djIZNy3/smZfYT7Q1ZWfufc2/RY5qcgOigADzsh3sP8IDVR2pNqkrdrsBEU736HYZLReoLLnvaYz77JDdN0uza6w78zGhgiJFaRZ8pG3yVNMSwc71Yje2s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UdC/fYSd; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UdC/fYSd; arc=fail smtp.client-ip=52.101.69.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qx7sdTQVS8EzKqd4hgIwaVZ/IPB6+ogNOUgAJ663XlzJNg25SSssHRot+2u4lPhAK7SdVxUVchKx6n3MFqAJPvWGiPvgaiM1VD8Myo9SfsVFTDYz2BgIQxH2BOW6+LMD1OzPb2wZnv3VAAO0a5q2vGHExqTLT9Etw37KXsXDKrpu6KzDntuLZdF0N5KjF1GyMF5Wg0iYvzB+LUvRF/qTGDq6igqHQAQ2tHTdVlT8c80qT/OGkl1hgE1TnrdF+fWOgfIlwZJLhCWUBXoF3nCyUZ7tRVVQ+mqr5N91ktl65ACiAJ80Ip/Bb+peRTXSWhHLowkvkImBol8Z5IMKeIO+BA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t39X4KuBXmC1hTWFDIu2YYjWT6BqUU1zbOiFCQY+XEw=;
 b=vtfdPJkCFgP7IpABldTLWB6JT7iUsBgevO0V1/XxYSLLMqPil7tS0eyzbFlGY8Nyp0xA8pB0s7VI14MviSVTEdm4LnF01qaVJSlS69K/ObTzBTRCgFg6JlmDoq78mrCbKB2RRnBZbUK2NtLqskDpitK1JYR2S2BndllLkJWzS/G//vxyPsk2yBwkFyiJTgZ/D1NfKQ1axtOSv8mFeyS8KZ+KcmC4bd7dywPjTbDWCXrEDHr4uVAoeekhIE7jYj1Qck4t4OloqNSdJC8Zax8wc9ZusmGSwynaztxr6LA96lwyTv9ojUfcx3r3HOq6FQe5pzt812hfoAWSTkXxKKd3cw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t39X4KuBXmC1hTWFDIu2YYjWT6BqUU1zbOiFCQY+XEw=;
 b=UdC/fYSdh3iMzcPow8H9svKyU4fyvEQmvV8A5FPW3sjfNG2lRwwCdR2hWCJS1wjXlkBz5CWbx3BE5FDvDuhIG+E6YO9/ebj/T1QeBsHMr+CwHjUVEUCvrs6hoPxjLC7QRwzdPp8tetYg0cKl0czUYqsZ0PZTem1UP7D2PKlbvcg=
Received: from DB9PR02CA0025.eurprd02.prod.outlook.com (2603:10a6:10:1d9::30)
 by DU0PR08MB7993.eurprd08.prod.outlook.com (2603:10a6:10:3e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:48 +0000
Received: from DU2PEPF00028D03.eurprd03.prod.outlook.com
 (2603:10a6:10:1d9:cafe::c3) by DB9PR02CA0025.outlook.office365.com
 (2603:10a6:10:1d9::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D03.mail.protection.outlook.com (10.167.242.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+aXDxtJ3926vY9XTC5wqOxPvvs/KrR3PZdAeh9XH778mpVHRgqN103d8B8utpJ7xaSroAgZq7pf1M9csno4WAem/Eo3UgVM+5UdyEe4zcn/lkP6qFh2Dhq8JG9ea+7p0mFSBJQ15XvcXBCgf9RGEmJW74AKSc6231giAN2Odt0spzc4n92kvl6R7PUFsqBqj4AVkO0CAs10ywqpN4kc7IeDMIi/i5YPCdEmn73XSJ+RznAqbvwVXYViDC4FF4+YGbivi1BVpyVeoVNBbE0QX6Xqr8cxDH0pvjwIdQn5WQpdzwOKff4+lhESdjtG/cUlBHcNkhDecbtIeeNBN8M98g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t39X4KuBXmC1hTWFDIu2YYjWT6BqUU1zbOiFCQY+XEw=;
 b=QsyiBn8KOptIx4QQ1Ja547bjh6X/3W4So2mNCnHMIS05KSQhnF7VBXXN0EdnzJBB4Cyz16J5J2kQElyis5P5crsruENml7UJ41lWb/vz0f0L85kYgsFbzqHWtqOX0uXbOTF/KywofmDRB82C9n00xegkl9/VZYOQ70aoGHMotrOL+TSoRP7dfCPRckV4kBdoNJjwu2yH3Um9x6cQi2j7QSpfIb++S0YswSKm277TZAebFB7w4NNKUN5KXXw8gu2F0Dpq5qKhhuD8mDJOGzPfHSsOXk2aNouW4nTv1FPy13xvb8Q+h8uFWDtCQKL/xYYkj29IKOIL03TGv37B/zBvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t39X4KuBXmC1hTWFDIu2YYjWT6BqUU1zbOiFCQY+XEw=;
 b=UdC/fYSdh3iMzcPow8H9svKyU4fyvEQmvV8A5FPW3sjfNG2lRwwCdR2hWCJS1wjXlkBz5CWbx3BE5FDvDuhIG+E6YO9/ebj/T1QeBsHMr+CwHjUVEUCvrs6hoPxjLC7QRwzdPp8tetYg0cKl0czUYqsZ0PZTem1UP7D2PKlbvcg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PR3PR08MB5676.eurprd08.prod.outlook.com (2603:10a6:102:82::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:45 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Topic: [PATCH v2 24/36] KVM: arm64: gic-v5: Create, init vgic_v5
Thread-Index: AQHccP+DB9N8LwWvhESuT1tUOl71Fg==
Date: Fri, 19 Dec 2025 15:52:44 +0000
Message-ID: <20251219155222.1383109-25-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PR3PR08MB5676:EE_|DU2PEPF00028D03:EE_|DU0PR08MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f3c5cc-1911-4d32-48dd-08de3f16cc23
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?FHhNytUVKO4qE/lnUboRx6peFAj+T4ZRibPoG4jQXfP6Sl+2jwN5FaVrr+?=
 =?iso-8859-1?Q?y1qlQLoBs8p+htWVO4DaU1ajcWiA7xyBuTzU+olAVvC8n6vziEFQlWCSY5?=
 =?iso-8859-1?Q?+6T8peXie0GtVDxFH6A+PVyo6dLK6oeYXiRiZzdhgvFSFpCx6c5yTGZ95l?=
 =?iso-8859-1?Q?2GbB0+NqXhyV3gvyPbnPmJIo+pVB7T3HcS0MdlyECdDciIx7ul470vdjrG?=
 =?iso-8859-1?Q?Iu6GQyP+XRnn3N2fu06jCwFGjiRAY86auRPIzcsVQQceBGXG4y0lt8OyUO?=
 =?iso-8859-1?Q?UKIOE8bbAFtV/a17TVHzaG1tXD/XZF+nlXoFlAFJcfg+bw6dbXC2cTXl7X?=
 =?iso-8859-1?Q?B4453qAUtgYY7T9B7MkpXoEH7Z81Urw6czFP6QGexSKLxx+hzjtLLkTTUY?=
 =?iso-8859-1?Q?JgDnLtYS+mmmiTqfubCvpIVVnkl91sjaOM2iW7HFRKvSIdYSZ7BjADQuTM?=
 =?iso-8859-1?Q?nfQFj0NTJOpRHYBXBkFRtCJHf9rl89aR5tq4UJ4ytzmAFdg2mb/7K7vITV?=
 =?iso-8859-1?Q?gSSd2Rj69pheUrHN2cwLWLPseefQCDTE8N3TMKqDBCBA2wM+oU37RC8mVF?=
 =?iso-8859-1?Q?c85GShmFlI+w3R44Zg4lN/34pBrC63k3WgNiACRdc2yurlc9TnEAPwlPo9?=
 =?iso-8859-1?Q?t4t2g3uYUb3X+6m8BJhyIJRDocl5udsriiGbGfJj2ar7I1QnOw8kTMdcEQ?=
 =?iso-8859-1?Q?33YKnBY62niuNGZjppdQe2rmunYZ7aaJcJhubWGBb6MymFzLfn/yhz/c5A?=
 =?iso-8859-1?Q?DJrVz9Kc/AuVo54c7IG2MdFBftNfWVRgUL7n3+s/CwmvYXCllj2JjYKwdv?=
 =?iso-8859-1?Q?x6GcVgc34jfXbzjzwMo84dQgQ8tc2QRbskZoKZtPNOVDeYc9Muj2NAvzFd?=
 =?iso-8859-1?Q?Os8w4pYshXzVPhMh3fRoJZBar4oLU2HOj3g5nE78PW6+NUpM+NBD1Dq6z5?=
 =?iso-8859-1?Q?2hCe8FEaDhxGJRreQLdLL+fC/8NnS7L/9GWFPN3TXFSwLjvOesc62hzpNf?=
 =?iso-8859-1?Q?oxwb/2MIPFxtJfa7anHxa2ByHjJ+fLM4RlD6VIQmWP+xH1ycCSGG+3eKUu?=
 =?iso-8859-1?Q?pNRGqr4mv+Q1LgEdh1mfkht5YrIsV25NEn3seQFbIr15mN3FUYsRbduk3V?=
 =?iso-8859-1?Q?/mEuAdFhm4j+Fli760cZzA/sFIZxaP/KNLx97d/gmrqGDxzGxqz3QW95gt?=
 =?iso-8859-1?Q?ahmjhUbEZfFSDRFw/dftXLP4QxfUkA80+CA2L67DBd9RVh+ZaB9Rw7y0eC?=
 =?iso-8859-1?Q?FzRHF7ZiPOGn+NZYD42ZhzWpvQFy+y2hqNny2IcnI+id1SpOETmOhndwfX?=
 =?iso-8859-1?Q?TPwW0QCV0LJhaDgKLVwPtmmv5C1nAuPMQUTRTOsLZfmO6HB0gP7Pg5b11J?=
 =?iso-8859-1?Q?z885lXkkctqE+zQGW83hhBgdUUj/FvLZtw6uf5tLUbgvoaRfNUbtxSiqq3?=
 =?iso-8859-1?Q?5FsTQnnuo21bVptaAIj6qvofq8EdSqmaGKgAFFd+hu6txZHDSNHQeN8Ae8?=
 =?iso-8859-1?Q?BBCwKrJCaT6BcdQKZYU34/Bngg0jI+htDpTG+Bcf3t84NU8xr7pM62iG+o?=
 =?iso-8859-1?Q?EcnyfgFKwGENQnZp4pL+7PRryB7B?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5676
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6da98bcf-ea2d-4736-ede2-08de3f16a70e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|36860700013|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?SAQnwtxf4WHoDnBUZdqZq3Sxr4tB/VSs9OUXxfEEOobSX+goHTRB/D/yUd?=
 =?iso-8859-1?Q?5DEgwGf069IQRuKNUIOYsjR97WUgRriGkpHfC3KqWv+gtdYQZpjeOia9MN?=
 =?iso-8859-1?Q?XpUF+VhE8EbxfCf7nRJXgQwMrHhi+mo6orAYLDIG2ozeIQaT8f5Jm8TbJr?=
 =?iso-8859-1?Q?t3GHEyLMYJSuIVg/YBuRcqLpWj5Zc0BIZDbdlr+RJuksZWoMtacYbYQqtT?=
 =?iso-8859-1?Q?xf2lyHdskIXLc3KaEgsgk6mNntW0ZtTOg4GDAaM+iOQvjKVyBMa/a5nk3Y?=
 =?iso-8859-1?Q?L24rwWhr62S7dcBekGqwgxjoHGuZbebuKiOr/26bkiJbqBwFPuenAUPMdh?=
 =?iso-8859-1?Q?CD1r/7WEbTMjLlMd57axbRfKSQ942JoEWlZpyaaYZ0aDcIBS6ywDoCRVw7?=
 =?iso-8859-1?Q?AcaFwuJjZDwknuPRzr/XzGXygsFgMtRrA8diKuvyVL/7B3Iobje51lPKPr?=
 =?iso-8859-1?Q?UMMlcAdWMjYMOhNM4nGP5CUO60SRVgXHCSmRZk5WnJqDu5p33+UygUKn+U?=
 =?iso-8859-1?Q?k6/Co6Zhb5yqQSmBcWCQYOfapa665jycFtTMkiIqfLUj6vPFN25BaEQx0+?=
 =?iso-8859-1?Q?+/nkj+aW9xlQXgoiQRLvzJGuueeIuAXYmKWZucHITqRdzydTnslvauMbNV?=
 =?iso-8859-1?Q?5sZSPBJaRvw6CSV4XWmb81TPUQKsp63gfPv/V8Fihb4pLL8DHZ/HKjnfVp?=
 =?iso-8859-1?Q?oicbWpTlj5430tLqm8sU/sYXIsSlKHI/tcnZcytMVv2J3XeVZWXlWsrkdP?=
 =?iso-8859-1?Q?MeJl12KLnbjg4qqSUvIoY7cLEM4lyDYzoIOtq2OEIgf11BZcfShpp9VCFM?=
 =?iso-8859-1?Q?iOfUD1A5f+cx8FxrIJ/r/mVNeG52wamxadNuYd52dWwHvxJ/tClkVQbmyY?=
 =?iso-8859-1?Q?DTDOHPKL1ucFKucxE0kcogKsy3C5XKbSzCEJJaVebzNxZc3LqxNQ8Xi6A7?=
 =?iso-8859-1?Q?RZy0br2rCZWhy5ltPaAOk0qN9lDWc/nNmFhl4JkMXH9GE/mx43fFLlhE9S?=
 =?iso-8859-1?Q?5Hz1R9/f11DRE1a1OShTHI0ztN8LV6mzqWTbEwsQ5BSAOrJ+8sBVqHjJqX?=
 =?iso-8859-1?Q?AroKADtJpYcqQJfRHrAneroQDVuomsl8R/tlsiilXJKzBTSCdH5QT/lLfS?=
 =?iso-8859-1?Q?tPyCLY5ieLaavmansbLKmqjR1G44K3mK4ymYDDg3J3XOoSxT9MvIIbfVZ4?=
 =?iso-8859-1?Q?MiFb7OHvKjQNfjuotz104oIoSdno0Q6+vZ23yeL++OrNt+4kZ6IxKEAntd?=
 =?iso-8859-1?Q?Xkb8+WVX9hfZ6UQWG/fFNROimKkY7fqz8tDI95kR4cEBLLm+5pdEhNM7Y9?=
 =?iso-8859-1?Q?LXoE9BrRAIUmZUI0hw6Pmq7UP7CR8l2UiQnSIVJICEKo3IPvsACCtzNZUd?=
 =?iso-8859-1?Q?+D2Q4ZMPnyxt8wtKV9LwmCzhXdzDCFBN2Iwh+2RQJicD6JXXDx9eNLxvY5?=
 =?iso-8859-1?Q?OnqLM6lE6uVWVrZcLOxD3lPZjwTth6Y5hj8AziMO4FU18gSnCFtfndDeog?=
 =?iso-8859-1?Q?2WStee8Vx5El4ASTQ9qSZx/Dk0/iVJ447+uELQECCoYsg6iye7bwP6gHxz?=
 =?iso-8859-1?Q?/jLEsgD6uIK7RD6rT+fy9bpo6TbvQIp7x99C7Fs0capTDzcwEr7+S5Myap?=
 =?iso-8859-1?Q?MBxVXxg6QcNEU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(36860700013)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:47.8802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f3c5cc-1911-4d32-48dd-08de3f16cc23
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D03.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7993

Update kvm_vgic_create to create a vgic_v5 device. When creating a
vgic, FEAT_GCIE in the ID_AA64PFR2 is only exposed to vgic_v5-based
guests, and is hidden otherwise. GIC in ~ID_AA64PFR0_EL1 is never
exposed for a vgic_v5 guest.

When initialising a vgic_v5, skip kvm_vgic_dist_init as GICv5 doesn't
support one. The current vgic_v5 implementation only supports PPIs, so
no SPIs are initialised either.

The current vgic_v5 support doesn't extend to nested
guests. Therefore, the init of vgic_v5 for a nested guest is failed in
vgic_v5_init.

As the current vgic_v5 doesn't require any resources to be mapped,
vgic_v5_map_resources is simply used to check that the vgic has indeed
been initialised. Again, this will change as more GICv5 support is
merged in.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 51 ++++++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-v5.c   | 26 +++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 include/kvm/arm_vgic.h          |  1 +
 4 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 03f45816464b0..afb5888cd8219 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -66,12 +66,12 @@ static int vgic_allocate_private_irqs_locked(struct kvm=
_vcpu *vcpu, u32 type);
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
  * @kvm: kvm struct pointer
- * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[235]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
+	u64 aa64pfr0, aa64pfr2, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -132,8 +132,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
 		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
-	else
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
+	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
+				     kvm_vgic_global_state.max_gic_vcpus);
=20
 	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret =3D -E2BIG;
@@ -163,17 +166,21 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	}
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
 	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
+	} else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	} else {
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
 	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
@@ -420,20 +427,26 @@ int vgic_init(struct kvm *kvm)
 	if (kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus))
 		return -EBUSY;
=20
-	/* freeze the number of spis */
-	if (!dist->nr_spis)
-		dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	if (!vgic_is_v5(kvm)) {
+		/* freeze the number of spis */
+		if (!dist->nr_spis)
+			dist->nr_spis =3D VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
=20
-	ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
-	if (ret)
-		goto out;
+		ret =3D kvm_vgic_dist_init(kvm, dist->nr_spis);
+		if (ret)
+			goto out;
=20
-	/*
-	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
-	 * vLPIs) is supported.
-	 */
-	if (vgic_supports_direct_irqs(kvm)) {
-		ret =3D vgic_v4_init(kvm);
+		/*
+		 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+		 * vLPIs) is supported.
+		 */
+		if (vgic_supports_direct_irqs(kvm)) {
+			ret =3D vgic_v4_init(kvm);
+			if (ret)
+				goto out;
+		}
+	} else {
+		ret =3D vgic_v5_init(kvm);
 		if (ret)
 			goto out;
 	}
@@ -610,9 +623,13 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret =3D vgic_v2_map_resources(kvm);
 		type =3D VGIC_V2;
-	} else {
+	} else if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
 		ret =3D vgic_v3_map_resources(kvm);
 		type =3D VGIC_V3;
+	} else {
+		ret =3D vgic_v5_map_resources(kvm);
+		type =3D VGIC_V5;
+		goto out;
 	}
=20
 	if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index f1fa63e67c1f6..17001b06af600 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_init(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long idx;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu_has_nv(vcpu)) {
+			kvm_err("Nested GICv5 VMs are currently unsupported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int vgic_v5_map_resources(struct kvm *kvm)
+{
+	if (!vgic_initialized(kvm))
+		return -EBUSY;
+
+	return 0;
+}
+
 static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 65c031da83e78..f974b55fb8058 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -386,6 +386,8 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+int vgic_v5_init(struct kvm *kvm);
+int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index dc7bac0226b3c..696e2316f1ea9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -21,6 +21,7 @@
 #include <linux/irqchip/arm-gic-v4.h>
 #include <linux/irqchip/arm-gic-v5.h>
=20
+#define VGIC_V5_MAX_CPUS	512
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
 #define VGIC_NR_IRQS_LEGACY     256
--=20
2.34.1

