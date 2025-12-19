Return-Path: <kvm+bounces-66398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD447CD1128
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9AD83011EF8
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51756382D5B;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="exgWCHja";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="exgWCHja"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013065.outbound.protection.outlook.com [40.107.162.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6908E37D118
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=jwi0XFVv5jTUqz3yQn78p49Ko0zPznXykWf/4B4J9nt+eZhW6j1vhPAiRAwnHqDyBM/CFhtNW6tC5PP7X3/nb1rTrK+EKv823ofvv11jD7/0Pb7mdA7VvjNqL2gNt8C94bhqlvLpodAbS7HMX2F59EwTJiS8e6KrRINqsl+OUJk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=xCkcXO0SRs6fGSI5bqgMo1oKX0xY/M0k5ecc1I5BC2M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XIIBHLcHy2s+5VTq2mIrzNUWsOknCulYeDLscOMaA6rB89AdYSayHt5zoUrXChxMZrKsUIPQIfSgfAq5FkNfBbkUJu+wTeMoR+8vVrPjj5HogGkNZn0GzQyHc8oH+Tsc5OubKpds7PwSRarpjPOqvr3kTjWlioKokm1dDjKqAs8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=exgWCHja; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=exgWCHja; arc=fail smtp.client-ip=40.107.162.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=b9qkCd9GyJA0X4p3XpZGxj1FCstm886tjUnHsA4QIn8b/f+oplqeVb94dSC//a1j0pncE8tGwHfbhyihA8ew59Dn5pBzONx3HIiGaUzNhuGuwWKYEQBznvkpd9H1DFvVzohqUqw9G1yelAVmN3F+kxBmD88p1IayXqGsyEkh2RCnkTSvHO7canTDCotnPxVDugesn31baR06pshQC9DuN8PElpZ1fRdkXctVqCRMABy97xM0oERz3knoBacLBoHvZhkPU+2644ZEaVsktcgLODlRK+0cUIqE/0ir5CwHG9CUiTG5yaR0ueSqcTFroI3est+4sqNoqoWsUbQ5QE8ICw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZYNx8TiMPv7xFf8DcO5rV9zpNZH/E+n1mTiwyHrKsk=;
 b=KcTcZiHLmesdmxdkhU6j0Dps4M4aEKup6lDETqjSZcBOxC+J/b6JQGhl3pIowxnSxVoey5QI4HOTOyICoPDk24UIiXUcYiP5qfAdasxZTGVchNt681uHpKy6EBROmt8wubKc0Q9DEbh0Y3ao10rcCtzt1At6r9g6Rh0Dday3lyzaCxoiWoK+KYOI75KCSC+f2c1NwqaTwCRNTZ26E2nR++9glxeg4FkaEOy+5oyNLw6mZAXqIQwI3R/u+9NijMxDsAWcwUVcq2L0vMJYjniqmR+ci0WEs+HJzGaiEcsT+R8F5v5+gxGTOSQrl3/BopIVkAV9MGuVbfiyppTMoDSVOg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZYNx8TiMPv7xFf8DcO5rV9zpNZH/E+n1mTiwyHrKsk=;
 b=exgWCHjaF3IvXkS04f8aO8uQ7l4YiuaU7cxA1m3/U5AeeuEr2KmZ3NLIeCnZJEl7wzL167SQMwg4RYFO7RSFmiy2nlxX7KvSD5uOL64lJCo8N/HqrBt2xMG/ExAVBxRIr9tZEGnl6Ox//j0BJ8bGOY0TlBJI1B2MtYdKFzwKrQI=
Received: from CWXP123CA0020.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:73::32)
 by PA4PR08MB7594.eurprd08.prod.outlook.com (2603:10a6:102:270::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:14:01 +0000
Received: from AM4PEPF00027A60.eurprd04.prod.outlook.com
 (2603:10a6:401:73:cafe::82) by CWXP123CA0020.outlook.office365.com
 (2603:10a6:401:73::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:13:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A60.mail.protection.outlook.com (10.167.16.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOdzyYriJn52XF1h+ZEGq971MKhtbomsE2NNy23Q2Ttj2zNNwTfpax/5LjCEGq855yLZN2PxPljpPmh+UkBAEtQTgJwsx8+bjPXVPGQUIB+wt1PRlEGhDUL2vVOvKHCqWWZuEEuIV+Fa2H5hG+gDQ+yzNkLgSkX1EpcN889nLBx68vvSwCYHhJrd0uLnSOTBCMHu5Va+1txj5E2gmOlFZyt+nHQ0RvhCpcf8NJSHIs6h1iZ++781YlbJcSHq2COAhCRNMN3hIBuBcvsTohYjSUpsJSce17eyXPSZh9OZ3IcErFMuzWVRlKokNX65NNqhBbwjjUXD7gYpay6pVZAT0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZYNx8TiMPv7xFf8DcO5rV9zpNZH/E+n1mTiwyHrKsk=;
 b=C67p1wf1GtWu9LWT7Abk7tChBEOLV1BERrUyEZ0DOFFEVWUQtY2npHdDos4yvqSNJDkXUDjSvfdUR5kP5vrJMhfSnaWjLA4vvYz3PTTnfhinQFcxcMUUVAmvGEQWWYCzZTtj6t4/y4V2pe00zZKERwp+7Tx6UuMuKrIODVFkyBW/pMmiBMuzM8OwlzzFRvXNWBa4bgl8bwizV4xJjsZdnwVCH1eJchWzcWTmMhlzooL8QebBz+R8v5KDjJLF8ySkFKWTDU/4DzYp6OjMfKbfyhTJ6jTFVhv/lXblIFkBP4X5ewR85viKWzlSFsWyB0X0FT9OCnvaK+DgRhVz/XgETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZYNx8TiMPv7xFf8DcO5rV9zpNZH/E+n1mTiwyHrKsk=;
 b=exgWCHjaF3IvXkS04f8aO8uQ7l4YiuaU7cxA1m3/U5AeeuEr2KmZ3NLIeCnZJEl7wzL167SQMwg4RYFO7RSFmiy2nlxX7KvSD5uOL64lJCo8N/HqrBt2xMG/ExAVBxRIr9tZEGnl6Ox//j0BJ8bGOY0TlBJI1B2MtYdKFzwKrQI=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:59 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:59 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 09/17] arm64: Simplify GIC type checks by adding gic__is_v5()
Thread-Topic: [PATCH 09/17] arm64: Simplify GIC type checks by adding
 gic__is_v5()
Thread-Index: AQHccQJWrfN+oayoVEGkoVmTx96aBQ==
Date: Fri, 19 Dec 2025 16:12:57 +0000
Message-ID: <20251219161240.1385034-10-sascha.bischoff@arm.com>
References: <20251219161240.1385034-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219161240.1385034-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AM4PEPF00027A60:EE_|PA4PR08MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 70568691-a5ad-4d1a-d0a1-08de3f199f35
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?T3Cn2cWuoZywcdGIrHz9mfB5ZgE83NTnw3SDwK0n2dbfA9i3FD1jpUiaGt?=
 =?iso-8859-1?Q?naTmkdXzU5q0YDau81pm4bTaQOlnbAlDebS1PQNp2+kaY5xy9z5HWEBipR?=
 =?iso-8859-1?Q?+i4KKDS8BODx7nPsYsKIT+v8pWjCa2s2+HDPI/cx7nVRRK1kD1PITvooVb?=
 =?iso-8859-1?Q?HWE0TXm9NqivPeLdPB3Oe1S5V8Ymj2sgGl3AL2uZb4cByW2sLagp6JnxTx?=
 =?iso-8859-1?Q?uuar0QAQ/uWHih1bkRBai+nG/ulzAtD1eyxL1sMgxqAAjNhZxDvss/+0/z?=
 =?iso-8859-1?Q?agw8RN0vCHuZLylan3urpMQDANLEtaVFi5iHZckWvyVFSB63G299qWWqcg?=
 =?iso-8859-1?Q?bdA+SK5gUesW9Rpcq++ot2qYI4xpA5SIRw3C28CMMLYmPOOxth0NO4rNeu?=
 =?iso-8859-1?Q?Ev/r7YsI9Qy67lq5CoTeKZX3dhlml/z9pgGhuQUWI2jH4YNj6ZICskgsYJ?=
 =?iso-8859-1?Q?uCcfLh+x0Zs6edrSewUeT1FsZoB1IFOXo4EYEkc8S55SS7JuKfnL1Rey7g?=
 =?iso-8859-1?Q?LMIu7ktMZe0pw2Mv+hfPn+bTnaflLVHZtVWWu+LoMPInFlvpsNMBdLRNwV?=
 =?iso-8859-1?Q?c9yu1AO5T3bs5PGUfALFPCvtu0yN6jwh+GkyMLbiU7cBsPoUlh66J71WFd?=
 =?iso-8859-1?Q?79t8j2fWsut1VFRx+ZxfNn8jT0NSwMsEkjuYzOZ9GLDLneqi3VrDc/teuc?=
 =?iso-8859-1?Q?k5gcpMlTBgf6uSwJdTP2VYttQkgXgZSFlAuIlaflukTHRqZaSa0G2aVRE1?=
 =?iso-8859-1?Q?gaRWFX3smfzultwhIu5siMGyE9xyW7P81MTTPoSzQUkc9JBw9gC+SJptmY?=
 =?iso-8859-1?Q?DNgQrQbhNBzrjkhHz6vQFmxw5pumg9++xB+CdQdu9CL3VsWBU506LPOziQ?=
 =?iso-8859-1?Q?+Tf2zjT2Slotrcg//d3mcdwc0wvQozPvZPZpHGfugDy1FsyhJY1nFPamXW?=
 =?iso-8859-1?Q?XP37A04ICRYdIAv7uztbbNsIw0uyUmNx9JOat48WkWHyK1/TngwkAvEbQ9?=
 =?iso-8859-1?Q?3EQbsGDq9ryuWy7Rlwb6SErJQJI/QMvJw03dIYZuTaGg7E7O6M2L/RRjGn?=
 =?iso-8859-1?Q?N4GQsgZaaO0jnQzQ4MM5rHxYGuG8tCBBqcRHd5uhE9Ih4E286x/bQBoZt8?=
 =?iso-8859-1?Q?AyUbY00luLl81nLEXXKrT6a1CGUwShpF4nPW8mucB1l51uDLa8NHonKzHh?=
 =?iso-8859-1?Q?UUUUMo8rpYjwL4+MGWqYQ3Q+uqVDAOCbIAslBLxjQ2E78IaR0bL8EyXx1n?=
 =?iso-8859-1?Q?myrbsoPmafPbLPrcjw+ANEMpWMH/iXVpG+sOVofXYWpAmnKlg06eo6W88y?=
 =?iso-8859-1?Q?31j+wJxv7oXYukzmkfXOlRKeP6Z8SYEmUiG+xM+tMs7wyZpoiXvGIpeBsR?=
 =?iso-8859-1?Q?IVzln3J+TT+K+rehlx9Zj5m7B4+4Fo1gYN3pIHqOvHj5yRwg13DLUPGO/A?=
 =?iso-8859-1?Q?MHZ1GVCoIkqR+a60VQZZGgdJnJdD8fWHaFxg9kFcLB0Mb74mow/ugIkXE7?=
 =?iso-8859-1?Q?C476GJPTDWOCLXrcCLVvRjpLC8P471vTgrab2PtSUiLhEc94fNX9hNt1x5?=
 =?iso-8859-1?Q?e9VmkSAUoF4pSitno5KABK5E7bvr?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9582
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A60.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c86c5f32-46ae-476b-f7c0-08de3f197a3c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?hd9t1N7ojJYZwzEm3xoONDqtJWPRBdBG2aiyZqb4WjuMEpt1UW0/JWpw0i?=
 =?iso-8859-1?Q?/tSIo1ot1p6I1QxOngv6Z1k+oP/m8Di6wSwGD5IUKWLFlzMXbpeOUjrbKq?=
 =?iso-8859-1?Q?Hag+8AiTLvsdEXneYnt/Jkf/k4wh0dD+ujvDW6nZa8TjHYNVKW70sgCqWN?=
 =?iso-8859-1?Q?orLiDBZqG0aL1lBFb/PFwO81F1utObsOY9pUPF735lAbrYXaBIzjKd+TKs?=
 =?iso-8859-1?Q?ECdes/DqJGKy9Jvx/Y202xb1QUkPQr9Cw69O7YKD0GL79BK6Oha9NFG+f3?=
 =?iso-8859-1?Q?uvoPDd0oaXksNonqFEIl968EN70vAIuNHV7DoWVaNJdbaURMEuPEbQXlxu?=
 =?iso-8859-1?Q?qXUW4D1Xn1OG+wkfL22lTj0/bqzssGK73N5T19igJIoR9iNT14vEFy5SxI?=
 =?iso-8859-1?Q?8BjI4xGlqqb5VKLSikr9eHt6TpVDuBstxOjwU4CXdSmHSCMUh/nEQhrNxK?=
 =?iso-8859-1?Q?Of4M3b/m6riAIFTeMrB1PJAJOx6s/wDRgyNt5rnCGFdRvSGgUJ4vzk2iKv?=
 =?iso-8859-1?Q?2cD5rUxIJiMPXj8qsWqLh77W7BwQByUPSFnQmvWXPOlOABlmw2W+ou9mOj?=
 =?iso-8859-1?Q?+DOp+zoAhud1ASI88RAGTpcCGuLTwh2fQ2rw1erBWLpKBYBSRPnLRcVQLX?=
 =?iso-8859-1?Q?7ybCqfC6eLCvhIPX8lQYH1LO2mmtYno4lskimh7Jh1ChLlqTj2sHqvyyDC?=
 =?iso-8859-1?Q?lclIQlM4Qr8x5K5gwLZTc/yUuT00WlPLBRlbsjyTOvpcajmKlNMatGBrSE?=
 =?iso-8859-1?Q?zyTQZeToVMHMAsfDLvZ+6ZsIVZ4OR/cNTJl1qCPmllHnzk1f5LqlkHCFQN?=
 =?iso-8859-1?Q?YvaNkK414fabiIpIEZbiaIvxNp0OD3g1E1C5md7AZjydH2tMUROPcFl+XP?=
 =?iso-8859-1?Q?MVeGvQauqo7Q4sfQP4PBvEPzAmDWFfzId/3sTHj90SAcsGzvpARkVo2X55?=
 =?iso-8859-1?Q?GwRpqmyHxBZxaI/PucgcTX46xwjsMmWW5g4a+iJAgep6fsbpOulMse5V13?=
 =?iso-8859-1?Q?1DaS6aGGeHgkhf9zKBiSpeDSu7gkGIorfafEnBusxjGePSCvBxpxqu7sSm?=
 =?iso-8859-1?Q?+RZxG3Wgf++sMZrP2PrF3+wgAugn1CsB5jtGxPLBOW78dfq7/SaHgfo+2H?=
 =?iso-8859-1?Q?iACRSiQ3/dTOVHwmaV5GndJmePWofX7mCCRu30ZSWuTJw3qOC2ScJAuZBW?=
 =?iso-8859-1?Q?9mjWt2EttE4Of124gorIgsGhW9X0hKjBerZVw5YVJlsdHk2OXJVwjSsm31?=
 =?iso-8859-1?Q?nkMac2DIyCQ241ZHwTcP5FGbOQ2i1t9h+DaHvzsa0QRcpGKm3sFvtBACj+?=
 =?iso-8859-1?Q?nPC0x5cbk4S1CEzsidm9OUmhhtCESUDZtAMK/bZu55eXXq5vpK7HBr7H6n?=
 =?iso-8859-1?Q?JIVwdJUXFOv7HpU6kwU1PjaSYcYxRWn+PVm4vKIxkYQXnkSNMZlw7ARrRN?=
 =?iso-8859-1?Q?/E8cs1c8R8vsh1Rb5VNPt4DD6v6xI3OB3Vz26s95A5Ccz6UsRLPotdZUZ2?=
 =?iso-8859-1?Q?dMFAJQ6oPJQxI1VYTYfRRT2G4H6iEhnfZPieWKvEXwoG7Tga0lyWWcs1Ed?=
 =?iso-8859-1?Q?ISrikjvrUty0XWvmXlBlIYTtROWePqFAsTpWq0+c2uE07727KZDBcvGb08?=
 =?iso-8859-1?Q?g8B/85x6bemSc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.9906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70568691-a5ad-4d1a-d0a1-08de3f199f35
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A60.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7594

Track if the GIC is GICv5, and provide interface to check that. This
avoids having to rely on either struct kvm or passing irqchip
information throughout the code, thereby keeping things a tad cleaner
in the process.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 20 ++++++++++++++++++++
 arm64/include/kvm/gic.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 67b96734..a49bc9b9 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -19,6 +19,12 @@ static u64 gic_redists_size;
 static u64 gic_msi_base;
 static u64 gic_msi_size =3D 0;
 static bool vgic_is_init =3D false;
+static bool vgic_is_v5 =3D false;
+
+bool gic__is_v5(void)
+{
+	return vgic_is_v5;
+}
=20
 struct kvm_irqfd_line {
 	unsigned int		gsi;
@@ -225,6 +231,20 @@ static int gic__create_device(struct kvm *kvm, enum ir=
qchip_type type)
 	if (err)
 		goto out_err;
=20
+	/*
+         * If we are using GICv5, then we need to allocate SPIs starting a=
t 0,
+         * and not at the legacy offset of 32. This must happen before any
+         * interrupts are allocated.
+         */
+        if ((type =3D=3D IRQCHIP_GICV5)) {
+		err =3D irq__init_irq_offset(0);
+		if (err)
+			goto out_err;
+
+		/* Track that we have a GICv5 - needed for FDT */
+		vgic_is_v5 =3D true;
+	}
+
 	return 0;
=20
 out_err:
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 13742bd5..805f4247 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -40,6 +40,7 @@ enum irqchip_type {
=20
 struct kvm;
=20
+bool gic__is_v5(void);
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
--=20
2.34.1

