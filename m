Return-Path: <kvm+bounces-68375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BC4D3844E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7386031540F4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B58403A0B2C;
	Fri, 16 Jan 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dXpg6Tnq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dXpg6Tnq"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010046.outbound.protection.outlook.com [52.101.69.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BA13A0B3C
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588080; cv=fail; b=frJvVTVZbOtg2X/xEEGf1Y0t9XpYAyCCEOaRpLiA3uAtp+lViydEMgqMdXjmdtkTjP/7CdBRCCKL2ajmEEAkT5ClXgVFmv6ZzMQGGf/MHpc30G82Nqxp55tWhR8k9fhHUkce2eX60NvkiZfETlsBpjX+k4y5jSqIkUsxwdhU7qs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588080; c=relaxed/simple;
	bh=0xUmr3SMKVR6VkpdNK9yNMpdI5i/Txo0g3vK7X0xAb0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sceM336d8EMavO2m+apTPbjQZTQCf0vFJ+GlIe7uiiqFdLyPDk+ep1H0/DtgZ2MrZHdCgqG3u7SAx31Ns2+y5Dpa3OIHJr6tVmQ0x6ycIOJHfEFmRaxWGTjZk90n9bkibmpVV+LDLGtMQ1y4VmpVfDgQMDZsYjIt9ywwyM/zWEM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dXpg6Tnq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dXpg6Tnq; arc=fail smtp.client-ip=52.101.69.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lOwDn85IuOEBM7Kw2/q5wodWdFeW8rnjS3G7/qNu5qKurLHW5XFvVxQiPXVgEgtDqUYFGUnDY8jtcAbsiV59Repi6XtTkp3MmDyvqMKLSGq5Z/NTvlXOw0qewM+bhW567uuMqB8vsj4IWoujUyyvoGAsKVJiie19TEvGEhKBXg513UkFv/BGYZbDlSzYL3gZTHAjRX4rAua5FMMj+Z4K5jcBfc5NTvaDmgZX1qFZwv4/xidkaHSJTlOi18K0or9QAXuUjRLgMRAM0+Ljzfcjah89bS3SkoXADG0o/8N49Hc2D2usdpgUfZJiZXGyPCWwmLakyh9RQbAkDy1LxF0o7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdSmXS06G21h02EwvrdxNGIWzZokJdYFe20bsdImiFk=;
 b=xJS8OtYq/zVA50wNjpoeYQsz2qx1ui2Di5Zrexg7oS+iZcHcEeIG0HZb50mgNMwMH33KC5MEk37ffa99djjht8xWXRWQp1fYvlp/jxPA5gslOju+cu8v2x2huoz3xGHqmG5az61/Y9WioaVJxuXF+1J7PfKY2ClkednMxagYI9VSZu5rEH+SIwlUDT1TVLcU0uYe8A+wP2z+5HoVaJSR0t39Xuw18spq0bd7dnSYbOUt6KtLCPAOKl061f6SIAgkDD7dWLl+++vLhcRLKHOC4l2OlK7pYy18LEpVP/V9lR6Doq51shkERE0e6JG+4GvSF8t9EHcRikkPs5HsazwYhA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdSmXS06G21h02EwvrdxNGIWzZokJdYFe20bsdImiFk=;
 b=dXpg6Tnq3sgq7ImjArU0+gjPxGjpf1uuhmLD2q8Dx6Sg86DKabe+fCFUShSxh/9Xu22+J0CY00oz8faovy9XedoJ8KptTVLykyE8auBjOT25fyTxzQ6jekSXtFBjTeVJlgDLarT6SA8S+0iNre2fy2SxEfB31G4ms89EcBOOBsI=
