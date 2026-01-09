Return-Path: <kvm+bounces-67591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A696FD0B899
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:11:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 816B1310E5D9
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87137365A13;
	Fri,  9 Jan 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DkCkdqDB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DkCkdqDB"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013019.outbound.protection.outlook.com [40.107.159.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE0231280D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978351; cv=fail; b=BNOnGoDWUqSwQikDE8QJ2em5FLdIEYy+hv42zzKDXfUjFkuY4fMUjR0C0J3RjqWtBd79gFv/g3K2PTh/Eb5ulcsw4/NocrL0BPw9OlcrdC2ac1NC4egDiI56exCTSHE+G1tszuRzUPdVkx3IjCBBvjvOeQtqdfW9/BuIYYDGrG8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978351; c=relaxed/simple;
	bh=D0zGmNrbscRPBJJWgF6N9DBIFxBZQ2iii4TIqvFAZWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jc4ZWubwf3I0geT4aTGgdHj67ozPAsk0+FMf9i2SkEUQQcw0kZMv8wIKpRsgycdo2sqF6tG0oB/3yZfHjZGcNY6BfpP04cf/LOda0ucuIArN7FhS5hilk7UStQWlURVJvRs6mW24/6E8GTMc2l9tgklsca7CjRkIuEvL0vhlosg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DkCkdqDB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DkCkdqDB; arc=fail smtp.client-ip=40.107.159.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xmkQXRwFm5K0fyqW+rE3jMUWwhG7BzAt1qqLN1+tA9G1BVDfhpV6yoBiyucbkdnodtp5gnHFxrxiIsGI97kAOgSH/xJFDgU11tNPBil9MfWPGm9AFg6oMu6nZa18/s6pJKOgCp5I6zqNDQlbLw8s9HXFCH0hBSNU1aE9qKuEfkjvs5r255drqYNhhg3nICt3b7qAyF1JmNNmyva0Irm5+DMBNH6+Yccq7YaQc0hegsqK7fmov9W9dNAl/LyU4RmxKR7kfgH/jHpNC03s0exZY8Bvp3JgzcxX5ylNAQId0kU6IR5ph7J6xvvQ9Eq+YHftshbzz+gsICMQVUtg1R4JMw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t//un51X3IsCha298k9GPsb5m7OXhFbDXZG5TDtKdNA=;
 b=T165/m/g6hCYC1AeQp0RcdBG73RA3Kr99aOPIM39iJgBTjz0vC6XuzOd88i3ivKEFwkc1xbiFbp56EgULwj1NDdWo8hZ6vPETs/bVqx85RNrFjXQEJB3bqR4P38YmOwGhWKs6XnIRPjSYp2kecjgwbY/xb24hf1MFh2zMXl2mNSyBEnJiJPvsv+bVmWh3vXAVY6FXydq056iMqHsAMdfMJF6mofqqYTBl7uyYOKY/RDdwImP3wM6/KpK7e6Nhiwq0SIeV7kkLaf2ZtkH0d5pswWH39d4K6XGPlJ1uVlUyAEWoEkKkk5t7mC4pTvfCEs1bsGJdddpSsYdlfYd5jo6yw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t//un51X3IsCha298k9GPsb5m7OXhFbDXZG5TDtKdNA=;
 b=DkCkdqDBIOixIq8DYaIEVZmLvC2ZJ+aP1Rssyhs2QZQl7eRltUwcWuWrV2fsFdSPAWsEstTkW7sSNctkUHlnQvM43ciWYURb7hg6fnrgspm40trPqnWjDKGI7kc0kpVpTpYrCUoIbFRlP+uKfyWglwHIsbzk90Q5DFIPW3uY0zo=
