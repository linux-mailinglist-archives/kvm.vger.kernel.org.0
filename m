Return-Path: <kvm+bounces-40089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8281DA4F09C
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:38:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92E40188DF82
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC3824EAAA;
	Tue,  4 Mar 2025 22:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PJsMuXYx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PJsMuXYx"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEF71FBCB7;
	Tue,  4 Mar 2025 22:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741127915; cv=fail; b=WZZfF9UCCL+hQbeOEz4+kVZbKha1qsbSN+UOvpjTsZsTdMqj7mQDGf3q7dnmEhs77wC2kw5hw64KWkxn1FMqksybUpzqfvPu7m8yv0biXSBEqRgu978k0P6hmV5k6BKQn1UlGkTHaoJTi2BdMvV7dX7naf99v/AiG06GPz77seE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741127915; c=relaxed/simple;
	bh=0YZRQYD/xThOnaut37+N2MXoRyGjXufuU4baaJF7V14=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WLV9CRRAywHC3B4YvEUZ7rQtaDx2FSaocrM9BJlbvY/9RSESR0MyVuFol0IqgzyQD3HckyChAwqLcT//4imTL00sefDq22UegOw30cffyWVoggj0Kd1cazePLkJ/KHWHPcsRxlcDj0BYyNmbmUC7O4Bza3KQxiDyBXh+Mlu5j0c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PJsMuXYx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PJsMuXYx; arc=fail smtp.client-ip=40.107.21.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=b2fLuRoSw8gC3pLpi7V7BSntOmU+Q4ug9xE6ZiQbBtzpgTi1Wfkv+hu1fPay0lmY/xnK9QZyy+grv5x+HHQZA+V+XRBZVEkuamoSBZR9OYTnp4IUracTx87QyJTqvfNYPJVYNZNXs4uA8SqVuppVg6sO24Vwe+jfom2k9sSQBumEvezGzUsxm5G3ZA5O+WDuaBZQ+vVmUS9kKCPbdN1/MeNyZVusTmfkYJ6yQmc/ORomjgXsCHyQeQRa6ZFbfohHd0nFX/27/8BT37tPogTkX6nm28p1a/kcCVdNJLA/rgY2yBiPZ0ZiPZFzMwy7V+KgaI67HaGCusyCLKir0+L0BQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YZRQYD/xThOnaut37+N2MXoRyGjXufuU4baaJF7V14=;
 b=yxfH62BkgY4cX1aosnfh1pVKEvJeDkDGs4n9VUBWg6SEjJkq11+BAVTjiUBXZqWLkVFC6pAIHjeUudxPRG7lu+Q4NJ6m+XzIYTw9HqvPQDCWFbh9Vvh2dKB5MUHuMQ4usGLYaM4M17w8z/uNmDuIfiO9q6I38VxOyeQXugjSw5n9KfdH0ct1paMUg+zZVvzl0FrafgCAgdzIoPNO579knBHKwM2re4uXDlsytQZOuuUaZ/dTNBfDy36DC/55QmXB0/JZNnxtgtCTYx5DLFiJ0hsiuNuydZmiITxaFcR+shw7/AYP6JYaMHV5vP2bUuUTAHfNBUfN/1ci6q7ivFWnEg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YZRQYD/xThOnaut37+N2MXoRyGjXufuU4baaJF7V14=;
 b=PJsMuXYx6f8AAo5WTZGeoSuQhJguh3Z2U7TkB/9UX3JQJ7rGnc/jr6fP06G6/53N6rUKME4gp3Ueinegx/cdfaueHTJ3LFue+MXi+OEcfncYaNV5FBzk1g4SoBCd2DJcCbm4GxQRS4Yk8yAPueTHr8uXFvvXLrZi/o+tT2LhrKk=
