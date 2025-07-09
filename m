Return-Path: <kvm+bounces-51932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28144AFEA79
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53A471C83171
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9952E4265;
	Wed,  9 Jul 2025 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OYKy+myM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC1B2DEA87;
	Wed,  9 Jul 2025 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752068421; cv=fail; b=gFUl7mKQa7eoZw/k6fhPRGPTSVm6PJi6rbqvJ3uM1b+kRg/1FQwiqoXNd6wYwAdPMRZ8/xwXyIwjvv+Vnz+Pj2kDhCMFbHPUscuVO+ivp/tCMUBWxhZgVI445Ru2YsJixkxcuWT4a5h9bX7yYi5zQH8eWZ7IDj0A/ngYDMgEQ4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752068421; c=relaxed/simple;
	bh=Q1loUoqTyoTYEGpecx4pLP1bjwLRKIu+4dsUQqAjV+M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KPrlBDjjglePGdo7n9RoFgU8T5wLfAuX9qCnGodwSXbMy5UpIOkLvIDFdx+yyTld1tbOJ+7Va/ON/yzEqe4PnKrU0MY05PqQ0Ul571HyYuejwNfyuxuMN6shi5tJ6Ve/kQU0PttIpgkCE+d6GGbJUOHcD51h6h9TV8zX61CtLOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OYKy+myM; arc=fail smtp.client-ip=40.107.100.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmiVsGbiVeCGoZkHSkQSeY/0596SRcQ7yPUZqbTyvH5hqHFc1d0PTTZEtFLebpK5cGJoc3hydLKo6ZYk+MI2NozAIuLcxFnws6sDZT0AqdekmCNTgxWe2UkPYVwgxIfGaNeRYbFiMvaZAzksz4julc+o0CyFa4VKph/yqBGOpFen99xFjwmNCsYNqDxezqEs1yFZ+enQS9duEo39Yf8+/e7yywg8jDu3BoqTvXSXTZz59eTfbRAh34P5B1WCrmxwv/wDqK8sCj4mew0z4K9CgP31nnvaZhgI7TvUtGH0N70m6U056BLd3DZSOhQWCWooqLAllMrBZWIWtfFj7yTRDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1loUoqTyoTYEGpecx4pLP1bjwLRKIu+4dsUQqAjV+M=;
 b=IxVYBynjkz2xicdYkmxErWokYyaVwzq83vRzG6SlAaFSm537t4+AkH/DIvLkk08r8HhGZUO0wY9/w6PHZ6rzHgyExTdhEkdgRFekLoLMa+pMNARv0UEnnqjCIyBlicKRi7ldkSny0bodLoBLp0s6bKqoeeMyfrjov5CpBK2Z45wHDxhzLro4KGfjxuFaPqzEzYaky/l33qkTXpIJeULrsaU9XCRuvaq4EuOkayL920J5fWMd+BbWli9fsyb0TsteQmQYtXaZN+jUP3SN381/QJzVt+0YPp+692wav8XtF7RZjG6HpFsfKHOzFCY513Geq1nKCLhqbJJiNdTxL5rMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1loUoqTyoTYEGpecx4pLP1bjwLRKIu+4dsUQqAjV+M=;
 b=OYKy+myMkewgd9B0laq+2mxuyr/TiXblXJY51LqUM469m/nsba4ReiZd0rXNtbajflc7U5VvqjGrVhTVc9WnV3NQ65u7zXySMr4s0k/vsXJmxUZjItvY8HEWJINvZypSxYCw37KNk9g3rg55QkT5XNMDP7zZcxSKPiVDJ/s7yR4=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MW6PR12MB8898.namprd12.prod.outlook.com (2603:10b6:303:246::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Wed, 9 Jul
 2025 13:40:16 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%4]) with mapi id 15.20.8880.015; Wed, 9 Jul 2025
 13:40:16 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"jon@nutanix.com" <jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Topic: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Index: AQHbxM926MXs9CcUxkqIa02t4IOATLQHmku+gCKKFoA=
