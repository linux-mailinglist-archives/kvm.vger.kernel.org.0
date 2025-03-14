Return-Path: <kvm+bounces-41018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9BAA60723
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 02:49:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8380D1897305
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 01:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D5D7081A;
	Fri, 14 Mar 2025 01:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ExTagKRW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ExTagKRW"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011052.outbound.protection.outlook.com [52.101.70.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8672943AB7;
	Fri, 14 Mar 2025 01:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741916980; cv=fail; b=Ef6ombZsN20BkH5tFulPsdZ1WBLjK1PqGhGtBvziDMC1zflEpFVHAxCe+A5MdxEjayPrJrTDik9pgNMQOxDf8ejtwcgbOhQZoXVelYW5SnIbryP4k/3bvsoRr1wcmjaZoc8qULODhIRbYR2Y1KFWtbJoNz7MgEB4uOIYqPQYyAY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741916980; c=relaxed/simple;
	bh=7Re03j3Sbayf758i5qz8eWDIXYw7XQ6/tEkzQYBJ6to=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FR2pEjIrIMPvyOAyNc3iIXDa0U9vT9rvpoOufCPk/GywKcMwbtlFtrO+QhjqrtEGMMu8gFxo2NLUyeRa4Vq/hH7mffK2U58HASf1xIm706+OrrTe4gKQokeBu2yJGrEH6/pX1e3WhhS2gyZ3zgGUbQ+0RO+hZ/AJ46yOUwNN68E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ExTagKRW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ExTagKRW; arc=fail smtp.client-ip=52.101.70.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ozWfYiZGfJ1KPmXFPcwlGpY5nyHWSt704z3rJ0ZHb9Jj13VEXqEcrpJZAyzWabV69EOKNQFOjDM80NdA4sGcn3Cm//GA5QDxtQRJnsjn85Au5pw+MyPasYCzCLHsY7cmXORYWv6cyx8HJR4xDWB01KxlJwvImhO6E4TUOYMYcluQkGDVpGHmcRa8a+P3/J+MGZaw4L19oncsGvi+VJTGl6EUThPbIdAX/97goBNk8xe0wGEG8F64X13kkvUdkZmDgMg3mvhEtO463l3btvR5h/vMaOuWRLCSiLpnKDf/m9GPgDyWKdPbOdqHxsGMt7Chi/W72I0rUGDXAFAZEeIT8w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m07BJeZ5BiFp7WsH2L7wyCxOhwfgkG7iorEBQ3xAaPw=;
 b=b7PT+JP7o+/i1bGE4lZjmANAh4LCcAHJl9Rv46eo1qhbM6WSpWF5GrN7KYJC3iCIhp6Cb/afDx8PniVyZH6G953Fbu/f0En+0MAFevZnyEJcYhP3+YX2QMSF/CeLu2Vfx6plBfIJf9nAc7QV3q4SMjDzWFxRR9MMMaFm0ZsxMoQaYT9N8zFg169uCtEOVXGxxbT59oPgPo0O94dKsCKGcxSl6mBHxcs+kfdXy4uioY9WXv4XLL9pXEv9dvBYSWGOegXDmA2ljyJKndtlzRjSRWEyECpo4T0I7QZAEmHU8ptEeP+ANiOOaq+t8dbhODz5JsRLymPnGdcUH1NbCW0dpA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m07BJeZ5BiFp7WsH2L7wyCxOhwfgkG7iorEBQ3xAaPw=;
 b=ExTagKRW7bQaCtlNURLh8CJKS6TkItEkVeqh6efXZATkopGDRGskJuC50sPApdY58NmywMa+hnynoK0veNV2pMqDiClaHRgzFDs5+TV2kdcs6w+yYEnmYOKqGBr+oullfBx/Cr70IdtHRQ0pBOiV93DyUfXWgrQAOjgRz5rt04U=
