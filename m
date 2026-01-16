Return-Path: <kvm+bounces-68370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC97D3843D
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 40FB73012A9C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598FA3A0B0E;
	Fri, 16 Jan 2026 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q7m8rpvf";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q7m8rpvf"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013024.outbound.protection.outlook.com [52.101.83.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05127346FAD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.24
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588058; cv=fail; b=cSdUubuudx7YiEUQObo+9m1YgzYOQyGjVTBSKvvm9pPt6E/6Iw5VMrvr8c/2YWWR+CruJrZqHnXnwSgfhv64gZRcivaXpkkXS44NWkgBcvdDHQ5CXZCju/gZMsKjwVKcPGXQ+iAwgMpMu+FjNi75sW6IKBlxois2mtIIOT4vyeQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588058; c=relaxed/simple;
	bh=lvdz87aF+dNe0KoM/8mP+SEAQe0RCMF6fbgDkyi5dSc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TxNyTYpE6i3yftXrTwQYHzacvXqPAuj5an0zDTavkSl4Dqye5LJ43zubQpFKTof+YYPxY+/rN6jWJMdJUxAwDEPDtGOeBfN/b8wDtIOjXwshH6zpxKvkR3X/Xt9K++BsSG1IPQvn+hCs0GDgB9HWzlAsKVbvt8esWUo2TadLRm8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q7m8rpvf; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q7m8rpvf; arc=fail smtp.client-ip=52.101.83.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jzkqhS3Dj/0gQJLgN8c449o5lJaeRVVCi/M2oBB10hJrklAicR/KFhL6G+tBMCF+JEbJXRX4WtsMNwc1H6HRaonccpFJJpfetpCNJzmwYXcbnaWMARpxc4FVz9wJxrToeJFcwkswKsjBv+tFzQ3lV7KDINPUGmbGnBjI3RvqLBtFypQg00flTO93LDJagbBkskBGD3pxg+t6e/thBHWdPvIIoWyUF32bbPB0LPo37evRZUa2edGSLQVM3dMp6OsuTzek+6YUFuHWuMEejR3mYVTTw5GvUQJcA5dUzcpTD3tjaR2HvBl9UurLPlXFArDtsSlAlY0ySXQi6HGrjBHSFA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPmMhr+yeQ7Gv+T9eLqdiOXx/fAp/1sPSFvaNXwKWl8=;
 b=g52r5DmdMnRBhW0Emf3rR80C8+GGt4los0OoQ5LZe3n4V4M4E7nnMBl6gHdrMX+vHoryDX9y/IzfqBdeXqXG0fMhJHIpVYk26UusseFjcE4lZL/FbGPdPqkgmy1xktbapfHV1IQSOcSRKBuznfbuFT6M1d3yd8gg5Ucl3td/yt6ea2yY/evAxP/H9oEYXYNgElDJpqMqsH72srcLk4sQckElOcnYb//j+Mh8g7Qspqo17BSpKoeuB1ffuLpIt07V1FyJYtyPQBxQD4AI77Fz+gzRiuJfcQqTV6DkaCUbxKY+d6gBlbtx6Q8EzhCS+1PCBrAPpJIb5c8dXWwtmYIu/A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPmMhr+yeQ7Gv+T9eLqdiOXx/fAp/1sPSFvaNXwKWl8=;
 b=Q7m8rpvflvBZRBR2GqMjBDEeuJutglSh83v4qgRMlr7ZFnYdxT/n1E5hP5Qm79DnTjL5FHp/hIaNjTVKGm7XB6D3MM3B6b3Hxw+gPGEaO1FvAyHodRou0WKtIrcHn2MjWTd6Lras3VX+4S+dmEV1inMeh8HyS6HmeIPvp37p9KA=
Received: from AM8P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::27)
 by FRZPR08MB11191.eurprd08.prod.outlook.com (2603:10a6:d10:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Fri, 16 Jan
 2026 18:27:26 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:20b:218:cafe::b4) by AM8P189CA0022.outlook.office365.com
 (2603:10a6:20b:218::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:27:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GhnbaWswGrQBrfvyIO5+Mzj8qjwMFtbTMx75kuH+o7pUShkMu63kWGtMU2HNG2N4OGFYAmZ68nOTSWPQf7DivGd5dnFr/5Kdy7BNMQF4weazcGwPZ+lvsnsWUcTSqDphX104/ZD6DJVnTBQMz71IVP9BzKzNDPvXATAN++HD/foYQ73yqIL8erKFxJtJgmNEXbWyj1nLEV15NAUubsmfcbM9Tyj1uP/Hi8t6u2SybrM6085HDP0ZhXj+mPbxCvEjzB0TxtZBL8J2dNy0W1sOtcaimzIQkBt3njPe6quzab7nq8S0eJeQQrbRrhmyDdYMzoveCtvdARTe9467Mtixzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPmMhr+yeQ7Gv+T9eLqdiOXx/fAp/1sPSFvaNXwKWl8=;
 b=bTqccKDfyGZztRgfpRut2LI87t8d7sRE22FVZKlaYgYjXQEOPqG+dCpgO+Qw/CLAuCPB1/Z8YqneP+EM7y+A7NQnnXMEfhW/WWF7/vi3mvKvdQVlakl9o+1yIjz/Jonya985eStIdM4OzAcZSSZUjFKu8gAEVOaZD8P3+HGzR9b8FHbGPJI7uzTJENPpPZJu4xk05/z09GolIDZWhU7lSaw3KOPS47+IgIU5b8vOl0nxhSIu4/BM0mWRKUXkOpaN8581U8ctVMau5PMeyar6XDL4Df7b8rclfzwRjMBd1bK6f5PhJcdXoWi9oh5zkCQguuva8W0RM2jPcV51KdhLbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPmMhr+yeQ7Gv+T9eLqdiOXx/fAp/1sPSFvaNXwKWl8=;
 b=Q7m8rpvflvBZRBR2GqMjBDEeuJutglSh83v4qgRMlr7ZFnYdxT/n1E5hP5Qm79DnTjL5FHp/hIaNjTVKGm7XB6D3MM3B6b3Hxw+gPGEaO1FvAyHodRou0WKtIrcHn2MjWTd6Lras3VX+4S+dmEV1inMeh8HyS6HmeIPvp37p9KA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:23 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 03/17] arm64: Simplify GICv5 type checks by adding
 gic__is_v5()
