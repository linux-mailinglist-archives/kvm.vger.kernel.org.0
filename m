Return-Path: <kvm+bounces-68384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 684B7D38444
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 19:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDAB7304BBCC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C92C3A0B3D;
	Fri, 16 Jan 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bp76PilJ";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bp76PilJ"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013064.outbound.protection.outlook.com [52.101.83.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C23346FAD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 18:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588131; cv=fail; b=eT7ofMPyktWv+5tTeStqaqQF+2qW64zKx4ct18gS0C2cjBSVht+FG3OKoz1S38Kqm8/FmNHJ8rjttex9+I/aQGAwtM3FHMbciZlUZZlv3DwIjxf9n16Uzgj0fUscYWlvsLquUQ5/1P+azcUyU3fLnBSVOPkjTQbFUbai6L0tEQ4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588131; c=relaxed/simple;
	bh=TtWGaAlnyaNxbI6s9l3PhCX7iU6F2ICeoMgLSuhGHC0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b3cM2gG7IOB1PPZsdWoH3grJPMFgP2qzjj5bo/lMZ1SQQhaw/Qb5ZkMkoIK0zs9ePzlW4y1Y6dNbo0DsXMAgc2L1ArYd5ZQKsFKKO35kX3kl1dHMbLjtgy3IyO/YrKuTNHaH1iLKABHQMm2S1FNxqJtWoS4kr/QndTGndbNJZ6Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bp76PilJ; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bp76PilJ; arc=fail smtp.client-ip=52.101.83.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=X/cqQ3sw7Nvs28ai+E3ak9BSVqwCmhC5bWi+RRVYy+BFwdNVT87UYkRxtl+78Mla8yl2qFe1vdpR2+4pE3ogJ5RbYLKf3V3rF5B+HXg+NvPvtiEZQijtJPMJWwPRZeZogUlmyUh0IgFRNyEYlfq1BJTLnll1DYPxERfe3jZtbt/TFHDCLlzFbnj+O1MiMJVaMbblhpPNg9GOIiocQhjG6sk68RTkl7+yaY3cahYCa+HSjqnOc1jKC34RNdWAMQY9nbWX6/oVc3JWtZEYHSPVhq+3WXa/xyrOzQmtcyhI+vugnb7m1qCR4Ua12/a4Qp3DGclj/1zcaOnwqVUk4o+LXw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U50TSEGVFQPgUXMEpoBCHFZCndCMFK5nySh2BxwCjIM=;
 b=e3nXxV4zGo1WIzyUzv858PEbtYv3EUgWgkeAd9w+LXDLc0VFSelZ91CwdRWI3fOlTwx6FfMQ42Uq14oJxmDG+l9CbXVsI3pbvMNR+++h0Pna8/qvzFNwU2r48whrBCHGORjlIDB7eMHQuhpNR3XKrv/LLBAR+EDrPaNxtV3tAdmTiwvL1Fd1x/Lw7YdEXiV0c88Orv2ofU5EMUhp2OxacZQdPETUWTw8IYJuy5oSvLKr20hgdFg4LFsbLgXLDNrvEPGJ31ebJPeit+BRA1N/N14YhaKeTLd2mmCpnS8/Yi34FKQ9jgmEjo5Lnl519WIZKu277dYz3xsmX8L7inwjyA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U50TSEGVFQPgUXMEpoBCHFZCndCMFK5nySh2BxwCjIM=;
 b=Bp76PilJLdWcNsdbRXWAz2dN08Odw2Fs0+innMKjDfSN+k+WLSp/hpH2FDxbiiiVYWmb1+0/AFO2KmEdzHcv+vkVN3ro1h6RtEbKFhVE8nen+nZ/iwHTDc1Osl4W0EuM3tZxV2Y2JQZLQBasWVfSZBmJjnCcYOwRkKv9vy7b3GM=
Received: from DUZPR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::20) by AS2PR08MB10155.eurprd08.prod.outlook.com
 (2603:10a6:20b:62d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:28:44 +0000
Received: from DB1PEPF000509E8.eurprd03.prod.outlook.com
 (2603:10a6:10:46a:cafe::a0) by DUZPR01CA0078.outlook.office365.com
 (2603:10a6:10:46a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.9 via Frontend Transport; Fri,
 16 Jan 2026 18:29:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E8.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 16 Jan 2026 18:28:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSx+wQWlX4hlZu02cjZ/LzjFm2SAOfzJr76X3/dSkdCLhtoxXITLyogLtRuu8DQvzrL7QjMC6VvkgRNigQ7jIoltNN+zFFxxaqBHqqsb5BJEd5t9G++ZL2qnZnZ1TOJVr/SyJ/Rm7CBssAdA0yg8/SKdIoMVdCiXe0F3hNgKsedMBJuHjISgPWg4FvtjzEmj6s3N0iEvub7mwdzXrw9EFF35hmtQlCEPU2rkSaSkB198jU55icARLhm5l3o6Uwl7nhnaD3fDVCoKJgJFJbhZ6D0jSRUIx7AVip56OVyW3RxS4s+v4dfctwFfJpiCduWOYdb/e63GingRW+SijUTM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U50TSEGVFQPgUXMEpoBCHFZCndCMFK5nySh2BxwCjIM=;
 b=yraKNuxzYdac4ZUn5lI2ctfDqGtbNuK+6oOznPadtKA+De/AvbYDy0bAZHe1tzkKqpuff05may0j+HUGyUIxtzuZALgmQRu4ux3eDJLNU6pmuiX3h9ljWfTtf8qEKjCSPghd/YM3kSHrnWZVe+sSQyV9kDnt38OZ3Z9h2C+gBhcu8bzOUwFs4ZcFAMOWQqY9AHi7ol6cy3pd04OgRTVMW7zRG704avVfg6aVHsRnE2zrmx/emBZDRZlcVHstaXGiOyXE851jmHrCd//CX3guyG/6F28TywXLqpQJHKtYHBTJ/JbiipYItz6SvtINRUCAVh3OzACSdbikIED3YqKrPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U50TSEGVFQPgUXMEpoBCHFZCndCMFK5nySh2BxwCjIM=;
 b=Bp76PilJLdWcNsdbRXWAz2dN08Odw2Fs0+innMKjDfSN+k+WLSp/hpH2FDxbiiiVYWmb1+0/AFO2KmEdzHcv+vkVN3ro1h6RtEbKFhVE8nen+nZ/iwHTDc1Osl4W0EuM3tZxV2Y2JQZLQBasWVfSZBmJjnCcYOwRkKv9vy7b3GM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VE1PR08MB5616.eurprd08.prod.outlook.com (2603:10a6:800:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 18:27:42 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:27:41 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "will@kernel.org" <will@kernel.org>, "julien.thierry.kdev@gmail.com"
	<julien.thierry.kdev@gmail.com>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH kvmtool v2 17/17] arm64: Update PCI FDT generation for GICv5
 ITS MSIs
Thread-Topic: [PATCH kvmtool v2 17/17] arm64: Update PCI FDT generation for
 GICv5 ITS MSIs
Thread-Index: AQHchxXN6M9WLdNRLk+LsQQImKSVBA==
Date: Fri, 16 Jan 2026 18:27:41 +0000
Message-ID: <20260116182606.61856-18-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VE1PR08MB5616:EE_|DB1PEPF000509E8:EE_|AS2PR08MB10155:EE_
X-MS-Office365-Filtering-Correlation-Id: e3397ae8-808a-4c99-d120-08de552d14fd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?7wizmaaA4Y5Wi3BmzZenxTwdQZWsF/RR2mTSlT57Hx7uaC04ShSmg2FBFu?=
 =?iso-8859-1?Q?f6PdPoPMy874urtpP+ot/Ch6B7qFmOQ1laf9A0dJFrjW8CXekqUBBpPMtk?=
 =?iso-8859-1?Q?4QmSMwGVSAetl3EThlkpb9XP3QEbVJLokTumWH3KIeFvX3cnF8o2OWTLai?=
 =?iso-8859-1?Q?RfaXpL4T/uoYO7bYgHb0W5Iiv3s2HWiPx+bpjErv999vqcBlVXOnhd4x66?=
 =?iso-8859-1?Q?VSnZmlH7h8ZnHvopTpFNVZvsaTlvD7Evq5+3rzWQl8ELUUaAGXoT0ACqgx?=
 =?iso-8859-1?Q?wa/frqaB4iz9b/kmSXhpj8gF9RiXpKGBo9IgIkakW1yC+dLi1aDH2e2P23?=
 =?iso-8859-1?Q?zSRQV5xTewi0lo4KgU48FciCRZhf4sm3/3v61ZvDovh3MhWj9sXlvV7269?=
 =?iso-8859-1?Q?pKr1hoL0LIqmtHbCwuAFYKqrRyunBb3w6RKwRfCgDZAiB39Gf2Fxbu0zqr?=
 =?iso-8859-1?Q?REKo1YJ5T6j2FnJQ1LYcEt9fumHTyyNy/ntXs8OAk1DFO1NgUu0EocYFZ5?=
 =?iso-8859-1?Q?SfH5m1OzhlLzOpg3/NGlSfYRzgLfwfpzdndCjo87uB647BvWGPxGi53Abs?=
 =?iso-8859-1?Q?2Nph+kfXmGe8mPt+0CgNeLkcfx7pCtF/4G4hg3H8SuRivrbH1z/Yboy/NQ?=
 =?iso-8859-1?Q?qnXg68rNrzuWesX1U2QEcK4RdcFLqI60Y3oW0COWy0g9u33pVuPTH32XwT?=
 =?iso-8859-1?Q?YhYE8cibWsL0D0Wpn3VuIbDTN6ZywM/mejyzBdRrpA5oBCupeBmTCUHG28?=
 =?iso-8859-1?Q?LmFMeWLKU+98RXw1zXfRBX7K9OwNE5qJHjg+ZgRzFkLN/gMFMBa6ToegXJ?=
 =?iso-8859-1?Q?W7CNPjvHu7XpikugzA7nb5wWyNn3XRKKJWruUL6GkpDgGkNfnImYxvYxzV?=
 =?iso-8859-1?Q?OzmNWBu7o8V5gcHaVnqUhY28x4pFeGKSK25uEW4e/j1eq+tJgIhenlqRP+?=
 =?iso-8859-1?Q?scNlPkIT5rLGu+Y8PeYF8kfIS3TT7vHGX+lvdFH584h6fk6QL3vH1y7pwe?=
 =?iso-8859-1?Q?SYr/X/WAjOYAAgnUlx8AUTpf7hRhKpt4Kaj+EvgqHfaQr4xzKWb11T8zw1?=
 =?iso-8859-1?Q?BdKDgomHdbZfSoxu3+gYxCVBV7G94+/m9Go7hqsqiuoNdFU0RVtfl06Wxj?=
 =?iso-8859-1?Q?132EZzYvSdqFvU6zRaQ+cFC/693hXScBUJrr2APNOxk+dvH9/POGb+N/wJ?=
 =?iso-8859-1?Q?Ac3wGDT1Ibu/OA/4uvRTEaGAEELzN/59Wl/iYCZlFuFrsSl8QO+4sZoEUG?=
 =?iso-8859-1?Q?oZcxRfzNzcocc/gluU43k9I7ufpxdLzjPlEKQjfNOJHeanc/PwhiD9ZbDD?=
 =?iso-8859-1?Q?XXC2KKaNw4ud0khJgmbMwXQUFgTeMmMOZhVMIq2helkyL5BRE8+gUNGNUZ?=
 =?iso-8859-1?Q?EqT3kh566OhRDYpgRqMDKdMfP4Jp8ISSnq7o+LfUDPjdPHwu7yMYSCf2eX?=
 =?iso-8859-1?Q?HuulxfyMhu6tIYbSoWzdRTpvCTRx15BmHupomY9vEWnQHUDqTRX9cAGs31?=
 =?iso-8859-1?Q?OrAEeqeRi+eVMNyXmyc7jhliT/0Zq4FuPPlMj9SbC9oSTC9BA8AzHr96yq?=
 =?iso-8859-1?Q?sg5S7pFOlUd8tJ8U2rq4IXSupcQgO3oUwqBbBHzBbWmdIE2kCD+AkMW16T?=
 =?iso-8859-1?Q?rwrTg4spqZYwrHI9egO3WAtjJIFhxHCUF9OobfKfwailVZEOrn3WFmOR3s?=
 =?iso-8859-1?Q?TqYGCY2oqowdzgfSYT4=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5616
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f34bce95-7787-49ec-1f71-08de552cef8d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|14060799003|36860700013|35042699022|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?fXKu/l1XU6RKx0Upk3yXcxScA09G6TI+bOc68BpRyj18Unye1YH0rEs8qe?=
 =?iso-8859-1?Q?hEDBU406zwnPjDbr3EW/fMjgjKZu/HIecwUy9RKyDz9ZEltK0YWVs8ZVN2?=
 =?iso-8859-1?Q?oAY4tvRRg7TPFK4C61yPwEgRHf6Y3RLJ2l+GS6my6Gg4KkXM/ow34xlRln?=
 =?iso-8859-1?Q?yyuzWytD6vENL7yxsHCM6UenKK6CX1WaUW2SdCPNX8iq3O+P59TPwac7Oc?=
 =?iso-8859-1?Q?7K/Z4o63uhOzdTo3l8JwAgN1sywtRIuuW3aTaI0UlYdWSZTP9b8KmSuKcC?=
 =?iso-8859-1?Q?cxdbczI+i0WOyHZG2MleAZJL1jRTwPAcGNt1cC9GTuLMYLI3FlyYDdmTR0?=
 =?iso-8859-1?Q?F540aG8IOL18WQcA3oVofuPwo0bTXreUU7fmYaPVhL3t0/dJ/eZFBJEW78?=
 =?iso-8859-1?Q?hMrmTGk3jFG36tCAY0PMNL5vh8Wnki/hQQkqfEcmBtn8W8RAMWLX11JAxR?=
 =?iso-8859-1?Q?7BMTZ1n7Q2ZWRDLk5rkXLZPya1W5GIfPbBRw3KgUKoZe+qVi0W33pItxsH?=
 =?iso-8859-1?Q?jNVvLTP1YBbGAyvw3hpi2284moSxZekqAOI2m77XSOSENY4uirZcGY4E62?=
 =?iso-8859-1?Q?bJvM7IdD6S7j604DSBDefAJ7nSvr+5pAqivBmRMHQNkysubrDJlwjz6EK2?=
 =?iso-8859-1?Q?KS88uDj232qdifXl8PfqggQe5Kh697dbC3BYJiH/KvKo3J0kP3BS6SLFc4?=
 =?iso-8859-1?Q?1Nd7xicg0aT9BQA/JdYMYVzcq15oCjmfydA+TDdwv5cJmDkcHQd+ZxcCh8?=
 =?iso-8859-1?Q?sO3nGL4+Ac+iSQSYuOFQ5boAdSvCCaFocMJ1gOFSxvCGTm2rgS4sKH0+xa?=
 =?iso-8859-1?Q?06VPNhOLykPuHVO9FaTP3ilhwtfpGbnkMc8AusD/XukNTaVkSPjO8WBzqw?=
 =?iso-8859-1?Q?GZuPBljTJMk5mIJELO6bA9uOVuukM1lQwVkpH1JP/TCqkiznKQs8Lvs6OU?=
 =?iso-8859-1?Q?DiQos0OFL9DxTt45kWNV7TJYFvPRtPofd/swREzDwkYFmcyipec/ClE2oM?=
 =?iso-8859-1?Q?0V3eBkPVsU7cMCiD8/2TcdFihJ+ZGZ8D8SES1glTCJG4DUwc05PjScc1AG?=
 =?iso-8859-1?Q?5ZzzTKnwyCWyyZEjwKoGDkg01CzeVuNfbjJ8xUgiFPiO2xtt2UMqAVQ76F?=
 =?iso-8859-1?Q?k62d/ISQTD1q4BIjPQWXre+N1yz1ALX5GOV4pKrx9ASv1yN/UFmQCmPvgD?=
 =?iso-8859-1?Q?1DwriT0wVfzQlbxNHIUpFv035e6i2DcBVx0uH4/0p+ASgTxvRfN0mgvVMO?=
 =?iso-8859-1?Q?ezIaVuO4dvYL7DaS/wnYBg/S1ruA/oBHLtaH0D7os/Oaz4I4sMJWDa715y?=
 =?iso-8859-1?Q?24fO6VTNrlxaLMc9zMHtSf9RIzp7xKAhtU36gLfi+wz/2XPL1r4gcNx8/D?=
 =?iso-8859-1?Q?vTfoL4xDShltwMtPiMOwsjTnCurW9ilFlKbsK407RL27m6cLGMbp3GZl3h?=
 =?iso-8859-1?Q?K/b0GiqzWRApOpKSnAajZzF53e2GsTuI/53W+FjPWjesQNnHZuMXE6+wGK?=
 =?iso-8859-1?Q?WHL9ypPkwzHla4LIOsJeBdCpq/WiRTOex1QqyS+h/c4KNPcVeXmkkMhtXy?=
 =?iso-8859-1?Q?T/Q6TXtbD7gctXG5H1NiH2KtRgiigCmqkI2Z0w3aIxAawyAYxc8b5THSeJ?=
 =?iso-8859-1?Q?06Kv8eySUUz8d1Wrc9VxT35fqEw6oC0Wp1FtBR25c23tbzQSPFcLGgM5yu?=
 =?iso-8859-1?Q?mfGYD1nZfWN52c4Sij6BunPJz3nsyn6YA/ReBQvXASjIGCP+BeTEMyb6VH?=
 =?iso-8859-1?Q?jFJw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(14060799003)(36860700013)(35042699022)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:28:44.6257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3397ae8-808a-4c99-d120-08de552d14fd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E8.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10155

Now that GICv5's ITS is supported, point the MSI-generating devices to
PHANDLE_MSI for the `gicv5-its` config.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arm64/pci.c b/arm64/pci.c
index 79ca34e8..aacaf6b6 100644
--- a/arm64/pci.c
+++ b/arm64/pci.c
@@ -70,7 +70,8 @@ void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
=20
-	if (irqchip =3D=3D IRQCHIP_GICV2M || irqchip =3D=3D IRQCHIP_GICV3_ITS)
+	if (irqchip =3D=3D IRQCHIP_GICV2M || irqchip =3D=3D IRQCHIP_GICV3_ITS ||
+	    irqchip =3D=3D IRQCHIP_GICV5_ITS)
 		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
=20
 	/* Generate the interrupt map ... */
--=20
2.34.1

