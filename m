Return-Path: <kvm+bounces-65507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4B4CAD979
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 16:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8F8D305F31A
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 15:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF732D8378;
	Mon,  8 Dec 2025 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XkTuzLMU";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XkTuzLMU"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013026.outbound.protection.outlook.com [40.107.159.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758627F19F;
	Mon,  8 Dec 2025 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765207775; cv=fail; b=r49B7eOUgmW7lyizMtHmzE71ZMhzvlgyOCeXp6+gN1wKsdYQsDM9OewcAbv1XKGixn8S5tOJ9Nt92CgJZNoFXXglytxCEhEctA68c5sYAFgi/MwMMIa0gCv1DYQIkiQfaF6i0L6hFdtHzZjBRKQe872VbTAs5I5zrC+/Ne0t1aY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765207775; c=relaxed/simple;
	bh=wrs3bCok7wcIfP6Gp+80t9I8A99PF6n9THlzINLko6g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mJUJlhfXyEbQ6py+FMzFSPW7Ki0/6Vu0JxLl87OkK72nbafIQ76Y17YjGYWLUxjyAZjmFh58AzL5T4piMtzI+Mx8oSK3Vdg26Nq/hYq0A6Hkr52sFWS0E9OwNmfl7JHeb+EwflSDo8lHEAAyQNLo7Au3Hv1FOW9CTd3PNJlYtgA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XkTuzLMU; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XkTuzLMU; arc=fail smtp.client-ip=40.107.159.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eswxbV5tj+3yJne/uMtprF3andxWuO9VvZparU9g445le1JXa9gbDejvFR9imcky+WdIg7i0muT5q9knvyW0vUCNnNWmo63F9WCTmH8efOSy/NnaEXUySK2yy4AbjxMdqNBrzfrMXku/Qy4+vB1FtSnrfB4Hya4oIlqmeEUrXM9us96uKoDxGQyMS2C5piPSzdXmsd3HiGjQj6Kz/TUHzldwb6ZTfYg7f4MDLgxH3oXqiHStaNbWj2z0YCs23m3h2p2iN75JR4A6NHcnc6mJm+4fHcG5txscPYKkAiaDnDtef1AksWFEO7lSI3mb3GUJN2Qbi6c/g2Si2lSYOT2Leg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=q0IevPZ/c80B65jD5vYGOD3K98oXdV3P5SxNHZDJ9xVFLWtUc840CCAZUeIo9VdOo8ucFTCckmihxpib3+WGca+RPyebfQA0h8Z2p9JOC+MWzDq57iS+lpYHWeFhWWkXKgyikptKmriLgm7usCn5oGZU1C8C++UwHcKXzpLIU5Hh5EyDLy3Z4ALHVF4UW06FYEhhiX4SMe0q10E7dvWwarnio74TGN+bu9c6Cn4XcUo72+5L1HO4zL3A5lZQ+YMzd5qAh1qL2l9udbSO7L7AJ8XxbRT6PmD5NI7O4sF1MPo9lnseeSy3cmDVAFsCG+SvhCFWbF5fxsW5PKAvCqnauA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=googlemail.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=XkTuzLMU4HF52LlMRuG0SMIBs2Z+nG+jhAndS5DMGRvDh5+Ew8A2fdP0OjmRSO3PyXBZRC7eVoN3esp7JUWoMxZVqdjAppDkwaTMFEgOKFlKidkDXU4aJGz+UbBTuDmgm/3EP358MLPL5nA4KykaWZ08bRvqCD0g+256nTErbvs=
Received: from DU2PR04CA0167.eurprd04.prod.outlook.com (2603:10a6:10:2b0::22)
 by AS8PR08MB9338.eurprd08.prod.outlook.com (2603:10a6:20b:5a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:29:28 +0000
Received: from DB5PEPF00014B9D.eurprd02.prod.outlook.com
 (2603:10a6:10:2b0:cafe::4) by DU2PR04CA0167.outlook.office365.com
 (2603:10a6:10:2b0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Mon,
 8 Dec 2025 15:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9D.mail.protection.outlook.com (10.167.8.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.8
 via Frontend Transport; Mon, 8 Dec 2025 15:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vbMutzEsezsbZgI+5+IfsGrtN1QerlZwvy8fcL9k1BHPkBfdiGt9PlXXLj6/3vrLB0eHe7KXWcVKMRxZsTdhhiFRoyUw4UUFB7s+Auz4EtvS3QPQM2sKPiHmHuH+FZen1ejKYAvwkmqBbHoc2cWz15BHbzv+gu1DAYQtUdUxQMeEm32Q9kvSu51nOhdyRmDjRj4CsyC0lg0B3caoyuDhYSe/Y1rtDG/FWSeOokk/afNCPyR6gvdBTUFerngj7xwQl/UjvaAJkE02b+Pmp73eaAaPlFQeTsY8rf2ho586DM91STKdV5Dpv8NiR2Bx4PJFbjKeHlfB6Ug+IInjlAme/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=W/44i59gIGipeAkocGrokZ60im/QI7rRQZB6KT4gnJo1PSv4CRLz67dRbvMvq95aLjfRlh3aq4SjG3Uj+oFFSsJb1HcPoN7L8Gl0ZQqDYwzS6UakYwcEq4buDabyTJpqv+peHX8Hayol2RtwDo7aQzeQNlM4lYKScdHiLp+xtwh4SSNi1hL/5AfJBP4l5pv3/gNGMSV8BLSFSxtqMDnKL6wCNPpYijUKb/TmLbyTdxQxipKt9++6+cr++nP0O9PcpD/0xdi9CWg6eRpMKEeysqwLI/wD4B+OBTqRZrBc2mRtggMWfveXfjBq1iMOVFYEGIbOXjsfjrQ8EvNaKKaxzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vB2dPzCxXUUpinh3t1TVTSFf0Xt9vi+6+/0ZezYUfK0=;
 b=XkTuzLMU4HF52LlMRuG0SMIBs2Z+nG+jhAndS5DMGRvDh5+Ew8A2fdP0OjmRSO3PyXBZRC7eVoN3esp7JUWoMxZVqdjAppDkwaTMFEgOKFlKidkDXU4aJGz+UbBTuDmgm/3EP358MLPL5nA4KykaWZ08bRvqCD0g+256nTErbvs=
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com (2603:10a6:102:2fc::17)
 by AS8PR08MB9573.eurprd08.prod.outlook.com (2603:10a6:20b:61b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 15:28:23 +0000
Received: from PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f]) by PAVPR08MB8821.eurprd08.prod.outlook.com
 ([fe80::32ad:60b4:63d4:3b8f%4]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 15:28:23 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "sascha.bischoff@googlemail.com" <sascha.bischoff@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "will@kernel.org"
	<will@kernel.org>
Subject: [PATCH 0/2] Enable GICv5 Legacy CPUIF trapping & fix TDIR cap test
Thread-Topic: [PATCH 0/2] Enable GICv5 Legacy CPUIF trapping & fix TDIR cap
 test
Thread-Index: AQHcaFdJi092p79CtkuLB9s/+novxrUX3Z0A
Date: Mon, 8 Dec 2025 15:28:22 +0000
Message-ID: <20251208152724.3637157-2-sascha.bischoff@arm.com>
References: <20251208152724.3637157-1-sascha.bischoff@arm.com>
In-Reply-To: <20251208152724.3637157-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAVPR08MB8821:EE_|AS8PR08MB9573:EE_|DB5PEPF00014B9D:EE_|AS8PR08MB9338:EE_
X-MS-Office365-Filtering-Correlation-Id: fda86634-c766-4b87-e92c-08de366e93bd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ldCRW9WZ2BDlcxlP49A8zA5JphjcvIIC1R9s0HGIe4er21x3SiYun55tiJ?=
 =?iso-8859-1?Q?jnz9iETQHBJDmG0SD/dDsY63wUgGJ3aGTDceh8hmpT7eIj8fGHGgfnIsxa?=
 =?iso-8859-1?Q?znYDL12tZF3Lz5qG3yy4AL7bz03eBN8XxgVsA01Ij9TDqFkM1BMfxcawAx?=
 =?iso-8859-1?Q?VQ9H5onafiFqpQoyR4fsSBuxNcWQSmGjP4arhwVnXFoQE8/Dh5Zi288lhX?=
 =?iso-8859-1?Q?BtQejMwc3JQnV48IZYelCNQWQnnck9r97O1Y8BRNjbRvsKfcx5Ne96/rZh?=
 =?iso-8859-1?Q?KOtmjgmm9OySirhrdP7X2fF1wsWHXvlVlkU/25BHiK97ZGJQXfiI4LLbHX?=
 =?iso-8859-1?Q?RqKSnXQQHX7L9wvlG9WBHrXmgmb0MgBfa7MqpHAD6Kq68cBvmfvY1w1/E0?=
 =?iso-8859-1?Q?bRV7aOn4ryRHhfB59xkV4/aq39ILAHcdj7TBrUAfYE+y2Vgd/STY2V6VLR?=
 =?iso-8859-1?Q?03ZcD6qteNFCPiLoJw9FE0OVbPqu3AHikThoxQxBsxOhhmE+IvPcT68rnb?=
 =?iso-8859-1?Q?0jUW9G3/7r56iZK8cVGTveinesA9J6C/ONnW36IH/Z5PGrdQAkQt8zQUd3?=
 =?iso-8859-1?Q?yGaCj1Oa74tnEvMB7soAarqWNzJ3/GPE0BPN2je9S6C1jZVe6Onkb5Kvo8?=
 =?iso-8859-1?Q?4xc1AWPmnrxj6tuwI1JZ2Mnk3HlC6MO4/93vQ1c0S39gJRIwsLy/+P3LR2?=
 =?iso-8859-1?Q?SqCEdvEWz1NH/TZd4KAXNAW2HPiJKAwfj91gJcpfmADZthmQCSmEMwvhYG?=
 =?iso-8859-1?Q?yIezSS3SEiQcp7bhocC5yHG96cO3XudIdQZxbTfW3JlrDJw8qNGUtN8pAp?=
 =?iso-8859-1?Q?0wi6IAWsFtdxuXlfTEIhXpEYgaSM4ogPm9dMt0KvGmJV42QlSYyLMrGQ+n?=
 =?iso-8859-1?Q?azXTqgcIFk51j5UP5xLyuPUzO85DwC4MWsI5NniwuTE7uJ0fkzlnFlk+6x?=
 =?iso-8859-1?Q?Jej5T9TRt30w6Mzwihkv/STxZWwTm3KxwXBJt8fespS9Fo/EaFkJMHuLoh?=
 =?iso-8859-1?Q?fhQyCnRLtI9Wc/AlUvyO1+oQkeoD4AY0i9e4gst9oI71KsAPhmcnm6ZWPS?=
 =?iso-8859-1?Q?2len4H04JIqepwrYjUHirjWKH7DkmnnqodWMbMb4J723/b46q1RcHKAcHq?=
 =?iso-8859-1?Q?qw/ybegdezQuPqB1jLmFlW1wim0EAw59z/YNwZXqa1XmxBeVxl7OHkTEaL?=
 =?iso-8859-1?Q?GPC6JvTj7X+Q6A3c88X3XjSEds1uYO6NoNe5+hV0bUDYx/nta6YALS2ggI?=
 =?iso-8859-1?Q?V3j4S0kM3/F/n6+nyArELZU8rwFLXj04FmX5rhsr0BzxpYwTACpYOnfLMm?=
 =?iso-8859-1?Q?skArixjijjZ/Whlrtq5Sn0uiSi7fmSERqcgKqLrmX3GYT5ivlGFYQ6B1OV?=
 =?iso-8859-1?Q?byFTSjzTVT63zdapTBjEGr49UPmJA1b5IJfzPZatBgrwocwzevW0V+BDgm?=
 =?iso-8859-1?Q?dHmpN6Gd0v0tTA/tvUKyzfgeBZsdNbEVXdqDerD6VwzQyxuYwm5lqS/uJs?=
 =?iso-8859-1?Q?mJ0glzo24m1HcAaMmenVh+dzrviRgqgPsiyxT+EU/TQtqxobLK0oBp3tmU?=
 =?iso-8859-1?Q?gQ0NQbG5EnYIQF+ZC7nrUxRNvnM2?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR08MB8821.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9573
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	10e3453e-c588-4121-02da-08de366e6ca4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|14060799003|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?zMtdJdtMAPwRB0OKQayo3BvTNLkR+DPMJmHpHEe7fGm85+ajJysZXs9sKJ?=
 =?iso-8859-1?Q?7DFPtgtghWQooc59grllfOe1sgDYI5Z72M57VdVcttiNhQ+37XLhSEncqR?=
 =?iso-8859-1?Q?2TLGHTETEs2j+hZiqTs/shkOq2JHCS4ctzVdJpxS9v6X+vRxjT5RQlnVXt?=
 =?iso-8859-1?Q?vwJeS6OPq5PRxFgnFUwZ9xVDvH8Mb3QjMjbcxuO3q4K0oqO1Y57M1oA8xA?=
 =?iso-8859-1?Q?nQbk+4gdbh5H8PivW0aa0RiBnouSvR7uv6KWRGIGVMtG9+nQRVM9fbN2oh?=
 =?iso-8859-1?Q?agQ7m6gr+uK/jd1q4RQpwIIAG9/mGQyTmY7OKt+ap8g1pSv0OeYnQ7mG+U?=
 =?iso-8859-1?Q?oSKfFTUlypujICs9wpTi+9ooRpc7ELXpmm2QAYXTRv+hI3t84UbjHgqtKa?=
 =?iso-8859-1?Q?Ddp8M6S8OB4aTZjQA++SnwR8vQFLSwhT+NnJ5mayfDBj2Cke/koD5GUKN3?=
 =?iso-8859-1?Q?EKe06+o76ihk36uwda7BQJidsYbSNq/6LgVkvefBWGypWYBhs3VuQ3VizH?=
 =?iso-8859-1?Q?q6SdbGsAwmgX29yEGnFyyv0NPWqC2OLabyz4fzMWuakFh+31GlV4HUNq5Q?=
 =?iso-8859-1?Q?uR3Gf9VYgW1ldxh3kG6NTdJ/7I6TS3TnEGtbPyjSXJP18jVOjSLXTZWfxc?=
 =?iso-8859-1?Q?sFi3y7wT6TOb4UUF88V01YBLjTrMWh9TUWHAY7u42p4ejinL0uH42aOLci?=
 =?iso-8859-1?Q?RT7OZplPSreWZXq1AvuTN6ScnNRC1ddyy/W1MfX9nY1VSF8CSMhaMSBBok?=
 =?iso-8859-1?Q?grfQiwz6dBieCycto7J9ekmAx1i8C8TOX4d2cpmznNclkXRbmT6cxMDx8v?=
 =?iso-8859-1?Q?eL9tLjowL9XRRp6XlF+ieXVgplCIuCnB4sbSR/tpl4vSdMxRdRDUWGy8xt?=
 =?iso-8859-1?Q?ZEGA8RCllsK+SgFAanR3NCYakr9JcHbI5RUOWuxmC5U1u9lokM2YS4LMu8?=
 =?iso-8859-1?Q?1blDbTNNjVujeXTucwOt0lt9vjqSlZlSeILjhl/lOsCdciL9xUJCAy48cV?=
 =?iso-8859-1?Q?WNoYYxpOXNWLfQTM/ESPFpN4/UV0FkJn3sCNSFCaDr5/BhpzYOlQNpPtjI?=
 =?iso-8859-1?Q?BxBiFCHgs/sQ5WQv6BGQjhVHBoh/KYf3nPfBwwRdOiKqfKBwImvgc1eUxx?=
 =?iso-8859-1?Q?d/hYEgelX4lPvqnOxo0hN4G9KY4h+pM0Yz9FgZm/LTR+mcKmx1F3XpRjie?=
 =?iso-8859-1?Q?gJtK0c5U0RdyleifQvciCJ8Gxqd9L9nsG+5TDbjYoDLj3uZOi8tePmuwF5?=
 =?iso-8859-1?Q?ZB0a815tQV+ndSmwISlHuTBAC8rZ+rfKAkgmodHWjIBE/a6ApkQIU7WMii?=
 =?iso-8859-1?Q?uuGc+SoWdaHbVXEnfTn2VuchZJl0dTsWDT0tmDfcOMVn28jc+DpS9Pg48l?=
 =?iso-8859-1?Q?ywnDUxGAgR1wPP1fRUDPzK3DWm1zpurksZhFJ5l9bGCZn76/HRn5HAkFXr?=
 =?iso-8859-1?Q?jwqZgzBZ8YtthvzlTau79u4rJ3FyN9PQUKMXewvrAsgVQfR4zEl8RpmVhi?=
 =?iso-8859-1?Q?Y4Ao8Ciy9BeikwiHC0pESBrChz+oBk8TTRxZUcv3u0xZ2xHulMVUNCGbCZ?=
 =?iso-8859-1?Q?ll8UonzF6OGBP+cxFKHfFXkepTHA0HLrYQ3g5Xr1v2SrkErBQbrayNDXxN?=
 =?iso-8859-1?Q?9FvwtdylaYDnE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(14060799003)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 15:29:28.5143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fda86634-c766-4b87-e92c-08de366e93bd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9338

These changes address two trapping-related issues when running legacy
(i.e. GICv3) guests on GICv5 hosts.

The first change enables the vgic_v3_cpuif_trap static branch on GICv5
hosts with legacy support, if trapping is required. The missing enable
was caught as part of debugging why UNDEFs were being injected into
guests when the ICH_HCR_EL2.TC bit was set - the expected bahaviour
was that KVM should handle the trapped accesses, with the guest
remaining blissfully unaware.

The second change fixes the specific cause of the TC bit being set in
the first place. The test for the ICH_HCR_EL2_TDIR cap was checking
for GICv3 CPUIF support and returning false prior to checking for
GICv5 Legacy support. The result was that on GICv5 hosts, the test
always returned false, and therefore the TC bit was being set. The
issue is fixed by reordering the checks to check for GICv5 Legacy
support first.

These changes are based against kvmarm/next.

Thanks,
Sascha

Sascha Bischoff (2):
  KVM: arm64: gic: Enable GICv3 CPUIF trapping on GICv5 hosts if
    required
  KVM: arm64: Correct test for ICH_HCR_EL2_TDIR cap for GICv5 hosts

 arch/arm64/kernel/cpufeature.c |  8 ++++----
 arch/arm64/kvm/vgic/vgic-v3.c  | 25 +++++++++++++++----------
 arch/arm64/kvm/vgic/vgic-v5.c  |  2 ++
 arch/arm64/kvm/vgic/vgic.h     |  1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

--
2.34.1=

