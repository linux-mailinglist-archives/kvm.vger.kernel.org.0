Return-Path: <kvm+bounces-50971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26090AEB3D5
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 245787A5DD1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE39B2989A3;
	Fri, 27 Jun 2025 10:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LNHXc+1m";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LNHXc+1m"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011029.outbound.protection.outlook.com [40.107.130.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D40296169;
	Fri, 27 Jun 2025 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.29
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018982; cv=fail; b=kudVQKaN31apussIDt/Yfqov26qQZuskto4jnoN6qzqV8aMBLt8OhxejdI4Rd759327I8wsy68hyVxeg3wNEwvPPV3WYOk0kDThEbLNbEwo7x2yHxcq7lAhNv7vMs37pidutnqQJY6PMVUrKzaXpSTvLyXm+R21nxtugVvweNLI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018982; c=relaxed/simple;
	bh=eqtADKyJ0JMnDHZuz1Uf8yI6qvIyqbDOde29Su87xsg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XPn+5BYrefJ9yiXgxOfxaLdBiT8Hf3qPm3QXJZMm9EsHbyknZoN+ws8rq/Nfls13WFxU5IBm9JAp2xWiERVx1zBCiuzZhRdE62EapIvFed5ydC4fmDl4d5WFpjx3PNC9+2tHj873uWlfkmHoACgu3+7wZz8meQ2b/SAyxJ84o2c=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LNHXc+1m; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LNHXc+1m; arc=fail smtp.client-ip=40.107.130.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N0Lfm/QaXo8laFOmYITooxFGTefKHfJ5gq+9tjir9Z1J0VMJEe2HjymJdZCyBr9uCNuXS90W+LMxnOwE/5MdbGC34UxMjeucP9u8ZffOSBsprla+1oI4LIQeYZf4Tvi1CAQwocDsexJwbsv5wFvcXDbGj516lgmYPul2mwwSvxQKWMZ+E1Qhodz3gPE678PnMvXQX4t8kXONiHKG98VWMzSZek1ZIj4zJ9Q4aA96smzIqiZ481VFupmwwoWicPp26NiUpXWNRNHg2ypJa0YqS7K9jlKa+inH4cD7l02JHIUjnHR0g8O4x/6DKrLEoGEnwusRcCwt4TiFkRMuE45URA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fF0ATQHd0BxM0xFGeqcvsqseQZYzMeYU6cMt6UkgLok=;
 b=wqlamt2R5RawNjNk6myO13jnny9RVUJKU3aYB1m/jb89bURjyGtwrk365PX3tHW7JF00u5yHn6ory9CiVsNwbqFU/w53htrY85Mw5r+FIJ5QibVePZkfBx5tkQuhnoyJ3oSrP6031+uVQeI7qhDpuKtCtKiT1WSadbelpIzgkxLWgEumVG/bs1KlLQ2xMo52aUNXSuOOe/32fDlE3pbdIT1+vrdXcmwHHHiCQoeWcnjlY2lMGe+c8g0tNsfQXaDv6uu8yKowfhqZo1B+f6VIC9e+Tr95k20K79Y1kI2jXhWEqmr7klBWayXODMdJTldKT7WZGhkZebQEfuU6CYeBIA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF0ATQHd0BxM0xFGeqcvsqseQZYzMeYU6cMt6UkgLok=;
 b=LNHXc+1mBbQS1BWMVHyeqiqL4KNWBGWQQC1Z60K9l7rqimI1sXwro4Mc0VRwfrzHlMhD6zoCOuXV7Ut5PnrR/FtMQxJAcudXjbE8NSesGlUFTPxnx+9W0QLSbpNaVAlArQLS7zEG1pM4BVHnxP+on7WuuZbtKlxZwy1AG/mV9wg=
Received: from AS4P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::18)
 by AS8PR08MB8111.eurprd08.prod.outlook.com (2603:10a6:20b:54d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Fri, 27 Jun
 2025 10:09:34 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::b) by AS4P251CA0013.outlook.office365.com
 (2603:10a6:20b:5d2::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 10:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ER7dDN6bwwa8QvUsEPgvvvCP6bVnxQVrPwJnOOss2IUgCrtsssLfBWuPBkLaizO052m4ejubG9MpsHMyd+/k107lRHsRYQiIxVLCkZTAS7IoQndVGhrq62iBPtlbOsLYWcdh8V1uZ51X09XXfOpbr+hq+A4NTl51dJGLEjdr3PSCm+gH/jg/3+n8DaTpQR07k+TRM+/4Vg2OvkFjtJkwNp1d/rip187tv8Qa53ZWL5ysCQ6yERIvlCbgtDkvqYsaZLzr2975F2PvMQn1T54vYv7M5TSUbhR33dR+O5ibQAHhlun4jYZqG8s+JYJsSAqkAiV2g7vkdUS4KadpzkoBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fF0ATQHd0BxM0xFGeqcvsqseQZYzMeYU6cMt6UkgLok=;
 b=HU8Spy+cujJz/OzbCj+Rwmt86Iyy+2N6nrNoPxErKYekdRwgbjSi7814jDTaBuVQnSPkt5sUzD9QsQAxypZx9R1nGBAQtfu0p4nK08tV0mKvdTwU68iqwXbfLYkh8la3CvoLqxYAz+/+VXvul6bqNHD5vUKYMp43mx95pRQGPv8agaRFtJbFnAg0as5Wt3vJ5gHOf4K818EHdA+AxHUqEGWV5wgSAStxwL2rkmzIt99quxKqjNuDk2ierGbHR1tZD+yDdhdp92soVTadMMPcU6kJmx32Zu/nPOC0HqZ0vx5jzx2mJyfmyB0dihAyuIYF7BQhaSqZsx0W6c1eZkjX2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF0ATQHd0BxM0xFGeqcvsqseQZYzMeYU6cMt6UkgLok=;
 b=LNHXc+1mBbQS1BWMVHyeqiqL4KNWBGWQQC1Z60K9l7rqimI1sXwro4Mc0VRwfrzHlMhD6zoCOuXV7Ut5PnrR/FtMQxJAcudXjbE8NSesGlUFTPxnx+9W0QLSbpNaVAlArQLS7zEG1pM4BVHnxP+on7WuuZbtKlxZwy1AG/mV9wg=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by PAXPR08MB7466.eurprd08.prod.outlook.com (2603:10a6:102:2b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 10:09:02 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 10:09:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: [PATCH v2 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Topic: [PATCH v2 2/5] irqchip/gic-v5: Populate struct gic_kvm_info
Thread-Index: AQHb50uBQ+TR0rqMf0qls1RTKMQOQw==
Date: Fri, 27 Jun 2025 10:09:01 +0000
Message-ID: <20250627100847.1022515-3-sascha.bischoff@arm.com>
References: <20250627100847.1022515-1-sascha.bischoff@arm.com>
In-Reply-To: <20250627100847.1022515-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|AM3PEPF00009B9D:EE_|AS8PR08MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a68b94e-00a5-4080-b324-08ddb562b755
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?8gp7lce5/H66xl/5VkELmF7+M2VXq3/PmIyjP4mv8mVMossjbJg5NGj7BK?=
 =?iso-8859-1?Q?NRxg1kwioGUPrQTHMDyMsNJUYABkbW2L/kIm20qdrtTB9+fq5DCeRleovn?=
 =?iso-8859-1?Q?BWaHQpzJbL7xeNDGW2bultkjM1jetA34ZknNZq0rWOpB29o0/8ocHlp4n8?=
 =?iso-8859-1?Q?YNFgPYzTHTmaOJEmL43U3UUs9k/M48LH8p9ipuQOLIa2rEi+1g/2JilADA?=
 =?iso-8859-1?Q?gv2RA/UNIcOjjhukJGx+454fHC47DXtrJd3J6Tn3RC9+7QBBXvc0HLQTaw?=
 =?iso-8859-1?Q?jCe/eNjtGA1YtWo4u9STu6CEfr9V6ZQibcqMXfmUP9Mx6RrooU/J8A6AcD?=
 =?iso-8859-1?Q?4n121TBIVsep8S6A3P8gRkZhRV4PW4L4Yy5laWq/g9ryhw19gpIXXUBdVB?=
 =?iso-8859-1?Q?fGnUmeFZy9qPVClpcKi6sSUQWAInodrc7F93+cyxUCsdmUQuzljwosOodc?=
 =?iso-8859-1?Q?lML+mJnTNKJsv67YVu3nEJKs1po4FbdAXmasGQkfG2p214mzRU6qzkvVZR?=
 =?iso-8859-1?Q?5VzsYd2GiO0yLJYwb575FNtStnWNZOcNpzWWv4mHlMPVhBzuKNHNrduKdk?=
 =?iso-8859-1?Q?VwjreVoT+zkDJKqqfczFQf8rpgLKT0sB476IPEBx7jke6zLAAG9OyhUg0c?=
 =?iso-8859-1?Q?yYDzGSkQXECEzWMsjW0ROGmjieJh30+qLj4EiEvgi7kNU1gLLSKhRGjIvc?=
 =?iso-8859-1?Q?L80hwhNaKeaayqXvgrgF9OE8qnw5Fi4l/a2tC1GCPqXhibiyw5gP1HJ9fa?=
 =?iso-8859-1?Q?KAtSYRZs8UfC3v6SsDJII0e+30kVTNv88y4/eKfOIoOx9DWP27ciJpoQA7?=
 =?iso-8859-1?Q?sBO9Jqa8wLDljDvzAJYeee8WrOw0cQ7b67/QNs9RFjhHR3hQVinSHjeM0/?=
 =?iso-8859-1?Q?MAQQL7Vsrbdn7jEdLx1Wcb8I7lKptSwu1yMTdaitJTQzMZyQiI+ZkyN4PG?=
 =?iso-8859-1?Q?yR6m86BVer57HUNb3qp1ZNMrKlNoPgShfx4F08shwqqJljRaa5C6xMHubM?=
 =?iso-8859-1?Q?9tu4VwmZIgH1y+Z5eG/FU+d/NLckWMrOevNTYGKDO/WjjEoTrcCfooaIVn?=
 =?iso-8859-1?Q?rs4xFWy/vlCK6kwGpUflPyFxp1TqJqC3294dXw30rOvMd3E30ST45yEA1a?=
 =?iso-8859-1?Q?x7lfwCdV9dQihToUa6HrQWfgmLsirI+0pOD2QaMdmCb7Unmbwb6jIeAG1R?=
 =?iso-8859-1?Q?NIBZi4KOguDFcQisCDCGtGKptZ0FFgpZ1fiiMrhpz+Lz0VN08zfRYfSAZ2?=
 =?iso-8859-1?Q?5mrUStysSisIjd+3CWJUwRO74SLO2KKb/4FnZN8jSjmTg+q29kLT9KyhbA?=
 =?iso-8859-1?Q?Y0qOor8zO8Eke9lQLn7FT+gsEjO1XPUxrAQ4B5O7maXILFOc4tvnVZ4jXn?=
 =?iso-8859-1?Q?xw5XIQoPIXHdE+6b9HyUKmqjMG+UQ+1AA0jqI9onsCrUb91kPOCq2Jj94a?=
 =?iso-8859-1?Q?P8CrLx1ONWx3luQSAQuyoAXRBeHzqC4G6Ynwh10iYP6dGyLaGz7cMswSgK?=
 =?iso-8859-1?Q?O4DmQx7i/LQyS/q9KsR7BFo7Mmf4DG1WVAELGsIDb0sw=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7466
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93eaf7a0-4229-4ae7-68f8-08ddb562a415
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|14060799003|35042699022|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?zQ1qq7tSR8wQLom4kFuju8RL18rvnF1Mm1UwYCO7wEaGeIDuJVyosdRJcT?=
 =?iso-8859-1?Q?JW1vMYmV6MmT3XDEQtXOt9r1+wO55sfsjzTZgb4lQD269Kn5V1OeNR/PpV?=
 =?iso-8859-1?Q?Rv5tY1fhPr8pf6VKasVe7XceoDyq0Z15b/7Rm1CPkFFwBHhpJXnQiTl6L1?=
 =?iso-8859-1?Q?OCUR7KeLvvgfBxD3drpsmqk+1l2CU2pV1fO3fMLnK2mopywVuIxu5rHHZ5?=
 =?iso-8859-1?Q?TA5C5bhHeL9hWZ5WCth75YBG/by72W0tX9LEC2X1uo5SPQxPptfkMpsc9d?=
 =?iso-8859-1?Q?Bo/MUXoaN1u3xbfB4CypC8puy7Zd5fnB0m2fYJWhljVSoNYUJ4gKQDqEy3?=
 =?iso-8859-1?Q?bD1TV+gJ0mS50JiSdqOZ5ZVKND4HRZ7Ihnusou7ELLB+UzMu8sRp4OjFBq?=
 =?iso-8859-1?Q?7WN+2Wq30un4BvjnOoP0DXBbaU+sVT1efGqbXng+3UrbrvxrjCzCCeL2/l?=
 =?iso-8859-1?Q?YvH7wSuaBIgwIpTMEPHMeYtipLVY5XTtCV7Ud/bEp4vlGIa72KniTT+6zU?=
 =?iso-8859-1?Q?YZJTEcL8XrD05YHzZKUExtBlEooXJy/vQs3edbdZjXuoV0ytNB0eDCpw/l?=
 =?iso-8859-1?Q?3HKh+iU47732/EIbMXJKBqNcthWb9vn9txbtBbHtXPK4V2lx3Ih//Y4uNY?=
 =?iso-8859-1?Q?gk6b57deocJ1HiJc0CcbIXgNMBTxr9jhXZGnQclVcAIv0yVcDxIxci590G?=
 =?iso-8859-1?Q?obqrRAGJ6Hf7PJdgHtIrrTbVMb0MzSfQ0sOIEe5iIb9nA90c15EBMso5kW?=
 =?iso-8859-1?Q?gOGCJVUl9Yka+yAjhtTKf96D51alEA0MhLjOAA8kKQqw34ftAOHiMHyswC?=
 =?iso-8859-1?Q?S/AEz0nf2r2d+1fxFjuTBu20o4v49qXnbsIAIWZw4usbfbTF/1nufmddDM?=
 =?iso-8859-1?Q?vmHpISDd7/d+0uLh8ya66ll0l8cyXP+CZaYCfGj2K++FIjl8cKDoW+JUMi?=
 =?iso-8859-1?Q?zQ5yreVqbptoDX+uPTCpxVNnB5SiRvz1QbB1njOAaVNh7KjRNkoaxyIsOk?=
 =?iso-8859-1?Q?6Kc/omNHYaMh1xnMHBAd1dDQHLuVAdG94ML20eeMvGHRydafPOVEYf4uLv?=
 =?iso-8859-1?Q?pznp+qXly/XtFDTTrq2wwXAHYj5OTtx95PM7hl9VOfFi4XVkOAFcE/Htlx?=
 =?iso-8859-1?Q?OmdFvv6jeNiiq7KAmuSWLt7SNbfvwLotZUhcnioKPlRvfFTRsIWk8Et47p?=
 =?iso-8859-1?Q?UZd/O8HXNvukszrQPRe/mv8fC34PjAoIqC0kQF332ZrcLK+G8XtkAleIon?=
 =?iso-8859-1?Q?FNmc2UkBWuNcqR9cCzo/4twm5yy9eNvtiKNzI2tzfm1K0Lyqeih3HuX7HJ?=
 =?iso-8859-1?Q?Lxlvl3UWCHuWORIunyzy5VZwnjJTOkBUtyvDOsUhq2qTvva0AGiZolwNxE?=
 =?iso-8859-1?Q?EWCQHBdpUElS778eVPTGYSnpR+1oK7hCV1eTHld+xid1KGDzkfK9XLe5jm?=
 =?iso-8859-1?Q?Nbq8WPLIvZZBIExT41moG64V95K6QGdmLClLDDL4Uw23Xqzf55ZFWOyZaN?=
 =?iso-8859-1?Q?JPtcxQo3Kxg1TD16TVV2ymdEToGK7WpxkptCBXlTnigbsFHskxkm7rExRf?=
 =?iso-8859-1?Q?BRWXnsFF1/On2nK/7zSpXNr/4yAQ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(14060799003)(35042699022)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:34.2859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a68b94e-00a5-4080-b324-08ddb562b755
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8111

Populate the gic_kvm_info struct based on support for
FEAT_GCIE_LEGACY.  The struct is used by KVM to probe for a compatible
GIC.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 drivers/irqchip/irq-gic-v5.c          | 33 +++++++++++++++++++++++++++
 include/linux/irqchip/arm-vgic-info.h |  4 ++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 6b42c4af5c79..9ba43ec9318b 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -13,6 +13,7 @@
=20
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v5.h>
+#include <linux/irqchip/arm-vgic-info.h>
=20
 #include <asm/cpufeature.h>
 #include <asm/exception.h>
@@ -1049,6 +1050,36 @@ static void gicv5_set_cpuif_idbits(void)
 	}
 }
=20
+#ifdef CONFIG_KVM
+static struct gic_kvm_info gic_v5_kvm_info __initdata;
+
+static bool __init gicv5_cpuif_has_gcie_legacy(void)
+{
+	u64 idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+	return !!FIELD_GET(ICC_IDR0_EL1_GCIE_LEGACY, idr0);
+}
+
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	gic_v5_kvm_info.type =3D GIC_V5;
+	gic_v5_kvm_info.has_gcie_v3_compat =3D gicv5_cpuif_has_gcie_legacy();
+
+	/* GIC Virtual CPU interface maintenance interrupt */
+	gic_v5_kvm_info.no_maint_irq_mask =3D false;
+	gic_v5_kvm_info.maint_irq =3D irq_of_parse_and_map(node, 0);
+	if (!gic_v5_kvm_info.maint_irq) {
+		pr_warn("cannot find GICv5 virtual CPU interface maintenance interrupt\n=
");
+		return;
+	}
+
+	vgic_set_kvm_info(&gic_v5_kvm_info);
+}
+#else
+static inline void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+}
+#endif // CONFIG_KVM
+
 static int __init gicv5_of_init(struct device_node *node, struct device_no=
de *parent)
 {
 	int ret =3D gicv5_irs_of_probe(node);
@@ -1081,6 +1112,8 @@ static int __init gicv5_of_init(struct device_node *n=
ode, struct device_node *pa
=20
 	gicv5_irs_its_probe();
=20
+	gic_of_setup_kvm_info(node);
+
 	return 0;
=20
 out_int:
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/=
arm-vgic-info.h
index a75b2c7de69d..ca1713fac6e3 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -15,6 +15,8 @@ enum gic_type {
 	GIC_V2,
 	/* Full GICv3, optionally with v2 compat */
 	GIC_V3,
+	/* Full GICv5, optionally with v3 compat */
+	GIC_V5,
 };
=20
 struct gic_kvm_info {
@@ -34,6 +36,8 @@ struct gic_kvm_info {
 	bool		has_v4_1;
 	/* Deactivation impared, subpar stuff */
 	bool		no_hw_deactivation;
+	/* v3 compat support (GICv5 hosts, only) */
+	bool		has_gcie_v3_compat;
 };
=20
 #ifdef CONFIG_KVM
--=20
2.34.1

