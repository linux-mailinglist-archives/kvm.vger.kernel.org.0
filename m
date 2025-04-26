Return-Path: <kvm+bounces-44455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE30A9DAC5
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ED3B3B36B3
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E502747F;
	Sat, 26 Apr 2025 12:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ln3ROXKy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ln3ROXKy"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2074.outbound.protection.outlook.com [40.107.20.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A4720E6;
	Sat, 26 Apr 2025 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.74
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745671398; cv=fail; b=VYfsbxGMR+g0ZafckGlasf7Ezy86ap2BBzRrhtVOmDBV2+wAUwQeQFL0/e0NHHVt9fJ7UXU60yEPbrvFkxcO7Q0IO2NUtXNY0oD6TsEAfPL8r0KYdtl3XCuKRpMvj7nkeRsXaVI2mOEqTYc1hLTbk1pznmOhkn5+tAph/Eu/r4s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745671398; c=relaxed/simple;
	bh=bope75ijoXGmDLbmQhCF5tHUx8aUEL4gnAN/7W9Wd/o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HB6XqPWNeGFq8T+2B8YMLgjfS15O0l02oMiDvJMOv2Zh/E/cUsxD/OHH5MJoEi/XNirthdkYzFMLVh3Y5PNdlUgN6ZTKUzqS9+NVUqImnpaRJc9iucYCnGlQXOCR3o1ZTTFOZcuAxJGPOyB2RczSy1NeLBzUG7XJ5O2/cYokCrs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ln3ROXKy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ln3ROXKy; arc=fail smtp.client-ip=40.107.20.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=livYc0czkwhG3T+uEjvX9nOd7IONJ6EZ46sQQ4lAy5yzVaTGs3DrTLjYvpvlt7559PJFoo6TUlOFgikALXnId7TnG292QhGx4xcuamEfQ1TVyHb7RuQq55y8M/mY6m0+Rtc9OIUSgo4yTRRvaQW8Co2d3P1fJgPdPIxHYk4ZzNkNrpZStuqregZIystQjvxcr8FmdKewJYp5ccaiYOejkKPqOaUBtdI6wc3gqocAlzr3TvryWrJTJo41u9W2EkYQrU1Grz+WSs5LZBC86AgelNLd+gt//VuMXKpAFJrh4hUY9v3FlbSiTUKEMYYLN4mgIl2QKwJzPYj3lyXQDk/bmg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bope75ijoXGmDLbmQhCF5tHUx8aUEL4gnAN/7W9Wd/o=;
 b=TZk9TvAFhsXHuMtE7jIMzwduIPEv1r+7LznPIMgQKPTb8wOHU+Up4iM8+yZJsYI+4c47HPbM4Xn5H76ozDyRFraMsssF9/CITgsQkFZkVksR2TKavJTKplYM4B9hSUVl1Tl4eGoUpLi0UFN5LR1YBdSDHViONzAt+qFeOOhnEjfW71RH+jiCJm0ZBIeC5R7r8cxXnc0Fp/lJ18Ao73/gk9BMX+bHcBdNA9HDtMEZIbO4EFuUOBKtT/jbr0L2dgJOhGLv3LANwZc85hKaLto93sTVo/6u+NwZTCyjgoYtHWnov3138EeaRIqZrfg4UD7guSrdVb9SV/M7dhQtNb5NBw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bope75ijoXGmDLbmQhCF5tHUx8aUEL4gnAN/7W9Wd/o=;
 b=Ln3ROXKy8IWfuEQ4VialBXvRz63ob+LKqA88A5eKXdMDzns9gBVoSSLHYFcDfVZSClPJ4bOhcNH+EZ/+rA/zmMOUWgBbDeq70O5BTKPwwCyX0NhAT9lIOfg4Xkio/MbugSFhcLoreefVtJcLu77vbLBTtNGuvct/XdEUgCfUG04=