Received: from AS4P189CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::8)
 by VI0PR08MB11383.eurprd08.prod.outlook.com (2603:10a6:800:303::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:27:54 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::cd) by AS4P189CA0016.outlook.office365.com
 (2603:10a6:20b:5db::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:27:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6Wm1l/zx9/yB+iPjTcHhrzEwpf/cbLErqDV4fU8btQfeuHJogm0BiurZmuXAVfzCCGNr35JbOC78fQU6pV4tlZadBZp5Mr7JXVqsoQ1SjsD62zOtRaB1oQG14wqDJXyncwLJvruSD7LvW9Oxu8OxlgTmn+F8iEAxknP+5hNToGtH6Fo/1zC+7clOOSwjuMWgjRXHDKsYKeFZlwMdKVBkUOrpW/JiDlSeXNGg8Dq5d+IgQ4xchE9uhFMXqs+Hxft6TJ2MkVE5OPXd4Zzes/gT2IfSlhiUlbuVPHza2MV66DAXf7HTLOkaZ5Cvg6vxoNMsfTgsMRswJi3yhM9r718tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdSmXS06G21h02EwvrdxNGIWzZokJdYFe20bsdImiFk=;
 b=wz2IXUbbB6e0XM9nG9irS5vFhx63TAURhPHLzT1NEfaQ5PRwVJlem3V9OizLoTr0c1a1UZtmGEQhC6tsK7q0RZ2QWAgMT5ujBBDytUoRlOGlCQRjphW4AV8rni2z6bqwl1O31rlB27ceIR6Q+mwMBRRTlKULdeQXlTT+i4rK/yu9rjJ2h8YBGtozc8TwekskxlEgaULD+poEqDE2l8UAldc9R++FuvyHufU/V87zffuC4FWum+W7z6aKYm0h+39C9JupW3/UD+9G3aSJvqqFfiWAHumwxjxGH6n0E0ymzTOcFwtNOeBVFCYHgXU1UmUiU5Evk2s/xiBrPVM3yijZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdSmXS06G21h02EwvrdxNGIWzZokJdYFe20bsdImiFk=;
 b=dXpg6Tnq3sgq7ImjArU0+gjPxGjpf1uuhmLD2q8Dx6Sg86DKabe+fCFUShSxh/9Xu22+J0CY00oz8faovy9XedoJ8KptTVLykyE8auBjOT25fyTxzQ6jekSXtFBjTeVJlgDLarT6SA8S+0iNre2fy2SxEfB31G4ms89EcBOOBsI=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:26:51 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:51 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 08/17] irq: Add interface to override default irq
 offset
Thread-Topic: [PATCH kvmtool v2 08/17] irq: Add interface to override default
 irq offset
