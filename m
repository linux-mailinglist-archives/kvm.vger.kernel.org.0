Return-Path: <kvm+bounces-68368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2BBD3843C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 516E430A28EB
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACF63A0B0F;
	Fri, 16 Jan 2026 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LM46Vy6w";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LM46Vy6w"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010008.outbound.protection.outlook.com [52.101.69.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9113346FAD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588044; cv=fail; b=UbPwH9QPTNC55/Fm9tZbyHE+/dMMc+5q3tiAfj3Vyw3Z8fRRpt4bZdBPNFvgTOATWC2uF/Hc8KQvKbIUV0z3dUbr07C8apSrOuYj0D2N4WQWtetSrZIG0rf3bSg+GKtrvDeIhM/vFrLh2FObWUyJGnMjK/57YFyyG5EF/n91+j8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588044; c=relaxed/simple;
	bh=bVRJBjP45prrUkn+60gWgdfVA+Oa9ZEdQdVYasNUPUU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kmUiASqtm6u3ws+exFCxnm0rZ8FGAk23P6tdtNr1v9+009TZ4KhL8334da5Bw4MyV3KSyVcUJTO9Tl2RvH6e1MVMDPmQpZDw/pfrYNSbuLSRbImeddeyRFbVt0TK+hvmqY3k83w87fMa7ukaTEcvSD1vUExdBcDKNyzamGeTyas=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LM46Vy6w; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LM46Vy6w; arc=fail smtp.client-ip=52.101.69.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TsB0gDji2HUD2Epf/KWy0t7iWR/3m2fFK7pDapYyQZaz69kETsBt4vsg1I5kQKewYQB2vVI0Jow5rVL0iwRNjYqd6NxFrplCzBXavXeG6n02ck8RZxUb7EFKE6n4UWxtXFGpJijyS3IOd6fy/qyp4M/Mh4ORHN1eOMsOVmSenUB4xWlxYzJ6reurHz8erPO3xAu53JS62ibSA8bwTxQzfQJdF50jFxceeWP281jfR51Nnaa1bsmM47scbdWKDyQOl78bVeOOlhYNQhYns2AAjvL9I0QlPMTS5xgLU9ox1xKGqTqpm8dmRDz3k3OwREO7kH6cBtoMIO1qfigJMK3Z+Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjxaXvYKrt+rn7MPG4d+k5cL+5c/kXb+FIANZrsBUtw=;
 b=m5wwJNnW4p0YDMFx1sBCDz0W8Whgb8BNiCOV8e9V08HqQMc55JZoPavp3vMt8w3+/rRW4i5/T1yR2dTFZ/8nWjl2DNg+b4qics1R/uYEvFv3XCKsLDHT1AXKDxmthLvc3cU4r+tgbHYHM0XwRvuqiuBWUdjYTV0Dy3H28DyJeVcIVufku+xxnn3ffeYFJ2LbUVwXQv/OigRtoFOwey551urJMLxqjpUUB+D9ktdI/rpAUC+EyFucyEb5zHMCCYS1SQdPuRpTNyrhPg5uXsXq6T2LdPv5ny9yfiKa03e1rZxu2vxqs3iKex25HZriok3xvGgH6S4B/H5IKJh5SNLa8w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjxaXvYKrt+rn7MPG4d+k5cL+5c/kXb+FIANZrsBUtw=;
 b=LM46Vy6w9pyi7mnXp/HLheB8wVvXXkhXV/3ylY6mmFyDiVq1ZPynOOFQECIdSh/9jAtaKGeLip/Fy2dW6WIOSlPE6xNm64vgZUBDiCckMXlIK2OlbN8SDsYDKocYjJHH3POiOKGXiX4L9nvzXnYeiEp+wvB86T/B9ycwuQhhpko=
Received: from DU7P251CA0003.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:551::33)
 by PAWPR08MB8814.eurprd08.prod.outlook.com (2603:10a6:102:336::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:27:16 +0000
Received: from DB5PEPF00014B96.eurprd02.prod.outlook.com
 (2603:10a6:10:551:cafe::bf) by DU7P251CA0003.outlook.office365.com
 (2603:10a6:10:551::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 18:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B96.mail.protection.outlook.com (10.167.8.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4CPeGgwm2T4ImBs4abmxpC090mCJpgD5hE+62+DVo/dlChE5c6bs4DY89LqYkPNYUmHb76mgn0I/tFls2EgkDH+/PH6J0quZzxxtRf7rcQ9aa/h3+9W1s9yhA1/MAqv+Tgu3OE3fgickvIb1bI2iF+/vTQQWolzIc7JNJZmpucLjQIf6jQKCAkj0Yucfl1heG/LQiYwlfKcBF3ceOQmTMgKA7PaVugMBYTWsarrE08fKnjoUPLeCH094nX8u6TCUlFEznlxBO9ZWIUTVnlQf17I3UUAzFbTgKDxoEJwgezczUrb6XqwclqSqrhXHwac8+ktsCAVmQmt7vuUKwu4LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjxaXvYKrt+rn7MPG4d+k5cL+5c/kXb+FIANZrsBUtw=;
 b=Wj/cqoyKG39PSygTptzMbQS9oO3FNjB7VHeSOETDuPx1h4iY+UGDAt0RyuOwiOEzUluIa73Q6TdsrBJgErBbtdWN0qry5LGVaoa7Q8NtL08M4b+mQMOS0PokxtqPv5drzdmQXSae9OOFragkmBuCrYxOgomYYJcAoRBSKN8dMbWbc0e77mKv80D5bD9tUQ8ki4stBuK1mLz5lEHwfrmWKiVZ7u9lT4kRhxVKfrnc1WXPSO68hfKLsteZE6B8U4rnTIhSMZDxpojVZO1443GRvya4lXJ4vwsoKCaZtzdm88QKHU5z0lyvN6xzSBaN39NH+4P7V12oLm2FH08AVa2FVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjxaXvYKrt+rn7MPG4d+k5cL+5c/kXb+FIANZrsBUtw=;
 b=LM46Vy6w9pyi7mnXp/HLheB8wVvXXkhXV/3ylY6mmFyDiVq1ZPynOOFQECIdSh/9jAtaKGeLip/Fy2dW6WIOSlPE6xNm64vgZUBDiCckMXlIK2OlbN8SDsYDKocYjJHH3POiOKGXiX4L9nvzXnYeiEp+wvB86T/B9ycwuQhhpko=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:12 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:12 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 01/17] Sync kernel UAPI headers with v6.19-rc5 with
 WIP KVM GICv5 PPI support
Thread-Topic: [PATCH kvmtool v2 01/17] Sync kernel UAPI headers with v6.19-rc5
 with WIP KVM GICv5 PPI support
Thread-Index: AQHchxWXvVV/sEf8QEWV51gkd5+Nfg==
Date: Fri, 16 Jan 2026 18:26:12 +0000
Message-ID: <20260116182606.61856-2-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|DB5PEPF00014B96:EE_|PAWPR08MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: 562fa468-e8c1-441b-c61a-08de552ce080
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?px1j+oe2IoHbEPEKtGLGefjIufQPw4Hy69sxaBhxHkzswxzjh6JD0n0UAN?=
 =?iso-8859-1?Q?Rn1iKy/WFYepDvJ/jU2oUM0NDyjK3tEAFWBXEjmEPJpCnG7tQ3y6GDWngN?=
 =?iso-8859-1?Q?uB4Q0cZs/m3qp6K5Lj+woPN0belskGneuJhPIKRKLpQUAu3AhPS9ZdPsX3?=
 =?iso-8859-1?Q?9ynsi4rF6ngJxFz21eFU7Ze3EaVNxzf37Z3KHcOjq/By9AlyLVwC/SHeXn?=
 =?iso-8859-1?Q?84eUsK9vXjrg1/FVwTYDPF59DRtK69XN/ZF7mrUOwPE6wHB3i/Eh0paQxH?=
 =?iso-8859-1?Q?z+x2Nd7hj2JH3GN9+qzcISBuhk80p1xSogmhZL/LqVGJe7TPa3oDbntsyi?=
 =?iso-8859-1?Q?NtjnvUkmwVWmadFuaLxUriQZRDiw9JN5qLycVz2YvPljOQ3naN1czxsTaN?=
 =?iso-8859-1?Q?BOggTxSTGFbNSWeiQ2msm5mj5bhkN6xeJaPdtmQtkPWkgmK2wz7oofG6+6?=
 =?iso-8859-1?Q?Drt2SSDeq4ULKl7rQQLhBgBNJpzzTCSnjoyhMjdK/jOjuEUlp8FF2LKrXp?=
 =?iso-8859-1?Q?TA2LT5qMuiQIt/EFxmlm/EVeO5R8otla5AkgQO/V5MqpRcfd2IgYXjuihc?=
 =?iso-8859-1?Q?cpUQL7TPMQVdTlupyaLAOl70D0tmK7vZC3ujK8AE2RX6iLyTapp56F95Ho?=
 =?iso-8859-1?Q?OUDE6nOX1Rgaw1axFhi+wkX6/6pylr/NQm32sisAWLJs0ZjeU8kr2klq45?=
 =?iso-8859-1?Q?x0fGWUdbzW96SvZaRuGrc3Cu649yOQ1km1BQkrTWy9OeHRKzovKOwP685a?=
 =?iso-8859-1?Q?B58tES8DYl/c+IprQ5Ltk+Mi2As7gyIoUmDHW9YJV6SHgWZL9ypV7bIRAi?=
 =?iso-8859-1?Q?nmy4dCa0/Tl2tCP8Dq2FOdcRZ72qoh5fBEIOlvWSDO1iqWB9yRF4sVowj8?=
 =?iso-8859-1?Q?hg0y2CnmFkBITI2m31ZN0kWupXd2UKGKeSLhlcdyt52m5m6mG+x+jtlLH5?=
 =?iso-8859-1?Q?Wt5WaPA5VYzo/UxSZz+3weLPSeZ+lgSe6HUF6lbtRcsybuCk4kbZEXGwLE?=
 =?iso-8859-1?Q?JVw05QCh8320AdY0XN8e9/jODxkP/GNFYJz3S1FI3TzZd2fRt4czOg7Hjh?=
 =?iso-8859-1?Q?/9hffjTdoVm/8C0PVTatbiIVoSNuL5gPeJ56Pj+RT0sX81m5z82mWTDFjN?=
 =?iso-8859-1?Q?2GqFM5SvUaOrhQeFrX78KHLEZ1dBLUxvmFX3WEgeZfDQ3xlk+Zp5Yla1Gx?=
 =?iso-8859-1?Q?Pxunh1BjbezmRSep2aB8e5i4gGAo/BRsYObxfq+AIAsRgwUiPA5iAtw9WQ?=
 =?iso-8859-1?Q?d+XQGp/gK4k37O9D3MKuoJ4/O2ro7rj69bCA57y4fwNTWiMey3kIGEJgO9?=
 =?iso-8859-1?Q?glbfc5Yr5unc0ddyegYcWa5/ItMVp00HucZMpFYXNVTrgWxCGho96rKTtB?=
 =?iso-8859-1?Q?FbITw+GATMWeKd/hswFqYTO0QiG5hL/SiYMyJN8hWPn+CAcvQwGLs/2gAY?=
 =?iso-8859-1?Q?5FPhKEA6hzHUvsRFMkz0qvfxq/3ZrnNcE41c373AZDoEYMaUHlhyfkVInN?=
 =?iso-8859-1?Q?CvJT3YqKtipc0Nu6XX1BPofasT+FeOIhpkgicL5EaaE8/4YIgzYn8zvP2S?=
 =?iso-8859-1?Q?ap4yz8N4sOsrUhoUOj7HxVUlllfp9/xYxhqi/pVPwvIPw60fV3DvNmTiv1?=
 =?iso-8859-1?Q?w3pcVTuaPUuqUMhk1e2Wd8pqsRmEzXiMZw3WYr2fZdx0I08XXWeViR89vz?=
 =?iso-8859-1?Q?cTRznMWKkuEfF+IomlU=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d3af3414-a459-4431-93d0-08de552cba3c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?R+VO3alLXO57vlGIa/1PgI+c7ED1KkuqUPnoGCHRP7LBRzxXEyArQDCZZ0?=
 =?iso-8859-1?Q?TgmVP8kKtSz0DWKg6oHKvkWu0YJWSjQ2mTN/kkrHHP6JGGYNhiviG5q3lq?=
 =?iso-8859-1?Q?Q7Luf6irF3fFWVrHZIIpitSsA1t9SvoVEhN06ChDSDFz4svO+8eoIKkFY9?=
 =?iso-8859-1?Q?lQF103Irt4qLCRj+Yxu4tZS51HyNey9XAdD65dzwhI46tGAmvsFO0uUlX2?=
 =?iso-8859-1?Q?OQWWhPybWWQDuJN/Q86OiiJh7sJrmaXSgD36zBd2546pUT7vihwx2isVay?=
 =?iso-8859-1?Q?tdVyOywo3vuMPT6zhhZc2htzaFDOX3xhh7YHZFyAz6RA5SmFL3buX4jsPt?=
 =?iso-8859-1?Q?FZ9aR9va9+6/HRscKehKAySVo3EqzzqhDntUJJq9w73o0LkagDY9Em9LRF?=
 =?iso-8859-1?Q?cTatxyG61VZDYf060RIakYvEfcIIHiz4TRZBICFakpXhXHmGyU+VK4yiQt?=
 =?iso-8859-1?Q?+X2WAWK5GFDcTrXfUCIaJMSwQBkGAFjBqOVxoLLncZqJYz9R6Ia/xozbS0?=
 =?iso-8859-1?Q?tgwatjt52THU5RRLfxTa7vKnrfcv3ONf91hNTf+T0KePfBWpVb0DaMm+36?=
 =?iso-8859-1?Q?t7UI/gbJzGW/fUTBHhfguQHcj8q7ASglpeZ/q3ZrJcrN6NX+kez2oq+fVu?=
 =?iso-8859-1?Q?10RP4vA7D+4DfFVhgDSjxH8Zfmy0SmePgFeYxzc5R63hJUwwHye+Nqf96k?=
 =?iso-8859-1?Q?fadLR+fizIgFqCkdi8gM5ZOnk18B/lnzpCbbyld+NBVokvr9sdha7FL2Fd?=
 =?iso-8859-1?Q?E+A4L947zPjTtFmBk8TZt7Tq+DMGLLZjJbYInx0Io5+LfK77l57TCBbQh3?=
 =?iso-8859-1?Q?MIPrcryCk+cmAnxbtYJDxY94tnHIMO/bINQXZxG/n/Ipl01QVzBZc6/nPb?=
 =?iso-8859-1?Q?lod7LxfFFuLB2w94KH4V0ivz7zkbKDdCXAM8CDzVhVRkJKZs0wsNddsBdR?=
 =?iso-8859-1?Q?U1HPnfZRrkgDeSkDSqyeQB6bn5hhyNYbS5x585+rBjVmfec8yt0TJFaBV2?=
 =?iso-8859-1?Q?+qBG/WhhBM3UV/CiCJybUezy78TkPRkDD6LruuhvnGtHk83WQlHUG0Q01J?=
 =?iso-8859-1?Q?c7U9YQ6lVUvExUudh+ltDm/mRgbgPj5chZlFMC0ImPlf68AYguPhmZ3Yj6?=
 =?iso-8859-1?Q?oDmEB4Gv74YbtBc5uOGE22kVVrBKEf/FZuPfYx3dh6HBvWmAR4MpVgmB+R?=
 =?iso-8859-1?Q?BCGNhuCfN4wUJhrS227Tc3dpxtj4JXIIq/ipA69NFkLQUtilWli/lA7j7g?=
 =?iso-8859-1?Q?+7Gzp281VIDE1cLj4a0HmIn3wEs7/KWDNHl8GJXmUIG/7fUWgjfp4T1WTP?=
 =?iso-8859-1?Q?YVI8kvxsKANID3GZpd05pNm+Q2fdak2Kqn5ixUREfyGeWJ8m8URhxx+tc+?=
 =?iso-8859-1?Q?BfuVhFxGEz584IFb+/KXtx1FUdmcma9tewJHcwm5PxYwY1AC5DBrYy4j/f?=
 =?iso-8859-1?Q?u0oq3F74fhyHZwe0aScstMWLnxO1XX+ZL7GwVR1uAKFJjG9DtvvZKarhkb?=
 =?iso-8859-1?Q?6PqqibieqflGl1eeVGStohBxO2jiAhi8FKH6fhtNW0e2VV4bJt2dTaVArN?=
 =?iso-8859-1?Q?MzBFcodmgS5fSFxsWinHKnPeM6i3a9zZ1NDY+BVjHDIZytSOA6ySAb7Cvp?=
 =?iso-8859-1?Q?n/R65Yt4HoSJxkEfYuTCTdJtiAzar5k1x19q3qGEy2dJ+wdsnJL+4dAHd7?=
 =?iso-8859-1?Q?YDp3eVqiPAVnlKu7vUuzp9ifpg5U7JHEArUyEGUpYnSoHAwBX0/XCZNZ0X?=
 =?iso-8859-1?Q?JTcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:16.5566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 562fa468-e8c1-441b-c61a-08de552ce080
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B96.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8814

This is required for ARM GICv5 support. At this stage, only PPIs are
supported as the creating of the IRS and ITS are not implemented in
KVM.

This change needs to be refreshed once the GICv5 KVM support has made it
into Linux. For now, it is based on WIP changes.

Change generated using util/update_headers.sh.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h    |  3 ++-
 include/linux/kvm.h        | 18 ++++++++++++++++++
 include/linux/virtio_ids.h |  1 +
 include/linux/virtio_net.h | 36 +++++++++++++++++++++++++++++++++++-
 include/linux/virtio_pci.h |  2 +-
 powerpc/include/asm/kvm.h  | 13 -------------
 riscv/include/asm/kvm.h    | 27 ++++++++++++++++++++++++++-
 x86/include/asm/kvm.h      | 35 +++++++++++++++++++++++++++++++++++
 8 files changed, 118 insertions(+), 17 deletions(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index ed5f3892..1c13bfa2 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -31,7 +31,7 @@
 #define KVM_SPSR_FIQ	4
 #define KVM_NR_SPSR	5
=20
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 #include <linux/psci.h>
 #include <linux/types.h>
 #include <asm/ptrace.h>
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 7a4c35ff..f7dabbf1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -179,6 +179,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
+#define KVM_EXIT_ARM_SEA          41
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -473,6 +474,14 @@ struct kvm_run {
 				} setup_event_notify;
 			};
 		} tdx;
+		/* KVM_EXIT_ARM_SEA */
+		struct {
+#define KVM_EXIT_ARM_SEA_FLAG_GPA_VALID	(1ULL << 0)
+			__u64 flags;
+			__u64 esr;
+			__u64 gva;
+			__u64 gpa;
+		} arm_sea;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -644,6 +653,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
=20
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -960,6 +970,10 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
+#define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_SEA_TO_USER 245
+#define KVM_CAP_S390_USER_OPEREXEC 246
=20
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1195,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
@@ -1596,6 +1612,8 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
=20
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest=
_memfd)
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
=20
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 7aa2eb76..6c12db16 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -68,6 +68,7 @@
 #define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
 #define VIRTIO_ID_GPIO			41 /* virtio gpio */
