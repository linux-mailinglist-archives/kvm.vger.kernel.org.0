Return-Path: <kvm+bounces-59723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FD7BCA43A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 18:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD6FF1A60449
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 16:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82362459F7;
	Thu,  9 Oct 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B/KoVf5h";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B/KoVf5h"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013037.outbound.protection.outlook.com [52.101.83.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C5123D7CA;
	Thu,  9 Oct 2025 16:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760028935; cv=fail; b=VfDQhcjopYHXci/+pHaHJQnuw7uJ2Bp+Rue6rDo6JVc8LuccctOE24UHEmno6y8k9lJmOjpddFh/JjccfhJs45C2aIlNXeTSs3MdjIdyO789zDPS25Tr98WLHU2kqGNFzV0nPn6bsCrLtBDY/S3duRm4QQcFNg2OZyJHSM9ttno=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760028935; c=relaxed/simple;
	bh=Get2MfRVhVfai4Z27hv7M8Pxi+UQmjLIBgLn2ZKzgUc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IzEsf8bdYc36m8Zp6c8jlAs3hrzzSiKrvyCNro15VIQR/N6svwUqUucAWhwVOHtxLgyd3pDcp2l44CeFRKppdcxkGAg9tniFDd4J7/V1Ll1HA+LMO+V5jfJbgZhRqEY/4mQXyZt9Edobe2WJpY7twzmGZK7Y0VTbN0JuSHqNeIQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B/KoVf5h; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B/KoVf5h; arc=fail smtp.client-ip=52.101.83.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gpflpwN95Or50LvuRx0sYnWXcCji/5VOJW9ItYSxWln5PM+NYhO//Qi+rdCZL5mWNNgKpNzzNHWqh0JFc3HOo9lQH0Kc1gmvhSHgUf4fLl/ewoOgrjNiIJ2WOkD1jbyfBILILk7o1/gZclphV/Rjqmc4Nmw1D1ZWu5cRCd1OPbq0Bp5shxk7LLS+0oNWA8NKg/4x53CLMlvU8bmpkFCXibjqppfs2wxHVPkTSq55yJVSshI+XIuwZyIXhaYgJhEitV3g5O5J6pYlSXTue64BODt+vRWZGaTy7jK9l+OV+aGPVMW0jECPvyNOadx6ezjwzplfUrVH4nc9f3rVCFv2sA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=Jdl+y50ZXJlhgrzBrkaljOhLXYgFN9KlfsetsKelttOFX9nIA3GGW5RplnC+e92Zd8MkwrKBu++LmltonseMNW5VbFSg42SXFeuYOBpKnxbBocWpFP1pGdNZrHNhzAg5rYHardN8XjFn5Mzk7aHqskG0Qx7l2ck8XVZEfYIgi1hZE763HHIHIjmeR19OXF4bu/A6IEDzwwrYcDC+6FCzAG4qi62FhyQPm3gGKL57RD1X2aaAbgfAJtmCU10gtviFFD5MkVeEDq9QGfkjdPldd1B6Xjm2iDXDj3ujWyyYtZ0dDBjtBgLhqdf0RWvN6gaX49yuwZ4PMwfl6Q0LtnDoSw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=B/KoVf5hilzQKNU5whJG7VrXwaSEjKMIROyEqJ9f8+jGPrmY9UxpoDgyhU7vFCWHXAnzufiTRb9o2rG2GwwVvbDM5PMusWWDqNFHMZ/V/XpI+1hUckXmiN6bOYf0KWeq/bk2YkBtF1YMOXNunhtfojPm/A+6UTjndfYE/zV8Lqc=
Received: from DB8PR04CA0002.eurprd04.prod.outlook.com (2603:10a6:10:110::12)
 by DBBPR08MB10700.eurprd08.prod.outlook.com (2603:10a6:10:537::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 16:55:23 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::5) by DB8PR04CA0002.outlook.office365.com
 (2603:10a6:10:110::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Thu,
 9 Oct 2025 16:55:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Thu, 9 Oct 2025 16:55:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xe9ZBIwWItGf+gN30nUxSG4qcDXVNqXd+o+dIkehX6KGiOGq4768NxqcimzGcQfH8RmxLlxFd+uuNN3tIlKCRZ51tthQ+NeQk2/rCsut1xzmiJKXfyLySakz/p++663uWpak+3JqBP8ZOMZsej6sFS0gIRXZwNuj78DCwwlkdKMYj7ds3RYGNmaFcV+6MGOD9Pjl72J5QEUUQ8nVlD5nbdVFo40MzNc47c+zPt05+DfgmSO2D3lq8SEJ1A+yeh7C4D02Bedq5AM0MiC8Q2mEmD9/VmFTkuu6wDM66BVTQ4FSFYMRuQ9PgfJ8GWJOJNmHsR429ljGfCQXLQc0nhzgEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=yUeNSuYkKDrnWw6ZNJKLjWgfnX7nn2QripxVq7TNVDImnDA7uKNCt4x+hSCnbyxxS6ue8DHiBHgJoxEM5EECCHam18WaUjz9drzLRi0vxXhCsRL/p8BQTeMmDbaaDJ8RBhoA+vPtqsO9p6bXUmI4WZwJKH71n6rfwiAyt/tcT7+JWvdjcxpzHj5H0w+qR1kh1Bu6vWvtOvlFGcJVr2pApSAoTj9bspZotxtblzXmdCMi1ub3neiPSI4WXZPrO8csV2sprvhasDapnYpLYZLd0IlsDrQ93UxYBiYQ06K74RHXZUCjAzs7aXg7+kKFZNYYPg19WG5ldfCdJnGPfT5xHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6exw/zOqb98LmTg+WH0DT4Y8LBiOvpwhk9bM6sLWhc=;
 b=B/KoVf5hilzQKNU5whJG7VrXwaSEjKMIROyEqJ9f8+jGPrmY9UxpoDgyhU7vFCWHXAnzufiTRb9o2rG2GwwVvbDM5PMusWWDqNFHMZ/V/XpI+1hUckXmiN6bOYf0KWeq/bk2YkBtF1YMOXNunhtfojPm/A+6UTjndfYE/zV8Lqc=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB3PR08MB8795.eurprd08.prod.outlook.com (2603:10a6:10:432::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:54:49 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 16:54:49 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH v2 4/4] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH v2 4/4] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHcOT1sEJpQvf0ckk6LdJWV6xHdUA==
Date: Thu, 9 Oct 2025 16:54:48 +0000
Message-ID: <20251009165427.437379-5-sascha.bischoff@arm.com>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
In-Reply-To: <20251009165427.437379-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB3PR08MB8795:EE_|DB1PEPF000509F6:EE_|DBBPR08MB10700:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6f816f-8df2-43c4-f46f-08de0754a272
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?NckXZmqKvKxq+Iag6lXzDTN+cZWMz4AsgrnCSuOQ1gaEkQEQ5k0oe24Gg7?=
 =?iso-8859-1?Q?ojY6U5/0xnAlKa8AIXTCwIIoqGAIIfcgjmPuiSaoZtkPFkisKOEeUg9Z+Z?=
 =?iso-8859-1?Q?fzJLR21Ng+CQgQj6IvRrq4fIOi0Ux8vLFWTA31waI5A2odO9MBCt1tAjaW?=
 =?iso-8859-1?Q?lIhP2YzOjkfHonaQPuVS611xiflp3LkhGzEOB5/nyCNx4PhfkfIRbwUvfL?=
 =?iso-8859-1?Q?M7+jJUfTLml7I/GHeamzDdg7wXZ/bDaTJHMrHb7O//UnJzPKNLm9oneeyW?=
 =?iso-8859-1?Q?Z9X8LHZRHa4aUZtbdiHS3CarCGAickOCNqqMam/u/xvwFxfpQ+hE08jnLM?=
 =?iso-8859-1?Q?J6z76a/LwMBaaSGKmyoFRYvJzTEOMgSLbnrFg0FzQAxPYLN8ubPShN3S3r?=
 =?iso-8859-1?Q?I/M19pRRqFIqSPrRZ09JXWKWAMZN8vQYfqOEAotJj5HSxMM9EnxLuzMnzM?=
 =?iso-8859-1?Q?84YTkcrbMIJOU4jKaMe9+HWbMpaRklwsJNEXdQ4115hcktk49GhjqCoICE?=
 =?iso-8859-1?Q?42RxCvBxQd2Uo2ltu5Sgp1mllfg6Ezfg8qM85T4TvrHzvG37O04AAzuaqE?=
 =?iso-8859-1?Q?FfqDv2XDWdAhBYaata59iBHHS5ThbTYI+N738zkw9E7JEJOQB5eMhZ65OM?=
 =?iso-8859-1?Q?SHvw8MPXqTAzUmzUbc6ILHUEJdeLg28ztWUdKDfzZjS4EFWzdb9VQFoe5l?=
 =?iso-8859-1?Q?oNB9TVfhR+a+sT/y4zn1TupbhgJbr3eZ/3BITseosqBQyrykpEckUFIe1I?=
 =?iso-8859-1?Q?ZHleQ3cDL7+05n0nd8GPxo7TXxwuqTfZDGXGo3ncqkPxfLwiTQk4/p8BFf?=
 =?iso-8859-1?Q?aiUAwbS4z5uexp+749tAzvT5zcirOO26mhM96tKl4kqDHedRR6tKroc4uU?=
 =?iso-8859-1?Q?C+JR6Ztkm6vq9mDG3KAHVhpJKDouN+6rFUXVMQwVaS9VFlqD1UWKxWfvDN?=
 =?iso-8859-1?Q?ba0NF1+C/t7fcmqVb/lr7JKLqc5x02OvagwtTMdL7iLz2HChMZ4z6ToHwo?=
 =?iso-8859-1?Q?p92QS4D1q63mPJ2fKjBU3XvF2WBDf7l/TIm8GiTkA1TLMNtyTxSE+FCVjC?=
 =?iso-8859-1?Q?WO2odIe0Y9EKqAc22MCHewwDqaN51w0mA/l8odMqr1HEXtPoX2q803Hk17?=
 =?iso-8859-1?Q?ovwaD6Ou5ZVV0GCfNdBcLh2N2KJ4HBtEDydvKa7hEdKHWqUwVrG7aCEe3/?=
 =?iso-8859-1?Q?6Itq9rtX1RnOx3TxroZhFSTbEVNjLHU6i5qpl7Ftcb6Oc8b968p4TU1NQJ?=
 =?iso-8859-1?Q?6NPZPRZDuIC2BX+nKUu/BKObKdaJ7IUCD++6a9rpu+aJNwCFBuL3qsXEMS?=
 =?iso-8859-1?Q?ABZk4mDDJcq5msmXgrHxBkHaQ+r9Zu1TVRUMOlZRNV8JFITGHYEFVhE+ji?=
 =?iso-8859-1?Q?J/P9z6nPP922KdwXsJoR28bFJd9MvHwqT0CJCOPsXr+iusYurjpRAvQrBo?=
 =?iso-8859-1?Q?gYPRgFU3maE5haaDhY5sJPCFj4GP2AahEgRgq5rwTxK7EUto/YeEFLJouW?=
 =?iso-8859-1?Q?IzFWwdTsyGBRF80DVJZNbleT/2K/LySZniV3/dHl1gH0KdefI6e5r1u72m?=
 =?iso-8859-1?Q?S+qq4vQfaB0je+T6UP6A5hQ7sYqA?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8795
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	d54fc6d7-85b1-421d-546c-08de07548f0e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?iqzLjDmM/oP2lKUukB/NG0spRZKO74Ddg012xxzcglyQU6IT1mECmvHUjj?=
 =?iso-8859-1?Q?R7Del5bCwRRRI2UX8ur6UDieXsusMT1T0Z8INMHa/sSODO7yQ3eDJ/4R4+?=
 =?iso-8859-1?Q?1rmsV2Pc8MLYPpNo0tjH5/S2LSxaQjva6pXp3sSXMlQ43YpZBtRb3GqA8v?=
 =?iso-8859-1?Q?H4ypsAMAqTmiZgXvQb9a6uyEI+3kWNGaSOvH2XDugo7mR5Ey656sSn4Vw7?=
 =?iso-8859-1?Q?WA++yGOQqd70qyHMTJTuB/EqLZ7oMQWUdig9NldB0MFO1eqZF+OwNDWhDP?=
 =?iso-8859-1?Q?QIol3RnBjplXULdS9hxS8wrTUnEWab9A3UmxkCEbNkYPA+07DdKEVWjxCd?=
 =?iso-8859-1?Q?KDyCXiJ2uHYiF5ObkqJ4OMcL1B8BQuF8f8/jnD/AtE8u9yBoO6fRuSrbGc?=
 =?iso-8859-1?Q?1+m8YRJzJqxJZhfsEjbxn+w97+XS/MHfKQPDpVeGnLZbFq0iELdaKw/5EG?=
 =?iso-8859-1?Q?ho5u45mhoxUm4+VRlMBzQEeWT6zScomviAeUCfbAbb3TQx3BEcCs+FJIMN?=
 =?iso-8859-1?Q?7Btnqg82P/C6wNgsqaXz18xkj41maDVkh00JXpOfhgTdyc2kYZmeZRDuH0?=
 =?iso-8859-1?Q?kHOSbO4+z6XYJnFCgvoOkH5DWjmYoiN4Fp4pIXonCaGn0Zqur1G8XCGoHh?=
 =?iso-8859-1?Q?znbs9ScRePPAiLM9fwOMq5m8+yqL7EMmfj0BC02wFhQwwdsCyrqL16NVnm?=
 =?iso-8859-1?Q?dcEIFOpdwlzqKeyniDMvwbkZWl2uGnH4ZOsoRUOOqDhL9y+ka8qQNTsBYA?=
 =?iso-8859-1?Q?KoEmupJATpCn3eHv0I00AdbCJDOe2ed/v4+yO79xLgpaKIQ5E43+Ha37M7?=
 =?iso-8859-1?Q?jbich0z/4pwdIOxaJZAx/AYOUz/n2iEBQgoOm1SQ8tr0h88DlaRW4egfak?=
 =?iso-8859-1?Q?8BnQQj6cNo+Anw/Lrdf0bXafQwtHn7a51sk5JtHtrE/GvW1S8tqoJPVT6t?=
 =?iso-8859-1?Q?GJb5YYCq1luRTZyqsmjpt4x+yvTe/ihG+7SZXfTtEbL0ZgzGy2R5aP5mtu?=
 =?iso-8859-1?Q?NF/m4Ofmip3Z6AKrK+a+GY5eC17OS6gLOPBem9MumUuioDCGmQjPDu0pq8?=
 =?iso-8859-1?Q?RLqpe5OpqSoi+z+T6dHTI1vKP1E6qQchLGWv0/fYbIuGH9huXP02QdNrhI?=
 =?iso-8859-1?Q?awfSwYXZ2oMB0C1GJ8lITUl4UwlVBAagmv0DVVLE9ADREli9/k/xZ9fLSB?=
 =?iso-8859-1?Q?X7/QY+0fOYoSEV9fq+WhB9E8XVQYQOQXf/+O+Aqcbqep8VEzPJGunjTjUA?=
 =?iso-8859-1?Q?xCDUmvaNydzlM8OMnOou4wZ4VUTJfd7BViOq97Lp0zstCJDhW1Jqjpg8Y3?=
 =?iso-8859-1?Q?KZLxtZ8io6HCOo7QgsUc+bwZqumFeP2zIPUX1NFf1xpWNnWHQaAqm3VQoc?=
 =?iso-8859-1?Q?RX0d+kBvXLEqEdUcLGZuL4QjxFcQ7Eq3RoWBjr/V7seNEk6/UB7c8cnfp/?=
 =?iso-8859-1?Q?zr/t5TKrhd+WQOr95k9k4gKYUS4c83IDrBePTqob4AsURXau6WPiMWHJw9?=
 =?iso-8859-1?Q?fgRzOf68PwlGFTDR/qCMsTiFWDMuKqLd+wy3i6eTAmK00GNcOdqbWkrKEr?=
 =?iso-8859-1?Q?AB1QnzoVmF/iMERF90n9fs2bEoyswHMZX2zBbzbOcZjsOxQkPZvruNSMyw?=
 =?iso-8859-1?Q?lR0KEd9fzd1dA=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 16:55:21.6186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6f816f-8df2-43c4-f46f-08de0754a272
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10700

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 64 ++++++++++++----------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 42 +++++++++---------
 4 files changed, 51 insertions(+), 84 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 6604fd6f33f45..06bc0e628b03e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -571,7 +571,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -999,26 +998,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index d81275790e69b..c90608daa5b2b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -567,11 +567,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -644,19 +644,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -756,7 +756,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -804,7 +804,7 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr))
 		return;
=20
 	/* No deactivate to be performed on an LPI */
@@ -841,7 +841,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if (FIELD_GET(ICH_VMCR_EL2_VEOIM_MASK, vmcr) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -857,12 +857,12 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG0_MASK, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, !!FIELD_GET(ICH_VMCR_EL2_VENG1_MASK, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
@@ -870,9 +870,9 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG0_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG0_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -882,9 +882,9 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vc=
pu, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VENG1_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VENG1_MASK;
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -908,10 +908,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR0_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -921,17 +919,15 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR_MASK, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VBPR1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1021,19 +1017,15 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	vmcr &=3D ~ICH_VMCR_EL2_VPMR_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1056,9 +1048,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr) << ICC_CTLR_EL1_EOImode_SHIF=
T;
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1068,14 +1060,14 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VCBPR_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VCBPR_MASK;
=20
 	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
+		vmcr |=3D ICH_VMCR_EL2_VEOIM_MASK;
 	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+		vmcr &=3D ~ICH_VMCR_EL2_VEOIM_MASK;
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 7f1259b49c505..cf9c14e0edd48 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -199,16 +199,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b01..f9dd5b6c57294 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -199,25 +199,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -231,10 +229,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -244,13 +240,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