Received: from PR1P264CA0135.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:2ce::19)
 by VE1PR08MB5630.eurprd08.prod.outlook.com (2603:10a6:800:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.28; Sat, 26 Apr
 2025 12:43:09 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:102:2ce:cafe::49) by PR1P264CA0135.outlook.office365.com
 (2603:10a6:102:2ce::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.38 via Frontend Transport; Sat,
 26 Apr 2025 12:43:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12
 via Frontend Transport; Sat, 26 Apr 2025 12:43:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KG6TON7Ft8caw/3c1KidOLewgjqQ6vHT9CVZqVlNZKSn1No3byGM6b+MwOz0JHdFf9Io+XjALn5ufiya2yNAAUjj2oBLSLekCPBnCLpxWtjAKFYwKYnn2poy+sVAmw85AbT2TBSEauxOYfpd4PYs0cHhOvWg9FV2Dy9e0lqXmUGjvxmqNVNaPB0Qj1XfZs6qgzgGktu84aXWX0VjXHbYHB0D4ujKSDhqqspcTNow/Kb0AqRepD86roNrEx9u1sEuvvF6E9rqKxbLDaW11C57MHMD+Xhkgs+e0D6mEZ8bcmD65EgO77LB1yeLGDbWLu1Rn7nq9OLkdmiiwmqE+yNxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bope75ijoXGmDLbmQhCF5tHUx8aUEL4gnAN/7W9Wd/o=;
 b=mKrVyf4RboA9w5PSSI1IWIsi2ReHyDdEAcbaw1VBD0x01gXNG10TuyC51MvDBBVItSrzfmNplOLQaTy1rWhzqAiGDZ+ukVOu9qw9CygkU53H5uxV6r+daUM2yAi0cDSEHEfc6KRWekC8sFds09Cveg615dV5ofDBHn7ntiIIwwNkkOvh5WTBahn73lAoWyHfpW/3OAh5cxAGNBzx9Ltn5dBj5vfh2CrlE9TBx0ILdGkQ7JzWS2SxMqkHnELW8Qe+Gx16eLEMWoCGz1o4GPOsFwzjM3indUU2hAZKWECWJweSsf99XbcKAuxYRah1gIEXTcjJvLX7F5nBa5TLdvzMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bope75ijoXGmDLbmQhCF5tHUx8aUEL4gnAN/7W9Wd/o=;
 b=Ln3ROXKy8IWfuEQ4VialBXvRz63ob+LKqA88A5eKXdMDzns9gBVoSSLHYFcDfVZSClPJ4bOhcNH+EZ/+rA/zmMOUWgBbDeq70O5BTKPwwCyX0NhAT9lIOfg4Xkio/MbugSFhcLoreefVtJcLu77vbLBTtNGuvct/XdEUgCfUG04=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by AS2PR08MB9269.eurprd08.prod.outlook.com (2603:10a6:20b:59e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Sat, 26 Apr
 2025 12:42:34 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%7]) with mapi id 15.20.8678.025; Sat, 26 Apr 2025
 12:42:34 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Kevin Tian
	<kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGACAADH7gIAAQ1nQgFIltaA=
Date: Sat, 26 Apr 2025 12:42:34 +0000
Message-ID:
 <PAWPR08MB8909FF04485529558B58BE1D9F872@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
