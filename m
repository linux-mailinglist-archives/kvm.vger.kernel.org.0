Return-Path: <kvm+bounces-67620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1E0D0B905
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B89163003FD3
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79924366562;
	Fri,  9 Jan 2026 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j8LicYbT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j8LicYbT"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010009.outbound.protection.outlook.com [52.101.84.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8450094D
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.9
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978393; cv=fail; b=rFkWjI9E0sVoiLb7KWfS30q/ETSq6L86T1/xXlJPet8g7qGXZgUIo6QK+P1Uk8/hvKUKBy7M+xBvm2x5gOvD6KDHJ94KuLefosPtwyJlzq9K9duQSXgwQlwYQBDnO4ix241W3/kCJ5BYdgAerQkpQh9F4LkTa4jJCuwcMJJGpwc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978393; c=relaxed/simple;
	bh=4e+6CkIsS55x+mw/mWvoPy6WxUIa7lVPF7WmOe+BRQk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iJdmMOdWBLko56xZsrqNtO+abhZQfqO8RcSVQMG3yNVqoPd1PYgAkMrR2ybNZ77sovArNEjXMLtYQZeh7sj8ES73mXYPVXNYIEQ7Icp8flX2AvYIcduL+5UfUbC5LU/KkPK5XFPylu6XDmR79U2ug3ru/Qly06Bnkpw8nbM1Uew=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j8LicYbT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j8LicYbT; arc=fail smtp.client-ip=52.101.84.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=PAWQSJ1Fe2JaTA+89B/F1DV2t7C0r32b3kDPD+MehcsG/KF+rJxSMW/nNUsNnFqp4O175dRBTBDdGcKM97ceNs4BoY3vE8CsrSOS7y9zR5KsbMUBaCr86x5XmqAVliyaf5XMLM7fvO8lSKvV3PP/C08xVdA70H7w/AHiRZRwfhuOLeYlXVLmDGrx9VeocQ9ZbzABL6J6KlsrH3PkTnDJUeVZ0PxFmWWOGVlx5LmTiDpovHbQ81YdnWeabDcQUaHJUwpiY+rdrO1NiS9Xh949LFExariN5fqn8CAs/GAvs28LaknIrMrpBsRm7lPLrlI5MqGtjjdlpjeynZo19JwO3g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rC7TYAr44aarPdC4PPolkcAx4h17l21Pzw9WUxvGeac=;
 b=IIqSi8dMwpo/XrwV3RAwArcPED2T3uGwMCA1tyKC4LV7//snKddLQphMNSNKOWNB+jyOric0jL2bIGCYP0LwarUu4sp02guywBUSaSI5ktiVam5b/yxCZ//F/NziZOPV6p907Jo5KnTtXw17FwO0lNh76Eq6+iZ+XtfM6cgCZhwQeF9Hv5lW3BdesgsXE1bnIKYjYS8oOTxASI0IxZez4uavSXG2YCtj6h3uvwAQmhW/NGGESBLToAsUekh9D5RhrAcwHUijDyP5dpB4TElmtUAvInD7u1HO1CMZaQkeoTGrtlTflYZVu9/Jaz888fa0u4/Qoko1k+KfpWw2zmFjIg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rC7TYAr44aarPdC4PPolkcAx4h17l21Pzw9WUxvGeac=;
 b=j8LicYbTkFhvU3RZMDxDnxDq4jMCB8kSan9z2mMrBp3avpXC4+fkz8X9F14L2ZocakjdZMJz3Bcdxm2Xjen7bHJRAd44YcIMXYZOpYoCuh+exSxFD3PWdxw4MGlVVn0PT8j0q/vFwzhiRVt8XwScgFX4PJYYHUUeRh8BsgQa18g=
