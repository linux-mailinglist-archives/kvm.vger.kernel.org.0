Return-Path: <kvm+bounces-65867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 564A4CB91FB
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 955903092426
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DB0325739;
	Fri, 12 Dec 2025 15:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A7lg490D";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="A7lg490D"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011031.outbound.protection.outlook.com [52.101.70.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5C31B11C
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553041; cv=fail; b=s5cghIg/yasFStSQPufaUxUS/7qlH+auzghCA/7xbBRoy+HhKvWb6DBwJx20bHvfjWiboo64ALi24nqW+VBsr366LyWignuWY4zWI9xdgBUdgJo85xUol57pZZMeZT01HmKLRir+V7WPToCbL8HGjPjuFX/NIQk6ZmTKa99fyiM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553041; c=relaxed/simple;
	bh=jNp7nUrFHRkzbEsqEN7N2hPplqIifKL7sBEs8c6ZReA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pN9xr6emP/SAog+qksJdGQE+qXhx5WsXAHmgXr8l+rOcEG5Isk6pgwqLUTciozMxgTLWDpQ2OcjAoDPlb5u9W7jdXDa8PKiT9HUi+b5aWfNZU6RHPd1xwUQ7OL4p+Z8qqVhZXQlic+a3qngFohorDKxTOa8kzXpLqrZAOmwdrQE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A7lg490D; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=A7lg490D; arc=fail smtp.client-ip=52.101.70.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d/olFy39IlrgSn5WTUpklLI5XYVzaR72SSxE8OftfDMNrM2V/YKmkPfthdY5A2UCrjU5h24LIRvJTADDCIGJXVUYRGO41vxZmFz5Z0FzSwC2g9174+YF9oAchZ1nrI0ZfKj0t7ETFDbrdok7UZiouaXaIOABRcxhXetFcpsl1K0SX6uHTqD0DR1oGR64UTCZHLtZFQsvrkyvoZ98hpgntf6kJlhuCVyhhnPWmTSzz6XkXKYi1Sjse5yIOd4CdE6WSyytBp1UEEaHbhnJxqU83m9waVld+4Ftef+WheLgtY8TOfm0swsd7iBrBEesyjP2tPoV33/B1Z6tLFLXIKfKlg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=rh1aXkWDoEWEaCvzyNcAuU4LPwsG8kMf7X6/GTnSDVUL0ZvMTwCIxFd3/Uh7iWGxOednejBoWq1ANh0U8hqs50SPmni1SdY/i7f8YEuv9a6Ifm2I1QBZdYWOqtQfytsEMF4KpNiLG9Kbm21R3Pc4de27AVy4SyquO1h5KQYA+6w9llheJbJP6amVYvRIKjbjwh8mOnnTb2K9VvAA837mWUD7vpnxOE+fmruCNQwjAYJ+rBYIIu1+yxfvzRaaG8H0QBcgc+ylD2mtLZpRncvJP7poVmVoaCAV6GC6s3GTHT34zzE34CozIy/hOWaQGuhPA4naW8tpDFse9gsnUq8bLg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=A7lg490DOnoHSAwMfKVV48F2/Z2rFInwTMNWIoBMlctYm9E6mAO9hRSvoErjrR/85QFd7S+eg0YuDrwvImi8xf8dCctM/Fbk7SlRBlyhXat/NY96WsQ20p6P18Ns2yON8aFYjVBh0HGhCH48CpX6zWokK/ZkVUVu5q3gHqBWdbg=