Received: from DB9PR01CA0025.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::30) by PAXPR08MB7492.eurprd08.prod.outlook.com
 (2603:10a6:102:2b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:45 +0000
Received: from DU2PEPF00028D07.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::47) by DB9PR01CA0025.outlook.office365.com
 (2603:10a6:10:1d8::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D07.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pl2hWbMGDoudV2Lohtt+2GAcGVpigTe2sHZuq0C16lBzSOh2ZUD779djVVhLxTmj6VEDfBoeCyN00NQsXGt/H4/W1Sjg4BDywPUdehEgI9cGKi0Px6+OEj0UdO0xzfzk4oRymKLBrhyEYI+T/KaVhvWnKeqtzWgVzu7FwfFNX8lzH86lklsD+KcNULOMyfqPZAAh/DElF0rMhfSxBaUo8FkE3GSn2lIZmjsIWV8z1S2V4IIw9g/13zY2dN/fkELFRe3O6phiAzehGCRyZBDoAdkAmpXllW87WWnT1KfWxFTqBVPgDmdh8MpnKoF4kuaPTd28ciUi+e0YnwDm3lY2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t//un51X3IsCha298k9GPsb5m7OXhFbDXZG5TDtKdNA=;
 b=d9u39kcGybNYdRgsWSycsEF1UVz6aVTaLbwTqNQ8aNBCrEjhOwra8uoBnMvyUV98jdqqbjCA37vEtMIODyTJaFlLjO9K8QOSF0jj5n+0tpsT1IEOX+kF7nx3BiC86ytipmg2T6Vq5r1teLGy04rVo9MqLK6X5YxkAxBEDD4kHoDSeusUoChfcDEzjEWDkQeJaz06WnZp//aWCzfJOTzJsrI5jVHm9YSFgUVs+083yBmm/Fg1Uta58k+ol1fTvzeB8lkDluQsL1EqsZhK4OkC12fNUrU7943UbXdfnzM4w8znjfVooLAdyyUkwigKw2Ha3gCTzBAUQoIo5835ow2kog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t//un51X3IsCha298k9GPsb5m7OXhFbDXZG5TDtKdNA=;
 b=DkCkdqDBIOixIq8DYaIEVZmLvC2ZJ+aP1Rssyhs2QZQl7eRltUwcWuWrV2fsFdSPAWsEstTkW7sSNctkUHlnQvM43ciWYURb7hg6fnrgspm40trPqnWjDKGI7kc0kpVpTpYrCUoIbFRlP+uKfyWglwHIsbzk90Q5DFIPW3uY0zo=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:41 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:41 +0000
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
Subject: [PATCH v3 07/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v3 07/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHcgYoLykeocUyHoEW71v05Rsoz4g==
Date: Fri, 9 Jan 2026 17:04:41 +0000
Message-ID: <20260109170400.1585048-8-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DU2PEPF00028D07:EE_|PAXPR08MB7492:EE_
X-MS-Office365-Filtering-Correlation-Id: d45272f5-ae40-499f-c164-08de4fa15383
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?IMpebqpwUVa9Qcr+5Y2KF+7namffu4sHb0FQalQJwOeL/kfVZHz90g85Q0?=
 =?iso-8859-1?Q?ezO1P78ymOLhwZ2PPAB0JuifdMAkMB1Tq4OVbg550Imv4ivOo1/Sccv3ct?=
 =?iso-8859-1?Q?ftwrk0h+8Gx2KxA/OYzq6Z8yMdtxYo//qs2a+2BtkgOPlc8XG63oWANuB8?=
 =?iso-8859-1?Q?q62sId/ClR70gVsrPJbhNFaY5sExUSxL4FlS1m5O4Dn17s93Mc+IdiCLd2?=
 =?iso-8859-1?Q?SUaTTjaAK1AXApT0N5z00vmEYFzYBG6IhSzFyqOLa2eIwoP47o6UJws29e?=
 =?iso-8859-1?Q?oNEBH/wwGgzTIprzG1jAdadgaDxpAhVA/WZzP2nvFSo21AV+7817xmEuJM?=
 =?iso-8859-1?Q?KF9J2DqoK7S/+sndPTex8xPPXCuaiS9J6gfRMmXcsjVvl8JxmlTj+UqIax?=
 =?iso-8859-1?Q?v4q4pfYHCmL9ZqIP5WKvaj4Vc6QVsjPvzfKXcUEPIRUpJsJMoQy99xQzoT?=
 =?iso-8859-1?Q?53r0IcAPTCTmmNm/ZhQIYuOgM2zs+me8Abkcn5ljPJIjqHKwovdQoBK25t?=
 =?iso-8859-1?Q?+NU3EciwA7A1HhqxfOUofSSCwvkxMhz+kQy8uPAm+UGcbfKid48CSUwHXI?=
 =?iso-8859-1?Q?htp2ez1Xze2uhqYqWIPr0QNSH9ow2OW117NmMboDGrdVuHJcfgzEFu3FkH?=
 =?iso-8859-1?Q?8M+zvYYzuohrvgpOY7uhx5w/hwLW8posQHW9vTkDAoL2gp3+PBIBOzDYeB?=
 =?iso-8859-1?Q?WJh2VLb2DMdp59yCoS4w6xYL78DtxiBdTQZLEYSsfEyQojHj1vgLdncGnN?=
 =?iso-8859-1?Q?m9AET6k6Yao5Oewz8pKlhL3ktItOZ7deAf96MHgh0/agMRZvq+FJq5wS5c?=
 =?iso-8859-1?Q?WsOItdeLUGUSmkPi9OnyVAAy3Aw9E/Y+bzHPdWXc4uy2GNyL8PB44XlVUR?=
 =?iso-8859-1?Q?I+RVxiH0eLPo22qwQj5FI/EVSei3JwJcwM75qj8prUGRp4r2yOsapihJdK?=
 =?iso-8859-1?Q?ft6bA9Cec2XpmWO6bGhwLkUudIbHsMcrcm6x9IFzDroZCETAFA8vy4KCKZ?=
 =?iso-8859-1?Q?IASbxVkU7oLaHfyeDcjJS0+8ZYOW/JrsqLnKEjf5aawbyr8zVL3dohe8/k?=
 =?iso-8859-1?Q?SL72bsPNjDMEo8x2IKLdcbJSqmGsFxq6rcseD1P1QvJ6cU+pvckO2ySh9T?=
 =?iso-8859-1?Q?zIEsewrS8fOoNHlcrjBRxfmBP2sJwP1ULQOod8AIiJLAC3+gqSvPfQPEdM?=
 =?iso-8859-1?Q?5g+3gV6UjHQjvusV/aheVQgOiU745S7yM53Kn8p49dhE7E/SnU06y13SFi?=
 =?iso-8859-1?Q?YydT+Ad4FcMFZaqK0K23cuBYsiilZzqxncN0otJlGLegtta1becp1YGr6y?=
 =?iso-8859-1?Q?ffcRJThh7uTYNjWN8ZhXdcrPeCUCPYOzknw6K8jkB+k13N7KU8aKi/quPT?=
 =?iso-8859-1?Q?zTaL1d5iZO0+36ufgYIFclOEMLvOVp9IkP9A9v895jQ3HH9We2oW0Z79nb?=
 =?iso-8859-1?Q?agLanicT3Cn8b6f92+qcEM1scLyPPq8/uKBrlj4ojLI8Mn/H+p7kaevGX8?=
 =?iso-8859-1?Q?gOm5QX0f5ggPFhjtAB4bKGsT0js0KrgoNEnTJgXHPL/Dnn0YHftVVVViIs?=
 =?iso-8859-1?Q?zAaVjipa6ZsJcAGDxcqpTKV2LiUQ?=
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
 DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	df3aa47e-4afc-449a-b78d-08de4fa12e0c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?EjcAwe7LMsvOK7lAld5l37K799jgo6xwaYtj4/xi4Pb2thvt4t7D7TIhoM?=
 =?iso-8859-1?Q?qOXplWKlKP5QDQxzoRUjHAwWZszj2x0yOgy8dmDIAsyL9VHHOA03slcu2m?=
 =?iso-8859-1?Q?xWXVgUuaya/2HG0fvZao1vhZuiA3EyfO+8pwPyfEWonEtuBdAhqz0vYLnN?=
 =?iso-8859-1?Q?9DmHBYQKnlMDaN3QyJttR0KDD4VbZZriINDvtY5eQg7ddIWHVDzGhfmhiX?=
 =?iso-8859-1?Q?Ki+Cimj/ORS/d63t66o41P8f47B9Znm3ccPDJX2PnyiBsSHVW2Xt0eOjQp?=
 =?iso-8859-1?Q?/e0sDhp5xPHV6ewSW344pM6ZueRi521TitCYDRtLwF+o8r4CFmAV7qOtZB?=
 =?iso-8859-1?Q?dBs9GJQHT17BYtkpy7HRKb9T7AJYDOLREBH5qtfXTBym/a9XncodtICirx?=
 =?iso-8859-1?Q?K2UWPkM6i9wwa+7fyHVEoqNR6znf8+QDqN2dDgAjLsa7wSsiwjnuaYRv8w?=
 =?iso-8859-1?Q?5WLxJqx3mMUkKnZlJzW/N+X6IVyd9sFp9KWhWLf9Vr/G6lXZye/cqJLonR?=
 =?iso-8859-1?Q?aFzl8Imhx5q8/rMvOHOmscaChRLbn7VJU3tnMD2KMYAVPGF6XcyFFuOc7k?=
 =?iso-8859-1?Q?LFLNuEzgk+iCoL5hIWVa90Z4VQsRGmjEzzxyrjPphMknzxE03pLkap8JUV?=
 =?iso-8859-1?Q?LcsBI3Q5AETsFgwewzmdIsOsxXRgRzHfq+nAj/TdIxkjYhWOwPU2TDgE8s?=
 =?iso-8859-1?Q?2pJ14KOF8qkvYpibHldTLqkhzgftp9FdS2qk1f8hbPArsBWOQymPOZgfCk?=
 =?iso-8859-1?Q?v5/FReON030kor8fWd/HZnFzjQ2cLVAFAwRORchUrjaxb51T2xilvcOXcX?=
 =?iso-8859-1?Q?pgn8NiDSnwxJkhVXF4S308gkijhx5TbJoYpU6PzP9/IX7RWWCUgolF7Zfd?=
 =?iso-8859-1?Q?xEHiupex8GQ4W0ht4b2P770nU1uyVYOayd/uxJalQYecHtSbMOBzr47H6y?=
 =?iso-8859-1?Q?atwESDdangJrvLeHpVQQyFasx0R/tuv0U+d88aOjsfjYAB3b6KxTJvvL/1?=
 =?iso-8859-1?Q?ZQk/SPj+++W938psXIFZQgZfr+xZnvNDvGs7uhMRXgi9HvoK62Fsx4bYSb?=
 =?iso-8859-1?Q?NbdQCsPWu49yfPZsXGb4lk8SfVUQ2SMPLu3pqAXhgKtAscVVsBU33xrhIA?=
 =?iso-8859-1?Q?T0ues0Sjfi4nLedbJXY53mfnx4upR2TVJ9q5KC9UTCYfaSciSvaJVWLshU?=
 =?iso-8859-1?Q?t/dlSNzn4P1rOwAmLSzuPfBL5IIK4UXh/WqT4YCYtVM5eZeGYs0U+F/xbe?=
 =?iso-8859-1?Q?ic9CwEMvzSLyKFnfmpdkFn5YycCTkafyhueLZ6TNZpaXeO45YgEscl+MHz?=
 =?iso-8859-1?Q?ijFEVfgL5/KPEpymycZTbPTXn/M9MmhMUGj5XIlIZmxANFPyI8igdxo2az?=
 =?iso-8859-1?Q?9t0QnxqNBrGp5iBL1wDdK8sEvDDZQvR1QG6MZqtrY2tbwuytdSLIbmzdjl?=
 =?iso-8859-1?Q?OqpqAumQNrahHOJc9tvchoGMYOTvgkjywcUadE/SplGH7VBQJYOON0K7p7?=
 =?iso-8859-1?Q?uyre4LNtEChUupke9qmR9ZuVMRdqdae22tMVtfjGd1BMvu1pV+Qy1d4dK7?=
 =?iso-8859-1?Q?o4aQLmRL9wS46g4gapTn4U/yBFUoBHzR/aoXujnK2T4nHucASwJdY3HXsf?=
 =?iso-8859-1?Q?5rtU1vunkZZBQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:44.1597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d45272f5-ae40-499f-c164-08de4fa15383
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D07.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7492

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507d..f7dabbf17e1a7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index dddb781b0507d..f7dabbf17e1a7 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