Received: from CWLP123CA0032.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:58::20)
 by AM0PR08MB11778.eurprd08.prod.outlook.com (2603:10a6:20b:747::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:06:27 +0000
Received: from AM4PEPF00025F9C.EURPRD83.prod.outlook.com
 (2603:10a6:401:58:cafe::8f) by CWLP123CA0032.outlook.office365.com
 (2603:10a6:401:58::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:06:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9C.mail.protection.outlook.com (10.167.16.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.0
 via Frontend Transport; Fri, 9 Jan 2026 17:06:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IF+HsyaRiM2Fdq8ZlQ1QyZlanzC7/DCaQfM1Fq1cBwuyikJkwn4n+g0tiUut2dyHlmJec2geBGbfToc5FdGHJcI1GnYH3annM8x1ZB9r2REcfjMOOqSQan9wd5xl3mgtQV//HtCZMe/I0ap2mEltx66xety17HHQoEcL6aq0MLD/YjkaUukEtNuBmIZtwBfwy8pgCU1lhOIpKooCocnrneqFYmnSOeeQH66qohqjz7gwgEil1FsxE1/IqeEC4WxR9gRBkRy66DUDSv+YeNVvt7tEUXS8iUhHUHZlEXqfZYNQugCS9dwFou4ufbZlfowwQaudLTfDl4pFLGMyB5pNkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rC7TYAr44aarPdC4PPolkcAx4h17l21Pzw9WUxvGeac=;
 b=cukdL/TocgxQ4QlU/svjtWiuZWBzS7QG/xh7lgFmwLT3vVBMeBtMnJ7WLIATEjBP1W2B+hqPIZXVt/0fUXNZAuPQysAipgc+Blg4jAyhQLtWcDzmlZkCz39yNntp0xwb3RUtIQSHBM8H994OP4sIrHkQx+naM4ojltN6WMhhQorEHsl615RR5nmdPSXyb2Rj4LvYMDPkyldXgFKqxyNWZkSZliYHv8M4yfsJOtqSZeNlDDco9hyhJbrRVNCPTyP1WqWSQVD/uwphkSDoOX3ncz9C6D6Rgmia5OirrJ1s29/GztozInfhgO2V1lgI7Qu0Un+ovNErpnofJWztg7hf0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rC7TYAr44aarPdC4PPolkcAx4h17l21Pzw9WUxvGeac=;
 b=j8LicYbTkFhvU3RZMDxDnxDq4jMCB8kSan9z2mMrBp3avpXC4+fkz8X9F14L2ZocakjdZMJz3Bcdxm2Xjen7bHJRAd44YcIMXYZOpYoCuh+exSxFD3PWdxw4MGlVVn0PT8j0q/vFwzhiRVt8XwScgFX4PJYYHUUeRh8BsgQa18g=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:05:24 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:05:24 +0000
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
Subject: [PATCH v3 36/36] KVM: arm64: gic-v5: Communicate userspace-driveable
 PPIs via a UAPI
Thread-Topic: [PATCH v3 36/36] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Thread-Index: AQHcgYoRmskW/ijQVke9Wl7ggbhccA==
Date: Fri, 9 Jan 2026 17:04:50 +0000
Message-ID: <20260109170400.1585048-37-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|AM4PEPF00025F9C:EE_|AM0PR08MB11778:EE_
X-MS-Office365-Filtering-Correlation-Id: 618eaac4-6e52-4b61-2ff3-08de4fa16d08
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?gHvBIkQ+6Svyhtm3Aj8xiPCT653W+OYKKATSAlQ3MrGOadzX4QEEpQWs+W?=
 =?iso-8859-1?Q?8hNz7LYgf4px6p/xE89iqyyE8CiMNlTJGl1jEFzTayHCzriwVRrKzd/W9C?=
 =?iso-8859-1?Q?msGlCj337V1+we6UvhYRN2udV92nvAB00XtML3so/sFsv+5akH4QHMprPL?=
 =?iso-8859-1?Q?R5EKRMdS+SGAo4avjb7uYyh14HJs30ou9IC9Ut1RQpTW56Q7gBTmby8a99?=
 =?iso-8859-1?Q?Ibp681jIHV6oyKWPOk4BNlSvy5sfH8gIkAvgX6SpQMZT9G8IKUSFLtIvNv?=
 =?iso-8859-1?Q?fk6kKp86PzL6Qb4LmPTqNLvN1X8SIQC0Fie1Wd6Ub7u1XTsj8V8dogNKGZ?=
 =?iso-8859-1?Q?qyLGI5o37TAJ9BSlsg7TfxKdIMtPX1W6Op8UihfjVag3s+r5GSHnON4zDh?=
 =?iso-8859-1?Q?8BR8FsvdukOQHXa2nyJQJVgfv3a61HL2QzYQ0/uODB+GN3YP6t9438au0B?=
 =?iso-8859-1?Q?wqYXqW7138hUnew5MczYStUKVRZ0qNV5aNrKWxbwLdIo2bvWAxtu84ZVe4?=
 =?iso-8859-1?Q?VNdKSks7e6lrQWAWDAbD8oZOcwIhIFGceBVnbwZNcpUz61spSTlNWvGqmg?=
 =?iso-8859-1?Q?9V7BUhFhie5by0lv8VKMxvxvb6oQHVhUTYpxkJzzJvlFeZdxt2p6zypoFu?=
 =?iso-8859-1?Q?Z+tjcAxKzWZv4thrzzdJGX8Sav/F+CZh5yTsGoe/Edi1P8dLUpl96dUBMo?=
 =?iso-8859-1?Q?XAzxaNfhZKBeVqhKD5Q4CNZXsvlGCAdTUFArpwxg+5pCdaHOa8Mo88NZHB?=
 =?iso-8859-1?Q?UYZYML4HFi3pZg0gyiAnUJczop8WkKyo2nqM0y81Bf0mkrdHk0ZZUHAcjt?=
 =?iso-8859-1?Q?1mnVH0vMqe/zY66JJeOFj7SLYEvH894OOk2QorNxzMyzTsQixOr+Ar080p?=
 =?iso-8859-1?Q?B9u6qztIRM7YsXAyKKIichhXRtwUvyQ4b030y0FmEEreOafElcjA1dLzTy?=
 =?iso-8859-1?Q?i8SzYYYnoSU/O7qYEpuwA+ceavmd5L/9GOn2EAiVk6nBW38XCCEwQM+Qj5?=
 =?iso-8859-1?Q?0KxlMmuUuzpmbpVtNsiKnBGgxRnPTtp3TC9sscQQi1BUi0Za4tyAr1aTBn?=
 =?iso-8859-1?Q?PvYtIHpHO1YyNHDBFCs0Z8IIuuu2L9f8i7RJW28EiED2ZHeRmks1vn7tFN?=
 =?iso-8859-1?Q?OmPEBXIRUeYoh6XPePEbnR8u1rpfaC7sl50iAB2ouZBShgrhApj8jjY8tx?=
 =?iso-8859-1?Q?yYbkc6+GlhiD6YlTi1emHSAIJSVZcvJWcR1Vx7ncys/gXuH4Pc9F/Vj6kG?=
 =?iso-8859-1?Q?8MGbE1NKPVYlfPeFQwcgBkGpzJ6T7KxO0LbCnjFJgdhUf50c/qIRuOoSzB?=
 =?iso-8859-1?Q?AvNEnE+sCn/js0tMHnkrz+iww9WZC1Ey2dg1OT4cjm8j+aQeUPO2+Xure/?=
 =?iso-8859-1?Q?4cDZOopsKFCFeDzUbmnP9QKijt0AY832khjKCFQr0TxlQpSnrkvJMHyAAH?=
 =?iso-8859-1?Q?LZzlnQZ2YwoLfIrQqVNlBKv4xbhleLH1g+3SDN3MYn+ONSMIewltjbqDXJ?=
 =?iso-8859-1?Q?i54CBv4L8L8pvpPRqFBczOBN9PORKSRXLNgnx6lVS9YsN6ydQyeljBA7hO?=
 =?iso-8859-1?Q?ApgE9wurHGZ/ZmS22eVfBOxl2O7Q?=
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
 AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	865c8c1a-cd7d-4a13-cc5c-08de4fa14777
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|14060799003|36860700013|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/NzrUHsM0IG11E4Btbh+9KWEPwVoUmlwM0jXXUxWNOyLr4NSU64mSM8gWK?=
 =?iso-8859-1?Q?SRZcxyeLRyqO5le4DeFHrYN4jZz3WHzSeegD1LFlkMuCy13Z4AgNsYkEOq?=
 =?iso-8859-1?Q?Hwe3NAi1hAV6iUOY3nMTQfgirgyxdAe61TT/tmyW3/nVrDLjbDTTU/0lCO?=
 =?iso-8859-1?Q?Vb8qisMGbNDtiNqN4BwpyU9gwldx1w7SXvPwj4ng1P0yf9BELylF/rfEGZ?=
 =?iso-8859-1?Q?yg0o/M16Yry4KO1aVI/pNsfrunitM1LZfJ5zcE1Odf9CrhODvQvIN0rBjv?=
 =?iso-8859-1?Q?dcIXimW1UN7t6UUPW4jlRliKEG0IAcIQn4hhacdNT3AAV49wGGbFZhzwcj?=
 =?iso-8859-1?Q?nUSSWI7QvTFulpQErq1+PevhpjyXl3SbA5vIqLTI0NvXfrC/oUEa3tm2bk?=
 =?iso-8859-1?Q?/rS3fmZm7DFW+XOytr5Q9aEqg1rlH+2AOInuW5nHtkbYQ6nXIGegJTXcEM?=
 =?iso-8859-1?Q?XYCvOIgpkuTaJSIVYRdUHDnIZTnOSHriJDClH6IorP6NMmjbPw5q/kp+TI?=
 =?iso-8859-1?Q?6/VhJ4F3LGKmnZSHQbMAHLUNrnqsSANA4PwE8W+ilaZQjm7oetiyMJPV9V?=
 =?iso-8859-1?Q?UPOLk3REhWfKhJmpq1mbnqoswDRIkMz9lMFX84vxKH55v8H5ikSUrEzDuW?=
 =?iso-8859-1?Q?Q4es/oksDgX9F03QSPR2F3k8rm5J95JMXZfhzVFCL4eK+QJLAbolbI8uK1?=
 =?iso-8859-1?Q?aJRUbWGEYOHlTgzXprYlxwO6hULHkSoQyGKLHUuyngrgMXqOCL/xzEG4Rd?=
 =?iso-8859-1?Q?rlBxNmjhRTiHKt5fW3rL11w0JAP+hQknh71UEsF/n9dNofcm7DQ63AHycX?=
 =?iso-8859-1?Q?vrila0oIGkK/jds1U7qMYvB+qkZ/3vPteaVQhRpToAIUqeeJIhINgu8wmb?=
 =?iso-8859-1?Q?qcY+0w9curqbGlXQdyeRDnh+XIAIsd0DJwQxJmcOk7cOTiEpFhyZjePFW+?=
 =?iso-8859-1?Q?ncNiBWOoMEzS26HiFGe0bvMaRY3telYe06A5VK/+3Yf/8hhzwCRedZNGIx?=
 =?iso-8859-1?Q?+9hkOJ6lO2JyIoNqlJML6pIA9N3Sqgoax4tnbHAUADEgcVP0K4xrSnQU3k?=
 =?iso-8859-1?Q?DJZI9cye5nB7HgwFpqcObhXB++ESU709ivIfJGVp86Bj6ht7mqj0qkIvwW?=
 =?iso-8859-1?Q?Oa0L38ZgQ9/bWB1TrqclzL2MpDXlg+5In7r08eemuAiL8zd/tpMAbNug95?=
 =?iso-8859-1?Q?KwL+YA1XutnpeugRTyKJmn4RcTGcjRxRg42c1wld+d1+DQej2CYcd8/rkh?=
 =?iso-8859-1?Q?gHUFr8yWiX4JN0VR1/hKp3RdK30a++FGdq+T92GRQdfAR5fh4n93rcVYJQ?=
 =?iso-8859-1?Q?9xbfY6pAPMUBFVNVcoobZi9Id43u/K87t4yTDFIdzjp2UCGgzVdy/6Dj9/?=
 =?iso-8859-1?Q?g7ixRdllYf6RlayDFtHoWD+KMlMuTG/3Dk6TlpCFrOwd5/gU3kMrwCjQr1?=
 =?iso-8859-1?Q?6kYAVlZbuUSn0oLXZBwscYBVNlKO7ldnNEQGwKamIYHMmcfnSK1lMchsUv?=
 =?iso-8859-1?Q?Y5pYR0ljQet8clQiWAdSuv2hi4Yw2b0MCf00oI2R9ATLKzWZeo/fpSVIX6?=
 =?iso-8859-1?Q?pgYJ5m+gLDEOe3pNBNBLQ2mdqFk/?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(14060799003)(36860700013)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:06:26.9804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 618eaac4-6e52-4b61-2ff3-08de4fa16d08
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9C.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB11778

GICv5 systems will likely not support the full set of PPIs. The
presence of any virtual PPI is tied to the presence of the physical
PPI. Therefore, the available PPIs will be limited by the physical
host. Userspace cannot drive any PPIs that are not implemented.

Moreover, it is not desirable to expose all PPIs to the guest in the
first place, even if they are supported in hardware. Some devices,
such as the arch timer, are implemented in KVM, and hence those PPIs
shouldn't be driven by userspace, either.

Provided a new UAPI:
  KVM_DEV_ARM_VGIC_GRP_CTRL =3D> KVM_DEV_ARM_VGIC_USERPSPACE_PPIs

This allows userspace to query which PPIs it is able to drive via
KVM_IRQ_LINE.

Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
any PPIs not in the userspace mask.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

FOLD: Limit KVM_IRQ_LINE PPIs
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 13 ++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/arm.c                          |  8 +++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 24 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v5.c                 |  5 ++++
 include/linux/irqchip/arm-gic-v5.h            |  3 +++
 tools/arch/arm64/include/uapi/asm/kvm.h       |  1 +
 7 files changed, 55 insertions(+)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
index 9904cb888277d..29335ea823fc5 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -25,6 +25,19 @@ Groups:
       request the initialization of the VGIC, no additional parameter in
       kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
=20
+   KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
+      request the mask of userspace-drivable PPIs. Only a subset of the PP=
Is can
+      be directly driven from userspace with GICv5, and the returned mask
+      informs userspace of which it is allowed to drive via KVM_IRQ_LINE.
+
+      Userspace must allocate and point to __u64[2] of data in
+      kvm_device_attr.addr. When this call returns, the provided memory wi=
ll be
+      populated with the userspace PPI mask. The lower __u64 contains the =
mask
+      for the lower 64 PPIS, with the remaining 64 being in the second __u=
64.
+
+      This is a read-only attribute, and cannot be set. Attempts to set it=
 are
+      rejected.
+
   Errors:
=20
     =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/as=
m/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cfd1e53b060e..e15c97395f50f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1437,6 +1437,14 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kv=
m_irq_level *irq_level,
 			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
 				return -EINVAL;
=20
+			/*
+			 * Only allow PPIs that are explicitly exposed to
+			 * usespace to be driven via KVM_IRQ_LINE
+			 */
+			u64 mask =3D kvm->arch.vgic.gicv5_vm.userspace_ppis[irq_num / 64];
+			if (!(mask & BIT_ULL(irq_num % 64)))
+				return -EINVAL;
+
 			/* Build a GICv5-style IntID here */
 			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
 		} else if (irq_num < VGIC_NR_SGIS ||
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 772da54c1518b..21d21216f2185 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -720,6 +720,25 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.has_attr =3D vgic_v3_has_attr,
 };
=20
+static int vgic_v5_get_userspace_ppis(struct kvm_device *dev,
+				      struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr =3D (u64 __user *)(long)attr->addr;
+	struct gicv5_vm *gicv5_vm =3D &dev->kvm->arch.vgic.gicv5_vm;
+	int ret;
+
+	guard(mutex)(&dev->kvm->arch.config_lock);
+
+	for (int i =3D 0; i < 2; i++) {
+		ret =3D put_user(gicv5_vm->userspace_ppis[i], uaddr);
+		if (ret)
+			return ret;
+		uaddr++;
+	}
+
+	return 0;
+}
+
 static int vgic_v5_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -732,6 +751,7 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_set_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
 		default:
 			return -ENXIO;
 		}
@@ -753,6 +773,8 @@ static int vgic_v5_get_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return vgic_get_common_attr(dev, attr);
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return vgic_v5_get_userspace_ppis(dev, attr);
 		default:
 			return -ENXIO;
 		}
