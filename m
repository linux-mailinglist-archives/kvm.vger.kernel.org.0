Return-Path: <kvm+bounces-65872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F29FCB9231
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C20430A58DA
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6FD3161A6;
	Fri, 12 Dec 2025 15:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="INl7lV3P";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="INl7lV3P"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011061.outbound.protection.outlook.com [52.101.70.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2D324B2C
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553045; cv=fail; b=LxR61F41IO3OTuXig+F1lm1mFdSWnsIt4PYkZtuZ7BqQ40ky/pZvIIsMekVeyfmpNm44DezQsgeyU3DerXUaWZ20HTI9k/nEXAsImBYk5H1I40rDIYMglz9p6wTo17f5nobwa6/e2seOF+cij6AmauzaobR3eNRT4O8EwCeG/gA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553045; c=relaxed/simple;
	bh=we5ihRD6j+pb3B6P7t30SNghCBV5CmdA87Y47LXlhtQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OBkElLEiFeHhOVVppch+Y1hwstFCoY+rtAvkke4GtU/j4Hu/3x//o0sFCQZKTfJhQ10S3UvwqBxpxE2Y092HwyDFO71kByHkU4jGj2QG6I1ove7bFUN8nMQ/BQ0Ao/mMyVfVAtFmSvJ0kUlie/ruu2fi1KT2LVbCrDOdtO8Kuzo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=INl7lV3P; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=INl7lV3P; arc=fail smtp.client-ip=52.101.70.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AnALvpJGY6X7tCiYco9dA2sHdI9yD6Akw7ivwqgfH5slCluu8g2oVCzih/E//wbuqGOnqi6jKrVPKj795Fs4xi4XOa8S5oCqokTnb4tzyx6EKXvXT5wA3JDUcq/pQasxCG1xZCpcDOtAES1S4xQwyKquzciRN+ExuxivdcG+DgBHo1JqziiukNfGqjH5LAqELA3ghGRDG+ksomJli20HJDyWqh5kS8r7e0MTGqY+J7eYrVRlGRTEdA11EDStgq/VSuaqztu+gMmfU59zNOefgf4w0f920jrImAlA+N2RX+Wd/u5SrLXFtO9+3W7BlwIdntBwX6/miMYAGFl8CgasZg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP8QlfxAbLMyM+Jn3DZah9vBY7D1yZmJ/xOi6cXh+Fw=;
 b=VIDJxy5+Pb87oLgRRkz1gn6s0Gj82xvt0gQ2kt6HvD2BfCfmSVsZxN/eaanN2bBAJHmuh3UOCtBTwzEB6f7IJ/KZDhMwKJLuQx5qI26MJFQ4bhnWi2yEXrTAZKKIcFJOPun0+8OCLs+O4yLPVkQDsSveXk4kw4fra3gLOLaiDDZa5DAkacVq61qTphvvIUorzpiKgfQ9GMBm3M2qvXRyULrXOGCt2t0BeYs8KNz0YBy9vQC5DuxtsHOUruLhknd0LYqTskXNy8ttEymyCGJ2n7iChg1Fx0f9+THK8Jr8ynJmmJy/vnSrh+Y47U/F3QZzoDWHfTeTOhjyq3UpJsFv5w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KP8QlfxAbLMyM+Jn3DZah9vBY7D1yZmJ/xOi6cXh+Fw=;
 b=INl7lV3Pg/Yb9An46PrUr3CtDccxIZ/TRfEbY/SycQ2b6Kf5NcrJO8Ixp1+XtJ8hWQmSOMtQKaNMui66NGLeBeOdaPHTQpN7VONCZzZq/YYsYsVJ3jN4fEIKok6m0UNd2qqhKihEWBDJHJjqPAQyR5lqpoA+0DK3XKHRAgjWydw=
Received: from DUZPR01CA0192.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::15) by AS2PR08MB9785.eurprd08.prod.outlook.com
 (2603:10a6:20b:606::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:23:49 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:4b6:cafe::79) by DUZPR01CA0192.outlook.office365.com
 (2603:10a6:10:4b6::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.10 via Frontend Transport; Fri,
 12 Dec 2025 15:23:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FECN84f4zlknNbIqZK13jv5csC7OD+CzjjXtG/WZHAwUIHTTwVeSAqiJPSXdmVuHEPP1lRnoejZsnaoAH4hNOyGjxNjVe8wwhs+rcn7zW/oZzW3YjaG85v8EMJpUhMHksCPG2J2LpCG8xzZemn/NlXUXW9CDy3whg9Qw8BiSFEHXtaNWBBnn8wTXY8XFg62G19xfVjX+WIgF+iQUVVS9+XCLzTtLHHXLM5waPKZNKtN6BQK1L9llDE54lUYho3c2+nBCJ+yYiLRM6Pvf1vS0zyuHVx1246x143Vs+kPw76WCKxf5u3crcVyjPEu3Tgmt8meDy/6GnrkzaU5GM+eDhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KP8QlfxAbLMyM+Jn3DZah9vBY7D1yZmJ/xOi6cXh+Fw=;
 b=qaKyjUAiubIqZviQGVGmiadS0vmFNuVosc1vU2OngtR7oR/ukVQ+Gjvux51ZJmAjPdTjfjUUgafx/fInTxiEGZjNeyZLAXX7PTRyBXRbyw4wFaZCKSRUMp6TvSEcZswJ1gejZCWieTQK1clGEUYHTnFa5+q/sIa7f+em8mk+/7P7kXFbleSnWzuEWYPNpYNoHL5rL0d5RET3nsfzup/CbJXcBscLVaUY1Xz5vJpmDsNEi2PMXr+7Lhtdix8IK5kNEtpfrHob7mJUcvhK+uEt0AHeTQoLGWjI9iNicpIegFDImCLhVeQ6eNfhPVzygf8d2DqW/H3+bk4EYjvaC/tnwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KP8QlfxAbLMyM+Jn3DZah9vBY7D1yZmJ/xOi6cXh+Fw=;
 b=INl7lV3Pg/Yb9An46PrUr3CtDccxIZ/TRfEbY/SycQ2b6Kf5NcrJO8Ixp1+XtJ8hWQmSOMtQKaNMui66NGLeBeOdaPHTQpN7VONCZzZq/YYsYsVJ3jN4fEIKok6m0UNd2qqhKihEWBDJHJjqPAQyR5lqpoA+0DK3XKHRAgjWydw=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:45 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:45 +0000
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
Subject: [PATCH 22/32] KVM: arm64: gic-v5: Reset vcpu state
Thread-Topic: [PATCH 22/32] KVM: arm64: gic-v5: Reset vcpu state
Thread-Index: AQHca3sp/EbL0X5N50ycBQGNU3utjw==
Date: Fri, 12 Dec 2025 15:22:42 +0000
Message-ID: <20251212152215.675767-23-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|DB1PEPF000509E2:EE_|AS2PR08MB9785:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f6f0a17-fdb1-44d7-00be-08de39927245
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?bkV3ZPpmLKO4dsZpfitrZIM3otD2SB+5FyE9pe74paQdFS7Q69tHv/hyD/?=
 =?iso-8859-1?Q?DV9hy1GGVQmz5k5sq0Al88mrxbHyeD6dIek+3GlS3cHLRZUJmKm+WCbF7g?=
 =?iso-8859-1?Q?UveUw0MQCvsDDE7WkbV9hBuyVLcHfJAyL+XWZ2Pt/CcQI8GxxgEcTFehmC?=
 =?iso-8859-1?Q?i45Tmc3643UfMCvvji3Sw9LLUaJ+keEvs2f5UleDpY6F8K1DnnZrp5wS54?=
 =?iso-8859-1?Q?INQO+Ob+S6tmOWpKCw49IUUv529n4EISMzA69Gd8lVfriVjJ425MZkijKp?=
 =?iso-8859-1?Q?b4zhioXuDpgIaYN4kyGbWLuwMGW8N1u2ZF1WWHrhAZqOCpmVPGQhKiHVN9?=
 =?iso-8859-1?Q?jgobeYgIYluFiR8ziFPNeIY9loRWqjcDMXGkmz27hIwyRWfGZugIxrSCYA?=
 =?iso-8859-1?Q?FlyLM6D1owvjF+knEc0zUce8oK4KxmVi8FMyG2wxG9Sgt34b9BkByRk+ft?=
 =?iso-8859-1?Q?oIphAAuznd3C6CuGSVKGLhzOSgcnUpABYPBUfiH8fNkaX+2jx5PVdlkUHW?=
 =?iso-8859-1?Q?m4mgq1qUfEBHzL9pTwvbwKreo+ZZJyYHqp5ZqcJm/55KVmuMK2zAKkjVz2?=
 =?iso-8859-1?Q?IBD2et0dkAwVupAIMgEh4120IooCE94ol+5Z7QBzkrcUXMnihCxg0bqQbI?=
 =?iso-8859-1?Q?/EPnX4bCw+GeAotCyKai9iQr1vLPb3GcosH94qCZ8sbOs/C7PqFdGNnET3?=
 =?iso-8859-1?Q?RLDsMelN47YSxNXvCH49+3XEX9S1Um9QhymXDfvsyUwwJ/xoq3Bkr6qt92?=
 =?iso-8859-1?Q?6dXimN7oSiTGKHz3+cIMgAVa4AKaWsXyPh3qMt5PSSjE/8uU2ftYdS3lbD?=
 =?iso-8859-1?Q?n22LhFEMvfmLMtyYL2zrewPUMuiI8ABgJbHP7WOr828/fokmzFHNL5AYTP?=
 =?iso-8859-1?Q?/432JsI+U4rVSUEICJa4zHdO/sNchNJgeGbs8bLiO6aCj9rJJ07mX42nNv?=
 =?iso-8859-1?Q?ujTZtKR80tQCE53uza0YZWxra7sbtM66+9liBmB2gpSIs1r2DHk+99e9Gn?=
 =?iso-8859-1?Q?kxikO0hgJrSlXDr31EJPUnLVBXzNi8WNmhesVLDkhVIV647zknx4gkaL5F?=
 =?iso-8859-1?Q?L1qoVAfM23ETJedS+wbLiordSRO9JfHZKgH5LgWng3nzWCrwRlN2djVmaH?=
 =?iso-8859-1?Q?L7wxyBOyuGWIvyAHnaH6qcIZTDpX4bss0O0W7QqpxLT1K1u1vDMcwyVoJV?=
 =?iso-8859-1?Q?oNtzmM5/JHTEa2Z3fwkONvW0/BitDNsRHLOS7hrgZzptuXAHlye+actgo2?=
 =?iso-8859-1?Q?SMEdGc9KD88BZZcnCgOPYzNR6WMVyQYpAOMbI8kLEw1j7Ar6I3sNR5M1Z6?=
 =?iso-8859-1?Q?zgrtsiJg8o1pgcPjEawdlqZ9cMx3inYXXHRYDWrw8sYfXiGOztdx7Q7z8W?=
 =?iso-8859-1?Q?ej+k+b3hnSa4mFIa5BEBtyfY1siwJfCcCYgDh03+5UdUm2qYiURzAJZQi2?=
 =?iso-8859-1?Q?rnrYk0XS7g3GTT31B2o6hI/+YxxwppUDDrsUwP/HaVveqQRF9ZkRT1NM8H?=
 =?iso-8859-1?Q?EnAInauC+Ys+TyGGzciaTjkmM/5YN5gfVPDupSp4c6kiJA6z6kz2v52eJD?=
 =?iso-8859-1?Q?at2VAOoqfXRImcteWsI9zM16+F83?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fc57e791-8a54-418d-bd0e-08de39924d36
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?POlmzP4mUbCZbS+8Ec9CbsYC0r17KbdGKfdDIxc02y8GPmBM1+DgCd/wh1?=
 =?iso-8859-1?Q?0Em2vHANJLhAVqhBpAmdMZBZRSbwV2XqlsrhVZA7yVxsxIA969YcelTnQa?=
 =?iso-8859-1?Q?Lywgxfhv9AYaIU60uN7MaC2BByn9O8rXhOg+Iw9MUe6Ltl6px+rDrkshkA?=
 =?iso-8859-1?Q?lNUTU+NXKBsAXGqkAEYH+zQZq58NNGxaJN8YRcRUiArlDFUhKZeMfVoZYu?=
 =?iso-8859-1?Q?Pz4bRUdhJ5sGwQ3lyw80voOVdgZuJCb88K0HSX+Yrx3S8mlr+pWTpgkJxI?=
 =?iso-8859-1?Q?vcwlemoaimki1JJ29vIEJxjGasucjY9VuX92HotJJw72mYj31o/9+YrZjN?=
 =?iso-8859-1?Q?LhFk1QxQpZAgFz35eH4EHHHfnjzDDmXrrR4G6CJSXqPdDshMj6iZpwlyNN?=
 =?iso-8859-1?Q?dtmmcE+u4CLQ4LweachmfR2R+NKOGu/Hw12WnPlrVM8HgjwQCZj2n0iCbW?=
 =?iso-8859-1?Q?2/Kf/e3eLomIer9J/T/dzJJB/9mS7fqwSVZuWxTU64RXABWJIXiC2Wu534?=
 =?iso-8859-1?Q?BnhzUvi842Z9JN2ODMB0m5S0zNzMN8VcnscoEaWwp6B6D0B1d1WJZwH7z2?=
 =?iso-8859-1?Q?X0pA55OWpzr3INoDDWX5IZZ0pgtyYOUa9aW38Subgmuc6wDhPflyuRzaTi?=
 =?iso-8859-1?Q?vPkJYF6yxslHdUIZvnOMi7LjGqvORK89atf7Xd37SL+p5uWT08ZH0xJarI?=
 =?iso-8859-1?Q?+1hpHDtwNIbucpHE15TvJcYs3kszyP9RiPtaYDkSTj0BIhe/YQCMuxst79?=
 =?iso-8859-1?Q?hEtxBgtZX+nkH2rrDbDyRuo47H9oh7kUx5YDi3YnYsrFa6HdLm58oeJTla?=
 =?iso-8859-1?Q?m2fJCB9t9N4KS/waEj8BnEiBMlCacDn/GbGGOwq9h+eMWuCRQWHAdhQXf6?=
 =?iso-8859-1?Q?OCdcRuvb/WfcBBaX2yoUw4enGdOrdTjJDeP954FkaGTWLREZn/5HEY7iIl?=
 =?iso-8859-1?Q?VBpsk3JpQBiy09NQlxJW282d9yBsAk3TFjrpMSZ9EKthHOOkxj24ezclFO?=
 =?iso-8859-1?Q?NNNQo3CEUhRf+1mT1DVrwHugDdmyRv9d27vgkcXCe/ZFBNDQu/NBtk3sL+?=
 =?iso-8859-1?Q?jFQfOlobHPbWM1p3tiWBMvg5Awz4zaFdUT+3iBaC6TeO7GpSXY5vIaTT/8?=
 =?iso-8859-1?Q?a3OlLc1iPCf93JjatSRdariIkLmGCaFZLmCh28iyGTXyCRPoB+i1fJKhgK?=
 =?iso-8859-1?Q?23qXGaj9QY5OBINurs/mlziH7sI4gGWzoXXmmouZ9paBwN8qDzJEcKFLy/?=
 =?iso-8859-1?Q?ALZNtIX+gCwWc4TlX48cOM48Bhb6F0bBbxx9hQ8mUx3/gLrtD6auEhD+Ij?=
 =?iso-8859-1?Q?vJUuk8l54ADc1cpxt47rgRBiOCaSdPjLhKXPCOyuDioAn7L7WcLJ7UWjeG?=
 =?iso-8859-1?Q?MrzP1ZIxkMap4/gXSY1sIHrut3gzwPpB5sGobUFLPLusrDvwR6NX+WgLT/?=
 =?iso-8859-1?Q?GfU/R75u5IGj6R524Jby6eqMWoIHP83UKzJjNS5oYG/EepE3C9QQiknQW2?=
 =?iso-8859-1?Q?J4Qm2xd8txF2c7JUyuLMCgM4XJDYZThN7kBul9LVP/qUWNf5RZvxe7tHMZ?=
 =?iso-8859-1?Q?AaOGMhrK9bUe3NECmEtIqbBwRViSgZW2SfyrZwDYkP+YOmfqlO21fd8D+w?=
 =?iso-8859-1?Q?h9ZeiGqiwwWGs=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:47.7316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6f0a17-fdb1-44d7-00be-08de39927245
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9785

Limit the number of ID and priority bits supported based on the
hardware capabilities when resetting the vcpu state. Additionally,
calculate the PPI HMR representation for the vcpu. This is presented
to the guest when it accesses the ICC_PPI_HMRx_EL1 register (by
trapping and emulating the access).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 63 ++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 69e8746516799..120f28b329738 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -396,7 +396,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 3567754ae1459..a3d52ce066869 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -54,6 +54,45 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+static void vgic_v5_construct_hmrs(struct kvm_vcpu *vcpu);
+
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	u64 idr0;
+
+	idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+	switch (FIELD_GET(ICC_IDR0_EL1_ID_BITS, idr0)) {
+	case ICC_IDR0_EL1_ID_BITS_16BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+		break;
+	case ICC_IDR0_EL1_ID_BITS_24BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 24;
+		break;
+	default:
+		pr_warn("unknown value for id_bits");
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+	}
+
+	switch (FIELD_GET(ICC_IDR0_EL1_PRI_BITS, idr0)) {
+	case ICC_IDR0_EL1_PRI_BITS_4BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+		break;
+	case ICC_IDR0_EL1_PRI_BITS_5BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+		break;
+	default:
+		pr_warn("unknown value for priority_bits");
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+	}
+
+	/*
+	 * We're now ready to run this VCPU so no more changes to the
+	 * PPI config are expected.
+	 */
+	vgic_v5_construct_hmrs(vcpu);
+
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -105,8 +144,30 @@ static u32 vgic_v5_get_effective_priority_mask(struct =
kvm_vcpu *vcpu)
 	return priority_mask;
 }
=20
+static void vgic_v5_construct_hmrs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Calculate the PPI HMR to present to the guest (and for
+	 * internal interrupt masking).
+	 */
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0] =3D 0;
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1] =3D 0;
+	for (int i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; ++i) {
+		int reg =3D i / 64;
+		u64 bit =3D BIT_ULL(i % 64);
+		struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		raw_spin_lock(&irq->irq_lock);
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+			vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[reg] |=3D bit;
+
+		raw_spin_unlock(&irq->irq_lock);
+	}
+}
+
 static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
-					  struct vgic_irq *irq)
+				   struct vgic_irq *irq)
 {
 	struct vgic_v5_cpu_if *cpu_if;
 	const u32 id_bit =3D BIT_ULL(irq->intid % 64);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 66698973b2872..91969b3b80d04 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -385,6 +385,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1

