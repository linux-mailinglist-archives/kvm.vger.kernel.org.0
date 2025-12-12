Return-Path: <kvm+bounces-65863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBF7CB91DA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD159308BA14
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA3D316905;
	Fri, 12 Dec 2025 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vz37+iWR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vz37+iWR"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B12F3203B2
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553038; cv=fail; b=WpcUQ7zzE3Yz+59gWPjSgF3UnAO9fzM5R8A704IUyTTDMR4Ky95CwS8dBsdR/jKmt29zeHdgsYG8yN5VqNe4mMM9ve5kUT1eQXrKNQqgVNoaU76KnpVD7FmCqXAd07xT0l4OBWtv71zRSbs8D86QFa5V9HGtb3ouZzXcmS2YVgQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553038; c=relaxed/simple;
	bh=UGC9l8juxGf7GdQSiYDPCMjcRhI/UAlmfmCcQ5VntOg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=qLZKjHXGJhjqY1f7nyZZ+GcMvyiIq4xIUlKcPut97Dgx3zfgPwjlLzQgNEc5Tic9uxMhEfX5LsYCqht54iboJj8igTBnVMJ2W3LCS93oRzoiX/7xncGy+dk144WvbmWDdGNGqBfiT0GYW/wYNs0JyPNGTmeENXz66o28SNCICzY=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vz37+iWR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vz37+iWR; arc=fail smtp.client-ip=52.101.66.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bYlzaEdSJUnnDVW0QscxZaP7O77+YpsSJ02er9l/Y1kpFO9nbcxSnumalhGOwB7cE8t0eClxp7IcpLEkOjxLK4cCcFG4g+XdcZlAHQ+Fq8p6jkvdgyzY065rVJSH+jvHaqSozxNDmu4Y0C3rSeBqjVfdPP0TmqQShneQO8adopO+A2xMv1i07uyq9Cut3/2+DCdeH7OpNVEDhVnWfTyXc3ub6rOe7CPmij+rlaMbYufB4HGvMilSbKc8vpj89rUkuQUVEonUXq4QEFk+zeanMmdf2j/S5yqxFqA0GTgbONltxw84tCBRNuL0jqozPnZZCmYbCKwb445h09t0GEmoPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBuWrCeYz2bTkZ0MiicYJXtKKSwBs0z20zfS4a09f48=;
 b=x4VfrrZ5pyoQwn41d3YaNYtj0+NkPZm36hA4s9uyHnvytvwYzJrqpAI8/4C5nwKP1UFhkCQFgT8Dz7TCrWjrLFV3sHvnay6gvc87s/j4DN8JyAEtAIbAdTuXp+cFGXlc//K4NvN7THgMo0besDWBjOl1hQLWLvlVgnsUBNLZoG6ftbUwITP7Bv2Jq/azg+10gDTSaOMEfT9UWje+qFAL3ZsIiSES73pL4X3rQ0QbvcVKy3o5b12QlvsTWTO7cXN/jEVcfgdXd5gBSyVpzgZnameGTX50pSARPgyMO1M5TSiiZp3Y39acENxwM+cmFZ/OWgrI+SDv7ifJBZMRaRaL+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBuWrCeYz2bTkZ0MiicYJXtKKSwBs0z20zfS4a09f48=;
 b=Vz37+iWRA82qwYzJkDvjAZYuCxlkl1bYB0G8x1T1W6MBSj2QLx8hBaKQEi/VHwUHO4lXYOZp/3nNZ/6weTzq/jsK6JhD4hOGEq5yw8wqd1kTDbv/lgEPEa82SelKLY81OQBlPopqXd6n3VLPwvjuacpnT24ppkXC84YhTPQPsqw=
