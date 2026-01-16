Return-Path: <kvm+bounces-68378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2711DD38452
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:31:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D4899315CE93
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559AB3A0B26;
	Fri, 16 Jan 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oq6Hn/Xa";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Oq6Hn/Xa"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013010.outbound.protection.outlook.com [52.101.83.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D8F39C634
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588096; cv=fail; b=GQyE0gCfmbiShRG5wH+ZIrlybghOqHJEGi26M+KlUJW5WThWhypVYPWTmzwauYGh7kcdyBQg1qKR/jLp3m3uPF9QFdCTLzXMjFTGZJrvWI7KG59zLobSVAmjmV8itbLs4bSLmRA8rUFbPzYYglILVAngFeAm0zAqdzFCr1b562A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588096; c=relaxed/simple;
	bh=SdB1FFpBLosv3St6vlX+Z7iOpInZatCx0fu+djGBnkM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=biWTyscQn9LhE/M2Itqluft6DeFBa5FSW8t+WAdYUNhGw9cWmWHCbfKwyxp7Q5aD3ftAFKqHGSLT9oNBxzI40utVybWotxEKT1M4UAFxsAC0SAPurW+RslhBUWBsOtn9FjR66ohoLC/EkJAofPDKkdQofrEyZpSaxf9+6QaRVew=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oq6Hn/Xa; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Oq6Hn/Xa; arc=fail smtp.client-ip=52.101.83.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=p1gRcCVq2tn0c39NzvkV8ktf2yLiDHMAQ/PDjzGss5UUYiccpECD4GOZ1MrXr8FcO95j6dvi1Pn2y7WLvvXBwziCcsTkDsgWjCsJZpOf1s/bOeiPbdrvf6urTKm0alV4IM8wcgLIbHqs8RC+FHUR3thAOt/H3c4A4Z4JP5Ljp8q8oOEY1R0eXtW3VLHPYGiIbFBTvDgmK8tF+nHt/fdA/1BixY0PDTVFCRgSvH1IhX4GaGEujhzRP6Z5NIrquc0yrCbD0BGS6jc415gJ80QWuvd3UYRbJKWq2huC22mTORSyXIKd5wxUxVVBXe/iEnsx6wseEeEq1+XzTHEtWXpnsw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6Mg5l9nElRITsr3L8Owqx0ez3DmE0GWZEXYUwg+0g8=;
 b=stGUdI0xBnV+YQagfMIaBT5rQ8YT/o4C4kTUvcKuzdIiKUgf/dbmnNRRTe8FsIqheE7XI3yBSzkOk7yHFFJrKxkw1e+i92zToPoxipOR9BoCOmJhCnJrUd3QMYtBG2/Pno/M+kSuffvSj8AlksgYJoZh2BpRvj7IzovFQBlyj0rCztbgb53L1xRvYY4tOfF4MvPVB4VxJtrjhQxG3sPaXanAeZRVFOTpFIB3mpTuqI5d6cms8Ja/yIqEkyorvVplXUgkK+I/NXV38VCQ9fbvlY2QFp1f7ZaX6XVe48w32Syvp3XWCkLB5NcyW1KATTLuZL1UGVtLhalTA1Y0ZwdMhg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6Mg5l9nElRITsr3L8Owqx0ez3DmE0GWZEXYUwg+0g8=;
 b=Oq6Hn/XaFyiLikqbyHi99OglKqMROBe99h7Gd0wY/XppDyZSe8m2XfUdATYWyGREIsmjz+i8+ITG7xrZq170vbeTKQnBBcFIkaO9tICiFsQWLVPYfJBZ7aCkcu1Lw4uejt9y8J41pDN1jPEOZMQWeiWrCg8x3jlPY86K9T+y9dE=
Received: from CWLP265CA0288.GBRP265.PROD.OUTLOOK.COM (2603:10a6:401:5c::36)
 by DBBPR08MB6041.eurprd08.prod.outlook.com (2603:10a6:10:206::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:28:10 +0000
Received: from AM3PEPF0000A794.eurprd04.prod.outlook.com
 (2603:10a6:401:5c:cafe::ef) by CWLP265CA0288.outlook.office365.com
 (2603:10a6:401:5c::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:28:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A794.mail.protection.outlook.com (10.167.16.123) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Fri, 16 Jan 2026 18:28:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlRtRwyC52Nl7T0N7zELecC/zQBeI71jarvM9vzbX27KTMaMKO6JFnNF4abHP9R2swL1IwP8chLeyYYx1pgQUn56JJqMmLIwaOANNowGnLnwA0encPVW7QMn6R3Q54KlGadp3ESXam6DmryrM0CJA1+1GYWOYI4/nYLKpHX4P9hp/vCeI4ylS0/tdVHm4UZKRS54Lhx7vsWGKesHzsafVquy1Pdvx4918yDHsho+wfNj9J0iEM6TGlQeQmgMIedFWczcv9HfW0ys195wTRoE3/MvJRu/Y6jaH9HfHhl6wqOS3qAPdC7Lgj8vBSjiaOok1tSuem/HGXtgv5NJi6OI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6Mg5l9nElRITsr3L8Owqx0ez3DmE0GWZEXYUwg+0g8=;
 b=ODdprQow98k/ZpU5OTPNswZL1+lOPiSzgNbKdY3hYN4QcLdv6hROvwvc3kNyedJARwvNlPHJGmQFtDCiB8WB9Y2uBRWEZAKnf5iWPvXvxQiLYY1tiMjnHvpyVsOhz/ix0EEXR9Eax6IVRSmq3ee0SKXXuPwXFiqU0Yr1SfZNNe44taAdj41QjjRumScXIf8RGS/rF+3buzrw+K07/XY4UzS6GvBKkU33jNQwdjAuD242JwBuc1GWBJrORb1wr3qcugz9/akri6CIrJvg7AtrPYJj0c146I3hydQPQPLoRSjmwaKpokSAw0m+wl2Ign1QTCp5CzyX1q6tuBf1wK4Tsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6Mg5l9nElRITsr3L8Owqx0ez3DmE0GWZEXYUwg+0g8=;
 b=Oq6Hn/XaFyiLikqbyHi99OglKqMROBe99h7Gd0wY/XppDyZSe8m2XfUdATYWyGREIsmjz+i8+ITG7xrZq170vbeTKQnBBcFIkaO9tICiFsQWLVPYfJBZ7aCkcu1Lw4uejt9y8J41pDN1jPEOZMQWeiWrCg8x3jlPY86K9T+y9dE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:07 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:07 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 11/17] arm64: Add GICv5 IRS support
Thread-Topic: [PATCH kvmtool v2 11/17] arm64: Add GICv5 IRS support
Thread-Index: AQHchxW4CJqZt6qveUC1WknvpsidrA==
Date: Fri, 16 Jan 2026 18:27:07 +0000
Message-ID: <20260116182606.61856-12-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|AM3PEPF0000A794:EE_|DBBPR08MB6041:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ccdcf15-b15d-4625-94db-08de552d0014
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?RuDkLm2n/47ed0dDHQHw80tC45UDyXYi5dT8LUKHhuoH02lLxjSN/kmhnw?=
 =?iso-8859-1?Q?Tz6cAL9hGIm6CI/WH+5ZQyRujZiE4T6QzgvJxfYkiya3e+54E3Em2kQ25E?=
 =?iso-8859-1?Q?GJt1rmdzkHsrOpxl2QHoxT7IlgoXSe/2VB20jtTnZOyt7ryzYD6pxA7boy?=
 =?iso-8859-1?Q?DVwGCXckK0LDIz0IIWqIC5Aq7dNyILpvZ9euYR0vTzqKZaEbeV1XrnzL4O?=
 =?iso-8859-1?Q?uVXN6b/fhwVSTSnXMexymjeAu0B3vN6zREIjzpJzYDnN8VEEmvaHoG72kc?=
 =?iso-8859-1?Q?VYeBxaObjlaRU72OnpriX1RpnC0cpMJsd3XKkSk0Kc3tsp8UkRTo4oVBXq?=
 =?iso-8859-1?Q?MC5xoBb/CnJ3s4lx/GUaUMehNIEFjDwDLFma3DdhAjBMA1Q7JPBAjBJeZI?=
 =?iso-8859-1?Q?WQMpiZOGvXbXCMnger8U6EvT7cRr3aeUQQ1rTozirSc5X4vCYdqj/Z4DDG?=
 =?iso-8859-1?Q?lUcsH+Z9vZ1ErNc32k8evy+EbM5DYDKfLofULh9VDIpDFOn0sVP0s9ZNfz?=
 =?iso-8859-1?Q?FGlIXNM4IFco5zSJEpp+v3XroSWgZZ+YaPukgdCQxIZ5OeLeL9RRLm1V12?=
 =?iso-8859-1?Q?Mmz+ktS9tNbc+hNLB72FOD1sPd9UWXZQCxFs9omQa3ophAiTx984xALlUc?=
 =?iso-8859-1?Q?8hiSwbBj2VkK5F6Q1Br02Vpg/twrfvLl2zuj+zGJ6E3RAHXnB0gLMoen5o?=
 =?iso-8859-1?Q?fVVgJf7fsuJ7YuIqrAmPoayjNOwZrESAWbls74YFwToBhElzuZA1wNkxKj?=
 =?iso-8859-1?Q?d089mCHdlKD3OHaGfecXoRcGZevUIg4lefoCa44WV24bVqLdvmIrIr8TRt?=
 =?iso-8859-1?Q?uDr0F9jCZd1uSuvA2Vhl8DQ8pGXDMNYnWtXwMHPYC+qStaG1NOkLXyJW66?=
 =?iso-8859-1?Q?ztS3r+0KmVVUW67/FU1Wl+HiNM07/dJ9YPLZj8ZGz6if0UFhHt5zkb43Ye?=
 =?iso-8859-1?Q?GgWkuJ9oX0Y56zOo5c+Fi3uVYWp6fbrqgEMgS5eu4dhwsI1w9jKwYxh6Lk?=
 =?iso-8859-1?Q?5J110/coGl+jpk9jqVfHNSFKICoAMbNVGKl7aa0vVzkO0/CaBXLJ35IPg9?=
 =?iso-8859-1?Q?lRQ1S0YhlcoB5BU9t5PBzpAxeEqi9Kqli7nJ60D+FhHdkHj2dRzsbU1+g5?=
 =?iso-8859-1?Q?1EqGBpLj0a9STG6uZJuVdhC0ksZMhbeTzOaXNL2Gbr4HOQgv8EL74PP9y4?=
 =?iso-8859-1?Q?E8Z7CEamVUCxNUNnaqbq1FdV6bID0/UHhszyR1NZFg/aoKPzuBIt+o+Vlc?=
 =?iso-8859-1?Q?2h/z4JgOAV+KM7kSQd4skN9G34ZEXF3//LPBDk+SKaAeITDwVCAtxQUAJH?=
 =?iso-8859-1?Q?BjIeLLRibA8/NKZc4z1637G2cRbhJmADVl6mHTCWVCOgq3R9X/dj/NH4cu?=
 =?iso-8859-1?Q?/uxCBH254cUIw2y04ZjJZbMeYMEUS+hpUwsHkS1JsL9NV234rHV3m/fOJE?=
 =?iso-8859-1?Q?v3H7vjslOlFP9Of5NqIkDXB+zsm+9lNqX3NjJjdy0RA+K9s4uQuI9Rubf0?=
 =?iso-8859-1?Q?grI3DWlz5k3CLClcESbfnhyQH7YaeKNIiA+EU3Da4jTVqO933T1/ukUfzD?=
 =?iso-8859-1?Q?n1ebD/xk9zo/gzi4EklDKXALvEWCSDskHp5xn/+O3CIG/aIEYY6AcIPF4Q?=
 =?iso-8859-1?Q?SLiOvpqpKMgODZH6E7xeezyKlvlTFmsPWlr1nlNTgAxgVGQi6gOpPrwDM5?=
 =?iso-8859-1?Q?A57UYnEzTzyZxSEnsBc=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	40991323-44ac-4626-72e4-08de552cdb0a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?DulZsQD1nDtBYHDjcRoqCyp0dro1j0TdLxfV1uLvWI9WI4YRCc7Abhtb/h?=
 =?iso-8859-1?Q?kOiclXyykkunqy6VhpZM0DjDf9qH9CWDzsav8OhBkpotzIPxb4yzr718Hh?=
 =?iso-8859-1?Q?kYDxfI/VfbANtctAHwjbKxnaF9CiOcEbYMrzIY+pStLcRDh7O30TA32FHX?=
 =?iso-8859-1?Q?A7r5FoQl6GkDxLH3uItzPzKny4z1riQEXIGDTC/Tfr24pXO5O5rqOsvtfd?=
 =?iso-8859-1?Q?GLHlcpVNoCQvfNh7G/TQ618t6gDWXrsMaWw2urUavTUP/IHFIitM6FD7Fi?=
 =?iso-8859-1?Q?7DfCTtnGBOrLinny8KVGCI18ySrB7CDWruP4ytl9BI4JdCWJRBYxmPMWvJ?=
 =?iso-8859-1?Q?b6Km0DuX6PlKTJlHDeFPzWf9FglndNA2ET9X2r0WTmAn7J2fNvFkmVKsVt?=
 =?iso-8859-1?Q?VeioFK3mxU5D6zFuOx7CUdoX+ZGT/buZKnBPo1K24VgS+mNSG9sucAE7fm?=
 =?iso-8859-1?Q?8glvS6gg90iwdSexcbE7LH+MhZO4z6ZpzRK0/RfHTiChWI2jdmKXoPI+3D?=
 =?iso-8859-1?Q?WpnbWs9HSZ8HUZftUMHhSfZ2uSjAKWGXvZv27RHqOF1Fz94AB3Ea2tKdSM?=
 =?iso-8859-1?Q?vMzLhoXQ+v7kqtwsFxUxuqQYQDPC+uCK79fYzTM1yvK/Im3jXu039piYgC?=
 =?iso-8859-1?Q?E/4WVBCQ0r3XAIiHkyuF2J0sCD4x+5Q2qJCco/dqSFlocZ89H0fA6mjYQK?=
 =?iso-8859-1?Q?IlpTK6kEchOmsTZ9ptgHXNGS0gpsepaVDOl54UJFJqUbIXGEFe1AYyu+z4?=
 =?iso-8859-1?Q?YhLvO14AzormIEOWKGz5Hl3XYAT0pYJvrNRH1VWcomY2I37U0qHayOpmsq?=
 =?iso-8859-1?Q?jJL0sGBQFsc6KoQVwDhe/xQ1cLhs5AY9UZJcRuJ6C3SUf/GYmdhnAO3wZC?=
 =?iso-8859-1?Q?Z4dpsMUgTwsyJGUoT7JcPwxFsH1+1eAB/kuFnWkqvhewldC6uiK1z3hEni?=
 =?iso-8859-1?Q?qZPbBxCjc85PkTze2EthnvzQuaCma5c/8S3kSeMt6KpseZ4HSL5n8rnrg/?=
 =?iso-8859-1?Q?aP/fI8YGxoqKTK3Cs97UVNqbivESZy8LjsU9hpTQkJ95Id48hFLX1Ig9ay?=
 =?iso-8859-1?Q?YioXDztOWyOeUNo6wmEpmwoPTYlzOn6U1PcBWIMtManiFeBbzqoalkcN4o?=
 =?iso-8859-1?Q?PjL8CxbEbEqxSHAtFCYbZI4+LqXgfx1dEdUPb5hjBAynFL4FaBoY1eO2/o?=
 =?iso-8859-1?Q?8h6fo3K3EtoEVuaQo474at2AKOgX06wCXly5d+2JDu5jVhoGYRe7wsV9K5?=
 =?iso-8859-1?Q?z5WAMtSEduOhWWXwsnAZN95GkjqhYIGYGy/TWJ273nx1ozHg8HddORDMkQ?=
 =?iso-8859-1?Q?SI6+2JheqmhBurgxMdkTVwNfJxcnQR7sgqXRTQR8v68rIFIXjCqI6gSL7u?=
 =?iso-8859-1?Q?tElQlQI9oFsxNaUsPeocBT97IV4zW1S5ac63GbRmyZ0Y1RkTaF0mgTzEXH?=
 =?iso-8859-1?Q?dl+DhFODibfuTM6nxZevty6STyGK7jnKdMShkJ35zdEprrb9MFwY0lBP+g?=
 =?iso-8859-1?Q?5HdGfWCaeBc3be2xTAOJHAGsgBI223J3SsOt302E8YbgemJAgTVREZnq6K?=
 =?iso-8859-1?Q?OVgosasAD99zDglWDfZvpkj5iLoWxqQmMX2dGxrhqpvUenRo7YJA2apFIc?=
 =?iso-8859-1?Q?WN3762JIUTms6IoD/s3w04HtwLonDvI7VMkbxzumvgTd9ubPDme45DC6bM?=
 =?iso-8859-1?Q?G0nPNpLQ+sWXVM56juaDMpiqJyy/Cmhn7oSu8GQt7fD0csSmIox5fw5z8j?=
 =?iso-8859-1?Q?Hh1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:09.5587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccdcf15-b15d-4625-94db-08de552d0014
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A794.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6041

Set the address of the IRS for the basic `gicv5` config, which is
required to correctly initialise the GIC once the KVM IRS support has
been introduced.

This change enables SPIs and LPIs to be used with a GICv5
guest. MSIs are not supported with this configuration.

Note: the FDT changes to add the IRS node to the FDT are in a
subsequent change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c                  | 20 ++++++++++++++++++--
 arm64/include/kvm/kvm-arch.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index e88a6c33..e75fd6c2 100644
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
@@ -216,6 +223,7 @@ static int gic__create_device(struct kvm *kvm, enum irq=
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
 	u32 maint_irq =3D GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
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