Thread-Topic: [PATCH kvmtool v2 03/17] arm64: Simplify GICv5 type checks by
 adding gic__is_v5()
Thread-Index: AQHchxWe/VJjhDA4lkOwBSb/XJkbZQ==
Date: Fri, 16 Jan 2026 18:26:23 +0000
Message-ID: <20260116182606.61856-4-sascha.bischoff@arm.com>
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|AMS1EPF0000004B:EE_|FRZPR08MB11191:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d5737c-52da-4da3-9b07-08de552ce64f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?1JhEGikyXeRy5UcncTeYPuM4ruwEabCxYYnMapmSN0YORPihwDOehcpWAZ?=
 =?iso-8859-1?Q?AMlVPGRoYmC8UDcXHbA7uiQmqELDDg8D9i5faB+Z6Gzg76eOP4HVsXI3Zr?=
 =?iso-8859-1?Q?YFd55aimXssi1AGsgObz4z4ZVKbzWvBu+Ogrd/F9KZaYv0md5QVS15uAqb?=
 =?iso-8859-1?Q?7NcCY9xullAn81+VdJeAuPNzvXJcNyNWKEcga2WVdZeJqw46z/yJOB1Vrz?=
 =?iso-8859-1?Q?rXRJdkz85qhtyPT4/01GeRlK4MGDB8t9XeBH2CwX5UDeGoaIHw0/bP2kDI?=
 =?iso-8859-1?Q?2Ifgk8F9/4ekYMRmQBZEdPvEIGXUuMyEc2JYf/4Td3JqkwEGlMJfrdoq/2?=
 =?iso-8859-1?Q?kC3QxLx6iodPdK4Bu/lmQ0u6fMMS6KjMZ4/OROwRWj8RssfZKmpSlsJe5H?=
 =?iso-8859-1?Q?R3ntTuHAyzAejBHyaTXd/nanWOqfrQwEAMVtEFaKcF0CDQxf17zvf9ZHVO?=
 =?iso-8859-1?Q?M0tvRYU9G6TLkbmHQCIU8wupJXrp1WycHr9AKRCEW0ohPARTw084gz4C/j?=
 =?iso-8859-1?Q?TlenaIGAL6tKt3RuYhAo/AzCMuMGuVj0tA2hPS90GIbJrVIdFDnM8qajVo?=
 =?iso-8859-1?Q?CgtcnhFuHGB1jAkJEAyeQIKHY8IFI/1Lghcvb/YA65oFCjBnQXRHBPHJOk?=
 =?iso-8859-1?Q?UeJMpRCXzzHABlW0GPoOReNzrUbAtlJwWqm0X817FVbFPTYUk5eoBK8wmN?=
 =?iso-8859-1?Q?pdn/5H8ylQie8LXymDd5AnzUCrSbFB60atp7JO7hqSdPSDBdaEwMkOqhWz?=
 =?iso-8859-1?Q?YAhZxCLD7Tz+BpYVTG16rBFVW4CeJNNBq1G5X3sonu4PbemCgHLgWa/AJX?=
 =?iso-8859-1?Q?17/7XRctmoYvWSHuoI29SqOauJyvTQUqVIDEET1hTblbRQ1T81686fmU7h?=
 =?iso-8859-1?Q?+tAgFJQJNneHKiUIvKgDePvJ9JsaSO4h7pLutmrM+evkHd+wvug2P3f4Xn?=
 =?iso-8859-1?Q?B31WFocpDS7tun5sP7kqpZ3buBpNCRq9aqWXEY+4TSgmLSYpXhrusxWiQq?=
 =?iso-8859-1?Q?qvccfqeJuRMG8XI6k4ezW+F3klKnrvkog64aJPnHcCvIvwNZ2djEO0r1hW?=
 =?iso-8859-1?Q?TPMkMSTgxHT8hPTnS0Fe/HGYA/mxL3r404QWfmZTPx0kpWzYJFwBU0s8+q?=
 =?iso-8859-1?Q?FVyvy7so5D7EZwf0lhDc3fxuJ//NX4SSMjIEe7nbib/S1su04AnE7p5nXv?=
 =?iso-8859-1?Q?tv2gxw5X7sAfO/XDXIVSdTNJB9or1+CMcY42cLdjIp/z9GYqnc4fGf4XGs?=
 =?iso-8859-1?Q?YiSqV/LNXIT9rDudiKt1N7lg9HJFhQk/yJsWRec9QDLBuwiH+pYQAjqD+Q?=
 =?iso-8859-1?Q?yJ8p6UmS9y+0kAp27hsqsBZqTonlxGM/2/2QlX2nrq8QPvD4p2esvn4viF?=
 =?iso-8859-1?Q?q6rI3uLFdG5/FJAeu9Nenb4Fi4Mo7Tdzw196mg8++sqINIHy7yFqekbrdS?=
 =?iso-8859-1?Q?lqgaZL4fGmvrFuRWwZJIhM1cgg79o5LYznRH+CjW7sH7STRE7AVq2W/UgU?=
 =?iso-8859-1?Q?oZMJrsyDAMiyYylLF3z/vdPlqANwtPzv50iNrp0oUAOAEFTiZZB3Vfj6Ft?=
 =?iso-8859-1?Q?5VXtKfrjF0QgNx/PFnKLYifqzajW/5WLY/ukT6CmI9ok6dZIJA/Svwgwv7?=
 =?iso-8859-1?Q?ff3iTFWEmCSpYbTg6VUpcMBafRocx/m1jwXsU5TdbGymlGJlJeTazu4mOB?=
 =?iso-8859-1?Q?xHpqLC9d81CrQrg4CTM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8731
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4729814c-0b46-4ace-62cf-08de552cc0fd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|35042699022|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Omk4+IOQrDXTOQh4gOYCcITvcmQlYlFyDXyFSzw0cSRgXMw6LvgsDON4/2?=
 =?iso-8859-1?Q?nDbwC5hBcrRIh4FHMFOsCmgR11kK8czYtV1gYl3br7OJJ5gFuCvRl2SGW1?=
 =?iso-8859-1?Q?rqdCe4fcOEL6yKt+3ixUq6gTNC0+cyk6h7rqsfWKOgxIYDLox2t9kBD1P9?=
 =?iso-8859-1?Q?VqkekMKSf5gv844Zo8BZFJT0SWujiQpZ3lPoG7ub9piUG8eteV0tDBExXN?=
 =?iso-8859-1?Q?7+6yvp0h1dAX1oWYYo+Uw0Xr4TjbU2rEFiJbNlSfHPgyObW5q6sWdONbi7?=
 =?iso-8859-1?Q?TN5T9nDm6/1CiKfLy7CPvWFDfwi47xSBeDtZaGarJeSbol6SzWtdZJesxY?=
 =?iso-8859-1?Q?LEXoG2siyJf2XNr9IWivm74rqUI29CvnLd6L83QKvWsgcxKR7HBkYTs+Jc?=
 =?iso-8859-1?Q?ZyxjTNegxjOlOHQOQNz5xLwh5GnwwJw2ebvQOYHgkRrfXPicq91a+yxX+J?=
 =?iso-8859-1?Q?UU4kA6abXY+duVxrriGJxOnpY8cVgvzUjkLmHQaweLUF7k9fW6Nq1iIyau?=
 =?iso-8859-1?Q?pYQsw4prPwdryRf3TfCJf1ccPjVEgwk2iMDrK16glJJ+hmooilAMR8HsW6?=
 =?iso-8859-1?Q?PGuHu/cj0iF8gZYUHA4ZNdBOw8UVqBbNsohsbggQc7xo++Rm/UftwrbHQF?=
 =?iso-8859-1?Q?0ojECaLpfdHwk5PT1NY7+kI5l55yBJYzT7x7g8iGqZviNPJp3AfKxlHNqo?=
 =?iso-8859-1?Q?75ZZ4lniSOI7q49hmxescr/K/iCshUqEK9Mk5dPMDEw6WtnJ4vnmqqHrL5?=
 =?iso-8859-1?Q?c3IFXm0I/tcwQZIjsfacEGMl/vRrn6tpqBtNU/oH4XBxLP77vaxCfFN5m8?=
 =?iso-8859-1?Q?kw9BtgJ8Lm0Hk2kPlPesjqHTbz5G5g6/iWiJNC7PyN4nTfmDSlUkcLKUbw?=
 =?iso-8859-1?Q?aXAQ/YWis2B1ww7BsmcQpTo/4epWDd6+EIkli1s+ySkmQCis5xIm8yLwqW?=
 =?iso-8859-1?Q?+PngRG3QeJcvXIHElvdvik2gf+JSfCOY8vdP05wgC2CY6f0xfCOedR6VSx?=
 =?iso-8859-1?Q?Hlj4uP1jiZqYf52dKM8G9tIlSEta7zsnIZq0FxSNJR6WDBhrAQC04J1/2q?=
 =?iso-8859-1?Q?toh8oPxMpGf16YDgBXt2MAZKrJeksKWrA0i0JbfvPJk/UboCv0jcpgNnOj?=
 =?iso-8859-1?Q?B18KCayrLVOAMSP/Cl/bQGOcG3ph8YXguVVys9p1KiZ+6em7BCmNVxAVOD?=
 =?iso-8859-1?Q?wcd0OkmQXkQMUJPMo+kgwkm6MrMpTmc3yzEuIm4khLMm0zhXGAq7eQYYZK?=
 =?iso-8859-1?Q?Yx8JE+UD2QkhXNj1XI0SlzcWutuHH9i7EIka6u3oGGvWsVJZXMbU7tOeg6?=
 =?iso-8859-1?Q?vHdWbydzjRnAoGmrflYsgLYb9k03H2LxziLB1amUEXS4fgwJuilywpUXRA?=
 =?iso-8859-1?Q?mCSi4f/H4CYCz4ssvU6zXOJzCzGeKqQyMFcp05ntY+TI92d1nan61m7yZl?=
 =?iso-8859-1?Q?y+em2jQ27nJtaKv4ju7TF1EjrhfcEXtmeoYBnjWfLgp5k13Iv2O1mNJSW5?=
 =?iso-8859-1?Q?/Ef/jXbjfVzm3O8mga+ZskK50isLnr1dd//QcZj3tUBI2MmxZFkCFQ0LvH?=
 =?iso-8859-1?Q?d5uPgXVB5udNQ1eVlPJVAPg03WOfR98P1WcHavGuhIM5cj8dU3MvuMpnCr?=
 =?iso-8859-1?Q?Iyi78V0t7iyapRTvctDE5/XpbIMCuY9uoLEAs/5baBQM3V+K3SBok/Y4Tk?=
 =?iso-8859-1?Q?d2MLl7q66QM95vKuZsib6031BYXgWhSy89gREEeKWouq+WfLiO6Pc4HpCw?=
 =?iso-8859-1?Q?HIsw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(35042699022)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:26.3185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d5737c-52da-4da3-9b07-08de552ce64f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11191

Track if the GIC is GICv5, and provide interface to check that. This
avoids having to rely on either struct kvm or passing irqchip
information throughout the code, thereby keeping things a tad cleaner
in the process.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c             | 9 +++++++++
 arm64/include/kvm/gic.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/arm64/gic.c b/arm64/gic.c
index 879f956e..725f0d52 100644
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
@@ -186,6 +192,9 @@ static int gic__create_device(struct kvm *kvm, enum irq=
chip_type type)
 		break;
 	case IRQCHIP_GICV5:
 		gic_device.type =3D KVM_DEV_TYPE_ARM_VGIC_V5;
+
+		/* Track that we have a GICv5 */
+		vgic_is_v5 =3D true;
 		break;
 	case IRQCHIP_AUTO:
 		return -ENODEV;
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index 630f0bbd..991aa912 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -34,6 +34,7 @@ enum irqchip_type {
=20
 struct kvm;
=20
+bool gic__is_v5(void);
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
--=20
2.34.1

