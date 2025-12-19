Return-Path: <kvm+bounces-66387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6549ACD0DE8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05F533119EA7
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9482137D53F;
	Fri, 19 Dec 2025 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LmSdrKCu";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LmSdrKCu"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011005.outbound.protection.outlook.com [52.101.65.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB2137D11E
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160848; cv=fail; b=bGfAAcWawEnsVybh0gOE9bcndWyjzHA1CO7lNJTXXLZDlPsdI8PfGAG8E0DKlpDmTKeWkEYilaYyuO/0ZsWALtyfrTbPvQl4P0AwyNDqB5VtS/+sGncG2iIpukiO8VBWwEwjS4mr0oObRyOetA81QWmEZEb59r9nwbrRglkEhew=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160848; c=relaxed/simple;
	bh=ohAIv49DZY0JvlS7hzVu90kJU+t+hqBK2NBIwIkjQXc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LqYoZFzZKhqdCVsrB7ekTbW5ZXAGyv4EEA9XkeKHX6UTuQMCLz0KPjU5dbwpKXq6Nr0XbO1OX4khkNFIGwNHwBL8u8WkoWYrPc2qOnGD3g1nGJM8OCwmaZd9pOc1AYxGDgsIC2Mn6vts9UMEo0tRicufYbS0agAsJJZnen8rW2s=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LmSdrKCu; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LmSdrKCu; arc=fail smtp.client-ip=52.101.65.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JIav/n0nfUvES5Y4fo0qCo+YwdXQhDFQxXwKfPTivmqEL/QORl/rjGiIKWdZnAva/wJUPVp9K9cgHJhvPQcKiBDMY0xFNQ1NYkj2T8TQVNBIBy5JUYUmTN0oiywRZaN45XzzLDRZIEknRNfjouyVuB2b1qjwdRGCUCGTaBhZRbZ45kcoCGwq1MQlkPJ8RypctqYiSVgaIN7zcKo+kc0ZoSmgk2Hxf3YvuB5AXxfWImMCxwWbNOtlzZbe4m4MRI2bhNu5PEcLi4yEwDSskuzZtSH5PnaVdcbIbSiyjQ83T9OhlG3cnB2zoqurg7cy2fH8kpvZ5UJpRsb34lWCw0GJiw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeiQIVsvqNY1y2GFgdT2suL5st5Y0dv0QDblaapXLRs=;
 b=l2gKvaVRuvT3VQBuIIAL96XyD5y/btFMkrFd/ZIuDD2SzcxoXxcd9VJvKGVTvn5aLUpyz9EyQBYJIoQgR2aLbFdxTHypTo9sYedNg5eCg2y9fPIn9+smZGk1VqMuRCVRS6t64fTg9psF4v9Wymv+VgkQhg5kSUPZX1HqG2sMmR1tovY6cs/xLyUmCSnoMc/frHBiAd05QgkCK7eB+wZPNeEXy8ZQ7yZHOlXgS/N7hNDfX8Cw5hYjA5Bg8wld0HiGONCCVojv99Ud/5Qcf8CBifv2tTM/KEx2LSGWmnMHRg+8OuLWIWiLgVLA868hmXDLNLA1ajIvb80kRG7wMLz2cA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeiQIVsvqNY1y2GFgdT2suL5st5Y0dv0QDblaapXLRs=;
 b=LmSdrKCuSglLvDE/TGPCm6ONsV3/ME4MmSESK09PH7/7uwluqL6FaJlO5KJvVkvP8mKOAMtVmbWMkku2rtg7KTnIUpZiHFVCXUnQiNuJlsLECQcl92iExFT+2lTutBjy8yCv+cjJb2SZQ13QT57QjjG0PWHhaWbM+xrl+jSIkTI=
Received: from AM9P195CA0014.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::19)
 by DBAPR08MB5814.eurprd08.prod.outlook.com (2603:10a6:10:1b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:14:00 +0000
Received: from AMS1EPF00000048.eurprd04.prod.outlook.com
 (2603:10a6:20b:21f:cafe::4f) by AM9P195CA0014.outlook.office365.com
 (2603:10a6:20b:21f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Fri,
 19 Dec 2025 16:13:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000048.mail.protection.outlook.com (10.167.16.132) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgaRClKshHHy8sY2CT8MpRtl/srI+Xgjb2Z+4gq4UqhafBKabANAQ41c4aP8pUd64+FUPOuhf1iGsg937y+PmcKhR4qYgvl+rC54CNtuV+7HY5V/lw9M2ms2AOmjvwKYleE1ACny+8WhGS8GY+G4KZelHo9TnDr1L+tl1F91XYi67Yh44RYYgfOuetQkUnX8h0TeAx8FjfuprpA5DOQb+ypI+VaNIlVuDRCr8ZcnqgQDcv6x/DEllhhR53HN+U5sh+qc7Bn54vdLT+28qvOTQXan0ZG2gMj3KYQRwcfhIAb1BDNRQhmaiZRRW1FxFFzIqyWehGEvqZ4B3eR9OtUkYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeiQIVsvqNY1y2GFgdT2suL5st5Y0dv0QDblaapXLRs=;
 b=ZkfnYSHgGJNJf9pe8T00PwcHLtaHJHJusNl9wqEEw9d9Km+qqdweAh2L0MNbET/VhCI14j3n+g/JsVkUnmzswANUEu/DAuEum97GnXPzG4gHSD1pywgT4DXk5YQgriZNfpMUQb1kqk8/T4QPZbzgw/Nhvt2Mge70WKuwRblBwpP8EEtSC/EAtDmOBJLZ0ct9/HfR5Nh3XfsiGeZK32yP6dhExRYHjoJTzETETN9mp5Mj5Yw9u9kiOh1DnvOHV4LYbkLkUmFSDmfn+MC8DrzcAuqQBN+8QMG9MZc9IhWj7NcBAdLXUrFqAn+M3qgkcpV6DOeb9F3kj99fvJaZZaIQFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeiQIVsvqNY1y2GFgdT2suL5st5Y0dv0QDblaapXLRs=;
 b=LmSdrKCuSglLvDE/TGPCm6ONsV3/ME4MmSESK09PH7/7uwluqL6FaJlO5KJvVkvP8mKOAMtVmbWMkku2rtg7KTnIUpZiHFVCXUnQiNuJlsLECQcl92iExFT+2lTutBjy8yCv+cjJb2SZQ13QT57QjjG0PWHhaWbM+xrl+jSIkTI=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:58 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:58 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 06/17] arm64: Update timer FDT for GICv5
Thread-Topic: [PATCH 06/17] arm64: Update timer FDT for GICv5
Thread-Index: AQHccQJW67J7Wh924U2yFGbCYFoORA==
Date: Fri, 19 Dec 2025 16:12:56 +0000
Message-ID: <20251219161240.1385034-7-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AMS1EPF00000048:EE_|DBAPR08MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: b40727d4-64d5-4af0-8203-08de3f199eb1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DTaxk/Xn/1SAkOwrECY+sqxSH6F0aVTKhSyVOHF15kvbnytA6JiUCnQ70t?=
 =?iso-8859-1?Q?3gIrzPHn5FhWSIBs+6yiMi1wjnPkHdM9uuQ6r3xspFXZQAXvb9fq8Xthoe?=
 =?iso-8859-1?Q?GhqiG6zlU+B/zwMoTFGSUYaAyFZI/c54VnxVuHlHRb/PQ1W33zRAhVDLN2?=
 =?iso-8859-1?Q?Fz6VSkOtM4X3ILp8SkCFgYvPiOXyVq416wwzcysRislfNeHREhVnMd0irc?=
 =?iso-8859-1?Q?1KN6NnZmAJXP3z/nFscm1vEFspHBcZGzV6iqdqrmUspt+rQXCYP57sfAqi?=
 =?iso-8859-1?Q?rldoq/t/B+2qUbu0ttWSDSDi9/lpByCkJdLQjy4Irpe/wUUEIdfaoiHdNd?=
 =?iso-8859-1?Q?k5+cEBLPZZP09+G5ybypAzC3uBL8QFdy7nhZEjHeZPU16nl61/w4CgHyyR?=
 =?iso-8859-1?Q?9VoVUQz5H9C4SsRoq3+nAv5iOoWZGRGQ1A/WZt1ZHEQmCRUuz/KUBZRbbf?=
 =?iso-8859-1?Q?TGK1UZ6gnzTrZwhnpYH/jvyI85dRrctAJmX4LORFkD7C9NjdvQlOCG6RkJ?=
 =?iso-8859-1?Q?nsO0L2hJWUoM3d3lxVYZ9W4rigRFgnAn90hnzF5ht1UrurJpWfq9yrUfQt?=
 =?iso-8859-1?Q?m4kdQYz9+Ffyp7ooUypFIbNBqgh70QcSFOqyEUMQVwwnafE/4luIMWqgC5?=
 =?iso-8859-1?Q?GIEKWgoK36RcZSUUfPLBEWsg4rasBszqjUTn9HI+vbAJ89fpcsScrOHdMM?=
 =?iso-8859-1?Q?xgJU5vP4EsmRDwZFA7Km7Nh0DnTXyJ6tJZjt74LrFbitePk6VWzdOmOnK+?=
 =?iso-8859-1?Q?63hkmmI0Bwl520m2w0Cs3HqnwJBbGAY6+sI5zQgJJW5sq3RjYZA5Y0JShr?=
 =?iso-8859-1?Q?3ICG/sw2HUen9ELF9lqT9j2Mwn0uRKHe5x04esQ5gTjPfY9JUlBOYOE0Z9?=
 =?iso-8859-1?Q?YAZVtaaDl8Sm7yYK1gqjflHAKT9lLkYjLBfV2dIwTzI6ybK5sSpjEN8gh7?=
 =?iso-8859-1?Q?9+6gSgkqtVkiJQankZDrqW5BLbqHw9qd7YHfLP8xUfyv9m8UNZC5d590u9?=
 =?iso-8859-1?Q?o1gPuopX8PPBO42f4F7yU5KoWdazo8+4/FBKj+oZ25rGoz9VrGRhIu6HO4?=
 =?iso-8859-1?Q?xaaGPcY7Qe90FFDeGA+/ffnBv7C6FVmBxiJYxweaRuBdYumYDIgFfkJcNm?=
 =?iso-8859-1?Q?3JBZRpGGzT4hXP9Xk15ks1lBKO9/qx/Kwl0+EzpkveSUxjAykvdIyXl79B?=
 =?iso-8859-1?Q?DtUAs6qv5xyIQZsQ6nB8caE859ZzSIHkwk1EbxTAoMBIB0RqOledtomKZK?=
 =?iso-8859-1?Q?M2njYEi94LrmTgor4Y1sSsYPorTssm8k6h2aqaDpOfnDp45uf4rGWpv9QI?=
 =?iso-8859-1?Q?piwBbzR15X/YigPwPeVzwsdaxv9NBrI55+R0x2XWH7u9R/RabGOmUeYUVK?=
 =?iso-8859-1?Q?WOgIe2PN89Jcofc+zMHqcOQsM03zl1nSwIJYotrUtCygtl62ky+jZUV4AP?=
 =?iso-8859-1?Q?OMeHSgcYCSxMnr5ssTV3Bfg2hlRyWh5U7uXLdWSa+sFFoViUjk6WTcTv8U?=
 =?iso-8859-1?Q?IOFAq5qQ//Iv8J+B+n3XNdTM7fzk6So8tPA41K+rhwfKXJcEbXJDL4Fz/P?=
 =?iso-8859-1?Q?2ERFH67I2iwFcH/R2AHl9hd1m6S3?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d0efb8ad-51d4-4340-ec07-08de3f197992
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?oUWVN2RxTrGQEh2HxJWI41+2eYayffjhFKNAPhTzxOlMnEob85dcsyI9mA?=
 =?iso-8859-1?Q?D3zVtwhtXv+eaIlcAn7SDj01NciHMl6iPa6gT+o8grSbew1tONTnKZphOI?=
 =?iso-8859-1?Q?cUnzGo7+z1qEZcdIUnjpNEGJiJeNq/fQVchziLsY+D3hTg8YUEbC0Vese4?=
 =?iso-8859-1?Q?Q8vzDTohc/Rc6unAKyk1D/rUxfxFZYNWhRVzWVgQZ+gn+LEv6usKvJ3daA?=
 =?iso-8859-1?Q?ABlwjhlKzaSBL3RNTTjDbJaT3oLIHm7qZQXEgZYsJ5cjaqRb4yAx1XRi/N?=
 =?iso-8859-1?Q?YPX94+pr3L80w9D1PMImpX+soxPSgCeO0ou573uGP0y4YHd9+mcJDqlFJK?=
 =?iso-8859-1?Q?Kg/39tEY7Xl2XJnDwULrAaFmys37PC69k0Gpz7xr3y/Efp1j4/PQLaeBnC?=
 =?iso-8859-1?Q?cRDLi4ydxy+y7SIF5H7w6WGaykwXYnfhZXNmVo+Y0672ItUNlsbV0zq0KQ?=
 =?iso-8859-1?Q?R3ewPXV8UwMOrGJ4Ea+TTlfMey/maILINqEp11eOHq+Sd1FnbGaPuJO4C0?=
 =?iso-8859-1?Q?ugRbr6FaOt/SJxHRzHrVXSTtOhtKKdoQAGt33YcnRpGeW7iK6OqBJgm0vl?=
 =?iso-8859-1?Q?ngdMGlrLiuy7uGXx/etkfzLDhk5RcDRClKxi24bEikS7wPBfC2msX3GwKU?=
 =?iso-8859-1?Q?zPU+Q5DCPGDH2u1WBQKtvkKCS5rFnHCDGcvnGpoTyAuUrYEjGZu9BL3WTh?=
 =?iso-8859-1?Q?koOC+fHwMfjdrlyXFMDyWCD94AIs7pM3BgYtzzKHTazkxAhDatpPJnDUJr?=
 =?iso-8859-1?Q?eUsCCPOa5M/xUPPlPX/JR81LSVAGQEfCrps8mYVisjSU88Yc6QKpeacegZ?=
 =?iso-8859-1?Q?5uDjowFRj3HXz41XmFbeoJmZiCl/tUhZMy35bMrwh2cUJmXrdtXIZERuyd?=
 =?iso-8859-1?Q?M2uCITPftHtmoQaDhMW59uR7iJgVbBPaH1xZjLzzVNalMGjIFBxo+CfZf8?=
 =?iso-8859-1?Q?nHEsbmER6UeaJ4GwwfGAG727hJFNPNST58r6X7ulPl+EwH2B9uUXkvFkgU?=
 =?iso-8859-1?Q?6HYL5fFHYKkNKjKmWSellavf7PxbGHBkmsLGiBGovQAuyupZv5vhun0d1Y?=
 =?iso-8859-1?Q?CHWFwc5Z5wUPjRp2/0/st+FH0PkpXV2gk4J36dkDq1WvIxag3ko4S7WPWI?=
 =?iso-8859-1?Q?30rCLRxyZOxh6aNjnUVESIW2Ny4upxk00bhrgnRoYTuWzMNmKL4euM/M2C?=
 =?iso-8859-1?Q?DQ1Ud/uiBfjE/3CDjm26V0PUjBg1+Lo00ddQVUFwd5povqipvAYmL1lRgJ?=
 =?iso-8859-1?Q?JhmPZ2bl70botCz2rQ6QorKZzt+QnC4adkYLKwxqG5WuvA1mbfDCkgmnRs?=
 =?iso-8859-1?Q?3RcwgzX1EvPLICKmGLlwjcIWiaEAD0Elnl73zmCSh67u1gHYpWEZv4w/jQ?=
 =?iso-8859-1?Q?D7UwMOd9nZT6Wac1EjmgCQK510H6u8dJ46VnFsT/mNwjyswwUilabTDgfx?=
 =?iso-8859-1?Q?ch6AZxh9hDJ5s9LPwyLg7W3Ob7uq7kRSkk20Zmcj75wSAbSc0ysYhtFFFK?=
 =?iso-8859-1?Q?Q/9hMmp0CA0ZlnVlugcedQhllzW+X5bXmcaWQuiXmhkWudLAKMkojbOTjw?=
 =?iso-8859-1?Q?7COe+2LbDCqIygyHU0f9BCJe2P0ztMjt+xCWNWx7bmxd96beNhewhn2AG3?=
 =?iso-8859-1?Q?KVhLqSU2P6Nx4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.1409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b40727d4-64d5-4af0-8203-08de3f199eb1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000048.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5814

Update the FDT generation for the per-CPU PPI timers to be
GICv5-compatible.

In order to keep the code working for both older GICs and GICv5, we
introduce an offset for GICv5. This effectively applies the implicit
shift that is applied to PPI IDs on older GICs (they follow the
SGIs) explicitly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/timer.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arm64/timer.c b/arm64/timer.c
index 2ac6144f..0945510d 100644
--- a/arm64/timer.c
+++ b/arm64/timer.c
@@ -12,13 +12,22 @@ void timer__generate_fdt_nodes(void *fdt, struct kvm *k=
vm)
 	int irqs[5] =3D {13, 14, 11, 10, 12};
 	int nr =3D ARRAY_SIZE(irqs);
 	u32 irq_prop[nr * 3];
+	u32 type, offset;
=20
 	if (!kvm->cfg.arch.nested_virt)
 		nr--;
=20
+	if (kvm->cfg.arch.irqchip =3D=3D IRQCHIP_GICV5) {
+		type =3D GICV5_FDT_IRQ_TYPE_PPI;
+		offset =3D 16;
+	} else {
+		type =3D GIC_FDT_IRQ_TYPE_PPI;
+		offset =3D 0;
+	}
+
 	for (int i =3D 0; i < nr; i++) {
-		irq_prop[i * 3 + 0] =3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
-		irq_prop[i * 3 + 1] =3D cpu_to_fdt32(irqs[i]);
+		irq_prop[i * 3 + 0] =3D cpu_to_fdt32(type);
+		irq_prop[i * 3 + 1] =3D cpu_to_fdt32(irqs[i] + offset);
 		irq_prop[i * 3 + 2] =3D cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_LOW);
 	}
=20
--=20
2.34.1

