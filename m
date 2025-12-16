Return-Path: <kvm+bounces-66062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F86CC1ACB
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 09:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA17230220DB
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 08:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B5F3346A6;
	Tue, 16 Dec 2025 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kK9hfzuy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kK9hfzuy"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013018.outbound.protection.outlook.com [52.101.72.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115E313E2D
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765875499; cv=fail; b=EwssZA2kVyDe69pVn3rxOn3JAwvC05p5oBWKT0HJuGH/xyD3m2KfIIS4g1llp3tNvEMasFUbwh9qqISpYXEopxRlDGgt797uTAhlXtOQc+tblp8fhjx304WNgIBnMcaZVNA0wM6uonnuFDBPU8XgCmOdQBt904vuEXP4+DUEgyg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765875499; c=relaxed/simple;
	bh=kbE1wl1Q0adCS2EgEgd5OTHGX1T49uNqgoIRdt+LyM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JrktJ3VVPycg1wz2qAPlf2eEuBcOq5qX94qO7Mn8ZidrPOUsxdbMicN6PXKj1Wv7XwBctChf0Lg2xBqK0NoH9m3Ci0NJntPPM9DO1rkwwVOFaTbEmYZ/CIAhwh7cl219AkkbY4m7zi11t9P3nUZ8qz8v6Q9Uc4c1TSKZHGuj+rU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kK9hfzuy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kK9hfzuy; arc=fail smtp.client-ip=52.101.72.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=glIfjIlaR5SKWucep6YDTRZTM8eJtd0En9J4+8gCLdjr6dqSrF9G9SiMnm9NDrgqmB0qBtDq+xwzllx1TVbwTXym7U3QoR5ZGQoTBG6B6+b97tN1cPIFeLyvjnMFuNeDK6qsRU9VchnS910/jxswLC7y4wZbNYotqnJ+CO+NQ70i7YWop0TDTw2f5d6gCAkBKisznB9m+6BTNvDyL2J0BnuYFVAQUQRqFtsfGUwB0uO9ZqThy3fowEeM+UYY0zQv+7sg9UG+7g2t8igoGiyqddwY5QnYJhXw+VAX6v5sbOqHhAU3mIqGeY5xdqQMc05VCwHfwz1VzjkGc5CAuZdZDA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbE1wl1Q0adCS2EgEgd5OTHGX1T49uNqgoIRdt+LyM4=;
 b=u84OS6yh4gwehNC/Bi4ueLrEQAzp41htnPfwXORpCdmAajow1y3FtRAfPKYJJoaUUMD5QRmK5cnRAaClPu6/fWwiSLvFkjt2FrKgomvu44usOZR/CRpe0r10PPA84vf+fanZnC5yEWGiuhM/F/XgiyZmUK59ikmjWMbaVgX5LxiXDYBeVx1q/BB6WUZUSxaX9EwrJtYHAvaC67VLqvNf4TuzGD/MA81tzOTDn3Kw94LC2r0IsdE7HElxok4twMi5y9IOPPsJ0+BMvFXE927jupLQ4skbypQpauNF7J0Lcoy2Gp1q9iTw+Zlmk4NgGx2d9om/e6bv+9Q8/ejyiGa7Xw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbE1wl1Q0adCS2EgEgd5OTHGX1T49uNqgoIRdt+LyM4=;
 b=kK9hfzuypaVm3WUgryfnzcU6PpTh4D+WceKx4/DLTEiKWIZaOdXGXVeeocRAXRie5FVv+47OxAtJaXp/teDDYc5uZwBD/obrieP8KArr5NZxRSXm+XMj1DxVSwH62SPsx5oAMNI1PjTgHeUMZbZLlxo7rrS21tY6udFVoE71a5s=
