Return-Path: <kvm+bounces-66365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F60CD0C01
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD208306B6CE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9089036405C;
	Fri, 19 Dec 2025 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l1W9hhPw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l1W9hhPw"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010055.outbound.protection.outlook.com [52.101.69.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730CB361DDA
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.55
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159639; cv=fail; b=qqwOrUsm8UimLlkny2zNgjdGfFwhmfCw3FfMXa3lqM6AdgBGKyiYhNVF9dywbjzqZtM7fibvrw8jccy27Zbr+3CvSiZFuL7pQwbvzHh3I1nI6CFKjNOHJPNLdrI9SaFHj/iBkbfFMu/Fe79WVLegmIADDrpUJJlG8LqYEZxYXWk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159639; c=relaxed/simple;
	bh=G5KYpXeQqVNGbsAp8qcR2hxzHFXxXeufipyPud6oNeU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bH7UmK+oznUzGLf/c7iHZm0/TLFicTnkxJBko36h3jm+xHaCidjEXyQjEmzYnXRE8s8qV48tzvWIOql3LY2b6Frhh0keqSk3SHCy5HJWwLMUj9YaAKIBtMAmzwvHNKShFIUsktzKv/porALnzZZ7g182uHP4jE9UJc6emiWI45k=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l1W9hhPw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l1W9hhPw; arc=fail smtp.client-ip=52.101.69.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=d1U3Xpfb+feh7y9zNPz0/TrXV3hBtEn9TzwMVGs4mr4nbw7jj9rFX0rW5oR+dMGWMdBUHy+FCqDt9GmceMJzOMa3le4el9We1HpdGIitASuDcLgM6il6vHVBmkw5ggGC4zR0hlV2TG1aEumGEqdoTPLOVGDheG3xKaLE9nyLIPrOiUKw1DclcKwONpG66Q41mLL9ZxnJeArUjCkn0BPDuqrtr8EcDYnpxnHjLF/lZUAxknC9c3JZVc+NRTWj+2jGlDISZJGeJeyeIojSnIYvjMbWQakxY0jvzDXv7OnXDWwZEnWHnD+Y4joK+TxEZ3xVefPSONQXI11u07PJ30NUZA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vMjgPU2cI/EqZAxF2mM7h+Ax+6Tq54/qhEeFKVnKLQ=;
 b=UGHb/fmnfdhPPrVbV4YVaZ6obemoe0qZNG4+KeUDEJixbt4Xa6UmLrZmxy9UHdac/VQ6pMCVp/hEw1qXiiCQOmMrpKdBF+mzZxcDlHDG7kEs+fm4aS9fj/UCjpWWTCBBabUFvJeihiQBFex8mV54BJ8kA/DyZMa/f09/5ky4NElEh/Mkb2HIUP3toSsoh9UiaZf7qWY/nt2fYI7EjD+eZTskMSO/gI6HbWZids3P/fYmF+SVe2Xt4c/jd3YDb3Xan6OY1hIEfKs1ltCTnDTs8flZ5QDILTb2/u8YoiU1Awi4iFusOJH+kn5EGStuwUWzbXxhKm8z0HwxS28B2zyvOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vMjgPU2cI/EqZAxF2mM7h+Ax+6Tq54/qhEeFKVnKLQ=;
 b=l1W9hhPwdq5wpWOVymiu1Lnc9Gno0njWlFjgcd04NxmaaVPQIhOi8x+X6ZBdTwHv8MBWRVCk3OmyZKK17KYrUgWHDiaLTcx/1rHPeCV139h4ALkiKPgyK2cLVmRXL/0D5dAe+fHkzgBVHfLCjxefNmcLJb6VYiWfSS7QY5v/5t0=
