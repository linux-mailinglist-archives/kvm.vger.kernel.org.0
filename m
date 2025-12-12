Return-Path: <kvm+bounces-65846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91748CB9195
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F255F308A949
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C3630FC1D;
	Fri, 12 Dec 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dwFLklcs";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dwFLklcs"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013025.outbound.protection.outlook.com [40.107.162.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB8B30F53E
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553028; cv=fail; b=QCo3oD+3DxIrVUWmtnvXDha8mb/CSKzKr7EoU58yAZCfMHCrmbUai4Hj/rU7ILpjR8A+wvWGRcxAzZfbeFqDOiJbpyi3vk5fo7EwOMLTGfQiyuPQ0LRkq/My6CpTlMn7LEsMIFISlhYI24HssAiAbXpI5K44azgprdeAWQ6LpvM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553028; c=relaxed/simple;
	bh=30eiZFV27a90esgj6MuKrNTnkPEraDI+8EYEHP1wcs8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FMfthXyO204DH4U32YWDXgJPBmjsRVSmOupiPnfaXeqXkP/9OVk7vKxhC7cNkfAb5N+UYvHBemij4PZr/ztYI/bRXOF1xVGHfDH7HBo7kgyc/8wAkogAda3rG5W1covh9SoIwPH4jjo+/VeEeKnn+4xQ4mdEGAHRvAy0/PfiVNk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dwFLklcs; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dwFLklcs; arc=fail smtp.client-ip=40.107.162.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yoEoCawgzYb6aKYYmkLJ0zn5mJjb5rsWMsJLJ1ngkjO52DVkpKGLzCI8TeFNMiorbY4iZkSs9MAUZw2pCnbWWoXfXAKsC1QhvMVfmw7wdD5uO8n+LgbDFAT9Pq8cuxUcZ6kPwL7T9a7ytLp7hfjCb2aMkkX3ZnhDXTEgpreAHrlISuJ4FQp0pXFoerElQ0Gzr1eXEdz2Q+I82ROJ1grwX60Bw0r8kcl0+aZB0/1cF60kvyAeGYK5jlnokYmhjXg2q5mwxz8g7Dyrir2LvUGfUwn+b9B7SkeoI0COxWnvxfTRhAWnnohC5N3fc7zx5C041IPcRO2bCJ3uFP8fA5F6Jg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0vKnnQVQOLcuGM0Z6DABlcPjogcbXkt0OdhVZNjZAY=;
 b=ZCjzHwuhDERJ8V1YvCV0zYH2afumu1K9a4nRgJTrBrtpXp+WfS2iS2NvMjUw/6KduOsYwglUgiH5qf+Ud91u2WUVmgMPRDM9DiJ5GE+B/cxegT5yLlGVUDEDxD2ZSIIwQi870uoW3bZphUAsNViFkDpZGxuRBu539hALtDxHT0qlDoEt0Y9d9/DL0+4N/2jIbGTirhkk4AGUhcpmBo3UYXFrs7C3dlqs5jx9eL/bCf7W2wcAKOCEWBliXxiD8jnBKW+jLO/PxsjvjhMxoywmn9lHreP2aVx5kIaz2ggCT+vB4ZM7Hm2K9D6L+8dXnM5Mq1UZDYGntg5jBD6TGxiH2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0vKnnQVQOLcuGM0Z6DABlcPjogcbXkt0OdhVZNjZAY=;
 b=dwFLklcsIKY2lzowrseOBfLEEPb5TcDkik/ABhMJb0vtq+cwbOOjJJjUbzycJ60jKFtnztvovVIrNFr1oXN2+WbYgEt8awj9ojwjqT4ejkef7g8UKfsxkJaTRJffoM7jLaSXZbFNDNJDnSwOUiGAeCyYkDrvBwbY53+hfUGgZf0=
Received: from DU6P191CA0048.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::7) by
 AS8PR08MB9313.eurprd08.prod.outlook.com (2603:10a6:20b:5a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:41 +0000
Received: from DU2PEPF0001E9C2.eurprd03.prod.outlook.com
 (2603:10a6:10:53f:cafe::8d) by DU6P191CA0048.outlook.office365.com
 (2603:10a6:10:53f::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C2.mail.protection.outlook.com (10.167.8.71) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4 via
 Frontend Transport; Fri, 12 Dec 2025 15:23:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EAqEBXMNCRYrAY+MI3h4Uti3Prd4aAkwfDYYNujXfN/75FFQV4BWiCksv7hnW/CJadzyftjSyvYx1xHYCDUtu+itE/WUIphNIcycDHtWmmdA/4P1HxSURXHQFLO6UWttg9aWt8TgcMlu27f31qcRp2zD8Hn4HKfI86gscu9NbwRhYr0tWyUEJFBv5rBSmIJXWS8pme5IK2uLvrW+zTPwDsqGFZZSjsi3ZQ/LPJiIgw+qt4CZS/764PEdtZL4CoRzUBK5IPdIdK05DpyxqtXqGQWOM+kblbhFq9tATqDkiQaKIBT3aonRnjqEcQRZwdcwb+JKaYqF2I+ViJEj+tC4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0vKnnQVQOLcuGM0Z6DABlcPjogcbXkt0OdhVZNjZAY=;
 b=UVqb8ARQri3fYiuGeQK1C8NyThzKtjrlgtCqdLddaN8qLKPVHEoR13C6Mb6mCN4dEr+IeIYwslS1y5KrlueAGKZ4oWd/zFHEDn2qPaxlwTrzmQUxgKT46l5pz7jQ4/B4F5Z0Kuz60oHQervqYM1eV6avmpWXPxIL/xWMP0vbG+UHD/C3/AXQtoqRaE7u2/ZQD0e9+SIRezBKitYMNtqD/pXnckaCHu4j27UNgSgWN5bStuVr8/j2NgTkUoD8QKx1pkkMD53cZQpjcs0F0RuEChdFwR8HRQMmayxCUhDsd0dv7kwDe9qQs47oDu5UnYkjTGN5RRLUOqAb2YvJHz2Ntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0vKnnQVQOLcuGM0Z6DABlcPjogcbXkt0OdhVZNjZAY=;
 b=dwFLklcsIKY2lzowrseOBfLEEPb5TcDkik/ABhMJb0vtq+cwbOOjJJjUbzycJ60jKFtnztvovVIrNFr1oXN2+WbYgEt8awj9ojwjqT4ejkef7g8UKfsxkJaTRJffoM7jLaSXZbFNDNJDnSwOUiGAeCyYkDrvBwbY53+hfUGgZf0=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:37 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:37 +0000
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
Subject: [PATCH 05/32] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH 05/32] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHca3slTVuUwDqmvESPyDY63I85qA==
Date: Fri, 12 Dec 2025 15:22:36 +0000
Message-ID: <20251212152215.675767-6-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DU2PEPF0001E9C2:EE_|AS8PR08MB9313:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f213733-1870-4f56-63ef-08de39926d74
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?v1YnozRXKfvymVVqZcwa/AqqR8N0QoH3DuyrJYIIhlq350siEw2qwZ0+VU?=
 =?iso-8859-1?Q?W6UCI05PDB8HMLfhjQemgAV9Dg9C3BzTCa9BedpQhqj+2o21WqHuO9dOcd?=
 =?iso-8859-1?Q?IKPac01eZ3UhTEUTSVTwL9ET6zj4OzWubMYLR4wQpODAsAeeYLA+paSTZH?=
 =?iso-8859-1?Q?ZozLp5291aEHQOcHfmjTTXdmcVR6paEPOLMzNWuAS3rwTXeq+cKDX5EuC4?=
 =?iso-8859-1?Q?8L7Zb/3Rw9vu/NFsiXoAVxlg91odQFV+wFsbbEP99MuYSTGV2lE6Y7Gvhz?=
 =?iso-8859-1?Q?Kw7TwtrU8EOifQNZ6dOxIMC1APttv23vCsY/NM0aez2hv31aFRn8wN7SCm?=
 =?iso-8859-1?Q?JMH62w3IzxX51Drm8Gy2IOBmFEzr24YvoYoN40CUSGD8wIatmUOM2AJeNX?=
 =?iso-8859-1?Q?IJnigD3f1Cy3H8o1l4mNnU+3ES45OqLkXy/ILqqn5SrKFaVU+9TbAA7zd9?=
 =?iso-8859-1?Q?0lplG46aCxDZu4W19aWGS7e69GHzS9/wObJ50bEnXScwyic1ifz/AMkmFF?=
 =?iso-8859-1?Q?X1LQSa66j1cyTfwYIFs/bNVRlpvhFasMf8ow6ETSdVq/2vpH2MhUo9bVma?=
 =?iso-8859-1?Q?2Mubsaxccw+aHoEISTwYUes/1VbbjWTZAabUxssgDsiFcElZ7APw/k1ySE?=
 =?iso-8859-1?Q?cEsnmY5czK5ctCCVOLj/2OtvlE0IYXVAzomD56Q2GsUxmmtg9fJsrQSLnr?=
 =?iso-8859-1?Q?QS3aTiBatrTapzp+ruhzdzEyGxCzO3TE3bmOrv5TRUxcLNrEMkdnIWgj9c?=
 =?iso-8859-1?Q?di8386DUIxtlGE6WE1bxdtZX5PcbLjlpLqClBaLPh1vKALHWFsrcDN8RhC?=
 =?iso-8859-1?Q?3fSXfN24swsdRYfZ/Z9YXqGniZ2Oqs4/ohHDHUfdXUXBWtiSqoO9RXKT6z?=
 =?iso-8859-1?Q?g5SDK9WOQDYYFFTtXsNQZtwMMbh1TSqMNFqY/MrSuk0lfITVPjc65OhWro?=
 =?iso-8859-1?Q?nWGsteYzRzxdUr8tXKt99KoxZy/GQ779Xiyaan1X+r1yZzBndCZLdiMemV?=
 =?iso-8859-1?Q?cbv0EL66v3bXxB11Jbse58AqA/0R+sZ/mzvzTEenDX0Cb0Mq+ViQ1Lg7JP?=
 =?iso-8859-1?Q?jcu3b9uM39rK3vWU6+FGD2kjS/EqFShS+q0se9nn1+njsn/iROr+myQRKq?=
 =?iso-8859-1?Q?oQ86ZnxzF4pKgcWUNHMkhdTgyUSnHiY1nIWKCTa/jBqBAnLoNuDGCQ9GX5?=
 =?iso-8859-1?Q?PYelJ4dIU2geF7K+WkA3uYKkEuCzxhFHq1sicEWjxikJB791o5V7aV130d?=
 =?iso-8859-1?Q?sj2DZrvqp1enci6RgTCGZ05QlRLhWnvzuouWZznUmjGuZY2YNgJ612b9aK?=
 =?iso-8859-1?Q?bWcwM0GdnnWxvlYj0S6CXWWFu0rQBikpQY/VKUsJizsQH9NrqQlpHTwqZQ?=
 =?iso-8859-1?Q?d3M0thGspjEsrPG/hp7M2tasoUEC4Wtr21eHwriFgpEhyLZAXe633OTZu2?=
 =?iso-8859-1?Q?Wa6h+6+yaGofi+NqnOj0igD7Os4f2WQJ6lmgAjJmbIQbyDK72BMAfb9pe2?=
 =?iso-8859-1?Q?qp9j7hJhavnlkK6xXs9iNRGbfjlJQkUk8+O06hetOpmMkdUGj9z/mxbL97?=
 =?iso-8859-1?Q?iWVUfTsh7H4/59JYuKcKgacWUz3n?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4f0b1140-26ae-4069-50c9-08de39924825
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?zhPAkHACJGYl7Wjg6ib2rIi+8H57KAOh2TYbhqWU9l0RuomwzBMlPtk8AB?=
 =?iso-8859-1?Q?d7WDv8t2FnOsGSRGz7lYraylYv9hm5oV4iGwlmvT8FikP2EjoEXFr4b0t4?=
 =?iso-8859-1?Q?ChBd0w1L7e/+eO5aaaFrG1VqcwCdx2fBN0Hv9XYfxfZxxbVlvLkPJBlCDR?=
 =?iso-8859-1?Q?LSbG+OAhRyP+M+gOBz/eaHAma6iUee2LTiMe5QxGzyeAxp653l7kTKQnTh?=
 =?iso-8859-1?Q?5MYGMaYjq1S4VX1B4V6+XWLMACCtJp0T5I8H1Kv0SXAIooqWvS8bBVTPNj?=
 =?iso-8859-1?Q?mEYQmt0VFMqBCk6AwdVisSCD1KdosUl64dEs1qOdraM56a3gT2X8ySsHKl?=
 =?iso-8859-1?Q?a6tOtRouUeA5IigKfnCRfHWjbCic7csq9CkzC9g6JhM5B2iPD9/RMH8jRJ?=
 =?iso-8859-1?Q?PzzAyxNrlN2io/3RWjZe8DTDKSuosq742HTy8B0Z/N25410EuepHmopkKM?=
 =?iso-8859-1?Q?gHwxcz7EUypbcHS6vO5sNUDQ3AGyMRr9l7O6wL/yah4hWddylLUifsBg32?=
 =?iso-8859-1?Q?KlTQO8VNM8QxQumr3Oj042d+epeoz0Yx5vnjHR30rB10p2zt8OBhyyD2OC?=
 =?iso-8859-1?Q?KerLS6li9NjXTgkVnVxQXrpkYoTy95iOzOoqU/w5LVoxqVpz0NgAurk4db?=
 =?iso-8859-1?Q?FpM7HBqPLJMi4aItNNXhg+Hnryr66aSbAMkEhyhVNbORLMcIHqCf3tmH24?=
 =?iso-8859-1?Q?+ic3Y8YtBtfH2HFmYyCsM02ReEWkr+KUceKnIMLYYXIaHg+5X5+DQfqSbZ?=
 =?iso-8859-1?Q?TabfT55J0G1YKw0jEeLR71A4uS3EF2vGpI1P2LfiP2xPiGp2miWKKQb7GQ?=
 =?iso-8859-1?Q?8gg4IzwSahCgiXZ/FsyGDGgB1g0N7OPG/y5SRWLTL0yeNI+KRer9Qaaq+z?=
 =?iso-8859-1?Q?eBJ1rKl8oFqKxPWChyGD+pJ0IX3oc87KOe66ft0OYFeU3j3TlSKwkh+ehP?=
 =?iso-8859-1?Q?TaxeqBSKJ5HBmu4ayWhNeQSTaGh7qmtB0vvvUtUZNDoiByWkh79cEKPaaw?=
 =?iso-8859-1?Q?o0sBYNTwjybLwRaLk78G0tY+4OkaxZMUA2WjAnfAxJgPZtUMa5HSIhgvLt?=
 =?iso-8859-1?Q?RBLppgPwOogiUvrZCVY1zBm7ovLfcCJ+Mj3f7AHc108rFmeqwQzyEeAUSt?=
 =?iso-8859-1?Q?MofCWV4Sla/M0+nflmkHteoZS1dqJhePrIhTTfgJZuMch79cjtUM6K7/Vn?=
 =?iso-8859-1?Q?/EpVU4sMUbYzrpUgyG8rCx/888TWY4VhEFwDbbFR3B/q7oKerb8ayaf84c?=
 =?iso-8859-1?Q?cAG1Zuf0zE88EpqKzp1zsKbhmlw/sbswFbPmbm+/ETQOuf0pz+ShEdYevG?=
 =?iso-8859-1?Q?6pRwpI9qvvjqtn4GQrts+TERjRqFZl16WmMgsXuqOQmhDX4BIuHIM5xLTv?=
 =?iso-8859-1?Q?osYh1y5gzwvjn6uxRDAVuXKA8G8+fHHvLDSTjF0poXgWbAwmGfubi9A8H3?=
 =?iso-8859-1?Q?cF29Wuq0xDV0UQqxJ4Y2JyU1QdffDUEUhFAGYxlGZNQTp15X5yKxJvETa9?=
 =?iso-8859-1?Q?o/1ZDIcap/93hUhmhLY96F1jUpl+f8MiodrKfWgCFXUoc2I40D62B6zjYe?=
 =?iso-8859-1?Q?2yHSmozmUPMt4nzbzfwlVWbJiEwNM+BxpbeKSEWQuL/N1lP4galqbLuEsK?=
 =?iso-8859-1?Q?4ZCIRmLzv7His=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:39.6559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f213733-1870-4f56-63ef-08de39926d74
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9313

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index b3b8b8cd7bf1e..e99acb6dbd5d8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1059,6 +1059,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1105,6 +1106,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GIC_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GIC_CDNMIA_VALID_MASK, =
r)
+#define GICV5_GIC_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1

