Return-Path: <kvm+bounces-67420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42133D04A56
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CF5D3067233
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494C32EDD76;
	Thu,  8 Jan 2026 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ja/OZAPp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ja/OZAPp"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013030.outbound.protection.outlook.com [40.107.159.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7E2E8E16
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891284; cv=fail; b=livTc6iYpIib+CmqE3cDGJoQkOJFBRhlAoNaJSqxoRqv3EM4tCLdj5wLJCl6rUiwivq4oq2n935LdFLtI89VXpp3bB7OQN76ukUrJD6kiNcS1VEfRHwEkkQXEi+fJG6zUg5Dvbdl+l8/n11pTqAR3QutNRJOVE7llieRfVKoiJs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891284; c=relaxed/simple;
	bh=mJ2l51NF6RtqZ15ZmiIjrZpJA1N9/KJOjH1Zlt412HQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W4wSDXjCEHkPRCh9FEM4BPTHvGoVNiybYWhJpr2T1lNR8TPb7Q0Rbwm/l6Qri6v/Kwr19DtGcjxHNRKgZixtHYOjEh88wOcPu3IlFqClhpnI4KCUaMfkI08Gkg1VXcGYJRISi/Ycv+iMbnZaEaqpWW6aUjtjPVhSKvpaGK5W9Ks=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ja/OZAPp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ja/OZAPp; arc=fail smtp.client-ip=40.107.159.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=px2IBDr/b0jpKpHLBRP85whVFuhRO+0L+CJu14ToU9B+a3FvJUD2+/vV59Z19MU2aY6kOvS7UJHcr0oWIaHxD+KnTn7ARXdD9J7talTfa0hY7Ek1RUtCFwHwHuTjQzaakvVDImK4U1V5l5YZvy5a2vaSDp/trRoJrNG42z6Dqk0N7BAUNyOa7rj+dIHamQeLv1dT4JO/gwgWfBd1SCdum2HJ+AQh4c+QALwHitargXvm5HnOmeLnVfcN9lGOU/mD30LwddeV4+SUB8HLDfUg2RGU1EwLp1rSsZLnbsuII+nfGTMZwT9BZAVJzH2uGtIGAL892QHvZMPRCHlrRuAfXA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ2l51NF6RtqZ15ZmiIjrZpJA1N9/KJOjH1Zlt412HQ=;
 b=gju+K/vsfvKzUns7J0ncl0RWIJQAPzPB6ZBGClMfOcgo7AWTONqEW+lwdPWITBI8dlX+y2+H+1VegvyPgRm5mYBjrh8o2Bb7KjMi1yT1HHXZkzngRH8SKDJI8xih7f6VPC+tmamXwFT2dy9yvcv6/hLl/eogg/8mvgLzAJLAGiMehg8zEqo4elWNUZO6ta1F+S78bJFZJyucSmB7I+PPotj6F5sGltsa/mbikZizvlTh1HEWCgo2I6UKF/6RlabfQxAZ78fb0OMyYUT8Oxs3e19G2r2prOyussk5AuHCEHUkUZLYrnMOT6XaL0VoMUe4u9d/ozlEpVzGXzkQHkvKIQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJ2l51NF6RtqZ15ZmiIjrZpJA1N9/KJOjH1Zlt412HQ=;
 b=ja/OZAPp+gK8+vfPCPwmRFULwQN3VmdSD5NUEJabk0ePQmjP9+eJUoUFGgB3DU7yfMdlkWCqv7kcUF8zdH8P2H80tWFN6TJE/QonLyYnq5zgDDZtk5GqB19ESIC5dXFOp8wPasHbbvHpl+0qX1uf66ywYmBZyaPMAa6jG3iLH+s=