Received: from DUZPR01CA0304.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::6) by DU0PR08MB9800.eurprd08.prod.outlook.com
 (2603:10a6:10:443::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:52 +0000
Received: from DB1PEPF000509ED.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::41) by DUZPR01CA0304.outlook.office365.com
 (2603:10a6:10:4b7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:24:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509ED.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Fri, 12 Dec 2025 15:23:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pJJqQ3u/KRdAuKIBcJp54MN7x2ZSiwtPxULHGijGDQTyeDZ4RRF7L+P3pp1AdbtDakNfiyqLfk0dAmhxPZ7GfRftvifz4xCRXHts7kOlfVbY1dhrPJK+CfcWAn4X02CflY4huLRtBgQHcoUqCWfxnf/bZs3x8hW1q+NDFAo4VfPCd57nQ8VVP5jzPwunD39cE+xKGGaEItfIVu5e7aU69/Mc2+pCZv/EkelLn5eOSC3skneLx4But1xxt674EOTJ1cjvcWwJSvVgNEYg6GJn8BiBaZ8Rcz4MmEPI19BTF46Eff+2GiTOBzi24su4hSMimqkakbzeULsN1JlR8wYiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=pfWn23S9cIUQ55soEuNGGjKQxCR2Y2nz0auYysuRxPkjQ1B2Ssr8/OI7Dj4VV+DZ0HFjqHwKKOniTxe/fjEBRkHWd+XZkreTK4bPpGLqL1V3v5r9NnPpxW6nvIlYV3cB/Pa9o3+FgCVfgAJ1ixIFpVLdlYjcN3C0JdMBC8zrNfQFC0K2BIHc1Ac8knhc0/2SD9gIXwX4ZVFpxvuuu45dXfG6LZ6hd8Vz9xzQGFoqrxtbhrz1XU1D8xDL3j5QRYAvajj/WPmeaTzYT4ZuiVV8fTUw3Axu6+nOIV634HJFQXrpJdbF0xvm+WetAk1ealPuo33UIJakXflUAIl3vdneWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn7IeW4CjFvq1YLy/rZBYSBXvoXbisAZ2xECaiHx9eE=;
 b=A7lg490DOnoHSAwMfKVV48F2/Z2rFInwTMNWIoBMlctYm9E6mAO9hRSvoErjrR/85QFd7S+eg0YuDrwvImi8xf8dCctM/Fbk7SlRBlyhXat/NY96WsQ20p6P18Ns2yON8aFYjVBh0HGhCH48CpX6zWokK/ZkVUVu5q3gHqBWdbg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS8PR08MB9386.eurprd08.prod.outlook.com (2603:10a6:20b:5a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:22:49 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:49 +0000
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
Subject: [PATCH 26/32] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
Thread-Topic: [PATCH 26/32] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Index: AQHca3spK+24ZdsDykKtjs1zW2V8nw==
Date: Fri, 12 Dec 2025 15:22:44 +0000
Message-ID: <20251212152215.675767-27-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AS8PR08MB9386:EE_|DB1PEPF000509ED:EE_|DU0PR08MB9800:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c48b4f-6ce6-41cc-bb82-08de3992745d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?symOyVsAVe/4p4Fw/hF2GgXbfpjuKyuAsWpNoAu4E336t2VWGrW8Mxoc3P?=
 =?iso-8859-1?Q?aKVJzg4d4jG7NgenpZlchqPBlAMHy6fQqVf/aPmA9bVbQRwfbGNh78sMZS?=
 =?iso-8859-1?Q?SuU8xTpJxnSDVNGbTQFU+vScaN3eS/xTEGaCll2xUf+ksMRPJHb00GCOrU?=
 =?iso-8859-1?Q?/1z5LiuulfSv6Lhp4WO4tq0a5ghCNgTlN30Xr6tjnrL2VVNme7R2HrU5lm?=
 =?iso-8859-1?Q?RnfamMD1NRFEH3M5E9Kg0gwCisbNkVinz6eNakrnaOuG1yuLQCrJidrSR2?=
 =?iso-8859-1?Q?0+BiCMeYZeQMIfsNRoFZcRpbnU0PeAwHrF4mXvbHvN7P2IemGLFu+oWBct?=
 =?iso-8859-1?Q?8ZD0meAYZrVjVQC8YiGCpR46Xx58QMDJn81LwG5WA/ECVxYLATQ0ZpJa77?=
 =?iso-8859-1?Q?bwSPgl7kjbxxxZYBaTY7rb3B5sfrZbpQ3u1VZoVU2aGakjAmhJhesNhGHp?=
 =?iso-8859-1?Q?cRBjAeFY+nkGsviTqz3JHUt7ZqZ0VkKLIy+I70MvNf/C0UObbOWGtKQqdv?=
 =?iso-8859-1?Q?7uPalMhMj1CbCq6YHG6L7/F9q8d96aFbjrJpMmmyG7dGYBIdFbKGiFXQZ4?=
 =?iso-8859-1?Q?HKNnccMdcZdHkd4uusHVVO+wdFdQBzXhLRN1ZAji5n0B5qy6OTaS2jVdSY?=
 =?iso-8859-1?Q?26t9nzysLFe7dKW1V3fLXh4A32mpZMSurE1PmqJFhGxQH6gKbm3NTrvTT4?=
 =?iso-8859-1?Q?oGB4GoHoVQjyscFhQh6seKNHh1prJ7jagnEcfwcstLYqMpAxQlbixgArXw?=
 =?iso-8859-1?Q?CdppxzxLE9N9MASPqpjzassFX8VomK3XY79mlf83G3xFBNZBXVS1YgATxe?=
 =?iso-8859-1?Q?AJaWXDQNAEQKE1pM0iqViD46R+KMtJe5Wm2N0vGYCU57ixe5fTjDVc8OP4?=
 =?iso-8859-1?Q?ee9dRFbT/vuWRdp6OTGtw1UKj6kEiUP4gQCdg8Y/nKosvaGxGpO5vnrYZz?=
 =?iso-8859-1?Q?0EHty2trjjitvCu+yktpfOW+n1AH+xtEh1KbSmVCAmrgkwYqlxhXs5U85p?=
 =?iso-8859-1?Q?1gr/RIRmN6L5gH9NTnlIY9Alz5jT3BLubJBC1meK419sFrB/+JkG/JJ+UG?=
 =?iso-8859-1?Q?OnjNv2X4jbu+vmTsYspAewDFOFN4MZDOkinQtyzVnxx7B6v1VvMh2KXS1C?=
 =?iso-8859-1?Q?e5U0sJeeJu8jx+I5HHtBcuqSDbOyTOdXvEFYiuiqGxGisFsx3bkjUlTDRJ?=
 =?iso-8859-1?Q?QXqMSJT4LjVPxZa6dqPVjj5ui2VTYqRF3z+hY4MxsL+zK16CxjjrwDmAiX?=
 =?iso-8859-1?Q?W5asPd3LMfss5DRDs7dA7xZTbkiqUOYJmN74EQNo9G+ORPC2nUxZGKGZsz?=
 =?iso-8859-1?Q?q0uxPNuIv0niBcQlsm3p24iiF7AUL+TZLXiwf9+it3KRxA1lvjkMEfNmM6?=
 =?iso-8859-1?Q?kRKpHcxNgAEQyScoyOHdxYGhjGQAU7dLXJ/U4kBuqcCrF9kGQOTte2FYQk?=
 =?iso-8859-1?Q?Mfuggc7ZAIsSpzDZlNs9vCcFq7qrtDJvtGzz/xHoImF8rvfDZ0I3QPVTnU?=
 =?iso-8859-1?Q?AchPy7M/KPKNRtWN4ScbYvZaA8dl2HBKEEhWnTaV0d2RY0H8Dq/9RIyklU?=
 =?iso-8859-1?Q?f0VYC2PieqjArW6S7DaLWKJaTcLT?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	62a77380-654b-472f-0245-08de39924f5f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|1800799024|35042699022|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?dL8qlSkqlq6QwuEhYbfl6jLktOtbWkAn04QEQZUszqiVQyJ0D2J7nh21mu?=
 =?iso-8859-1?Q?S7nfSuNMGtHmHjR66VnQNjo1lBb9hcvZiBR59bbwxKXMEK9edmDMIh7ba9?=
 =?iso-8859-1?Q?YAbV/WmX3hmg+jgPmDP/EVjp2A4lO7+jVZjVezi1Li66/3ZcCYNrN3IOhy?=
 =?iso-8859-1?Q?Gq5Wn7XEULfuM5P64t3/oWT6PCp55FG7xKdDhOEMej0cwp6y1kTxJqF/vR?=
 =?iso-8859-1?Q?RoKw7ahjqeNhMlp+QaSxFoiqy7w8dPkS2QcGjSzCgBg04tn6otPAJCPty7?=
 =?iso-8859-1?Q?LI3wXxhmGdXuXmuroR+IhxU6N3nMCQqDY1HnHMqdQvwaV3mZIFRAzAeLVm?=
 =?iso-8859-1?Q?maN2r9K2WPWVfFke4K9soQAmEME+7VvK41+uK5to3yqD8RszB0F0MepzUl?=
 =?iso-8859-1?Q?RQ4m5yLk2Z+qYSdRp3v7mtIR9jZ/87dkvM+owZswf7d3H5/7cRiLp06WeO?=
 =?iso-8859-1?Q?SJ+f7mHWS+riMT/wp0J++AznNWHYV5jZEq/zGMiJ782E3i4R1aLEnYfBwS?=
 =?iso-8859-1?Q?hs4dZL/wr28l9SM7jJLsQUTHGE+X5kOuWLnXCNPS4yHtD/mNAYCjxOm9jm?=
 =?iso-8859-1?Q?hUHy6y+9Fy9leRil4NloTIXgLl8qs5k3zADfvG3AXQxSTCESSNgVDtk0Qe?=
 =?iso-8859-1?Q?+ICvniJxpNk/6Q94/TF5IxiDiqk9bkufqUwzNEPQa+xbq8IRNyDlm5HT4w?=
 =?iso-8859-1?Q?7ba2KuFuayL5YoxX3volQYMDIJ3lT72pRZHNp81sF9UbQufVY58ViF68/f?=
 =?iso-8859-1?Q?3uWXryUPkc2/hdnRrTfSH+Nkdj8xtmEJeJRUoxIxw5vUiV7JLRpTPnc9TO?=
 =?iso-8859-1?Q?vwfTti4OjUB7nVx2Wr+pnWMAM5GVbqKwpHEkve9p7vlfWdEclrgOk4JGOt?=
 =?iso-8859-1?Q?NBMb3JXOS+qx0m0I+IBL3/5v6v7CakD01+n6ssNI5L17Q3sk/xSgScJjBG?=
 =?iso-8859-1?Q?1ePgbkk6dAkzscGYulV5zK8S5AvM/zV4ve09rwZY4x0of1Z+YGPleVqcnz?=
 =?iso-8859-1?Q?CLjKwMkohYdtxzsghRUQR4RvTqNtvqu8v2jAIJ2xk7F+Rh0zBJVHoEMCuX?=
 =?iso-8859-1?Q?tOS5cjhF23EN+ygum8AqLRaWR1jEzKHAgrlAt1R/qz19fW87FWjYHqxU8d?=
 =?iso-8859-1?Q?kNQX/o4SKVYnn2aQTZ0+nVxKgqJYmWDiEslo5jh1icDH1qycYK1TPNcsg3?=
 =?iso-8859-1?Q?VViCP4VfrSExhATFBqMPKWhpAaWAczREHmJ5yovF08tERhAP/a81YAaGvk?=
 =?iso-8859-1?Q?MZ9F3MGbjjVxiAWA6XAtfMGdXegiF/8GjACfZBiPJCo0/2gtam0lJIEx5K?=
 =?iso-8859-1?Q?Kc8wEnLTEe+KZDIMq3yP+jayWiGd1Cd2usgF9wwVDOl9kkovlwxt80JZQ7?=
 =?iso-8859-1?Q?JO8wR/6iLKpIBpDzuw7hqCHyvfDUeWxnCnQVNXkDF6yWk/jmPbVYzqdfAD?=
 =?iso-8859-1?Q?GQxGIsp6sMcCC5ObIIhYmvxbA3jQSFyu9pQZexmtibYcEr/oqVEvgUu5tq?=
 =?iso-8859-1?Q?M6X5C0Ti2BRTF9HoMVqhlvyI6AhH5ovGmR2mmC5+1WBzq7mFEuXQzDP3GK?=
 =?iso-8859-1?Q?U9DQJInLHJt10WlvBEdihC4LwONn0uhX4P7pMEesXennL3oDBKGjJQL0eW?=
 =?iso-8859-1?Q?jGlk/jgS1UjFw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(1800799024)(35042699022)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:51.2514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c48b4f-6ce6-41cc-bb82-08de3992745d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509ED.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9800

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e722..66404d48405e7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1547,6 +1547,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1

