Return-Path: <kvm+bounces-59581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A38BC1FCB
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 17:49:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 610A234FBE5
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 15:49:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C9D2E229E;
	Tue,  7 Oct 2025 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QcR5CRsk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QcR5CRsk"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013004.outbound.protection.outlook.com [52.101.83.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8972147E5;
	Tue,  7 Oct 2025 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.4
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759852177; cv=fail; b=rxMJuoRX1OoA/VknQw6Pa4M9Ip1XI5bSJFU9IAGfndnxHtrYpqAxji9IZlcueSPkRChCJgQTN0FlsNzUYQ7ltbXe9SDyU/iM+wcK6pNONJubu85/7Nq/SL/vfa8KZD6dTVcZH8LoDF/mVvgd7H5eycIfJN7M8xZQa3pYRPAlOag=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759852177; c=relaxed/simple;
	bh=md26Qo6S2u6v+NCyc3zduNwfPkbBNnPPjlO7ppAD/AE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RIMpZWzUvAW13zOfIjzaFo7HZYVpQbfYGuJoFlTi57aooBJcOfsPRRGXfAerj9fJxWLmTMFm50jrqLFpksmcNJREJtA2XryXs/4PBEowUMXhZTxI9Y5RexS+OOVbJUu4yFCJ1gbbSIpOmfWjHlKl9wI0K6JWpA2I00sOKJ0t1E0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QcR5CRsk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QcR5CRsk; arc=fail smtp.client-ip=52.101.83.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SOSEY3+Nyuz9E01Wyfnv4G+nRqslkWr4Q6N7SZQLmBIcscmrvaBmzdoKZ12z0wDfoehRMURpjCXONzNunATOr8X3Qt8/fUsHWdHTgymCqlv/P3KCW63gtGcIl4eECG/aCPo/qaTsaTR6al0TTo1PdfZdext8pZHMVDqYMfvFt0Nm1kh7H/PKpL7Nxxh33Uw9UH+F62dm2JBjTulQ6lsA5aNh7pJeLuIFrHc+t1ngxBMAfcOKRGTWt3JXy8pQ76DW1IahaKDyj9o5oiJMQMFdohsuJFNHEzEatjFK4ONGOtUYY7fTfajToJLqVB72rZL5pku5WZtrGGvV+/HA4lfbZg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkojZqMq5eMacpnQq7vwLAOyWaQ6OpT2VeGQMHTgOsY=;
 b=Nf8SfUSx2BzKnn5yO6pl0XoX0T/6jtKrRGFeGBPNUCRmBlmSj/QZPSGeioGtszhBAA4nEg4SJPeaM3o+xccceSvURFATGhF33IizJDfwVhfOmoGOcMq5ZLY5pP84Wz/TEed3ofFX9h53qkG0BbXCs4UsI/W3dpZeFBD5ambrEfHbkO9EkwhLhatkOCrSgYy/pUXpPiK9V50yr0803ea231EtMntBDeYn8THUToMHRXfHEU7Wz8/+txDnBqUM/oJmvPLIkUgCfcPdnZPx9WRtkXNnO31TdJ4SpsEPdc2BJ5CCd0cuKaVBBeD7wYXJq0tYnp3wraYLdYbqoVaBtqWyig==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkojZqMq5eMacpnQq7vwLAOyWaQ6OpT2VeGQMHTgOsY=;
 b=QcR5CRskm2n/DJMcdDJRZU3znbzod6d8q45Sh2eDlp1qoNxGPEb6ifzF7LrP3G7dRE80oIdiJsV+pRJHzWU+9Fb4/z66tPh+JgUH188nZEzqT5dsqlPRS4bGtXYCxamvuZ5gQ+cwlNt5hMkgMTpy+ZdfCXBt30cYoW6dBbj4A2I=
