Return-Path: <kvm+bounces-59580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F74FBC1F23
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 17:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D3A19A1186
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 15:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF712E764B;
	Tue,  7 Oct 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UoWPaleR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UoWPaleR"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012061.outbound.protection.outlook.com [52.101.66.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B72E6CC4;
	Tue,  7 Oct 2025 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759851367; cv=fail; b=DWXBjPyoBZw+Lfg4OUdLS1BsjQg7xCaK0ONN8q9fGcBxcUWe5QSXGPcy4G4/lB20KDTEi6dcd5v3lZQq/DWsj4z2BnpuBqBNub8mhJ2KDoh0HEX63LJ2BG8x/NY7fnLnGxPTEi5xGSLdrbgmO83qLUMoQvrO0NimcusNq4LKi9Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759851367; c=relaxed/simple;
	bh=Get2MfRVhVfai4Z27hv7M8Pxi+UQmjLIBgLn2ZKzgUc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lnLJZJ2r+V/EgCoSLypDdgQ4Xt7m2Q3pGGSrQYCB11j3wVXdpxsWxpxdOAc81txk+hy5uzQJ2g+25a+M6JoIJhFHqBUUYBgyI+6W0hruoV1EfLIlZ2+/b+h0MrWkbW9ienmw1z6LlGWWGZJpW4AzrZ0JIOAh6tYIMwoNUWLdrFg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UoWPaleR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UoWPaleR; arc=fail smtp.client-ip=52.101.66.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f0clCdivbRJdNIcFXdvUfKg+OOmL4rKVFoKMz5BVh51jzVRPevifds5o/32okIuloa9+5d8lBUgR6zmpSBhWdY3WaSxc4QJmhRkVGReTeRfYxgbigqk655jiIwAu0sLgDm45G27ecUTwQNYeERNO/JKZqITBXglHmPbAVO9BZxhSsk5AKQDgTS7aJKmibVHNMf0gBqkXHqreD0dw72PNznrQ8qCmtgvch5loJCYNnHkELi9BnLKUj58ZRLKvv1IXXbfbvDJMJhsqPhkRrtFr1s0728q0X+syg+D3l4Uwrtg3Lkskctv2nOO/1zJ6y+Cc7xc2WmWNJ6NqrbIm2Hs8WA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=QTIgm9WDTIa04QTESY8tNn0l26gbijSSslxZ6BZONuca+gMgh+264Yp+kL+WI1ZZrLOKZaTzBYZZj1n8D1AOPuzvmPYAEhNCBnUHvb1NZU6HvPp+9tKtLovHLv/GXgGO8O9SnZs/NmU0lbFzPX13uPC9tfdRXUmLJ+I+LISVV9AZE1zhLtBMNoKeosqnBuq/3ReGVTImrZCPphWrLy9OyMAb6DYtcUV/BkQnoPC4csivP160vqufeIqJRYz5yxOGud19a1Qdwxdrz4M4tr30gHpr07DPusPufkFZhjNsjG+owoE/1Kg0Lqjbz/o9Qbk5CFz7x4QI1Foqh0IRBi9Btw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=UoWPaleR4yQkdokNZTUop8HiY+SydqIg83kIBjSrK5YrkE6Q5tsG1hoQUFx0vLWDshtny8Q1XRq0elc7xZy6F+p4oB2L4neuwhSeD6D3gXW17IkR3Yp1Z4Yiv3GHRYWNQ4EI/zVML402Vn3YTQ/i7X0MZIl49qDfGYx6bEeT3tg=
