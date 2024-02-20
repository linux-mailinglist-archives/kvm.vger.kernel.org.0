Return-Path: <kvm+bounces-9137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2091985B510
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 453191C21330
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CEB5C5F9;
	Tue, 20 Feb 2024 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jwRNNqFa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87715C8E9;
	Tue, 20 Feb 2024 08:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417606; cv=fail; b=s40o9aLQNjxouiL4rRxfpucH9VIO7GEhRyzqM3tEPQoX/IdNLxaHea0lHjCu1f67asCfkTt9OwzEecPEAjnjTa6YhHDsM8s4kKG2ZW8/wgati5CC9utw0K1OFVoBmRdnkF7za9WV8xXTgLo3Pvunu7BC4Yj3JDJxolhyrVS2Lmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417606; c=relaxed/simple;
	bh=HEryPttJ6NkK5gzU6c2JNQ6F6PEYH/fo8m06qyAKsJE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KCQrkc0eHBV/m5uSGbkwjRw++JHJAFIzV24WQ4zSRXBRIjjakVm0lqHXm+Fs/S+50PJ10ZYw6QG+3Ds0WBLRiLNTVjXkfRVbRIrEardZCcXG8304yA8gIKnlD5V3lm6WKOIdokz/uJxFJt49GphKbYlsh2aw9315TofNeDO94Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jwRNNqFa; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieLT3mQ5nue0xJ+cKHJtUh/IVE0wunNGAcpKB49YzehqI+fyU0vzraxi6mq+zQGCDcvfXfAz2m3SV80kCy2hhMuqfMfGnRnyCheUtrmLlzs/8HBlwr6t5IlVzCdHX8YSo1o1TbPj55quGFJTeUGyh5NqBmijqId/dwmbnWuNV99AZgNHVImI7ngLy0tevl7rVCsUu3++GnoEn0BF9M8seggk2dOfaa5KxxozKicA66x13mP1mxMgmqGPq/6sllEstg9fTiUnFqx/xZPwVioQ4U0K7tN9I4NhWRqftlBbb40PTADFjpp5Vjbl1d3ltzUFVJahaz7Kzdh8/B15Jt2dUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEryPttJ6NkK5gzU6c2JNQ6F6PEYH/fo8m06qyAKsJE=;
 b=I8qdCQ4uQcHENKNCPRsGS+5jsEQY3d2thnNA6TZ76ubz8/6P//o7+psnvt9hlSEtJ8hPKNUMUXMF/Nih9xBZIr+UV5KSLtavW2cvPtvFcBlQiq+6BM1hfDNu0HJ+5j2N5TTMmhJKEvbjHs3g7Z0tO3Ngp/qz7DCIh74zO+55o3sR7MDKTjsApr/n3ybZcZ2LMaMzehne1Kh9iAarTWpTPQP4GFM6+93Ej9W78DXLiNtmCsYUVtnRpAUfomXaD56EzxI/ExZAz2ViNTLEIiX1EIhUmeqvjlu8owJrhxa9lu6ig4koOg36OemRSF/LFYUAmeLYr6mSwEYN06Kl2UYaDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEryPttJ6NkK5gzU6c2JNQ6F6PEYH/fo8m06qyAKsJE=;
 b=jwRNNqFaLu6gKy8kNTnFvf3IVA5ClqU0EC5KiswIYmCO2o6uL1delZP+rkv0yqxi7sgZRKfZ5zPvgTIZujcZl2+g1ElBogWxFq97GyKDJVWZ1NIPZyMWVlhUuTs8WFPizw7gfgULO9F/YUO+ncJcfudzMcIZ6t7n3T59tM4E2d8gOkldKrBhMwU6HgdVLTxOV7fDPTLY8G8LQ7pYtNHvx/x3/LR8Wiwj1AFhaSruOVZpZyjfcWRZr94yhiKZFK/PLNLV8CGIkAk+kYAHPWc6oQfvub15mGgBtbs4FL8f4mLxzYO4rpJw8xuDzP8q2Loj54VzLYJHT9E6kJlYiEffgg==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Tue, 20 Feb
 2024 08:26:39 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89%4]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 08:26:39 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaY86q3o4vxPMh/EWney6fGMJmL7ES5W4A