Date: Wed, 9 Jul 2025 13:40:16 +0000
Message-ID: <d530621e89dae01dc27bbdc8a97a1935b0827699.camel@amd.com>
References: <20250313203702.575156-1-jon@nutanix.com>
	 <20250313203702.575156-7-jon@nutanix.com> <aCI8pGJbn3l99kq8@google.com>
	 <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
	 <aCNI72KuMLfWb9F2@google.com>
	 <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
	 <aCSSptnxW7EBEzSQ@google.com>
	 <7704c861ba54c246dc8e5f26113c6f84306a099e.camel@amd.com>
	 <aFF38Pq71JdLBlqO@google.com>
In-Reply-To: <aFF38Pq71JdLBlqO@google.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MW6PR12MB8898:EE_
x-ms-office365-filtering-correlation-id: 01d34061-bb57-4897-72e8-08ddbeee235c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZnNXWEFsdm94QTl1SkZZTWJoOVEvM1NTZ0UvTFdYMVJ1VmZsMXUzSVBuTGpa?=
 =?utf-8?B?M3V1UGk0NFpIQUE2TjFHKzQvVUMrZkVZVlVrQ3c2aEZuMWRXNHFNc09zVFB0?=
 =?utf-8?B?ZVNwVU9UcVRFSFA4ZEFibHN6WXp0TlV1QjVtTVovVFNkUk5jZFAwK1U2Qjlo?=
 =?utf-8?B?dTd0RTh3RlcrM0lwZVQ3WTVUMjR4MktHY3ZXSExONGNCYU9qbkw2blNhOFBM?=
 =?utf-8?B?SUJUYlRnbkxkOUFWRHhRa1FTbmsxQksvelMxK0FzcVdOQ0lNS0lJT2N0cHRG?=
 =?utf-8?B?ZE9QanlWUEJ0b0IveUFmMnMrc1dhYXZiS1g1bEpRRjhOcnFEa0l2TmZPS0dq?=
 =?utf-8?B?NEFwZGd2em5vVEZxNFREaEY3RGVSQ1lGdzlVRC9uZmgwSnNoeXhBV1h3cVVG?=
 =?utf-8?B?QUJtWGRTQ2t6dU1EWVNOd0NBd09HUG1CN2gwZ29mQmE0M3pTS3pIenA1dVU4?=
 =?utf-8?B?Q3NZellUajhLbUhpMjVtSE9xbkZxNUFRakRsbVllL2hQSVNkbjZsV2pzRzZX?=
 =?utf-8?B?SWdKVnVpSzZxcDViT2Y5ekNSQmJrcnlDMHdwaDFCUDV4WGdvb2ZkNVRpTW85?=
 =?utf-8?B?WkxscWRBd1UzL1duRGNpb2ZEOE5lSjUvOW84WllpRk5pVEZjQy95ZHkzZTNL?=
 =?utf-8?B?VlFURXJ2WEhVQStHbEpsbDBxT3RJY2t5d1NqV0VUK1VOZ3lnYXhVZ3pPb2kz?=
 =?utf-8?B?T2psdnpSSUtKa0xZUjhqNStLRDZFWCtEM1c1MXVrQjVBVDkrNGprQlJoN1Nu?=
 =?utf-8?B?NnFiNVNJSzRCZFQxZ2ZCRitCWXN6N2w3UjhxNU1BOWRCNEpEYU5lcG5RcHc5?=
 =?utf-8?B?dXl6b0ZQcmxhU3dJR3JEU0xPUjUxMko0UlpJWXdpWHUrOWQ5cUh4a0ZLTW81?=
 =?utf-8?B?WHZzV3B1aHpCYmdaWEZla1dYV3drbUFhUnZvbytPUGdlNUZFYTRkSDd1bUV3?=
 =?utf-8?B?MDRYQzA1WlVWV21pM0k5UXVQMnViRTg1em1sL05wc3c3RklQU3F4UFRvaXU2?=
 =?utf-8?B?cjlJdWozQ3JWZGtqdElUdy8xYmdvMVZ2dFNCeXRNWW5MQVZUUDFNVHVsUHRo?=
 =?utf-8?B?Z0RkY0c0dTlrRVg3ZE10REhDL1ZRekU1S1FOUnE2ZTRwOWYrTEZIZUdwbVI5?=
 =?utf-8?B?ZDh6TzROK3E2OTJEOGZaNHdqNWxERFNEZkFrUVdjZ2IvQVRPKzV5c2VNblR3?=
 =?utf-8?B?Q3dGNzRqbWpnQ29nSFdweHdGUDZJd2J4ZUxOZkFKc29HaUFFN0dnYllPRkh3?=
 =?utf-8?B?YWpXTzh6MmJzeU5RU0NKVkpvTUdDeFNIM2h1dG92eWlUd0J1eVpKMXRmd0o2?=
 =?utf-8?B?K0JJNlZYMEhzYlI5THoydHVkOGVhbENJZTlYaXFWS1BKTUsySW1SbXF6aDRi?=
 =?utf-8?B?eVUvU1VZdU1GRUlUOGxsTitOZUtuTGpyTjkrOWtQOVlqdE1ZMkpaaVZhLzhN?=
 =?utf-8?B?RVd2MmZVdnBacFZxSllMQU5tdy9NRXNaRmNCVjdjYzVqVlo0TjNNODFaMmQw?=
 =?utf-8?B?VitnbHl6WnVqWFNPYTFpMStncXBPQ1ZoN1VHRGw1bW02YjViMzZNR1d6TVRy?=
 =?utf-8?B?VUV2S0pNcC9ad2xMTFdsVUprMzhBMkdZZFVQaHJ1R3AvdnBFWnZ2VlZ5TDM0?=
 =?utf-8?B?UlRWbVVNVlVJNFh1MVVFT2dwUTVFanpveE8vOUZyMXpWSzFZWVN2TVRLYXBH?=
 =?utf-8?B?bXZQc3ZkRUNHb2Y3SndSRDdFMmtvT0h4SEJ1SGFtNjVKOERjc1RtS1ZUSWlt?=
 =?utf-8?B?UXVscUljSnZtY3E0U2M1ODlaQnRkc2tjR2NaT1lEbG9UdFVSSEtrRXUzM0hn?=
 =?utf-8?B?VDJETjJEQVZTRXlXRnBrTG1qL1YzZjloYXRtL3lsUlVPL0ZPZFhicUNDc3ZV?=
 =?utf-8?B?SjFZTjl6VUVUcFk5R25mVk5XVlQxT2JIcjdxMUFYcWZYSzczeTdvUS9BMG8v?=
 =?utf-8?B?Z1pFV1o3aFJLWWxwYnhGZ2JMRHppRVpwaVBQRUtmdjg4Y2EyZXBkSGdaRmlY?=
 =?utf-8?B?c0g3QjFkNTNBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2VlWGpKQkFGSWNkUVB1bzJ3bkNDYUVLOGFxblB4QzZLaGg0NDlsM0s1UzE2?=
 =?utf-8?B?S01oY0NueldzbVE0L1B2WEJsYWdkU1B5OFdVbCtKZHF0RmVRSU1qc2RocVVQ?=
 =?utf-8?B?cEIzSE9La1BFenlSV0lRYnlJa1NmWkFNZ1dxK0tlV2NudVlzZmFScXRZUGlj?=
 =?utf-8?B?VzdhMkdpSUI3b0VWamQzL2ZibkJqQUxGZE10YXUrbEpIc05lMFhYQ0NiY2xG?=
 =?utf-8?B?U29MM1g1L3ZiZWljVHV6SS9nYjMzbVNObFdic2VzWEhRMmVoQldFS3REblNm?=
 =?utf-8?B?dGM1WnRCM2R6S1FjMXh6SVF2bWQ2d1FQbWtibkFnS04wSm4rOWVLbTA4RHBV?=
 =?utf-8?B?M1cyUTVrUTZrOFBFeS9WY2diQTJJeVUybjFBUHo0T3p1Q25HVEhtWlhoNmdS?=
 =?utf-8?B?bzhmQk01d3VsQ0xmQTkzaWlXR253RStSU2VHcFAvUFdwNXNNUm9DcXdDK1E4?=
 =?utf-8?B?SHo3LzNKMmljQS9pK0RGUjd6YitPT0xjRHlvejdWcm1jOHhsMndXaUpNYmFI?=
 =?utf-8?B?VDJ0UzVQQUQ5b3p2SWdsU3g4V2E0ekRKZ0Y4OVlXY09LRWpFM0ZXbDlYLzRS?=
 =?utf-8?B?eVRUTlNSYTlBZ3NOZEtHUE9BeXNRWk1YY2E5L1g4T3VZWTA1V2dybVVORTZR?=
 =?utf-8?B?NmJUc3VoTG8rK2hMeFg2YUkweHU1U0VtcWx2cDdqZ1VtVVNpdE5KemVxUXJX?=
 =?utf-8?B?Y2tVdjFLeXdRMzVGWGlZL2xielAwUWFhSEZIL1NPQkhQQnMwZ2ZPN0hqS25i?=
 =?utf-8?B?NlFmbExwUWh2SnBSeWdjOVhDVXZxVC9OUy9PZ0hSL1NEb3FkZ1crelRkU0NG?=
 =?utf-8?B?cWE4aGJ6VGw3L2NoTUw3L2VxTzJWV1FldXFqUGY0Wkl4eUhKNW5PSHp1eldF?=
 =?utf-8?B?MFZBZmtmdHNiNXd1SmpacldpTU9MblVKb2hJYnh6d1lqNG9rRmhuWVhkSlVz?=
 =?utf-8?B?YjZNbEpYTVRzdEVlSnhvbDJkSExVWUVLdFN6QUNTM1RxbzRLa3R6bno5T3FZ?=
 =?utf-8?B?elpNV0ZiKzU5ckc2UGFxQm8ydzFzeXMwQWpKYWh3bW1PSjU2STZxVnliZjBM?=
 =?utf-8?B?YkloQ0ovTStxVjA5cU1ZT0xzK1UzcFhDZ2svTVJYdnlvVU9zWFNRMVQ0Q3B3?=
 =?utf-8?B?RXRKZEFITWVJM3g4bmMwT0dZQkhBMWt4elFXM0ErR05ZNlprUUQ0U2E0OUdV?=
 =?utf-8?B?dThDcEZWajRxSGJEbG1HNnM5SFczUVdWUFBDVGwrdXhFSytiWjVnL0FBU1FY?=
 =?utf-8?B?U2ZHVXlCYnZXNmIrTXlsb0krTGxMckRDc2J6NkFoUDQ0ZUpHakpNSWlWbXl4?=
 =?utf-8?B?aWEzMG9Rd3pSeGYySnBaejhGd2FYS1luS2wwUk1qaXlUN0QyMTNzblNhcVps?=
 =?utf-8?B?a2dwYVBkU3Z1NHNsZ3J4L3lnc1RGelhtMyt6VWVyNWwwekhPeCtkQXJUNTRU?=
 =?utf-8?B?QmNxaXlCbkg1d1lhTGFBeFhLUHJnc1hiOEtZQVlrVzkvSm5LK2pkVDBGNjFC?=
 =?utf-8?B?azRDbUI0UlhqZlc5c1FPSURXNnMrTlNhamE4VGdQM1lQRFJTdkZRUWNtZ1cr?=
 =?utf-8?B?YmpKZS95d2Q5Z2VNamt3czFVM25xTDNqV1BMeXpSZmg3SkVUZnhMQjc4RGxp?=
 =?utf-8?B?RjlGMVZwQUJVL1IrQVhaaitDOGozZWhzMGxSNnpnMkhLR3lObkZFUC9jZDRt?=
 =?utf-8?B?TEZGVURFMDVlRS82VHUwb1Z5SllhMTlOZmV5NGowQ0Z1b1JxV2V6anlxNEsy?=
 =?utf-8?B?eFVMcEFkNC9zWVVTOGlteC9CN0ttNUVtSkJKbm5WR2cvRWxzamMwMmlJbmdX?=
 =?utf-8?B?dFVnelVZM1RiNUpWVFNIOHdEa0RzOEhLZTNIOG1CN0xhdzg5WmRaUC9kcDAw?=
 =?utf-8?B?U1NHVW42N1c2cyt6U1JTK0VJZHZBaElHZC8zQ0dWd2RLMzAxSHZLalZrTXB6?=
 =?utf-8?B?bVZoVFg5djRKdnRQTzZhMWQ5OFJpNXN2NXg2a0lnTDBHVVhVUVQ5NlYvQzNp?=
 =?utf-8?B?bHcxTHdkV1hQeStMYXBPS3RwcHhsNDBxSVVOcXRQSlFDUTB1QUZCa1lTbHUx?=
 =?utf-8?B?dGxSeXdjenk1bEdJZXVJa3h1clJKcWhYUUs2KzlSeldDV2o1TFdGR3ZIaHRP?=
 =?utf-8?Q?4QctnJQj4/JRx1KxZKVa9PiMG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAFAFFF37FF0CA4DB659C821BD42967D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d34061-bb57-4897-72e8-08ddbeee235c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2025 13:40:16.0666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEEHTxChWeOrsMTyOG78MRcxqbH6GboHmTQgH1zU+2dwrxHbTvnlR7jqAUTZxpYmZ+Wq3JnVQ/VCNYAix8v0XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8898

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDA3OjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KDQoNCj4gW3NuaXBwZWQgbmVzdGVkIHBhZ2Ugd2FsayBvdmVydmlld10NCg0KVGhhbmtz
IGEgbG90IGZvciB0aGlzIQ0KDQo+IA0KPiBTaWRlIHRvcGljLCBzb21lb25lIHNob3VsZCBjaGVj
ayB3aXRoIHRoZSBBTUQgYXJjaGl0ZWN0cyBhcyB0bw0KPiB3aGV0aGVyIG9yIG5vdA0KPiBHTUVU
IGRlcGVuZHMgb24gRUZFUi5OWEU9MS7CoCBUaGUgQVBNIHNheXMgdGhhdCBhbGwgTlBUIG1hcHBp
bmdzIGFyZQ0KPiBleGVjdXRhYmxlDQo+IGlmIEVGRVIuTlhFPTAgaW4gdGhlIGhvc3QgKHdoZXJl
IHRoZSAiaG9zdCIgaXMgTDEgd2hlbiBkZWFsaW5nIHdpdGgNCj4gbmVzdGVkIE5QVCkuDQo+IFRv
IG1lLCB0aGF0IGltcGxpZXMgR01FVCBpcyBlZmZlY3RpdmVseSBpZ25vcmVkIGlmIEVGRVIuTlhF
PTAuDQo+IA0KPiDCoCBTaW1pbGFybHksIGlmIHRoZSBFRkVSLk5YRSBiaXQgaXMgY2xlYXJlZCBm
b3IgdGhlIGhvc3QsIGFsbCBuZXN0ZWQNCj4gcGFnZSB0YWJsZQ0KPiDCoCBtYXBwaW5ncyBhcmUg
ZXhlY3V0YWJsZSBhdCB0aGUgdW5kZXJseWluZyBuZXN0ZWQgbGV2ZWwuDQoNClRoZSAiZWZmZWN0
aXZlIE5YIiBjb21wdXRhdGlvbiBpbmNsdWRlcyBFRkVSLk5YRS4gIElmIHRoYXQncyAwLCBHTUVU
IGlzDQpzdGlsbCBhY3RpdmUgYW5kIGRlcGVuZHMgb24gdGhlIFUvUyBiaXQgaWYgZW5hYmxlZCwg
YXMgbWVudGlvbmVkIGluIHRoZQ0KQVBNLg0KDQpDaGVlcnMsDQoNCgkJQW1pdA0K

