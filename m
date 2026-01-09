Return-Path: <kvm+bounces-67612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BAA2D0B854
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:09:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D2527303D5DC
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD15C366547;
	Fri,  9 Jan 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iXQmWHcp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iXQmWHcp"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010031.outbound.protection.outlook.com [52.101.69.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A843368261
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978361; cv=fail; b=XnANSG1rX/bnq3MB6Xf5F7bv8RTJIOLFPPuZ/Z/djrFBcDvPIo5w+b4REM040Rl7TDfSReqnTiuXvliIakkxMgwErbCSirTx0K/k4otpfNnC/BDN0YXtXUK8EiDVZLkuMs/i+uYrqibEy4sTUnUWbIEfeK4+cdRnknCyLhMfzKg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978361; c=relaxed/simple;
	bh=qkxUKR8UpZkfeEpUwQRbb73UTLBL2QY3jYsow5Bn1zY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JbkNmS2wLhvfelFFpDQo4clbvTI+UEjNvj6PEocX//FC5KQcPbFQ0ZaSq2p7cT7XZkPC0s7DTLhEl3AJpEPK4kIJ5tnXovOjIbphDidLcfvbwicxvB8cvS9QeRviWGmWTb5WwwyHIkpr8k3uhCwA+XJRzjFDTWum2wg+ta/TKak=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iXQmWHcp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iXQmWHcp; arc=fail smtp.client-ip=52.101.69.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=olR6ywaHDjEZAALRZBwQB3YGl2fJkOblu8IZXAbcKgd4161tPAzm6Jn5ME+3VXUBQnTcAO4XrD2H4OQLh5mPwinqaQsCyqav9T6Ou1Egv4c0KquGEbJBtlProA0wxO70umMG8BzQttnWdIm3l0Q+zSp56/MDuUA1OvGlpt7YuWS5A4RFkJSX8RRRDjQDsPJQkflIMJUELW8uTq9beV9IB9kS9H5j3ckzNq7IAfzxdS4zcQxPMeDMo7Sq1xVv6T+Wt/NgeDqbP9nYuTVzKa5mHVFd/RApoNAc2mlPJCDxQLrcuvLySusr9d3s5V0wq6rplOLfLGxNmxupJjPHtp+3Dg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k22isQeR0llB3q+eEuo4aDH/UHyG67tga6kUxABFj/g=;
 b=xrkUA6pLyRqvzAYuPySzTkY14OoOhJs1fFal1bNeUaj+RH0gTfiqZsbM2Ywfd8lfomHmcL1UDTDdsLPCRjFjCzxqpFN+//tsad2hT6ia5e9ntE0ctaGA6DhkZiKS45JmKzC8/V0jCQXBWvXv8z7N6Ifm7cF6NPWYpP59JQW0PvBKMM5+Kemgyn+CsWBshtLH+AohPhsNjKTGlRIEpmP6KlCfkb2PDDMCouZROqKHcvHQR6GeczDarbt0iSQm6AenFbdSQDr1tI6qymngva/HvtJFHaHFU8RXlCQGBas3cuRS2EGbddpGx513gsTqQFUs8pRHVv9rmxCJ5tzPicWnlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k22isQeR0llB3q+eEuo4aDH/UHyG67tga6kUxABFj/g=;
 b=iXQmWHcpPoxMu0zZY8cECWz7GLaaKRLIX0QTgK1T5RMig8XAnDkuZoHECt9faCMCz0h6mAhqzUFC8O8ywqmXLYE0E0/JaOTTSnRFOOm+eQNYcUVlpjYcQucY1USLeix3LpP8VcIzekjUw4/+OckmsSCaKHK0312vwMeB8Eha/GY=
