Return-Path: <kvm+bounces-50122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B718AE1FDA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77D7A1C221E1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D752EB5CB;
	Fri, 20 Jun 2025 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k0ig2l3Z";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k0ig2l3Z"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011035.outbound.protection.outlook.com [52.101.70.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59492E610E;
	Fri, 20 Jun 2025 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435725; cv=fail; b=fhVAZF1XOlCkozfy0QJDkhypWiIZmo+7cI+yn6mFKq9/b8WQkNBBpAeDM+g/FBnZrfW0tk6PRN8ftwvzhCvE+ek33zxNjT04EdSAOI7FQvUOc/t/QGJSokCvmbIMsoQLrNQV7De4+eNWZeFPjQVNXlaW/IZtEKE2JBbYMsUqis8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435725; c=relaxed/simple;
	bh=/ou/VldlMTrZusuVtODurKdrr6dbdOx17QTjC+T4M08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NaCPyyyhE4qqjl3YljICiGb0LThS/QzsmgvUHMAckni3fkjWadcUTBNQVnQX4mQtN+SbJTsz3rcTk7oB48bc83pJpET6VFskEf5e4/Crq/DDqfHg1Prsnc2TRCdi918PAna9yg/chCIvm1/QcJv6DuX+enrSCJx+2QsGn8qFNWw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k0ig2l3Z; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k0ig2l3Z; arc=fail smtp.client-ip=52.101.70.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JFSqyOWyw5KrG7uB4i8TT6lLqM6vcxC1G8+yek8Cs6Eu7DzSu69wwDMCRSlo2ueH45Q4Q+2iV8fxOaCzwCQb5OqEYtQQcn/KpNuCxZajyIe7P8Uz7OJ8V+5MHvLYmgJPzWplWv0HIKZdKitd4dEIGVkbzPn1Pt1qbNjpGWFM8y9RXio+XTmTi21MLq0Z0rvJ+XXyxG+kyj6C+PanxJfi/eGjrcLUFatUYWKDi+5cSG4i+/lHje4V1omnRexS7DI5H0DKT0KkLiecrOP32QWxGHW7iHJBPP6NAM01C62/lD4ZyQdo+rpbTzH7KSfkFR3O8i3AFs5xK3Clm4cF/iymkA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5dDqJ+aDlbaU8RPmtwKPAMtNEa2doX6+fWzKM4jab0=;
 b=Jl9fsrQVOvWywIDrRVDBIHQP3NBE0qq5Jz0m5dh6wuT94ERoNXCeVt0eb7SsJoPgGjkefvxHh8KdKFlzcHzM7NoPbg/Lr0Rxb9rXyQosUA+W2tN3cDVBhbW4/2vRe8qct/9oR6xiGNh8iyOTw3Md+KkZLqGH139KT+pHOO8I0SFTIsBsLBVJBge2RJou2tkq3jx/byKQq1Hg0T1e0j7kpHXU49LYO29NjHNkQhqfmNlaB9LJz4JBlTjGKKLVSrsrR/EXa82kZBAMUTfoJbqxZM8D4+dK/qMgXOmW5uSNhh94adTxuD8qcZ+bypNHp1AZPdI/qW0e4toabPI/1VRFLQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5dDqJ+aDlbaU8RPmtwKPAMtNEa2doX6+fWzKM4jab0=;
 b=k0ig2l3ZqBwu8mkQ9sVTLw/GUvEJUnuJUWXnp3EkKN2Y/h7Zn6ijY84VWCnhCAHh6ZJk3EnPfuU2xFAlihOuUugJwSzES1iimrThbvQ5bUkQg+VTfF8fuVXhHnw/Aniw2GE9DqalnXTdoXpoT/msQw5afvBzurm1i+BlOKta8MM=
Received: from PR3P189CA0070.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::15)
 by DU2PR08MB10261.eurprd08.prod.outlook.com (2603:10a6:10:499::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.32; Fri, 20 Jun
 2025 16:08:26 +0000
Received: from AM2PEPF0001C709.eurprd05.prod.outlook.com
 (2603:10a6:102:b4:cafe::d0) by PR3P189CA0070.outlook.office365.com
 (2603:10a6:102:b4::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.25 via Frontend Transport; Fri,
 20 Jun 2025 16:08:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C709.mail.protection.outlook.com (10.167.16.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EU8ln6hV0A0tKov2UeNIYXnQOIAskAeKlJX7EBOxni5wTsZfsrztjALHI+O123U61F4OASYXepW9BpPXujCFuh3jB1Y/G//hbMvMXwzdo9Q98PVpCtXj7F8luv6LGJKNjzloDwRl/SIWrEdVvmoW1ktXDONiuDpzSCowhCT0x//Vi+AsVNr73XtV36GeP7VsEoOthlDgU4uPvhZWPcyfmUlq653DJUCdnyNbC6SpCpuDlcfUwBLA2yQEyOTmwqrZ8HMd5gAKj+5ZLJawmN0kZTDjwhN0zFRoPNaDeUD5Q6EYiPPo/p+pV3DQ5KsaEYeeAXKtSxlqP+SFCtVtDcVC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5dDqJ+aDlbaU8RPmtwKPAMtNEa2doX6+fWzKM4jab0=;
 b=UUp46Iq0hdnVBq4Uq/YIJEZ3UeCb/O1qPLDnvOJHY75ZKL4W53/aYYC1qx4mI3O9LLOJKmhIYstKBLJ+iyIphUjmuiw8esYtopmYId4e5ewnCLVO52f2ECE/N9BcJOgAbGlBk1bbwjk13RVMxm225s49GHVr6DtPrLRu2VtAeu/F4jFss4/DI3qIOFxf6BInmw53TGqypR0xWj9XTqnP2gqW+uhsWUcExCHDMA8i64UVX59bZn2yHR/ZSoWrpYMacMhGgIYrZ3ub/C/McuuXdd8xOo6UsdknHXYDg/gHK5QM0/eEuphngL38bQD08zdDAO2ghopCz7SNvGHfc3T1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5dDqJ+aDlbaU8RPmtwKPAMtNEa2doX6+fWzKM4jab0=;
 b=k0ig2l3ZqBwu8mkQ9sVTLw/GUvEJUnuJUWXnp3EkKN2Y/h7Zn6ijY84VWCnhCAHh6ZJk3EnPfuU2xFAlihOuUugJwSzES1iimrThbvQ5bUkQg+VTfF8fuVXhHnw/Aniw2GE9DqalnXTdoXpoT/msQw5afvBzurm1i+BlOKta8MM=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS2PR08MB9474.eurprd08.prod.outlook.com (2603:10a6:20b:5e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Fri, 20 Jun
 2025 16:07:54 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:54 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Topic: [PATCH 5/5] KVM: arm64: gic-v5: Probe for GICv5
Thread-Index: AQHb4f15UlqrD7JLkk2rg+S3NQZyFw==
Date: Fri, 20 Jun 2025 16:07:52 +0000
Message-ID: <20250620160741.3513940-6-sascha.bischoff@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
In-Reply-To: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS2PR08MB9474:EE_|AM2PEPF0001C709:EE_|DU2PR08MB10261:EE_
X-MS-Office365-Filtering-Correlation-Id: a787bef8-af10-4589-0ac0-08ddb014b08d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?UsjJSB2B12IByeLMAoX0yJYgNn+IlZ6dKTCpfiFrG2IxqdhLA+T3BoMX/A?=
 =?iso-8859-1?Q?Bt3ARNvl006NTZHOWxImhrvqkjMRwnXa5JzsftDQLAbuCQqxmHCiyLI67W?=
 =?iso-8859-1?Q?6QxMmi+pQER4kR5KBHNchHRgWu8+UAbzzskikksmE6TuYdAQH3+KQRuzZm?=
 =?iso-8859-1?Q?zkEHWi7eSmNm26xTBGyGqXtCcCInoWf3sMtZMDStWyvcBOS4JOgrLQ1I/D?=
 =?iso-8859-1?Q?lD8WK7K3izbKZSNT99i3BMHge25k8cyQRdiAu4MFLDStbqTvK/sRYtaX+P?=
 =?iso-8859-1?Q?wn6LNogDN/yYOGhHqvk62JlCG8tl+galz/xpwu03Err1dPhMDtonbD93xq?=
 =?iso-8859-1?Q?cUPV18BEBU2HJOzh9m8c59TkMs2k1RA5sW4rhU9XNXx2uuQcmLfGfpOngy?=
 =?iso-8859-1?Q?/tHOq8QWiz5fSBu1IU1pRXAWoBR+VzLUcYqOwU+COHjSWO8aP9udDTBUvL?=
 =?iso-8859-1?Q?kvRaki+TuRAkIIXkIZGZgnSI5jKLKCiHd2YComaIcXBEzkTOIdaAAkMO2X?=
 =?iso-8859-1?Q?hnkEAytRUmyanv1Jx2O0h8zPMNyP3lTDHYuLuIPcR/+8ABwZtnRvZRdwSG?=
 =?iso-8859-1?Q?kmOBmRFHStk7Jkq/+C5B5CtCOF454RuUjpSUS0+S29H85y4v5qzJ+dqLZg?=
 =?iso-8859-1?Q?ycHAZRCYYFQi3WPiru4dI1pDfaLvHUtd6+C9/C2o0Luub4H8bVa0B8KxrH?=
 =?iso-8859-1?Q?jitmcbKQlO6EC8f17WHXZsZWy4uUvuLKTip62p+1Ya16+son+/MYpYKgSH?=
 =?iso-8859-1?Q?8T/VdgN8duKm+BDSoflVU6aTWScC7uNvq1gECs6NdUTLQPWMtXh9ctPRbu?=
 =?iso-8859-1?Q?5FlAQH5dK30XB8nyjKeaaJu75TAacRiwtikHWJzEkh8lXm7uW29L00/syG?=
 =?iso-8859-1?Q?yAAxIwcojeKi/4dtdk6KhcRTRFRck5ZH2ntuVkj/xYI5q9a/PGN0QuxKSb?=
 =?iso-8859-1?Q?c7+A7TBsg89521v3HTPWqwDyQlP5AJQAAfmO4wPPyqaCiKX2VM6CHh5f+y?=
 =?iso-8859-1?Q?QlHf9Or1Fc4oArfiPppL37AJtFgCeAcMcKrMcIC8qXzzFG+b14fvc6Q++z?=
 =?iso-8859-1?Q?aWVT0FuRZTisLQeYt5XcHDQPz6sKzKNLNLbTH3pWBe7Pi0f7YWb+ILvO5A?=
 =?iso-8859-1?Q?oR6/ZuaHsgO1FEUKbHw5yDsiyH1sGfeQH/WJjSv0fnuvHMYfEMYTyzw4os?=
 =?iso-8859-1?Q?9xKXkERujUitqtc5gi9yST/Lv1riNu2XQ7uwP29IMw8+Yuva3sLvaGMUdL?=
 =?iso-8859-1?Q?AvwgrhVu19zNSSmio6pKWkLamf6Sdx3Rb9+72nFLKnWHKOOcinTW2jv7S8?=
 =?iso-8859-1?Q?DNyPAkW/LEYBZOlkbVCB1gMyXRt/doFKfQqkpozL/kCSkn3d1CxvI3Q45s?=
 =?iso-8859-1?Q?5Cd9gAA+pFb08GRwJVxpHLYlT1PQMOUegMzFRVJ7JPLMdAzeuM2hZWdHuR?=
 =?iso-8859-1?Q?BrDutfe4o8qRZzoEM8XYwrAF9GDgDd+t5opSqHmPV9MC3cT7VIifomxMr9?=
 =?iso-8859-1?Q?0eQErJOyuoQzUjGjU8HOjO/Nfda6AUBfUjW4dy582h++Btp34SOimKd6fU?=
 =?iso-8859-1?Q?H0ScBng=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C709.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	47f8b22b-3b19-4146-51c2-08ddb0149d5f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|35042699022|82310400026|36860700013|1800799024|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TdW23RFI9CGCuq3E4LMrrsB+aUkUMlk3djKF4l/PpMv/1plq9xV1T9GouC?=
 =?iso-8859-1?Q?4Jn/gZbASKZo+Dw2k0znXCVxvEn022PL2Iwmrd8vf1Famx3QbyHgUjHgpP?=
 =?iso-8859-1?Q?NuAlm8Qfs/IDkYG3oPRcx1Ottg9pAtt9T5I38TftKn6ZwD6y43uorr7XFN?=
 =?iso-8859-1?Q?LjKT6DvpjNgFR4T0gkd0JOKakmverLIVqWrsG/VbfrGjUgDbKhRrgKa6lo?=
 =?iso-8859-1?Q?l5GxAjUadZG0+ixNJqxRESQ5g7SDga7rFL+B44D1TiappCagd4zfCbNVUH?=
 =?iso-8859-1?Q?htYwgWmQ/xqtO/wvDFgo8Yq5hvJS4N5kBNGxevBMyNi0v+uJaFIm0Ta8UE?=
 =?iso-8859-1?Q?foT3Yyf6Crr0Ivtab3L0w+a9CMC4NytLKuld/hmjThacV+BsOrXpKoUh6v?=
 =?iso-8859-1?Q?GU/5i5gGTgqNYB98+87cbuXCv8xt8ihdTfQmGYFKgJKhCeP7+SOcTTAKY2?=
 =?iso-8859-1?Q?p54XRxbrB1XBTZJN2k6nqaGYpJ9RRu2aRt4wS6xO3oMAqg9FipPXjZVw3W?=
 =?iso-8859-1?Q?GdRJWbA1xvBWYKj9tFe3YMcGtYn/Xoj3xltqMGYVGjrtudvZScHFvdzYeU?=
 =?iso-8859-1?Q?PlnI+RBbqqp/HvMI+xmxKcW90EOmsffZYxrhiLZBRZIwUtZDwqzlvOpPvD?=
 =?iso-8859-1?Q?giXqIz0T30YYu+IovDnmQpCIf1NMY8Ll0tsUxG3q4x1/H688Xnqkzurzco?=
 =?iso-8859-1?Q?XlLCLfiFoy5rbCepNvO9POBebw1n/ns26hM4++fCboWXE9Wlu8lkGB4w9L?=
 =?iso-8859-1?Q?qBHxZA6rSGsKrpOPjJpleXMas7SirvBXxNrxCVTSVgCs1GCOR0QP6uqH8s?=
 =?iso-8859-1?Q?OpVSeBi14GjeBU6rJ+ifvMU9hp6+VxL9yL737z7GNzE2mvH5pY69NnWa0F?=
 =?iso-8859-1?Q?auM9ALswBMKgUJAOBBHLYh1edxTwmz0MTxzzW91+T7MXSYe7xEPqiWZP7i?=
 =?iso-8859-1?Q?SIzfys+A1nCJ4sDDmPmBeMbZ0Mb3JPSUrj7/3454iOxjP/q7RA1nxVvPSF?=
 =?iso-8859-1?Q?GZpGCtZ7ka7KQkp0jIQT9+ziqiNCM6yqcLXhr5J74tXjpHWvqyDSYCwrUS?=
 =?iso-8859-1?Q?a5HTCdhlX2idRChyuTRJIb2qlUs2mEox8khET9UUGNaLzUSLLylF+Mvugb?=
 =?iso-8859-1?Q?oNMK4rCryVySIzPNUPdvwN4W1mC2Mm+MxAAHlHFbnceLfwa3cjTxM7BSok?=
 =?iso-8859-1?Q?gZpr55luzYhil+/TVcwrv8Kjv939Gf68vlXyvvJJdvf6QKDwp7rzaxQ39s?=
 =?iso-8859-1?Q?btks2UbwauLoO1Sm9+QdIn+WgmJ7Bg3TqXXlP7eGErCNcE36QJxw6LEqSE?=
 =?iso-8859-1?Q?rW3yN9m7x3Ri1yd5PRwhi2AvetdVpsJShz08GrzM0PlsfM+SEm1TQPPTLA?=
 =?iso-8859-1?Q?TSWsFwZAjCNJyG7PPctxhCfXQDYd+nenHGHFeopYN3WSA2Sl0JeBcqRJ6t?=
 =?iso-8859-1?Q?6UaiTjDqihfHjg019poJMkY8uQHBVCpuqa7Y/pQuE4aqUo6aZJSEJeAWs+?=
 =?iso-8859-1?Q?ge6qXIdm6V8kvG9V0TUw4G/kxVoi/EJmq5vZBWUGJ1w7Qssvo+zvdgx3OP?=
 =?iso-8859-1?Q?hmm54cHj5gXmQLWlQCG3feIzOm14?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(35042699022)(82310400026)(36860700013)(1800799024)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:26.3448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a787bef8-af10-4589-0ac0-08ddb014b08d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C709.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10261

Add in a probe function for GICv5 which enables support for GICv3
guests on a GICv5 host, if FEAT_GCIE_LEGACY is support.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  3 ++
 arch/arm64/kvm/vgic/vgic-v5.c   | 50 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 5f6506e297c1..2ec3da04a607 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -724,6 +724,9 @@ int kvm_vgic_hyp_init(void)
 			kvm_info("GIC system register CPU interface enabled\n");
 		}
 		break;
+	case GIC_V5:
+		ret =3D vgic_v5_probe(gic_kvm_info);
+		break;
 	default:
 		ret =3D -ENODEV;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 57199449ca0f..5d0cfcbbefa7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,9 +1,59 @@
 // SPDX-License-Identifier: GPL-2.0-only
=20
 #include <kvm/arm_vgic.h>
+#include <linux/irqchip/arm-vgic-info.h>
=20
 #include "vgic.h"
=20
+/**
+ * vgic_v5_probe - probe for a VGICv5 compatible interrupt controller
+ * @info:	pointer to the GIC description
+ *
+ * Returns 0 if the VGICv5 has been probed successfully, returns an error =
code
+ * otherwise.
+ */
+int vgic_v5_probe(const struct gic_kvm_info *info)
+{
+	u64 ich_vtr_el2;
+	int ret;
+
+	if (!info->has_gcie_v3_compat)
+		return -ENODEV;
+
+	kvm_vgic_global_state.type =3D VGIC_V5;
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
+	static_branch_enable(&kvm_vgic_global_state.gicv5_cpuif);
+
+	/* We only support v3 compat mode - use vGICv3 limits */
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
+
+	kvm_vgic_global_state.vcpu_base =3D 0;
+	kvm_vgic_global_state.vctrl_base =3D NULL;
+	kvm_vgic_global_state.can_emulate_gicv2 =3D false;
+	kvm_vgic_global_state.has_gicv4 =3D false;
+	kvm_vgic_global_state.has_gicv4_1 =3D false;
+
+	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
+	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
+
+	/*
+	 * The ListRegs field is 5 bits, but there is an architectural
+	 * maximum of 16 list registers. Just ignore bit 4...
+	 */
+	kvm_vgic_global_state.nr_lr =3D (ich_vtr_el2 & 0xf) + 1;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
+	if (ret) {
+		kvm_err("Cannot register GICv3-legacy KVM device.\n");
+		return ret;
+	}
+
+	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
+	kvm_info("GCIE legacy system register CPU interface\n");
+
+	return 0;
+}
+
 inline bool kvm_vgic_in_v3_compat_mode(void)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv5_cpuif) &&
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5c78eb915a22..a5292cad60ff 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -308,6 +308,8 @@ int vgic_init(struct kvm *kvm);
 void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
+int vgic_v5_probe(const struct gic_kvm_info *info);
+
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *cpu_if =3D &vcpu->arch.vgic_cpu;
--=20
2.34.1