Date: Tue, 20 Feb 2024 08:26:39 +0000
Message-ID: <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
In-Reply-To: <20240220072926.6466-3-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|SN7PR12MB7786:EE_
x-ms-office365-filtering-correlation-id: 975c1810-8e42-436a-d2a0-08dc31eda919
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 mV4sGb/0fFAmLyn2IjGaf2UyC+4O60CaIqbjiWXBwXWpwG4Kc29q9s/RQfga9pfIiEPlNDW6MGCSoSVFORN1bxoOuNt7Zh6vZkU3ySUBw1KplDqYityRYhBhuSgow0Fbx6WpRYq5kXMbUhc1EnOAiaAqDzA+lANUx1xUCLNgOefYs6m3WBvvcdrzNkj9mbvBwY/x0rGogZY5MGMzD45mieqduuolJy/4+Pw+AkmjqY2Nti+xHSHxkrTW8HxaYnP+MdJUoo33GIj0gHRzJs/jahTyDigokyMgKzr91QHSiAqh+PzRQk7uPG9iXw8p1ZLu3fnSNrFZ6yvQcluO8UlGqeDCeFI1dmb7JDo+JYDqRahyjWz8ZnB4rcafkCOHNynvIgmhHmMpWTxBScKqe6Ztmjd1zjofx3AB+pHmGwNR+Sy8xriBEmx4CVOVbtZAfWktYHpCPcNZvDX6khzSxuNEdF7ATKHKLrDI5abZPrzJ3Co89EYpIT01fM5C+480b4o0ajaG3TJTU8QkW9Ju+7Fbdt4M92RONbSmCIwz5OKWNy0Nx8AUWbMKjEq3qwg0O39wiopL7GyDWk5I75s6fGG4bQSvWlknbp5Ad9m7bMNFdwZahQL9/wbxA5RA1vGpgXsn/WZB7WI3/KsFbF1clK7VxA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K0ZZZ0w3NTBjMHJGWUhDV0NNM2plaEFyb3lrazhCbTJ1NVFaSG1IMEd0MXdX?=
 =?utf-8?B?ZW5xU1F0RExMRU1Dand1WDVCNnpMSmNPdGxyeDMxZXJNY2Y2aHFOQ29MazdI?=
 =?utf-8?B?b1JVQVNJVUFtYi82WDcvSFlKblFSMmtlcmh1Mzh4Rm5NS0o3NERLU2UxVDF6?=
 =?utf-8?B?M0NmcFZ6M2dMV3dnYmUwTVRPbDNUbjVLbm4yV0VXR3pmSUwrM202OUNqSVRv?=
 =?utf-8?B?amhoU2pvRmdkRk1MKzc1Q1pON0ZRc1R5aEdRVEl3OHNYWE81ZzZ4N2ZHU1Z2?=
 =?utf-8?B?RHVxeDdweStNdWFkdmFzclNhb2J3d3RtL2RLTHNIcGtOVlZQTHFSRThORlhF?=
 =?utf-8?B?SEFIK0xTNUVTWEEzR2JoS3VCZjV4TWtBdXhHTUdOeGFwMi9RTUxUU2VEQWpj?=
 =?utf-8?B?QXQ4bTJwSWRyeHB4L1NweXdMY01TYld5OTRaZDBmdFY3QkNBWGwvQ0VCMDM3?=
 =?utf-8?B?SmhJTXdzUTByMEpYU3A5K2o3MlVoUUJtNG84Y2VEaHRkeUYyVlB6RGFBenR0?=
 =?utf-8?B?ZEVqRnFnd1FkNmpOQjJiSWx5RVAxUHdMYkgyVTQwc1FQY3dLTmRVa1JxQ3Fx?=
 =?utf-8?B?eWpNdXBaNFkxdTVUdnhvUUk0RzVtUVdsWnNVcFZpUjJZOXY4UlY2VmRFbnlp?=
 =?utf-8?B?WmlmemNDZFZidzlGU2pnSkdrY2theE9aakJ0ZVBtRWpOODBiUFJIczNROHFH?=
 =?utf-8?B?S2tScnROWEFXNHRpUDRqZ3N5Q0RkVENMWXJEaDVDNFFtQ2hjM1ZLT2ZqT1hw?=
 =?utf-8?B?U0l0SFAreWp0aTFnQU9yNWVtSSszQytKbmdaYUpVd2l0NldHU0xtcTM1ZStE?=
 =?utf-8?B?SVNOYmRJVmMwS2FCZGVhYklBVjN2ZmdhWG4xTVNCOUNRbkw4RXpKQ3Jwallq?=
 =?utf-8?B?eTVPSEVQbnM4dEhBWlExVzBWc05Vem5xVnpqcEx2T0tvY2xHVm9EdVRQSmVo?=
 =?utf-8?B?TGdHUkROMzZkUWR4ZUR1RXRMckxiUWZ5VWxoNXdJWHdMcnlobUlVenBnMHBp?=
 =?utf-8?B?NHJxTEs0YitJaWJrbHF5T3AzUXp2dmVHeTRndHBRVHA0bm1qZHRnVjZkNHhE?=
 =?utf-8?B?RWNWelIwcHJCV2JwRnA5NU9ZQ1ZjWHpFL1ZZT0djV2JDa2E1aUg2K3R2aERB?=
 =?utf-8?B?UVJyR1ErZFZnc1Q1eE44ZzY0NWZJSW1wZGV2T3RCU3JvZHlCWlFsczFucmN5?=
 =?utf-8?B?ZFJDOElINEJzenZBR1JGUUk1RWoyRU9LbnpDU0N0bkV6bDBFTnRMMHEwYldo?=
 =?utf-8?B?bE1sNmlhWVdnd1lhRStJUmxSVDM4OEQ0Wk9HWG4xUUFqcFdpUzlBK3JsUktD?=
 =?utf-8?B?OTVXc25ESDdvVVIzYjAramxTM0NUTWFiZXhNaWtTWE1jSmlyc1FjRitock1L?=
 =?utf-8?B?Z0Z5aFdkYm5hSHZCViszRUpwenlBcGV3ZzlwbStiYUdEdWg4RWI1M3VkZ2NY?=
 =?utf-8?B?OXFaRTlkTmhTVGFUOVFPNFgvY0ZqeVB6Z09pUkU5NkJkaWc5ZkNkdXVHMzFn?=
 =?utf-8?B?RDEwKytDUkkzWGhOTnZINm5UWWlGZW5VQXJycXdObkVXaS9pZHQ1YngxaitH?=
 =?utf-8?B?MjZPeXg2NWlHcmdUK2tjajFlbWlPSVZ6TjVXK2V3VWgrRDNDeEhodU5wN2dN?=
 =?utf-8?B?SVduL3FVeXVVcnE1VEx1SXA5MFR6YjVWTTV5VWFSV3k5aEIxLzR1dWdrRnlB?=
 =?utf-8?B?a2xnTGpya2d2QTB4RjJzbXRWZ242MDhNQ2loK3FGUUFTd1NzSjBhanZjbVRs?=
 =?utf-8?B?M21KSnMrdkJMQmhzdVFmVFR4LzRkMms5bTlTV2NuNG1yWGo5V2NIdUhKQmJl?=
 =?utf-8?B?OUNyanBoYVVacGpiMEdUanA1TjhMdEN2a2xMY1FrSUp4cFF5T3FvRXBIeWlE?=
 =?utf-8?B?Y3dRcHZWRnVKbjZFOWtIT3ZBdHU0bDZoSTVuZDJoYnRUb0dZSE5lanc5Vld3?=
 =?utf-8?B?elhaN3NpcnFzNDFRWmQxOVBSdHRUd0NpYWpZbnpVZ1AyTmFiOWFaSzQ1akhP?=
 =?utf-8?B?Yi9mZWtKRlVaWEhhd1ZEWGxlY0FlYWlMSEd1dGxrT0Y0a0FacVZIOU1IWjdL?=
 =?utf-8?B?TjRDUXFmWXp6ZGcyTUN1VHNpMjFyeEdHbjhBOVdhVklmRjhSNWdCWnVDZUdw?=
 =?utf-8?Q?RJwM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35C6E47F78DE5D4BB6337DCE28D2A318@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975c1810-8e42-436a-d2a0-08dc31eda919
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 08:26:39.3187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: olilM5GN9Piaw9bqCRV5tlVL6EbdoxXTsWB2WM9C+7VW+R0nIlqFTh+qW7gBEz0g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786

