Return-Path: <kvm+bounces-67599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF94D0B839
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:07:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9F0743026DC5
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA35A366DC5;
	Fri,  9 Jan 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qzpqdNjy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qzpqdNjy"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23DF364EB2
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978355; cv=fail; b=lpiZCTTyH2nK3awgvGKu7QCvaBYgzHz34/vaX9gM+msx2u02T1P+MS/21EJ7bwwvJh/lyhUeELq12D/B4DHbRi5zFHmRDA4mgXj299AbZgB2CH66QLCF/C5PU2cz0A7MLsOSUlxUEzyjLVyGkKA7CtpLYKgi6TCiQ3Gnix4upqI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978355; c=relaxed/simple;
	bh=X+IydvKflndKqZo0hqtewUQ+XPA+PU62djCWSEXbGnQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BNVmWestYfhM9vqEkT+cuXzN6t+ExG8TIORVBoTwFAzkbBea+h0xNIfnR3RiwDVirXGaY9DEecnhYQhGXquRIFPyGcZ8kmJfXsi3GyMbd60T0snNENepM9IVR3/LFKS0bdYyTq4LSH+lGrWWM9AbWZGNF8KRJXzIbkGOj4PKLq0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qzpqdNjy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qzpqdNjy; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=uA7d9SEFPZ9HuFrWOOK0d18M+yFVZ68/b8WASWswmwN1vg7f+3ywN/Kt/A3PQEwjZTTSiHD1adRv+w1jyGSmlfzk4tpY+I3VsuQ5OnYEeysbnTd7R2S1DtB85tvJUuAwPG0oDX44Rg1C1PUVskVGtBztb7WU/kAxtSfb4OBIIrisnEzRTXD8mXlGg+hTNjv4EalZakL92vUXoZ1aizqHE5H5+9F2abY7hofXVch91UOkFQY1IBkXQKvQI0gJOGT48VlREb2+lSQHpFyGiCktpF2ziPiJwFVKziZKO7Ljwx0jtGVIj2JX1e48Jz8HTzvDqZCBvOtoYpopBYPIFxfSow==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pILwjqiJFvnt5GBmWmqjXBylv3KBZ/bQC/WLIgtCYTI=;
 b=vKoMX/Ci9DM2IrSr4h2VNKpRMhTdmridf+DfNwOOQVqc15QfWREhV//rkzbfkza4PqmUXJJlMiAmxcKJQGdNpJJLWP4ncrFj5T6TZTAm4z6mYPJJod/g/0GFbsyCf4o8e826jHUp4ZpGHdUTwnkOsyF2vrFvWMgiEWTymFvehqg6p4yc7dN6zSN2NrjvIeNDMpeFnxO52zX90ASipbJeMTWZxLBMg07Ke68YxViZE9QecT/bBrCdol2PmHWYXXbXF2j4O+TY6cClGUlTebcGEtkOWMYz1Mhn+a9HxqZaLh/Z0YfMnJd79uHQenbQJ1GLCGlY6TxwGSbxIzbTmmC/uA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pILwjqiJFvnt5GBmWmqjXBylv3KBZ/bQC/WLIgtCYTI=;
 b=qzpqdNjydT+aax4zCwOxYhBV9v82lJ/vtAyh2g71NaPnt1LQLrs8xLFAvHziO/0XS6TbBScEhh8cZziU54cgKU0XPi/6Mv5mU8ErPgGw6jgkHAgKgErVSSU85vLH/bGd5NqPfnV8/hjLFT/ydKWYnHMhQ9pAt58pWaImtWkmuCE=
