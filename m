Return-Path: <kvm+bounces-65857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A35E8CB919B
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 30529300C347
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27813246FD;
	Fri, 12 Dec 2025 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QZaDqOv/";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QZaDqOv/"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013028.outbound.protection.outlook.com [40.107.162.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F0319604
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553033; cv=fail; b=FgcUolAKKwsQE+py0KlZDMxk5MwjFdjw6NzVEmYj1eiZKnZvC5u5t/sT9GGXjYmHEKselpcxcwJL6DSaSlELEDVkf5j9qqtAz1ItnDb0SkpesV5UWhilE1YqvNjgrhTlxK5IqlBMuPWO3PkocN1xBbII32NwtaYetjhXMaatrko=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553033; c=relaxed/simple;
	bh=zM98x5+lKt6sSkRRNG7vldGiramZXUbM+pEXz/zSfao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jw/mPy22P7XJJ01Su+5jQ6M2zUzU4P6jxh7g1qiq4YXziGbhJqQYlRp8bMSCmhzrtXkuUiwTLlIVmU1zi46vYHzsJnp/4D/9Qolefsv0V1RX+GKNOdqtlQUAJuBNk7ZctD6iaB8Gz3ZwwYIUQOCNOpkTIWtiCUFe3PvjcI9mlN8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QZaDqOv/; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QZaDqOv/; arc=fail smtp.client-ip=40.107.162.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iDfLPEd4jg7u/6YI2cC18Zxkmvc35TwbLbWdF5m4WmsaBz1yAEYb4xlhJ2nriOWgxVQpw7a+mfkOlI20JU4X5SBCsMciNqo9h6V2QHSbqFRAVHI2cvENb1B3P4wHBwR0HGUEbO/p/WDPhuIACJsIuLi3ye8TNv8g+WcOL0jlbE1oUHbXQ9qmAnnffZaa+Fns0jzeXdeU2x0a5PNJYY9CCNdkFpuqr4aDpxZHDPlqOanuafr5DbpOE30/tdT6PduJONW+P9JRL9OFhKL+vRkv3WZmFM6EPUvVPSM3yTMcX/aTC2EMvlnriuqw9p/VoeH+9kASk0ht9QlAmPuwl4Fvbg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=KiK6HxTXgjb+tBAknH+LCr3Jqy7X+a165Fk+BYNArisVwFVT43HSTUpDY1xpAz53cmWZ5BOrDFc2v9xvnrl0mSXqQLxIvYsGgnYNdrQqbw8Iia6qtYTgH3kjPSLZinMxVts5QciC1M7Yqzd3jPhOQfj3yqJnqj9Y54ojW5h5iQhn/GUgK6ywqETEnhjTcK72g8Evbeqi8+KmaSjclZ3T6EdniUSKyZjQOFp81NBsIOTT31fugScwwGxRfLbhazjeNJoes3T+VbUEAuuxZK3Du9QfSPo0TheE/nfLkKew00+T/MJmMnYODwl1p+aPfLb9I/ALY2dfyqehWJ53XWcLlw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=QZaDqOv/XAWAqVGlNCYU20cQroSUvLM8Qwyzooleb2/+uRP5OUioSMIsj49qQDFesq183iEzye6ubzYMqnxfIMQZEv/lXnszLKRtlRDL6iuuXf1kyTrelJCurAPUazp1e+ovGpVO0etaTv7mzO87SBi23IzuzhdJ3HF0RHX1AaA=
Received: from AS4P189CA0024.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::14)
 by DBBPR08MB10483.eurprd08.prod.outlook.com (2603:10a6:10:535::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from AM4PEPF00027A69.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::6b) by AS4P189CA0024.outlook.office365.com
 (2603:10a6:20b:5db::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A69.mail.protection.outlook.com (10.167.16.87) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkSkZQEkdzR09xLWE9x/eJXXLd0bSLBWT+R0lRtc6Yb577wIxWoBg/F1IumP18+J3lqATmCrSTlDuQbmOqeip3LkWN24zvb1a0pKqeBsEZjdBlgm3kMN6kUoRx/48uUXYVjltZFU4dzfiCB4UHFphYo9YxsX31iL/CXEN+mey4CBJzLbuZWgGYyRMrMFajHTSFiauTT1oNn5GdUG2nCs1olvtGmv8mzpr+b9ytSXAZtn7/J9U678P8gE1YPY3rVCCNXrlpQWEJd46iAByd90i5SdI61MGt0qpX2rHPQr9JFJqlvBv+xmFUL8JSs2d43BoZg4I/PwfQSw4ivAXNM9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=I4zCIXzFEdqSPkBXNkNrULGzp/OIgRDNMk1AGJYXYKwzADNeGbUk7/CZO7eVAQiFm9m3+wz/6dGOpHWWnEj/VKC4k1p7EbqjgHB79L65gPT2O/Y3smFZxZCwVER/kUItGsenQlkh+LEDpCesQM5WGJX09jwhToltcw551G4b//REr+F6np+Dia6lZBIcCRoMCBtwQ+Qfp97Fx/ElHBJlaHjpV7xWpVizDcuOLW8FpYtun7+uaiXclZTbrfDwRFjwfLIGiRL6YuUhWYUVRoqmJnWr9d6xV5ldXDHgH8yiExhJuLAKE8h6mfIVnTwr3KBwqqjdBE2Kx/LTFfD3Wdybyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwxyANOLvSzdvDCB1LM08Yj1dOd/6/t+JPTmbglgNqY=;
 b=QZaDqOv/XAWAqVGlNCYU20cQroSUvLM8Qwyzooleb2/+uRP5OUioSMIsj49qQDFesq183iEzye6ubzYMqnxfIMQZEv/lXnszLKRtlRDL6iuuXf1kyTrelJCurAPUazp1e+ovGpVO0etaTv7mzO87SBi23IzuzhdJ3HF0RHX1AaA=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB9756.eurprd08.prod.outlook.com (2603:10a6:10:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:22:36 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:36 +0000
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
Subject: [PATCH 04/32] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs
 for KVM support
Thread-Topic: [PATCH 04/32] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHca3slo/iovGxqi0mLpe0GxZetVQ==
Date: Fri, 12 Dec 2025 15:22:36 +0000
Message-ID: <20251212152215.675767-5-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DB9PR08MB9756:EE_|AM4PEPF00027A69:EE_|DBBPR08MB10483:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e754461-b0e4-4dba-ec30-08de39926f54
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?uKcklBoYv2gKraW/9XDc6XBMYtLGqDlhw1gDfnAXcpWP6oFsdcP6Jqr//g?=
 =?iso-8859-1?Q?73mYGHQNELZVPOmLv/ifVOwVo/MeNfbNr2sxwPAljHwkD8sEiI6K3mdA+6?=
 =?iso-8859-1?Q?jvh51Cg0xqxgmfj1mjvzL6pg+LENdHA3B4dcfp2o6xHcM2aSv5pGDilJIG?=
 =?iso-8859-1?Q?ibKXtTS9wiGuC7ziKSjyHDcbXBRL08sAClYBAAhgYgnW8msAJaN7kBvd0Z?=
 =?iso-8859-1?Q?Q2EJL9N1OXvmU43KtmbFRY4WDwy/r+/XNhNZYXJRWCoIfQdotHrfICII4N?=
 =?iso-8859-1?Q?5fmW0ICkWqwTZ1hSWqlJ1G6B3KAatYInRUU/FmOFC2bz0fgPrnqge1hyrf?=
 =?iso-8859-1?Q?Np3BLg3juhktZEYFAlINUr4xP378S1/9SD79cfBf/pnVMph4ji/tSsFvuu?=
 =?iso-8859-1?Q?52ch8YsRxZrZiCUAlaDc1Qg7ipvL7fxSYk9fgUAdCUlYMilZYri5D3mr2Y?=
 =?iso-8859-1?Q?MWC8/pi4oeW4zikSjuri/7DEOyJ5Hmg1W0R0BWRHAd7AkjBiyzel2FJF3S?=
 =?iso-8859-1?Q?kOuUWnHA0EZw1CnNQZXtZkEXJJGY1/YYSEmMjuvS2rvWDks0JnivhukhLy?=
 =?iso-8859-1?Q?A7z9WjAR9naLErzDBBReaaWPylInXbYOFEn52C0qOJVBmDBQ7qOnDfNcAZ?=
 =?iso-8859-1?Q?+b6f33M2jxe8zDYtTM9XpkOEfzE4YTtWsdofO7IKRkz/0/K6R6cnB0f1Yh?=
 =?iso-8859-1?Q?EWvEgU+NHmKSlaPdxYreQZIwXv0Y5VND+kut4WHoTrg0dPuQUyJKG53D6T?=
 =?iso-8859-1?Q?hC8mS9hqMtTNuiZ1qGFJ/WCZNKvhrwbl+9uRBKCfMs0+dfACZnWTSrXRIF?=
 =?iso-8859-1?Q?fcQMqh4momJCnl0YDP88XSUWbwR65Bk9NTffiyetG20TWy8OYS5STNMw3u?=
 =?iso-8859-1?Q?PMGs3WqB4rdcg4xHwJQesDKcbmYgBotzROUDI5ZlJvN4tRdP+0CmRkk5z5?=
 =?iso-8859-1?Q?ZYj/UnKcMCGQROqNyJ4pSlkSsTmbiAwUeCWgwq+tFimtkVnjk7wxQr1kUK?=
 =?iso-8859-1?Q?q4tvhhCPU65eUiQdi9HhlCDtzLgA+YRb+NcDwxO9LcGcXrwrK3xql6aw57?=
 =?iso-8859-1?Q?adQscjKfsJ2xfQJ9D5xXHACV0rzRuoO+vocuTPUMSm8DVrWHkQq9vGZ8US?=
 =?iso-8859-1?Q?eBCQZKBAkAFXVvBLNv77WApOojsgWY9g2+RcCzyPHIXn/VKhXHJP4J0GDf?=
 =?iso-8859-1?Q?CwgnPHeLhspAOaypkh097uJO85mAfuTkZPFF6zZ0YsEPe/CCJPrNvOBeGA?=
 =?iso-8859-1?Q?IZrM412iGjNzcNydlf3gIYGO+Tw04hJMotQTMbtQuG6m+ZpeislKg6NjQn?=
 =?iso-8859-1?Q?/344uq761GYecBAFUTpWRCFdrialqitCl1LDW6Uz8kAn2wrelVTM0lT/Ya?=
 =?iso-8859-1?Q?Y60Y2TTijblTtInvna7ca2iOEKrf6ecr2V8KsgscXUok1+ySlMBzpRzxhA?=
 =?iso-8859-1?Q?U1CWQ+y/xCS58aRmudUGjx4W16+xmqfiM8A+grOVn9eAGSrSL1WaYzIKlw?=
 =?iso-8859-1?Q?QxLAXCEL14W17nblUQAHpi5UFv/RlTN+eJHtBD4Zeqrv6ay06sDDiGnLaS?=
 =?iso-8859-1?Q?qfU3NsRUHdCOVv438VjHPii6bfSN?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9756
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	462c10c2-9a12-45de-adbb-08de399247dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|35042699022|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/sApUb98xN40eGpB4K5br3pCdiliHtI+p05dgkUgNMBe71vPp3gLTK1UYX?=
 =?iso-8859-1?Q?ANDR+KiL2hFyDr92xL8nbyMHayzHffB6KDZ2ZaIiQvq7A0SRJaxT/YqLKk?=
 =?iso-8859-1?Q?Jv82e6f3+bahGk7MCZVT+MlifNlkWt5nT/3Vm9VYtrwye5KyU0cbgpvWQX?=
 =?iso-8859-1?Q?qRE7tloFTVa9SeuSEcLmHtp6jcrdXDBRWqs0SN8QcUIc6N75SfCWSBn9B0?=
 =?iso-8859-1?Q?qkuTuwQLE4engO32wfiyoLpxB8J9w+iPwb3nQBIeU3Jc7SFmbBeNGaqcUw?=
 =?iso-8859-1?Q?zxQGLZCK9rngKS9k+engEFQcPr1KLwnnokjH2Eo9OjWcGl2nadi66pUrFm?=
 =?iso-8859-1?Q?c6X1MEHqj3dxKNQAFnIqM3VAVzbaNIZ2EFMicjt3uIFEBrFwryWwuXKVH/?=
 =?iso-8859-1?Q?qKCz58CW+LftZOu71/HABAkMz7iVXw3yWSv0/C2lyR6YTXTMokjk0zWYAr?=
 =?iso-8859-1?Q?8X6oCKWJznILQARVaIfwWFwtlIY5PydimQl6MeYk2FcK9Q8UU+iLC7NMUY?=
 =?iso-8859-1?Q?stl3k1nhf4M8G027woEAEpTlaN8UNmBgT/3fu4XfX3vZIAgtYy1/a8Lh1U?=
 =?iso-8859-1?Q?q2bFmLU1GRd18xeRJ9W6N5icRl17OlfsX5RL4x4oEKE0y5DuIMvkc7E0V7?=
 =?iso-8859-1?Q?lZpQYbrDAGfDFvoAhltlpQ/d250oYZoGgegfgZDXVsW2OiubhsApihfYKd?=
 =?iso-8859-1?Q?TWiZdX+GQ+X52gEG5kzxeNJr2QQ0h+cy0iKYS5q8wgKff8p6D0El/pohjk?=
 =?iso-8859-1?Q?FXgukLGuldvJuecTZwX/fmg6tEfSGZwcQeJK+jBNOQoxn/4gYosRS9JOBf?=
 =?iso-8859-1?Q?ntCxiCnIlru/GMAPmTSYC1cRNfVk6XJJx4fuGptFB381n5MS9aOqbw9R3m?=
 =?iso-8859-1?Q?YntAubsZNIJ7RtGSUMsCoDn1XDmsGUKzonUJPOVNMqjomVuvd6AQH9jtDl?=
 =?iso-8859-1?Q?vCO8pSGD+oEgt//xmyUdk8NkwBXSXdgx34J7Wqpwo0H8XisY0lHWmCt/l0?=
 =?iso-8859-1?Q?e72QcD1bXzAS2EIqBVFX4qiVQtymi+FFEZUCkHqmYx32+8v96+32zaLeS6?=
 =?iso-8859-1?Q?SzK37W+71CwdZ431CzPkJm+1jBUUtflVhgmt1Kh9PwOdPGxWpNzUuohW5+?=
 =?iso-8859-1?Q?t5Xh19VMs/jYhVlLsGYADPTvNkimwvBklFJXDI4U8s1zGOnGTjzyh+7rPD?=
 =?iso-8859-1?Q?3IdgGPKVM9FJaTC6Ev5I4qmsur6tfX3zEvBeL7RJ21q8iTQzaLxbCm1OB8?=
 =?iso-8859-1?Q?/qLMiENRLZS+V19BRIm6YymhCyp9ZfQsfK2gaqHCmRsStMDEfAWjxGzTOn?=
 =?iso-8859-1?Q?FkZxN5Rdo9LRs3DQOYvjfprUfQD+uWySg3D5eaJNrijPtNHOPKIq4tdmli?=
 =?iso-8859-1?Q?VX4ZmriO0ZXX4wNCjijnN15zZYeR6V0xTCcb1TZlRzBn6OLMFgvQvLQBIK?=
 =?iso-8859-1?Q?nN3VpDK1rs4jOOJ1r9X8CZh7NBtIVuWjLNzt/3a+IZBlffg0CayjvLk9bQ?=
 =?iso-8859-1?Q?76ItzceewdIIbas2nlnRzpUVT6Mtau4w0Awvw9TGjJ9fUMG2wXrvTd2mlv?=
 =?iso-8859-1?Q?EB50x1fy9lJ+WTJrJtds4OuIfX2J2nnIhSWzSAKWPNVMPOYtjYgWEGcMsr?=
 =?iso-8859-1?Q?ZAzBCY6Hjrk9Y=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(35042699022)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:42.7933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e754461-b0e4-4dba-ec30-08de39926f54
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A69.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10483

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dab5bfe8c9686..2f44a568ebf4e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3248,6 +3248,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3262,6 +3270,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3668,6 +3681,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4567,6 +4616,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4615,6 +4700,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4669,6 +5054,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4690,6 +5087,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

