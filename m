Return-Path: <kvm+bounces-56085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C03B39AD5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181779836CC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8825730F921;
	Thu, 28 Aug 2025 11:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GWrz2KK1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GWrz2KK1"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012006.outbound.protection.outlook.com [52.101.66.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F04830F549;
	Thu, 28 Aug 2025 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378826; cv=fail; b=mgRX0+iqd6U2dXXl+/4T3sD1SMbRsnqhdKm9VbVd9DyXCVIvukebn3oxneKMPLsKCOLSpR3yTvCR8XsbZfPnlUN/zZzcFjM/jXSu4wjn4QECz5C1Gc5eEcuZ8huz/Fcwn6/lrw/e7OED162bXRIAYUcQEVjrTLKZ9I4NUI+lGoM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378826; c=relaxed/simple;
	bh=+MbyzTX4+0vGJkwU/rg1OgBRq33MdNnJmMvbzo3OhaA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nqkUCyJMH3QzaB9JX7j/qmzn/u0+ZuDuNWIC37NCh+QNO9wvxYnukZaQ7RjLQQIBv9OYlpamS97guYPXIgv9w3wgPBT6kKmJ1iXhSDDntbqFSSYYmlHKuvu17absvX1S6Kso+EhkLo1J0OhFurTY9rckrTUoQ6a7gdhKSaXuIrI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GWrz2KK1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GWrz2KK1; arc=fail smtp.client-ip=52.101.66.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SMqgUqRJJoifujMES+2rGk/OWs2A+sJxZYPKdcwfzEjWJkmNjGAH0Tee3WzkSpUYdWTUZ+SQfJ0Hks4AxMAum8jlOvKzhsyF0zZbgdXRVvJ3m5ziEcHl7xDuHoSdpdsTVvBJpCoETEu9NIQrvg/SYmYbEEMToPviiisHCHjjzRMT6t8Lz+sww9IzdvZVs8DBO7ymKTE+jcr7ss+zt9P0tK3KuPamwXVsS+DeoHXr8C62USt0/X+nnVB9CdGDfMUTSQRpeSh2p/Rx9GWk09cbYU/K6w9CELeJbJs5HT4XcFcSjioMTXEPrfk39nO3eiscQGsOc2X+s9C1Rcr9br9e1w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRdDdftjgbnDXW72vYFTbkkTLrzZRGvd32QE5mhAWqc=;
 b=VvqZ7lPJd/drhj/Jh5z2TWUlmxLj8byRWrsqG5XCNhRvFaD8/StDw9IUOBCDChAFE/E8iMZ4Dke16iQ5Ao+whagLYzxXrWmvWQBT9HT+Wu3YJwNn9Ela0k3l8xCGwv4mOqitg7ywNt7KtbnZkDHuc2lyezn76VyewfPcb2NXxBS+GwjsMMzT5mrAkAe9HpZ73hj4LF9WCBnEx8koP9TEdjCqzupNrsI2Upnt826SxIH9NIiee9Dn49rgWd8DgN0wjbJvdMz6KI56xRUHurio4Dvp7cxPPukjF1vxBQjB5SSr1nIZEfuNo+/zj8LgdCoo1HW/B4ZhbkL5EO8ITMNgPg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRdDdftjgbnDXW72vYFTbkkTLrzZRGvd32QE5mhAWqc=;
 b=GWrz2KK10KHH9sekroz+ob+ZQC74ZCcPg9RrmFqP8FR6E8VFjcVZWZA/ePfMTfLN3lNfXOTg3GZ+34sxKSjJMcuSO3X8eb1/l1rRExwVVwMDUalvSd6UzOnxEHvoB8xQ5flHbFBn3G7tQOBQLjDLWK1SEtiSkdpJxEKyXz/mxOc=
