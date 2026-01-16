Return-Path: <kvm+bounces-68373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E38D3844A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE60831457FD
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1393A0B2C;
	Fri, 16 Jan 2026 18:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YbTZk39Z";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YbTZk39Z"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010032.outbound.protection.outlook.com [52.101.69.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C039C634
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588071; cv=fail; b=pff9ynLPpil3rp8dX98GySrL1N/4pL+hYv3SrvgFtu/S9ERt5FNzU5kvnulbI21ocWqfYPV5YNkAfWhrBJTlIZcnJwkooGWjwXJ/cUDR8XL9xdS7f4YW46M5k5YRMGlXBEr89dCz0S+00Ihv2GW1hqcCLcw20hfljtohEqzHsfY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588071; c=relaxed/simple;
	bh=UhNl9RfdpWm6egOLBxdeZoZVsaGX1LwDsI0HoANCu3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TxuBsPPzdcdNrMTzBBbfNU5xX2Ou5NrIOC4k+03949Oqb+5x9LFDGW6eJMlqMO6uzBJygFz78/c4tkR2ehC7zmZTulKDcUQ5fJ3mdCR8Y7c/uWJhg2Z8oKl6G0th1vOuDvEZXqgBSY+zXWcoTBFvDokqPHOINT7tKZ3p+lcTcOc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YbTZk39Z; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YbTZk39Z; arc=fail smtp.client-ip=52.101.69.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xrdNxlUwqGvUyHbqz19x0Oe0axYcGG6qA7A07tgPqDvuCF3DEqViT+L/nN5o0WS74JBtraTZaFdSk3YwYx1+L9Y4OR8l/3BOIYcf0Fn1GQieZblb/c20jsbjwFtBpvDWUyzaTRUbuSe+w3W1kKFa3KNfl0BPaPuGJoxdB3yijxGzEF1ppo8/AWl9FEgpR+pKEgfquiso4IVNQqm4iJsP8sstMiYP3JMuwvKP2DLz5GqsiHSZYRbEkPl4wQs+d58o+W42LKbHvjeVQXXF8Byk9yvAE7mt2FAvxKQ9UFqcRFMtJgUd1p2rPCtRDvP/ADKywwdV9Y15C+zAmYnjPEEDLQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QA0e950tAlS/qphzrlLMjX4tDcwmOzyetuCKRxqyEfw=;
 b=rVFmVPj3SfWTEARq05T7GowyI+Or9WCd9edWzoIVu66RCUjXIe7OPcyzvFwPLHBHC5/P5sPk0oVx5+aJ+dRjo1h6uFQffKIB4ZoFW3MpnIwf4hKAC0HkbZhKIhzD+MJVgwZap0xh0LqOLxTy5VONd6hQ0bGRj6sbUVC6IwJVOk2bft9VudbTqMtFqKIIVbzhpwQMH95mLnr05/FAdKGSZKLLeuFt7ael/fmFJ1nZyvfIJ9Gz8Ct1cshISses44zi2y5B73WebFEn93Eg4XUL3eRCLdXvLBGzjGx9VJDBPYQFmk9dAJmWBOFHUdbzQ8H+wk7bQ3ZPulKyY3fNXd402A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QA0e950tAlS/qphzrlLMjX4tDcwmOzyetuCKRxqyEfw=;
 b=YbTZk39Z1xKgZdvOpyPMmC5nEG2/v20wdIeV04fQGVfz8ZKCItr8mmDGBo/OKELTAZbLCmLd7RKYza8zib28rDFzknrO58ecyDvsUSgbSYobyqIjqmft56w7QoTZPXu1EoFAAL+B4QjEK/zRT1scs5wuJVUhrlWLRF9S0KjbEYk=
Received: from DUZPR01CA0080.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::9) by FRZPR08MB11023.eurprd08.prod.outlook.com
 (2603:10a6:d10:135::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:27:44 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::ee) by DUZPR01CA0080.outlook.office365.com
 (2603:10a6:10:46a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.8 via Frontend Transport; Fri,
 16 Jan 2026 18:27:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:27:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YxMA6n9Y69SBQG0UoS6LtJo4mFxk11EN4Bp/AzBX3j7vuPvS5t66RPYbMrtbe+X7fTKpniyEGZB6Zd8rAT7RVVAfUPGIXV8v0BsFvLauF6KjLZF2IYbZCsUrD6DToCQz89ZrhIN3HOSvTXmOpx/F3vVVy6uLSg0F1WkYD/iMPiTkoBrITZOFvtRhCMG/InbRCEEYpQWZ7MBKfvGcd7d1XwLtCZcv23LMo1Idgk9uigpbG+ftUFdduBHb0sLcdUeiLNKzU7au9Ps9EcQTDDychbHkUoiViO0KfSO0owUCzCtpZJ8RPHlTm/11S/Y+B/GEbiY7bI6gTz3qcTh/oE27BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QA0e950tAlS/qphzrlLMjX4tDcwmOzyetuCKRxqyEfw=;
 b=YCkkpLzcAvn+xfPrJJq2MzI1Wq0ApXF7hTV4YGczos6BncOdVj0iv1NtfLh/Nq3PHEF0YpsW1jPxX6Aa5eYyJ+qVEK4++VQe0CslVPHa0rVo90qzT7MH+icPWT+iPKu6tNhU9z4/i/f1fylYejHVzzQ+UBG+33VeZvNyPJRbDyXvqbqLueozKoyTmhaOSZFDiFOJ+HA0IYZTvu9g7m8jOl1oWoUu3WIN0+yf31EHhXTWvYK/QAAsnitvcsF+vyhwS6ZKuMS0nkApkAwGumwPZjMkRSBTcNL/bsUiRUijJYG2V/12vgF6Ww208Tq8WGbfoJZ62aL3ALwmDV6FFh+kjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QA0e950tAlS/qphzrlLMjX4tDcwmOzyetuCKRxqyEfw=;
 b=YbTZk39Z1xKgZdvOpyPMmC5nEG2/v20wdIeV04fQGVfz8ZKCItr8mmDGBo/OKELTAZbLCmLd7RKYza8zib28rDFzknrO58ecyDvsUSgbSYobyqIjqmft56w7QoTZPXu1EoFAAL+B4QjEK/zRT1scs5wuJVUhrlWLRF9S0KjbEYk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8731.eurprd08.prod.outlook.com (2603:10a6:10:401::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 18:26:40 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:26:40 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 06/17] arm64: Update PMU IRQ and FDT code for GICv5
Thread-Topic: [PATCH kvmtool v2 06/17] arm64: Update PMU IRQ and FDT code for
 GICv5
Thread-Index: AQHchxWoUNBzvTHTEEmrWNOlqRMsWQ==
Date: Fri, 16 Jan 2026 18:26:40 +0000
Message-ID: <20260116182606.61856-7-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DU0PR08MB8731:EE_|DB1PEPF000509E8:EE_|FRZPR08MB11023:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f02bf9-8ef7-4828-f65e-08de552cf0d7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?NjuKmQnxw2Tya+nYNIt5LsUfK8bq6hMuc8xxsol5sQDGQsQO2y9TVStV26?=
 =?iso-8859-1?Q?JWSWyIU5TkeffUV03qDWzlVmtzfD39CWUgQP4gTk2g4DJ23kbAaDQKWdUl?=
 =?iso-8859-1?Q?xQvDNGG/mt2OUpOzl8x2o/mH5erGM+sskxGHHffBnyq5GT5I5wnTgUrBzP?=
 =?iso-8859-1?Q?xA98rpmBQajMBTr1ZmE/dF74wSLRGTEyOByK+jxMs4VIpFvdebIGLTVMjd?=
 =?iso-8859-1?Q?QX/JipDffOOYx8OWCUYVWPOZDr490w/PlgoU3a2vbINjTFy9Xb278fqLi9?=
 =?iso-8859-1?Q?/e08A4R4e+WwrAOFysFbjC2AT9C0QOkbg/PtA74kN0T9X2jIZeY/M0KVap?=
 =?iso-8859-1?Q?ozKaNngRHw8fLdq/xGqSD57k0hvqmQ5t+hWj3Cs5nljcBQZUUvcGLq2BKg?=
 =?iso-8859-1?Q?akVbY2huQWhstxFffpXWkx6gyigbMF6iUiuWfRnsYEsaBTXvQfgv/9ANTL?=
 =?iso-8859-1?Q?rKp0H0ZNGdIL7TWzB21p7Fug7hrDrqXRsZCGxiZ3ly2SIm6MEKFTtlfM0A?=
 =?iso-8859-1?Q?s7AQUn5AFsMxviVmutWLPPphACL+ziTl3KKK096/IDb2Di/bSqCV18qcdg?=
 =?iso-8859-1?Q?j/zntHcLSX3L5dRqHdxYGelV6m3MZjMJbMSxEfwKm4f2liOXKR8UhdnwQt?=
 =?iso-8859-1?Q?vaBcJGCDTCkCc3CuDxN6bT4KwHy+n0tFP+LVCg7WdMowoedvxvsi2E7w6c?=
 =?iso-8859-1?Q?eW1wFX6YaKWsn6aHoVTb2SYmYJYmDo1/au/3S/pldX+tq6PoOQ4Aku4aL1?=
 =?iso-8859-1?Q?oo9f4ykA7v44JxybxL/eljWj7nXaoiBhZYmrhRH2J195Nz2O2a4V0LOLDe?=
 =?iso-8859-1?Q?xkdUGNhZ3AqJOb6OzpLPz9idX7ZiiteMTSvMxJZHlKdXeqYNf9pfdErGu9?=
 =?iso-8859-1?Q?dLXbS8tPeIuagBJa0V47DkiXe2/PWp6o4cItZQIU8NojGVhssMdPyyrjju?=
 =?iso-8859-1?Q?h2MhZXDTPF8ZQ21RMozaVOtv5wCvtTXh3DHLVJo8pqxm3mfytb2kP8upr5?=
 =?iso-8859-1?Q?GJaVDc9IA0u6WApngL2hHxQRuPtf1xPAQajN0g/wn4cPTrQzPiz2LDDzg3?=
 =?iso-8859-1?Q?iMCyevGyrYpwvqv3SyJHtnkf97CR9zfbSlU4nSQZebFATZx0ZSqqoa3/lj?=
 =?iso-8859-1?Q?Nb8eakyRU/vsHU7jTN607rw5ulIPwbu/lCeESrRb1fOmEeOJU6IPdbBNmd?=
 =?iso-8859-1?Q?AnRskdD2dUHilwayfL4AcJpzCHqSVw8PYUyuVGXlb4o67VNCW7Jy3tQZBs?=
 =?iso-8859-1?Q?sCEjqwrGGl/6laoDS4lKonBxzgj6A91rn4XtqWm5t3Y5fXuoqGVLY8fVKU?=
 =?iso-8859-1?Q?YSbnmWq5/fvMvtrts4pQNbGCFFebod6JcCQOZJ1JpwobYWjleL4NoCC816?=
 =?iso-8859-1?Q?GyBdoTyh/G6u3wRjYEhhQzeQukHEIxpPz5NTa5DoEidtGwDEGI6EdNfOhQ?=
 =?iso-8859-1?Q?jXQqNsJAppqkAGGkn/Y5JWpmn+FCVUces5GDJgGOZ91oCoTmNlyRX4nLjn?=
 =?iso-8859-1?Q?qKY7kqp2StXFZXnBo2tLGW0O223/P1ncne977YNulZzF/crMe9HqkPcmhM?=
 =?iso-8859-1?Q?aX91Hpqhp74Ek7xHFqxLKRCOaACGOR23wmtLFa0VT8N2abmbWhbBWNSaP2?=
 =?iso-8859-1?Q?B1/6eLZiqGE0j0CRJLxvFyzvGh4a/cyTgb1wCMdUTMYJHEjwmM4XiJgO5d?=
 =?iso-8859-1?Q?s+ehmktf+u3QXSrH+Ow=3D?=
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
 DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	79deba62-a456-4eb8-625c-08de552ccaab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|14060799003|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?CV9LuqrxdSbacAa/XLzu0JX+aIDbvnbYM4jF+RLGDxW5V9cOCbmih5GnLu?=
 =?iso-8859-1?Q?H/sIuVfDPLKnh5qwqsQ4OyzBX1v7gTX/4msVKnuu+SFe5Sujhe7rAtE9Ci?=
 =?iso-8859-1?Q?T9gf9mA3KQ8B7grUrEOMgLXIbh0yfCG/Eg5AT6grwifb3CkmPoWLGvo2Gu?=
 =?iso-8859-1?Q?ko1vdblqjZhDpkVGXs9AlCXL2FmNoHOpcmFPqzaU9PDKnDLwx/0l2/7ESl?=
 =?iso-8859-1?Q?yVT/zobd39qQA3NnJ9UiXbemVFxe2UGUbOYG/F650nxpADX2uC+1geLGJ+?=
 =?iso-8859-1?Q?reo6X1vYk/jxOgdEjh6j8FOa52YUe58S/RA6LvmwX+WL1TtfomrJ1l0hxq?=
 =?iso-8859-1?Q?TTv8cO2pDFhNixPNMP+o2avAkOsf7iQYpQqgqnaLRTxQV/auRu8BZf6jiC?=
 =?iso-8859-1?Q?jYl0YLqSPiNkhJ+Gwf3fZobyLvjyAeITUzeii/NuAyHB2v0ralVkVFGw46?=
 =?iso-8859-1?Q?fVTpZdwYJ9y1w6KyeWp8E6DDtYfjtbheQ4cnLSYa3Bhbv2AtPxqZVhZIAz?=
 =?iso-8859-1?Q?YjNy+5yoVIEIJxmEIuKMXOK+tEmINBx6iB+eRrBh6OIf5UMe19XajGv29o?=
 =?iso-8859-1?Q?FPGyzhQPZxAPcjI9tmnYjbn91G5ZOEBKotHtKWYImxIP4hMyX0OzJNfi1n?=
 =?iso-8859-1?Q?neClLZK0HVDoxM7HZH1WrV6wkdG2eQuuaToopA2sGftHxEQxqVZluRHyAM?=
 =?iso-8859-1?Q?USyRi43qiESdngSjEUrcQL1YNwt2MLa73g81x9q+KxguQhY5lTQhVn2okx?=
 =?iso-8859-1?Q?kGrZ08E3PZRr136i9EXSq6412nkFehR3hBZUWC8JokaMTGbchkbUKpUyza?=
 =?iso-8859-1?Q?CR+zeACaKcE9oWtui+di+gGsPnqT9raOeqybvycCZjqPd1WCEyrN3JoMfu?=
 =?iso-8859-1?Q?ZnvREybtLxrgPZZdW0GuSiylFxpPy3Ed/LQ7lqEobdza5Ff69j7hUNWt84?=
 =?iso-8859-1?Q?Kz4c+YWRMeAwWszhxb2k8z8GdB3jxFaRsfcmixwTHfqMi/k0z1j6egltsw?=
 =?iso-8859-1?Q?sINIlbTr28lYnB8qgMZ1htN3zdZtfJIjBCc8rk72ajENIzDqRom3NCsuRK?=
 =?iso-8859-1?Q?LEMwdRVx5VIvYRnI5hVQEq8mQVfPoXaO1equph1Xrf3dTtgMB3BkCekuax?=
 =?iso-8859-1?Q?2v5vP18nCh8IiszXY7V4uNsVM2J2HYl6vjXLnQQjwF4MaTzIdecBR6duQT?=
 =?iso-8859-1?Q?2rNakeqCDs1/W6+4ISwTogh6nJsiw0comfXtQOM+flKGxYORLiHE/zQBLO?=
 =?iso-8859-1?Q?2RPTqteOAv7aMqBkGa7X/mmJL5q124vLY9xKIcjsdLFCGtTl7fw3IvdOf3?=
 =?iso-8859-1?Q?S2ivv7m+xGbcEGCgg8RpoP8fkmNDAaEQxuZxn/tF4E1tTpfLvOyrWK7Op+?=
 =?iso-8859-1?Q?05ec1cUbRLGvd4PxUSnlBDeOTrXWdyHE1gZsvCAUwFt1qqW2T12TVRrcOw?=
 =?iso-8859-1?Q?xuKhQGZDNyHkX+tq7BWcqrXDAOtOVfUBW8f6PSusrPx781HR9+aq23LcsI?=
 =?iso-8859-1?Q?rMa1cR9boU4+S84ffOJudFagL1KiPURQgrSfXsZBgTnid71+N5Lcx1at1B?=
 =?iso-8859-1?Q?1Z2dqWHpa089mUP+gN3U9ByQVwq9eV34rwuHA5udSF6vSeK7bti1G06ffm?=
 =?iso-8859-1?Q?wfx0QPMGhiwKJFwm+dQKBAEMiHdrQwSyx2TXDZ2ANJmiat7NkB7nhh4zDk?=
 =?iso-8859-1?Q?84SsWP3N6W4LnXqeoTOGad6CYJlvThIc4ubIwbOGidrNXhsHbwvtkejHhS?=
 =?iso-8859-1?Q?XO+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(14060799003)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:43.9717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f02bf9-8ef7-4828-f65e-08de552cf0d7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB11023

Update the PMU code to interact correctly with the GICV5 support in
KVM and the guest.

This change comprises two parts:

The first is to update the interrupt specifier used for the FDT to
generate a GICv5-compatible description of the PMU overflow interrupt.

The second is to correctly convey the PPI used for the overflow
interrupt to KVM itself. This needs to be in the correct GICv5
interrupt ID format (type + ID), which requires the interrupt type in
the top bits. Moreover, it must match the architecturally defined
PMUIRQ for GICv5, or else KVM will reject it for a GICv5-based guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pmu.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5f31d6b6..f6316425 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -197,13 +197,8 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kv=
m)
 	struct kvm_cpu *vcpu;
 	int pmu_id =3D -ENXIO;
 	int i;
-
+	u32 irq_prop[3];
 	u32 cpu_mask =3D gic__get_fdt_irq_cpumask(kvm);
-	u32 irq_prop[] =3D {
-		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
-		cpu_to_fdt32(irq - 16),
-		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
-	};
=20
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
@@ -216,6 +211,22 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kv=
m)
 		}
 	}
=20
+	if (gic__is_v5()) {
+		irq_prop[0] =3D cpu_to_fdt32(GICV5_FDT_IRQ_TYPE_PPI);
+		irq_prop[1] =3D cpu_to_fdt32(irq);
+	} else {
+		irq_prop[0] =3D cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI);
+		irq_prop[1] =3D cpu_to_fdt32(irq - 16);
+	}
+	irq_prop[2] =3D cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH);
+
+	/*
+	 * For GICv5, we must encode the full IntID by adding the type (PPI)
+	 * when setting the PMUIRQ.
+	 */
+	if (gic__is_v5())
+		irq |=3D GICV5_FDT_IRQ_TYPE_PPI << GICV5_FDT_IRQ_TYPE_SHIFT;
+
 	for (i =3D 0; i < kvm->nrcpus; i++) {
 		vcpu =3D kvm->cpus[i];
 		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
--=20
2.34.1

