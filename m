Return-Path: <kvm+bounces-67613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4418D0B8CF
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C1A930ACE2E
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B033236828E;
	Fri,  9 Jan 2026 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MBomrZf+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MBomrZf+"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010053.outbound.protection.outlook.com [52.101.69.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90C368262
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978361; cv=fail; b=FW7SQ6weQ7J6iiFB8DpaQJ5Vji1Tap7YOE9IhgoxgzI3sQt1fiYTQVxj8KvVjImeAMBTkdN4/f217TgRv1Xh/Y2mhIwAsyK+fExMxxMNjApIFdmvMjiThy8KKVRs/MS6Gti/vpWE4/Q0JR72f/t4TnMQvYQoOv2B5SPtAUWGokU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978361; c=relaxed/simple;
	bh=d4f5XplZv40eBnKfnH5/zDHvbAaBQic+HEnENR2L+CI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hZkJxyLFg/yt/4Pe+Ko60fc4jdTcqSYOMo7Xzw/p6EEsNqu63q922Nu+7ChktJEXNDbxIUP6WyASySQYFcCdYu/8Y91OnsXJvnVDxsaSlvbTENO/tKR93JtwDdeZxOozCshX+5BXdx5qWy7mJQ8GRVyFigDOBYJnpuHS5o5ebb8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MBomrZf+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MBomrZf+; arc=fail smtp.client-ip=52.101.69.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qAUk8ggA3CEWBm8fLPHd/yZGFSj7NczHaxGu2v6VQHtHfLtQfTsk+12efeGQC0jhPrZ1hKEt6KlVuVsg0SPpwzIZY4he2CgXhVpuuIoXOZJ1uZM3qPF7BnYzeYFjl93FtQ7rJFWnbMxhDJfiEhmrIOKxkh2V9rmdyTlLIShwkM7ixzh/Y5qyzl8k3l5Ldn2sf90smvBsgKEdA/94myLmSjTmysONSBk+3vvmnKNBz+XrXPxUamJjnTkJAaZu0s0sebUBSCrT8uFE+hqeMWhNtovXB7EStxQjehck4H7Bfqf4jzdduW/8hTDZvp397odBwHFksc3ZE7isiXugfZ5EYg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVzd+r3efZ8rqk5aQjBGL1O04qvL0XAbVKZ6ulqMM0g=;
 b=T3xBJebm6HVlcbIIJdEx9N+aO/upA+Cjs7xiQTQak2NqtxHDT2WEF8feqwNCAvmH4cEaLuhywKuQdRq1ZCt3dYBRkG4+dOph2wH5013E8I2Pks3KoruvhUZaCj6RZF1vsvCPrgtWdS0Quo2chDIMrkvZJvEFT5WsTnvEy8YJXgf/e/1aBa62clM2ktxpJtXdXhJo2Z4O53hWL5B++gt6/yg7fyiVg5byisK/lj1EDl+S/agMNwgngdbU9Q8HURCDaBTqB/Srpfj+7k9Ur8rxAnR99NQ6wAsSQxvi4FgoQvljKYeEsZ52Mm+V6CXbpHBY6kfdoSjbNQ4f/dTdjgvygw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVzd+r3efZ8rqk5aQjBGL1O04qvL0XAbVKZ6ulqMM0g=;
 b=MBomrZf+9lOPOtQo2OJISFVRBan0VJfBl3a3/sSTavJeZpWSCD7yoKejNyJNkLmM+fux7YHC/9hM2dQcYL1QSIt8PeHAVo9/0tPXQMYgMMbNXyYjX0+QRNKyqc2XnoV2cfrIeH3dmBPVT0GbCZK7XLnfAfGSiCtdlb9xBzHftfk=
