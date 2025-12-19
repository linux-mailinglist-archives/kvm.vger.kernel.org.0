Return-Path: <kvm+bounces-66377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B509CD0C91
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B50FB30D15E2
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747B2361DDD;
	Fri, 19 Dec 2025 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T9wozrbI";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="T9wozrbI"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010003.outbound.protection.outlook.com [52.101.69.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86442361DCA
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.3
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159648; cv=fail; b=Wu7n78IDwr1UCXPHBCzA2w8HIoh3tUmymNwGfJ1S8ij4RtOLIqKSWn303PblmvEi1nYsYx/ZjkyiZHQm1bGkOBMY80eB1hlkbKzmeQLLyw7A9z3T7jLAgRrGQ8FMEt7dbmP5fd4tTtnkEiGtYFg7VpD5nMQU5XxAqMtpyL1LUaU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159648; c=relaxed/simple;
	bh=yUhoYj4Yi8Snq06cWpN1qyyIj9ymBBPjtgo1t1DHSOs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HgfnxRyVdyKNO6WWaracZolzcKyk5UkpfZGOiWcVeNwc5TMl2uXN07xAVbhH2i2zEGbumpG9t1dEvdJ56lRvyUKzX3EMJCiRcjLr3xG4hZQXy+H3s5NZ442BCaceNDs+3vR3+XPLC7vSMySgs9LR76Jr3gbpxpDJBhWzjCe3NIs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T9wozrbI; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=T9wozrbI; arc=fail smtp.client-ip=52.101.69.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Ji8xYydyoNC37znYlTzch5p1gPGyLSOrfro23wcDJkvanVBZ6+9bQctWOmr3xd4d3a5cwsjKmpPe8oeCWYedrgn98d1cY9Wy/wj6pN/hwgAbgsc/nFf4vQxXUZYielMgbXNLlbwI+9Lg1tOlo7aAbdvMFMysXKAamIIod5lNelrFrfBvRmmmeV6pZztx5O7q8neHHMQlChNYOg40VNlAzCZ0dEpfjuE4x5PI6j+DV/670kKkC9kfGbxgOISvF94xTt0u0WyAQv3g1Dnh0a+bvN/0u9Hj0TtudAczX3kfeX3UTwT12CFZGb7SddSZD8pjm1JxGmkLgsFfh1kxYqAJAQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztJ8HKEt8a91M1QDNSy0JTjkcj1015hkjUgfWevoy2s=;
 b=TjHHPBc8nDvw+U5AOFwbWokksQh2fMyCTYVCUSFEgyAcinrS9SvAd2w1L0AEApbe16HKGQJpWVJNkNAZ4I9X3fs+BwMJGXkftAd/eoAUc4eSR+keMJdVjn19p/fpsOPMX1uLwVHTBH2qolCcfU1IC1HdOI6Ydv5Tb4+3tf4KwIdDNhG5LccBuCnh2p6Ivua6po5SGndKThK5xS+0G2TERuwpTlekLnU+CiQPa5fIb1jj65EAGIR0AANOwE8OR36mKmt/oyAQmo0g6gJuueXBL56fzPbbuYdsGv8Boyban6HDizVE/aIOKuS/tj1D3BF8Z/b3KzkQxLDCc+cBHxmTIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztJ8HKEt8a91M1QDNSy0JTjkcj1015hkjUgfWevoy2s=;
 b=T9wozrbIdmxo/ycqT6iAGQrozq1AeUjwyBDaF4PLCdJL/ToLOI4VgEWiwnMrzp13o0HcHv8nKDFHxM9EPzcq6B8gkiO3zkSbHAi0ZSTPmvEGDtInRNEfbsnXjtiZtUN/mIOXZhhyzT9LMGj/8vdRuP3HDuYcAv0G0mZ35t4pT9I=