Received: from AM0PR02CA0035.eurprd02.prod.outlook.com (2603:10a6:208:3e::48)
 by DB9PR08MB9923.eurprd08.prod.outlook.com (2603:10a6:10:3d1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:49:28 +0000
Received: from AMS0EPF0000019F.eurprd05.prod.outlook.com
 (2603:10a6:208:3e:cafe::55) by AM0PR02CA0035.outlook.office365.com
 (2603:10a6:208:3e::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 15:49:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019F.mail.protection.outlook.com (10.167.16.251) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 15:49:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvW3VVPQ9dNSfTILZDC1f/vtjCvFGownTx3kMKaAKQ2mVWGLMXMllUTMCSXKCc5tXGqrqs590Q/NOdcRIXwH0hKt1iyq29Zs0GhdwL49drTcznk/sQgeFCwmjtoznh4eGVPBCijxW9VarKnw7DIcvZIe/2E5N0n34+6+dz74jgxOyqujlRQfyJ2toUx6Ul8vbTbhQ+N8IXArLZXxzNvU1QMKGMRNC2IRhInTb66Z8hvP/k5sRBchjnhMo/5BsjzkKrC52cfTFmS7rd0QaypnUbQwP7grbVQm5ZHu2WTpR7EODvljcP1GZGPSfdonmZy8GYVSNs1otSv4YqQws+4wdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkojZqMq5eMacpnQq7vwLAOyWaQ6OpT2VeGQMHTgOsY=;
 b=nAwR2skVR/ipyTU1q6PmTwIwJJx2UhpnqJuam7bpOMjInUJjprHcoAXPwW3a7F9QnQSBZbKH1SzineGdPyZInfYw2wzAzhBvK4vkjj2WR7a8IdXB/TiFeC99s01tlOHWTCfbG/eCpTitq0DnFXM2iYPxg87cWh8hGIBXeZFlyQDLJd1evrLBxSEpFbvTsfITR7Tiu6vN1o1RRSiP+qAD9mrcowhz+22V48a/c37dd95ueI5UWwN78qmVeDLgXyMNY4u9eGmXRuYpdxFcv95g8j15hQYJtX95PxJD92C6aFwqE7pXziQVM6Cv+Ic4zi+PyCIswZ/w5uaZwQX1pfrsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkojZqMq5eMacpnQq7vwLAOyWaQ6OpT2VeGQMHTgOsY=;
 b=QcR5CRskm2n/DJMcdDJRZU3znbzod6d8q45Sh2eDlp1qoNxGPEb6ifzF7LrP3G7dRE80oIdiJsV+pRJHzWU+9Fb4/z66tPh+JgUH188nZEzqT5dsqlPRS4bGtXYCxamvuZ5gQ+cwlNt5hMkgMTpy+ZdfCXBt30cYoW6dBbj4A2I=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB8PR08MB5388.eurprd08.prod.outlook.com (2603:10a6:10:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:48:54 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:48:54 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: [PATCH] Documentation: KVM: Update GICv3 docs for GICv5 hosts
Thread-Topic: [PATCH] Documentation: KVM: Update GICv3 docs for GICv5 hosts
Thread-Index: AQHcN6Hi4xmPu+fUmEeZ6Y2Wm2bWYA==
Date: Tue, 7 Oct 2025 15:48:54 +0000
Message-ID: <20251007154848.1640444-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB8PR08MB5388:EE_|AMS0EPF0000019F:EE_|DB9PR08MB9923:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e735fa-4b13-4db5-4b5e-08de05b918a8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ug+mCOR730vpgpQ/ASY/MCK/+ntRqvVB71sCzyDLHF5Cc5q0bfw4SglxzN?=
 =?iso-8859-1?Q?atV28TjkH77h/kK+FKJZysirYaV0Hm7hZ2P+rtXviky2IyVP/wxmXRu/1m?=
 =?iso-8859-1?Q?/AnERzAcUIxEUdnnD1kKwndypMmMOZ75d+HKaB7gjvGWcXCrsC65PVqCtm?=
 =?iso-8859-1?Q?wzdbt3DkwoAdCh2Dpe6JdJ8edspAKyXqEbqpn6vldDb+ymp3pIHz5BO0+W?=
 =?iso-8859-1?Q?05kKDt75zNPwgpFdRtHMU6tZ85DsOr9LuYJkkosQIu1yNYAYt/CHQgcwcD?=
 =?iso-8859-1?Q?X4wKNxMQ4uNrReK0ieSwkBoeOcNi8w3ATJQTzC2Vzn4VgcG/8F1nkIGHMt?=
 =?iso-8859-1?Q?2I/MpvBVkbWJ6vxr67l7cXTGdlXUPHuM44N3yF39zUHWUxfsinZLwYl+mb?=
 =?iso-8859-1?Q?gxeYzE2wIALtLTezNuA0HQSGJ40fZ2v8kB7As8RSevbtPKE2fPoRRzQmxz?=
 =?iso-8859-1?Q?6vXPRe9LrIfQ5n6qZzutvChXcmLkzKOoHTm6sK2e29g2NGPjffl7Bz8c5G?=
 =?iso-8859-1?Q?lmRLjZ3FdKQT5y5MZysux5I1e01EKdxD/TbOdDQLtNpuw2CF7eoefjkS4e?=
 =?iso-8859-1?Q?vPqQOBpfD0l3VzRoKaI4z7YNgTahl9/6/w9rprpahmXDfgZGU5iXIFRIIg?=
 =?iso-8859-1?Q?iDJCPxv2Zff6QrWgpgHBt94HdqUqouZH41I0NxuR2VD89i5ciZSZpgwC80?=
 =?iso-8859-1?Q?ptQUml/8QfAUdRpMYJvL2U6i8+3ngaSRpWI+Pp169O5jhdyxaAs9vhwc/7?=
 =?iso-8859-1?Q?JgPBB/5xUlShPc2K8Inq1K+hNKksYA/Y/EttoIPDgWuPW9jNQcpul6XB1n?=
 =?iso-8859-1?Q?yi3vDmGzKHt1cCPFvSxdetVGccHJziC9EfHw2Ca+Mk5jDfcjOUb4ZjB0Bc?=
 =?iso-8859-1?Q?CFSCi9DQYlPbb6dI9aoXly1fOBdTN1s/tSOD2xsmbqZ/P8S2s+Uhsun0KJ?=
 =?iso-8859-1?Q?USHhB1CKXMlf3jAVC0TVaC4vDNKxXpMAgr1MmfRckkcn9ZcXTpejSuc28w?=
 =?iso-8859-1?Q?/4g7zpBYVFpUaktHS78z4sUPFvmENn6EOyWJ2iAM/R6EaCwJTuVyoxAxny?=
 =?iso-8859-1?Q?hhJVOHL5+Mid+J8hzltWHJrCQMYZSIPnPpaGaftRbIVa7c0z7n7RkOaIrv?=
 =?iso-8859-1?Q?TOMQwnOGBwsdKx5bBumnDu4B0XToWg18MzLAYlQXVRPWmn9n2c99LFP5pT?=
 =?iso-8859-1?Q?Ff1+10cnTrjimw0qzhP5YvwfQBMMobOjvfQHQHaQBK9JVDfbi2n8uXM46Y?=
 =?iso-8859-1?Q?zzYkTVWBUbbh8GsxK51QjaMPRoEm8pku1OO052ngIPDlIAaY0z08I/Peqh?=
 =?iso-8859-1?Q?G56xGiPphrqzPw0NdauU5hVbD4eU5wdvI6D0uuSM0fxxo24/BY6Y5cPQ7o?=
 =?iso-8859-1?Q?cM0rgPnhCDgZ86F7+lt6a4yi6HFHs+2gI65CHV+CC1tHeksTV82DLP88qJ?=
 =?iso-8859-1?Q?LNyDee92tRVGBqbapp4lBM46MiLy0TjNud7O++MBtqJScO5mrNDtQwvoXE?=
 =?iso-8859-1?Q?VTBbE4Y5obc82eKF2yTOwWrVzfhFVf1V+ZHi+pjql9RNANSJ2Ragde7oUP?=
 =?iso-8859-1?Q?dbXYGh4GBGydpGKTuWdYQMvt6onO?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5388
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4b437a03-8f79-4fa3-82c8-08de05b904ed
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|376014|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?IhFpLFK4yePKSdJbo4oR75D/gXuS+vIXd/JlS4CTaNlAAzRSyxHOIhNdpU?=
 =?iso-8859-1?Q?j+FoJhA3bKyNHG2lPCpSnHaMhnJjEv157aiP59iq+PEEzkBac9DIo4YKaj?=
 =?iso-8859-1?Q?TrA4t7nU9jtdYmSEys4/t9B7hI/OCED/vLrXobxNpDuOVfImL8q4gGD4HO?=
 =?iso-8859-1?Q?gc1sOxSqQ2jaFFJroZIRrQ9vL5iNZkaQucTLAbYee+np5/kmZ0zjbd18tl?=
 =?iso-8859-1?Q?/U6JDgWv+mOerlqCIgxTlZYhQdrrFPT5jbyFDDUU5PncRp8gp0yr98h19b?=
 =?iso-8859-1?Q?GYAPBAyIgBxJvUTyoBfY2/um6eItz+FMxF+kTpaKtYqjTu3lZ56IKzRftt?=
 =?iso-8859-1?Q?Pf3CZMw73dR9luvLlODiuE5Ilu5PlNIooAyDrqPIm7J+tYXDV5tH9yAMtN?=
 =?iso-8859-1?Q?kU4OwXIF8jWrJy06FxqNunxi4Zo+eL6ylrCaKmqP5FIfTC3r5A7RszmCl7?=
 =?iso-8859-1?Q?qFp4Ouag19TMMUg1zelvKNiPC/JOW4UPGcJYxO/+1yHIn/XPNqov9SNnci?=
 =?iso-8859-1?Q?2SSCtzomTiiXaPcyrG2jC48//LKtI0iLUVAtcKu/kueX8RUA8daqC0vRos?=
 =?iso-8859-1?Q?Z5Lf3oe9i+zv5IR2g9Zwa+pUibAg+jzvl+pw+JZNPNw+gtGQXBGjmUBQ4p?=
 =?iso-8859-1?Q?SYqCj8eyVR0NhG4ds8XFcNvZnbnzWDP0TT+zKyl6kEfdIzZvWSy7lX88TB?=
 =?iso-8859-1?Q?tbQTWK/LIfaltGkm54VrD1QivpcsorhdQNTspPDrZ38PvWFKd4CAWPKii5?=
 =?iso-8859-1?Q?iTNfqZFckfHodW90qUNEDoQqMsdEjJLdUSzkBDpU29Q31/h1zwncmqLQqi?=
 =?iso-8859-1?Q?bSnVA1Gp0mf/BuCDoQVBjmQ8ITXIwwmxgTn0FkV+b0tb7hvjVP7uOJPZUC?=
 =?iso-8859-1?Q?V0xELHjwnTPGkf6o3Tvrlofuny5wfXbe6/rchhgIAg5ESIxPlLF9zjEte4?=
 =?iso-8859-1?Q?atfa0ax19+t0NGvkXfZ27SQ0LkQ7gN/Sv/phdBz8TldAqB3dbK28uIQ4Og?=
 =?iso-8859-1?Q?ytWveSyTWSrHLLiL6vJAAjiD/lfvJEjDwsHQLrrU5tMa2c7k9Z82iby5hk?=
 =?iso-8859-1?Q?J2HrUi7IP17ziXLTndsV9uaBuDz65ZXqPZQ9Pv1ib32T7sUabhTSB2Klqz?=
 =?iso-8859-1?Q?DCymCjvs5RgUpIU5OSzGNQY6HYubRdF1HtDfzUlrUgEJyf7C2jZ7+CvSgp?=
 =?iso-8859-1?Q?wbJKHI0xTe9BLYg2ZMQ3XzwH2b0tjtpTXpTZqxO1yJpS+fNMJxk5c4GYOx?=
 =?iso-8859-1?Q?cfGEv80JYGfL3h0yHEBYRX14zF9eUOdAV4xrAnrwthWAssslEbqwDZp5fB?=
 =?iso-8859-1?Q?d7cYrM+HfQxPAr40qGzDdcKFT0tYq9wYEXyYH2mS5kzoxwI6DN/IPu4i9u?=
 =?iso-8859-1?Q?W1mytwkjV36EqR2W0zOj+49TT1v0z3M+dxxT08W5QDGKFV4boAzeG8ymKq?=
 =?iso-8859-1?Q?cermfaeevRIM/zzqotxrIsOuY5RH0cti9rvSHiVTMzbOuqeMsc2Ms54GeR?=
 =?iso-8859-1?Q?a5nBxGIoPiPq+E9XCenCRLpmBodXe03CYhIr91O80j/xObrBxcJ8GKa2QW?=
 =?iso-8859-1?Q?WYk+yHJz9p2tNmo5A1NfWcbynd/t5E6eVBmi5BrPlSS0dSD7cPX9Hnjd8O?=
 =?iso-8859-1?Q?FfXeKzWpdtTFw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(376014)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:49:27.3074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e735fa-4b13-4db5-4b5e-08de05b918a8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9923

GICv5 hosts optionally include FEAT_GCIE_LEGACY, which allows them to
execute GICv3-based VMs on GICv5 hardware. Update the GICv3
documentation to reflect this now that GICv3 guests are supports on
compatible GICv5 hosts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/devices/arm-vgic-v3.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v3.rst
index ff02102f71410..5395ee66fc324 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -13,7 +13,8 @@ will act as the VM interrupt controller, requiring emulat=
ed user-space devices
 to inject interrupts to the VGIC instead of directly to CPUs.  It is not
 possible to create both a GICv3 and GICv2 on the same VM.
=20
-Creating a guest GICv3 device requires a host GICv3 as well.
+Creating a guest GICv3 device requires a host GICv3 host, or a GICv5 host =
with
+support for FEAT_GCIE_LEGACY.
=20
=20
 Groups:
--=20
2.34.1

