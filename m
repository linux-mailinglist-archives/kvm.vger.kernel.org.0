Return-Path: <kvm+bounces-67624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95491D0B908
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29C2230BEA6D
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B05C365A05;
	Fri,  9 Jan 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ezV3ms17";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ezV3ms17"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011062.outbound.protection.outlook.com [52.101.70.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F5E364EB2
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978422; cv=fail; b=eGOG4LgXyq/TCRNcPqpjdjrx27u+1UPrDR/lu/WXBK4qDlOqlIolGAu9H+Sy1NTnlT8apphmbG3NpA9Dhh0mIX6aoUprmLdFENLiHxzAll140NBsrS/2afHpz+vkpGV2U7bhHx/K4USNxbj8wjG5x3KUQdAlOobRdo85r66tHJM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978422; c=relaxed/simple;
	bh=JvTPrPthzaPEdUTbk/3Ftb32hQD9H/Bmm/D7CujAUXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YGcMvi2BSTyYjALcoePc0eA1PiOydzktIZnVbWx3MYb9g7WzeWKbP/shF+mtgHVKsFdZqPeSxoJQKOrhDIIfVyeXQw2TaOhFsYjWdDO75A7n3K4w8uJxO1Qa5wWi681Jv18PV2rOjD1WjfHL6BhJKZEhOAB9u89n7eN2ZPvHsb4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ezV3ms17; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ezV3ms17; arc=fail smtp.client-ip=52.101.70.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=mXU0zSp1Bv4xmEWmv3kqpdhIZlhIeaaL/SRaHFhs3Y1hPW1lpl0XXIzziK67Q96qeb/zfHDnMt99bs7EBfO0CpG6gSjgicWebLmQFkWMhcogT1AE2TDDRciLRsMbdmLXCDfPBIxG56t/xKFIu0UbKriW3AZopkJvu76dC2oDMOMsm1P8EG7gPAFY6twI1yKIeVXHOQTqINYBxq3N2MaJme7RfeXhSx2ogaaitwiG/fgYr5gjKvC2QmYsUMp3mjRx63Qgk+4glMqCcIheWpAHoDLzbG7Y5CLWOXDSiCwlrCdA91G4pAoBY/ca4ueoz0olGKRWhaoXTunVzaOEIejh2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DLfqqbfv7Ac9dF0b4f7J0AefvH9xkvpqB5OvVrj7io=;
 b=XQPMP6VU9qnhadnK8bl/qrFBhEvcN12YDbrWjRVuou1llsbakI52WME1kdqy4BdwxitLlkbcIiplyPaO3ael+oVtSWTA7ReqK8rYBAi+84NnBPd6t7hdz5FUuD7WMDGyewGhfeFQFnkOMSj8Ub39jr0uweOJ8k2cbe7/zA2U4bBZm761bsgvfUqDNh5twvpPn3bGXHh2oI2qzWe3TMLt+UeAOLEP09OSO0EJHY7aFSy6/VT3vng+hgK8Cq+fGc7LxvLn8QSicuZMnk58BaeAO+ijVpE3afwghlnFEprLuIwJJl473fz8InvXx1YjLC0v7BCoZryQ6ijuS0A16CElcQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DLfqqbfv7Ac9dF0b4f7J0AefvH9xkvpqB5OvVrj7io=;
 b=ezV3ms17HEo37t8YcbO45TwwTy1CS8+YKaVI5+o/qUXkpiUZJxFlsLt1Yr/kOsFoENLBzvWuSAmRgxx9Q+qaqZqetcj5t7LnPEqe0cutm0w9i2B22wsfVS/QtG5E/0MdXCbCjzXGxwcadQfek7k1M49O8wEmM4y1aFsNSu2dGi4=
Received: from CWLP265CA0536.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::18)
 by DBBPR08MB6122.eurprd08.prod.outlook.com (2603:10a6:10:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:05:43 +0000
Received: from AM2PEPF0001C717.eurprd05.prod.outlook.com
 (2603:10a6:400:18d:cafe::6) by CWLP265CA0536.outlook.office365.com
 (2603:10a6:400:18d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 17:05:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C717.mail.protection.outlook.com (10.167.16.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ub0L0zvF+66b+7Q55brmXgy9VTA9NnNjE4F6sOKtH3bfvql2W2MgmNrWJkIcBz9peRupnyC8EvPG6mTV4TaZryTYkWF/bDys3FcoRGS3sOoGstEINnWYIOZoar7co6fdiuwn8pXaXIiqT8BdqTObKOZYGudpJ29IWBQKcr6K+zyx1x1yknry4AyqyY0sWAv0b1rx1aw0VMB24Hf+JBSpArMrahu2+eUHqi3PIbPSsV+RuEiyokF1CzAOoWY27a6zxWol54fFSw07f9yz51C5r860nilB2LsqZVneTJOCWWUcaMhxfOHCx8HfAGX467Dy3tmBipeOOQtGGdJ39/y8mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DLfqqbfv7Ac9dF0b4f7J0AefvH9xkvpqB5OvVrj7io=;
 b=kQAniIoA0l3bjx4qsNkGOdowOP+fXPn6YI6oMtIKcBVtPMXM1cTI4zBp5uyWF/LTu6N+mG6grC7eqPZMFsJo0Z4YixsJEGVxCQpKhv8QOljnNvFn7V9B6RU6X3lzxpgJpYigUzJQ2BcRii/DR8H2yyGrEDZD7ds+mOzOEdn/oigLsW7fduh9x9RWrVHR22/JE3xIj84H3OFb7BHi8n1J2keG2Xsm7w1MmVw1/WJ0oA6dBJWXafp2uSCK5sdt4evIBib1UgOMPSz+Gqz+Y+yR+KfHnEOrkXcXMmtBsMBg2UDnjkIi4ADuzizi5OKH8Z7eACZGV0cwnB0+3PHC7t82hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DLfqqbfv7Ac9dF0b4f7J0AefvH9xkvpqB5OvVrj7io=;
 b=ezV3ms17HEo37t8YcbO45TwwTy1CS8+YKaVI5+o/qUXkpiUZJxFlsLt1Yr/kOsFoENLBzvWuSAmRgxx9Q+qaqZqetcj5t7LnPEqe0cutm0w9i2B22wsfVS/QtG5E/0MdXCbCjzXGxwcadQfek7k1M49O8wEmM4y1aFsNSu2dGi4=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS8PR08MB6216.eurprd08.prod.outlook.com (2603:10a6:20b:29c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:04:40 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Topic: [PATCH v3 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHcgYoKprpjfVyo4kqROmUKDJKe/g==
Date: Fri, 9 Jan 2026 17:04:40 +0000
Message-ID: <20260109170400.1585048-5-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|AS8PR08MB6216:EE_|AM2PEPF0001C717:EE_|DBBPR08MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: ec88150e-3848-42c7-fe8d-08de4fa1531a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?+5rB6IxVcCEhId3xhZ/1/IpTai7r6rvja4RjpXRUi3JJeaUrzDlOiDjiqr?=
 =?iso-8859-1?Q?iPDrfja3Pf1JBarKkm5iB2Jgd9IFgF450SfY2rn0MM1/Kk4acS05JBLSOO?=
 =?iso-8859-1?Q?W0Zseru9ULLN8KKqU+nMeM2p2p0TZHZV1E8M8LG+OwG2MGOTlTu+8EEiPG?=
 =?iso-8859-1?Q?PFoVbhdfGclqidCN6GQkmwL9xvIml/sW4ar3EIW1g4+XSPuU9dFHDASmgc?=
 =?iso-8859-1?Q?cU9nG4G/j+N5fuOfRPFeM05wE6aiv9I4pFo+UWu5/uQcjJPYdSmJa4hAk8?=
 =?iso-8859-1?Q?BuIxBBvyUNQw80AT/pX/vO7gn7pyfqcQxndu7vdRJF56j0/SHnH4eQ6Xsz?=
 =?iso-8859-1?Q?MtjB78ce+PTa+h4VF/ul64JxtRdSfl+OYA+BHZ1IfiusTnGE50Ux767rDA?=
 =?iso-8859-1?Q?OPjRp70TTqezRaJeRn6jSuz4N1IRM62CDH0JnBL9AsEYeQs6aWIzM7MLFf?=
 =?iso-8859-1?Q?PXJMq/coOrCzAKtxm2eEX4jTS3Gzq5vLTsZzzKcRqFHnAoLBkXoJFcRdSO?=
 =?iso-8859-1?Q?qvO2if5mUkOCM1sfqoL2kjge7WLwxFDlCydTS4Sf5bwwmzNGzNVw6aJWmb?=
 =?iso-8859-1?Q?vbfh0rtcWvKOSzykxM/oUca9G6FuuokRw7GDntd9MpL60B+/VniL5WH9j7?=
 =?iso-8859-1?Q?eWaZD4nmVXi4ORdWVyi3Ax83y2HG6krQwTKocRwgmcewcxgP5PI9JJj6fr?=
 =?iso-8859-1?Q?OGADbefs5oJ/fQzMW4bNYxuTuiTNj/HL83MHoA2/XXqe2JTobyLkJNTRNE?=
 =?iso-8859-1?Q?przWOFjFZtWIZwANwCtF+fAfX3ZWfBC1jkW0lcfchGd49akFM2Iz/S9xDq?=
 =?iso-8859-1?Q?RPg9AQwAM89e56Hk8y0DUKiW6/l6JsOzG2/noIiQa9XvVNNKAjxpAKTsFh?=
 =?iso-8859-1?Q?aHpXw0moSYLMhOLOZW3luyv/+WFLpmVgJpeQuW9FSQxUlmVGgnUC8lK4XZ?=
 =?iso-8859-1?Q?5jNOti4j5I15Ekk1Lc+krI2L63g33OqSDfCkjKewJXlbttUlqo1eJCqMZd?=
 =?iso-8859-1?Q?4eRlzEKnpUzziPxQDCt91L44aURJLTpUVirhnYxeWhQPbWvY0NdL+q/NjY?=
 =?iso-8859-1?Q?b7cBv9h0pAKgzbj45/GegoVdCw151tZBGCkwk2bkC6/6mxrzOA7CPdnkS6?=
 =?iso-8859-1?Q?Wsq0TA8OU02YwDXhFUqrasXpWUQEgnwzEu4N9Ctb9O9/5sII1KzqW+LgsO?=
 =?iso-8859-1?Q?BfDbQzxvzDCuSQF0KpCQWyMlaR18IJPcZSQYV7Y/w8rO1a5H4kyv0ebyfv?=
 =?iso-8859-1?Q?VT/m4Bdt/eDLNFg+32JYSKXtmetPqjN2eEiOEUO/BUjbrqLtoA9Kvityo6?=
 =?iso-8859-1?Q?YIl0ZLc7yqcW3P3F90auv+kwQAKC2Q8B4MUnlut+jy7ZXw583RWZ4DsGAX?=
 =?iso-8859-1?Q?m6wXAh+aFYUjc5eVTUTdIt+qaixVraRqZlhMiRJXp2KkXBa6cnuaeDG7ii?=
 =?iso-8859-1?Q?02aZFYBYzMQghFpJY6PVceRoK90saOyewqHB7H5P5UtsyPeuPSD6ke3nq7?=
 =?iso-8859-1?Q?rWU6FXPf4tuU2SVHpukUh0bCTYVeCJZXxfYCJOzNmRt6bBi2RFGVl844yv?=
 =?iso-8859-1?Q?oj1sPwaw42Ve2E6ksqPXBLa2fsqQ?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6216
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4576941b-2000-4a7e-62e1-08de4fa12d84
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?6cwv2V8t1YwWMidaBlgxZYoJREA5BDFdyfsgzArQ+koiSrvGhJkyRCOpHV?=
 =?iso-8859-1?Q?QvPlqQHkIrLaBICCwPIrwmv6CKCx4wGvkowtp6/YbexxPMINqutmpwoviQ?=
 =?iso-8859-1?Q?w2ZQdC5ivLLCy4UD3sm9tXM619r6Qo5QNDDdzl+Gw5c+nyTFIqaEDbopka?=
 =?iso-8859-1?Q?U5GPGEQX2n0x7KL7zDMDnXm1DEqgxojdOse5gwo0ZOZNNOaIwFoJlDWqgl?=
 =?iso-8859-1?Q?Wxez2yskRpw4WnMS2yIS3k4j09sFOSho7aVJdYkM7vcOWem1/2sDYXuwRB?=
 =?iso-8859-1?Q?xdy+Kv422P+hwF/yx8HqQ5BxHoO+tu3i8zQC0cCKRYF5+5+d+WbGlMU0+G?=
 =?iso-8859-1?Q?ptCxt5T5SHgCDq8tCSTxNtggo+bwRZDp/aQPkMv51jZrWxUkGsytx5XkIz?=
 =?iso-8859-1?Q?yjIymxwnh0CuouJHm9fx6k7x/iF/yULvWxjNzO3fZJDFusciKuwoKl0JMg?=
 =?iso-8859-1?Q?mqGyKf81kpxE07slPGJuWHkGl0dWSXEvmiOhLpljemVcO4WTg5fQHIybBK?=
 =?iso-8859-1?Q?m+818ZK3g/9iwtn/piTblimk+SsA7Y0H33ngG8LQHQjuGQi3acP4fWYdUq?=
 =?iso-8859-1?Q?FBz7ArKFeyTVKdgLn4x+J/lYLl7hNQguogennv/5/pcgOssp37ep7eCTxp?=
 =?iso-8859-1?Q?0W2OA54kXuA7i/d93tubltVqx10fE2U2zQ/AokTb0zEZUA1FvBguU6VvaJ?=
 =?iso-8859-1?Q?tHI9d7qdPnnQ9tx+534OjglxQbwID1yH5naSGqtQmR7srwJhLiop9YAvf3?=
 =?iso-8859-1?Q?Xacxr5bZStdnOq196zjtCvMBGFtFdsAYHKYm5YMt8Q6AuZSbFAoESMKtrq?=
 =?iso-8859-1?Q?VY9beIEp+QdCrOxX51xQzzV6tTh+NnjICZa5mrDNXKu6BQj0BeY2Jso7W1?=
 =?iso-8859-1?Q?leR3eCRdT6BSnX7nBPlm0eU8SBGCENKhWG5kzQZWaTA3WlldnVI47CYio4?=
 =?iso-8859-1?Q?RuBDUdQRfyDudhE6fw3QFubounQwHJtsgJq/SorT3IunBM5nTXJDrQgLOR?=
 =?iso-8859-1?Q?Fve7vOoT6rKwZXoDxTJ1vNNp10p40Lh8u5X+kEjGtAJVPQOtb9T0YbApuN?=
 =?iso-8859-1?Q?/xgX6eSYi0KjEjPvHhKFZ3ZFu0K8r7ItSFkzG+SBHMZHgxukbbHvAM+BkT?=
 =?iso-8859-1?Q?vHKtEBfmad/a52tMp9Z19B2uW1bCt0q3jTFZkPFepX9DNJnZjNiK6v5pFA?=
 =?iso-8859-1?Q?FFBYtAfsxPqCSeVlOPktFaLHX+jv9WJDmJH/MeDIUldzctXXixkwn3VEzE?=
 =?iso-8859-1?Q?6TU6DrARN3BMlSwA2SFvcY7L+1RAWbMOKuSJRDl97tc/68y7903gXGuejD?=
 =?iso-8859-1?Q?g9A/k6422Ad1rF4nhrxKHqQLxi2U0eUIDDWJWJmrbhqx0qZG9q4baw8j8S?=
 =?iso-8859-1?Q?o9zGnOuFdUn/lPR/vQaaS68qY0IqrfsgSelWGYDCH/jjDLaZZye4vNol1/?=
 =?iso-8859-1?Q?tvFlf0IKgawf7ySKB8s0oaHuYb/TF/5TEl/Wd/J/Nrbq+QkOuOYMNmklC6?=
 =?iso-8859-1?Q?qMRumRu5uoA5qZdFPNon32Tzfhm5EtZ8pCdjaWysvSl2z0KX36+cZgPBWQ?=
 =?iso-8859-1?Q?R9iN5rM79zglYrrGesSo5U7/5dBrvdXPMHtk5cIs8HbaaZfR6JbSHdLid1?=
 =?iso-8859-1?Q?c2vPRPCufNvUU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:43.4833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec88150e-3848-42c7-fe8d-08de4fa1531a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6122

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dab5bfe8c9686..2f44a568ebf4e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3248,6 +3248,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3262,6 +3270,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3668,6 +3681,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4567,6 +4616,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4615,6 +4700,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4669,6 +5054,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4690,6 +5087,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

