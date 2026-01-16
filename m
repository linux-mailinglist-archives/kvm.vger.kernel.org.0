Return-Path: <kvm+bounces-68379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50784D3845A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49D20316C634
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F2B39C63B;
	Fri, 16 Jan 2026 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKGYfCPP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OKGYfCPP"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013051.outbound.protection.outlook.com [52.101.72.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865E3A0B3F
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588106; cv=fail; b=B4wiQj1cblLcf7BjmfBR8QerJMXOukMs6Ten4PmtofTGaAk4ouIjwLfrb2f+5oi9/EPzZ40GZURNuRoIzPN9DAX2PaloLaB2T/LiA5ioGK3FeJAe+pNz1Gg/vsKAvX7kx85I+n4dsuAeE6oA3utxXAx4K6yYckwAp8or6DMIKYU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588106; c=relaxed/simple;
	bh=4g8Fjn+151mij1FFX2T+cZesNSNZ7Q16HEpYuLq8VXI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IQlM/imExkuZo8K5WrxygUZ6HKsypQ1Cqf5xRwVuZiT0K3yj+weeXygrLLDIXiqPOmWY6lE/Sn07fxOBfa1HEqQnC8WHe7AD8wEYAquWDQyEF71tx8cw8z10yPv/0OZQMK+GhFbv5KqlqSfzmQ6CRdLeXb9tr5K3KpKD0/jiaU8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKGYfCPP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OKGYfCPP; arc=fail smtp.client-ip=52.101.72.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rB43XuX7rOEjUF0HgRdFi4jdQHA4cT48+FmVXfiqCJcrJv+MD9EEeIPinnEy0tX2s3oCyGxLmijCdqMTnrlniH4HeQdRTC+zkfx2Y83P8XRhA0AG+GVVy/xt26PNqshgEuGnUbyTdrMYFlCJSzjdfO3lqF2NAoHyvT1AiZsFksqfWRYtaKAfq74eYEU8YbJAa2caGnKPa4pN6jFk79Oh1MsHe9SECJypFBnXpRfyczcRFKummPTDOV2Pe3PELoJx8vFxfzlCf9NwsPGbyU6SOdTPthJSivbSmPWR3VuOTFFnH/ZI2g3W7uAf/PCwaEwtxujMrKSny5SVyDzEOIIEqA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQHRWWlKDZVfvnmquqwlRsVJcxV9qgAwphTMhHZjNTg=;
 b=simusOl5b9Zwmq5T22CkJKmqkvS8keIb1dU1Cgu5QRROR32e5nnz3HEDvBxW4vnLK2TX/rXjdquIlsrU4HzDh/LByyZk38b5si7mAYz9s59S2LqcRht55j+6C4izEGoZYSX8mImIP9q0yblco7Obv4iERsVLspWIXwYfg3kLqjSlSoFda1mu0OwetXFI1njxaZILeMPnvdEUiyp+5MX2JraETXx6dIaP024/Uo9Wk/7xHKhQ7ZxwbpAJ5hZmgSCgspuYjVFLHwKoK0bN20SkCGTEtp8ToyMk0Hm+t53f9TD9LjulcuUgLdwiY+0HkPNbmwkzsza7+7ZohmsSkc4ZYQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQHRWWlKDZVfvnmquqwlRsVJcxV9qgAwphTMhHZjNTg=;
 b=OKGYfCPP8XVZN3PWUff4pOjrOWVlT9y5UXR9ulEji68ther2G1AikYIl9W4US35VPB00v6oh9DkOkjwI8FSox9i+4hJjQGtP3B80zndnnMthzOT3NeEWb3UyhAJ53oDTOpf6bjFQalPq652wJ0DsnxhERXG9g8pHw3F12Tyvio0=
