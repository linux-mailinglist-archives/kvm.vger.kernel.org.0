Return-Path: <kvm+bounces-67606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABB3D0B8E4
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46AE23132C93
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1F636829F;
	Fri,  9 Jan 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CBQ63efr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CBQ63efr"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011039.outbound.protection.outlook.com [52.101.70.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3590366DAB
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=SfJLb2oGUtWRWVy246YvJfeYBuDm+7aWn8dtnSRxF2tKV0I1vTuQPdncITac36JlNefmdN1bSo2d04viRBvzAz4dlVCDdQJwKiLLFSHTN2yBwM6/coJ79wvUR5ggYegUgy2KyKeBXzNf4E8RvL+E5QyMfzC+k2KxzB6uKWr3Aoo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=LysQhcJRD1Jv+dqNxzizwL2ffpkfk3hby/j55wYoeDo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HoeQAHWFk8ttirT2OWguAfqTgF3vS6/lwtcAuBT2kVo+MwwVjQ9pdRkbgTI+lt2KYUPc6dz2q5oaI8RKgI+JpK5JW4QWXKCpfJYAAERMYbJ0XPA+kTgOD5u0Hccf3rOuUL/mn/gB1aT0uE9/79qEq2jBxUQH9blMqSQDatESzis=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CBQ63efr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CBQ63efr; arc=fail smtp.client-ip=52.101.70.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=CMlILslshIAf2NLeOSFoUFrrTluAJz3hxc1UI+R3oUxKlHedu/a3WWQlalaiq7eH3Imr5CTQJcAhbmdIjkb5M4FTo8WT2s0OhcmeT3eeSvLSGxydv5Qlq1ZoebNzH0AlbTxyqW0yx8VuZhKS22UDdN0rBZdqWoYcYul7Ek6f+QyogQWNfKnhhZaY+b1fNRtlc7Vw1JgT12TK+9YgwJA9SZcAA+OQaN7M/OgKLIpDxWb+ZNAruKY4pcKzEB4pIMwQ75u2KyQxBFQtN0AUZlEPhpKNw6Vy/rIgF7FDGnioCVZsBhKmPyB0KaYIEL//3DJXeJOqWogMekkToCFb4Lj7Aw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/87Z4367VAjMBAWmjgH7JxVh+/+9x8Heg1AVOOEpIY=;
 b=uE6FcVZedH8KiqJfNyKr6CbOP2gpgEDn6JDNQqZMOEIWZ6t8M+aypEWOoT8cKONse/nkRPMCnJDI924LdHUHXy2cl4hNGydibnvUEtgpQAue09hT2Uvb3ugbzb6EiP6tfZSZ1Gd2LGboqZ9A1xqIofdcS26e2sHExEdEzk5EnErdZymEZCk548J8uIJuen7fNT0j+axEAHUM7In/39AjiVPVPJufZD63+Zayi6eEl1rRPr/Qd3Vh8RJVKYmg+mwBXgWtV+qUD5go5B66zKScYRYamEafPiX+MyeqyuKzsA00BfHOAqr2rp9D84eOebo3GbAqW8b5hNmGZhys0z1X6g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/87Z4367VAjMBAWmjgH7JxVh+/+9x8Heg1AVOOEpIY=;
 b=CBQ63efr76hCnRpPjrv6OnSRccj9zubS+ltv2WEpcgUcJsYobinttzD9zd5DgNldAKxHTKei26NSt9hqMe9Mhcd1gSvGvHotxBg/bGsbM46poKOD3hdUAba+tHeA3QORPbtYkERvNY4kEuWvH09Kt2wPK4KoxI58J8xgbK2o3nU=
