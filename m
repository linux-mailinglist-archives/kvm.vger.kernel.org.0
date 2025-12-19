Return-Path: <kvm+bounces-66382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C463ECD0BD1
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 71559306413F
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2673A361DDC;
	Fri, 19 Dec 2025 15:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ed1WK4jC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ed1WK4jC"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013071.outbound.protection.outlook.com [40.107.162.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD15036214F
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159669; cv=fail; b=uPIg9TGjXoGX5A8AaAt4igqyLttnG8+28v4HAFgkYg5oCcUvuhZwGDczDdJfDbWy5RUopUS04xOkzBV8/mnHrciBubdlSDw6snMG6J8hJVUi2+VIi3g5+q4Yid7Xhh5OxRS2wHMfxUHhiEiqBGm6EI/l4Vh+8K/ZFLAMCf0RbKg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159669; c=relaxed/simple;
	bh=qAo5c2h3HPW6H40OOGcTLJ013S2pNNQpQ7MiKtG0YDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mKE4qy0ObLjSzF99w9x/UK9k7h34zVktp6aOdy8tJ2IQcu4/WLI+xQ11sGXBToFCxV00Uu6LyWsNswD4shMyyiM32WXQCieWYz+IG3KbVIUvV1crJBUdlQpjmdbp6I57T7CEaDHi5ITZ3ODZR7CGpJP8QNlIU224wKfbb0oAZvk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ed1WK4jC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ed1WK4jC; arc=fail smtp.client-ip=40.107.162.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=k2oBasxSpyRKiXc7ztR8x2khFDe50y/Y7RmpNTX2Z1PaPF0mEViEGMV0L2YyF2pevYxbyMtv0cgQN+oLz4hHu0scY78PnZRojw91KqDfgfeVMy7tUs5PEBjLEy0El/kqZLxVv4XU0EynpqKZK1uaKvv/lAI0X+khJ/mh6l+2XGKh4wegUyAb0KhVs22NzNL5YfaGcBU/2f2HeF3ChN5z0TsOaAwRYifbmBG5OLpmwIgHRQEDQ+bLlqetoh6nbmi2HzGVINsKrRdg5SHsdWbfc2dgrobgx3YcGOEKQ4THLlJ/Nz6iwXzIW25O4gRPkCoCNTYYuNnEd78dFF8vh6fj/A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK3HGg7H/AvcFA6SZtO5DdiDZzR9QgewXvp4KYXzjJs=;
 b=Bls8SIS9bpc/ptJClfxbbcdstdcAfbsX7Rz8qW/QgzkUYD6sS313o0tO9IwuaWZ3mB/bKLlhCRAUr72jZro2lEllNCDEssIZdPiYORPs1JaScKSX9iYLKWzA1BfrHc94ppZJGrtHdT13uH8Eo9C9/ngxrpmF4Cz8sxhPQZIz45zkiXQ9wwBmBSLWDEki2s3UhoidtDXt2BnzrDIu2z5CBjRMvQkCzVnd+K3ypZWWhFaoem6FW9PhTimAn63kOovz1/xcjhGnXSR68u+PkyhXcbBUb7xh2Q8hG2VlC4oPlPfNjFf5yNV59w0EFn8c4p37ojKJrzxblWFB9I1709ocGQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK3HGg7H/AvcFA6SZtO5DdiDZzR9QgewXvp4KYXzjJs=;
 b=Ed1WK4jCX/Rq1o3yZMcXSyFM6YUy72XEuWhytfVs0YCm/z4LzKzOTwR56LZkUfEVe/qLsXUVyKddlTu/hEapOlh/SXqyDvXdhqaaxJyBfbu7TR6ZFe4XQb+NykTa+cgvBFmCufNCL+ERuS/NQDaTP+mJ1OSy1IErdl+Idf/9X90=
