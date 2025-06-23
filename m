Return-Path: <kvm+bounces-50346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90098AE41EB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54B11746FB
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F7B251792;
	Mon, 23 Jun 2025 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eYHSRIny";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eYHSRIny"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013046.outbound.protection.outlook.com [40.107.159.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976B623F295;
	Mon, 23 Jun 2025 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.46
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684351; cv=fail; b=cSwuSQL0wRiwfWMG5INIuMXOuWTpZqwFQoXdQaHoF+Bxbb7YIlQoChq0PzF7Hpx6obUQmu1Rfmwaq8YH8dS9xWVw1VUOe2eWCKnkcC5xf2Abt0253KjLfV9XYYsgdm9JfsZExGMGSXr0KJD3y/GVcJuNGF2RWyQmQU1hNdUUkRY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684351; c=relaxed/simple;
	bh=VSDBtN4g99QHTM501GZPCHfWLvib6gHl+mAVnjc55eU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E9Q93K5d+korxGkkr2+71/TlBzB6zQXX4u/lstIXKJGZpqmL/oRZCGjtK2sadO3qWgH+kqQKrip3cPNQP0o1ATBluJZXNu6N758P1CGqsg37ryVzQzieWfr8v7BXTuM92vfUA4QIBJ86rMYSQUO4ZjqRiR6bJyVoBrzXI0ZcECw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eYHSRIny; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eYHSRIny; arc=fail smtp.client-ip=40.107.159.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yNP1C6OoDeiVwCC5LUxJxvFVU4PU/HuM6vDvl4+Ki0L0m0lqZMjiBFzJbnR6K6uONrIvITy217yWx/106RDT9p8oc4x+K7IDXh+nvR75k0Ew5iwmdSufFwEBGxGHWOGPsgO/EqRLO3nnhDJ+44+V6muvna99FCjoG8RcLNoGVKMlhfhmijOHoEzOSsXP021lNFim9BaL+ZEalmpq6eTeZrJ73VQzIBDP0EcM15McONNgXfwxBmzURVsFTU3rJNvRWnIXydrYsFJOqGjPnEPTRYuRovQ7Zfqk10Cr0oQdTnPtBFIg86Bs3IMCZIyO+5H3ofm2SVbtVk+6eN8wjCAlPg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSDBtN4g99QHTM501GZPCHfWLvib6gHl+mAVnjc55eU=;
 b=qLVXr/Zadlu/iEmhxFEI7F/UqukKu6d753fduF3uJLYkxv7UiE4I32wPgFJBYG/AFXcoYU1lDDYkmnM/Zdjfc5UIwl56pNctvixI6txvpUgD+u3L4egRk4uXMaS+8KXGLjdnwnJ3+0Vvp022+tD04I49vZ4+39Wv8ds63splxMyZS4QBOKhpixAI5hs+ew/LDzi5l38xJwI6UIvgcx847Qcf8plQyrr8Z/gaEeVwTNF2eqeYt6EyluZsX9rMNe5AToOjtOSJKcRUsCerypMUCLIRunFqu+FS99Dk2+LNIqGsD66q/ol+N+KSfzdypjgHq16ZpQ21wSsRyS8qKXww/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSDBtN4g99QHTM501GZPCHfWLvib6gHl+mAVnjc55eU=;
 b=eYHSRInyiD9gjUOIhE/DT9r/3ETwID6EUB4TUJoG6p9gnQ7gFJsCT4xxUNfS0XPdoVeBQXlweCIeQm/QChfoIVESZcE8tBL+Hw/3QYc2QPORjkUusp7yoP0F8atCnXPGhCTqg1kf7sJqmKGA4SqJ6kDZMpnMyW6MK8p0BZNjwEM=
Received: from DU7P189CA0002.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:552::7) by
 DB9PR08MB6553.eurprd08.prod.outlook.com (2603:10a6:10:25b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Mon, 23 Jun 2025 13:12:23 +0000
Received: from DU2PEPF00028D0B.eurprd03.prod.outlook.com
 (2603:10a6:10:552:cafe::89) by DU7P189CA0002.outlook.office365.com
 (2603:10a6:10:552::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.29 via Frontend Transport; Mon,
 23 Jun 2025 13:12:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0B.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Mon, 23 Jun 2025 13:12:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFgBtyJx5E6zgnNu2sZEEz+oRg8gQk3lSW1QbAaIa7CX43VmXOfUCM6BZdmQt32+eaQf5VJlKLSvrfDEiMCLLMlnS9L5AKNvpnVpu3Jy7UdTYQC+MmqsIxeVBSuRpjo9SF632cM3W/IVmraWnVVVUh/UELxJnvPQ/ox+vO385frmg8iHedHmeavyJRIQW0cSgTKlhb4eRgmUyFUrQGArlA8qCvq6hOSs/1TBN62p0wiAa2mGsX5pmj9QM1fDfI1q9xVM96zWmH7MDxqFl4H/R+YTRNMz8VDHySvOwNqrVIU618S0CVAN1G8RTV0pcaNadpEtkqhUrTnL5rU2X6K7Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSDBtN4g99QHTM501GZPCHfWLvib6gHl+mAVnjc55eU=;
 b=IoYVbMgDPG6m4e8ntNWaMKyPnqsP+l00tI9TREEQrjlbgv9r70WTOWYoG8J6p4SBhHV2Dt7X6J8Lm1N/82itmgUhM/nX53jCQnq2IAXOVCUcdF2+zwkWgKG8QQqNulowaNcAwTkcRp44TRj+Q+8u5EiovlAawytokpnc2JM0WcpdijuQn80Tv9EAfXvkZwcak0eqZlPIw4rRCORmgdUTWDxeSKf8AN3rCuyTIu3sWlP6NoSP+3itgv5ePOg8Bub6f4T3ZZPccBx7/Ursd5Ki6b1++8kTjRQaZGNhTaJ4JFI5OOjQFtWbxbRkAmr9UXRvYi3h7LUHp/w6NYIndFMusA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSDBtN4g99QHTM501GZPCHfWLvib6gHl+mAVnjc55eU=;
 b=eYHSRInyiD9gjUOIhE/DT9r/3ETwID6EUB4TUJoG6p9gnQ7gFJsCT4xxUNfS0XPdoVeBQXlweCIeQm/QChfoIVESZcE8tBL+Hw/3QYc2QPORjkUusp7yoP0F8atCnXPGhCTqg1kf7sJqmKGA4SqJ6kDZMpnMyW6MK8p0BZNjwEM=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by AS8PR08MB6200.eurprd08.prod.outlook.com (2603:10a6:20b:292::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Mon, 23 Jun
 2025 13:11:48 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.8857.026; Mon, 23 Jun 2025
 13:11:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Topic: [PATCH 4/5] KVM: arm64: gic-v5: Support GICv3 compat
Thread-Index: AQHb4f15BBM4oiETR0uMyl7uJd3tLbQMfZUAgAAtUoCABBHdgA==
Date: Mon, 23 Jun 2025 13:11:48 +0000
Message-ID: <e34738676fef5ec6f06564ecf22a4de1705df66f.camel@arm.com>
References: <20250620160741.3513940-1-sascha.bischoff@arm.com>
	 <20250620160741.3513940-5-sascha.bischoff@arm.com>
	 <aFXClKQRG3KNAD2y@linux.dev> <aFXomXKBk1V9iYSa@linux.dev>
In-Reply-To: <aFXomXKBk1V9iYSa@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|AS8PR08MB6200:EE_|DU2PEPF00028D0B:EE_|DB9PR08MB6553:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc22edb-dbfb-4e74-3deb-08ddb25796d6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?eENiVXZ3MWppdlUrRFhTN2d4VVFvclZVL2xGT2NIZzNlWmhXaTFvVXVkL3Mx?=
 =?utf-8?B?ak9oaVQzbTg3UEYzdSsybUNnR2hsTkF6RWdicDYzMkwrTXl5QStBNkZycElD?=
 =?utf-8?B?bnF0ZWZlbnNNL0loN2dUYWc4YkgyZlpOQ1RpV1RqVEswSXVXOFpZOE8wdExG?=
 =?utf-8?B?RS9haVJuYmRBVGEwV1N3T0xsRnVRbEpManVHUGQyUWx1ZUw1THk4M0Z2US9i?=
 =?utf-8?B?bjFOcjhKQk9rV3UzOEwzWlJmRllKR1BTNitaSWl1MWRub2FhTjVzd3ZIK3U2?=
 =?utf-8?B?bXF5eElTZWVrVE1HNVBEUDhybjdJSEFpR1dmdUxsM0licy9GQU9jemU4dWJw?=
 =?utf-8?B?cmc3cVhWSTdwM2xISkZLNk5ORHJyOVRueW1NQy9zYlIvcXpuaDdGVUI3OUM2?=
 =?utf-8?B?NXhDS004K1N6ejk2aTlsMXhveTN5ZmRkOWxXOFN3T3RQTDB3azdkQVVuUW5v?=
 =?utf-8?B?dEI2ZmRBc09reFIzLzUyZkNFYU5IZERLSnNBd09GQ21oNUZFVi9BUHJvcnJ5?=
 =?utf-8?B?M0Z1K012WnFJdHZiS1dDN0FOemYydlZRQWNaWGIrVTZkRnBWZHNLdjVtNXhk?=
 =?utf-8?B?NVphUEszTEFNcVVhNTQ3WFlFRGZqQW41SmJzMjNjVmVJQXllR2s3emk3VEto?=
 =?utf-8?B?aXdiMGR2QUF0eGF0d1RFTWxZb2MyaHVEMThjNVRvYytKZ0NFLzZ6S2VWSVJi?=
 =?utf-8?B?eGFHTDZmdGlRbGNRMUhoQ1BaVUxxdDFkcXl3bDlzcG9CZGNCSVNTbkNFakIw?=
 =?utf-8?B?SEV2ZWFyVXdQZVQvNzVObHR6VGM1cGlpaVBVVFROcGtwRktiNnJsSmQvQzhv?=
 =?utf-8?B?R05TeE5ZWVZCNFZvYmtDSUMwazBjaHh2OGQ3WDBLTmZpaXY5OEVpLzdTMHBR?=
 =?utf-8?B?L2NpSndiUzQ2bUdlc2Y4b3NNQ3MvbjVOdWlPRE91QlhMaDMzcEt4c0RDcUwv?=
 =?utf-8?B?M2hJaG5kQ1dCZmdOM05vNVM3WHJURXVxS3BQNDhmWm9ubFR6OXFGRWR2RExQ?=
 =?utf-8?B?OWNrOThCcVZwOTUrY2ZLbXRLUzE2ZEdOUnZzc2VhSHAyTk0rcWxSeFQybHVy?=
 =?utf-8?B?NVUwaW4xcmFhUzJaUnZVVVNjMlNTVGdoalFqTUdJc3VTa1BzZUtBSG85SFlO?=
 =?utf-8?B?cFVvS0YrSGNqb2VNU0R5N3Q1Z1UvVWYrWlNDMDdOeUJlbGlVRjE3ZlBZWVBp?=
 =?utf-8?B?NkNGeWxUeFJOcEkvSzFQd0FkeHlxVkw2d3VnaFlIYmtQczBnSEtyMnpQdGZJ?=
 =?utf-8?B?eW4vOW5xdkxTREhzMjMxZ0RyNG5TMWUzWUE5MWRTMFA1RnVqb1gzWi9ndmNa?=
 =?utf-8?B?aU5nZHJqUmIrNDBCR2dLb1R0ZVFaK1BaaU1DeWZ3bDl3cTdLYlJZeThkUkNL?=
 =?utf-8?B?VjhGY0ZGNWtVNTZHbFpNRlh3RSt2bStUUUJpWFZGVWlWRUVHdkR2TFBlRUVs?=
 =?utf-8?B?VFFnTk93NmNMaVljQ0l5NXc4WGdsNUpLTThDUXFEc2FWbEgwU1BrWEtpZGg1?=
 =?utf-8?B?eWltRkM3VllyVjcyZnJtUkI0eFhjT2t4WTNXdnp4Q0NEdnltcG95aENTUFBu?=
 =?utf-8?B?UVZOL0wrSlcyWG9naExVeXlGVEt0ZHl6a2U5cmNXelNVN1k3R0p2a3k5VUZI?=
 =?utf-8?B?ZlM5VE50ODdVMkUvZ3k0Nlh0aDV6YlRzYVVCVWo2TUdkZEJpUGVoOUNFVVlL?=
 =?utf-8?B?Ynk4eXRHbWRuQ3hQb3FpQ3MrbHp2cXhZZElWbEtzenRQaWdOcjFuZ2M5aGY2?=
 =?utf-8?B?ekYxMi9XTzdSWjRaZDU4UVV4SmRZaTRlWnVQaXF4ejNTU0J3ZEEwbjJiYU50?=
 =?utf-8?B?S0xmZ3BJaEpuTnZpK3NtUDNTUUxTajU4Vm9aUkl5cG1jK3hvd3lkdFB0K1cr?=
 =?utf-8?B?UER0Qjd2a3VLMkUvNytXcHFETnN5SXhubGJxZnJDNlQwdXVYY1lMU0dLdXZK?=
 =?utf-8?B?OHhzNThEOFA0aWJYVXZGZ2RMMEJwa2pyN2RCNGdqWm4xa2VRVlEyQnAxWVNq?=
 =?utf-8?Q?JrchQyIx0VNsX8aKfmphmH7mhKb1/M=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <72FBF51B4DF1924AB49D580A4621C341@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6200
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0005d13e-32cc-498e-0de4-08ddb25782fd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|14060799003|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVJyZjBtdHVac0xRQkhpL3hFTEIrc1JLR1dpQ3k4ajladWlKa0Ura2pLOXVM?=
 =?utf-8?B?czIxVTQ3ZnlYRWx6eVdsRkttMlZRTC94V0Jxa1RkMEZ2anlHZnRSeGdSN2Ey?=
 =?utf-8?B?b21wejdRUkUvYkpqZUVvYmExQkRITGJaSytEU2ZSMDFLRHk0UExZRjM3OFBT?=
 =?utf-8?B?cG4rMmxMZkNGeHhGaWVzSlQwSUVpTkNFb2wxc2p1UnNmbUVKVWJ2cUJTNW9u?=
 =?utf-8?B?TzNlVVVPUmJvcHJmWU9EOXJwQmJKekZaOHUyOG1Lb2JodFBGanB1NDBFNFZu?=
 =?utf-8?B?S01iVkFhNVdQVmwyZWlsQWVVb0VqMUY0blVRMi8wMXNsRmY1Z091aHVKb21H?=
 =?utf-8?B?Z2E4YWVVOXBzOU93Q1AyOG16T2VkdUo3U2QvQmVrTkNqOGdwL29QaStMN2M1?=
 =?utf-8?B?SDdDSFpkYzhGRDY1UmRzNXdBWkdPRnpSOGtnckdiR2hTcnFCSEI5TnR0RFdk?=
 =?utf-8?B?L0Uxb1l4S3lMMFJmMDNydTFsM2NhVHNuckdtYnM0KzVCSUk4aFV3WTVUVVl3?=
 =?utf-8?B?dXJDOHVOc2pTb2VRZThnejdGcXdMQW9mM3M1OUtPa0VEeEpid2FKUWhKTEsv?=
 =?utf-8?B?ZlUzSWhMNGRmMlBwUlhEM3czZEVka2Y4Zzkxc3RFUkVrNzlQU212UmxlWFVo?=
 =?utf-8?B?Y1VkQUdlWm91dHBYbHZ5aFg5bFpodm9vRWxLQlNkZVNBUHhqTmZHOXF1YW56?=
 =?utf-8?B?Q1kzc1ROamhJUkRnZTVDa1RockJzK0ZVL3dUYXd6dzVsK1pJaElCQzB0OUdi?=
 =?utf-8?B?UlpWcVJxMEswY25VRWJMWHJ2cDZwOEM5MUc5aE92NHlnUTNockpybWszNUQz?=
 =?utf-8?B?YXE4WlRCcUtYdWxJQmljandWRXl3aUFmMzBtM08vbklTMUxYcEJnZ1A4M2Nk?=
 =?utf-8?B?QmRvWmdwUFh6SEx6ZWVadkI3ZGN5SUdlUFVTcG0wVFAzUGlkQVNGelNzbjRa?=
 =?utf-8?B?WUtncFMzTEpYZytxcytjU3dVZHJwckdjeWprWkxYb3BGNnZ3REVhSUM2RXJC?=
 =?utf-8?B?VU0vR2ZHSG5OV0xHa1l2VTFIUUJVVDlPZDNBbWRLaWNxU25mZjZaNWVIMTFL?=
 =?utf-8?B?QU42SEQzN0N2Q09kQjdLTXp5dEtwenU0cjhwRnlxNzZNeEV3bWtvL0N0MldL?=
 =?utf-8?B?Q0lxMzZ5NHU3VWY3R3grTHh4d1FHWVBaL0NXQXFyeDJjd2dCRXJ2YkFpWHox?=
 =?utf-8?B?VVp2SlJ0Wk1lNmoxRFJhRXFuZnR6NUUxanNXc3NWQmNRZmJoK1JON29OK21I?=
 =?utf-8?B?V3lRYnpSKzltekNQL0d0K3BzcTloSUhHMnRNenI4elNLWWwxZzRPcTVIaXBL?=
 =?utf-8?B?ZmZRUWx5Ty9MZVJlUzJab1MwVlc1MXhsemVGczZYQmdicjd0Y1FtQ09wU2xW?=
 =?utf-8?B?N0dQSG8vWGRkbXZXZGVPdXRicCtkaTROYjhzeVgzKzJlYzVUU1dnSEQ2bmh6?=
 =?utf-8?B?cXBSZVBmNmVHUnh1SjBaV2Rkdzl1M3BKR3Jhd2Fuam41K01FMXZmSElNeUlM?=
 =?utf-8?B?QU1nMnlMbmtoc0VFdDJLUGZEdEdZK0dUVnZLdER2Y3FEQ1Jsd0NjMXJ3UWkr?=
 =?utf-8?B?Y0wrbUFMcHBRdTBiV1VEMXZqak1jNUxrTmlrVHkrL3I3aGFweEV6R3J5VCtu?=
 =?utf-8?B?L0RabGU5M2E5WXBtQ2dmaVJQN2svV0NYa29aNkV6MTRFeitSbTJZQXBCSi9o?=
 =?utf-8?B?WG1Xb0FNUmRFaTRJSGdLVG5hUXdLTFhsQkkvbVFXYWxIV0NRcWFmNWFhWjVD?=
 =?utf-8?B?WkdZdFcrNEN3blZHSXQzZEhCV0lEdnl4dXB1bmovclVkN3lQWi9MbVNxd1Na?=
 =?utf-8?B?K0lmaG5kWHlTQmdoVGJvdi9NRWFVOGYvWW1nREp3elk5K2huN1JCd2lDcFNT?=
 =?utf-8?B?eEhxK05DVTRYdGZjWWJDbWI5TGV0dXNQeTZqdHRjOHpwK2RRVDFpakd2SHZv?=
 =?utf-8?B?V0tBSzZ1YmpOQkxaaHpmM3hzRGVsVHNPRFIzT0pWenZSYXpyb1hFdll3Nmti?=
 =?utf-8?B?Vk5tSlBmeGdoMHUvdGdITFlUeURrczlUN1FjOVJ3QktTT2NRZjQ1VWFXNDhm?=
 =?utf-8?Q?wV9nuo?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(14060799003)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 13:12:21.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc22edb-dbfb-4e74-3deb-08ddb25796d6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0B.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6553

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDE2OjAyIC0wNzAwLCBPbGl2ZXIgVXB0b24gd3JvdGU6DQo+
IE9uIEZyaSwgSnVuIDIwLCAyMDI1IGF0IDAxOjIwOjM2UE0gLTA3MDAsIE9saXZlciBVcHRvbiB3
cm90ZToNCj4gPiA+ICt2b2lkIF9fdmdpY192M19jb21wYXRfbW9kZV9lbmFibGUodm9pZCkNCj4g
PiA+ICt7DQo+ID4gPiArCXN5c3JlZ19jbGVhcl9zZXRfcyhTWVNfSUNIX1ZDVExSX0VMMiwgMCwN
Cj4gPiA+IElDSF9WQ1RMUl9FTDJfVjMpOw0KPiA+ID4gKwlpc2IoKTsNCj4gPiA+ICt9DQo+ID4g
PiArDQo+ID4gPiArdm9pZCBfX3ZnaWNfdjNfY29tcGF0X21vZGVfZGlzYWJsZSh2b2lkKQ0KPiA+
ID4gK3sNCj4gPiA+ICsJc3lzcmVnX2NsZWFyX3NldF9zKFNZU19JQ0hfVkNUTFJfRUwyLCBJQ0hf
VkNUTFJfRUwyX1YzLA0KPiA+ID4gMCk7DQo+ID4gPiArCWlzYigpOw0KPiA+ID4gK30NCj4gPiA+
ICsNCj4gPiANCj4gPiBJdCBpc24ndCBjbGVhciB0byBtZSB3aGF0IHRoZXNlIElTQnMgYXJlIHN5
bmNob25pemluZyBhZ2FpbnN0Lg0KPiA+IEFGQUlDVCwNCj4gPiB0aGUgd2hvbGUgY29tcGF0IHRo
aW5nIGlzIGFsd2F5cyB2aXNpYmxlIGFuZCB3ZSBjYW4gcmVzdG9yZSB0aGUNCj4gPiByZXN0IG9m
DQo+ID4gdGhlIFZHSUN2MyBjb250ZXh0IGJlZm9yZSBndWFyYW50ZWVpbmcgdGhlIGVuYWJsZSBi
aXQgaGFzIGJlZW4NCj4gPiBvYnNlcnZlZC4NCj4gPiANCj4gPiBDYW4gd2UgY29uc29saWRhdGUg
dGhpcyBpbnRvIGEgc2luZ2xlIGh5cCBjYWxsIGFsb25nIHdpdGgNCj4gPiBfX3ZnaWNfdjNfKl92
bWNyX2FwcnMoKT8NCj4gPiANCj4gPiBMYXN0IGJpdCBhcyBhbiBGWUksIGt2bV9jYWxsX2h5cCgp
IGhhcyBhbiBpbXBsaWVkIGNvbnRleHQNCj4gPiBzeW5jaHJvbml6YXRpb24gdXBvbg0KPiA+IHJl
dHVybiwgZWl0aGVyIGJlY2F1c2Ugb2YgRVJFVCBpbiBuVkhFIG9yIGFuIGV4cGxpY2l0IElTQiBv
biBWSEUuDQo+IA0KPiBBaCwgcmVhZGluZyB0aGUgc3BlYyB3YXMgYSB1c2VmdWwgZXhlcmNpc2Uu
IElDSF9WTUNSX0VMMiBpcyBhIG1vZGFsDQo+IHJlZ2lzdGVyLi4uIEkgaGVhciBpbXBsZW1lbnRh
dGlvbiBmb2xrcyAqbG92ZSogdGhvc2UgOikNCj4gDQo+IFBsZWFzZSBkbyB0aGUgYWZvcmVtZW50
aW9uZWQgY29uc29saWRhdGlvbiwgYXQgd2hpY2ggcG9pbnQgdGhlDQo+IHB1cnBvc2UNCj4gb2Yg
dGhlIElTQiBzaG91bGQgYmUgYXBwYXJlbnQuDQoNCklmIHdlIGFyZSBoYXBweSB0byBtb3ZlIHRv
IG9ubHkgdG91Y2hpbmcgdGhlIElDSF9WQ1RMUl9FTDIuVjMgY29tcGF0DQptb2RlIGNvbnRyb2wg
aW4gdGhlIHYzL3Y1IGxvYWQgcGF0aCwgSSB0aGluayB0aGlzIGNoYW5nZSBjYW4gaGFwcGVuDQpu
b3cuIEhvd2V2ZXIsIHdlIG90aGVyd2lzZSBuZWVkIHRvIGNsZWFuIHVwIHRoZSBXRkkgbG9hZC9w
dXQgcGF0aCBmaXJzdA0KdG8gYXZvaWQgdGhlIGRvdWJsZSBjYWxscy4NCg0KPiA+ID4gKwlpZg0K
PiA+ID4gKCFzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZrdm1fdmdpY19nbG9iYWxfc3RhdGUuZ2lj
djVfY3B1aWYpKSB7DQo+ID4gDQo+ID4gQ2FuIHdlIHVzZSB0aGUgR0NJRSBjcHVjYXAgaW5zdGVh
ZCwgcG9zc2libHkgdmlhIGEgc2hhcmVkIGhlbHBlcg0KPiA+IHdpdGgNCj4gPiB0aGUgZHJpdmVy
Pw0KDQpJJ2xsIGxvb2sgaW50byBpdC4NCg0KPiA+ID4gLQlpZiAoa3ZtX3ZnaWNfZ2xvYmFsX3N0
YXRlLnR5cGUgPT0gVkdJQ19WMykgew0KPiA+ID4gKwlpZiAoa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRl
LnR5cGUgPT0gVkdJQ19WMyB8fA0KPiA+ID4ga3ZtX3ZnaWNfaW5fdjNfY29tcGF0X21vZGUoKSkg
ew0KPiA+IA0KPiA+IENhbiB3ZSBkbyBhIGhlbHBlciBmb3IgdGhpcyB0b28/DQoNCldpbGwgZG8u
DQoNCj4gPiANCj4gPiA+IMKgCQl2YWwgJj0gfklEX0FBNjRQRlIwX0VMMV9HSUNfTUFTSzsNCj4g
PiA+IMKgCQl2YWwgfD0gU1lTX0ZJRUxEX1BSRVBfRU5VTShJRF9BQTY0UEZSMF9FTDEsIEdJQywN
Cj4gPiA+IElNUCk7DQo+ID4gPiDCoAl9DQo+ID4gPiANCg0KPiA+ID4gKwlpZg0KPiA+ID4gKHN0
YXRpY19icmFuY2hfdW5saWtlbHkoJmt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5naWN2NV9jcHVpZikp
DQo+ID4gPiArCQlrdm1fY2FsbF9oeXAoX192Z2ljX3YzX2NvbXBhdF9tb2RlX2Rpc2FibGUpOw0K
PiANCj4gRG8gd2UgbmVlZCB0byBlYWdlcmx5IGRpc2FibGUgY29tcGF0IG1vZGUgb3IgY2FuIHdl
IGp1c3QgY29uZmlndXJlDQo+IHRoZQ0KPiBWR0lDIGNvcnJlY3RseSBmb3IgdGhlIGludGVuZGVk
IHZDUFUgYXQgbG9hZCgpPw0KDQpJJ3ZlIHJlc3BvbmRlZCB0byB0aGlzIGluIHRoZSBvdGhlciB0
aHJlYWQgKEkgdGhpbmsgd2UgY291bGQgZG8gaXQNCnB1cmVseSBvbiBsb2FkLCBhbmQgZHJvcCBl
YWdlciBkaXNhYmxlKS4NCg0KPiANCj4gPiA+IMKgfQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gPiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy12NS5jDQo+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+ID4gaW5kZXggMDAwMDAwMDAw
MDAwLi41NzE5OTQ0OWNhMGYNCj4gPiA+IC0tLSAvZGV2L251bGwNCj4gPiA+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gPiBAQCAtMCwwICsxLDE0IEBADQo+ID4gPiAr
Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPiA+ID4gKw0KPiA+ID4g
KyNpbmNsdWRlIDxrdm0vYXJtX3ZnaWMuaD4NCj4gPiA+ICsNCj4gPiA+ICsjaW5jbHVkZSAidmdp
Yy5oIg0KPiA+ID4gKw0KPiA+ID4gK2lubGluZSBib29sIGt2bV92Z2ljX2luX3YzX2NvbXBhdF9t
b2RlKHZvaWQpYQ0KPiA+IA0KPiA+IG5pdDogd2UncmUgZ2VuZXJhbGx5IHRydXN0aW5nIG9mIHRo
ZSBjb21waWxlciB0byAnZG8gdGhlIHJpZ2h0DQo+ID4gdGhpbmcnDQo+ID4gYW5kIGF2b2lkIGV4
cGxpY2l0IGlubGluZSBzcGVjaWZpZXJzIHVubGVzcyBuZWNlc3NhcnkuDQoNCkRyb3BwZWQgdGhl
IGV4cGxpY2l0IGlubGluZS4NCg0KPiA+IA0KPiA+ID4gK3sNCj4gPiA+ICsJaWYNCj4gPiA+IChz
dGF0aWNfYnJhbmNoX3VubGlrZWx5KCZrdm1fdmdpY19nbG9iYWxfc3RhdGUuZ2ljdjVfY3B1aWYp
ICYmDQo+ID4gPiArCcKgwqDCoCBrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2djaWVfdjNfY29t
cGF0KQ0KPiA+ID4gKwkJcmV0dXJuIHRydWU7DQo+ID4gPiArDQo+ID4gPiArCXJldHVybiBmYWxz
ZTsNCj4gPiA+ICt9DQo+ID4gDQo+ID4gVGhpcyBzaG91bGQgYmUgYSBwZXItVk0gdGhpbmcgb25j
ZSBLVk0gc3VwcG9ydCBmb3IgR0lDdjUgbGFuZHMuIENhbg0KPiA+IHlvdQ0KPiA+IGdldCBhaGVh
ZCBvZiB0aGF0IGFuZCB0YWtlIGEgS1ZNIHBvaW50ZXIgdGhhdCBnb2VzIHVudXNlZC4gTWF5YmUN
Cj4gPiByZW5hbWUNCj4gPiBpdDoNCj4gPiANCj4gPiBib29sIHZnaWNfaXNfdjNfY29tcGF0KHN0
cnVjdCBrdm0gKmt2bSkNCj4gPiANCj4gPiBPciBzb21ldGhpbmcgc2ltaWxhci4NCg0KT0ssIHdp
bGwgZG8uIFRoZXJlJ3Mgb25lIGNhc2Ugd2VyZSB3ZSB1c2UgdGhpcyB3aXRob3V0IGFjY2VzcyB0
byBhDQpzdHJ1Y3Qga3ZtKiBpbiBrdm1fdmdpY19pbml0X2NwdV9oYXJkd2FyZSwgc28gdGhhdCB3
aWxsIG5lZWQgdG8gYmUgZG9uZQ0Kd2l0aG91dCB0aGlzIGhlbHBlciwgYnV0IHdlIGNvdWxkIGZh
bGwgYmFjayB0byB1c2luZyBjcHVjYXBzIGRpcmVjdGx5DQp0aGVyZS4NCg0KVGhhbmtzLA0KU2Fz
Y2hhDQoNCj4gDQo=