Received: from AM6P194CA0025.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::38)
 by DU0PR08MB8494.eurprd08.prod.outlook.com (2603:10a6:10:405::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 17:05:49 +0000
Received: from AM3PEPF0000A797.eurprd04.prod.outlook.com
 (2603:10a6:209:90:cafe::de) by AM6P194CA0025.outlook.office365.com
 (2603:10a6:209:90::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A797.mail.protection.outlook.com (10.167.16.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ro7pyjyl0b2u0LDcRFb8xT3tLYzaTqmkqWQn1F77e+QjwySNtnaLDKDVijcRknteukbwEy5GNlNCoPCf5ZjV9+2TvJqgdg4aGxKXCzjrvFEn48hPOCbqNT8UxdqUSfCrheynzrkb9KZCfw8RAPsHxAE/gVzvz9IfylCz0D3oPbfKVJO+6x3lTGnydcIF/BaiNJjLOLfekXFi+KGi8tElMpWr1YxFYkGVWmu7FNszfrd9Mz5owl2KbJbm+gmW9P7I1TKbkylcfHViYNy2p4B8HnJs956nlZALSNh3cOECA8J9XLsONUo3FfuiKz2QByJTxCe6PBZKbQE4XNP2hE7DEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/87Z4367VAjMBAWmjgH7JxVh+/+9x8Heg1AVOOEpIY=;
 b=B0BRXuNVIaXUVetwFuJ69m1KmFoMywrkTJCCjhi9BiUU8bsIMOowd90CWsTlSyAvBPLsPfMWX1DddISOoiz6S7qm5fjKkFaS63uewHy1mJVl17RHCRgNlT/QSvZRJHEtka09i09vC6Ud5mqctwoY+Y02TY9WcmErFSZpqaxWV+eCaZ20UkXTg7+Vf7ditrt8dcw8iUnWliLOlwAcd119VcwVHXqcLRSwJVg1/tS6+OmzMyb5izQDkPuiaikajtKCEcbWQHnWY07B78HbvePce8haqd0coTTShigpmHRfBhbr73gQ2GDFjY+eY6PZnPTq5E+lNUaSFfNn1JSDOqqAVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/87Z4367VAjMBAWmjgH7JxVh+/+9x8Heg1AVOOEpIY=;
 b=CBQ63efr76hCnRpPjrv6OnSRccj9zubS+ltv2WEpcgUcJsYobinttzD9zd5DgNldAKxHTKei26NSt9hqMe9Mhcd1gSvGvHotxBg/bGsbM46poKOD3hdUAba+tHeA3QORPbtYkERvNY4kEuWvH09Kt2wPK4KoxI58J8xgbK2o3nU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:46 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:46 +0000
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
Subject: [PATCH v3 18/36] KVM: arm64: gic: Introduce queue_irq_unlock and
 set_pending_state to irq_ops
Thread-Topic: [PATCH v3 18/36] KVM: arm64: gic: Introduce queue_irq_unlock and
 set_pending_state to irq_ops
Thread-Index: AQHcgYoN35EoESWAoU+xmzaiUw+ldg==
Date: Fri, 9 Jan 2026 17:04:44 +0000
Message-ID: <20260109170400.1585048-19-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM3PEPF0000A797:EE_|DU0PR08MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: 556ec619-cf32-46d4-1bb5-08de4fa15667
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?On286VCPZOH8gQfd66TqmTBGal3JZGY74KJd1TPOS+bE5oKWwsapRPHwQp?=
 =?iso-8859-1?Q?3sMk7IJlfteq4Cf5IEqdUcINpJFelJjKjMwUZOP87B/jGeywvb07+k3lR1?=
 =?iso-8859-1?Q?Yr0QoWCLdorBwFA8bxfdhR2eVlTze02vYJASHBp5S26+mE5FLdIRPSUvqz?=
 =?iso-8859-1?Q?MPvap+3XjeeAYCapvVVT3LkGD0TEe+yzm29VBP7Wr/Btjl018I/G874+YU?=
 =?iso-8859-1?Q?sEIO0a3XRp9iCPvVoaqOvYjtYlm+9v/LZXhj3X0itXNWsJePtFNNhhBfty?=
 =?iso-8859-1?Q?/wS0ZC1Kiw8mgPjjuxuDiyR8wy4vGjepsbpSCIAKbDBNfDLyvgQSrRAh50?=
 =?iso-8859-1?Q?k6SpCBnmFTmnjYxjMeKl8eu2JcD2ZCUEnSQyXnu336r0UD1Kk98ylSYdIW?=
 =?iso-8859-1?Q?CeayMK8pRI+stKFCQJh0PO9Px+VeN26cN65Z+E865degURXCQlMTuLWMOR?=
 =?iso-8859-1?Q?ooA5puuBmBJARQNOtJVdSDXuC4dgmrBKtxgy2Fums/cvXsaTpZqpcbNbLC?=
 =?iso-8859-1?Q?a8AXQiq7vJnuqaHblDdMe/v3ZqOzsEgHaJK0+tzCq+FjMvmpkMVddtxsf9?=
 =?iso-8859-1?Q?jrXSSjG1lepCkajUchOrTF3gbk6eOIco6+DOTZI0lPOWLi+gn5J5OCbEIH?=
 =?iso-8859-1?Q?2oRaoT5hQzEc5EIJQeNA4aJv+YEUEojsK2FF7NzvZ9q1ilBySnt9IdLwFX?=
 =?iso-8859-1?Q?uICtxuhdY4sRLwPNwjrKZyFjRIbuwpyyzpA5WIQzYUocZaa4gVzZfQVE+s?=
 =?iso-8859-1?Q?NnwMt9O7y53fQm/MSJqssQW1O8s4TcUY8a4RH2r/jB5kwPSQh0O4nvyy0O?=
 =?iso-8859-1?Q?IaAx/cs19xULgLs9FvyFXkP8wm3W5EVGGFnPPlOmxR/rIQuJSiMgHz6q4S?=
 =?iso-8859-1?Q?OpKP9lGuFWcxfK+8t8nS8TuRwJSpeqJsmNTF4VC+fzavog24TS0DyZ/S8y?=
 =?iso-8859-1?Q?uF5RDjUGgwX95k8yi9juTNxKrUIEk0Ytxb35LuDW0fmyS+cYU698lIdA6q?=
 =?iso-8859-1?Q?QEtldwC+Fp4kVw/DycSA+evS4Z3atsg55VsMBkXwJt0W6abBYR2lrcIVsF?=
 =?iso-8859-1?Q?FoHXiEKm84iF9dCJd9dzkDEi21Ix82fjzeOnGjBEW6KGsf81qTf5hDXy06?=
 =?iso-8859-1?Q?89NXZvS8qhmSm3r1NKATGLE1xsj47JfSs8117//tnEgzqAZSgh9rFgKem2?=
 =?iso-8859-1?Q?vClD3/TxFeOWxhqXZ+zrHdAX/0DQc4JHGt18ew73ekLzKPufxgTieXh0IX?=
 =?iso-8859-1?Q?sF7jym1RvcAcd4FR060Kszk7zG3wcalLVs43pfDsnL4K6wsg815QsZE0lF?=
 =?iso-8859-1?Q?tnnB/1tLc8xzqkfPSUGLutUjkZVl9KNqv/PRqUi/fTR/5Zqds0FuiFCnaa?=
 =?iso-8859-1?Q?z+X5OYxfju0sdBehrO5uw1A6jsR4lCVKIUaiUth4eJDLb05xr+CT0/oP8d?=
 =?iso-8859-1?Q?ZqN2gEz2h0iucDQacbDTET8Z3lUUGNl204xvxhF/NTXmpUi8ExkN1WAjJr?=
 =?iso-8859-1?Q?ubeFeh3irlzH7xdlMZlyen9dytfwh+k49IpASlzm+nbs1NGh/+RS/8CVfu?=
 =?iso-8859-1?Q?VXYKPTtwY1oJf8CfT9lzDKGKSB6U?=
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
 AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25658f5b-ea27-4cde-d892-08de4fa130e4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|14060799003|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?MPV0TqARfynLgAOPRyds+jtUITKXURK1dDudpv497Mqzg4xM+y/tX+/N2X?=
 =?iso-8859-1?Q?k7M5uqw+wgT4TBr4ELOjpsJV21dHkMb4GKpL2VSMdWGYnFhJHIrWhxDIHN?=
 =?iso-8859-1?Q?qyG335yMwoydinzjo34pjAASLCkKuqqWKcFDa+I7eicPD2iIMEfjpapwnk?=
 =?iso-8859-1?Q?Kwz5FULyWK0yyedqGsMO61s8b/Y4SrwVrASxHe9h3AO/0bKulxVVvHFoKj?=
 =?iso-8859-1?Q?l8VcsPKj5nDOZB7YyRb+D6x27zD82Wzw2WqdShGNwRpqFZJhRuYNhwVa6z?=
 =?iso-8859-1?Q?rM3gJgmXafKQTiO5olVRJaI/lb+fy++I8B9EUwYqm3EpRyAPaFOmhEET4C?=
 =?iso-8859-1?Q?huIflpKBkvB0NuKFIxM9Kwxu40l3MTlettTcdCLi8Y6rIfSRNyJUUSOqIp?=
 =?iso-8859-1?Q?h9yXNXcyUtLoDTGHtbIV2rh8AYaxU10cjLFb1f2Du3lXwWo1gHax3R4cWm?=
 =?iso-8859-1?Q?jFmetUworbA6+Pbb61x28Zn/OnXVoRbJCNDpEAWOoxL8QJPnXpaInW5zGU?=
 =?iso-8859-1?Q?3gT9epmHQVL3Cuu0+pN3W3MCF+ug/zKfRx6kCsW/oau5ADLGmIdIN2ZvCc?=
 =?iso-8859-1?Q?X279N0ghYBDzR21tXC4/1MBM70KXcBGvVW3Xb5IRRR7NSAXmo59ZBw1FAN?=
 =?iso-8859-1?Q?HtRFtk+kzWy5Fm42HflU624YlxX3eTHza1Pan3qInZ78ArP3qjHjihkzK9?=
 =?iso-8859-1?Q?riWolBkVWYoEQ0Oo6Ne7MasJSSM6ZF+HICMVV1b46pm7aMEAyao17ByGB3?=
 =?iso-8859-1?Q?aVCk+DeKsPh1SacRmJvqDSWPCr6gBMpFAv3Fc3Y4AtTuuXeCpIilRasA2C?=
 =?iso-8859-1?Q?KuBb1wPDc23nK/ss9wMomKju6lcsI/gskO+8dxC7IpO4EPfVsAacIejaQO?=
 =?iso-8859-1?Q?xKzRVfV6ZEpI+O9rdbwQoyt8A6sVkJxdXnW16CoPoKuXLXv6eBEPEumCN5?=
 =?iso-8859-1?Q?xeNX3ZnBH2r6XAeNQmeKQljFEP9qML/fSAUMARFFmDabxuJfhr06WOclNS?=
 =?iso-8859-1?Q?ZKOmaswH93DCdWB074Kh/B3Q4p4SETkQ8sRY6c9OcHwPY2CdVVa23Hksl1?=
 =?iso-8859-1?Q?DNmvOrWqH5JZJVBkQrfRM0GcpBLbsb7vOx63tqnC44SzJA5ff61uAI1pbp?=
 =?iso-8859-1?Q?0dFvBaA2hZwM/L9NZb90j9J82m9Gxdty78RHj/qQCG1VVL5ShMVgxp1y+g?=
 =?iso-8859-1?Q?08zzpep0XyKVXzjNylIIgwQgzOjX51ebHohhpccGu/Nt58FKaRQxkEYwh0?=
 =?iso-8859-1?Q?+j0YvLTb4alPsKKZ4i5+0Udc/dPg94Yi4BKOIej+XP6npbdMwGwS7pC+Pu?=
 =?iso-8859-1?Q?Cbb7Rxr7HYc99InP432Ss6PXjSrwd420dsP2dxA4ijeTk/dgMCXTA8l1C2?=
 =?iso-8859-1?Q?a/fVfCdpMROEgPqnQewE8Epl2u+z81vIdkkvOEw6iYvfk+R+Hztyzyuloh?=
 =?iso-8859-1?Q?Z1DTBRRm60oEhNR/EwkYrh6p2XubiZ+qwx8JkKVWprP1dCW87T9ljT5UoV?=
 =?iso-8859-1?Q?KywViqZLbcrX/dXFWAF9O5RkGa37N8jO7wDywOdZAqjoISyO6p5CA3W9rk?=
 =?iso-8859-1?Q?1V6KS/Y0FEm+YYu9tDo/F/FLoNRxKYMyWhCif76tRG3Sn9zceAk3/swHz5?=
 =?iso-8859-1?Q?Ip7RcPlLldq8g=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(14060799003)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:49.0189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 556ec619-cf32-46d4-1bb5-08de4fa15667
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A797.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8494

There are times when the default behaviour of vgic_queue_irq_unlock()
is undesirable. This is because some GICs, such a GICv5 which is the
main driver for this change, handle the majority of the interrupt
lifecycle in hardware. In this case, there is no need for a per-VCPU
AP list as the interrupt can be made pending directly. This is done
either via the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND
system instruction for SPIs and LPIs.

The vgic_queue_irq_unlock() function is made overridable using a new
function pointer in struct irq_ops. vgic_queue_irq_unlock() is
overridden if the function pointer is non-null.

Additionally, a new function is added via a function pointer -
set_pending_state. The intent is for this to be used to directly set
the pending state in hardware.

Both of these new irq_ops are unused in this change - it is purely
providing the infrastructure itself. The subsequent PPI injection
changes provide a demonstration of their usage.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic.c |  6 ++++++
 include/kvm/arm_vgic.h     | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 62e58fdf611d3..c465ff51cb073 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -404,6 +404,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic=
_irq *irq,
=20
 	lockdep_assert_held(&irq->irq_lock);
=20
+	if (irq->ops && irq->ops->queue_irq_unlock)
+		return irq->ops->queue_irq_unlock(kvm, irq, flags);
+
 retry:
 	vcpu =3D vgic_target_oracle(irq);
 	if (irq->vcpu || !vcpu) {
@@ -547,6 +550,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_vcp=
u *vcpu,
 	else
 		irq->pending_latch =3D true;
=20
+	if (irq->ops && irq->ops->set_pending_state)
+		WARN_ON_ONCE(!irq->ops->set_pending_state(vcpu, irq));
+
 	vgic_queue_irq_unlock(kvm, irq, flags);
 	vgic_put_irq(kvm, irq);
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 50f5e3ffda6bd..4d6791c1ae55e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -173,6 +173,8 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
=20
+struct vgic_irq;
+
 /*
  * Per-irq ops overriding some common behavious.
  *
@@ -191,6 +193,19 @@ struct irq_ops {
 	 * peaking into the physical GIC.
 	 */
 	bool (*get_input_level)(int vintid);
+
+	/*
+	 * Function pointer to directly set the pending state for interrupts
+	 * that don't need to be enqueued on AP lists (for example, GICv5 PPIs).
+	 */
+	bool (*set_pending_state)(struct kvm_vcpu *vcpu, struct vgic_irq *irq);
+
+	/*
+	 * Function pointer to override the queuing of an IRQ.
+	 */
+	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
+				unsigned long flags) __releases(&irq->irq_lock);
+
 };
=20
 struct vgic_irq {
--=20
2.34.1

