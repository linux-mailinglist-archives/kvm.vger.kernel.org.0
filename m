Return-Path: <kvm+bounces-66374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A8DCD0CDA
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:17:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDCAC313D8F9
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A1D362121;
	Fri, 19 Dec 2025 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PY3Y9jQq";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PY3Y9jQq"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012016.outbound.protection.outlook.com [52.101.66.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A77E363C4B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159645; cv=fail; b=urRu0Ph4V17ceH2rZbVlRgUa6Ogqmt3Gl4Jd5JUyc8YtztbhqP23a+ZFF1BJQ5+k3pa3NP4lZTAOU+DKnxa56QUv9+JW+K81k3ECYtbfHcO0J+gQ9JniS84sYMs/dVObOb3Dp2czCYOECHkiCFEtqhMdGFRuMt2dngVLv7+cl0s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159645; c=relaxed/simple;
	bh=pRAFPz4wdj7CgYtVP5g1JIyG7FKbY/QMoCQMn2RWZpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h2YlSm5J+y+hKZZY/NX1wgB05136GSNrgHKvVQ6jb69V+2ntJCYv1xwrbSWQKwicKDAZ83YqMYDcP5n0UhJ1LFTn267A4OhpLZnNRfr+lweWWmps+kDXbjfrJSdNdyVKB3bzPLlwGJCZrgYIGlB3tyukceCRYCk6oxTwR4MEZLc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PY3Y9jQq; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PY3Y9jQq; arc=fail smtp.client-ip=52.101.66.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=q0tec8Ot1zPohQBDfzm7CDKV8LeWMKtt17XtPPIdNfYRsXPxy5KnrtfKYcy7xiykpdbmtFF4OOlZyFlmdy9ivAl9fKwRrGEajJTl3yJ5A94Ugwq2oWkxR19f4qNX4AFkKs+BvuX9ZS9/MMRPX6FwpNGCEnY2EdIH+Ofz2Xn1HHMG3II91riiiA0SpMjVqKTnyefuEfZX/sr6F62poyc8+uEX6/W1gUlIGVBVYV6Xr9sABX+4mTv/XLbNxSi7jOv79SpkTQJEp0XNcRmEepj+Qabxqa0s0tY3Sgd43OYkeaBAFH936icEhyBxS6J1kO8EVHDEUXGisv706P86kIFRmg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MOPzaNBxYlY29czbHsQ0jlJ//T+kwVyQ2AgXn0RZHc=;
 b=dVY6HenG08uG6wXxfvGaXq8kYNufbmfii+ATEljLNW1rDquTvZwTGWf8IzoTbhVFleS1xihJwh4YrWGHL4k3OBehq8TS3RZ2Cupxse5tLG5qqilPuXKobqie6DCFGADBEXniCvzVKgJYmRo8disq7UC1bzrpUQa5Usm+mcPaJU5ccUBENzmZbyYabo8wxM383r6HTwE0kBrHNhoALa5NDbDF2OlQs5MD7RbgDOVpjjQZIAZj4WkywUfptgQ0gmNBY77az0Pi4o8y1e2lx03trrpjLBGvgPSgp+0eFsm5DrZnCHOSk1Q7BFg8E1Rlk891cglfrv4xLyaau9TdvQQMvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MOPzaNBxYlY29czbHsQ0jlJ//T+kwVyQ2AgXn0RZHc=;
 b=PY3Y9jQqF3KnvvmNLlmkSr7SrzPl9XTwSzF9XLThyxTHgiJnF5Od/gzuLvsDfVLOxvTTUav/P/b2ZQ6w7DyTzt+7T882CXKl/+HFy5vTjiO687oXi1bU2QlYLyYg15qWWm+UjT6GNr7w08bVYz9+i+vsb6lzhVn3eEYtSc034q0=
Received: from DU2P250CA0029.EURP250.PROD.OUTLOOK.COM (2603:10a6:10:231::34)
 by PAWPR08MB8960.eurprd08.prod.outlook.com (2603:10a6:102:340::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Fri, 19 Dec
 2025 15:53:52 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:231:cafe::4c) by DU2P250CA0029.outlook.office365.com
 (2603:10a6:10:231::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEaluKXSRczZOLsFYl0uXRmSHdpK2GFSM4vO+9urExoq/JDRAT8XAmujIZVDWgtWLuXomzKO05Evk9u1WmT0ur+/65xsNhq+LC2jRqMf4uzfuweYZeUeSjH5lcBKSJypKAtJKBVOp7siIyWkEa32Ubv+4mnoz2zYghZeQ71+xoDPtXZTrHFbZoobhDO4BlnaCrqmtfaNmxC7/GKQj5KEVHVj6OOti17QL7g7OPbHTAsrcJQcNK0oSdSlN+ZW+tKUJfwDUBT5OSECyBixIH98tMvASnJsPcsHXOMlu2ijqkArYJ/0RUEruBx9WatGdUU8/C5MFqyaiu2mssIua8V8EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MOPzaNBxYlY29czbHsQ0jlJ//T+kwVyQ2AgXn0RZHc=;
 b=QjE9St6LsDbpZSIZi4ID8DF4XEmyV8lUV/nzceOWLkbHBOGGOClF/6mjzD6we9t2jxdIpL66214pvL4XGd+EsOVpSxE3zAWlAnG5BhSpN6GN8DUwJBPKWxg6f9VX9PgKjlCXSTPpA0jRplaR/zBICQAM0auXs88LXC0cfo50k18RqhiPrucfib02S8uXLtLuGyrHtY/UOEaexW+WUKZqzA6M180hiCgV6RLJPVuNOHSMxpNElKL6vtt9chONMNlcmTBy3P7JzrKvIu8nDuW7qUsptln4D/4goIfeFNNzTBYRvH24eI/o0dHlWqstZEL+CTLY6MLL7HNgFX2iBPd+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MOPzaNBxYlY29czbHsQ0jlJ//T+kwVyQ2AgXn0RZHc=;
 b=PY3Y9jQqF3KnvvmNLlmkSr7SrzPl9XTwSzF9XLThyxTHgiJnF5Od/gzuLvsDfVLOxvTTUav/P/b2ZQ6w7DyTzt+7T882CXKl/+HFy5vTjiO687oXi1bU2QlYLyYg15qWWm+UjT6GNr7w08bVYz9+i+vsb6lzhVn3eEYtSc034q0=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:45 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:45 +0000
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
Subject: [PATCH v2 22/36] KVM: arm64: gic-v5: Trap and mask guest PPI register
 accesses
Thread-Topic: [PATCH v2 22/36] KVM: arm64: gic-v5: Trap and mask guest PPI
 register accesses
Thread-Index: AQHccP+DJ+d1Bl/alUKhapZrPXwVYA==
Date: Fri, 19 Dec 2025 15:52:43 +0000
Message-ID: <20251219155222.1383109-23-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|DB1PEPF000509FC:EE_|PAWPR08MB8960:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6c0f84-0be0-479c-c9b2-08de3f16cdf0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?sY7QmutebDZvC9Y7+y5N1QEBH7V3yAVvUbgNQ5y3wRjZ4mwInHoSc/cVqB?=
 =?iso-8859-1?Q?Sb5bKRVli5lJQk1XugNDvLZgK0krCIFV+CfQ9aI4f7SZIQ9ZIf1ksmuOHB?=
 =?iso-8859-1?Q?GAGIxkqqxKyzVbIg0sSrjc81GUIrI0MYn4Lpoba4zOuoWkTPhWiJYnj3IB?=
 =?iso-8859-1?Q?WlUWDaabN2N6qt+GQ7j1DHPmmDaKWG/8irZ7J5zhdrqWuNAFrxZ+QrsvlG?=
 =?iso-8859-1?Q?RxU4ib1R6BYFes4yu4/VKEKjKCBkkhnf99a+7746Nu4VU/qWCSW2kErWjD?=
 =?iso-8859-1?Q?EqJhWnm89xIgH0Iw55D1GQmCw490EAXBmQoLA2mrSgvWs6J0nG2CYtFnjr?=
 =?iso-8859-1?Q?HhFuj5Rpbq3K+HVIGLhzHijOV6n6UpZK94Lh2quu6VSu4JfuDzhkDSr8XL?=
 =?iso-8859-1?Q?f6AuQbva6ywREdrBMRTU1Z9bo7F0EdKbkRbm8aRC0BUsUPknanmG9OU7DX?=
 =?iso-8859-1?Q?er9mOjHz3Qrznxg5SSB/OZBZT6Lj6LkJgJOOS1DyLUsZEWJDqTZ2nVPlX0?=
 =?iso-8859-1?Q?3UvAxzv/yYXNs4VJH8mS/hrisyStk8a3P1pPnhZp33l6Wbh5eCVcumHDDG?=
 =?iso-8859-1?Q?LlSkbvv0CO0s0PFV1asZYEEuV1k8wQows0AgA4qB4vNAKynh+THR+2FHLv?=
 =?iso-8859-1?Q?yPf3eFWcXLIsFWcd2MwF2nXJWvGCrTzqLh+yr4oTfeQ7okgUo/hSywu2MC?=
 =?iso-8859-1?Q?b2/1qj3QoxxJwZln4iF5PvShKRdpXeROT9pVeTefWZv55K+kzyVZ9QQ9tD?=
 =?iso-8859-1?Q?MgqQDL+Nv3IEr3peRIcS0Y1gIRm0s4OIr1cuAUvnrJ7KjrNq5ik2QLH6b3?=
 =?iso-8859-1?Q?YhFcNJ0BOalNF+Z5lNva5iTex1ZQj+j0bGZakwEabW7wuXENeqLPiFCkbp?=
 =?iso-8859-1?Q?edTuKhPIHRRtMrwBZOryK1kfJlufLl0LmUxKTp968mxwZoHcnXm6GALwg6?=
 =?iso-8859-1?Q?EfdB7OxSkhUoy4whd4IfowVYXYnWLOTez1tyalFSmOhPB6UqYDTYa68lfu?=
 =?iso-8859-1?Q?NZMAeKhPQ1AfE/oOiMq/MZmluGTFPuJHLbdCgqeF2gwdYnJCNw/bIVzJt5?=
 =?iso-8859-1?Q?tDCuwSF62A2WyIJZ09pudKKVMaKyi4EOKhGDRSFgwaHxXc0HaBoBrrIUYi?=
 =?iso-8859-1?Q?SY57CNj12QqHv5jdNbvvUqf5/qA1QWbTpWFqsJRw3Hh5kJspPkCVdNN5A1?=
 =?iso-8859-1?Q?Uy0KerrWdWDYkZbLrKwfDOxrY/xj+/dEECGBkKAIyxPEIwbHyTokM7cZJa?=
 =?iso-8859-1?Q?NEtmkLqfGH2pvIkE9tzOhJfb1J5S5+4wV5gW7CS0e8zqbX5uXLV2srFsy+?=
 =?iso-8859-1?Q?2n1Y2AXx5FMrRgj5a7N474PflXSWFF9NT6HMzn6gFoHIMNg03TOz+QQX9D?=
 =?iso-8859-1?Q?CzvMnprBcD0wjsp7opeJDYSRdhp+3DAHES8Fbl/N/sJ1SUdhP7eIQR96lX?=
 =?iso-8859-1?Q?gcphuIYiHM9U+mr46oS9iuXk5H28WYQtMtHr3OrRA4caoKqgcGg3aZaoQ+?=
 =?iso-8859-1?Q?BmQPgjuJL3tcubBnNKXnZ6tw1VE4DiGYQzxdA6a0774s0pLYE6dk+PTG2N?=
 =?iso-8859-1?Q?oSGjIhs6UPqr8WrtD4BDIAXDr4FI?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eb814307-75b7-4085-72e7-08de3f16a6ab
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|82310400026|1800799024|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?dkz82z0U62gL4cZ822+xiZr/nEnb/spk53IaztqYVseQLtQpZIx/i34g5V?=
 =?iso-8859-1?Q?RFQXZANHKeIkvWH0cTTfrA51ljXNS7YEAkUFq07568/r+YvEC4PsQeY/Kq?=
 =?iso-8859-1?Q?QDOwr3FEyfFJnDTUMMfCsFvLTekle0fJKwe6xR4vXpt0hR6Bl4LVZauCq6?=
 =?iso-8859-1?Q?8fjDob/7l2WMqqLyTJ2BpFatctLyYAl5mnt4xzSSkKiHtBzKwUGq1u+S0W?=
 =?iso-8859-1?Q?NQItLnIpzmyZihOtegUVbUzLYEHVUL2GRh5e53CbTLhuvyi0/isLbFT/Vc?=
 =?iso-8859-1?Q?KKeMY8yC/cENjN/XpFH2Bx4Akx3mncEELE97Ne+z3A2sLoIzkqfbwzd/ea?=
 =?iso-8859-1?Q?ifvGIRHyHsXe1WyDV0MVy/A1yJDVmHl9oYopMCJIejSDnr3ZactbV+ZBao?=
 =?iso-8859-1?Q?vRWamqy9wmwmlHVf5AQlSHPN/u20AVnqbAzmEadWB4SFRzMLTBmYqdWVY4?=
 =?iso-8859-1?Q?sru/SEQr/9OzNE6x/Aslv3vsXWDRkg7cixm5afEBdIM0pRqlIBPzLCXAIj?=
 =?iso-8859-1?Q?rIRqFtO/cqAVPwSpxzn+OeOrImFH71CjL5SqT+IwG4K+FV6XFTQ4+y986v?=
 =?iso-8859-1?Q?VpV5SqKIC6FS1lo0Ysmrr0FPy0gKG06WodR+gdalGKw6Yyr8hBmfttXinP?=
 =?iso-8859-1?Q?1VcMPbF8YhQiPbW9BruFyWjHsK2wqeJD345ebTrJbgWEymZOnsoz+yfdeC?=
 =?iso-8859-1?Q?vWvUIO9ozaabsQI24bT/jT0CXiIeWrAurrzxZIMstz/WG035BKKfu2bSdH?=
 =?iso-8859-1?Q?h+Xu0308FWj80t+fLgY868PVZcmyo7gXh9wk8oGv5fZF8QD+3znjWs2fAB?=
 =?iso-8859-1?Q?cPbthhvrYc1zKEUJDHlo4oAFXmnfnTqZAKoUt/K4zeyXg+37XnWZUxcs6O?=
 =?iso-8859-1?Q?FxSktPCeh5zeH0RXkc+tkXeTF5/8WEqZvzZn3Xgjs59vqy4vmgycNN2Jab?=
 =?iso-8859-1?Q?JqkpTQr9a9aI84Z+wh88Ac4kJ5agmkuI2LXH7ixywiDDmEV2Xh3bZmGVJf?=
 =?iso-8859-1?Q?0+ROoX1U3N1Xc1UcQvMsZI0tRtByPxb5Mk1PsvVNULabaKqDfuCeLLus0A?=
 =?iso-8859-1?Q?jGhq2ccY1WlcbiHAjkVSMVmrjQgKgHD6cOLO1Ncusl3wlWNUHTm6tG7X/i?=
 =?iso-8859-1?Q?1F5M1xvuNDUE/rASO/yqXuKQA0nEgal3n6lhQ2clXODjCuV89IMswYMefb?=
 =?iso-8859-1?Q?apEHg/8lrqa8zwZ/gqvs94yknH0Xw5sOGh/02oX7pbbX5bBIMT/5+l4QwP?=
 =?iso-8859-1?Q?BLd72/7pq5YcXphjYEO8l6tJpB/xb8TvRNPtwf/xOhyI+hw+Yp7Dn894Y4?=
 =?iso-8859-1?Q?9q1sRIZvdl99zbos6NpSiEIkmecYheD74oK+IqFCapqlLWYBc2VOcHRP3W?=
 =?iso-8859-1?Q?qAKxxkDYN/bHZtIcWlaTvoI/4uy4EodJ/0OPrheO2ODDeBh+Ygmh3UW0ud?=
 =?iso-8859-1?Q?/RGeLSNHiYrlquHgQapLCzBuvFMigouO4cGqDiKDFqx4go8ycf3sl2Uuis?=
 =?iso-8859-1?Q?chNVgUBggIZFyYMLCWaFVWyTjFmWwENhh9V6AUsMVJ5YB/V25oEY8xSOeh?=
 =?iso-8859-1?Q?h8OZgoxLQUXPPGOEnoFKL+58iByYrsr5adXahKOTEuwuA031rerF39lMz4?=
 =?iso-8859-1?Q?uFPQrlolFlH+0=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(82310400026)(1800799024)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:50.9049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6c0f84-0be0-479c-c9b2-08de3f16cdf0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8960

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. If the writes to the PPI registers
are not masked, it becomes possible for the guest to detect the
presence of all implemented PPIs on the host.

Guest writes to the following registers are masked:

ICC_CACTIVERx_EL1
ICC_SACTIVERx_EL1
ICC_CPENDRx_EL1
ICC_SPENDRx_EL1
ICC_ENABLERx_EL1
ICC_PRIORITYRx_EL1

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state..

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_x_EL2 registers, which is the masked
version of what the guest last wrote.

The ICC_PPI_HMRx_EL1 register is used to determine which PPIs use
Level-sensitive semantics, and which use Edge. For a GICv5 guest, the
correct view of the virtual PPIs must be provided to the guest, and
hence this must also be trapped, but only for reads. The content of
the HMRs is calculated and masked when finalising the PPI state for
the guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   |  22 ++++++-
 arch/arm64/kvm/sys_regs.c | 133 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index eb0c6f4d95b6d..f81bfdadd12fb 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1586,8 +1586,26 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 {
 	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
=20
-	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	/*
+	 * ICC_IAFFIDR_EL1 and ICH_PPI_HMRx_EL1 *always* needs to be
+	 * trapped when running a guest.
+	 **/
 	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1;
+}
+
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1 |
+					     ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+					     ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+					     ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1);
 }