Received: from DUZPR01CA0088.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::14) by DB3PR08MB8843.eurprd08.prod.outlook.com
 (2603:10a6:10:438::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 17:05:53 +0000
Received: from DU2PEPF00028D08.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::4) by DUZPR01CA0088.outlook.office365.com
 (2603:10a6:10:46a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D08.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I1dGATnNxsg2JXgzINGd+0YqAPmRjV8ZLJQFYxnSMdJu7V1704p1xWYr7hb6C4ghC72mC+MipwLtBF1oja7KmaoOWZlVktannhiEpIKwvJexD0tpTWQ9Cn1dJtEGirKPNylhG1uBp8ekGiAh6/8TILZhL65IU2fXyT225ora87xV0nhtVlT4lDVKuV6xEGfGp7zYFv/tXX20K7siQCQZGG9XZMK2dx9bapMoyUxWpnuTnBpsczBC9LBGRBT/L3COesdqICh6AgsMecP3m9/21sAkrf4qVRxWHuX8sTUfYtziX3Jav2+eZyVSM+CrSd+UiNg/PxAmEkB+CB+kiN9lxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVzd+r3efZ8rqk5aQjBGL1O04qvL0XAbVKZ6ulqMM0g=;
 b=U8/9a3fl+SFZuE0j/PPd7YTmsC0DYHd/cwoy9o14fWy4aXekqahqoSMq42NuI+glOVpM9RdxYeswzDfuuNDjAyrPtDyqQKZ3+q2iFokSiU2WeUliwR4gjt/TWMZuAw/BN71+Q/ALJjLEQ6UDqacoyzRPQY5J1kqOwPP8OVrJVkdrzz3BhTST7pnzAo7antISnDYgBhtlV2bHHsyB8D839yU3LguLsU6wfhS+IqokVYczDyDM2fEkHbTOIYnwYP5FeNl52L8GkIl2xMI0fUL0xuQdIUnASNuTEZP0UZh6Q8uHZyWq5aH/Os48RWJ/oKc7Y3Za4P1XQX4dxYrOu5fl6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVzd+r3efZ8rqk5aQjBGL1O04qvL0XAbVKZ6ulqMM0g=;
 b=MBomrZf+9lOPOtQo2OJISFVRBan0VJfBl3a3/sSTavJeZpWSCD7yoKejNyJNkLmM+fux7YHC/9hM2dQcYL1QSIt8PeHAVo9/0tPXQMYgMMbNXyYjX0+QRNKyqc2XnoV2cfrIeH3dmBPVT0GbCZK7XLnfAfGSiCtdlb9xBzHftfk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:50 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:50 +0000
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
Subject: [PATCH v3 27/36] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v3 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHcgYoPjEQGd69SGkmz324PZQ8sOg==
Date: Fri, 9 Jan 2026 17:04:47 +0000
Message-ID: <20260109170400.1585048-28-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DU2PEPF00028D08:EE_|DB3PR08MB8843:EE_
X-MS-Office365-Filtering-Correlation-Id: 646c3708-5c41-4298-2b85-08de4fa158c6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?lstbuWYkCT41lKnU8X1lx5WXSytpJkEM/3AOgIU0+QUtr2n+07Ix9eANZ3?=
 =?iso-8859-1?Q?UlM89ZmARAew9neHqfazGY5eHSiaKJxtG6gwK7220OGp0sCXYezUfl72lD?=
 =?iso-8859-1?Q?0PapWYHt4XqauDCOSCfvfBL0CQUI/UGHZ0tnwznMvhJUjA0GjTOl5G7odI?=
 =?iso-8859-1?Q?WU/6tSlf3lqG1T4+PmjAIzEJtuSll+te0vtlDqxz+IdsdyjXhN5Aqj3grf?=
 =?iso-8859-1?Q?yIb5f9VPQ+X09GP2RkBmE3b/Yl+LyEl9lrl8eXinwPwnNESpt8GeeMHapv?=
 =?iso-8859-1?Q?2CiXobHs4+3rU0QcpXBtK9UZe1RfR8TwOVlo54BF0BHgH/qXFkBVrWWRVq?=
 =?iso-8859-1?Q?g4YvusxLAvcaYH7iwAjEbI79td1V+aCiYYIn3BmKW5nkF6ysOK3yGzuWFl?=
 =?iso-8859-1?Q?EL4RtVqHGHGTfGuwvINJ5jZ1v551jwPjvXDfLAaiXyIO8ViVgZhKsk9DyV?=
 =?iso-8859-1?Q?i7NEL1XqrBxYLnywvZdJk+KONK0hX6rg+QTXwdQ/pQc62+UqDlou1luzXW?=
 =?iso-8859-1?Q?+RC6iMyOFtyEP9j6Ru1Y5hYwmgod/ccPXPhwGpbAYs3iUhdwQ5XQ77k5KQ?=
 =?iso-8859-1?Q?503oK8BmbMyjnt3cBnHs64+HYyzf4jBO431PdGtB51EKOpcbLXVqAW19qU?=
 =?iso-8859-1?Q?03GxW+aODAjBHIctcKm5l1FK32MEuOPd61QO5BiusJFhdFrKOdLxuoAz8z?=
 =?iso-8859-1?Q?0cUwITHByJKf0hop5Joki9etPzMFucyBOODTqeg3MmtHOaZWTFi387Yap4?=
 =?iso-8859-1?Q?Y9SJ7xg1RB0HC0WOfgXxVVVHQ8PtXvgug57xSPzx1e00b20XPovp2WYXTj?=
 =?iso-8859-1?Q?sr7tcmkbld8dJ9YW+QIMUcDDu/HRIRmhCJ2cKVy+BVbtDWJeaFeHaJEFrO?=
 =?iso-8859-1?Q?jV4SGsG+u6JuoYANSgq3KyejXq5E7N7YbNFROmLtbQXml8PhYHxDF1m94e?=
 =?iso-8859-1?Q?AWE9NBbmevparsrd9xG3Hz52HC6i02jpLKM7Y0V2ydxCedQbiVSWPOsELO?=
 =?iso-8859-1?Q?6uum/in/V0lFdkf6S9MySpyO7nuXXsGFU3ZqYt51pkmsuTQ49P8oMYPPxB?=
 =?iso-8859-1?Q?WmF9pGFxreOweJj8Nr7bqAecctq0hR9tozCOJ366UD2UVToEYgU/wCqMR+?=
 =?iso-8859-1?Q?wJzz7fKlGZO6Oz/S3PF9naflFeKoQI7eL+mVcpXYANp+83N4rLIKqGrSjG?=
 =?iso-8859-1?Q?Je12pjacCyy+ky4x4WqBP8Bf1t95XAqyWUmcnJLJVQU6wvHQkXCL42g+6l?=
 =?iso-8859-1?Q?ukVed2BuJPAYyDJpO3is1Jl6RDoJK33kCe4P0kEGBdxHKWoJfyyjaURBTx?=
 =?iso-8859-1?Q?R/zwN1Wf9Y5/rY8sOHc7NeDZ47toJc2MMNdGA/TXjvWhOMv+R7BbZMDmnI?=
 =?iso-8859-1?Q?dK8YQSnAzNBNgRKySuQVDYu7+pknXU39rCn1ehlvn5JsDLUMLt6BggNi6o?=
 =?iso-8859-1?Q?2XY9w5otZLUQDHn5nRXRPS/Pfx+mR7uT+5RQ4yXdn6REmtoDSUzm31jMHJ?=
 =?iso-8859-1?Q?CRklcBDZ2CsVdafkxI9qdNg9Wr7IYQWAwBmJKEEnz3xBkJp0tyJsadSo6C?=
 =?iso-8859-1?Q?3ymPFEVw61dCRkeoHnXYnR5OgrPd?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D08.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1f401815-eabe-4a5c-36b2-08de4fa13343
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|35042699022|36860700013|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?xUTjK6RDHGPWXvEhsZBByCTfrxjlXyhmQpHdncdXsPr+/y0JsOeH6ZYqIF?=
 =?iso-8859-1?Q?gDK+pJ//zADcQPvwe74MRZp7bCnF+aQIS7uwHBZBReIY7B9o4ADMJqFCTo?=
 =?iso-8859-1?Q?p/tNbbom9yqPta3KgyQSz8gYKdraw8y5DObl0fc3m5u24vT5NlfDBM6qtS?=
 =?iso-8859-1?Q?1LUZMtuNZW3wOd3yG1UL8FUXAxwQtfsLxxrgWXOOLzVQB6wTkzKNRrNMOK?=
 =?iso-8859-1?Q?ZsI42OCXfZWzYOlH0HdN5hMRVyGzHm41oU7iCJmOOb7WsxtKjSpRlYO4v8?=
 =?iso-8859-1?Q?8MczWgCyJV/2SWoHsufirr62TgICoXK5tyFakvMz8e/0Actqc2cGiHN/G5?=
 =?iso-8859-1?Q?Zue3mTDx4z8GkRLG8qk9JRst8Z6hryOzFtUcqVQCHWkxJTkDTR3m/BS8K1?=
 =?iso-8859-1?Q?H4i33vERUVR+IpbwZwLQoBLxP9f3ZJBwc3MXKZ1ngI/0bBacqsnpsYWI7T?=
 =?iso-8859-1?Q?Yv/eMWenfL1FN6ExdSjvMKdGTPJKsw9nynbFoRtSQctm9OLw3QiG2Pne4p?=
 =?iso-8859-1?Q?ccK85JF/PxKzosq/faqLYuebihvmz9CmJ/rT7esT0xjj37zwzdvawwhyTb?=
 =?iso-8859-1?Q?K4o1444s/quZKQ2khNTwkEindqj8WoN4yUeb49BE0vONgEWi0U0bUbnemq?=
 =?iso-8859-1?Q?txEbfO4Y84ql0pBgqSwnjRHEU+zwmvzPc477g88eHpOKUevH3HqdFTBMdi?=
 =?iso-8859-1?Q?+HcLrqUD4Tkg/AGC6AhkSnsJnk8bsPtMJYUDG2GBRdmnOzMXvnCPTMQE9r?=
 =?iso-8859-1?Q?NOTt3k8bQ22H/IV1UOISGFw3/m/Vdg7NDYDQMFHIi9hP27DuWvnNQ+cYHh?=
 =?iso-8859-1?Q?YIWgWiXkaE8ycQEJBc79EVgL4V8PpsKq0oKr/v6T22kFhKGX8mT8SngRfH?=
 =?iso-8859-1?Q?L76xfIp5Xp0qGmjoBu/jkegM0ck7ziYBaHZ0iEHgIIsjEJPMQ1lH9KLs5l?=
 =?iso-8859-1?Q?P/2HtvY+6n20l9MTVMxIR3LPKg7HqGrq+r/woFYmZIMk2qsilkGB6g2eW9?=
 =?iso-8859-1?Q?rPBkXhyOFKm96pqiw8NmODI2WnkvlDXWIgMIhkqW+qkDb9Pw9edMJu60T5?=
 =?iso-8859-1?Q?WF6dD8bJFl/Kadh0M+ukODxyGpTEfUmAsmfVZHPgG6PIoHsA5h4+YltwGR?=
 =?iso-8859-1?Q?X3nM+m70pXCx7hl1u/TdQKj4Ju1uovlc19EHeqWXndDMrGVZ7LuQbXqjdk?=
 =?iso-8859-1?Q?4o+ZtId2rJdcjOOvFaGklz6VJROjintQVwKkceWBdAcQN6rY6PqsJnIOrS?=
 =?iso-8859-1?Q?nW8Xs3kbZU/oS9H/lzrpNXAsjpN8dTffzvvCjvVAn2YExYVX7oTDnsHDxQ?=
 =?iso-8859-1?Q?IRgqqnJJu25WtQ+iEOT3SyTf3OPZAwHGSdXUuUb0l4UVMuCSTShkDxkjdT?=
 =?iso-8859-1?Q?MXQphsBRouHjE63X7tOEdldcWFgzZgbTZxcxtI0NKuQmd5iRI64mnfKFmJ?=
 =?iso-8859-1?Q?UwcD3Co6nUz0jBxpKumFRSE/xZEUXRj9xGiW+tjGmbQ2LKP1yavtBphlRe?=
 =?iso-8859-1?Q?jk6DibY3YiK5ogCjiNWHPMTIFqSpkGWy6hDDpbSeWinH36gg4Oh7bQLFc/?=
 =?iso-8859-1?Q?eMgTqCrZgJ7DFC1xW+10S3Ozis7lefoyF/1Zqd+Ez+CucFHu9HRGHJOMLA?=
 =?iso-8859-1?Q?R60u9UVJPrnlE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(35042699022)(36860700013)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:52.9926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 646c3708-5c41-4298-2b85-08de4fa158c6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D08.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8843

Make it mandatory to use the architected PPI when running a GICv5
guest. Attempts to set anything other than the architected PPI (23)
are rejected.

Additionally, KVM_ARM_VCPU_PMU_V3_INIT is relaxed to no longer require
KVM_ARM_VCPU_PMU_V3_IRQ to be called for GICv5-based guests. In this
case, the architectued PPI is automatically used.

Documentation is bumped accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  5 +++--
 arch/arm64/kvm/pmu-emul.c               | 13 +++++++++++--
 include/kvm/arm_pmu.h                   |  5 ++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/k=
vm/devices/vcpu.rst
index 60bf205cb3730..5e38058200105 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -37,7 +37,8 @@ Returns:
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interr=
upt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interr=
upt
 type must be same for each vcpu. As a PPI, the interrupt number is the sam=
e for
-all vcpus, while as an SPI it must be a separate number per vcpu.
+all vcpus, while as an SPI it must be a separate number per vcpu. For
+GICv5-based guests, the architected PPI (23) must be used.
=20
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 ---------------------------------------
@@ -50,7 +51,7 @@ Returns:
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set
+		  number not set (non-GICv5 guests, only)
 	 -EBUSY   PMUv3 already initialized
 	 =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index afc838ea2503e..ba7f22b636040 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
=20
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			if (!vgic_is_v5(vcpu->kvm))
+				return -ENXIO;
+
+			/* Use the architected irq number for GICv5. */
+			vcpu->arch.pmu.irq_num =3D KVM_ARMV8_PMU_GICV5_IRQ;
+		}
=20
 		ret =3D kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
 					 &vcpu->arch.pmu);
@@ -988,6 +993,10 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
=20
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (vgic_is_v5(kvm) && irq !=3D KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..0a36a3d5c8944 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,9 @@
=20
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
=20
+/* PPI #23 - architecturally specified for GICv5 */
+#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -38,7 +41,7 @@ struct arm_pmu_entry {
 };
=20
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_NR=
_SGIS)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 =
val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx,=
 u64 val);
--=20
2.34.1

