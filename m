Return-Path: <kvm+bounces-65996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 18BF1CBF419
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D131F301102A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2C83242D9;
	Mon, 15 Dec 2025 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D5zo+eZU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D5zo+eZU"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010031.outbound.protection.outlook.com [52.101.69.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5C1310629
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765820306; cv=fail; b=SpHLqf1483i4X4qaowDYJXcCg9BOC9PLRgXYrqjtTX5HbbLV0DbZnvVWlpDac4GySMZE7wL5wk1VWrGrbYFjhomR8IIuI2TI48TUaCQquP0pS0WRX+W7NkOp3b4QhpVWrIob5K8B2DnPCJJUsmtJzJqqj1w13lQFWdvfHCuLH9Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765820306; c=relaxed/simple;
	bh=SLpolXIxK7UxAtpKDDc0bXN04FSy/NEYqUBG9GNyjzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L0j0e530V1gvQiZ1ioOcyosIJPQSJk4Z0HJMClVkDAGwO/GfYJktxlW+xrsslnWWLfW2XDfwtweMa22j2aL5P1vRP4i/nS/i6Y4JI9PjN6HVFx95HVkuEHVhjXZYd4LhmyasGuPLeQmHrf982YLyXuNyWJ8vyJTBI520bsb3wYk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D5zo+eZU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D5zo+eZU; arc=fail smtp.client-ip=52.101.69.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=P0hugj49o1YWl3jm9rGvZUPWJ2JEIJ3a5Zut/7/RdpOSFpk2nI7ppCgl+ScGz5r8go0Q3/9ZWT7XojO4lxCqi8UnzbsR4HYNqsBkSS0ptu485q1xWlXf7JOSL/Jw4TVJ1+lVN6CceT1603mw113mswVEGGxDTBJk/saHIyc7aS3skY+nnOD6XFzuWa4M0aMOfmwtNHfw64zzIHO6uYyUBuHj5+lcPQcMR2YzyzR908zTECOfHcMrLmJjn5dJ1jR4IhIyi2cBpqXIESMtmhd1LUSyTyA/vp0E2AoXzpCcHYflUlqW5BiIMGSrD6+SUkWzD3JRwLz9MFSsgUKfeQJFcw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLpolXIxK7UxAtpKDDc0bXN04FSy/NEYqUBG9GNyjzk=;
 b=l96LF32EAQlwj+O/0Ic82oscgsq5e+6IIgqCcFoMZcSv/JjhBF1Lsvv1Rxhlm29m+OSIHedaYOJ1OS7oZ+tV74B7q84ACzz9vdBgbtnF6DE+9D9a9M2uKllhJLVsVQ0KzoWMFTfoXpruUM69TtMVQmZvi/a3kkYU4mi8iiNWIhCPaa8tnN1kT0ItiXb43Rl2qMTmAvxV8rqN1+2oMpdMH9geSK4LwSY28NosaUo+urV61dFsVHYVEJhodD5yskM2cyUVl2oBjqdvjxF8XgUBHjuLIeJ9ZurGrUETGu4gWP+vb7Hz/mgrM3FA+TwEBWCTrAaSfj6NSBSu9G4UY+iOBg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLpolXIxK7UxAtpKDDc0bXN04FSy/NEYqUBG9GNyjzk=;
 b=D5zo+eZUqq13knQi9p+4yjzuKHrl4iWnL7BVF3D6MkG9PwukKAY4SncoW1dxvtx7ZiswL+KAgFAhzZxsbTXk5h2Y14eIE6uoA6RcRXFBvMUXkIC8tTXZylRhpJrIPHZaUZVWO2c/amtYIQpbi3LKJWpoiL1QrGQYiazJebCLYK4=