Received: from AM0PR02CA0168.eurprd02.prod.outlook.com (2603:10a6:20b:28d::35)
 by VI0PR08MB10709.eurprd08.prod.outlook.com (2603:10a6:800:206::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:44 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::9c) by AM0PR02CA0168.outlook.office365.com
 (2603:10a6:20b:28d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Fri,
 19 Dec 2025 15:53:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nc1LXKKPzgGzY6UV+Z+PJDPHcJO6omKjsVNRZdQbU/KE5klkNxEh5n5QxPW2K8XxeHQehxOlIft0Wqr4bRbeiuqcs/z5Z2D4RT8BBGE5b4EPGKF3ujwcmP1GCQGrw8A8S/f0sUJfH3pWeJTa3NhOlJd/vjl7uONd7vcga8A14BR4uIHJtMUmznOr1Dt/1GTSc9qNBrNEOFOiPpSLOQDERYK4KIWpFGuqbwGopevghSS9Le57Vij4oS6Xd4YoF5BUwxpoWJjR4U/fPXNFXTDusU9XpDcebrwQctOQdduz2TR/3z7BvEPLBK5NqbQIo5WefrfqbcnQ+UqI2eLD+ra1tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vMjgPU2cI/EqZAxF2mM7h+Ax+6Tq54/qhEeFKVnKLQ=;
 b=lDot9t74VMxYZSPFV9+Q5HaMw0TEIdSjI1ihf8uIG4aqp64DUwbw0qgSuxbx27dkITN76ofUYDTpN4nzHcaxEd9MhB3mR11ylWWa9vFMRV7AoUOUuip6Ysy7q5QyW4pOVDztjXoV4ahpJ93Px4U7Aj1pMLwZ324u5dsaOEzkuTuDggegeZzE4FE6DDTuY5a2FjHoqbchROrwl8ISqgg8/qtFEY/rOwjVE7fWko09Ab3fO8LJRVzQrfIZANQADPgs0i6aWrymDbdCSFg+FDMkUjHEo/9nQjjnqLza8Vhbzcezbua+gi8hyGCf/rtW9BrKM+gFR+ONoPxYkDILWtiKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vMjgPU2cI/EqZAxF2mM7h+Ax+6Tq54/qhEeFKVnKLQ=;
 b=l1W9hhPwdq5wpWOVymiu1Lnc9Gno0njWlFjgcd04NxmaaVPQIhOi8x+X6ZBdTwHv8MBWRVCk3OmyZKK17KYrUgWHDiaLTcx/1rHPeCV139h4ALkiKPgyK2cLVmRXL/0D5dAe+fHkzgBVHfLCjxefNmcLJb6VYiWfSS7QY5v/5t0=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:40 +0000
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
Subject: [PATCH v2 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v2 11/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHccP+APzwlx8MbOUCYBmzg2uKwhQ==
Date: Fri, 19 Dec 2025 15:52:39 +0000
Message-ID: <20251219155222.1383109-12-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|AM4PEPF00027A68:EE_|VI0PR08MB10709:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b905f99-5ae8-4156-a669-08de3f16c9f4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?foT795Y8LI2y6vL8L0sFnkbJt0EQ23nMaFoXy3R4ZS8Sg4+kN2Cd05uWSr?=
 =?iso-8859-1?Q?05bb0JKuHjJcGu1dKjVDw6i+a3JdGyzGVq0YR/2LDPuhpbxcrShqxE1XZT?=
 =?iso-8859-1?Q?PiPp8ZwELAjbibeEUbhQCV+ptnFLcM/34ejX8P3wDUNnZiK23p491BAq09?=
 =?iso-8859-1?Q?AAqtpJk3wxhivbmpeC7M3WC6AFWA7PJxDTyIHdr+hw+DkAK87IurJ2h+qG?=
 =?iso-8859-1?Q?CntDOZztoL5OswccPMoC0yGmRC8ON2lM83PoR8DKOD7qFO2CHV+vvwLJFT?=
 =?iso-8859-1?Q?bRi8FLJO4kCa8qz3CEKgAzu0Q6tbkaKPjhPIsbq/L2gOcW2YowT269Fec6?=
 =?iso-8859-1?Q?dmaxM8S66otx0Ljye+r/WMsVbtWaqa5fYX9IjMrZkfEp5v9zWMKHfqucuV?=
 =?iso-8859-1?Q?hNLEw66irlL2q0jyzP5zrIacFph2pL7IzwQSZCa+FgWabNXITMn1bvQH+A?=
 =?iso-8859-1?Q?LJkCH8VB0E4F+rh8v91vvXSOK4h4Nkg13S8kd2UM/+L741IGKcxx6sNHX6?=
 =?iso-8859-1?Q?SKpvCBz2wKoQu2Y4QdhrwuIK6DrOEWO4ysaXq2ChFrW2s5oWRjU/VsXnFM?=
 =?iso-8859-1?Q?dFrUXVHvBsczBZfhLM9RDZlV0pIcQ+tAeZPqkWK73IfAbyG7FLOKMKcpG5?=
 =?iso-8859-1?Q?cpyfTHgb57Qo5rwLY6QPcgutAHg4IjBAN6u1xuDIvbQnmSeZuhjgkBExMZ?=
 =?iso-8859-1?Q?S+Sdtrj3+mMVp1WZzQ6O8fezoTYhX2gikwBW6AE7o3gNSS6PXMOv9MyUc7?=
 =?iso-8859-1?Q?ltSoEflwuKjd44Jl69O1LrT3GPxlIG71XCq08eWzT1sMCdgse4IzkuyrCC?=
 =?iso-8859-1?Q?+Vs2HpJmoulqR6K/TRtYEkweYlOKGfkJyHqvWOejwPr1Ovz/fkm4brHU/m?=
 =?iso-8859-1?Q?PUIM9d7aySBSHYpJp8DTRWHhZzL7JjOPJZ+XG7bQJp0HsHW7T41szmJvL+?=
 =?iso-8859-1?Q?toWoCbWI+gAiHOCnM06C/jRV3oDxjQalQliX/HUWIwOojn0hN9DPn7KmiL?=
 =?iso-8859-1?Q?QlAaAs3SJjcDfjl9ZXdcu3YOaqaAyQ2J392iCajpoKbDmo5B/C3e1TtFN0?=
 =?iso-8859-1?Q?ShoiA6Oi4ErTrwrZSjgVCl4z/6+XMzoEFxm2611KZM6tdCZm3Ov/c2H9bE?=
 =?iso-8859-1?Q?m5sPkzbzvF2/Azx+q57blDj+hAai7HopwLpAmvKL9mhToslyJq4MI7cHSp?=
 =?iso-8859-1?Q?LBguUv8rBDOqyllxZ2jIicIJPqNzgAykpfjHrJBVsDV1PtApNr0MneM7Ju?=
 =?iso-8859-1?Q?tjmDlJinSeuaSEGIS6zhnFSjSJlPdho4aSGpy7pFVNEbSDM8cvwzm/X3m2?=
 =?iso-8859-1?Q?NC5e8Kfj8WNzv1XFy3ukPR5Wts4obVXp6G08sSz3AGtdTIvicLp6Tcm967?=
 =?iso-8859-1?Q?qFnR/WGHKnurmZtY1Q916cxEu08UIy9liQTftaO88veL1ynYrX+YSrr40I?=
 =?iso-8859-1?Q?E+ZryXiSpEpvj3DyUPd8YhgmB2iPIkJB49eiRpeqAupGuI2IXon9RamznE?=
 =?iso-8859-1?Q?2Q6Q3p/5cjX5m6VxTP1HoSap8ZCZfnMSjOfgSVuR5Y9egI3igx+9WMfOMl?=
 =?iso-8859-1?Q?XY7YLahurNB++kEzTV5xl0iYpBA8?=
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
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	70250826-656c-4d45-f821-08de3f16a40c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?2iKpRN7k/migS+AbIFJD70gtwgXMiyCu6CWgebgcUmySsQbkZThof8liHJ?=
 =?iso-8859-1?Q?W3LhmtJ5I2Az2elygj7HuIKK1G3t+9AbL6sxisD25uBcbwSM89tVujTlGU?=
 =?iso-8859-1?Q?SL9AhgPFTmeSpq/FGARGi71+b6W+bk0sEm3GtJkwty+aeC3Znx/bnsleRS?=
 =?iso-8859-1?Q?Jb4DdEPLSTwkuMDSaam/ohco63twYxy4xvEcG22AiZMiwK7iqn+PgFXsT3?=
 =?iso-8859-1?Q?YH/gvByhL40jVC05WmJ2VGonEOYMzuCvxO3EDmltdKRPjOZKvEbHURcVHN?=
 =?iso-8859-1?Q?kjy4U+Psb5N9HboWU3oGgF97RX3CI9YCM4UbODNLBij9ckUggPhB4a1Adn?=
 =?iso-8859-1?Q?+dlwkRPjYnzAhyPTqIYYJm6U9FrXLL5+9eiRZ6ioEnQfLmTQJsslFvpP+x?=
 =?iso-8859-1?Q?iUYz/P8yF44zuMccMr9/M/IH4ut0rBwXgbhZJJsR4R8CzWgjYDPF/sMEbu?=
 =?iso-8859-1?Q?eoSIUlApwcQbK5Dui2b0Xaoj9oHvIQUga4R5eFwssiU9ZBve8ayz2mRBBc?=
 =?iso-8859-1?Q?tW2WQRNMzPh4Dv6SqWrmeccmmsegwb5cLufmYoAgk+a0oQxLZxZ+HXiIu/?=
 =?iso-8859-1?Q?QCEPqvrnxoSp6RY3DRuu0HwY89oE6lhdtvsG9iso0Sji7MEDvy3+0/g8Sk?=
 =?iso-8859-1?Q?01HTVaCUoo1oDOObWJ4nfyLzmGWuQaUklSq5prWcpk/ieJ4tQ+Q47voyKp?=
 =?iso-8859-1?Q?wcqSeGSJhmpr4c5Zl1iWZoJUxIXqSug0bp2h0/vWm3JMS2+jHqIZsA2UAF?=
 =?iso-8859-1?Q?hteOvSqXSgxN4184OIfviIZZwSLxJZF6ptnGgNzUTEXCgr/plQh4eb7D1G?=
 =?iso-8859-1?Q?yNOn5tmGhclpZuydPjcJqhvlsbVxMImfdK5HV6bvJC9kj6ZdGNxm7yZYXn?=
 =?iso-8859-1?Q?6CIAzfcqKPxfx7AF5b23PnqhPu2L52H5Ixhnjhqu+ghduukxV5NbxTEz6X?=
 =?iso-8859-1?Q?M5y3xe0yFbtRldURIJ0ebCfU7Ijljzo2jkkl+zgKcanSUxKgTCdO4antv4?=
 =?iso-8859-1?Q?2Moxjt8v7pyiHzzsyyJIxB7Whh+WpPySxDmKKd0v73MQ0nBun8tXVdpRbX?=
 =?iso-8859-1?Q?D1qwoEENzDCjs/K3Jnj5QCIA1vZhlmrgjlMbtJtuAo0Nkap0UcYz+xeubd?=
 =?iso-8859-1?Q?fuTW0hViPH2rJaGwtqkuMhK3J0rWh8QUxnidBztobHk5sIbmlnofFChcdZ?=
 =?iso-8859-1?Q?KyTtj4d2GM1rWOykl7Qn9FSCniD4fR0D7c1iq99q15Sk5QFq6mCXAwNDay?=
 =?iso-8859-1?Q?YY7fSpbSsdAgvTXppSngNfKlGF2EDxJQTEvvw3MIka4aqRoph/XM9Mvxxe?=
 =?iso-8859-1?Q?KuziWImaQ+I1D7RI03WdbzgAdyq9bkP6YkPjVIwxZqjeuLrwDFqZxJv2AE?=
 =?iso-8859-1?Q?SdwYWP8Qvmt3B6rEj0DVnHSWqlSE849zvAdXSAb9t8VI7RoL4gq0XB6O7n?=
 =?iso-8859-1?Q?wmKdwkj5jDOVQnCcwVk9VxCcbHB8g1WcBeucNQhFVRkLBE5HQ6FeKmkcS5?=
 =?iso-8859-1?Q?UdOENBQxcNagnxEIC4T2Rc4izL0o6SwjAeNonH2OmDc5r3fvEzOepe8bqY?=
 =?iso-8859-1?Q?jhloPd5Bi8AUsHExAmgjYSLBhgPApKZ/t3WBon2l0JwLVyD67S2uIENAlA?=
 =?iso-8859-1?Q?LUFnBqMEvUd2M=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:44.2260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b905f99-5ae8-4156-a669-08de3f16c9f4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10709

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_host.h       | 19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |  3 +
 arch/arm64/kvm/arm.c                    |  3 +
 arch/arm64/kvm/config.c                 | 94 ++++++++++++++++++++++++-
 arch/arm64/kvm/emulate-nested.c         | 68 ++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  3 +
 arch/arm64/kvm/sys_regs.c               |  2 +
 8 files changed, 218 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 971b153b0a3fa..f08c333d8b113 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -623,6 +626,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -652,6 +659,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -664,6 +674,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1637,6 +1650,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1651,6 +1669,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e690..14366d35ce82f 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4f80da0c0d1de..b7cf9d86aabb7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2474,6 +2474,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 3845b188551b6..5f57dc07cc482 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -219,6 +219,7 @@ struct reg_feat_map_desc {
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1168,6 +1169,58 @@ static const struct reg_bits_to_feat_map mdcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1211,6 +1264,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
 	check_reg_desc(&mdcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1342,6 +1398,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
 					     0, NEVER_FGU);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc,
+					     0, NEVER_FGU);
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc,
+					     0, NEVER_FGU);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc,
+					     0, NEVER_FGU);
+		break;
 	default:
 		BUG();
 	}
