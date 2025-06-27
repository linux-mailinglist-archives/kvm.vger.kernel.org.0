Return-Path: <kvm+bounces-50974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E56AEB3D8
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC9AB178F62
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEB5299943;
	Fri, 27 Jun 2025 10:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FyX36aor";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FyX36aor"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013052.outbound.protection.outlook.com [40.107.162.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5E9296152;
	Fri, 27 Jun 2025 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018982; cv=fail; b=YGY3f7pHMrrFH+wYAxS5uVuwXgC70KiGoy8F2AmEJlV5oXLPJ8yG0FfP1R+FCc0y4JqoNtRY2E+QMwzBKoXJ2zxXsX8aU6Hrq65U0N+dxc4z0PEG+r7g65oIT/ojKgxaOCJSH+34EdEgtNRfC+/uSbDd5SuDq3vxesaN7yIRyjE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018982; c=relaxed/simple;
	bh=fCmFVSLLKXDdY1FGVa52bmxbThdLvBdERp1O7JgnN/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cgB53KSqU/4R4xWFXyJb6Lp/nn/71016jWswlcJgIEJ/RBlVqT6eTFoa+oaSCXk3aNoMiyxiyArIi0xgAmr+ScgTCsWxEY3B6q5csGTw2kUtdYXHJbrt7yPDbAl+5Db5SIbH2A7SzSyhubCHKXmTwqSqeLMwAe1g5us6kLoJnn0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FyX36aor; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FyX36aor; arc=fail smtp.client-ip=40.107.162.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aOZq2Tg3bqkQ97BPKz4g43UrFeoHzPWh9MyPy5/GcKG2FLXTEMIOekGoQDRJp9ciAtaLJ/bgvwFtPQf4p4nQaPnGrzwcM2to8oka8VsNkmWlrfNEsg9QH4RnbeAv7cyix1/rZACwsB1W4m9boHpSlgr/Y8KhoSkuUWhPR91uCIiEU200K3x86PUweGKZhh0iwwptIgb1Iq9hGpPDA3tfgejrdNPNIku18E7ZFyER5u+ekzF8Zaw1akSpycegl9JQLrl8Or/ViQOfCK4ya8HF2D7yAw4qspAL6NN6b5MthqpYtC1x6CJCsxBBZcVnffXUnreRBsIwTp4trWYaZwroMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0q3NGdWIZdqxluBrO0yGO0dm85042lBhi5zRTvhxF5E=;
 b=uHxRZxSyznkJlnc4lmruQ0FY4+3+ubueIBVPTGk4pUbOA07hrDGQIaCVQMdqyqDLX23rfXIGn5LuTd93MIQ14lBvpRk6xtVJyBZDk8R0yplWEgJSJ6vLLDxzwvexpZew8bAngnZXIQj4bMkjl0sta0sWrPCBSpd1rWctc3BS4HCCbK3i9XIZNgSjx7YpoO+2s0J/WmU/P6jc1eAxl+ZjsMDS2uPGDjSAgWsURZiAr1HvF74g3qiECMj/HHzSnsYUEsz5r62kPkZ14Xof7RajU8qcHLrkUMMHDkYLMamNUBWZF/rQzOxwZUgu/2xF1/Hs63KzFNsHdGFXiFwwmlUW1A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0q3NGdWIZdqxluBrO0yGO0dm85042lBhi5zRTvhxF5E=;
 b=FyX36aor6rvPhgzs/cOwY+gfKWyVW3wkRpGaC1osU0x4XeJJoA6emv0JNOxOq/QeSZrIIj6HLUTHp7YUTKZj8byUTX1MZu5Um85NmdQx4kO/brB9fxPF87tBMKda9vZG+kxD+229+nKFmIHll1z8YHvx3vm0WFvGca7mhMcPFxY=
Received: from DU2PR04CA0021.eurprd04.prod.outlook.com (2603:10a6:10:3b::26)
 by AS4PR08MB7553.eurprd08.prod.outlook.com (2603:10a6:20b:4fb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:36 +0000
Received: from DB1PEPF000509F0.eurprd03.prod.outlook.com
 (2603:10a6:10:3b:cafe::ba) by DU2PR04CA0021.outlook.office365.com
 (2603:10a6:10:3b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.21 via Frontend Transport; Fri,
 27 Jun 2025 10:09:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F0.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WgAl7E/5HRCaG3DLhvgVdm3jP61Ivs0ARGSFn3PmE35ia6NXw+vdhNelwhrGTvZCE6JG0SuExOeGsgVmCOYmrG3HuuvhNqIvruOuAal7/QVDHGCKOXGwe6WlEPqaIuPgnlrlILSnGglUcssW+6hF7v+uTx+tS4wAIIEUZWC7odz1WTtcjBhFwQTmgA0RFg5krRTOzMuMTeXkv9Ry3DL8+R8OZiTPhn+f3wDE8My9A8sbOya81FQa6Zs/pj1nB2SAU4OabnhEP9YiNqXsdqbfv9KgtnEmHoDX7GmuROQdvdAIogLo9qO/JNcuXpJKx85eXYN6BAQngexHZ1xQcoz8Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0q3NGdWIZdqxluBrO0yGO0dm85042lBhi5zRTvhxF5E=;
 b=SmsgvjasGGDrldItUfOe71uMXY2cWYlH5iulz8ko/gpd7T/uJaYtD1wzQxFesp4Kyg6Yo2rRodOGoUESvpITORRq64J7t0RvIOgbS1MbBXGqI4AKFyQrYtd80+7h7j1t85MzW/qrnRHaZCZrjELX+jUJ3Z5UU2gjojqjciQW1JmuaD8x7PRXWmH8QEFwvZ0wzi5iyB6rTcKh6NSpKXmjRr1DxDvTCUpKAd5PHn30N0fSs/vmCTFbPbgxA9NNFFyZUEjZdkiy1qOrwahM9DyUNsFhmeya0XD+lulnMib+73MRHn6ku4aaTpxlAe0ER1IMnSZoHtr7XXBQLQg//mp75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0q3NGdWIZdqxluBrO0yGO0dm85042lBhi5zRTvhxF5E=;
 b=FyX36aor6rvPhgzs/cOwY+gfKWyVW3wkRpGaC1osU0x4XeJJoA6emv0JNOxOq/QeSZrIIj6HLUTHp7YUTKZj8byUTX1MZu5Um85NmdQx4kO/brB9fxPF87tBMKda9vZG+kxD+229+nKFmIHll1z8YHvx3vm0WFvGca7mhMcPFxY=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by PAXPR08MB7466.eurprd08.prod.outlook.com (2603:10a6:102:2b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:01 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 10:09:01 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH v2 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Topic: [PATCH v2 1/5] irqchip/gic-v5: Skip deactivate for forwarded PPI
 interrupts
Thread-Index: AQHb50uBVT08xxo3SUOh7vh/YrsqMA==
Date: Fri, 27 Jun 2025 10:09:01 +0000
Message-ID: <20250627100847.1022515-2-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
In-Reply-To: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|DB1PEPF000509F0:EE_|AS4PR08MB7553:EE_
X-MS-Office365-Filtering-Correlation-Id: 175c138b-4bc9-42a4-ac8b-08ddb562b72b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?JwSAVw+uuXCnxAecpdrk4KZlx/J+44yl3vvSR6YOg8jLFYoJHpE5dOzNPQ?=
 =?iso-8859-1?Q?jqhzNMJoLhNxs1vRhHIKX3+mkDLbfCYKvuPWvo0d4zVQFlwhoSBdw0whAl?=
 =?iso-8859-1?Q?4lIgO9+Deb1x4QPxUI1IF54d/cD57B8FJeDdQo/lBCUXpcBfpw9pFp21M2?=
 =?iso-8859-1?Q?/YW9/T/6VjmO2i7WvYu5NY2nXFUJGVeIAT/4YPYChdfi7iRhzJVL4+JQRB?=
 =?iso-8859-1?Q?hMzO71pzBlu0DU5RsoPrnorPjzGWreyZGGfzQ+OrGB7LR+Gn8q7d5IUsBU?=
 =?iso-8859-1?Q?L4UZZmePeDfUsBLVcN3xiQ6nnHqibTI4iXytGfznjaXU3Hw6k0TQrJrjtm?=
 =?iso-8859-1?Q?yREsWuNnch51ctV/Jc9gDtM8bP059RnE5tV08uxKT/hKhLZx2KiB/Hbz4O?=
 =?iso-8859-1?Q?a+NeaG5ySRYAc3O0uRmHvxfQg6V4k4GPjEy3xYEnjOmp4l0fSvPlgJ3OO6?=
 =?iso-8859-1?Q?Vs+qCSUHlyMvrOMDHvKbLSWHzcicMvx87FWFqfWsJJdxZvB5W3ij6bo18U?=
 =?iso-8859-1?Q?wW6BQNR6vn2j14mUFkmneWAvFD+aS9jDd9Ps/t3SWuUaLApH7YQ2AtMFre?=
 =?iso-8859-1?Q?ouAViNzOqXYEIvl1rVTOHqfhmlCFH5F9oYaqXoSVeHH52x7iyFybUSJhh2?=
 =?iso-8859-1?Q?BO88j37JSPabiMKzc8pikj5qb69LnpGjb5iuVIukOIsStgH/wLMEvjeZzc?=
 =?iso-8859-1?Q?1vdm59mqLlYB8Cftc3APU7qsSPTuNSVJyPB/XzK+03iwKf84WbUDq9xq3M?=
 =?iso-8859-1?Q?ltkM8egFayhhSia8w6A+SfKf5JzKm2MXFq982gKIQshah7+ONAC66/4c2w?=
 =?iso-8859-1?Q?otOX9QwD4zf7pS8dCgh4zx6zyFe+kIFRU+8BGeEwKeu/1zDlUasaYaqKxT?=
 =?iso-8859-1?Q?nS2zFaTl6+caalR9CNqhTgo6BOBE1F5aWi0W4n/JUNUU5/ztFwnEwAEKp4?=
 =?iso-8859-1?Q?1PeCZJH5Nk7mq5cJ9Aer3ViOmOUE2aZHcfT7ExDiECqtOOx2DA6E3R22m9?=
 =?iso-8859-1?Q?6a3NoqOe4xio+uEgPNlk9sZxbAGZRcVIuIG7bPtLT1vNWU6fHkgHhkTwu3?=
 =?iso-8859-1?Q?Q8vBQAtTjmWsURL6hyNrZuY22KzMadFDAznuZqFTyOPXdZHBuqPbFbZd72?=
 =?iso-8859-1?Q?nrdOJ/Yol3UbYx0cYr2TW5zzxg/V+eaNkPuLVG0G7D+K0V0T/0HG8kWKJ4?=
 =?iso-8859-1?Q?iYjJI6WP5j2n/Za8FC/570T8YwRsXpmOclS46y6RVAuXqtPyx1sNakVXI2?=
 =?iso-8859-1?Q?n+tY3hrLoFAH+/cXacP997nnAWF8eWANbsQdyIayaheO6o9beZyHEDuC+O?=
 =?iso-8859-1?Q?+ddW7whKnSaH7U8Z0cAfe63VXAULOXQsISJZKzvRQaMoTHEnmTxsNc+XcZ?=
 =?iso-8859-1?Q?+hUwogVwLfUITE+bXh7LFojrPUve+siFLEGTwXiSIgBAlJ1/PUfsSk1BNx?=
 =?iso-8859-1?Q?l1Q7TMOYKbdhnbz1aV893ccFWXlXG6w+H6pzr1BIlpIIQS4IBKGv2sa9QR?=
 =?iso-8859-1?Q?DM6xtMmWTjWKu4Oewq16rGAUvXV6k0qKVHrdp7WhryeQ=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d5f8c781-b219-440a-74e9-08ddb562a3bb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|14060799003|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?oBTK4ii25/mGDVUL4XYOjRNmd12LrbAwTSFqQvsHBfwkMOvYOu2BFoku80?=
 =?iso-8859-1?Q?X30tX50/83SjvtbHQU1MHKF4GmOgKac7Ha/kz0PMyWSU0M0pnpP2gbKNTb?=
 =?iso-8859-1?Q?MIdQxKQxbqmbBUyKP3I5WRKrIuXqhIEJfKT/aWihHO+vGEK+XuFrBdjOjH?=
 =?iso-8859-1?Q?EzUVzNhYnfCUcPrqG3psm+gIgFasx1j4p7AbNAkSZgQORDse3WUJT9ohd+?=
 =?iso-8859-1?Q?XUmsc6NcZEFrqrSwI1g1U/y5Hqavb+xsTgRoqphmA2xQX/GpsaZSpqTWQ/?=
 =?iso-8859-1?Q?jfdYD3D2L+5kafRbcjW4pA9BCvkZRZXZsZdpzKQooUq92qvXXMyzEjVnFP?=
 =?iso-8859-1?Q?Y0S/GA8pwLj111WrtfHA7LkCawSDYq5PAY14iymp4E/EFaZ+UoMiNibpUX?=
 =?iso-8859-1?Q?5RCgzzOFQ9C1AgqcCjqCy5w3t1acbLvACBiHSzD2vc0DMs75WkHrdq+e7R?=
 =?iso-8859-1?Q?Zs62a8ohUUoquVYXzhVaWDk7mM8UxU69UNAs2QD6AyWi4Todi8juCJr6Rb?=
 =?iso-8859-1?Q?Q7OGey4DLtUFMZWh5FslZ+ftWSi0VNVLlkRmuAchxxvgxoIMgviwYMfiG8?=
 =?iso-8859-1?Q?/afv07STXWS/rr9ZKjF1M0yAQVyniwLoV1kH7MEcXrmHiZ60NqybeKUfV9?=
 =?iso-8859-1?Q?WAhUxqxzhZgaJFDovMxY2wsuwd7TXfbEmcTYel62f9HgbC9m5QkytzBI4l?=
 =?iso-8859-1?Q?4FuDTh/cFsbMVYYImBOseYVcAHlVXpGbGqz1etltoa9bYvkP498XtnoyF3?=
 =?iso-8859-1?Q?sz5HhiqVG5AAlE2ownPI0fkv+sSQ0pGe5fAsIo0LgfJBeSD+r2hISb39+w?=
 =?iso-8859-1?Q?3gKq4I3sAol86rHlJQdzQjQk77zUdW23NVRfEylZ5AF8HkavrJT3ZTJy1t?=
 =?iso-8859-1?Q?HfRQOMduzaVSdUSuIGYe4kUdZm24kFkk8Wghn0UHza3tEVb7kBqsXw0Bl0?=
 =?iso-8859-1?Q?qI+Kyu4OCQxMJbfVR9JLgsm3Y3aEsBP+uA6xkp5iIg0N3Uy7fEolo5ei1m?=
 =?iso-8859-1?Q?MJpy7WnoB4bol/8KxinlP3LlX2Yf56g0sHiyauf986MJzTU0LYqGC2eU3F?=
 =?iso-8859-1?Q?s1kOvYwZEdHxwwr86bfx8OszjPC1rxpLsTIuCxlURCCv5j3rfEkvV6Plv4?=
 =?iso-8859-1?Q?thj8nphWmra3mndDeDu3qBAtnoKRRxc6X/LlEsx0a3LFZ48rb585awKkzZ?=
 =?iso-8859-1?Q?SSIB9PF93WgdI2O1LFxToJfWOIFxmaiEbdVenc/13Y/mkWo4LvmX5ssbFe?=
 =?iso-8859-1?Q?pX3BwrgdF8N9EOYigTNMz70j3Qd3guM2MAF25JrOTRDiAz2Lus28RKahgs?=
 =?iso-8859-1?Q?ilkJDC2vH0wqoU4xLms8oz9c69bLwwrGgi4ld7apfEFGMy6QV0dhS4yMJu?=
 =?iso-8859-1?Q?c1joMbnapK+936YE1xs8PRzyddn3PFJUT9ZMEaeuX/xL4DZfseB0jIsCo/?=
 =?iso-8859-1?Q?0KExrozWJSJTziOJ6xwJGRcVsUnE6alvbRHssHLUkOSTlEOIn9iHt7jYzi?=
 =?iso-8859-1?Q?QZ0/u6N0FN67r+8kTG/ACQ1QGSIu+M390vJsV3Rm5SguyW3IzExWXsDi0C?=
 =?iso-8859-1?Q?979vAs9/OAQoa217TtXzTrD9S6t9?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(14060799003)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:33.9961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 175c138b-4bc9-42a4-ac8b-08ddb562b72b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7553

If a PPI interrupt is forwarded to a guest, skip the deactivate and
only EOI. Rely on the guest deactivating both the virtual and physical
interrupts (due to ICH_LRx_EL2.HW being set) later on as part of
handling the injected interrupt. This mimics the behaviour seen on
native GICv3.

This is part of adding support for the GICv3 compatibility mode on a
GICv5 host.

Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 7a11521eeeca..6b42c4af5c79 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -213,6 +213,12 @@ static void gicv5_hwirq_eoi(u32 hwirq_id, u8 hwirq_typ=
e)
=20
 static void gicv5_ppi_irq_eoi(struct irq_data *d)
 {
+	/* Skip deactivate for forwarded PPI interrupts */
+	if (irqd_is_forwarded_to_vcpu(d)) {
+		gic_insn(0, CDEOI);
+		return;
+	}
+
 	gicv5_hwirq_eoi(d->hwirq, GICV5_HWIRQ_TYPE_PPI);
 }
=20
@@ -494,6 +500,16 @@ static bool gicv5_ppi_irq_is_level(irq_hw_number_t hwi=
rq)
 	return !!(read_ppi_sysreg_s(hwirq, PPI_HM) & bit);
 }
=20
+static int gicv5_ppi_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
+{
+	if (vcpu)
+		irqd_set_forwarded_to_vcpu(d);
+	else
+		irqd_clr_forwarded_to_vcpu(d);
+
+	return 0;
+}
+
 static const struct irq_chip gicv5_ppi_irq_chip =3D {
 	.name			=3D "GICv5-PPI",
 	.irq_mask		=3D gicv5_ppi_irq_mask,
@@ -501,6 +517,7 @@ static const struct irq_chip gicv5_ppi_irq_chip =3D {
 	.irq_eoi		=3D gicv5_ppi_irq_eoi,
 	.irq_get_irqchip_state	=3D gicv5_ppi_irq_get_irqchip_state,
 	.irq_set_irqchip_state	=3D gicv5_ppi_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	=3D gicv5_ppi_irq_set_vcpu_affinity,
 	.flags			=3D IRQCHIP_SKIP_SET_WAKE	  |
 				  IRQCHIP_MASK_ON_SUSPEND,
 };
--=20
2.34.1

