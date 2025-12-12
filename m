Return-Path: <kvm+bounces-65855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB571CB91B3
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CDA930BC506
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FEA322DD4;
	Fri, 12 Dec 2025 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XIImpdSV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XIImpdSV"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011071.outbound.protection.outlook.com [52.101.65.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A331AF25
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553031; cv=fail; b=eRgHuvEdENi+VNbbwPhlAeOkbPM823ErdGid/J6ECETUFV+0fUAH8hkXhUtPGPyGEIN9kGainHmoBU4SsKuALuv2c9VNdqGZOHuojcMxtxQefRjkU+N4lZLKB4ZosZSvA5mRkor+PNzOxKYL7E96itR/FDULUd6yOCYrUCRercQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553031; c=relaxed/simple;
	bh=TMiVVBW6mvzQanotaBVFf3fEtfAHSQimQO2uyTheb34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IE2OoVvccbKuiMn0VFT0ONFfWEsGLXO/9H/93Zfi3mHXiXBrDduBfuzpesOOsLpKYuPpG0S3YyLs/aBKNzpWEGZQxiKZCcRER6PJLQ6hXa7UaY1y38uBGuiTtFyGZs/ottwL7GTr0IvOzF+swptsfiaXa76qNW+ZPiOjhfyoy0Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XIImpdSV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XIImpdSV; arc=fail smtp.client-ip=52.101.65.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MxDd4R4PCUJqKoeQ+KGdzqMwmpioC1ybhFk/Fc0yJUO0TZ6LCM3SqK5UPDiIYYZ8j0wtsRdfZvLAZGBWhNTcTmy/9k21HO13i8/wqBdFDwCKz2Xaj7NJX8fw/2teHeuR38Zi5EXBWNnIKpJwkU2mX3W7q0SQZz4VgVvA2Ea+u4Ls/63D4Jld7eX84ZiXwudcAAPQ1G32coA5478lvfaQb5EtXzltoNEu+102b/ZvDcs9K4nQgLh0kt0s+F4UqdSU//B/S6jttjzv6vIG4I+c92P5SZgwLsaI/JtwuUEckdmDUX/0TkysynMCECpGSghlU8EzCgFwgFpBgVSsJiwERQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKproi7dOCJs53RqTSgs39rdKZdI0B53bevtMFZzYx4=;
 b=vCnwskhlwukMTtY6/zNkUfYx0EGrKeZU/U7F2r1uXOJolLHPZKqkSdzlJHkaFmJ0py4sge5yjja83eUHAZPKF7+NPD1d9dy4t26135zY7gjdrKDl9bAZ/FEIIenyrRarA1ocYs8h5VJCeiV3jbLgtdN6IRHcDi+bllpbNbRWPYlE+gTnvYFu0+yREG0zy3RNS/kZ7p/bWUZphk9YGsx6Q3VfHUw/q7sPum3/UDfCWftpc67fbe7Nvs6phsd9NOeI5xUSBZi3r67X55cp42oJKE8/QcPGfUew7kCcHfcQ8PRyTnQErzExSdXz1NSlfXAfa1Jfmh0zeBxYWyipDcHL2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKproi7dOCJs53RqTSgs39rdKZdI0B53bevtMFZzYx4=;
 b=XIImpdSVXVS0F8BuPsavl+ZY2jLa5jXZlL71uxUs83YOJk4sBwB7m5ERsbz7FwSmpbssd9rfqq2WZ6pil9uaBvBnVa4K1HOXhNFWFuWa0mJtoZtaIEJY9GbYUYfyC9gFrILOk0YuBxs/r4JQVLbu0g7j8gOMXP0hsj2HLG+5Tjw=
