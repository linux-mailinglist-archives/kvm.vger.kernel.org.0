Return-Path: <kvm+bounces-66392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 04BCFCD0DDC
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 81BF13062914
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B692E382BD3;
	Fri, 19 Dec 2025 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="idTrEAwT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="idTrEAwT"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012015.outbound.protection.outlook.com [52.101.66.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA3B37D525
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160851; cv=fail; b=EasxuWdvD4rpauLsQaGMjIzNUXiTO4F5FRbMPx8FDdhYvZrRx0urgHJqgz1OTLLf70CmdRvDIFQX0gZaFTSyJEfCU0/uhT+KR9v+jjsrPtSyfQN5rN6rHKKsVPSj5gzPYD+CVoimRt2o4cCtcEC1lul/TZxW3tE0d3DhiLKIgUE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160851; c=relaxed/simple;
	bh=cIlJ7MCpjj9A8nyTYR0uTK96i2gPo1Yx3NKEWQholow=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VCEcXI1LlhUvQvhTLYjZralPT4ahUg0Yuv1LwY/QHw5DVYECwroLG3Mc/fsmQeer1WXfMM4pA7ak8LaVhniwQ5xsnqieSnySzs9OVueN6VP7rmL/SKiieBXVqrwZpATQ3bvPegVMzSgAlZk0csOjyO1YXBB6nxKp2WlZPsMXlgM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=idTrEAwT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=idTrEAwT; arc=fail smtp.client-ip=52.101.66.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IAzuU4ffio0nuhipkQEEiqhwGTsTC6WeUpNTN7Qur1cZVoQmSomgEF+yYUl9oIzlvSAaOSlBvyMk0ZTiQArc0S8OG7lbd8OzcKhYHDqReNgBgywvMsSNMTOwiQbPO3iFp6t+PQjAxSYbV3XCGgvL35T93WWN60S3RMN7CC2Y0WkleJ09YDJq38Mx+lXoy9RwML5rimomDBqAFiREmdpHcBC3M64f1buNu/FffaNQVFy5s7FLE+jumek6gKxRCddtkYxUSFiqLvlQ1et57KcCeJsBfmGdcfFDnBw3w7xS2kWz+fHOirZS7SCk9tOadGJYS1U6HVcdMoxljazwC1i59g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naFMa+v7J8CPEjSGakIkh4OxUkyVK6j9xdy41h/a6MA=;
 b=mT4Y/OGjYvXyV/FwiLyiA/goPVV9Px3wGuHKozGR64mux11RJy5L/GQc6zDXHRlxn3ipzW1/Rg9SG6Pke0AAYDrKn68TXIGPrE7S+GNRsjQmH4EtDXtYdqf7vMAdv+GnwvcJHzbhNSzSU70KJDy5HWNVp1U5vw4GcaBNKQcSDTHo0uBwy5n78mprC+cpE3TkS9ngkf7JvBrDEJz4Qtys5Ercc6qg9A73P5O4C4GRLN7q93jfO4OMqilu9aU5KmmXuSHyB6vzEa71uFMhORnLoU0AE8Vdq4JD4KkawzqQ3gMdgheMr+Tw9PQ830CUfdY2KAQxq43XpKF1Kht9anUsPA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naFMa+v7J8CPEjSGakIkh4OxUkyVK6j9xdy41h/a6MA=;
 b=idTrEAwTqyI8mk2W5hxshr03EQd6NYb/p//TlHKYTfok1sJC5CQ9pQYgiX1AFQXdQ6W8M6/GX19DhAYnrQTnhs3HVMpjQ/P8JGZfYqiKnp5K4dSlYO8ZkEvHtOVg0TB5f2fGDEXjKx2hsCybfo+AIUFrbXCr2ofI49B3pF8ANG4=
