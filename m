Return-Path: <kvm+bounces-67585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB60D0B803
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:06:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4CB9315F708
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A54B36826F;
	Fri,  9 Jan 2026 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bt18As3X";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bt18As3X"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010000.outbound.protection.outlook.com [52.101.84.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B957636654E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767977927; cv=fail; b=JWm/zFrkZPvt76jfwDmx3ZA13ZgWw/s9zzFe5sujD5bMEIMcakISDOirEXfCW/TqrDP9k9WMMqN8m8Pih347Y6D9EYKdiu9fnsGCfQIXqMscqtWefQED0jzKJAOE6FXA8WWddlskVl/V+fzgL6nlc5w4Z7e98AwFMalSy+vzKV8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767977927; c=relaxed/simple;
	bh=7TG7gFVuRKo0gv8pvYzbSBrQcq87+x2C71g+04hBsBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jNqHI4hqecuWCTOHCAAxbvXVuzh9O65StqfJmlY7oLJFBO9o6ZlhrXRpuMbSi/l/Gt358gHZDRsb9nCR4FoMY3Q+Pk9IIgAE06WqNsKh9bMGN1yQmDhl/2Sh4qeqQ8tVHTGc4P3a3Ze+IINUSObBYv2vPF547tAZVOmUkc1eJGU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bt18As3X; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bt18As3X; arc=fail smtp.client-ip=52.101.84.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Wv5UISJW/s5IhI3fz2Qz1JNMFzK+PSm3ChFsJcK2Oz427ERm3Idx3wQPy8ellD422kH7Ow/4IJWWlYVPUs8j8Udej7ZC/Xhki+Vx/EAwry4dm5ZtKLZclyAdbdKVUV+AoLLPFCvIwBYZirHNdAC3eys+Io+7jYwPe6yE+7Eop+j3IqZqD/IincczYOFqTsC2eSMKeIE6VmhLFJAXXEhec2noXN42MUrbl4Wc8I34+vVt3qXFVHIBZotw33jKqdq3wRqQomgst1TOu61ZeBz+8UXQw/YP+eZ/laDV9fRcpfgDBgtdqrEpH2h6qasR4paJQkzLp+ykn5kGzx6MiPN8Sg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TG7gFVuRKo0gv8pvYzbSBrQcq87+x2C71g+04hBsBc=;
 b=ySpakj0vKV92+eVIe99c39rKPZFmGMBKIWs/6t3rIsQ8uRJ5ULWyHERVxwQhwKpIefuGfJc45mAPTaNy9zRRtO+sPLYAskjxUpdBdKUb1RruisNbzRnzmX2LKebQ9HC+/SPNIVWLQFFQKKhmpDoeUA85V7gbM7d56TIvb0u8J6WhBIXeLNHuGrYf+t4UN6lGmBaNRxLR0pZyG/xtSTDyUTJaJKOtitDXLewqcq7QqkAfsHGAicawy44mNXH8iD0LZ0VsYxp0dQKVdTNpoaBg8iIVSCWHpozEn8p9JtM1sCo59awaUu+BHj5YSmLihsm33/x2490x25TSOlPIIn5lmQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TG7gFVuRKo0gv8pvYzbSBrQcq87+x2C71g+04hBsBc=;
 b=Bt18As3Xew4cVAiahREf2jUGnWLHFmXq/VOh+tdSowvRk5xrTM2e4c5zM8eoOXORv0OzEz0AFC8yJ10KNlfUUL/PElPr+pwVmAPjphC/4We8ZIp9CfssZh/PqDIr/fS/neTGUDVPtcIkoO0fiHBJ0pvbw3Z7wUP87QM64sLbmQo=
Received: from AM9P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::25)
 by GVXPR08MB7870.eurprd08.prod.outlook.com (2603:10a6:150::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Fri, 9 Jan 2026 16:58:22 +0000
Received: from AMS0EPF0000019E.eurprd05.prod.outlook.com
 (2603:10a6:20b:21d:cafe::26) by AM9P192CA0020.outlook.office365.com
 (2603:10a6:20b:21d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Fri, 9
 Jan 2026 16:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019E.mail.protection.outlook.com (10.167.16.250) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 16:58:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ybWmp6lMmQUZCw/TnNkWuD3nESObvQ6snUn8IdDU3g4osvCkhcHqVHjeGRgrCprlMkhQ5lDRMGluB7+3hCSZu5CxnHvtLYhDLLcMiPm78ONZxg7FzKr55XhVZ0QNbRveo/QCXLp29m2c/if5lfNRfVS976ehnJabPwxA2KhFO0rCKzqz7KTahh+7TXfKf10wuWfuqIQsMWlLrCmQ48xd1YlkgascwMfJLekI1QNBnGyal8UYoUUvlw439oE275O4emnUnSeJrxb214ZsNUSKlYMJnAdWK/XtzLuaTJZ6lM3VcXffv5Rp6OOG9y9BBzJdvYMLzPAszyBdTe5j1sHcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TG7gFVuRKo0gv8pvYzbSBrQcq87+x2C71g+04hBsBc=;
 b=qQKpNvlM9c0/xSZt/qAXOGST1zRVK9SRpKGZDpZwK5uVDYi4t49mmkPSBG1TeEOWRfpq+YmiX/7trVVJalpU8o4RhsabJ4OmkSRDd/EYhV9BA7OgXA/LkfKRpulK2j+ivDgtCQmzX6WryGQysawfmi//AUvUP3U0m1fZ6cZB03qg5WH3KMRVS2DKeeR/j7fnUkDcEGx8pGfhKmWKJdji6B4lXgtxFUxDQjOsxgFEyhUTjnlAqHa/psKTpUbulxiIRWxvHrvAtdsopvJncN5OdJsblwEyUfHuJQPWEuzgwv4t/a0/LONOrsB58/xm1CNRt+Z2wBjDau8Wbs0/RBoFfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7TG7gFVuRKo0gv8pvYzbSBrQcq87+x2C71g+04hBsBc=;
 b=Bt18As3Xew4cVAiahREf2jUGnWLHFmXq/VOh+tdSowvRk5xrTM2e4c5zM8eoOXORv0OzEz0AFC8yJ10KNlfUUL/PElPr+pwVmAPjphC/4We8ZIp9CfssZh/PqDIr/fS/neTGUDVPtcIkoO0fiHBJ0pvbw3Z7wUP87QM64sLbmQo=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB4PR08MB9333.eurprd08.prod.outlook.com (2603:10a6:10:3f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 16:57:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 16:57:18 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Topic: [PATCH v2 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHccP9/cRjaE9ujSUGgGwLBe3eVgLVFiqcAgAEbkYCAA4nPAA==
Date: Fri, 9 Jan 2026 16:57:18 +0000
Message-ID: <4117fd5aca061db0857c0fc87f320b01f3347376.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-3-sascha.bischoff@arm.com>
	 <20260106180022.00006dcd@huawei.com>
	 <cdef264835c24f1e2155cadd5a414fb34d06bca3.camel@arm.com>
In-Reply-To: <cdef264835c24f1e2155cadd5a414fb34d06bca3.camel@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DB4PR08MB9333:EE_|AMS0EPF0000019E:EE_|GVXPR08MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e3a2c90-e883-4337-9540-08de4fa04b74
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UUZYbjdRcENpaUVNTVZGWXRrRzlyMzRSekUyQnh1eVdIRlZvZnpqNHdpR0p4?=
 =?utf-8?B?ZEVMNlJMcXU1ejNNVFFCczlWbnE0OUsxOVNwRWRSNksweitPRGFuejBMRUhY?=
 =?utf-8?B?Y2p1emRLMXB5eDhCZmZmaUhOdDFwTjB4dFdvS01oSkw1UjNsdXA1aC9xTGVD?=
 =?utf-8?B?QU5USFFXY3RiSzZ4WXFoS2Yyc095bG83Nkk3a3p0NmxlUCtMa2Vqd1k4TytU?=
 =?utf-8?B?UmNTQ1dNNVBaSENLSlg3RVRBUUx1aG4vTFNGay9zcEZEcnR0dmNWc1Z2V3pH?=
 =?utf-8?B?TmJ3dE9kQVJzNkxtT1VVTDAwOWFhOTZKbk9YQkxHODhVZDB0SGVQL2hjazhT?=
 =?utf-8?B?NWE1eVBEMlVwdXhqaVg1RmliRFgrWGs2WUZSSHZFaSs1dmtGa0UxcndXWi9S?=
 =?utf-8?B?VlErOFNOeUE1OXFNRTJnSEczVERYSTNFUlNCRVFVaGdCUHh0WU1jMkVPekN6?=
 =?utf-8?B?VlVDbGYvZ25CckZmczRmUCs2bGVwK0pjZVhyRytVUVovd1cwbzFwcXpMTTJP?=
 =?utf-8?B?QUxEU1p3WUo5YlV3TzNFSWJvSWxqWjZTN3VFWUpwbE5NSTQyRlVyalo4bE1B?=
 =?utf-8?B?cWJPQjBpUGlscE9paDdHL0hVcVZLakZ4Yk5qb2U3a2NiN2hPMDlHUUNnVFdw?=
 =?utf-8?B?eEJZMGhxZWxRazZpckQxMkkzZ2xwbllKelc5TDljc2RIam9QSFNpZytvaU1S?=
 =?utf-8?B?MW14SXY2T056bWNsQVo4RVBnVWtjcDlVaDF4eEpYTEE1NHBmRGErMjBGWjRN?=
 =?utf-8?B?SWo4MjBKTTArc1pON1FtVHM2QXAwM2pRNHB5K21EeGpmVWVkbStUZEdPbnJM?=
 =?utf-8?B?Y2gxT2hhMXoydlYxeG1GeTJvWUswRTZxVjBYZDRRVUM1dTg4dWdjdSttczVz?=
 =?utf-8?B?dmc3SzRHbDBVZ09hV2VsODAyeE52TWpzMkVoeDdCUkE0Z2I4RWZlUmRncWtw?=
 =?utf-8?B?TDdXc01TQ28xSlo2ckRwVys3alQwcGxUTTBIcGdrMStmMldRYzhrVS9MMFJS?=
 =?utf-8?B?b1VYSllUK08wUUJTRXN4TWEzcTBmLy9lL2Z4aTRHdnF4b3Y1Tlp0dHcycm9m?=
 =?utf-8?B?dFhudi9IMnBSMFJVWlNLRWVJSDQwSExRVUJHWWNaRHVVSFRseGNRYTg3QnlJ?=
 =?utf-8?B?UzUwN3o5SzBXaDBFbEdXbFZpYWd6aFVhc0h2b0MzNFlsa1B5ejFZZ1dVYW9V?=
 =?utf-8?B?SUVlb05mUlJUUEY4SWVpNjN6elB3UnM5NUhTK3BoVjZqaU1UWHArUnlhMWNM?=
 =?utf-8?B?eHE1V1JjS1hBSXkyTjBQdllQTlpZZ21EL3UxMFVsdVJMcitsL3V2bzNWQk9Z?=
 =?utf-8?B?QzA3LzY0LzZxT004MnREOFpJQm1SUVNQditCb1ZuSVprRW9RUkY5aEZVVWk3?=
 =?utf-8?B?amtLSHBiY1lWNVdUU2FOYXcxMVZFYSt1K0VlalRkQnd3RlU4SmRZbzh0eU9C?=
 =?utf-8?B?cmhnWGJFT1RRejJWcWQ2am5JMDZkZVpHQnV4WWtRS0lhMkxBN0tkZ25IcEFw?=
 =?utf-8?B?SkJia3NpdkZnL1NiaWwvYS9ITkEreWkxZDNLbW1WWUF6UE9paHVJUGNRbHBa?=
 =?utf-8?B?SmRrdGJhOVNLTUREb1M4UW9TRG5GSG1sQjloQ012dG9ldEJ5UzNkZUg3Tk1o?=
 =?utf-8?B?dUV6MCtjczNhS3dqbTN0aWFVZWhIUlgrZ0tZVU04TGxKZDNYc3AvMGFHYWtR?=
 =?utf-8?B?L3BFOHZMaklFYkMzYmRPUnZKM3JNY0dNNUIvN1owVko0azJOYnpFT0Erc1hs?=
 =?utf-8?B?Y2xZU1UwV09ackErU1VabFphRjIweHhpSTdIM1JtRkcyMFZLMzRuNlRrTkhz?=
 =?utf-8?B?K3JOc2RPUHhjSDlTK1lTMUIzblFJYWhHYlNieEhjdHAyYmxUMWZkNGN0UEha?=
 =?utf-8?B?N1JzbFYwdTNDMUNXcFh5Y21lMUR6VjZ6NWtiUE05QVN5b3F5M2tEUnB4a0lN?=
 =?utf-8?B?QmF3MmFudGtxR2x6M3VmRGF0Sk43YjlSZmZuQlRoblIvd0x4a01XTThLcGEx?=
 =?utf-8?B?R2RFYzhWcHF1TWw5bWw1a1NZQkRQc08ycjFmZi90UXlGb1A4RUh2bXlQSTVl?=
 =?utf-8?Q?nvMd0o?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <60DAE94BBBFC554EB4A5BA7AB52F0CE5@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB9333
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d51e3fe2-279e-4ea9-3193-08de4fa02627
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|14060799003|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHZQY2pWRzJUc0lKZFZTYmQ3Z0F4V1h0dmQ0MGJWb1VoNDVHdWdrY1RUMEVo?=
 =?utf-8?B?cVlULy9YQVRqa2FSWElnQmpnZWx4TExwMWh3L3B4bzcrMEs3dlQzRGJzY2dU?=
 =?utf-8?B?Wk5sVll2d0QxaTh2R2pVREovQmdlQzB3UlVwMUR5QnR4bmxQTEhSQm1JcG5y?=
 =?utf-8?B?QXNCTTVmWU05WnFUWGI3UlhKckhNZm1RWXdCQlNJM2loaGh4MEdxeVBJZFp6?=
 =?utf-8?B?MlgzbVd3Y2Yxb0dobXRhUHVLaDg4SGdEVHF2RlhFOEsrZTlueTdqaFpOcGtj?=
 =?utf-8?B?eWVOTFlGVGFSQTVObXNGbGI3Sis0TEdMVDRuZUs0dU1YdlBrRGpjOGNuZm8r?=
 =?utf-8?B?QVgxTzl2cTBGSTlGY1NBVDlWQVk2cDZXcFBXOUhWLzBWRlIrN2Z4TldHc1Z2?=
 =?utf-8?B?SXJLOERrK04vZThLbG9ZSEFqWURtL0d4a3JYZzJOeHQrSjJ0clh5ZlhnWHNn?=
 =?utf-8?B?dTJlbml3ZHIyNEdLTEorR1VLOEdUUWJKU3RYbFI1UmIwM1BUcGc1eHpVRitu?=
 =?utf-8?B?VlFRVDN0TnZZK0VaV3czNVJ2UGtKYU1icDRzd0VaY1J1c01WR2Ztb0VTMVJi?=
 =?utf-8?B?Z2FvTUZtV2h5MjF5Qnh3M2xFWjVYaVVFTTBHSml3eWdGckRUREdBWUMrKzJP?=
 =?utf-8?B?NkdrdFNLNG9pTGhadHk1aTJMeVN5eCtHNzJDMHdacnFLdWhDRnhJczJwcXRt?=
 =?utf-8?B?YkpnQ3A5eFhQVnU4Tng2dDZRNDVic1BDQktoQVp6NGMwSFlkdDgzTnIzWDZi?=
 =?utf-8?B?L0crcHFjKzBBYlY2SW5pTTdCYW5EUUFLWFZVVnliMXI0STNNYldTbnBXNEt6?=
 =?utf-8?B?dDlXb3dkdzA4aEh6T1M5cjNkbFRPVHlNN2U1VU8wdjRrK2hxanlWakcwTEZQ?=
 =?utf-8?B?YXJFTUJ2ZFlEUkJQYTVMMXZZSnBoZ1VISmtQVEdUbFJnWGptdDVNWFo3Q0M1?=
 =?utf-8?B?b3gyekUzSUFMb1QyUHFCV2trQlVtYmFnSkoxK1NWQjg5dGhtMHFydW5jam9D?=
 =?utf-8?B?b3ZHM1llYyttc0VTTjYrVjY2ZkROVFZEZFE5bmc5VFNaYVJwYlh6N0JsSVow?=
 =?utf-8?B?TFpoamltM3RwT3A3REN4YWY4RXQ2TWxNczhyRDhudHRlNkt2eGFhZFFBOTd1?=
 =?utf-8?B?NXdIU2JYMFBLYXhVVkx4MlVpbUdVTlVJekhwa3kydDBNMzVHelJKS25vVDJH?=
 =?utf-8?B?d3hvdDFFOW8vdnlwYUx4UkJ0TktHMG5PeWFFcGhJL0I3eVhqTXZwT1dzR2cx?=
 =?utf-8?B?bFdKMnMvOUgyWnBjWEtlMDdWUjlDWElSS3h1UkdNdzlaVkNCelJUMVMzSXNI?=
 =?utf-8?B?SjEyalFOelQxTUhQRkZ3MDMyM2t2QUNXVDNtc1V5VXJWL2JSTmVjenZOUFcx?=
 =?utf-8?B?dmR4cTJrMExQYTRlQ2RaZXY5akhZRFl0cnBaN1RKQ1ZDalIrVFJLRGQySjlT?=
 =?utf-8?B?cGlrc0prRFFNb05VVkZkV3ZabzRScDJ0WGJmbGhHUHREYlBFYWZvK3ZCVjha?=
 =?utf-8?B?RG9xZWpmcmI4S1krRzhGREdCaEM2SVFjM2pQV2NxeXgrajBoTDc1R0RlUEw0?=
 =?utf-8?B?TEZEcjRBcUtTQ3pFZG9ISDdzZHh5amdBNjVyc2I5YzdTM0oyOXJsckdtUVNv?=
 =?utf-8?B?TTdHOFNzZlkvQkQ4dmJMUmt5QStxc2pkelhJSFRXS3BLR0dqMDY4MjhSSGxT?=
 =?utf-8?B?dTZVWXpGR3RuTFZPREk3NlFEL0w0NFFEZmVSREZpWm1xTDFoT2FYY29POXFS?=
 =?utf-8?B?dGRkdXpWR3NDSVNBeVZwVXZITExsRi91YUdyY091cE9xOEhva0IwZzMzSDRC?=
 =?utf-8?B?Q0Q3N2RjdXE0NU9jRFZXakt2Mi9FYThhQXc3Mi93N1hXMUtveDlEbURwQVNF?=
 =?utf-8?B?QTR4SGF2L1lwQ25wRDFVY05MRmFVMW5JSTJpYThGbEc1MjBSNkhtRlZYQlEz?=
 =?utf-8?B?QnMwV0NTTm01WjFicHpKYk81NStPUnEzelNDT2ZWOU5LMDh5Z0kyMFhWenlv?=
 =?utf-8?B?NVREVGliNEJLeUVudnp6cllrVzZWay9NcHRYR2tOci9FR1c2akpHRDJ5THVh?=
 =?utf-8?B?MXA0SWRrS3BoNUptR3I4cE82bGtGMytSck44dGJJWFpIa0szRnZCYlNYaStP?=
 =?utf-8?Q?UUMw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(14060799003)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:58:21.1601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e3a2c90-e883-4337-9540-08de4fa04b74
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7870

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEwOjU1ICswMDAwLCBTYXNjaGEgQmlzY2hvZmYgd3JvdGU6
DQo+IE9uIFR1ZSwgMjAyNi0wMS0wNiBhdCAxODowMCArMDAwMCwgSm9uYXRoYW4gQ2FtZXJvbiB3
cm90ZToNCj4gPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM2ICswMDAwDQo+ID4gU2FzY2hh
IEJpc2Nob2ZmIDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gPiBG
cm9tOiBTYXNjaGEgQmlzY2hvZmYgPFNhc2NoYS5CaXNjaG9mZkBhcm0uY29tPg0KPiA+ID4gDQo+
ID4gPiBUaGUgVkdJQy12MyBjb2RlIHJlbGllZCBvbiBoYW5kLXdyaXR0ZW4gZGVmaW5pdGlvbnMg
Zm9yIHRoZQ0KPiA+ID4gSUNIX1ZNQ1JfRUwyIHJlZ2lzdGVyLiBUaGlzIHJlZ2lzdGVyLCBhbmQg
dGhlIGFzc29jaWF0ZWQgZmllbGRzLA0KPiA+ID4gaXMNCj4gPiA+IG5vdyBnZW5lcmF0ZWQgYXMg
cGFydCBvZiB0aGUgc3lzcmVnIGZyYW1ld29yay4gTW92ZSB0byB1c2luZyB0aGUNCj4gPiA+IGdl
bmVyYXRlZCBkZWZpbml0aW9ucyBpbnN0ZWFkIG9mIHRoZSBoYW5kLXdyaXR0ZW4gb25lcy4NCj4g
PiA+IA0KPiA+ID4gVGhlcmUgYXJlIG5vIGZ1bmN0aW9uYWwgY2hhbmdlcyBhcyBwYXJ0IG9mIHRo
aXMgY2hhbmdlLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYg
PHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0KPiA+IEhpIFNhc2NoYQ0KPiA+IA0KPiA+IEhhcHB5
IG5ldyB5ZWFyLsKgIFRoZXJlIGlzIGEgYml0IGluIGhlcmUgdGhhdCBpc24ndCBvYnZpb3VzbHkg
Z29pbmcNCj4gPiB0byByZXN1bHQgaW4gbm8gZnVuY3Rpb25hbCBjaGFuZ2UuIEknbSB0b28gbGF6
eSB0byBjaGFzZSB3aGVyZSB0aGUNCj4gPiB2YWx1ZQ0KPiA+IGdvZXMgdG8gY2hlY2sgaXQgaXQn
cyBhIHJlYWwgYnVnIG9yIG5vdC4NCj4gPiANCj4gPiBPdGhlcndpc2UgdGhpcyBpcyBpbmNvbnNp
c3RlbnQgb24gd2hldGhlciB0aGUgX01BU0sgb3IgZGVmaW5lDQo+ID4gd2l0aG91dA0KPiA+IGl0
IGZyb20gdGhlIHN5c3JlZyBnZW5lcmF0ZWQgaGVhZGVyIGlzIHVzZWQgaW4gRklFTERfR0VUKCkg
Lw0KPiA+IEZJRUxEX1BSRVAoKQ0KPiA+IA0KPiA+IEknZCBhbHdheXMgdXNlIHRoZSBfTUFTSyB2
ZXJzaW9uLg0KPiANCj4gSGkgSm9uYXRoYW4sDQo+IA0KPiBJJ3ZlIHVwZGF0ZWQgdGhlIGNvZGUg
dG8gdXNlIHRoZSBfTUFTSyB2ZXJzaW9uLg0KPiANCkhpIEpvbmF0aGFuLA0KDQpJJ3ZlIGFjdHVh
bGx5IGhhZCBhIGNoYW5nZSBvZiBoZWFydCAoc29ycnkhKS4gSSB0aGluayBpdCBpcyBjbGVhcmVy
IHRvDQp1c2UgdGhlIF9NQVNLIHZlcnNpb24gd2hlbiBleHBsaWNpdGx5IHVzaW5nIHRoZSB2YWx1
ZSBhcyBhIG1hc2ssIGJ1dCB0bw0KZHJvcCB0aGF0IGZvciB0aGUgRklFTERfeCgpIG9wcyBhcyBp
biB0aGF0IGNhc2Ugd2UncmUgbmFtaW5nIGEgZmllbGQuDQoNCkkndmUgZ29uZSB0aHJvdWdoIGFu
ZCBtYWRlIHRoZSB1c2FnZSBvZiB0aG9zZSBjb25zaXN0ZW50Lg0KDQpTYXNjaGENCg0KPiANCg==