Received: from AS4P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::14)
 by GV1PR08MB10478.eurprd08.prod.outlook.com (2603:10a6:150:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:49 +0000
Received: from AM3PEPF0000A795.eurprd04.prod.outlook.com
 (2603:10a6:20b:5df:cafe::f5) by AS4P250CA0015.outlook.office365.com
 (2603:10a6:20b:5df::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A795.mail.protection.outlook.com (10.167.16.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEM3YsEYxSjRtoO/Wij09nBJXnN7SXnLLtrRkBY4Ily4eaV9cm2SnWGHK7odAQqo72uwmyCrW84WRU/NFcU55Zy0wOhpzVTlVg9d/VOZAq+W4ij09IL8BYkBaX7ev7amVkOifsPU5ZRmcIdwYqeCQSFPnhLTgSNudHRodI9MZRImdRFVVcQvSXuunm5KFr1Hcs67oezbmRpgT+PBSKBPL/cqciZTUgf6II0AGKI/2mAghEjPockqVqiqO9ZLE9Kcyk52Y5o/lEdP5At9zgKQqw5vOsofG7KekNlPj1Ve8pfV8BAbt1drAcT6mu7TDr0OOkb3cB3usi14V5adR3BVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztJ8HKEt8a91M1QDNSy0JTjkcj1015hkjUgfWevoy2s=;
 b=UFGnaMMXUfipazedLbZwwDC0jbSP7JIl/+u3ub9qgp+M3TZwT7ice3CaWAI9OpSFaoFI4s9TQ9x3KXpsIfkZYD0zoM2J9QDY/hsQflCr6Y1yTmN5JmBw7U6pCRSS6FlLpOtphWzgMg/I5P159d9lwKjTyly+Bw6o2Kis5mKh6cYCPGU32xmOk7odLvxe3zLeqG4cHpDBpoge5Mh4QefQtcrks+3f0c1a+xy/YeRNS8MK0qAo3XoHvpm/4WoME5+ZrAgXxjp8AWzuO0oWG23BlQcCPlc7024YC0C8B7X/e49pfnwqldbo7xDnX+O1L9tsEqMLfBp0U7h0aYXAA3rJpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztJ8HKEt8a91M1QDNSy0JTjkcj1015hkjUgfWevoy2s=;
 b=T9wozrbIdmxo/ycqT6iAGQrozq1AeUjwyBDaF4PLCdJL/ToLOI4VgEWiwnMrzp13o0HcHv8nKDFHxM9EPzcq6B8gkiO3zkSbHAi0ZSTPmvEGDtInRNEfbsnXjtiZtUN/mIOXZhhyzT9LMGj/8vdRuP3HDuYcAv0G0mZ35t4pT9I=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:46 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH v2 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH v2 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHccP+ErHYu2ILPq0yuremdrhunsw==
Date: Fri, 19 Dec 2025 15:52:45 +0000
Message-ID: <20251219155222.1383109-27-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AM3PEPF0000A795:EE_|GV1PR08MB10478:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f55256f-7698-4b70-d752-08de3f16cd12
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?zj/38Sn9NJvt5vNmuM2oj/5+j5rjVWz58QPBfaNp54QMqVnS2DmAZRSqoI?=
 =?iso-8859-1?Q?LxoWpQYloAom7Bkj0eOfeesb0PA/kQxoqshiFsi6tNDobthrVoI2Ms57ck?=
 =?iso-8859-1?Q?MNG9VhEtEIaOzsRs8TnrLYfbkKfTkTfAn65PpkoENGZWfUI99zsBahbmVY?=
 =?iso-8859-1?Q?h6glzC20DD1GkdGnC7PBxnMOVSsXcWBdFbqTgWAzKU8c4A1kRvVwe07scr?=
 =?iso-8859-1?Q?mvOA9Dm5hNSrUixRaVG0GnewWf+1eNZKyo9XiennRiwb+bbcSqx4SxQOz2?=
 =?iso-8859-1?Q?skvMvWQCWey8RO+MiLFNW9GpFNVFfll57qF+Zrznue5r5PnI+8dsnny3bx?=
 =?iso-8859-1?Q?92CwxRyrgRDpH2tQZHjXSivQLa3u8SOW3JbKkn9QfQJnfASEHp2Z7+acpO?=
 =?iso-8859-1?Q?xcImlHIT1Z3cT3uRt6N2i7Z6le0Z0EaoQSMfQMaNqhbIA3Udj0uEgdodF7?=
 =?iso-8859-1?Q?Cbtb0APessu5FP8+Vyan6GqDpdCkFnA+tHUoJhGMs1S+c3fMjoY+KXpUFq?=
 =?iso-8859-1?Q?8yW4qWEnFFV5GyZY7bb9ibZzf0Dl3xg3IzH/C08J1tSkTt1ECkecSeXDik?=
 =?iso-8859-1?Q?xtyPTtHiHPDSlj0qYcuaee4vvumNXe0X8YpKZ0fUZoqNkHSGqL6woPqym2?=
 =?iso-8859-1?Q?xyONI9RCFqQfJjKmY0lhr2yp9dIiINCoabzCOHoYf/9J93gSmrCCC1sm3C?=
 =?iso-8859-1?Q?ueMxjG/Tce0ELMPnSZLYqSQbESM3XCIHQHmD63sjUmeuzRNzjEYOA+3Bee?=
 =?iso-8859-1?Q?qWZDqDFFe4yPeDCU9DUdfNaBqMqie+aW799/Qc/30N1kJVbRqKw40Zxmud?=
 =?iso-8859-1?Q?CS0olUQKIWX0qCoZiGeWATa9JHQgBkTXY15db09UnlL9WWl+6Sdn3Dcq0t?=
 =?iso-8859-1?Q?sOwIVVuokh0zjhBruqKChfdVQAqfoHsFbYSuJfYpFk7LvRHOQmOE85ZxLe?=
 =?iso-8859-1?Q?xWO5F4GqSHEpKVx+T2jv7PWB71GA2nHi9M/0DgVWKiYh16+tZFMTF/9LJa?=
 =?iso-8859-1?Q?fgj717P1is+/Cmup92SQS2W5xejW5HCpVyhh0iKucZ+6e4kRM3k2Kkt2H/?=
 =?iso-8859-1?Q?vya1m3Ud7aD3+K+3COSJaKzluxlHYBw7bkDTDfahWD8ntEDTI2R8uXf1MX?=
 =?iso-8859-1?Q?AnMMm/xX+Y2pHEjLroh8qQUDPwMt1BdTznuUDctH9dtmCsqgR8J1l9WFo8?=
 =?iso-8859-1?Q?l5Gg4LSFGNp+V7eCM2M2fbkpVrAQfrCyDKYNc1O2bEuETjefQk+3MczFby?=
 =?iso-8859-1?Q?zobyAKXg3o+sNLYx3RXjRDiiVwOf71+l35APyGEtEZjTPGSFKxWRB4GIEL?=
 =?iso-8859-1?Q?/KC9ifAVf/iepDWiOPlWGQ3ZIX8c+iGck9LvnGcZfXGTNmORvmv3ipcP8I?=
 =?iso-8859-1?Q?SU5aDS7wMFWVSDoHcpXqXd0leaB0yMFGwtDwF/qv6cvVXUVdFT1XJu0lmw?=
 =?iso-8859-1?Q?ydvZBPlbB+6S4OPA+WYNjV8NvuKoA1gLVAjL+P1PwrfZyBETh1dN25Nk+i?=
 =?iso-8859-1?Q?cWxPX8I60NnH9ki5K4oRRzcic7ZOKsQOng/kBFbF/saGTa2wqu0suCTFuF?=
 =?iso-8859-1?Q?Eo/PoDMxwh7yeveR/GSTpDNOcXaL?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6515
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e4ac1523-f05c-4d69-2754-08de3f16a763
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?0XveEWnzdEnpBHQ8I77Ghhtd98R19TLYFF3FHLq6sk97ycc4XpPtXVM6oA?=
 =?iso-8859-1?Q?xjsaAtRoOQ3yqpKUqVn3JXgfriGdzVzljZwRt5MKWV+0UTI5YRPqOj+k6d?=
 =?iso-8859-1?Q?pxxR3ZdSqwqVqvqIm/hX+DPqXL4GZ2UMmTxQvQhNXdffvGePZHUv2cuhIl?=
 =?iso-8859-1?Q?I255Vyb7+8JUOJkpYHZEX2YDuzbbJNFgoy0oHoDyh4tvhGvZ/wRO39VQHg?=
 =?iso-8859-1?Q?25MP91UcaaDw8oK1nl4rAZKPqv3zH6H6rKKbgS4ORhN3vXL/N5XCNRMF78?=
 =?iso-8859-1?Q?khRX8FYO4RsccuFiHnPtyIyLuv3+i6VnQ4EkEOrBQhSHsws71G5iQD4vxY?=
 =?iso-8859-1?Q?ENtILFcHndvpfELVfEtET8hlWFM6bFU+Qdd8kP3j7bVtA/D5ftYL3qd5W0?=
 =?iso-8859-1?Q?k6I8tudI7pDQ29+cyh/oRyQUdrWADFhk7lJliEfsGQS0EvOqCr3Fn6S2+0?=
 =?iso-8859-1?Q?1Xoi76CB2HdDhh9ADYVyXxZ64pLzCAcpflb6eW1uNE0mGpDq9DyQ7+DpBi?=
 =?iso-8859-1?Q?UBNKZEtr6SoyqBTXDjbLiLJzPyW+YZC7LDtkGRj7DGYdDADyfMSwfHOO0G?=
 =?iso-8859-1?Q?fJKpUCs3bv0tBuZWaa2Wzo8NV26pGYOU076A7ncaOMRI2AA5x7u6M1f2wk?=
 =?iso-8859-1?Q?ewDPvYKBfcHRd5E0L/gz9yEOhAbXJHOHYwU+HqgctsnhWoOFNWU+bxQtSi?=
 =?iso-8859-1?Q?R/5SyM8hfcDgVNo7HzZwG816JTNFE7v0VjagQG3MGqZ++g34bd2t1Pn0VO?=
 =?iso-8859-1?Q?ThhhR5FNeH9jDykjTHbVQ9OxBrKUOmTjGfsnF4P9hoRDdqQPCXmV0v5KGH?=
 =?iso-8859-1?Q?645SgqvTTpWI//kd7q7MQK/flKH9TEZ8VlEmjh9P4bhnsXenWhA/RRo+rC?=
 =?iso-8859-1?Q?zTCNYPd+KFnLxOIKQj/bPxY7dJ+RWh/5YhXLeHdlirwrTxDFZgo7xljS+i?=
 =?iso-8859-1?Q?cRMsrKlMT+1QnB1WYPlxERR76HssMWomuvoZvYb5PLsJlR0+57B/ICuhF0?=
 =?iso-8859-1?Q?dSZ5PExVtHjmXuryjOyYoKYdPQD66/95gGl9XObjaNXmChW/9rB60KQkx1?=
 =?iso-8859-1?Q?lsGEU0WP1C5rN2YVytzc4lNor3lTEheqqO6UJgcC2AYT9hT7ZfR773HhcJ?=
 =?iso-8859-1?Q?EE5hDLSiRKrySGDWu4exzafV8nHh59Hh0Y4J0ncceUJu9G6e4tYcWCHdkA?=
 =?iso-8859-1?Q?UJTpDsxfVTH2AdFibhB4jf1Y6bv2V04wUbbFxVKblkOzuujXXm7CSNeIgp?=
 =?iso-8859-1?Q?OU8K8uvus3kWaujim7XNl+uMydFRnXK3ylISF9+G6tv0tgBAya82gzGpPp?=
 =?iso-8859-1?Q?OlepD3d5kyZ8j973F2F/DobZhNIs/mTtY4wQOLUkC+zsNUB3vIW9rdX8uz?=
 =?iso-8859-1?Q?8ubbEfVInwWNVBstjwnfZxh3osdrT8W+vdvN1uONxY0A2oKNo6isKEt9uY?=
 =?iso-8859-1?Q?veEs2QwAjXBZx00syU8VcgY/tCw3gKkH6MGaGxkxYLgB2RDUwaSi9QYGCb?=
 =?iso-8859-1?Q?3tR3b2RIAfm0DQtgKdTfvp390luyV1ELLaMMyP/32BwLtuag4vx7JpXB8v?=
 =?iso-8859-1?Q?HRvga5iWUokARy2RKgnHyvk6r7h+L6oGI8TDPzKpfiZmG8irVLfp5c2t1r?=
 =?iso-8859-1?Q?iRfWKwjNpAUS0=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:49.4463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f55256f-7698-4b70-d752-08de3f16cd12
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10478

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the set_pending_state and queue_irq_unlock irq_ops
are used as AP lists are not required at all for GICv5. The arch timer
also introduces an irq_op - get_input_level. Extend the
arch-timer-provided irq_ops to include the two PPI ops for vgic_v5
guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state in to the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has two impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c     | 110 ++++++++++++++++++++++++++------
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   8 +--
 include/kvm/arm_arch_timer.h    |   7 +-
 include/kvm/arm_vgic.h          |   4 ++
 5 files changed, 115 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6f033f6644219..78d66a67b34ac 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,12 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.set_pending_state =3D vgic_v5_ppi_set_pending_state,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -396,7 +402,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -657,6 +667,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +703,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu->kvm))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +750,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -741,12 +776,12 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
 					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -864,7 +899,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -934,6 +970,15 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1034,12 +1079,15 @@ void kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	if (timer->enabled) {
 		for (int i =3D 0; i < nr_timers(vcpu); i++)
 			kvm_timer_update_irq(vcpu, false,
-					     vcpu_get_timer(vcpu, i));
+					vcpu_get_timer(vcpu, i));
=20
 		if (irqchip_in_kernel(vcpu->kvm)) {
-			kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_vtimer));
+			kvm_vgic_reset_mapped_irq(
+				vcpu, timer_irq(map.direct_vtimer));
 			if (map.direct_ptimer)
