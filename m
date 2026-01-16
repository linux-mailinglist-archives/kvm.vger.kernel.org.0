Return-Path: <kvm+bounces-68374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB264D3844B
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 81BF6314F2CE
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6133A0B33;
	Fri, 16 Jan 2026 18:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R4ep97hA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R4ep97hA"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010038.outbound.protection.outlook.com [52.101.69.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A203A0B0F
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588078; cv=fail; b=fC513JlqwmZTJvxRDlroY945aFJ7yUoj87yjPiXdQ/SLQMjZw+8N+1INaAtfCgP77126dUHdR5bmqI2OAIBbsebj+yeHucHcsirpkfRd6vRbzrPz6r3ly3iB7zsq2qkwQSDy2v0eH4lvs47xFh+B4DxqXRscRK5wMWQMuRPbhzs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588078; c=relaxed/simple;
	bh=dOEHcKSGiE1yQTM3Q5IdaB4SufRdsL6/xPqIsngHAXA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D0oeE3SJAhZqwOuhjTodA93o6GX2P9xnKg9H+EuexQrnphgq+X1v3hPEcprKP+tVb4qFNh7fE/6OplxDxrq6GUFe9j3jaktxPsehk9jwC2Y0S2EH6BUnW16AXMHGaSibceMaJeAqGkgUUEDzYfQuVaxa/sVPGFyXsrzjyhz1vHs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R4ep97hA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R4ep97hA; arc=fail smtp.client-ip=52.101.69.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yGAH9EmlRLj4F6yFagAbMrJtblvgcemgF5lhxtHUAh970dmc96wSUxyDCbe9ARR4RhX9xYwUHVwDjW4okssvD8n96JWysVL1B8QVkE/SF08FjsCM4haCjn9jBTCKWzfK6twX/8Vu9CPeVcRyHoae73zwpf2WHlKSjf3gZCY6diePnK8hnUMjnYaGkwvU75/geUIRvJtyct2cjQPHv8CWI+nTySR/HNLsele2S/Fz4BdZptahbnYtYHscZzu+WKUxuRh3OzxUOKYK+ampiiPFe88yM9mYPm7LZKipOfSAVTMpeDeD8WVMXpqmM85l2uTmLtR8XckAuZ/+/klDggwj0w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgMxNqa4RAtmUA63CbNnqflxmooekMimiVmVGXLuGXA=;
 b=tKZpO2CfMkFgVxQ8DYnxugs/b5hLkKGdQfPQo9gyAoqc9oAgbYH45Y5NHkW3fwAILGis0f9NTgjODkis89WyLOQMXbFyR6s9vkLgXph+s+Z+2fPsVc6ztPyfN0g8B9OrOGKV2NQIZNFzgfYcrjNI5h1tbqpzdR6zPbchntck/ckITLqR47D1JjDYxo3S1VLfB9RbmpRTyv9H9Q2cdBCMRamHUL8rW9fYFVWWeTwvcLNjEqun9aTK3i8Co8XM903SP2gnMiEltxWeoK1I9peR/sfZgpI9KrBpmpvigghgrStdF7AAkGotorlorDS3VgKH51sQeujnk+neXapK84L7gQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgMxNqa4RAtmUA63CbNnqflxmooekMimiVmVGXLuGXA=;
 b=R4ep97hA73Qw6tkZIEfDb/ViDe8GM2VGCgv1yqIjthEQn7mQLVighhH9ofkCPPbVa2LkpHiCJ1tkO/zwOarcKMgcDqWkWxWQo7ks6qplxn/kVm4JECxqeHxkDdvOJY0dhCtvSGfLMvvyvZ5Aog+FDKRhipjaPuNOY6tFewWWzgQ=
