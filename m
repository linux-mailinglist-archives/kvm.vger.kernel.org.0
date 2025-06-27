Return-Path: <kvm+bounces-50975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71411AEB3D9
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 500A23A903A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E17D2980C9;
	Fri, 27 Jun 2025 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="omISiRsG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="omISiRsG"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012014.outbound.protection.outlook.com [52.101.66.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DA52980BF;
	Fri, 27 Jun 2025 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018983; cv=fail; b=JkSlrZF3boNoZ5/i2hY9Ywhus+ciV/u1jiJqlVrDPh3hyG3CxFEP5ymnZsDTAXT/T7/b7OarXqBNGWaN+FUVlVRs3PfWbUwRK0KCsdBGRZQF9oQn4yZ/C9lvEez2FLdCuTfl99LkcqZsimxVqloqlXRtjfGm55qhVz6aOzV21rg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018983; c=relaxed/simple;
	bh=/T+MKL3wOcoOKwE9gXOh/IZGnwov4rrRN7ITr87R+y4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=umrmknITCnQgDn6GGC8x+Rd13vMxSuBjL1HTboyg6n1zYrksC11JIMbylZVPIG3fNnRpiUfBxinizCqy/bgklUi8rSkcCJ+v5kYcWSJAE2ohqTiqY7pf50T/UOjpLWe40qrJlhyIYoyzC6tNfdVEzBHktTuQ/WxjTCmTP2MO9qc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=omISiRsG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=omISiRsG; arc=fail smtp.client-ip=52.101.66.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=g61nzWohS3PnVh60Iwf4zmzNkTLbUDacThqlLPFBxWtYwt7oh1HBMHPPspD7EnYi2NsuY2zFNg7lIIctdApa8+W+bzCNDrhSTRAMxuaB1oIDPGCshNAD/avSFP1SqodrDG1ItWe9bDBHDMxJ7B+/mG7sRhE2piVzixH90cPnOxodT2rHlH8E7jiTZaO/D9XCaH8n4VbKSPTEKEJYcKU6V7L+qouGGGokh1MYNiYx28g/+sHWrSHM5WUn+ij6xt18uxYH/AplWY0Hcy9xAq2XjAHLPDFoKglT85zqebqiX8sWBrSGvRC36vNum5SfwxI3hD1VFacX+rFch6oig58Z8A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JZWyBHQ4DdI0xlEbAxmeEvzN1yQPqX6oatqt7IA7hM=;
 b=QhGVt8Nb+MNOl93qV6lUsRQtlupY5p/1MoYpBxhRPltWUHFaLjDnNo3B1Jcuq73XZny/+3M3+R8Hqt/iVFsTFVGkfDC248mT4aSjprM1MAH8J4qCqaoTT8VJZR+1y/KtV346Vz5gHakQ42+pIBTivzOHvh7sPGNDstB5yag0M50wE6s+smXPWlyg9MFOUEhP8Zg1OGwbCOKXvdGW/YjRjSQFq42Et6/ABN6BeogTC0Wml7uXEF2MV5+AzNo+nHcu2Ur5tCx9AhtYMcJ450M4N06/Oz3XF+ZU5KxCFG/YcyJBa/3w9m5hANn/QPfgwr3y+e4dOzOUk/abkHE2YWaTbQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZWyBHQ4DdI0xlEbAxmeEvzN1yQPqX6oatqt7IA7hM=;
 b=omISiRsGsl1Zvpd13uj18OW4cWQY+4CQIZzElKE0RkbBD7nYyIMudiXRym9Pl3NJPB+rPg9wwT1irTS/ZCHx++S97/kD3e+0dy0NzlCfM17B3VrWtdY3xXiTCcwPOPX8qtRaVcpHq9wMjx4pRho2lfhZ3St13oRkwwD7pP85CQY=
