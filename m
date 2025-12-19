Return-Path: <kvm+bounces-66390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE3FCD0D97
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 98B41300A8D4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331E1382BD4;
	Fri, 19 Dec 2025 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aAQz8PZp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aAQz8PZp"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013028.outbound.protection.outlook.com [52.101.72.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7445C37D10E
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160850; cv=fail; b=GloJ0rDsxHbONus65EiUX6zvhJRM/qQxUogJOmS06XAUEl3IbegQhj1Qgy3TIPfVgk9M1u9qYj+5kOKLy9Z8/OyspnML0st/E6z828+1+C6TgSlSImE1+lK6siO0LRBzQwsssdZ3YBgSPDZj3hXPou7cKP1OYCCRjJ8GoqlcO5A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160850; c=relaxed/simple;
	bh=4vcRpcsGIhuHW5TSrcuvcf88xoxPtGmOw3dWOASJRNc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HfxAtz0KqDVBhxhcsb8CuBG/ICdfKnMfQbeHdimL0x7tV9zrDxKntrPfg2iwBeCfQa7Iu7KW4XW0N3IIJubThslzNbI327NEKY+oyKskP7DAj9Z+Lbg/Qex5kpUHk97vb9HzL31a2sb7a3zGfN+V0eH4IKTUHSSxFUJ6jdJb8pU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aAQz8PZp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aAQz8PZp; arc=fail smtp.client-ip=52.101.72.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=KOmo1mqW1yzJ9U8FAZ5KC9lV/S8D78bb0i8EQR0w/R2H96NEYwr2a9XNhdYzfp11i8hwY3uwOox76yRvstkAKl8QARzdVA6KFll68gxisVw56CqXzX5CtwuGwX/61p/wTtqX9e8u/D0sgDNvIcwTTj2cN8/SMq+QHTDFjc43OsTZTz1y4wd2wnm8BdVCJuLm1q56gR4TFQIXNmciHC35lYFaFCSUZ/HbShVpjZTDeAJW1re5Dm8/7Vi1W5uw2WFL4lptHXNOmPY8Fp4ls7WgE6laC+r/4NY28A0jA6BTH0y0EZWMg5V0jMqHrYltL5Qzvi/r+H3+wJ3xXwdg0KzfKg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEWr6centLxklaYFY4saix1Xchlx3LWO7PpmXIaSiak=;
 b=IVM7RM3in9vBNivzEv+5oJc13eYd/pLK8GQGOLOF01dmoZ1kof+KBrr8Ox63w27tvR7XahzsxGgkMjUTw0iRG7qvDsGw26AE/+YY/cqDyAKj/P7w6YLgSzFaMHG3q4+WrvdIQHnF6yKcRhSJd7Hm0/Eciwqqm+qLiwc+SLMj3ex2VV9+Kih64f7aTGCt4PUwGh6WuitcY+csdGnwypKBdUhobCaHVufUxKEBiJ9FF8/cylwFOw8zsV0YyN4Jq0paj7VBezsmLyeviKLakn1MHqMnsL5dOQTtthTLecAWmdjr0UrsDw18KZpSkWRBbfcsmjK9VnysSnJoMJI0K37NHg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEWr6centLxklaYFY4saix1Xchlx3LWO7PpmXIaSiak=;
 b=aAQz8PZpgZ01NWHm4tbEU0KI0VqyEbG6whCLvFRYDqvLoFPqQR3KX3QSmZG3ELg1EXbcmnMOPTKy3ECcX1SZeDoYcNFTQG1VS3zcwMCUqO39SSXG5JSJzXSwCbc1nTxJN9mDlE6IgteDB5RUh/jEGdSeDIJiwCfaKF70t78DbHg=
