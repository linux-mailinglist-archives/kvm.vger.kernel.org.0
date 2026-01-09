Return-Path: <kvm+bounces-67618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 917CDD0B8D5
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F94F314A08C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B6B366542;
	Fri,  9 Jan 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MYnXMZh9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MYnXMZh9"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011050.outbound.protection.outlook.com [40.107.130.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77491364E97
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.50
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978391; cv=fail; b=TFW3QxwGurtn8x8idPyLoyjq1C24zTSq60F2Gq2V+bXNFtUH/DuNt8rOyaIH3d7fBMNNehcAKNWVVcqJK4JhfK4aG8hqfNzhFOrrW1neqhzH0EeHORflZBGiiio9KJ4W5EAlEvE1AC3xRBO5maFa3sRLxp5V3yh335VVVIpAs7w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978391; c=relaxed/simple;
	bh=Gp9zuK6f0HFBxtArxHPwK4Q/+No7ECk2eraUsLhI1OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kv1cJ+XdD/GJPS8WeBKLdrRndyma21v2vlopRqpHEcktXuKbl3/E0Nu8/VrlCJPqdhqxTZP56nbzT6wjBuoO8Q2AZ4Cm6WibuyYsgKE/5kOaEbTu012yB6+fWU7Md0pFtAIz9oWUtDTUnOn/P7iAuXged9PlFn2BaarZ4nENieI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MYnXMZh9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MYnXMZh9; arc=fail smtp.client-ip=40.107.130.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jwjAw/8Er5GwdneAQNk06dyxZXFGuH1ebiLo6Zo+qWRjrLHvCGRbNzy6ImN7Ydn73rs2vi4dkq7duJgx7iNQqcTOTn60DfQYyFTsNtMGkEtcjbD7GhEob3fXiT2nLsmENax09yJFZqRneWAJPsEd5eIiNEcbkarGxLDtkcVsrr0t49QzdrWxmYFTs1oxiRHO2qK9uj6Poj8vDreWq/qDh99kDPALdyAbh8Obw07rpwho1uhGvtud+skctrcvINnaShkx8aBVLhfOh5/ceQO0n0uMgp6VwmqRrFUhSFcgYx/eRsPJehfug5zojsxdrIMylEUJxrOiiw4fLJBJ5pZMxw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=LXL/4IAHocb+/4SjYXboM5f6Bi+sVTjey54lsoSoztaSNyTK4QnGrkcAeUIHTaybiRq5147PCwJtFU3UWaEjBwFbNvL11d8H+0sNWA6iJW/RHpJLhBZ+MgsaUFTEjweqqFMrD0izyQqJaWSeV5X3j9l8EA1eklb40SFxKhdgKAJPt8iskOSDOUm0L50UjwbD75tdNI4+jep56jBO2VFZBvgok10hbalP3hTgnbHFg8U/mNePpMvILCh7oHn8ftVPvlU0hWufd0WNyZkpbSM0+pImqkud6p1vIDRiNcTvANzBzkCyNW1t3tZ5jdT5N0f8meuE5Ih3vpIc9k20qzhNBg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=MYnXMZh97k/YzN5lfvgXdMTjg64vmnBWHST6VOgt0rKkHsNnX+uKXrBo/26UOj2KHJjoO2T+MEr5N72gWadFXu9qq3PPbwsPJ2szcvwg7KyDr3sOlsDiNInrHwt66II0htRpH0nU906EGgDRijnCLY8suNhtbhoTRS6gzJgYBNY=
