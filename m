Return-Path: <kvm+bounces-42418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBA4A7854D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 01:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB61A18858AE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 23:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCA021A447;
	Tue,  1 Apr 2025 23:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KbMi0Vny";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KbMi0Vny"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2074.outbound.protection.outlook.com [40.107.22.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A86520766A;
	Tue,  1 Apr 2025 23:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.74
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743550725; cv=fail; b=l9JkvDC78dNyJVxbrdng/bV5kWXZM/RMpGzGeUN9PwzzAnUTKjMi7nLNdROF8YvwgkF4S1IXJf7O7QRSs6mgemfmuUiA13IrrNbilbnm1Uj244523f18+ahWDpVuuFosrLfzfwQSqkoOyrgFKQk4Bzd5TERM0T4pGeWUDl47b4s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743550725; c=relaxed/simple;
	bh=NdUgP2DKp+B+1uQzfxibKbjbLH9+ForSGzONMgU0oEs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eH3RJyU7ee+aGcfQa8RiptYnqxBg5IraJmbNlCNiN7bnu1yeEUr68oLzM/ZEyq24H142p+cKV5ocOxif1/TPgp1+cyMSkjO85oqoPlFtZY3CmpCorYds8gELBY3o9bV3OjavwWF2C04TNpWi2Rq7skmDRrKABffHK1QZ2+gPfJI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KbMi0Vny; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KbMi0Vny; arc=fail smtp.client-ip=40.107.22.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Kive/wAwXHILsWj9LjTlipG3fPhMz/fmvMV+eLxk4/nkVVGlUvL83vRWDN9ENWFlS+Cz3Mq32peml7M4JztVngeL/c6935q0zJ+iBuM7qtrd3Bs8lA0PfQpRxuHiwfBO2KgqgjRl27N9diGhGg6vEdpt4Tj/tuf8AXXSEjKELp9Z0mWEXpc0wV9PhCecMfDihQ7dpUXIQGDzb4x33MyVh6dYp2A59RTohlciIIqcV3NR7QwGAser8c2PAMd0gCqMT5zxhL9PlSHHOSimLYvYeVaz2aXfHkirJOUHM8T3PgpN9Sx6OT/LygbbwvcebbvAEC9cP6qoqjtM4YJoN9vIyA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdUgP2DKp+B+1uQzfxibKbjbLH9+ForSGzONMgU0oEs=;
 b=YORXIP5YVlE9jxVNrtdvPcG1OW/CAGJW6IRjJm8kNgyvilNAdzpr7/hw26n5kDYbCMYkH5MhFs9poed7mW6/CFyclHYswiIdGmtAD/sp9EBsw5om5pCGMqyWDineF2dF0u6ycQi9wBnuLLdMoD4G78nxZIweDF6iTd/EcSXrIVATCPfpQlb3+3EDZ06ZeNrw+zCsj0qR3mmbfQR0QbOpSZxeXU7gNGEolluJGhgy7bi9X4siBpkh4t1ver/uPH5TOHmeeS68Nbdn/UPUk1IO9dNQCivf24nkh5PK8CBOw3DcAdpwIfjDycKTSnIuHZUPMmWLaSwG8lUeNdp65p4SGA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=fail (sender ip is
 4.158.2.129) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdUgP2DKp+B+1uQzfxibKbjbLH9+ForSGzONMgU0oEs=;
 b=KbMi0Vnyq+XmoZ8Ne0WheK2y5g7EI0PdaDr2R+EmVuu0x/AZ0r/DadPz4aquq5U3prJwYkw5dCyLpZkzFX8BpC9+TW+cyzF3EpMRbzesGyIFFWMnC5XqEAgEVMJEYS4IwxXZe4dhCisOJ5c2oYRIbPRRwLb/oVqXm1/haXT9TYg=
Received: from DUZPR01CA0323.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::24) by DU5PR08MB10823.eurprd08.prod.outlook.com
 (2603:10a6:10:528::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Tue, 1 Apr
 2025 23:38:34 +0000
Received: from DU2PEPF00028D09.eurprd03.prod.outlook.com
 (2603:10a6:10:4ba:cafe::eb) by DUZPR01CA0323.outlook.office365.com
 (2603:10a6:10:4ba::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.41 via Frontend Transport; Tue,
 1 Apr 2025 23:38:34 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com;
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D09.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.22
 via Frontend Transport; Tue, 1 Apr 2025 23:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lV68Fon8igUu3E8547FbB31lvUWoopsbaipGsR1ihTIYTjFuUUPJDNZQjdxva9LyNxaIV/X2KLRrIWRoNfzKOPn/wFI58vKYWV8VQBXsT+BgaMTnPNYFWj6lpHZHp0UZLgoJCipM2ZvZM7InPO0QT6ad6pvbflUGVKOJkxd+Lm9xbHev/BaIpJQE+neT/toVxPNbcg7RBX+xzCPpizCBGr6xdYGhORcj9uo20Ilf2BYNQjWp20kuMHHOEIl0z4Oks7C4AsOSsAg/b9FW6UHdEjbkfGDtIECv7sqoBTUeBBn4q9cb268bbmEdlFMA9KvE3Q26QjwSyTw0BBVUw5iGOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdUgP2DKp+B+1uQzfxibKbjbLH9+ForSGzONMgU0oEs=;
 b=DmAbMtK7CE62LZaB2Hu9Hi9BwpARuqxQDRTv+UZyZr/Ft7ACNK4eWwkXVy4X7WU802FF/kPqa3n5yFbDyyAgjV8993c2P1x9JYf7mWWvZwBxVBVfa2j9vYxb/TiCAbJY4ywjuT6jVnaZR8+OWRxt2ngEFlkPKCZcA38hGTQZ8V8hcoETM0mAQaxMqF4UTCyvsCmxoC96j60GpwTbxGgJqqOw1nfMXQ3rNXVssT/MGWcLbXcWoHDcmCFfDO/Z0gy6VyBstod0mfob77Ti/+15Y5Jgi5ntsUng66mXs51n+jvkXY5y0cX1/PqeG+NlxGtTmK7rSBCBqOR4XWVpwYh8Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdUgP2DKp+B+1uQzfxibKbjbLH9+ForSGzONMgU0oEs=;
 b=KbMi0Vnyq+XmoZ8Ne0WheK2y5g7EI0PdaDr2R+EmVuu0x/AZ0r/DadPz4aquq5U3prJwYkw5dCyLpZkzFX8BpC9+TW+cyzF3EpMRbzesGyIFFWMnC5XqEAgEVMJEYS4IwxXZe4dhCisOJ5c2oYRIbPRRwLb/oVqXm1/haXT9TYg=
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com (2603:10a6:102:33a::19)
 by DBBPR08MB10602.eurprd08.prod.outlook.com (2603:10a6:10:52c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.52; Tue, 1 Apr
 2025 23:38:01 +0000
Received: from PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294]) by PAWPR08MB8909.eurprd08.prod.outlook.com
 ([fe80::613d:8d51:60e5:d294%5]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 23:38:01 +0000
From: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, "Tian, Kevin" <kevin.tian@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
	<Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>, Honnappa Nagarahalli
	<Honnappa.Nagarahalli@arm.com>, Jeremy Linton <Jeremy.Linton@arm.com>
Subject: RE: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Topic: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Thread-Index:
 AQHbhLKEApVfqCfEsEO/VXZQklRIvLNjFiyAgACJGACAADH7gIAAQ1nQgAsppICAH9hWAIAAlytg
Date: Tue, 1 Apr 2025 23:38:01 +0000
Message-ID:
 <PAWPR08MB8909781BE207255E830DE1589FAC2@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250401141138.GE186258@ziepe.ca>
In-Reply-To: <20250401141138.GE186258@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PAWPR08MB8909:EE_|DBBPR08MB10602:EE_|DU2PEPF00028D09:EE_|DU5PR08MB10823:EE_
X-MS-Office365-Filtering-Correlation-Id: 02057611-a697-4f77-6e2f-08dd717651b0
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?f5UyNBDRRMatjJ3yYGYMBQbGF9Ns71KJAhFyal5wjW1q0GLY4b2ehyAsx1+g?=
 =?us-ascii?Q?KI0fUmH3c3htE1Na3Izi+a8QlrGZVBniUEdTQqwfIfu21bF7ndZ5aqTg/G+o?=
 =?us-ascii?Q?Mva+AaW0ufz8OzaeMM0KBxSnn28XaNSx7/jrcfzxb0VZfJzRda2Ba1nmvMeD?=
 =?us-ascii?Q?hgv2d+Jzq6a8UuvmFc/dO3LQ2z8/Ihrpgo6cYjKeVHdBh9xmj5H6Fp8la8GV?=
 =?us-ascii?Q?IOEIb9vhLi4LKnOONiZ2bzd1THBmdJiZDP7ea+Fq5jXKFltPzjnnH2n/pAD/?=
 =?us-ascii?Q?wh9cRcPJYAD7CxN+lBeowly1Yuetm0btSeqXz/fvnCQIuNCOFzhsCHGi22TS?=
 =?us-ascii?Q?jrWKoEC471TZCmrhTypMpm67X3JTBLLwWGt7E7y0t04M8q3A5bkPoff2aLaI?=
 =?us-ascii?Q?QIqNNp1jWAXwAhOHAdAitW6LU2qSQhsD3quuaa9RdA9gj+cTOIh0wQ0QCr5Z?=
 =?us-ascii?Q?q1MPNvBK7/i2r/3dZC0gt5FSNAc5nWX6mVSMqwl53R0EDjJlM9rudU46kTtH?=
 =?us-ascii?Q?X5+OKoECbAg7Lpe3WvtOsZ02d6l8kyCVzj2utSov0ODBNIxIPNLsqCl56ow7?=
 =?us-ascii?Q?qA7mvG4aQRVHqiKwE7I9WuFDsX9Apvr/KE6zwL891Ew1yeuLBjJ7BJaFqlgc?=
 =?us-ascii?Q?WsrSQZlEHUygVIPIB6CljxPYhQ9hDvHtzB94qpsSafaOC4rpwAbgAE4l7YQ3?=
 =?us-ascii?Q?RR75vF4SG+mJy6nu5/Vz/XUJWU+em6UZclkfoeqKQBM0mGwXvYlaL5NxXmKF?=
 =?us-ascii?Q?IeTiNhPK1HK7TzVR4nIAINWuUoYjood0TICwpD6tVMgxzKAC6lm+vlttYQd2?=
 =?us-ascii?Q?V+s86QvjHvRvbexxc90MUIR07VgPYZHX5frd8Hgwfy+MHHTKR//F2yDOK5bA?=
 =?us-ascii?Q?X4O3nB2zTepL+JAtUaati0YoliB1LmIh0jq9i2mEM23evQMatHuhi89AZwsn?=
 =?us-ascii?Q?Hq+sL5SwQ9fbVfHUnjl4sUZxLIpjRkNH2VSwovsn0R8u9q1IEiwUKKCddAg3?=
 =?us-ascii?Q?8NJD9Ls7Gc0BkJEqgZ9JnTOpNrJI7vn01kmOF6j8MKZNUek+cm/CE7gwL0kK?=
 =?us-ascii?Q?FCZspzqPoUyS0H0Bt+0bfi+QyfOm8au9ZS4NgbtUVZVF89r5zLsrKnsyzwms?=
 =?us-ascii?Q?tEg17pI/CWYnJZ0usrMrRwHIDHEuN4aEHucHJz/oBKlf4wUnoWdOf9QtBHhA?=
 =?us-ascii?Q?134pJO9mBi6v5B1eT9jTHBBwdWcXVfk5jCIJvugdCNoh4iXW/omthHWDOSom?=
 =?us-ascii?Q?1XKiEoK+Dp5ST2wjx+tk8i5/0unCxKlgHV2MVmGqwrjv9EVKNrc43YNn6a4X?=
 =?us-ascii?Q?hfn8FklPuaSt77aXJGHOBV9wSsVAuAtXB3+OmR1aPUy7iB7Wln00AxGazlMa?=
 =?us-ascii?Q?78aR9AaDNhPNYX7e8WloxQS6rc4A9OPzQ3COvk8EDtQG8KSuPxqnff0tPof/?=
 =?us-ascii?Q?6iI3ptkFuAuyEvVSQtRHaiJS3b7HEqtq?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB8909.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10602
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0c577c22-ee81-46ca-939a-08dd71763dc1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|1800799024|376014|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aQ7vFCDc5kdNVPTuUiQyGCBiLyhgJdLhIL2ClLLQkROn82QxJwF86zVRdp95?=
 =?us-ascii?Q?27MUC1X6UpyyQSu+WC9Zpz8UXK9UmJzZzJAmFAhQlcV13US1ypzuAwJnijOK?=
 =?us-ascii?Q?2DzIts5MJ4L6MBb/vFtAmG8EGDvF92Mg7kJQ6Lwj3i8PDWpio/33Y/mU7XRR?=
 =?us-ascii?Q?KOkvbKMUGX64kv2hkRycBHU+lOdNKFu46r/1LK/dVNA3JRGZY1ZvDCaC0x0J?=
 =?us-ascii?Q?7i4T6Xzj1IkTmXuQJSSiK7+0LMOQtwYEtWQzZsVaUkUZzbN57jNGmKUEwbf+?=
 =?us-ascii?Q?1DW5NuNpfIBtxb24dxPDegrNSzwwYvxeTaQR6r9v871XuTSdECFuwTRdWoi1?=
 =?us-ascii?Q?pbU4j/vI9g6TBShrDVMxfIbZANr6nbcXBefYRsNZsPaUVFCnh02GHZXnct7r?=
 =?us-ascii?Q?+0MDK9MuGGEZWwl2r/uqpGSp1BTQV5gQsjEFW2zWLIWU+jAt+w4UAeOSLtc4?=
 =?us-ascii?Q?gZWAXUgoBV99AlNHLkqm2XnY2EuKrF9+FNjq+EHg5E1o0C+4CTFFHPAsxX4H?=
 =?us-ascii?Q?ifHC/M10zCQzy715ipMza5y9NBzIEy+nUndeAFHFSQdfZGtiM8qQEPPGu+ue?=
 =?us-ascii?Q?//lLpq/v9NpFHG64ouahw42P5kPptlTuEeukN2YsOTXYhE3Y8S7Dc9aA2okN?=
 =?us-ascii?Q?+StXF9JIpgPgCOqapMBGuzInnFmJZfbjAjuthh3p2AU4L0jeGAPBneGbHHsL?=
 =?us-ascii?Q?+m8QRhR9CLFAMIrzkKJE75SDi6bmlQgrR1DgpPmXRgYrg7povBJPGlPJLSok?=
 =?us-ascii?Q?JGKhboM9w7rekXBrySXsitRa0qa+zWY6bef3Z4FsDPLupI3XXpCJdANz66Cj?=
 =?us-ascii?Q?OagO2XFC4/52Sfb+pxyeSCSnPxXpfOr+PnLm8HPWCZuPT8YTZyTmYwx7D2t9?=
 =?us-ascii?Q?u/VWm8htRy+l2366hFk1jr8g3Jjin4D52wYFjcEZaLGlZNmPZanCibdz5hrR?=
 =?us-ascii?Q?ymLoP49gAFqEbEcjos0wrjmkzgIZw0hW3lhAaap6d8BtsrRjoiT9nQp5HWT8?=
 =?us-ascii?Q?wS3HtRn9Vp8NeOO70vgtxjMrLhAeqMiKeTLuuhBOispJOz85WUnhj/Hh8XsQ?=
 =?us-ascii?Q?kRha0ogsrw86bEIHJ+dWbter2ldq5gR6SSsdtyiki+fOZVObrh39VJy2qTlb?=
 =?us-ascii?Q?Wh+XOvxvUU+rBk5N4Vo/t7L2yqVTRAUqV9Ig4Bfdg6CCTRF014rCTikrvEGH?=
 =?us-ascii?Q?4ZXiHxqDI9Hl30HeIw/+3dR2s4JDsmAbASgtSvqWkOTWFZC2PoLEpkjpHJK3?=
 =?us-ascii?Q?vOkqBcNPDnvueuMnTw6Ey3xnJIpnKIbHULyU1VtY6Ms61yQUj6CmqMYxjnn+?=
 =?us-ascii?Q?uMcB1m6EEvhXKhieGH1oY8s6XBrh3uEQo1sZQuJi0ANBHMmU7UCmnX9oRlSg?=
 =?us-ascii?Q?TSdVfBO+T7OjL9KIFjiktAfSmSpMCInDs5yyT7S91H59YaPTcMYjcX6BZDUO?=
 =?us-ascii?Q?uWj6ymAiFQzuFqG/cvi6EqL7YRgKId/FBBLiNYIu06fFEdT0pNYah3cG+vfR?=
 =?us-ascii?Q?FYfq7B0K0AG+cco=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(1800799024)(376014)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 23:38:34.5981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02057611-a697-4f77-6e2f-08dd717651b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10823



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, April 1, 2025 9:12 AM
> To: Tian, Kevin <kevin.tian@intel.com>
> Cc: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>; Alex
> Williamson <alex.williamson@redhat.com>; linux-kernel@vger.kernel.org; nd
> <nd@arm.com>; Philipp Stanner <pstanner@redhat.com>; Yunxiang Li
> <Yunxiang.Li@amd.com>; Dr. David Alan Gilbert <linux@treblig.org>; Ankit
> Agrawal <ankita@nvidia.com>; open list:VFIO DRIVER <kvm@vger.kernel.org>;
> Dhruv Tripathi <Dhruv.Tripathi@arm.com>; Honnappa Nagarahalli
> <Honnappa.Nagarahalli@arm.com>; Jeremy Linton <Jeremy.Linton@arm.com>
> Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
>=20
> On Wed, Mar 12, 2025 at 07:53:17AM +0000, Tian, Kevin wrote:
>=20
> > Probably we should not allow device-specific mode unless the user is
> > capable of CAP_SYS_RAWIO? It allows an user to pollute caches on CPUs
> > which its processes are not affined to, hence could easily break SLAs
> > which CSPs try to achieve...
>=20
> I'm not sure this is within the threat model for VFIO though..
>=20
> qemu or the operator needs to deal with this by not permiting such HW to =
go into
> a VM.
>=20
> Really we can't block device specific mode anyhow because we can't even
> discover it on the kernel side..
>=20

We cannot block users from writing a steering-tag to a device specific loca=
tion, but
can we use a capability to prevent users from enabling device specific mode=
 on the device?


