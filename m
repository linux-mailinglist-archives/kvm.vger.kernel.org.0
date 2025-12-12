Return-Path: <kvm+bounces-65854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57393CB91B0
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5791F3072870
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46FF322DC2;
	Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gu93kEW7";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gu93kEW7"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010000.outbound.protection.outlook.com [52.101.69.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95740316909
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553031; cv=fail; b=mGwF4eTvtnyiDGB3iz0h/rTxks0B2L6Qv5AjNFIr0WIUTqI/BhSE4K0kr+pWLf1kM4VKhrJr34BbdauOQgl0EGsq4fgO8G3+AFVvqy0gGnuHh0CK5K5qb701CMwz/ztt+ht+W+/Ir97BVM4hXsyH1oOX/H7ift6GMBmo7r53Kmc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553031; c=relaxed/simple;
	bh=l0mmhZwxkStOeF4rhhtK+P1gYLGx0GsyEyd3spfXhZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sxYJIrh86Rsfjek8OiDR4CEzfbY7ftO6Hh8i15NdHANUXqjczoM54jY1ZFqlUqWHE1cw25bodKrw82unPg3ieQtX8t46zBFfEf49fouoh+ZX2Yvhj03DyvdlZLaICltOTxpmLkslh6hllutf/EByx+SdK+L4IqrFpqaL6hUYEO0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gu93kEW7; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gu93kEW7; arc=fail smtp.client-ip=52.101.69.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kqsxatgiXzPMDNBgzvZ5BDIolsyyQgjqjA+9V8jPR/1nhl10KtMT9a8iEc5PH+pnrjl+qklvmRM57J/ikfLw+4DrbBuwem7g1Kj/lt3KmXWezslHxw3gG9s+nWxewsBCQyTxFbotNwGG9CZJKxt2K2WVlen7plTfOtSXPa9igyL2bcnch9ydLjz5TtWBg5fAlyNtHnFTSYBrYtzlCyB5kYugYCv8yvuuvyHWcKlnG4iepameKLG4lbuSocCbC6EgsAhrOShWOcP2ef1qSSLSLovIhJ33zGt+g58k9U2OGMt7/iSCXqaho9PD0wwYxjmYomz39NJMowESSuFc7IuBgg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vtp49JtJTAHWk0P5SeLhiqZ509MzHqqYRz0nfffv38=;
 b=Od7RPDZsa5tX0cJC2npXu8ZR9AZWgYitG3wTDyfeZ1yQ25Pn9/ID7T3fAJI+fN/488G82bbvLqxMfDJGqOOqRnGbYyVAm2uvn2xXmqxhHaTPhU80t/IbjETfD8uQhpKtM5w2mYZCB1FG39aObNO1r1+bKi9PptKjA8DaTyQMwlTNJ/CIZJfClsa3nXE6JlhQU+kn8fvnbM9yVpp75wad8kfJp9iOH+5As4vTzWiklliUZarS+C5Jfs/vV1c1iHJXBnTZA1aH9oW2yv/iD5P2pb4NWwmx7WtuRnTDbrq9+bNjVIxwZVf6KfYNBBib+cKiIdQJQZYCi5rHDdPV5H1piQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vtp49JtJTAHWk0P5SeLhiqZ509MzHqqYRz0nfffv38=;
 b=gu93kEW7Lsu2Z+AguA1/bgQERODzwmWZLT0306mxJ98hIGUQBcf6at8fyP+eXfugPigSrjmseYw1pIm8QKUTe9QCu3EwGxUaa9TRKV9WHJVUZ8nvej5dEn7QJyyjnaNwAOdP5WyYlfCydSiOwjkOrL67B7419YtxAmGVyRjro1w=
Received: from AS4P189CA0035.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::14)
 by AS8PR08MB9388.eurprd08.prod.outlook.com (2603:10a6:20b:5ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from AM2PEPF0001C70F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::f4) by AS4P189CA0035.outlook.office365.com
 (2603:10a6:20b:5dd::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70F.mail.protection.outlook.com (10.167.16.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ih4yHeYCTDqI9GRYGCZLeYuZl2WAbOeimUmO12BBB0Q5OdQeyG8jxcXshSYrnAVc0pLCbuC0gva4lfIPpyTg34LRomGtzGxZR+XEfEdQcDUCgkeApHfhcM04REmJ52v6cXWRx3aq+lVyuoH31xE4D5L7EydRcPcOsff2+bZj5NEcb8PPHG1Vj9mxFjk2JeuYvGH/HpfkVOiqfHWPRObJ1kHdN2ZbSDyVUf6UEQO+h97YlftTvWHbZYJR1/cWdWB4uKzvEdF4uP6U7im0gY5XVeExTen6L/9D47qr3ChquKiBy5wNxsQ64Lvpy1E3HNaNSSNYmvaTLjnlJIClx45ULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vtp49JtJTAHWk0P5SeLhiqZ509MzHqqYRz0nfffv38=;
 b=kxc4CawqwZis2dWzOISEbAUXdC0SK3sx89w5pcIlHJNjaJ7VkVKB+HGLlj48kazIrcLCbl+YtTD5xhpKCVKAN93NIEmci+bhzc5lM1RgqDEmtr1iS2HRcKXK9EHDYm3xB35sti5JxQ/K08izjWWnftTyPjyIs7osMubowI7ew4S0m0ooOQYwHcwEbq1vNp4vjoIDRYe4kfAt5XwE7Fw7y3CUnukGnmkMDwpmLR8lF0EagUnHr1fW4Trzgh6+ZeJU/eKz1CiiPLVlL+8oWOf4Pfvybnhnopky7AegNKl4pajjsQCIbYN9FgKnK63oaUIzs9szSVLmN8zJy74P3g7vOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vtp49JtJTAHWk0P5SeLhiqZ509MzHqqYRz0nfffv38=;
 b=gu93kEW7Lsu2Z+AguA1/bgQERODzwmWZLT0306mxJ98hIGUQBcf6at8fyP+eXfugPigSrjmseYw1pIm8QKUTe9QCu3EwGxUaa9TRKV9WHJVUZ8nvej5dEn7QJyyjnaNwAOdP5WyYlfCydSiOwjkOrL67B7419YtxAmGVyRjro1w=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:39 +0000
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
Subject: [PATCH 13/32] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH 13/32] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Index: AQHca3snsrG+V/OS2UOhNLRdjlwFcQ==
Date: Fri, 12 Dec 2025 15:22:39 +0000
Message-ID: <20251212152215.675767-14-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AM2PEPF0001C70F:EE_|AS8PR08MB9388:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ae60bfc-235b-42c4-6292-08de39926ee3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?bEvUFmp3GKFw3Y+jsSsj73dbfP78wGLP6xgeFNw9pyxvBom3u2VeI7+i1F?=
 =?iso-8859-1?Q?5+qOrKK4KkicNzrUJx7s3zPtItuut9j+W4VIDTpiAAmfpeKJXvtAfqqniF?=
 =?iso-8859-1?Q?cOOLDeUVClr3wgPws8PPvhFV3GDx9mOvXcf863N8I6LnipfkCeTj/HQEUf?=
 =?iso-8859-1?Q?DLz1Ufs1RUtdwzo2vfo+zL8ISaBXH0WAF6Ig0aCWUThPVFaiU42vOsGYV9?=
 =?iso-8859-1?Q?Flleg4bD0n/6JcTX1Kk9EJxIge8qPIICgMeuTNZVp1WmnyyHBPhvttZMJv?=
 =?iso-8859-1?Q?DK1J+LTeU40lNxsNCBkn3n5vQx4hfjOp1i+EyDNNEka5JWPvjOP1k/bJeD?=
 =?iso-8859-1?Q?t9jPQCW9IMfwnaRZ828IiYKirex6v8ob0Gb1jRw7QMSdbfKDWqKA9fiW4H?=
 =?iso-8859-1?Q?m1CDW+KWUmjhVE1ogQ/Mhvx7zXJF8M0Qp9vpbpEO5lLrtb53WNeUwi+P7R?=
 =?iso-8859-1?Q?GFDXBCnKSxdzplgIJse1W3KHaR3ZjuHTt0QGW76Ykm/TA2mfTfQ52g113J?=
 =?iso-8859-1?Q?hEqhf06JZNOqfnBCrNKb7MemeJx5CJM1jJ9jHuwkNVp9tW2w7pGr6C6q34?=
 =?iso-8859-1?Q?bbXevPqY+mVmkU7tbownTtLdrgMEOqRhaVWa9BLXJJwt2O8yNo8d1C8gAe?=
 =?iso-8859-1?Q?3H0bHAQ344UD11nj4z1WWkvMDLApbO+DacVJE4Vg0sdGEG21BjJ3jr+o+4?=
 =?iso-8859-1?Q?MF+v6avTjMUw4XYX0lrZLUjogfg6rk5ZyXrGHd1vwXHIMRL75B8eiGixIK?=
 =?iso-8859-1?Q?ioBzFhJdnDzdqpkwkEFyLmQ2F8Cu4rG1eez654ea0VfoD7vwPwn/xPUbB9?=
 =?iso-8859-1?Q?r0FRpTahz+tWgQkYNhiAiGEIEGZD8XzNzs266RxfQTb9EPfnY36qjIIzah?=
 =?iso-8859-1?Q?2+M9cJ0g7RRE+gY1ebnUPnvumBDDFTJKpzM+pmNgcfRF0XTkAp/irufJvV?=
 =?iso-8859-1?Q?mWIL3vqQWZ7fIRI3N4UKyDsVVCFzoeIHLV2218Cq3CNtjb9gAU9c2S/H8p?=
 =?iso-8859-1?Q?B7r7bn07hXWqJ85qPM7NLw9IFm3y/VqhJC9BaAVzFtIPDnjHOd2YmSFenu?=
 =?iso-8859-1?Q?tqr6tK2zck0Rbeds/kAmLsPTtbXewgbyf72Ztaqw4FNFBJ9amDjBB0jdtU?=
 =?iso-8859-1?Q?MRp+0NLiNJRZ7AsjIenCBduayJA08JDrZb3Ts9CIFvt2zTeE7CSUAQ6P7C?=
 =?iso-8859-1?Q?JtrfJoFTfTLvO1UOM1J3z3prscI/Uj9iHTLOPRC6vNmGlz8sQZnorzGAlK?=
 =?iso-8859-1?Q?DOcXt15Xx4S0vi11xPfpVE2Fxa44PdbyVK1/hWDzV6sRIReWp+hxRxvKyY?=
 =?iso-8859-1?Q?pS8D8CzvowlCGdgEJuQU7EozU2W5zZS8fLMAz7GaKvMsVDQ30EIWNn0h46?=
 =?iso-8859-1?Q?pDWOXG714HxGVqGQvDJ7TKN5VJHVuF/ySbp2RbVyLw8De+vz+4syWsGEbl?=
 =?iso-8859-1?Q?1D4KQJozR0HpGt6gz5HKuTxKvU/KU3luzgsLtC8ELsf4qNr6EfbshW8U6k?=
 =?iso-8859-1?Q?8vAAerEjyFDnAQqgFg7cl2GnclrcyfjIwjTJ1lD77obTLk7yZehZ5KY8l0?=
 =?iso-8859-1?Q?Z1X5oIkOKWWpdBEWUzSeNoX1QH6Z?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5812ac5a-98df-4f01-f5b4-08de399249c6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|35042699022|36860700013|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?dbqJyoTMb0A/6z2ibr6BxOYrIM208fO0bA7pnoZAzxuRWJj4XLiYiJvZAV?=
 =?iso-8859-1?Q?Yu06QePBRK0VZXieiHPtmcIEucwXvBR3fhlqFSKAgIP9SfH/NVRbNf28P9?=
 =?iso-8859-1?Q?mzeQyE+CT4xuNI01gzImBLWfNBnwZ9Dv6p3KJ+ojL1r1CYnvYpDtCpfLVa?=
 =?iso-8859-1?Q?pCxmrqaxKEYUvGNxcnZrSwTH8iBYvrPQu7xe9gKOLeem+dMJcKP39I/ZpM?=
 =?iso-8859-1?Q?eplTNcavE8EfvPcaN/mq6+SPfcPhYLQKOCxPWC9YehxAbYdtwrsy5/2uYH?=
 =?iso-8859-1?Q?+HFFY2NSN/K0FAQ8pWs/kbixxXxlRouWk1icaqH2sUnm/76MqfnDOLF6+h?=
 =?iso-8859-1?Q?2o5JtSBw831G+lkbE5G5Ki4HVAUsodR0gFf10Lq5qTQJtWSXf6FB0jz9vb?=
 =?iso-8859-1?Q?16v7qzW8bHT3gBULdt8X558O3fsvjyAU0cmFUwjVCEbvrhu4mkTjQCBYFE?=
 =?iso-8859-1?Q?7m67iHkQSOnEfosQ4HJ5C4QpOzjtR6gow4yJxPflbxN//yItz/5qQWJdmx?=
 =?iso-8859-1?Q?zY4lXfu/7U5d12aeaO3TFt6Ghc3asZHwYdcdmdG690KLVP4GPZE6IAJxYb?=
 =?iso-8859-1?Q?O6pySsAGjF/d3irsDqxYl2fDSjZPcdL3KKVwrRNS9LJeGXn4bKphQc7diB?=
 =?iso-8859-1?Q?oXpGEEzHRx2+Px+yiQvxLc77+r5HjipUjCpv4ueIv/ys6QaCrUad+OyB8Z?=
 =?iso-8859-1?Q?7H+QIQpkPWXJ2DUSO3gZdNOAk/O4L7rYaYb1/Nt0EFVuEEu1+Anu1ZCLEO?=
 =?iso-8859-1?Q?w9mwtTN+Fi/x43heklHBpQlo2wu6gwRrhW74JyPsSAof6YpCR8W9/AFSFX?=
 =?iso-8859-1?Q?OQccRHatPAKEYp3vQ8TLokhn+0yOn9fUTvoUf8LwrRtCGefbXNBVK91Hg3?=
 =?iso-8859-1?Q?bPK1PBB95IGoPjMlUEtwt6dUzVPbxZzQTV8VJZ3UaqUjLDfpCXuKh/Mx2X?=
 =?iso-8859-1?Q?3dWFIV4cdw/AkzO0zc1Bwjyhn3qv7wo8PFgBwrYph+hd1Z+1nHChE4xzDD?=
 =?iso-8859-1?Q?NSjQrCwAILA0P0sivmUP4usSpB0QZe6HiWE8EhmhWwt2ahtECQJLaOGyGZ?=
 =?iso-8859-1?Q?0X1/Ho2MItAU7zQ18MVOy8OD+ZgFoNg+NaXUbNzzEnSORX8Ny58NmsBSTS?=
 =?iso-8859-1?Q?f+RK/xhE/MkRDW8ZhjHpXOp/c0L0KuOwxzCcBc57sPc80MOxi9E6f6FVo4?=
 =?iso-8859-1?Q?XaGxmRUgUcACB3MrNHKysmMHlRFUD0xQl7K07Wt7kdDzxWiHNMPsBbnvym?=
 =?iso-8859-1?Q?duX/aeNqAQSfn+8HOgYV4QqBoVx2s4L1iiNTy+wYy044/y5u89xC1ajO38?=
 =?iso-8859-1?Q?ajgbtkVZ3Vxyjvo//BGq/pZqIV64v4VxbrypASxfoHSSSAX9OkUnlLqbwH?=
 =?iso-8859-1?Q?Kyv2qFAPPEA9kYw2qAgt632fDSwcqflvWIqdz3KE7chXho6EaZl3lsgEvY?=
 =?iso-8859-1?Q?BvDrHaHphxwlZ1ykRF4UwObHY6yJG1p96VovDPuyKmBo6Dsnd4wymDz42a?=
 =?iso-8859-1?Q?/gTa0oaN6EkK99AjBJ81vEA7aK3MmHYakYVpICQfB+8XRplIjA1hkplv3I?=
 =?iso-8859-1?Q?R9cdgbqVSIF5zCNnRwPGBcgJHhniCJsq0BAiTTTlvs93AAUhDsz5tZ7M1U?=
 =?iso-8859-1?Q?2FRVzaPFnRFH4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(35042699022)(36860700013)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:42.0621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ae60bfc-235b-42c4-6292-08de39926ee3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9388

Introduce hyp functions to save/restore the following GICv5 state:

* ICC_ICSR_EL1
* ICH_APR_EL2
* ICH_PPI_ACTIVERx_EL2
* ICH_PPI_DVIRx_EL2
* ICH_PPI_ENABLERx_EL2
* ICH_PPI_PENDRRx_EL2
* ICH_PPI_PRIORITYRx_EL2
* ICH_VMCR_EL2

All of these are saved/restored to/from the KVM vgic_v5 CPUIF shadow
state.

The ICSR must be save/restored as this register is shared between host
and guest. Therefore, to avoid leaking host state to the guest, this
must be saved and restored. Moreover, as this can by used by the host
at any time, it must be save/restored eagerly. Note: the host state is
not preserved as the host should only use this register when
preemption is disabled.

As part of restoring the ICH_VMCR_EL2 and ICH_APR_EL2, GICv3-compat
mode is also disabled by setting the ICH_VCTLR_EL2.V3 bit to 0. The
correspoinding GICv3-compat mode enable is part of the VMCR & APR
restore for a GICv3 guest as it only takes effect when actually
running a guest.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |   4 +
 arch/arm64/include/asm/kvm_hyp.h   |   8 ++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  32 ++++++
 arch/arm64/kvm/hyp/vgic-v5.c       | 155 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile    |   2 +-
 include/kvm/arm_vgic.h             |  28 ++++++
 7 files changed, 229 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a1ad12c72ebf1..5f669299fb956 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_ppi_state,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_ppi_state,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 76ce2b94bd97e..f6cf59a719ac6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -87,6 +87,14 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
+/* GICv5 */
+void __vgic_v5_save_vmcr_aprs(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_vmcr_aprs(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_icsr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_icsr(struct vgic_v5_cpu_if *cpu_if);
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index a244ec25f8c5b..d860fbe9bc476 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5.o
 hyp-obj-y +=3D ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index a7c689152f686..6bc5a4f75fd01 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -586,6 +586,34 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+static void handle___vgic_v5_save_vmcr_aprs(struct kvm_cpu_context *host_c=
txt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_vmcr_aprs(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_vmcr_aprs(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_vmcr_aprs(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_save_ppi_state(struct kvm_cpu_context *host_c=
txt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_ppi_state(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_ppi_state(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_ppi_state(kern_hyp_va(cpu_if));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -627,6 +655,10 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__vgic_v5_save_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_aprs),
+	HANDLE_FUNC(__vgic_v5_save_ppi_state),
+	HANDLE_FUNC(__vgic_v5_restore_ppi_state),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5.c b/arch/arm64/kvm/hyp/vgic-v5.c
new file mode 100644
index 0000000000000..11b67ae09e326
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vgic-v5.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - ARM Ltd
+ */
+
+#include <hyp/adjust_pc.h>
+
+#include <linux/compiler.h>
+#include <linux/irqchip/arm-gic-v5.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+
+void __vgic_v5_save_vmcr_aprs(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_vmcr =3D read_sysreg_s(SYS_ICH_VMCR_EL2);
+	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
+}
+
+static void  __vgic_v5_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
+void __vgic_v5_restore_vmcr_aprs(struct vgic_v5_cpu_if *cpu_if)
+{
+	__vgic_v5_compat_mode_disable();
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+	write_sysreg_s(cpu_if->vgic_apr, SYS_ICH_APR_EL2);
+}
+
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_ppi_activer_exit[0] =3D
+		read_sysreg_s(SYS_ICH_PPI_ACTIVER0_EL2);
+	cpu_if->vgic_ppi_activer_exit[1] =3D
+		read_sysreg_s(SYS_ICH_PPI_ACTIVER1_EL2);
+
+	cpu_if->vgic_ich_ppi_enabler_exit[0] =3D
+		read_sysreg_s(SYS_ICH_PPI_ENABLER0_EL2);
+	cpu_if->vgic_ich_ppi_enabler_exit[1] =3D
+		read_sysreg_s(SYS_ICH_PPI_ENABLER1_EL2);
+
+	cpu_if->vgic_ppi_pendr_exit[0] =3D read_sysreg_s(SYS_ICH_PPI_PENDR0_EL2);
+	cpu_if->vgic_ppi_pendr_exit[1] =3D read_sysreg_s(SYS_ICH_PPI_PENDR1_EL2);
+
+	cpu_if->vgic_ppi_priorityr[0] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL2);
+	cpu_if->vgic_ppi_priorityr[1] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR1_EL2);
+	cpu_if->vgic_ppi_priorityr[2] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR2_EL2);
+	cpu_if->vgic_ppi_priorityr[3] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR3_EL2);
+	cpu_if->vgic_ppi_priorityr[4] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR4_EL2);
+	cpu_if->vgic_ppi_priorityr[5] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR5_EL2);
+	cpu_if->vgic_ppi_priorityr[6] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL2);
+	cpu_if->vgic_ppi_priorityr[7] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL2);
+	cpu_if->vgic_ppi_priorityr[8] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL2);
+	cpu_if->vgic_ppi_priorityr[9] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL2);
+	cpu_if->vgic_ppi_priorityr[10] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_EL2);
+	cpu_if->vgic_ppi_priorityr[11] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_EL2);
+	cpu_if->vgic_ppi_priorityr[12] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_EL2);
+	cpu_if->vgic_ppi_priorityr[13] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_EL2);
+	cpu_if->vgic_ppi_priorityr[14] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_EL2);
+	cpu_if->vgic_ppi_priorityr[15] =3D
+		read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_EL2);
+
+	/* Now that we are done, disable DVI */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+}
+
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	 /* Now enable DVI so that the guest's interrupt config takes over */
+	 write_sysreg_s(cpu_if->vgic_ppi_dvir[0], SYS_ICH_PPI_DVIR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_dvir[1], SYS_ICH_PPI_DVIR1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ppi_activer_entry[0],
+			SYS_ICH_PPI_ACTIVER0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_activer_entry[1],
+			SYS_ICH_PPI_ACTIVER1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ich_ppi_enabler_entry[0],
+			SYS_ICH_PPI_ENABLER0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ich_ppi_enabler_entry[1],
+			SYS_ICH_PPI_ENABLER1_EL2);
+
+	 /* Update the pending state of the NON-DVI'd PPIs, only */
+	 write_sysreg_s(cpu_if->vgic_ppi_pendr_entry[0] &
+				~cpu_if->vgic_ppi_dvir[0],
+			SYS_ICH_PPI_PENDR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_pendr_entry[1] &
+				~cpu_if->vgic_ppi_dvir[1],
+			SYS_ICH_PPI_PENDR1_EL2);
+
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[0],
+			SYS_ICH_PPI_PRIORITYR0_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[1],
+			SYS_ICH_PPI_PRIORITYR1_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[2],
+			SYS_ICH_PPI_PRIORITYR2_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[3],
+			SYS_ICH_PPI_PRIORITYR3_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[4],
+			SYS_ICH_PPI_PRIORITYR4_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[5],
+			SYS_ICH_PPI_PRIORITYR5_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[6],
+			SYS_ICH_PPI_PRIORITYR6_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
+			SYS_ICH_PPI_PRIORITYR7_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
+			SYS_ICH_PPI_PRIORITYR8_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
+			SYS_ICH_PPI_PRIORITYR9_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
+			SYS_ICH_PPI_PRIORITYR10_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
+			SYS_ICH_PPI_PRIORITYR11_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
+			SYS_ICH_PPI_PRIORITYR12_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
+			SYS_ICH_PPI_PRIORITYR13_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
+			SYS_ICH_PPI_PRIORITYR14_EL2);
+	 write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
+			SYS_ICH_PPI_PRIORITYR15_EL2);
+}
+
+void __vgic_v5_save_icsr(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_icsr =3D read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
+
+void __vgic_v5_restore_icsr(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index afc4aed9231ac..fcf5e68ab591c 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -10,4 +10,4 @@ CFLAGS_switch.o +=3D -Wno-override-init
=20
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../vgic-v5.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index fbbaef4ad2114..525c8b83e83c9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -359,7 +359,35 @@ struct vgic_v3_cpu_if {
 };
=20
 struct vgic_v5_cpu_if {
+	u64	vgic_apr;
+	u64	vgic_vmcr;
+
+	/* PPI register state */
 	u64	vgic_ppi_hmr[2];
+	u64	vgic_ppi_dvir[2];
+	u64	vgic_ppi_priorityr[16];
+
+	/* The pending state of the guest. This is merged with the exit state */
+	u64	vgic_ppi_pendr[2];
+
+	/* The state flushed to the regs when entering the guest */
+	u64	vgic_ppi_activer_entry[2];
+	u64	vgic_ich_ppi_enabler_entry[2];
+	u64	vgic_ppi_pendr_entry[2];
+
+	/* The saved state of the regs when leaving the guest */
+	u64	vgic_ppi_activer_exit[2];
+	u64	vgic_ich_ppi_enabler_exit[2];
+	u64	vgic_ppi_pendr_exit[2];
+
+	/*
+	 * The ICSR is re-used across host and guest, and hence it needs to be
+	 * saved/restored. Only one copy is required as the host should block
+	 * preemption between executing GIC CDRCFG and acccessing the
+	 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
+	 * it is the hyp's responsibility to keep the state constistent.
+	 */
+	u64	vgic_icsr;
 };
=20
 struct vgic_cpu {
--=20
2.34.1