-				kvm_vgic_reset_mapped_irq(vcpu, timer_irq(map.direct_ptimer));
+				kvm_vgic_reset_mapped_irq(
+					vcpu,
+					timer_irq(map.direct_ptimer));
 		}
 	}
=20
@@ -1092,10 +1140,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1347,6 +1404,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1497,10 +1555,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 vgics. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1538,7 +1599,9 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
+	int irq;
=20
 	if (timer->enabled)
 		return 0;
@@ -1556,20 +1619,22 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
-	ret =3D kvm_vgic_map_phys_irq(vcpu,
-				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+	irq =3D timer_irq(map.direct_vtimer);
+	ret =3D kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
+				    irq, ops);
 	if (ret)
 		return ret;
=20
 	if (map.direct_ptimer) {
+		irq =3D timer_irq(map.direct_ptimer);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
+					    irq, ops);
 	}
=20
 	if (ret)
@@ -1627,6 +1692,15 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 		goto out;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers arch architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 56cd5c05742df..cca0b5fb5a465 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -177,6 +177,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 	} else {
 		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
+		kvm_timer_init_vm(kvm);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index feba175a5047d..97d67c1d16541 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -197,8 +197,8 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
-static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
-					  struct vgic_irq *irq)
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+				   struct vgic_irq *irq)
 {
 	struct vgic_v5_cpu_if *cpu_if;
 	const u64 id_bit =3D BIT_ULL(irq->intid % 64);
@@ -227,8 +227,8 @@ static bool vgic_v5_ppi_set_pending_state(struct kvm_vc=
pu *vcpu,
  * save/restore, but don't need the PPIs to be queued on a per-VCPU AP
  * list. Therefore, sanity check the state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..6cb9c20f9db65 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -130,6 +132,9 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+				(i) : ((i) | FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 696e2316f1ea9..22f979b561054 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -601,6 +601,10 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
+				   struct vgic_irq *irq);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1

