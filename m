Return-Path: <kvm+bounces-66395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C81ACCD117C
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 18:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0787A302DB09
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCEE382D4C;
	Fri, 19 Dec 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HbPlb/ck";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HbPlb/ck"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012071.outbound.protection.outlook.com [52.101.66.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D555737D131
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.71
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160853; cv=fail; b=gSNitYVysJJRKHwjGJtJTgudlBv0RwChoK0j8NTiXNMXHy5XSAAZOgkrKAgXrzK85LVH6bDkeHQeJHiI+iHGRVMKaJPVqlIxxdv+FkgTMQ3VDN93kVD8j4S6n78b8nTErau9HBQFlumQl6OiK6bVEE62kdffw9sqcXrRVDXN7rc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160853; c=relaxed/simple;
	bh=HsOuDX0Z4atjKf6YwhqXIRnxbKp35gYUHAq8AgHzHtU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HSzlk887I7LkxNPjTwhWj6mMaPRf/vP444BSRGX36FEL3c+48KTHcukbdDfTE2PFgJjr2g2i2QLEPBntHeXvlfe7Lnx7db2p7q9SWxGWNLoUZPRVzdv75fgPV5eQ8PdT85sYH0d7HDpRH37UDnWQStbhNBt5JxKyquCZYJKFRjo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HbPlb/ck; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HbPlb/ck; arc=fail smtp.client-ip=52.101.66.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FtY5xHTfwcf0CBpH0oNh54WdlyzW4bT+fJsnRF/aEuiQnuDtxHJPzhirl2/GcvGgGkP8zb2XHAZBccQHZqaDBMnsgOMvV2THkoivGHP9HphXb4RioAIMEu9tRnuTwfey9fmmdK5OhNK4Ptg0XbBf62o8w9svEdkED6x8xiKeOB/+/5/IlLDugFlhYeNhJ1NPEHpjS1p08CvmNFEqWVeAlmBbiPQSOHVXNPBDhwgy8jCxFb79g/OE8zJlUCuaWm1ZuLmsuVyxsVo8vRIRPvc8lWPclxrb7MRT2oXXmYwiH57Jvtt9kXJ0Wt/vLGxXv9HaAs3aiY8O7EUmXn715Kr93w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cTeEVfTA/6EO+SWZAGaXJqsQSXrFLURaCERO3+jdkY=;
 b=Zn5oWZVF060vEEdq9D8ZASDzA4IXztw58qIHEWuP8LF0o/1J2Pdj+NmUDM/brNbtFa5fbCoAG1mxRa+DOL6hbI8oUdcGPS3MgwTUA2Iw38WC0qgq8I3VFIM1Y+mMAc4l+bu8X3O9y+CABTETcMBBu+ZM0GFaFX0v2wMZWngYy0j5Hg0FnTXLeDccAtrkcQ2JxoK/1V+tamiVLsLnJoNrz8WnehgG7jVYIdSh+g7QYeaQM6IcU0kQR1iiN7r/oXGhO65d5l75gkekHgqHkeCsCCpsPoJqjFsOaP5SjEEHzs8SX3cchiHmnj13oPQ7mOhVx9VxX4ouASmLxkXhAIvILw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cTeEVfTA/6EO+SWZAGaXJqsQSXrFLURaCERO3+jdkY=;
 b=HbPlb/ckvkJj3EaE0nymaDgj8YwOYmaruhXFRSS8ZB8ByUiOafyUjrdxYEVNHenM3XG7txetxOGgUOZrs7L65JGM5llFFe43RtCmjRahtror//RSy6C3MoArgj8wJ/dRgKr9MJfwFpoTZehSg2J0FCntXgFszH8vLu8byYc/6kk=
Received: from DB9PR06CA0009.eurprd06.prod.outlook.com (2603:10a6:10:1db::14)
 by VE1PR08MB5757.eurprd08.prod.outlook.com (2603:10a6:800:1a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:14:02 +0000
Received: from DU2PEPF00028D04.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::13) by DB9PR06CA0009.outlook.office365.com
 (2603:10a6:10:1db::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Fri,
 19 Dec 2025 16:13:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D04.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 19 Dec 2025 16:14:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABz0zTCFqnFJBdwkC7GY1ktiN683EotE/Q8dg1DhvWJ2JUJkhDJqViKbZlFWJ0iyIEuMoXa/6nZh67Q9qD/JzzPEK+o4wYZjfttx/HpfAStE8YCpokwnt67PLBe7Ucbg5tu2m3HvoxL9KyRCdnJD/gpFIvRepa0Tc6ZtaBoz65wrTpAu+/wphtm0+xwOWrr1tX9/M7ygIe6s+1EgE8mRPwQNyE9jj0RPTd3EsDLOTHA/JzDImqkV0xhZ1rek44su9zmzLeNFcWN9hIQ7rCTTnotJmREj8ggZO0reRt16zmpMiNNdOwUTsTfqqv2C+fn4z4u+5bKCYjZ6OgjRQorm0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cTeEVfTA/6EO+SWZAGaXJqsQSXrFLURaCERO3+jdkY=;
 b=wJbxYhVjOfhqYwgd0jzgW9+ulVNaR9Wz8ugs5ndWymHrhVc9rAZorG/WBvMvB9QqyBktAuFk9cHKbq6gp/HKh+NV6vueTAUhn6lEZ9DMrPUnjGcINo9vKBdQCGWhmklG2FtCCHA3dkE6526St4h+bLV4GPQGseWdU5qPXjLH4ulHs5pHeWVzzmv90PwkXn41JMMMpLDShGKxYyzD2Z3cd1Xk07T8r2rz5vNJ6AanBayDD+gloFApP41/OMR2m08UKnP6snccs72OTypkDT97STN0IKx3XOwNwappvw9atUqyeQW4txe6oHqQHoKZMzqebmxC4ytY+q0nKeDyOlzAkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cTeEVfTA/6EO+SWZAGaXJqsQSXrFLURaCERO3+jdkY=;
 b=HbPlb/ckvkJj3EaE0nymaDgj8YwOYmaruhXFRSS8ZB8ByUiOafyUjrdxYEVNHenM3XG7txetxOGgUOZrs7L65JGM5llFFe43RtCmjRahtror//RSy6C3MoArgj8wJ/dRgKr9MJfwFpoTZehSg2J0FCntXgFszH8vLu8byYc/6kk=
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
Subject: [PATCH 11/17] arm64: Add GICv5 IRS support
Thread-Topic: [PATCH 11/17] arm64: Add GICv5 IRS support
Thread-Index: AQHccQJXXCxDs45VvEmZQ1sBdrc1Fw==
Date: Fri, 19 Dec 2025 16:12:57 +0000
Message-ID: <20251219161240.1385034-12-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DU2PEPF00028D04:EE_|VE1PR08MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cfab914-4deb-4a59-0a8b-08de3f199ff8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Ba+8BD1yk6naWe1Aj/0Ky02BLXyLdSXDmWgcgYRcTafFdkh/UYmezhEg2W?=
 =?iso-8859-1?Q?lIzkzJoRjQ4/UcYarPlmduW49N1uul2ztEH6fw9LT018jnLGtR0qApwub/?=
 =?iso-8859-1?Q?y7hPHJAf8P17z0TAIrFb5BkSFY5crh9m9Qr3TiEwe4zRo8GnHaQBwcRqmr?=
 =?iso-8859-1?Q?zLIWMzHBXGC9hpBiIrGEa5w4wXO3YhsLXSUy7xQRf548QxuDPZ9NlPj+bD?=
 =?iso-8859-1?Q?vgiqEdC0Z8bMdgc28xG3uFz7M8X6wqzdSsHDWv9QRKbx8/CvOa5IyiFCcN?=
 =?iso-8859-1?Q?W95vOBf0jraLFhUA58WBqhchNHfItPiVuASBk+Bybc3Xt70txE9RafjCsD?=
 =?iso-8859-1?Q?lB/x0FMV4QRGZ2nrb3Ijacn8Z2kIgy2ZmjRBTRx1G2IHkPPmjtk36TfEH2?=
 =?iso-8859-1?Q?u7Glbu5cWh5Ak1vDvjWWsaXS/Sd1rwI+UhHq4L3/IFNr7Kn6qHnGV8I58f?=
 =?iso-8859-1?Q?Wz1ywRH9t75viOspmFnjcTCtP8x3Nl7UOSf0SZqdYWveQ4Epm+8U8yCHMp?=
 =?iso-8859-1?Q?+kLickRPndCiGaAcD7MBNoaD7ZZtz4jiGKPDCB7Q8a8O5p5NyQyPyAVYbb?=
 =?iso-8859-1?Q?mVr5kkSG4KIasBmJdEKpuP7wekbi86+lqoqsECI0cYrbUdIc+shC/ybyKA?=
 =?iso-8859-1?Q?GqA3Vrn8mgQFiP96xOYN27MBpPeg2XC3B0seoCsqncOTDdlsXxFITPjhYb?=
 =?iso-8859-1?Q?jspp2JOlRlTqqIoiM+bpUyXPlg7yAg+EdVA1IEQDuQciGI+KxQUGW9LiJW?=
 =?iso-8859-1?Q?+3MLmodhJVpJSm/gDAx/uX2O6ksPv5GUrjHjI2c2b8EE7iWync8WNB1SIO?=
 =?iso-8859-1?Q?QI7K+0wwsa0wbrjdhSCAv6q/2luF78G6zEnKWSYf51iM0/kffOdQewOwyj?=
 =?iso-8859-1?Q?om7tQKOo//VlWQVwl4MpuVI2pfEpaRJDUIRmBO4xMyOK3bkWcgr3Rs/zeT?=
 =?iso-8859-1?Q?MQhk04kpUrrklehiqU8Gx8gxwGTY6HyU/Zx3Sb6UTzyLXWqztmkNCHTLkP?=
 =?iso-8859-1?Q?deFZN8pNhzALFZB3+hwvsIMLjeraPXbAeDwn4mcn3GpVKLWzGLkTBHDmd4?=
 =?iso-8859-1?Q?ABo0pzsolSibXgdIbvOuW507X7+jlqMcIdfj4/iKdTFqlaVioTiAy7zssv?=
 =?iso-8859-1?Q?EpdsA5po0D0vOYkLX4HC10LaItKj83SFJOav/TRHlPr5N8nPDCyH8qNzgr?=
 =?iso-8859-1?Q?b9lnVhw8h+w/DYxvYzJIp57u9FN8XlPqNcjxalnhxY1BQSftbbk8Fit8dC?=
 =?iso-8859-1?Q?DCh+eGlTHnepqJHeuBVWjy3CdPM856/EIJgKbWpXUnG0PWlUxb6BgX71Xi?=
 =?iso-8859-1?Q?yxB2yH2kjeYel6OHQH+yU9+qq5r3TFU0MH29Fxt6yezvEO7o2eP0kbFYlp?=
 =?iso-8859-1?Q?9PYxWCzXO7PpGvOkfVgipNj5Gc2injmahzJGV3yV+risdJ2DSE7tki2wvp?=
 =?iso-8859-1?Q?o5/rAooFQRRgBZpgQ/OfmTh22eWBOJCitEma0VniHitGGeTPmAwsDTHs+c?=
 =?iso-8859-1?Q?nYVMWS7lEHg2J/Uvu3D9RQb0c5Quk5hSv4MF/Av1DAs2w/BobSGwDTW8mx?=
 =?iso-8859-1?Q?XjbFCEJEThDB/uBW7FDWtI7SRCyO?=
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
 DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	221dfb55-56c8-4334-00bb-08de3f197aa9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|36860700013|1800799024|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?c0ukFJGMSmOrJV/H4zeK4FvYfXvQy7ldDyviqT9xqLbDg6kSS9P6K3Yz5B?=
 =?iso-8859-1?Q?ojjX93YtDkdyeeRtAZmqW/Kw4i9Uyn1lCh5bcAcNJlMYZmODsiIZwvIV3N?=
 =?iso-8859-1?Q?H75p9O0rRys0hsW42U0lm6p0mh6vw6v9rGuGRGzvZuupLGCcLOS887aZRR?=
 =?iso-8859-1?Q?OWgLAxV6sI3O4UXlCtejenSVoOYF4iRP4CLqoa2DOCKn2DBsykxAiGYU0t?=
 =?iso-8859-1?Q?Mv98mcyUQ8+QAcoNiuJZlIty/FMrktM94SvgO8X5Kj6xeQRrbvqjjuBbKA?=
 =?iso-8859-1?Q?Ne3lb5sX1GscatbDeNgD8KOlwbdTKsLZBVPymKRAS4V7QxrqHrNMDvYv39?=
 =?iso-8859-1?Q?e3NSQpLfHt/jSqRt0BpenPjdV02UVqhClDxJLlUdR/xdvLFajPLpb5fvlB?=
 =?iso-8859-1?Q?cNCx8Ahx0p059KzCEVIWqkoNMHIv6LUtK+mtdn1wApQlmgK/ggspuudtyp?=
 =?iso-8859-1?Q?12SX9NMGhuEGOXgzuoY3sr1vpWvsXjaV9ZcZ0h0UCK6VScdX1OX6z/IkV4?=
 =?iso-8859-1?Q?B34j6sLz3G6VZlopbwMrDCkLzOowkXFms5TtfytOJN6W1QagpbTCad9eH6?=
 =?iso-8859-1?Q?bJmh2J3iZgKdXjB/ZhezRosjsaDIScA47hSbkAxNMwPWy5QuKUZrfBYGpI?=
 =?iso-8859-1?Q?iUgaXx9afQgqQF4tBfBu7ijWA4UTX8Aqs46CYybCmI8osVmu1ILjQY+wWo?=
 =?iso-8859-1?Q?PNZHyFTWhFxiF8GjMatHTLQfdEQS7sIZXsFknV3F1ApBFTFYh7o8kX/a2h?=
 =?iso-8859-1?Q?Gz9iHcnVRbJVzovxpZ0r34NiEG681nHcnSgnbdhbycLrQEo43GoSQLMHyo?=
 =?iso-8859-1?Q?M467797xjcZ8xzD42sHy7Om9WSOo7P27BsCeLjuCUuU4GO3zuHX7k+uyrg?=
 =?iso-8859-1?Q?XNlOozi/4PI5kC/l3t4VSUbrfv3yJIPQCKoV/dJnjy3VOPMfGbeDx65JEu?=
 =?iso-8859-1?Q?hg03NecP5cLauNEmhbw3uMxxrFmjLdzjQ3Sp7XPjvnZoPuaqHBD/xWuo6Q?=
 =?iso-8859-1?Q?l7pqek6K6yNXEn7sc/HCuCRKPrHOfgRuGHuEbEt7VdKpEWdy0YvdKLUxNV?=
 =?iso-8859-1?Q?4ad1IydFah6IDgX0rjz2r6Jj1ay40FKOs3HJzQ8MXfJVpM9Sw1ygtVtCEf?=
 =?iso-8859-1?Q?4GOR/s5N736/VkEUHMh1O7vnvBd6+7QHTToaL2PM5g+1s59lxVj6d8AUWB?=
 =?iso-8859-1?Q?qhgmxXCjtErhrwsTrJTWzGxleMb1VPtsXnlPNOA8oJQj7KBH1z/garDewm?=
 =?iso-8859-1?Q?Yn8hgSFjtvStXVlPYHkllZmyWLQaJ2/wtAUeP8DGRlF/OO+/25IlFHp3tT?=
 =?iso-8859-1?Q?WJe0yov+3vpn+6yW2YKVLKu7oTVIASlc6K+3JPp4pG7Alx+sJqeTPTC481?=
 =?iso-8859-1?Q?lKGxaAoUnT1kZBSn1AM4WGOjd80Zv4n0wGVJ7PnmrakaOY0krgeCECWtmG?=
 =?iso-8859-1?Q?2ceFzutSfVe5A2GjV/SRmbaUuxMQ+jhFHHtyW8QGMUj83v6/Mmv3G4+zDB?=
 =?iso-8859-1?Q?54NAalZ9J3xcU7+kPw7qD1dABAq9mPVKp07hc13sCELWHI1vpbrjDDaeJ8?=
 =?iso-8859-1?Q?/5yRK7Z6ZW30fdpnGIdxLZfGF/R+t1eyFSIUobAQLyrywGr2UisbTX5gSQ?=
 =?iso-8859-1?Q?HK4EuPSNyJLHg=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(36860700013)(1800799024)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:02.2694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfab914-4deb-4a59-0a8b-08de3f199ff8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5757

Set the address of the IRS for the basic `gicv5` config, which is
required to correctly initialise the GIC once the KVM IRS support has
been introduced.

This change enables SPIs and LPIs to be used with a GICv5
guest. MSIs are not supported.

Note: the FDT changes to add the IRS node are still to come.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 20 ++++++++++++++++++--
 arm64/include/kvm/kvm-arch.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index a49bc9b9..5cb195ac 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -16,6 +16,8 @@
 static int gic_fd =3D -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
+static u64 gicv5_irs_base;
+static u64 gicv5_irs_size;
 static u64 gic_msi_base;
 static u64 gic_msi_size =3D 0;
 static bool vgic_is_init =3D false;
@@ -178,6 +180,11 @@ static int gic__create_device(struct kvm *kvm, enum ir=
qchip_type type)
 		.attr	=3D KVM_VGIC_V3_ADDR_TYPE_REDIST,
 		.addr	=3D (u64)(unsigned long)&gic_redists_base,
 	};
+	struct kvm_device_attr gicv5_irs_attr =3D {
+		.group	=3D KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	=3D KVM_VGIC_V5_ADDR_TYPE_IRS,
+		.addr	=3D (u64)(unsigned long)&gicv5_irs_base,
+	};
=20
 	switch (type) {
 	case IRQCHIP_GICV2M:
@@ -213,6 +220,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
 		break;
 	case IRQCHIP_GICV5:
+		err =3D ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &gicv5_irs_attr);
 		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
@@ -314,6 +322,8 @@ int gic__create(struct kvm *kvm, enum irqchip_type type=
)
 		gic_msi_base =3D gic_redists_base - gic_msi_size;
 		break;
 	case IRQCHIP_GICV5:
+		gicv5_irs_base =3D ARM_GICV5_IRS_BASE;
+		gicv5_irs_size =3D ARM_GICV5_IRS_SIZE;
 		break;
 	default:
 		return -ENODEV;
@@ -335,8 +345,14 @@ static int gic__init_gic(struct kvm *kvm)
 	int ret;
=20
 	int lines =3D irq__get_nr_allocated_lines();
-	u32 nr_irqs =3D ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
 	u32 maint_irq =3D GIC_MAINT_IRQ + 16;			/* PPI */
+	u32 nr_irqs;
+
+        if ((kvm->cfg.arch.irqchip !=3D IRQCHIP_GICV5))
+		nr_irqs =3D ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
+	else
+		nr_irqs =3D roundup_pow_of_two(lines);
+
 	struct kvm_device_attr nr_irqs_attr =3D {
 		.group	=3D KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	=3D (u64)(unsigned long)&nr_irqs,
@@ -495,7 +511,7 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level)
 		.level	=3D !!level,
 	};