Received: from PA7P264CA0283.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:373::7)
 by GVXPR08MB10937.eurprd08.prod.outlook.com (2603:10a6:150:1fa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:53 +0000
Received: from AM4PEPF00025F97.EURPRD83.prod.outlook.com
 (2603:10a6:102:373:cafe::54) by PA7P264CA0283.outlook.office365.com
 (2603:10a6:102:373::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.16 via Frontend Transport; Tue,
 7 Oct 2025 15:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F97.mail.protection.outlook.com (10.167.16.6) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.3 via
 Frontend Transport; Tue, 7 Oct 2025 15:35:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZetqtzOE2wWbQzQmGJ0wwgnBgi4dM3/bOxvrDN7LUmcVMThJzYW60xPyaq2CnJwIFOxz5iLzqpFeEI/3SJJ/UzVgtat4Feg/MTvrOyM9NrTn91DCyWEm47TRBhW881gY30gj0/9liLbRyQ9CWj/uGx/2FZ3U431t3aq3Np9z6WzKfLpNPxhd8l2q1tWRO4hkKQ70ThpdMwqx2hOtO2KErRYALBQtbnFcVCArU+iYT0ioGXvqZexKxSznJ/eK0pmAterbFpybMLtQxT0lJ6GQloopgUIjzTWkRNnwzOQJdxpMtIHtLOenpq+HscpJ0ePW2Bl8u6z2V4YDmNsaXXf9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=v5qh+UPPPdzafq54KySaDtvGzTDBwaSPoAOaexGFWbuo6vA6R8J9iCPQyjOQbIWcGpiHbgRfWL8z9j/KwmSVrByp+dDtZzXzv7opUTQcNGsCr20IudszfO1k5yARAzB53LL6BwUEJXTEXD06vWibQ65+LQXtMVXzYAYQDzPehK2+Tzsn5yClVNtJI+ofH66l+fJcCmownv/lrOX45JBXn2RCGuekiX4uzNfwXTfiCvEAHgCYc+TMiP/FyCC2IAqRV3QW2a8chFHfOgj6C+hk3yl4jyvRzEz4O3kHQWl6FyTkkiAGui04KTvGs7+gbqWb7iNEqlkVabohaHKQGYgucQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=UoWPaleR4yQkdokNZTUop8HiY+SydqIg83kIBjSrK5YrkE6Q5tsG1hoQUFx0vLWDshtny8Q1XRq0elc7xZy6F+p4oB2L4neuwhSeD6D3gXW17IkR3Yp1Z4Yiv3GHRYWNQ4EI/zVML402Vn3YTQ/i7X0MZIl49qDfGYx6bEeT3tg=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by PA6PR08MB10593.eurprd08.prod.outlook.com (2603:10a6:102:3c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 15:35:14 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 15:35:14 +0000
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
Subject: [PATCH 3/3] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH 3/3] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Index: AQHcN5/6qA2RSo1eqEiJHYg8JY7FlQ==
Date: Tue, 7 Oct 2025 15:35:14 +0000
Message-ID: <20251007153505.1606208-4-sascha.bischoff@arm.com>
References: <20251007153505.1606208-1-sascha.bischoff@arm.com>
In-Reply-To: <20251007153505.1606208-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|PA6PR08MB10593:EE_|AM4PEPF00025F97:EE_|GVXPR08MB10937:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aedf28c-c263-40f1-f013-08de05b7330e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?uNUhVnFg1ZfB9QsMaR2jdsIr627bIQ7T8B2jWt1JMzCYCcsJRqR0n4ltnS?=
 =?iso-8859-1?Q?H3Lgzx7dWDkDzhCIwgSn8dO+OUA8X5q5I5PXdYzoziFqxCNGmPf9f8lN0e?=
 =?iso-8859-1?Q?fsmZPBB9rtp1VXdmYyuNu0QxwqE09S07dyIQgypyR5JPaY9p9ACj0C1Lpg?=
 =?iso-8859-1?Q?iGAdQ6gzt/dGqQEJsZkl7rmQVHDJ2Eu62haVzReh1he4wOMqHmnmfCgpc0?=
 =?iso-8859-1?Q?rzn0lASHE6xV86PU3j7koZ4yrVnI3M3yYy7KpPjzUihCMidchEtpRv2a2O?=
 =?iso-8859-1?Q?sGDWhd0KfDe7VC7/1x7IbqFYmuDOHBvdn43OOKD2XJl9uw7SGvsWnGJoOe?=
 =?iso-8859-1?Q?y9qqrrIAOqAeAFaoWWw90ckuStbogP1NuPAk67g9h1tvEQKXy/rHyATv2q?=
 =?iso-8859-1?Q?eKScgkMuLJfk+mOTruJ3dfwpS4aLOcyw/Gczx/sead70BuJFgi5SPjljCW?=
 =?iso-8859-1?Q?Nw/veNb0uqmv8vfkzPN65CZqI0BzpoJB+C3fQ5vebFKbSgsKQQ9e4fYNki?=
 =?iso-8859-1?Q?zKutvk/z0/blc3GdrZrWgwchYxyLKzERzibq4tDrW+4Ih9NX5bk5G1G1KI?=
 =?iso-8859-1?Q?DVodmuscU8WAKJcxge9CemmmErODmOJEjcUmAhsDhV8oi7lyWxtmrjlXff?=
 =?iso-8859-1?Q?V9uVrFYT9gwOh4EzxSsT3eBiU+YOw6XdRrf6bujdMEJIAl90KHWf5FkHox?=
 =?iso-8859-1?Q?3hvG+2YzFf4taLKuRtLgc2I7nSV5dRBsLGJyHOKbl5PfKznD/YvYYBqwII?=
 =?iso-8859-1?Q?afYIrlzb0CmfN72AVRo2TTQENdJZGqPnIZv0ZYsYDY/Stxo42uGQBFJWNi?=
 =?iso-8859-1?Q?PF77Ucdj3RofnN77VbW/CMKDPUBt0VV0GE5L5+fUjurdZm0T9MHBSAdM7U?=
 =?iso-8859-1?Q?rd+COL22dNr+04Jp8jSRG/Vpr3E+a9e6/nNHfuC4D2bWFO7JDJPoYeikqP?=
 =?iso-8859-1?Q?bNfksYEQlDXzL2qEJ4cWA6v5z2w+45uTxwVvC8/umRTh4Nvmfw1+YBjrvQ?=
 =?iso-8859-1?Q?A7hWXvJ3aK2Css0sILcUkdpUVpBpYJtCfpxjJ51z5JxkChoVQbigkS4lI/?=
 =?iso-8859-1?Q?IFdVRonUFuKuxTQk1dXbCsXZ/JENVXBF0yci5up/O1Pg0noWNMkgfrpH1D?=
 =?iso-8859-1?Q?70GyLmZ9ql0alV4Ffb33AECb+XE66V5b00u6aMiCDbmUMG6xQX+9IgYQ+b?=
 =?iso-8859-1?Q?c/BILWAPZWJrUbmtVepSeoTqsX3IZ81QfF2M87ADBjzpaJ8IxkeSQwPMNo?=
 =?iso-8859-1?Q?JSPmPYLv3VobC5ntaGZHmJ1P2VBdKuDfwbFv0ahxcG7v97jmB9lxhJXAbU?=
 =?iso-8859-1?Q?JJN+e5BysQbFJeeIi39N1b9M60gCMSx3vJ0/+uMumbfY6FLoOTM6CWGua9?=
 =?iso-8859-1?Q?XcsZWo9mO1pFuN9JLgYw7mUVT0lXdG+Kixg6PLneEC7EMBir+Z4OjVtUaC?=
 =?iso-8859-1?Q?AYzvo5jDfXUVYy8SWRwH5NVpah+a+Ub3lBHhdKfw+7jB9j+F8wne8PShhD?=
 =?iso-8859-1?Q?tzu/0guJTkfuWdbj8e6LmW1Rtv8YBXGD6M1VmYU4VAeFg9vnnlg2w4a35p?=
 =?iso-8859-1?Q?Um2BfDN/4y/iQD2cuxpdzUggtSNV?=
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
 AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2494289b-9448-420f-9032-08de05b71c86
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|35042699022|36860700013|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?F+eCbeqjj+Ixx9s6hTtS/aVEm5Gpc3E/iGW+/vkiDwyBciA4iA3Mz5QTOD?=
 =?iso-8859-1?Q?2jnTvMZdqkCB5wchMXZhF69ZMz684+tZiifcbbXu8r8LlMtmMGNQH8v6Zg?=
 =?iso-8859-1?Q?JsBjORuu6dxgPnG8xKTd/nJFOsN4W+wZfzqKoowa0PRnxxYyj8MvG+d5vH?=
 =?iso-8859-1?Q?vQUjORj1KJ8rJwU7WOivvwcfJvjRb7imJ6D/50seo+Z3J49/PTqgZ1Klh9?=
 =?iso-8859-1?Q?s6bacqaXmT7MWuRYdRVKjp8J5uMO8KnWHE8971m9w7tccpkjljd/c9mBI8?=
 =?iso-8859-1?Q?qvPWQSzMkhdFUCoscYgVcrnsejcsp34H0gMhas5gic+FIKo5XWjUtN6Nwr?=
 =?iso-8859-1?Q?HECUM4jC/Tize/OgTXhm8j9hzW6wD3dTHc/k7peOq6SH3EdCyU+2+VZB+D?=
 =?iso-8859-1?Q?NhgsS5y/d1TVtIuqF3DwXvJ1exW7yPK3nZLAKooiy7+3XRHaZok427TGnE?=
 =?iso-8859-1?Q?3ymfLyKuQJg6oeciJJc6U6+ThdX5Ut2vGD+CazZJmiTSbqe/dgeidfGh8A?=
 =?iso-8859-1?Q?T+wh652DvQhFfe3nrF3CHckdy9fTLCfPQjc+sBXk+M25U25D3uFLPHjNR6?=
 =?iso-8859-1?Q?2RYAXkGl9g0cRKT062LlfKL5YwHTLu2j+l45X9tUpJaAwTtwdPe//DBQAJ?=
 =?iso-8859-1?Q?/aIdj6+4MwSnhbyx4rU6cvCuj4Mq+cXQKgJuMuAxKMa1tGpa4Xf5qIikOe?=
 =?iso-8859-1?Q?FYFWlnsZj4PAb50tJBCIZgi56wqYjddtegtvyZyNZRsz5EuByGy3kAtIlE?=
 =?iso-8859-1?Q?l0vi7Si5Pmtp1ojHjMz/1NKqAYHCR6HSF0XjsGibLNyxk0Wx+PAq2SmPub?=
 =?iso-8859-1?Q?PEOzHz3hpr1QgaHUWkLGze+meCpE0I3fUH4okwJEf7cdU2elpk6m1BOUHE?=
 =?iso-8859-1?Q?Q15VkyH/w4xKXBX4wfdMk+mbDe6RQ6uKxwqAs3UIV5XvGRyIlYBEgFvKaL?=
 =?iso-8859-1?Q?at88/X24zJLWM/tOLhF3SpfBI/8PKSxUfxaazWDkQQEyXLxEtiyyfEBmLx?=
 =?iso-8859-1?Q?n7Wes5eTNM2/GBqC0B/muIMZukJNrr/pVtxEKHf1nXBqFl1IDNMU4FpHKS?=
 =?iso-8859-1?Q?oGEnDrm4cDz7TKQyJ77xBDeiyOXCjiNz7RGOdbVHNK8KauJooRDKhb1hFd?=
 =?iso-8859-1?Q?TGoUUxXMXW0tBx+/ee4dys5OeB7yB8GVBW1fe8tQZFOhWqiQyjZAUsgEnU?=
 =?iso-8859-1?Q?e4wQ3aBf4Tj5x7QSTMtRmTPAWNScOcynoQUd9AQAwBMgtY8wJ5qYxVoifn?=
 =?iso-8859-1?Q?SCHz4l1MFi3AaHbHCxMtAsQun42G/hcB0z/7Bc4nSx74Qj/zvQQ0rpBlak?=
 =?iso-8859-1?Q?lOvE/MK1bVcovAR/WG8QTHk8fVzxUU9XvqAzkqZjfmPzRjOqzHWHQOPqPI?=
 =?iso-8859-1?Q?EvtLvlwnjVgCqD1vhmS9TS5YP2FyjTAVy3lBxzMFrFzs5xwU/7knCc1Su7?=
 =?iso-8859-1?Q?9vc8jGlTNiEOK4V/qbj32vmoD58y727dNnaW81slU9+ratxO2Zz8fZD1Av?=
 =?iso-8859-1?Q?XtDadjXlxv0u02Fd1XHQVz5i3D13qIQCKLvczkBHoHPcgdUlVlwvUGpzFT?=
 =?iso-8859-1?Q?YvAgwb/RjhJWhk1tH1gEwfPUoCDFpHqTFPQbIMqNaPE50OBFSR8pxg1u07?=
 =?iso-8859-1?Q?xRDqq4FT7JpJ8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(35042699022)(36860700013)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 15:35:52.5786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aedf28c-c263-40f1-f013-08de05b7330e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F97.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10937

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 64 ++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 42 +++++++++---------
 4 files changed, 51 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 6604fd6f33f45..06bc0e628b03e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -571,7 +571,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -999,26 +998,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index d81275790e69b..c90608daa5b2b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -567,11 +567,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -644,19 +644,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -756,7 +756,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -804,7 +804,7 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr))
 		return;
=20
 	/* No deactivate to be performed on an LPI */
@@ -841,7 +841,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if (FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -857,12 +857,12 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG0_MASK, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG1_MASK, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
@@ -870,9 +870,9 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG0_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG0_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -882,9 +882,9 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG1_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG1_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -908,10 +908,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR0_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -921,17 +919,15 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR_MASK, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1021,19 +1017,15 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VPMR_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1056,9 +1048,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr) << ICC_CTLR_EL1_EOImode_SHIF=
T;
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1068,14 +1060,14 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VCBPR_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VCBPR_MASK;
=20
 	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VEOIM_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VEOIM_MASK;
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 7f1259b49c505..cf9c14e0edd48 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -199,16 +199,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b01..f9dd5b6c57294 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -199,25 +199,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -231,10 +229,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -244,13 +240,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

