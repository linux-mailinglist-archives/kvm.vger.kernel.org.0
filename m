Return-Path: <kvm+bounces-67611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FE4D0B851
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 121133039F42
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B98369970;
	Fri,  9 Jan 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YA4PK97L";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YA4PK97L"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013015.outbound.protection.outlook.com [40.107.159.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05A366DD3
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.15
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978361; cv=fail; b=G3wGGkV/olsPE/9BhTSSIH7jkZKbo1H5H/OENHsw6QoRfZKG9NtjU6PWWe5TSiUv2r+TAYyTdT+AlmF5uoSVC7VQfNsnvewf8PCPlRK0JvIiep6cS3Vuyio9MZld2BvdOP56MVr5X+h4Rp6/tNDIQl0/ZxpKDqVIcO0dQZ3+vhQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978361; c=relaxed/simple;
	bh=aGI2CS8/8MwqjsiDI+WTC0NQnKjuLcbzCZH0yAewk8s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N2U535IFq8QW6COInZwakPscLMoGbonjgowzMxWlVe+TXNSaBRjWuMHj90Sw74cF3clR0eKQb6EcAtLmG1PkVCaivx9CIpY00K60TWD+faBoprU3+WF8zaL+sm6zbHn/3EowZFk/a2nX5LlpUX9tTVN+go/34nmcbtHbpeuSCsg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YA4PK97L; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YA4PK97L; arc=fail smtp.client-ip=40.107.159.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FJyxM4fK4uPmyVQb7YhRz3e8+YTLj9IDOwPa7eCei+hbhMxnMYfhVPz3znbXGajx3/BUFl4t2K4gswqryw98Ph3A2TSFHWeyWoRPEb0qowdSyFInGkkzf8AVsjjo2WiKUIvHrt4Ypj2fhZv2ToqGD0iMXfEklOuZAGJkKga7wu2vJAoz0vdTxyEu6k+ThqjBRqJhKDEMiPfYcX/b+oZIcOeh5XOcWG27d736PrPmi8oRKoPOOvmHXIxH+7OgWCqw/Hoe+qS2g5C+snMAeWkiFZl13+oe8iPaCvrqVzuxMK+/lJEiLdb4UhXsp/NXfv0oT1prhbJFMwPa47TE2B3lAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8hxjya/Xf0aqen1qE+UnE+3U2A8zp60jnYaUT+f/IQ=;
 b=YVpImh6BAa/QAXWWjQXpVMOHx4ZitmsklmCbgk855k5f583ptZp9nWStPCywoWB+mpPy7a/E70TrDcxEVv2WGtd2xAW0yRRJKWBxp/U0URuS2PCHuCZrkIsaicbGul3q5ydILe922efBPZgTD+d+zPR4uruWypPnuqDFUV+H1TOxh5h0/VrCmYTrURTWVE/ifXXx5F8m1EWX7nsvnXUpH/qsX2pEJPGND2m0sG9CKkeJo8dUCjO0UYpIZJN2Ny87RzCuRTiHU5uNrrkmKiD0rq08+qTkF+Z2o2rGNMAkkWev8vGz4+n9iBre2uimvgBmPEbhyX26wYzqGXbO0/pkmw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8hxjya/Xf0aqen1qE+UnE+3U2A8zp60jnYaUT+f/IQ=;
 b=YA4PK97LyG3ljH70Rv9xFKpilUO3qVIkM2pHFHuL8lwk4Kj4+2f49eMK0CUqQmQ/+teDzCXy7RdVzIHMIk1LhhaaA4DhjB0OMKwN0BD+KZd9MSfSq22fMmixtFuQfejTs+HgEehs3ai2jGJA1DyCZB96k1tC28xMKI1w8ham26s=
Received: from AS4P190CA0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::13)
 by DU2PR08MB7374.eurprd08.prod.outlook.com (2603:10a6:10:2f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:53 +0000
Received: from AM2PEPF0001C70A.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::4b) by AS4P190CA0026.outlook.office365.com
 (2603:10a6:20b:5d0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70A.mail.protection.outlook.com (10.167.16.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hnb1o2Omw79jUxW7VapawAM045FF6Pm9jmVANYY6L6qLprMkWiQxsCV6zEqKES98SAh45hhZGuJ6YpekUg9Tb9xSbjlIny39ngNLZzbS//nPfyrW3uwXwlhxlmh0RzfhpuYHByfz4iVJnY0nPBZ7fTZpRaGqVKeeVLgPWJcr8BeRsb5jlv/UHbQeMf1XsjiD+9GxDwwmiHMAuVW0LtoKp6+f9eNQj/XvU8EHaV8A6zEwmcp9XG8SLU+h+1zrAqdFjLPvyNucXazsgQ9I+M4Oe5VbALQOW7KVfSorhVWhS2LtkXviCzMk/XGgHR7jykiOuxJYIYeAnTwxt+pORIzL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8hxjya/Xf0aqen1qE+UnE+3U2A8zp60jnYaUT+f/IQ=;
 b=jeF0D5QghNgEj5HWTEt7094KpmQFI86oRKiXsAcxc6Ty/uSHWMQYCjXTBX2cj6BTod/hbFGnIwMUOB8SakiSSy+6/ErxT6PB4dxOUCCFly3ACGLoesKM/hZslLinHUgBP+1eJxr5H7mQbxIwX3AQuXIzAYI2J/FjTeEulNISQpkYDGw+Zo4S65AdQiqtPmEsvPH/QG6TAdx93WeDCtK828eWzYMIbiNc8wYTJQjoBNkgF0AFyARdEL+dZTs1WANnV1qN9FAd7V9+A5CK9R3dtDhnTuNwca5HMQDm58Z5RwJv2C6g6B9zK0SGqwKZ82trgmyq1nFv+iajb7T+sbzC6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8hxjya/Xf0aqen1qE+UnE+3U2A8zp60jnYaUT+f/IQ=;
 b=YA4PK97LyG3ljH70Rv9xFKpilUO3qVIkM2pHFHuL8lwk4Kj4+2f49eMK0CUqQmQ/+teDzCXy7RdVzIHMIk1LhhaaA4DhjB0OMKwN0BD+KZd9MSfSq22fMmixtFuQfejTs+HgEehs3ai2jGJA1DyCZB96k1tC28xMKI1w8ham26s=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:50 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:50 +0000
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
Subject: [PATCH v3 28/36] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v3 28/36] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHcgYoPjv5aSzbKQkSH1nC3ISrv0Q==
Date: Fri, 9 Jan 2026 17:04:48 +0000
Message-ID: <20260109170400.1585048-29-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM2PEPF0001C70A:EE_|DU2PR08MB7374:EE_
X-MS-Office365-Filtering-Correlation-Id: 22150ec8-d75e-4c7d-e9ef-08de4fa1590a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ZKl4Cz+hNtIYPRMVNvsHZiddqkbL5dIx5nftHLd/RPo4QQE/HoGAUbZNhA?=
 =?iso-8859-1?Q?VesG9k4bsQ68PwTQ7C7+Y+m4+ngSMV/RkH+yZ7ISrzRMPrOgWIE4/ueA7v?=
 =?iso-8859-1?Q?Oc/2lvxWBvr6VLEx5GAjxm0BgqZN29RrcphX+5/BB6TF0pavop0tXZMn94?=
 =?iso-8859-1?Q?NvGtuLD9l8FISgjH1dQUu286UPqnJSwLhatL2jyrYuy1xkSkqDttMQjewf?=
 =?iso-8859-1?Q?naQ7DS5wnV2bPj5g03olcmxmSJfhkzMROcZEyijEeItehwEecMqngze8UQ?=
 =?iso-8859-1?Q?lsAbkEhzBcPF/KWoZ4yaVzmEAQsq0rafec7naCorJti9M5sonTYXfyhQHZ?=
 =?iso-8859-1?Q?u74YgFdq1qeTLftSL7ggdcKprCL1KM1m4BkCi5mU05KCzr9eJDUdIiA8YI?=
 =?iso-8859-1?Q?PzQ7TSEVO08OGXsD875mBkZrfngua9luv+X1vvMNCNKJ1Ag5BdTINMhDgb?=
 =?iso-8859-1?Q?2nIQrF2kGu7ChKWHwJI/jXw0k9jwkMi7KEHgrAVGFcdJRyqvIRNYTT4Jm/?=
 =?iso-8859-1?Q?vd5zmt9waAZ2clFWszzL2zghW52OVtJSw0wWZJXuQE7whQFIBZ1BmCPOnf?=
 =?iso-8859-1?Q?hNcpYbpjDoWyk2Ix2tYnMD7X6PMs6Myg1P9IneIoVSci2hnN0lAIDcIZQS?=
 =?iso-8859-1?Q?WgaVP8VgECEr4vStaELKr6CYkFHH4QRG06Cf3s8WzM5kZ2plK7LLXr6k0Q?=
 =?iso-8859-1?Q?NU1EMw/aDl/rwikbc/t/YENyFAmCeOkq53v7fOy9lqntHLbX2U3el4U0Ro?=
 =?iso-8859-1?Q?P9zRooubInrYeKlEEeTnpDgL1+e7HO/ew4w067Dxr9da0jok/v5QSYJIpw?=
 =?iso-8859-1?Q?Uov3gPNfN2ZSIs86gBMaf3X2SbHuSalQxaNIm2BJbdVXWESMED+eT1M1Wx?=
 =?iso-8859-1?Q?Vea9T+P76LrICMB+7IMRft9RpHp2W+C+0wejyAaFCQhkSSizM/Etb5HeqB?=
 =?iso-8859-1?Q?IRoSwUSffPyGHJZSlrLCvN3tJ/e74gSC6jeSAr6PUIcnZUgiUXSSrk3v5P?=
 =?iso-8859-1?Q?j5egD8t3mFdyLxccucHHLLVJ6ioUVgPDs75sAZ73IsK1wjEA3uVYihZwHx?=
 =?iso-8859-1?Q?4zaq9oy03UDAKzDCX2Pr+uiY2ccaF2ctU1IFImxSThVf6Sd36ZwHwHZu3K?=
 =?iso-8859-1?Q?VYT07wbMPsJBF0lIWrJaRoeSrZR+/jkErHn1+GwYQfyrMe0kIe8j22seya?=
 =?iso-8859-1?Q?oU5WyNTUmcrCnYTpwYavF9FjGpSXjZ2UB//B9Pv90YZZOaSFqD/JidEn6M?=
 =?iso-8859-1?Q?PGCmYPoIKGQXrtk+WHowJkqOOZFBwrt9dWKofhrtGqCjqmswq6ZKFcxWRs?=
 =?iso-8859-1?Q?B897SfBUwxvPGmGkK2U3w/S+MDlambBa8nfeHo6M0ImCo7BT+KLkFLLOte?=
 =?iso-8859-1?Q?0alcpdj/crjjGHzeHsCkWwtQqB4yAfLheYpiTJGLse5c2uD75b6TcG6bSY?=
 =?iso-8859-1?Q?iV9ixOI6Ws8thU0My2tnIDpY8zErK7JDhkW6/YfSFxAMRXNP27nn6/RnEC?=
 =?iso-8859-1?Q?GO7O2iQ18IEFRJ6fC7zZiUVWf3WJmBlZngLriV+AcX8Atd9KTZ7rmfy5NS?=
 =?iso-8859-1?Q?52LGX8RU0G3PmKS0qeOxZmbLSDQS?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fcfd2336-08df-4846-3216-08de4fa133a5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|14060799003|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?v1qlN+WIyq4rViLrdn4eCJJPKX4k/vYGlhPW5ZNcp/RyE+ajBlF30Uzedc?=
 =?iso-8859-1?Q?LRpAORiKMhyfI7fCCmtg3i3l3HAB8IjkNggAXAaDX3J2v1K5RQRXPpVqFu?=
 =?iso-8859-1?Q?RWX5daJz6vSm6p6f9ihVj4Ew2U9Oavb0pAi0XKfE2m8uhyAeccETbYcT3D?=
 =?iso-8859-1?Q?TuFK6u2iF9P3eYVdbArbIchej6oN/0BZcU0pYDPHBE4KGYpKiKn8kmDsHz?=
 =?iso-8859-1?Q?uZrA0cM9sCPBd4yrqq/kqvSMcSxsX1tMdI89Rzc9xperqlvZ0huQI8kuno?=
 =?iso-8859-1?Q?nigPq0mKR1BNurV8KLcWnmr42IrUhXDppzCOGXqR/Ynxh0h2ZMMl3GToCE?=
 =?iso-8859-1?Q?nkT/1lFmQL3Rmwdwvf0dVDZnosWoOh6ooEC6G8LXpBKWmR60rVFXWdt8UN?=
 =?iso-8859-1?Q?lQunwrDv4zyCQa3uacwFAUOW/EF5qwtxULjL7Yilm5lfUqnflq/bK85pe1?=
 =?iso-8859-1?Q?huGJ67tPSj9PZmNNFG0HcnAD1Zjt/ewXltrV378eGmv4/njmdWh6SuzTjD?=
 =?iso-8859-1?Q?/Xb87phpAsubqdILHdBeJlfam4KKK+WWQyGbVYfGtmGwPN3WYfvNICqV34?=
 =?iso-8859-1?Q?eKX5aBVxF6+a6Un3azVCxeuN335B2cwbgUQ7orvGCYdTBWCienSB8kSGfv?=
 =?iso-8859-1?Q?RAF0/fRozdmPTZxRjLRM1aAvnqIzA7snay6kU5qkOwO1TG8Jhvoglju1qs?=
 =?iso-8859-1?Q?QaFEVqhIDNdGiJw/g4loDb/m4cPR18pOI6I0gP/EIrG4aYXM1QzzgRGifW?=
 =?iso-8859-1?Q?3yejct5HhOD6EK/raSLMH6oV1+UpmUK5sjVsKDskl9YSMjl4sSgf+Dk686?=
 =?iso-8859-1?Q?qhwV7s0iW/I0MjTPVkllel+Qu4P0t+9scFvWwnVlo4pE1khVmLqZh4l62n?=
 =?iso-8859-1?Q?fo6kp+lgLJfM8bYxJDanxOs5xFwwjcY749LUvAfC65j/Hc3dZkQOtdD52o?=
 =?iso-8859-1?Q?vVu+U4YLAU38DWoNR26xuSQWJLyEI633S9P+rhKtkbVu2kaYzGmjpMBKgg?=
 =?iso-8859-1?Q?w6Lzeu6vFVUS4g3FnSQFg0R/v8Xtiz3R7JPKu52jeJPwS5DFPFPI0Xw5RA?=
 =?iso-8859-1?Q?mtWmEdSSo4czc/D54hqNkeFkrW/Uz72aTXqrOfypezeaRKvaWPm2SkJhua?=
 =?iso-8859-1?Q?KSM7Y82E6HcDpGi7bpDv/OKUdTkNfjTZ2wrdwTIM89aTflfKVQs5p9LMcU?=
 =?iso-8859-1?Q?Mg6PvHtLMay77LFhdQvFs7bAxZwlPRjb3CAI04XAp2yCejAfBipdlC3eec?=
 =?iso-8859-1?Q?v/vlwhZdoXUt5Guypfo6gwNPyCuq3gWZYmR+oIuddITedjBTeRPVHPUvcz?=
 =?iso-8859-1?Q?k5gKoed2SKgn43eczIyAXoUU4WV/Sqji/R8hekRCQZAlvGg0b13fOdRRD5?=
 =?iso-8859-1?Q?vsAu1qTiPdL3qI7CuCw7dHKmPxz0acvR4ZboIvqLqZwPk2Mx2T7VmN1+Td?=
 =?iso-8859-1?Q?ekc44WtLeq1F956Z0GkPRKSb3g2N2DCjI/YApdSr4JevVNL40J5OXPjJNl?=
 =?iso-8859-1?Q?5BTHSy0rAKHuQh2AOyW1g2ZH4x2ikoQNAYP/cSY9KpxJNgyisp5V/08PXa?=
 =?iso-8859-1?Q?hum6loY73C8+VuM8dO5cCPuilAb8cSv7m0aPn/s4J+5bJc5VnP3VAW5shG?=
 =?iso-8859-1?Q?VO9mf449ucl4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(14060799003)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:53.4544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22150ec8-d75e-4c7d-e9ef-08de4fa1590a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7374

We don't support running protected guest with GICv5 at the moment.
Therefore, be sure that we don't expose it to the guest at all by
actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3dcec1df87e9e..8163c6d2509c5 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecb7a87cca15b..1cfd1e53b060e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2472,6 +2472,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 3108b5185c204..9652935a6ebdd 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1

