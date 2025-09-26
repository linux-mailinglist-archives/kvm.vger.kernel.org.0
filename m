Return-Path: <kvm+bounces-58842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1A0BA23E3
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 04:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2735F1C22620
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 02:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7971FDE19;
	Fri, 26 Sep 2025 02:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m93Xlssp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m93Xlssp"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011065.outbound.protection.outlook.com [52.101.70.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EDD17996
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 02:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758855026; cv=fail; b=CuJk5h3lopjzvjSk0zcgiotIJmWyCmgPsMvHopkRsnD0PW4mglFHB83Pm1tMr58ttl8eVm4T7Ymc44F/IHaf/iA/nozjiQgu+nysFO1yL6ki4B5F0BmBhIyJFeEfAKTVyhg8jhGXRMAKSaiwAKXYybwtGJt6pYBwwqMdcNElDMY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758855026; c=relaxed/simple;
	bh=Pv0nYqL0pJF7QSlNO6IOOGruTD338WWiyrcfGzGhLXE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KgggyE9xFZbz+xp+qz+TTUHTGaZ6IKuGnOdQtvfSGc2KzSDm/mQGXO2arbV3gYEE/KbzKdEh6E+PswanllOAy8cdtfvaXZA4qcNfwjZVLcnWM0uqxDGLITV+gkHiqetxAnoe5w8T9bYQ0JGfzPHCmEjQp8zI44rP7D9eaRjvOrE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m93Xlssp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m93Xlssp; arc=fail smtp.client-ip=52.101.70.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sGatxUnd/POAYbj96qWN/E+S35L2CHnMDvcIBzuC1TXqF84XKsKVOp2WkBPYG0NwnBYVidxKx0sg44GRcH6gwGYgEeFe6mnOTrpBigH2OCOPnwNQ+5naz5dq196GJixH+yoj83rkNWdEgB33l4ARfMbN6qSASvl2jiUOhrc3Pl2gPAeMnn6OE5pGdRA7t1WFh7nf29PyV+UNyF3EI836oyucfOJyJfscFqpVQl8Cio82MKzgK1M4XWTa535UXNWQK7fQuyFFWojD1HRVBucRIpDtIalKRdYzndTBUKtxjjPRCMHF5IwvSCPVtPVyXqVjeKDvs9XUuHq4uOj+r3K8zQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv0nYqL0pJF7QSlNO6IOOGruTD338WWiyrcfGzGhLXE=;
 b=oQuvVnEv0ly732qjsUYjQV3iPvi2NziAauuVZeAQWoreuNFRdyAxy/uevfn91TEnDjgoJa0UFCMzmYWPO5KK8hxxPHq2VjI8Hzt7P0f7jrtsASXHQdeRw9+168ToLWhjoq7VUhTjs2XpMV4z+e0qL7gsbB4fVyPSWEROB8svJWH+9g15C488JzO0ziNlHA9/lHx8CP1Jqi/dg1mJCWboAi14OJUVVhXC4ZObMh13s7jkuCMlX0gyPP2IH3duGfjfjfmztOFb7XZJ1ns3Xs+44h+5DgTBKp2hGPE93dicQW6I1AakQwymf1iDIa/5KItT6A14/mB4YQwRGEr1OAVZMg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv0nYqL0pJF7QSlNO6IOOGruTD338WWiyrcfGzGhLXE=;
 b=m93Xlssps3eJjvyP3MbuLlM7gM1LVlW4jnFTMlk0ELmxDMbf1lDfMr0zRAMuVckd/ls9YCjI2sHzCX+JfOdtyZntI7nJdXHeDk+WGcU5J1KcIkbQ0gVcHwhD9k5mWNPS2wZSatPLoFjWss1uMBcqtMI9KeqxTyySVtLy8I2szNI=