Received: from AM8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::20)
 by VI0PR08MB11043.eurprd08.prod.outlook.com (2603:10a6:800:250::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:20b:21a:cafe::1) by AM8P191CA0015.outlook.office365.com
 (2603:10a6:20b:21a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahj3/tr9e737TgehjslZ+M73CQWJy/uAd0J+hd0+sr7uOfexB3HVLbef6qOrAAOyQ/GmtE11NXjus0D+LzuxOtaXA4onPqwjgwRH953tQtG7Qd4yAuiNrOq5poxYueCDXIY2LUaBqETBYgvakm1YtRIgLluhklGBP6SdFP3+/qYdWrgC3nJ0kzU+uoO5nQaFKEiWB9/LX05QhEfZmEglBlf87GGM0NNLlCqDApoI71I9NPVHkcCWI4uokuiTB9fTQYuM5eoy2bY+2en4DGIWMy3Dt1BJcE2HH6yII2kthid/of+VDDZmX55PDWzw7oQD3PG2DCqGP3lirlTQqX3DpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKproi7dOCJs53RqTSgs39rdKZdI0B53bevtMFZzYx4=;
 b=u+tb5QXYc0Fe/spWmicKB4J9V6yWQSSK9d6Q7h1cUt6mLw0jI0LDR/whqJBBjnVV5TaEWqeokdR7utEyDAWzIzvKf6Q2I2toIbZ/lD58Okf1X6kBCAq0qshiCvcwEb1gguJ9QP5AarMYqSAqhMOXFtE1UPP0ZIRQFBrek5qM3ZxqQTMIivDo2fwcBnMezHVkUYURFgcESQj9x93gfF/5t7PqTs0CQzBkcMnrBiAxR15vE2Bl3JEIFTAuw2B4HwiaquM56doJ5uPqvSx+hphHsk46Q3WKEO+EPz6jYkiP6+uBuMz1mO7BPG5fd0m6lOJ1zOXfA4d4NGdrpDyo9o7b9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKproi7dOCJs53RqTSgs39rdKZdI0B53bevtMFZzYx4=;
 b=XIImpdSVXVS0F8BuPsavl+ZY2jLa5jXZlL71uxUs83YOJk4sBwB7m5ERsbz7FwSmpbssd9rfqq2WZ6pil9uaBvBnVa4K1HOXhNFWFuWa0mJtoZtaIEJY9GbYUYfyC9gFrILOk0YuBxs/r4JQVLbu0g7j8gOMXP0hsj2HLG+5Tjw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:38 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:38 +0000
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
Subject: [PATCH 10/32] KVM: arm64: gic-v5: Add emulation for ICC_IAFFID_EL1
 accesses
Thread-Topic: [PATCH 10/32] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFID_EL1 accesses
Thread-Index: AQHca3smxBv9JjzF/kKDD2nLSHnzog==
Date: Fri, 12 Dec 2025 15:22:38 +0000
Message-ID: <20251212152215.675767-11-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AM4PEPF00027A6A:EE_|VI0PR08MB11043:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ed42fb-ba23-4619-860e-08de39926e68
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?G2K8Fe4xkYcyMZFE0CzynlDL3qDxIuS536uOCWDZK1LhqiRvyXOvPeDrEl?=
 =?iso-8859-1?Q?sFUsIGEmJnaLXN493TCPznvXp+3LuwjyfnQLDvfHR7vCQbXdZ+4Jfn/nUN?=
 =?iso-8859-1?Q?53JLzCQ7oIpiPvvR73iZ9Nx9ZqieqtG7r1PEDytDOkapooSfHXLDXN/ftC?=
 =?iso-8859-1?Q?+pXwlXZg1YLX37r05Q/QT9zqeFSimWjA918qrovsbSVdwkgea2IA3t3na7?=
 =?iso-8859-1?Q?NHdyXQAEvABs8iuJyTcSz9+S6F43YAqEtbmLVlH+n92y375qsdTjGILbFi?=
 =?iso-8859-1?Q?gPzlAjYym0hvp6sdEE2xgobFQIgqj1rrL0qOYdL/IePq4fDhZ8J/RyPDWG?=
 =?iso-8859-1?Q?VVgqyIFe+mmyNrobJgLOrPdRiTI+fogJAXV/By5REIf5yh2/kiPZdGrW+V?=
 =?iso-8859-1?Q?oYsbGONSwoiYozOC5H2aUhS4PIElG5nD7Ti8OMSY5HAUXl3hnuXr4O53jp?=
 =?iso-8859-1?Q?lXpfD77aMKWkor/aiOIKlv2xEd0ig7UlhBbgLjju3O/h7Speq9lYoyHCXm?=
 =?iso-8859-1?Q?rCd80QmRxhPuoJNEtCok/0GUevAxJlmpOz8B8HjV/d8MlJRrPA59CzKeU3?=
 =?iso-8859-1?Q?r4EOFhVNvqhMVctDfw6z1SD2dzZP2AN5gvK0ZMy/BbLWbKgAJRz5N0yk1M?=
 =?iso-8859-1?Q?Mmq3bC0yGOHb8qvK1Ac8Xq6RhEek5siKuqqlRibX83xJnR9uzPeaymUcpz?=
 =?iso-8859-1?Q?T7NhP8EebuL0j0YokzCHfJ5fwpayiAlhJqe5D5brjJ6EcxqGlRU+yN85zW?=
 =?iso-8859-1?Q?LvLs+Dw/RpOTqLoK2rmqGr+//Dr7AjL9RLfH4022pMGFIGPdFrR7btFbZ+?=
 =?iso-8859-1?Q?gi23HsG2kTbUqgDVahQ/89m4bfimCnMhc2Cccw3geNF+dd/rABwzSvtFug?=
 =?iso-8859-1?Q?6F95ITzKeO66JSkCRn0ulQn+LWQyd+udeRl70mw402jcYOtHQ8odziCGAZ?=
 =?iso-8859-1?Q?SAcXC1MUZ+q4i7jdoJ0OF7o/5+qLdruiKgq+KRUrIkUrBTUFefuVaMTMk3?=
 =?iso-8859-1?Q?pJHfvoTj09TqX2oa/Cco/p4fiyGXKxTgBNi0rF5Z91rnlJWQj74VEaCYnI?=
 =?iso-8859-1?Q?6ZvwBp8cO45EzXa1HBGs8WPJaWo8rp7CoM+18E146mP1ZFFfnhOp9fZxDx?=
 =?iso-8859-1?Q?wfl/ijjfCM+tJYo2QNwszVdJlnnwZzvcfGYV0YTZicWvvb1mty55gDxt1J?=
 =?iso-8859-1?Q?NdhwohtZBiHBXtgR7SaLyTjK58SNEm6tB7JHNxKkDducWk5S08Mi8316Ah?=
 =?iso-8859-1?Q?WuQHsJGn8eUyWtbUFZOPSsn6ixESuroQUNAeImk5ZsviRzTodGGuXi9r0z?=
 =?iso-8859-1?Q?rOdZeoAiVhQR5B3tVWyoXdmbDVCEg8Q8QYw4DPpzcVZDiKB8kSw2LKb9Ea?=
 =?iso-8859-1?Q?N0FEFaonz43XD7m4GNzUMU7DOlGrUpBkBI8BAlfk7GjIv0oLlQVpNwTkha?=
 =?iso-8859-1?Q?OyMF0KLYoQMCq1ZkvuNapcI4aNNuaTs3xAUPbgeCccv7O55/5/GGC/z99G?=
 =?iso-8859-1?Q?61c98gT1Qz6hofPam/4KAUE7SZKH0VEwSRIatSo3Fwl4V8nGr9KM7or4Ch?=
 =?iso-8859-1?Q?yKVULHD/plcN7WSuYN+kf4yhr2ud?=
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
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3d908a99-2d84-4310-487a-08de39924919
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?LM0ps4KazcWM3q4lUxJVQxzBiyaJQieyVj/fEhs8XZBAaG3Gjfayxb5/C9?=
 =?iso-8859-1?Q?4l1bGZZgkUu3P0Q62DGI7m6ZCPtgWFTZE4xplKH/n3KeEkRzuZPCFX+pBF?=
 =?iso-8859-1?Q?xyQqwkx1Vb5gjK/nRLPI9MPaepsQs1Y5/+CRdmT1uGQBAwh4YadvuK7AJE?=
 =?iso-8859-1?Q?oqWhKDTb49vKeuE9Ao1s3BbFhTqtc73fGqYBK35iEF0Yo5RfLRttUkzMKJ?=
 =?iso-8859-1?Q?3xvW7UJDptqDFcSL8v1w5b4KHrg5YsZXRQahKIhmMzncAywKZWBb0BW/sk?=
 =?iso-8859-1?Q?NeIyXMonkWhWxiekDr/ZAhVi6vyhog3AZwAmYunJyi3gqG7o6I5z+YegJB?=
 =?iso-8859-1?Q?x3IVTnotPieNblrudCLO5Hhm1LBfAN0X0G0i4Ez/UoAqAFTEtaAS6miQzT?=
 =?iso-8859-1?Q?NWNqC9a6L8C78/q+lVfhoOXriZJ/Zzl05pxnnwYoCt0fO2MdlraUOhlpMI?=
 =?iso-8859-1?Q?owhRt42Xr5T/2XYU6aln899RShdrxxutjOqAl9pikxHTm/yBSwAe9k+Ah9?=
 =?iso-8859-1?Q?AjvlnJmRJyI74uLVO17iOdgeFxRXZk27D3rkJbuWxuTz8D1VOrH+CWK/4Z?=
 =?iso-8859-1?Q?OuIDG9ZUwydV6qWPZGImT7GTpLw5DIJ+Iv5XW+D8IgomX/VfEj5+4WH2Rr?=
 =?iso-8859-1?Q?pXH/VS8Hz9gelZp0VtC79+APA6S/+15kkAWVjBPJ69vkkx71nv45Kmi3K7?=
 =?iso-8859-1?Q?NKPqhrVSQS+EG+oLpY2t55vzesKcjYrAa4FpZNKT7EEJXraMobix3m3GGN?=
 =?iso-8859-1?Q?71HVH8h0TPVY69Kkgj/SGI3xlAgy2P7ynP9bneCtn5Wo3/HuyolEQnPZZV?=
 =?iso-8859-1?Q?HvI7knlx1YWgo4IkK5HRheHXo6ng0UNGpNKig1GQUqFs4zZyVLcqERJP7A?=
 =?iso-8859-1?Q?FPZZYkg73WAkexmN3kSgBcGwo92VdTgl9RTfAKxbNF2bzO5aw35ROHiz01?=
 =?iso-8859-1?Q?iSBFmQvDUe848AC5XAFx7kBDiVsXbXMWWp+ybvkz8q4H5lz1HLfpk0vT3g?=
 =?iso-8859-1?Q?vQHX3UZI6gwzhK18A42OpOrRt1dPTNtENAUVnzxt5V1NhzJMfZVjM7P39q?=
 =?iso-8859-1?Q?cSbgNGzA0tz8ctZkRmwVrmWG3ZJPKJ2lFnY2QHc/9tdNHVsw6sLnI+4Nai?=
 =?iso-8859-1?Q?k7hAhYT9Xf/GYPh+cMa2fEjOxAojN+nUWu8SrnN+CRR+JLcx6Kk41+Fy44?=
 =?iso-8859-1?Q?/rrGcsDZnlPofBd3J793or+5h25eg8Z/Kas5fe0PjqilwdtSdTCYa4s7Ra?=
 =?iso-8859-1?Q?uqNVzQzQfAythAv8beBUmd5te0f9zbyYk2xJmnne9UQtl1H68BVWxomgNW?=
 =?iso-8859-1?Q?jNu8vazat8ksV8Lc0DWBeSA0aX4G4KAabrEk5vwfdb9baziqB1i5h2nbrF?=
 =?iso-8859-1?Q?57mv1bm0uyODUOm457wPuLF6I2E1+ycf0r459C+q64UrU+8Ex2JZEUC+ke?=
 =?iso-8859-1?Q?SnkPhYalATHzAMc75jq+i3u/Ok2aSMBBx+Ot3xJGDMd5Pl0JG3Mj3iU67i?=
 =?iso-8859-1?Q?yNN7LFCAANLtrYKNNmQEc5wPpX4bb9YEdB8LyZuCiRRcSdew8QgUvVIw07?=
 =?iso-8859-1?Q?SbyCI9D6OqM78dh7dQpbG0ztHLiI/3pzfYWynJ1WX+iXP/s0E9M5fdAKIv?=
 =?iso-8859-1?Q?cOma/T9y0Asgw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:41.2580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ed42fb-ba23-4619-860e-08de39926e68
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11043

GICv5 doesn't include an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICH_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

For GICv5, the VPE ID corresponds to the virtual IAFFID for the
purposes of specifying the affinity of virtual interrupts. The VPE ID
is the index into the VPE Table, which will be the same as the
vcpu->vcpu_id once the various GICv5 VM tables are introduced. At this
stage, said VM tables have yet to be introduced as they are not
required for PPI support. Moreover, the IAFFID should go largely
unused by any guest using just PPIs as they are not routable to a
different PE. That said, we still need to trap and emulate the guest's
accesses to avoid leaking host state into the guest.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFID_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored.

The trapping for the ICC_IAFFIDR_EL2 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 57ef67f718113..cbdd8ac90f4d0 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1582,6 +1582,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1607,7 +1615,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
 		return;
=20
-	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+	__compute_ich_hfgrtr(vcpu);
 	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 	__compute_fgt(vcpu, ICH_HFGITR_EL2);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fbbd7b6ff6507..31c08fd591d08 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,24 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (!vgic_is_v5(vcpu->kvm))
+		return undef_access(vcpu, p, r);
+
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3411,6 +3429,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