Received: from DB3PR06CA0027.eurprd06.prod.outlook.com (2603:10a6:8:1::40) by
 VE1PR08MB5776.eurprd08.prod.outlook.com (2603:10a6:800:1ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 16:54:36 +0000
Received: from DB1PEPF000509F8.eurprd02.prod.outlook.com
 (2603:10a6:8:1:cafe::c8) by DB3PR06CA0027.outlook.office365.com
 (2603:10a6:8:1::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 16:54:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F8.mail.protection.outlook.com (10.167.242.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Thu, 8 Jan 2026 16:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GpwCZ441LmLraDbseUGXbcesRpdnosggVcnn22P1TkN+TXvha+5sYQuuuBOX52LVNkfPFrXpUrm9u4wL370MOkl6v3vb5YaSN+ehIIs0HpBtGdf0jJqPTf9RSevWXnvJgRaPRgvManOuCz9ksSKzdy3RdENINI0+NY7hJLgHLgP2Gi8RLVGrixQL8NNAUUFKLWRreQnp3kA3KgIRQY6g9iEWQt4lJKKhl2RUuWzitFNzp7Qb4Kj3qFe5u0ahHglgf6dhN4TZpx3Qhsr/liLudwOvk6W4sLRkfhgiTlElSxGX1xGmnHSnON+ZfXbsSD6mkR9Emotn44LvOIJ2RO9Ldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJ2l51NF6RtqZ15ZmiIjrZpJA1N9/KJOjH1Zlt412HQ=;
 b=C8AKlmcjzcknO/01F96LvrNEaYWRRGdUSPcXAMpw5w5I10GNnbT1INY53G+/Gz1DieTxpBJ4wfIxBpXVr5zyjTT1hd7zHpkIEJuwRk5Bis76NDEcw9KuUewNcaPiYqDKC4NqaY61b4q4rFPCPEUczRtDMQISCimB1kOlpfysOm2W0aAL5Ui//sndb448Vm03PPie7ju6gWRV/YdB4FE74Ca8G+P1pgZG5edZyyVoBUrnus6f9MQubXNsojD11P0A0k9UFWl1LyS2+6FGS216Z8yz3w7/Ifc/BQSK/yrv7nxCp7fvaMQ6b0MJXehyoxqLaZZehUvqqCI4c1EQsjW4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJ2l51NF6RtqZ15ZmiIjrZpJA1N9/KJOjH1Zlt412HQ=;
 b=ja/OZAPp+gK8+vfPCPwmRFULwQN3VmdSD5NUEJabk0ePQmjP9+eJUoUFGgB3DU7yfMdlkWCqv7kcUF8zdH8P2H80tWFN6TJE/QonLyYnq5zgDDZtk5GqB19ESIC5dXFOp8wPasHbbvHpl+0qX1uf66ywYmBZyaPMAa6jG3iLH+s=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAVPR08MB9377.eurprd08.prod.outlook.com (2603:10a6:102:302::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 16:53:32 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:53:32 +0000
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
Subject: Re: [PATCH v2 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Topic: [PATCH v2 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHccP+Dc9snDtO58EWYfGyuNDvZWrVG8riAgAGp7IA=
Date: Thu, 8 Jan 2026 16:53:32 +0000
Message-ID: <69d813ac306ac5fc81df2831750bb7381b0fc74a.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-24-sascha.bischoff@arm.com>
	 <20260107152905.00001d81@huawei.com>
In-Reply-To: <20260107152905.00001d81@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAVPR08MB9377:EE_|DB1PEPF000509F8:EE_|VE1PR08MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0b8bbe-f3f0-488d-b5d7-08de4ed69aef
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?NTZZV0N1RFJpa2JtVEl4MU0rcGhiTjdrenRRUkxHRDNFSDIxMWlmd3RJOGR6?=
 =?utf-8?B?K2FxdzNKTnZmVTVJbzJZR3ZHQjFsMVF6TlFaeU40OUtiK0dnRHArZmJLV3Z6?=
 =?utf-8?B?TTFKOGJnbjdOZnJJQUlqei9oMUdIc2Y0ZVM2ODRGYngxaENkK2hwb0pSMGEy?=
 =?utf-8?B?ZzAxN3l6T09uWVc5MjhZSE1IWmNiNCt1Sk5RYWlzNU9BNjREMmF0WG1nYW9K?=
 =?utf-8?B?SEFGTllXbklyZ1FmM2lTRHF5ekdtYlIydkdKYjQyb1pTdnZZMDg5NERBVlFi?=
 =?utf-8?B?RE5vcXIzNEdRbzRFZENoUHk2bTNRcnhCTm9McHlsUmtOakZ5Z25MZzVIbFJC?=
 =?utf-8?B?b1ZRWTBzdzlXUWJ5amlLcVozYmZ6dy8vNmVoYmE5Wnp6UnB5WEdwS2d2Y2J0?=
 =?utf-8?B?TjRGWUFtaEdxVkYwYzU2S042NWpySnF0N3lGakhabDVHNzBCZWF1T2s3MmpW?=
 =?utf-8?B?cTNNWXF0WVVRL3VRSGRGRm9LeXdnYnQ3R0xyQXJrc2x1ZVZiVTJyL2VlNGhv?=
 =?utf-8?B?ZjBpMkJMOEFNWksrMzBDb0xSbGR4dnhEcEtqS3ZEeGVudFF6Rkx6WWd5MWE1?=
 =?utf-8?B?S3hITy9VdSs2UjFRV0hvc0dUdWlQWG10MUNYbDR1YldPTmJ3U0h0bUxSenda?=
 =?utf-8?B?SDdCeGJlZXB0WkswdGtEaXFNZ1I4Z2l1K29JbXV0UHBJUnJYN2cvSGovZWND?=
 =?utf-8?B?eDZ4MlExY1JzQk9ablRORFZkR29jd1d6dUljdUxDM2QvWXhqbUxrM1lKYVc0?=
 =?utf-8?B?UTUyRXhFWmhtRG1NbEZKbDhvM2FVd0NnSnVvVnBvMlpyUm1QUzZCRUp3L2s4?=
 =?utf-8?B?dEtuSVhmeFh1MjlSb2NHM0xzQ05lTExoR2RxSHFydFpqL0lJUHBtRGZSayt2?=
 =?utf-8?B?Skh3UkhyRmEwYnNqWHE2Qi9rOHhVeVgreUtUZVZKbzFlMWZQSVZNWEV0Sm1B?=
 =?utf-8?B?TVpLb1BaMDQxZDQxRlV5TUJ6QkxwOW9qdk5zVXJibER0bzNMMlZycWtIclA1?=
 =?utf-8?B?OWdlNjF5UlpNN3MzV044VmVjVDZTaW9hV3VZWWVJTURqY2IvWlFGMDQ3QU9t?=
 =?utf-8?B?V2RhdWRTaU9ZaW1BYkhVbENnZjY3VDhtKzNQeHVyQklPdldjWHlXZThYVDBI?=
 =?utf-8?B?eUdNeVlXSlNFdmozc3huMFFQRzcrY2k2OGViRGVVY0NmdUdiY29SN01PbHZF?=
 =?utf-8?B?SUFDcFlPM0JJSG8vaEI5UkZRM2tPUnZkVzdGNGdDd1lwZ3MzYk5HWlhoWHJW?=
 =?utf-8?B?a1VjMTRMQWNQSzNnY1N1TWVDVHdUd2s0NmhuMWtoMjNrWHFpRUdBbU02djBE?=
 =?utf-8?B?NHBxeTI2K2tteEtaUDNNUWFMUDdQaENDUGJtSWhHUFQ4Mlc3SlFlSlVTS3RZ?=
 =?utf-8?B?UFBib3dhcHIvUjUvdVUyZFl6TzBERGNtUUNXekFTT0xMTG9GNjBmazY5OWFr?=
 =?utf-8?B?dWRZbEkzSitlTktpdGM4bVFsWERjbDEzbVBwWkxtRHp1UG1TS0xtNWxIclgr?=
 =?utf-8?B?QmJSWWtYSXhZQjFDem0rUkhCRlRhL0I4cnV0K29NeU1TdXpRdHRsVE5pa3l1?=
 =?utf-8?B?MWE4R1E1SmNzaHh6eGgwVHY0c1RHNEJmN21MMzdNZlZOaVRhTWJabG9DNVVu?=
 =?utf-8?B?UUh2dmF2K2w4ek91K1dMUWY2WlMrR1hoeFgrNWl4M2ozdkEwSFJ1cEdmYXMx?=
 =?utf-8?B?ZFB4S1g4TUpmTWp6MGwwbDlUdWJ1N3FEV0JCNyt2SDhNWGpheHJNVndIMkQv?=
 =?utf-8?B?bHhhK3dSQlJFZnQ0aXJ5cWFiTm5rVDB1S0dGTXFwTEhER1gxamQ5SktnTTA1?=
 =?utf-8?B?eDJ5RFYxVWhUVFdOZlJ5ZG80SDA0ZlZ0TzcrTzlaNVkrakQyZEtyOFBCeTdm?=
 =?utf-8?B?cU5hRDRHcHdRUmtRSXpqcEE3SEtwVkozWTVaWGlTcUthMUc2U01IVUtSNmts?=
 =?utf-8?B?Lzc5Y0o5SFpmMm1mSkltZzZtVGNmU25KTTcvTmpPalNFYTZFYThIQVVVaW0z?=
 =?utf-8?B?ZXVmam51U1NjRUkxdExCWmhzQ01QeTA3QjhZUlJLa1NmWDJjNTRWWmhqYU1r?=
 =?utf-8?Q?J3HD8z?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A39C36D17293D34A94273C263F8974FB@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9377
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5816fad8-2d08-46bd-d051-08de4ed674e4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|35042699022|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHRJSVIwdEsrdVVnRmpoNkF6b05Pc1JlREw3ZzNvSWg1R1NnYmk3bVF1TWhC?=
 =?utf-8?B?OUdvV1hpcFBlYjhRMVZpZ3RYamFwdmpyWk4xeHR1K0tuU0lHcEhCc2ZleWpl?=
 =?utf-8?B?THRaSVRWV050ZVRialJNaklHQW5zd1RFUGlPL1hwV2xQTHUxRkZxRndGMFFE?=
 =?utf-8?B?YUsrU2RLS0k4WEVrOXpObmJFL3NwbTJ4VjUySUQ5SHNJRG5DY2ZPNXZrUHM0?=
 =?utf-8?B?cHdyMmR6VC81N2FuNkVtZ1dZa25pKzB3bGJKNHdRS3ZRam1MOXFmR3ZkUFRW?=
 =?utf-8?B?NHFvbkp0VUp6VVdRQTBPVktSL2duMytmMUU3cm0vaFUwRjBOZWFQUVZ6YXRp?=
 =?utf-8?B?blVwdU1iei9xVjV5NitOQ2NBcHVlNFQwQ3pPRWR6eEMyTkd4V1BLTlFQY2lj?=
 =?utf-8?B?b2krNjB3eHBYT0swQXljMWlodG05NnpDbmZBdW1sTFcyODlHSUtOUThac3Qr?=
 =?utf-8?B?RDVlOVUyWnFzWTdaWUdsa0lRUngxN3RCYWl1elh5cjdZeGhIUUNVUVNHVnJk?=
 =?utf-8?B?a1h3bjI0eWdacXZ3NDFyZUo3cHk0aTMvY1BvVGpubnpLQlJvdElpWHVBc1di?=
 =?utf-8?B?cmlhZmNEWFFYMnRValcydmdDYXZPbGt2dDA4TFdrNEtLYlowRVh6WVpWdUxj?=
 =?utf-8?B?LytiOWpvejNBcERrU1hiQzRVTVRrY0hEcElDSVVoT0tHbm8wQVpjL0dwZjlQ?=
 =?utf-8?B?cXMzY0VLTEpHbFdGT21CMUVxcEw2SERSZmowU2Z2c0FRWGFsbmZXVzhPUU1L?=
 =?utf-8?B?cE5nNVBJeU50UmdjL2F4SzhtdmxJZUlDSlJUNmN4L0VoZXJKZUpFQ1RCMDZv?=
 =?utf-8?B?REFvRjlGZGtJbDNrbjZxRHd0MStGeEwzOFluQXM2MVFQRFE4djh0TzlXUUYv?=
 =?utf-8?B?TTlNWTdDLzNnWHlkTlRmSDc2WHpCdUkyc0dhMU40ck54T1lLc1l2NEZlWkc5?=
 =?utf-8?B?VjRZYVVqcGxCYi9Fc1JpYWR1Q21rRVVqclJzaGlkTy9rQkN1UUlhU250bEdp?=
 =?utf-8?B?L2Vmdmk4OWxXL2l4ZllZQW44Wi9sSjVGMy9iM1BBR1EyYUk2cDJYdUJ3VXBT?=
 =?utf-8?B?alJSK3FHYmFLdUkrNzMyM0V3ZXg0NlBqMExDUlh1U1REb1lLNzNRYnpRTnFM?=
 =?utf-8?B?L1ovZXJnU3hpcXJWT3VuL2lJYnpYUXdwYWp5UGhFbnY5WU1wU2VVeFAvaGZs?=
 =?utf-8?B?OXIyeHZaWHlkbFBUbjlQMlV3ZFlJT1MzeG91MkJSUFhodzRtNk9FWUFsaWlw?=
 =?utf-8?B?WlFPWFhUVGJSNzB3S2YwN3hxbDBMNEdIZTJvY25WWjBncUdVbks3ZjNMdnpu?=
 =?utf-8?B?Qko3T3VLRndnS0o4ZGdYVnp4RUp5WGZhbmRxVStsUVhjazI3aTF2bmpjUGZo?=
 =?utf-8?B?WVpZNXdvUXBlMWl6cEJSQU9sVS9kMUxRdm9lZnRoODVBdlNyd1lici9ISkRC?=
 =?utf-8?B?Z2xCRFdubHFqT2YyMnBUakc1QTFVRURkeVBVSldpdjRRY2FQd3doZWJoTVpG?=
 =?utf-8?B?eXBEWEVJMFJ2MW9DSG1naW5nM2czWkZ1QTlqK1pxcnI4dE1YeC9vazZpT1VI?=
 =?utf-8?B?K0F6ajd4T2R5Wm94NFBVbVVQOFk0cU9FYW5IQWplSFE5S016cU53ZkR1eEZ2?=
 =?utf-8?B?R1NJUmhERWtSVHFGWjFYVFkxTnk2VlBJMTh0Q29wWU1SUkxKSG9qK1FvY3JJ?=
 =?utf-8?B?UVN6YW4xaHUwcW9JY0tZK1V1NWl3NlFPNzFIRUdnZVF3NFJlTU1wT1UxTzhk?=
 =?utf-8?B?QS9yYitNZ01rWHFTczJ3d3JoV29HRDhETGxkU2NVRGgwUDN0aHBEV2daUUFw?=
 =?utf-8?B?TEN3U2x4MVVJZDZ3Vnh0Q3dwVHp5Sk5XbnpkU0xjZkduSjBZUG92YVBVVUF5?=
 =?utf-8?B?K3Z6ZFExR2hxZHJ3a2gxRWZoR2dzVWdTcHpCanpPeExkaldCckt6aUZ4b1pQ?=
 =?utf-8?B?SnF5WDExUW1rRjQ3RVZJaWExT3F5a01yK3d6ZFFkS0JERnlwTDMwQUw4bWdY?=
 =?utf-8?B?L29PL0h0aDVmSDNNbTZmdyt3aGswUEQ0UDZUaGNNVkdvemlhNTZuNHpUaWho?=
 =?utf-8?B?ci9iRUwraE9sT3VKUFVGNmFzMXpRUitwVGliQWZXRmJ5VVJwQ0YvMVppbHk2?=
 =?utf-8?Q?/qdQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:54:36.1453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0b8bbe-f3f0-488d-b5d7-08de4ed69aef
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5776

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE1OjI5ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjQzICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBJbnRlcnJ1cHRzIHVu
ZGVyIEdJQ3Y1IGxvb2sgcXVpdGUgZGlmZmVyZW50IHRvIHRob3NlIGZyb20gb2xkZXIgQXJtDQo+
ID4gR0lDcy4gU3BlY2lmaWNhbGx5LCB0aGUgdHlwZSBpcyBlbmNvZGVkIGluIHRoZSB0b3AgYml0
cyBvZiB0aGUNCj4gPiBpbnRlcnJ1cHQgSUQuDQo+ID4gDQo+ID4gRXh0ZW5kIEtWTV9JUlFfTElO
RSB0byBjb3BlIHdpdGggR0lDdjUgUFBJcyBhbmQgU1BJcy4gVGhlIHJlcXVpcmVzDQo+ID4gc3Vi
dGx5IGNoYW5naW5nIHRoZSBLVk1fSVJRX0xJTkUgQVBJIGZvciBHSUN2NSBndWVzdHMuIEZvciBv
bGRlcg0KPiA+IEFybQ0KPiA+IEdJQ3MsIFBQSXMgaGFkIHRvIGJlIGluIHRoZSByYW5nZSBvZiAx
Ni0zMSwgYW5kIFNQSXMgaGFkIHRvIGJlDQo+ID4gMzItMTAxOSwgYnV0IHRoaXMgbm8gbG9uZ2Vy
IGhvbGRzIHRydWUgZm9yIEdJQ3Y1LiBJbnN0ZWFkLCBmb3IgYQ0KPiA+IEdJQ3Y1DQo+ID4gZ3Vl
c3Qgc3VwcG9ydCBQUElzIGluIHRoZSByYW5nZSBvZiAwLTEyNywgYW5kIFNQSXMgaW4gdGhlIHJh
bmdlDQo+ID4gMC02NTUzNS4gVGhlIGRvY3VtZW50YXRpb24gaXMgdXBkYXRlZCBhY2NvcmRpbmds
eS4NCj4gPiANCj4gPiBUaGUgU1BJIHJhbmdlIGRvZXNuJ3QgY292ZXIgdGhlIGZ1bGwgU1BJIHJh
bmdlIHRoYXQgYSBHSUN2NSBzeXN0ZW0NCj4gPiBjYW4NCj4gPiBwb3RlbnRpYWxseSBjb3BlIHdp
dGggKEdJQ3Y1IHByb3ZpZGVzIHVwIHRvIDI0LWJpdHMgb2YgU1BJIElEDQo+ID4gc3BhY2UsDQo+
ID4gYW5kIHdlIG9ubHkgaGF2ZSAxNiBiaXRzIHRvIHdvcmsgd2l0aCBpbiBLVk1fSVJRX0xJTkUp
LiBIb3dldmVyLA0KPiA+IDY1aw0KPiA+IFNQSXMgaXMgbW9yZSB0aGFuIHdvdWxkIGJlIHJlYXNv
bmFibHkgZXhwZWN0ZWQgb24gc3lzdGVtcyBmb3IgeWVhcnMNCj4gPiB0bw0KPiA+IGNvbWUuDQo+
ID4gDQo+ID4gTm90ZTogQXMgdGhlIEdJQ3Y1IEtWTSBpbXBsZW1lbnRhdGlvbiBjdXJyZW50bHkg
ZG9lc24ndCBzdXBwb3J0DQo+ID4gaW5qZWN0aW5nIFNQSXMgYXR0ZW1wdHMgdG8gZG8gc28gd2ls
bCBmYWlsLiBUaGlzIHJlc3RydWN0aW9uIHdpbGwNCj4gDQo+IHJlc3RyaWN0aW9uDQo+IA0KPiBJ
biBnZW5lcmFsLMKgIHdvcnRoIHNwZWxsIGNoZWNraW5nIHRoZSBsb3QuIChzb21ldGhpbmcgSSBh
bHdheXMNCj4gZm9yZ2V0IHRvIGRvIGZvciBteSBvd24gc2VyaWVzISkNCj4gDQo+ID4gbGlmdGVk
IGFzIHRoZSBHSUN2NSBLVk0gc3VwcG9ydCBldm9sdmVzLg0KPiA+IA0KPiA+IENvLWF1dGhvcmVk
LWJ5OiBUaW1vdGh5IEhheWVzIDx0aW1vdGh5LmhheWVzQGFybS5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogVGltb3RoeSBIYXllcyA8dGltb3RoeS5oYXllc0Bhcm0uY29tPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IFNhc2NoYSBCaXNjaG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+IE9uZSBw
YXNzaW5nIGNvbW1lbnQgaW5saW5lLiBQZXJoYXBzIHRoZXJlIGlzbid0IGEgc3VpdGFibGUgcGxh
Y2UgdG8NCj4gcHV0DQo+IHZnaWNfaXNfdjUoKSB0aG91Z2guIEkgaGF2ZW4ndCBjaGVja2VkLg0K
PiANCj4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFuIENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVh
d2VpLmNvbT4NCj4gDQo+ID4gLS0tDQo+ID4gwqBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5y
c3QgfMKgIDYgKysrKy0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS9hcm0uY8KgwqDCoMKgwqDCoMKg
wqDCoMKgIHwgMjEgKysrKysrKysrKysrKysrKysrLS0tDQo+ID4gwqBhcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMuY8KgwqDCoMKgIHzCoCA0ICsrKysNCj4gPiDCoDMgZmlsZXMgY2hhbmdlZCwgMjYg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiANCj4gDQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMNCj4gPiBpbmRleCA5
NGY4ZDEzYWIzYjU4Li40NDQ4ZThhNWZjMDc2IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gvYXJtNjQv
a3ZtL2FybS5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMNCj4gPiBAQCAtNDUsNiAr
NDUsOCBAQA0KPiA+IMKgI2luY2x1ZGUgPGt2bS9hcm1fcG11Lmg+DQo+ID4gwqAjaW5jbHVkZSA8
a3ZtL2FybV9wc2NpLmg+DQo+ID4gwqANCj4gPiArI2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJt
LWdpYy12NS5oPg0KPiA+ICsNCj4gPiDCoCNpbmNsdWRlICJzeXNfcmVncy5oIg0KPiA+IMKgDQo+
ID4gwqBzdGF0aWMgZW51bSBrdm1fbW9kZSBrdm1fbW9kZSA9IEtWTV9NT0RFX0RFRkFVTFQ7DQo+
ID4gQEAgLTE0MzAsMTYgKzE0MzIsMjkgQEAgaW50IGt2bV92bV9pb2N0bF9pcnFfbGluZShzdHJ1
Y3Qga3ZtICprdm0sDQo+ID4gc3RydWN0IGt2bV9pcnFfbGV2ZWwgKmlycV9sZXZlbCwNCj4gPiDC
oAkJaWYgKCF2Y3B1KQ0KPiA+IMKgCQkJcmV0dXJuIC1FSU5WQUw7DQo+ID4gwqANCj4gPiAtCQlp
ZiAoaXJxX251bSA8IFZHSUNfTlJfU0dJUyB8fCBpcnFfbnVtID49DQo+ID4gVkdJQ19OUl9QUklW
QVRFX0lSUVMpDQo+ID4gKwkJaWYgKGt2bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4gPiBL
Vk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUpIHsNCj4gDQo+IE1heWJlIGl0J3Mgd29ydGggbW92aW5n
IHRoZSB2Z2ljX2lzX3Y1KCkgaGVscGVyIHRvIHNvbWV3aGVyZSB0aGF0DQo+IG1ha2VzIGl0IHVz
ZWFibGUNCj4gaGVyZT8NCg0KQ29uc2lkZXJpbmcgdGhhdCB0aGlzIGlzIGhhbmRsaW5nIGNvZGUg
Zm9yIGludGVycnVwdHMgb24gQXJtLCBJJ3ZlDQphZGRlZCB0aGUga3ZtL2FybV92Z2ljLmggaGVh
ZGVyLCBhbmQgY2hhbmdlZCB0byB1c2luZyB0aGF0IGhlbHBlci4NCg0KU2FzY2hhDQoNCj4gDQo+
IA0KPiA+ICsJCQlpZiAoaXJxX251bSA+PSBWR0lDX1Y1X05SX1BSSVZBVEVfSVJRUykNCj4gPiAr
CQkJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArCQkJLyogQnVpbGQgYSBHSUN2NS1zdHls
ZSBJbnRJRCBoZXJlICovDQo+ID4gKwkJCWlycV9udW0gfD0gRklFTERfUFJFUChHSUNWNV9IV0lS
UV9UWVBFLA0KPiA+IEdJQ1Y1X0hXSVJRX1RZUEVfUFBJKTsNCj4gPiArCQl9IGVsc2UgaWYgKGly
cV9udW0gPCBWR0lDX05SX1NHSVMgfHwNCj4gPiArCQkJwqDCoCBpcnFfbnVtID49IFZHSUNfTlJf
UFJJVkFURV9JUlFTKSB7DQo+ID4gwqAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCQl9DQo+ID4g
wqANCj4gPiDCoAkJcmV0dXJuIGt2bV92Z2ljX2luamVjdF9pcnEoa3ZtLCB2Y3B1LCBpcnFfbnVt
LA0KPiA+IGxldmVsLCBOVUxMKTsNCj4gDQoNCg==