Received: from AS4P192CA0036.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:658::29)
 by DU0PR08MB9395.eurprd08.prod.outlook.com (2603:10a6:10:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:54:21 +0000
Received: from AM3PEPF00009B9E.eurprd04.prod.outlook.com
 (2603:10a6:20b:658:cafe::9) by AS4P192CA0036.outlook.office365.com
 (2603:10a6:20b:658::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9E.mail.protection.outlook.com (10.167.16.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzCcfgHSqueD1HL6NBsSGRrRhuAaGWvGLly46tB4Z1/HY+KxvYlLi3EyWStgVDPM1Scrz94kwUd7TE0BpfT9I5iF5R+5hX52BV6MgtGT4UzHPWKExoqRkJ9q0PSF1qBvI13VI3/aaATYRozt8C/AFqHJ3MhV8Tzp/cw+FO6e2IDdECPDKx/MRIRvygC8Zsm4tRIP4pLfZh118vt6yvhyNIRUfsNosploLu1+4PW5+3M25B0tmSgaugXTM0g9rIwNZcNdffgMrtxWYba4b9vg3/oIbwTShvS6L+u3vy8T1y3fkLCJ1Pn1OnQXzCNvehGmXsQHm28IOYlfzcEQXahq4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK3HGg7H/AvcFA6SZtO5DdiDZzR9QgewXvp4KYXzjJs=;
 b=Q0vnAHP9Fn2i6zuzTDip0Fp4n1u5ojh/DwdYAUMdEZGtOOIZfoLPrlUywirXG6pg3UJe7D8N//9BU+0jYqQI/yWCXslTiI9SeHNjTn8YZevAd1JE9nBiccPSJKDxUn2aBNF2oJXtCo7OOuqf3kDZGKWcibgBmc7uBJgrqiKvHACqxMX2vmXEKXajNgW3M++qtExv3Z+qY/Zbee2fop2wREflax6FhgxYn+6D5aEJvNBlmbmKI9u/qS56ZJgERBRQCKNWuuNiPeYJicoZwfw/2WLesuQvolGNIUS1sgJzCvKdmIzRURrG4ecd+rpUiyV3t3KQJg2qqebvFccOoDWGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK3HGg7H/AvcFA6SZtO5DdiDZzR9QgewXvp4KYXzjJs=;
 b=Ed1WK4jCX/Rq1o3yZMcXSyFM6YUy72XEuWhytfVs0YCm/z4LzKzOTwR56LZkUfEVe/qLsXUVyKddlTu/hEapOlh/SXqyDvXdhqaaxJyBfbu7TR6ZFe4XQb+NykTa+cgvBFmCufNCL+ERuS/NQDaTP+mJ1OSy1IErdl+Idf/9X90=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:18 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:18 +0000
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
Subject: [PATCH v2 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v2 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHccP+FQKEYYun7+km+pbH9OjBGRg==
Date: Fri, 19 Dec 2025 15:52:47 +0000
Message-ID: <20251219155222.1383109-34-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AM3PEPF00009B9E:EE_|DU0PR08MB9395:EE_
X-MS-Office365-Filtering-Correlation-Id: 0edcc5a1-3785-40a2-1b41-08de3f16dfb9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?+DWy9bY+zErtjJ1z7wFBDnjNpGprM0CJe5mCc083GQFojS2qDFFl3vcGYg?=
 =?iso-8859-1?Q?gUzCt+q7/MjaFzrzfFy/xX3+ZNiap1F4n8SvIJHwlVTO1DJrZga9Yy3+i2?=
 =?iso-8859-1?Q?GF62SsuyuZ9Z6kc46I0ggPqaSa9Xl34sj7+A/ySauzKJ4BT89k821COsjk?=
 =?iso-8859-1?Q?/da8I4+kCdswx5brpl1QC8Dnx+Jtlpc2LkwaUBaLdmvNwG1LiTIPQmviT0?=
 =?iso-8859-1?Q?N+zzVT2EcIoW0o+QXTiRV1GWUl9IdNeQkgeXb0ZdufVYYykWRg2z8Pp8JQ?=
 =?iso-8859-1?Q?3bKaOMuCCBhDPB1zSwTnB8h8EYCQeGvjYETCHfuBegszwcnqcNJKSdps1q?=
 =?iso-8859-1?Q?GcbqB5jRCQE7MCe/VvKC68k9frcQs2088erFcalPV+S2wHH3Sl8CQcB38s?=
 =?iso-8859-1?Q?Fs3feQR5yRyfUsws64REIsd7UXUeAMLWjrUuDTYIDCkJhNBQ2DqpHqrCHB?=
 =?iso-8859-1?Q?pnGK4SWdnn6FHPrH/WRzIMJ63c0oWV4a2/SLJdFOixn9H884DeTY8EVfaM?=
 =?iso-8859-1?Q?nkgTlwLMk64tYCMBJCbeqj7jSDnGSpy74fsmbLnbIhqADoVewpAcXCPnv+?=
 =?iso-8859-1?Q?0wXcB+aunwG/mnYcWh27Ca7KIb70YXfOxcZohYc4JpvIdePxZzyTUGGZbo?=
 =?iso-8859-1?Q?Q1PLsk8k4fLkIPIZNZyAShNJpAiOAYtkOc69ADUuBZ8X7MhRVf/IOfBIuO?=
 =?iso-8859-1?Q?wE2ciGMwDEfGtWmUPJOyEO+HPDC2wHBxQRYLjogotB4RCAntSIwbdDS2aK?=
 =?iso-8859-1?Q?ugdFGNNcTVZXN4ka/ia4wvt90SZW8AyFozxm+b944durOQq2U1J+Pvxc3O?=
 =?iso-8859-1?Q?JlGZ9S1z88tZ7um7EPBu2OG7nmwo7S58wLGZpFS4/l5j9lUhskzjHY0dyQ?=
 =?iso-8859-1?Q?V4kMFMgk33+g1frN7kVJAGrk0kgHR2eZ400EwURy1QGdozg7QhHRnsz8Ze?=
 =?iso-8859-1?Q?tYbjJF1vXzxaDt1vvvoh+c9MOvtI5E9dLisP7/grXbl5uBaE3h9B/JDTGo?=
 =?iso-8859-1?Q?Q75vLbEoLlAfUavWmwZ3v7T0Uo5TyT6S/gRQLq834LFedhoKtVBm2KpxAA?=
 =?iso-8859-1?Q?0iJkqQxrO6EAgaY4hh1dr5O41AZxyDOYaDPAKeQLYHv1EoYs4X5A+Z1eCu?=
 =?iso-8859-1?Q?IPIZRvKHhtv2m3j6eZBJToyIjR0lAB7+i8XLBXQIuAmvuK1STLpJSNMMd8?=
 =?iso-8859-1?Q?doLe91LFRKJ+hsLYKy50QlQSvuszlOoWgQHPmXNnukLct/VxREeR6kh+VL?=
 =?iso-8859-1?Q?Npvaqz6sILtFWicMXiY4Hp2ORwU6o5bTys9oTbgc1HNVW6ioOvnCaPBZqi?=
 =?iso-8859-1?Q?iHeVzFv6R6zLnMmR1TzYOSezD1LKb4s+i+cqIPigbwuiMKqFukwrPQ2YqW?=
 =?iso-8859-1?Q?qzXcumrt4IM4Jof+1QWW692siVHRMhMvgQy7xBYym5Av41eWpXwwYgtMWm?=
 =?iso-8859-1?Q?KJhVHE8QS5b9yRO+G5NXvgey4SOfr22svxOvY4WedVhkGh+8JcZJJRTxaT?=
 =?iso-8859-1?Q?a0fftnx32bVAwHfYd0pMQSpJxu0ByZGptoTe8Jd3lZitJ6TwcDZY4mbJ8r?=
 =?iso-8859-1?Q?0VuGQ3QnT4xpAR0MCBLDIwUO09O+?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	193c3668-2d6e-46b7-229e-08de3f16baa5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?U+VSyED5i9YpjtExws++6/lUO5louo7LevPpTRI5dLLalaTbaxlABB+/rf?=
 =?iso-8859-1?Q?Lx45K38E7A47bxJA9DN317GuXk1iiRL6bFgDhbo7vLiBBGp6aaCjZ7kMpy?=
 =?iso-8859-1?Q?qxJwu/W0zcUfh8fjbgimMdZzAgZwJrmSh57XwryJI5aMoH0lldoAOPjvkD?=
 =?iso-8859-1?Q?Fg9HCz4OPSc1hYUiHUVtVtzqx9oItfkZfpxKBJ3yn4k1lI2J2QQGdlak96?=
 =?iso-8859-1?Q?tkVjft4mp9HrkRox7O84xkhJctLHdqyzawQ7MdiFI90yOIFuxxGgOd/xOl?=
 =?iso-8859-1?Q?kkd8hmmnwhcjWYx/xHgl3/ARk1MC9JGtxYuvFANADOeyGetCei9aRQkjnL?=
 =?iso-8859-1?Q?wqdumrvVDi8igNYVa78X8N87CPZ6ZOiW959AS8TC/CF5YqyF/Dr2jrCw5C?=
 =?iso-8859-1?Q?/M6mrg1cSmO9ITuY/SbWDxMpyQO5sa53pFnEIHAMPfBst1y8KIroUd3VY7?=
 =?iso-8859-1?Q?KWcZ03daDWUjB8aPkRV3R5tjRulrUvqz6g5o17/Nhd0QEBawgQ6wQ2MVRc?=
 =?iso-8859-1?Q?01Rzdot5VgXZ4i6eFe25IyDrdAhZ9ZLhFPGRHFfZxc6Hr8Q+Tga1AGMMCg?=
 =?iso-8859-1?Q?boZRzXJ3XPxD4lvkkShpNTpunhUev92z3LohM0uSTEYedEJdzUo4NiraFr?=
 =?iso-8859-1?Q?01y7lxu8fwgUb8fP0eApz2UufKD/5gq1DOV+wmxIzCCPqz/eTiVbLczzZS?=
 =?iso-8859-1?Q?89WcrovQVH4zQ3BebvI+TS/Ks1WvmbXZbK9udx4r+MWDr4z9jmByJ7Fn+5?=
 =?iso-8859-1?Q?5yXU8+Wk1+WpgbF2Y339QQQroMleIKl/cvL98fukSB6fiN1G4SJfYY9QbP?=
 =?iso-8859-1?Q?g9DH8JA2tEsJn+KUsHCOO5u+Aauqsk9kY7Z8tOVTKC4K1vr3Oeim+cN3oJ?=
 =?iso-8859-1?Q?XGVcEW07Ymn/zd7RyctSnmI2HBParKbZuDw8kema8PC1a1F6DSRYoZlyjl?=
 =?iso-8859-1?Q?rgR352N6KCFN7jEYoWuzd7L5O1AL0aLXho5q0F47MSFRHx0xKqQQvyDBWI?=
 =?iso-8859-1?Q?nglHy8L25uKxspJ7G/cFRAK2BYle4MWxcOaDZTSMcNQf8DE3dxu0VJpAW/?=
 =?iso-8859-1?Q?pZIQmduTATSbtqcZVxY2mFSzljM3/MMlT4gxD3s4bnxyOcsob+e10q8IT8?=
 =?iso-8859-1?Q?LSXzh9hTCqT+xk961r429Q/0T+x2ictUeyZXcf5ADSWXsX7Hvs4Kb8JcfO?=
 =?iso-8859-1?Q?n07OFAwv70df1xmPTvNZOvkN69IwfOLEZQc/thPsIX1eCHvSAoyLCz+RRB?=
 =?iso-8859-1?Q?6EhhJg9/SkpFgPh3nbc2K3/vpPb7JI6iL10llTd1dR6Yw3nVcGyJaqlyfL?=
 =?iso-8859-1?Q?FHM+/VlL2T/PDg9thdCmc3cl/HEtUeGWdV5WFrb3WfWymXJKN6duqKT984?=
 =?iso-8859-1?Q?y8pl7Mutj0If1Bx5+o6WqdhD703Cl8e4RPh/yoQ8wzmZRGV5TuptFmyXZU?=
 =?iso-8859-1?Q?e96I16FhXmnB1jwRNOj8pkVQMAmg7nMKYoBxlOTGhmHN/72ADmkRSOnAN/?=
 =?iso-8859-1?Q?ZPwE1gUvPfUpJv9dtynMnDrNK+Y4NRhFld42TzpcFSrq+Gu4/WGh5AbIGR?=
 =?iso-8859-1?Q?BSmkScb5LbNWU1C5r32JkP2J60aV0F5eb65FXlkWMcmCgxIse+9Pd/lf1k?=
 =?iso-8859-1?Q?1gmtKEtOSucoE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:20.7572
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edcc5a1-3785-40a2-1b41-08de3f16dfb9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9395

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 39 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 97d67c1d16541..bf72982d6a2e8 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -12,22 +12,13 @@ static struct vgic_v5_ppi_caps *ppi_caps;
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2;
 	int ret;
=20
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -35,6 +26,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		return 0;
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -50,6 +67,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1