Received: from DB3PR08CA0032.eurprd08.prod.outlook.com (2603:10a6:8::45) by
 AM8PR08MB6545.eurprd08.prod.outlook.com (2603:10a6:20b:368::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 16:14:00 +0000
Received: from DB1PEPF000509E5.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::d6) by DB3PR08CA0032.outlook.office365.com
 (2603:10a6:8::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:14:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E5.mail.protection.outlook.com (10.167.242.55) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 19 Dec 2025 16:14:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/ff2CLVi4Qbc4zG8VN1fvaVyomrHNkDn666x6VjD13bKezdF7CddPlp6cfiqQnamKNBIm4kTrT1CnA3pUU/E9lNzCN61ocCxS1p2pVTx9bRaff7NEx7cbku+64d9FNvq7kxqwPnYdf8sGs469ZsP7be2394puI8HX1xcp1KfCTQsW9B06mOxhaSkzblFrWvXbf5vu9lPrT7I7yimt4XFTc3aSo+KNb5XwkMG0uYBo6Q5tMgoG+8idTkQuyP6eXCSw/BKQxRVAMqsjEUhDkPvLQSjDZ+9vLM92KlCjeRSg3hRTKojkbEa2Oj+mOI9qN3WYhcrPyX8pZDaZmMonUMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEWr6centLxklaYFY4saix1Xchlx3LWO7PpmXIaSiak=;
 b=HsN8csKuV7uNCb5LiH2e3gJe5tf6T3gtoU7Ggp2vJKiBfpf7Afb9VChQPeYnDPmHhdPoUUHpqA/EBmwxsiv8b2jKqGklX6T9IvdliTWL3XKOLtLdF1Ug4xINOLRCl+8eDdWuHGGcoF2mDVm533hfu4f/dZZJ5JSjQwI2KhQgk3E7RoZoevxbtM/YQkH4IK1+VxeruWlHkA2JqpNWjUBCd/4S/9WB68053sriyxsW0ZVnbpfPk4P0oqNX0sSSuo3qLxY88x9D0mvbfB2rpOpZYnqfPjBBb0iw+hhDQhRywQ4bDw25hIqyUoLlWanAl/6Yj+i8QHASMCWm5mcAQ6qCfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEWr6centLxklaYFY4saix1Xchlx3LWO7PpmXIaSiak=;
 b=aAQz8PZpgZ01NWHm4tbEU0KI0VqyEbG6whCLvFRYDqvLoFPqQR3KX3QSmZG3ELg1EXbcmnMOPTKy3ECcX1SZeDoYcNFTQG1VS3zcwMCUqO39SSXG5JSJzXSwCbc1nTxJN9mDlE6IgteDB5RUh/jEGdSeDIJiwCfaKF70t78DbHg=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by DU0PR08MB9582.eurprd08.prod.outlook.com (2603:10a6:10:44a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 16:12:58 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 16:12:58 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 07/17] irq: Add interface to override default irq offset
Thread-Topic: [PATCH 07/17] irq: Add interface to override default irq offset
Thread-Index: AQHccQJWY+wcHvvG50yRYStCLgqRjQ==
Date: Fri, 19 Dec 2025 16:12:56 +0000
Message-ID: <20251219161240.1385034-8-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|DB1PEPF000509E5:EE_|AM8PR08MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: 731e998c-720c-4aeb-9b36-08de3f199eeb
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?OFzbNkLvwUrWXPmZ4hH+Vp9sHLAyH16AXrVu90j7rHpOqrSBxD0BIayukf?=
 =?iso-8859-1?Q?80xGxudox6DQ4EwQVLvsYNLxi2kI7oZoaAOc4btHVhDutIHauUrcLI53+J?=
 =?iso-8859-1?Q?CQuIkiLOwcdJCn6EZ6Ka8y0fGh7a6RxwdqqdYIpRMALHs0RkR6asPKV1sq?=
 =?iso-8859-1?Q?Kc3Dq+6SFctjQAcg2es98TJ8fBzrvVZ190dPT2Agbdlo7qIDc3Wf8UGQOJ?=
 =?iso-8859-1?Q?qXmjp4riB7dpA7yME+lPB4saGrgEFNb4q0IFNrNfLlnfTt3+i0pfUuGj+2?=
 =?iso-8859-1?Q?V58eSPBejcbIK7x9CpXprA3A/DbroTAu60VZStC5h6anmNXvmB0KBltKTH?=
 =?iso-8859-1?Q?vcafbzrXqxxaVzlNMzP5vXihzDO3+zxYSLxkNNvOxQfhh7/Jn5GgBbbplR?=
 =?iso-8859-1?Q?XW8w6QQ6NlpluBCO3t8S2ACk0yr3xVaVc4KIoCkri7o2n1S+RAH/IM8nay?=
 =?iso-8859-1?Q?LtNlWffCcSscaFQRG6eV02fVk2VVvCTq2NTEFxiFuuBylISRIKdhY+sZ3O?=
 =?iso-8859-1?Q?XL/g8/mG/uh/LEz+R5QJaAORE8WZoPnk9dsPuIpfWe00EjFK8QuwwKDFoX?=
 =?iso-8859-1?Q?ii0ghciEkKx0g28lLfKlY49j+46nOHUA/npIegioMeCyv2kG02CwHk8w7w?=
 =?iso-8859-1?Q?dSeVimc4HfURp4FEzFtcj7Rit614b2kpL0UTwT9RdY5UquD9tU0+vs9JF/?=
 =?iso-8859-1?Q?MtqHo+hzARbwYivpaU1SQKzDJXnxyTkx+87GHx66AnFuXkakaBFDOv2CwC?=
 =?iso-8859-1?Q?rPVG8GpNepkK96u4yXxb76e/gaB1p4KPFcG+PDFlEDo1qK/t3J4/lV3mK1?=
 =?iso-8859-1?Q?2iAOy61vVCQZhKNldAJaQkSd2ouUWi6hhEm6DOmtQLOTBSna7bgS6pTi2u?=
 =?iso-8859-1?Q?V4x7mYUyYidjYhxGjTTaHEuF1c4YSi82A/xXd6nnf2zWbHuIKl9ag73gu1?=
 =?iso-8859-1?Q?/ZmFkmk/j54Ce3Hslw0ynlQsHo6TGB3HImtN28cwFMXdfVkdwyJWE4852b?=
 =?iso-8859-1?Q?BrFF26pJbowjW2MEBVyiRve9xthVNsRRS0S+kHUrG+7EkQHw6pzfdJIWuL?=
 =?iso-8859-1?Q?Bj5bTx9kCn8ED1exjvlqHrmJCEk95CULkQoxRZkwKuNu6poWFsownXYPpF?=
 =?iso-8859-1?Q?Zgt2HZTBorrnSy/j5AYy7q44qF9ksFARQix/3YzQIBaooEBbYAVU3kht8/?=
 =?iso-8859-1?Q?csww4Fhz/vFdF4XQg6iDwdqiyiDOO00TphzQMeK5awssJnzN8YOkAUrMVb?=
 =?iso-8859-1?Q?dF1g8uABlgta7rT02rVIcyj+6AtULsayDKvF6FfTCFqtoz0R5MxTk3Hmbz?=
 =?iso-8859-1?Q?IRq7OEd3paEgMkcJ67Gs53aBYrWb53uafR43oMH4wrYPzvSSp8TivZfEtd?=
 =?iso-8859-1?Q?8rk/zM5qTbN9FJ11mKXPOJOtA1DfiBQnWZGeQMHZib5ggTih1A4/yZpY++?=
 =?iso-8859-1?Q?LGCUuOrTkICwyQdaUJkA89TG37Qnc6bvFMGMxC3c4F5jLcIa9kyBmDF75j?=
 =?iso-8859-1?Q?QNZ8SD0YpJ7nOQtcXBzKeJjxmlysQZzHZfmWwGAEDDPgYzDlv7uyj9aXQR?=
 =?iso-8859-1?Q?+f2Z+dK3VvR2qCcDFlTBqBlDJtd+?=
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
 DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c729d9c5-4236-46d5-dabe-08de3f1979d4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|14060799003|35042699022|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?FwJPhXxRpbU4Ya8IgCfULyPq8KN4jPig8Lf1eOSi81x0jpInJf+gPnAa/A?=
 =?iso-8859-1?Q?hqgZscT/s7eTvLQpoiVNVhWTkf6qakEocYWH6qSIvL21n+IjAGgIjCfZMr?=
 =?iso-8859-1?Q?AVbOYGvP18YqlQlrbg1pT8s0kq1DbFRaAYKjnvK5IeDhY7LA0McTrN5Odi?=
 =?iso-8859-1?Q?rniIZ5BhosYDMglE3W3YWfVgwv9t0GCFPW1lSpbmpvhR2YTSJCtFtyRfCd?=
 =?iso-8859-1?Q?HCYY+hh2kpRCjCgmBpL7Gk8ZW1qp4RAg5rYfBbkEpT11/iVNVDRZfKJGiO?=
 =?iso-8859-1?Q?DW37yPeU+tEvTI2EnbaYFuqP/e4ggufgYGbdnrBSbuy3Divf5IYd4om4fu?=
 =?iso-8859-1?Q?VkBNUmxyrYHAgSWxDcWbHyo32mxM+by9RudFKXmVw4zQuUR1qvxxfh/Lck?=
 =?iso-8859-1?Q?rYtYWtejHJ6ULqFtassjjlxchB6xAM8IZ79Elp+jkjN4MB9iQYk4TZB1iN?=
 =?iso-8859-1?Q?yfiTOe3uWRZIs4FQmwc60RteY51bJrBOWihRdQxWfcmqxRnmg28/JUqjRK?=
 =?iso-8859-1?Q?D8YYTjAxGUtcFcEI8Or1AFNI98z/Bvhm62mS2iS9gsutzd4XRfSxZ8NYgP?=
 =?iso-8859-1?Q?xxwM96nFmzWWK90cl5dvX5mCPA7CBwvDk5kr5SDDvXLl0muCR4iAmGbnEw?=
 =?iso-8859-1?Q?ejaWtLs2ii19XlD3cKa8ktR72zeNKkNEq9m/532JyW0UB0LvMV834U07de?=
 =?iso-8859-1?Q?opSA9R0PBfv2/2ssc+ZCoZcN0Lbc8ajQHsHJ5rztTkvWA7vUFznGrsU6oR?=
 =?iso-8859-1?Q?RB83JbmDT2VAbdUahyFF3bLAzeip3h+nsge0AIA/sHyC7nfGgJKsrr5jMx?=
 =?iso-8859-1?Q?nPD6r6wYu50FeSucJdIMDH5W9cj1YtUIh1oZ8qPzKsWpTpr8LZkxrabCmA?=
 =?iso-8859-1?Q?QNvT3wsShUr+EBnYv5RQWxDuXGwkFVY9DHObQErGqd/jcw/0DmNueGSNfY?=
 =?iso-8859-1?Q?32NwM20qHut5eSpk2hobz7WbE/Uqd94fRBWXxebKdVTf8LlHz6Iw1n9sJm?=
 =?iso-8859-1?Q?qCuqEVq98FM6343Pa/X94WAh6pjD0z2NTgfMe1OMUx2GtySOx61Ki5v1aG?=
 =?iso-8859-1?Q?778t988nLdmOICWA99WweoKPQSV7gbXaZ1uW8V4+NGxjC4khz8T3oN2eQ9?=
 =?iso-8859-1?Q?46rtAz1ZBuhp3lNio2BsEzjaCzeK+vqNow35uWXfmzNfV3VLWKb5AZEKN4?=
 =?iso-8859-1?Q?UrYiqodenIdxNE7A0Iw0g72hITAveMwE0EtvY5ZIealziCGtEd2mwlDnWb?=
 =?iso-8859-1?Q?nXzaAvSBpx0RE8a8Mw4erVq8/eOHSwYi7jMop95NQYQ8M+ImXOuNhurAAF?=
 =?iso-8859-1?Q?oRgCt4Sh685VdwWiZb6pyntUHNqlR0LtfA3YZ+8JPQgsgObof1HtBZC0TQ?=
 =?iso-8859-1?Q?8cJFAPWvf26IC4rpG9WMWttaAsdKXsIZ2ehhqlPFuJh52AGzgojffFFan0?=
 =?iso-8859-1?Q?IeJZvxXXLDm0VC1nE5HgZsAFe0rxK0yqRQURW80po/FRYgfUdj2+eTYvOm?=
 =?iso-8859-1?Q?BDoPwL5zEdltb87SHYz5jbLTYHLeU8FcKyZd6L3AMT8zVot26fmFocm2aM?=
 =?iso-8859-1?Q?emg6QReHYjTY6UqH85FOKnPtYbWqbLwsEHdo9POnFPomXLU3SrvQVsz7+j?=
 =?iso-8859-1?Q?xkDcVL5oUqQuo=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(14060799003)(35042699022)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:00.5181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 731e998c-720c-4aeb-9b36-08de3f199eeb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6545

Add an interface to override the default irq offset (KVM_IRQ_OFFSET)
as long as no interrupt lines have been allocated. By default,
KVM_IRQ_OFFSET is applied to all allocated interrupt lines, but
calling irq__init_irq_offset() prior to allocating any interrupt lines
allows this default offset to be overridden. Attempts to change the
offset once lines have been allocated are intentionally rejected.

This is part of GICv5-enablement as GICv5 SPIs count from 0, whilst
older Arm GICs count from 32. Therefore, on a GICv5 system there is no
shift that gets applied to the SPI ID, and hence we need to start
counting from 0 to ensure correct alignment between kvmtool and Linux.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 include/kvm/irq.h |  1 +
 irq.c             | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 2a3f8c9d..17113979 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
 extern struct kvm_irq_routing *irq_routing;
 extern int next_gsi;
=20
+int irq__init_irq_offset(u8 offset);
 int irq__alloc_line(void);
 int irq__get_nr_allocated_lines(void);
=20
diff --git a/irq.c b/irq.c
index cdcf9923..8b9daa91 100644
--- a/irq.c
+++ b/irq.c
@@ -8,6 +8,7 @@
 #include "kvm/irq.h"
 #include "kvm/kvm-arch.h"
=20
+static u8 irq_offset =3D KVM_IRQ_OFFSET;
 static u8 next_line =3D KVM_IRQ_OFFSET;
 static int allocated_gsis =3D 0;
=20
@@ -18,6 +19,19 @@ struct msi_routing_ops *msi_routing_ops =3D &irq__defaul=
t_routing_ops;
=20
 struct kvm_irq_routing *irq_routing =3D NULL;
=20
+/* Override the default KVM_IRQ_OFFSET */
+int irq__init_irq_offset(u8 offset)
+{
+	/* Block attempt to do this too late */
+	if (irq__get_nr_allocated_lines())
+		return -EBUSY;
+
+	irq_offset =3D offset;
+	next_line =3D offset;
+
+	return 0;
+}
+
 int irq__alloc_line(void)
 {
 	return next_line++;
@@ -25,7 +39,7 @@ int irq__alloc_line(void)
=20
 int irq__get_nr_allocated_lines(void)
 {
-	return next_line - KVM_IRQ_OFFSET;
+	return next_line - irq_offset;
 }
=20
 int irq__allocate_routing_entry(void)
--=20
2.34.1

