Return-Path: <kvm+bounces-67593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9203BD0B809
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD05A301E17B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4757365A1E;
	Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gWpFy66C";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gWpFy66C"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010006.outbound.protection.outlook.com [52.101.84.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002D5364EB2
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978351; cv=fail; b=W9skEesVNOmzzv55+pPUJL1eSVqcGID77M2u+B8E9oEOdom+KeVR5wVRIMFwoFaHjs05UffGfJqN7RuI4sgm3ql5CP+R5+1VUiLuu/Ui3tU7/n6T3FoTu8PaXUcJ8X5jYfLE1nam5WVzkIV1NrbQK36skFcgkTIocMoieAmQh/o=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978351; c=relaxed/simple;
	bh=xLnWRUBN1+o+4RkfwSXnUtREC4kWiqrNeIrjXrFBu4Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k/hJu7fa8uMfYmPr68SmFoHTEQGK4Et3uhYx14oTACPQpGkSFqGJK5h1HWF738hVeg4itFiGnb/dfSm8UzXnKT5KnNHT4XvqcwXU2QdvjM/OSLs+GxNwf7eVG0/5mzeLrcnKq6t5jskdukjC42dSxQwVY94/i+vv41J95XO4cWo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gWpFy66C; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gWpFy66C; arc=fail smtp.client-ip=52.101.84.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Q9DxpCEnrKdaD1mkECztQEmUAKgJD2y2m4yb2p5vW3/n20ZYU1I39LmlrlLumq3zCsZBOX03k43SvWL5sWj+m4ogqzMbdUmSnZnj02HVcOwMd327o0v3/i3Wv8d9oDmoPPZa1DadXXjQlPlvR+guZYDOe5keojzjzGMTURpgEBYvV1Cel1TnCjb6IZI/u1TWdL5CCAu611zVwPr2JsUYv3qIkjSZDtJYFwH2ufKOAXtyxdIUj2kSdfRqj4aMo8CBaPs3IXy9/xuvZsB2udZA7Ec1l78dQlQUovZ3+88TEVDlax/ySwjHP32bJkjJ9pjoXr8m0hTAqOhaEzmlqmvGwg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLnWRUBN1+o+4RkfwSXnUtREC4kWiqrNeIrjXrFBu4Q=;
 b=SaQNlH8tb2fwD2TCpxixNobTb4NBeP/06K/M802BV2bMgzg5MbO3Btiz3TuZU7p/cVxyWTUIpoc3iiEZWwp9nS/QRsIhS4Vk2sDmhVgo3/rQqv6j3S4hzWt+kxV1wNnhMxYBSZZ17zr6H/BYqcAeQOY/Lmin3U/CHteFqHyZeuPt5/21saZFigignzACBerXrJRigprkSBY48GKhjZLgB0eh3IDvRei61ylJ+MBp8125ZuR2FyK/qoQCXAUbikw/CahKfaWvShp0Xa9xQQal6xNRseV4lXZSMEeRoJwPDYYvsTYtKQVfO3xbXxG9JeA2FmDDllPKOEi1jl36r4g+Tg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLnWRUBN1+o+4RkfwSXnUtREC4kWiqrNeIrjXrFBu4Q=;
 b=gWpFy66CIj5zWWlUTfh64EVpyNlzQx/PSLBktCadOc2J63JecLTsPRbz8DjEtkius16Psr0so4O6wsEChvLrl3ft9ev8lu5XZoZq+Z9FMKowTxeZwSvnSeUM8nWVDa2nDA0ar/laEr4QeuEDJHAICsI2AfU4UG0Sd6dxgPn5leI=
Received: from DU7P190CA0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::10)
 by DB9PR08MB9513.eurprd08.prod.outlook.com (2603:10a6:10:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:46 +0000
Received: from DU2PEPF00028D0B.eurprd03.prod.outlook.com
 (2603:10a6:10:550:cafe::d0) by DU7P190CA0026.outlook.office365.com
 (2603:10a6:10:550::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0B.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6cXWQ6qKJdAihxUrw7ME1ghfojP9ng1LHwXvjgJ3kg+SdpJ/c526hwYIaEfXSvLeX3cSh2b8MkDfq6wek1ndOFs/LjOVFuOgsvM7neqZiA8reEwNrDxugpKL3YC0+Dhq65dvG79qFfm47Wakx9aLPXyPw7TlqzbrvukjT/HQ8XGOyUzdYfVO//2IlEjbDnITwOzwqzdM7i4NU6168FjEM6/IRML5gBtMelGwfO9PgrjY7kIwckplfRNrTj4PpLAIu5QHZCqpnBOSmg8Fc1bsDj4EBlmqNBi14C0RPL8UGLcGMG5aKSM45YBWIX4DT5J8VlyaJsNEsVJFqCEJvWnxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLnWRUBN1+o+4RkfwSXnUtREC4kWiqrNeIrjXrFBu4Q=;
 b=WJJa2uFOPcBUO7ZGL/CwLAQyUG3GTKOun+AtwNoq4+9zGKMyjXkUWEcriLeEWGtDlZ8F1f/LibqATw0hladH0Q8ZIxDo2aSOH6T2Ey2C4LkOSDZ5RwduB6JaV+Gea9uS/+VfVNNQLjqvSt7WmhNq2us+iQy2CPlqo5aVJuvqJj95GKSZNck6AdB75Dr0bZltDJGgJ3j3KThxlAixn/zpDTIPrQMTTNEqWGAgGkEIgEOrA7K+xEqLh3SXaDZfEZWmQn1GAmBdQNTCyzFtNv+n/G+ESoiq9apQMPNU+3sMPXjnSqBKARydPsrAlG269abKf6aSBFmr1TdnkWbGcTltrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLnWRUBN1+o+4RkfwSXnUtREC4kWiqrNeIrjXrFBu4Q=;
 b=gWpFy66CIj5zWWlUTfh64EVpyNlzQx/PSLBktCadOc2J63JecLTsPRbz8DjEtkius16Psr0so4O6wsEChvLrl3ft9ev8lu5XZoZq+Z9FMKowTxeZwSvnSeUM8nWVDa2nDA0ar/laEr4QeuEDJHAICsI2AfU4UG0Sd6dxgPn5leI=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:42 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:42 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 09/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Topic: [PATCH v3 09/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Index: AQHcgYoLO/1ZFo2+JUylykpoViYCvg==
Date: Fri, 9 Jan 2026 17:04:41 +0000
Message-ID: <20260109170400.1585048-10-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DU2PEPF00028D0B:EE_|DB9PR08MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: a0abb251-0459-4983-7d93-08de4fa15460
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?lBbeeOLUFP33WbUhxNYsYTKWCKVV9l9i/tIGq7H+UTRYNCcpzDoVbnIYGg?=
 =?iso-8859-1?Q?5x50CZLi8UXQmLjz4kzYepg7e1NpSPz5rrXHxF4horzXL8cEtLERB0IDDC?=
 =?iso-8859-1?Q?nWU8vNPXIucCVr4LISrIdRSfJ6DLh+H8a0t0VmOq7fTZPKYrp6MIWTrh9f?=
 =?iso-8859-1?Q?bB6YLc5UVm4lp+B+NEr7IN2tdg8A2B9u5bcSY6NoLGFO+Ku76GFGwBIHN+?=
 =?iso-8859-1?Q?/zr2II9YH6VG1X1lugVg0JTUh7J5txNu6ha8mvIcBdcCp1G2QoPP8NxpDy?=
 =?iso-8859-1?Q?8HzClMhQXiKDWKSOM6BgjLeKvgLzNbc28FEl7r7fDTxP6/WK4sBCs8qSM+?=
 =?iso-8859-1?Q?Ikt/sNAzi5eOqMP2vLus/+C9+OXdexr3YfI+WUZdQkIjT0DFJbnwCJVFvB?=
 =?iso-8859-1?Q?0ERiYcO6Pxu9qI4DfbfQN/yMkThusSramPqf+TmLLnFaLA45aztdiFg3vK?=
 =?iso-8859-1?Q?Sc8FUWAENhWW3mmtXCtdTCPe+U5duNhWEuoGbHoh98iUu4r2wRgrs5V/Bl?=
 =?iso-8859-1?Q?Lft17vsij8RUpRroqT/aYL9QrypuaEJlN5IP5gxfiLgWfV8gE+nmFbCRRm?=
 =?iso-8859-1?Q?P5Sk9ctvnieUU2uS0XhfJaYUHKSc6xFAPzxGcR2JQpGzBX4Kyf1k3kzdzz?=
 =?iso-8859-1?Q?yDGDNNueYIPX2hVjmSCN/Qh6cFB99JWyTEvPS5UXF6+wjY1Klm+SIHrETq?=
 =?iso-8859-1?Q?p7+IoqCzGuJyVehuji8wfKQK6Vh3z0gFEJjyqQCSpIFuynI6A7QfT3Jg/9?=
 =?iso-8859-1?Q?rKpK2YgfXeLBhBvMSFtLJps38W5EBGyayTTzg7n9qxP+qpublyPhgHjBtS?=
 =?iso-8859-1?Q?O4Lk5n0iiB4kNFfsNwz1/DMMaorSqWmKeDGjCTmuVOHjgGHgtSV/1GbY/V?=
 =?iso-8859-1?Q?2VCG0T9sTf4t0D3c9sU2qeEkDqvo+DwNOSir4j9/OMTEr+yMgflAjR1TYS?=
 =?iso-8859-1?Q?nrEQKUXBbGj7s42WLJMm+gRP2j72wn/4roUC6qmod1O3HTCCVSM0Hc3ykU?=
 =?iso-8859-1?Q?5hQ1O1gqrTgSVW9H539Oj2pvLiMrYcc443x6Q2i5swaz7cFJqZs8YAnSFP?=
 =?iso-8859-1?Q?f/XCaqX0dIiFFjsHhFi1rKLaVvdnXPewU6o31Ah55cSPiGh4Jrne0XkO3B?=
 =?iso-8859-1?Q?koGopilt0XAWUEwtc2XjTmogahPCQPL45law2AAFfF4oMSj4dvNsIedmw/?=
 =?iso-8859-1?Q?2a8hvap7h2pxBf/3WArRnsThTT9pgJmmHUB0pnzHgvAdPQFXHzS9A3XBet?=
 =?iso-8859-1?Q?ULABxvIz3GO6QZe03hMiTpvd6CeiYkaVFcQeiInUCXS70A5FtqMqh+fTrE?=
 =?iso-8859-1?Q?pKD3Aejp1hzC2HoAo0Sh814ba51x4Fw3wUVWdcpKTfKT2WE6YjYnZiwkQH?=
 =?iso-8859-1?Q?kS0Tzk362/wVKjESgE6CyEUTtOR8qVfZV7gtDBdKySzZYPPSDCuQ//8xFA?=
 =?iso-8859-1?Q?9+AENwsjxlPLw6VU5im/mcK2vlGMiw4m3GDMCafvyyITKhoFfFqJfP0X5b?=
 =?iso-8859-1?Q?LE56ZDURUEkEPy1i8FCcYQAdh+JI1u0QnnQ7hr6Y1C0cfqE9sjMqFvr0nk?=
 =?iso-8859-1?Q?NJ2RNaxDgg4wzNOvNS+7eT8aDDth?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c94235ff-73e0-4698-a0a2-08de4fa12e6a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|376014|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rQI4wtpUuEtD157yVbHbPpreznHN158fI5X/EifiWjlP6V+Xtba8dAv42J?=
 =?iso-8859-1?Q?qgFVP6Nnv24CmMydBSDkO0RneJMkWZqLT7G2oVixjrovq49mbNwIIDmpfG?=
 =?iso-8859-1?Q?v5M/YKlp9hA27jTbBQydz3PT3lyTqI0wcQHsMyaDRA9Xbx/d7awnmaaWjc?=
 =?iso-8859-1?Q?8OYpJFm+DGWe+43avsHkRGFaDpQuquEC4ppeeF7ZgQ5bGfw2FcNinxqlxi?=
 =?iso-8859-1?Q?ndnz80sTLMTITpqs1hGdKCNiwD6CbnEykAiQv7vD94N/MZbuaVT7It9BaW?=
 =?iso-8859-1?Q?3mTn9tSM/hqAmaH6fX9R19AF16uBgQ+FPx7rD3gkIAsyIW0sri+52izasd?=
 =?iso-8859-1?Q?t+87ysjzoZTvDQwr/gBGVBL8/qT1wddYsP/zKw6X+UGApxSayPvb4KIkxF?=
 =?iso-8859-1?Q?5s0WYlImKhpz8CjjU+fR3x09CirZVCR39T4xPe6rtiHvPqSFFH98iBCyod?=
 =?iso-8859-1?Q?3iCgHOyh+g070bAIQH+D/h2iorBX8Gv/e/wOialE/t4Ciz6YTdYFXjaU64?=
 =?iso-8859-1?Q?mqzTXPjTXDqYPPuHxaxV4Y5H6TM2I9FNd1BLvXkVPaGAWmnJPc+EGsHMFj?=
 =?iso-8859-1?Q?S+dxT9J2rXtDmszz2ffU4koolZlBi+oxZtXfEQD7cGIhTYWTi+gQxTRjSJ?=
 =?iso-8859-1?Q?M2z2tTuux3cZL9ynsfzQaMoqYvZt40q/ps6c7xyC0MJstJ3dFSa8gaxOOD?=
 =?iso-8859-1?Q?iB7t5muE+Hc9+7vNS6SPw9ESyAhXrUAQhi+/zwkuptsN5jITMC026xQOa8?=
 =?iso-8859-1?Q?/AplF2a5fA8e1r+dL/+NmHqFt2VFtwJgy1MT5K8lHnRgLu+jbY128IUxIz?=
 =?iso-8859-1?Q?eKqj0pQug6J5D29hLuz0Lv/dYCr52pWvT30uHu1nejUWo1xAmpXIga47qw?=
 =?iso-8859-1?Q?LRO2G1KDOWpasGX/M8hYcjzoJPmVruO9UJVWUTZVYIi2+i3ZIErnO1P67F?=
 =?iso-8859-1?Q?zD2jKq4VXb4GLOr8GY6cWfcEGqlqESIXzzYkuzBR5TjZHJge6Z/t++aWzr?=
 =?iso-8859-1?Q?11RQk8uFoB38JOkxLJT5yHL3TeXhS6L6lCMjfchLRqzUVVGOMjjlu7ZZAE?=
 =?iso-8859-1?Q?BSw3spJc6GejMdAB6dRr9jlX1bh9qmoVQfaPrfzjEeBUrclXcR7O6BM317?=
 =?iso-8859-1?Q?C82cH3vDlkKLa5nAhM+8aQzX7GUjE/nB0lgDUI/iWaXglg57EPD7WmUeS4?=
 =?iso-8859-1?Q?hmAi4R13P/Gh1WSmilRdw/Zpma/21PBj8CwO8IIsf1Uvx7Z3IS9L+P3Hyy?=
 =?iso-8859-1?Q?iKtvHpM4Av/QHcfz47E6YlPuq2qb+0GIGz7JDKvIopqRkii6f+xPSQszuH?=
 =?iso-8859-1?Q?S82zh6ndenMna2TrPqh4kMGlu5KQr7vAHSRQxvFxc8r95UeU/43zUub6sx?=
 =?iso-8859-1?Q?PmqaCihl6ZpaAf5+IK+8FYamWcNur77wF6WRc+Mkdes7mFN3H1FRIrGCtu?=
 =?iso-8859-1?Q?BlXHdfQyCTlY8Ru8wcSSuX/H6QFR6jCIMLmyxmqZSoVZ0b+F3rPqGcsbPO?=
 =?iso-8859-1?Q?uYDg98JhZkHVCSt1cyDKnj4e4kZOih+57uAG+xmPtNYOHV7SY1iHY0sp5U?=
 =?iso-8859-1?Q?Ujfg6hR3gB/4KVhaPkPqgpDCGLtFyuTu6f4u8IoZDlWidbSa1f/jl8JyJv?=
 =?iso-8859-1?Q?OXZwkPUp6YXAg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(376014)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:45.6018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0abb251-0459-4983-7d93-08de4fa15460
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9513

This header was mistakenly omitted during the creation of this
file. Add it now. Better late than never.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2d3811f4e1174..23d0a495d855e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
--=20
2.34.1