Received: from AS4PR10CA0003.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::16)
 by GV4PR08MB11604.eurprd08.prod.outlook.com (2603:10a6:150:2db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:28:15 +0000
Received: from AMS1EPF00000044.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::83) by AS4PR10CA0003.outlook.office365.com
 (2603:10a6:20b:5dc::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:28:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000044.mail.protection.outlook.com (10.167.16.41) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LdFmqDKTDa72wQsBQ3cA+m7IHGdBHCZf/VK6W3+1ShYY7vNN/+7HJvK7dQ8RxaUW+VY6BuS5yBF1ghM4me5zjqp6PEKy6AIksc0OpTsFNvo+YLbIOGK3k1eFGU5XRO4sbA+zQ07fyZ/++GvT3TWMSTU/Q2ynSltnm93yV6wCcXQlTYjusIAMaDLSauvlquOUDOd9rHP3oxdfAdRsS9ftYf7R6gWCGl14CEr1vIUtnRL6o4KJ6gWOMDnmSJ8mkG5o99tNJ8+dZfkBXT0kdTPFCWT7VbA1/BcIc/1RGIz/f9euPLaBq2lDGT2Dmv/Q/Nj26JVajg5R7yG885SygeibrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQHRWWlKDZVfvnmquqwlRsVJcxV9qgAwphTMhHZjNTg=;
 b=XBg6lbPeWv0G0iJr7V9LgXlHVqEosapYqxYT1HFZN6CjD6OFTjhvbzsDviHEkeZy57tiOv7paEeG8tfNVlWml/axjkKoC/SvFgMbeboaatwLj6qjIceEtufioX8IsGZ/eIu2gSIZRHoj6u08Z1kM4RZ1kv71qy8ffTJt/EBX0QgfUrxccP6P7btIP5eMiuJN0Z1wDxRcuNPxknfCoWJLdePzlrJlVCyeJTwck4vmsrzY78Hp1JRE2XTbwIL9ehTFx87NUGF/aY1ovLMZ4pJGq3mTBoOyumbkWydQ3JGQ+CrtG3YyKak354IlW6S4+qxcVuGOwiwKnrZpjjtmI1LIxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQHRWWlKDZVfvnmquqwlRsVJcxV9qgAwphTMhHZjNTg=;
 b=OKGYfCPP8XVZN3PWUff4pOjrOWVlT9y5UXR9ulEji68ther2G1AikYIl9W4US35VPB00v6oh9DkOkjwI8FSox9i+4hJjQGtP3B80zndnnMthzOT3NeEWb3UyhAJ53oDTOpf6bjFQalPq652wJ0DsnxhERXG9g8pHw3F12Tyvio0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:12 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:12 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 12/17] arm64: Generate FDT node for GICv5's IRS
Thread-Topic: [PATCH kvmtool v2 12/17] arm64: Generate FDT node for GICv5's
 IRS
