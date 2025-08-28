Return-Path: <kvm+bounces-56084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE904B39AD3
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:01:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E9E1164CB6
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08C3030F556;
	Thu, 28 Aug 2025 11:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K7kayEdM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K7kayEdM"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013027.outbound.protection.outlook.com [40.107.159.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DAE3090D7;
	Thu, 28 Aug 2025 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378824; cv=fail; b=IEjGT/eHxiV82SjDlOB9uBgCygbEYLGmqrjJ6PORS5lyN3vXD26FqSD+8MgHbtcwJDE1JUEOdf9hIxXrOxCvflJDwR6eX6x3b8Z+irBcGZbnTSOOIMAKTYYYAKwrYNX5br3ndJIaXRymv3uk6bM7Hg0id/NLeNQ3/wNNLzBPj7g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378824; c=relaxed/simple;
	bh=VjDH2MOX4ALM/v/UvswLaa2xk+IA7tukoSIsJ0JvXxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tNMiToJ2baaSnvxtiE3MY6TopZIKBpRdGfTBQ9+dfVRkOCLwOWZEq2WezgesePxkA6GnTbTToo1kdKYhXaHEv3r9hUk4IkubYnaO1SNLZ/YcqaaeGIuK4NSX343plc4e2Bmxf2C9EQdMYToccyTR3zXSbtcflYaBPLEYm8g20q0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K7kayEdM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K7kayEdM; arc=fail smtp.client-ip=40.107.159.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HP1VV24IPOlBKdE3a+NINtnblugBgzcmSyMMIcFSPrU+WRHsMG/JCtfKysXvcBRzuPn8wa02TrAdl8wUYSekD4676rkZB+1IdvkjnI4LyejvvLngZQCJCRaQHGs+V3BUjtRANtK5y1o8wtwMvv1MHAo8wGWx+apgMRANtb37H2G5S8BxODiQEaJ9LZaw01jReu1Hs9AqREEaA5TQBTZoyx4ZB5ES1+hFQk0Pax2YDYuzGqgRhHBky+CU3/ACL5aelSCLVRTfv6D/KN3sCxuyo5W7hw3/qiOa2X5+Abathj7HntmCWmaBuf9HNarKnGETstD7nPKMQ262vdushN7f1Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8MhKhjD61T8t/FM++5+rwJ0z3tliZ9JPRm+P+QxM8s=;
 b=nlxp8byIKTT+6kwZUauhA2ZWPIguuEu4pda2p8mJZX1wcUZ9QDig0qPZol+USd2qHEwcajZNIpYrF10TjJf7n2VRpgVeA4w4yu7iX9pHR82U/fIE2qCEYRxLY4wpNh57Gj8d3eWDL57ucz/J6Z03w+ZknqAZNLFosJ0w+DIhCPeAaUuxKMiHMSgvnNSuYJ5rjH98VWX0d9ybwqvSD/EPaXfRmO2E5tDkANjWnGcRSK2lVLMV+aGYio6HLnRu6qQNx2Ky7hjtN4ngeerzwbgE2q2krJElMNfEjBcFj55szm9Hll188tFkxttCb2yPg5FA1CfzSXHCAxLPkyS37QOzaQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8MhKhjD61T8t/FM++5+rwJ0z3tliZ9JPRm+P+QxM8s=;
 b=K7kayEdMEjJo1ImtNzuGwO23WmFnae8yaGf0zLG+nie2MfFsJnioBRprJ0KuF1av1u7Nr462B6L0cE2BtMrLFXiKAIUldOgH8d7DdPjGXRDZBfHEsDxRZv5JUKl921XNQybxHVZ/trViPFGRlGte2ivZpwhhqQy9/0xaMBqUz3Y=