Received: from DUZPR01CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::11) by GV1PR08MB10751.eurprd08.prod.outlook.com
 (2603:10a6:150:166::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:14:02 +0000
Received: from DU2PEPF00028D0A.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::a8) by DUZPR01CA0053.outlook.office365.com
 (2603:10a6:10:469::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:13:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0A.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzZneY7LutKiy7mNCC4LvnIRiMSdCFh5pRl1Xpkvflo+Js1Fl7I/zav3+1fWJbuM5sqJgoC6U8O9qVCkN/KrFccRcfxM2+JyR6qjZI3Hl21SPZKlvh9y1sfXLXQQgvsrD0VYtNktzY29vexe1YzZX1RCyDatw0ouugg/l9dx0DDiFNwOOTe4V5lmNIabbGG2IqWizk/2OwpxT84yF2lsAXOPyDFrdR+MmHG9uR8Qk3fF3QaYajOGq6aMjigSN4kR8WJgaMN0yySjusJOn3FagKmWue6fyKycWPs8XtXfR6+JPr7d9GE+Jh8pWzYpg6HwBUo22diMC3lmNbJG7PzpkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naFMa+v7J8CPEjSGakIkh4OxUkyVK6j9xdy41h/a6MA=;
 b=Cd6PrxtLqL4YczmIjcMaYXI7zaAbkLnboIgBvcq7mBxorfR3fYBFacb6EYWwYgR7J7AdQkE8aHpugar+uzXX70fz+0xG7RPbubBxg4Dfm17cwuj1vliVzDHlkcKNxgyBKB3ISieYJWcoGuvq48uK2sBLEhY77xiOWPFkPw1TXhxwK6q3mWhsnOHgdKXcPdDKsbtNmNSedjc83SkyK+e46b9dl88vPd+znLWTcWAv4PJJTH/FVuixJqgFVJ8yxfimer8ANsbLKbKQ1g4Turovyx6lbSylcXBD5Ikv0w0pF8exRaruj1U5YXp4mxkiyT0Fjp7ACpv8wCDHqpjZ0XR2jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naFMa+v7J8CPEjSGakIkh4OxUkyVK6j9xdy41h/a6MA=;
 b=idTrEAwTqyI8mk2W5hxshr03EQd6NYb/p//TlHKYTfok1sJC5CQ9pQYgiX1AFQXdQ6W8M6/GX19DhAYnrQTnhs3HVMpjQ/P8JGZfYqiKnp5K4dSlYO8ZkEvHtOVg0TB5f2fGDEXjKx2hsCybfo+AIUFrbXCr2ofI49B3pF8ANG4=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by GVXPR08MB10452.eurprd08.prod.outlook.com (2603:10a6:150:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:12:54 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:54 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool 00/17] arm64: Support GICv5-based guests
Thread-Topic: [PATCH kvmtool 00/17] arm64: Support GICv5-based guests
Thread-Index: AQHccQJUzA6IisCEGUe5IUJZMsVwcg==
Date: Fri, 19 Dec 2025 16:12:53 +0000
Message-ID: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|GVXPR08MB10452:EE_|DU2PEPF00028D0A:EE_|GV1PR08MB10751:EE_
X-MS-Office365-Filtering-Correlation-Id: ee0184f9-c4d6-4dd7-78c8-08de3f199f61
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?/Xo0umoRYnN7RadRbO+5GeNigEO6GZuxMFAR6DhAoAxCAXgbtkw/Dro9xM?=
 =?iso-8859-1?Q?XLpR1p4Vd4BDPgIdxTIN+MPeOD9/EHjYAHjrfcjDJlpaEDmK/D9uSu3o3X?=
 =?iso-8859-1?Q?f3CpgK4pho+SyoAFYK1RR+A7BPjiaEOPa3/56qO5h4oF6t7Q/AVVoCecVa?=
 =?iso-8859-1?Q?IMnlTye+rZ0w5/vMwWe39d1jSzb2SxQZ8NzSBn2WaUR2eK2Cw1dOAy0a+P?=
 =?iso-8859-1?Q?E/UUsNdlCg+NOuinb6VdfBPHt+utcvJjJ/ZwpgQuesKt6/pM3cZQvr03Vp?=
 =?iso-8859-1?Q?lyBR4EUP10hD5SkVjdPZZ9LxhW7fKJrXWUyyaA+As38TwmG6aMCa/SjzQc?=
 =?iso-8859-1?Q?P4hgBbQ2uRybM8DO69fu/9v89ce3vWxQ/eZHo7Reyh7M2xZbrwoUSZ/vOs?=
 =?iso-8859-1?Q?W+PpD06tewgY916X/kpvqnV2nkCIjAuxfihW433dyW9dCgU0uDKx91bxEm?=
 =?iso-8859-1?Q?8yZ8PhiH2r032ly0Xl/Vn5l1yWMGfzqrRTmEM2CFoWczU3E1VrTDb74eVv?=
 =?iso-8859-1?Q?bsJaEBHZSvEeDYVD1HsHiuY//A0Tf0EUX/arN2k7ZNlOGvrCm+usyfZQ2k?=
 =?iso-8859-1?Q?Wu7ANknXA2EAEwgHq6x619ZIM9Xjq7/2teLEjVAyShStq2eSRUXJSPy+H4?=
 =?iso-8859-1?Q?Gn+abus5f3kCKZGBnGBxZkvCnxrItUaOjSIDAV9BG3NNqO6lifJqA4G7hc?=
 =?iso-8859-1?Q?8/CzyhfkoqgILpDEAVC4/OyJ5pxe3h/fOtF5sIL84ccWQQTzVeri6rM6PD?=
 =?iso-8859-1?Q?WYu5KcM19/XtEgFWP3ZtlfEBLXQOEO1/RvDRGOrPjO6RpJE7zHt9O7TUre?=
 =?iso-8859-1?Q?KjfDpx3ywWZhfEuK6GczO1CTOHkPy3DlWJZ77KHdnfE6zcTjhgQ9Zb4HXU?=
 =?iso-8859-1?Q?Nc0IV0zGmcZHAT0J9C+XpogLi3mhwEB7so1/tNQXCwtaUD1wF6d1dPoX3D?=
 =?iso-8859-1?Q?8rsnkUwbGnupjyNV648DR6yDEtf7G2K+r+WjMiHUS+5ms4SfDg6T0ZZjB3?=
 =?iso-8859-1?Q?UN3IzO7aLagTSfXN2F5495MsZJAn5sikkTQ4th1BoSZc/okbKPdTA5cqXW?=
 =?iso-8859-1?Q?ouWrZSB15etZPZWWfnWwR972YyAWqgtKXQro4x0pbLffot8cLbu/Mp2ubP?=
 =?iso-8859-1?Q?pQdihtCftgZs8AR8ru9UhCIKrfKO1IIXgK2OUE8rUnrdv/IGq4iyOpDX5w?=
 =?iso-8859-1?Q?kRYUADuCsE9gURWiIvdl6KOB38XRB3nEuxKrcubVWMPu92Td9wO06VHgsZ?=
 =?iso-8859-1?Q?XusuTRyarNznok7yzXZWoui5O7a6LQtEFa6mgDLSobLWyMTFDl22JJvVLV?=
 =?iso-8859-1?Q?3cbImtdz7Nk3ICy8EY22vN67/2QVmekXIl4JmDBqTw4UXwBTn9U2mmKWN8?=
 =?iso-8859-1?Q?tE6NXc7UlJQkZNuq4NpJU6Sa3Lqh9KMCYS+q1iz1Wolrmuh5NFT90UNnl2?=
 =?iso-8859-1?Q?j7QLalUI25tZkU0/E1VoGimkTsgy3w3tU+gWOE8ZYa0gyrraEx42DjtS6t?=
 =?iso-8859-1?Q?zEjqEGrLeSUbPIs9FkkVazPL3bSVQRb0QH9Il80hscpOt1yYHKGr14FdC4?=
 =?iso-8859-1?Q?o3UYRahNdH+APyKEVrlWrKNlz07b6dPQ+nKqPQ8d0bsO5YTBgA=3D=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10452
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	708280a3-d938-45c7-a603-08de3f197739
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?SQ1tcANM9A15sXYHK0+cixo43I/VHJ1NzxzaNtxVsBTT+IhqLL59Oao/Me?=
 =?iso-8859-1?Q?PYSmIdTB5BCPP3pyHwA2RvwV2q6ekWlfmtAqhH/KRlY065gMp1MzGLI9Oe?=
 =?iso-8859-1?Q?xGy924+rrUKrejewZlnC/gKWDf64HiiB6e+NJYjKZzhHoMJH9mLn8JafJT?=
 =?iso-8859-1?Q?iLXpHkaw6bPvMtCkJogXQasDbQZob9+BEMxfMcstuaXfj38A3CBv9J98Kk?=
 =?iso-8859-1?Q?G0IJ/FC2UO+rw7bm+q2ke1+ZxyIdyHqMg76Rpr8guhfmXM7mv04+tJA+4M?=
 =?iso-8859-1?Q?vA84ekzaL6vPercY455kr3k1PZqEL3Q5KZU2z9zYy5YOB2URzLpiiaMER5?=
 =?iso-8859-1?Q?CYdu8OEoWFYqHc/1bhR7qGZKcrPIz0fJZtaqcu0ux/yLcFkPYF9oNzDBTh?=
 =?iso-8859-1?Q?EAeUJ6tWBRGHj6mEVO5C1E16/JKukh5Bcqx9xsO8XbWpsvjPFTcqX030VR?=
 =?iso-8859-1?Q?WyJzfgWfd2Bichu/Ny9vbC36RM106e7fvojVm+xC5ImPh1H7nXtHvQhBfB?=
 =?iso-8859-1?Q?pntS1Z/69MByzL4BlWbRW9MS2DURchVI/YbcOigtCtAFGMuXoDbzMugUTR?=
 =?iso-8859-1?Q?tsN4b2bxASPU98uFZ+AMdX61Ol6iq2Qk6a85Z8sY9bdelSKviZSZamASOE?=
 =?iso-8859-1?Q?oCtNK5O58t9IoONUzBoxIRCyZpKcJ01zVzdGO89Z6NZr7KdAZOF9YaWDya?=
 =?iso-8859-1?Q?xEn+nYzfy+SjGzDiCOs3C+/3dsR0R71RmTSEusvA7lbLvRUK2vRDgfdK55?=
 =?iso-8859-1?Q?0XnUCGQ8NwuAGCjz6ORmYtYoeThieg9QPiPa6/is8NdPNtv1YyqSYNG6Gl?=
 =?iso-8859-1?Q?TCnc0uI7EL3al/Mjtb9bSiLPeQTLKt1KXiv8DGJaqMkpvWq3mWNDIFePhv?=
 =?iso-8859-1?Q?K7bXBxT0zl9qdCmA1ULDeXW9iKZRnNokCyTBrbOAlBXrKJclJ2M1rpKghv?=
 =?iso-8859-1?Q?P4qW6mfhZ/+HyOwTbYwjx5DZwxK7HM8SALmgZfFuFLyKyiiR7cLQ0+J6AE?=
 =?iso-8859-1?Q?UbeYj+cv9ZoKDVyw3GZqf2DIRFsBGk6+1GYjT7y5X2YWQ6/3boZ5hjTZXJ?=
 =?iso-8859-1?Q?3XmSTFZsItfQG+Ttmf6YCLb9waeMN1J96Ue1gS3g/jU5afP/6HcxSBAf8S?=
 =?iso-8859-1?Q?x7LZAKczVj48b25DM5dnDmm0vOAbt+mTs6tQqFnXZ5D6+5bR0AUwQGzIzn?=
 =?iso-8859-1?Q?CzP258gT4tbs7zJmfTiIE1OYP+IGuYzKVjmvoins0M3ORQtmY7YhgnNeZw?=
 =?iso-8859-1?Q?SC1zN8CrsXYl8JtrDvirkt+KWb8WIW8VBV/tUegD7y+n6M0vgO4+zcNXOi?=
 =?iso-8859-1?Q?mt1G+5CKBcx2Bv3Ani0YeGxkJT5QSgffXEtxhAC4Z/gXlQViVV5haJw7FF?=
 =?iso-8859-1?Q?ZrZ+7Ak0SfzDaUaEp0hK6EOKT6UpRmHxGDlA3Ux8ESm3AzOfcFacYM60Wh?=
 =?iso-8859-1?Q?9UT8V1g/c1wfVv2SI9z0rJFGnoiavAahCZyBe+ruCpRTEPWQ/JyVul66IC?=
 =?iso-8859-1?Q?uoMunD/EfHfgV0aG3qg32bTz8bItf97hqbZwyJqh4xBoUPgGmYn2JRO8Z7?=
 =?iso-8859-1?Q?JHm6vwxN2xuiZ2wZW6kDekN4atL3CimtmlOp7ihSPZFknxJM2SaACSPp2V?=
 =?iso-8859-1?Q?ebJoTFBGtpFVJLwJrw3uYTxKA71VHdPLjk?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:01.2909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0184f9-c4d6-4dd7-78c8-08de3f199f61
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0A.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10751

This series adds support for GICv5-based guests. The GICv5
specification can be found at [1]. There are initial, under-reiew
Linux KVM patches at [2]. These add support for PPIs, only. Future
patch series will add support for the GICv5 IRS and ITS, as well as
SPIs and LPIs. Marc has very kindly agreed to host the full *WIP* set
of GICv5 KVM patches which can be found at [3].

These kvmtool changes add two new --irqchip parameters: gicv5 and
gicv5-its. The former creates a virtual GICv5 with emulated IRS, while
the latter creates a virtual GICv5 with emulated IRS and
ITS. Therefore, as with the GICv3 irqchip variants, the latter
supports MSIs while the former does not.

The GICv5 support for kvmtool has been staged such that the initial
changes just support PPIs (and go hand-in-hand with those currently
under review at [2]). As of "arm64: Update timer FDT for GICv5" the
support is sufficient to run small tests with the arch timer or
PMU.

Subsequent patches add support for the IRS and ITS. IRS support is
available from "arm64: Bump PCI FDT code for GICv5", and the ITS
support is available with the last change in the series. These can be
used with the full set of WIP patches at [3]. All have been tested
using an Arm FVP. Instructions for getting up and running can be found
at [4] (note, that one needs the 11.30 release for GICv5 virt
support).

NOTE: The currently under-review GICv5 KVM support doesn't include
setting the IRS address. The kvmtool IRS support does set this
address. Therefore, it is not possible to use this full set of kvmtool
changes with the under-review changes at [2]. This is an artifact of
the staged posting for the GICv5 KVM support.

This series is based on the Nested Virtualisation series at [5]. While
GICv5 the KVM implementation doesn't support NV at this point, I
wanted to be sure that I didn't break NV through the GICv5 additions,
and therefore it was very valuable for me to test with these changes.

Thanks in advance for any comments,
Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/l=
og/?h=3Dkvm-arm64/gicv5-full
[4] https://linaro.atlassian.net/wiki/x/CQAF-wY
[5] https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm=
.com/

Sascha Bischoff (17):
  Sync kernel UAPI headers with v6.19-rc1 with WIP KVM GICv5 PPI support
  arm64: Add basic support for creating a VM with GICv5
  arm64: Introduce GICv5 FDT IRQ types
  arm64: Generate main GICv5 FDT node
  arm64: Update PMU IRQ/FDT code for GICv5
  arm64: Update timer FDT for GICv5
  irq: Add interface to override default irq offset
  arm64: Add phandle for CPUs
  arm64: Simplify GIC type checks by adding gic__is_v5()
  Sync kernel headers to add WIP GICv5 IRS and ITS support in KVM
  arm64: Add GICv5 IRS support
  arm64: Generate FDT nodes for GICv5's IRS
  arm64: Update generic FDT interrupt desc generator for GICv5
  arm64: Bump PCI FDT code for GICv5
  arm64: Introduce gicv5-its irqchip
  arm64: Add GICv5 ITS node to FDT
  arm64: Update PCI FDT generation for GICv5 ITS MSIs

 arm64/arm-cpu.c              |   3 +-
 arm64/fdt.c                  |  22 ++++-
 arm64/gic.c                  | 184 ++++++++++++++++++++++++++++++++---
 arm64/include/asm/kvm.h      |  12 ++-
 arm64/include/kvm/fdt-arch.h |   2 +
 arm64/include/kvm/gic.h      |  12 ++-
 arm64/include/kvm/kvm-arch.h |  30 ++++++
 arm64/pci.c                  |  16 ++-
 arm64/pmu.c                  |  19 ++--
 arm64/timer.c                |  14 ++-
 include/kvm/irq.h            |   1 +
 include/linux/kvm.h          |  20 ++++
 include/linux/virtio_ids.h   |   1 +
 include/linux/virtio_net.h   |  36 ++++++-
 include/linux/virtio_pci.h   |   2 +-
 irq.c                        |  16 ++-
 powerpc/include/asm/kvm.h    |  13 ---
 riscv/include/asm/kvm.h      |  27 ++++-
 x86/include/asm/kvm.h        |  35 +++++++
 19 files changed, 415 insertions(+), 50 deletions(-)

--=20
2.34.1