Thread-Index: AQHchxWuD4ipLtzzw0KUu8NxDHDXuA==
Date: Fri, 16 Jan 2026 18:26:51 +0000
Message-ID: <20260116182606.61856-9-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AMS0EPF00000197:EE_|VI0PR08MB11383:EE_
X-MS-Office365-Filtering-Correlation-Id: 20bb46d3-9ce9-4416-96cc-08de552cf66d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Ii+MAFfhdqzWZzZ7+hYBzFswg2Py4Ged38n0rb/vvpYGX7/y0HSRb4LWLg?=
 =?iso-8859-1?Q?Bh94wY1sKj0pmnE1gFNF76WjAj+TViFLoZGzix1+KAYe5wnsiGiKlybA3+?=
 =?iso-8859-1?Q?g6Pb9kPB38NO0p0yih8sOPsZdD35juRVmwJiyZL6FMerib/+Q8VB+NiKke?=
 =?iso-8859-1?Q?0WUvMOoT01AcOaFmvT/NYqp05vMoTFHMVL9zLAqUSMjuN3o42c9pPVYLP+?=
 =?iso-8859-1?Q?G4672fsyEA+OPU6xVS925wGJI6bzLsPRoY8XqxAA5LeEePLVPehxozBNar?=
 =?iso-8859-1?Q?bZH2aNXfksqizWf1cPC1HrhqsvOwL+7qOjgRNvTHcOwYubZo7iV4sCcN1A?=
 =?iso-8859-1?Q?PAr3r+y78RLqnI+oYNpvc/nij2YBKfm/2T4e6M5Qxz6qkg7NLa38veBRci?=
 =?iso-8859-1?Q?PkiXDcH6JmwQd0idpfQDCnPdkk1PoZv1Q4bF6tWQHF1pgQinda7gWuOr5a?=
 =?iso-8859-1?Q?kk4nNYCuF5ZeoF9bZgK/+NmLSUxR/2Fs60Z/PNTdQEpMmMv3KdJGaxvoat?=
 =?iso-8859-1?Q?kJfRIwp1zSkloh+duRZ+tKszbFnc7p8Wc2U8loOWLTgbabqeEA+66rtsZW?=
 =?iso-8859-1?Q?RRnBi1Ym07JTboe/MlJS5vd7hNELNX2P9Zp2elcZOKIiJOMkYFn6wtzBQk?=
 =?iso-8859-1?Q?SGMA6ZonfwCLfqLHqlkrzvbw/8HixPfXYFxQqTkXodovaWLfhoJkI8DRvS?=
 =?iso-8859-1?Q?Bspj59aovgtbPQdIzMzuO0DnU1J60aQqbwQ9k0aS6Z6eEJH/7sWTEQ95SU?=
 =?iso-8859-1?Q?XnOc3EMeMjjDN6iphKVVzkA5GDJOV8W1PWzrxBAHKXUEjPHkZybgSMApFs?=
 =?iso-8859-1?Q?S0OCo07igM1o6fair7gwED6TEkZNxQMHZcsujB4hHSjPdt3i9sUIWabJHt?=
 =?iso-8859-1?Q?8GU6+PQywptLxaTistKgoWKX8jHPvzZP785EKQ3e9v7tVTF/tI+5M6zoLx?=
 =?iso-8859-1?Q?7SCSBGg8gqGY6clmfgFSWR6fF3QBPvqTf84EKpGQCZM6LKCYcKVAv6NVJX?=
 =?iso-8859-1?Q?4um6pD4kuPgiHkwSX5qZtTjhOXX4m4BICIaWGGtdxhJqAN8zn1cVB2rC8D?=
 =?iso-8859-1?Q?PhjtLwUzK8EIryY4s4I+XeIOKvX8HrTcmPwxYX180Ho/uO63t9EWpOcj4G?=
 =?iso-8859-1?Q?G7DZdVy3hNadz3P4zNDQyQlmbhrsZDE39o+TiOHbHbDYxqNOYCBdw1dNZZ?=
 =?iso-8859-1?Q?dsOaBkxGTUIBhfC+VM03iaWsDz7wD0v3p+T7BIx6UUwMywOtyy4kTlBSF2?=
 =?iso-8859-1?Q?IV1wjb8rfSjfVug9VpisTDO/m8Diiy2ebRe9AaZZoOnxlful9zq3CcXJNU?=
 =?iso-8859-1?Q?DfIEfQHezawytSUBHTakjSAaHKrb+zqHAHB5fyD6xAQQWb1q/wiKpqqNrw?=
 =?iso-8859-1?Q?tqm/BHKl88aIRmuo9Vrjdfx0h6D5o+ThRGzta9NIDFJ9+IuHhBdINP0G1D?=
 =?iso-8859-1?Q?b+VE9kTiFcebh/jyswc4yK49c/noS3HmrMfIcrJswluweMCs0mglI1r8KT?=
 =?iso-8859-1?Q?bwRqLYSSCRB2n8zzkHn54xTeS3gDjuFx++jSmeQyqxIDWnMYPHvEDPimIe?=
 =?iso-8859-1?Q?Z6u+C8j71Iclis6X4DKFfse27cRZUxYnNe1UVrPGmRFjVWzLdBMdfNNnrj?=
 =?iso-8859-1?Q?4Acwuba1Z9GcpArvBZvcx++lCz6ObEdYC/55pOVZr7ioOZZ/tfjkyFPiTU?=
 =?iso-8859-1?Q?vlBHp4W9ty8WrhwkRFI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b3ceaf9e-9a0a-4327-60a7-08de552cd165
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?QvWMasuICDv+ugHU8HAIjBlhhIPXepi8/Xnm6moN9kHZGP8faJ698xp+dZ?=
 =?iso-8859-1?Q?z4RrHzEanSUNGfultQMZQJdnkoJX5Y9maspbpvv4KaI0Kk/JF/dSzHDnE9?=
 =?iso-8859-1?Q?Ri45oRBq3vWbzxkxAKvBzzMF56sTIfVdnQlSxNUnNGjR+xRAIfbiw3i6nN?=
 =?iso-8859-1?Q?JqahTjpkEAyAQ3fePpzxgY8qDGsBHX31or26sz9qnqEG0tMmNnrhbUFgnY?=
 =?iso-8859-1?Q?tyXTMa1xY0tXXUfvc+lDQwehNnlzcaPh+UIk67dhaR0y2fvUBnDRi351QK?=
 =?iso-8859-1?Q?ioF1vXDRYN+beuV7ngewUK+seoX6VrKxMe2oxHBusCPmPaE7nJf1qhPf4f?=
 =?iso-8859-1?Q?jJ6LxxQoGDWudpne1p4RVBzcyzvH5FAvmlPxvkz7yQK6tlRrqcbIzlZNRd?=
 =?iso-8859-1?Q?MCk8xkC1XPGwq803npzuvsweBjgIm5FAeduSpMhSAnPerOXzI5SJBwHsdy?=
 =?iso-8859-1?Q?UKcJPFG+NPT5qZGyh51FJxIujEK/BAaJfik4KURZaX0z4mPkVG8bSBW2rf?=
 =?iso-8859-1?Q?dT9fKuYph4mN420MMWzZMzvQI6gvzUUSyPtxenDTJvTP2CnWDUX/V1W1XA?=
 =?iso-8859-1?Q?lFoRMwquu+t7ZauOqQob3Dlj/0cx00LkUxc1Ld80e7LAk6mjkgAsmOUeO7?=
 =?iso-8859-1?Q?N6CgNiXfJKG5GMtVlOrNczrjIJUL+6KDrtKYh5+WDg+nGXzJAGnOJugqqz?=
 =?iso-8859-1?Q?+BLvAUfpIxPujx4rm0eGB8C8AxEPEbhXsWVczSdt/VhSskAQ0PfQRTulb8?=
 =?iso-8859-1?Q?7bdDRe7qdYOdmxdbGWZ7u+liUZAITDDEpWXMfFTU3gXhQLgRo2oFRfYuIS?=
 =?iso-8859-1?Q?czumrrkB4bfRHlckg77NokzfUC/Q7Sf2te6m5M1nzCesfuHiEeB6gom/Bh?=
 =?iso-8859-1?Q?WLKzn9Fwtcc1ryG0kmqgDfGt1vQOKwCUSgLKiOM4rUeammSYOYPAgVKdta?=
 =?iso-8859-1?Q?dDBNp51wE/c7mq7QQBKIq2eFeSArpStGioUfAYJiokKjDDA7BYYiL1Bd7B?=
 =?iso-8859-1?Q?MhboOjxaPUDLOk2JHZrlzLi059fGKd0CvATTK2B+tcwe6SCQeXQ1mHCaQ7?=
 =?iso-8859-1?Q?tT2hL+M0isU86UMQZ1NOngtX0M+zKujV2Ss5EmZAU2v1Z5F6Ht4YKRLZK9?=
 =?iso-8859-1?Q?kaQ/PNdemswx6BbtFsOKhGYvXy4ThEuK+kIfdoltyvQDtboq37b7wWGjNV?=
 =?iso-8859-1?Q?ycylXrF1pTNofMau8PCgeH6ab8RiN0M6C4aBBc8fiRC9DdpOrpwsikK2QR?=
 =?iso-8859-1?Q?ZWeoENo8+y89mqlD7cK2QFPI/MMsgtASmsUf0jmvy2p3vPUk95tfbb+X6m?=
 =?iso-8859-1?Q?QQfhJyhYv9uhbzxpKGvdSH4Nl2tnxmn1wI4d3JQdpu79Nw5cgo42xksH3r?=
 =?iso-8859-1?Q?gwG1FKgWiaukB+tSlkVcoTHRG8VS8DNsRXaZRmyMM088WDF64IO2SYGmrp?=
 =?iso-8859-1?Q?E5uYXPRVudPJ0bUW3Ume1JjhjR35x7qWP2mYoJhYXyemNT2oSakWfLTOEx?=
 =?iso-8859-1?Q?jj0hyFC6Yq/HDm4XG6+R1V7lXFjmjgOFwIvHEqhiOSVAfbuRdE6gGwIPNo?=
 =?iso-8859-1?Q?mZ75ZzoOT+OaP0J+LXoCm2uM0O6toAxTtzAeX1QkyduqwIHEBp2lv1OuGr?=
 =?iso-8859-1?Q?irlFkk07Ae8jauDscWIcc8kLFFnX46hu4bfUHf1iMMoX9T03Wm6q6ecVFi?=
 =?iso-8859-1?Q?JfPXrmrcKLup2LpbugzBnVBzKxSuD5UFFyD3E2GVg67dOYEQjN5MV/LiYS?=
 =?iso-8859-1?Q?laEA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:53.3559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20bb46d3-9ce9-4416-96cc-08de552cf66d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11383