@@ -1425,6 +1491,18 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_s=
ysreg reg, u64 *res0, u64 *r
 		*res0 =3D compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
 		*res1 =3D MDCR_EL2_RES1;
 		break;
+	case ICH_HFGRTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		*res1 =3D ICH_HFGRTR_EL2_RES1;
+		break;
+	case ICH_HFGWTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		*res1 =3D ICH_HFGWTR_EL2_RES1;
+		break;
+	case ICH_HFGITR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		*res1 =3D ICH_HFGITR_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 =3D *res1 =3D 0;
@@ -1457,6 +1535,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1511,11 +1595,19 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
 	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+		goto skip_fgt2;
=20
 	__compute_fgt(vcpu, HFGRTR2_EL2);
 	__compute_fgt(vcpu, HFGWTR2_EL2);
 	__compute_fgt(vcpu, HFGITR2_EL2);
 	__compute_fgt(vcpu, HDFGRTR2_EL2);
 	__compute_fgt(vcpu, HDFGWTR2_EL2);
+
+skip_fgt2:
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+	__compute_fgt(vcpu, ICH_HFGITR_EL2);
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 75d49f83342a5..de316bdf90d46 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2044,6 +2044,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2118,6 +2172,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2153,6 +2210,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2223,6 +2288,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index c5d5e5b86eaf0..14805336725f5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -235,6 +235,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -267,6 +279,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -330,6 +355,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -347,6 +373,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index d3b9ec8a7c283..c23e22ffac080 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a065f8939bc8f..fbbd7b6ff6507 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5630,6 +5630,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1

