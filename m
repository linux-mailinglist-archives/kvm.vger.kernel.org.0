Return-Path: <kvm+bounces-46465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99162AB6528
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5E58863DCB
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3788216386;
	Wed, 14 May 2025 08:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pe8i06u5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84D19924E;
	Wed, 14 May 2025 08:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209823; cv=fail; b=ovqJKMOezSqTL1QMISHFP0+54/jF99vbOcYYOT72jMfAzxjUHhq6pQLrlPmkQkk2pR/I5I5Y/3Z5EQSj8zGYw6NibrEuxsn8T8rUfCgYMWSOPIsqTJDQ+jQHfvMArhbB/JS8OlPxRVPHGDlJRfu0gYotzY6yPO99EcF/PfNntuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209823; c=relaxed/simple;
	bh=YcQnV5ELL1e8uB+ounFDWYMlHDCjOpTuzwZ7pMTRsPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B4PAdHfdUVuD4kt82qwcOIYolGPXVikaTz3EY+YL+f7RLniXmVZfhj2iHVXItxr3gIzIj2etbYsC4ch0BriuMimYXYdFqD7M6ZttgY8+Zqh2uX1205/9JGkeW4QTCVyeEAsExQWur02kX5ktoVba8Y7ExOSItbAaUIlybgt8A5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pe8i06u5; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oExgTda1vHCV//0kd0gtg4FPVoe7OS+rhb2F+j9HlPgEQKjFCApXzdydUwetAXKi5BqJFEGQKxoiYQnJw2ULFuJkaPNBLVWKUg9qjd5ioXC+huhCoWKvelRzPjOOkT7Wkk39mygfTznqOaxppmcqsfmBXSmIIq3e8ifVGSxT3d7M32FOm7nfyeQf4zt61k6wkPNwHg6Jv5RMY0B2XJ2Q+EmrJE+O9Ufsilr6KoaZmRL05M0LIJ+ksZHy2e6pHS9BmJYVyo3VouN5TxE0lhRvmLCbu5sgVlfGWeJ4+/i90EEXQJ9up2xoFfSENjCQrq1ZsrlTnqQLgvfmE1lYxq7chQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLY74wctcg+6OFOaTK2bP33oIIqZsDvcmqCKsI+BKMg=;
 b=V6nLyasx+iC0cabzoYYCKTukvD+ULrnSfYrpSNbH3GMdZEwLm8F6ih6W1jYtDZRq33bza6bSn8fZbR90HQrKv8UyQqOUjEQ/fLUP1ciumcUkjBbxpIkoJsJ6M9EiBSOG4lNr3JTIsVK3yMJT8HbVaqEyUx4EFbz+WYdClzzxJQzzw9oxCgdv/xXDCpYbyM8QLkiel9Zy7U0iqcGjNYr1KuWfc7LiSewKuC8JNxyDxlVJnMt9eZmJdjoWmAhkTLED4CEwaETPcYp1RUTvkZYG6EyLYD/DRmYV4V9bslzqk3qAYbpXOcNh2u5joxH7LYsE3FcdI4qrrDKdUVodt7+Etg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLY74wctcg+6OFOaTK2bP33oIIqZsDvcmqCKsI+BKMg=;
 b=pe8i06u5SCgF7AX9gJ9aBNyFbmBTUVRVWANJXjZn0m+eW3nzAhEzq5fjkdyvJHTml47lu+X7QEr105bCcQ/piTXMEacqm5eu2RBryNqe+PL+kFGSJnbjCQYSm2Bm6sr0kSw5RISbAugroTPK5pdWr/e2KyLVES78AD3QSIt80Gc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by MN0PR12MB6294.namprd12.prod.outlook.com (2603:10b6:208:3c1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 08:03:38 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 08:03:37 +0000
Message-ID: <ca08a552-5d9d-4839-9d3e-0d3c73959cf8@amd.com>
Date: Wed, 14 May 2025 13:33:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-8-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250513163438.3942405-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::35) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|MN0PR12MB6294:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f377e3-a9e2-4e56-1fa4-08dd92bdd4ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzhGZ1JiNGpGNHlXenorcG5OcEw0MUlWd1hqMzZtOUtjZURRcUVibFJZeElD?=
 =?utf-8?B?YkdUMGdyVTNPbnA5bUtSYW93NmU2eENxWHQzdjIvUXN5Y3lqVUp4Yk4vWEhu?=
 =?utf-8?B?ZktzMk1BVGJnQ2pGRnRMdHBmelJHUXZ0NWgvL1VvWlFnL1o2MEhwTmczUThz?=
 =?utf-8?B?dS9kWHg1UVRidGtBZFNIWUZHQVRtYVR5aXJ4TlJXSnZLVEhRbmp4MXR0c0Qy?=
 =?utf-8?B?aW5tNDhYN2VmcXJZcUtFZ3A0bGpXTmtmeWh1YVJIK1JBVjY1YmxLd2tZMGlH?=
 =?utf-8?B?WHlkK3N3eVNsOGp4aytKcHArSERyUFlqWHFTTDVmVVlaZUljWWw4UWRJaTdD?=
 =?utf-8?B?OTZlcW1hZXdCSFVkWWEwc1hTcU5WUG1GTUU5ZWhFMTF3blcxZWlqRTNjdVBI?=
 =?utf-8?B?Z1p4N0NNZzVZUlJ0SklidXNNRlU1OWhlbkVXSENoNWhSR0pFcllqM2lKamRv?=
 =?utf-8?B?RXVySk9hR2JPNStnR0NRdHg0T2FjRU9DK3lCbTM4M2ZUUU9Na3lQOXUyL2pL?=
 =?utf-8?B?VzhJemVHa3RSUDFYajJBVFNjRlMwYVZ3N2RmbDV4bW5zZHdxMmNWbG01UXY1?=
 =?utf-8?B?SFRxRVVuTEg4RHdjb3VZcFpDMFc0enpKV3pGMVp0UllUTEFvYTRKazFwY0Fw?=
 =?utf-8?B?YmdZVjRzUkR5MTRxR0I2SVYrT0ZlbkpwNTZlL1N6QkM2Y2NUWmVib0w2aGtr?=
 =?utf-8?B?Z281VENsc0I1c1dqY25WSVpUL0Z2bjdtcDBocHZDVVRhN2h5UkpVQStQUVBv?=
 =?utf-8?B?OUNZNnJXeFF2bUQwMkdYZnBxMGx5UktPRXhiQXkxYWNIekU0aGovb0lHSStJ?=
 =?utf-8?B?bWl5VGZDS2JzRFhvUnFjdGZ0VkdUenJhNDBLaWpOdVdaRVRaMFVkMmdMZWtV?=
 =?utf-8?B?MjNKUW82cWZkb3hiWUVlUXF3MXRBaXVyTTJCdXdjVFNyQ3VWSFAzOHp0TjFS?=
 =?utf-8?B?UlFwcmdOTUNpaENYY3NKS3J1TWdST0ttYW5DeHl3MjYrTVE2QmliQTZRTm1h?=
 =?utf-8?B?Q0VyeGdNTm52SFoyd3J6YkN1WWh6V0pFdGc3RURyU2ZIYlVnU0lzRmlHMnlD?=
 =?utf-8?B?UXNyS2c2MXRGbzI1UCs1SEM1d1lqNDFOQnNHK3ZQU2J2WW9yS0I0Rng4QkZr?=
 =?utf-8?B?OU43ZXBXbEZmUE9Zc25tUCtweTBiYXlObXdyb3hkaUFYWkFoMi84SWxRbnNs?=
 =?utf-8?B?bDlveHhWTHNwSHVEVTM2VGc4eWc2K0RkOVRVc0JPcDd3K0FzQU5IT2dRQmVY?=
 =?utf-8?B?d3F0dnpLZVNhY1hlR3VsY2g0amxteGFkOHVCK2VGcGdFUW5HTkpBU3ZXWXZ3?=
 =?utf-8?B?d0VKSWh5NHQ4dEgrZGxWYzFJSDFtY0RZZnR3VTdKN0x2QlFqUzA1YTJCTi9R?=
 =?utf-8?B?ZTlRR0V0WURsRzg1aUtEUjR6alY0WVFFb0IyVDJiNnVDWkZpcDZ1OW5nSmo4?=
 =?utf-8?B?aWc3RzNJT211elA0UHlBcUZ3dnIrTVU5ZytSb2lsWmdNelJPclBHTnk3dCty?=
 =?utf-8?B?S1Z4c2JLSXlEZ0lhd0Qrb3J2WWwzeEdHc3JJK2V5U2FVM1lpZ1hSZUI4UzdE?=
 =?utf-8?B?Yk0yNlpyQ0VEdk1SeHI4bTh5SUhsRmdhcnlzV1pUb2dBYTEwYUEvU3Bzcmpv?=
 =?utf-8?B?ZXMrejdKRjhYakdaSlhnN2hwNmprOUkwZjdPRjFtbFZ2UTlnM20xaVNtSUtJ?=
 =?utf-8?B?WWF6U0YxckNzbUZrNm1TSUZwaXowQ0N5OW5NRXVCS0VTNXZNKzFLazZ0dlE0?=
 =?utf-8?B?SXJyV09SV21WMnVPYTlGdlpEaXY4amVJUEwwcEd3RkFtSHBWd1VhZzlxS0Uy?=
 =?utf-8?B?eTlVc051VkFTaVhvZEdoWC9zSjhrVG9JZ2N2T1k1SUNJRHQ1cGtIakJ4Qmox?=
 =?utf-8?B?ZFJhMHREU0lVNEZBejdodWJZL2hzTXkwQW52Qnl0ZGhUeGYyZ1Z0MTFjNCtj?=
 =?utf-8?Q?AJ/qkjEdD7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG1ENTVXOWJkYytzMUs5d2hrODFWRE41UjIyZlloM0w2UzhFSWJWV3puTys5?=
 =?utf-8?B?Um9yY1htQlZ1Z0xScnpkZFh4QTd1YmV1OGdMTVlHQUNNWFJwN1hZMTBWL1Zk?=
 =?utf-8?B?M0U4N3hrbWF6eEt0TlhiOXM2dGhKby90TktPR2gxUnNqS0dGWEJ0YWxOeHpE?=
 =?utf-8?B?M3FVY1VmRXQ4UWlOMnptZXRrNU1rbitpOGlQRVc3WERSTTZkV3F6aHRTSjVw?=
 =?utf-8?B?bWdrbm4xdDFDYnFIMEZJejEzS0lKaGt6ZHByV3AvV1Rhc05KRENXTXhjNCtr?=
 =?utf-8?B?S1dSLzVBcTFNNldvUjcxaVR3dlU5ZUNNZWdxQitCdHphQi8zN0xuM2ZYeWhT?=
 =?utf-8?B?UWhpWk5GRWdZM2cwSUgreEJtekZZWWVGM3ZaM2t5c2gyNXFwbFlpYTU1MEY2?=
 =?utf-8?B?cnlPeWttL3Qwc25ndXE4TVpGU203Qml4Tkg0eFpNVmRSanBJVVB2UDZxQnBU?=
 =?utf-8?B?cHRvbzkySTM5blJVYlBCMXV5ck9pcnZ3emJyMWJRNSt1TUpLR281Wnh6dUl3?=
 =?utf-8?B?VU9ZTVNSMXBoUUo3OGpIR09zaHZUcER1aVRTZmd3YzZKRFZmTEM3STNNWUNJ?=
 =?utf-8?B?NzlkTlR0WWprMGxabHpjL29sNUlWYTd1VE9CYm82S20wWndKSDdYcEc5QXZh?=
 =?utf-8?B?QURsUGpNYWJGekVqMnRrc1F2Y1ZlK3ZjblorUktwMW9FanNKaGVJZlJlUHli?=
 =?utf-8?B?em1CZmE3a0FUcDl5MFNBWk5ERmMvMkNyaTQwd0NxbzZsQzR2Wm9qS0lzMS9J?=
 =?utf-8?B?ZnRhamI5T3N1MmFFRDVBQTZhaEhwWEQwUDhxUVFzR1U4eWlGSnZiUjJCQXRR?=
 =?utf-8?B?cjY1U3k4N3drZW9oYkFnL3JtN0YybFJaWkxXZEU2dW1uNnZFNWg3bkk1OEJp?=
 =?utf-8?B?MkkxTklZOWVjekNmcVhxU1Y5b3pRUWV3TGk5L3RrUFRZVWRyWXN5eXNHVWp5?=
 =?utf-8?B?UXR5VVpwajJ6YXRNU3RWZGR4RFZ4eVNya29pMnl2R1VJTlRWZmdGWUJOR3d0?=
 =?utf-8?B?ZjZOT2RwU09rRHJ0Wkl5cVVZaEgxWENnM3RJNUd2b0c2djFTWUs2ZncyWXVP?=
 =?utf-8?B?MHl2dkFFeDVzVStFdEJHdXJud3ZOUzlUQWVkaVVPR25tY2t0TWUrOVVMbnBW?=
 =?utf-8?B?WTc2bTZ1TUFXMklXRzVOa0V4NzF6TlpFam1BVjlCeTZUNEREdnhQZUo2azEy?=
 =?utf-8?B?QVlqVlJ2MWxnclJDRTBGQ2x0QWxCSkFhWkpUTmlHU05hYzRram9WSlJ6UjRa?=
 =?utf-8?B?Y2c3amxncUxtUlFyeVRwNTVObWN5OEFwYXF0U09KOXNEdHZJVFpCM0V3UEtD?=
 =?utf-8?B?L0hLYlNCcFErS0xITGY1aktyci93TUNjbU1mRkVUcjlzamhONitYTkhHZmVl?=
 =?utf-8?B?Z3RSeUtCaVdMYjZkcHRna1Q5bG9tL0NUajFMMHpJOTNhMXo0K0oxYjZWS2Ra?=
 =?utf-8?B?WTI3ejRCTjRmZ29McWpYdWR5QUJaU2RKYjFLK29jUStZaER4cXBaY1h3eTJP?=
 =?utf-8?B?QzFDYm5JcnYwZm1LQlliTXEwTUhNd0ZkeVNJSThPV1RSNU9peXF3WU1tMExZ?=
 =?utf-8?B?dHd1NWVLRnRhWGpSWHlYWEJGSW4waXgrVnV1T3FKekkvLy9Vd0hXNHRzZ21w?=
 =?utf-8?B?SlZzUGNxb0lLUzV6NVU4R0ZtMmNwRFE2eE5xUzJkT1ViR0RhRTdxQjFmNTJD?=
 =?utf-8?B?YXNZTDM2dmxoRzRMbFBSQ3FRYTcvSmdWSDNRWFhFWWJDcHl6Wlk4aVltVTNK?=
 =?utf-8?B?V0FTRW15VkdJcUtMYm0wMnY2UkFYSklEb3d6aDVHMlhGZlVHS2Y4NjZPbmlh?=
 =?utf-8?B?Z05LTi9yQmhGOURhWE5ENjZicFlMWUZtMVlMbzdhb1hyZG5oUkpmZDRtYlg3?=
 =?utf-8?B?VGFKS0hIeUJYOXhNdlNnRHZXNjJhaW9mQytjV1hjMFp2bDhDR2tFbmJHZCtZ?=
 =?utf-8?B?djZ4Q0laUFlNdHBHVmNFaXdLeitoZUlKZDNOWkNSRXp3TnJmeERKcCs5eEJO?=
 =?utf-8?B?cXU3T2dNUXNQSkVNaCs0K2pFL0dLdkV6aFZWOE5iM3JlQlJ6ZXh0bW9IUERG?=
 =?utf-8?B?TjRhU2phTG8rRDFPSGplSXlrekpBQUxZejNrMUlhc1pqU1ljY3V4K1hGRVkx?=
 =?utf-8?Q?18hm6PONaOct+aNFVTqFMJlsW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f377e3-a9e2-4e56-1fa4-08dd92bdd4ec
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 08:03:37.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LKVM9mswG5blFFqPGnxvDJAMoKF46N8c3WCn5fWvzkVKu4QLNjBWpr3YthuSbcJpVQonM2kw8Ltiw3rU08q3zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6294

