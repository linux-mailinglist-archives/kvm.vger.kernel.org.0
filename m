Return-Path: <kvm+bounces-67601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD57D0B8BA
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25498303E671
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B44368282;
	Fri,  9 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NhZerS93";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NhZerS93"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010048.outbound.protection.outlook.com [52.101.69.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B894366566
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=LzDQsUwpTBqi+vh6Y7jT3zCtvYXKavk9WjRko1fXTorD5Z8DuEXwHnZm7o7sdHaUKdZS4ug6/+jw3ceaK2/TvGXJ1sbzgGFvCK1Mb3qRF7hWqj/51Q8v22sm9d5LO8a7eDreSjwi9FG9ZzTlqImOu5vl/kdEiZLSbOHi1zGs0wA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=afJYTQsFMKosy0NyKJc2sqLVO4mb74hiNAJJ01wuksg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GIwCH/ScggJPCQ2P3EYtf4E+fip4fwavOkpranvy7HeqKqkIj29iXMGcwMEKItDnLzFUNUpG6VrbiUkLSmwQNZbJbDyd4y2MWTIGPvilO9vPc2KgBnrTsu4C8u3o+SdxmbcfcDSvjt/Wcs4qfIsreVTcNzppAq9n16lUxisWEpg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NhZerS93; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NhZerS93; arc=fail smtp.client-ip=52.101.69.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YwPJIm1PhaMz38kbErChOTG95daHmhJMYEiC3qBmR59YaiPSnL0+BJcAmA7V1i+VhtAfxl7oHtb9MiqVC6DPJ0p0Raiuc/ERkjBr178fB6XpxbMMVZ3CxvtYWSkrL8KqCAsPlFBm7FGtSBl0WJGSaSHEqGFZHnr3Sv3AX2pYfQUgWAGdb2zHiWXdSaOCQTj3eFYYIiOiktXAA0rMUMtaTudRZZzwuQVNk+fBKPjARLPbAXsFCSnsXUzPKwTTgEFPllTFRNK4k3is0UkOsAQZjBjQcGrOI5mlkEhDz9NNOHgWo8HauM9g58d86p1RJeNAn6gSFL6cRztYcmgOMhxE4g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnlnQkPJw2U2PK1wguJTBwuQbUIXnLJX3pkqOTRiwCw=;
 b=seOkZwUL/B/Lc95nR8mfrBeRU1ohXQ3+FmrCM6veXtSSJyUbHfRGzUOE23uxonMPv2FegKn+LfxjJqsMK9j9rarPwUtywvhEDH87gBHQZKavJxcOuQWGNqHReOT716Ncsa/h66pveHW0uqb6GV65R2nzWiXBraGfUYRsFYfchsjNS9Axi0p1NcdnBk4gdzvlzG9LyHY0EKlO0/nHNprQKPM1HZzoaS6QXE3n1vk+uZ+nhk7X4+MxjtAELzoNYg0KeVOGoSjxJkioKNxMsY5jSxvh63Aa4JuDmttnT3YQvHw6OY8AUuinGfR6OS3Ci/3If5bSJPhQUlI7VR9ZPRvyLA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnlnQkPJw2U2PK1wguJTBwuQbUIXnLJX3pkqOTRiwCw=;
 b=NhZerS93Qdj1pBONqwpowpQ2LRGQ64iPsqKSKGjQsZ15VYM0TtL1NcPxNUuT8Smvwk7ROXIEsk6d2qs3MlESFXqSXC5IO2bLKzSwclbNfxg9RdMKXeFqQ5sENsvssP6S8d2p1TzywRNotfkEr/k654geAlGTpbUljS5kKniNEt4=
Received: from DUZPR01CA0149.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::25) by GVXPR08MB10763.eurprd08.prod.outlook.com
 (2603:10a6:150:15c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:47 +0000
Received: from DB1PEPF0003922D.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::a4) by DUZPR01CA0149.outlook.office365.com
 (2603:10a6:10:4bd::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922D.mail.protection.outlook.com (10.167.8.100) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HDmNnPISbaK9V/dzxs1jlenFEw3n1k4g4icSzfVgwpdLtQWOx2Dz/9/K/50nxSnwVzEi7XcAOXMT9TpCb45hGMqGQwVHd5ZyDvxURrchtsHVdINkLdpqMmAfSfq0SDItlE63QaVR4RV2XSg4BfPSzkTHuqai34QNVEZ/Rx+bBzrz3VEoLbZFkLQUrwJcvhuzD2nPbm+XrT8seTktLoVpiljgqeg+btyxNXpAr9PoQiOm7gKj87x3PIqFVR7KMqqYw2++6Q8eauD8qTN//z7nvxiuf1bWgOnAEKBQQC4pP9hHoOQGV1bK/ovj3M2QspgoPDyXiSDodduaMpMfEMpygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnlnQkPJw2U2PK1wguJTBwuQbUIXnLJX3pkqOTRiwCw=;
 b=MnWCt1zoiVuocVnFsONDPQ+vtjYRNBIf5FbYlIG461S9nxSkARYj3BkXR8lv5A1ygZCvWnd+ofCokEu9y8OHn3WJMlDJqe1J8sZpXv9DuiHd9e6SRFy2yMXxOk3DZSc+TMb6NojuZO/WyrQDKizX0gOM/Ivo7LGAUiJHLo0w4GA48fBkcEXyRVwaLgVWaKVdQedImLBXFV81orbBtfhNWvBPHWGqsuuH1XBL7So+cbdkrD6lnbvM+O0MDOPHWgU5EQ6kEYi/55b9jl4viJgEP7M0Gm5NKTEDZ5vkGywRqQIW7Zk2XxPg5kMBW2Wpvxwmxl2wYiaMETbhi+g+iiysJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UnlnQkPJw2U2PK1wguJTBwuQbUIXnLJX3pkqOTRiwCw=;
 b=NhZerS93Qdj1pBONqwpowpQ2LRGQ64iPsqKSKGjQsZ15VYM0TtL1NcPxNUuT8Smvwk7ROXIEsk6d2qs3MlESFXqSXC5IO2bLKzSwclbNfxg9RdMKXeFqQ5sENsvssP6S8d2p1TzywRNotfkEr/k654geAlGTpbUljS5kKniNEt4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:45 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:45 +0000
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
Subject: [PATCH v3 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v3 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHcgYoMkOvoP9U3PEabPfMRsSCfmQ==
Date: Fri, 9 Jan 2026 17:04:43 +0000
Message-ID: <20260109170400.1585048-15-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|DB1PEPF0003922D:EE_|GVXPR08MB10763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9c3efb-1429-4fdd-9f57-08de4fa15585
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?aKoJxTEcCG5tA95pgc/9+4FdEsqwTsEnXwWvZzSQ9zoegQBU5vZF81Idqs?=
 =?iso-8859-1?Q?BTZt3fnCrsJUrDGcIRAUW/o+0Ai1+BWUDl/hIvbaqrdhIm2kyvjM7BewgX?=
 =?iso-8859-1?Q?6olEVjfYhzjI4tmxxYUVueeWBg52ntbP+DnaQwkITsqD4Y8W53i3nu4oFo?=
 =?iso-8859-1?Q?hYceO/eRo5jbaf+kasJhFEA3rA5DpP6fl7Ee2Cem/ZW/UizrBHqPPZm9Zi?=
 =?iso-8859-1?Q?7Tdk/qoi5lx2wz8LlbFtE5PksWD0ofViuzezH41zdHew0uYN6Dq4BCA6wb?=
 =?iso-8859-1?Q?7povCcSE4LsqsPdVXq6E7o3flM3x/jAKK7q8bt0G654U7k9ocFcCB17qh0?=
 =?iso-8859-1?Q?XqztO1UrnYpKS/UzrpOyJBlwptNsIBmk/beHUYLbPpWXZtwPkoM7QKUQru?=
 =?iso-8859-1?Q?ENs/9gVZIwSk0yh7/zANMMBzUXNQfO/rd/Rvazo7yDo/rpcQ+Z0rvhawSG?=
 =?iso-8859-1?Q?af04hZ9s1bTCdqq5k++fU/dIf26I7fbxhZNlmZcRKqtpSEZYxsEUYXs1q5?=
 =?iso-8859-1?Q?9NlYm5HAFS5vcdl76S+EAZjCwh2ZhXzWCyhfxGlZh2YbHHEYjPyIeb9KkX?=
 =?iso-8859-1?Q?61I2NUy9/C8IlGKmmPsf9YYHKM/UFp8TSUcfPh6lbrZ1bwJLYSDZoblCBu?=
 =?iso-8859-1?Q?XCH+sHwklzKAub9UsoXteuVpX6tkJkcXKd55TQBYTEWjzlQE76FTrqV8z9?=
 =?iso-8859-1?Q?/aMSmt3gzSAej7zWWLh04cGMNrsp2+C2f3upYc/Y/65uZTiWa7+74KBBH4?=
 =?iso-8859-1?Q?XEL4ETE11ihoKbF5yOe31GXHpeqoFHIsxVqZH7x5iBqYBzCNTUwAlxWohv?=
 =?iso-8859-1?Q?keFpuhhya6pfOK9Nq+7Kwd1RfT5w8pp10XS7MBHVQTSL4mxW2fkZg8V8Bn?=
 =?iso-8859-1?Q?HPMUUWvRg86fDfrAx+dIydbrSVW3FRMIK5pZwQv52OIEftFYkENM+L58qC?=
 =?iso-8859-1?Q?8PpRGYQscqBRcH6Eizt0mp2ReOQIPo3gbOH0c8DOgMHN62e7ATfuwz8woO?=
 =?iso-8859-1?Q?UIG2todgU71sB0+zMOmuZq4RAsQRthpGW1ig+Q0veIMjpb0VGhpsDJ41/A?=
 =?iso-8859-1?Q?M9GV9j8FLZ0gtaHvaWb2tC1U5UWX4kdH6dgpVXcZSLoT6vIW7l5TQ1688F?=
 =?iso-8859-1?Q?aYUbePI0fXIW/JcmtOghinTmWcG9qZVDLTzIaf1DnuNKzq0urLUDwkYBeI?=
 =?iso-8859-1?Q?gfN7gPa9VZcdS79JwSyVLKN2To8X7CJk6vvu9K1F8zM0BZnK33SPKNtRiX?=
 =?iso-8859-1?Q?Xu83b+VicVxNmCa9gw2puoS2Oi+lSW2FjjM22bnEXa4/zGVa2FDyn56WlU?=
 =?iso-8859-1?Q?8a/XOWEf3vF4hQtRlFoYWa1P8zxgVtd3gBEw/oB7edKT1ECs0G1eRWNnxk?=
 =?iso-8859-1?Q?qhaGP8RdBDV4sXAubKGoVnF/lkW9t0++1DvcJCudiAHWDF1rkOWGMHKUMQ?=
 =?iso-8859-1?Q?SD3I/DmAsTNrQUler5HCJ31YQ4YzIZaJpkqacZtOuudh0zjQy8nby85dLR?=
 =?iso-8859-1?Q?XKbmc/kOnGEWWxaBuU4KzgESv9vR76432PBtlRkZjeTdbUBu1oz9uOc+Dn?=
 =?iso-8859-1?Q?cQdhRsPBHQ3qKGVqtxCwAv5b8G9d?=
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
 DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	02c738d8-efe1-4cc9-b7c4-08de4fa13042
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|35042699022|82310400026|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?3KmexLp+lp01Au1rsaoNcNykce6nfIviq8o6xhwrvlKrzvqamyWjzvGzqu?=
 =?iso-8859-1?Q?EuujCtG02Qw63kLMR4PWJYuhNcH78/2sXR+VV4avVU/7IvdvVsPBhFshw0?=
 =?iso-8859-1?Q?2jdTKZvlEfRZ2y5YvW0YHtNCysT5CXqJjNwwmTCFaOPht8yb7o0HtK+13i?=
 =?iso-8859-1?Q?cFvAR64NMmmtQzRWock1o6Di+5S9azdD7ccfA2g06G1xQ55MQhcMkJONLr?=
 =?iso-8859-1?Q?lIx8CfldUkYVjbiI2lnQAt8qYjJn32dYUFKNzLgHh75aUf4AO5pSUIdNjF?=
 =?iso-8859-1?Q?/jqsos9rzOGrCdRh3+1mm8Fu53PLyXIrfKpZTyHuYflLE/6CCIe3xwlHCy?=
 =?iso-8859-1?Q?7b5YAtsF+yKGsbkxpTAr2H/CDGm6khXELWY/WCHgaQR5dACfodGW+eNvMV?=
 =?iso-8859-1?Q?TGGqBGRFV1dk/9RFEbJe7x7k/n6gHZhhVwY6KTztR6GOmfGmNwBJVm8ZKy?=
 =?iso-8859-1?Q?oN6FVfM2HyDozT6awTNaUNe8mgNCIYvvRvSw+1xeAu37GvJiu6D9NU4lUX?=
 =?iso-8859-1?Q?z2CGYv0GzI54cBo+aEDruUsDO7xy4WJYgu5OUzE6OAyVtyiz3tT2tlPPXE?=
 =?iso-8859-1?Q?qR1rhqDpGjF2Rd4b4vDWFvq6Ek27iiyx9FdseLZoib6TOQTZvtLoi3uQRP?=
 =?iso-8859-1?Q?sbgIXncF9TbZxTXhFvFCCMJz/5AAsiopqTI/AiYkb/LW++Y/XfdQXeERQG?=
 =?iso-8859-1?Q?LWd7j60m0l69ki9r5ElAwnwOwUzEWHyOYZjzf+JjY3yknID2ntL/UE4GkL?=
 =?iso-8859-1?Q?hsHmDVCBeHCgRF4zV/5EMERRCK6661H/Pyq6561hYlOkbBgT3FvhVGxSaA?=
 =?iso-8859-1?Q?uQDwX/lYq07rRnonsiCF5k7xN/wtVJoj64k0S7PIppW0gDQ9Y1p0FLEiue?=
 =?iso-8859-1?Q?eMPoy4Nahr4vhWVo06eNzzxu3n185n5fbe5izfiNsoepGV4Qon7Fh+pFmZ?=
 =?iso-8859-1?Q?OxIiDZfl5lCC02AATM16gUyZ3G6ZPXDK0orqnRC/R2WQNXa/3wqNqIu5xY?=
 =?iso-8859-1?Q?MoqzNqQhSa7IYUijLbkeQjnGq53gG7DpYlhSzzgltyziBRdEu+jjIaOW6/?=
 =?iso-8859-1?Q?tHSVSMUAY99FTDI/I2vB6Lsd2qfEFAb+KjP3h8LT6vMX5XNw9cjFc37wAg?=
 =?iso-8859-1?Q?g2xhsfjkCNPIlPhFxN95jdcG4szP92qhqa2m+mEjzyDbtA5WmzjyJE2WmA?=
 =?iso-8859-1?Q?UcGzZFm4nBF3YHZSgB885i1hUG0wylx43ELr5MuHyDihfknswrwHhKtjWJ?=
 =?iso-8859-1?Q?TK2qrapzYS4wD8cOivCqKBikyaC5Cz24vX2BmtlZsrdINheZYtddqy9OA+?=
 =?iso-8859-1?Q?9qUmDN3ZPZEoS1YNdUpcGuclNfZUksTifSHHivM52BWcw9xkzqJMNmwb7q?=
 =?iso-8859-1?Q?nooB6WMgzQ8oDmJ8ZQCwJWzWpgiouqK+ZXtITWoIJgi13SSzCVGgcYwD76?=
 =?iso-8859-1?Q?/kLMydCC1r/p+T6kNLeyqx1ScX1K2tz3NavqiHUe8pzfRpa+UoYywTNoBP?=
 =?iso-8859-1?Q?VtNmbkziE4lUlxEK/AIUV6VYKBk5HY+alzNb+UUOR1EklDEvW00nq81k6f?=
 =?iso-8859-1?Q?VOTVo0mv4b99Ks8smSQ/AbiP++3gmRT45ex8jtPQlNcH3IDABxRfNlzasg?=
 =?iso-8859-1?Q?FyPi9LdjzQJ+o=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(35042699022)(82310400026)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:47.5142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9c3efb-1429-4fdd-9f57-08de4fa15585
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10763

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
state, with the exception of the active, pending, and enable
state. The pending state is saved and restored from kvm_host_data as
any changes here need to be tracked and propagated back to the
vgic_irq shadow structures (coming in a future commit). Therefore, an
entry and an exit copy is required. The active and enable state is
restored from the vgic_v5 CPUIF, but is saved to kvm_host_data. Again,
this needs to by synced back into the shadow data structures.

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
 arch/arm64/include/asm/kvm_host.h  |  16 ++++
 arch/arm64/include/asm/kvm_hyp.h   |   8 ++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  32 ++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 123 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile    |   2 +-
 include/kvm/arm_vgic.h             |  22 ++++++
 8 files changed, 207 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a1ad12c72ebf1..fe8d4adfc281d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_ppi_state,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_ppi_state,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 0e535ef50c231..b49820d05e6c5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -774,6 +774,22 @@ struct kvm_host_data {
 	/* Number of debug breakpoints/watchpoints for this CPU (minus 1) */
 	unsigned int debug_brps;
 	unsigned int debug_wrps;
+
+	/* PPI state tracking for GICv5-based guests */
+	struct {
+		/*
+		 * For tracking the PPI pending state, we need both
+		 * the entry state and exit state to correctly detect
+		 * edges as it is possible that an interrupt has been
+		 * injected in software in the interim.
+		 */
+		u64 pendr_entry[2];
+		u64 pendr_exit[2];
+
+		/* The saved state of the regs when leaving the guest */
+		u64 activer_exit[2];
+		u64 enabler_exit[2];
+	} vgic_v5_ppi_state;
 };
=20
 struct kvm_host_psci_config {
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 76ce2b94bd97e..3dcec1df87e9e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -87,6 +87,14 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
+/* GICv5 */
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index a244ec25f8c5b..84a3bf96def6b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y +=3D ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index a7c689152f686..4fd3ead96df9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -586,6 +586,34 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
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
+	HANDLE_FUNC(__vgic_v5_save_apr),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
+	HANDLE_FUNC(__vgic_v5_save_ppi_state),
+	HANDLE_FUNC(__vgic_v5_restore_ppi_state),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
new file mode 100644
index 0000000000000..47c71c53fcb10
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 - Arm Ltd
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <asm/kvm_hyp.h>
+
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
+}
+
+static void  __vgic_v5_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	__vgic_v5_compat_mode_disable();
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+	write_sysreg_s(cpu_if->vgic_apr, SYS_ICH_APR_EL2);
+}
+
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	host_data_ptr(vgic_v5_ppi_state)->activer_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->activer_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER1_EL2);
+
+	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER1_EL2);
+
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR1_EL2);
+
+	cpu_if->vgic_ppi_priorityr[0] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL=
2);
+	cpu_if->vgic_ppi_priorityr[1] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR1_EL=
2);
+	cpu_if->vgic_ppi_priorityr[2] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR2_EL=
2);
+	cpu_if->vgic_ppi_priorityr[3] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR3_EL=
2);
+	cpu_if->vgic_ppi_priorityr[4] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR4_EL=
2);
+	cpu_if->vgic_ppi_priorityr[5] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR5_EL=
2);
+	cpu_if->vgic_ppi_priorityr[6] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL=
2);
+	cpu_if->vgic_ppi_priorityr[7] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL=
2);
+	cpu_if->vgic_ppi_priorityr[8] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL=
2);
+	cpu_if->vgic_ppi_priorityr[9] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL=
2);
+	cpu_if->vgic_ppi_priorityr[10] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_=
EL2);
+	cpu_if->vgic_ppi_priorityr[11] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_=
EL2);
+	cpu_if->vgic_ppi_priorityr[12] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_=
EL2);
+	cpu_if->vgic_ppi_priorityr[13] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_=
EL2);
+	cpu_if->vgic_ppi_priorityr[14] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_=
EL2);
+	cpu_if->vgic_ppi_priorityr[15] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_=
EL2);
+
+	/* Now that we are done, disable DVI */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+}
+
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	/* Enable DVI so that the guest's interrupt config takes over */
+	write_sysreg_s(cpu_if->vgic_ppi_dvir[0], SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_dvir[1], SYS_ICH_PPI_DVIR1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_activer[0], SYS_ICH_PPI_ACTIVER0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_activer[1], SYS_ICH_PPI_ACTIVER1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_enabler[0], SYS_ICH_PPI_ENABLER0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_enabler[1], SYS_ICH_PPI_ENABLER1_EL2);
+
+	/* Update the pending state of the NON-DVI'd PPIs, only */
+	write_sysreg_s(host_data_ptr(vgic_v5_ppi_state)->pendr_entry[0] & ~cpu_if=
->vgic_ppi_dvir[0],
+		       SYS_ICH_PPI_PENDR0_EL2);
+	write_sysreg_s(host_data_ptr(vgic_v5_ppi_state)->pendr_entry[1] & ~cpu_if=
->vgic_ppi_dvir[1],
+		       SYS_ICH_PPI_PENDR1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[0],
+		       SYS_ICH_PPI_PRIORITYR0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[1],
+		       SYS_ICH_PPI_PRIORITYR1_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[2],
+		       SYS_ICH_PPI_PRIORITYR2_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[3],
+		       SYS_ICH_PPI_PRIORITYR3_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[4],
+		       SYS_ICH_PPI_PRIORITYR4_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[5],
+		       SYS_ICH_PPI_PRIORITYR5_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[6],
+		       SYS_ICH_PPI_PRIORITYR6_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
+		       SYS_ICH_PPI_PRIORITYR7_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
+		       SYS_ICH_PPI_PRIORITYR8_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
+		       SYS_ICH_PPI_PRIORITYR9_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
+		       SYS_ICH_PPI_PRIORITYR10_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
+		       SYS_ICH_PPI_PRIORITYR11_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
+		       SYS_ICH_PPI_PRIORITYR12_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
+		       SYS_ICH_PPI_PRIORITYR13_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
+		       SYS_ICH_PPI_PRIORITYR14_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
+		       SYS_ICH_PPI_PRIORITYR15_EL2);
+}
+
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_vmcr =3D read_sysreg_s(SYS_ICH_VMCR_EL2);
+	cpu_if->vgic_icsr =3D read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
+
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index afc4aed9231ac..9695328bbd96e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -10,4 +10,4 @@ CFLAGS_switch.o +=3D -Wno-override-init
=20
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8529fcbbfd49b..7682ee72af775 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -414,6 +414,27 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+struct vgic_v5_cpu_if {
+	u64	vgic_apr;
+	u64	vgic_vmcr;
+
+	/* PPI register state */
+	u64	vgic_ppi_dvir[2];
+	u64	vgic_ppi_priorityr[16];
+	u64	vgic_ppi_activer[2];
+	u64	vgic_ppi_enabler[2];
+	u64	vgic_ppi_pendr[2];
+
+	/*
+	 * The ICSR is re-used across host and guest, and hence it needs to be
+	 * saved/restored. Only one copy is required as the host should block
+	 * preemption between executing GIC CDRCFG and acccessing the
+	 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
+	 * it is the hyp's responsibility to keep the state constistent.
+	 */
+	u64	vgic_icsr;
+};
+
 /* What PPI capabilities does a GICv5 host have */
 struct vgic_v5_ppi_caps {
 	u64	impl_ppi_mask[2];
@@ -424,6 +445,7 @@ struct vgic_cpu {
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1