=20
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
@@ -1616,6 +1634,6 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 		return;
=20
 	__compute_ich_hfgrtr(vcpu);
-	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+	__compute_ich_hfgwtr(vcpu);
 	__compute_fgt(vcpu, ICH_HFGITR_EL2);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 383ada0d75922..cef13bf6bb3a1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -696,6 +696,111 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu=
, struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_hmr(struct kvm_vcpu *vcpu, struct sys_reg_par=
ams *p,
+				 const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	if (p->Op2 =3D=3D 0) {	/* ICC_PPI_HMR0_EL1 */
+		p->regval =3D vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0];
+	} else {		/* ICC_PPI_HMR1_EL1 */
+		p->regval =3D vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1];
+	}
+
+	return true;
+}
+
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 masked_write;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & cpu_if->vgic_ppi_mask[p->Op2 % 2];
+	cpu_if->vgic_ich_ppi_enabler_entry[p->Op2 % 2] =3D masked_write;
+
+	return true;
+}
+
+static bool access_gicv5_ppi_pendr(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *p,
+				   const struct sys_reg_desc *r)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 masked_write;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & cpu_if->vgic_ppi_mask[p->Op2 % 2];
+
+	if (p->Op2 & 0x2) {	/* SPENDRx */
+		cpu_if->vgic_ppi_pendr_entry[p->Op2 % 2] |=3D masked_write;
+	} else {		/* CPENDRx */
+		cpu_if->vgic_ppi_pendr_entry[p->Op2 % 2] &=3D ~masked_write;
+	}
+
+	return true;
+}
+
+static bool access_gicv5_ppi_activer(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 masked_write;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & cpu_if->vgic_ppi_mask[p->Op2 % 2];
+
+	if (p->Op2 & 0x2) {	/* SACTIVERx */
+		cpu_if->vgic_ppi_activer_entry[p->Op2 % 2] |=3D masked_write;
+	} else {		/* CACTIVERx */
+		cpu_if->vgic_ppi_activer_entry[p->Op2 % 2] &=3D ~masked_write;
+	}
+
+	return true;
+}
+
+static bool access_gicv5_ppi_priorityr(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 mask, masked_write;
+	unsigned long mask_slice;
+	int i;
+	int reg_idx =3D ((p->CRm & 0x1) << 3) | p->Op2;
+	int mask_idx =3D reg_idx >=3D 8;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	/* Get the 8 bits of the mask that we care about */
+	mask_slice =3D (cpu_if->vgic_ppi_mask[mask_idx] >> (reg_idx % 8) * 8) & 0=
xff;
+
+	/* Generate our mask for the PRIORITYR */
+	mask =3D 0;
+	for_each_set_bit(i, &mask_slice, 8)
+		mask |=3D 0x1f << i * 8;
+
+	masked_write =3D p->regval & mask;
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_priorityr[reg_idx] =3D masked_write;
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3426,7 +3531,11 @@ static const struct sys_reg_desc sys_reg_descs[] =3D=
 {
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_PPI_HMR0_EL1), access_gicv5_ppi_hmr },
+	{ SYS_DESC(SYS_ICC_PPI_HMR1_EL1), access_gicv5_ppi_hmr },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
@@ -3440,6 +3549,30 @@ static const struct sys_reg_desc sys_reg_descs[] =3D=
 {
 	{ SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
 	{ SYS_DESC(SYS_ICC_IGRPEN0_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_PPI_CACTIVER0_EL1), access_gicv5_ppi_activer },
+	{ SYS_DESC(SYS_ICC_PPI_CACTIVER1_EL1), access_gicv5_ppi_activer },
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER0_EL1), access_gicv5_ppi_activer },
+	{ SYS_DESC(SYS_ICC_PPI_SACTIVER1_EL1), access_gicv5_ppi_activer },
+	{ SYS_DESC(SYS_ICC_PPI_CPENDR0_EL1), access_gicv5_ppi_pendr },
+	{ SYS_DESC(SYS_ICC_PPI_CPENDR1_EL1), access_gicv5_ppi_pendr },
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR0_EL1), access_gicv5_ppi_pendr },
+	{ SYS_DESC(SYS_ICC_PPI_SPENDR1_EL1), access_gicv5_ppi_pendr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR0_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR1_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR2_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR3_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR4_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR5_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR6_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR7_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR8_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR9_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR10_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR11_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR12_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR13_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR14_EL1), access_gicv5_ppi_priorityr },
+	{ SYS_DESC(SYS_ICC_PPI_PRIORITYR15_EL1), access_gicv5_ppi_priorityr },
=20
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1,=
 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
--=20
2.34.1

