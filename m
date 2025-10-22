Return-Path: <kvm+bounces-60823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E05ABFC50D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AA30B56743F
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C0DF34BA5A;
	Wed, 22 Oct 2025 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jjPuzl9f";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jjPuzl9f"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010063.outbound.protection.outlook.com [52.101.69.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F434B1B6;
	Wed, 22 Oct 2025 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.63
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140779; cv=fail; b=apqM2Nm7luw3lzlzj4LplkKfc8SwMDY2I1FMZx0ajwKSlvESwNApPIWeaIfh2EpNTC4TkO89SCPJWoxvtHvvAFC+ViPC2xmvbyJU7efqQd561gGv6jPTm5NbAbQSOaAaD+d1x75FMeSTQNI5WXYMAqrR48Tv4hTtTsomImtdQ0U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140779; c=relaxed/simple;
	bh=TLgTbs1o0zbYLIwzj0NJTFXd6dCU2i8if1+tR+NGGb0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=btSehwR9y7IL8K+q/AV0MUVQTQbD5JvuKI8cjKvu6/4Q5EdEszCdMR6m96/XW55BlcbYorIL8DSm4UFvbD3pzSNFKgz9682x3adlMMhg8ts/jg/sFDD5TtM9uLeuXLDk+rOTrirDdfJJBaou8uGl4mLW/ek6MdZgIHznBZxMYro=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jjPuzl9f; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jjPuzl9f; arc=fail smtp.client-ip=52.101.69.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KRZbs0LR+Wf5mcC97S5SQcw0nH5DS+GnnKcRRESRDWlIwO/UWPY4+wT8MtOWeDqTKMhbUK98z3j+9AA7vEAbvTWiHKRyIruvey/B57eWLrnoqDWdCqKBm0e105bBrh3X6lhWI15dF1nlo2GgfngPnBKjl6mlg+HBezp1RXJNGUdl3rhfPcY4hSdrIaGruBJRU6XAsFQJa1MOGe+03b/twGD0z80sqqwdwKC72hUgfuxesDEhknZZXwTP59Fns64wqDrr68niVWKJ9T7DFFuImOMyUOT2F9+DE5gbS3nGJEFBDfyIHU/6Cp6+LedpMIefcIVIPpUotVqrodZF4Xtrxw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97X09zMBOp+vyZhl2OHRPJSZXgLZ0HL5NfSgV3301VE=;
 b=mIa5mFaOwpXdf2aVQj23SAvzMw2nLZz5Cvl+Vv7kuqKDFtSfIQCeOeIKiGhikjlPsAJGU7qUwk6cRHDZeDuWYutkr83uZkyRDM0XlbqT9czpHYNpLA1EwsrOtj1vm9DRQRGCu155rhG7LpQTwuYEYUCjpE+8XIgI+A5nphvxZ5xW3TQ9CfH4hPlSN6DouE8z8yLMHrHvOMHgh1qVjhkd+FJbfOec2FmogBqSbs2NJO3JEFwfKYRDWzQk2/cZSRTXoWuz4+AH4R1pqBK03MwUCWK2JA6YPRJmgirTVcC6JZxGwmFRstLNDVqhhCOyMSlDXSc1F/hUH+BlZVgkLWlRoQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97X09zMBOp+vyZhl2OHRPJSZXgLZ0HL5NfSgV3301VE=;
 b=jjPuzl9flUXxHWvnODdo9ccQEGVfy00+d6JUrAzFphgghIyp4oDAY7NKIjT5/wKT5uskPaFjtaIp2NglfT+Vqaq8wFusc7pfSkZiJ9vccUZwOGlSilfy142+vaejaQI/BZlNpGBvCiLSr7G9iqO+XMoUUUOEhNoKnbVhOK/zsP8=
Received: from CWLP265CA0346.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5a::22)
 by DB5PR08MB10288.eurprd08.prod.outlook.com (2603:10a6:10:4a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Wed, 22 Oct
 2025 13:46:12 +0000
Received: from AM1PEPF000252DD.eurprd07.prod.outlook.com
 (2603:10a6:401:5a:cafe::6) by CWLP265CA0346.outlook.office365.com
 (2603:10a6:401:5a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Wed,
 22 Oct 2025 13:46:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DD.mail.protection.outlook.com (10.167.16.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Wed, 22 Oct 2025 13:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVYZpS/vTyMZSBlj6E+CLQukXMQ+9A3l9WDvB3XuWo/6e2FHF/XetLWllWIjwLwXHwoVFIq6PgIPhahMocujelUFf67lKHhrQ0Qstq0TJVhsmDFLupkCb7qtg+cWSvG0cm6ml9BrynfKxlHqOCzjCOUppxzVHPLsdBg3Eksp/sNab6eWD2NIzZ2RNJzdD96UGNUX08FauifnhBr+p40QHUgRGHt3J2Ew/juouhe0haJGswaCkVuDLZs0vPw3VPfKiEX9fEkpNupMkC28NK1YhIzpAipXLDkmFOqBpl1zgvJZTk0O35Ig0TdkTrRLa8upqyXsvUr8zUum5o8PzJZdJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97X09zMBOp+vyZhl2OHRPJSZXgLZ0HL5NfSgV3301VE=;
 b=WsMRF7XuTXrbFxTjyyRGPao5bFe/2+vVV9WNAKVgbG/BvTlWB4slcLjmP/gi8uoM6bI3hGkyMR72ZeZZoPvWihwGDGbdC1S4vIj6VrQm2LNr8SUbNkK2u7vzqHgJ/N8NWfV/FzanJqOX/MGXDCNayvi5AwcYjTIbWELydcY94RzJpO+Q7seCKD9J5epVBR/vqrdgJyMvCUslNSm/80ZGvqxqzIlF8FvfEGkQBZO2yYefc4XqNi/OrkFmtrT9hU2t4tA6e6ofrfZNQ1v3yBVKfX+HaR1lo0lxyskCsKzvS4RzVAgv48XvBRMROWGJt8ba3jH2btOPErLS5uUlq7bU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97X09zMBOp+vyZhl2OHRPJSZXgLZ0HL5NfSgV3301VE=;
 b=jjPuzl9flUXxHWvnODdo9ccQEGVfy00+d6JUrAzFphgghIyp4oDAY7NKIjT5/wKT5uskPaFjtaIp2NglfT+Vqaq8wFusc7pfSkZiJ9vccUZwOGlSilfy142+vaejaQI/BZlNpGBvCiLSr7G9iqO+XMoUUUOEhNoKnbVhOK/zsP8=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by AS8PR08MB9244.eurprd08.prod.outlook.com (2603:10a6:20b:5a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:38 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:37 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH v3 3/5] arm64/sysreg: Move generation of RES0/RES1/UNKN to
 function
Thread-Topic: [PATCH v3 3/5] arm64/sysreg: Move generation of RES0/RES1/UNKN
 to function
Thread-Index: AQHcQ1ol254TFjpK4kOS/Hc3isDp8g==
Date: Wed, 22 Oct 2025 13:45:37 +0000
Message-ID: <20251022134526.2735399-4-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|AS8PR08MB9244:EE_|AM1PEPF000252DD:EE_|DB5PR08MB10288:EE_
X-MS-Office365-Filtering-Correlation-Id: 743a1be5-4460-4af0-029b-08de11715ccf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?mKsrzfBOTnTqeq3U2DmRBixRErCT9tNi26JVxfqgXjC/OD568+zrMlZ1Q0?=
 =?iso-8859-1?Q?GyS4XOLBHpwgVdz1hEfsth24Syy333/yROeFbDtubojcMCP1Mo+fCpty1H?=
 =?iso-8859-1?Q?Vy8LzQDXDNZPs8+yYcctnT/2isVCKkmBd1V5Ltg72XdGfjnVkSgBn+SsPd?=
 =?iso-8859-1?Q?mGOUR1a6iu6w/qcYVXvc9dT7vdaluRuayfK6e+u93eu1aBxcmzJ4yI9zAi?=
 =?iso-8859-1?Q?1hw0aaSHYgdmBJkutMkNdwasgg370M/xvfVFlpUzU2p+QUFmZLpMs0dhdV?=
 =?iso-8859-1?Q?LGl7OEgnIw/iZlorPT+ecq9yb8BKjM9VpVBXiA6OQmZVamB4R/sf4J27J/?=
 =?iso-8859-1?Q?lkzA/We6OvcWwGUzgvrnTlNdtSjU0MA1PlRROTebURK8ttJf/ip9osPthh?=
 =?iso-8859-1?Q?+i7POwmNzKpc2uFHrGGgFwZi4NLtBmPeYtIAobvANfA2mBUrx/PJccACte?=
 =?iso-8859-1?Q?ta641kJTmWUDvlnO8rdL6d1NvSkdm23TA6GfARPkEj6fVVKVTZlX4lYoQF?=
 =?iso-8859-1?Q?CFDO61t2ZCOsIbKVlhEZxJJ8000DdOIqBVjvwG5vkwZvsjkHwL9xKDKfUW?=
 =?iso-8859-1?Q?3K/P+fiuGFr83uhs5E/u6CAtm4lU3tU8Qjyij7idrWKPrhZNKJHPykwm23?=
 =?iso-8859-1?Q?h7Fw8Jkdw8GufSs49bDLfCXnTo05viOmdMorErfQnlcGT+L4QZI7MeWC57?=
 =?iso-8859-1?Q?i7EsptvQ1y5ZNHp8aFrEkCGikE0FImJqJdBkdf6jH9p3qygc0PCkt8RKNE?=
 =?iso-8859-1?Q?M+MgHEb3l1dvo28e4ZcMQYUP24UweudM2ahCxpXqm97uIHmDGOp+J6+5x+?=
 =?iso-8859-1?Q?YtGEHBlqvFJoHOJmodLAsnEZkXZXcTEcglEOmbjZNTRuaaTkhufWPJ+YZe?=
 =?iso-8859-1?Q?5YWyDTi+6B8O7s7cIUXDqczDn1g1MvNK2Qn/ToYT7qNJL9pTRotqgj+Gii?=
 =?iso-8859-1?Q?+xI75y5I1lIIENmczNi9qoCrcZLgHxhfSX1Pst08DtjWkrGYlEHaWF0j+t?=
 =?iso-8859-1?Q?6RjICWMzf6IJZDJdnf/jfLZIXaT1RroN3VXFN9XEZAwPLfKen7sQ+ULYBB?=
 =?iso-8859-1?Q?hveZoHWt3P8vma73hPubRndhqZx3pqm/Ou728pGXkXcwVEZAdhysQUqm7k?=
 =?iso-8859-1?Q?EwNy66fRL7j97HqnFNX717zMiHKJvUepMUGS1M+G74IqJcyV2RfvFgTsnX?=
 =?iso-8859-1?Q?XSGN+CXTMPs5XOIpH/er6ptqQKkjngrCFbLu5TMyIWyLLWo0ISlxE7YDE0?=
 =?iso-8859-1?Q?N5nc0rOqN1B3CbG8T1u7l/1FYIXBiK4vbII5RcnmT9WzGlz24jF6dnGsTo?=
 =?iso-8859-1?Q?HDrybwncQ2AUYkDbvGGPoQkZTKPX2vjghU/MnMhXwRZCLdroDDnt6QZW8v?=
 =?iso-8859-1?Q?lguhWmxA6XttN4BVVfURiAUl18O2mFQfbIfd/sNghe8gnbctaJkCP4wPnE?=
 =?iso-8859-1?Q?OTu44RyDoWlcihXtQxK9ldzersjbINVoe7GIYoRslNXhineRrKlfeGzKEw?=
 =?iso-8859-1?Q?kQrJRcevIi/rskddzTVWo6u2Qy7lmTtWpYfEvVp7Xt56GSsso7aAj10hxN?=
 =?iso-8859-1?Q?l9FFnb+Ea03jSTuhKVX9ZA5zGl6v?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9244
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	20aeef4a-4837-4eca-a149-08de1171483c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|35042699022|7416014|36860700013|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?j/vBIVpmz4b/UghS5YuIiiL7dbNyK5Y4INe9psJsYc3g868qWLFkQJqgPW?=
 =?iso-8859-1?Q?EJXREAV3vlEYG0cJdYpIJXPNsO5/I83SIV74xlPyfyvp2TlUKVUXx8G9Ey?=
 =?iso-8859-1?Q?4w8LBGqce/y4TBTGuhGCdajczc0w4uOKp5GlTsO35zst+gu4F344bU+Hg/?=
 =?iso-8859-1?Q?OTKXHqwdl2RPPxAFBYlozlacKoA6kBC4Z2uEu8PSqvFNHwGPx+v4SW5wC5?=
 =?iso-8859-1?Q?cY/SL0++NLGomPCwHhtV5TjxEfahspDlXM5ih6t/hoJ+KLdce7nV5grCMJ?=
 =?iso-8859-1?Q?USp3Fa8gB73D1hk67bf1l0eHI72QoNsDaQoayyasJV+7JPjt0dtDpJNkKb?=
 =?iso-8859-1?Q?iZThFSWcadgTdMeQmJEHEDPJloPMBmc/xlGKiHsyDych8zcWIg0w8zDMqg?=
 =?iso-8859-1?Q?2mhRX96xTXomMPJBzVuy33waPah8J2c2cIUNOPepq6Sl9CF76txSbmKhLe?=
 =?iso-8859-1?Q?e+pUXKFaWrYg7PWLe+yX2Ie68mIcZGrJVFnkqm7m3TG5OFRlTO2wpP62On?=
 =?iso-8859-1?Q?uC1P3LmbOVX8gwpse7QKXrymqRKNwT3eVQjWUi8k5aUKl3d8WlUS770TvP?=
 =?iso-8859-1?Q?Qb0j7vtRzH8w9NR1tSKLhhr1yc5gmHviqeJ7GYpUZa89zLdoYuj50a2mKr?=
 =?iso-8859-1?Q?lYvyCTaSZPJeoiyBiM/WM+US2TYeIk0dg55s8SWB0IhxKpotN20R5K+ZYo?=
 =?iso-8859-1?Q?Ex27RTvGywdUDCBT6kZy6MuHYMdz6VjlgNzrjczsLWXU8YAFq2KBnMHQkO?=
 =?iso-8859-1?Q?VzfJD5LCD8Ut4J1nrjZKs/iWMbwR5Iq8KIT8fr+Ru2rWnQEou9urB+hkH6?=
 =?iso-8859-1?Q?pN/anH5CTqvfeP6IUPvs5Nx9QslvCLgrUWcVUTqkuC2XVVsBDNoUf8TGsm?=
 =?iso-8859-1?Q?Jkz2dSa8f3Yoa0oHUuAvxVJgduTsiBV/0xnFbpqHEw5Ss7t+YlexoE7FMK?=
 =?iso-8859-1?Q?RCTpJsVLA4eXtXmeZQo4EqnTLZm7I18x51vNlSk4eY9UnYteevPPcBHGbp?=
 =?iso-8859-1?Q?AiIxSCtsFUvujga8GIU2vvesfH1kQxEZSobU1eciXrQHQr0YQNlNozXQqI?=
 =?iso-8859-1?Q?2XTL/bhSPyZ6gt7wfHrw0F6ChgZGY7Rgzdw7grZphH45U3AeoAg+QJfAiC?=
 =?iso-8859-1?Q?Ker5t/GA+PG35g7R8j2B1LevdOfKt0FZ23cJLAKRGAdIuswt18TbcbRKm9?=
 =?iso-8859-1?Q?XW6Lj2xQxIkOXnB1PMZFsRkUUfb6emWrLvZjR4W/MdJ+aDDp+ya/TC3RKD?=
 =?iso-8859-1?Q?kuDB7VrD0ALbpqesdZwTpNa++QsdItWgWxpDEhDukkNZ44JqXIBVsN6L54?=
 =?iso-8859-1?Q?xOuIgTF52nN7cza4Jd8K6Bsu2iBLiPnPKs6tZQlyPlI5Ixe9VI1GXcdpQa?=
 =?iso-8859-1?Q?Gi9nFJLU4lb9PV4h2AjjIi06dyHrUcZZvWldE5vRsG5FER5kgNB4mzwevt?=
 =?iso-8859-1?Q?6htyyPRW9am7SXWV+7iMUzFTEGKH+HC/XEtjXXF94Ql11Efjcgv20UN7SX?=
 =?iso-8859-1?Q?vlo9+6rtyhq/GNqpsVF8ME97omRetgW1XEEKW9GhX8aZpeBLoFX0oHRb1j?=
 =?iso-8859-1?Q?v1hFyVpHS9HuQiMx98AeuCHhce6Sa1XKjNH63C+D2GyoPrKIQZAUbYLwP/?=
 =?iso-8859-1?Q?8/gnAj8BXKhE0=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(35042699022)(7416014)(36860700013)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:11.8282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 743a1be5-4460-4af0-029b-08de11715ccf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DD.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10288

The RESx and UNKN define generation happens in two places
(EndSysreg and EndSysregFields), and was using nearly identical
code. Split this out into a function, and call that instead, rather
then keeping the dupliated code.

There are no changes to the generated sysregs as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/gen-sysreg.awk | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index 3446b347a80f..f83892af551d 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -66,6 +66,18 @@ function define_field_sign(prefix, reg, field, sign) {
 	define(prefix, reg "_" field "_SIGNED", sign)
 }
=20
+# Print the Res0, Res1, Unkn masks
+function define_resx_unkn(prefix, reg, res0, res1, unkn) {
+	if (res0 !=3D null)
+		define(prefix, reg "_RES0", "(" res0 ")")
+	if (res1 !=3D null)
+		define(prefix, reg "_RES1", "(" res1 ")")
+	if (unkn !=3D null)
+		define(prefix, reg "_UNKN", "(" unkn ")")
+	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
+		print ""
+}
+
 # Parse a "<msb>[:<lsb>]" string into the global variables @msb and @lsb
 function parse_bitdef(reg, field, bitdef, _bits)
 {
@@ -143,10 +155,7 @@ $1 =3D=3D "EndSysregFields" && block_current() =3D=3D =
"SysregFields" {
 	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
-	define(prefix, reg "_RES0", "(" res0 ")")
-	define(prefix, reg "_RES1", "(" res1 ")")
-	define(prefix, reg "_UNKN", "(" unkn ")")
-	print ""
+	define_resx_unkn(prefix, reg, res0, res1, unkn)
=20
 	reg =3D null
 	res0 =3D null
@@ -201,14 +210,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysre=
g" {
 	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
-	if (res0 !=3D null)
-		define(prefix, reg "_RES0", "(" res0 ")")
-	if (res1 !=3D null)
-		define(prefix, reg "_RES1", "(" res1 ")")
-	if (unkn !=3D null)
-		define(prefix, reg "_UNKN", "(" unkn ")")
-	if (res0 !=3D null || res1 !=3D null || unkn !=3D null)
-		print ""
+	define_resx_unkn(prefix, reg, res0, res1, unkn)
=20
 	reg =3D null
 	op0 =3D null
--=20
2.34.1