Received: from DB9PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:1db::33)
 by AS4PR08MB7453.eurprd08.prod.outlook.com (2603:10a6:20b:4e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Fri, 16 Jan
 2026 18:27:50 +0000
Received: from DB5PEPF00014B95.eurprd02.prod.outlook.com
 (2603:10a6:10:1db:cafe::f2) by DB9PR06CA0028.outlook.office365.com
 (2603:10a6:10:1db::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Fri,
 16 Jan 2026 18:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B95.mail.protection.outlook.com (10.167.8.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VSNMPYjsgbbXQ6/LwxEgyX8G1rkSs76vltFPL22HNQ9FfYFgUr2m/CU+LLSIYO/GN/lk6kZwhApAYrbCAQtcDwCVuB9OKU644DW0SmpMR492OiJ2KLbQkpty/BC9vvZJyy/nYWagYzKRGesmpSdIg/b/jow6PVdVZWgAm2GNjlfPmCxzJbRD/1tX8PtFoi/aeOtPbEzYQiSDHu9bHG4c7CfQfe0JYYO8rwNjXtrSpvo36Eg4ZsLOtYVyto6TQd4d379tbHVvyioMWcqsyAM/MI2qdBDUVErv6il3hWFFpGAPgg9sLT2NThF6q064/YxVt44d3uI/haZkFuP3NB4BVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgMxNqa4RAtmUA63CbNnqflxmooekMimiVmVGXLuGXA=;
 b=pMBum7DnKbCso2mWjzl5jhSPXDSYx2VlYdNXeZFPcSAYhvGHVhNGxNjrZjJ1WO16KSKY6lWuacVHggUCDGNnEp0LerngzgX/RK3IvC3ZirKblJ/XW24LOgrVgeTElHcO7MTiVEtrKnfMiqy2rMBhqv+E71+6Va6qTa5a/kNDqO2Wq6phVDqx7HY5mnN4ddtSV7FAWduoSt3JwF7K3hV4RsAvkuDmUKbS9U89fBvGwtCLplaYlhhoH9YlQO6Hj2Bj0Db+JZRVv5s0jBXHqWwSioo6b1Zdd+kp+a8Ee7mE0jgZBg26Zxqwm7bKA+GilNUk9KiRH35njUuHofqPpEeecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgMxNqa4RAtmUA63CbNnqflxmooekMimiVmVGXLuGXA=;
 b=R4ep97hA73Qw6tkZIEfDb/ViDe8GM2VGCgv1yqIjthEQn7mQLVighhH9ofkCPPbVa2LkpHiCJ1tkO/zwOarcKMgcDqWkWxWQo7ks6qplxn/kVm4JECxqeHxkDdvOJY0dhCtvSGfLMvvyvZ5Aog+FDKRhipjaPuNOY6tFewWWzgQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:45 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:45 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 07/17] arm64: Update timer FDT IRQsfor GICv5
Thread-Topic: [PATCH kvmtool v2 07/17] arm64: Update timer FDT IRQsfor GICv5
Thread-Index: AQHchxWrf/yVo3yLpUiHiyJiBmWluA==
Date: Fri, 16 Jan 2026 18:26:45 +0000
Message-ID: <20260116182606.61856-8-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|DB5PEPF00014B95:EE_|AS4PR08MB7453:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ebd0aa-3968-4623-8dd1-08de552cf470
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Z9nrDHSDx4QzjlaQ5Ue3h0A4zV0LMGE0UZdif46kpKFuS0mzt/lKcSV7Ma?=
 =?iso-8859-1?Q?4tZWBf3uU+g1fjIkVyFZFnNy5G1jDxqBS7uWhezQW6M5AN7iLFQDeyt3EV?=
 =?iso-8859-1?Q?lIwQZCIWw8GZafcVpmamiVe9F8M6sxzcm80Ym6Opm3n2GEhbQf/O/TduIT?=
 =?iso-8859-1?Q?wnkiB6zQHHhHIJQ3XsOBloao/W1i98f2e5H3aMnp+wM5UKOhRQz/xv4WyB?=
 =?iso-8859-1?Q?qsxOIZRBvdX7qo1KBof8v2CNjLNUH5QCVQH+OWCRFyhKeaw5ySOkLVmjJP?=
 =?iso-8859-1?Q?MHbrD0zIP3x8W3yzWkaZku23ROKkPW32grEBLAZPK6wLVjQMEhIYV15idE?=
 =?iso-8859-1?Q?P0sbGARl3BHYOe9eF6RuE4rR5yJ3knFojhHp268KvYDnS5QMCQ6Xj+nJH+?=
 =?iso-8859-1?Q?4I6rXadBFkMNL1mXiSzhQm0352d6osB9MAsrYAOMq2HTWhc8DCkha9Vrn7?=
 =?iso-8859-1?Q?hVfyc2wV1ckBDRQfS93vbZOA7q/hf5WpRKgFQvrMjSgX2ZXULjLp5HN6zK?=
 =?iso-8859-1?Q?Nc6ryDCXWC7UAHGko6RS5ciUMQkHH25VTcAJcEarOHj9xmSJ8SYBuLEDtU?=
 =?iso-8859-1?Q?MTaPp1eFUAA0Qtx7GOFWHBO6s0RI7AwRWbAAFduhRfuoY4cfENroeBUyZZ?=
 =?iso-8859-1?Q?wzpErosFHTfh2Kc0lRPi8GCLASGVkD7yGCRM6m+vIExDAJmu874WY6Pzed?=
 =?iso-8859-1?Q?Q68/7IRBCxCE4Vu6Rbfo/CuCCAoRchIRqygWQZNvpRN+6IiQ4+CQ1lba7D?=
 =?iso-8859-1?Q?2wYcqvsjr9N71305XAJJEOaoFNbBtsZlcbxbVmTp2hNY+DehER44/WBP4W?=
 =?iso-8859-1?Q?8US7IRZlAfF+E6jFYPtZ+3LE1qIwPndfpl+oOdkZSI9XSGLR8rV8vGxLGr?=
 =?iso-8859-1?Q?tdLD6XPnYCYDj7WoOT9Wf72ZTgp7HVDW+jq22rUIOHoQHxImJx/7oTLmjf?=
 =?iso-8859-1?Q?esu2GNutzf+Dm6lQ0BnF+6bWATbwqp7Qp6/5W05DWteS/wv07n9osdd/1K?=
 =?iso-8859-1?Q?WWmndE2vz/t5MYIfgGZJ0n8aTMbFjJmZdJsc5jw5yUrMpE/4HLpqHSnLS4?=
 =?iso-8859-1?Q?MTSkSxgJt7g8GfRJirGttHuUAShrwshEQydTz4051kx+CuTERHRgEJ8FX5?=
 =?iso-8859-1?Q?UsIKRKwOi5XmQmEeJW7AdKpalKvMqMDzgsbqYaqLuh/RrPMRAyCk+7SAPJ?=
 =?iso-8859-1?Q?di8dNvZpHW7cCuaHdUSCYmt6/7NNikS4BF8boTFEn31Eo3krRmVRnPW3KM?=
 =?iso-8859-1?Q?M8i5nr5ioZh0R2i0QC670xyx6pQbimYC9I50SZPEEKqbB65wHBQ+d7+rN+?=
 =?iso-8859-1?Q?Qp/4qvoIb419sg/c80ZuLvD6XbXOm3eDcExeg8Hnerm72QkCB8BmRIsO73?=
 =?iso-8859-1?Q?g7YVt3jSAXr7szj2LipZkgcvbh8zo9pJ+LCQ6lIZP6BaC3J3fRr0j/NI5N?=
 =?iso-8859-1?Q?VRSxmJBEQlSLuXeIFC9n8eKYAxdT+PwRMPatwy+C0Xcr+qqGWKfkGdgUlD?=
 =?iso-8859-1?Q?v5ThNQra+dIK9ZLx+WNBrTyGUPbImgLz5+7Cj6sbFvHvHNthIAIjXe1dd5?=
 =?iso-8859-1?Q?mZSAI7S2gLoxh6PVJigvXhYtj2Pgq7DzgywxNMb2Kb9Q7Wy7t7Xihd3bTV?=
 =?iso-8859-1?Q?6DvgF81tenEKp2PPr0N/taCv3LVg0hNSsYqeBF72mLaPE+9PUBmPrG7qer?=
 =?iso-8859-1?Q?98V6WOqqhS2K1jv4sKo=3D?=
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
 DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e9d19e56-0f03-443e-f70c-08de552cce23
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|35042699022|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?A3YxV1G2daDf5kNW2UMbUNgRlrcmyBiTNR4Cb0nAoLdK3TogtYiH5U1pdT?=
 =?iso-8859-1?Q?6vI9sZgpLYI+C4ZFgSkPgrKc3nWHH4UVshiIa6y9Me97E+hJ04KrIqBZ3q?=
 =?iso-8859-1?Q?qdPI7Vd1/W4VfXfIqeaRY4mcKu2IyD3GKz9wwQ0d4+apJE1K+9u5X1v3W2?=
 =?iso-8859-1?Q?lNXkj0qPPOnR/bF/yMKV+abQrY06Pr5QFEk4PU6o2z+ifjcSn863Qmhi5u?=
 =?iso-8859-1?Q?5cXSUUB0pWh42OTq0Acmb8Jc06mXV3P1mXTEOE2uE2X6yPNFAxhf8Dt7Na?=
 =?iso-8859-1?Q?pS/NjkFmVOXCYmGjkXw3RncBl8F+GF+vPRwE1GgXcblsqYeiVSh14rwOsY?=
 =?iso-8859-1?Q?QoJFgDipeCbf39xhyk0OsOMDNLOx9vlBGkGYUBcXojj7oHOzVSrQRgO6bb?=
 =?iso-8859-1?Q?moNKzIbRLbulAbTDdoK4/pjYVGLiL1KaE/jy4ds6TKi/vTpVwJlOOSWRs4?=
 =?iso-8859-1?Q?Cw41uJPXXqNkdXwBHWlQu3hQhAmWJdT+5sZyyiF0LjiW/nVjv0k9BPMbNk?=
 =?iso-8859-1?Q?T8LJ/XnNb/3HVLRd3HB0UEo+YtM30p5KUotcOGFCDM0hA0Sx1fPClZV+KG?=
 =?iso-8859-1?Q?lUl1uEnwP0ci8a6OhDtr+dzxgXAAkbzZd6xgDSZerQWutmqjUCO6u4vHQS?=
 =?iso-8859-1?Q?jmNKU88FiW7BCvkjqAr4O37XrEilRDlRRQlPTvDJIQNiNQG0u7G5VqvYpG?=
 =?iso-8859-1?Q?NQNErd3Z41t4IgnHjQsIXRibW/EPrVro+aqZUa2JTkqXS0hSD5BezFw2y6?=
 =?iso-8859-1?Q?WwchzBWYZDu8Ha51eubhEYfa1dcV9GL+lW09/p9654voXKsiNvznCwwIeC?=
 =?iso-8859-1?Q?gVE+RHDlSecaHAhJUBqecmS0h5eSnX662eCHipPjVI922hKW5vKAc3BOWu?=
 =?iso-8859-1?Q?BkzZk+5S2am1mzjtFOBWhfv8C1XaZ64jH5aOZMe/GT74R6zPZLKfXV9iTS?=
 =?iso-8859-1?Q?DSgQ5JRJQWswEsl3VidlSPr9mQ/E1bGkgYi0h+jljy/pl9vobEnWKl9uCG?=
 =?iso-8859-1?Q?/Qts0Ef7B7/kxb6+lLt/W9grWUMAXEOfdi+q8s9tphEFgVCf7MdjvuWd8p?=
 =?iso-8859-1?Q?VSk56hZZM6zPWaYCqSeXf2e+J5FEL6kyFITZ0IfZidf8MssCy7eHt8olak?=
 =?iso-8859-1?Q?NHvTrpCmJjuhHpfsZRIm5EGQk5QCTliIl2VFI9wdzdAwM2BhKaWIYKSiqJ?=
 =?iso-8859-1?Q?KoV5wF+zjC3/y4qCY98JLw14Wwduq2c+T8jK39XnxGMUdGHc1Cf4Qax0Ha?=
 =?iso-8859-1?Q?8AzEeUvCVPZBW1V5nC3vuk7CR6ros2fVryzCB6qEydPkoTDFJ72KwlCzCF?=
 =?iso-8859-1?Q?V3JvqiE+r8JrgfMqAwNUy0zMcL1eDQuwM7Ax6BIQS/4obHohbUeq05tiIQ?=
 =?iso-8859-1?Q?9AiwzgUZs0IMwGwlu4NrnjzVo0hQ7voLwAcCUxAEoxBFWX1f3iRPSHgJ3S?=
 =?iso-8859-1?Q?Ms3cN+pqzxquhOYQk8x2w2X+BAh8vOJZ8kB1S0PlBaTMoKHITRTB/Cw1/h?=
 =?iso-8859-1?Q?vqeFlvIZJbD4ja4N82X6oJDUOyun0QSVnEmctT//QWxtlPhlkFqK2/Sgph?=
 =?iso-8859-1?Q?fJsGPSiqZA30LbB0CGv/VtK74LCMSwW6oiLCUxMtDFjo3KsfbxcmaJlSyp?=
 =?iso-8859-1?Q?YkK1E0s4afw5Lav9oHpV2h7c7IA3Z3BJCFnfGBQwCmEEVGg0aWPnuddblD?=
 =?iso-8859-1?Q?pgZgtNf6fq6sgMmnIffpZTYBUUJFmGOMNYsuQ1lOeMK1U33hd75Z37USx0?=
 =?iso-8859-1?Q?60cQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(35042699022)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:49.8756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ebd0aa-3968-4623-8dd1-08de552cf470
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7453

Update the FDT generation for the per-CPU PPI timers to be
GICv5-compatible.

In order to keep the code working for both older GICs and GICv5, we
introduce an offset to the PPI IDs. The timer IRQs are redefined to be
the absolute 0-based ID, i.e. the CNTP interrupt is changed from 14 to
30 (+16). For GICv5, these redefined IRQs are directly used. For other
GICs, an offset of -16 is applied to revert these to the exected range
for those systems.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/timer.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arm64/timer.c b/arm64/timer.c
index 2ac6144f..9708f4f8 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -9,16 +9,30 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm=
)
 {
 	const char compatible[] =3D "arm,armv8-timer\0arm,armv7-timer";
 	u32 cpu_mask =3D gic__get_fdt_irq_cpumask(kvm);
-	int irqs[5] =3D {13, 14, 11, 10, 12};
+	int irqs[5] =3D {29, 30, 27, 26, 28};
 	int nr =3D ARRAY_SIZE(irqs);
 	u32 irq_prop[nr * 3];
+	u32 type, offset;
=20
 	if (!kvm->cfg.arch.nested_virt)
 		nr--;
=20
+	/*
+	 * For GICv5 guests, we can directly use the IRQs above in the FDT, but
+	 * for older GICs one specifies the offset into the PPI range, which is
+	 * adjusted using the offset below.
+	 */
+	if (gic__is_v5()) {
+		type =3D GICV5_FDT_IRQ_TYPE_PPI;
+		offset =3D 0;
+	} else {
+		type =3D GIC_FDT_IRQ_TYPE_PPI;
+		offset =3D -16;
+	}
+
 	for (int i =3D 0; i < nr; i++) {
-		irq_prop[i * 3 + 0] =3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
-		irq_prop[i * 3 + 1] =3D cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 0] =3D cpu_to_fdt32(type);
+		irq_prop[i * 3 + 1] =3D cpu_to_fdt32(irqs[i] + offset);
 		irq_prop[i * 3 + 2] =3D cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
 	}
=20
--=20
2.34.1