In-Reply-To:
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|AS2PR08MB9269:EE_|AMS1EPF00000047:EE_|VE1PR08MB5630:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c215af4-0f23-400a-80ed-08dd84bfe5b8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?SwerIb/3NzpiyDO7KmZ9OTC4AQE7mpNhllo9I6dwq3HRTFSBaHAStdEm4tdG?=
 =?us-ascii?Q?QxYFkog2+tHRQk5nxwXZiLNHLCDP/J4+o+hVikICwHM8f76Ey3OzW+SgFORk?=
 =?us-ascii?Q?3arMcVn+PXsjlVEWrSIZ2amEo+hVCm8g4OQGLPSfbg/Sws31wDdgb9s93iqn?=
 =?us-ascii?Q?Tquvi1yvTyH361zuflASAqKzC5ZT10KLq/Oc1UcWPZzywWtYlkFkGzV/ORt9?=
 =?us-ascii?Q?XOQ+vVlzInL/Wi72kNQu2teOchSqwiOD8djFgePgXAgI+bkOgPZStERAhDDs?=
 =?us-ascii?Q?/flrdw4Rs9CVMRh5OViY0bxWS/uuF2ch/kX6IQRPL3J7hcH2v3ZMjWfdNz3Z?=
 =?us-ascii?Q?h4KbmQ3PCvge5/3eLhxY0OK6X0UXzA9fQss3L/0iXmO/tVWs0z1HvxmGPFXR?=
 =?us-ascii?Q?yEIuYRxQIL+/tK24rxyMhtXEYd4FJ95n3y5tMfJ02OURi/+q/ZRqsiEc0pCg?=
 =?us-ascii?Q?pfRv2r+naPl01BMQE7QD52R3MaVD/NCkXVLB1lkfWontHU/ZrtRX06Yepfe6?=
 =?us-ascii?Q?1ZFvlc9VkpFF6ujgPlKNZTWRoaIZpdkAlN8OXt/oB7eUyA+cmdh9Anc3XK6T?=
 =?us-ascii?Q?q7rmyeY3bpa9SQpki4Liln6/cU2TJYxWvv4iqFJ2LdGjYT/u5IH0AyUihur4?=
 =?us-ascii?Q?tF5yMyye+mBRKu5IeS0CpikJfHtcHUYTPfKg/7735RnulPMXE89GGS+5bSmv?=
 =?us-ascii?Q?XPOyuAKx/1CtKNM9ypuUFIcpTFOLeh6YWC/QBAs0iJcDkBVd3HNu3VWFn/Yp?=
 =?us-ascii?Q?2YqMcO6ceXxoTak+EhkQ2cT2xdk5+9gYExruC74Q16k/UQMDo6PqTNExMdTp?=
 =?us-ascii?Q?daj4z817kzz6I9IQVhm5LasXEwh6VKXAtfmowDB4d808pnJ4IipIcSNt18Q7?=
 =?us-ascii?Q?U9nybrivcSXZ3pJ1J/eBrKjxHh4YCzlnQXDVvwW/WoX2gPpIgrkLZnfEB0Dm?=
 =?us-ascii?Q?1eTmUX7YMuyD33LLgFDPON6qJrzt5Q3QAX2Ebja7vXVzHlB0WIDmKwGOQ4CF?=
 =?us-ascii?Q?O3u/MndnDkI0nvu16mhwz7kIaGEmUqz4ozagRUOtWnLqzUKfaTjO5tsGhWUA?=
 =?us-ascii?Q?+6TX+5wc2bqWrAExUl49gWTnSQveTBzHOU7fk3N2Qmej5jUDsieYa5ZaJCpi?=
 =?us-ascii?Q?ItpJIKd2f3zR0cRj8qwek1TS1ygQM8/JmvdE7SdtdOEZ9OYBOphxpwYPhbbv?=
 =?us-ascii?Q?vvdDovl1adqTjFaMIL32ZZ4MhaaAJiHKTrTib4Q0mpX7zg4Lm3GXY6Xy4N3D?=
 =?us-ascii?Q?4gP9ZbJkmsOVafrZLVipeY5rTLfIRlCdmzCahcuUG9oUpvVD7a/coH812b0z?=
 =?us-ascii?Q?udbQRKgGNoPibszXkcn9R2rPopxOMAsBIheg7LPyTJCd4DELUdAxnxr8DiTu?=
 =?us-ascii?Q?ey+Cp+utZpg6UvNzcWWHsKMy1P2P14yu8fJo1vguNCKuQQkNJBZhnjIRa7UJ?=
 =?us-ascii?Q?KMyzSFiRRzF9WxtiOWHQ9FCBvEQLa4FU3j4QinecadL0zm1KdTQu4I0wRCUm?=
 =?us-ascii?Q?48MREZs/D86KeAo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9269
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8a04ff05-f27e-4f38-87df-08dd84bfd144
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|36860700013|1800799024|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KjMZFPun6BTlfOahqBW4anEJ5sOVwDIGFq+3IXj72itccGR/52XNbJU8XaW7?=
 =?us-ascii?Q?eZkYvhif+nU5bRyvwnViOl7hJWL6cj0jPdGGZ7KNEqrH9dhoEG+B/XnotjPO?=
 =?us-ascii?Q?n6onGB147GC266+L8xCf7dAGl50iQfGId2jaHRY6wEDmhtgI3H8G1c2ljy6Z?=
 =?us-ascii?Q?yoensf8VCKPVjgP8ezV8Q/xv9FwIG6kwnh7syyL2YeLWa2Ey6Xbu+Lm/SqJw?=
 =?us-ascii?Q?0FFI3dXAQLVnNDwDtpXWtTpKWHTQ8RMeTxdUMljH80g3+ZVR4fxqq3Wf1WVn?=
 =?us-ascii?Q?5ZzmMkf8E7fvlVHu93w59NkhrNuy9Dlm3UXrypLSLwEl8MrEZhk8K7jiaQbU?=
 =?us-ascii?Q?R2cWgaEiemRwNjYPYNcbEE6MFtjSb/g0pz8HSJU6taj5BtMVW6GV2FOxE//2?=
 =?us-ascii?Q?bDDtmvKV1fgxzjOr3JaBEG2/P8ku0aKf+pxpwoQM07jHsMQALWKu9KRVR///?=
 =?us-ascii?Q?vwLh5uCUxItpSiCMudSk26QyMN17zNEagZW7643xH2Eq/PFkZTPd5HwnBjQ2?=
 =?us-ascii?Q?FaoGak3KsH96+RfmcCcOFkl+GT31gij0E6+VV2IUxkRw3GKNKDsA01+h5g11?=
 =?us-ascii?Q?wuMGxoaX2tHYN7Jo/vFSNwi7MGTHbffwv9iIZoz4kPyRd9adQikSs9yATtU7?=
 =?us-ascii?Q?ps3o22zAJlZSyZxGCyXOaixhBV1VusolPiqSez05Ad5E0EYFh33U7Rxizo50?=
 =?us-ascii?Q?+fYQkdtpH2AfydGdhTpVWom/rP1BUnPTURoIo76MWEN559oKcksQmJJpOW91?=
 =?us-ascii?Q?D7pxyv7wh+UP4xXY8iClIrbGV/w5wUdlUyRdlt8Skm/LVDlGxd21yrlOrUZ2?=
 =?us-ascii?Q?/IDB0zCUjJeda7JRVnuYfverwbpdVqD4dNt/JcJK9SnlrtMFPptYwHKQakIA?=
 =?us-ascii?Q?K/cr+FnE6/LAqEeZd7qKkghi29S/5wz1d/lUd2eYCQumnCGFe2g/ufdQ7c5n?=
 =?us-ascii?Q?3UtOc4p+9KUmUuC/dYKzC950a6Re758BUxsE3/qYKRBX5I4eqcBkxZzg/cLs?=
 =?us-ascii?Q?J9YoZaDSn3SbyB+TGQEZS6GrBtZEgWgmBgXJlRFQQ15IKP81s8RXCTmuzQmA?=
 =?us-ascii?Q?O2NamaiLMu5sCmgnNScUWrNnGqCyOVTMcwIMrkcRV/iFJ0y08BUvmoybbCNj?=
 =?us-ascii?Q?noKlizo0kIP+5Wl/TETUba67aQJw0TTdUm0h9u2Cv2AEZpGG1Pg/bH4ADcUo?=
 =?us-ascii?Q?c2AGWP2PYfbfrrWJFhilWfLCcKzhZ/v4lpUOPMeCDA5Xr45rA+xVOMon3o0z?=
 =?us-ascii?Q?oj7ZPP/siipVtuMBIRsnly7ESQ8nKEIIJwgYMVihHA1LXexX7Ab6aR78559g?=
 =?us-ascii?Q?6Gpmdn/0sarTxVUpqowBU61IoqaLVZ7by16pizjY6w2CEtGh4fbTnjjTyQYH?=
 =?us-ascii?Q?309HMFFmz55RBStt/ilgkz3WTFSThuchxtDnzwNtmmE07/z0zT8Jc4VckSGX?=
 =?us-ascii?Q?X8aRsrz7XKrnpyVzh68p0EgtNVax0UN6hcn+kdBs//c7fggJQZIC+aTKZxWs?=
 =?us-ascii?Q?VXo18TWjCvR+koABc19Rwap3Nt043g8af6Dt?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(36860700013)(1800799024)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2025 12:43:08.3391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c215af4-0f23-400a-80ed-08dd84bfe5b8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5630

> Having said that, regardless of this proposal or the availability of kern=
el
> TPH support, a VFIO driver could enable TPH and set an arbitrary ST on th=
e
> MSI-X/ST table or a device-specific location on supported platforms. If t=
he
> driver doesn't have a list of valid STs, it can enumerate 8- or 16-bit ST=
s and
> measure access latencies to determine valid ones.
>=20
I tested enabling TPH inside a VM with setpci, it turned out that it doesn'=
t
write to TPH control register thankfully because vfio_pci_init_perm_bits()
in host kernel is not setting config write permissions for PCI_EXT_CAP_ID_T=
PH.=20

QEMU traps config writes and routes them via vfio_pci_write_config().
So, like how it already handles MSI/MSI-X enablement, TPH enablement
too could be handled by a special handler that does the following.
1. Error out on device specific mode enablement.
2. Check ST-table writes for STs that do not belong to CPUs the VM is bound=
 to.

Then for MSI-X mode, a Quirk could trap and check STs for the #2 case
above.
To make #1 above consistent with TPH cap register, some emulated bits can
be added to mask out availability of device specific mode.

--wathsala