Received: from DU7PR01CA0020.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::25) by AS8PR08MB8947.eurprd08.prod.outlook.com
 (2603:10a6:20b:5b3::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:53 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:10:50f:cafe::d7) by DU7PR01CA0020.outlook.office365.com
 (2603:10a6:10:50f::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:06:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fd+XLdUyqgOIOdUoddhmExRKN+TY6eZgCWuvS2r4Fh0CyY8EPIK3My/+XQhC5wn+44JbGfPPtLja3lkFLWlnaWakIOR+U+7dtqT2zrfABo/HpccuLhzsCHMiY/rmitnYC39mNsDjKsU34xSMXTfqKFj8zpl/k9RlC3+1ztcXV8ruNwUH8hbQFhoL0emxMqo7IDkbEPWzxTYWuH7eF3iZ6J9/03gRvsgS1XIQXpl4Ms0Sf4Nfq1XrKc1wJhzTnzkLhFFTXzZ1CKSb33k8QbBVNNsU94jNQkYv2etvAiXl6SMRS2F6aI0F9H48spv4fl+78o2XXf5d1dOuDd9sk5vYaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k22isQeR0llB3q+eEuo4aDH/UHyG67tga6kUxABFj/g=;
 b=pw3SaGG+IEFfDhDQE+5v9tgRagqgz4D+VKeU2L3eLwW/2JfBabnXL9VR+g7nXNoWDSyD7tpjT8F6veGD1ANvR9ku/u216MHaO6uZDAU9IDPcFt3/mwJ23+gd4GLFis75R7WE4UnlpRT0XgUVuoVsYg9so0Aq5bF1BTJZbiQIr4CM7g+hE+DIfcTSehlXfsm4K183D7dygmgfH69q/vxz5ZTfYa2z7o71nSlE08yd3uRgItgbTwurjIUpX7ihSROlO++wOXOYNPhmRktNV6UcsD/1LeRKddurjGyFta6H57+Kg4FKEYw5HKhr8/pD5JpcuTLBz2DGarKB/bHXXbY4MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k22isQeR0llB3q+eEuo4aDH/UHyG67tga6kUxABFj/g=;
 b=iXQmWHcpPoxMu0zZY8cECWz7GLaaKRLIX0QTgK1T5RMig8XAnDkuZoHECt9faCMCz0h6mAhqzUFC8O8ywqmXLYE0E0/JaOTTSnRFOOm+eQNYcUVlpjYcQucY1USLeix3LpP8VcIzekjUw4/+OckmsSCaKHK0312vwMeB8Eha/GY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:51 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:51 +0000
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
Subject: [PATCH v3 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v3 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHcgYoPRISdyMo9806I0JOgzmf/kg==
Date: Fri, 9 Jan 2026 17:04:48 +0000
Message-ID: <20260109170400.1585048-30-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB1PEPF000509F6:EE_|AS8PR08MB8947:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ddf2c60-d02d-4132-6c22-08de4fa15916
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?tT5A4Onhj87AaZQ5oIKBLzNXf8d8cF+TZWvdB65Mgjb+/DMu95JIvtYLIA?=
 =?iso-8859-1?Q?zMsPblW5vZNz+U0snj6EvEYNF8I42Jg+bOAVMfzHaQ6CcmFpCt38HHykEc?=
 =?iso-8859-1?Q?7mvxQf9nFJR5BUh0Z7cCDdWnRgl5F4mWs6mVNYc58b2lZI+kmwcKNBxHHK?=
 =?iso-8859-1?Q?TySOMugaMp7XPtFa8M6oSUh5klEBUqpH/e5BlCJuPQdrOWItn2rjPI2SAq?=
 =?iso-8859-1?Q?C5yASwQPwGm5TUzyNvVn9WNk2ZkjYOaGUu5ndNqaF0KoAYVY7Ix2imWRiN?=
 =?iso-8859-1?Q?smAcPLv0+A82eg/RC0APQbZho+ptzH7L/Wi0cNSwfwiMGI9U7CbPIhe5by?=
 =?iso-8859-1?Q?WeYi/20pNd8w/sbyZKTsfPpxqdMfA6udvauyLhVuuvHpHyGka31QSaaXnX?=
 =?iso-8859-1?Q?6FWOpZuma92kU33fEJOK6qmogvtQnJ2dJpUuXqLXcDguxkJI8h6jBKTqxS?=
 =?iso-8859-1?Q?6kMz21WUGTiD3ugPKYxw0L7tPDcglx2GMOhKpWY8MKM2IewjiIwq3XGcEu?=
 =?iso-8859-1?Q?at+1ESMr2Dip+6ZHJlr6j85hgcIQy4IqC3jOOVGQaZfUlCE5CCAf/yDwZK?=
 =?iso-8859-1?Q?OD7J93Zxb8bjH52kD5xNbJUDE7qw5G/kXryBnmR2jnjzRXLiySkKXU7bHt?=
 =?iso-8859-1?Q?w1HlQFMsG1gpNmQX/lR02tjy7UqOjE1qBa+r9VZ5HXQnLRHj0d/q4/cZ8F?=
 =?iso-8859-1?Q?gcAP+eK40KOhUbElgOLneEPmNOM1p0Tgpw9XnQ0wxQMRkhPBmzwDkTKIjU?=
 =?iso-8859-1?Q?E2dGE08goDNehu1xzK66pUHEznA7SNp8CY1NiT8pXqK2R1BbrgdBeIzPOF?=
 =?iso-8859-1?Q?x3RGgixtRtvICHSmo8pfevHYQRGLMgvoNGDR01cPsBaqaoMljBWcnNr7Qt?=
 =?iso-8859-1?Q?p2wcTrKhFS5IloPW9Lkmc2YEOKiPMyaDi9tveNqLYeyJXenCuKtTrPvAEb?=
 =?iso-8859-1?Q?PKz5GZO9V+/Sibb0SrQEdm7waXzNEsPvA6pHMiT4GqJnCNbM9lh+KuazD+?=
 =?iso-8859-1?Q?n0o9TjFDN3iIurTtTldkR6hnTOylN0TFC44NMuOlTyHi+GtgCedYkKJZPb?=
 =?iso-8859-1?Q?w/DY3Y34MsDBIVUXVI54gISr8GVcAHTAzbwrx3k3qSekdQF9Q1jG8j7eT3?=
 =?iso-8859-1?Q?+OQl1wnAUDihmFUnOiHYmKF+EPRF7kHc0cqVJ8Y7pvbNWtHKUY5UIA5tjX?=
 =?iso-8859-1?Q?2KeiiVjekvKkRT6WsRaYhiAXvb6nPuWcXEGRta8R/FSrbSdih9Q8j2xUBV?=
 =?iso-8859-1?Q?6A8Gn5Sry3XoLDeMruLrDPWwJoKq7LQj/SiLqsvaJEMewM+XNQkDFBZ4jr?=
 =?iso-8859-1?Q?m3t3MUdpY1l/mKkwQ81z62IJvOuEt7FFSA6AsD/cfzsg4itZrgtt1SKMQ6?=
 =?iso-8859-1?Q?nceZPrt+4ATJUxzEF0tRYiBqoKI50T7AR641Otn8XoBd7aDITnvb51MgJw?=
 =?iso-8859-1?Q?jH6WxHlC+cX0eiKEMo6ksSaKvqmvM/eZ9icX5AGAjxpHuHe8fBjIqFXFaL?=
 =?iso-8859-1?Q?CjrNYEL6qvqiggSm0R+qaJnmk/Ju2hKJqUBkc1xQDUBJw+abZpCtHizd14?=
 =?iso-8859-1?Q?13j4iN2VXnN810qNR98TGxjqQygM?=
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
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7581eece-5d35-4523-baca-08de4fa133e5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|14060799003|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?9kiHx8DZDmoczHovgvU+ZvIyK3Pjj/eiiW7ean/xsxUZsWnv3lteQ/VBFa?=
 =?iso-8859-1?Q?aZ4xNlbsGjyJiiWUQjs1Z8R1MTZU4KiCiRhczcxHQ2Rdu4Lc4MD9gbq0bg?=
 =?iso-8859-1?Q?ldUI+DNpZ5jCI1j5ITGc10uhAWz7/06VtFkbth/gG/cJAhIoFlPMkS/Vzw?=
 =?iso-8859-1?Q?45yE5k4ad6dkdordSHYJJ3kQEIRvn0zbTsd3I/ujcLW/mAt74gNTqcpzaH?=
 =?iso-8859-1?Q?iEOUh++PHDkrKZ5v1r1T7Z+c1gA+QCeXPBDpu/L/Gq+EQgysSLM/r/kg2B?=
 =?iso-8859-1?Q?diffK0xJ4qeEVe0Aq55CEouiMWYH6foKUijXQfAjjQQarARJ1F6osIlk6O?=
 =?iso-8859-1?Q?GFdL/t9c659QIvRBvbQMpht0VWiLZ53nfzp/JT86LiCNG1j3THXtLpM1ZW?=
 =?iso-8859-1?Q?4oM5QqMDFnvAo0h88d0GZSca9vmq6//BmhxBHHNYeLwFAf/p5ysdDmVuul?=
 =?iso-8859-1?Q?tcj+NV6u6Tflc/BFmX1nPP/6fezUmg5lz2GmK6jLej3DWM+A72/exBEeAL?=
 =?iso-8859-1?Q?llNuwONosZbreyJBLBxsWaTXkQugTs8d20PeVg3rbIruexEZJEEJvo0cec?=
 =?iso-8859-1?Q?JSr9CrsD4DJCr7hlgG1pTcmoi19t4I9+Dq0DQ2LRQPx1woLFfV1zZw51bS?=
 =?iso-8859-1?Q?dQ+p+R/fJiLTocqf8rVTLuFrKN4mc9vwrxRoVgw13CZpye+mrzHduN6aqi?=
 =?iso-8859-1?Q?yxwFKmK9Uoz1yxKG/CNgOPEhBUupaEjKglZKJ4uq1aFIP72OD4GycCoZ0C?=
 =?iso-8859-1?Q?aQVEcsOLpNG0Tp1Afask4v39H4ZdSosghMWiadEdRMZRnmPBNVLi3LaD7h?=
 =?iso-8859-1?Q?9KkqR6w2d6jFO+/6ubFbdWi9d9fJb7uP69/ly5229wD8eB7eFoDEMqouoX?=
 =?iso-8859-1?Q?j3nIbIguYTx+xQ9990dSB+yJWo9OJLWiN8j8bT8x8Hl7ES2LxLDeQ0DmyR?=
 =?iso-8859-1?Q?p82NJSEEm6sIwRrY/tdB7Puwircj8ZDG+q9d/uGqlHCyg+8bEa0yM7bG2l?=
 =?iso-8859-1?Q?O7dE5FzjQQeRt6G6Hpaz96+758eOCllHAqXOad+wUW3eAqnpEaJNwijZUD?=
 =?iso-8859-1?Q?pXa6ZsufFyLpJjoVPCUTETJknk93BIcZL9ovFte9erbvc7wa/643D0Wzsi?=
 =?iso-8859-1?Q?SKW5+V6yoYNXrkoY/wfxNcxGKMtcX0zTYrhR8HU3/aqBLR3e5VijBDjknt?=
 =?iso-8859-1?Q?EbOjxhvhJ2X7ar5NuZe7oWIruTJUjeqS+6aBYHWBO5FgNLKOHjNeOjwxPL?=
 =?iso-8859-1?Q?BTTUmJe/PJwW0rqxDNWSY2Q9BXeAR1UZyadNgiYaBvxfmEXxZ0dTfAOLM5?=
 =?iso-8859-1?Q?Nxdlc+RwU4xaMz3Iu6o1uOTUdIG2rCfPFhEootkfm9Il6dGrVU8OKVRXnq?=
 =?iso-8859-1?Q?GvtPgWMSNOoETLPKxN+TsHxZ46A/M24oUOOthGVc2eZbaKzfJfa+O4YRM3?=
 =?iso-8859-1?Q?hSONEzycgSnGlr9rvFDY80GQnLQNPGDoNxY7gnBNxK9p6UDGcXqNuOXVwC?=
 =?iso-8859-1?Q?ywOClSDrw/k572Vy67H5f8d3dFx7Jgs2VWIpnfS/VaXtqVePNDJYGoMguT?=
 =?iso-8859-1?Q?RZLGxX7kh/DVNFF6BmR4fMBmsPAlIc0b+Gitxzd5fdI84oLq8Ek+S+hjoq?=
 =?iso-8859-1?Q?Dd+tfriR+aMAU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(14060799003)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:53.5147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddf2c60-d02d-4132-6c22-08de4fa15916
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8947

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e722..66404d48405e7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1547,6 +1547,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1