Add an interface to override the default irq offset (KVM_IRQ_OFFSET)
as long as no interrupt lines have been allocated. By default,
KVM_IRQ_OFFSET is applied to all allocated interrupt lines, but
calling irq__init_irq_offset() prior to allocating any interrupt lines
allows this default offset to be overridden. Attempts to change the
offset once lines have been allocated are intentionally rejected.

This is part of GICv5-enablement as GICv5 SPIs count from 0, whilst
older Arm GICs count from 32. Therefore, on a GICv5 system there is no
shift that gets applied to the SPI ID, and hence we need to start
counting from 0 to ensure correct alignment between kvmtool and Linux.

irq__init_irq_offset() is only called for a GICv5-based guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c       | 11 +++++++++++
 include/kvm/irq.h |  1 +
 irq.c             | 16 +++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 189309e1..e88a6c33 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -234,6 +234,17 @@ static int gic__create_device(struct kvm *kvm, enum ir=
qchip_type type)
 	if (err)
 		goto out_err;
=20
+	/*
+         * If we are using GICv5, then we need to allocate SPIs starting a=
t 0,
+         * and not at the legacy offset of 32. This must happen before any
+         * interrupts are allocated.
+         */
+        if (vgic_is_v5) {
+		err =3D irq__init_irq_offset(0);
+		if (err)
+			goto out_err;
+	}
+
 	return 0;