On 5/13/2025 10:04 PM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ++++
>  include/linux/kvm_host.h        | 13 +++++
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/Kconfig                |  5 ++
>  virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
>  5 files changed, 117 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 709cc2a7ba66..f72722949cae 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)			\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
> +	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
> +	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
>  #endif
>  
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae70e4e19700..2ec89c214978 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..9857022a0f0c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1UL << 0)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..f4e469a62a60 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> +       prompt "Enables in-place shared memory for guest_memfd"

Hi,

I noticed following warnings with checkpatch.pl:

WARNING: Argument 'kvm' is not used in function-like macro
#42: FILE: arch/x86/include/asm/kvm_host.h:2269:
+#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false

WARNING: please write a help paragraph that fully describes the config symbol with at least 4 lines
#91: FILE: virt/kvm/Kconfig:132:
+config KVM_GMEM_SHARED_MEM
+       select KVM_GMEM
+       bool
+       prompt "Enables in-place shared memory for guest_memfd"

0003-KVM-Rename-kvm_arch_has_private_mem-to-kvm_arch_supp.patch
-----------------------------------------------------------------------------
WARNING: Argument 'kvm' is not used in function-like macro
#35: FILE: arch/x86/include/asm/kvm_host.h:2259:
+#define kvm_arch_supports_gmem(kvm) false

total: 0 errors, 1 warnings, 91 lines checked

Please let me know if these are ignored intentionally - if so, sorry for the noise.

Best Regards,
Shivank


> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..8e6d1866b55e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	uint64_t flags = (uint64_t)inode->i_private;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			ret = VM_FAULT_RETRY;
> +		else
> +			ret = vmf_error(err);
> +
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +out_filemap:
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_shared(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	u64 flags = args->flags;
>  	u64 valid_flags = 0;
>  
> +	if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	    offset + size > i_size_read(inode))
>  		goto err;
>  
> +	if (kvm_gmem_supports_shared(inode) &&
> +	    !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +		goto err;
> +
>  	filemap_invalidate_lock(inode->i_mapping);
>  
>  	start = offset >> PAGE_SHIFT;


