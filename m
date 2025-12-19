Return-Path: <kvm+bounces-66353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D3DCD0A6A
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88BB530E121D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047A5361DDC;
	Fri, 19 Dec 2025 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q2au8u/D";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q2au8u/D"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013002.outbound.protection.outlook.com [52.101.83.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE1361DD1
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.2
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159631; cv=fail; b=G67ogVTwnVTemkEgL9mkX388ex7u/BWanAlXjPVpVehg1owwEJQ5FJsqHhV2xr8VSeCpC0p2r+16SfZyNOF0TbAfXuyQY6ZLlEroVnuPO1buvF+ULCMXgQICms8cTbr8YYh3JqEPpDH0gLhkQDdKj+JO4tRmvtVjN80P/8pxiwo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159631; c=relaxed/simple;
	bh=D1pFBLs/ElkiVK6TYVV8f8nikJHeZCjeX5otPk5pS3E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eIr+vPDxk4j5twBunkrTbRlRlC+MByG+jolmn/1mpd6pX2me6Y+aqa0Xhz6/XgBjSs+7sVbcRYWF62J8IRySrqBYIXbAIn3Mk2GFTU/IWgXh6IfAYxP9On6kPnTE2O3kb9pZHWUW2b8/eNX4xkOML9BziGRKmUPbZLN2Alr0XPw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q2au8u/D; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q2au8u/D; arc=fail smtp.client-ip=52.101.83.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=G74Ob69s4iM8vIhWMmFkNhcqxz6MjR3dz0AXbXUCJl9lT2KVGYSp5yAE1B6wtaYh+KtVIUYnXbMbTF5ze9AZGgfVCb/oFouaYlCejMC22BBnJixZFMxyx8a0W/ZIPKK+hyoEJGu6gOuJKuQhISsf9KijZB6SCxAU8dV2waAyo0pF18mLkWvrp7UR1NgVFmsil3iEPiFUiOna8YlZK1Ezt6pni4szLnMIFu+fCCCiOZEHP9ACKz1zRMuRQR1ZSJubfrRm/byqrTWzfy1tywj5mPhqH2vEGy64GQ3WhqFDkSlGK9LVSVxgCcCWKf8co2zz6Z6j5/lR60nzWBdtefxtlA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeSuLKfxH+Jq7n0SHa7Jx+HDj2ZGG8A8QFQWYefr9zU=;
 b=uUAsTlAMye+c7Cg3LpcL6x7jpH3X2HYaSz2zn4/fsC1J9NpRBfMI6GPnEnz8dr63cvkb8Tu+dsqyCKbIGbyiHyYZJVPDxF2ORVuRhw72wpyKoJJJJN1iWy8KlP3cX2d1PZQJctg7T38UT5sMr+jcqpXTgxnfoaa7LkhyIPJRcfTAABTGWlpmitHkrtO+mzbBz6wwFiltrO3YZxuxUfWjfW2uZ+Dy9+pXLxDY//3xffP5n5BO7uEXmccIadXjqJu1dCNzeCAZiiOzpTAi069vkTakLoVT2yhCh8IS5ywaRuvEixn/+M8tKaMGr+RFyFgr7VnvPcH74cRoceUQD7D0mg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeSuLKfxH+Jq7n0SHa7Jx+HDj2ZGG8A8QFQWYefr9zU=;
 b=q2au8u/DFxOV4/Di2LTNRMp5XJWRtUm4WnJvjbgVaHqnQuj7mrDOHE75KPdpESWa5iXyaNjClWOK/f2O/4+IgKuTEJ1vEb9xsmvmdxmcxoeehvSlATxR53eo80djl16aD7TI9COmZUwfvUREbFbQ5i4qCWacKunkSxUwWlrIe5s=
Received: from AM0PR02CA0146.eurprd02.prod.outlook.com (2603:10a6:20b:28d::13)
 by DU2PR08MB10201.eurprd08.prod.outlook.com (2603:10a6:10:496::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:42 +0000
Received: from AM4PEPF00027A68.eurprd04.prod.outlook.com
 (2603:10a6:20b:28d:cafe::cb) by AM0PR02CA0146.outlook.office365.com
 (2603:10a6:20b:28d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.12 via Frontend Transport; Fri,
 19 Dec 2025 15:53:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A68.mail.protection.outlook.com (10.167.16.85) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b712NnK+IQYbFE6FnZkZ7fAESRFdUJXHUDSFAu14gHEFRbpIFbIXJhrm86eUHUinekxkTPVrV1UGPc1LUfCtuxaweJJM4oPRh3UecrZi1+izC/IKlLP/LZVd9MH0HSFmbnvHUpou86WEJprJIUkOZ97V1Zwj1e5lX2S4qibEZASkYoBxRP0m3wFvVu83JcjOTiPPE2zOFxnTSMabLSoAPalcpu+WdhluSEtllLnFGXmzWK9XbUGZfJYTzWeKw2Y487Mh2mxH0Yp0Pv8D42PRwK2UeMozWT+NVSHYvawfFW86VHqanxZEEt6csKT69RifOgeRVRPjcC5d0Yrwpmam9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeSuLKfxH+Jq7n0SHa7Jx+HDj2ZGG8A8QFQWYefr9zU=;
 b=Db1VIPIwo4eFNv1MLAFIqjDNOlncqw/oYSZwpSU/PLaq/JEXLGrwbsbxQxXEXOHoAAIa+yW45w+30+9XrejmwWz91ky1/w1mmTZ+JAV7VN7T9rphKRA7XEL1Mgx1ht/jkjQozqIF+mT36x8KJd0866B8DhnxhCjhtfeoLoc6u89L0xlI/srbSxpNDZP0K04ncPoFT7VgmdoEIdU1WyxteNfMl52/2bmrb0BPB3DLDRWm8gWbCoahnQQWsd3qiK19GzYHHka/wUTeG8IHPQ77OztHiv4aCUJswFhmdiEZL59TGirXHVt6G9gJMTJBP4mHRvoxK+z/EWKlmTP+BlkbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeSuLKfxH+Jq7n0SHa7Jx+HDj2ZGG8A8QFQWYefr9zU=;
 b=q2au8u/DFxOV4/Di2LTNRMp5XJWRtUm4WnJvjbgVaHqnQuj7mrDOHE75KPdpESWa5iXyaNjClWOK/f2O/4+IgKuTEJ1vEb9xsmvmdxmcxoeehvSlATxR53eo80djl16aD7TI9COmZUwfvUREbFbQ5i4qCWacKunkSxUwWlrIe5s=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AM8PR08MB6546.eurprd08.prod.outlook.com (2603:10a6:20b:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 15:52:39 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:39 +0000
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
Subject: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH v2 07/36] KVM: arm64: gic: Introduce interrupt type
 helpers
Thread-Index: AQHccP+Amw5F4YQtr0Wu9c2UcjY0fg==
Date: Fri, 19 Dec 2025 15:52:38 +0000
Message-ID: <20251219155222.1383109-8-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|AM8PR08MB6546:EE_|AM4PEPF00027A68:EE_|DU2PR08MB10201:EE_
X-MS-Office365-Filtering-Correlation-Id: bf63021a-8bcb-42d8-90a5-08de3f16c86e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?uq5jhiJacBpbSCLuT+OAPIS3VZ7yne8+0ChQ4muRy1IQU4hxRnx4bVuA9Q?=
 =?iso-8859-1?Q?vE9CYPxdXpMVijkpduf9uDUIeNYIF6KTS0DLqZ1+c7o/Sww7q/WKrvlErN?=
 =?iso-8859-1?Q?efkXuiJibh0dPmm7ZZb1U9cAZypAGJCc9sbg2W90465jB9K/dO3mnw1gjf?=
 =?iso-8859-1?Q?j39nqbaiPIVqJSmkCYJmWILv/PfEjHDJFPa7EOY0QPS9lIwB2hWlplfsnf?=
 =?iso-8859-1?Q?q4jYUdLkfiPw6Dys2OHjnNVD/4ChvJIr0sUnRQWU8nAbkUwkrvnPOkwk0Y?=
 =?iso-8859-1?Q?oIdRYsL7G1TG8s8509vsTVjIcNw/ALKmBOYEz77q5Dg3wxJ/YQSYQxfi26?=
 =?iso-8859-1?Q?WMkzRLZGSGGxHPMd4yO5u31i4jqMjQ7e9vqxDb3uJnlA0u0mS1phEoBG8S?=
 =?iso-8859-1?Q?Smrppg9QZAQREUts/4CpZcZB+pldj/qFWTnhBVTLja67OrJpIka6LTX5y2?=
 =?iso-8859-1?Q?e6WZ+ZhTG9kd++3EUSp6DTRMB7Y8HiPzNzme8aRZwD9I6lSh7yID9yBQrr?=
 =?iso-8859-1?Q?hr5uSlfnmQH3wdNV4tem1yL4Fj73xMJVpRf8+Owc+/89vGnhf7dICHWVE7?=
 =?iso-8859-1?Q?n0x+bM5OVR1s+fWKIswpqCL6WHYFdbUdDBHE2GHKc9EkRY26nmLMGCEarW?=
 =?iso-8859-1?Q?6EJqh7zQjHsmnTflr+3z9JhPpD+FrKA+x+3GZHmj+aIeghjSPNA6KhvDgy?=
 =?iso-8859-1?Q?i4tbWxx6Mwpu4xNbJ8Y8uL86zPO0jnkrGQ8/6nOt+BciMZzl7lLYM+ydo8?=
 =?iso-8859-1?Q?kh6+i2c39QJotzd/TJBC7peLt+bbqiwgY/exi+gaxYOW1L696ydCLvmdit?=
 =?iso-8859-1?Q?Zde9FIml7Sh9SMCLh+IJjuBWiaEBCKHqoxqhq58pDBUUCJgyrrFXDhqTPj?=
 =?iso-8859-1?Q?Kz98Zw+ndjxs9NV0qdXuMLDf8k+icdgdavLNkc5XRnRLUK3xwZBufN6LyD?=
 =?iso-8859-1?Q?hzFika4mhDPRRRYtCXmYIxnR+wWd2xVh7KZfhDSLHIav2Fwty0oAgApEz0?=
 =?iso-8859-1?Q?d2IiCDJG1p7dOZW+iaikf+xuNrqGAphGXfB62EpFmOJrQzP065oiWimd5p?=
 =?iso-8859-1?Q?+cGzBKgxVEY99MQwn+SUykCtdSrjlSHinWWVrsmGmSZof3Q1XMPzZ92PRN?=
 =?iso-8859-1?Q?SyotcckNbZtLbL+4mE6dG0CEqt35TULIipEdQZEum/rTGZaVB6A7IVV2jb?=
 =?iso-8859-1?Q?2XqQZWQrEF5bdcXA7kPyGu86NItnpaCn6yTueehZxlXe4V+L98jdYTz2nm?=
 =?iso-8859-1?Q?AT0Kp4zrDcbXUQ/8EpHoP6v0nrhxSgGZNBEZM+P/c2W5EWEglRLbGxdzGc?=
 =?iso-8859-1?Q?c57kwj4MV4z4Ezt1ES8cKVdhe8UQxavTN3vq4bQ3URvU0G0TW1IpwNv1of?=
 =?iso-8859-1?Q?nx6fN9GVtrL3hCSeLRoO1CSloACa0o3RAlfymsoVawQTFdgihAPNaxvIHS?=
 =?iso-8859-1?Q?TVMp/aBCkL9nuQy3S0eIYiPI1evG8B2kSdkmwbOXw+pbG8NJZWZMJAcozh?=
 =?iso-8859-1?Q?AHE381JJOhl/ZK1Kx1bet/5PVKbh+B8Q+Rw0j1wmdnRL70fUB0n1vrgiZZ?=
 =?iso-8859-1?Q?VraynDKMga4s6k6NKvAgxE6eDJu5?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6546
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0fadd42c-44bc-465d-85c4-08de3f16a349
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|82310400026|36860700013|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?xpk8TifNFDXm394F9FLVD7Ziuv5KLGXXQWzgJ4z+iofcV0HQugLleKw0hF?=
 =?iso-8859-1?Q?dQwSdh4ZA5+RPi3BSi0raL2iKEaIe6WoWm5ACy9q1HomZkAU4PjIcSZppv?=
 =?iso-8859-1?Q?loYnoLE7VtyxAyZKXHhgcXXqn8PPjEbYvGbonAYx/KI4UBREiJNgvSzeIU?=
 =?iso-8859-1?Q?ZqsbhqIxce7CjgbB/lg9/P7HcPHhvHJhYfkW19ILm8eyKzmR1juFsRI63V?=
 =?iso-8859-1?Q?fZtuRg5jJAcc6PyVzdBOlhQuMtBT4M2hYoJ9RALWyTApK+qWcOtkD0BdYI?=
 =?iso-8859-1?Q?J3jSNgCdDXvmgw0TqcbCU9usvpZRro7ZnuBFJ9+Ew0A/6NDUwzTKcTGu/S?=
 =?iso-8859-1?Q?aI6jXQT6QThyWIhEevpWk5JU3NpHgc+qs5yZwaVdZ1iiTHbdFDkdLmtnBR?=
 =?iso-8859-1?Q?b3cZKoWWRSc1WFBYYXdpvlqfsc7vuhFJsViLDQM4Z7AT6m+D0yTSmkpgc+?=
 =?iso-8859-1?Q?gNx7W9YGVRQUgb0r7Gy0xPWbDkuGdqOPX4466ToBHel9YsHYSi8tgCvk//?=
 =?iso-8859-1?Q?XNJwu3Tu8wDQXs9nBgOvsWXWkRiMqjFwK4w/PP0k/FzFcb2JfwRjgWOL4m?=
 =?iso-8859-1?Q?sxYEvXtCVbcDvnyBFaRBKaOu+jQMiWEaKWL5zEuTAw9b1qA35D+okk3lVG?=
 =?iso-8859-1?Q?ubVGd3WWhdaPAVCdZ8nRakZCkZdeECpkS9OG9Egoj3hutC8omSutR8tkdP?=
 =?iso-8859-1?Q?bJ/WoNUJIBuVDgIZKNMqVDWq//iYW1xOeLDNNqjIGUi4XazR1CM6xrIaWQ?=
 =?iso-8859-1?Q?c5iwllXvMEkhPmkIWOoh7RpV2PLhyGJB/+T17uQ5ov4Gfwo5nsqS4QFMQV?=
 =?iso-8859-1?Q?yUOyzYzUYJijM1hI9Q0ZaGduWrtFbQlPGQi3MOCJFFizzz6vB5UOUyDcKO?=
 =?iso-8859-1?Q?xJR0ibV7ZkfPe+gVNEUtOnPhswF6HixCRTyxNqcAOBKCGgKVRa1+j2eokS?=
 =?iso-8859-1?Q?YFE5IGM2D4n1FYAurhLs9LlvAJ8xuAd1/ZINEjTz9lKPPkqozFlurgLqx3?=
 =?iso-8859-1?Q?70SRJ+xF+7uyBeA/xsisYOCnRi1dmB82XJNlzUQ6dB5070JmIAyuG+6Z4q?=
 =?iso-8859-1?Q?DBw6AcUJAzohxhI2hUEWqc/SReUY8kqXAa07o0nIrWyjUTAxa8zU3RdsGL?=
 =?iso-8859-1?Q?01EozbCwWHXG802CxD7sZQ+vo6siWgaNNf3TIxoVmMuhaCZxMupCdJKSTb?=
 =?iso-8859-1?Q?Zo7BQIW+ciehXxwdzCiNFOdIzEXvjW3XseV8gr28OvGFA6RAoHFUtA73Gf?=
 =?iso-8859-1?Q?Mh97j9gBAsJS8nRu2l3MOXbu6igrF5Vjazx4qI6utw7c4dUW/gkIKJfDwM?=
 =?iso-8859-1?Q?t7GcJV3DSuMOeoFtGJ9SJrD4dG9uw/CQAFxPvJS8xhBGg5v7x0mjrwRhFc?=
 =?iso-8859-1?Q?1uLg/yPgBSLDmo0L7ZGqg354AbvaAhhLpywfbIxCK5NGDEwxSLZZgVXtl1?=
 =?iso-8859-1?Q?BjxTg6kbcrqXK89PQS8xgYM4TrTXc6tfUxRnD6KjCKFw3F9U7hxeuo5G5A?=
 =?iso-8859-1?Q?AOEHjyA416C6gK0d2KLinlRl367eIr0xe4s34BQNUwuiq0+8oybvZiDfGQ?=
 =?iso-8859-1?Q?43IC6nAOjJFFk2MIim6FJpFFbsUW2PzriRmsWXM9cblE6dwyK4Aa9lyyBO?=
 =?iso-8859-1?Q?JMZTPpccScp4U=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(82310400026)(36860700013)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:41.6724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf63021a-8bcb-42d8-90a5-08de3f16c86e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A68.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10201

GICv5 has moved from using interrupt ranges for different interrupt
types to using some of the upper bits of the interrupt ID to denote
the interrupt type. This is not compatible with older GICs (which rely
on ranges of interrupts to determine the type), and hence a set of
helpers is introduced. These helpers take a struct kvm*, and use the
vgic model to determine how to interpret the interrupt ID.

Helpers are introduced for PPIs, SPIs, and LPIs. Additionally, a
helper is introduced to determine if an interrupt is private - SGIs
and PPIs for older GICs, and PPIs only for GICv5.

The helpers are plumbed into the core vgic code, as well as the Arch
Timer and PMU code.

There should be no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arch_timer.c           |  2 +-
 arch/arm64/kvm/pmu-emul.c             |  7 ++-
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  2 +-
 arch/arm64/kvm/vgic/vgic.c            | 14 ++---
 include/kvm/arm_vgic.h                | 82 +++++++++++++++++++++++++--
 5 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 99a07972068d1..6f033f6644219 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1598,7 +1598,7 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	if (get_user(irq, uaddr))
 		return -EFAULT;
=20
-	if (!(irq_is_ppi(irq)))
+	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
 	mutex_lock(&vcpu->kvm->arch.config_lock);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index b03dbda7f1ab9..afc838ea2503e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,7 +939,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		 * number against the dimensions of the vgic and make sure
 		 * it's valid.
 		 */
-		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+		if (!irq_is_ppi(vcpu->kvm, irq) &&
+		    !vgic_valid_spi(vcpu->kvm, irq))
 			return -EINVAL;
 	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
 		   return -EINVAL;
@@ -991,7 +992,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
=20
-		if (irq_is_ppi(irq)) {
+		if (irq_is_ppi(vcpu->kvm, irq)) {
 			if (vcpu->arch.pmu.irq_num !=3D irq)
 				return false;
 		} else {
@@ -1142,7 +1143,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, st=
ruct kvm_device_attr *attr)
 			return -EFAULT;
=20
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
+		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
 			return -EINVAL;
=20
 		if (!pmu_irq_is_valid(kvm, irq))
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index 3d1a776b716d7..b12ba99a423e5 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -639,7 +639,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		if (vgic_initialized(dev->kvm))
 			return -EBUSY;
=20
-		if (!irq_is_ppi(val))
+		if (!irq_is_ppi(dev->kvm, val))
 			return -EINVAL;
=20
 		dev->kvm->arch.vgic.mi_intid =3D val;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 430aa98888fda..2c0e8803342e2 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -94,7 +94,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 	}
=20
 	/* LPIs */
-	if (intid >=3D VGIC_MIN_LPI)
+	if (irq_is_lpi(kvm, intid))
 		return vgic_get_lpi(kvm, intid);
=20
 	return NULL;
@@ -123,7 +123,7 @@ static void vgic_release_lpi_locked(struct vgic_dist *d=
ist, struct vgic_irq *irq
=20
 static __must_check bool __vgic_put_irq(struct kvm *kvm, struct vgic_irq *=
irq)
 {
-	if (irq->intid < VGIC_MIN_LPI)
+	if (!irq_is_lpi(kvm, irq->intid))
 		return false;
=20
 	return refcount_dec_and_test(&irq->refcount);
@@ -148,7 +148,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq=
)
 	 * Acquire/release it early on lockdep kernels to make locking issues
 	 * in rare release paths a bit more obvious.
 	 */
-	if (IS_ENABLED(CONFIG_LOCKDEP) && irq->intid >=3D VGIC_MIN_LPI) {
+	if (IS_ENABLED(CONFIG_LOCKDEP) && irq_is_lpi(kvm, irq->intid)) {
 		guard(spinlock_irqsave)(&dist->lpi_xa.xa_lock);
 	}
=20
@@ -186,7 +186,7 @@ void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu)
 	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
=20
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
-		if (irq->intid >=3D VGIC_MIN_LPI) {
+		if (irq_is_lpi(vcpu->kvm, irq->intid)) {
 			raw_spin_lock(&irq->irq_lock);
 			list_del(&irq->ap_list);
 			irq->vcpu =3D NULL;
@@ -521,12 +521,12 @@ int kvm_vgic_inject_irq(struct kvm *kvm, struct kvm_v=
cpu *vcpu,
 	if (ret)
 		return ret;
=20
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu && irq_is_private(kvm, intid))
 		return -EINVAL;
=20
 	trace_vgic_update_irq_pending(vcpu ? vcpu->vcpu_idx : 0, intid, level);
=20
-	if (intid < VGIC_NR_PRIVATE_IRQS)
+	if (irq_is_private(kvm, intid))
 		irq =3D vgic_get_vcpu_irq(vcpu, intid);
 	else
 		irq =3D vgic_get_irq(kvm, intid);
@@ -685,7 +685,7 @@ int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned =
int intid, void *owner)
 		return -EAGAIN;
=20
 	/* SGIs and LPIs cannot be wired up to any device */
-	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+	if (!irq_is_ppi(vcpu->kvm, intid) && !vgic_valid_spi(vcpu->kvm, intid))
 		return -EINVAL;
=20
 	irq =3D vgic_get_vcpu_irq(vcpu, intid);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b261fb3968d03..6778f676eaf08 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
=20
 #include <linux/irqchip/arm-gic-v4.h>
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #define VGIC_V3_MAX_CPUS	512
 #define VGIC_V2_MAX_CPUS	8
@@ -31,9 +32,78 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
-#define irq_is_ppi(irq) ((irq) >=3D VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVAT=
E_IRQS)
-#define irq_is_spi(irq) ((irq) >=3D VGIC_NR_PRIVATE_IRQS && \
-			 (irq) <=3D VGIC_MAX_SPI)
+#define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
+
+#define __irq_is_sgi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D false;					\
+			break;						\
+		default:						\
+			__ret  =3D (i) < VGIC_NR_SGIS;			\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_ppi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_PPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D VGIC_NR_SGIS;			\
+			__ret &=3D (i) < VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_spi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_SPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) <=3D VGIC_MAX_SPI;			\
+			__ret &=3D (i) >=3D VGIC_NR_PRIVATE_IRQS;		\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define __irq_is_lpi(t, i)						\
+	({								\
+		bool __ret;						\
+									\
+		switch (t) {						\
+		case KVM_DEV_TYPE_ARM_VGIC_V5:				\
+			__ret =3D is_v5_type(GICV5_HWIRQ_TYPE_LPI, (i));	\
+			break;						\
+		default:						\
+			__ret  =3D (i) >=3D 8192;				\
+		}							\
+									\
+		__ret;							\
+	})
+
+#define irq_is_sgi(k, i) __irq_is_sgi((k)->arch.vgic.vgic_model, i)
+#define irq_is_ppi(k, i) __irq_is_ppi((k)->arch.vgic.vgic_model, i)
+#define irq_is_spi(k, i) __irq_is_spi((k)->arch.vgic.vgic_model, i)
+#define irq_is_lpi(k, i) __irq_is_lpi((k)->arch.vgic.vgic_model, i)
+
+#define irq_is_private(k, i) (irq_is_ppi(k, i) || irq_is_sgi(k, i))
+
+#define vgic_is_v5(k) ((k)->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_V=
GIC_V5)
=20
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -418,8 +488,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
=20
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	((k)->arch.vgic.initialized)
-#define vgic_valid_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
+#define vgic_valid_nv5_spi(k, i)	(((i) >=3D VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+#define vgic_valid_v5_spi(k, i)	(irq_is_spi(k, i) && \
+				 (FIELD_GET(GICV5_HWIRQ_ID, i) < (k)->arch.vgic.nr_spis))
+#define vgic_valid_spi(k, i) (vgic_is_v5(k) ?				\
+			      vgic_valid_v5_spi(k, i) : vgic_valid_nv5_spi(k, i))
=20
 bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
--=20
2.34.1