=20
-	if (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ)
+	if (!gic__is_v5() && (irq < GIC_SPI_IRQ_BASE || irq > GIC_MAX_IRQ))
 		pr_warning("Ignoring invalid GIC IRQ %d", irq);
 	else if (ioctl(kvm->vm_fd, KVM_IRQ_LINE, &irq_level) < 0)
 		pr_warning("Could not KVM_IRQ_LINE for irq %d", irq);
diff --git a/arm64/include/kvm/kvm-arch.h b/arm64/include/kvm/kvm-arch.h
index 8f508ef8..717a7360 100644
--- a/arm64/include/kvm/kvm-arch.h
+++ b/arm64/include/kvm/kvm-arch.h
@@ -57,6 +57,36 @@
 #define ARM_GIC_CPUI_SIZE	0x20000
=20
=20
+/*
+ * GICv5-specific definitions for the various MMIO frames.
+ *
+ * Base for the IRS, ITS. These live at the end of the MMIO area.
+ *
+ * The IRS assumes back-to-back CONFIG and SETLPI frames.
+ * The ITS assumes back-to-back CONFIG and TRANSLATE frames.
+ *
+ *              REST OF MMIO AREA
+ * *****************************************
+ *              ITS FRAMES (128K)
+ * *****************************************
+ *              IRS FRAMES (128K)
+ * *****************************************
+ *                ARM_AXI_AREA
+ */
+#define ARM_GICV5_IRS_BASE              (ARM_AXI_AREA - ARM_GICV5_IRS_SIZE=
)
+#define ARM_GICV5_IRS_SIZE              (ARM_GICV5_IRS_CONFIG_SIZE + ARM_G=
ICV5_IRS_SETLPI_SIZE)
+#define ARM_GICV5_IRS_CONFIG_BASE       ARM_GICV5_IRS_BASE
+#define ARM_GICV5_IRS_CONFIG_SIZE       0x10000
+#define ARM_GICV5_IRS_SETLPI_BASE       (ARM_GICV5_IRS_BASE + ARM_GICV5_IR=
S_SETLPI_SIZE)
+#define ARM_GICV5_IRS_SETLPI_SIZE       0x10000
+#define ARM_GICV5_ITS_BASE              (ARM_GICV5_IRS_BASE - ARM_GICV5_IT=
S_SIZE)
+#define ARM_GICV5_ITS_SIZE              (ARM_GICV5_ITS_CONFIG_SIZE + ARM_G=
ICV5_ITS_TRANSL_SIZE)
+#define ARM_GICV5_ITS_CONFIG_BASE       ARM_GICV5_ITS_BASE
+#define ARM_GICV5_ITS_CONFIG_SIZE       0x10000
+#define ARM_GICV5_ITS_TRANSL_BASE       (ARM_GICV5_ITS_BASE + ARM_GICV5_IT=
S_TRANSL_SIZE)
+#define ARM_GICV5_ITS_TRANSL_SIZE       0x10000
+
+
 #define KVM_PCI_CFG_AREA	ARM_AXI_AREA
 #define ARM_PCI_CFG_SIZE	(1ULL << 28)
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
--=20
2.34.1