Received: from DB8PR04CA0007.eurprd04.prod.outlook.com (2603:10a6:10:110::17)
 by DB9PR08MB8337.eurprd08.prod.outlook.com (2603:10a6:10:3de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Fri, 26 Sep
 2025 02:50:17 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:110:cafe::ce) by DB8PR04CA0007.outlook.office365.com
 (2603:10a6:10:110::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.10 via Frontend Transport; Fri,
 26 Sep 2025 02:50:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.9
 via Frontend Transport; Fri, 26 Sep 2025 02:50:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQO/CoZKexAmd+n055634maBhTb1IPkN0S24je5US9G2TsnepMQvGFGzs9aLDAp5ZFCyq0uHTXAnTZUnDiBvMY3HVZG0lAZk5m6m15mxIcYnWU4ZZfGx7YrBzcw4CxRc9ZJ5xpwdDcTJ48UKAOZLdYan9nUBFJRzGFvXoAAfJ9yKpweGJOTQdM4y5ZpL9alVgJLONw1COfkWPNTlBFbDfmN74aairulcYDwRf5cYcyjJERexB789B/SyuJs6iZVUwI1yuaUmYEr+RKHXdomoQ3SOg2SRhBcljQb87Ab5xTxatzteb5G8JKyrHkO1Q0OZNnllO1QfTVj1Cno/BGV8GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv0nYqL0pJF7QSlNO6IOOGruTD338WWiyrcfGzGhLXE=;
 b=UJyUsLD8zJkRc2bo3ShlwYKYc1Ao0uH+fTnbyl0XoaO1tEXIpjuX2O1cpH+J0NWgleswN1jlRMLKF93i/+kfYvdexQ9psZ859GIJSBiGfEC9xi2CwvuawV0Oj1wF9jASiDPNlxd7iG5CzE3BczgoxrHVlXaef2TuPPbpOR8I4poRuCm2SaZniS+bhz8ePIKrCrMT4r5d4qTJPx5NWDHK2nyWxjaLzLdXHjpOGfQpX2fkDmZRM5UigJw0tR5nf8OK+a0O1Cr/AKC+TZF/rkZR11UQJZRWidpFjGgyzSV3Bdh4INz1lEuDTcmEcnzT3r0QGzzJCF5E9M2uzCDrHVNDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv0nYqL0pJF7QSlNO6IOOGruTD338WWiyrcfGzGhLXE=;
 b=m93Xlssps3eJjvyP3MbuLlM7gM1LVlW4jnFTMlk0ELmxDMbf1lDfMr0zRAMuVckd/ls9YCjI2sHzCX+JfOdtyZntI7nJdXHeDk+WGcU5J1KcIkbQ0gVcHwhD9k5mWNPS2wZSatPLoFjWss1uMBcqtMI9KeqxTyySVtLy8I2szNI=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by GV1PR08MB8403.eurprd08.prod.outlook.com (2603:10a6:150:8a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 02:49:39 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 02:49:39 +0000
From: Wathsala Vithanage <wathsala.vithanage@arm.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "pstanner@redhat.com" <pstanner@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: Re: [RFC PATCH v3 1/1] vfio/pci: add PCIe TPH device ioctl
Thread-Topic: [RFC PATCH v3 1/1] vfio/pci: add PCIe TPH device ioctl
Thread-Index: AQHcJzNBRkXO3TKbRkWI3eiwLHBU6bShGqiAgAO3VoA=
Date: Fri, 26 Sep 2025 02:49:39 +0000
Message-ID: <8f4097bcffaafcf65ec9ee3b709bfc6d70d076e1.camel@arm.com>
References: <20250916175626.698384-1-wathsala.vithanage@arm.com>
	 <20250923180439.GG2547959@ziepe.ca>
In-Reply-To: <20250923180439.GG2547959@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|GV1PR08MB8403:EE_|DB1PEPF000509FC:EE_|DB9PR08MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: 440705d4-15f2-4df4-85c2-08ddfca76c40
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cGtWbEIyTVNKUFZEVGU5Mk4wUUhQUko2QjdmZnd3bG0vQ2k0eUNCQ1ZlT0ZK?=
 =?utf-8?B?RjUvdkVpQWZBblVNV3pNbUxvM2VNb21CLzI5OHFyRjgxU0ZTVUtDZmNVUllZ?=
 =?utf-8?B?SWtYZTlKT0ZjZDhtbTg4SFpsMmRMQUhLSzBOMnQyTHVKbG14TFY3LzNKMG9B?=
 =?utf-8?B?OC8wdEp5cXl3VzdzckNjSHpOUDhFVGk0UGx5djN2VTdVbHpHWXRXRTEzaG9n?=
 =?utf-8?B?QkNkc1Y4LzE2M2hMS2FFREx0bW4wNFF6Q01yRit0QWN4VHJ4S0ZTWm9mZjNi?=
 =?utf-8?B?UEN5a0habloyQTU4RFJaT2laZi9WTGhwd0VrcjRXZnpYYkE4VHNXenZvOTBS?=
 =?utf-8?B?SzFIdzJWTHhBWE1hWFM5Vk55L01uZ1NZQ2U0bU16VzMrT2ZKVXdrWlk0WERp?=
 =?utf-8?B?VGdDd0VTSnE5VDJMdEpWTktYSkNiSWpFOUxzUGNQVk1FVWVWeklaMWxBekVw?=
 =?utf-8?B?QW14aEtYbUJrS2FtcGpyMGk3MHJrbzBXd1dGQyszZWxrRUJSUkFrNktBMFRo?=
 =?utf-8?B?ZEVzU2JoRjlEcGVGNTFQTVZEZDZTck9pYURmRHpTOThqS0tEeVJsV3plajF1?=
 =?utf-8?B?a0hBeCtnYXR5dUMzcUQ1RmpPL1daOGVYUVlGQmcxNXZQdU9aSlB0WndhK3JI?=
 =?utf-8?B?WXRFTGZvK0xyRE56cTFjL1MwRXBucWhIQkVDNThxdHNTVlkveVV1TXhWUytW?=
 =?utf-8?B?RHNBdk5PcVo4M3VpYzZOTU9teTBhTklMOWQ1K3FQM1V2K25uQkpHVk9PUlJh?=
 =?utf-8?B?RHJ4U3dPNmoxTlFUaGV3TjIwUnkxYlRXSFFQbUZQY0dnMW80UXE0LzVNTS9v?=
 =?utf-8?B?VG5LQnNhUGxoeHljcjFuUnJKME9CZEI5RXZaUW9vQW1WaE5uS3h2T1FXRHYy?=
 =?utf-8?B?ZExrUm1SQzVwVVFzZmprdUdTeWkyTHMvUkF2QzYwVDRXQWRCS05kaWpGYWNh?=
 =?utf-8?B?MWxBNHJoT2h3SVE4TFBuMlVrbFMxVm9hL1ZId1hSSzlyYkZDRHE3SGF0MVcy?=
 =?utf-8?B?Q0t4K3VTMVdDS29XZjRnL1oySHp1d0ttRmJiZlg1dFFnWmRPeVlOdmNkMXFS?=
 =?utf-8?B?SVpXSnBtOERhbjQ4WGl6TGE2NktUcUhEMmpycUQ1NXBVMnUyWGJnOTlEdngw?=
 =?utf-8?B?b3lzcW1qTTdZNGUzbWd1LzNJQjFVNHI1Rzd5MWh6ZWVOQ1kvdGtkNXZhSWQ2?=
 =?utf-8?B?WFlGWU40NUtCa1JXd3NNZUVFZmJVaVZaVzBzTjVCcXAyenN6SE4yWHlyNHRN?=
 =?utf-8?B?TEVacExnUldYWkVzZ3pocVM5Y3d4VTJWNUV3Y3V3cHhlcCtHUTZkL2FIZUpY?=
 =?utf-8?B?b3QwTENNRExYOGhSY0tHTS95N3ZuK1FwZHIxRHR4eExnNi96Yi9mcTBBNCtJ?=
 =?utf-8?B?dm1kazdmb0sxSFFlUVlIejQxV0dlUEcrOFVMQW5qZytPMHRsemZkMDc0czlx?=
 =?utf-8?B?R2Z1bkU0Y2EyZ3JidnRKRTdxRGVKZmhsb29hZUl0UFhhYmFkamZJdXdtcGdT?=
 =?utf-8?B?US9Na3VNeC9hSEFkdWZUK2dReVNyVTZESi9xM0lLeDE0dGNieVRrR1l0U0lY?=
 =?utf-8?B?T1lDbGdScUNQZlNud04ra3ZvU3FDYm5HTjJWaWxVMmFSU25DVkZXNTloUHM0?=
 =?utf-8?B?UFIrQ2JMY2taSG92dUh6aGQ4Q24wNlZKUUw2ckc4d0NVbzJJK0xTUFg2RGQv?=
 =?utf-8?B?bnlubFI1RGRPczhRd0lYR0ErbnRNcVdkcUlYSWJ0UjZwS0Uvc3dIY21Yam1l?=
 =?utf-8?B?WHNrOG1TR0M1RUdLY21UUmMxVVVSMXZKSVcvMGZOQmNGd3NsVTlDR2ZCZytI?=
 =?utf-8?B?WUZoT21MR3NBTTgva25xVm1iUWdGSExBaWREVVNQaE5heWN6bG8zUkY1ZXhN?=
 =?utf-8?B?MDV6OG5RRkZDZGR5ZHJmbXlHRDFBMnMzTDN5S0p6YVdaVzNoZUNXeDYvN2VM?=
 =?utf-8?B?WG90U1d2Z2tCODVCSDhyV1pKaHZoMElDQmJLeWVwTmhVSjNHcHlUb1UrV3BF?=
 =?utf-8?Q?1qR9rSZS330O+0aKM2aZbuRqoekHUA=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <38EF4FB10384CF44B86631715238F0E2@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c711b48b-6d03-4c61-0817-08ddfca75669
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|82310400026|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXp2UXFHUW5SQmh0TE8xRmFueHpNWlA0TUQ3WTBSV1lQdkVEMktMRWJqM2lM?=
 =?utf-8?B?SXdRM3ZjVys5V1RKK3FRYkRzUWFNZmUvMEI4bFVNQ2UrVnIxTldKUFlDenpR?=
 =?utf-8?B?dGNWTzZtd1lWS0pHV3J6WHVYdTkzTTYyVFc2MWFqSUNHVTdlMW1SWWlSVUlC?=
 =?utf-8?B?YklmTVpMellCNVBiQkNwRzhZVlNsRmlwbC9Wek0xc3pDYWxvSjRJbVAwS3lY?=
 =?utf-8?B?TWRjWjJuY0VoQmJUeCtSWjltZ2wxUkJLeTdPZ3VGSms4MnZhMHo0QkZVYmla?=
 =?utf-8?B?ZTFMbjFYWWFvT09kWEhMenBLb1JhMzZjR1JaWWptMzFZTStOYlFvTHR2cjNI?=
 =?utf-8?B?M01OeE5hdTlyaDhkZ2w0bmtPTzk5RzJSR1BhaCtVbnNVU1BWcVhxTGxUMXBC?=
 =?utf-8?B?eG9iVDhzTk4zT2FNd1NNc1ZpTHZpT29kWlB2eW5yWndsdU5JcTlzb0Z2KzZa?=
 =?utf-8?B?RWM4d3Z2aWFYZGM3dFVVNkVrb1RxL0ZiYWdCd2hLQVBHQXBDRlQrMkx4dXJG?=
 =?utf-8?B?amZ5TFh2dWV6MDlOdCs2WjJod1QvWkZhWXRDUkN4bkxpSkF0ZVBwNlhUeXpW?=
 =?utf-8?B?YUNjZTVCalVpbEZWcXNUUUdmbVhNcEtVUm9BZW5IcGZnZTJaQTQwVTNJTldJ?=
 =?utf-8?B?N0JORmFOQjc5cnU1aDY0L1V6R0h6N1ROT0V6emZVa0FnbkFMSDFTRzYrT3Ez?=
 =?utf-8?B?Y2hWTmNYclFRbklleUdQK1VjZ2Zsdlo0cVladzZxSWlsZytITHFFTG5QNzM0?=
 =?utf-8?B?MGYyMUZqaWo5Um5DUXJRNk54MStqYitzQ0RES2Z6WTUwK1RQMktEbFVhZ3Zs?=
 =?utf-8?B?Snc2aUcyMzdHbkpCZ0VEWnA2MmRJU01hakNROXNPMHN2eElQR2lzVFpULzJx?=
 =?utf-8?B?Umw5OGZBc2puS2lJZ01TSC9UY2xpcTUyN2F6QlR0RksydEJCbDVPdkQ2Sldx?=
 =?utf-8?B?Z3U2LzJPcFY1YUt2VE1KeGF6emVDN2Jhd21iQXpYYkJRQkV3ZkVyTlBCR281?=
 =?utf-8?B?c2xVdDdWYWpYV2xKYThib3dzbTF4Vkprc0gzUmJqa0VqSExwSVhFemc4UUVQ?=
 =?utf-8?B?aW9YYWRZbEtXcGNzMU1kL0JMMlpheXVXeXRuamU3SjZjaVFTVndoVTgwd2pi?=
 =?utf-8?B?MUJnTGNaOW5TZjVZTE9XTlY4NmJ4dlArb0ZlOVROY24vQ3BkWU5PMjR2anly?=
 =?utf-8?B?RTlNbXhDYVE2S3dsN3Y4Z2xqRjdRNXdQMHZmcDJSNG9TbXY4bW1KRGhPNEcv?=
 =?utf-8?B?SHRaWG1MdG1zYTFSalR0UGk3Ly9hSGdNRi9UOE5lc3lISk9WRUtQWHZ2RUlP?=
 =?utf-8?B?UWROSlpyV000eUdXZjI1SHhQYURrZHBOSC8vbVF2L01NenZoWVk2S3FTZ3Zq?=
 =?utf-8?B?NFBhblk2VnRsbEg3LzdWTU9Lbkh0cXRuUENKQ1BVUVI0aCtUeDVOR04xRTR3?=
 =?utf-8?B?dVVrd2VYb2pKRytQSzU0bkt1N3JhTFVvVDJzQW13M0NMb3VwaXdpRGtzak9w?=
 =?utf-8?B?WGlJVDNoeFErV0d4M0RsUjRBTTZESjMrcE1GNGJGVUR1WWFUYzNTWkhpSmZq?=
 =?utf-8?B?RWtlSkRSUHI0Mk9RMjU5NU0yVVpDYlV4cXA4cHpVbEhzVlpSYVVjdS9IZnpy?=
 =?utf-8?B?c1N2dm9pMjMxUmlaWjJRc1BXcDU4Z0lpOVZjcUFEZ2NZQXlXQWw3TUlmOFB6?=
 =?utf-8?B?ZUwxenpsc25RUWxYa01vL2ZuMklncmZpV0pZZzNaQ0I4K3JIWUJaUXdoYWxK?=
 =?utf-8?B?SjErZlQ2NVBDaWdQK2M3MEk0SkFCYld1NWV5clRrc3hjSzY5c1IrSlFUU28r?=
 =?utf-8?B?L2xiTXZYWTRzbE9SYmQxMjM0ZGQ1NnBKc1pHQW9KWkhZckluWWZpdVBCVno3?=
 =?utf-8?B?SSs2RUhuSEFQOTNSVTc4U3RtUGlNQWhpeHpKcEk1Q05EOWZiUkY1bU9uN1Fk?=
 =?utf-8?B?MWtyTlhXL1FNUzRTUmRRQUt2SHdKUFJaVVgyRlQ2N2Fvc29uZ05mS29pNFcx?=
 =?utf-8?B?RUdhM0dDVENhMTBObkE0SHRsV2hBR3NUbXFLQXBsOVBUSEpvOHkwUFFhcVFV?=
 =?utf-8?B?WmgwQVFnRnhLaG5KQ082V05FaWxEZEtqMlBoVFRLOEsycjZmekZOV2ZkMUJy?=
 =?utf-8?Q?C2qU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(82310400026)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 02:50:16.1309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 440705d4-15f2-4df4-85c2-08ddfca76c40
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8337

VGhhbmtzIEphc29uLCBJIHdpbGwgYWRkcmVzcyB0aGVzZSBjb21tZW50cyBpbiBWNC4gQmVsb3cg
SSBoYXZlIHNvbWUNCnF1ZXN0aW9ucyBmb3IgeW91Lg0KDQoNCj4gVGhpcyBzaG91bGQgY2hlY2sg
dGhlIHByb2Nlc3MgaGFzIGFjY2VzcyB0byB0aGUgZ2l2ZW4gQ1BVOg0KPg0KPiAgICAgICAgICAg
ICAgICAgaWYgKCFjcHVtYXNrX3Rlc3RfY3B1KGNwdV9pZCwgY3VycmVudC0+Y3B1c19wdHIpKSB7
DQo+DQo+ID4gKyAgICAgICAgICAgbXR5cGUgPSAoZW50c1tpXS5mbGFncyAmIFZGSU9fVFBIX01F
TV9UWVBFX01BU0spDQo+ID4gPj4NCj4gPiArICAgICAgICAgICAgICAgICAgIFZGSU9fVFBIX01F
TV9UWVBFX1NISUZUOw0KPg0KPiBXaHkgdGhpcyB3ZWlyZCBlbmNvZGluZyB3aXRoIGZsYWdzPyBK
dXN0IGdpdmUgaXQgYSBub3JtYWwgbWVtYmVyLg0KPg0KPiA+ICsvKioNCj4gPiArICogVkZJT19E
RVZJQ0VfUENJX1RQSCAgICAgLSBfSU8oVkZJT19UWVBFLCBWRklPX0JBU0UgKyAyMikNCj4gPiAr
ICoNCj4gPiArICogVGhpcyBjb21tYW5kIGlzIHVzZWQgdG8gY29udHJvbCBQQ0llIFRMUCBQcm9j
ZXNzaW5nIEhpbnRzIChUUEgpDQo+ID4gKyAqIGNhcGFiaWxpdHkgaW4gYSBQQ0llIGRldmljZS4N
Cj4gPiArICogSXQgc3VwcG9ydHMgZm9sbG93aW5nIG9wZXJhdGlvbnMgb24gYSBQQ0llIGRldmlj
ZSB3aXRoIHJlc3BlY3QNCj4gPiB0byBUUEgNCj4gPiArICogY2FwYWJpbGl0eS4NCj4gPiArICoN
Cj4gPiArICogLSBFbmFibGluZy9kaXNhYmxpbmcgVFBIIGNhcGFiaWxpdHkgaW4gYSBQQ0llIGRl
dmljZS4NCj4gPiArICoNCj4gPiArICogICBTZXR0aW5nIFZGSU9fREVWSUNFX1RQSF9FTkFCTEUg
ZmxhZyBlbmFibGVzIFRQSCBpbiBuby0NCj4gPiBzdGVlcmluZy10YWcsDQo+ID4gKyAqICAgaW50
ZXJydXB0LXZlY3Rvciwgb3IgZGV2aWNlLXNwZWNpZmljIG1vZGUgZGVmaW5lZCBpbiB0aGUgUENJ
ZQ0KPiA+IHNwZWNmaWNpYXRpb24NCj4gPiArICogICB3aGVuIGZlYXR1cmUgZmxhZ3MgVFBIX1NU
X05TX01PREUsIFRQSF9TVF9JVl9NT0RFLCBhbmQNCj4gPiBUUEhfU1RfRFNfTU9ERSBhcmUNCj4g
PiArICogICBzZXQgcmVzcGVjdGl2ZWx5LiBUUEhfU1RfeHhfTU9ERSBtYWNyb3MgYXJlIGRlZmlu
ZWQgaW4NCj4gPiArICogICB1YXBpL2xpbnV4L3BjaV9yZWdzLmguDQo+ID4gKyAqDQo+ID4gKyAq
ICAgVkZJT19ERVZJQ0VfVFBIX0RJU0FCTEUgZGlzYWJsZXMgUENJZSBUUEggb24gdGhlIGRldmlj
ZS4NCj4gPiArICoNCj4gPiArICogLSBXcml0aW5nIFNUcyB0byBNU0ktWCBvciBTVCB0YWJsZSBp
biBhIFBDSWUgZGV2aWNlLg0KPiA+ICsgKg0KPiA+ICsgKiAgIFZGSU9fREVWSUNFX1RQSF9TRVRf
U1QgZmxhZyBzZXQgc3RlZXJpbmcgdGFncyBvbiBhIGRldmljZSBhdA0KPiA+IGFuIGluZGV4IGlu
DQo+ID4gKyAqICAgTVNJLVggb3IgU1QtdGFibGUgZGVwZW5kaW5nIG9uIHRoZSBWRklPX1RQSF9T
VF94X01PREUgZmxhZw0KPiA+IHVzZWQgYW5kDQo+ID4gKyAqICAgcmV0dXJucyB0aGUgcHJvZ3Jh
bW1lZCBzdGVlcmluZyB0YWcgdmFsdWVzLiBUaGUgY2FsbGVyIGNhbg0KPiA+IHNldCBvbmUgb3Ig
bW9yZQ0KPiA+ICsgKiAgIHN0ZWVyaW5nIHRhZ3MgYnkgcGFzc2luZyBhbiBhcnJheSBvZiB2Zmlv
X3BjaV90cGhfZW50cnkNCj4gPiBvYmplY3RzIGNvbnRhaW5pbmcNCj4gPiArICogICBjcHVfaWQs
IGNhY2hlX2xldmVsLCBhbmQgTVNJLVgvU1QtdGFibGUgaW5kZXguIFRoZSBjYWxsZXIgY2FuDQo+
ID4gYWxzbyBzZXQgdGhlDQo+ID4gKyAqICAgaW50ZW5kZWQgbWVtb3J5IHR5cGUgYW5kIHRoZSBw
cm9jZXNzaW5nIGhpbnQgYnkgc2V0dGluZw0KPiA+IFZGSU9fVFBIX01FTV9UWVBFX3gNCj4gPiAr
ICogICBhbmQgVkZJT19UUEhfSElOVF94IGZsYWdzLCByZXNwZWN0aXZlbHkuDQo+DQo+IEknbSBu
b3Qgc3VyZSBpZiB0aGUgTVNJLVggbW9kZSBpcyByZWFsbHkgc2FmZSB0byBleHBvc2UgdG8NCj4g
dXNlcnNwYWNlLi4gSSB0aG91Z2h0IHRoZSBoYWNrIHdhcyBzb3J0IG9mIE9LIGlmIGl0IHdhcyB1
c2VkIHdpdGggYQ0KPiBjby1vcGVyYXRpbmcgZHJpdmVyIHRoYXQgZGlkbid0IHRyeSB0byBjb25j
dXJyZW50bHkgbWFuaXB1bGF0ZSB0aGUNCj4gc3RlZXJpbmcgdGFncy4NCg0KRG8geW91IHByZWZl
ciBndXR0aW5nIHRoaXMgY29tcGxldGVseSBvciBzeW5jaHJvbml6aW5nIGFjY2Vzcz8NCg0KPg0K
PiA+ICsgKiAtIFJlYWRpbmcgU3RlZXJpbmcgVGFncyAoU1QpIGZyb20gdGhlIGhvc3QgcGxhdGZv
cm0uDQo+ID4gKyAqDQo+ID4gKyAqICAgVkZJT19ERVZJQ0VfVFBIX0dFVF9TVCBmbGFncyByZXR1
cm5zIHN0ZWVyaW5nIHRhZ3MgdG8gdGhlDQo+ID4gY2FsbGVyLiBDYWxsZXINCj4gPiArICogICBj
YW4gcmVxdWVzdCBvbmUgb3IgbW9yZSBzdGVlcmluZyB0YWdzIGJ5IHBhc3NpbmcgYW4gYXJyYXkg
b2YNCj4gPiArICogICB2ZmlvX3BjaV90cGhfZW50cnkgb2JqZWN0cy4gU3RlZXJpbmcgVGFnIGZv
ciBlYWNoIHJlcXVlc3QgaXMNCj4gPiByZXR1cm5lZCB2aWENCj4gPiArICogICB0aGUgc3QgZmll
bGQgaW4gdmZpb19wY2lfdHBoX2VudHJ5Lg0KPiA+ICsgKi8NCj4gPiArc3RydWN0IHZmaW9fcGNp
X3RwaF9lbnRyeSB7DQo+ID4gKyAgIC8qIGluICovDQo+ID4gKyAgIF9fdTMyIGNwdV9pZDsgICAg
ICAgICAgICAgICAgICAgLyogQ1BVIGxvZ2ljYWwgSUQgKi8NCj4gPiArICAgX191MzIgY2FjaGVf
bGV2ZWw7ICAgICAgICAgICAgICAvKiBDYWNoZSBsZXZlbC4gTDEgRD0gMCwNCj4gPiBMMkQgPSAy
LCAuLi4qLw0KPg0KPiBOb3RoaW5nIHJlYWRzIGNhY2hlX2xldmVsID8NCj4NCj4gPiArICAgX191
OCAgZmxhZ3M7DQo+ID4gKyNkZWZpbmUgVkZJT19UUEhfTUVNX1RZUEVfTUFTSyAgICAgICAgICAg
ICAweDENCj4gPiArI2RlZmluZSBWRklPX1RQSF9NRU1fVFlQRV9TSElGVCAgICAgICAgICAgIDAN
Cj4gPiArI2RlZmluZSBWRklPX1RQSF9NRU1fVFlQRV9WTUVNICAgICAgICAgICAgIDAgICAvKiBS
ZXF1ZXN0IHZvbGF0aWxlDQo+ID4gbWVtb3J5IFNUICovDQo+ID4gKyNkZWZpbmUgVkZJT19UUEhf
TUVNX1RZUEVfUE1FTSAgICAgICAgICAgICAxICAgLyogUmVxdWVzdCBwZXJzaXN0ZW50DQo+ID4g
bWVtb3J5IFNUICovDQo+ID4gKw0KPiA+ICsjZGVmaW5lIFZGSU9fVFBIX0hJTlRfU0hJRlQgICAg
ICAgICAgICAgICAgMQ0KPiA+ICsjZGVmaW5lIFZGSU9fVFBIX0hJTlRfTUFTSyAgICAgICAgICgw
eDMgPDwNCj4gPiBWRklPX1RQSF9ISU5UX1NISUZUKQ0KPiA+ICsjZGVmaW5lIFZGSU9fVFBIX0hJ
TlRfQklESVIgICAgICAgICAgICAgICAgMA0KPiA+ICsjZGVmaW5lIFZGSU9fVFBIX0hJTlRfUkVR
U1RSICAgICAgICAgICAgICAgKDEgPDwgVkZJT19UUEhfSElOVF9TSElGVCkNCj4gPiArI2RlZmlu
ZSBWRklPX1RQSF9ISU5UX1RBUkdFVCAgICAgICAgICAgICAgICgyIDw8IFZGSU9fVFBIX0hJTlRf
U0hJRlQpDQo+ID4gKyNkZWZpbmUgVkZJT19UUEhfSElOVF9UQVJHRVRfUFJJTyAgKDMgPDwgVkZJ
T19UUEhfSElOVF9TSElGVCkNCj4gPiArICAgX191OCAgcGFkMDsNCj4gPiArICAgX191MTYgaW5k
ZXg7ICAgICAgICAgICAgICAgICAgICAvKiBNU0ktWC9TVC10YWJsZSBpbmRleCB0bw0KPiA+IHNl
dCBTVCAqLw0KPiA+ICsgICAvKiBvdXQgKi8NCj4gPiArICAgX191MTYgc3Q7ICAgICAgICAgICAg
ICAgICAgICAgICAvKiBTdGVlcmluZy1UYWcgKi8NCj4NCj4gSSBkb24ndCBrbm93IGlmIHdlIHNo
b3VsZCBsZWFrIHRoZSBIVyBzdGVlcmluZyB0YWcgdG8gdXNlcnNwYWNlPz8NCg0KQWdyZWUsIHdl
IGRpc2N1c3NlZCB0aGlzIGluIFYxLiBJIHdpbGwgZHJvcCBWRklPX0RFVklDRV9UUEhfR0VUX1NU
Lg0KDQo+DQo+ID4gKyAgIF9fdTggIHBoX2lnbm9yZTsgICAgICAgICAgICAgICAgLyogUGxhdGZv
cm0gaWdub3JlZCB0aGUNCj4gPiBQcm9jZXNzaW5nICovDQo+ID4gKyAgIF9fdTggIHBhZDE7DQo+
ID4gK307DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgdmZpb19wY2lfdHBoIHsNCj4gPiArICAgX191MzIg
YXJnc3o7ICAgICAgICAgICAgICAgICAgICAvKiBTaXplIG9mIHZmaW9fcGNpX3RwaA0KPiA+IGFu
ZCBlbnRzW10gKi8NCj4gPiArICAgX191MzIgZmxhZ3M7DQo+ID4gKyNkZWZpbmUgVkZJT19UUEhf
U1RfTU9ERV9NQVNLICAgICAgICAgICAgICAweDcNCj4gPiArDQo+ID4gKyNkZWZpbmUgVkZJT19E
RVZJQ0VfVFBIX09QX1NISUZUICAgMw0KPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX1RQSF9PUF9N
QVNLICAgICAgICAgICAgKDB4NyA8PA0KPiA+IFZGSU9fREVWSUNFX1RQSF9PUF9TSElGVCkNCj4g
PiArLyogRW5hYmxlIFRQSCBvbiBkZXZpY2UgKi8NCj4gPiArI2RlZmluZSBWRklPX0RFVklDRV9U
UEhfRU5BQkxFICAgICAgICAgICAgIDANCj4gPiArLyogRGlzYWJsZSBUUEggb24gZGV2aWNlICov
DQo+ID4gKyNkZWZpbmUgVkZJT19ERVZJQ0VfVFBIX0RJU0FCTEUgICAgICAgICAgICAoMSA8PA0K
PiA+IFZGSU9fREVWSUNFX1RQSF9PUF9TSElGVCkNCj4gPiArLyogR2V0IHN0ZWVyaW5nLXRhZ3Mg
Ki8NCj4gPiArI2RlZmluZSBWRklPX0RFVklDRV9UUEhfR0VUX1NUICAgICAgICAgICAgICgyIDw8
DQo+ID4gVkZJT19ERVZJQ0VfVFBIX09QX1NISUZUKQ0KPiA+ICsvKiBTZXQgc3RlZXJpbmctdGFn
cyAqLw0KPiA+ICsjZGVmaW5lIFZGSU9fREVWSUNFX1RQSF9TRVRfU1QgICAgICAgICAgICAgKDQg
PDwNCj4gPiBWRklPX0RFVklDRV9UUEhfT1BfU0hJRlQpDQo+DQo+IERvbid0IG11bHRpcGxleCBv
cGVyYXRpb25zIG9uIGZsYWdzLCBnaXZlIGl0IGFuIG9wIG1lbWJlciBpZiB0aGlzIGlzDQo+IHRo
ZSBkZXNpZ24uDQoNCisxDQoNCj4NCj4gPiArICAgX191MzIgY291bnQ7ICAgICAgICAgICAgICAg
ICAgICAvKiBOdW1iZXIgb2YgZW50cmllcyBpbg0KPiA+IGVudHNbXSAqLw0KPiA+ICsgICBzdHJ1
Y3QgdmZpb19wY2lfdHBoX2VudHJ5IGVudHNbXTsNCj4NCj4gVGhpcyBlZmZlY3RpdmVseSBtYWtl
cyB2ZmlvX3BjaV90cGhfZW50cnkgZXh0ZW5kYWJsZSwgeW91IHNob3VsZCB0cnkNCj4gdG8gYXZv
aWQgdGhhdC4uDQo+DQpJIHdpbGwgdHJ5IHRvIGZpeCB0aGlzLg0KQWxzbywgbWF5YmUgaXQncyBi
ZXR0ZXIgdG8gaGF2ZSBhIHNpbmdsZSBzZXQtc3Qgb3BlcmF0aW9uIHBlciBpb2N0bC4NCldoYXQg
ZG8geW91IHRoaW5rPw0KDQoNCj4NCj4gSmFzb24NCj4NCj4NCi0td2F0aHNhbGENCg0KSU1QT1JU
QU5UIE5PVElDRTogVGhlIGNvbnRlbnRzIG9mIHRoaXMgZW1haWwgYW5kIGFueSBhdHRhY2htZW50
cyBhcmUgY29uZmlkZW50aWFsIGFuZCBtYXkgYWxzbyBiZSBwcml2aWxlZ2VkLiBJZiB5b3UgYXJl
IG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1t
ZWRpYXRlbHkgYW5kIGRvIG5vdCBkaXNjbG9zZSB0aGUgY29udGVudHMgdG8gYW55IG90aGVyIHBl
cnNvbiwgdXNlIGl0IGZvciBhbnkgcHVycG9zZSwgb3Igc3RvcmUgb3IgY29weSB0aGUgaW5mb3Jt
YXRpb24gaW4gYW55IG1lZGl1bS4gVGhhbmsgeW91Lg0K