Received: from AM0PR08CA0026.eurprd08.prod.outlook.com (2603:10a6:208:d2::39)
 by DU0PR08MB8017.eurprd08.prod.outlook.com (2603:10a6:10:3e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.24; Thu, 28 Aug
 2025 11:00:16 +0000
Received: from AM4PEPF00025F95.EURPRD83.prod.outlook.com
 (2603:10a6:208:d2:cafe::cd) by AM0PR08CA0026.outlook.office365.com
 (2603:10a6:208:d2::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:00:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F95.mail.protection.outlook.com (10.167.16.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.0 via
 Frontend Transport; Thu, 28 Aug 2025 11:00:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SU0o2xYPI4a00B6RxfQjca5r3c4Dw+QV18AH9XNwl4u/DN8UHZ58+LTstrG7spQcmUtsrIv4VIOkCJ5w+XkNYOXtFvNgFLvLBsNs9wh7IK+HXe5AdigvaYkF28yOUTXzkWiZ1xvIvspLELIGxyp8esMZ1Jue1/+2mER4ek3EjgpUxS7fr4nNpz5hf+SCh7xyov7ST4eE5Qjeclpm2ELSqMul/xidiqCP+JANmZpqh3NHMVoYH3OWBoQOTQlSP37mUsjoMoQeeqbfzDaX88i9MdwkkdQFAVH14/OY74FDdga+IYAXJRScIppQO/PzJDproK/K4mX9EweOZO3LWwBI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRdDdftjgbnDXW72vYFTbkkTLrzZRGvd32QE5mhAWqc=;
 b=LGXeaOwZQ0Uy5wYfJdHFvSzdQHzrrGPYr5raLJYF7+nWWU6bNKeadsv9Fe6nCNb4LJ+eJ1P00X/Sp+LlaieUg5u+AJHTZagBsRyb2uA0hOB99uPbylVk9n9lVmb6PcW5e727VU0aCh3oaxw04fqOJiStKRZ6R/aqNKSlOkR7NjJP9GL52ox01p0aP5X0Oed+pO6p8QM81063CVIiuFsE9d0QZvyV7/mx6KiTmSzRb94QK4KUUTM5ZzlFcgpVdJAPUnFRpU7nAi2zRWproIzrtwC+TH/fWHhgedfQjQmmeGD6WTiuUaKtXMiVK9dWcFngeiOjKzauf8ou0w/tHUHsBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRdDdftjgbnDXW72vYFTbkkTLrzZRGvd32QE5mhAWqc=;
 b=GWrz2KK10KHH9sekroz+ob+ZQC74ZCcPg9RrmFqP8FR6E8VFjcVZWZA/ePfMTfLN3lNfXOTg3GZ+34sxKSjJMcuSO3X8eb1/l1rRExwVVwMDUalvSd6UzOnxEHvoB8xQ5flHbFBn3G7tQOBQLjDLWK1SEtiSkdpJxEKyXz/mxOc=
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com (2603:10a6:10:46e::5)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 10:59:42 +0000
Received: from DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31]) by DU2PR08MB10202.eurprd08.prod.outlook.com
 ([fe80::871d:8cc1:8a32:2d31%3]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:59:42 +0000
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
Subject: [PATCH 3/5] arm64: cpucaps: Add GICv5 Legacy vCPU interface
 (GCIE_LEGACY) capability
Thread-Topic: [PATCH 3/5] arm64: cpucaps: Add GICv5 Legacy vCPU interface
 (GCIE_LEGACY) capability
Thread-Index: AQHcGArbI7nZmYTmvUaD0mJb7qSXTw==
Date: Thu, 28 Aug 2025 10:59:42 +0000
Message-ID: <20250828105925.3865158-4-sascha.bischoff@arm.com>
References: <20250828105925.3865158-1-sascha.bischoff@arm.com>
In-Reply-To: <20250828105925.3865158-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DU2PR08MB10202:EE_|DBBPR08MB10481:EE_|AM4PEPF00025F95:EE_|DU0PR08MB8017:EE_
X-MS-Office365-Filtering-Correlation-Id: f0e63efa-3c49-4d4e-b7e1-08dde62211d3
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?jsGp5mCshDjh09D6OITWE5BCbPpqU2UkYtgs5A0muBqm5JIH1Zbn+qcTpn?=
 =?iso-8859-1?Q?0Lm6BiP4FFESmWBYsMcYOHsjHX7Jwj4M/QdW5yqRz5ziFUmSbmjCGltxak?=
 =?iso-8859-1?Q?zdsSoViacPdfzBRIcf7mWtnfsDhhLWUFWnJ9DfvbVKvns3sYugI2ikb5aA?=
 =?iso-8859-1?Q?pl75rfnKkyDLUiBrI6pDNv21R4nO2ZcCfmFjrWGq71S2elXh6Wrm82eH+N?=
 =?iso-8859-1?Q?pzG1MdvBHgH7NiRL0TdB/FOycVkpCY8ZsrjiKcLNWS/RFidnGDhtNVfEEb?=
 =?iso-8859-1?Q?bbtD8BJzAGVsfeUTqOANA8nGy5WT/MJnNpFNjkFXfLeaMfTCQL6aTu339S?=
 =?iso-8859-1?Q?cCgvonP8gb+AOVLFe6Gn2Do3xA5v6ZwLrPMKW39eItasxsIJiQpMWeP70E?=
 =?iso-8859-1?Q?XfdWyqoHwbd/ivB9QIqIpSps58Cu/9A00SPiVoqJkH1hawsN+jb/0du7Zo?=
 =?iso-8859-1?Q?lIC+6cZClGlXJFx9Ilz0vCDfrKpaPQ4uhhx4IM7PR2GC9i/F79hfNjBDeh?=
 =?iso-8859-1?Q?HjwbIuYNF1KyuZCZZdoV9rBVtegiOsu0++/6vlurgDEnToiOFP3ldrnaWV?=
 =?iso-8859-1?Q?6twNeZrM8V1v406QxsLzrCJbz0TbKr0S0EmTtVOOS4tstikZXEVFZgpDKi?=
 =?iso-8859-1?Q?7PhhdccfSLCjvj+HR0iMzVtBJH4oopXS0hZcRg4oInZlwkJJSIXBJIcR03?=
 =?iso-8859-1?Q?dhrAXVLVEGZ8rutPLuyO4Zb5LGspIsB5WF6fOm4CegKNdIcKjqI5iIJBYT?=
 =?iso-8859-1?Q?Y4n3LCKHqCADLOtjvn3Cz9ybKqChYy8jpKf2+xTjgLkB+T2CEy/gkyEZJ8?=
 =?iso-8859-1?Q?dFzL1aBXjFYIx26k/QqbEaJ1i5v8oFoEhF/dKhPaD7UPg70ODy6FSQ0L4t?=
 =?iso-8859-1?Q?3dR8RdUxXGXIoAxJ82cC2vaXN20dkppTfQdKaLA6zNo8Xm/Zx5X9AWtLHh?=
 =?iso-8859-1?Q?TFh5dfvLTR835a9uyHu8CInNZQhVspcCFIQsdis0G3GuPqmZMQaMWSXiXu?=
 =?iso-8859-1?Q?UsIrCmTdWOdS9YB17yF0BSSOLM8lwFYV4O4tVqPS6JVqLgjrpCfyreoAul?=
 =?iso-8859-1?Q?g3+dyT5m8o7ZSh+ybT/9UHS178YdmOBVoMH0Nw6nDaQKPCf0cmpiUlBjGr?=
 =?iso-8859-1?Q?8+Xt8P8vUY9VRy9Pgb2tIfCBJI3FkBRSCyX8NeFYbj2gJFIAokB76fEuJq?=
 =?iso-8859-1?Q?qCxjUyeCtGj8aR3jxYRe9Ub6RQUlqOUVJX+3fPa0b+zVtN5oTBRusALjdz?=
 =?iso-8859-1?Q?dSWyhbeT7Hi2Rwp4h3CwwZ32TmzjP3rTuCN9A5sFZOnrs4dzFqEJZY65Oo?=
 =?iso-8859-1?Q?m0U4MRiVG6myu2wu7rPhcil++HVDWVmAGY52amEbRv1Kgf1nYcrl1pClBr?=
 =?iso-8859-1?Q?GskQ8uEc+T0N5TsntV8KAFKVX22cHWApYT8DGpyo/+RvlZPsuFcW6NzHn9?=
 =?iso-8859-1?Q?w7nZE/J6egHVF8y4xPFA3Fb9i7qkVcBAb/46NPdr13XmOvNZ1xfeN8shyu?=
 =?iso-8859-1?Q?lx5m7Ri3P80mRiaNcVK2RI3TLs50SFzz06SNBk29JI8g=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR08MB10202.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	086ead93-4d56-4a03-9e2c-08dde621fe1e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|376014|7416014|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?7HxzSHiScc9l4tic9KiU7PFJI8BbUlL8x4O5B6PlqBEeEP1iN3olF60OxJ?=
 =?iso-8859-1?Q?W3km2mWEH23h8ZOkDG1g8OG9Jb5Jt1ek/UckbmOD91NoMFvOVLFuAqPOBt?=
 =?iso-8859-1?Q?chK0XCir3JUDUyywwJvLDCjfXaKC13Znkbjs07eu5gqa3hCB9StfHisavn?=
 =?iso-8859-1?Q?6pwyhiMdvpl18Lfy3CcAb9PxlkQBVxkiT0lSmT/dgzlMUn9eBjPBF7o3a+?=
 =?iso-8859-1?Q?pomPrHQg3zxaDpOTKEuStzouUVqHmfG/1Jydp/rzFhX5Q+ESvhpv65Bg4f?=
 =?iso-8859-1?Q?fcM1f7uJbk1phK7SH5McfF75ySx9FxOva9d/D0zaoXnouTj0/gADxcqfBI?=
 =?iso-8859-1?Q?YUBfNfJPTOgICoBO5Vd2lfFeNdeB8W5x6Nfo1b/Sp84OdsXiEsZuaEInXi?=
 =?iso-8859-1?Q?w+Qx2QmFULAb53QEWR6psfNXjHiIub9+weAaI9/sV1WuJvpAT+pNjx1YPI?=
 =?iso-8859-1?Q?ktz6SEAIypW8hUuV5Yi3q90hfIzdu6f/h/Qcn4kgrM+ohOrhh7XX7Kh/Jm?=
 =?iso-8859-1?Q?JLBPe9JtPVoBYnaG+UyJVfp3SYWFq+bmtup4h62sPpBWbso4efXgwBz7Nk?=
 =?iso-8859-1?Q?vEHgiOXeYyG4GK2+Kpknxw4TRaLitrGWdLPQ+jxMcHOMnZ6dHeYApkwXuO?=
 =?iso-8859-1?Q?X41R95mHmORAlDfqQM50DlSOiWIxorC+tFvV/BCHn6WLXv8baDEFEVOaGk?=
 =?iso-8859-1?Q?fPZMCYcw5vZ5XkNWFg5WDN2JJPF54orGvlhzawPxBX7K3ax9Yrl5Cq/ISV?=
 =?iso-8859-1?Q?pr6j1a97BW1bpyOpQP4g597b/bVM/EtsRpI0DjK8LGYorlNTLYbxiqNs2E?=
 =?iso-8859-1?Q?dXpJ4d9VE/N4LezSGu91oOVfIrmvCl3rEbwcxkCXpc58fd7rJy9nSNAJZo?=
 =?iso-8859-1?Q?HAXUiJD+u7/jNc+uhwnAWnTZtRTvIljdsJxNqaaPLp/S16wNyHnpn1eHKz?=
 =?iso-8859-1?Q?/2aho9woTAk/36lgiBOuVJG8nCmv0VACXR2uI7sOeYYVSGZkcT3f00QvIL?=
 =?iso-8859-1?Q?fBrlajAXLhbuuPyiCnS1aRcAM+/avbSWBrwqFgvvpJTHFVR1uNNypJ0CnM?=
 =?iso-8859-1?Q?qUp0Q2yQzWrxKFy9uOYhyZ6PxZEVXMNn8TKDT/0c3NIzE5SfeHWazmm6Hu?=
 =?iso-8859-1?Q?E9i0jPo235cho5i+voPkbl8IwLa7hfh069SrxJVPM2GwXByfFQY63Sma+o?=
 =?iso-8859-1?Q?GnEE2gjFFNl09xeTLWZCaeCMAP6QIoPjDDTBpV6dY3kgq2yu5zYUNM9iHD?=
 =?iso-8859-1?Q?JhAWJImtkf66axcRxxPMvEsENxFXg8BgeBGiq0g9aPnEFZAOD3Br6FpdGy?=
 =?iso-8859-1?Q?YZGNwumpS05L2qoHUO8DYMZgdzGZCRUXl+DeRWRGW04Uhm38+tONB0/I2O?=
 =?iso-8859-1?Q?LiKcnM76qn7Uwas6LUqp40msyWxNG9RmbKgl4GFeHytTJ56b9mv5bcoNJb?=
 =?iso-8859-1?Q?j0wGwxo4RSU7w3LoB1PZu2ScxVho5TXZhVng8adF7vpgLYLvhwU7gY+GGE?=
 =?iso-8859-1?Q?uGm4Sj5cHoE526o9idEiLEpLH0vOlP/HJZBImjhZmTlai0/YomksLXY9bi?=
 =?iso-8859-1?Q?DwIT/T07d8RUo1nEWsuRIs/xCySl?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(376014)(7416014)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:00:15.7660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e63efa-3c49-4d4e-b7e1-08dde62211d3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F95.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8017

Implement the GCIE_LEGACY capability as a system feature to be able to
check for support from KVM. The type is explicitly
ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE, which means that the capability
is enabled early if all boot CPUs support it. Additionally, if this
capability is enabled during boot, it prevents late onlining of CPUs
that lack it, thereby avoiding potential mismatched configurations
which would break KVM.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 15 +++++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.=
c
index 9ad065f15f1d..afb3b10afd75 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2520,6 +2520,15 @@ test_has_mpam_hcr(const struct arm64_cpu_capabilitie=
s *entry, int scope)
 	return idr & MPAMIDR_EL1_HAS_HCR;
 }
=20
+static bool
+test_has_gicv5_legacy(const struct arm64_cpu_capabilities *entry, int scop=
e)
+{
+	if (!this_cpu_has_cap(ARM64_HAS_GICV5_CPUIF))
+		return false;
+
+	return !!(read_sysreg_s(SYS_ICC_IDR0_EL1) & ICC_IDR0_EL1_GCIE_LEGACY);
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] =3D {
 	{
 		.capability =3D ARM64_ALWAYS_BOOT,
@@ -3131,6 +3140,12 @@ static const struct arm64_cpu_capabilities arm64_fea=
tures[] =3D {
 		.matches =3D has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, GCIE, IMP)
 	},
+	{
+		.desc =3D "GICv5 Legacy vCPU interface",
+		.type =3D ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE,
+		.capability =3D ARM64_HAS_GICV5_LEGACY,
+		.matches =3D test_has_gicv5_legacy,
+	},
 	{},
 };
=20
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index ef0b7946f5a4..d055664613e6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -37,6 +37,7 @@ HAS_GENERIC_AUTH_ARCH_QARMA5
 HAS_GENERIC_AUTH_IMP_DEF
 HAS_GICV3_CPUIF
 HAS_GICV5_CPUIF
+HAS_GICV5_LEGACY
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCR_NV1
--=20
2.34.1

