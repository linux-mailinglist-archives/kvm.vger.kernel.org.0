Return-Path: <kvm+bounces-66384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7176CD0BF3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C13393045551
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AB2363C76;
	Fri, 19 Dec 2025 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f3I9jcBb";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f3I9jcBb"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012033.outbound.protection.outlook.com [52.101.66.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2153624DE
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159671; cv=fail; b=sBRDujUp1WTiba7qv0R3JFpObEGhzD74TNFP4JY1ZTSvmGojQtShZhM9TLi+R9P8yJ6sfiNAl4v4N+b03T9VPlaeD5RMK9Ubyh3WPd7HerRpJdPTnGyI/+X2aAJ2OYrRkTbvtSbAW5KwG1tzDIj3ZWbB8Rg7MjZJP3u6QNX53bQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159671; c=relaxed/simple;
	bh=ugaE/ndJfns6xf6Q/pP0Yo9Q7YzMGZUBoyNPQtnGp9s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pk0btXVWFtl23jlLX5zmxK8lAg3ee1HSIJZGkqAI5PCbkBgkO2bS710Gym8s0AqijC7eqANwkxBmGDywLMYHTc36oG5aiJj41vpv/CGrfoy/uxSC+YNvu9y1acZ7SV9dyhTNfWzsVi7tngC0PMJ8qIMOa1W7ntTm5Ar2DA951h0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=fail smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f3I9jcBb; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f3I9jcBb; arc=fail smtp.client-ip=52.101.66.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=own3Q5eUvFu02pyBacW12rnMpDFgjnUILTio1x3Fn1gfoi490Z/ohnVureT4iPaphoVdlVi0UhHuMU0MOI14Px8SozPNpmpaeOlKNzunM9zfDUZiYMboUTlxOD8vrnx6vHeYAYWQxtr+6XKo1gt4G/Qem48/uLtmSK3zGZD8xq9bVT1ga/UwSB+tqonwgB+W0mm2ydnbWI957bLhzKgq3XquRgiB7eiDdFaTw0V0w068VvkBzHFLwFoHsTy04TFkFnExcM5Pq9N0h2HKjV7dHV2rErY3upO7vqjbDlvUNQ0Rjm56Dqsg/WJTObY2mLDkrPWv9K0Z5niwm9nYR3+rhg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQzMkZ3DzFOxJA1hLZl2pYPasI6+ZdkPSCcCJeb8LaI=;
 b=NrVfWYUTmA4bS+J2h1S45kI1vEhoQxgJRNUtaGyeHvLsmBuyvhxNTBAWA3Sh6N08HKp19avgwI8AE5X002CVTbFOLsaN55eI7AZcwTJFFsV1fU3riLzpiCl0Cj83R6Nu3EsxUAUa4im9Lie6MtMs0GC8+O8oRd7A+GiwFLSc5uvhX3xLD4GHOoV9/QgKfZptd2GZgxoSShTxCaC5E8dSotF8osJbsE/TotHc6tbk7UxJMmyetGXcZMUfOipMcyBVOCabLOmNcCUOIzZB5ZqnmeE9sQidCwAWMJiobgsl2C6PbNRBpk8mlI6Jl4AtI7XF1AKjoYmW3KI0OAJMC6FLfQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQzMkZ3DzFOxJA1hLZl2pYPasI6+ZdkPSCcCJeb8LaI=;
 b=f3I9jcBbgiEyPeGx+2I7mG9NFsmZyBA2cGn1HIfHouZfFnwEiHeaUzykWDVlUJ+JiXfhojAt8Fvn84zWXX2QmluQOsY1Je7be3mZkpJ8pOHKauPX+2vXqdtr+Zsqfm3jc03BlDc9DWvgCuhKMlyZAKPoMowkvd+khmf2ku3LGcQ=
Received: from AS4P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::15)
 by GV1PR08MB10524.eurprd08.prod.outlook.com (2603:10a6:150:15f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:54:22 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::56) by AS4P189CA0041.outlook.office365.com
 (2603:10a6:20b:5dd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:54:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:54:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkV6BctwD4RowQCFwFrrkXxm+uIyZj8GhEi1p5X+6dCw/87NJG2lexVRxy08Fiow05txpRW33QP18p5/Ej5VZDG+VM/0imiEsVhCLaR/M7KQEViX/A9xYT9MCJEynQ4rfWdbQauHnStNtPbMzvw9N8Kh+1F/nsq1WtGFyviVIuLnglDA43rYmW3ygaGxASaHhrrbNRHgCqiFAuWVGWYRQnqewTA2x6WfYbaU9HMGq+LgfnPfn/aNFMaZOBoI0dcdeStYFl0kPOQTpkG0GkVbAGN0+hyzqRJEG7G7S8agMNEv2N6bNVJXXPrnUIzbZokj+sVwwjuMCGEnk4L4PaMuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQzMkZ3DzFOxJA1hLZl2pYPasI6+ZdkPSCcCJeb8LaI=;
 b=Ckm6zCVNUm1N+4sZbYa+cfEPuxuPh/mCSb8ilv6QpBu1ZF1J3FINzd/E+SoptOTrqI3tyHZLYnJkhFgK+TeU19DPutEor1AZvWgcQ9XIDjkl1SfPjUn6Xvw83vWxvHa4xEynPgRmMBjameHvftTR+2aaJRsCkk09kLcz3P6YB6EnCwOfBT6Z6xAyN9FhxN90suWMsYit0Q6TA3JMzCmd4T2RDGLwm71K9TCdK7zmd9AHG7PoJwv/XWOf6+MjuMQNTwTnao6KVaECxycFO/Oq4ZG8YJgYEyJcCOgwcNRB+WpxOZLFZGoNXCtE3YyaieYbFtxG0tH1NALKAP0MFiMZwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQzMkZ3DzFOxJA1hLZl2pYPasI6+ZdkPSCcCJeb8LaI=;
 b=f3I9jcBbgiEyPeGx+2I7mG9NFsmZyBA2cGn1HIfHouZfFnwEiHeaUzykWDVlUJ+JiXfhojAt8Fvn84zWXX2QmluQOsY1Je7be3mZkpJ8pOHKauPX+2vXqdtr+Zsqfm3jc03BlDc9DWvgCuhKMlyZAKPoMowkvd+khmf2ku3LGcQ=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6515.eurprd08.prod.outlook.com (2603:10a6:20b:369::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:53:19 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:53:19 +0000
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
Subject: [PATCH v2 36/36] KVM: arm64: gic-v5: Communicate userspace-drivable
 PPIs via a UAPI
Thread-Topic: [PATCH v2 36/36] KVM: arm64: gic-v5: Communicate
 userspace-drivable PPIs via a UAPI
Thread-Index: AQHccP+GtSwTW7EH5EC9df/dn1cNgg==
Date: Fri, 19 Dec 2025 15:52:48 +0000
Message-ID: <20251219155222.1383109-37-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6515:EE_|AMS0EPF00000191:EE_|GV1PR08MB10524:EE_
X-MS-Office365-Filtering-Correlation-Id: 3880bc41-0064-4d4a-9b2a-08de3f16e04f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?iTOOKY8z5TOzocpPT47S11s32GLhtufGxXKLPvKxWxbYYZ0GZIuyyRFF4l?=
 =?iso-8859-1?Q?zU6KEITSUhaPtRoICvqDWiuJ3RUX/8nAc+uRngyJivWwIsq5OY+W1DfnPB?=
 =?iso-8859-1?Q?mUR/do9bGqmEqiG6R9ClZCjE+AUKVHOhMIzLddSdJiap03Z+i3rviv8AMO?=
 =?iso-8859-1?Q?HHK89vrmLj+OS9oKOyleBanZywvzIYUxEBqCDgejokZCMO0O8UTp1r/BNs?=
 =?iso-8859-1?Q?COZ1TNlFu3iJp3PGwSY3/JIbMEylnfUeWiZKzheWTgD6wmlchlunVOw47x?=
 =?iso-8859-1?Q?AHdv2GtMH7a/GC0dswBPhRlv9kN1S6tcWy52UvIBHJ9qJjtbuzvCO7n/nU?=
 =?iso-8859-1?Q?kVWa8gP9ECJKP2Qa7m+VeQDFW1v/QzqrwQDhMtN9LUS/no6KX2UU3T7RRQ?=
 =?iso-8859-1?Q?vO3aFKLWMr3hOJ/zRZ6GIksnSA55iyqJbd4vyKbNOf6cTZggkqglsFc3Hb?=
 =?iso-8859-1?Q?1bUx14t9640L9nXTwh+EpJ3KJ8zb5IM7dIQ6OH+smRuWUzvx/0iyjBmF69?=
 =?iso-8859-1?Q?4U1038obUGvC5nqdIvtG6/sv9IxxZ8rS8j6g8kw5xcZMGO777hbLUcRl8t?=
 =?iso-8859-1?Q?vD58SIDnAD88EfaKmdV340XSqmFxXnWEyJc0OBMyNtmSMvYLLB60bLqUP9?=
 =?iso-8859-1?Q?pw74DwYwLYO08dZf7NH++dOq8Km1raXvl5mi1rtrDDbShOxM6dlpRmqyZT?=
 =?iso-8859-1?Q?BjVOM4nltSmx9kG8fdqrlG7vN/zE7R9ZmnaBqq6D3ovpcX+DCAilJIX+DJ?=
 =?iso-8859-1?Q?rqWMmz7phbIi7mddHrCAnsLg09uysOnqdwTAqgwmwntU7zfAs9K0WqDMTs?=
 =?iso-8859-1?Q?PgHRhXu+Fh07pftB780zqOFT6xO1IMm3P8RfAkjk48ZHMesIlkZBpp/wcH?=
 =?iso-8859-1?Q?kNfZiJ6TPFFsk2yZarX3v0x/ns3AUuJwqtE2i1g2WuZnFMr2N3um03W53B?=
 =?iso-8859-1?Q?gxEPrJbTO97Go8N2elK0wymiTHPc0Q2ej2H4T5Tpe+LmTwP6DDyWfK8N3W?=
 =?iso-8859-1?Q?54+YaczM7Omhgp+aJx/o1+r6lUxnodi5u4A+JmJmssq43JpxxVOnFkwJN+?=
 =?iso-8859-1?Q?uKuoj6+51diTMW/T5WLJrDtUgedri+Yl+QEpzAlWlAK/eO0FOH7hsimgjK?=
 =?iso-8859-1?Q?4lcfApaAxe2U8k7oPVz4Dz7ywSs6ZR51rypbUpYMDpYOOloOmpg32k0Clv?=
 =?iso-8859-1?Q?3o2l7NpgK/mDbX5HOOZCRB8qqUz43+Ibx4oN7JYFIoU+jUnCmWKb/YpGVQ?=
 =?iso-8859-1?Q?szaPlpOTpjWRz8DNhBe2RXnk8ZPcL8GCjVrnBPgkqpcMS4H9DpeUTX96vj?=
 =?iso-8859-1?Q?GiRcigA003cN6DiagR4DvmmbRk0lf+kLEjlVLF1N3S8nZ0IKhIoVeiIPhm?=
 =?iso-8859-1?Q?TjmOv/keIwX5ojERqjQ1DOVSmFxinf/g3gHy7JvZxrHPP+icPrc4JghHwi?=
 =?iso-8859-1?Q?D2LM4RmjN1WgqrL4Vt1jrVU6P7DkjJsOXb98aX9G5lrWTTv6RSw/QJWcKs?=
 =?iso-8859-1?Q?9QI8zE+xNpInroAWx1JK0EccudYR5b6t38W6/1Ahom2gtp/NH8IQHZ0eIC?=
 =?iso-8859-1?Q?APPVB6UY776pRr6VKUoArl4JgLum?=
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
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8762790e-4b46-4c6a-eb9d-08de3f16bb2d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?LKpatu9ZnNSMEgaWEi9MeCMzIKfCbZZRgFg6VxDWM6jMD3wM3BRa8ifWmC?=
 =?iso-8859-1?Q?+e80dM5+3rGRjgAeEHYntq7scUYP/iEfCnB51OgS/ptdItG0uaLrN1FKZ2?=
 =?iso-8859-1?Q?mBmO/dBXyBTfKUk3BLl8cUk1yNNTq3OA9SdyfIpJ+g+6Gjd2Ak37Xor4r8?=
 =?iso-8859-1?Q?eeOlxFTH7xWui6A1bIS3UlzS2Useu9EkLIouoNgO1pp2dLIOmd7DniZ14m?=
 =?iso-8859-1?Q?SIsSK6Y5In/A3e0AESkLsjpEyRitbh4vc6quzuB/zRhVqg8CCAZYp7yUH5?=
 =?iso-8859-1?Q?L0WXvZJZxwcDtoILB/5gozDmMuSEPdmztBhxehdaiR15WmpNlSK/PVNyxE?=
 =?iso-8859-1?Q?Kei0ZcLNwWzbuCMAOqjML/epQg6hD3Boh+KE+obeikxv3BVeTrwr2zY2La?=
 =?iso-8859-1?Q?BSIBjCTowOVQDKSmtUN/ZXfaUOCNtoGnf5+gNRWo9Ywrc1de7+zPombNlt?=
 =?iso-8859-1?Q?kwynJWmzhWiHoS8qc+wfvJJ5UY8j/G3144RIoYJ8jmgTLtsluYsLYMkTtU?=
 =?iso-8859-1?Q?0CpkRQHvIycQcNsl+ND289+s4kZkwteUk1xt1hz4vP0lazuO+5VlExobrQ?=
 =?iso-8859-1?Q?4/7osoKM+TCL9NXWETG5iKZixzFzNf5/Rvya1HoCPF/pmGbmAfSbqp4bS0?=
 =?iso-8859-1?Q?mva3XebN9xSh5m80++nQy83oNN2zGRZcD5ZO7nvpCtlad9ZpzbKHfgF7mX?=
 =?iso-8859-1?Q?AvsNzStypnITxVOtf5lHbubgd8qxWYYIcbWmgVQPJpt4mYlCWQIP7Q2GW5?=
 =?iso-8859-1?Q?sHwQHCuubE2mVco5bAOd76hqMT1s0CYkpNyNJPCNGEkXqnxmUehR5FrS9Z?=
 =?iso-8859-1?Q?kRGd2aYMqgvN3PodVeXWipc6qKI8cD50pq+bw06O0ISzFXDoHWRHGd1B6n?=
 =?iso-8859-1?Q?3ES0uEhLqf25l3QkO+yMTqzZajlFNBPUYOD9rMubO4o2BGLpGvXNJ+fG4w?=
 =?iso-8859-1?Q?3Ttk5oPj0T8XDd6+tO4FOnwFPeR1ti5HnncCQx3ILZq/ttJai7arGbcklw?=
 =?iso-8859-1?Q?3pGQ108b3pgUvxuhCyapmIiEJ8lwZN77N6PJtApbRcSCsCADZQZyuqRoik?=
 =?iso-8859-1?Q?sn05g2efAySncQPmnlwshnazYkXQvXYP7f9ayFMvElst6emNb1YtqXoAMG?=
 =?iso-8859-1?Q?XJQ1nsbxv6w5mHnhjFqRUu0aQXsNyvD9Ap8dBpSWlSODpwfRatln4+N0d+?=
 =?iso-8859-1?Q?ePxwuChf9EaU/ONhPXj+A8yV/zvp2ZpAO9503VHWG46F3vZzzyPl4WowR6?=
 =?iso-8859-1?Q?bnggqRevkY4OX2G5fQ8er0mP/4d5CI7XfzQJtQF3Ck0w3JPT4FTDVGMxLQ?=
 =?iso-8859-1?Q?ZUyT46/7HxO5mCyEL5JL2PfW3utIdV8dMGACFsq85nbLmlutXuyInA2UDk?=
 =?iso-8859-1?Q?juVPv5a6PrYpFtMUakkoc3dnTP1pZceal7Um2IXYWEzsDQYVRDXFnyEEK3?=
 =?iso-8859-1?Q?ptyDLCoTEGf+zIwhuz2t3eWsXvrrFgIsMwf7eTwyckwv38AsR/8jGoTShK?=
 =?iso-8859-1?Q?AjNU9xCbXiZq6VO6o8UtAL/fR2Qd6CVMqcASPaIQsf9FzCuSWRprKIDI8j?=
 =?iso-8859-1?Q?J8X9ji0ZdHUyuksIZGmjUWpubNU01XnoyPQDjNYiaLNjepUsUuMpwPlXVY?=
 =?iso-8859-1?Q?UGaLLLhGTLfXw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:54:21.7249
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3880bc41-0064-4d4a-9b2a-08de3f16e04f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10524

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 25 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 |  8 ++++++
 include/kvm/arm_vgic.h                        |  5 ++++
 include/linux/irqchip/arm-gic-v5.h            |  4 +++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 57 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277d..d9f2917b609c5 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] with of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 78903182bba08..360c78ed4f104 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -719,6 +719,25 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	struct gicv5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	int i, ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	for (i =3D 0; i < 2; ++i) {
+		ret =3D put_user(gicv5_vm->userspace_ppis[i], uaddr);
+		if (ret)
+			return ret;
+		uaddr++;
+	}
+
+	return 0;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -731,6 +750,8 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return  vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			break;
 		default:
 			break;
 		}
@@ -751,6 +772,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			break;
 		}
@@ -771,6 +794,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			break;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index bf72982d6a2e8..04300926683b6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,14 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/*
+	 * We only allow userspace to drive the SW_PPI, if it is
+	 * implemented.
+	 */
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] =3D GICV5_SW_PPI & GICV5_HWIRQ_=
ID;
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] &=3D ppi_caps->impl_ppi_mask[0]=
;
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[1] =3D 0;
+
 	return 0;
 }
=20
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 22f979b561054..5a7de3b74a99d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -404,6 +404,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct gicv5_vm		gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 06ebb2a1cfb1d..123c6cfc344c5 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -365,6 +365,10 @@ struct gicv5_vpe {
 	bool			resident;
 };
=20
+struct gicv5_vm {
+	u64			userspace_ppis[2];
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1

