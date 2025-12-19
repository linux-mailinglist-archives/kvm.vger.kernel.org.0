Return-Path: <kvm+bounces-66381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE48CD0CE9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1716C317A788
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FBA363C43;
	Fri, 19 Dec 2025 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X6WPVtz0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X6WPVtz0"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013033.outbound.protection.outlook.com [40.107.162.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D983361DDC
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159668; cv=fail; b=MNDUJpMVhguJ0F4JqBdyS6cvEzcxaFl2DptaVFuIFM6uw2h8HWTUoEh6riSKDkZwecOCeVGB/9YoMTM36W+7LDj2ORyfdN+m65bICcM/GlwXzUjaaj4A+t3BK81ZL25mJlv1zvPl03lp/zo7kwYWHnN/35bThc0kR0lwFNMCQ/0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159668; c=relaxed/simple;
	bh=Gp9zuK6f0HFBxtArxHPwK4Q/+No7ECk2eraUsLhI1OI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nhdtKuibE6q4an9P0lwSY1oUUi/92s1+vtKGdrvReVI6zFNpdRDqPvxyddlCsX/oaLrQmaIu1gSx1jE9VLLZydKZZy2SHX3zhEZdE8LCy7vyZUWGTjCCYF5Te/iFWmumeW3fGvrhHkIStAmIvfYFdf7omJrpUOUPca9ldVvNWX8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X6WPVtz0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X6WPVtz0; arc=fail smtp.client-ip=40.107.162.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iVxvHsMatuoud+27BCJKp8b38qCkyGiX6gUiItj0A/qC8XPoMbkUNtl8jheZSjzu7I7Ikk0ARhvxchW2kwRtSRXjJLR8KAUgvU6WspAsaewSg5piplcI5btdEQ5ey1PV9HIxxlOecOwJaHnSks2uQYZ9SCvoR3zZfVkPFu5Wd8hPFNGGY1899kqy+O4msY2jT0uDw8+iTDvyyJ9q0Ewut/gDwQIX+XFXKmnIoQA22F/zv9LqcYOmg24y2SP1ZW9vNRKh9dyPwReK/bxN7WqL6JZRgpnO+wtzW3yymfppovFQYtDI6vwWe33s/vTkRuQGuu5gHDd9rcMNnH0e6xY5fQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=Jeaxr1rZFkzQ8kO/2hrdWYkLNLtGUmCq3bAZ1rPSTF1KZhiu0bdyOy3HFqonZMt8Uc67iKs4WBdR7+q3R/wiQr0anyqdVwGz6x6+pUWEES4i5NSHSAZ00AAVM8nlJqaK/yI2wvLlofRqpnCmnzo7oDTPeS4JOHtjiyLvEbxCBheNppWL5l3RrAzAFJMy5mB0XDneZJ0MrDo/T1NW41IiQ3zbfgu5KXLt9eWd399gvYHXBvw6qdt9unChIeNW6JzKyZoYmyhs65JgXWXw5ezwQ6J66lSquRJTUjUwgHrqXnd/iSbl/qEXQPaIF09JNIkqXcD8XVW1PSSOysWMeU72Lw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=X6WPVtz08szFYup9D4BdeG7x+9VY7qwa8T3Goql30b3yDuZKeG7hoqF3wU66SPnxR0dDGnUZTio3chYC8AcfnCUr+s1VXn2cofvaSHVVmPGDrgbQD46nYFwSYcQPuDoMv8UvzcKb/9IH7gaUnX4LX2CyADQ4hg7oWrc4v/e3vWM=