T24gMi8yMC8yNCAwNzoyOSwgQW5raXQgQWdyYXdhbCB3cm90ZToNCj4gRnJvbTogQW5raXQgQWdy
YXdhbCA8YW5raXRhQG52aWRpYS5jb20+DQo+IA0KPiBUaGUgVk1fQUxMT1dfQU5ZX1VOQ0FDSEVE
IGZsYWcgaXMgaW1wbGVtZW50ZWQgZm9yIEFSTTY0LCBhbGxvd2luZyBLVk0NCj4gc3RhZ2UgMiBk
ZXZpY2UgbWFwcGluZyBhdHRyaWJ1dGVzIHRvIHVzZSBOb3JtYWxOQyByYXRoZXIgdGhhbg0KPiBE
RVZJQ0VfbkduUkUsIHdoaWNoIGFsbG93cyBndWVzdCBtYXBwaW5ncyBzdXBwb3J0aW5nIGNvbWJp
bmluZw0KPiBhdHRyaWJ1dGVzIChXQykuIEFSTSBkb2VzIG5vdCBhcmNoaXRlY3R1cmFsbHkgZ3Vh
cmFudGVlIHRoaXMgaXMgc2FmZSwNCj4gYW5kIGluZGVlZCBzb21lIE1NSU8gcmVnaW9ucyBsaWtl
IHRoZSBHSUN2MiBWQ1BVIGludGVyZmFjZSBjYW4gdHJpZ2dlcg0KPiB1bmNvbnRhaW5lZCBmYXVs
dHMgaWYgTm9ybWFsTkMgaXMgdXNlZC4NCj4gDQo+IEV2ZW4gd29yc2Ugd2UgZXhwZWN0IHRoZXJl
IGFyZSBwbGF0Zm9ybXMgd2hlcmUgZXZlbiBERVZJQ0VfbkduUkUgY2FuDQo+IGFsbG93IHVuY29u
dGFpbmVkIGZhdWx0cyBpbiBjb3JuZXIgY2FzZXMuIFVuZm9ydHVuYXRlbHkgZXhpc3RpbmcgQVJN
IElQDQo+IHJlcXVpcmVzIHBsYXRmb3JtIGludGVncmF0aW9uIHRvIHRha2UgcmVzcG9uc2liaWxp
dHkgdG8gcHJldmVudCB0aGlzLg0KPiANCj4gVG8gc2FmZWx5IHVzZSBWRklPIGluIEtWTSB0aGUg
cGxhdGZvcm0gbXVzdCBndWFyYW50ZWUgZnVsbCBzYWZldHkgaW4gdGhlDQo+IGd1ZXN0IHdoZXJl
IG5vIGFjdGlvbiB0YWtlbiBhZ2FpbnN0IGEgTU1JTyBtYXBwaW5nIGNhbiB0cmlnZ2VyIGFuDQo+
IHVuY29udGFpbmVkIGZhaWx1cmUuIFdlIGJlbGl2ZSB0aGF0IG1vc3QgVkZJTyBQQ0kgcGxhdGZv
cm1zIHN1cHBvcnQgdGhpcw0KDQpBIG5pdCwgbGV0J3MgdXNlIHBhc3NpdmUgdm9pY2UgaW4gdGhl
IHBhdGNoIGNvbW1lbnQuIEFsc28gYmVsaXZlIGlzIG1vc3RseQ0KYSB0eXBvLg0KDQo+IGZvciBi
b3RoIG1hcHBpbmcgdHlwZXMsIGF0IGxlYXN0IGluIGNvbW1vbiBmbG93cywgYmFzZWQgb24gc29t
ZQ0KPiBleHBlY3RhdGlvbnMgb2YgaG93IFBDSSBJUCBpcyBpbnRlZ3JhdGVkLiBUaGlzIGNhbiBi
ZSBlbmFibGVkIG1vcmUgYnJvYWRseSwNCj4gZm9yIGluc3RhbmNlIGludG8gdmZpby1wbGF0Zm9y
bSBkcml2ZXJzLCBidXQgb25seSBhZnRlciB0aGUgcGxhdGZvcm0NCj4gdmVuZG9yIGNvbXBsZXRl
cyBhdWRpdGluZyBmb3Igc2FmZXR5Lg0KPiANCj4gVGhlIFZNQSBmbGFnIFZNX0FMTE9XX0FOWV9V
TkNBQ0hFRCB3YXMgZm91bmQgdG8gYmUgdGhlIHNpbXBsZXN0IGFuZA0KPiBjbGVhbmVzdCB3YXkg
dG8gY29tbXVuaWNhdGUgdGhlIGluZm9ybWF0aW9uIGZyb20gVkZJTyB0byBLVk0gdGhhdA0KPiBt
YXBwaW5nIHRoZSByZWdpb24gaW4gUzIgYXMgTm9ybWFsTkMgaXMgc2FmZS4gS1ZNIGNvbnN1bWVz
IGl0IHRvDQo+IGFjdGl2YXRlIHRoZSBjb2RlIHRoYXQgZG9lcyB0aGUgUzIgbWFwcGluZyBhcyBO
b3JtYWxOQy4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1h
cmluYXNAYXJtLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRp
YS5jb20+DQo+IEFja2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogQW5raXQgQWdyYXdhbCA8YW5raXRhQG52aWRpYS5jb20+DQo+IC0t
LQ0KPiAgIGluY2x1ZGUvbGludXgvbW0uaCB8IDE0ICsrKysrKysrKysrKysrDQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L21tLmggYi9pbmNsdWRlL2xpbnV4L21tLmgNCj4gaW5kZXggZjVhOTdkZWM1MTY5Li41OTU3
NmU1NmM1OGIgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvbW0uaA0KPiArKysgYi9pbmNs
dWRlL2xpbnV4L21tLmgNCj4gQEAgLTM5MSw2ICszOTEsMjAgQEAgZXh0ZXJuIHVuc2lnbmVkIGlu
dCBrb2Jqc2l6ZShjb25zdCB2b2lkICpvYmpwKTsNCj4gICAjIGRlZmluZSBWTV9VRkZEX01JTk9S
CQlWTV9OT05FDQo+ICAgI2VuZGlmIC8qIENPTkZJR19IQVZFX0FSQ0hfVVNFUkZBVUxURkRfTUlO
T1IgKi8NCj4gICANCj4gKy8qDQo+ICsgKiBUaGlzIGZsYWcgaXMgdXNlZCB0byBjb25uZWN0IFZG
SU8gdG8gYXJjaCBzcGVjaWZpYyBLVk0gY29kZS4gSXQNCj4gKyAqIGluZGljYXRlcyB0aGF0IHRo
ZSBtZW1vcnkgdW5kZXIgdGhpcyBWTUEgaXMgc2FmZSBmb3IgdXNlIHdpdGggYW55DQo+ICsgKiBu
b24tY2FjaGFibGUgbWVtb3J5IHR5cGUgaW5zaWRlIEtWTS4gU29tZSBWRklPIGRldmljZXMsIG9u
IHNvbWUNCj4gKyAqIHBsYXRmb3JtcywgYXJlIHRob3VnaHQgdG8gYmUgdW5zYWZlIGFuZCBjYW4g
Y2F1c2UgbWFjaGluZSBjcmFzaGVzDQo+ICsgKiBpZiBLVk0gZG9lcyBub3QgbG9jayBkb3duIHRo
ZSBtZW1vcnkgdHlwZS4NCj4gKyAqLw0KPiArI2lmZGVmIENPTkZJR182NEJJVA0KPiArI2RlZmlu
ZSBWTV9BTExPV19BTllfVU5DQUNIRURfQklUCTM5DQo+ICsjZGVmaW5lIFZNX0FMTE9XX0FOWV9V
TkNBQ0hFRAkJQklUKFZNX0FMTE9XX0FOWV9VTkNBQ0hFRF9CSVQpDQo+ICsjZWxzZQ0KPiArI2Rl
ZmluZSBWTV9BTExPV19BTllfVU5DQUNIRUQJCVZNX05PTkUNCj4gKyNlbmRpZg0KPiArDQo+ICAg
LyogQml0cyBzZXQgaW4gdGhlIFZNQSB1bnRpbCB0aGUgc3RhY2sgaXMgaW4gaXRzIGZpbmFsIGxv
Y2F0aW9uICovDQo+ICAgI2RlZmluZSBWTV9TVEFDS19JTkNPTVBMRVRFX1NFVFVQIChWTV9SQU5E
X1JFQUQgfCBWTV9TRVFfUkVBRCB8IFZNX1NUQUNLX0VBUkxZKQ0KPiAgIA0KDQo=