Received: from PAZP264CA0171.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:236::33)
 by PR3PR08MB5724.eurprd08.prod.outlook.com (2603:10a6:102:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Fri, 27 Jun
 2025 10:09:36 +0000
Received: from AM1PEPF000252E0.eurprd07.prod.outlook.com
 (2603:10a6:102:236:cafe::ad) by PAZP264CA0171.outlook.office365.com
 (2603:10a6:102:236::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 10:09:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252E0.mail.protection.outlook.com (10.167.16.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0DgNkbVGx49+urOun6eFC28y+7MZwzysPHzJauCWnP8U+t5LwRCqaVJXeMcCqfDU4rCrzCIQPFG6C3w+ZXBtF38X36MqSgnkQ0ZFYLnRh5NctnTR4ewMhRcn+WUcMwSzr+AlrlntNvuUw4QWB3jgD0YTRqGBr8FnVPPe7TxprCQwtOy2RB07UveQF0gn3IgBlYKdO/7kdTJewZPETgM5wbEOMuBci7XHTTdRgLmP7u+ENfGF3LmojDaqHxKi08I28C0oNUX8qnu4+9YA+Q9DoQGgVKg7g2DTGuWhLPtqxJmV2KinUazSlGmauO5Ie4B6z/8E+TMfTBSJYfgOI3ewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JZWyBHQ4DdI0xlEbAxmeEvzN1yQPqX6oatqt7IA7hM=;
 b=XI72jcp5qb6CSdLvk6Gm78xPYJhFQ6sSelkP3R7Hlc4eB19SbVJDl4cCI9njGoMug+CqLN+pKDuICUCAikyNPZWIeFE+bkj2FhEaRutzyFXX5EHwWRK846EnA38qq33CGIZKoRELNU3FiHZaci38o1TsFh02WiJUcXCQZ1hlmtb9zhKhmIWRWM8VMI9O09kR2ewfe5/GmrLsLblmahVHdMX6fwizZ6zVHsFQd93lrp7thFoW16Gz7bJrfdmRmR5q59Kz4fY17kfdDypfsOaE0WxVQylicsIlMM4qo0UxjvcvwASHjvdyVRsrRxA/U8rIUpQmEr4V325yhgyf6TCX+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZWyBHQ4DdI0xlEbAxmeEvzN1yQPqX6oatqt7IA7hM=;
 b=omISiRsGsl1Zvpd13uj18OW4cWQY+4CQIZzElKE0RkbBD7nYyIMudiXRym9Pl3NJPB+rPg9wwT1irTS/ZCHx++S97/kD3e+0dy0NzlCfM17B3VrWtdY3xXiTCcwPOPX8qtRaVcpHq9wMjx4pRho2lfhZ3St13oRkwwD7pP85CQY=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by PAXPR08MB7466.eurprd08.prod.outlook.com (2603:10a6:102:2b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:02 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 10:09:02 +0000
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
Subject: [PATCH v2 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Topic: [PATCH v2 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Index: AQHb50uBjf2gMU8QZUm8oyds38bs7g==
Date: Fri, 27 Jun 2025 10:09:02 +0000
Message-ID: <20250627100847.1022515-5-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
In-Reply-To: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|AM1PEPF000252E0:EE_|PR3PR08MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: 795b0223-c009-49b3-86c5-08ddb562b863
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?jGf1/Gm/hNPlkMu3ksB2Zmc5Pe6Pq9dO0iUhPNZdRJVho7l7lnor2b3gRF?=
 =?iso-8859-1?Q?qYtOVx9aQ4fo3nODnz3i5N6IDg86VYtHRox4LTJdLVOu4Tmu2dCtRag4ae?=
 =?iso-8859-1?Q?x3odO1DbXy6sP0IxzsMDZ1Nqm1tf496lS+LOpsOVIW3Cgpm5Xshd8ejH5q?=
 =?iso-8859-1?Q?heDfvWyyKIDN9t5NQN68AI2BlVaRf0SGbBKT+0VIxNKTv3CDns6GsENzmv?=
 =?iso-8859-1?Q?S2txaeZqaNwSD5T9UwiNFRQWFnERFQHOqfNTzAEwryMgtp4YHwgBjihshU?=
 =?iso-8859-1?Q?6JWKqmcZuTm7fkFucX2WcskSb27pjNrTOdDE0Gv6ORaASGqSvOls9j7Dhn?=
 =?iso-8859-1?Q?e9CeujtQkUGfCl2LS9mluv71HUhqLFvkutOSPsKBQICzc0vcbfWGo6Hbd+?=
 =?iso-8859-1?Q?QVyuT86KC9GEKcgUr+dSvin+oel9wPYwh421a/4oT3JOT6sCOVRB7eFH0x?=
 =?iso-8859-1?Q?6ud7A5AzrNNz6N+MRyJXVldch08G33YgfTv+VukGgUmT0QEShWUuFhgA1Y?=
 =?iso-8859-1?Q?xzuQzMtxoUw+a6m1YUzO1Y+x78upeTp50QXexd6AWAiXC9WluGdD1+HtGs?=
 =?iso-8859-1?Q?o5WdoOUoUl3lebcNHM343tK6or8NiNJGvUM4KAC8oaQEr6rJ/VUE9hbs7J?=
 =?iso-8859-1?Q?U6lTkutNx+nk53mwacNEgdBd4uf+MFxJUj2+TSeVEu4CdnRff9h6wVF4X3?=
 =?iso-8859-1?Q?2elOfkl0/rpWE92V041dhX/mULYqMmzRtPntYlDya99ZTlG63gTMdP2ppR?=
 =?iso-8859-1?Q?QPKQR8PTl/DR5vwh6S6YY3tBHpawysI+BwgBQ7+suQDlGGzj4pwzne/XKT?=
 =?iso-8859-1?Q?tP3tAvGST3NaM2UI5kBBJF6F/VUPX2X7p4g91Bt4UbUzLFeO9lRhKiKUtX?=
 =?iso-8859-1?Q?8V3UIJECzXq+4a4xiNGP42cgcJAlv2Tl12I6UUGyh5dm6JDWhor138S4k1?=
 =?iso-8859-1?Q?CjOt3npch8zDiNtVpnpbcYEd8lPOubpNc8M6EfvkN5H089jc91WNUV+T1h?=
 =?iso-8859-1?Q?p07iRZRzuUwN7vf6LKQMGT/iJtBBp5IhVhb6+HMzwopxoe/DyWPztJJnYk?=
 =?iso-8859-1?Q?8qgmbPCijhSV0K0Gv0jAriWU5GcnMfR8SI6aZx15+Kwi4Llsi1NDZGAabX?=
 =?iso-8859-1?Q?U7S53GRkQqQTSW0pFtl5LM928ZYz8+iPLLJ7TSzVu52WJACpVPOK6lUOjj?=
 =?iso-8859-1?Q?8kNHEYPFbi4ILzczwSPDom1EOzXDHBWsc+PHi/wWwl7pP7qdvYV6fSvvwL?=
 =?iso-8859-1?Q?/GFUsMwspHIZmggVFn5DnAPBNiEkdg7buIdetbASwJjQTixpH0gbM2k+Db?=
 =?iso-8859-1?Q?6mRlEunFYZs1kS9XFkewZlvhlUtIEXxI1QmgAFFuY5xH61a9l9jY0N97Je?=
 =?iso-8859-1?Q?nKN71Dj7hIfMFhgDJ4pHqZdCSf259++nZxIE6NXvbpdW7NErvVpMY/KcBC?=
 =?iso-8859-1?Q?StfdYVgWwFR7vbtA5bd4GLeyefBaYho7H7i+I4dUESqqO6vHzXfl4dt9qH?=
 =?iso-8859-1?Q?V1U0VJrBNNBmGn4JkrtUELFtrP37TQoCnH49hEO9dlmw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b776e6ea-a240-4263-6bee-08ddb562a47c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|14060799003|376014|7416014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?z4iqUoYGWmWEAyvC/4reVc95rTChNyuVtWj+C/z7/1CABryaWlw4SV8I1z?=
 =?iso-8859-1?Q?/QgouupiSTba2YCPaiS4FgZnZhaanHzwpg+yY5Yjxzd/vrPKws8LyBCsNA?=
 =?iso-8859-1?Q?GDNv2XOn/7NZQASOC7tBALTKrdGqeSqX2S7UeUXJlWv3xDujcJFURzYQgG?=
 =?iso-8859-1?Q?rUNpPJZeILNRTm6v7RpYDfp7oa0JQ4cJcX4wU7+eX7WsiYx4BZuft4qQjZ?=
 =?iso-8859-1?Q?fGYYg4MEsz0QSbWby8CZGJNG5AafBI/FExpOU4t5bVu3DkjGHKZ1jwQ0lS?=
 =?iso-8859-1?Q?PSRwt1jTeBBYWgutRFeJpt/apbFfoSiku0Mo3KWnWNQpKUx6MTLg81Da01?=
 =?iso-8859-1?Q?eaPX455mzkUOZlazPol1qc1D0l+kANKLEPhqtHkwd0oxQnw2tXBERXW1rj?=
 =?iso-8859-1?Q?2x3B++PsI8CMfMDAQYbRFRL2QjYq6YtXejiCD8KlRv7KqUw9TRb+UV2UNo?=
 =?iso-8859-1?Q?aBnfIpsqX3H2J6wQmKbpBG6bZbcC6tUrtuq8eXfoiTGQpvHKmIuBg3zzO3?=
 =?iso-8859-1?Q?ic8wAxtJh6+xnVSjoHgeKF7TAF67A5VQnRlPb6ie2DEp9NcpRAu9kClFNW?=
 =?iso-8859-1?Q?x9Mf9jWLiQrCPbUJRo46mEA6VrzIUYdD+eGlNncAmsmVV4ZqDRC2UbiNdK?=
 =?iso-8859-1?Q?XXgAjqx1r9bKj5cJ6TwSiQ5y7+cS3iJoVQB9eRlOfCc6WIyxfDufCIvxmZ?=
 =?iso-8859-1?Q?WmXqP2jQ+JeRREOZc4xymOq1XKeg0JfJJyZu6NiSUFiV6X0b/aSJuYzlNr?=
 =?iso-8859-1?Q?SAk4N8hnMrAUezEFqcjt0bVwineKy3RDZ6gnzdWQZjOJkmoeuCNVeMkxRV?=
 =?iso-8859-1?Q?nUhOvjU9hgi31xzchPm7YrKFc2I5RZXJv0sF0c4qcZ4kk+idZAl55v6ud2?=
 =?iso-8859-1?Q?iwu4Q22UPiNVEb/9Ha2pDPl17ZZO7Ui9/g949fYC4Cp6QBK3BJAcPAvIhR?=
 =?iso-8859-1?Q?62ficTQOCx3ioHuNT/t9/IZaVo56tgSojaFuj4vcbjEq2C98GxOVU521Ia?=
 =?iso-8859-1?Q?HcNLdIbku3ruTkt8O9JNrP90zsza9WIR9vBMmCYNfmvuVFNVSTg8zEU82e?=
 =?iso-8859-1?Q?MNsEhPsl2Zk/MrhRNIs2VVXoUuwLoWdRxQ/JNjnsgaK/UJZkyaJVSqui9F?=
 =?iso-8859-1?Q?lLCFDlS/+iYwXJwCUDp7YQA9ckQTzGBggzE87lA5cy6yCvm1PYHD8e/HaR?=
 =?iso-8859-1?Q?PQBd9Yaop02J7XuexNKdhY8rA5ser5/lkDDKEgeR436K0ZZ0F01/7M16bb?=
 =?iso-8859-1?Q?DUfz25Ylhlt326oNw42p6UwzSaUeAigS7gSNerphPcP3V2VE/+GwE1n2GI?=
 =?iso-8859-1?Q?bAB517zmpDnH+Irosv/VSygHVgADfccKxvNYH8RoYRsmIRz91jE7LjmV79?=
 =?iso-8859-1?Q?4O4vweSgBO/6CNBQFk6SUOrVAufbpSSkwVwZc+yj474bmsNSvikDN48zhU?=
 =?iso-8859-1?Q?smSjZILbLFful5Fdtl0qhpZ7cdiIfMGxXYDu5ALhcqEjk7iAgCoWj2Livb?=
 =?iso-8859-1?Q?Z1gY014rFU1xZqR+sStJO4uzlljSxwek8NzFE6fcn8MD/KPsZigia0Q00w?=
 =?iso-8859-1?Q?FjVLj6jch51ONDGTgEEEEq9TiyKd?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(14060799003)(376014)(7416014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:36.0413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 795b0223-c009-49b3-86c5-08ddb562b863
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252E0.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5724

Add support for GICv3 compat mode (FEAT_GCIE_LEGACY) which allows a
GICv5 host to run GICv3-based VMs. This change enables the
VHE/nVHE/hVHE/protected modes, but does not support nested
virtualization.

A lazy-disable approach is taken for compat mode; it is enabled on the
vgic_v3_load path but not disabled on the vgic_v3_put path. A
non-GICv3 VM, i.e., one based on GICv5, is responsible for disabling
compat mode on the corresponding vgic_v5_load path. Currently, GICv5
is not supported, and hence compat mode is not disabled again once it
is enabled, and this function is intentionally omitted from the code.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 51 +++++++++++++++++++++++++++------
 arch/arm64/kvm/sys_regs.c       | 10 ++++++-
 arch/arm64/kvm/vgic/vgic-init.c |  6 ++--
 arch/arm64/kvm/vgic/vgic.h      | 11 +++++++
 include/kvm/arm_vgic.h          |  6 +++-
 5 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index f162b0df5cae..6ce88e56ccb8 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -296,12 +296,19 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *=
cpu_if)
 	}
=20
 	/*
-	 * Prevent the guest from touching the ICC_SRE_EL1 system
-	 * register. Note that this may not have any effect, as
-	 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
+	 * GICv5 BET0 FEAT_GCIE_LEGACY doesn't include ICC_SRE_EL2. This is due
+	 * to be relaxed in a future spec release, at which point this in
+	 * condition can be dropped.
 	 */
-	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
-		     ICC_SRE_EL2);
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		/*
+		 * Prevent the guest from touching the ICC_SRE_EL1 system
+		 * register. Note that this may not have any effect, as
+		 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
+		 */
+		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+			     ICC_SRE_EL2);
+	}
=20
 	/*
 	 * If we need to trap system registers, we must write
@@ -322,8 +329,14 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if =
*cpu_if)
 		cpu_if->vgic_vmcr =3D read_gicreg(ICH_VMCR_EL2);
 	}
=20
-	val =3D read_gicreg(ICC_SRE_EL2);
-	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
+	/*
+	 * Can be dropped in the future when GICv5 spec is relaxed. See comment
+	 * above.
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		val =3D read_gicreg(ICC_SRE_EL2);
+		write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
+	}
=20
 	if (!cpu_if->vgic_sre) {
 		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
@@ -423,9 +436,19 @@ void __vgic_v3_init_lrs(void)
  */
 u64 __vgic_v3_get_gic_config(void)
 {
-	u64 val, sre =3D read_gicreg(ICC_SRE_EL1);
+	u64 val, sre;
 	unsigned long flags =3D 0;
=20
+	/*
+	 * In compat mode, we cannot access ICC_SRE_EL1 at any EL
+	 * other than EL1 itself; just return the
+	 * ICH_VTR_EL2. ICC_IDR0_EL1 is only implemented on a GICv5
+	 * system, so we first check if we have GICv5 support.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return read_gicreg(ICH_VTR_EL2);
+
+	sre =3D read_gicreg(ICC_SRE_EL1);
 	/*
 	 * To check whether we have a MMIO-based (GICv2 compatible)
 	 * CPU interface, we need to disable the system register
@@ -471,6 +494,16 @@ u64 __vgic_v3_get_gic_config(void)
 	return val;
 }
=20
+static void __vgic_v3_compat_mode_enable(void)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, 0, ICH_VCTLR_EL2_V3);
+	/* Wait for V3 to become enabled */
+	isb();
+}
+
 static u64 __vgic_v3_read_vmcr(void)
 {
 	return read_gicreg(ICH_VMCR_EL2);
@@ -490,6 +523,8 @@ void __vgic_v3_save_vmcr_aprs(struct vgic_v3_cpu_if *cp=
u_if)
=20
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if)
 {
+	__vgic_v3_compat_mode_enable();
+
 	/*
 	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
 	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..f01953c7c2a9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1811,7 +1811,7 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_=
vcpu *vcpu, u64 val)
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
 	}
=20
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
+	if (vgic_is_v3(vcpu->kvm)) {
 		val &=3D ~ID_AA64PFR0_EL1_GIC_MASK;
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
@@ -1953,6 +1953,14 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu=
,
 	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
 		return -EINVAL;
=20
+	/*
+	 * If we are running on a GICv5 host and support FEAT_GCIE_LEGACY, then
+	 * we support GICv3. Fail attempts to do anything but set that to IMP.
+	 */
+	if (vgic_is_v3_compat(vcpu->kvm) &&
+	    FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D ID_AA64PFR0_EL1_GI=
C_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index eb1205654ac8..1f1f0c9ce64f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -674,10 +674,12 @@ void kvm_vgic_init_cpu_hardware(void)
 	 * We want to make sure the list registers start out clear so that we
 	 * only have the program the used registers.
 	 */
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	if (kvm_vgic_global_state.type =3D=3D VGIC_V2) {
 		vgic_v2_init_lrs();
-	else
+	} else if (kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
+		   kvm_vgic_global_state.has_gcie_v3_compat) {
 		kvm_call_hyp(__vgic_v3_init_lrs);
+	}
 }
=20
 /**
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6..23d393998085 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -389,6 +389,17 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
+static inline bool vgic_is_v3_compat(struct kvm *kvm)
+{
+	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
+		kvm_vgic_global_state.has_gcie_v3_compat;
+}
+
+static inline bool vgic_is_v3(struct kvm *kvm)
+{
+	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
+}
+
 int vgic_its_debug_init(struct kvm_device *dev);
 void vgic_its_debug_destroy(struct kvm_device *dev);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..5c293e0ff5c1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -38,6 +38,7 @@
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
 	VGIC_V3,		/* New fancy GICv3 */
+	VGIC_V5,		/* Newer, fancier GICv5 */
 };
=20
 /* same for all guests, as depending only on the _host's_ GIC model */
@@ -77,9 +78,12 @@ struct vgic_global {
 	/* Pseudo GICv3 from outer space */
 	bool			no_hw_deactivation;
=20
-	/* GIC system register CPU interface */
+	/* GICv3 system register CPU interface */
 	struct static_key_false gicv3_cpuif;
=20
+	/* GICv3 compat mode on a GICv5 host */
+	bool			has_gcie_v3_compat;
+
 	u32			ich_vtr_el2;
 };
=20
--=20
2.34.1

