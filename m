Return-Path: <kvm+bounces-50117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5052AE1FCA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24FCC188B946
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DEA2E6123;
	Fri, 20 Jun 2025 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Femz4Mec";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Femz4Mec"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012064.outbound.protection.outlook.com [52.101.66.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBFE23ABA9;
	Fri, 20 Jun 2025 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435710; cv=fail; b=Mb8I20HoTxu0lsQzGnGc1Zod8CrmUu3ZXjlAyngL+Jl+op2DbPcX6gw3BGIyEfUWTWdmOl0RROnqe/U3610GcoLFmJWs+XC0c2/5hn4D69A70HuQzo2tI+TCPHhJQO2JtaQjZGPuWBrU7xDYC/QJFtbWPPq2ptOrh1RisKux9/4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435710; c=relaxed/simple;
	bh=/yk3C4aiTNU+H+REVbsZW9R7pH17RiojLd6DjU4tyhQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jMfrkd+dF9GzaC11kTiTb4ID+qthM/AIxDJJFX+kiIZJuSl/td3dNguvc5YRCjZJJ9usR+k2xZkMWBueVWBbk7uek67rw69EACMhTA0k/bcJCAwuHrju++NYjV+AvAUsdI5OJevB1XhitsG9+ShaqX9epyJfjMOoM5zdrsVFF3Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Femz4Mec; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Femz4Mec; arc=fail smtp.client-ip=52.101.66.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Lail3TCUYpPW+CtAO6epDKnWXIWRmMouKmhXZCWfYW0I95+wQaU9WRfr9F4sqbiz++QMrUXdnbfnBKMmDtyF1SbqEDRnfEaaPRdNNnMbW9RGS+xHxtmNxdUIKJj5eew0tIiVYYRF2FJXFj8YQ3LMmg75MlBNj9/1lC9hgHqBBWBYRMZYxZXTG1BNzHt2vI6QfzUu/HsIVrko4OJxn7ZpbAYtypT8PZfysJuHr+S97LYfCnb5yny5sbi9srSyDGcL+SOHv4GC5zuOU54Wo9w4z5pxrJWIlBcZf0MPmGo7v6nsInw2ne/Uv7ZSRjY5iZEw6oyUzHyWz+e55Fi69XuVpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpWecAU/Y/0wBTVmh9wqlgj1gTjZPmcwRxP3iNAQOm4=;
 b=iZHkH/Ox5roMqt9j2bDh419BCkSyIyw2xIYDyFLIZSNZYesZ26RKBeBmH7x2WFCfGGql3mAD5DBqJQNUvGcFuTHTklwL3128R0evi7/5ZO7Hsa8IcO7agmvcgJDYXYdAKmQe+a+PZcVvJVLL4QkolpWx9fUXWNH4jgNyfB1yokH5FDVhJaSFpYZ6pnQgAAGF1VfKx8uofxJDk/qfnkxcg4423o3qSgulHcuiscy/Mp23i9AxCt+C8UXkJH36NT+GA4saYX+Kd4Bp6GW8Wb4G+XNl5gz6+PoojokKpcaAdY/+Oas+ChrPnDU8oap1EMP1Bz8gcgyrJIdr0dwBNyYubg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpWecAU/Y/0wBTVmh9wqlgj1gTjZPmcwRxP3iNAQOm4=;
 b=Femz4MecQoM6SQuJZviB/Q9rgEcgmJmHTMYCb7fMSVhskZmCXHrVQU3Nexx8CYviNuhsrov9H+k555FHD2ce9nW6xy1tgH+pzWtDyLo09WVBGn7MXpotqIUV+AvLzfbnGBTt+5+hAfbovBMdj2autjXHl/bfql0GvTg9HxDt/1g=
Received: from AS9PR06CA0266.eurprd06.prod.outlook.com (2603:10a6:20b:45f::15)
 by DBBPR08MB5979.eurprd08.prod.outlook.com (2603:10a6:10:205::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Fri, 20 Jun
 2025 16:08:25 +0000
Received: from AM1PEPF000252DF.eurprd07.prod.outlook.com
 (2603:10a6:20b:45f:cafe::e2) by AS9PR06CA0266.outlook.office365.com
 (2603:10a6:20b:45f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.25 via Frontend Transport; Fri,
 20 Jun 2025 16:08:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DF.mail.protection.outlook.com (10.167.16.57) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.21
 via Frontend Transport; Fri, 20 Jun 2025 16:08:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPkmQPtG8X0veNcUUDfLXGzng8BVLTzrfV7r6ebxi69WkLHxjPa7TN0LY5nptMkluY06NjO5Nj1PSFEjxlCHdpYL2nvOyT0pxW2zmTaPKxrA3RE9PoXMaBUiMRL9GXF+qTK3aOEsmPOgiMIHITo2h9qlvmjjbgAmnqH2STwosgNlw7NUjdUU2AI0YY/6ZBRxrlpsz1ZjciNDcprBpQJ4SApHbzWdbfMMxCZX5WMMnWk/kUH+b5LtwCC4y4PtnupMeZg9MuC1Ok9ZQHezUVDNZINbbkJ2gVg2nN97Vud9ZoAgtZncdXqEXHSv7PqccLcQgMuWv5rus7J9NER0a7IoBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpWecAU/Y/0wBTVmh9wqlgj1gTjZPmcwRxP3iNAQOm4=;
 b=iI1xQiQ8vTfxf4AB3OICXH6rcVsbWWoWUrkUXR+sgy7T6eT48A5pzBEMob3+rvYpdSIqBJWm3trJ8rGK2VuusPk3HM/4ZQ8Cwag9Ir32ijsD1PedLrps09Fja+dgzriiYri5HGGQ3+py9zVl8BAQjjaKMlRemEXRg6IhvCiU3sCDcyZFP3+U3adreYiD7x6Q4L7mwhUQz/KYsirTBh8gCoWYahDHGU2criEqx6YHVXE7KYb9hlfXsUjBebHXf1QBj8pMdSxAGUHFR11LX5OI6OJFJGGr3WSD+fAnzD1rF6AdDFAkrOo7E3nDRdEg2hjfOMO8yLoIuf1sJ2sXh4MNWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpWecAU/Y/0wBTVmh9wqlgj1gTjZPmcwRxP3iNAQOm4=;
 b=Femz4MecQoM6SQuJZviB/Q9rgEcgmJmHTMYCb7fMSVhskZmCXHrVQU3Nexx8CYviNuhsrov9H+k555FHD2ce9nW6xy1tgH+pzWtDyLo09WVBGn7MXpotqIUV+AvLzfbnGBTt+5+hAfbovBMdj2autjXHl/bfql0GvTg9HxDt/1g=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS8PR08MB8735.eurprd08.prod.outlook.com (2603:10a6:20b:563::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Fri, 20 Jun
 2025 16:07:50 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 16:07:50 +0000
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
Subject: [PATCH 0/5] KVM: arm64: Enable GICv3 guests on GICv5 hosts using
 FEAT_GCIE_LEGACY
Thread-Topic: [PATCH 0/5] KVM: arm64: Enable GICv3 guests on GICv5 hosts using
 FEAT_GCIE_LEGACY
Thread-Index: AQHb4f14sC/dti4l8UyjYowzoNYZVQ==
Date: Fri, 20 Jun 2025 16:07:50 +0000
Message-ID: <20250620160741.3513940-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS8PR08MB8735:EE_|AM1PEPF000252DF:EE_|DBBPR08MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 318448b8-a2ea-4aaa-6d2f-08ddb014aedd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?tCnRivU0e6GnhxMK4MCMFzcNnl+JEyd71a5w0a5ELBgq9t4PhYvYju2/ch?=
 =?iso-8859-1?Q?UquCdkkmGnlobs/Zp7UYlqYhRSee2nUaGlHpUlihtjkUgbwKHbubYiTJd+?=
 =?iso-8859-1?Q?YvrfhCI98WmQWEw4dhyDfDEZYwGx+Dx0ouUrjZwIInK1BTgU4zdvdws7Ec?=
 =?iso-8859-1?Q?P2tgOAfbslaEjKDwFSz6OVk6jV/qptvOGPV72qfZ1XGJBo5R99XS1nIn7Q?=
 =?iso-8859-1?Q?LcNO4Wv4mVDpdbzg7uDXzOdn497NYJ6ipZofLgg5/9XHRbQwWdyN6X0ZCH?=
 =?iso-8859-1?Q?ALt5E0fkrSmE0BiuwKWyPcdbxlCni4sd+98r8sMOuxJdZ9f6K3XkZqbWif?=
 =?iso-8859-1?Q?HQSP4Z4amwI1SKXhG6JUxq8Om3bdUzISn5rcnL75U69gPTGBmbTifVzaJE?=
 =?iso-8859-1?Q?ksKud3jc0sfx/JSo2DHALb2SF6BQJ0Y4gwU/apGIbfakNShBNRQa0I0MaC?=
 =?iso-8859-1?Q?9PeISmSSBXOOJ9CfXWZku3GFXEadjlG8QStqGWM5e0U1gqFLzVqEzexUT3?=
 =?iso-8859-1?Q?bCfNoYTqdBZbqeTKnpKLVE3YHQgmA7Z9Q9i2DxewQlLMOW7Ghyq2rwQ+Uq?=
 =?iso-8859-1?Q?NdOEPSvbnCBjMDYzYDhSbVJX+IJ1bjm7DnkghGVEHAV+1JvS8r/cMh18/6?=
 =?iso-8859-1?Q?j8lvDi4qaxS0uRmhqQjyVcgnD9+G8e/LVO05MCUi7YSebDIuGEcPzkKi0q?=
 =?iso-8859-1?Q?BpUUpl/ouXW0i3T7Aat8/dD5LacMdiB03u+kCT4PXItS9UVLljtR8PE8sc?=
 =?iso-8859-1?Q?eJpDr+eSu3CseRrxv2BbmF+s5atfaB045QnK7XSZSMAOMkNZBsdCJ55QCn?=
 =?iso-8859-1?Q?7CywhNoUg5rx7OPkqGkre/n2uF+Cqp751E2lEKxg0KsiQ/EUt0uZr53O0o?=
 =?iso-8859-1?Q?9rbXwegj5d7nfg21dOoqOyBFKJQWw+rfoJxgHXcOyJoDNK2ZxsHCn5qpUX?=
 =?iso-8859-1?Q?JrpaoYSYQHl/5OIfniN21d3mbHh6ovZXSrK6++ru9K30OHN6qDsY97SPye?=
 =?iso-8859-1?Q?m738T0tL0pIb8qC+V4ucnLGKGSYKa+qjtXRBgrlbGOWjm4pHexAWQNsfA6?=
 =?iso-8859-1?Q?symO0Sis8yhwT3LvPrjBoEuajVxCmIAqgsmFf7I/7ukhFNU3mshnyes3Gp?=
 =?iso-8859-1?Q?TKvpMbUfeJW5ZQn3XulasUdWYKFJv2tXNcgP9oYKkSVmT58hIrHpX60zGV?=
 =?iso-8859-1?Q?1c6D+ZdRcZOugdFpOhXFsUs5SwUIibafDxWeBnP5yUCa2lXi7Gf1mZ6wy8?=
 =?iso-8859-1?Q?nr1lY5GVfXV61rCDB0cJQVB9Kw43iiHTiKnBOm9T3PWoeEqcysuhrQenLL?=
 =?iso-8859-1?Q?1XvoTm0BM2gcJXxXinR5tfoqUYeB4TNPyHbh4UrUnfI6vMsCjiNh4cij16?=
 =?iso-8859-1?Q?QOmonk2qhsXo3uwPiy/saoyrtteg0HJ0wRCc2d3mXXr+svWdXtzBPjjiCy?=
 =?iso-8859-1?Q?cQxFSdL04UWF7mbAG66GVuhx+UGAWzSVk/7IB4ZH+lA610qBNLugXvBuPz?=
 =?iso-8859-1?Q?w=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8735
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b01697a7-0d53-432f-6f37-08ddb0149b35
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?n9uQK+nswTUJgYBhO4ONTi/cc8YGm8bSnD0Ly7yLz39VJTLoCHqgB71jdm?=
 =?iso-8859-1?Q?ZRjT/AKIuLZldXIh9XSZI1tH8WDvkFYHXN5u8BXSumleiZMxF2LVQqK+Bm?=
 =?iso-8859-1?Q?WOo2ZlOqPqqu0e9wyWgp6oOfc40Ds1SCsiE49x5F7gNGUzPaWsWLygP74I?=
 =?iso-8859-1?Q?OrqjuKy3PmE1zrJx40yzOFZ8Ec+zpZRMlag2qpmqcZR/U1rqtRqwrOBssP?=
 =?iso-8859-1?Q?V/hgPBH0OjI0gJafREWNJcPrs2VwxtyZEnQC2m0AoaXLNc8sO2CAApjsBb?=
 =?iso-8859-1?Q?uWSoJNVDW36sid3koVgWGBfebis8a1fOfNEl1aHZTMGXI2iI3ewUwZE2HG?=
 =?iso-8859-1?Q?WngMto1AfqEHHtUlpVvOgXaxIC4AKBkZKqArFbs45TUOQ+MbdQ/PQZMnD+?=
 =?iso-8859-1?Q?NrjUVdgfJ5BT2KXz503laxPHUpyaqDw3QdXcDZmGXU0V2qAbl5beCytir9?=
 =?iso-8859-1?Q?42enoRyjaAMiv0SHmzbXbTnJ9FmduxyAnlSoFs9G7f123rInJJZIeRe87P?=
 =?iso-8859-1?Q?2bKc4DN92L0YfDUBliML6IsOjXucmXwXKOEeMD1OhxHYae0mFCtoQv2XtN?=
 =?iso-8859-1?Q?hM3NMqdx73A63Ztm65MSFCZKfNAkPKFkkx0qlBd70PuWEksu6I4nFmhlTK?=
 =?iso-8859-1?Q?Y0rOiX5EI9UvM18/v8vSRQ3od4EY/i7Dpn+9STM2+/ZDCL/z13pHbfNtdj?=
 =?iso-8859-1?Q?BysFDC83oFIIiFx1Pdy78eSEFF9ddbON2q0Luw1huHywWoJGCZ2xPgOWp8?=
 =?iso-8859-1?Q?MkU485eJqkwOPhCk1R/7+skq3q5/j+3NIKiAtPGGj5fDZzhP0qYWxaDBsg?=
 =?iso-8859-1?Q?FNG4sOSH7qSzNIq2s9ABLpd2WQ1BMlYNisReck4PnuAypb32phWM3whCA0?=
 =?iso-8859-1?Q?p+an29lDV+cenYTvISDy/zJX4snMoAFh8CfMvTji2DKKzuxQh08s1R8uAa?=
 =?iso-8859-1?Q?pH8HyXUjwOcefQodZhDfhIbs0Ilt368VO2vw6MGrgqsz0nfbQiJxNV9tBG?=
 =?iso-8859-1?Q?lXNB4ZvdrM36Qzw8ILBeIHKXiKY+GWkBhNxtd1weYVmOQRqR29JvcORP+S?=
 =?iso-8859-1?Q?UNnlqj35rsfywxW/t/fJRnV+GdN6GEA1Py9jhDjVc8HGvTTmOgakf4TteW?=
 =?iso-8859-1?Q?lkF7hWIO4Aap2TX8czzmBh/Psjb/B5QcH5R0dfAPLrWcCXGeF8i6t1kHwQ?=
 =?iso-8859-1?Q?A9MvTPxhlqx+LYT7RaSKzI+NIbMDO053mt/VHo3iWg3Owbu+LM/1NpClHD?=
 =?iso-8859-1?Q?3F9qxrOc5/Rvqatwht9cIB4r/zil8+UzrRf5pFPRflGjvo8W+DQOeuOq93?=
 =?iso-8859-1?Q?Is8cCACNPliWPS7BnpptQ2C+nqr0Eb5t6WRu8XIrLLKZfBFmyjSqDGmWHQ?=
 =?iso-8859-1?Q?UOqFWlv83jIO1Q/JGQoxRH2wPaypyVidKrdIrjdPQGcrV5anTHumEL2n5d?=
 =?iso-8859-1?Q?bhs3IPTV2gjbpgesLTu0stWsz+AQLoqhrapFCpM/J4UgE/+buAZgA9fqWC?=
 =?iso-8859-1?Q?2I0/c2oksMJ5JMekU60UO/GXxc1YcTOzXnqsmm7zqHvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 16:08:23.5170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 318448b8-a2ea-4aaa-6d2f-08ddb014aedd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DF.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB5979

Hi all,

This series introduces support for running GICv3 guests on GICv5 hosts
by leveraging the GICv5 legacy compatibility feature
(FEAT_GCIE_LEGACY). The main motivation is to enable existing GICv3
VMs on GICv5 system without VM or VMM modifications - things should
work out of the box.

The changes are focused on two main areas:

    KVM GIC support: Enabling detection of a GICv5 host and
    configuring it to support GICv3 guests.

    IRQ chip support: Ensuring forwarded PPIs behave consistently with
    GICv3 expectations.

Summary of the patches:

    Ensure injected guest interrupts behave correctly by deferring
    deactivation to the guest, matching GICv3-native behavior.

    Set up the necessary GIC capabilities to advertise
    FEAT_GCIE_LEGACY to KVM.

    Add missing system register required for enabling GICv3 compat
    mode from EL2.

    Enable full support for running GICv3 VMs on a GICv5 host when
    compat mode is present, covering VHE, nVHE, and protected KVM
    configurations (excluding nested virt).

    Introduce a probe routine to enable GICv5 when FEAT_GCIE_LEGACY is
    detected. This consumes the gic_kvm_info populated earlier.

This support has been co-developed with T.Hayes, indicated with
Co-authored-by tags.

This series is based and dependent on [PATCH v5 00/27] Arm GICv5: Host
driver implementation [1].

Feedback welcome!

Thanks,
Sascha

[1] https://lore.kernel.org/all/20250618-gicv5-host-v5-0-d9e622ac5539@kerne=
l.org/

Sascha Bischoff (5):
  irqchip/gic-v5: Skip deactivate for forwarded PPI interrupts
  irqchip/gic-v5: Populate struct gic_kvm_info
  arm64/sysreg: Add ICH_VCTLR_EL2
  KVM: arm64: gic-v5: Support GICv3 compat
  KVM: arm64: gic-v5: Probe for GICv5

 arch/arm64/include/asm/kvm_asm.h      |  2 +
 arch/arm64/include/asm/kvm_hyp.h      |  2 +
 arch/arm64/kvm/Makefile               |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 12 +++++
 arch/arm64/kvm/hyp/vgic-v3-sr.c       | 51 +++++++++++++++++----
 arch/arm64/kvm/sys_regs.c             | 10 ++++-
 arch/arm64/kvm/vgic/vgic-init.c       |  9 +++-
 arch/arm64/kvm/vgic/vgic-v3.c         |  6 +++
 arch/arm64/kvm/vgic/vgic-v5.c         | 64 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            |  4 ++
 arch/arm64/tools/sysreg               |  6 +++
 drivers/irqchip/irq-gic-v5.c          | 51 +++++++++++++++++++++
 include/kvm/arm_vgic.h                |  9 +++-
 include/linux/irqchip/arm-vgic-info.h |  4 ++
 14 files changed, 220 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c

--=20
2.34.1