Received: from DU7P190CA0019.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:550::15)
 by GV1PR08MB10791.eurprd08.prod.outlook.com (2603:10a6:150:15f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 08:58:08 +0000
Received: from DB5PEPF00014B9B.eurprd02.prod.outlook.com
 (2603:10a6:10:550:cafe::92) by DU7P190CA0019.outlook.office365.com
 (2603:10a6:10:550::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Tue,
 16 Dec 2025 08:58:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9B.mail.protection.outlook.com (10.167.8.168) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Tue, 16 Dec 2025 08:58:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFvstGKBuqV6rZZiDqx1Q8KI7V54KHee4EtLbhKsHyF1YJ+UerjtlwOEvB5+50bIecLQFPBCTyfgz2+I5HADhHjdfXOvkfQ3gP7iasPWY3RoCxkiULL5hiiTuc78qBqvvPfPCAjCyj6MyNcnKA2WLKOHVX4LqPcMPgKuMpyleD6dvHYxHAmq9+wgmj0o4NmhpybkRQFcfCHfhZzk2F7jbQef5BaRQH6PxgxTjMzAMDHDDvpWM0hRnSh+hbL0S2XtrP9KkbboRKRrPXlOrDgKCsgNd3+HYMsGk5cAle6xYWoe/gJZj+AczK3gUV4+Ng28X59ZY3o/Ds9HrsTHy7LL6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbE1wl1Q0adCS2EgEgd5OTHGX1T49uNqgoIRdt+LyM4=;
 b=FDJK8jSeXmsQ9HDvmtyvHG1c7+/JSqp9PIAgid72UFX5Pa93jCDwkqJ/YjyDR719vBKR7w3VwVkZhuQTLaJYIWd8UT0HTHVlxadWnbWnHpg3OYG6kQwP82oCT1j08asPSAFlVjZR8oQP4vQbpgcnVwb54GVWXxrAzs058N7bBYsfrfN+ruaq1UnfMRuxD+09fHRhRd64Nq8v7vLakZ7rbGlNJU/1kQ+I/Ymkj6uaIZgwFltWL0L3g9U4V5k05SPatce4vSwEP8/3OsNdStmhHtiM91aXDU2DcT+/UZgVBwmDvPvYbn8El04j5NNs2QBoZlmj1nV1Buw80YPpn4gDUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbE1wl1Q0adCS2EgEgd5OTHGX1T49uNqgoIRdt+LyM4=;
 b=kK9hfzuypaVm3WUgryfnzcU6PpTh4D+WceKx4/DLTEiKWIZaOdXGXVeeocRAXRie5FVv+47OxAtJaXp/teDDYc5uZwBD/obrieP8KArr5NZxRSXm+XMj1DxVSwH62SPsx5oAMNI1PjTgHeUMZbZLlxo7rrS21tY6udFVoE71a5s=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by AS1PR08MB7660.eurprd08.prod.outlook.com (2603:10a6:20b:47b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 08:57:02 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 08:57:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Topic: [PATCH 07/32] KVM: arm64: gic: Introduce interrupt type helpers
Thread-Index: AQHca3slbeKJlkPOlUaF8+aOc+XY6rUit3AAgAAqvwCAARq8gA==
Date: Tue, 16 Dec 2025 08:57:02 +0000
Message-ID: <34f4147fb0dae6123722b38c0d481af1d8f69c24.camel@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
	 <20251212152215.675767-8-sascha.bischoff@arm.com>
	 <86jyynooq3.wl-maz@kernel.org> <86ecovohn3.wl-maz@kernel.org>
In-Reply-To: <86ecovohn3.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|AS1PR08MB7660:EE_|DB5PEPF00014B9B:EE_|GV1PR08MB10791:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d70fb71-13da-493d-6f29-08de3c813a85
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?aUc4Sk93SXVFbUQ5R3JJWitPRmdyMy8vQ09MOWRPbkczVnZrOHhMVExqNWNW?=
 =?utf-8?B?ZmJuNWNhSElSUTF2MlMyUWh4ZHJGUFhsS0VqQjU3d0ZXNWEwUEhKbTRac1VN?=
 =?utf-8?B?SXB6RHl0dUY3dTVjWnVEQ1NjaEZBZUhLeFYwWS9ubzMxNWdreUtRM1JDd1Z1?=
 =?utf-8?B?WnhuVHg2ZC9GUmhLeldqVU5NeEh5UDhUWFlSckkwT0lITUJYZHQxOVpEeXhn?=
 =?utf-8?B?THJIZm00dldtZmdSYjlaK0pITnhacGRGamtURHlDQUpkWU1hUG5sa2srbm9D?=
 =?utf-8?B?N1FPRVZ4eVZYTXRwUWZjRTh4UzNnSUovL3J0V1U0VzBFdnZhVXBCdmxyQzdB?=
 =?utf-8?B?Sk5laVh3NjhiWWlFVGlPaXpPQ0VKVk5XM2RpZ1pqbTdqMUhUKzdZQ1ZiY2Rp?=
 =?utf-8?B?RXQyTXN5K3Q0ZStSaDM3akljSUZ3UDVZQUw2a0VDUkdSTGVMYWdwZ1JrM0lu?=
 =?utf-8?B?WjAvcmR4VG01WE51N1A4YnVSZjZpdU5XSVZZbGVBakM5bFJlNkFONVFTWUMx?=
 =?utf-8?B?b3FCN040VWp1cFBHeW9oMG5YUkkzbnJnazJHM0pKM2YvTXF2dktUZmdCV0Iw?=
 =?utf-8?B?ZHJXU3RqZXFYRXNaUW1pTk5NZ0RpTzNVOFNleFh4czR2VC8rcUxIdFp5bXJx?=
 =?utf-8?B?Rys5NXlaeGxtb2JKZ3FZY2sxQTJWWWQ4OVA2clRWKzF1bEtiNVYvMU5IMFhW?=
 =?utf-8?B?enNMZjd3SmJEM1RwblJMSWFyWUowaU90RDVSb25yM2VreGdpNGZUemtxdDU3?=
 =?utf-8?B?WTBBUXh6amZrbkExOFlMMDZ0VWp0K0xEbjdzYTl2ejU3QUNHcHNEN2NtaEM4?=
 =?utf-8?B?T1NOMEU5SUxEYy9vQmVjWW9hakJoY0lBbDltUTk0TlVMZzNhVkhOUWtXN2U3?=
 =?utf-8?B?aVNSbTFpK09TZzVGaElxWVgwekpraDVhK1BQRnJhVGFUaWVVblF1c2VEVGZZ?=
 =?utf-8?B?RHBkamsrRXpVczhqeVVTU0tyUlhRQ3kzZ2NKZElLZGRJc3FUS04rZVZUendH?=
 =?utf-8?B?YVFjQktOc1FuWHlQMy9jRWo4cDYvVHNZL3FhR1JVeHJ2TGFqVFhmM1dvcms4?=
 =?utf-8?B?bXZKN2hMSG5EMnQ4VWszamZMWmtFc3hESHB1c3dGcHA2L0l0djJNaWZOeXQy?=
 =?utf-8?B?ZmV6NTJVVXBGbWQ1SE1PVzFiclFwNS80Z3ByVlEvSkxSUVJGNHpTV3RKYUtY?=
 =?utf-8?B?YTdyT3N4bGg0U0VnZkNid3B0RXNVUFNlVFNMZ3dmSExzV1ZkS1dDTWx5cnhU?=
 =?utf-8?B?TG0xcG1TWG5WTEpxdXFzZHovNUlsb1lKTnR5bURPWG45NXFpUklwNElJSFE3?=
 =?utf-8?B?NzViN0F2OHYzeThoZnZjM2hPVU8zeHhqcTBIR256aEZDcFFBc09MbGpWVklo?=
 =?utf-8?B?eVZXY2lLNHViNngxb0tjV1gzQjJpZW5Yai84eWIwcE9mNk4zRkJCclMrdTI0?=
 =?utf-8?B?K1BKTTRsRVlrZ3AzSzNoNzZiREI5ZENHdm9EVnRtWGQ0VWc2cHdydFVrOEVC?=
 =?utf-8?B?bkY4RXlRdjU2b0dBNCt6TE9ZUllEYnBNbnJ3cTFheWZNWWdXOHgxY01VTzVH?=
 =?utf-8?B?aGRJVjROSkdHVFlWUjQ5b0FJR0R6enFMemVoMWg3dGNqSTV1REhSZXlvaEtL?=
 =?utf-8?B?T05lOEk3OExDNkFEdXR5a3cxdEc3WmU2ck1YTVNZN0dHaXR3d0taT1VHSWNt?=
 =?utf-8?B?SzYyWU5aWFQrYy95ZmZTYlF3UjAvQnRwTEE3NmxLdGlhbkdhdFlFSi8wd0FG?=
 =?utf-8?B?UFJkemtob2V1U0pqQXJQTGFIcW9Bam9rVkszYytVSmxBRTQzNFIxTFVJL0JT?=
 =?utf-8?B?QmZsRXpsYUEyTXRKUDZYOERRVi9WWDhrUE9pZlcvL0h6SlVTYmtscXN5WlZr?=
 =?utf-8?B?MVVDTUhka0NpQ3pJWWcxWE90RVdlek1XZ2Y1eElzc2o5SDVyQWZzSXBqOVcr?=
 =?utf-8?B?T1FkdzBYekZSekZlZkNmNjVpeVl4SjNqRFc1ZnRhY1hJblh0V3doU3B3Wklz?=
 =?utf-8?B?RGRGUE1wdjVEMVBkWjNpVFQvU1BVZzhkSWNZc0h5THRnRUlOdUpEWlYzK2Za?=
 =?utf-8?Q?jqF2Ze?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <64661311662632488BA36DBCA4093EBC@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7660
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a3bced87-6d10-4afc-73be-08de3c81143d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|82310400026|1800799024|14060799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDU0WncyZmZ2aC9IYWROeVorL1pwOGpiRlpvdW1QaVVrT1dSVThHZkp6blpo?=
 =?utf-8?B?QTJYSzl5dS9abDMvTlg0emN4Wk55aWpNd0JTaS81SHFRMVVvVEFTcVFpcDBi?=
 =?utf-8?B?TnkvT3Z1Y2VHTzQrTWs5WlcxQmZRM3drOXBZSTZUdGYxN2pTUnY1WW1Ib2lv?=
 =?utf-8?B?RVNEcW9pTlhuS3NIS2Zsa0VzT2RhNXNKcVV6NDhxaEFpVDNwdmpsSGQ1N2hH?=
 =?utf-8?B?aFVDdzBDTVNMSlM2SmZscjNnLzlIdjhub3Faa0lLbXgvZCtiRUZ5UEtxRmk3?=
 =?utf-8?B?dlRjanUzUnV6QmNFU3J0WHViakF6d3ZJY1ZaZCs2L1NQWWorRkZvbWlpRWV0?=
 =?utf-8?B?L1VVSnNNT0pWU1BZR3lDaVpJaEMyaU1BTGhpZ2ZrcnJua1pOV3RUNEtmZ0dz?=
 =?utf-8?B?TkJJSGxwMlJhSG5IWTR3V3JoVGNEdXRFNDZpT0xCczdpOGltSjRZUGlpN1M3?=
 =?utf-8?B?cnp1OWZ0bUQ4MGFoOWFvNkFXUWZVWFpUdnVwRXU4NUh4R1ZOZEgyZTUzNUFJ?=
 =?utf-8?B?RVJBZjZ3bllab0Z3MWV2TWxNLy9wOXRoWGpsTWdROGpxOE1vN3hBWXFpdi9K?=
 =?utf-8?B?WFpYeVZhcFFHUnZMY0Z4WjJrdU01L09BMlZVRDRZdW1hblJrTzAwWXI5K2ZQ?=
 =?utf-8?B?RlNtUHBxNG11eEd1WjBmZEdDc3N5N2tMMVZNcTBtTjFGTUNDcnY1alNsYTlm?=
 =?utf-8?B?aGc4UTV1WXBNL1c5c256UXR6RHhGdDNvZUhHcTlZT0czVlZUYnVHQm5PZmVV?=
 =?utf-8?B?UjhMamlsUW1iOGhlUFEzSFNnQys5TFFwL2Fjb3pjYU02M1NXZEs4czVQQzI3?=
 =?utf-8?B?UmtqV0JtRTI2Wk95SW1neXpiZXhuZVVpRWJTcDVPRkZaRjFwalZpQ2pKbWxv?=
 =?utf-8?B?K3dUbWFKT1R1MEZ0akVReUZmUU1JMngzbWdaelg0Y0pLZ0ttcnA5b21EVFF5?=
 =?utf-8?B?QUorMmFIVlo0Q2owZTM2UU5XQXdCNDEyQmVQbEs2M1AwZitLeXZUenozeGMx?=
 =?utf-8?B?Wk95WThUTGFrcjN2WkNmdG05VXl1dlpUZEtlek11dzJGOEFRcFVIeTVIZk1z?=
 =?utf-8?B?RW1rbHVNRGZRb1I0cllFOEorMVU5dmtSUjJ3YUs5cEJLZkdmSkZobVU2NTNL?=
 =?utf-8?B?cnY4SlNlVVAzcXpzMkk3OG5mU29CYm9qNVJpbVhWQVkrT3ByMWE1eXhnSUdC?=
 =?utf-8?B?VUdWb00rOGYyMnhpWjBQYTdPaWp1dUFYY2dad2tXU0EvRVNYUnVhL3pDUk5V?=
 =?utf-8?B?c2M1VUY4QmVpdkMyZDBuT1JBeVdlUjJTWXlWbG9WUlhDVFVEdk5OeFRucFQ5?=
 =?utf-8?B?QmVHR2tCb0M1eUcxQlNBYzA4T21hQ1ViemlXcWhVd2FFVUFmNW5MZzlJR2x5?=
 =?utf-8?B?QlZFNHVZS3hjUmw2WWM0SW5LUkc4M0FPamVjdng0YWxseFZVb3ZvNWVXVndK?=
 =?utf-8?B?SnlpbHBDRmpCQjNVbG96R29tNTR3YmNiUG5QVHVNV3A5OGZQZERyQ2NieGhK?=
 =?utf-8?B?cHFtdG1sd0g2allCclFvajgveWFPU2o4d1hNaUZRTG1SRUpQT2h5VFYzMkRv?=
 =?utf-8?B?eGxhek10c2JPQUgxTk1URmRkSjRWR1ExNjdJVWd4QzJITk1ZallrZTJuS3Rw?=
 =?utf-8?B?NlcySGpmUnRENVdXRHRURjk2K0xhYTVzQVNMb1FaWjJPeFZjck1DODd5TUg4?=
 =?utf-8?B?OC9SWFJ6Q0NCUG9CazJNK1VIVEx4blJYcE1oRFcxaWtKcUYrK0lDbUZXaVBu?=
 =?utf-8?B?U3Zxdk5wbFRTQ0lPYjdNc1ZZbzJlc0dqemk4TUtDYXN3YTk2clhaeFVIWVBB?=
 =?utf-8?B?MGRxc1I1V1ZVKy9uUW5YSFdxQXZLUzNsUXBxcktzRCsrTEFOdk43dDdlWGpy?=
 =?utf-8?B?bXdMSG5BUU9IVU1NK3l3YnY5NXBVRExUdlZvOGxmQUtKVndIRzB0NFFkTjhh?=
 =?utf-8?B?MGFUNVp1bzFoQ3h2c0dnTzZDUzd3NVNpYmNETCtqNFR0SENacys2Vm8vQWNo?=
 =?utf-8?B?cC9tMk5jMFpmSXlYdDBSS25jbGJGNGVVNkxMQVM0L3FPeEFaMTdtb09GMVhF?=
 =?utf-8?B?WVdyVXlHT3lqd3hMWVpVVmhOMFlxOXpPc25WTXlwWWxPRWdEak1vS05WT2JV?=
 =?utf-8?Q?Ed5c=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(82310400026)(1800799024)(14060799003)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 08:58:06.2310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d70fb71-13da-493d-6f29-08de3c813a85
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10791

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDE2OjA1ICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIE1vbiwgMTUgRGVjIDIwMjUgMTM6MzI6MDQgKzAwMDAsDQo+IE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+IA0KPiA+IEknZCByYXRoZXIgeW91IGhhdmUgc29tZXRo
aW5nIHRoYXQgZGVub3RlcyB0aGUgbm9uLUdJQ3Y1LW5lc3Mgb2YNCj4gPiB0aGUNCj4gPiBpbXBs
ZW1lbnRhdGlvbi4gaXJxX2lzX252NV9wcGkoKT8NCj4gDQo+IEFjdHVhbGx5LCB0aGlzIGlzIGp1
c3QgYXMgYmFkLiBJIHNwZW50IHRoZSBwYXN0IDMwIG1pbnV0ZXMgaGFja2luZyBvbg0KPiB0aGlz
LCBhbmQgY2FtZSB1cCB3aXRoIHRoaXMgaGFjayAod2hpY2ggY29tcGlsZXMsIGJ1dCBwcm9iYWJs
eQ0KPiBkb2Vzbid0DQo+IHJ1bikuIEl0IGlzIHNpZ25pZmljYW50bHkgbW9yZSBjb2RlLCBidXQg
SSBsaWtlIHRoYXQgaXQgdHJlYXRzIGFsbA0KPiBHSUMNCj4gaW1wbGVtZW50YXRpb25zIG1vcmUg
b3IgbGVzcyB0aGUgc2FtZSB3YXkuDQo+IA0KPiBJdCBhbHNvIGNsZWFycyB0aGUgd2hvIFt2XWdp
Y19pc192NSgpIHNpdHVhdGlvbiB0aGF0IG1hZGUgbGl0dGxlDQo+IHNlbnNlLg0KPiANCj4gTGV0
IG1lIGtub3cgd2hhdCB5b3UgdGhpbmsuDQo+IA0KPiAJTS4NCg0KVGhhbmtzLCBNYXJjIQ0KDQpJ
IGRvIHRoaW5rIHRoYXQgdGhpcyBpcyBiZXR0ZXIgb3ZlcmFsbC4gSXQgcmVtb3ZlcyB0aGUgbmFt
aW5nIGlzc3VlcyBhcw0KeW91IHNheSwgYW5kIG1ha2VzIHRoZSB3aG9sZSBzaXR1YXRpb24gbW9y
ZSByZWFkYWJsZSAoYW5kIGFkZHMgaW4gU0dJDQpzdXBwb3J0IGluIHRob3NlIGNoZWNrcykuDQoN
Ckl0IGRvZXMgbWVhbiB0aGF0IHdlJ3JlIHN0aWxsIHBhc3NpbmcgYSBub24tdmNwdSBwb2ludGVy
IGZvciB0aGUNCnByaXZhdGUgaXJxcyAoUFBJcywgU0dJcykgYnV0IGVsc2UgaXQgZ2V0cyBxdWl0
ZSBpbmNvbnNpc3RlbnQuIEdvaW5nDQp0aHJvdWdoIHRoZSBjb2RlIHdlIGRvIGFjdHVhbGx5IGhh
dmUgb25lIHBsYWNlIHdoZXJlIHdlIGNoZWNrIGZvciBhIFBQSQ0Kd2l0aG91dCBoYXZpbmcgYSB2
Y3B1IC0gc2V0dGluZyB0aGUgR0lDdjMgbWFpbnQgSVJRLiBJIGd1ZXNzIHRoYXQgaXQgaXMNCndv
cnRoIHBheWluZyB0aGUgcHJpY2Ugb2YgaGF2aW5nIHZjcHUtPmt2bSBpbiBhIGZldyBwbGFjZXMg
Zm9yIHRoZSBzYWtlDQpvZiBjb25zaXN0ZW5jeS4NCg0KV2lsbCB3b3JrIHRoZXNlIGNoYW5nZXMg
aW50byB0aGUgcGF0Y2ggc2VyaWVzIChpbmNsdWRpbmcgY2xlYW5pbmcgdXANCnRoZSBnaWMgdHlw
ZSBjaGVja3MpLg0KDQpUaGFua3MsDQpTYXNjaGENCg0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL2FyY2hfdGltZXIuYw0KPiBiL2FyY2gvYXJtNjQva3ZtL2FyY2hfdGltZXIuYw0K
PiBpbmRleCBiMGE1YTZjNmJmOGRhLi5jOTA4ZDVhYzRkNjc4IDEwMDY0NA0KPiAtLS0gYS9hcmNo
L2FybTY0L2t2bS9hcmNoX3RpbWVyLmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vYXJjaF90aW1l
ci5jDQo+IEBAIC02MiwxMSArNjIsNiBAQCBzdGF0aWMgc3RydWN0IGlycV9vcHMgYXJjaF90aW1l
cl9pcnFfb3BzX3ZnaWNfdjUgPQ0KPiB7DQo+IMKgCS5xdWV1ZV9pcnFfdW5sb2NrID0gdmdpY192
NV9wcGlfcXVldWVfaXJxX3VubG9jaywNCj4gwqB9Ow0KPiDCoA0KPiAtc3RhdGljIGJvb2wgdmdp
Y19pc192NShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IC17DQo+IC0JcmV0dXJuIHZjcHUtPmt2
bS0+YXJjaC52Z2ljLnZnaWNfbW9kZWwgPT0NCj4gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1Ow0K
PiAtfQ0KPiAtDQo+IMKgc3RhdGljIGludCBucl90aW1lcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQ0KPiDCoHsNCj4gwqAJaWYgKCF2Y3B1X2hhc19udih2Y3B1KSkNCj4gQEAgLTcwOCw3ICs3MDMs
NyBAQCBzdGF0aWMgdm9pZCBrdm1fdGltZXJfdmNwdV9sb2FkX2dpYyhzdHJ1Y3QNCj4gYXJjaF90
aW1lcl9jb250ZXh0ICpjdHgpDQo+IMKgDQo+IMKgCXBoeXNfYWN0aXZlIHw9IGN0eC0+aXJxLmxl
dmVsOw0KPiDCoA0KPiAtCWlmICghdmdpY19pc192NSh2Y3B1KSkNCj4gKwlpZiAoIXZnaWNfaXNf
djUodmNwdS0+a3ZtKSkNCj4gwqAJCXNldF90aW1lcl9pcnFfcGh5c19hY3RpdmUoY3R4LCBwaHlz
X2FjdGl2ZSk7DQo+IMKgCWVsc2UNCj4gwqAJCXNldF90aW1lcl9pcnFfcGh5c19tYXNrZWQoY3R4
LCB0cnVlKTsNCj4gQEAgLTc2MCw3ICs3NTUsNyBAQCBzdGF0aWMgdm9pZA0KPiBrdm1fdGltZXJf
dmNwdV9sb2FkX25lc3RlZF9zd2l0Y2goc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiDCoAlpZiAo
IWlycWNoaXBfaW5fa2VybmVsKHZjcHUtPmt2bSkpDQo+IMKgCQlyZXR1cm47DQo+IMKgDQo+IC0J
b3BzID0gdmdpY19pc192NSh2Y3B1KSA/ICZhcmNoX3RpbWVyX2lycV9vcHNfdmdpY192NSA6DQo+
ICsJb3BzID0gdmdpY19pc192NSh2Y3B1LT5rdm0pID8gJmFyY2hfdGltZXJfaXJxX29wc192Z2lj
X3Y1IDoNCj4gwqAJCQkJICZhcmNoX3RpbWVyX2lycV9vcHM7DQo+IMKgDQo+IMKgCS8qDQo+IEBA
IC05MDUsNyArOTAwLDcgQEAgdm9pZCBrdm1fdGltZXJfdmNwdV9sb2FkKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gwqANCj4gwqAJaWYgKHN0YXRpY19icmFuY2hfbGlrZWx5KCZoYXNfZ2ljX2Fj
dGl2ZV9zdGF0ZSkpIHsNCj4gwqAJCS8qIFdlIGRvbid0IGRvIE5WIG9uIEdJQ3Y1LCB5ZXQgKi8N
Cj4gLQkJaWYgKHZjcHVfaGFzX252KHZjcHUpICYmICF2Z2ljX2lzX3Y1KHZjcHUpKQ0KPiArCQlp
ZiAodmNwdV9oYXNfbnYodmNwdSkgJiYgIXZnaWNfaXNfdjUodmNwdS0+a3ZtKSkNCj4gwqAJCQlr
dm1fdGltZXJfdmNwdV9sb2FkX25lc3RlZF9zd2l0Y2godmNwdSwNCj4gJm1hcCk7DQo+IMKgDQo+
IMKgCQlrdm1fdGltZXJfdmNwdV9sb2FkX2dpYyhtYXAuZGlyZWN0X3Z0aW1lcik7DQo+IEBAIC05
NzcsNyArOTcyLDcgQEAgdm9pZCBrdm1fdGltZXJfdmNwdV9wdXQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQ0KPiDCoAkJa3ZtX3RpbWVyX2Jsb2NraW5nKHZjcHUpOw0KPiDCoA0KPiDCoAkvKiBVbm1h
c2sgYWdhaW4gb24gR0lDVjUgKi8NCj4gLQlpZiAodmdpY19pc192NSh2Y3B1KSkgew0KPiArCWlm
ICh2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpIHsNCj4gwqAJCXNldF90aW1lcl9pcnFfcGh5c19tYXNr
ZWQobWFwLmRpcmVjdF92dGltZXIsIGZhbHNlKTsNCj4gwqANCj4gwqAJCWlmIChtYXAuZGlyZWN0
X3B0aW1lcikNCj4gQEAgLTE2MjMsNyArMTYxOCw3IEBAIGludCBrdm1fdGltZXJfZW5hYmxlKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gwqAJCXJldHVybiAtRUlOVkFMOw0KPiDCoAl9DQo+IMKg
DQo+IC0Jb3BzID0gdmdpY19pc192NSh2Y3B1KSA/ICZhcmNoX3RpbWVyX2lycV9vcHNfdmdpY192
NSA6DQo+ICsJb3BzID0gdmdpY19pc192NSh2Y3B1LT5rdm0pID8gJmFyY2hfdGltZXJfaXJxX29w
c192Z2ljX3Y1IDoNCj4gwqAJCQkJICZhcmNoX3RpbWVyX2lycV9vcHM7DQo+IMKgDQo+IMKgCWdl
dF90aW1lcl9tYXAodmNwdSwgJm1hcCk7DQo+IEBAIC0xNzAwLDcgKzE2OTUsNyBAQCBpbnQga3Zt
X2FybV90aW1lcl9zZXRfYXR0cihzdHJ1Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUsIHN0cnVjdCBrdm1f
ZGV2aWNlX2F0dHIgKmF0dHIpDQo+IMKgCSAqIFRoZSBQUElzIGZvciB0aGUgQXJjaCBUaW1lcnMg
YXJjaCBhcmNoaXRlY3R1cmFsbHkgZGVmaW5lZA0KPiBmb3INCj4gwqAJICogR0lDdjUuIFJlamVj
dCBhbnl0aGluZyB0aGF0IGNoYW5nZXMgdGhlbSBmcm9tIHRoZQ0KPiBzcGVjaWZpZWQgdmFsdWUu
DQo+IMKgCSAqLw0KPiAtCWlmICh2Z2ljX2lzX3Y1KHZjcHUpICYmIHZjcHUtPmt2bS0+YXJjaC50
aW1lcl9kYXRhLnBwaVtpZHhdDQo+ICE9IGlycSkgew0KPiArCWlmICh2Z2ljX2lzX3Y1KHZjcHUt
Pmt2bSkgJiYgdmNwdS0+a3ZtLQ0KPiA+YXJjaC50aW1lcl9kYXRhLnBwaVtpZHhdICE9IGlycSkg
ew0KPiDCoAkJcmV0ID0gLUVJTlZBTDsNCj4gwqAJCWdvdG8gb3V0Ow0KPiDCoAl9DQo+IGRpZmYg
LS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUuYw0KPiBiL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NS5jDQo+IGluZGV4IGQ3NGNjMzU0M2I5YTQuLjE5ZDhiZjkwZjhmNmMgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ICsrKyBiL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+IEBAIC0yMjUsNyArMjI1LDcgQEAgYm9vbCB2Z2lj
X3Y1X3BwaV9xdWV1ZV9pcnFfdW5sb2NrKHN0cnVjdCBrdm0NCj4gKmt2bSwgc3RydWN0IHZnaWNf
aXJxICppcnEsDQo+IMKgDQo+IMKgCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmlycS0+aXJxX2xvY2sp
Ow0KPiDCoA0KPiAtCWlmIChXQVJOX09OX09OQ0UoIWlycV9pc19wcGlfdjUoaXJxLT5pbnRpZCkp
KQ0KPiArCWlmIChXQVJOX09OX09OQ0UoIV9faXJxX2lzX3BwaShLVk1fREVWX1RZUEVfQVJNX1ZH
SUNfVjUsDQo+IGlycS0+aW50aWQpKSkNCj4gwqAJCXJldHVybiBmYWxzZTsNCj4gwqANCj4gwqAJ
dmNwdSA9IGlycS0+dGFyZ2V0X3ZjcHU7DQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+IGluZGV4IDYyZDdkNGM1
NjUwZTQuLjZkOGU0Y2Q2NjE3MzQgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy5jDQo+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5jDQo+IEBAIC0xMDksMTAg
KzEwOSwxMCBAQCBzdHJ1Y3QgdmdpY19pcnEgKnZnaWNfZ2V0X3ZjcHVfaXJxKHN0cnVjdA0KPiBr
dm1fdmNwdSAqdmNwdSwgdTMyIGludGlkKQ0KPiDCoAlpZiAoV0FSTl9PTighdmNwdSkpDQo+IMKg
CQlyZXR1cm4gTlVMTDsNCj4gwqANCj4gLQlpZiAodmNwdS0+a3ZtLT5hcmNoLnZnaWMudmdpY19t
b2RlbCA9PQ0KPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUpIHsNCj4gKwlpZiAodmdpY19pc192
NSh2Y3B1LT5rdm0pKSB7DQo+IMKgCQl1MzIgaW50X251bSA9IEZJRUxEX0dFVChHSUNWNV9IV0lS
UV9JRCwgaW50aWQpOw0KPiDCoA0KPiAtCQlpZiAoaXJxX2lzX3BwaV92NShpbnRpZCkpIHsNCj4g
KwkJaWYgKF9faXJxX2lzX3BwaShLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjUsIGludGlkKSkgew0K
PiDCoAkJCWludF9udW0gPSBhcnJheV9pbmRleF9ub3NwZWMoaW50X251bSwNCj4gVkdJQ19WNV9O
Ul9QUklWQVRFX0lSUVMpOw0KPiDCoAkJCXJldHVybiAmdmNwdS0NCj4gPmFyY2gudmdpY19jcHUu
cHJpdmF0ZV9pcnFzW2ludF9udW1dOw0KPiDCoAkJfQ0KPiBAQCAtNjAwLDE1ICs2MDAsMTMgQEAg
c3RhdGljIGludCBrdm1fdmdpY19tYXBfaXJxKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSwgc3Ry
dWN0IHZnaWNfaXJxICppcnEsDQo+IMKgCWlycS0+aHdpbnRpZCA9IGRhdGEtPmh3aXJxOw0KPiDC
oAlpcnEtPm9wcyA9IG9wczsNCj4gwqANCj4gLQlpZiAodmdpY19pc192NSh2Y3B1LT5rdm0pKSB7
DQo+IC0JCS8qIE5vdGhpbmcgZm9yIHVzIHRvIGRvICovDQo+IC0JCWlmICghaXJxX2lzX3BwaV92
NShpcnEtPmludGlkKSkNCj4gLQkJCXJldHVybiAwOw0KPiArCWlmICh2Z2ljX2lzX3Y1KHZjcHUt
Pmt2bSkgJiYNCj4gKwnCoMKgwqAgIV9faXJxX2lzX3BwaShLVk1fREVWX1RZUEVfQVJNX1ZHSUNf
VjUsIGlycS0+aW50aWQpKQ0KPiArCQlyZXR1cm4gMDsNCj4gwqANCj4gLQkJaWYgKEZJRUxEX0dF
VChHSUNWNV9IV0lSUV9JRCwgaXJxLT5pbnRpZCkgPT0gaXJxLQ0KPiA+aHdpbnRpZCkgew0KPiAt
CQkJaWYgKCF2Z2ljX3Y1X3NldF9wcGlfZHZpKHZjcHUsIGlycS0+aHdpbnRpZCwNCj4gdHJ1ZSkp
DQo+IC0JCQkJaXJxLT5kaXJlY3RseV9pbmplY3RlZCA9IHRydWU7DQo+IC0JCX0NCj4gKwlpZiAo
RklFTERfR0VUKEdJQ1Y1X0hXSVJRX0lELCBpcnEtPmludGlkKSA9PSBpcnEtPmh3aW50aWQpIHsN
Cj4gKwkJaWYgKCF2Z2ljX3Y1X3NldF9wcGlfZHZpKHZjcHUsIGlycS0+aHdpbnRpZCwgdHJ1ZSkp
DQo+ICsJCQlpcnEtPmRpcmVjdGx5X2luamVjdGVkID0gdHJ1ZTsNCj4gwqAJfQ0KPiDCoA0KPiDC
oAlyZXR1cm4gMDsNCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy5oIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gaW5kZXggOTE5NjliM2I4MGQwNC4uZDhhOTQ3
YTdlYjk0MSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gKysr
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLmgNCj4gQEAgLTUwMCwxMSArNTAwLDYgQEAgc3Rh
dGljIGlubGluZSBib29sIHZnaWNfaXNfdjMoc3RydWN0IGt2bSAqa3ZtKQ0KPiDCoAlyZXR1cm4g
a3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLnR5cGUgPT0gVkdJQ19WMyB8fA0KPiB2Z2ljX2lzX3YzX2Nv
bXBhdChrdm0pOw0KPiDCoH0NCj4gwqANCj4gLXN0YXRpYyBpbmxpbmUgYm9vbCB2Z2ljX2lzX3Y1
KHN0cnVjdCBrdm0gKmt2bSkNCj4gLXsNCj4gLQlyZXR1cm4ga3ZtX3ZnaWNfZ2xvYmFsX3N0YXRl
LnR5cGUgPT0gVkdJQ19WNSAmJg0KPiAhdmdpY19pc192M19jb21wYXQoa3ZtKTsNCj4gLX0NCj4g
LQ0KPiDCoGJvb2wgc3lzdGVtX3N1cHBvcnRzX2RpcmVjdF9zZ2lzKHZvaWQpOw0KPiDCoGJvb2wg
dmdpY19zdXBwb3J0c19kaXJlY3RfbXNpcyhzdHJ1Y3Qga3ZtICprdm0pOw0KPiDCoGJvb2wgdmdp
Y19zdXBwb3J0c19kaXJlY3Rfc2dpcyhzdHJ1Y3Qga3ZtICprdm0pOw0KPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9rdm0vYXJtX3ZnaWMuaCBiL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgNCj4gaW5kZXgg
Njg2M2UxOWQ2ZWViNy4uYWUyODk3YzUzOWFmNyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9rdm0v
YXJtX3ZnaWMuaA0KPiArKysgYi9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oDQo+IEBAIC0zNiwyMiAr
MzYsNzggQEANCj4gwqAvKiBHSUN2NSBjb25zdGFudHMgKi8NCj4gwqAjZGVmaW5lIFZHSUNfVjVf
TlJfUFJJVkFURV9JUlFTCTEyOA0KPiDCoA0KPiAtI2RlZmluZSBpcnFfaXNfcHBpX2xlZ2FjeShp
cnEpICgoaXJxKSA+PSBWR0lDX05SX1NHSVMgJiYgKGlycSkgPA0KPiBWR0lDX05SX1BSSVZBVEVf
SVJRUykNCj4gLSNkZWZpbmUgaXJxX2lzX3NwaV9sZWdhY3koaXJxKSAoKGlycSkgPj0gVkdJQ19O
Ul9QUklWQVRFX0lSUVMgJiYgXA0KPiAtCQkJCQkoaXJxKSA8PSBWR0lDX01BWF9TUEkpDQo+IC0j
ZGVmaW5lIGlycV9pc19scGlfbGVnYWN5KGlycSkgKChpcnEpID4gVkdJQ19NQVhfU1BJKQ0KPiAt
DQo+IC0jZGVmaW5lIGlycV9pc19wcGlfdjUoaXJxKSAoRklFTERfR0VUKEdJQ1Y1X0hXSVJRX1RZ
UEUsIGlycSkgPT0NCj4gR0lDVjVfSFdJUlFfVFlQRV9QUEkpDQo+IC0jZGVmaW5lIGlycV9pc19z
cGlfdjUoaXJxKSAoRklFTERfR0VUKEdJQ1Y1X0hXSVJRX1RZUEUsIGlycSkgPT0NCj4gR0lDVjVf
SFdJUlFfVFlQRV9TUEkpDQo+IC0jZGVmaW5lIGlycV9pc19scGlfdjUoaXJxKSAoRklFTERfR0VU
KEdJQ1Y1X0hXSVJRX1RZUEUsIGlycSkgPT0NCj4gR0lDVjVfSFdJUlFfVFlQRV9MUEkpDQo+IC0N
Cj4gLSNkZWZpbmUgZ2ljX2lzX3Y1KGspICgoayktPmFyY2gudmdpYy52Z2ljX21vZGVsID09DQo+
IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSkNCj4gLQ0KPiAtI2RlZmluZSBpcnFfaXNfcHBpKGss
IGkpIChnaWNfaXNfdjUoaykgPyBpcnFfaXNfcHBpX3Y1KGkpIDoNCj4gaXJxX2lzX3BwaV9sZWdh
Y3koaSkpDQo+IC0jZGVmaW5lIGlycV9pc19zcGkoaywgaSkgKGdpY19pc192NShrKSA/IGlycV9p
c19zcGlfdjUoaSkgOg0KPiBpcnFfaXNfc3BpX2xlZ2FjeShpKSkNCj4gLSNkZWZpbmUgaXJxX2lz
X2xwaShrLCBpKSAoZ2ljX2lzX3Y1KGspID8gaXJxX2lzX2xwaV92NShpKSA6DQo+IGlycV9pc19s
cGlfbGVnYWN5KGkpKQ0KPiAtDQo+IC0jZGVmaW5lIGlycV9pc19wcml2YXRlKGssIGkpIChnaWNf
aXNfdjUoaykgPyBpcnFfaXNfcHBpX3Y1KGkpIDogaSA8DQo+IFZHSUNfTlJfUFJJVkFURV9JUlFT
KQ0KPiArI2RlZmluZSBpc192NV90eXBlKHQsIGkpCShGSUVMRF9HRVQoR0lDVjVfSFdJUlFfVFlQ
RSwgKGkpKSA9PQ0KPiAodCkpDQo+ICsNCj4gKyNkZWZpbmUgX19pcnFfaXNfc2dpKHQsDQo+IGkp
CQkJCQkJXA0KPiArCSh7CQkJCQkJCQ0KPiAJXA0KPiArCQlib29sDQo+IF9fcmV0OwkJCQkJCVwN
Cj4gKwkJCQkJCQkJDQo+IAlcDQo+ICsJCXN3aXRjaCAodCkNCj4gewkJCQkJCVwNCj4gKwkJY2Fz
ZQ0KPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjU6CQkJCVwNCj4gKwkJCV9fcmV0ID0NCj4gZmFs
c2U7CQkJCQlcDQo+ICsJCQlicmVhazsJCQkJCQ0KPiAJXA0KPiArCQlkZWZhdWx0OgkJCQkJDQo+
IAlcDQo+ICsJCQlfX3JldMKgID0gKGkpIDwNCj4gVkdJQ19OUl9TR0lTOwkJCVwNCj4gKwkJfQkJ
CQkJCQ0KPiAJXA0KPiArCQkJCQkJCQkNCj4gCVwNCj4gKwkJX19yZXQ7CQkJCQkJDQo+IAlcDQo+
ICsJfSkNCj4gKw0KPiArI2RlZmluZSBfX2lycV9pc19wcGkodCwNCj4gaSkJCQkJCQlcDQo+ICsJ
KHsJCQkJCQkJDQo+IAlcDQo+ICsJCWJvb2wNCj4gX19yZXQ7CQkJCQkJXA0KPiArCQkJCQkJCQkN
Cj4gCVwNCj4gKwkJc3dpdGNoICh0KQ0KPiB7CQkJCQkJXA0KPiArCQljYXNlDQo+IEtWTV9ERVZf
VFlQRV9BUk1fVkdJQ19WNToJCQkJXA0KPiArCQkJX19yZXQgPSBpc192NV90eXBlKEdJQ1Y1X0hX
SVJRX1RZUEVfUFBJLA0KPiAoaSkpOwlcDQo+ICsJCQlicmVhazsJCQkJCQ0KPiAJXA0KPiArCQlk
ZWZhdWx0OgkJCQkJDQo+IAlcDQo+ICsJCQlfX3JldMKgID0gKGkpID49DQo+IFZHSUNfTlJfU0dJ
UzsJCQlcDQo+ICsJCQlfX3JldCAmPSAoaSkgPA0KPiBWR0lDX05SX1BSSVZBVEVfSVJRUzsJCVwN
Cj4gKwkJfQkJCQkJCQ0KPiAJXA0KPiArCQkJCQkJCQkNCj4gCVwNCj4gKwkJX19yZXQ7CQkJCQkJ
DQo+IAlcDQo+ICsJfSkNCj4gKw0KPiArI2RlZmluZSBfX2lycV9pc19zcGkodCwNCj4gaSkJCQkJ
CQlcDQo+ICsJKHsJCQkJCQkJDQo+IAlcDQo+ICsJCWJvb2wNCj4gX19yZXQ7CQkJCQkJXA0KPiAr
CQkJCQkJCQkNCj4gCVwNCj4gKwkJc3dpdGNoICh0KQ0KPiB7CQkJCQkJXA0KPiArCQljYXNlDQo+
IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNToJCQkJXA0KPiArCQkJX19yZXQgPSBpc192NV90eXBl
KEdJQ1Y1X0hXSVJRX1RZUEVfU1BJLA0KPiAoaSkpOwlcDQo+ICsJCQlicmVhazsJCQkJCQ0KPiAJ
XA0KPiArCQlkZWZhdWx0OgkJCQkJDQo+IAlcDQo+ICsJCQlfX3JldMKgID0gKGkpIDw9DQo+IFZH
SUNfTUFYX1NQSTsJCQlcDQo+ICsJCQlfX3JldCAmPSAoaSkgPj0NCj4gVkdJQ19OUl9QUklWQVRF
X0lSUVM7CQlcDQo+ICsJCX0JCQkJCQkNCj4gCVwNCj4gKwkJCQkJCQkJDQo+IAlcDQo+ICsJCV9f
cmV0OwkJCQkJCQ0KPiAJXA0KPiArCX0pDQo+ICsNCj4gKyNkZWZpbmUgX19pcnFfaXNfbHBpKHQs
DQo+IGkpCQkJCQkJXA0KPiArCSh7CQkJCQkJCQ0KPiAJXA0KPiArCQlib29sDQo+IF9fcmV0OwkJ
CQkJCVwNCj4gKwkJCQkJCQkJDQo+IAlcDQo+ICsJCXN3aXRjaCAodCkNCj4gewkJCQkJCVwNCj4g
KwkJY2FzZQ0KPiBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjU6CQkJCVwNCj4gKwkJCV9fcmV0ID0g
aXNfdjVfdHlwZShHSUNWNV9IV0lSUV9UWVBFX0xQSSwNCj4gKGkpKTsJXA0KPiArCQkJYnJlYWs7
CQkJCQkNCj4gCVwNCj4gKwkJZGVmYXVsdDoJCQkJCQ0KPiAJXA0KPiArCQkJX19yZXTCoCA9IChp
KSA+PQ0KPiA4MTkyOwkJCQlcDQo+ICsJCX0JCQkJCQkNCj4gCVwNCj4gKwkJCQkJCQkJDQo+IAlc
DQo+ICsJCV9fcmV0OwkJCQkJCQ0KPiAJXA0KPiArCX0pDQo+ICsNCj4gKyNkZWZpbmUgaXJxX2lz
X3NnaShrLCBpKSBfX2lycV9pc19zZ2koKGspLT5hcmNoLnZnaWMudmdpY19tb2RlbCwgaSkNCj4g
KyNkZWZpbmUgaXJxX2lzX3BwaShrLCBpKSBfX2lycV9pc19wcGkoKGspLT5hcmNoLnZnaWMudmdp
Y19tb2RlbCwgaSkNCj4gKyNkZWZpbmUgaXJxX2lzX3NwaShrLCBpKSBfX2lycV9pc19zcGkoKGsp
LT5hcmNoLnZnaWMudmdpY19tb2RlbCwgaSkNCj4gKyNkZWZpbmUgaXJxX2lzX2xwaShrLCBpKSBf
X2lycV9pc19scGkoKGspLT5hcmNoLnZnaWMudmdpY19tb2RlbCwgaSkNCj4gKw0KPiArI2RlZmlu
ZSBpcnFfaXNfcHJpdmF0ZShrLCBpKSAoaXJxX2lzX3BwaShrLCBpKSB8fCBpcnFfaXNfc2dpKGss
IGkpKQ0KPiArDQo+ICsjZGVmaW5lIHZnaWNfaXNfdjUoaykgKChrKS0+YXJjaC52Z2ljLnZnaWNf
bW9kZWwgPT0NCj4gS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1Y1KQ0KPiDCoA0KPiDCoGVudW0gdmdp
Y190eXBlIHsNCj4gwqAJVkdJQ19WMiwJCS8qIEdvb2Qgb2wnIEdJQ3YyICovDQo+IA0KDQo=