@@ -773,6 +795,8 @@ static int vgic_v5_has_attr(struct kvm_device *dev,
 		switch (attr->attr) {
 		case KVM_DEV_ARM_VGIC_CTRL_INIT:
 			return 0;
+		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
+			return 0;
 		default:
 			return -ENXIO;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2664b33871e9b..cbae1dbd81cf7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -122,6 +122,11 @@ int vgic_v5_init(struct kvm *kvm)
 		}
 	}
=20
+	/* We only allow userspace to drive the SW_PPI, if it is implemented. */
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] =3D BIT_ULL(GICV5_ARCH_PPI_SW_P=
PI);
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[0] &=3D ppi_caps->impl_ppi_mask[0]=
;
+	kvm->arch.vgic.gicv5_vm.userspace_ppis[1] =3D 0;
+
 	return 0;
 }
=20
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index c9174cd7c31d0..fcebb0796a7d3 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -381,6 +381,9 @@ struct gicv5_vm {
 	 */
 	u64			vgic_ppi_mask[2];
=20
+	/* A mask of the PPIs that are exposed for userspace to drive */
+	u64			userspace_ppis[2];
+
 	/*
 	 * The HMR itself is handled by the hardware, but we still need to have
 	 * a mask that we can use when merging in pending state (only the state
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/inc=
lude/uapi/asm/kvm.h
index a792a599b9d68..1c13bfa2d38aa 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
=20
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
--=20
2.34.1