=20
 out_err:
diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 2a3f8c9d..17113979 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
 extern struct kvm_irq_routing *irq_routing;
 extern int next_gsi;
=20
+int irq__init_irq_offset(u8 offset);
 int irq__alloc_line(void);
 int irq__get_nr_allocated_lines(void);
=20
diff --git a/irq.c b/irq.c
index cdcf9923..8b9daa91 100644
--- a/irq.c
+++ b/irq.c
@@ -8,6 +8,7 @@
 #include "kvm/irq.h"
 #include "kvm/kvm-arch.h"
=20
+static u8 irq_offset =3D KVM_IRQ_OFFSET;
 static u8 next_line =3D KVM_IRQ_OFFSET;
 static int allocated_gsis =3D 0;
=20
@@ -18,6 +19,19 @@ struct msi_routing_ops *msi_routing_ops =3D &irq__defaul=
t_routing_ops;
=20
 struct kvm_irq_routing *irq_routing =3D NULL;
=20
+/* Override the default KVM_IRQ_OFFSET */
+int irq__init_irq_offset(u8 offset)
+{
+	/* Block attempt to do this too late */
+	if (irq__get_nr_allocated_lines())
+		return -EBUSY;
+
+	irq_offset =3D offset;
+	next_line =3D offset;
+
+	return 0;
+}
+
 int irq__alloc_line(void)
 {
 	return next_line++;
@@ -25,7 +39,7 @@ int irq__alloc_line(void)
=20
 int irq__get_nr_allocated_lines(void)
 {
-	return next_line - KVM_IRQ_OFFSET;
+	return next_line - irq_offset;
 }
=20
 int irq__allocate_routing_entry(void)
--=20
2.34.1

