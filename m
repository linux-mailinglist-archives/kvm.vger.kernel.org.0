Return-Path: <kvm+bounces-66396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06E9ECD11A4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A85E1300FE09
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9DC382D56;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jZbiSRcN";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jZbiSRcN"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011039.outbound.protection.outlook.com [40.107.130.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F103382BD1
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=G+YhIvFpJklQMaMsx9M7w1EfcEEtceRVov+5Zhk7GhhkaYTjqNBdLDm3c8fqbSdZaunCnZiiUNPYSmD8lrcitKv5vjsYf5aw8Ezjg5cuWZLHkeKSEoLg4y8JA4xOOj2RfyCewbGb4G0ZpQfMpc5xCe9Y3PdwIwpaniSqoSDUqf0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=TBwGrDFmIu1ah4Ewi7SkdxG5brJon449hohIvWVXGj0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UiUCuXEzkOddeVVzPtb+WFrydePUywh/ZishGY3pI3haT2XbsJcwQBHOVenE/A+z3sRvgCNp73Oz2VAL5Eg8iHIYS3TQ2tkFvrSDUlFrXc9IrNP6E0GUaJxdYCAfUCP1v+HCxmsG4CAVoH9/T4IMmq6+baL3mLti5qARFRC5i6w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jZbiSRcN; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jZbiSRcN; arc=fail smtp.client-ip=40.107.130.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m+WwrEw6KFl1Ge+mKnYRhrHCf3IpIjSlo6D/0H8Dps+hvS2wnEFA398tAs4BdsEYR27WmeygWtmVWEV+KOKaPAiz5BKn6bEOysKlHyptgDhYXw5C5YyNl7GOxqIBstAB3gKnCm4er8FjxBHOMt0NFEVV8Ud5VVaCv3gMXnJKdTkOjrHrUUofgWP0bJeaIfqnwFESlT3E0IDs9bSlIe5mt/kgjXRCz8glCNaBN/G33UCgnPZv25l3rHmssaB1/o8zm777MpwSGhGACOdxQu7T4M6piN2DdwDelAdr8r6XxWuZtth6eBlycd1JBegUNq7UoflhcLQIE8v9wUx4DgcWRA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GP19571gBVcqwfacb+Ta9zWdiDEsyTxiYKVdq/GTj70=;
 b=vr+kMhOgnOUTAAdaYLvxhXB4ABZyQDeZ3jgkh3r/aU0CfHuFvQd2ZR6f57JGd92WeGC6L7QrZlxB88mcN9/e2dDbloeVcKMuhOHDwQ7dyvI/C9J8HYqMj7ITKA9s6oAs0nimq+i78UsUHM9yV958SQ03bLapa2z4L8H0FSFr7NT9hwvXUEzmL/jbWLxCnqvlhkQhO5u3s7plLUIQFrT1OvlVXcTDfp278if5sFzB9kBLu/UBoQtVh6Qxd1/DVBhcxwAgwYJFDcgENN/nQaw+EgFdrSJLUZa0ixMyH5uWWIV6CTIII3RSZYX+LSbOMyDtP9u+nVhObgHOAC8M/fV27Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP19571gBVcqwfacb+Ta9zWdiDEsyTxiYKVdq/GTj70=;
 b=jZbiSRcNcqxgOklFOU0AMv2gSZi9zBb/w0ZDKWnTzE1/ds+rmW6L8JaZ9fCAOUjLnSTDc7fBbiFyq/pGSYr5/uNciQt2YO8/GVvmBiZzvoFKQDVlyIcXwkhqBDUxvJNrgZFepzD7Eqtoju//oNqEyc6l3LM1cMGyOC5/heISpQE=
Received: from DB3PR06CA0036.eurprd06.prod.outlook.com (2603:10a6:8:1::49) by
 AS8PR08MB8325.eurprd08.prod.outlook.com (2603:10a6:20b:536::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:14:04 +0000
Received: from DB3PEPF0000885A.eurprd02.prod.outlook.com
 (2603:10a6:8:1:cafe::fc) by DB3PR06CA0036.outlook.office365.com
 (2603:10a6:8:1::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:14:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF0000885A.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fk7hEQo1xvTC+/8KN0X3Wfn56GspUopj+FL/PiFqYL0XvL6YOwxcje1I536f0uXddZWbmLQAZsw2nCxwN/FKFC2HoYSUh/VSJ56gW2FnUfFmrC6YCwmgFMQ1QTIOuYSR3an9EkE5bHbqU8iJNKH/GSMQrk7R9xseVn8RC+Ynl3ZFgJyGhzQPB/a+nLmSRwaOLicvUKactGkdCxETMKAhY2ghEJKf4mRwPkcYz7pOiyGLK/6vn3tU36N65v2h3Xu2kGGQ5SQTsgQGT2NH7F8/+3ZNzaKSKdlEBsWr1E8/lDOm/2yuyEIBKsbPriKTxF7ORbJzzivxHBY1SkASHnNADQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GP19571gBVcqwfacb+Ta9zWdiDEsyTxiYKVdq/GTj70=;
 b=jZtbG6h2lqO7CEOxVpVvOtEHiD2Y3aTZDnIBNUPsFYq2ptUg8c9pBQCXjYt+O+RRqBucSaaF9LaDeddRpkku4BDaCMgzEpOxgPjBvnM08ZVN46yWc3tTz/vwd0sHbs0qKmczIGL0qWUEhEW/4wgSumfl4N15WSIOH2QW125roOlzu9atPsGeuAky5ZdSuVwvaXl18vEYhbZ5cDmGgUSlbpgturwDUFmcp0UOfLJcgAZ/z0M+3sBa+D2yeoZz8lDo/xW9sn/IDXCgeKxE/H2hNk/by0O4RA+nGiwVyLtUQl+0u+8SmK4xUJX0bBOBYEOTjYfr+GzxEykH4UkTqJ0MdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GP19571gBVcqwfacb+Ta9zWdiDEsyTxiYKVdq/GTj70=;
 b=jZbiSRcNcqxgOklFOU0AMv2gSZi9zBb/w0ZDKWnTzE1/ds+rmW6L8JaZ9fCAOUjLnSTDc7fBbiFyq/pGSYr5/uNciQt2YO8/GVvmBiZzvoFKQDVlyIcXwkhqBDUxvJNrgZFepzD7Eqtoju//oNqEyc6l3LM1cMGyOC5/heISpQE=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:13:00 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:13:00 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 12/17] arm64: Generate FDT nodes for GICv5's IRS
Thread-Topic: [PATCH 12/17] arm64: Generate FDT nodes for GICv5's IRS
Thread-Index: AQHccQJXRzdd0RgQLkyxNhpQ7xisCA==
Date: Fri, 19 Dec 2025 16:12:58 +0000
Message-ID: <20251219161240.1385034-13-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB3PEPF0000885A:EE_|AS8PR08MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db81c90-fa89-4a5a-f73d-08de3f19a049
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?k7s/h8zTyVzZyKCRPNAlEqmDM8b2WmBiJMi8pb6jm1K3UE9K5m7EtkIf2G?=
 =?iso-8859-1?Q?O278Z4LmFJU6DATaan2GdTb0gt/y1Nrr7FulwpmczGz6V3krn12wLDcnyn?=
 =?iso-8859-1?Q?w/Q0ktTn3ORHJ8AkkhSmHEM4hWmRs1Z9M3+ep5gX0vk7LL73ndE9igAr2D?=
 =?iso-8859-1?Q?OtMYwk220vQhsjYh5fcU9n7He8qKxzTDW1o0ezmYO/J9VwGGB/LyqQJoQH?=
 =?iso-8859-1?Q?89vPAqlYE1PHVDbr5RpNf8fl5dFkokFBCgDqQ6imts/bMkNpLchbxjMxCA?=
 =?iso-8859-1?Q?++nx6FtO/C9LiBYXLXOledN7YyHyfWvHj23PPmrDsOY26cSAwZLPJHzSqw?=
 =?iso-8859-1?Q?cnCS4yyk8bx1BGOd4so11+iwJ+0+udwrj6j0MkmxsQMhme+izRgxw0T4N6?=
 =?iso-8859-1?Q?IXztD2EDYqMV10GJROF3+hAmfMoQzFGjJM871zPJyQaV1xi9Lu+jGSbdXa?=
 =?iso-8859-1?Q?6v0mx1iFkaYEwjDBLIRTF6sgtzMVGTMl42bwqDb0ARTQzt731EZuIsIwLS?=
 =?iso-8859-1?Q?YFTBzAi07sxULUTKSSqGiSBvdRg3ctwCvToVBk46Vp8TIHchMssxc266KF?=
 =?iso-8859-1?Q?yO42DXH61+uE8GqGKtNEaVK0o/ACJqE4Z5o3m1XmuhY+JCxCCjN3GwexLQ?=
 =?iso-8859-1?Q?Q64ptKEtLpTCj+u3iUXioLjbTxxsiZDbgdBeTT+ZkZpsUtW5SQPZ4Sq8Ho?=
 =?iso-8859-1?Q?jPQW7Vk1TZyMKT9lXp2Dq3wg/55ENhe1iiZCZJ+lUgfms+ucM0h+PguOA2?=
 =?iso-8859-1?Q?Vl6tMgapv0HIb6fMsnbRR3mOHQbeUASLipxSRBEmbRbQ8senH/fyX39Yp0?=
 =?iso-8859-1?Q?5bgBRHsdBG3vquQ4/4UrGpPWTQlkPzFDm7KawSCMJOP0N8f9yuxMDP7fdU?=
 =?iso-8859-1?Q?FVBIectvoSNW7HWbjVr+KS4I+l9G8pV6O2IH0rgBbIt/LTdw/dKZWvmfZk?=
 =?iso-8859-1?Q?T4uU6kyGaIMiGl50BiWe3RlMG12lmebBM99JGurpUwQM04jY9WptNPxc5q?=
 =?iso-8859-1?Q?E1eIgFC7AxlCzAMd7mp1lE/bJPpZm7886FFZiyEH+7zIuWY6L0f1tpwkIz?=
 =?iso-8859-1?Q?yQekPftoeJplGoEtKS8gVC2f6EUTM5mX9gcnu4hqgCnGREz6/jBpoT28bf?=
 =?iso-8859-1?Q?NFFe++jnEeiibvV3H5EH9OTFWBbCZPIiTke+jVql5mcq+nqAlARM2+jLqx?=
 =?iso-8859-1?Q?Wbbjxfh4+1ppcSSPZPi4JzyR+aKdsxj6u3eE6cq5GtFRRK31sIFgAUqpFA?=
 =?iso-8859-1?Q?1e4v0zgbh3eG+ombt/EZTE9MsoD8De2N0YvPM25GBs3NuVaFI7kgtMfUL8?=
 =?iso-8859-1?Q?kPOkVnohvoAN5tEc8eARcjcTvZrhMqEpjpzNVl2C+Bvlzm1AGfTf+/op6M?=
 =?iso-8859-1?Q?PRpBUYDlsWI/XfIVUDy3g6UDgj1gZNgtR15FJYahj6EVLsyuduisaJcZVq?=
 =?iso-8859-1?Q?3s5OnVHnF4nP53qO7tlopHUBi9U+6cXuG3Tu4IDuzuDr/9jzE6VnXhmjQc?=
 =?iso-8859-1?Q?KnTJ5sFAvWZztvvV9PR/3F4hrI2RPNbC1/tkLAvzhLJ0jM7TxFSlZ3uJw0?=
 =?iso-8859-1?Q?wdpawkdJB1LS4g0kMEe6nlN/lfxc?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3f7c94e6-9705-4ff3-0240-08de3f197adf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?DWDxOXOp9GOrUOBCmxaS29BzCQiwFeFHMBbBWMC6rGJmY/XZ3w8m+h8BzN?=
 =?iso-8859-1?Q?MHkGK7aRjioT95Xnxsvn0DVHEhEW9AWWzbf50UxoA4wIOHpwQrap2VuWB1?=
 =?iso-8859-1?Q?IvTAZVmg6qhvRxrcBg+1CFPO8bPcQCUA4M/E7hjw0v0RnaPrLOcU0iXzPt?=
 =?iso-8859-1?Q?66765tzzZNDNQjcbet5dzr60m7Rnhbq/zrGzFaQ9Efd2WBvhW52rWsvg3Y?=
 =?iso-8859-1?Q?4/wP7UgfvQzaJV1frhuPbWKrN9g6Nl4WXosyGQWM/GDohE9tzZVMf215jJ?=
 =?iso-8859-1?Q?stSzN0SN0GLb3fMue2IObrrbQDma+uxPKbKU3IDJRe75jFbponeznrW+DP?=
 =?iso-8859-1?Q?YQPi6Ip8CZ/ft5cF3Bk9/uPUW+91uzhYRsu/Zm+Dpc26rIS4pLOVxLGY3n?=
 =?iso-8859-1?Q?GplbfdEB+THZ1WR8geyHgYaWQejWmUKdF+w73X1HWndz+kIHep36vpFl6L?=
 =?iso-8859-1?Q?ewmCJNMO3weGALADgmrJtVtMJDHwUac7hNbZ+AK0Kju2HWJ+/0saQKAPhI?=
 =?iso-8859-1?Q?dQvq0D/Eda52yZETR0Fjcr925W/C+Pt2L88qiQJ+iPqEF3Aw9qSAK9b3iY?=
 =?iso-8859-1?Q?Ax/ZfDeezPEICh/SZxs7nfSMGDu++zUlb/tRW7ntOjXBHnf6PLpICIdeyX?=
 =?iso-8859-1?Q?4FGL4bh8W4wLkH9aXf1oxwpMpYOpY/2WL6Hy04Tm3wEU2vsG/ocZblMdbD?=
 =?iso-8859-1?Q?FDEFeoWDOjQbjQwbAgA41vo0YwNO/0jG5puUCBU8wnQAgPhSPuZ+KoEf9G?=
 =?iso-8859-1?Q?VQqoSFvgzttpOIEl7BjvM5zP1QY7aI476N/wAUBp/gQihqN03pfk9qxeXX?=
 =?iso-8859-1?Q?xcVTSFJqrUqvhMavq8uS8+avxfP6iOOKVlQU5CSwCdF378lmKOfBIH7cRG?=
 =?iso-8859-1?Q?N3MSSA8E+Br09A+4Ligivo4lwzxJwT0aMHKIinPzpMzXs0RzxJrTiGmOXr?=
 =?iso-8859-1?Q?FNZnNd6zhUGlbN264aaFm/XHT5xTAtAszE9CKBZ3StLtwzKOaXLqiVujya?=
 =?iso-8859-1?Q?FMM2GBgJe90kHj+Sr5y0fJPA/a1LXCHcoihT9YDedBSKVCdqEmhxDOFW1o?=
 =?iso-8859-1?Q?sTsqniotbJXr8Mke9NEy7h6c6xVTWGqCX/I5w5fUffSksUHwn9IJGu9x30?=
 =?iso-8859-1?Q?BgoYxzgkL15CTasVv2YWrBtF9kppTX299sMn1+rqHR28uwcZQzcT+ojmf+?=
 =?iso-8859-1?Q?1JFxf0PgbaBdvrzuwYN0SmuUeEDZeAb9u2lhWlhWLTg85O4P4zwnXsCF6y?=
 =?iso-8859-1?Q?U3dnc9l/usd+HtnXUB6jvFsfDuCipQli02U8WAsPvQqN/+BEkortRcI2dW?=
 =?iso-8859-1?Q?G3IXKDcv0YAaXf2zX00xdXDeaBdHTXsvqyaIqkLf1soz/04DXkGVki2ZyU?=
 =?iso-8859-1?Q?6+ft+awpBprOX5+6RzaF8Qt7r/G3vAaG77RdM3FPskxbImyVFQ4YvKWbh9?=
 =?iso-8859-1?Q?LUR8mGXG8nTdV40B+i/xX8/wDNRswWfP2ZaTau8p9v498zvxOqiYWRtbAV?=
 =?iso-8859-1?Q?JHjrQPa56BdmHgvTsJl/7jlKUUHJYS6TL/pf6CkoILO57UAGL/+uthqbHp?=
 =?iso-8859-1?Q?RAl9UCpT+EegQ868A2rx+gNc2jghNtQWAk/anRxQ7pawdLqj3c8/ccyj3S?=
 =?iso-8859-1?Q?ApAB0gyfaSxmg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:02.8035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db81c90-fa89-4a5a-f73d-08de3f19a049
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8325

Extend the GICv5 FGT generation to include the IRS.

For the `gicv5` irqchip config, generate nodes for the GICv5 CPU
interface and the IRS. This means that the IAFFIDs are now configured,
using the CPU phandles that were previously set up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 5cb195ac..2152abf6 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -473,6 +473,16 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_t=
ype type, bool nested,
 static void gic__generate_gicv5_fdt_nodes(void *fdt, enum irqchip_type typ=
e,
 					  bool nested, int nr_cpus)
 {
+	char node_at_addr[64];
+	int cpus[nr_cpus];
+	u16 iaffids[nr_cpus];
+	u64 irs_reg_prop[] =3D {
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_BASE),
+		cpu_to_fdt64(ARM_GICV5_IRS_CONFIG_SIZE),
+		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_BASE),
+		cpu_to_fdt64(ARM_GICV5_IRS_SETLPI_SIZE)
+	};
+
 	_FDT(fdt_begin_node(fdt, "gicv5-cpuif"));
 	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5"));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
@@ -484,6 +494,29 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, e=
num irqchip_type type,
 	/* Use a hard-coded phandle for the GIC to help wire things up */
 	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
=20
+	/*
+	 * GICv5 IRS node
+	 */
+	snprintf(node_at_addr, 64, "gicv5-irs@%lx", fdt64_to_cpu(irs_reg_prop[0])=
);
+	_FDT(fdt_begin_node(fdt, node_at_addr));
+	_FDT(fdt_property_string(fdt, "compatible", "arm,gic-v5-irs"));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+	_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+	_FDT(fdt_property(fdt, "reg", irs_reg_prop, sizeof(irs_reg_prop)));
+	_FDT(fdt_property_string(fdt, "reg-names", "ns-config"));
+
+	for (int cpu =3D 0; cpu < nr_cpus; ++cpu) {
+		cpus[cpu] =3D cpu_to_fdt32(PHANDLE_CPU_BASE + cpu);
+		iaffids[cpu] =3D cpu_to_fdt16(cpu);
+	}
+
+	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * nr_cpus));
+	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * nr_cpus));
+
+	_FDT(fdt_end_node(fdt)); // End of IRS node
+
 	_FDT(fdt_end_node(fdt)); // End of GIC node
 }
=20
--=20
2.34.1

