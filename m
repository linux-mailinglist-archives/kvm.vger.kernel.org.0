Return-Path: <kvm+bounces-50976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B551BAEB3DD
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:11:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE8CB7B2E81
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DA729DB79;
	Fri, 27 Jun 2025 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L6P2HdBE";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L6P2HdBE"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011069.outbound.protection.outlook.com [52.101.70.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9479229AB11;
	Fri, 27 Jun 2025 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.69
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751018986; cv=fail; b=ExcFC0lVEoxE/wgbLyL8k6DDwLAedGBfhF0Z6/mqO0xRo1ZOpIz27j+8TQsuCGPcRmi2l3AYX+yYKYJqq+/h3nDBRJW4pZ2kNM+WghtHZ4JgeWq3fJp/2RQm3Zfk2JYAcMr0gs7VOzyLc5mATZeb9Asj/EkSQ0RrBFpbSG931vs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751018986; c=relaxed/simple;
	bh=6T3zU3ykp6ZocYmSvCsnBk0vCpzvDHlAo7DUvticcFs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GfslJWgKSjrECVm4rbj09rbdIoTxPnaJ3ZCzf3f+KeLQLBpCdxm7aVlpCZfnHW2lg3JyfmfA7ITH5BcBBgep5hMaBpLK6NQkfOSyJ7YofFKmEWDxUGh3FD6z6r8feJVcyGyiDJQoxZueSqCW3K2FbehIcV17PRU6+oxAOmIem78=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L6P2HdBE; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L6P2HdBE; arc=fail smtp.client-ip=52.101.70.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Rw22Urmuwh/x1HtGkBN3LtMFcyVMP40svwGUTbU5WDjN8d2W6bqj8KI9Ml554DICuO8pc8qmBjgBOVjt+GbQS6Spe/0OU1c+kfAdVZFU1ClGjA/iJ7ED7eOR2Zx6l352YDPPMY46/Dkk1acjCOhodW/OGcRdssd7o3E0LKKaonk0YTOe78YEM8kMTqaRy73dy0iuGCr3cMuKShpJ5ZEXaMOYfd73RE5QL+C36+wToeLW1E1w6WRajdlKEksqhqBbDUQVU82+cfJKHTDghTVxP2NTb8HZOCxne7KDpj24C4oy1AG5280FnNutrtTHyG9Uqy2qTPxFABPCvP72mc7k6g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=FEO6PXj5jm59aOGYI9JW4S6qgHFr82ZdIqIreaiGiM+jh2pG03ljUbj9ykGY12pR21SkvF/dPyOp56G+dQj6fmFMNuyOZZARjeFETRyRYL1k03Ogy3fERL+9gmKB5BO+3SNHNTQzQLPIBcb47nFDG0yirLtFX0/9sV1irvjF66WQdRtn/pfYSC4dWdD7TrjnPX+jmRDud7PA9I8mmP2qqFUq5Fns0XzUYb2iTrZmsINq6LFOOpYFylkKUYTEPM09ohZEUhBnUdIYG2TwggHbgRYzHrHCg67XmUkupZ/eLRXMCORNbKhPdkCbkIbzb3eIE+hufmsY0JTT5zJk88qsNw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=L6P2HdBEWzu+ZM55zt4B1Sp/oEeojhehdXIaAyF5gbeKSW01lcHqthNACRqxWn+cYxUD6i8vEmE5yW11KXEezT936V86xTYf8u6hCfrX134shxCi6YO0uhE21YXujT/5p4AONbG096JMnOKaB/xc0ay8LgvQtNu5qu9Y2xqGbDc=
Received: from DB9PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::12) by GVXPR08MB7895.eurprd08.prod.outlook.com
 (2603:10a6:150:17::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 27 Jun
 2025 10:09:36 +0000
Received: from DB5PEPF00014B95.eurprd02.prod.outlook.com
 (2603:10a6:10:1d8:cafe::a3) by DB9PR01CA0007.outlook.office365.com
 (2603:10a6:10:1d8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 10:09:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B95.mail.protection.outlook.com (10.167.8.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.14
 via Frontend Transport; Fri, 27 Jun 2025 10:09:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dj0yP3+8KxOp9NXM2kVWYS5PNZkZYH1zozDEzE7kq2EeQWBGDquFlFAXpDroEuIfEarbk3VgzFzU0C24w0amRVyQtYDNzcmI3qQyY6sCmSSTJ6hmv1rsy018bfCsfh9yDVKGUb4Y5dR+l3hYW3yoJCJbZuqccoqk9AuRpHcimnfMSvlYU2l7OaSkH4SDFanyajr20+YYadBsoGrD+9L6b4uMJbz0+/6VG0lXZJz+YHG/ek38TdVbyIy8fnkc+Kv7EDUweJUAhaTEOxL+4VeYB9XQfQk1+n3sBRiKSF9xRb7ssA4WraycTogFBoCnFUkFEBSLP8s6qC5UzsTVnrgbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=i/fBcGnOuwCrcJWvdaE+TCiIKziT0adV1bYrckdXXkbJlHimie2R+xpmRyeI1jp1yqWOvc1AB+OA0FdHCHhS5LfnKwlThPzR78Vl/x6A8vDTZGoXm0G5/cJa/hPH+JPyiLyejQqjpfvJT7S/71HgymheeyYjF/lPEmSncMkdsWdci5g14mu+wCIM6Hwdpl4M8l2rZ8eVMhpX4GncVd59lbivMwGihLZ5aaevUd4umixGO8tcRf+7VedKOHx1NS3TEsqThIZ5vUYhT+xhorVcbSrgOI4JSlXXvDu2I2BDokmNBoocMKxMQPVGpK7XGg4l2vIL2QQg2f3cFG4fnNlnqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dw68NpwQR9fegNGtN3zsHSuLn+pyiAshEG2fMZT/ro=;
 b=L6P2HdBEWzu+ZM55zt4B1Sp/oEeojhehdXIaAyF5gbeKSW01lcHqthNACRqxWn+cYxUD6i8vEmE5yW11KXEezT936V86xTYf8u6hCfrX134shxCi6YO0uhE21YXujT/5p4AONbG096JMnOKaB/xc0ay8LgvQtNu5qu9Y2xqGbDc=
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
Subject: [PATCH v2 3/5] arm64/sysreg: Add ICH_VCTLR_EL2
Thread-Topic: [PATCH v2 3/5] arm64/sysreg: Add ICH_VCTLR_EL2
Thread-Index: AQHb50uBf8S0sTTh2kCSK8Nlxbq3SQ==
Date: Fri, 27 Jun 2025 10:09:01 +0000
Message-ID: <20250627100847.1022515-4-sascha.bischoff@arm.com>
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
	DU2PR08MB10202:EE_|PAXPR08MB7466:EE_|DB5PEPF00014B95:EE_|GVXPR08MB7895:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0651ad-8f0c-497f-c6f0-08ddb562b776
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Cf2qu8eOGyZSk6vdinT2/Vp8MSrGkCKeM4GY0zhjTD4d8JUKh6y46R1kEY?=
 =?iso-8859-1?Q?LapEk8muP0N04H3bsiiepJoR2zlw4Kc5JaLMRs+3QO/eCteB1JefwYv78E?=
 =?iso-8859-1?Q?Slu4b8kaFupgjRNKNlHZRpYm/JpnCmFMld71SyxwmRlS2HnpJo8vVulz+d?=
 =?iso-8859-1?Q?bkMMvuGn0TXWFSbs/SA3yz+B6e+dYiJD7/3N8w/rgtZNEDgdrH8AKxErDe?=
 =?iso-8859-1?Q?gi5ugJscuDrc6QXU593N9GwDfM9Wfhh0fTD3F1weq9ywMGHdGrF2Exh/UP?=
 =?iso-8859-1?Q?RVcbjOqWJK3DF16rh/1rk6TiW7CMwoJywhQ4fLxiLSBwNXLF7KkZsbDZAu?=
 =?iso-8859-1?Q?19PGcw/K1tCuKFB/RpXGqcRluOFzpaA3m8a6oVJ8PtJGAlhE8fz1HUMgJ1?=
 =?iso-8859-1?Q?wHdLKIXUBU+xiTk8tIvvkRU7SFYfg1MA5S7gEEqlODR4LDN6UBUGHUw1zW?=
 =?iso-8859-1?Q?ZCkAUAR+GNYo942ZWV6lchV7QDsS4OLmJTIsl00WcjwHqHKzvckYTaONLl?=
 =?iso-8859-1?Q?o1UEEK8u8MX5x585VupPqMWmww0wkn15D5SbqvxqBkVci8V/aG8w6p3BiX?=
 =?iso-8859-1?Q?24TpNp2Q3eeU16Vv3mZH19sGG79obQHIsOxLpYoEsz171lXpAYqIhHMTlg?=
 =?iso-8859-1?Q?rc0K9iZncFn6FzCKJ76hcZxVf651QYAmSrguaNf/dlbSLq4U/9cPrba2ZE?=
 =?iso-8859-1?Q?hbqGFCH9IIt8Uh/GSyFyTR7chICa5wO69zdMHJtmxCLt+fgbZZVTclacKv?=
 =?iso-8859-1?Q?qj3mWg5gzCit7xlJCXOfeLRrPf7aIvzM4ijY8WxqhI+IS3BhDg+GeHykNA?=
 =?iso-8859-1?Q?SqyOkvabBCUNIR6mkQ5A34PsIdJJHI9785YAqXA80usSaoJQmDNywuiEHs?=
 =?iso-8859-1?Q?9M5XIOPeD+Aw/w/yw02se6T3MEXclyv0GENKao0ter2DvIXsMD/fLW3pdi?=
 =?iso-8859-1?Q?TvFvYBvqlPnDpH9YkoZSjg1G+eMvnMQ0QFufNlILEi6St+y/RTZA42Ka+f?=
 =?iso-8859-1?Q?gZjQyOgCvYSyrV3bTFyovys7cUJeAHTEZ8u5maorODmNwIViuj3h6quiFs?=
 =?iso-8859-1?Q?Ie3AIJkuQuDzVlclWuo+BafNMqUzWTkmycSgYiTg44FLFtcl92NPHAjXyv?=
 =?iso-8859-1?Q?zYwajtwdWcwQyI2XiXCSoscQp8bjUvQv3T1thseBgKVBffRfUV6x4BTf+r?=
 =?iso-8859-1?Q?Y2Xvvm61pIyTTcx++JmRAADi/k6oevnjmU991WL/1xD2aDEh5IyY1c9fXe?=
 =?iso-8859-1?Q?RNbl8NICeWn1qpEGz+UJ5ofwUdqHprlCrM/j8yczTXfElOeVkwSb3Jvsx6?=
 =?iso-8859-1?Q?F5cOFKIJM2jt8viFO6N/SWvvieMWuQWVwmcxmYsXMUIYHV+MdsEY6rhuAw?=
 =?iso-8859-1?Q?EeTrYm4UCPqzj7xwRvqhLkJAp0CBCoxaf0wkv+u3hUNTbOPxrbkrozz7E3?=
 =?iso-8859-1?Q?5hKZXwq4Ep4Bul6VS0Nrg8eFvcR73n0BTEhMkaxKhZJgHEfNYSv9AgKQCJ?=
 =?iso-8859-1?Q?01Xl5VwPDVkt5lrRAhj8I4iJ3FyejWMjT4cGVqyZxgnA=3D=3D?=
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
 DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f6cf9a02-69c0-40f0-9488-08ddb562a43e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|7416014|36860700013|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?HfVvJ4Qrh1zDmAi9i23GAtvsKECp9aw+gMhoFPnLLhM/7y3xD9FQTVBjdt?=
 =?iso-8859-1?Q?LvJcxP5BGeTfe9m7flOb4ADubVGYcqy1jXY3vaeEJyzVMq6lWVR8iJBydZ?=
 =?iso-8859-1?Q?PksXlYNkG64HbVLuxV0musW5I+ncT7ByYTmaMLTFjcQ5IwJEl9ZEF6ZbVJ?=
 =?iso-8859-1?Q?T9RkFtz16NTQeZLlTgFld3qaRk1j6HeiSJ38CG+8AmyqHCmD5ZCHQL5wti?=
 =?iso-8859-1?Q?zd9yLJprSG7/w04WrjGEd4rtbGTGYtkiDfEudG6q/ZwOHVD8SgvJxW0jDy?=
 =?iso-8859-1?Q?7o//oLNrZbwcVJ/0LS9xrM2Oig6Mw97VaAy55o9X1OdzCrUFi/b0kDF4Wk?=
 =?iso-8859-1?Q?/R18nJOwSIUX/3uC6f62szDRJWYkXogB7Ski3JVFsz8qPDgPnKsH570OLy?=
 =?iso-8859-1?Q?xxANIO9BSHnAnjpbk4Qx0kVblS126/eTK8jdX6KxjpZwo6G+ZO0bsUk9Po?=
 =?iso-8859-1?Q?C91D+jUeb3teiLSIonOwQw+dRTPMHPtwHqtHviPwieTpwNTdkYQOE/nI/G?=
 =?iso-8859-1?Q?EpY3KU+6bs1QuIGQNfD+hshfqAu1dNeIqVVusNcl9WbMFWq8n8z1UgDyfF?=
 =?iso-8859-1?Q?QAjcpIViXsVExaKPc/vymr0CWR4xH2moChFYBiZMKvaesEEsRr3W2qyqTS?=
 =?iso-8859-1?Q?6P4oCT71EWChinRq5VCBA3TsJfyJZL/Jj/bTvS3eG0mOwQLm0oaQpckTKy?=
 =?iso-8859-1?Q?ufPPfgukx04cw3F3FUKhT1Xs8eRmVXeaDzdHZdy3Octdhg2va0dGJgefk0?=
 =?iso-8859-1?Q?Osk6S4Mw6NnZPC8LS4cDPGsFl+DM4ezaYr6r7k8BTyJhoykZVV9x98XZ7q?=
 =?iso-8859-1?Q?1qjXJqajCYQztaxI9ayMeankzjXhkXbtTp47mt9FUgJBLiTCT2jySjMOI8?=
 =?iso-8859-1?Q?Wst8RIJ/ewq1DwGQvHMfGMvtLXnFowJ4GbHUVyVMPx7VnJBPQpMDBDNOUK?=
 =?iso-8859-1?Q?v0G1YyRYzEZ39oigF2Z8gK4xNMUq8xgVcEWr97Sfi09bkjpERBCJxYxtgZ?=
 =?iso-8859-1?Q?zuR0Fcmn57CRcskRo5NvUbpX6u5b1hu5KaMbAa28fN45jCCpwa4+/Cwk//?=
 =?iso-8859-1?Q?rZFKUHkQ0Fa2l0E5RkvHUDZV8YC+CLLWe/3FOYt8ZK1/bEs+gqkxBm7rnx?=
 =?iso-8859-1?Q?s71TK72JBb/6NcaqziQsJXkw9N9CBiTDbGGgFi5DpT7S/lJGAZ89NkDKiP?=
 =?iso-8859-1?Q?3U0rRyEaIvDukRZYeBoR/4QcFZGd2U4CtwuMO3gWYlMKW9hUhIxYFSFxM4?=
 =?iso-8859-1?Q?1ZSYKLI9FnbcFVuV84xX7iQ9+bpp4yot+0j1VUMb4FeSZldNi5czj5ELaZ?=
 =?iso-8859-1?Q?LhyAlWHA/mdB8+kyR/Z9S8RAawC6QRXrufxR7/ojxJs9J6N9OBfPpjZp37?=
 =?iso-8859-1?Q?5oORN5T5Bh8q0t6ULT9kbpN7UpjRUZ/cj9T2Z/MMFgeEoX5i7B2OvAbODF?=
 =?iso-8859-1?Q?QfeMiIU6gdCJ9uvytfj8vwMKbhTuQIw1X0wowG9MNIcQ25kMgN1WAOUWUf?=
 =?iso-8859-1?Q?K8GgwObbOgaekcqzFqHX4cQVlwGtxgV04JxB6FmjivZd+2/tnKunktQjAS?=
 =?iso-8859-1?Q?KfIne1rXXseQODM8gS3VAuazq26G?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(7416014)(36860700013)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 10:09:34.4936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0651ad-8f0c-497f-c6f0-08ddb562b776
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B95.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7895

This system register is required to enable/disable V3 legacy mode when
running on a GICv5 host.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index aab58bf4ed9c..dd1ae04eb033 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4530,6 +4530,12 @@ Field	1	U
 Field	0	EOI
 EndSysreg
=20
+Sysreg	ICH_VCTLR_EL2	3	4	12	11	4
+Res0	63:2
+Field	1	V3
+Field	0	En
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