Received: from DU7P250CA0002.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:54f::15)
 by DU2PR08MB9961.eurprd08.prod.outlook.com (2603:10a6:10:494::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Fri, 14 Mar
 2025 01:49:30 +0000
Received: from DB5PEPF00014B9E.eurprd02.prod.outlook.com
 (2603:10a6:10:54f:cafe::15) by DU7P250CA0002.outlook.office365.com
 (2603:10a6:10:54f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.24 via Frontend Transport; Fri,
 14 Mar 2025 01:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5PEPF00014B9E.mail.protection.outlook.com (10.167.8.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.20
 via Frontend Transport; Fri, 14 Mar 2025 01:49:28 +0000
Received: ("Tessian outbound f89894bb7c0d:v594"); Fri, 14 Mar 2025 01:49:28 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d7511033f37636e1
X-TessianGatewayMetadata: U+ABToPwcP4aCa9bFs1Ke+OE/C6HPsw5S9S+UfGcoO5Uajr1R3kzdGoO9HwjN6pUzf6voc8XcmdjCBYvDYX8nP9FG/xJxhrtmoHh3mgPRSTRfts2oyJcQdRbOouDruuD2ZeLhsNB+S7XexrlxWNqt48pQeAb802MYWcS5LkbBkbKSvlGAjdzrCM/S4jYCfxqNAuIG5hdsXwTWykBn8+UWw==
X-CR-MTA-TID: 64aa7808
Received: from L85dd1ebe956e.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4357C608-6E21-4567-8AA9-95D62AFC74DE.1;
	Fri, 14 Mar 2025 01:49:21 +0000
Received: from DB3PR0202CU003.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L85dd1ebe956e.2
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Fri, 14 Mar 2025 01:49:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYLzQvxt7GLfnV7MGzT+yIPH/k3RQ400ZnjxWbyuDTum/HouczQ8fqoaUPUUbiDJ9fG2GJBisNnEj7WVPdF95uXB60v1knOKeYQyZanIWbNOOwRiC7WEOZYbEQs/Fi+t6l4082Mn+5zti+IOWFPkrgm3h7t5zibXREcIpktOP+KcX100tSWfTyDyIVZc9SBwYZ5VRVN3ucwAO47n5nDQqHS4Lt/HqsEycMhHJfP5Vgn9THK/2vCpmKn7VRq8EgcI/LFzNaE51Diy7HQL5HtPKFUhBIYjQRTpSux5mkVEBpj9VbHcOH0rHNky77tp0DPrkqSnCjvMS+7gAatR3TinHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m07BJeZ5BiFp7WsH2L7wyCxOhwfgkG7iorEBQ3xAaPw=;
 b=bXH4AUOYv4ASO7eaMT9R6YrhriFGqfo6yBBh2odT19TQ91VL2Z0jmJ74B4oSzEqP/cHWcmn2gqEFV9RcKAdopopzH50w0lZTUC2i9vVq9sNSQtwxFu46K/WO6pG7Z1B2ESzzGzu5EupXK7Tp2he6psM0zgi7cvmtyJxb9fRAbo6zA+yHSvgL8cQik7VB6FKu0TzdZXwBkimC5SnHz8hQVaG6RCanbQA32KIIh0Yq2+5SW3EM4s8xMUsz/B7yKTYiDwjcTmPt+Mx+Vl86wlz9JvzuMnNOuwsH9n1vSGP9uOgjsUl4/XP8l4fWkWSxVEM+v+vbencRmGIWyQxg411kzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m07BJeZ5BiFp7WsH2L7wyCxOhwfgkG7iorEBQ3xAaPw=;
 b=ExTagKRW7bQaCtlNURLh8CJKS6TkItEkVeqh6efXZATkopGDRGskJuC50sPApdY58NmywMa+hnynoK0veNV2pMqDiClaHRgzFDs5+TV2kdcs6w+yYEnmYOKqGBr+oullfBx/Cr70IdtHRQ0pBOiV93DyUfXWgrQAOjgRz5rt04U=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by AS2PR08MB10352.eurprd08.prod.outlook.com (2603:10a6:20b:578::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Fri, 14 Mar
 2025 01:49:18 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 01:49:18 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, nd <nd@arm.com>, Philipp Stanner
	<pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>, "open
 list:VFIO DRIVER" <kvm@vger.kernel.org>, Dhruv Tripathi
	<Dhruv.Tripathi@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index:
 AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGACAADH7gIAAQ1nQgAsppICAArg00A==
Date: Fri, 14 Mar 2025 01:49:18 +0000
Message-ID:
 <PAWPR08MB89092CC3B8587E9938CCAA0C9FD22@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250304141447.GY5011@ziepe.ca>
	<PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|AS2PR08MB10352:EE_|DB5PEPF00014B9E:EE_|DU2PR08MB9961:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b885b0c-b677-4811-2d9d-08dd629a7556
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?8z/uhD+zyxWnjgRanpab750SFOiB8whhpgOgzBe9Dz6Z7wfeT2Tu1MCvcmzC?=
 =?us-ascii?Q?lqlyQEPRepJ4Ca0ZTnUmVhlqdWqDUkwGpX5y7AuQSe/SmMOvFJ88KwIT3w/o?=
 =?us-ascii?Q?p2tOaZ9jpOoTcPZVAuPdPJsfn3yIh9V4OKmz1W5CtSLgor5SNcVtCplaGOLe?=
 =?us-ascii?Q?A16bUzzfPX6Lwrg1gkPLFZNx55O8elmXyX/5ia8BBjEPpYAXuKRz8GNlRbYs?=
 =?us-ascii?Q?CKa/x77wkUJcvgy11Q6ZA0C4M2cDAVaxCYUZ/VeLWy/e1kunaGUyU/QCMHKL?=
 =?us-ascii?Q?47tXwj0nnoNkNESEX29v5LlTQAdV9MUX1XxW7IdmwXvvwXN+tvS42CdrRbgq?=
 =?us-ascii?Q?f75duqtyVZwYOfwbd2zMr/9XxHEiuichgPeAcltGz6lZeUbD8AfVtjKfez0P?=
 =?us-ascii?Q?WxkzcF6oJbFjjnBGZ4Boxp7zpdwdmaVZSA8H/ZbS6U0MIAJHLc0ksYSlOZvb?=
 =?us-ascii?Q?Yd1qLccXX2nEI1QrKz9IepFlLXD80DNQX5iC5NBDspYax0GWeXRDItYMPQpJ?=
 =?us-ascii?Q?6u5QOcQaVcWOGk+DXKoiXHGAfhkr89yPcIBCUo97hfBS+zb0GQqhA0y8+8Nz?=
 =?us-ascii?Q?IuYeuKbiaFZS9KN202iWdhqhF/lwB9dUv+lqUiFhk/sZMqFNkgS6EL42R69M?=
 =?us-ascii?Q?iWdiUkzLDzwdQowr3nNII5i6FucCopTjVyBSQ09rVbVUPqm3wBO2uZmEqGsM?=
 =?us-ascii?Q?IDPryObhLCHsYQdnvys+70bC0/6uDiVLCCEtMwW7ABWo2o6/+BLf8xJn9g7T?=
 =?us-ascii?Q?cirVddZq37hl35JiCtx1xO+4woHftr0qfdvq4PXQEpbyc6wqlAOfJW/AwVcF?=
 =?us-ascii?Q?gET2t8WoXsgwJFJFAA4+aE1bJqsLdplxCLqKNBBN74WEqMte2tv49tzZnqgL?=
 =?us-ascii?Q?KN/fVIpNTLnfDcVsaw6GzWvhHty5YrAC4lytncbzTEby/Ea9DxLQzBWmdxL6?=
 =?us-ascii?Q?Nhj05GmXDVEec3Hec+8wREll92iCS3jF3ppiCISgRDmmVJGyFJb1x5bVva6p?=
 =?us-ascii?Q?rBV8opEMBcHzjlkFfCfcpdzzLYS5Z3Y07SXqiUa0GWCBqJDLuc56O0X0ZSk1?=
 =?us-ascii?Q?LVA6wAjlDvCCN3oNcK3ZepRYXi74X4Aemw1a/v2BY4M2Pqs5nfmAIj0tCtRf?=
 =?us-ascii?Q?yEdVOpu7mW1ph2yeM7WY4mNxIPPR2P80dIe20PO70ZI3qkjQ3eR4gFLYUmbP?=
 =?us-ascii?Q?V23j3V5QVrIHcJkZHgkDNDDlBNNlvQBz55opbVsrDc6P1i1il3ZbBuLWDYx7?=
 =?us-ascii?Q?mMCO+SYRp7Odd+tCFHu6wgisPDcZ10l0takXT7ciQirpJmrnlIqBCnfTfkyT?=
 =?us-ascii?Q?PpHG9ThF5mF1kD2ZCgIe9hs5YGIKOPiqWLrZ0bzX9CP3klCsn9q2m0kxHszw?=
 =?us-ascii?Q?yI6VQFbv5cfd/grl/98tHw2G2nRXZt/WaoWSBVHw4TEQC2ItniC0E8QsM8Ah?=
 =?us-ascii?Q?+fl6HuVZ7VphSkOKn7SL60WLT4kq7bua?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10352
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:102:33a::19];domain=PAWPR08MB8909.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f9ef7d40-611f-48b8-f913-08dd629a6f3f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|376014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FOKQCtmKULqsjpFIJShzGmDOAHSxXd+I9xGEzuw+CaUWtNRRVz3uxD1umCSP?=
 =?us-ascii?Q?N9lxif4/PmKnJpMwHhEtJvERirSHxTbndVcre3C5brTFmrmGH53W2XFKG5SY?=
 =?us-ascii?Q?LIeo0vQtvXKYipZgFv/aaHCvkzXsBlIMLuIGEpjr5cQAzlOj0DKrAIE72Ag2?=
 =?us-ascii?Q?Y/FQcSS3u67t7xPlcGP6Y7GLCl/jUTHGfmzlp1ZY7QNIjPhzjs9W0wUDDPIh?=
 =?us-ascii?Q?+A0fGgWN3kWsh4hEzRs+se4hKa7qjyxxKDlIuR1UO3UGJmIy/l6cMf0m+UGA?=
 =?us-ascii?Q?aexyV1JLI4iJkKdverWCFYwKGkexrGsxqP7pTX2wPg5Px3u3eeB5eJp3LT7D?=
 =?us-ascii?Q?xjd0h+S1c4fevPwEWw7KgeXCOC0Kfn3FwWcT6cTo2FIrkEUQvtbwmXMkV+uU?=
 =?us-ascii?Q?iMB6xkrIco6DLD0hxS4vKapWYRFl5xrCusuSU+jXvGvRVEWDjVrbuxnRJ4R7?=
 =?us-ascii?Q?bPuCx1E+z/mZLonjiQwsivvd7mKrUXs0O4B5+vUsx611R72347jsLPNwCuh4?=
 =?us-ascii?Q?OkRTM/ZUMvf1yx3U06+sQDbRGebUpbIN2Dl59J7r5J9YInnZN8BBdQ9mM+xK?=
 =?us-ascii?Q?j5LxoHcLLT4mHaUreAuXlyLHYdy7uuJlaYwbkzMP3vec+vl4Wq5BgSbEAEek?=
 =?us-ascii?Q?jj+hL44PX5Ht0NYl8FaRztvPNOjlp+ohtQqfkd+1W7f4agk+52wTvYPTMu7g?=
 =?us-ascii?Q?MSqrFKwHm9iGFEt0/j2qumTMlZKThdtbD/yzkpLdLA4IBPSV/kATKrv3rna0?=
 =?us-ascii?Q?jCSpmYUHDpTFae5t1LaLd5Oykj9teSWtHmJKJJNlaJ0rQx3g+LGic0mif+YF?=
 =?us-ascii?Q?+0JFc3dYiPcvoqOJwPGTnJNHKcony03XIITl7202XroFjBEaZFn5dms3bJxx?=
 =?us-ascii?Q?bzLU51qD1TMgDwqne+3QDpmOl2NW9C6kqVTJi1H9c90JRrM/83v55Bu8t+4R?=
 =?us-ascii?Q?LD3ctw2yB6AZqbdpNpuiS4LoDv7ZoN2BsHZ1GlRIy5/JjOfYKPkTXo4Ycm9l?=
 =?us-ascii?Q?n8Wp8Nit4pA6xaOQtGQbR/7rvxE6T3fyvCtHXeF4cc1TwnDIaB5YDEStVjKU?=
 =?us-ascii?Q?83kT03rgwxjFPOWVYxGzP4W2krHC/IcLz6W/Q6+HgKUVsBKfv7+RyIEcVAWB?=
 =?us-ascii?Q?KVWDRnCbTHC9ebSaLwd5/S6RgQgZ1vytDjzdA4DQVQyqhyZJlXj0yLAC/fRO?=
 =?us-ascii?Q?JVslCMV4pFgKA/ib0AT6ROUDjtOL1KrfH6NR2WqBD8X7SA29alpyWkZsHTgH?=
 =?us-ascii?Q?y/V10v1+zvgEHxjg1YF0sWq9VCBjjX7NK0CFzu+DFjQ9w/bsDXUFNumbAix2?=
 =?us-ascii?Q?yx/m5Yk8mNlOrBC6znuy9gyoPa0fvbBhi0pik6dNROTfxkLQVcnMOqywI25v?=
 =?us-ascii?Q?GaE9mKMcWBw8um7+JluJiLJIFjiE60WENAIbXUUGVvYyufXODcgCcN7TwQDQ?=
 =?us-ascii?Q?kx5UCmeyTyxnIuPKWw9BNEHw9pu+I6H3qO1bBUQ82wLSwdoL2hYDxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(376014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 01:49:28.7358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b885b0c-b677-4811-2d9d-08dd629a7556
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9E.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB9961



> -----Original Message-----
> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, March 12, 2025 2:53 AM
> To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>; Alex
> Williamson <alex.williamson@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>; linux-kernel@vger.kernel.org; nd
> <nd@arm.com>; Philipp Stanner <pstanner@redhat.com>; Yunxiang Li
> <Yunxiang.Li@amd.com>; Dr. David Alan Gilbert <linux@treblig.org>; Ankit
> Agrawal <ankita@nvidia.com>; open list:VFIO DRIVER <kvm@vger.kernel.org>;
> Dhruv Tripathi <Dhruv.Tripathi@arm.com>; Honnappa Nagarahalli
> <Honnappa.Nagarahalli@arm.com>; Jeremy Linton <Jeremy.Linton@arm.com>
> Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
>=20
> > From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> > Sent: Wednesday, March 5, 2025 2:11 PM
> >
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, March 4, 2025 7:24 PM
> > > To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
> > > Cc: Jason Gunthorpe <jgg@ziepe.ca>; linux-kernel@vger.kernel.org; nd
> > > <nd@arm.com>; Kevin Tian <kevin.tian@intel.com>; Philipp Stanner
> > > <pstanner@redhat.com>; Yunxiang Li <Yunxiang.Li@amd.com>; Dr. David
> > Alan
> > > Gilbert <linux@treblig.org>; Ankit Agrawal <ankita@nvidia.com>; open
> > list:VFIO
> > > DRIVER <kvm@vger.kernel.org>
> > > Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioc=
tl
> > >
> > > On Tue, 4 Mar 2025 22:38:16 +0000
> > > Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com> wrote:
> > >
> > > > > > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feat=
ure for
> > > > > > direct cache injection. As described in the relevant patch set =
[1],
> > > > > > direct cache injection in supported hardware allows optimal pla=
tform
> > > > > > resource utilization for specific requests on the PCIe bus. Thi=
s feature
> > > > > > is currently available only for kernel device drivers. However,
> > > > > > user space applications, especially those whose performance is
> > sensitive
> > > > > > to the latency of inbound writes as seen by a CPU core, may ben=
efit
> > from
> > > > > > using this information (E.g., DPDK cache stashing RFC [2] or an=
 HPC
> > > > > > application running in a VM).
> > > > > >
> > > > > > This patch enables configuring of TPH from the user space via
> > > > > > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user spa=
ce
> > > > > > drivers and VMMs to enable/disable the TPH feature on PCIe devi=
ces
> > and
> > > > > > set steering tags in MSI-X or steering-tag table entries using
> > > > > > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the ker=
nel
> > using
> > > > > > VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.
> > > > >
> > > > > What level of protection do we expect to have here? Is it OK for
> > > > > userspace to make up any old tag value or is there some security
> > > > > concern with that?
> > > > >
> > > > Shouldn't be allowed from within a container.
> > > > A hypervisor should have its own STs and map them to platform STs f=
or
> > > > the cores the VM is pinned to and verify any old ST is not written =
to the
> > > > device MSI-X, ST table or device specific locations.
> > >
> > > And how exactly are we mediating device specific steering tags when w=
e
> > > don't know where/how they're written to the device.  An API that
> > > returns a valid ST to userspace doesn't provide any guarantees relati=
ve
> > > to what userspace later writes.  MSI-X tables are also writable by
> >
> > By not enabling TPH in device-specific mode, hypervisors can ensure tha=
t
> > setting an ST in a device-specific location (like queue contexts) will =
have no
> > effect. VMs should also not be allowed to enable TPH. I believe this co=
uld
> > be enforced by trapping (causing VM exits) on MSI-X/ST table writes.
>=20
> Probably we should not allow device-specific mode unless the user is
> capable of CAP_SYS_RAWIO? It allows an user to pollute caches on

Sounds plausible.=20

> CPUs which its processes are not affined to, hence could easily break
> SLAs which CSPs try to achieve...
>
> Interrupt vector mode sounds safer as it only needs to provide an
> enable/disable cmd to the user and it's the kernel VFIO driver
> managing the steering table, e.g. also in irq affinity handler.
>=20
> >
> > Having said that, regardless of this proposal or the availability of ke=
rnel
> > TPH support, a VFIO driver could enable TPH and set an arbitrary ST on =
the
> > MSI-X/ST table or a device-specific location on supported platforms. If=
 the
> > driver doesn't have a list of valid STs, it can enumerate 8- or 16-bit =
STs and
> > measure access latencies to determine valid ones.
> >
>=20
> PCI capabilities are managed by the kernel VFIO driver. So w/o this
> patch no userspace driver can enable TPH to try that trick?

Yes, it's possible. It's just a matter of setting the right bits in the PCI=
 config
space to enable TPH on the device.

Thanks=20
--wathsala