Received: from AM9P195CA0028.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::33)
 by AS2PR08MB8830.eurprd08.prod.outlook.com (2603:10a6:20b:5f3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 15:23:43 +0000
Received: from AM2PEPF0001C70D.eurprd05.prod.outlook.com
 (2603:10a6:20b:21f:cafe::6d) by AM9P195CA0028.outlook.office365.com
 (2603:10a6:20b:21f::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70D.mail.protection.outlook.com (10.167.16.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJKvYGGr/mI3i6YdJwIuTYCPjUfjAJsbhtrfBnzCVzHex2sDYoDK+TxjWrjVAW2BrUJgYvGzdvoR14fUMMoVp499M+QDTEjzXFtoqSINfEBTeud0qrf4Gbk4VBcAAVJLFptrVeYCqSftleQdGWtR9IU7viTqyqOen6YOo/SluiE4VEOZZXvwTt3l53kd5aeFcM8JmM/d1RCFGF6cl7wU/EFIix+etBcsWek+z9+vkxI1GQ6U2lfCzMuk8LG9+dCwCoFhGQHTBoVQsds//2VSO/Z30UDSHIpXEGF/iVntiaLe5XvqDRrua2oBTwak4MiuJqQd+YZmkNKxTaA70E51Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UBuWrCeYz2bTkZ0MiicYJXtKKSwBs0z20zfS4a09f48=;
 b=fwE3//Ag/dVRn4dmMN2b2jwn+h4B7B3OQ7Vmpu0VDurdQbluYEemgDB4zFjaiQO4dvhOxb6teW9PtMjvSjqHIuJVw4azA5MNECbrqPZuoYoLgcoR2pNgx+BF/Mg3DuQ6fgBBwUJFUVCDpv6UKU0WEd0hfHYdvW0cxHI1F0yuNF2/T0kaEDmjinSJEKZQIvphmQ3YlQY8qYBiNNh9VUscZBsc7tysEf8j/xd1yuJoLvpCuMHINjYdPKSSIGR1Y0YiphkGWx5++ScBtC0TTMvmKxGr6HwxlnUk6iCQbwJ1bPYs8ZJlROzBsRKD7/1+m9Ojenhd2xDF5g7ZRWESFEFHJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UBuWrCeYz2bTkZ0MiicYJXtKKSwBs0z20zfS4a09f48=;
 b=Vz37+iWRA82qwYzJkDvjAZYuCxlkl1bYB0G8x1T1W6MBSj2QLx8hBaKQEi/VHwUHO4lXYOZp/3nNZ/6weTzq/jsK6JhD4hOGEq5yw8wqd1kTDbv/lgEPEa82SelKLY81OQBlPopqXd6n3VLPwvjuacpnT24ppkXC84YhTPQPsqw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DB9PR08MB9756.eurprd08.prod.outlook.com (2603:10a6:10:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Fri, 12 Dec
 2025 15:22:35 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 00/32] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH 00/32] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHca3skGj7NnQCM9UqmLtxGHBYNvw==
Date: Fri, 12 Dec 2025 15:22:34 +0000
Message-ID: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DB9PR08MB9756:EE_|AM2PEPF0001C70D:EE_|AS2PR08MB8830:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ae8bd1-7c95-4055-0472-08de39926f2c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?koVgXi+OOFdHmKixRM3A8UsghPuV7/PfXmH44hGD4fPKpK6p07LI3ZWTMH?=
 =?iso-8859-1?Q?NVBgtuEbRO6NTTqaYRi0NCD8HPajw2Fr4bUKA5blJLJajPf9BpUa1LOkwL?=
 =?iso-8859-1?Q?oFzIiRqf3XCRyKVlFEPhUsN2GDxaAlU7ye9fSXD6y+G6cZ8l68vOr8ULOi?=
 =?iso-8859-1?Q?smDis5HM+Mp0MxXjktuNNVDvjYrpFXcaylv8Yvk6bcpGI4t6uCfodPGL88?=
 =?iso-8859-1?Q?xsI894p/0hUfI8Hrd/bHY1dVnaSip8LZys6XKcfrq3V/T6S2Gw181PSCax?=
 =?iso-8859-1?Q?VG5wYAU8J5fqHNmF6mJiNE8Losp8+uYjuTVTPObQPMjhQo4KvERdNgwFHj?=
 =?iso-8859-1?Q?hvp7o9KS3hEorGuPt+UfanfR35KEn+XbsLkI33lyTOtckNgUobVyfJZRq8?=
 =?iso-8859-1?Q?Cv6bIf9Ynyb/uN1oS2HzXsf/KSKsgB13NeRLqu+wwgPDgJ0jbwA2QpEmgC?=
 =?iso-8859-1?Q?OFWyOdfUyxuKgVYu8JrGo9BWtdKnsS/55MAhCUpjDT4h74wMgKZrzU0GzE?=
 =?iso-8859-1?Q?/ze/l/t42XaYDLbygt0VKCoLtOIbPzXq5bC38ciaRwlai2ncSxBnfXTVHu?=
 =?iso-8859-1?Q?ZKZsCu/sB1zp00mprgLhvt/g5/ZnQe+wb/+iw6SlMBAER4shZlcvFhhmb5?=
 =?iso-8859-1?Q?ssQ6qIoH+EN1cU6x5/5MY0dz/CEq8O21M2nabW7mCvVxtB5mSgRHEJiKpV?=
 =?iso-8859-1?Q?bYwkWdmWpeC5KkDmJKqX5Vg7qfEBwKKctAPSeMOnVrwat72zAiXToypiua?=
 =?iso-8859-1?Q?Xia0E8yoc8jJ+2FHjz8s85N5reFbJXkSmvDfFiix/IVzSSWB7toxXpqIfO?=
 =?iso-8859-1?Q?fiPFUZgxsFxK5yG+BzojC2PYTTTBlNUeinz5z33N3DQAxbk4Bt+6oNpEh3?=
 =?iso-8859-1?Q?8NtmUPkfzbtXJu1LC04Xo+QXb9lsVdnB7hmcRKCkGuJ1n+N8fejH3oH6ap?=
 =?iso-8859-1?Q?wz4Wv/Py037g9Ge1laUc/zYDzt1cLKkolOa5HReje/9f+UoQtxVipHNu6E?=
 =?iso-8859-1?Q?KumFmxSxifjXY9pVy4nbW4G359Kzd1HdweUDzgXpNU8CueUG94koAhlczP?=
 =?iso-8859-1?Q?OqOXaZlYFz8b6MD8npfQuzSUVjEBK2y3MaN9Rg0KmeQyivB68MA0WqAV0e?=
 =?iso-8859-1?Q?YBfC+eTIKqdvOJxIFieLnGOJgRqTPnOxskEMSlBRKEzKDpitqDR7/ip57Q?=
 =?iso-8859-1?Q?rtHyij875FyvaxY9MfnBePwYTNfU6/W5gYliHM5EIr+Hgo0CALxeB9hVol?=
 =?iso-8859-1?Q?GPVkzQKlsROy91/pjAT67+2f1WKu5ONqcsMP1etntZNx14XLxmZodeZhcT?=
 =?iso-8859-1?Q?7SFnSYwMUPRx0oXAQJSPIXZogcLAvWqUxgmluPIEFAZcAM+q/3FHWbKn1z?=
 =?iso-8859-1?Q?jNxRUHyyc9r5ORdx1ftdb52HXxVd/aBhWA8dCdMbngtpXqer3rWquu5cER?=
 =?iso-8859-1?Q?HUI2HTp3PS3eS1YzuDfBSHwkcGhwEkKuTs+/ibZcEH/IR5rkmmwYq1rupM?=
 =?iso-8859-1?Q?5f/0j1ncYXmfvTOKQP/fMZWY1LHFzv0tcE9K8E9NO2u+2+5dGaAjUG6GUL?=
 =?iso-8859-1?Q?Lx15mnhrSX+WERjlBswQ5TxKXeFlLk0wjAwl+8ZQPGff2Kd2zw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9756
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e30349f5-ba0c-4a53-7403-08de399246ca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|36860700013|376014|82310400026|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?czPke8ns6GUs6u05emx3pygJf+gEslLGQTBb1HkFfS7O6ADRRkjVNtOxXq?=
 =?iso-8859-1?Q?dJOl+Szy3709D0eDlQfSLckYoMXndhMpw1qG5pZvK8adxmYcaXl1CMScLU?=
 =?iso-8859-1?Q?BT+mLhYYVNwgfBvx+P22tQIlhW11MpUZI6FywtXtAU7FYErJXPBx2oLZcS?=
 =?iso-8859-1?Q?3Yt+FyK4+x629chn0uyuMOXUzftBRcyq4T4JZ8pY5s9VgmddSzWfr3bwsr?=
 =?iso-8859-1?Q?mPD4b4GnE3dpr4lXplepwjr25WiAEizXgRGIn13eQy8jz0iLNbCF5nzHCx?=
 =?iso-8859-1?Q?7V9lmhSkrwrRowdFlxKlYzXLbt/4qtf/Hf0ES4AJyPV9TL8HKUMcbhly+l?=
 =?iso-8859-1?Q?5J/lyHQavAqNZsu8X2aPGgpCPKTuWWYUa2d18W1aEIt5bEz9eVLpdM0Kkq?=
 =?iso-8859-1?Q?rN3xZdqB4cS5ClE8C7t7v00CinCGjgvKPLlWV7wA8YXivBszVyYddsVljH?=
 =?iso-8859-1?Q?2djn1Vsh9rsk+40Afc1iVQWFwM2xhDGatmA62fGso9xPCtHvbYLwZ704ZM?=
 =?iso-8859-1?Q?7sKwPDD9AVBPLglNE32Dhb8D6XfVWClj+VtEcxriX3YcPl7qpSdGmHsoVn?=
 =?iso-8859-1?Q?uEhyLVTCvsy0y/1UP7hJ40Beq1yHqHOSiaP/v3ltfuDsiKjihaoYW9PgY8?=
 =?iso-8859-1?Q?5RaK61tWEZ5nY3c8beS/QAucGxHI365oHrbpjqeMg4ga4jdoUVVk3+sPvR?=
 =?iso-8859-1?Q?ysh1pzJUMH+QUI+Z8pAuMvAUY3JL6oIKW6xBrw25UtZ/FVbf5uz8fA8HQt?=
 =?iso-8859-1?Q?Ahq1Ow558GeoDJNZZOK40INDgTUCxv5iLXi9gP9We1r7hpduu2Er47BkD7?=
 =?iso-8859-1?Q?egLAMsIGUrymSIxRoNuWRQ4j7kk4oAhEhYpvB+FaPpDWDx2Cl5JFvazrmT?=
 =?iso-8859-1?Q?l1rQQKJsyo637s7ABdWr/T10jPUD/MEDtxdMkwDyDM9qxdYD3XwxXOA8VK?=
 =?iso-8859-1?Q?RKI+Iyowh/eAbx87WTG4ZV+ZujHHY924TzCbE7ntfvHeKg0YiD2U7TojiA?=
 =?iso-8859-1?Q?B/rKtvmSVZsCcjTUZXULI+2xQO0m5IcKc+81LYBUNf4l/vBDREz4LuAdGC?=
 =?iso-8859-1?Q?nAKfsUwDCp6snnLg6oZqXgUwQN1eCU9K98PtPe334DhVRNyR6OSA+i8Q5I?=
 =?iso-8859-1?Q?jOom5RWjZPdpn3sC9GnJaspBbp6lK4H0U2SBqe6BVCb0SqLocIDPM7jrBk?=
 =?iso-8859-1?Q?5dEWLfUdT1AOrOGJxZbMumkPzt1aIVj8GKzyY6sHwvic7Ojslhx3dtDkHB?=
 =?iso-8859-1?Q?aC9/BV5dCUesALMKpplrkYy72ghQCwUPeDx3A8WxmjcDYOld1z3X8x7UY/?=
 =?iso-8859-1?Q?t6V2SMtI/aIb1zivy9yg/9TVyepyYoQSZQeDdY4/cFDsgQf4No2as1r0hv?=
 =?iso-8859-1?Q?QE/RCI1pouvRrvJTwvnJA/n8BgbQgIwLdrCcg9y88UB6jBXbHDmdPyYV6H?=
 =?iso-8859-1?Q?cvgc9wKSRtST3UYLt+MahF5Gu+3JI50nxai8uEwIRms+3Um65KwsK58Cwy?=
 =?iso-8859-1?Q?xsgnt1xfPUaEf/Aq3WuE8eyGAhwQ8L9vg6GKTKqZALTbECZqC1to5NBqY0?=
 =?iso-8859-1?Q?AgsdKQrOpvlNT5n4kqHq7pUxRZ4cIg49flS5QzidTzdr502/cx6YdjFFS/?=
 =?iso-8859-1?Q?iirkdz15fExrv/mxm6NJn/TfFC8dj5zSOv?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(36860700013)(376014)(82310400026)(35042699022)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:42.5295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ae8bd1-7c95-4055-0472-08de39926f2c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8830

This patch series adds the virtual GICv5 [1] device (vgic_v5). Only
PPIs are supported by this initial series, and the vgic_v5
implementation is restricted to the CPU interface, only. Further patch
series are to follow in due course, and will add support for SPIs,
LPIs, the GICv5 IRS, and the GICv5 ITS.

The main changes in this series are the following:

* Bump vgic_v3 to use generated ICH_VMCR_EL2 definitions
* Introduction of the vgic_v5 device, which can be created using the
  KVM_DEV_TYPE_ARM_VGIC_V5 device type
* GICv5 FGT handling, and trapping for guest accesses to
  ICC_IAFFIDR_EL1 and ICC_PPI_HMRx_EL1
* Introduction of queue_irq_unlock and set_pending_state to struct
  irq_ops
* Management of GICv5 PPI state & injection of PPIs
* Direct injection of PPIs using the GICv5 PPI DVI mechanism (used by
  the Arch Timer for mapped IRQs)
* Userspace injection of GICv5 interrupts via KVM_IRQ_LINE
* Addition of a simple GICv5 PPI selftest

As mentioned above, this series introduces two new irq_ops. The
reasoning for this is the following: GIGv5 doesn't have LRs, but
instead has the ICH_PPI_* registers which are able to manage the state
for all implemented vPPIs concurrently. Therefore, by carefully
managing the state of these, there is no need for per-VCPU AP lists
for GICv5. By using these new irq_ops, it becomes possible to directly
set vPPI pending state and to skip the enqueuing on AP lists.

One small, but noteworthy change is to KVM_IRQ_LINE. Previously,
KVM_IRQ_LINE has limited PPI injection to 16-31, inclusive, and SPI
injection to 32-1019, inclusive. When running with a vgic_v5, these
limits are now 0-127 and 0-65535, respectively. Note that technically
a GICv5 system could use up to 2^24 bits for the SPI ID space, but it
is expected that 65k should be sufficient for the foreseeable
future. If more are desired, it will require more significant changes
to KVM_IRQ_LINE.

One final thing to mention is the change to vgic_is_v3_compat(struct
kvm *kvm), which has now been extended to explicitly check that the
vgic_model is not v5. This was previously not required as native GICv5
guests didn't exist. This has a drawback: if called prior to
vgic_create, this check will return true on a GICv5 host with
FEAT_GCIE_LEGACY. This affects the initial state of the sanitized
system registers.

These changes have been tested on an Arm FVP with GICv5 support. A
guide on how to obtain this model and use it can be found at [2]. Note
that the 11.30 release is required as it adds the virtualisation
support.

Note: The first change in this series ("KVM: arm64: Account for RES1
bits in DECLARE_FEAT_MAP() and co") has been cherry-picked from Marc
Zyngier's VTCR sanitisation series [3], and adds support for RES1 FGT
bits. The reason for pulling in this change is that GICv5 adds a RES1
FGT bit, which needs to be correctly handled. Thanks for this change,
Marc!

The initial GICv5 KVM support was prototyped by myself and Timothy
Hayes. Timothy and I therefore have co-authorship on some of the
changes. Thanks for all of your efforts, Timothy!

These changes are based on torvalds/linux:master at 187d0801404f4. Any
future revisions of this series will be posted against the relevant
stable tags, but as we are close to 6.19-rc1 that didn't quite make
sense for this revision.

Thanks all for taking a look, and I look forward to your feedback!

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://linaro.atlassian.net/wiki/x/CQAF-wY
[3] https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org/

Marc Zyngier (1):
  KVM: arm64: Account for RES1 bits in DECLARE_FEAT_MAP() and co

Sascha Bischoff (31):
  KVM: arm64: gic-v3: Switch vGIC-v3 to use generated ICH_VMCR_EL2
  arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and make RES1
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Compute GICv5 FGTs on vcpu load
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFID_EL1 accesses
  KVM: arm64: gic-v5: Trap and emulate ICH_PPI_HMRx_EL1 accesses
  KVM: arm64: gic: Set vgic_model before initing private IRQs
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic: Introduce irq_queue and set_pending_state to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create, init vgic_v5
  KVM: arm64: gic-v5: Reset vcpu state
  KVM: arm64: gic-v5: Bump arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  irqchip/gic-v5: Check if impl is virt capable
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  18 +
 arch/arm64/include/asm/el2_setup.h            |   3 +-
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_host.h             |  20 +
 arch/arm64/include/asm/kvm_hyp.h              |   9 +
 arch/arm64/include/asm/sysreg.h               |  28 +-
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/kvm/arch_timer.c                   | 116 +++-
 arch/arm64/kvm/arm.c                          |  25 +-
 arch/arm64/kvm/config.c                       | 133 ++++-
 arch/arm64/kvm/emulate-nested.c               | 123 ++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  13 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c               |  64 +--
 arch/arm64/kvm/hyp/vgic-v5.c                  | 155 ++++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     |  86 ++-
 arch/arm64/kvm/vgic/vgic-init.c               | 119 +++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  74 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  28 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c          |   8 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  48 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 505 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 120 +++--
 arch/arm64/kvm/vgic/vgic.h                    |  76 ++-
 arch/arm64/tools/sysreg                       | 482 ++++++++++++++++-
 drivers/irqchip/irq-gic-v5-irs.c              |   4 +
 drivers/irqchip/irq-gic-v5.c                  |   5 +
 include/kvm/arm_arch_timer.h                  |   7 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        |  87 ++-
 include/linux/irqchip/arm-gic-v5.h            |  15 +
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 248 +++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++
 44 files changed, 2623 insertions(+), 264 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1