Thread-Index: AQHchxW7MI3eBhiisEiygCHZ/lt/0A==
Date: Fri, 16 Jan 2026 18:27:12 +0000
Message-ID: <20260116182606.61856-13-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AMS1EPF00000044:EE_|GV4PR08MB11604:EE_
X-MS-Office365-Filtering-Correlation-Id: 27451d15-a302-4f5f-ba40-08de552d0357
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DKp+GqjDV9MQjSu6lL3iFyllf9cqMyJcZHDkICJYUmAOlRqvOIrwGZyHMb?=
 =?iso-8859-1?Q?v2zCNxTbHaBluMxXfSYqP96yrAU6+cIpkOsP7/PSHQki8WFmUmLg6fUHJE?=
 =?iso-8859-1?Q?/lZxkWRGmX+/COtiXC4HepmmGM+iCzTiXnKXCs7r7N9r2oVJAuro7RrCMn?=
 =?iso-8859-1?Q?v6AwAe1IxNCMdNW66iDVeK5kcVKwse61+kHpNVbLuWMY+7M+6Dvao8Nw4Y?=
 =?iso-8859-1?Q?MqYS599wMQa95PJCC3CU8fgsutDivtIJ6v2ciSG+BNbzDBEtuHbiiCneYQ?=
 =?iso-8859-1?Q?7mojQuz5a8nmm7wNEm1B4Ck+mV2BYhjy6q4nbZWOy4PUGtXA2N5BINAcZm?=
 =?iso-8859-1?Q?PjDPsv4Ht3q5zdMM6jwaaHCBRSdraXvbfIYfDV6wIuVDHLAqZ9SqNpt68a?=
 =?iso-8859-1?Q?3Qz0lKnnIrR3DkxP9EeqWxSkqF2lZREGpDchZI4SIqBvPuN4XAxzU6N3Ko?=
 =?iso-8859-1?Q?BGQW38Xlj3eBdv5EU4xMHWm2cuVQZ/tp3kzPfgnVgKoUlkZuUwmr2Wp0Ya?=
 =?iso-8859-1?Q?bsVEuQs/xoBsqA2JIx9EZ7UPa2i2kmG+/xzUZI82+HaXVpanKhKpmfha6D?=
 =?iso-8859-1?Q?2KOTpSRkDSfqFAiMlN6Ioj9dlV0eO5KvHuj5nD6YS7CnlK4DzVN0o5W6nw?=
 =?iso-8859-1?Q?g64AMdA/S4GRjww1KYVxLGsyTNPBFxUtOKUCdtRCdcKUezVaJ3CGxA3uzU?=
 =?iso-8859-1?Q?aclJJK8ArbM6drWN0UAapeJRJcfNnJgj1XUhraeduQ8OxsV5glwuCFfH9w?=
 =?iso-8859-1?Q?VgUZrJ2RARBVYEL8qwwZ8NgUxlOe8FBgOFf5WU8GzOplIriLskN5QV2DH/?=
 =?iso-8859-1?Q?AnhKCnY4h1NNbmWDvlbKmA28j+VfluBS5gWBq4GT0RSsoCHSqIyckJej6H?=
 =?iso-8859-1?Q?vpo9uJo3lWjYVzTGIKULJF+Cx+E3WKaVQw3/iBmlUaJhPVojG5QycMwDEw?=
 =?iso-8859-1?Q?BMPxYndQV7/eTQ3E/DIMhp/ZRKBZ3dd5qS6XQAM0gbZ1uePMVgEkT1SIPR?=
 =?iso-8859-1?Q?RmcvT4eqwTVEBcRzhM6xJYF9+rcgiisH7Q1rHwdVNNZdA13GHVudbmMnMT?=
 =?iso-8859-1?Q?C4NmyrzPS94QsUZgwpKMi/SGZxVPgOtHMJMVZmxSSmBTELxNh3nmU+qXOk?=
 =?iso-8859-1?Q?qc+YNGoNTRIg6vkB2hziWNAxqb2o2prhROBv2eYskua5YfnRbus8AdtKUJ?=
 =?iso-8859-1?Q?ARN9vza7BW6u3yd6u7Xz14DReCVyCdJCeGt8vbL6RprL8gABP/BQH6gBGB?=
 =?iso-8859-1?Q?f5EIRXmR00gQrY+qmSATnaaPqISrUXTKhQSBgOZ0HCJlq37mqUtOv6SF4q?=
 =?iso-8859-1?Q?CtPZIb5xBncAWwNXcRHk70qOrN3G5hxvmSiktzdMrdQbBQyw9VAMLiXDCr?=
 =?iso-8859-1?Q?l17hs7Ibu/z+lQ1dsgqQo1Zh9k0/x9WaMCHw1EkNldZVTlh2WMtl5QJwFw?=
 =?iso-8859-1?Q?rkwT6zSK+McXaz5Y/xeCZ1Fp4jNn/N0Vs+U/v3oCuBXAU2PFrdNli8+9Jw?=
 =?iso-8859-1?Q?h/MrR9uyOMijY+QqDKt6+hhr1HS33dcI/T/5jvcuLXidp00TJmVyvkXetF?=
 =?iso-8859-1?Q?UmWLvOK1BcTmggFUU4cXtmOUBt2fLvLOcB2pUFQebiswCfi6W4ibNqIEAA?=
 =?iso-8859-1?Q?FKD7bPTCpHRDXvwvx26LLAhyxpXl5+fbLn/a2psSTT5WNWeS8QyKXtAi2l?=
 =?iso-8859-1?Q?L7GDPrter7SXYyDW/0A=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0c602f39-13b8-4149-1b1d-08de552cde3e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|35042699022|1800799024|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?KImgRcQzkDhlYg7aIYptBfcKU6lobF6dCsM883kLoUlTJm39NGQ1SuHAdR?=
 =?iso-8859-1?Q?qgLGibyufNFjCgKiTwMbwf+y5+TDdpNTAv38EnzBwItuVWmvLt3PNnRoWz?=
 =?iso-8859-1?Q?3+7FQrEIa/euIYDvW61g6hzra25khQwE4Xi3Je3mdrTllXsbjhGioFSCNL?=
 =?iso-8859-1?Q?VP2a2NpBFskAK/TQa7AZ3y8KgZBfsS7aZAdUWOqW3XRykMWw3xj5tCoPW9?=
 =?iso-8859-1?Q?uyfQynbf43fwtRyvKq3eAYGPnuPP7a3vtYtADnquPA0Vj8e0sCx6LTCZCA?=
 =?iso-8859-1?Q?dOnH0LN1Icm+d21lydoo3J1uY96AVlQ15tJQxwXJ5s72qMB5qnkKUULyFk?=
 =?iso-8859-1?Q?d85v9mHNK/S13fp7gj5llfQCeROR8DPvEY7ohROl0pYLStZYTl+JhlT8bW?=
 =?iso-8859-1?Q?2ERUqq5C9Jl6dlTgO03YNTkyqos15W+xlsKq8mL+vTdk1gpshIvG7iRjKn?=
 =?iso-8859-1?Q?oVJQE50O7kCZNM3K41GFiaDhIaEfr4b7AxOpL6flmslGRzTpdpZLwmCP4L?=
 =?iso-8859-1?Q?s5hcG97pKg61EX01pes1+edApBuZL64F9ol8w3JYI+sLc1UZX8Q07LzI8v?=
 =?iso-8859-1?Q?4JubJJFRWPAhVGvm3TLMdIE1Xbbu+t2Jsr7H/OIKAwp+Vjr856c/QqBN0W?=
 =?iso-8859-1?Q?3eDf74mNj04lIMRbR4j7/fjybrWb5xc8f+BKYZADcrJ6WYz/pmbGpjQQLE?=
 =?iso-8859-1?Q?OAIV7hKzQPGUx1R8gqr2z4ORkZ8xBHylLRzhGpYEt4m0sJEb9HBsqTjDlC?=
 =?iso-8859-1?Q?cgGWOHq9xIOQ0qm9hSLkEyZBiZG2LeVemRDxrDULtr9RwEmcSjxuh46GRt?=
 =?iso-8859-1?Q?o9bGGIpIYYjpxdUmwbiZh35QzQExlTTqmXlEm0isbGLXMKGKQa3ZvwYL0N?=
 =?iso-8859-1?Q?glrRzfckLR2JFpWtgltLwdstn5+wRA6MXkyngelpsgldLg05UJzAql6Zwa?=
 =?iso-8859-1?Q?ZJKhDq0FVNCL1eV6CbmLouCsk46p6HJbR0ukYCP7ZWr0rV2VUMlJ198ReV?=
 =?iso-8859-1?Q?sN3nmm3axGZx3wi9tvt7cnjhQPSHLRjcnhcJT7YBq2oEgoqDSCLqp3wxbu?=
 =?iso-8859-1?Q?xQ4jnPYJa6obMABpjHblo94ejN+f4DZ3etKnRS1UZ8xbDngsKsXZWa5rX0?=
 =?iso-8859-1?Q?Ha5XtooWyG27k1/sFNUzh3paq8T2DIkoGKw2PN0b52on2hkOU7Roj3wDMR?=
 =?iso-8859-1?Q?EAevazpcGoCOBGEgvLq3qspgluKrf+3pgoJ/tTHcdnGzzA9NQaXQ9QOJqX?=
 =?iso-8859-1?Q?Yq+vG3Ck3oWotkXtdu01iBVZnh8lw+kA6HuHGGGMyPA5HvQSmuJpe1wwRv?=
 =?iso-8859-1?Q?ZzQT3noMocXma0gwwFm8eYQ2VFZeLpTAotJPwcCAGD/9TtxDl1TOQZ4Rgm?=
 =?iso-8859-1?Q?lanzu/3LjBr4/SkaSBDXoLqzTEVDu2iLR71cVCWUWQFVHkhHUSedsxvHaE?=
 =?iso-8859-1?Q?ECa2tBvTFm9Pl80F3a2YDEts6PprZ1HwQJeVYDCjpF//1AuXxVgLbrLBW8?=
 =?iso-8859-1?Q?5vUYIEPno21IKmwMgWsZO3nGTJREbBJ72w0NZz1L8CdiEIBJ04XsTeF7sg?=
 =?iso-8859-1?Q?3uCz6DAbHt12g2PquNrAu0LGf2XUL9+J7WodpjG66+m4MFEfb5Pxy9ZSWB?=
 =?iso-8859-1?Q?BYGvONcQ5vaGD/PeWSuyhLxMm5wYBiJhY3Nquj4BHEobAoxHBBjcPAiTZb?=
 =?iso-8859-1?Q?19QukqdSH/0ouWwIoNoIfd7VKia/4VTDzQSnm25vWlfwMHL5KXn1TZTOTQ?=
 =?iso-8859-1?Q?BHmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(35042699022)(1800799024)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:15.0206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27451d15-a302-4f5f-ba40-08de552d0357
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000044.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11604