Received: from DUZPR01CA0180.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b3::14) by DB9PR08MB8722.eurprd08.prod.outlook.com
 (2603:10a6:10:3d2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 17:38:20 +0000
Received: from DU2PEPF00028D0F.eurprd03.prod.outlook.com
 (2603:10a6:10:4b3:cafe::26) by DUZPR01CA0180.outlook.office365.com
 (2603:10a6:10:4b3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 17:38:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0F.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Mon, 15 Dec 2025 17:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oon9fTu5S812GFnCHW7rLn5KaHcL2mBMd5QR7khTipuB/bYarTc17P4TJBnWIMD4joauYFF+Sj/1od0jI5qQYk9lPxsxqN0TX5uItk6r6r8KqXI3v3hqWWjx5aDkjGtkq+FOBWXUwgVTkcj2x8OlzEcJV+FG3MMf7Ux0f+MVzCVqKdYHv66pKvf/WFtx+VbswtR6eeCx72xrjTnSmY10T3BTilHekWa3RQwZaCzeimu9YeEtHkhzc821ARMm9QHenZvuzM6UMlyvFN8SJ7EXZKLwtOAgM3jvCcFbTCVb/Cefgddm9g5Ul35S3apDfui7ydCTvnK/LC7EKCOcRPTSXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLpolXIxK7UxAtpKDDc0bXN04FSy/NEYqUBG9GNyjzk=;
 b=D5NHZfs5CfBf0J4VoKFYvSCWh/cHDuqWQUbzo1msxsYriBGXVf5K8+vlQei3hWhzy5zAgtVWriWVaeiAPRL/MfkePpXmNZoxfZ9d/nAUXSp/lGlZUNAe8jkWf83NIAPd7Q2ZmUcnFR6ozZMY4KX18EwWZxzGYJDsoYEfE/LGqJ02GCVpROK3r+lYlDCP80b5LSHxbEu8UGpAsJWBZcyIyqfg5ef6xCSG5K6nz/DbrbLnCdC7CHBkm45BvfhCVVUcppq+p2o5kREXhMrohvHX8T1tj4utoBBSZuolMNHL/+K36+5x6xDO45IMwv49QUvaOs2zMFzKsntC6vlwHPv1jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLpolXIxK7UxAtpKDDc0bXN04FSy/NEYqUBG9GNyjzk=;
 b=D5zo+eZUqq13knQi9p+4yjzuKHrl4iWnL7BVF3D6MkG9PwukKAY4SncoW1dxvtx7ZiswL+KAgFAhzZxsbTXk5h2Y14eIE6uoA6RcRXFBvMUXkIC8tTXZylRhpJrIPHZaUZVWO2c/amtYIQpbi3LKJWpoiL1QrGQYiazJebCLYK4=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GV2PR08MB9950.eurprd08.prod.outlook.com (2603:10a6:150:b9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 17:37:16 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 17:37:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 09/32] KVM: arm64: gic-v5: Compute GICv5 FGTs on vcpu load
Thread-Topic: [PATCH 09/32] KVM: arm64: gic-v5: Compute GICv5 FGTs on vcpu
 load
Thread-Index: AQHca3smCJPVvLo5RUaFm1cfrYqWoLUeMIIAgATLbQA=
Date: Mon, 15 Dec 2025 17:37:15 +0000
Message-ID: <d858ab5e484032ddb903cd8c6d0031af798e41ba.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-10-sascha.bischoff@arm.com>
	 <86o6o3oehl.wl-maz@kernel.org>
In-Reply-To: <86o6o3oehl.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GV2PR08MB9950:EE_|DU2PEPF00028D0F:EE_|DB9PR08MB8722:EE_
X-MS-Office365-Filtering-Correlation-Id: bd4045c4-8db9-43ea-dd27-08de3c00bcc0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?U1dteUIwdGVraFBwMDJ4UXJZSXBzbEhBakU4cnZBOGhyTkFNbnZwd3FFMUpP?=
 =?utf-8?B?cnBKY2tlcHYrLzNSV2h4UjZWcE1ibmlieStQSFBVOUVhMGhYc01qV3huZVhI?=
 =?utf-8?B?azNudkVoQjRCRXNOZVo3cmVGUXJjc3BNTUxQWHd6UGhWMFpZR1I2dzVRcmU3?=
 =?utf-8?B?eW5jSmx5bmdBcnJOSzhGenlZSGlNVCtIQ0dCWnl5YlVZc2F3eFNmcHR4WHd2?=
 =?utf-8?B?a0JDbFNlbnl6RVpsRm5IWklpYUJ3ZnpadTBoWm5jRHlYeUlBWHlDeGErOVB4?=
 =?utf-8?B?STY4WU02c1hwNTU3UjhyTnQxZm1CQVZKdHhhaGt6OG5KemhBaUh1YUFHSU9U?=
 =?utf-8?B?dE5UMUpjRjd0akZiZ0ZraTcrR2Ixb0VadUpDS0xoY3RnbGpnNUhBZkRQdUhM?=
 =?utf-8?B?ZWlBdWdNR29hVnFsRUJGOHgzbmhYUFVwYXZsaEJ4eTZHLzEzbElwbkFYWFVz?=
 =?utf-8?B?RUVlbGJrRTRjYTYrblY3Uk1paGtPc0VWcGZxUG15RGZsVko0MUxOUnRkLzZY?=
 =?utf-8?B?TytEZmJXV2hXa1I4bk9mN3VHTWwvMzUrNmpPNDNCQ2MwZWpDalpSNlFDYWJX?=
 =?utf-8?B?TFhOc1BpTVFLZ0tjT2V2UVQ1VjIxM3psb2tqRHB4SjVsd1NnM0VQcm1vS0tB?=
 =?utf-8?B?em1xNG5pYVRFcXBTRXFXTWc5ZllOKzhGV0tpVXg5Wk9HQVBMNUY2b1hMUzZ3?=
 =?utf-8?B?aVhwZHNKOWlqMS9nLzQzOTdpajBsWTd5ZW0wSlpjS0FoRktuYm5keERwUHZa?=
 =?utf-8?B?b25aZE5NMzRBSlRUbEt0V2dpS3FaQXlNUkVBNzkyaDdFUE4wT1o0VzlqWjJG?=
 =?utf-8?B?b09uak9Od0ZhN2VTOHlRVWVNTEVRQ2hwMXRxOUpYa09TbVJFWXF5Skg4c0d0?=
 =?utf-8?B?WnZMTU5SUkNTaFlhVERMNlAxbE1EdWFkZzlDZmN4M1ltK3RkVWh1Uzh5ZGJ2?=
 =?utf-8?B?Ym5IYlQvQ3htWkJsZ1BzeVdQVFBFZm4xcHYrRmQxVXpOWTU3NTY2MktxK1Jw?=
 =?utf-8?B?ZUNRWTJoUkp5MFpUUjdZdW9aZE9GcHVjd1BTb3J3U0k0YVdBbW8yTDdiTy85?=
 =?utf-8?B?NTg5eUNhYzJSSE5YNmdtRWVETHV6bGJiQS9XUHp3ZEVVWmsrWDRwWUppM0lB?=
 =?utf-8?B?VVBlTzlIN1FCM2oyZDZJRnhQRDNpNlBlVVZEZmM0OW96YkVLdXJsSnZzY3dy?=
 =?utf-8?B?WVNiOE1YekdHcUN2cUk2S21hcStyVVB2RE5Qb3M5ZUNtUTlPeXpnK3c3M3FC?=
 =?utf-8?B?VHc0bDlpREF5R1E4dVZGU0lHSzIwV1VtRnB2M2JFWGdCbnpmdmJjN2t2VWxU?=
 =?utf-8?B?VDYveVAzeXExV0tXazBjeis0MXpZdFVQYTI3UEs2Zk13Y3E5dGNrd0ZBRzBo?=
 =?utf-8?B?b1JON2VBaHh3a2lMa0I1NFlpUElmUTJSZ0RhRjBBVWFuNG9HMGdHNlYyOFNh?=
 =?utf-8?B?dml5bTZrRVE1MHo4aUt0Zk1BQ2NSVkJVa0FtRGNxWERXb0JVemRLeDZSS1pw?=
 =?utf-8?B?eTdnS0FZVlQ4cHVOTmFhYWRFdnN3cFBNbmpnYldCTTZjSitJbkY5cVh6RDU0?=
 =?utf-8?B?MUJhUUZxenphdXJ0Wmdpb2lzL29QSE8xbjFNTlZCNWN0UE1OdXNaOUd6bVE2?=
 =?utf-8?B?RmdvSUhEWEhyWGhxMWFLOUhJZjdTWW5adi9RU0xEVVE5anF5ZXFFRFlWazZC?=
 =?utf-8?B?aEVIZkE4VUZWeG1DeDMwMjJ6Q2ZYYk53UDNOQXBmQUM3MG9RdWpVMzgrSVNq?=
 =?utf-8?B?WC9udWt1TWhUUkRta3duZTBmMTFlaGF1aUtLSVdCOG1TUW90VEZTaHE4MWVt?=
 =?utf-8?B?OEhoVTFndnlrVmIwWnJNMWZEbktuZXlaMGFnSWxPdlRUbnc0U3F2b3V2cXYr?=
 =?utf-8?B?NEoyeWFzQms1d0tERlNyamZ4dHFZTkkxV3VjZlV4R0ZCSWtYSjQxQTdTWi8r?=
 =?utf-8?B?dXVESlJEUWNqalVsOGc3eHRsdmFpTGM3eU5uRDR5WUsxR3llRVpHcnY2Ykcz?=
 =?utf-8?B?TFBRT083Y29CajUwMFJiRk91Ujdya1o3dHo3RzUxZ0VvNUk1Y0p0Y0w5UC9k?=
 =?utf-8?Q?Xj3gIR?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <003B17AE4DE31744A626E2E56DC3C59B@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9950
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	40134171-a970-4f49-7084-08de3c0096a1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|35042699022|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2RCSXRXY3UyejhQV3ZlV2ROUTlwKzE5NlduNUdNUmZVVGxpOUNDRzhaZmoy?=
 =?utf-8?B?ZnV2UmdqNVBCYWZwZk85YXZKZnoyWGJnVjZnVk12THN6WnQ4U25XQkRJY0Fu?=
 =?utf-8?B?TGZuQkFhR2pwTnBFU3B4YllpTnRZb3JNd0grWS81VGVRNVBrVnpiNzROZ09t?=
 =?utf-8?B?bm5yMVAzRlJ6eGl4dm9WeUl1QUVKUXQ2SEd1QTFkR2tON04vY2ZWQjg3VlNr?=
 =?utf-8?B?c1lYQzRGZDR0cmhpczBqWEd6NE9Xdi9UVTlOa01pVVdvSmVjL2NUdUdsbkl4?=
 =?utf-8?B?U3krMUM5dDJCelFSc1ZnMEV2WXRneXRmTGlDODBqWUZVT2JoSjZXSDBjb1ZZ?=
 =?utf-8?B?MWljdzNlbjF3RjZIQk9yLzI0bHFpalp5R1dmaHU1cmVXL1I1WFI2eUsvWEs5?=
 =?utf-8?B?aHpBaFZiTlVsRE1OaHpqNUFCWURYdkN3RXhXTzBzcG85aTFTOUpZaG1qV3FN?=
 =?utf-8?B?aWo3c0g3a1VJd25PbG5qZDZyQnFrUmZQM3JIWmJ4ejY0QTZxcnFNSm5ldXhH?=
 =?utf-8?B?UTdBVkdnU2RJLzlwc0l4dTFlenIrNnV2a1hSUnFyVTdXdHZXR085Z1VRTWJG?=
 =?utf-8?B?NGFmVTQvRmRXYVcrK3RPbWNHejc0Um8yV2hxMklKSVltN0p1Rk8vN1JvOHU4?=
 =?utf-8?B?dEpuVDU2cjcvcTdRTlBVL0liU0xXSkg2RnNRMmh6WThzL29nMng5Y1daZFdp?=
 =?utf-8?B?bmJ1RzNzUUFDclNYa2lJSzN4TVB2KzgxMXlKMFR0K3RBRGhwZWpSVXJMSDFJ?=
 =?utf-8?B?M2VIOCtMU0x3WlAwQ0xHeDZnRVpGM0gxWmE5UkFSTjkzM1BEZ2xFRHNqTDdG?=
 =?utf-8?B?M3l4ZXJSZUdiVXhzSTRsbDNNbmdrd3c2WkhyK013aGlvcm5DcTFtdzd1V3Zt?=
 =?utf-8?B?U3lrYW83ZWhRblZ6OGhveWgxY2Mwd1FDTlMzaFY5bWhBYXdIdHNnQ0pzSHlu?=
 =?utf-8?B?cWZHRUFsUEUwUDdLSDVjZ2JrM0FaWGhQYU9OT3NHcEI2bXVpOTQrMWpHdXdp?=
 =?utf-8?B?V0h5WG1nZXpqTGNQTVg1WHViLzYvK29DSHVHUXBnbkxxcm81bVQyVURqTk0v?=
 =?utf-8?B?bGVuMUplSWhYNnFySjhnQzUvWHVHbnZhSnFsaU9jQmR5TXdyM0RNWUtwZE5k?=
 =?utf-8?B?WUZJbDNQT2orUkRMQThkVTViS0E0UlA4azVDeUZjbExaSmhCYWU3cGlRa1Vh?=
 =?utf-8?B?cHAvSWdnNzlHUklEZHYrR1RHN2dpUlEwQSs4NW1tQ1ZBQzVkcit4M3ZJbGdN?=
 =?utf-8?B?czNaMTEvT3RvM1FseExVTDZMeVYveGxuSzNSbU1EUUxZV0JCb1NoVGE4bHRQ?=
 =?utf-8?B?dUxUclRmOFhLMXZ4bUVYdmtDVS9NVXFwN05NNkF3M2lkV0g5aGhTOUxpckN2?=
 =?utf-8?B?akVlcWttakd1N0ZWMWlWa1hDaUZhL2d0TDZ5MUZYK012R3RHZEZPZW9BbXpB?=
 =?utf-8?B?cUl3Q3RMVDN0bmdhTk1nejdTR3lYbXUrcTM5cjBkWTQzQ2kzZ1JVRUJMWGpB?=
 =?utf-8?B?elljb2pTRm1kRXBaYkR4Mmpjc3ZFQmMxY0ZENnZPamdHaW1Yb3pVQVhwVlpE?=
 =?utf-8?B?N2xqRWlJK3JCckRuamVQQnRVVzY5K1NMTzhORHlFQy9EcUoyR1FTN1JSQ1Mr?=
 =?utf-8?B?V1piU0k1Y1ZCK3BJUGdzSDIvY1JFeXNESk40QitiWnQwL3NXUVFvOTFWclpC?=
 =?utf-8?B?UVNGWWVFUzJVVlFNenJMdjJPUlhrVkYvYWR0MGlDTENqTTMrZXd1bERTMFJB?=
 =?utf-8?B?UkdOL3NETFZCMXBQbDRJRGVaWnJkSjgwb3JJQmlPV1lJa2VqZ1kyZXJOK2RO?=
 =?utf-8?B?OVNIeW1NbEIwSXc0S29CK0FVUEcyVmFqUVVBQ0krYnVPVUE5MzZ1c0t4YkE3?=
 =?utf-8?B?RVdyM2E1YUJZVnc2dTBTdE9BMFVxcWVucFRaNU9QRjNkdncyTnE2eEY2Rjlr?=
 =?utf-8?B?Y3JEQWpIQ1hYQm1VZ3M2ZUxDYzlQUkMyMno1MjgycXZzci9qbG1KR25LdjVi?=
 =?utf-8?B?R1BWNVVmb2UzdkFwcVRQSFBEVnVVM2lNWmFwV0Z0RWVEVUJhSGVSYk13OEFs?=
 =?utf-8?B?YzhvSVFOUHpyUFZvcVppYWZoVmJtZDdxM1ZxK0JLenlxekE2QWl0ZUkwa2VO?=
 =?utf-8?Q?26NY=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(35042699022)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 17:38:19.6526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4045c4-8db9-43ea-dd27-08de3c00bcc0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8722

T24gRnJpLCAyMDI1LTEyLTEyIGF0IDE2OjI0ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIEZyaSwgMTIgRGVjIDIwMjUgMTU6MjI6MzggKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEV4dGVuZCB0aGUgZXhp
c3RpbmcgRkdUIGluZnJhc3RydWN0dXJlIHRvIGNhbGN1bGF0ZSBhbmQgYWN0aXZhdGUNCj4gPiBh
bnkNCj4gPiByZXF1aXJlZCBHSUN2NSB0cmFwcyAoSUNIX0hGR1JUUl9FTDIsIElDSF9IRkdXVFJf
RUwyLA0KPiA+IElDSF9IRkdJVFJfRUwyKQ0KPiA+IGJlZm9yZSBlbnRlcmluZyB0aGUgZ3Vlc3Qs
IGFuZCByZXN0b3JlIHRoZSBvcmlnaW5hbCBJQ0hfSEZHeFRSX0VMMg0KPiA+IGNvbnRlbnRzIG9u
IHRoZSByZXR1cm4gcGF0aC4gVGhpcyBlbnN1cmVzIHRoYXQgdGhlIGhvc3QgYW5kIGd1ZXN0DQo+
ID4gYmVoYXZpb3VyIHJlbWFpbnMgaW5kZXBlbmRlbnQuDQo+ID4gDQo+ID4gQXMgb2YgdGhpcyBj
aGFuZ2UsIG5vbmUgb2YgdGhlIEdJQ3Y1IGluc3RydWN0aW9ucyBvciByZWdpc3Rlcg0KPiA+IGFj
Y2Vzc2VzDQo+ID4gYXJlIGJlaW5nIHRyYXBwZWQsIGJ1dCB0aGlzIHdpbGwgY2hhbmdlIGluIHN1
YnNlcXVlbnQgY29tbWl0cyBhcw0KPiA+IHNvbWUNCj4gPiBHSUN2NSBzeXN0ZW0gcmVnaXN0ZXJz
IG11c3QgYWx3YXlzIGJlIHRyYXBwZWQgKElDQ19JQUZGSURSX0VMMSwNCj4gPiBJQ0hfUFBJX0hN
UnhfRUwxKS4NCj4gDQo+IG5pdDogOTAlIG9mIHRoaXMgcGF0Y2ggaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCBjb21wdXRpbmcgdGhlIEZHVHMgYXQNCj4gbG9hZCB0aW1lLiBUaGUgZ2lzdCBvZiBpdCBp
cyBhY3R1YWxseSBzZXR0aW5nIHVwIHRoZSBGR1QNCj4gaW5mcmFzdHJ1Y3R1cmUsIGFuZCBhY3Rp
dmF0ZS9kZWFjdGl2YXRlIGFzcGVjdCBpcyBhY3R1YWxseSB2ZXJ5DQo+IG1pbm9yLiBZb3UgbWF5
IHdhbnQgdG8gcmVmb3JtdWxhdGUgdGhlIGNvbW1pdCBtZXNzYWdlIHRvIG1ha2UgdGhhdA0KPiBj
bGVhcmVyIChJIGRvbid0IHRoaW5rIHRoaXMgbmVlZHMgc3BsaXR0aW5nIHRob3VnaCkuDQoNCkdv
b2QgcG9pbnQuIEhhdmUgcmV3b3JkZWQgdGhlIGNvbW1pdCBtZXNzYWdlIGFjY29yZGluZ2x5Lg0K
DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiBAQCAtMTUwMSw3ICsxNTg1LDcgQEAgc3RhdGljIHZvaWQg
X19jb21wdXRlX2hkZmd3dHIoc3RydWN0IGt2bV92Y3B1DQo+ID4gKnZjcHUpDQo+ID4gwqB2b2lk
IGt2bV92Y3B1X2xvYWRfZmd0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiDCoHsNCj4gPiDC
oAlpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfSEFTX0ZHVCkpDQo+ID4gLQkJcmV0dXJu
Ow0KPiA+ICsJCWdvdG8gc2tpcF9mZWF0X2ZndDsNCj4gDQo+IEhvdyBjYW4geW91IGhhdmUgR0lD
djUsIGJ1dCBub3QgRkdUcz8gSSBkb24ndCB0aGluayB0aGlzIGlzIGEgdmFsaWQNCj4gY29uc3Ry
dWN0IGFzIHBlciB0aGUgYXJjaGl0ZWN0dXJlOg0KPiANCj4gCShGRUFUX0dDSUUgPT0+IHY5QXAz
KQ0KPiAJKEZFQVRfRkdUID09PiB2OEFwNSkNCj4gCSh2OUFwMyA9PT4gKHY5QXAyICYmIHY4QXA4
KSkNCg0KT0ssIGFncmVlZC4gRkVBVF9GR1QgaXMgbWFuZGF0b3J5IGZyb20gdjguNi4gSGF2ZSBk
cm9wcGVkIHRoaXMgZmlyc3QNCnNraXAgYXMgd2UnbGwgY2VydGFpbmx5IGhhdmUgaXQgaWYgd2Ug
aGF2ZSBHSUN2NS4NCg0KPiANCj4gPiDCoA0KPiA+IMKgCV9fY29tcHV0ZV9mZ3QodmNwdSwgSEZH
UlRSX0VMMik7DQo+ID4gwqAJX19jb21wdXRlX2hmZ3d0cih2Y3B1KTsNCj4gPiBAQCAtMTUxMSwx
MSArMTU5NSwxOSBAQCB2b2lkIGt2bV92Y3B1X2xvYWRfZmd0KHN0cnVjdCBrdm1fdmNwdQ0KPiA+
ICp2Y3B1KQ0KPiA+IMKgCV9fY29tcHV0ZV9mZ3QodmNwdSwgSEFGR1JUUl9FTDIpOw0KPiA+IMKg
DQo+ID4gwqAJaWYgKCFjcHVzX2hhdmVfZmluYWxfY2FwKEFSTTY0X0hBU19GR1QyKSkNCj4gPiAt
CQlyZXR1cm47DQo+ID4gKwkJZ290byBza2lwX2ZlYXRfZmd0Ow0KPiANCj4gRXZlbiBGR1QyIGlz
IGV4cGVjdGVkLCBzaW5jZSB2OS4zIGlzIGNvbmdydWVudCB0byB2OC44Og0KPiANCj4gCShGRUFU
X0ZHVDIgPT0+IHY4QXA4KQ0KDQpGRUFUX0ZHVDIgaXMgb3B0aW9uYWwgZnJvbSB2OC44ICh2OS4z
KSwgYW5kIG1hbmRhdG9yeSBmcm9tIHY4LjkgKHY5LjQpLg0KVGhpcyBtZWFucyB3ZSBjb3VsZCBo
YXZlIGEgR0lDdjUgc3lzdGVtIHdpdGhvdXQgRkVBVF9GR1QyOyBJJ2xsIGxlYXZlDQppbiB0aGUg
c2Vjb25kIHNraXAuDQoNClRoYW5rcywNClNhc2NoYQ0KDQo+IA0KPiA+IMKgDQo+ID4gwqAJX19j
b21wdXRlX2ZndCh2Y3B1LCBIRkdSVFIyX0VMMik7DQo+ID4gwqAJX19jb21wdXRlX2ZndCh2Y3B1
LCBIRkdXVFIyX0VMMik7DQo+ID4gwqAJX19jb21wdXRlX2ZndCh2Y3B1LCBIRkdJVFIyX0VMMik7
DQo+ID4gwqAJX19jb21wdXRlX2ZndCh2Y3B1LCBIREZHUlRSMl9FTDIpOw0KPiA+IMKgCV9fY29t
cHV0ZV9mZ3QodmNwdSwgSERGR1dUUjJfRUwyKTsNCj4gPiArDQo+ID4gK3NraXBfZmVhdF9mZ3Q6
DQo+ID4gKwlpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRfSEFTX0dJQ1Y1X0NQVUlGKSkN
Cj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJX19jb21wdXRlX2ZndCh2Y3B1LCBJQ0hfSEZH
UlRSX0VMMik7DQo+ID4gKwlfX2NvbXB1dGVfZmd0KHZjcHUsIElDSF9IRkdXVFJfRUwyKTsNCj4g
PiArCV9fY29tcHV0ZV9mZ3QodmNwdSwgSUNIX0hGR0lUUl9FTDIpOw0KPiA+IMKgfQ0KPiANCj4g
VGhhbmtzLA0KPiANCj4gCU0uDQo+IA0KDQo=

