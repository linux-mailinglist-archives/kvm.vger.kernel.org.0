Return-Path: <kvm+bounces-66388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2143BCD0EAB
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 709D73070ADF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FB8382560;
	Fri, 19 Dec 2025 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bgWebtmD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bgWebtmD"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013045.outbound.protection.outlook.com [52.101.83.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E437A3EF
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766160849; cv=fail; b=C5Qylq7m9kJQ62I+womnqruWFRqPineoTcyMa9OfeHKVGlUynGi78inCZlqYBvjl7RqNEDEjiYjlYzkexuPECp/oqesVGIWBAlZjarT0Eto4RlVA3nred7/UBJFBvuGAeADuC2sgNUQNJswaibxk6079/9GuZhUT9uH4z6SEy1E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766160849; c=relaxed/simple;
	bh=ThWkPV4AO7UEnuB/VkUz0Rl9mFlMdhvydOs4PhGJM8k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oRKYqL7VKy25Kt3DBWfAuAoqSFHhdUbVjJeCVUo9J1NBT+MlBTEAH61Dy3Mu1fZMcZxZa4dVxiVfJrrQQ6Sso2ZDI/dHzZzU5AP9llWMSD9Xt0WfqSs2Qt1XFUMtyRgA2YDpwhLg0wne1E6pAXBBfASb+XHZgqXcU1Yyp6sNO18=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bgWebtmD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bgWebtmD; arc=fail smtp.client-ip=52.101.83.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X/nSwvF9yB2K69S0306g3ICXpJqPf6Vfwr/ZZYSy7RWNUymoOSyGkrB8Hy7tUgpQSaJ0ynJBF599+C5v7V82oTKymneNResPwIi4zRdJP4bdTi66wavZO3rw4wULqoJd6OYYVyk8bDcygvV1GPiCa0mBdMNF4apQCKIt3enso+EDVJ9+bRnU0La6XyuZSigv/HsjfhVcGvyB2p9929XEY9ZALztQQLAAyzMTIUWkB8+GElkDcBfGV7b9BrVW3humgbzj6nmlT/9mudGL7f1CE+1SOXk4hkiyWE7m3MZ8zwPRJRk6wbWaMPmtGycsXRYTkAXKZ0bWRoxf9+PD2/hbhQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=j8oHVbkCL34qu5RN5SBsUv0x5jK6vr9Dz4PEOAKDLwSIJM5tva+jkM/jL2G24XUnnvwSQSy8ZYaXtOH7axGyXyL+RDAlVtBmDCOJWgQdDh8dUNWiJKV4v2esDt9J2KRPICQU/R9AEzOi1JsrmTXRrJDPTl5eH5JRAKFJheiAC0FsJ8IIeH4EWPIiV4Q8ZvNJcU6iWJzEcNg21QxZ1nUWMmxktV8HaAb27VO9981IAeImJwaZZDlHwm8Uhl+IJ09C5zuUlFIrTvYzvYmcj30FnJA/waKpv+beu2T3HwB7P5KjSkLak+/8giDZSbrlBq/NYoDD6kltgZisqr4Nmsnfuw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=bgWebtmDcw5dwui7AusSxHeCywA0NE2G0HH+gJM9R971jGvLejLEvSRTDPo333BQ2GGZi8w6u5XHN4kQaq5mMAfo7im8YVjiYAyRrBoPA8Qi68KsIvRp+PtyWUb+yebtg9uvwtj31plWc0QlTU25Uc5PrY1W6uhakctxvge7HA8=
