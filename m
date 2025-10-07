Return-Path: <kvm+bounces-59579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 002B8BC1F14
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 17:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA38F3C3C81
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 15:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006692E6CCA;
	Tue,  7 Oct 2025 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G7MKDksR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="G7MKDksR"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011031.outbound.protection.outlook.com [52.101.70.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F26B2E1EEE;
	Tue,  7 Oct 2025 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759851364; cv=fail; b=r1QEdyfQekcJ0GKJg4kz/317pybQhSP/vzHEB+YP7dNuYut+lz1mCGBB4NcDb7IQ+sjo+9jEqIEeqyugGncH4mFMl6RvsirKn+ZZ1ti4uzE7dPpD/WjTKUCE82kSevIlDRqbUbRxZMmt9jj0xCyKlDA8P4nIQlX6HFAg3NbJPUM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759851364; c=relaxed/simple;
	bh=W/lyU+0OqOw/uHEFSR3vqCkWHbznVzjkupkpS+9qx74=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UUuiE/IrIRfTxrHud4JFjVuWzmW91DMvjLUIpUriePZtNW+cAYRzHclGxY/t94Ua1a6S36NoYJ/30jTt57WGzRdSm0vfxQlPYZnpigzMNQXVcUbFyZMf+EQU3qcrLyfozC8XhuDdsdqdEHYFxtdDfbCA8wlDx8baDZIZ+LmCYXo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G7MKDksR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=G7MKDksR; arc=fail smtp.client-ip=52.101.70.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BygKbicTfhyr8Fbu11dGzzmh8Ii78ivS7rUA6z9WyEP7eSHy7pAy3zatukI0RItBTMZMrxOi1GLhOFPECDLnMBfY8GU0Ucwf86tfZKdZJUwaLzmvKoBEAzJIeQaYx4OZsXJ0y9UmYIvTEIZBrvEfGgnBOFeePTX0X4R8dSwOuKH79aA4GFbU1my3vuTr1f75PsfC6pvOpWbHz7qOITlYX+tAIqM43Mdj3YL/Q1qufY7/076JRyxZZeY2YqWigOIuFXGYpB8eoe1CiqYX4HheRirL8vRgmgrhP0ewLp86JInp4hFdzSI2CyI8UFEF8rg+birMTpBpbGmsVKij9JWm4g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuQalkF03pQPaxiECxKTyjwnjtZ7ZZUByu6XcGmmjtc=;
 b=J9YUg5dmgFQC4OYqqERBNOUrebFk0+XZ3+8L4/Zt2LG/Vm4tixdIbwrJYJ147b6SVPfYi3Ro95xfVxtLkvWosWhx+uOb3qAQjPjoj/ALpLGxfY3YOInN5Uv423m73cgJHWjz4srb7SMOZuiPN/YoUISRgALbxyWZ20/6xijurzM7ZAnD/rJWckxzMQ9fXbALOpcUIbEMlzTR/ZFoumon7st35MJzthUVDAQutImGWVmbioZgsvcLXDFv8NSSGoqS5or0lm4ozDmH7thxBPcbYN532rTAMMyzlQIR00kZ9gvKEWsF6VYR7lPStrXC3ZRCb3k9kY6Tg5zI0jZsWcZNAQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuQalkF03pQPaxiECxKTyjwnjtZ7ZZUByu6XcGmmjtc=;
 b=G7MKDksRHaeGfpn+d9Wvv4sYOb0yA/H1O8+uJG3NRCITN1tiloUyBenvzhbjto5y9jvjK57fBhiJJU2dnuqUOLmGdarX4GEYTAe/5gbP7J7/fo7/97Iud5m1EwIfdt0N4j9RFkN2yFK7zqTaV4n+G2ZwpB6Xg1PFs274vrRvK50=
Received: from CWLP265CA0337.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5a::13)
 by AS8PR08MB7864.eurprd08.prod.outlook.com (2603:10a6:20b:52f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:54 +0000
Received: from AMS0EPF000001AE.eurprd05.prod.outlook.com
 (2603:10a6:401:5a:cafe::e3) by CWLP265CA0337.outlook.office365.com
 (2603:10a6:401:5a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 15:35:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AE.mail.protection.outlook.com (10.167.16.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 15:35:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kuSgB22EXc5G8W2tRyOhV40829LORj0O/8HNr5JWSfqDTH7/eqsW06AzSRxW/hXREpXEQpnN1ar56QtYiSQqvcyp0ICwE9C/DXjrOaE4NE2Swp7EVg58PZAGgnsbEiMkQ1JHH3tNEWBLmu6MiUb8W/3Pg0h+uRSA6dse+q5mmhreaMVHXqQgNBOuRxii97A1dgk51PYnCuiczakb0beI9JtgnFLnDNhZcCSaSLcZEJuncdFcUtdgHiWsuVHX0LpWA7krc6L7EfoLrlrzDDxHjqb1irik5U5EzTAWo5FqfVGL1QKHGaSsmNV2Ff+hqsGMtittKHDxkb6NoDOlmnsgnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuQalkF03pQPaxiECxKTyjwnjtZ7ZZUByu6XcGmmjtc=;
 b=ssQOASfJ5HF/rKb+9iKSnnrA4PHITZter+CJ6i3OW5f3FiyFZUyLB5xSUFCJEJOCXWIfCGZY/4HN0bvrdOItxUawRvdTlyiK0fIhj2QfYLvxmMqZYnJsDJ6wLT9O7ax/qEYL/s+M6LXZJGE3QoG6/fn9jPyFw+PYw6tcKRHKjMTCvCuHLPT6j/wSj6lsRuOqnlV8WmvgpI+43hvdag0Jdo2khGITMqQiyWVyFeIErr+ew78oNSlaGj35Hphrry8iD26U4pruNwosjL6J4HhERLaj6hKByIxQaFNz4YNaJkbMYJBNwuvgJnB/o7IgiziGLRa6mthGP3/ZX5qbilkXqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuQalkF03pQPaxiECxKTyjwnjtZ7ZZUByu6XcGmmjtc=;
 b=G7MKDksRHaeGfpn+d9Wvv4sYOb0yA/H1O8+uJG3NRCITN1tiloUyBenvzhbjto5y9jvjK57fBhiJJU2dnuqUOLmGdarX4GEYTAe/5gbP7J7/fo7/97Iud5m1EwIfdt0N4j9RFkN2yFK7zqTaV4n+G2ZwpB6Xg1PFs274vrRvK50=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by PA6PR08MB10593.eurprd08.prod.outlook.com (2603:10a6:102:3c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:14 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:35:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH 0/3] arm64/sysreg: Introduce Feat descriptor and generated
 ICH_VMCR_EL2 support
Thread-Topic: [PATCH 0/3] arm64/sysreg: Introduce Feat descriptor and
 generated ICH_VMCR_EL2 support
Thread-Index: AQHcN5/5kDs/uuyBFEal/unuj65vRA==
Date: Tue, 7 Oct 2025 15:35:13 +0000
Message-ID: <20251007153505.1606208-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|PA6PR08MB10593:EE_|AMS0EPF000001AE:EE_|AS8PR08MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 747c61de-fa0a-4933-c080-08de05b73393
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?i6neToZYRZUBiaexoTsn495Xfan4+UCtnb6ORj1O/n47eizSguJV3OICeP?=
 =?iso-8859-1?Q?PS3G77VSMS6OwqI9SWhl2v9IuJAzjMgUJ9lV74bHtSVgJLZjaKrehTxJvS?=
 =?iso-8859-1?Q?DPLJrNiI2nHGeeUiK9YY17A0q2/e5Flgm14PfyWoPB5WH7uLHriPjzHo4j?=
 =?iso-8859-1?Q?ufgnjKA6ojVhu8cioo2TdcN4l7hatSorTqQe0qq3sEuS3poXL/thIfymd3?=
 =?iso-8859-1?Q?GZ9LuZMmcLNVxoXd4MGHzJZwB2YC+aSnnH3LcR24FxOO4LXytFAkhc3Dm0?=
 =?iso-8859-1?Q?0sEzkrMZBTYgxIHGAEnzcXlNxygTFZ4u5A1PzuCIfjRx9+Ad/Eh3zpq3Hh?=
 =?iso-8859-1?Q?N3HOCo5M476PX2TGczY5OhQkbIbTdYlWvrOtLC7FcHK/pETia1GZrObI0V?=
 =?iso-8859-1?Q?ZyDTZYGLl/saCZbZwMhgmOOJq7r5uMOnafB4NxMMMYgFgP7zgLoVPS8M27?=
 =?iso-8859-1?Q?73/TuscWhsBgQwuHzbr3DyjZPXVS8w3r5X/7kLWvSM5Y2z5ffUXfNKEK87?=
 =?iso-8859-1?Q?/UA/QRX0gsWzZ2Czxox+fVn7iKCib/Jiwv9C+pQxDJlnQqrRo0j49zi1wT?=
 =?iso-8859-1?Q?hhnXMKvKz08H6hwcA/iVkscEzvMLTEAJ6n4kNWJBqy1iBbag2ejqsUk1NG?=
 =?iso-8859-1?Q?OLdlLVOishg30lGg1FTT8T/B0hSZgXy4WVUYv8LtorplWl3ym82lcuP6uV?=
 =?iso-8859-1?Q?7ou05XZxw1YxapWRbDvTFGa65/gxxYbU9FJM2PLpubjkSCIOYmG9gXf8g9?=
 =?iso-8859-1?Q?nD0i2Umy71yZYlErre55Pu1ABZoa0IrZT3qB7V8DsHoyxHOsldQdyQ5Ift?=
 =?iso-8859-1?Q?zSBCvD1qM+Ctnb0sYBKtCBPOwgDJCGSOVwjaAASGihDAmMYO0iyg5RRuxL?=
 =?iso-8859-1?Q?wr1+9aYvw4o132qJ3QZA+TE7Ve/AHoiaLdz86Ej6jYTgLZcGz3LGPBz9kY?=
 =?iso-8859-1?Q?Q+znCM8/xuMTC7VGcq7JDf1cV6mcAbtJzJWs3iRT3OuukId/xtNlPYQKf3?=
 =?iso-8859-1?Q?taWeydqmYJs0Y6Rm9vPvTP49+IgUlgUDmwU/aFrxlH/BUBUxtFu2XFxIar?=
 =?iso-8859-1?Q?39mpXJ3e4xm5mnD/Y67nyyKK9bX4W2zGsO48KJhwcdI1yCcqo4yE35uhEB?=
 =?iso-8859-1?Q?qZjKY1JOjbtwnSdMkJ/yGMKemO1l6mVfjnvMpEqCtMTqp2gvec2k1ocMXn?=
 =?iso-8859-1?Q?v3k1cXfEP5Bj3AYkF9LE+GuoAWW55qVIWo/j+bshEX5mZ1p4yp45ClJ6Mi?=
 =?iso-8859-1?Q?UP0ribxuqjLhgoun/OfDCg/4e3hEPxx/Vx7ViUBssC1xXgc0qDNiorFJq1?=
 =?iso-8859-1?Q?xJ+TnfS3+6tbG2Rpf2t6Sjk1EqouP9wrrXvx/AD4tCe33YRwbfkvkVfUI9?=
 =?iso-8859-1?Q?o8ohqq0SqTDQ9TsobGROMYiR7OeBQwZJFrxnvP+rvPL3A32zX55Y3EFWUF?=
 =?iso-8859-1?Q?Pp3bB3pfUlYGY8WnPhTvdtGHqXhIU8samiOxLFnJuEo3VQDGv95PHM5qEu?=
 =?iso-8859-1?Q?kzFxT/rMu1m6OxY5OUsGstlO4vOrFtPZ8htkK0nz7j6j7xqI518uFTYq0H?=
 =?iso-8859-1?Q?fniVPKQWyT94T1RbP04epe9nIqmm?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10593
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7afc6a43-2535-4e0b-4e76-08de05b71bea
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|7416014|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?VNID41vE1HhiUw/WVqf7c/ISXBlszkKJn82jq4R4GZ/+r4ioKDvsNgs5dI?=
 =?iso-8859-1?Q?aXST3rfG6Opi7/O30y/GMNs6os/X7t9XzyUnbdzh6BO2mmjp0acZhEvG7N?=
 =?iso-8859-1?Q?d0MVZPGBLrurw+9TRldEn62Yieb98WTQ6jiVpWy2RwmKlQVrBkivoC6e+H?=
 =?iso-8859-1?Q?sq7cU1WpKQJ/T+xMcVcO42QoeFTAV90jStNSRFD2uU1L+/A4aOqfD1gxFF?=
 =?iso-8859-1?Q?ImPCLF/bBDmo5rXq8N43GYH4Cpxj56leX15XD+Yghfi9TF3xIXNsDXAN2k?=
 =?iso-8859-1?Q?MEEzLbBIH1L+qyZMMBLeMtv0Dy5bX9n+X/uBY6giBldn79WCA1PjBcOZ4l?=
 =?iso-8859-1?Q?qrrYFWT05JVKgWo6e6pn/XxbPIYtqV/y4OfnyZC3ULeYfuoHVoizOX8inb?=
 =?iso-8859-1?Q?E+dYAtO76cGlliKTCGeaJZ1/YjfSSPzZmLbclvPYhFg8pt8wuZMQohn2Zl?=
 =?iso-8859-1?Q?AeawjoIiMqwr4RXl2ia5G4F5msbMODyzhWKQVVbftO+oSwLmDryuf4faUz?=
 =?iso-8859-1?Q?0jQRtH4YmFBobBIK1ItWNf+WgdzlxopQr+pW5KKVria11HCO4nvNKwagrx?=
 =?iso-8859-1?Q?wVYcbAl82lSlKxwrsHBGO4nCMXLMr23oidIXmY4gCtfj5hvpP2WFqz2h21?=
 =?iso-8859-1?Q?A8CwreHBN+5cU/meC+HkDrH/nu1TDnzF6wKRa/RlTmrZiyoapyUxq/6xfB?=
 =?iso-8859-1?Q?MSI6Q3KBZNjqu3frtNYs3js62mV7CYBh1pfHgioKw6p6DmXaBCyZQ0R14p?=
 =?iso-8859-1?Q?mfI+Yv9AgF6Pa7LCG0tY11RncN/ycdxIolY8MYfHWJB0L/pZCK3fb1f84I?=
 =?iso-8859-1?Q?VhGm9ZHTkuZtYzSeIFVn7z0k3x5/1ERWaFZuqsuHKtdfv6LaZdW6MxundK?=
 =?iso-8859-1?Q?T4g5jTzS4Hx06vPeWVv8qZOLexsjHhnDdQzo+bNRKioizBlTCHeUsIXKGy?=
 =?iso-8859-1?Q?N9IrikbrJ/+l9MkI6gNz+e1bwOOGDWaXueQroccr+utSP4lq24U2l8qM4Q?=
 =?iso-8859-1?Q?ttA1eQk1eeGqpPZTWFHkMB7TmKNcWoLG3PpAuIXYsI0qemrKpMyffcBnsV?=
 =?iso-8859-1?Q?9EmwqUOup3GyEzCyASFSXz4edHeMapI1Hc29GiEAD2pLuaeksQerQuVmwl?=
 =?iso-8859-1?Q?VJDsRcug3W9riTG4xNLcu9kuoqjLkJEBJ+XYxS4UcvAHsEBESZt4/0d2et?=
 =?iso-8859-1?Q?Ghho6jlB4OxIXyomAWUHGMTi0OVuCu+4SE9duA7FVG5mcJ0zFHkhgBGrbY?=
 =?iso-8859-1?Q?RKoaPKg58Rz1fKGbsbaUFXhDfSDRGIX+jEbVVlzBOf5/g37vxJJCUMVnCF?=
 =?iso-8859-1?Q?ChvP5xialQC8cvSJrECG5yE2kl39wWV3aio7QJssVIjuXl7TizhBUJFAkF?=
 =?iso-8859-1?Q?7E7y4Z3tuswQElTgTaFjHWzmZEhPmC+/vVT5ZlkI4IpHE+qXyLaLX8MlSU?=
 =?iso-8859-1?Q?a01V0Amd6NV/MOoWEH54bObWbiXIm/HjV1N/e9lBxprAdM2ZquqtQINYJy?=
 =?iso-8859-1?Q?Xxmb525zE6hSMHNEed8XkcMeFBF9sZcScEd4B0eY19NtFEMrBynsorFEQh?=
 =?iso-8859-1?Q?bCV2u1PNt6hvRDIFNkCLA/4O8TWcNki/IqYqIQLrza8yuZd9YzqtxYAqkt?=
 =?iso-8859-1?Q?g5ofjQpV0U0EI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(7416014)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:35:53.4711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 747c61de-fa0a-4933-c080-08de05b73393
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AE.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7864

This series introduces support for feature-specific field encodings in
the sysreg description framework and migrates the vGIC-v3 code to use
generated definitions for ICH_VMCR_EL2, in part as an example of how
the Feat descriptor can be used.

The first patch adds the Feat descriptor, allowing sysreg definitions
to vary based on architectural features (e.g., GICv3 vs GICv5). The
Feat/ElseFeat/EndFeat construct enables generation of feature-prefixed
field encodings without affecting legacy definitions. This forms the
basis for supporting feature-dependent register layouts.

The second patch adds the generated description for ICH_VMCR_EL2,
including both its GICv3 and GICv5 variants. This register was
previously defined manually in the KVM GICv3 code; moving it into the
sysreg framework ensures consistency and reduces duplication.

Finally, the third patch updates the KVM vGIC-v3 implementation to use
the generated ICH_VMCR_EL2 definitions. This replaces and removes the
hand-written definitions, with no functional change to behaviour.

Together, these patches complete the migration of ICH_VMCR_EL2 to the
sysreg framework and establish the infrastructure needed to describe
registers whose field layouts depend on architectural features.

Thanks,
Sascha

Sascha Bischoff (3):
  arm64/sysreg: Support feature-specific fields with 'Feat' descriptor
  arm64/sysreg: Add ICH_VMCR_EL2
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2

 arch/arm64/include/asm/sysreg.h      |  21 ----
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  64 +++++-------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c        |  42 ++++----
 arch/arm64/tools/gen-sysreg.awk      | 148 +++++++++++++++++++--------
 arch/arm64/tools/sysreg              |  22 ++++
 6 files changed, 177 insertions(+), 128 deletions(-)

--=20
2.34.1