For the `gicv5` irqchip config, generate nodes for the GICv5 CPU
interface and the IRS. This means that the IAFFIDs are now configured,
using the CPU phandles that were previously set up.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index e75fd6c2..c144b42a 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -473,6 +473,16 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kv=
m)
=20
 static void gic__generate_gicv5_fdt_nodes(void *fdt, struct kvm *kvm)
 {
+	char node_at_addr[64];
+	u32 cpus[kvm->nrcpus];
+	u16 iaffids[kvm->nrcpus];
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
@@ -484,6 +494,29 @@ static void gic__generate_gicv5_fdt_nodes(void *fdt, s=
truct kvm *kvm)
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
+	for (int cpu =3D 0; cpu < kvm->nrcpus; ++cpu) {
+		cpus[cpu] =3D cpu_to_fdt32(PHANDLE_CPU_BASE + cpu);
+		iaffids[cpu] =3D cpu_to_fdt16(cpu);
+	}
+
+	_FDT(fdt_property(fdt, "cpus", cpus, sizeof(u32) * kvm->nrcpus));
+	_FDT(fdt_property(fdt, "arm,iaffids", iaffids, sizeof(u16) * kvm->nrcpus)=
);
+
+	_FDT(fdt_end_node(fdt)); // End of IRS node
+
 	_FDT(fdt_end_node(fdt)); // End of GIC node
 }
=20
--=20
2.34.1

