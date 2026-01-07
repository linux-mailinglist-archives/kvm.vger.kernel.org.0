Return-Path: <kvm+bounces-67205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8F5CFCA9F
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 09:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C51F309BCA4
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 08:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E6DD2C1590;
	Wed,  7 Jan 2026 08:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UQH9Hm6n";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UQH9Hm6n"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013061.outbound.protection.outlook.com [40.107.159.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47070287505
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 08:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.61
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767775247; cv=fail; b=dYD7/rhlZxg0RYycNOqRn5/giwxF9uS8Fzyk1Zw2Rb/OBA2uAA38uGPQ7XP46Zs6aci4SuwiFCgbw4UjqPg1QHkZBSi/Tev3gvSbom0PUGSto2MmSwXWzun17MzeJGUkWtXmh85358RnhbeaZA5W9ol5NlSwreIdGjpOSo2h8KQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767775247; c=relaxed/simple;
	bh=uIvFCOIP4glv3ZBdNvHfkKzRzugG700QLrLuXS4SagY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D4CyZ31qQILq5olby4jGroWNzCNojyr41oT31OeRI95wnsioNk3IkzH1ymn5/xl3nPbIWke/r53Mf+s2l5A4tU3L+4IYQwB+VZMFrzFy25TOZ/wDO+RS+c+bu9lJa1gbxkRU0hQLplOumFtmKRsUy0BfQ5NsLSSaZAuA5XxJNPU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UQH9Hm6n; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UQH9Hm6n; arc=fail smtp.client-ip=40.107.159.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h5Nv1dd0bbr0i21HQal5rUzz4gcxwfqGnseRvpEeSDnPY8he19mSyO2M0YzKM/tI1OsX4RYoWyhyy6SlJHCkBKpZKGtAPUWOHZ2nVbQeMRagM2EwHB5QuHYrj/+1cWYvrkOixlmXMGVIKxyWLLHpqT1J74pPcvimFNnAwn9lItlHMW/SfjD5eRwfLeXpf7X0lC25ByWTAwdIB8A/bTUoMG7FJubQ5eNXj6KqEU5EtBdLrBHvJe2WaI2uMuNSDVY8m1InqRBnMr5jVkkZV5TMwL5fcMSdRa+USAAsUii0MN62Ka7u8EeD+vJd+RYwclmldA94BdNYw4BzEXxszfEt5Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIvFCOIP4glv3ZBdNvHfkKzRzugG700QLrLuXS4SagY=;
 b=ob96Rn6RDYnAU6zZREdZJFZ4lgEsd+aTy83GYx3dWr2L/0DeXN/JxaIoo6ip0squ2tbaprLkogouftQCKdwxhKKX3VtjmJKk2s3su+wqJ6BMY8D3UQJ2om1Boqc+eS5kV18dlhsKISNni12dyWYfa89iJBCP5nFzV6bPiVJEzSumVSddJunmr67Gh+oD9qmgMCXmE1cq2w2431FJIIOaAwWmagJO/3qxROyDUlkuu0q7ztPHikix7+JJIpGr58x271NhuIuhyCiei1pmX3MnuWsns6PYe0JvlwjKJwA1SY03yG9oCRINvh5u5TNPXFVXTpgznp0SLaid/h1xQ/GI9Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIvFCOIP4glv3ZBdNvHfkKzRzugG700QLrLuXS4SagY=;
 b=UQH9Hm6nRpapa3oklBDaUQrA+Mf4oxAwvS1uFLKbEz86Btt297Kb14lLZdanX54Sb7tjccZViPcJOV2Ge+YnEfBemXGExY6WT9VyZnVHMkUOpfrxMQ1yZwe2gNf2rDKhZ2XZDGEgT5P8t++FdaUhKrcZqEol28bDKzwB+DMcglM=
Received: from DUZPR01CA0332.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::18) by DU0PR08MB9418.eurprd08.prod.outlook.com
 (2603:10a6:10:421::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 08:40:39 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::b0) by DUZPR01CA0332.outlook.office365.com
 (2603:10a6:10:4b8::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.2 via Frontend Transport; Wed, 7
 Jan 2026 08:40:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1
 via Frontend Transport; Wed, 7 Jan 2026 08:40:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w9dafdt2etEWD6hg7kkqzq5gUJ0P5JZ4FgC02jFkxIA/0MuTTKFV3S2+uAzF7mcVSXRXCQ/jtqyUOW4jNqOQQtiqYn7QK0GSGTwqF48CANMZNTmWI9mLZGaPEKLm9H4vZKD8X2YNIjJmMQ36ZYcAmHO0yqO5CoYE4j84VhOJvlq6QrotlyjofmQ919aLME43mQjUjl55ZM+HDzwMeDkEqhg1BQqME1YPNkXNK+UsSRxZYylv3jOD/5d+mkPyTPyzPJqD6+ngQLXYubMbdvOLYyahWVUw3jen7LJXuythkp7KG+HBo237TUvmCRahT4euURAWZQC9OXrXIBoZaHAu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIvFCOIP4glv3ZBdNvHfkKzRzugG700QLrLuXS4SagY=;
 b=D6wx56f1mnXDBMLTSGeUVcwelhTZwSVA9IRQtxaSvYZmJyKB/ZocjO1bxRoDGKYvKcGHUPLKdBzxY2+Xld11D47DS2NDvgj92zpsiIjFlQK54h4BlU5nEWS3hlk72tt1Je1MIU7aPgStesPkxuFxI271bdGpSERk0Bz2pQFplQlrdHssMdRkcAgnqvR5w11EQqg6+IwznMgWcLH0cdB4G7tXJ9anKoj0/83RF71d+kTVWvbEPyHpQeMhZOGutU9W/qNTbhR4lYOcsJRaPUnypgmWzmmtZWW0bITQ2/QUhtfxWFv0Ebh0kIIf5Q8WreMQOj5hAU4cMmyzzo/xOSaFWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIvFCOIP4glv3ZBdNvHfkKzRzugG700QLrLuXS4SagY=;
 b=UQH9Hm6nRpapa3oklBDaUQrA+Mf4oxAwvS1uFLKbEz86Btt297Kb14lLZdanX54Sb7tjccZViPcJOV2Ge+YnEfBemXGExY6WT9VyZnVHMkUOpfrxMQ1yZwe2gNf2rDKhZ2XZDGEgT5P8t++FdaUhKrcZqEol28bDKzwB+DMcglM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAWPR08MB10976.eurprd08.prod.outlook.com (2603:10a6:102:46f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 08:39:35 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 08:39:34 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v2 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHccP9/MNS4WvXxjkysb2bgAp6h37VFjOYAgADzZoA=
Date: Wed, 7 Jan 2026 08:39:34 +0000
Message-ID: <00e020516825d6a86f41ff4a5d99b0a401a62910.camel@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	 <20251219155222.1383109-6-sascha.bischoff@arm.com>
	 <20260106180824.00005516@huawei.com>
In-Reply-To: <20260106180824.00005516@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAWPR08MB10976:EE_|DU2PEPF00028D06:EE_|DU0PR08MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: 475b5046-bf51-4439-4a83-08de4dc86f32
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Zk5IV3ZaSUtRU3lzVWlVSGx0ZWFKdW9STmRIdXJPMmo5cHR1Y3FYeUlZdDdL?=
 =?utf-8?B?bktEMjRna21ZVEpWVW1oaEVnUnZSSGlIT3JYaHlBMHRrRDJLSmF6MXNOYkJB?=
 =?utf-8?B?TFJRdnk5RG82c3RIQklYaDJwWmdRRHpXVU9aYzVZSWVpWWJDQ2p5VXZNQXVk?=
 =?utf-8?B?bkplU2ZQcDBvbGhNSTc3SnhPdFRxeVkxQ0Z5ZUZjQ1hTM01Bd2h6THE2aDFi?=
 =?utf-8?B?eDg0cVBmTkM1UzI3alhrVjdJOFdvV0ZVdUJjT1VzWW9GMWd5dDEvRUNiOUZu?=
 =?utf-8?B?RjBWcjVXNU95MjhKZHZFaFBLR0hnQXoxOEtUTDhEeDJKdUZ4YWsraWJYeXRR?=
 =?utf-8?B?Q0RIcC9LSW42bzVkanZOYzRjVUZVVkRBWmx6bEorVnQxRVdOVDBieUt2UFhN?=
 =?utf-8?B?SFNxSHB0c01ValJlQWVWT2FOaVliQVl2aWJibHEyMVk4SkRRRkEwUk1oNEo2?=
 =?utf-8?B?MFJFMnBLckh0aXA4eXBrdDB3UHBlTVZ4ZW9aOWZhMVBJN1ZrVDlYdy9oNmZo?=
 =?utf-8?B?bi83NXBvc0xVK1VBQTgwT0diOGxFMlhJWVYwRURZcldNQVBXL0s1cjRGc1ll?=
 =?utf-8?B?SXQ2elFleDlndk5xc2FtNmZPNWVVeHhTQkpyVFc1eFByUzVpdTJtU2tBUVM2?=
 =?utf-8?B?ZFBNQU1CaWtNaE5SekVtRlBoQ0haUDA3WkYwOFgyTTBpMWRiTEI0K0lSc09n?=
 =?utf-8?B?cXpPMDZhUUZ6VElTZW5NY1l3MExPK3BQUmZTQnRwbkhPSUo1QTJDNjI3dzQy?=
 =?utf-8?B?dlpndjIwd1JyMkVTY0w3aVBGM2VWZ3ozajhNVjhHQU9vWmg5WTNPeURkMHFq?=
 =?utf-8?B?blV4OUZ1a0lHTFgwdDNBMDNWaStOOFZpd0crTzJwRXZQTlpsRktxYUhzbkJR?=
 =?utf-8?B?Y3RMeUNUeExxTTM2OENOMVp6N3RQYS9WMlM1YTlWN092UXNDMGN5NHVGcCtt?=
 =?utf-8?B?M0NMbHp6Q09XTTVJdWxyRUx6UEo5cEFqaGFCM3ZTbmg2UXZqNkhBYzhlOHBL?=
 =?utf-8?B?SFJ0bm8wTklLRDgzWXZXKzloTURVUlFVWjJBVmJRTGEwWHo4bVc0ZFlDOUZF?=
 =?utf-8?B?enB1UnV3YmIvZm1sNGZCWjU4dCtYRkZnLzBzMWZqS0dlZktVTzZWUjYzeVVJ?=
 =?utf-8?B?S1FuMFJhWTdJV2RNbkpsK1NPSFo5T1FuTVpONmpDM0d0c05tL3UvY1pqUHVU?=
 =?utf-8?B?MU5aR1RtY01nYVN5MHJEN05IYWNka29RMkJyVUtrTW5HU2tibDc1NWxnTGkr?=
 =?utf-8?B?OVNKTEFhQ0pjWlFTcmVXQlVSeXR5TVpLNzZZNXJaZ3dud3NjU2RvTTgvM3BT?=
 =?utf-8?B?c3pxMGMzeXh5RnFQNEZ1K0xHQ0g4NEYrWUI3cnV3SDhvMkZtTHd2T3FZbVU4?=
 =?utf-8?B?cFdSV2luY0ZJVmZ5UnlXZjE5MVF2b3NaaS9NWVVzeEZvem9OanNHSUpRQXJI?=
 =?utf-8?B?NUhiWU9hWWI4VEQzZDhpY0ZCQ2lJenZvN0J2QUU3MVFveTh3eE1Gc0hPSUE2?=
 =?utf-8?B?eGFCWWIyamk5clZsbGhFM3FWeXpoTFhicUs5Z2RGZC93TTExSlQ3WTQ0b3I5?=
 =?utf-8?B?a3B2S052QnJ1RUVTc1EvL2QzYU02bkxaYnU3NmJRSUVPdWc3M09EWDhBOFFU?=
 =?utf-8?B?bTZ6bHdOTTBnSlZoc2EyWHBhNDBjdlRGT0hVU0t2ZjlkMnhjSFBFVnlzQnZU?=
 =?utf-8?B?TzZ3SWEvZkZtcTdnQjVwbTloMVQwQ09OeWw3d2lzV2dHTGNWRXlYbnBCalZW?=
 =?utf-8?B?eTQwNEVXcm1qTjY1NllRSzB0TlhMZEdqME1HUjliUStLSHZPRVErZlpBSEVh?=
 =?utf-8?B?THp3UU9uanFHQi9TS2hxWEVhMFJadU1sUkQ4Z2k1cmlva3k5VmhhUE9IbTlI?=
 =?utf-8?B?Ymp6aGErbS9jRFhtUUxkMjBYdGpQWFAzeG1HSHZ3SnZmdTBldDB6cStsajhZ?=
 =?utf-8?B?bm9QZ080ZGxZR1lFUXVjNUNkMFVJYmpSaVR0RkFoUWRQQWR5MmdsbFU1SVBo?=
 =?utf-8?B?TkRYNVZxcmdPSitjUzRqZXFqNUV6U1BqNHo4K3FHS2h5Nzd5UG42RERRSnUz?=
 =?utf-8?Q?bc2rzS?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <D13C6824DC3C21458A0D0EABB3237854@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10976
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c00cfe24-ab01-446b-a2bd-08de4dc84922
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|376014|1800799024|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHcxTVVnZ1JMU09YUUtRWHhNUzBMN1c1bUh4U2VQRmdDZUVvUEtRSTRYc3pR?=
 =?utf-8?B?US9icWNUdnQvYnBaT3E5UGZFQ2NLaEtSTlVsSUxTV0FzZm1BWEdDZDhlMS80?=
 =?utf-8?B?SDJjazE1bUpUQlZ2WjNZdDl3QkhMcHUwWE8xbXNsdENLSFBQZW5kdCtpN2Qx?=
 =?utf-8?B?SWJtTDE2czR2dUNDTDJ4c25GTFBza0l3Sk44VEZZTURGSXRIRUE2dEg5Z0to?=
 =?utf-8?B?K1c2RkJ4N3BzRmpKTUh0a2NYWmNLbjk1ZkNISVhWd1VxdjdVUElmbDhkZTNq?=
 =?utf-8?B?TS8zMkhhZUxIVkpoVFpsSFovSVJ0MWNzajVMUng1V2puWjlBbDFTMWdrRTVw?=
 =?utf-8?B?RjVnU29YRTQva0lxZWlRQW5hazEwSUE4QjJrY3RyVzcwUHJoZWp6ZVVnSzRu?=
 =?utf-8?B?SVdiVWhOTXgxTmtPckhiWUYzQXpocFVVb3VGL2VWSjlDOXpvc2VmV2g4SFhF?=
 =?utf-8?B?K1BPVS96RUpHYU8zV3BQaW04aWRjTTBUbFUybVpLZ3VIdFNneFEzSjdpekNl?=
 =?utf-8?B?OWtydWlORDhhbzk5ajdVV1JXd1hFK2JmQlZ0LzdHTTRscnh6TVhKMlVobUZs?=
 =?utf-8?B?djA0K3BCcjA4dTk3VmJ1cnZBV1Q2aTVsUjJxaDl0SFdjaDQ3blEzekYrdTBk?=
 =?utf-8?B?cFZvT3NQb3NiaUpGaW5KalB5cjhwbHkvbEp5Q1pkWkpiWFVteGZ5ZDNzNVhV?=
 =?utf-8?B?cnJIeTBhZHI0d2d0MjlYRjI2a3NaZCtHR3psNWxMY2daREhWZUh0WURzUFNa?=
 =?utf-8?B?UFRLbkltcHpQVmFYRm90aTVQZ2hWNjIxL29Lekk1bnlBamdzZXNrMXB2bDdn?=
 =?utf-8?B?K091VlEyN1dVZlBYQ2txTHdHSHJQQ2J0akVLTUljSm9kM2J4VzlRQW9FcmN3?=
 =?utf-8?B?WVNteUExd3I2cCtqbkxYVitVaGxiMGtDS09XNmUvVXQ3ejQ5ZE1iVVNlTnZC?=
 =?utf-8?B?VnZMeDJtVGU1NlJqOFhtZ2lTTUU4UGk1eUEzd1kvd1pjZWpSb3J4UEhOQXU3?=
 =?utf-8?B?WWtiQm9FbWNxM3V3Wkc5WnFNWkN1Q0N2MTd4V0J3Rzd3L1lUVWV0OXZzaldz?=
 =?utf-8?B?a00wOXNpY2VhZDJ4T1ozVzYzaWY4WW1IM2QydWFtZEdpRjdMZkxUMXJwQ214?=
 =?utf-8?B?N1paeGpvQXpkK2tDeDQ0Vy90TjJoL1JTSFhrM0VrOWJLcTRJbllkRWw5UTN6?=
 =?utf-8?B?R1EyVk5PR0JNZWNDcTlBcGR2SHZlb0UrdUZXc3VDbURURFE5VDAyUVdpKzN2?=
 =?utf-8?B?dGw5QnMzcUxjY2V6b0h5R3JkWTVqM2hIK3pYRi9vS2M0ZXVWZGd4T0ZSZW9U?=
 =?utf-8?B?M1I0Tytqc2NobEVFTFRNaG1ZaXZ2RjdaR2ZTNkUzMVcxOXFRamlwcG8vRDYz?=
 =?utf-8?B?ZVNEYWdiOXVybldJYnVjYmozbitxN05tYkdBRFFFSkJETVVmYUh2YVBUL3FG?=
 =?utf-8?B?dnExSzZRZHo2RThjK2FhWWw0YVR1UDFqREpqb1NEM1FqUEhBbWhwelBtVG1x?=
 =?utf-8?B?bUVpaDNoTE9qaHVCREVwWW1ZOTBkSGNUbzNHa0xNQkY4SmRNanBaWkZZQ1pw?=
 =?utf-8?B?N2dldExZaUgwY1Y4dm9nMUNMVGJnOUVNcVFLS2dzYVMvajhlWmp3R3h6MDhx?=
 =?utf-8?B?WTU2Q0NudVh4K2s0V3VuRHZqTHNYVGhQd1Vhbi9qOGErZmtQZ0VnMW5tVHZs?=
 =?utf-8?B?eWZpNkRBUGtpTVBmMUVMdFJROVBBK2VFR1RlVzBDWkRrWnVrdkc4anI3a2Ur?=
 =?utf-8?B?RysrM2Z2RkUzRTVXTjBNK0VaZDhPRG5qbkl6dFZ1YWdRaWxNYmZOYzY4eDha?=
 =?utf-8?B?MmZYS1lpejVsQ3plYm92emMwM0xscjArb0RoK2ZMUHlYNjM0Y0RsYVo2MUdB?=
 =?utf-8?B?bUNCM1NlR2JEWmxsNWlzcUJxZ3Mwam83WG1aL201eGFBZ1d4aDFSd1BveVJm?=
 =?utf-8?B?enBPZEtyNVN5OXBsQ1F4RGxNdDREK2ZaazZVT1dHN3pFYUo4OGhoL0xPNGRP?=
 =?utf-8?B?TDhTcGVmTlU4dXU5azl3VkxVZkNkY1lwd1BDVWRWdW1hRVFiWEdhRVR5Lzhp?=
 =?utf-8?B?V0ZpT1FNeTdGbEpQRUY0SnNUMjFoeUxzZmtBZFdPQTBwcGFjeTU1b0tBcGs0?=
 =?utf-8?Q?hoiw=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(376014)(1800799024)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 08:40:38.6476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 475b5046-bf51-4439-4a83-08de4dc86f32
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9418

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjA4ICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDE5IERlYyAyMDI1IDE1OjUyOjM3ICswMDAwDQo+IFNhc2NoYSBCaXNjaG9m
ZiA8U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiANCj4gPiBUaGUgZW5jb2Rpbmcg
Zm9yIHRoZSBHSUNSIENETk1JQSBzeXN0ZW0gaW5zdHJ1Y3Rpb24gaXMgdGh1cyBmYXINCj4gPiB1
bnVzZWQNCj4gPiAoYW5kIHNoYWxsIHJlbWFpbiB1bnVzZWQgZm9yIHRoZSB0aW1lIGJlaW5nKS4g
SG93ZXZlciwgaW4gb3JkZXIgdG8NCj4gPiBwbHVtYiB0aGUgRkdUcyBpbnRvIEtWTSBjb3JyZWN0
bHksIEtWTSBuZWVkcyB0byBiZSBtYWRlIGF3YXJlIG9mDQo+ID4gdGhlDQo+ID4gZW5jb2Rpbmcg
b2YgdGhpcyBzeXN0ZW0gaW5zdHJ1Y3Rpb24uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2Fz
Y2hhIEJpc2Nob2ZmIDxzYXNjaGEuYmlzY2hvZmZAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFy
Y2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmggfCA3ICsrKysrKysNCj4gPiDCoDEgZmlsZSBj
aGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiA+IGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNy
ZWcuaA0KPiA+IGluZGV4IGIzYjhiOGNkN2JmMWUuLmU5OWFjYjZkYmQ1ZDggMTAwNjQ0DQo+ID4g
LS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaA0KPiA+ICsrKyBiL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vc3lzcmVnLmgNCj4gPiBAQCAtMTA1OSw2ICsxMDU5LDcgQEANCj4gPiDC
oCNkZWZpbmUgR0lDVjVfT1BfR0lDX0NEUFJJCQlzeXNfaW5zbigxLCAwLCAxMiwgMSwgMikNCj4g
PiDCoCNkZWZpbmUgR0lDVjVfT1BfR0lDX0NEUkNGRwkJc3lzX2luc24oMSwgMCwgMTIsIDEsIDUp
DQo+ID4gwqAjZGVmaW5lIEdJQ1Y1X09QX0dJQ1JfQ0RJQQkJc3lzX2luc24oMSwgMCwgMTIsIDMs
IDApDQo+ID4gKyNkZWZpbmUgR0lDVjVfT1BfR0lDUl9DRE5NSUEJCXN5c19pbnNuKDEsIDAsIDEy
LCAzLCAxKQ0KPiA+IMKgDQo+ID4gwqAvKiBEZWZpbml0aW9ucyBmb3IgR0lDIENEQUZGICovDQo+
ID4gwqAjZGVmaW5lIEdJQ1Y1X0dJQ19DREFGRl9JQUZGSURfTUFTSwlHRU5NQVNLX1VMTCg0Nywg
MzIpDQo+ID4gQEAgLTExMDUsNiArMTEwNiwxMiBAQA0KPiA+IMKgI2RlZmluZSBHSUNWNV9HSUNf
Q0RJQV9UWVBFX01BU0sJR0VOTUFTS19VTEwoMzEsIDI5KQ0KPiA+IMKgI2RlZmluZSBHSUNWNV9H
SUNfQ0RJQV9JRF9NQVNLCQlHRU5NQVNLX1VMTCgyMywgMCkNCj4gPiDCoA0KPiA+ICsvKiBEZWZp
bml0aW9ucyBmb3IgR0lDUiBDRE5NSUEgKi8NCj4gPiArI2RlZmluZSBHSUNWNV9HSUNfQ0ROTUlB
X1ZBTElEX01BU0sJQklUX1VMTCgzMikNCj4gPiArI2RlZmluZQ0KPiA+IEdJQ1Y1X0dJQ1JfQ0RO
TUlBX1ZBTElEKHIpCUZJRUxEX0dFVChHSUNWNV9HSUNfQ0ROTUlBX1ZBTElEX01BU0ssIHIpDQo+
IA0KPiBXaHkgdGhlIFIgZm9yIGp1c3QgdGhpcyBvbmU/DQo+IA0KPiBUaGVyZSBpcyBwcmVjZWRl
bmNlIHdpdGggR0lDVjVfR0lDUl9DRElBX1ZBTElEKCkgYnV0IEkndmUgbm8gaWRlYQ0KPiB3aHkg
dGhhdCBvbmUgZ290IHRoZSBSIChhbmQgbm90IHRoZSBmaWVsZCBkZWZpbml0aW9ucyBuZXh0IHRv
IGl0KQ0KPiBlaXRoZXIhDQo+IA0KPiBMb3JlbnpvLCBndWVzc2luZyB0aGF0IHdhcyBpbiB5b3Vy
IG1haW4gZ2ljdjUgc2VyaWVzPw0KPiANCj4gR2l2ZW4gaXQncyBHSUNSIENESUEgKGFuZCBoZXJl
IEdJQ1IgQ0ROTUlBKSBpbiB0aGUgc3BlYywgSSB0aGluaw0KPiBhbGwgdGhlIGRlZmluaXRpb25z
IHNob3VsZCBoYXZlIHRoZSBSIGJ1dCBtYXliZSBJJ20gbWlzc2luZw0KPiBzb21ldGhpbmcuDQo+
IA0KPiBKb25hdGhhbg0KDQpIaSBKb25hdGhhbiwNCg0KSGFwcHkgbmV3IHllYXIhDQoNClRoYW5r
cyBmb3Igc3BvdHRpbmcgdGhpcy4gSSdtIGluY2xpbmVkIHRvIGFncmVlIHdpdGggeW91IC0gYWxs
IG9mIHRoZQ0KR0lDUiBDRChOTSlJQSBkZWZpbml0aW9ucyBzaG91bGQgcmVhbGx5IGhhdmUgdGhl
IFIgcHJlc2VudC4gSSdsbCBhZGQgaXQNCnRvIHRoZSBDRE5NSUEgZGVmcy4NCg0KTG9yZW56bywg
YXNzdW1pbmcgdGhhdCB5b3UgYWdyZWUsIGhvdyB3b3VsZCB5b3UgbGlrZSB0byBoYW5kbGUgQ0RJ
QT8gSQ0KY2FuIGFkZCB0aGUgUiB0byB0aGUgQ0RJQSBkZWZpbml0aW9ucyBhcyBwYXJ0IG9mIHRo
aXMgY2hhbmdlIChvbmx5DQpHSUNWNV9HSUNSX0NESUFfVkFMSUQoKSBpcyB1c2VkIHNvIHRoZXJl
IGFyZSBubyBjaGFuZ2VzIHRvIG90aGVyDQpmaWxlcyksIG9yIG9uZSBvZiB1cyBjYW4gcG9zdCBh
IHNlcGFyYXRlIGNsZWFuIHVwIGZvciB0aGF0LiBMZXQgbWUga25vdw0KeW91ciBwcmVmZXJlbmNl
Lg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gDQo+ID4gKyNkZWZpbmUgR0lDVjVfR0lDX0NE
Tk1JQV9UWVBFX01BU0sJR0VOTUFTS19VTEwoMzEsIDI5KQ0KPiA+ICsjZGVmaW5lIEdJQ1Y1X0dJ
Q19DRE5NSUFfSURfTUFTSwlHRU5NQVNLX1VMTCgyMywgMCkNCj4gPiArDQo+ID4gwqAjZGVmaW5l
DQo+ID4gZ2ljcl9pbnNuKGluc24pCQkJcmVhZF9zeXNyZWdfcyhHSUNWNV9PUF9HSUNSXyMjaW5z
bikNCj4gPiDCoCNkZWZpbmUgZ2ljX2luc24odiwgaW5zbikJCXdyaXRlX3N5c3JlZ19zKHYsDQo+
ID4gR0lDVjVfT1BfR0lDXyMjaW5zbikNCj4gPiDCoA0KPiANCg0K

