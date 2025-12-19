Return-Path: <kvm+bounces-66352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 909C9CD0A64
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B26A30D9A8B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6179E363C48;
	Fri, 19 Dec 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OWBlD7gO";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OWBlD7gO"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013011.outbound.protection.outlook.com [40.107.162.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F48361DD8
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159630; cv=fail; b=UceOgu1dg33mCNLII0pBu5kqLbWS8tvv0A+gNm/DwsipbHn7y7zGvqgAS9mjOqMUwFcqsBKk90vU4prfp7STgXrPL3xkkhZEpT65Tzhy8duFRphQzeaW+jtfqCyF6m4izmZdAIPZ1mhgxr0Q+F83DVd0DLRmpIYZ2GXeYvvSaHQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159630; c=relaxed/simple;
	bh=uHbR31EEvriUD0mk/X8F1qcvk7zEDOZUeM2gqk8HDsA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aPoWvmkkPpeH4vbgJexcihBt4vQwmlg8bdr9zghcC/h044PXqD1x0zwAziCcI/py7gzMLIRTPRgJlbd8pUb04pgbtbML2tlPVVXYlVJUD057h6Gyudsd+cErkoIca2somUgcUZdZeub2TEP5SNpvBr4A+4MPtMFzkYI6CiZ9byg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OWBlD7gO; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OWBlD7gO; arc=fail smtp.client-ip=40.107.162.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VjWZMer/78xCS7u4xBTWuOhMsi/rE4bJZVrupsMylGrKuf6Va+9fGkL3UG5gNZ/NzO+kkRCapTCTqzIPqAB89LW0fF4ZtMdFFpuu/o6gH4pAPmlbFzzFqt31GfDpd530wMpkBs8pvgb/5oIIaDsD5ZSoFQ+Y9lNZtEKA6awOm3aYQbepkTWVNF3ZajxOu0wXYPrKtfue3F+JrJr9djuqSiedUhMljkfpZkcPw2oU+MXNsQzfUwVWyni0NJVw9icWRNq8+FaTtXieG0SLcKC79CrhbwkE5mb5cOUdh/IYuYGVuakQ5KylIaDgrQjf9xX+nc8FmB9Vv8fZdjQt+SAilw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9dWR+V2VW23RnRLI1MCAAymjSjFW7gbZQW67CISOSM=;
 b=w3o41via8jO3NW+lWUi58hkTmILk+PdlKPRTeJCkG/6Dfcv5AmPMgsr5lfmxCvV0nUcQSpxxRhOB8PA1TuTl/USTJIkeHnjRjgvohr1dDkv8gH1iZhFgXClgXHqu9rS3oEC+df2j21zcJBN7ObJLhnvOjq/CT6yqfZWUI5Ss8psQSy0jzO86zIrQkHpjwxC8lwMfTvXU5GVU6hPPbTJKmZQT0u33KfNaQmOdsGNnx08vt2TCm2FQjo93dsM/YBPZ8G2PY2hFM/xmzTj7+lNQ6Ffv9hnrb+iX93fHMaUwwEOOJE10yXqO7+TaBePhlWCl4TuUdJS1MVRzMLCYnFWd8w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9dWR+V2VW23RnRLI1MCAAymjSjFW7gbZQW67CISOSM=;
 b=OWBlD7gOlW4NHwL7L+Ye5Gc/Ilp6989qJW0CPsML0UArKpuYjFhP7G/fG+rg88ODZdOAO17NOflSmML68uK2DmHcPvx2K3KN4h8Dyts3dKj9OMX8kqs0uHm2rs1CN+CDRMKz9F1aI+ie6PnpPQ7RypyUKHhSHZ6k5ZSVlZ3tNGY=
Received: from DB9PR06CA0001.eurprd06.prod.outlook.com (2603:10a6:10:1db::6)
 by DU0PR08MB9322.eurprd08.prod.outlook.com (2603:10a6:10:41d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:42 +0000
Received: from DU2PEPF0001E9BF.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::20) by DB9PR06CA0001.outlook.office365.com
 (2603:10a6:10:1db::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9BF.mail.protection.outlook.com (10.167.8.68) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via
 Frontend Transport; Fri, 19 Dec 2025 15:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uO8pJs6UvtaKf6EfrE0DqhqoSFGtYyn67z2pepdT7oUF/l9ybyZyxlzGJ5HRGGdgqbTBcB50DwZ4mgWfJY7U2hyiS/Dom7xBXuQ8YyQgSYA0IIMB7CihDrAu4T2q8l55XzbCBktYHQlNVRvOmCA45NYi/rSH3Uu21Br8g0Y9To17ep2Mf7MO6kH0gszMWJhGEwAha/449KsFmkH3q656q5ztKMqxGqS/yUYRAf9rQyFs+tDmBorld2LWVf+0XhVm9yxNd8qwTBnnPwL7c9iOLG4ecmZQkhMityppwpJcP0kq8j6LiPqhQbKpsot+aRljh+0eISI+/ajePeEqbmEKmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9dWR+V2VW23RnRLI1MCAAymjSjFW7gbZQW67CISOSM=;
 b=RT26kg3sRrW3wN8xhyDNofQKIpBM9FmlCPXHqkdYVWLyEO1GEJbWyqmL4g7U6GP3wqB3JQ5sNpSmnl9oSSloLULsKBLwRTxmDEYsTEtA0W74Rfme7FCycVwqBInEChGOfMnip2tVXo08nu2cWE1/C5z1fA2kS/zF+3GcUdnCHeKxLFkXdz6ni76SfbM2w+Vm4utWDJBUFyS19d132hoDrk5kfQ3Yy7JVeAk/UZ6aFlURS946Avtc9sjH7eGlQIb3kXRHqR43xSQhpdI+6/kCDpbmMuXe7V93sx7J98Lx5OB8Oy+5SvMia0pa5Hnm+xD7rodbRNAaiAsc8z+8pQZD7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9dWR+V2VW23RnRLI1MCAAymjSjFW7gbZQW67CISOSM=;
 b=OWBlD7gOlW4NHwL7L+Ye5Gc/Ilp6989qJW0CPsML0UArKpuYjFhP7G/fG+rg88ODZdOAO17NOflSmML68uK2DmHcPvx2K3KN4h8Dyts3dKj9OMX8kqs0uHm2rs1CN+CDRMKz9F1aI+ie6PnpPQ7RypyUKHhSHZ6k5ZSVlZ3tNGY=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:39 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:39 +0000
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
Subject: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Thread-Topic: [PATCH v2 08/36] KVM: arm64: Introduce kvm_call_hyp_nvhe_res()
Thread-Index: AQHccP+AuO5u84edkE+pcGHcNBr/Ew==
Date: Fri, 19 Dec 2025 15:52:38 +0000
Message-ID: <20251219155222.1383109-9-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|DU2PEPF0001E9BF:EE_|DU0PR08MB9322:EE_
X-MS-Office365-Filtering-Correlation-Id: a63f7f1f-a006-4bd3-43b0-08de3f16c894
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?C88yEtJvuWkuSUFR3Xj/TaUoYAmz2VcAUSuMDOpnfxfY0GoAEqQmZLUk4G?=
 =?iso-8859-1?Q?BH2nIIkgw40W5D1uSfWOn0FDZv2dSqk7xUJJFuzCPrhWmGYOTid2AJ5Ycb?=
 =?iso-8859-1?Q?gw3CnXQkSfpfO+Ndv/TUurmmFQCDH3i5gYHFNoQwi0BOF0RaBZQ8Xphi1p?=
 =?iso-8859-1?Q?hoFWO2vqdOqXU31rZ/LnQQiGCA3vFQnI+drnLX2BCGZ42s/M7KULTVQSOs?=
 =?iso-8859-1?Q?7/RnWhKYzqASEISjWA+KMxg/JRac1zH+YgFNCKYel2YUiUNeGHS3RwX0xh?=
 =?iso-8859-1?Q?fbi/Nx+NwowpidZZ3Kwc/Rvx7u1oDNbl7CSBTE7E1+VfoO29b+AcF5ui8z?=
 =?iso-8859-1?Q?TqzukupaNpIOgTrVHG2+qFI6IC3zUyuvUHRtHKnYd68OTzN1XB8cfg4dDe?=
 =?iso-8859-1?Q?MW8TSDQpKTqg6NuIHiWlPlgrqLLdr3wUsAiTQE5FsHvHdpM0IZrXEYnMEB?=
 =?iso-8859-1?Q?jJofXW1t90E3UI+MiuX7o/9wlBQ/czVTfFCPSzFj9oQCi230lEUxTZHdsP?=
 =?iso-8859-1?Q?o6vu2A1bRcwfZR/NRVnoLqg8+ltFNBN4O2+LuKaUosxdh3mFHbtDVkWlgT?=
 =?iso-8859-1?Q?IpwgRyPRjlYGHGsrjHNlWkAHnM9Au2MpV/6ELRZqZqGi4WZFhQp7cShdAp?=
 =?iso-8859-1?Q?ouv4YPPXWLs3Z8X0UGVhU9H4LJ5AVvIuI6yHAslqbdadG8W0J32IY4lEwT?=
 =?iso-8859-1?Q?NBERqUV5TC4QSCRuF9IcieShSNYI96RBsYRCPK0qKhcoGiaT1WNlGT27WQ?=
 =?iso-8859-1?Q?sB/XLunYIRgBsYlQ4Ejs16I47GIe3exYibcsB9zVL0bxO4Psqpfw7H1zYT?=
 =?iso-8859-1?Q?aDuXkpB7Q4htHe4+y1Ist9d/ff4+6kkK3HRrcP8U3FmOLC6ZbZ13mf9oUg?=
 =?iso-8859-1?Q?YZ9OpmBY7y1hbaTI8BXhuWECduTG3pkOTOnWVrra6k87VFPMtOA4yPz7xr?=
 =?iso-8859-1?Q?L7AZBDN6YK428LN7gaLKhHiJaTZ+ym9/t2Iz+1p0KeNg5gW2HmnIasRZ6u?=
 =?iso-8859-1?Q?D3TNEkCeCYJix/D0m7OBW9eT3eTjtL4LHCjB1CNW56M9s1YmytM7OwE+jV?=
 =?iso-8859-1?Q?3+DMrz+VaZ1jWWCGoaYtpIZeNmAMxY1obGHQoasp/tSZNu128YFyjm/mIb?=
 =?iso-8859-1?Q?aw36oahraoVzAw0mUxc7qoN8jp4C1BTuL4FUXuz0OJndApFX7MBi6wqSss?=
 =?iso-8859-1?Q?/0kVMG4u+mBHOIXwdGwHkox6ZYJmw8Z/LR4jN86qnb8ultSw/u2PPIH0aI?=
 =?iso-8859-1?Q?txYpVDkj+8b92wV1IQr90Cy+mYmIFpaZWl5CQbkSIrL5pSuQp6D5Cke1/s?=
 =?iso-8859-1?Q?GIkks8y/UJaiQPkI0KjHtI9+lpu3P4nL7I6BQ+NWm6/g8ZB40MCVF9igJi?=
 =?iso-8859-1?Q?2J9LlSprT27gZJFLj1/U2msREf65CkXOchQg2P7SMJMCB9aIwPV0Trxlxe?=
 =?iso-8859-1?Q?XK/pFdoi2BqcfMbn6dRL5MjX7FPLeRr57mDvG4fsGJ6tjjQLLrFCNC0/n4?=
 =?iso-8859-1?Q?A7XuZ3QC3XYlWAP4mqR+EecrzklHs11GsOvAy5QFfav3uF1ep5yRkd6eqA?=
 =?iso-8859-1?Q?HWb63hXnta+g8k50anNyEXufbryb?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eecfbaa7-2d2f-4b63-1731-08de3f16a37c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?8PjPrb4U1GLi8INmpeXgTgNe67E3YS7rOs9bfIliZqhhfMdO6aHm8Fru2A?=
 =?iso-8859-1?Q?SDJYYRdoYHC4vC70/bIGEYxfcj1uAJa8Uv6uFfjY9eBakFF/7BWBc9MLIX?=
 =?iso-8859-1?Q?MzI463kDt0XwIR+08onlehHIg0C4aaQvklJpu9l7WuSQbEYb5oo9UJAU97?=
 =?iso-8859-1?Q?sjuBkRUJ8Zy2afYp1QYrovu2XApEYnp6oHLKcxFezmGNo3PlyvyvKmlViN?=
 =?iso-8859-1?Q?cwBtdI6j8lkX2LsR9lQDPXFqcMc9EFKUyYheKFBef3A5qa3t8zpuppC0sm?=
 =?iso-8859-1?Q?p5LakTZyVZ8PA/VgPeYfwkdFo8nQ+ZjUD3j9rQ2CBlfpyGAz7R2cuxi7eH?=
 =?iso-8859-1?Q?fYjsZ0rjK69yAO21/gRikUxekmXgBf2VJPuFwzRgkP8m3x+aBe3/m6ocBj?=
 =?iso-8859-1?Q?SNCl7X08YRgNEIwR7Me8w4qdDBWWT83cMpAWGX801W3mIKa8DlIFS5VeLV?=
 =?iso-8859-1?Q?ENE5gt+Kxo0M1h9+oh51/DouV6HCGqjAYOGStPqGkf3G2R643MSdeD67es?=
 =?iso-8859-1?Q?af14LCF7Y8N81UZUSNOA4zUNgb4R6uMsuz0Rz/MtEm4pKwjf8tMqWanQjZ?=
 =?iso-8859-1?Q?Uui9cBKRAff97VTUo3NLj389dhiUfN9ujja8C1qGdkhzfI+n0KXftZubRE?=
 =?iso-8859-1?Q?JHpd2lkVT0Zdpe4YVq6/1379aizpSQ+KCM29JwBUDO2aTTiZ7oqcMFt2rp?=
 =?iso-8859-1?Q?kcqFdMQaGtukc4AGyeUIuBMPvAoNHpfJlYY7ZrOXd7Lllk+Pcje/qWxNw0?=
 =?iso-8859-1?Q?2NbGItXQyoTAY+My5TlAUaTSLMAsCc71nPVYcKY/962ODtYcjm450ZdOxX?=
 =?iso-8859-1?Q?t798SLUqWVCU0xRdPi00z0hHy0E4Ur6Oh9G54deuVROfc1gxa88QmdxRKf?=
 =?iso-8859-1?Q?EclQz5Q3xvt3uTD29MY11G4l+BPBDKBukZMCLEpsM8taUiuw6eHXhtKjMz?=
 =?iso-8859-1?Q?nAk88IBYaZz5nstn/c7UPv1jXCjSfNUTx8NuEXFCzrpUwzuH2tm3jfoVUP?=
 =?iso-8859-1?Q?jDiC+5N41o8BGAcyC1g0OZyl2nRHsbTekuWlZcszJglbww84cAT+EnAQv1?=
 =?iso-8859-1?Q?zaaP8YQbImjfb/XaXbKuoT+4a7gc7W5r0AN1DXOK1ILSjcGgemKtWiuJlO?=
 =?iso-8859-1?Q?1VFpLY+G6PiuAVIsCuebJzp0mcU5VSKDGQ4UGuUptfUM60NgVbOSx8KavR?=
 =?iso-8859-1?Q?16f3k2jqM98CO2PYdgVFhe/ioiTip0tiN/0/qscTsz4TH2n9n5iCYYmDm/?=
 =?iso-8859-1?Q?4HtfooOwFT7Bs9TQ3mZIPg/dXnOX9umX3rB1wLgUOuqFx4xp8revY0vcZ2?=
 =?iso-8859-1?Q?GKcfcZL16VpeVmhsUrafKmvXWrJAHryyZRGIv7jt9ui4XK5+H/EE56noH1?=
 =?iso-8859-1?Q?LCszRevYBkdbogc+hTJibbsebQ8y3Qn9Xh+G4dd0Z8AcfL6SOtpPOlXFEQ?=
 =?iso-8859-1?Q?bdYUZ7uMvzkHLUxS00pVlvQg+szL1R0IqKyzd7BO0DlLKEsZ5YKTy2CAXt?=
 =?iso-8859-1?Q?XLZ+yt/a8/+YSTtG25D8JcWE/wDB/LVnMTRHExYUeAe9la0ZXy5gOBYC7I?=
 =?iso-8859-1?Q?2Y0tV7InabNTxFbB+w2+jbxu49rWo26O1qoBR4tTRJ/x5qtTXF97kPpfwn?=
 =?iso-8859-1?Q?oZEtoF9inWT1M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:41.9166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a63f7f1f-a006-4bd3-43b0-08de3f16c894
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9BF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9322

There are times when it is desirable to have more than one return
value for a hyp call. Split out kvm_call_hyp_nvhe_res from
kvm_call_hyp_nvhe such that it is possible to directly provide struct
arm_smccc_res from the calling code. Thereby, additional return values
can be stored in res.a2, etc.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b552a1e03848c..971b153b0a3fa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1208,14 +1208,19 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 #define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
=20
 #ifndef __KVM_NVHE_HYPERVISOR__
-#define kvm_call_hyp_nvhe(f, ...)						\
+#define kvm_call_hyp_nvhe_res(res, f, ...)				\
 	({								\
-		struct arm_smccc_res res;				\
-									\
+		struct arm_smccc_res *__res =3D res;			\
 		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f),		\
-				  ##__VA_ARGS__, &res);			\
-		WARN_ON(res.a0 !=3D SMCCC_RET_SUCCESS);			\
+				  ##__VA_ARGS__, __res);		\
+		WARN_ON(__res->a0 !=3D SMCCC_RET_SUCCESS);		\
+	})
+
+#define kvm_call_hyp_nvhe(f, ...)					\
+	({								\
+		struct arm_smccc_res res;				\
 									\
+		kvm_call_hyp_nvhe_res(&res, f, ##__VA_ARGS__);		\
 		res.a1;							\
 	})
=20
--=20
2.34.1