Received: from DUZP191CA0009.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4f9::17)
 by GV1PR08MB11248.eurprd08.prod.outlook.com (2603:10a6:150:283::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:54:21 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:4f9:cafe::a2) by DUZP191CA0009.outlook.office365.com
 (2603:10a6:10:4f9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k3KrH94ABYyRrnHE9g/ABQdZUZwlMRiQOM78BLArTyMkYzEGFlZyE9vMMggAbFpzKsiclffuirPgnfUThuBeFWtKnzKzOaAKtbujPetLynUwBq01tZ/Q+pP9ypPfDgEnZV3b4B2WrERpFMxUj+EosRj9z/lQWJXmxsBokiNZTekMpKFlGzhDQVar7pVXLUlqcCIzOrpGxpxFHASverL0Pca8AVG+Yiz1urKiUfIZjKUHFD0l7UbO1ns73RuBQRwGU8vRA64ORFQQhMtK6AvzfjeSCPJbSzhV5kYDhvKnvKg25MYIcPRYwsEjNsUwFP1QXDnF8bLX9dwLKlySif9GUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=g3nOOnxzQaMe17mt+1kCk9TDC7xI8LUiZfKOYXt4qY50qrH59WxV+VokRrU/7nnZsHDP/wJ3MycXDaZ8s55dl7T8u+hw/GUupmtQtG+UwgoByO/e9I2X8w9fOMyoMuNTRLYeohqXjAQeFusP4f+DcVZXgePlUPReBPXgMtmYgX4sKth/w0RFfWvzXhITn8EpygQgselfc0nV5b5xWMVuE23jgPkNGI1YosiqP3EUHb/yQKhprA9RT8gv8f3rsigWqYXmuP+b/sXeiLBIEApKBRgDkgIJLIkPMgy/cvCtW+Ph/9vbHnr/L9qPBVOvTK5pkxnA1NjMjJ7bnZOTr+q8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tpgaxj/MF+3xMeZHR+6Cxvg8GcbunoT8BsQiDq6p41c=;
 b=X6WPVtz08szFYup9D4BdeG7x+9VY7qwa8T3Goql30b3yDuZKeG7hoqF3wU66SPnxR0dDGnUZTio3chYC8AcfnCUr+s1VXn2cofvaSHVVmPGDrgbQD46nYFwSYcQPuDoMv8UvzcKb/9IH7gaUnX4LX2CyADQ4hg7oWrc4v/e3vWM=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:18 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:18 +0000
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
Subject: [PATCH v2 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v2 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHccP+FP4SIeHvhP0W/iFwcDqZZ3g==
Date: Fri, 19 Dec 2025 15:52:46 +0000
Message-ID: <20251219155222.1383109-32-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|DB5PEPF00014B9B:EE_|GV1PR08MB11248:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ee8ca31-ca09-4df9-6459-08de3f16df5c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?01VNI2I2IB9yEfmZIhIA6oQxdnl8BaOqS69G0Z1MXXTmP/fZijoyGnQXWu?=
 =?iso-8859-1?Q?YFMsaPL0NWt1EDtSZXI7xoXN05G2ylhjdQS3o2jMmegwiITaZk88ACrcxV?=
 =?iso-8859-1?Q?xx+3doUkx1jL+HxTm3cQXiiK96S2HufkKUpIMJ8UuoiNi9Rn4/nH0veMCJ?=
 =?iso-8859-1?Q?puHhNQT9B7ggfH37MdWsNinE6ZXJpUgSok9rACNwjulFWPLVOb5k+Afd/n?=
 =?iso-8859-1?Q?2KToWEIwEOMbr0IX7pCTyPDc5BGuIjCeLA9Kh0vP9Y08d8vo3KGzEeD8UX?=
 =?iso-8859-1?Q?sqXWD0Cb//bVb2RCREgqw5A4qPT9Wqb/sJBEOpyACjchoVlQRPnBIaUqFr?=
 =?iso-8859-1?Q?aduOTKGNovSpLP7Hq5v/XflO5/qvefgp/bsd1eXpZQcBz6Va+C+cWyeegK?=
 =?iso-8859-1?Q?40CwcpOTK0MxNFwrtTb3VAFC0+DzoM5tlk2ski9WUTh1gYemCKVlM3ZPzi?=
 =?iso-8859-1?Q?fetrvrLKfLGLIw/w6xLgQqlEfvAtZZc11LNCMLFCp+BwN1LQclW1N5Glp/?=
 =?iso-8859-1?Q?kb6Wa+qXVsdzDTnHyQXqwybUF2bHRsRx7B16K+FS79VQu4SwSa7x+aCrR7?=
 =?iso-8859-1?Q?mqXpUtWWIIYnQlow6rH3BkGyrzPLRn9ziDbrDRjrjZrUV0xI1Whn1xuUNi?=
 =?iso-8859-1?Q?yCYptre48b+iWLFX3Y5bYXXTGan6KNmubhszBuUH++vFjYXwGZbxihRung?=
 =?iso-8859-1?Q?WVlJPOxwu4jjbM/FQ9TeYSgxfYE0HWozs+9GdtLBHKLTFWrImBDKoa2+cI?=
 =?iso-8859-1?Q?CtMi1xYyyk+TN+jss110Z6/escjfs3wlpqZRYVUy0ZCno++R6UGtB6zvJU?=
 =?iso-8859-1?Q?ntQvUn44a3pUjW4AiwgXwZ1z+Vvuyp1XVlm41w3aVCl1cZ7JA5QvJfSRcH?=
 =?iso-8859-1?Q?+x1Wa85zDZMiU3r7EiUt93nOY0gjf8ag5RrA/kUG7Vqd8HoYWQbCfeKgXs?=
 =?iso-8859-1?Q?Ta0WjKDyq7qQJCFl0O+EBKmw2aNJ6oJ0SMwkaRsSxJmh1JxQ+dbSU7eiZb?=
 =?iso-8859-1?Q?rwgZwaNVleBPlr9EJ5NfNiiqbLcmJGzwc4oWADYT3oXhK8n0PPAP8zF/nz?=
 =?iso-8859-1?Q?M3cvMA8BUi8Pw5UUEsEqUS4bauOhDaN5XBNYL7RPcj4pnLYJEXWJM0x8c+?=
 =?iso-8859-1?Q?lXLgtuHKimu+RH9fszl3vgTFt3PvDmh+kWoGZfILlfI3hkJynVA8FiNq4W?=
 =?iso-8859-1?Q?64D3s9m6A18KEIRb/bMS/Zz/udGReI8PtxFfWEW+xn87/hwGAkUW09QR9A?=
 =?iso-8859-1?Q?vYtJVZdBNE/dJ63ByHz3eEVHJRc3BVY2D35u9j3u3300E8eT4sI3gR63p5?=
 =?iso-8859-1?Q?pJDrDo1b022/lNS0IwSni1Z17oT0X9x7HyEeLvUlIWIamak9UFsbi09aFQ?=
 =?iso-8859-1?Q?KcE6xYnRgR7mpmj8W5SYJ52uS6aApDf3YfpKikGVCfobOzKA+f6YDiQM9C?=
 =?iso-8859-1?Q?Lrme3ZW/y8yUHRV4f3WOUFzHlDgL4XrSB1WEY+3CWHQuEPQN/TAKzBib6j?=
 =?iso-8859-1?Q?ZzLzaeoD51VkKPyXPCTeP/z+rDbMdZiWwDjBBlnVdIQoHWDdI0cQM5bkGU?=
 =?iso-8859-1?Q?gPrSiwtrZUMa4GVIFQGMnoqAaN9s?=
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
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fee573ee-c125-4668-01ae-08de3f16ba43
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?vkkIz7/z2rwWwZhbi3YgCPeuIa2F5j8SKIKjTUBLfDSYwvpgO4cnZp4hvL?=
 =?iso-8859-1?Q?tmCiNU7Vu5c5ekNuRnosqFFg+FirwwTfTyao1H6KNXvLiNsIYQ6nb0Etoo?=
 =?iso-8859-1?Q?+gZ8YHyHk+JRLAVfafGb/aUMgz3uoKTfqflzdm4Sqm0zHnGHhZbAvVscwZ?=
 =?iso-8859-1?Q?Z/DtiuL+S9ZHUt+uy7cmLHd63Ot7jXXj/+KprN9P/d7NKx2hwagfd4gCG1?=
 =?iso-8859-1?Q?l20nDU2BMfmGyG7fHN4k96hXUib0eY1lEYbJgEdWNnqz+v8we/4yPsbL0v?=
 =?iso-8859-1?Q?diCp88Pb9xDArlcheFS2wuFZTOf0VCyfaoZEiLMbRPklQRf0IGEpadT5JS?=
 =?iso-8859-1?Q?+K6o8Mn8zoFwXQaG8+bg1orAR+cgjRuvA55NJUpTZSPv76k3Z6iozo3/QC?=
 =?iso-8859-1?Q?pDti9zk1XChyBFY2rXlk/PMBbkOaIEriSQDq7llXZDoGmLHBdAYqrAJY5h?=
 =?iso-8859-1?Q?7aPkkRUyxg3P+Z/w7lwQYW6nGPkhsOQTwA27WiExgyCEjL/woMju4J6LJ0?=
 =?iso-8859-1?Q?bCvnMCHmKD6h91ic3ZY5jDn+xLGUz4v+P0KGEhIaM8HzPtli9hQrB+vijd?=
 =?iso-8859-1?Q?DmEOq6CxSBgytggI2OXQ1mi6bZqGtiZdQFzVstTLuwSeqFLGXALT9NEYcp?=
 =?iso-8859-1?Q?V49j4+8o9hqvPJZ5b9qAAewZS2AjngVpt9nOv3OIY2Cnq/mEzViAPKXhqs?=
 =?iso-8859-1?Q?lxbKojP0hoDtEjqDnP8kzKI0GRGAGG1jUS34SiLJUi1rFmKf9Ih2gjqcSc?=
 =?iso-8859-1?Q?88qlrmZJLnsGAcCAmdf9BDjKz5Vzw34p8Ce/qcoLEXCfDHEImwGV/7TzQ1?=
 =?iso-8859-1?Q?xW3m8F+vUXIQdS4LoQ6O/EnYn/q4ANKEgRbUojJw/AZcthRLYe7kW2zrnH?=
 =?iso-8859-1?Q?VDI3ueeVwJV+9npsHMhgBGJKlhBQPWPQBS7N2GD0cisoKjnVFAAgihxmtY?=
 =?iso-8859-1?Q?6YNPObyUX4Z55WYbTnhoGOmE4Bz/jdSUF2Ks4mER/tJ0RT1MSo9KWpwXTJ?=
 =?iso-8859-1?Q?xEINhWt3NeHFi3ML6ehUZ0LypOb3zckIV38A/n6ZN5bE+6tHhyTL/iK+6q?=
 =?iso-8859-1?Q?/5fXTBaPF50VhG4/6PAzoFoyok90xynvg+JRHHjNp/m8AxKykNsb+5BqYt?=
 =?iso-8859-1?Q?hmnfnpUz6ovaqAyG008RosiEfRiU5uILo0jFrv4jTHHJZQHZsd3t1QAZYq?=
 =?iso-8859-1?Q?tmqFQ2s1reocUgyg+BsTAQa8eIH/7XCqvMXp2xdJ0IMFR3KsiB5rDTqiCe?=
 =?iso-8859-1?Q?ms1Asv/4L3lQTURx1uJebyQqXwK9lwzTioTjEiGTpS7u61zFL3XNk3VOVV?=
 =?iso-8859-1?Q?x6BA9BdK9LKmAXvOXsCTSQn7j/oaUshuQ0hOtQ+rKpp7XF8vBtpNwbM1Nd?=
 =?iso-8859-1?Q?Px3UyIWEsbP/8WS4pjKZzJZuatCA3rEtpMmYGinsGMjS29Ur1yeKEPJP6k?=
 =?iso-8859-1?Q?2U6ax94TOIBA4Dcok9lPQAWYeQVSK8PjqS4ih58oKo55UjnshvkcLIeJEg?=
 =?iso-8859-1?Q?Yl1+bRKKbw/oVQvi8vrfY4O0ETkM0bWwxHglFgPgL1HyMLsM/Wwqdrjlb2?=
 =?iso-8859-1?Q?Yu5UFxglmqtpXkIYoyR2YNHenMsteML/qm/IFo9c1uwkUQrv5fW6Qqng6Q?=
 =?iso-8859-1?Q?vT/SUiFf86CnI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:20.1403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ee8ca31-ca09-4df9-6459-08de3f16df5c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11248

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 07c12f4a69b41..e7e39117c79e5 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -238,6 +238,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1