Received: from DU2PR04CA0346.eurprd04.prod.outlook.com (2603:10a6:10:2b4::33)
 by AS2PR08MB8264.eurprd08.prod.outlook.com (2603:10a6:20b:553::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:06:24 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::12) by DU2PR04CA0346.outlook.office365.com
 (2603:10a6:10:2b4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:06:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPGIt/A2j4pZKAFiLrPDF2xtCGpUlXoeLrlNOW5meDgl+eP7Nrf7vHm4pSEeuYRq0QSrd3EVpOOAh6bVLm6vul0DYDYN8je+Zuh6ZrJwca5pN5/5fZ6d3VKChaJ0CJg6n42qNyGIdC2PexHinliV7A59NVfGT7It9jn09jDToks0I7FYm1lnJRtiRz2bWJs7gkTwLjq2v02ZOS7GxhfDSEHRGjDgTVG3Vq30agQ9TYrlTgwCWPJA5l1CKQEjHnaAfb/GGqWdjLPXpVH9C+Nf7g+N7JLv14QTj1Yc40Du344vFRwd150d8QaYBCG4hhxXlZjAWr5JHibllLaeSepnog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=cy6gHRSqsWIVISksD9e6YpWYuEAccCUDiyesVDO+QSdOAtjQPeRCw1jLdW5X2nIa4T1G9V67L5Y2aH2iL5r3xzUk2+yMbxJQ4nYNGPYcksT7Fth0YLdGdNjiWHMvsxDwG5piWeQMrukyHkRBbZKiTHrRLKs1Lqv5XzKBJw42aCce2nQyOgSZEi9FFrAFHeOayKB1fDUKQTK0aTE9xqzryabqD4XkafDXKMZwN3+7Bm3FvJAroETztfDug7ZyqrNy4TYdyKVl/uUZsuCfpLN3gtn5V5AyFlgSKjhL1tF1wOi37c/fWhOJPLKUVTIlSTFF/SDUSv8cOQhKmQH3NfjMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=MYnXMZh97k/YzN5lfvgXdMTjg64vmnBWHST6VOgt0rKkHsNnX+uKXrBo/26UOj2KHJjoO2T+MEr5N72gWadFXu9qq3PPbwsPJ2szcvwg7KyDr3sOlsDiNInrHwt66II0htRpH0nU906EGgDRijnCLY8suNhtbhoTRS6gzJgYBNY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:22 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:22 +0000
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
Subject: [PATCH v3 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v3 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHcgYoQ04/kw/rL4USVBNcuu544uw==
Date: Fri, 9 Jan 2026 17:04:49 +0000
Message-ID: <20260109170400.1585048-32-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DU2PEPF00028D11:EE_|AS2PR08MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: dd65c149-e0b6-423c-e2e6-08de4fa16b84
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?zzVeCVq9lS2ukm/xvR+tIOXqsFKcuxq+/9TraREhDBmQTSLs6A5jSL3fgc?=
 =?iso-8859-1?Q?ermC2p/zjoozoYqUpZqeQsHpiC/08wQ687x5HGJz5E1sXmKcJrr5xcO/ho?=
 =?iso-8859-1?Q?Io8j7fDwci8Nw/QMAJTK1ULNSZPlKpHLU3Ujf9o4h+TL3KG1aLIi+ETZgg?=
 =?iso-8859-1?Q?HUTJYNW1gCH5hP9MvjiB3Sbr5TOGidO42AeKO37iL1zp+wHjWZMOHjtYWI?=
 =?iso-8859-1?Q?ukuCr8UYFyjGPNtk9q7QhfbFj4UvHHdobGOBPCI9SEDusr3C+abuTvpDF4?=
 =?iso-8859-1?Q?1fwy9F7uH3wjBd+wJjrOvkPjQnGgi15yxwNN9zVK0bA7yGhC5CumXmmrOw?=
 =?iso-8859-1?Q?BxuUzpt76opSpXyjEv1cEVOyG5IUx/bPYMlg/nD+f9lbmK5mTNmSLDwZHb?=
 =?iso-8859-1?Q?ihhalNQkGno0E5t5mu74jMBgWDa/5kOLA4ql2HgLI3pc7YVvCPQ2LbQrSb?=
 =?iso-8859-1?Q?MDHifyOSPx8CLTp+OxuswYVXNOcfy1jqueQ8lQbutYyIpOl+0Qx2RP9iGD?=
 =?iso-8859-1?Q?kCqga+Amqw19gmWq2VKdPloqV7PgTW3o5lMkkIhbr03rBPk04Veqe++A3n?=
 =?iso-8859-1?Q?zLNLmEDAF+ji6DSAyFrkasM7rf4LIWe7hAs5Zu/0vwrNDndiMOtm9pKC0O?=
 =?iso-8859-1?Q?RBRiHjydFQARBGLlIRymhnw3NsEResrOh4TtzkLgCI3GIZWEM9zX4vOHwT?=
 =?iso-8859-1?Q?V+MBWZ74gH2ORDKxP/ZBtOVXrIogQydGDmkrI7rHUD/eQBjocXnr0+Vk1w?=
 =?iso-8859-1?Q?Uy7UrnSXhFtHNaBTdRlqyE2wsWlW2cegUMpVEqMmUxmFQeC1Hj5bWJzGlG?=
 =?iso-8859-1?Q?jiN/n89WLkbd8tqznYSfJNHb4gIahkTKkcaQf/refxLkYdcEiTi5rzB+aa?=
 =?iso-8859-1?Q?rPv5hgukGDUw7qpxF7oKcaN2g62CYILw4DLOf32sbz0JtbuIDIjf6Htp7Q?=
 =?iso-8859-1?Q?VVtco0+mP7xrORXXIL/9/7mjFvi1EXpB2fnOLBEJDs7FfEtqlL9BSh84Hx?=
 =?iso-8859-1?Q?C7xj/pVVafea5Gs8IJEkgZzOqARM5SDJOff+Zril88mFmSXTDLwmk5buCH?=
 =?iso-8859-1?Q?HH+vfgsk+NrNl0CMOxwkbOdr6bduuf04Kj1rhZfHhUndh8J8EsuDXUX2Bh?=
 =?iso-8859-1?Q?9d1Z55xbNmt58JvxU3p4NTBOETGJ/lkjq6NswrPeXqgUxEUqNIdUkdmnNn?=
 =?iso-8859-1?Q?StgGMu1RoM+fik1heZqYQvayntzXrtYmje1v/BX2u7pa/NdndZ3OV88xZE?=
 =?iso-8859-1?Q?YMxLw/nIN3OdYvqgLx/P96RgKC2xdjSGaoiOS2BjvjKL3T7SVz3s2a+7Lv?=
 =?iso-8859-1?Q?Kgl/6pRU/GcNjlaKEjIJ+rUkU2ovbVQUHzWYcRfqb7OfcY1ilJCCjgzEoJ?=
 =?iso-8859-1?Q?vhRttfEeY9FKat99fpEKPh2ynmt595UCRh0GZCKaPVBrdtvVrOjbaBO/aL?=
 =?iso-8859-1?Q?Aeg4S8VycK1QJ294xcopmzKg0BPql78r2XoCN/1Zr/3HNEyt9zic7RYXag?=
 =?iso-8859-1?Q?tn3x5n/gFLV8zuu0b6B3I9ulx2WiZCO8A0WzoX3mglpJXhiRFSZ1HXeLcS?=
 =?iso-8859-1?Q?oFMyh4X4Z9Vm4Iw0PuIDkvGyqxkY?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e6b8d203-b24f-480b-92a8-08de4fa1464f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|14060799003|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?CNhJGpGOWvfZxomPyuI1lqsJKNo9Qhz25nKatPKEp8sNfk6Ei7P94n0dfm?=
 =?iso-8859-1?Q?LWykfz+LSSem2I/iivF1vQjSxyPPJd9SgFjjWSXRVxnHYc2Su0ITgqPODn?=
 =?iso-8859-1?Q?fSIOsP1AQTO9RqYp5p6oGQBdXf++xiNNHfIIEkuSAcfJNNHaAm3m7dsGu0?=
 =?iso-8859-1?Q?P9Uvm8nX7p8bjzBlVjgpI6LWwT51q1rZxZ/CEkRye3W0IwEbcIiaVcm+e8?=
 =?iso-8859-1?Q?Lczc2sMmECctneuR6WyaaCYXJaNQubo6+urth7XTmAtxWKtm25C6i2FV5G?=
 =?iso-8859-1?Q?xhEA1usGWl8Rl3FoUecangr44v2px3onivhI3H6Gsq737WYStAIfwn4ZtX?=
 =?iso-8859-1?Q?kkL3vQpdXYINR+XZFFGoMP6B+M6qL1PMHRIy4fCIe4GBDLV6FHd//q65Kb?=
 =?iso-8859-1?Q?Bs1g5hJaocSJNVYa2z6s5DXAeH329F9DH4k2GyMCR+iNdPFJYoBDhIGd5z?=
 =?iso-8859-1?Q?jeR9c/mSjoSIq3I2f2zEMKmCSxQbegnJZ+9OiEN0Ombzx8bVwtXEONNgM5?=
 =?iso-8859-1?Q?MS2+Kuw2kRaSCG1VIq+uS+mzQXiyWdU9Vk94lZdGckPZjXPLYBMTm0g7Uo?=
 =?iso-8859-1?Q?CEFEly0gFVLNebGewaUrwF63XTsZ3p6ewaE92Yag2vMmZ4Drz0cBF0V4eS?=
 =?iso-8859-1?Q?Dm+iAmCJ4AA7vpnBqwdyDoypqjsVS/bRq5U38i02Yge8OM1mxcf4HT9/M8?=
 =?iso-8859-1?Q?Czf5Y//73SdsNt0XBaEBTARtdnkT2NlcMLz0LBHoM/WDRtE6twMK4PZi72?=
 =?iso-8859-1?Q?MbPKuOfn8PwNZ5CXZsDL9OqqXLcjEIbqoAF8617w+yHfweCKR/cQLVl9Zq?=
 =?iso-8859-1?Q?FyIkTBcxeuNWDGh3O+No8Km+jsMg2lFlw3aJKqG2NYNZ9UgAiJn2M01m/j?=
 =?iso-8859-1?Q?V5Zs7y+JAPn4Hq4fFzFYMFp1+IkZiuAjXuLgOGBIUhd0VyndhaqxkXG5eN?=
 =?iso-8859-1?Q?R5yhkUe2anceFB1I4MsGcrL7cmoK1Ajrj+yjR+pdXvhcSHyMd0ugTUWyvv?=
 =?iso-8859-1?Q?vzK+SYesEtqLoflck/ecejZtNRalLK4iJWYTiYKi4LdnqHK9XnAc3wmAxQ?=
 =?iso-8859-1?Q?UDbJFqYeVD24rprA89QrtmEejpEIQHkgWG1UhxHcFS6gCHn1RAlU+LaDFf?=
 =?iso-8859-1?Q?ZVxW7Of/FGiHqjaOVhh5HUlAI2kuL9jcALabbJKb0pBBSCORjRq1WpO9Nf?=
 =?iso-8859-1?Q?8MJJmXAtBYAABPGEWxZvA//mmS2E4aW6/tE/LNUqM5KumW+7j+nWXfyt83?=
 =?iso-8859-1?Q?HazH7mk4LZRi7YJmDLTHY/WcbJ3A+6DO+Mw5GRjxzAnLwFOrDf4U2wtFRt?=
 =?iso-8859-1?Q?SlA5i5Z0hB1El68bm6tYGIE/QxczU+OOUYJZpEa4x1Ggm0+k03xqJMWvB1?=
 =?iso-8859-1?Q?PIpIDYMpWNWWGy5c4cB57htC8QerdU4y5nEERdKvlsUq5SCDdlgHjobBGV?=
 =?iso-8859-1?Q?uvetEAd15ulHuZkUooao4xSpOKnrkMFE1UwIjwvCWSHXw3a2v5FGgE63Sm?=
 =?iso-8859-1?Q?J/k+nBk9e9SGoLR6y0erwbBofmnUEe+H/qOIeiUAuf+e1S7B/7HZUz7iIu?=
 =?iso-8859-1?Q?HUxMT+BRH94GSA0617RIvxTY41KrKtgRfjxENwEGsY++CIn5cop8EWOrNa?=
 =?iso-8859-1?Q?Fs8AGX2pkjt9U=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(14060799003)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:24.4392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd65c149-e0b6-423c-e2e6-08de4fa16b84
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8264

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 07c12f4a69b41..e7e39117c79e5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -238,6 +238,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1