Received: from DU2PR04CA0212.eurprd04.prod.outlook.com (2603:10a6:10:2b1::7)
 by GV1PR08MB11147.eurprd08.prod.outlook.com (2603:10a6:150:1ec::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:47 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::e3) by DU2PR04CA0212.outlook.office365.com
 (2603:10a6:10:2b1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McjtOaP9/UUfIbGAMWfHzPxwGfsPXjES1hOxceeEicT2+PFnHvmB/tEpXUYxZtE4d/+dVpmFWjHEOAYdla53P6VIWRfyGxjIyfpXpZ+10oyeUGmttFXqrnpEOiSDDduS0W9Ve2tJTZedD1g1yAZ4hb/t3Qh746iCiNlO5zFXWaT63PY3IyLFg+BIihv088nS65cW4MSGDs+szKRF5e9/WVP1zsyuamzFY/0t9MD3O9LDz0jvVl43aGr2HIABzOolVbTyJfIgGg9IXwP9FTDtLUnHxyyPBlJnLu3sz8jWXTRWYKtQ70Ib+26cmD5VgeTVDUps3ITOZE2gATNmyMvNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pILwjqiJFvnt5GBmWmqjXBylv3KBZ/bQC/WLIgtCYTI=;
 b=OFYKjO5XGEDabfqhG8R/LVyR4UzoMeWFBrA95GDxxsaQjfRQ4Lr7QngNgIYs/TGJAciGIS0/tIkfaeI2RMae+rWKlcg0+jKNBqUbNnevkz9lLPaK5JugPu1qow7ARUD3BiVII7oWuFiYbUG0/VXLSNadiqF+KSGbcBf4WkFRCm1ZR8Xey2vgBSiiCXVLahSgdqpkivioTm0hSZfJ/wcuWeQkp067BPd3Xn8sMgMpDkWGDwDma3407XBD9bOUOAZqn51+Pnkxrau6UBs2ZRveG/3Ikrptz7+C8Jb4RJ41PTkNm1SCfLl5jsThlk4IloiuS+diX7/WI/17255T2gzDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pILwjqiJFvnt5GBmWmqjXBylv3KBZ/bQC/WLIgtCYTI=;
 b=qzpqdNjydT+aax4zCwOxYhBV9v82lJ/vtAyh2g71NaPnt1LQLrs8xLFAvHziO/0XS6TbBScEhh8cZziU54cgKU0XPi/6Mv5mU8ErPgGw6jgkHAgKgErVSSU85vLH/bGd5NqPfnV8/hjLFT/ydKWYnHMhQ9pAt58pWaImtWkmuCE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:43 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:43 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 13/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v3 13/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHcgYoMMU7WshXBlkG5YvCRh2selg==
Date: Fri, 9 Jan 2026 17:04:43 +0000
Message-ID: <20260109170400.1585048-14-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DB5PEPF00014B8B:EE_|GV1PR08MB11147:EE_
X-MS-Office365-Filtering-Correlation-Id: 8174d465-0b2c-4cc0-efd9-08de4fa1554d
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ltoQA7ex2fBNFOnCWNrwhCsm01v9ERijnUYmwt+rsKbHWWzYm3eAVUh5U3?=
 =?iso-8859-1?Q?uaQdaW3iA1SvGn6b2klCNUhXkTI8TM6FbZixYtB+vG5oF1dblaaI30JAQm?=
 =?iso-8859-1?Q?czwVccCAXABrbCLpyjrdCfv0HwXM35LcLB2V/bvm4mItAC4au1yADK7i6a?=
 =?iso-8859-1?Q?E8N/zKwuBys+xaNwGTpFGK8cWLitDe+QlvZEucdtn3fTCLcQ7YFDanqTE1?=
 =?iso-8859-1?Q?1pCDcQkm9z/SgCQ3F1abJN85eRUGqRXVp6AkoqMA9l26cwyAJHjBuvEs+Y?=
 =?iso-8859-1?Q?iTDX/Cz91GZUeqoNWVO+EqgEcxZ0ehwbZRvwk2ViEqUiPcDyhUysrGEXod?=
 =?iso-8859-1?Q?oOoGL535LcGbNX+x2blQ4j/HBWQFSbarIZPjm46R2Zzk9/oKmmd5GZdFen?=
 =?iso-8859-1?Q?KNI+LEimLt3xOWEvzoX8nRAmD7DFZ7/jksO8Ply7oiqYksbr3iUOofievT?=
 =?iso-8859-1?Q?FYNP2Re5IkHjEES9FMeNyQu6ZsD1cpx5vCvtGp3X4BKVvuojBfele57pyy?=
 =?iso-8859-1?Q?RhnUzIT0Fld/qJnqHH4yYsDxfKQ3EFncT2+fjyq+3xFqtGaZCfdvSvk4pX?=
 =?iso-8859-1?Q?sbqUqSBurWvGFvzvYnrwO9+xaBJ2DL3Oh2MbtcWRLzg4LKs3O0e86qbqQq?=
 =?iso-8859-1?Q?vycYTJZ/kMfc9wqpxdeYGLjjYMnGm9PdZCYJkG9LdMgzKvE8wgnznGcE3j?=
 =?iso-8859-1?Q?6BcPqafSExV0T9ITuV8nEv7229xGNLppV/20xrNXUJJG1H1+I0TzHVYrox?=
 =?iso-8859-1?Q?U/goUQ1Fi9LKCC8k5zNEt4+DquzOi77DoPPmFnEPg+2gU/FcmjyXfSU1Nn?=
 =?iso-8859-1?Q?QpUtImGCBcjngv7g9Xmhdiwnv/R5cXVCXVupldQGL6lccom9ryW3FnSIcP?=
 =?iso-8859-1?Q?hdKBMR3saox5fne9+1LgSb5E30+MpubVGzNfC3DjEjltf+osqTpY8y/2b4?=
 =?iso-8859-1?Q?d0poue68rGIiKEt2lVbCc3dMM9q5aaQtaS24roqoGsMsCf05sx5qqSC6wg?=
 =?iso-8859-1?Q?X+GMFHLKLIuSZ+xgXuZRldqZbzyqijPOyNukYiJ0GV3hVgrzP36pZVSgTA?=
 =?iso-8859-1?Q?W2T0vXD+zlKqwDemA/2rhELusbvq0h2B+vToKBSoNsPv9MtAmbohBGkqM5?=
 =?iso-8859-1?Q?4ppIFvwcW7QIJqQiuCR8IMQNDtZxD9+iCV2+dnnUKDASkCvyj0R/LNTXSF?=
 =?iso-8859-1?Q?PHURZEYzNEX9wlPFrFlPI6fSmCpfsX3eKsZqbOJpzpd47X+xVLpKXzGLGi?=
 =?iso-8859-1?Q?G/VWJC/sJBLlq7Hc5moLhEY2U/VTCx6/jXFct9jdxsaMMj+pCLTdg6vUlx?=
 =?iso-8859-1?Q?LaED0p1FIJKfJCWlhfXvJLEBMgl8Sivfqr3e6Mb7baOeYG83sIzfcFZC5M?=
 =?iso-8859-1?Q?85kRefbeTqLaZcCF8JiL3Gxblq45XdTF/ISS1flfRHGU1MNEHlRBfNPU4P?=
 =?iso-8859-1?Q?mgqW5uDPZdHlcROauB5rtBppdF+0QiVTBVeFrw4HG0pRBC2xEyDLP9mg4m?=
 =?iso-8859-1?Q?hoGO/gO3iB9yTBNhKTO07JiFLr0Np41dOTeZppjczSU6Z8eYG4ANx5k65W?=
 =?iso-8859-1?Q?feueXVtDOiqO87On/Bm5IbShJYlv?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5abf2f87-a69d-4cf2-5078-08de4fa12f32
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|14060799003|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Fwjr7d0cn2tf4Xs7Pi2eJ4huCr/m2CuRyXTvQob8Q2HeMZnpzLC3+abhji?=
 =?iso-8859-1?Q?erg8OKOOWXtZYb+QeG+IH/qbr9eUFiLsV871971k+QLaHGnuGppNF9X/VX?=
 =?iso-8859-1?Q?7aMBl2/y38+OqNfpCQ1tuZfUKe7sUZBlY+Hh3si/8NCVH0ttczQPQFQ4z8?=
 =?iso-8859-1?Q?G6LoDLDg0lYlXivF5PuqhPy0DcQ13EeSxTn02KSqNqYjARq/HBRdzDQWo/?=
 =?iso-8859-1?Q?SVOJ3OxH+L6Ivbk1fU1Oboe6WNvW4vUnziwXKjLiNp8iG0clylmVuddqnr?=
 =?iso-8859-1?Q?fvkDxLT6eJactT/U6H/0HQaRJz5idYNulzfqWnXrWrs9guHYjZL3X/PegI?=
 =?iso-8859-1?Q?0sZRLXh3zsrMrZVk5VjTVOsmYsaKV4qUNQvJnW+3hj7dw0Fp1I3VyhRLig?=
 =?iso-8859-1?Q?25fPeuGzp4nrdHiM/X/Uz+lrKsr4r3/B30W7zv3HuBNnw3hGxmtLegLC2A?=
 =?iso-8859-1?Q?L8imkNENt6yUqbGsIU2CnFMGkx50ueWxyrr1LHhgFN3yTfZqwymb+PYZyt?=
 =?iso-8859-1?Q?Qe8LMfu0jSNCo3orYGK/nQdO/KjoxOBUdUlbpN86zbeDR0g5vECbnLel72?=
 =?iso-8859-1?Q?qjuTwU2ela1DAD5XXdIUzXqegigBBOcTVKE8LWZD5cKRkB4jhC24yA2SNc?=
 =?iso-8859-1?Q?T/HQtauhRBTmCSBMyyBVTKunb7nFL6UkdVCAIbv82Bt6dK9ZACd9ze6RuT?=
 =?iso-8859-1?Q?gsy4EgelcYKWvhr3T5wffg5m84mguurIDA/+0YlbT7lDt6VBTTMKTOTDlJ?=
 =?iso-8859-1?Q?Kr4zGZ2EfaN7BIjcYUMxhmihd9mMEFCRsiVm/9LJkBPK0nHOeAObw8V5IP?=
 =?iso-8859-1?Q?gukNLsp/VUAe8wYl0mmgHXElo4NsSbA++jJ6/6bafVoD3IyYB0LVCneV3f?=
 =?iso-8859-1?Q?djyVS+aJSOs78K9ZO7gbwBBd2EJYtN3oAU1fNbWVQsj2seC5HGpiAG559u?=
 =?iso-8859-1?Q?vWXeoliUVoRIWVwYTMhvZqoPduUUBtNE9BN7nWBkzARieDO0i72H4Goffm?=
 =?iso-8859-1?Q?jLlO8QOTr/XBvl09bsfbrUbg3tWZaMNXMSKJSBeCoUlf209PxidMkb/xh3?=
 =?iso-8859-1?Q?TShoYRzMNx1/lfCtf2hTn6aEEDxXjtWdQXv01w142G+7qEYTdZKFwy58tp?=
 =?iso-8859-1?Q?bC4Yc+qxHuRNxPAVgkTLOAs6AwCzSwdilECV4BpCbaSdGDz37qkuq9gYhZ?=
 =?iso-8859-1?Q?hUG1/74jCT/PogyTK6IDD6O9lt+j49rxvw7OfEo7QjklWRW2k5wMUdSOXx?=
 =?iso-8859-1?Q?f4/9d2HFpzIw4H3FFuHw9s/jI4SK9Y6tmUIYtTq9uw85xVBUlxohuNLgqp?=
 =?iso-8859-1?Q?mqK5+M9PsPetR1XXnnyGGZDA86HKN/lkCrmZSR94ZUy/CwhVhX6QAQpfm2?=
 =?iso-8859-1?Q?AWyJFZ8p30ssLC5ICc+EZzRGBg/McJFoErGwVKe8Kc+/YntL9QKaMKKCvd?=
 =?iso-8859-1?Q?DPvKMVhZNKyE8zDcnpjuHmigfLHuMGr1bd1ykAuR1tCHTNZDDyZcc7KRkI?=
 =?iso-8859-1?Q?Ycbn7eY3EZuHc0M9O2aDKneAQftLNRbN3nyZintuRz1EoX4kgxyOV2DbTy?=
 =?iso-8859-1?Q?4VYQRl1nJWjm/smmX8m/E7nZBdAQpCV1fSwKQpGH9fW/MIyRv9cQrIVxDD?=
 =?iso-8859-1?Q?+ceUuonuJhJqU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(14060799003)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:47.1710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8174d465-0b2c-4cc0-efd9-08de4fa1554d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB11147

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6e8ec127c0cea..79e8d6e3b5f8e 100644
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
@@ -1603,7 +1611,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	}
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_ich_hfgrtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 41699042a445e..eecfb5f2db79e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
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
@@ -3414,6 +3429,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
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