Received: from AS4P192CA0022.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::20)
 by FRZPR08MB10951.eurprd08.prod.outlook.com (2603:10a6:d10:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:00:17 +0000
Received: from AM3PEPF00009BA1.eurprd04.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::7f) by AS4P192CA0022.outlook.office365.com
 (2603:10a6:20b:5e1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:00:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA1.mail.protection.outlook.com (10.167.16.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Thu, 28 Aug 2025 11:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bcV0r1FBKR8GLUl+5G4eGMr/sNQFoZihDRcXX0C7C4imywVIfT21FJoOGxpNYbQAY5+snEPM0qb9Yyq5KjfiCsZZCXzUZT8Wdj4CC+mCxqXAk3SNgT75olWn0PFrABJPn02RmLWwNxtlQ9j69XKLwdJT8Wg4JJbPKvzVAzShp/q1NCafM1HS6gq0hKpA65Dooc32acZMrfQne032ihWHj00EylncGUxKWlL8ji2EgiV36HusKVzPztMLsf8NiS26KEeQyk6ZaOnc2YGH6ImN54SYFmGNJoqF3HIgSWzTOdH+iT3sErxN4FEWrOrXL3UUtiIl+ec+7BBdMcFcNPscEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8MhKhjD61T8t/FM++5+rwJ0z3tliZ9JPRm+P+QxM8s=;
 b=Yh07kKtRnXS0Z8m9WlEUaKUavWLt/lAfdCJQK6TIhL6yJTnYErihg2FOdUyEUrsutceXVR7nZT/2RdBHAfMYv3giQ89AWoMvTNQ2J39gb6hqI3SLTxlciQhpRrCVVdgVzgXtarPQT/P5g8yNj05NOKRVLiSt1ejATezF2Zfu+sJCISuEXgFT6W0OdT0IQzdMfXljXCoL1sT8ocl9HxTdxBjQEoQ3s/RS0LoS1fij+hJ0p7l5Erhp9o4mTy2EHsVNIXfJD5s7MQxpp5WmrguBo839IeVK6L+LD8MzTyBh8DLydQebndDHU1lADyRUYbtTJd79kMktVt9HUGZVKrwFBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8MhKhjD61T8t/FM++5+rwJ0z3tliZ9JPRm+P+QxM8s=;
 b=K7kayEdMEjJo1ImtNzuGwO23WmFnae8yaGf0zLG+nie2MfFsJnioBRprJ0KuF1av1u7Nr462B6L0cE2BtMrLFXiKAIUldOgH8d7DdPjGXRDZBfHEsDxRZv5JUKl921XNQybxHVZ/trViPFGRlGte2ivZpwhhqQy9/0xaMBqUz3Y=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 10:59:42 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:42 +0000
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
Subject: [PATCH 1/5] KVM: arm64: Allow ICC_SRE_EL2 accesses on a GICv5 host
Thread-Topic: [PATCH 1/5] KVM: arm64: Allow ICC_SRE_EL2 accesses on a GICv5
 host
Thread-Index: AQHcGArbk35K7F6gd0GbJ52c1G5nNg==
Date: Thu, 28 Aug 2025 10:59:42 +0000
Message-ID: <20250828105925.3865158-2-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DBBPR08MB10481:EE_|AM3PEPF00009BA1:EE_|FRZPR08MB10951:EE_
X-MS-Office365-Filtering-Correlation-Id: b5f4fd3e-4571-4524-2db4-08dde6221146
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?HBytgtWclByIWhBkf0FMGy2x3/Gl04+nYdf3PVkCsSM8NRjyy5lTarPm8y?=
 =?iso-8859-1?Q?2tq9MP+1N31OkRYeCyXcRZvywSotlTvTIkOrb/beUmTmOt2jNY9udA5D1t?=
 =?iso-8859-1?Q?DyBWu/p8HnuQL8OqMf0D8hf2HvkSh1GxEgqhaz4fyjRMiXyRn5FN6xWMm/?=
 =?iso-8859-1?Q?tMd/nwUsbdpOvFeuVjX8I3L1o8DUs4WDhONaUpBsnLh/hL0ePC39S1gSkd?=
 =?iso-8859-1?Q?H52qczGYoNNj38ArfjDTemow5xS6hIPYmzFeZ+XU6zlqR9pwRx9PNCJn4G?=
 =?iso-8859-1?Q?P4FRCKXEBGEnt5k94gPhShhz8RqdYVIhcRPMMjpq8HJmDcOj75HmaCrkey?=
 =?iso-8859-1?Q?AkZVmWrkag3ldhBNhg0Wzw3V3fPX+ktEwrD856sj7emwaeGqhZMeNAiniA?=
 =?iso-8859-1?Q?9HYMFgJtH9iRX22jHi2t75MrOGUXl1wsWkTf+OlmQ0icbo6ZZR+yPgEl/0?=
 =?iso-8859-1?Q?dIRxeG9As1VO2HCa2XWq+f8J9scmKQtER4l3uf9BeePMMmI1wxiNAqLZyj?=
 =?iso-8859-1?Q?zMtU03+pN6U3e87x6Vdf7G8306BbQ5BymIAyFslVHr3Rk+3lsu/IJnffca?=
 =?iso-8859-1?Q?IdX7ajUnmuYRivWOngJ+mxuFsoBig3+pptac4Sl34q6gYKB2DXsrAcj2/Y?=
 =?iso-8859-1?Q?p14ih6AhOtF3fWEfnYC14haLvcFBK/IfQVK38+Mmmu2QfzYMhTmAVG+fta?=
 =?iso-8859-1?Q?cyF5axbXowp08RwxKg/b6WzPKMPyXcCzOt/hAM0DppRwMl1ocAAQbr2CQa?=
 =?iso-8859-1?Q?34JrIha0QWtx0Gm6P9P2TZieE38slMVAyehoIPfoQ80JP8YCroFjR5gLWR?=
 =?iso-8859-1?Q?fh6/QIdeKTsfHGbGVe1uakJB4GlqA+0Jm/EhAkiGsHYq4sda63H0yB9mHB?=
 =?iso-8859-1?Q?qXIofGmxRvYQH7p0xtQDzPdh9YxaEmvj4Run/A+xHEciH7XxYFZR/hF0CC?=
 =?iso-8859-1?Q?TsCePcuepjE4hgBDTDh0B3N2WlrVCawNEQbzJDmqCfoX4HSjhrxSrHtABs?=
 =?iso-8859-1?Q?eUiHZDMiMum/cqLzFqnoxl7lHXPydITEVrBrumjvN+4pUgV1wgV1/0xdTP?=
 =?iso-8859-1?Q?WcizJqp4hejcGn+FiFrzdMl1J9jo+yC+kbFqPy1TFoGTZH4QrVzRTGWiUN?=
 =?iso-8859-1?Q?YfcUd1/uwmF+msmhRT/sYB6QnDO6zKTVNjO93jKMLuxQsCME6nqcsaSb+8?=
 =?iso-8859-1?Q?Ri42UZz5oUFGraPvzYhYGn+VWkmsD56lK5PVmUFI/jpctgmTzzK1rbDQ+9?=
 =?iso-8859-1?Q?QH1txdhgvwbsGRSV+CLOJqtKsM4tYKiVO4k6+SDzGcJIPXE1TnDgvuk5bS?=
 =?iso-8859-1?Q?4J1EjnEO028OSXMbryh209rMceM8YqEd4Jqqx3Q3TGFWveGdReezdpy61Z?=
 =?iso-8859-1?Q?IxWoEcctWVQ71/O/Of6jpKr2t0X12NTFUBH5JU+UryvlyfmnRM/YekiyfU?=
 =?iso-8859-1?Q?PVVoI4YkOYQGBlHO4jYTjAQNf9JPRAqJcmuyz/ipHVj+IqV5sGFyShznf1?=
 =?iso-8859-1?Q?GDjyZlHQ4mcfRrN8CfPxIcrRRQ5Tc6vaPauP3ROIZtiA=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca57376c-13c1-4a7c-4fa1-08dde621fdba
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|14060799003|376014|35042699022|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?YENhZKg0ykd/kquZqN5vtQw+QHKelMitr/PnKnlzMjJPn/MHwEHrgVtleg?=
 =?iso-8859-1?Q?nHsuF1USihsm5p39D/dCg0SPuj1maxKY35T5Gn4/30mlobiSSRWSdlhhmB?=
 =?iso-8859-1?Q?SVjLbauL65WjarHiaSmMugnlccxvbMBPcceELU0qWiE4Vp7wqNgYSsFd5r?=
 =?iso-8859-1?Q?DtNJXe0zrCY5Y93kfYHKewFZvK83EKNud0vJfo9aTyadskQbQLnzZQDVQs?=
 =?iso-8859-1?Q?Q5bpOJheZjDBEi4fXPULXaKrIIEhwkyiMwviq6QYGESiPravvs+jmOP/td?=
 =?iso-8859-1?Q?hdpRIG6+4aCHpzVSjj/wjiQyJQ6FT7VBCsCL3LE2o1uIiLwugIEusYFbyN?=
 =?iso-8859-1?Q?0MGkJBRub7QxJjHQiMpuBcBQr3CW6uNRzyHXIB/QKFPyfDWYivlszdNVlv?=
 =?iso-8859-1?Q?ZytO8m0AK88r7jgX8UVB0cxuFBIdLORr2JCGX33c2jwdDQD2+Z6t3iS7UG?=
 =?iso-8859-1?Q?EF6x6aI1QqUZlu4iHHP7mWIGo3PiHfut8i9x6vbY0RvsFDZ2A54FGdoQD9?=
 =?iso-8859-1?Q?WNa+0ioMPS9eRpqJm1y6ZOBj6yWmmdOzkugcTBAjFVtRBHebtX5RcJGzst?=
 =?iso-8859-1?Q?cXr6LrRRQqgK94JWW25PdxFJ+P2nxihD5dFUcfk9+StSCGIzQEofPoN8hG?=
 =?iso-8859-1?Q?YoIWdlcdi65s42uW10bVNCfS1EOT8SIp5ouNZOAF8EpfwYL9/PGumGU0QU?=
 =?iso-8859-1?Q?0+Rqc8ff+MeGnFKsY0WqRIECGwuphSETPlLqPWHFE6C/+mMq8+HhlWOnVh?=
 =?iso-8859-1?Q?M+/2iOeVutdBL4JjL1ds7ZXxe+B7AY59crV/Y3eX0+yIfNVV7WxJzTQHhD?=
 =?iso-8859-1?Q?dM25hYviyk4OHx9vzPn/9SRWIax2j0zdU1BPKOvbVaqzo3x+8uF70LNPdi?=
 =?iso-8859-1?Q?iySu+WAYXftXxJ//uC8OakY4yGNhnsK6q2RuJGAHTqMiCi0P9ExbjxAcZV?=
 =?iso-8859-1?Q?m9/eeXqwH80FZ5Cil1wUYGx25RScTH5X8o2h8g4SOgl8y4LLO2Aq7uQ+Rw?=
 =?iso-8859-1?Q?TwUp5aGUTV5lIPuVtdQkLVetPs6/LZoJxol4GIuisboBnpjVeUkXwXwkq9?=
 =?iso-8859-1?Q?QpfXPO+4onRLaRyNyjKDZTdWq0AbiRug3EYa1MWv/LhOZ/BZ3dUhV9st9Y?=
 =?iso-8859-1?Q?nyA27Ev9obcJJ7+aBXArt9hWoGkgANernlVRfonkI/w4A9/u6SpVnlnRuv?=
 =?iso-8859-1?Q?7c6Ka8lAADqgLALyFCYyv6FC6jEo1gQLZipUhfui4vo/wo6pT+lgv0IvRP?=
 =?iso-8859-1?Q?0rWT2P3g0gxFILpuULmOLz/9qnZYfmOcQDyQ2VJy/7VVrOm5LsR1zu++Qj?=
 =?iso-8859-1?Q?8tUSNCljKpQkKTdXUBJN42JToG4VxfxBTXLz6aIkoJQbqsUVArD07kygpT?=
 =?iso-8859-1?Q?LI1QmbDKIePJUUz4/4J+Xv8tNJoN59PhDhhX3N6gpMl5kRi/RnaxuUI2YT?=
 =?iso-8859-1?Q?vhEWXBHXbrSse51iv+T+gxK3CF1vnDTVbr9HjDg4DOiMo6VgdVLhf76s9d?=
 =?iso-8859-1?Q?hEEt7XM2ibRamWaBeURHkN6lXLiIj3zhySzu6uIObuD26pkOo6+P8HcQns?=
 =?iso-8859-1?Q?RcXTKkO/OG7ttYY9FKLeb4POPRtV?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(14060799003)(376014)(35042699022)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:14.8701
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5f4fd3e-4571-4524-2db4-08dde6221146
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA1.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10951

The bet0 release of the GICv5 specification didn't include the
ICC_SRE_EL2 register as part of FEAT_GCIE_LEGACY. This was an
oversight, and support for this register has been added as of the bet1
release of the specification.

Remove the guarding in the vGICv3 code that skipped the ICC_SRE_EL2
accesses for a GICv5 host. As a result of this change, it now becomes
possible to use nested virtualisation on a GICv5 host when running
legacy GICv3-based VMs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index d81275790e69..7dbfd35a63a8 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -296,19 +296,12 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *=
cpu_if)
 	}
=20
 	/*
-	 * GICv5 BET0 FEAT_GCIE_LEGACY doesn't include ICC_SRE_EL2. This is due
-	 * to be relaxed in a future spec release, at which point this in
-	 * condition can be dropped.
+	 * Prevent the guest from touching the ICC_SRE_EL1 system
+	 * register. Note that this may not have any effect, as
+	 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
 	 */
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		/*
-		 * Prevent the guest from touching the ICC_SRE_EL1 system
-		 * register. Note that this may not have any effect, as
-		 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
-		 */
-		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
-			     ICC_SRE_EL2);
-	}
+	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
+		     ICC_SRE_EL2);
=20
 	/*
 	 * If we need to trap system registers, we must write
@@ -329,14 +322,8 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if =
*cpu_if)
 		cpu_if->vgic_vmcr =3D read_gicreg(ICH_VMCR_EL2);
 	}
=20
-	/*
-	 * Can be dropped in the future when GICv5 spec is relaxed. See comment
-	 * above.
-	 */
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		val =3D read_gicreg(ICC_SRE_EL2);
-		write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
-	}
+	val =3D read_gicreg(ICC_SRE_EL2);
+	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
=20
 	if (!cpu_if->vgic_sre) {
 		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
--=20
2.34.1

