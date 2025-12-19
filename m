Return-Path: <kvm+bounces-66357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F600CD0A4C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8D4EB301D044
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6240C36214A;
	Fri, 19 Dec 2025 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LqOK3Pxw";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LqOK3Pxw"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012041.outbound.protection.outlook.com [52.101.66.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75066361DCF
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159634; cv=fail; b=DU7Kaw4znKIkYnSvR2IA94GbTochEeEU4S0wPrDqcackrBSGj9fOvmwYJyTHeESzzGMvPGivThKMTl+u7N0IlDTPvwYK7Vee4jqX0iRo4tBOsqvWq3ggfJl+agyeH9wN8yFDSqzUAAmEZH49cvL5S1+/JRTkC+R3TJ2bv1NODz0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159634; c=relaxed/simple;
	bh=eVI0KCAlkT7/xaK3ACiVyLmw0kxEnevakYXISUdcR9g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jxblvndwrxpWZCRplPjJ+LOvO9woA5Vi+U2fOAe2nTeJ7jCiV2glplO2naYAQ0NFWYh+nvkXdtY5mhssV3rVUwhFa8qAZUVyXwL1xnT60qYrg4v6tGtYSQSzJm3T5tGNTL5VLNBRGJRXOmIi8J6ar1VlZ02fIO2g7yLdxmxjZgw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LqOK3Pxw; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LqOK3Pxw; arc=fail smtp.client-ip=52.101.66.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wnwGbAwNDE2IOZfQvgGqcPFDLvMVRHjMo2rCBDeLuuFa6bKg1PZPDD9JxmIQO8eNppB0h2ISSj/DhuebIv6kUZLaqtbhO2f9j3SnVU/TX8Rt1MUSukx/bv/261kjMvilMRWITwCzRXvWY3OkiCg37wHvWXFIMnaK7x/I+LYKiImoaQBYPDjTBM0C/EVaxUvA5D9LpdSHDlNd09vkSc8Np1acQiYmAEy3QmR5C5sUBYVzLL+xmM4ZsHPpHI9Iw/aqzk5p3w6DoiipR5xdW0PWsJZBiAyqC8UFZ+tfRc3CAdfb9N1lHsyWB/dE6MNs0dBRc6MmEEpHeN27MC9nqvdxtQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teu+o7Wk3jwws1KAa5FaTwC+wWUgdNiDOpkoqbuuuNI=;
 b=BOF6U9cAl8iCcNavW9PQTuaBRXZBeLpZiHqPVHohgJMaRKxz4neewSfVVgdM/R/Mn12YS8vdjTJSSZXz6//VNKOJMBQoYuVWLJKd082gFSZFh3FedxCv5Np4UeFgdhMxuDY3EOKpGEWQOrovpamsFCWuW5vbe/xffwAnxad+t8bLc0dDcYIU5diNgdacI49YX1D49qSI/KHiv5UC8yI4Td8zmu+iEC5835BG/CJNktw64pgI9VyOdH75C57yYMHvnFGkjnGx8Y9n0ilK9u4Z6DkElmhdv9SrmEo+YBKHcDoRKc/oKJN3i71CjhsJ/f5y7gWJl9lpSqS6IkP91qZWIA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teu+o7Wk3jwws1KAa5FaTwC+wWUgdNiDOpkoqbuuuNI=;
 b=LqOK3PxwS1dyUvNmPYfsRG0sYfAlyiCxThop6qSqo7rKbeHuRhPFLYPZg6XbYPGBGjLm7sbeqbev+8/LHbEtOmce4RNoqUS0Ap1TEHHO5ekJ2lpX3pgwznh8rGe1lqoMrFvT7jeU1xIuKVbDXyVv22TZ7D0aPuLj5dAVdcvLQyI=
Received: from AS4P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::16)
 by DU2PR08MB10157.eurprd08.prod.outlook.com (2603:10a6:10:46c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:45 +0000
Received: from AM1PEPF000252DC.eurprd07.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::58) by AS4P251CA0008.outlook.office365.com
 (2603:10a6:20b:5d2::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 15:53:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DC.mail.protection.outlook.com (10.167.16.54) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tq7e4mMyCUuTVoGv1MKl/FpokE5hqh+HdhQRrxeQFO+sbD9WEYeOLqcGol/MY0U1NEQ6cupcxAVxO/y59SxscX/fw/qJODFVY5rK85BWQ7yy4JzViGC0A0F95WdYeAqITHLRje4Aytlz1Y+8jczRk7EBmDIDmzuNxxrF2JspiiIKO+Vc6DcLLd3SzbLzpswbsWxj2F7iWAOTUgKOwVmo5pbjRQCVsz3YiIEsN6/FSRcieLx6BffUz/9k73yLSAxeS0H4Wd5lJq5TFLJGVbr3cmZrISrX878XvjdCDXZ+mQ/GXO+xaKdjDMRJLxOamAykg64SqEz8+C8J/lmRTAbTFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teu+o7Wk3jwws1KAa5FaTwC+wWUgdNiDOpkoqbuuuNI=;
 b=W4W/1SZZw9QLk8FRMUXZM73DRFY013I6Fyt2pth7P9VVVgjBq1sZR8b6bGYSwd4Aa3oGFxW306dqIbnd+i3+clmnH7p8xxyxt7/hrb2kstIJW5NB2vLPEJxawgJr43hPXi+3JhqF/gfjzEu85h5enEVz3LLGokSj3omJm2MXV04RhEC5F+vbzURCJt5Myti7lVR+Vs1C6hRqK8ej2Mv62weqVyXEcNDHACE4FrkUCJvf3hBdms/NOg0VyBfPDeNAtXjqrmzvi1XqqxeX5g1BucFVjwnEKGW5mtwgkFCxtWpD9Fb4Gvvv+XZ4oWi9fdLctpiaNTwnDCzBjRrzVFAZgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teu+o7Wk3jwws1KAa5FaTwC+wWUgdNiDOpkoqbuuuNI=;
 b=LqOK3PxwS1dyUvNmPYfsRG0sYfAlyiCxThop6qSqo7rKbeHuRhPFLYPZg6XbYPGBGjLm7sbeqbev+8/LHbEtOmce4RNoqUS0Ap1TEHHO5ekJ2lpX3pgwznh8rGe1lqoMrFvT7jeU1xIuKVbDXyVv22TZ7D0aPuLj5dAVdcvLQyI=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:41 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:41 +0000
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
Subject: [PATCH v2 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v2 12/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHccP+B/RB3p8ArTkqg+/DsubAfBg==
Date: Fri, 19 Dec 2025 15:52:39 +0000
Message-ID: <20251219155222.1383109-13-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|AM1PEPF000252DC:EE_|DU2PR08MB10157:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2e90aa-5242-4c97-434a-08de3f16ca4a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?deISaMd+XLAdG7nkM7fWa4zOHuv+FdyJbMRRKObhg5e6Sq3M2hSvc+jprd?=
 =?iso-8859-1?Q?Z3h3YWbGSNu4gNwCviDOlFbimWRuGzUAXgjQH7mm+Fuo8E5mXXHkdDW3hi?=
 =?iso-8859-1?Q?2JuSAKj3Ca5yqFy9IwYbuT4q8tLMn6NkbrTsyURyb4e5OtOi+PapWtrnTg?=
 =?iso-8859-1?Q?fFefXNQ37aLJ+/+uo/HKDPdHPhOdjamjuUSKl5YtqUBJFCEvVs4EKMpZXQ?=
 =?iso-8859-1?Q?Y5LDMXkNeHS2BsnuEhYxNPlryyGEMbGhaKDdnHWrRtVX9s/O88qClR+2Fa?=
 =?iso-8859-1?Q?oPuuSmtH8TI7MKL9c+mBJEazB6wvxeMpTsZsEYk9e5FJwzWv3geGiusR+u?=
 =?iso-8859-1?Q?HzQzsOxXV+jc5kaHQPrX3fSPXBW8J3fsHK3ZFMpi5oYyNNkozzo/Pxsi7w?=
 =?iso-8859-1?Q?kxfNiNLvgxMaLFbuKlJW58RytX6RW6fJ1TdvZGJiWsEN/pBvJ0E9E12J/v?=
 =?iso-8859-1?Q?qJlrXhX2sQpO3++xkItRdg3dcxLI1aZ+skb0jet2wmuFJNPt/ckXoYLBvo?=
 =?iso-8859-1?Q?6GfzCyZIhQHsKBKXj+/9tw71rpjl3L2KUNrqZmdhowic+7JaeYH4zWczLp?=
 =?iso-8859-1?Q?BXpsMXUvJF9eo5LK60E4OOkQVtaU33N6yTRN7ZFaB3Nd8ZZv+Q87Yss0fZ?=
 =?iso-8859-1?Q?lkbjhHrrUvn/e4cqJHbZNs3xgTQhNnkhJbLMilKTnI8uUZG0azNlpU4QIs?=
 =?iso-8859-1?Q?sAEqiwJxjUYFvrbuiHjSuALIE44gRjqZDXifRR+u9akHBOZPy+cZBXw2Kw?=
 =?iso-8859-1?Q?YP5KFxSeQ6letIh1VoGtNtmdaHflbrIbNkFs7cBz1WEcwDRls0OOv3nEhT?=
 =?iso-8859-1?Q?7S46EBr9BxrpYk15OrIDMfmjbj508rYniw7haWKaqcoPiNU9/MswfAeKin?=
 =?iso-8859-1?Q?oMAjcS+DJGBwbQVfTyIUUewaF5pt+FqQ7oRdzSDZgkkuPVJX78NCMWil1r?=
 =?iso-8859-1?Q?DlIBkMKD9TZVJk5tOpJ5wPXt68qUsb4co6QlAd9ZMF94C3k+RoDrzZGS/M?=
 =?iso-8859-1?Q?Tgdew77+xMSu3mSeYwVZTvVnv/DwKY/Gi9E1azkAwNxKYlpRpT/M8L+x+g?=
 =?iso-8859-1?Q?u9NSVl80gyqp7I/FNBHE5qC1FW/Qai1IX/dUlTRPG5iTVS2NRehkpVgZCj?=
 =?iso-8859-1?Q?pKhyDkf9EWKBnQ6ykAoj+CGEl9tLd+bSLN3r4700+WgWHQ9Od/+ORwH8X8?=
 =?iso-8859-1?Q?og0He9svEDsC7ae1YrpQmJfo9IDxXxUBDN+k71eGXxDIlksph+8GmW6sHO?=
 =?iso-8859-1?Q?mkIeSmbRbmpYzYW0vsHlpRSR2wTLmGGExOIIW+PGGvTq9mpYsbHGH2czXk?=
 =?iso-8859-1?Q?ded/i/bjiZtBFGM9Cw1kK5I/A1PIf76V4nZySlkzMM9zneX10zJ9EwIRwm?=
 =?iso-8859-1?Q?l9SXIaIG462raX5mSr/a4DLcapQIEIXWv4r/QSr0SddcsETDeTQrzSXGZr?=
 =?iso-8859-1?Q?aU5qGUCAqDgK2jFLyZTwQ1Wnrz8tixQwo2eQc3boIYXqefvaVhlDA9iVFf?=
 =?iso-8859-1?Q?oPQpb80qQ7Fbq9S1efVSoxRLYP8f7/rzaQSHnFaH+ZDNY5012Z4dUIr1O9?=
 =?iso-8859-1?Q?yQeYGIo7a3J8YQqQq5LtaocvE1Yw?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2f2b3b1a-5893-45f6-c7d7-08de3f16a439
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|36860700013|82310400026|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?YggyPN3KZd81yPSZBp3Nz+ESDHvwvOGC+aukZspbi+YCTSPUe07B4IszdL?=
 =?iso-8859-1?Q?RFBMwzwHTjo1o1jYhDO1FkZlfjbWBKREvSJShqqcHFxKsGS8OemFqZdu8L?=
 =?iso-8859-1?Q?XAmGKCN1N/+2m6sHqajFXRo2s2ViFrScFyHCyaVC77QWFSr2YHfHSNwx5N?=
 =?iso-8859-1?Q?5lD/pHGxjbiBU6eVfQf1LraYmm77RKYB9U/7KnDv/yUHhg5Rl9qFx0iCBn?=
 =?iso-8859-1?Q?NcvJtJUFc40iA6fvD7SUbW6M4KA9cRQwwyS/Nzvxv4JsZIgOrD4Juc9tSp?=
 =?iso-8859-1?Q?BuEzS98wpXzd5dNMGcBrtPcEhi+iMDKSiKbFykHV1nNW8QgoMIiDPqNpNT?=
 =?iso-8859-1?Q?AL8+zd8oNcQbTyRrLUU619aQrD2473h+tgLn6DKhFvd+8zc0/EaoavqyDW?=
 =?iso-8859-1?Q?U/z+1TJU9u34mPjhHuGkbFB0fDeixVRjmEy6IbwRvRGU0kIJrEGBdbiej9?=
 =?iso-8859-1?Q?yvzmZEhkErlYlszxhYzaej2bKrJK6Hkhc+nig2GgFSjVw7mCaPklPjkKgd?=
 =?iso-8859-1?Q?0B88gwUFHOTDbXz4MOfibZgFzg+c1JrWF0GAXKsmxLl/D8gkHSFGW8dWDg?=
 =?iso-8859-1?Q?oxE7eXkWVcssamNLkJFM+rX6DG95vsNvznU+Fnm+GLOMLXh793AJHT16t9?=
 =?iso-8859-1?Q?LbQj84RPwYHoSCkgew2hjPccesDkXUOeGkwMtKqLAyInVYWNdbJm2RRe/J?=
 =?iso-8859-1?Q?bTVL4nJjajS09wuDfrreFeiggAAQGrO4sKtVo+D6EPsuFIBIEn61cyb90R?=
 =?iso-8859-1?Q?AtPA7AVPeLcL+T0r/fCWYSd5UwHVzslxuFzpNJtkAVEjtx+6L1am3ZjGW6?=
 =?iso-8859-1?Q?4i/RoxEgT+KK9D65Tx+8hHimTTjGRWT7L8W7IXnv30Z9u/5KE+1/y7yaKp?=
 =?iso-8859-1?Q?PJnmlgo1NxEBdCcnD72dgVgBayCQ9mNItD/fRSzjW6mMfE5Vyi9xHqPAJk?=
 =?iso-8859-1?Q?BulCwOBsGtz3Dky76sCTLsOlsn5jyMqkiwyhHM/+pcqJMk/t/WQz21UNrU?=
 =?iso-8859-1?Q?2xqMOm+QaGzGwdjoQuKVs/JqELajujnUqSCryqP0LpxTOfPweZgYARFoep?=
 =?iso-8859-1?Q?uOIKtTFek3w7lZMFjoboTH3NQMHCbYep0nd0f0Sx9ee/Vr6kulbVahs1wb?=
 =?iso-8859-1?Q?tp1peMwj05kju/25dSId7/kcZB+hiowm5v/C0ufwwFY17PWiyOyOkuoQ5M?=
 =?iso-8859-1?Q?SqVCMGEjxMca7B9/kgixKKHoXahrnjru1wjk2Pq4Oe4LzaHR0002x4CNeM?=
 =?iso-8859-1?Q?9V9Zhd3bd33KPaZkBbty7njetbtau6NgUl3kf3d8nm8f5NnrNSMVWyAatA?=
 =?iso-8859-1?Q?OhIPnyksQf91rP7ag2qAAsh5WYN8wwcAq6LGezjnt8PhgHCOZPvUC6zls6?=
 =?iso-8859-1?Q?BbAK+qsd7OGyHLaf05xLAZ1QfKdppkMTbTo7yN4jjmJvgmzsripbZIPeAS?=
 =?iso-8859-1?Q?c5v3G07eKXeuH7TkdZXGEoygm0/Aaelbp5UlaTuqN1triMODlofaT9ZNFM?=
 =?iso-8859-1?Q?xrqtAzDXUIX2djaFoTf1eJgncmUOP9cYCfe8ewNZbLxwhunHB+xcny4ghK?=
 =?iso-8859-1?Q?GULtsZFXryPplIqZJ+MIOuvW/WMUqn7itlY7F5fuPzQDG4jo9mOYLEsEMk?=
 =?iso-8859-1?Q?gJDoHNptfn1u4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(36860700013)(82310400026)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:44.7857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2e90aa-5242-4c97-434a-08de3f16ca4a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DC.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10157

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 5f57dc07cc482..eb0c6f4d95b6d 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1582,6 +1582,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1607,7 +1615,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
 		return;
=20
-	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+	__compute_ich_hfgrtr(vcpu);
 	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 	__compute_fgt(vcpu, ICH_HFGITR_EL2);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fbbd7b6ff6507..383ada0d75922 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3411,6 +3426,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