Received: from DU2PR04CA0357.eurprd04.prod.outlook.com (2603:10a6:10:2b4::32)
 by AM8PR08MB5649.eurprd08.prod.outlook.com (2603:10a6:20b:1dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.28; Tue, 4 Mar
 2025 22:38:28 +0000
Received: from DB3PEPF0000885B.eurprd02.prod.outlook.com
 (2603:10a6:10:2b4:cafe::24) by DU2PR04CA0357.outlook.office365.com
 (2603:10a6:10:2b4::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.29 via Frontend Transport; Tue,
 4 Mar 2025 22:38:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB3PEPF0000885B.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.15
 via Frontend Transport; Tue, 4 Mar 2025 22:38:27 +0000
Received: ("Tessian outbound 7c48d84d1965:v585"); Tue, 04 Mar 2025 22:38:27 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: d149c86bb62393c1
X-TessianGatewayMetadata: GoPWNrs1ZAS4swpALw9+xXwUQ/SxLDzD/rRNm0t8BppVGx6so+ig9qwt+r2ia5JRj9atdvMRQu2IB9FrWpJ5JToNFyZ1Li57Vqno0lO4OzJj8SRW1DuIuYCWVqN0jAj3/ZgEsNZpCXKGGXE46ev3MqYuA69rOAyO9Q5ZQOlA7y+a/QHBjnkbxfTC5wHFuu5saHMoti1V77XnlH2837i0Pw==
X-CR-MTA-TID: 64aa7808
Received: from L5f45a320f29d.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4ED65169-288A-4E74-98CE-6CE7443E8A9B.1;
	Tue, 04 Mar 2025 22:38:21 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L5f45a320f29d.1
    (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
    Tue, 04 Mar 2025 22:38:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WhleDA6sTAtoraBQZ9rk38YcXPhWiZ7hh50iTD0ZnSw57AF0/1bIJ8XQ7JuwDrXQjl/F6SC2JgjRMd8g7V7wMowAGKS/ole90MrMZFVQdFIWN/eiP+KuGe1WjyNkUBiCjUjhyrDSpBa1MfbYGDNBondhRO28QbADnnHm4PUjidEnVQoQYppi0GF780sqpH9KkDWfCR8nUhp0v/FJZkS/FRZ4RH3vHwybL5XZ+1JyXvCktw239zjTjuj1SeH8WgyYwgnAbOITblCj6mfveYl5Sy6EvZTNbiyxF5ffBU6aYorex8cbB5OeikOJ+iJ32tCy/xaHz60dd+Ugg902LOy2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YZRQYD/xThOnaut37+N2MXoRyGjXufuU4baaJF7V14=;
 b=KOkaW6FW+9RzBCgHAhMlHpbU/AFygWB7vIGB3g6tqin0BFfmMHXZt2W6sYzlMj8SS/ZcHbF3LDHwEZlGrm/u6cZOWq26rsW+ge3yWw1Ox6tpJxJU57uM/kTTX8ORfwNYx/nZ8JNMBxjl5VYDE61O1L3zqA3T0ivTyRufh1YHDq1tQd1ldRLtDovalcA2NCvePzT7Cd8wAOr8zt5/zlN6DTHcJujdCfH72L4qCKkCsrJyrimk8t6la72mYhpv7auvfTxi7RigtJiSqWaucEmzB8fxoyTVBWQ2hAH60ii7h3AWzoGI0juGDNFFvuKJzXUX5x+t5oRN7nniGugv38YXpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YZRQYD/xThOnaut37+N2MXoRyGjXufuU4baaJF7V14=;
 b=PJsMuXYx6f8AAo5WTZGeoSuQhJguh3Z2U7TkB/9UX3JQJ7rGnc/jr6fP06G6/53N6rUKME4gp3Ueinegx/cdfaueHTJ3LFue+MXi+OEcfncYaNV5FBzk1g4SoBCd2DJcCbm4GxQRS4Yk8yAPueTHr8uXFvvXLrZi/o+tT2LhrKk=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by GV1PR08MB10642.eurprd08.prod.outlook.com (2603:10a6:150:167::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 22:38:16 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8511.015; Tue, 4 Mar 2025
 22:38:16 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Kevin Tian
	<kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index: AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGAA=
Date: Tue, 4 Mar 2025 22:38:16 +0000
Message-ID:
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
In-Reply-To: <20250304141447.GY5011@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|GV1PR08MB10642:EE_|DB3PEPF0000885B:EE_|AM8PR08MB5649:EE_
X-MS-Office365-Filtering-Correlation-Id: 865ed5d0-0628-448e-f907-08dd5b6d4842
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?yCuKUCcXe3vKSkaHjzyL/ZyadscZwLaQeWasyJtU/FJkmDpe+pBOd+4lMSgx?=
 =?us-ascii?Q?a5zUog1bxnhlLNhuoPhcr1lFNirNIsPsEScLhTKypC6b16uMt7kRpl0Di1eR?=
 =?us-ascii?Q?QpXUviS+J0N4ZOUnTJ2qv/tyBkCwnut2g+pt6+U0qazXjHpW6BUw38aYEGMs?=
 =?us-ascii?Q?RS+oA9nle679E2XP/ZXCz4rzOlXyU8J9Zpei1svlRvn7r1y+6tdbIC2CTxDP?=
 =?us-ascii?Q?8NNAMvc11eY7VHxwn2JIYN1zlKbklzyP7nTqtpE93EYOF3zXniq/YlV3T0+Z?=
 =?us-ascii?Q?VsInmLlnBg+CReqaTR0tRAXWkIcBoPZnzGZorIPSo/tSPJL6U2xkdHNXxrvI?=
 =?us-ascii?Q?sMV+Xw69Po/sfbXQWfNRUVB5A157oD4nfWOwnIMsk4r2NvQ/Bi1Tlc6wwwIw?=
 =?us-ascii?Q?z+owhRIhjJPXUBVb6AuN8OWzUgcIGRfc3+OCOsOUeFCynum9kyVI7m1nqp7k?=
 =?us-ascii?Q?/ATX8gcrKJiRgUvjqh5x1tjsHhYA24OzHfV5i8Kxqry92Hqh1LOLajkBkqgT?=
 =?us-ascii?Q?m/94oInb1PSd1/TftGajXHvJ5D4XTGoT1jMpf/0RtCPNUpUr8tD6iKURZw1x?=
 =?us-ascii?Q?rAJxaz9sQG7mTminkMfP1UN8pHoVQDoIJlrzrS3ekyzji2SRqG0B43GxGkBi?=
 =?us-ascii?Q?hrQcPfZBcyAeQ6ecy44lJnb80xf6LqsT4fbfacjnae4/HkRdB2FBPUjePGqO?=
 =?us-ascii?Q?JwL8UQzAg4Ku/cRkms9Z5Zme+Bi/7TMudUMTRfZTOhbDWpDxrfPT924aWVr6?=
 =?us-ascii?Q?q8bX5ExHURh6RPp2jRk18OdIhZMxHmU9bX+S0bAlIfbPFxwK8gHCsN7MEviP?=
 =?us-ascii?Q?iVaJb8idn4sRvTE0bMOEiKANt+dm+tGcZpejNCNX2sN62sKF3mrWooF6xD1L?=
 =?us-ascii?Q?i1N0EjVXkLn6Hqv//3qB532ANiKTOpWk6BVfuSPww2GotiVQx+jquZeJ6KEO?=
 =?us-ascii?Q?85EM8u2m5JJxnPMU7/Zt6jRHOaSLT30FR3BMcB9zo5YhihYK6svyYW+EQDBp?=
 =?us-ascii?Q?N1THRHccrP7OGL0P8PW65gW5ILjq6WyEGRDNp3JigfajwmHJ7HgRiIewv5fC?=
 =?us-ascii?Q?9KNRfpsBB6qLmMflRoc3yl7K8Hm4WabMTP3VQH45hnSIISRtyOTChiKAOb20?=
 =?us-ascii?Q?38x2jy1VnlII9F4xXCdA+ocgrSO3py8jConoEmORV2iJ1hfwn6qr5PH41YhM?=
 =?us-ascii?Q?HgHFUegj0F0IdL07sQhdyvWCEUtUDb+53VBua95nr7xxmVS4fXucAxvGvmHz?=
 =?us-ascii?Q?bjX9vdSWrxmneqLtLLHUEkxXJz68cfsiQepF3fD9dZ5aUZmB2Y9JDthtiIGj?=
 =?us-ascii?Q?7w1JJtBdHUveHAiT96KLZN97G1z6ag8LqUEBbeHvjgdBz1aLTK6IGnbotkVP?=
 =?us-ascii?Q?5D4wkWKVGMKxIzkA+Jy4gdt6LTBhNnHGXLCUnadEowD7zbdYLDaJZ4XRyZlC?=
 =?us-ascii?Q?A8NRaeD7hfowDA/D0Qe0SasBDA6z7X9V?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10642
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:102:33a::19];domain=PAWPR08MB8909.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8964385d-f7f0-495c-5f55-08dd5b6d4178
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|36860700013|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Cunx61wJkEk4AvRSB/ooJNkL0h4tppFGxTpmqRHXtriVX0pmWoSWxa2PlCZj?=
 =?us-ascii?Q?zugxyNXXRaMOSbZyk7M+PJvqjs7uI7UEHkJGLZfdwosl6kzQ8gN1j3AM6hDS?=
 =?us-ascii?Q?3vcnxP+2h88OAqrGyloQNOEh6Gdz0QazEta5nO/zhTwaUvyx30IWXIISeWtl?=
 =?us-ascii?Q?kjD0/w+Dva/zUFjOj02HemJ6edzJL9vaAIs9R1+Y7BTgKj2l3FQ0ywVhJy3e?=
 =?us-ascii?Q?m+4QLx0QRAG/nmYRyQ5ZJ3jALqyLnJijnfzQYN78Kk1bHzQz54UIKLUct1kz?=
 =?us-ascii?Q?Jx4NqzJo0cd6J3hJrboi87Emo+gr3Nhh2StI2PhnwJ727+KVkeF1bT6wUbHL?=
 =?us-ascii?Q?He2XnxLYkAob6u0rhCGdStkcEkSTG3DozZBwvCRrxbniSxWsrDPaLKpOtd3G?=
 =?us-ascii?Q?M50H6Q1mvwstLxbAyeU8GW689uXrMJxtTIRd0OQtW0laixbUXO4wUTFDPmtx?=
 =?us-ascii?Q?mA8XkG7U+TjtTFIK0FGzhFSWh5L7SyHyPzx2mTBzl7i5c+IFiz75neWIOguC?=
 =?us-ascii?Q?IgleiuW+mr+Q0y6QYLeqT9tXmnccSoAvbhyLYt2JcbJO9Tup8q3LP2Lmyxzp?=
 =?us-ascii?Q?xZm6vCyuMvLgspJxRzR2A8z2LXRowYLQY4l0g/1SBW0RkqQugddyaE1TZ5MG?=
 =?us-ascii?Q?QgI879KY+yl+Ot6GT868ZUMvt9/byM8jH+sFOY2o8lLNjUiB5SS5gcg2GeNi?=
 =?us-ascii?Q?IUm4FlfA+aQvHKgcfGLbjPyB/R1+2WxnVeG/5gGlewc7SwaHEpjQniolFkR1?=
 =?us-ascii?Q?muISfvcGOyY6jvs38Mm2/PUKFUc1AATu0y7bVnRIrcrxEqxKABErxGKQj2i8?=
 =?us-ascii?Q?EethaTsduFwGHL2eucIZjccVMzWxQxmCosi1v0vfHYfKIe0Vijqn+nNLm/j/?=
 =?us-ascii?Q?//hieFzH7JrLND56f0O5596qhFQ5Mqjpsk7ebgMFa/Qu8t8dDGTAIsKSmMtP?=
 =?us-ascii?Q?t5zmUwK+pKeTtaQ2ruTuw4QRXQ+EsMJL4B9A2y6/Jvm/n8TiFpknTDXqpVRQ?=
 =?us-ascii?Q?JdVuTZWWZ/SjdSgu477pSNedk5jHLMyd4KaLofu3R9AyqHAqSSm0mWa28xeu?=
 =?us-ascii?Q?lT/+FYIPdVU/VUXWhW2ydbCQPSsYvGCBPyVWREFCDgRmZFd5gS4R4eb+YVFq?=
 =?us-ascii?Q?y8WEXFR0/vODCwSYkqnjt78uFOt3o4AbKtq6auCPLISxYDloWs6HhA4zOK6e?=
 =?us-ascii?Q?eeIr1lqeF5QHioupFKHxQ8njIaQhpINxzpXR10M6XrQWfY2j1b3/2G2vGboy?=
 =?us-ascii?Q?0a9cPj8vG/EX9xhpzIfke9DzEkxTJTnEqAK/Finw6rAxoX8kqZ7u9kQ3xlAu?=
 =?us-ascii?Q?qf3/iFHNWJMjnrgS1ILS+Ot8fVQmcV+3Fg6zcMtAS1+ies0zdhqtZD6091cy?=
 =?us-ascii?Q?jL+fuE/ze35EE409eoc0rArTDiVgmuzWywUoGQI3QpryqP4ccZknnQpvIgil?=
 =?us-ascii?Q?LMfPGCciIhjVvIXIyu0noKZ6ZxmSi6YwNVpGYTLQYGZG4UfQY92PkbZ091Ex?=
 =?us-ascii?Q?/cyAxbVOEbivPk4=3D?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:64aa7808-outbound-1.mta.getcheckrecipient.com;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(36860700013)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 22:38:27.8233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 865ed5d0-0628-448e-f907-08dd5b6d4842
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF0000885B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5649

> > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
> > direct cache injection. As described in the relevant patch set [1],
> > direct cache injection in supported hardware allows optimal platform
> > resource utilization for specific requests on the PCIe bus. This featur=
e
> > is currently available only for kernel device drivers. However,
> > user space applications, especially those whose performance is sensitiv=
e
> > to the latency of inbound writes as seen by a CPU core, may benefit fro=
m
> > using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> > application running in a VM).
> >
> > This patch enables configuring of TPH from the user space via
> > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> > drivers and VMMs to enable/disable the TPH feature on PCIe devices and
> > set steering tags in MSI-X or steering-tag table entries using
> > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel usin=
g
> > VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.
>=20
> What level of protection do we expect to have here? Is it OK for
> userspace to make up any old tag value or is there some security
> concern with that?
>=20
Shouldn't be allowed from within a container.
A hypervisor should have its own STs and map them to platform STs for
the cores the VM is pinned to and verify any old ST is not written to the
device MSI-X, ST table or device specific locations.

Thanks

--wathsala