Received: from CWLP123CA0128.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:87::20)
 by DU0PR08MB8162.eurprd08.prod.outlook.com (2603:10a6:10:3ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 16:14:02 +0000
Received: from AMS0EPF000001A7.eurprd05.prod.outlook.com
 (2603:10a6:401:87:cafe::a6) by CWLP123CA0128.outlook.office365.com
 (2603:10a6:401:87::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 16:14:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A7.mail.protection.outlook.com (10.167.16.234) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 16:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FjU9EYwuII7sCBmN5oENi+9eaK8DdDvRvFozAnDLfGf3TiI/99AyE62Q5CCio4rDDXrt3jUk5aJi7wqnelRoxEPubyHKBvmvEDVCgdl/3IhcCwUZc7l304tIUlTUS0d3ZDgmiRUi/4j5JrLciXoDStBOXiog7o12KHR8OQUNzqzzsQMlWoaadd0zj1MR1lexbQVvc1DpdBBovljuU6Fpx/VAWgvgAGX2PhnYI69HPZZ8AY38FS+zjnLLC1f5gq6KHNibkVYdxpqQ8E0fkfCBLKf+bRG/0K2Qe3UoMaAcskfG1LBHf9mi/7y/0blLE8aPU7LGlUo6LNGx1XbmnkULFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=XESeiwQCMXmdsyRDBaaQu4eLuwThhDCe+jYQhzxVVL6qjljef1QeOFFmgNEfOxreJwIrTwHKNFF/IkvRpdychqK6evTIK6fBmV5gq9+Bk4maYKU/5qNbSwf9jr9rHRRK5KvAcRbuv1Ct7FrmUThCLi/3uxvQ32FooxP7aFvfbWHpg6Qjm/yYxylUWI3fIlpOlF3NjzZIubCEB8NWnIOoJPVXY9/jKubgubDnk+jvIzsPJ0Jd6dTukxF2hcvkZ6nDGgMLGBbT+NDseqDXhshvJ2TJES1pxDMsaDNxQS4T47NMaTYL0YXlYltyDUKGqyQTkhoS1MnX9D6r2YfqGcN0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWycXWjojEqGfOpaVzub5nUMA25/Aantlx/ERnIItTg=;
 b=bgWebtmDcw5dwui7AusSxHeCywA0NE2G0HH+gJM9R971jGvLejLEvSRTDPo333BQ2GGZi8w6u5XHN4kQaq5mMAfo7im8YVjiYAyRrBoPA8Qi68KsIvRp+PtyWUb+yebtg9uvwtj31plWc0QlTU25Uc5PrY1W6uhakctxvge7HA8=
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
Subject: [PATCH 10/17] Sync kernel headers to add WIP GICv5 IRS and ITS
 support in KVM
Thread-Topic: [PATCH 10/17] Sync kernel headers to add WIP GICv5 IRS and ITS
 support in KVM
Thread-Index: AQHccQJW8g0Rq17TJkqhsAUCoIyPfw==
Date: Fri, 19 Dec 2025 16:12:57 +0000
Message-ID: <20251219161240.1385034-11-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|DU0PR08MB9582:EE_|AMS0EPF000001A7:EE_|DU0PR08MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: b4630b54-c78b-4710-6ef0-08de3f199fc1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ujYVPZukPcbIF6E/1KyYrSIsZEeiPsR7kgxuVbY2gYvPir2cRYfbsRxXAO?=
 =?iso-8859-1?Q?njYP+wm+/C6efVIsu6H+CgNPQB/g8FhocWiSi1SgxA2SYvxF8woU8wY9Np?=
 =?iso-8859-1?Q?TLZ/to2PU8IcI2GGq9Bkgb0+tnH2fD78HI/+oask70QaecP5CcJnhlN4C7?=
 =?iso-8859-1?Q?6+wgsE5OGbaiMEgqKdCRTMG/2Fy1itIIzfZKMP2mpR7flTindoWHX+KqWv?=
 =?iso-8859-1?Q?fpGxWhUMDhwkmITxNHa8fePtOatgJQ/4J4ArwWMc8iPzejQllFk8DCZbMr?=
 =?iso-8859-1?Q?kjS9DUSfq30jIpLQvHRWns4wbfHQ9I4N1o0irBELr+Fy9gdA6vrPZIXMZd?=
 =?iso-8859-1?Q?H8uD9W5fsoaaUFnPSMeMmFlBOH5f6WKSBtisNM+Ra1oVwlETi2XQ0LYLoG?=
 =?iso-8859-1?Q?yzuAehVCgVaZNWZB+x6Mep6HGLZZhstncg+vN+svskrVJBer9Yz8RfTZQw?=
 =?iso-8859-1?Q?/OjiiUbGr2FWyrdt3zybSS9LyOmrBoXBOgvhM/zWPCgzcCJmYidS8uwAGh?=
 =?iso-8859-1?Q?7TzedKCXJGbTyTYbEMaKsdebkNRYRbje3Q00CEx4piuSO76z+vXhLDOAvi?=
 =?iso-8859-1?Q?3Zpu6CPWajhquuO8xzCW1cuZ7FKbz5gAx66yYcoDmaM27+eImbG3ZmE/35?=
 =?iso-8859-1?Q?Wtwl/d3/rqfn7ijP/b3VJ+wEDoNZ7mGisWKJ/zCTtz+tcDCaLigOrG6Axo?=
 =?iso-8859-1?Q?qSxeIa+0VaGV7CYWWi+E+DfLfpA5rS59J4er/OsmJ941Ih47RW+kxIbnq1?=
 =?iso-8859-1?Q?X6bYAxego9MXpE0oPxdiyKIE0PLzkZy5cMeYxVhvXjpKtuTd8SHKvHHXut?=
 =?iso-8859-1?Q?grB0IadJ4ChdGHnZCT2CAZaKU0v4JfulMJPkaec2Co2BYg09Id7jv5w4mv?=
 =?iso-8859-1?Q?0dpXRR9aYvfE8JVRHAFFsyo/uLHeo4hgcgzZuRGebLzUEHqSzuJoEnbJzD?=
 =?iso-8859-1?Q?KJENwHxUOeUYvos7/++m7FiEhaTVyRXQsed0TchLesY0Tr3DbjMcC2z/Cu?=
 =?iso-8859-1?Q?veQrw2syh6jlUu+uSiomSFxggoxKobfl8be/2uU/s62Q1xpYAqY9WMHMUX?=
 =?iso-8859-1?Q?dI3qresvdJczlGLBXwBqj9RLSMhhcD4lOU4FEceydBwGFjutbY19kwlHxA?=
 =?iso-8859-1?Q?cuzZjl0+anzFYYFtJZ/BBr2J8DLRb1TKdKr7b4dgb/rd0DChU0n/gZnR5P?=
 =?iso-8859-1?Q?lblKBptq39n2Jz115RPylvMmew4kTmdo9iFQNvpXRm/LoFvanj1j0F+bRu?=
 =?iso-8859-1?Q?Unp+ccERRKqGWRpuIlXT54hi8pYkDJhZIEKm9gPCId3mmjO7Nl2YxujsqH?=
 =?iso-8859-1?Q?mVp/9JPyrgo++yMu30bHa+XeBg5vFC9lBTaXwHGj+tQCDz9J+yWOz90YJe?=
 =?iso-8859-1?Q?FcqEcK54kXBPPh/znf/w3UXuEf2FJFZl0PCC/cH/XIgtZoq/oF21M2a0M4?=
 =?iso-8859-1?Q?aqVl/fY3veQA4Dd6CXyGUwvUppTq7o6Py0R5Wzg/xOU9ynoj07jujuwPRM?=
 =?iso-8859-1?Q?hLODoQUsE0OAXUETFQ4SgD5AqQ3wByRn0WBwiHjlDpwCkIbVgPPAfhFjv3?=
 =?iso-8859-1?Q?IBYyCAfKd2SwCK3/yCBiNYEy6pZs?=
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
 AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	86323023-c6e4-4d20-7061-08de3f197a6c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|36860700013|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?GTpV7NUPwOmkxIS6p+2SQwDDB4qd6g0LIYgFItqLC08o93PgeLf4YkRVBq?=
 =?iso-8859-1?Q?YejXv8dSp5r76rk1ObsNEwmcvHWG/tIQe3wAAx3G6ePIxbrpVxiCmNlPp1?=
 =?iso-8859-1?Q?7jmy3/v+kExqeX05dzbChVMppBsbJ9d5P1758hAbVchLe0+O4+/YA7vm+E?=
 =?iso-8859-1?Q?58g1C2tbH8dZPKi5baThWuYGkYbJ+YkIsRTk7BzcOCCaAuxD1z34wKdbbe?=
 =?iso-8859-1?Q?oO4Bux3KxztQjY8yruAwRDmj/pUH8kpo4R2CsOyKkQpLMy/l/YB8LbZcS4?=
 =?iso-8859-1?Q?THvVKFXMVh66HsEom94OwsA9RDbtHyOXirYJiL+nNu8xGFyrHrR8J97Uxd?=
 =?iso-8859-1?Q?NOpDUbSwiOPvLPVQJ6cJ7W/py8QNjIi5kbwn3DX5zrztDZHQqCGZeQWewY?=
 =?iso-8859-1?Q?zg/R2deykE+zVvdpZzqCP0lRjwNYegcDZZxjyoJ7kDgApS/WV38dcPQ0VT?=
 =?iso-8859-1?Q?EODm+wP0h1rL/L5Q1UtSmzcyK4/ZCBs5oRG1RULMcHpVoCsbpv6S6LrPp/?=
 =?iso-8859-1?Q?rKdZv992XUqRROo5ljIF67TbeLMcnJ4MsSfDOZ/omq14gURhylygElukP3?=
 =?iso-8859-1?Q?bv/RnTrSomlKsXgOhetSHqir+jTlbavuQBDQbDwjyZjiNAMRvJPnl56rwl?=
 =?iso-8859-1?Q?W6qTZruTHrh2BEwiVMu79bQgemuxIrKMUmaarx7A12yPNc9taSoFgzQKRZ?=
 =?iso-8859-1?Q?Qro1GaAj9Aw5RFq+PtCsafz56XMcwyLELo4rSmaFJ2VzZjZSHrOrWSnna7?=
 =?iso-8859-1?Q?KnZ3zFy2Mz7zgaJRFLWbxUW9+cGKTVBf2h4TGwjIby5bDWXK9UCaRKkMMV?=
 =?iso-8859-1?Q?A644IadiddJVShKwokG9iK1X/xifGKTExI9T7TC/IVUKGVaodWd+KuGBDL?=
 =?iso-8859-1?Q?G1VFGOZ0WNV/oZ4aS3Zre0DGRVIzGm6eX72cE4Bd9TM1O/VShN2NmChiJY?=
 =?iso-8859-1?Q?DNe9BcFXw5u3K5jcJH7Hiyumr808FBN/Q40UOnGUmYQQl9uVN3mGERgtzf?=
 =?iso-8859-1?Q?26UTClrpe1UMKRH+5yVU3I66jbLd97EY2Dgk+yVJmRSv4DmzKiIvXCXLQc?=
 =?iso-8859-1?Q?p5260yc/FBDOqoE9JpVu/GwPmGWwRW2BIfma/+NnouydYc+NNAj3c48YYs?=
 =?iso-8859-1?Q?4iXJjPUq4P2aDYqrPAU3ULPRlyYcrhboFaPjjNLKd536iAmRD3RxgWF11a?=
 =?iso-8859-1?Q?vEnOFpJCChY7j/cmK30hDCBV5cQW8YjJELktoOwaFJo0K0W64E+YWADhad?=
 =?iso-8859-1?Q?aat66yRvQaiYivVOyTihTMLU9L0O9vdCYVcqb6DVDd3lXEhwJmH4euuteo?=
 =?iso-8859-1?Q?kOUw6HZ1qpzKwQJZmKmoKWRaCMmfL7P0hd5QIhuXRsN90z4NUMBYjOGy5J?=
 =?iso-8859-1?Q?DQuHwqZdN1w2xqdcU+Va3JMO0pz7dAjVxwwbQr6yLFPTS3rVLMV+yCD5cX?=
 =?iso-8859-1?Q?xmRwyCmAbc5JsHElIYPJddGp2bhSPSYOpQ+cDCglRMpl41XT8tMqkmmsmZ?=
 =?iso-8859-1?Q?VmQk1Xy+dw8R/+PGnK99IwNARXBYBWLBXfIgXwoeJQbkO+yqc32+Re9Q6s?=
 =?iso-8859-1?Q?f+bWYOFZbseZl5cEF1MIvb2QrIpWsysMjx1H+JHEXOFrhwfvkxl/WovfLO?=
 =?iso-8859-1?Q?rUUO1SOgQeUoI=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(36860700013)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 16:14:01.9240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4630b54-c78b-4710-6ef0-08de3f199fc1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8162

Add in the additional changes required to run GICv5 VMs with IRS and
ITS support.

For the IRS, this adds the ability to set the address of the IRS and
do save/restore operations for the MMIO regs and ISTs.

For the ITS, it allows the ITS device to be created, the base address
to be set, and again for save/restore of the MMIO regions to take
place.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h | 9 +++++++++
 include/linux/kvm.h     | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 1c13bfa2..6572514b 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -97,6 +97,13 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
=20
+/* Supported VGICv5 address types  */
+#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+#define KVM_VGIC_V5_ADDR_TYPE_ITS	7
+
+#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V5_ITS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
@@ -422,6 +429,8 @@ enum {
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
+#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
+#define KVM_DEV_ARM_VGIC_GRP_IST	11
=20
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
 #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f7dabbf1..14292051 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1210,7 +1210,9 @@ enum kvm_device_type {
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
-#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+#define KVM_DEV_TYPE_ARM_VGIC_V5 	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS KVM_DEV_TYPE_ARM_VGIC_V5_ITS
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