+#define VIRTIO_ID_SPI			45 /* virtio spi */
=20
 /*
  * Virtio Transitional IDs
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 963540de..1db45b01 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -70,6 +70,28 @@
 					 * with the same MAC.
 					 */
 #define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO 65 /* Driver can receive
+					      * GSO-over-UDP-tunnel packets
+					      */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM 66 /* Driver handles
+						   * GSO-over-UDP-tunnel
+						   * packets with partial csum
+						   * for the outer header
+						   */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO 67 /* Device can receive
+					     * GSO-over-UDP-tunnel packets
+					     */
+#define VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM 68 /* Device handles
+						  * GSO-over-UDP-tunnel
+						  * packets with partial csum
+						  * for the outer header
+						  */
+
+/* Offloads bits corresponding to VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO{,_CSUM}
+ * features
+ */
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_MAPPED	46
+#define VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM_MAPPED	47
=20
 #ifndef VIRTIO_NET_NO_LEGACY
 #define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
@@ -131,12 +153,17 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
 #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
 #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
+#define VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM 8	/* UDP tunnel csum offload */
 	__u8 flags;
 #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 0x20 /* UDPv4 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6 0x40 /* UDPv6 tunnel present */
+#define VIRTIO_NET_HDR_GSO_UDP_TUNNEL (VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4 =
| \
+				       VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6)
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
@@ -166,7 +193,8 @@ struct virtio_net_hdr_v1 {
=20
 struct virtio_net_hdr_v1_hash {
 	struct virtio_net_hdr_v1 hdr;
-	__le32 hash_value;
+	__le16 hash_value_lo;
+	__le16 hash_value_hi;
 #define VIRTIO_NET_HASH_REPORT_NONE            0
 #define VIRTIO_NET_HASH_REPORT_IPv4            1
 #define VIRTIO_NET_HASH_REPORT_TCPv4           2
@@ -181,6 +209,12 @@ struct virtio_net_hdr_v1_hash {
 	__le16 padding;
 };
=20
+struct virtio_net_hdr_v1_hash_tunnel {
+	struct virtio_net_hdr_v1_hash hash_hdr;
+	__le16 outer_th_offset;
+	__le16 inner_nh_offset;
+};
+
 #ifndef VIRTIO_NET_NO_LEGACY
 /* This header comes first in the scatter-gather list.
  * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index c691ac21..e732e345 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -40,7 +40,7 @@
 #define _LINUX_VIRTIO_PCI_H
=20
 #include <linux/types.h>
-#include <linux/kernel.h>
+#include <linux/const.h>
=20
 #ifndef VIRTIO_PCI_NO_LEGACY
=20
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index eaeda001..077c5437 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -1,18 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License, version 2, as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, US=
A.
- *
  * Copyright IBM Corp. 2007
  *
  * Authors: Hollis Blanchard <hollisb@us.ibm.com>
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 5f59fd22..54f3ad7e 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -9,7 +9,7 @@
 #ifndef __LINUX_KVM_RISCV_H
 #define __LINUX_KVM_RISCV_H
=20
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
=20
 #include <linux/types.h>
 #include <asm/bitsperlong.h>
@@ -18,10 +18,13 @@
 #define __KVM_HAVE_IRQ_LINE
=20
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
=20
 #define KVM_INTERRUPT_SET	-1U
 #define KVM_INTERRUPT_UNSET	-2U
=20
+#define KVM_EXIT_FAIL_ENTRY_NO_VSFILE	(1ULL << 0)
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
@@ -55,6 +58,7 @@ struct kvm_riscv_config {
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
 	unsigned long satp_mode;
+	unsigned long zicbop_block_size;
 };
=20
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -184,6 +188,10 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICCRSE,
 	KVM_RISCV_ISA_EXT_ZAAMO,
 	KVM_RISCV_ISA_EXT_ZALRSC,
+	KVM_RISCV_ISA_EXT_ZICBOP,
+	KVM_RISCV_ISA_EXT_ZFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFMIN,
+	KVM_RISCV_ISA_EXT_ZVFBFWMA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
=20
@@ -204,6 +212,8 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_FWFT,
+	KVM_RISCV_SBI_EXT_MPXY,
 	KVM_RISCV_SBI_EXT_MAX,
 };
=20
@@ -213,6 +223,18 @@ struct kvm_riscv_sbi_sta {
 	unsigned long shmem_hi;
 };
=20
+struct kvm_riscv_sbi_fwft_feature {
+	unsigned long enable;
+	unsigned long flags;
+	unsigned long value;
+};
+
+/* SBI FWFT extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_fwft {
+	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
+	struct kvm_riscv_sbi_fwft_feature pointer_masking;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -296,6 +318,9 @@ struct kvm_riscv_sbi_sta {
 #define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_SBI_STA_REG(name)		\
 		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_SBI_FWFT		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_FWFT_REG(name)	\
+		(offsetof(struct kvm_riscv_sbi_fwft, name) / sizeof(unsigned long))
=20
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 0f15d683..7ceff658 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -35,6 +35,11 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
+
+#define HV_VECTOR 28
+#define VC_VECTOR 29
+#define SX_VECTOR 30
=20
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
@@ -411,6 +416,35 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
=20
+#define KVM_X86_REG_TYPE_MSR		2
+#define KVM_X86_REG_TYPE_KVM		3
+
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg =3D=3D KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
+({										\
+	__u64 type_size =3D (__u64)type << 32;					\
+										\
+	type_size |=3D type =3D=3D KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
+		     type =3D=3D KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
+		     0;								\
+	type_size;								\
+})
+
+#define KVM_X86_REG_ID(type, index)				\
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
+
+#define KVM_X86_REG_MSR(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ID(KVM_X86_REG_TYPE_KVM, index)
+
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
+
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
 #define KVM_SYNC_X86_EVENTS    (1UL << 2)
@@ -468,6 +502,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
=20
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
--=20
2.34.1

