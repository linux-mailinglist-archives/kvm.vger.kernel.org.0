Return-Path: <kvm+bounces-59757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB85BCBAE1
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9562E4083E4
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 05:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E419D270EC1;
	Fri, 10 Oct 2025 05:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vtrYY8B6"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861851B4F08;
	Fri, 10 Oct 2025 05:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760072412; cv=fail; b=ITiFAcYyG1khIyMoBZBD9W6nsi/+0y3EAbJp6R4iPROL/XZ1/Kb1cWbBDe1fdsT8+vlXJMR+RlppvWCYFSKlWFZAhpZqJr2REbtruU3YjPYJD2ICpXLaT3pABKzXHojFArswoxhtWj5Y71/oVLuYHVpQDSvyuN/V355uXekLIJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760072412; c=relaxed/simple;
	bh=kI8+pz3lzXbk8b0xes6G47uOi5n6CvP+PmS5HSrg1HI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IU2s+7tsT6xY4GBimsMd5bQX0myAeVouiDY2fdaQtXPn7D9Yjn0X1J9ItMeJt/2j/tWGaVmMhiuQMZuuoMDAawujAIhr1um3pMgEtYjhSovskgUIIlzJXM8xfEOJyjrmB+fcV2HVmCh3fDvXpS25c34P/jeLBL+qVwLJLLZqjBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vtrYY8B6; arc=fail smtp.client-ip=52.101.193.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SoOShbbun1V7Pek2qoUFmCPTq2t4liQgEC/3xQ/GCgn7YmjGZSEMXoNeSjQSwiQVYr2cqlXmgocuGGrMOJwwPJpqulGvXAfYEZ9OxRPGKESQWSOebp/mFtOg0FXccdb+pZbgPDuOqVTMK4QnWvD6Tw+fkYVbKQKQoRwUXTlTYHo5XxHRDdqb1/NYV90zR2Pw3hlA/sMtklB9idiNx8ZQAxr7G1v1D19Ht9b4dXG4rnbZHqhcfzctEW2Ydj4pQHcbhfOMdbcqDnITN9uR5gRUVidqOOC1nTYy13HH/qgTmENe5cQFPUFkpEndTEEUoP+hMLRNrm4xjt9dVEvxoPYrkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Eg1L90pZXLhs8SnrZL2egwrCNJKgZMHf6i+C/xsqwo=;
 b=OA9kTnCE0dWzfD93Qb22F+9P0wPhTwhfBKt4hlo7QzSMmvsw6UmM4eppB/HsXLHtggOVZCiEb4qEdMz38ZTl8r6+4/rxPOMaQSShOB3oxpnOKrXaF8S5xmXvnNebRWRfbGEmMh4yhXaViR1zoe0j51ReSBB1EpzLiDjzCj0xP4DNbbs2brTKkMh5sZ9fVl8NJIcGjZkI8VmBoTplFKeBT0tZBRqRPmJPPPtbfP0uvuNq3WoS7ipod2qf1r9Qa3rwE0Q8J+ywz+MxT28JGvmpLUFEdvoj8oHT/uQGh0a6hqHm4C6Mh03DMxi7B69Rv+2kF7McEme70NY2t8ZAfHp3mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Eg1L90pZXLhs8SnrZL2egwrCNJKgZMHf6i+C/xsqwo=;
 b=vtrYY8B6GGah9KKhWNIvPki17W/bRrGtXrbWxkZPoySQT9Spdn6sGv8Ipnv7DTRphKiFV/r0euj7WPBWs7zQX+2ZsKS7E1213rjFq3nHdfsaGGPgoOa3qfw36YSqLTuNezUvys024OBfCKRX2l2PXnKH+Oj5xecRv5UtfKz+Kcc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by MW4PR12MB7467.namprd12.prod.outlook.com (2603:10b6:303:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 05:00:06 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 05:00:06 +0000
Message-ID: <46f31ad5-be3b-4945-87d1-c280f76fba76@amd.com>
Date: Fri, 10 Oct 2025 10:29:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/12] KVM: guest_memfd: Add NUMA mempolicy support
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 akpm@linux-foundation.org
References: <20251007221420.344669-1-seanjc@google.com>
 <diqz5xcniyhb.fsf@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <diqz5xcniyhb.fsf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::7) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|MW4PR12MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: 506f92d8-2eca-4b09-72c5-08de07b9e15b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmh3RTF6N21wb1Rtck1ySnlrK0JucWpRM1F4WWpNcUdoUlNIY3hRNkpqeDlI?=
 =?utf-8?B?TGdJTU5DOURGWCtDcnVvUnlpb2cyR2xyUG9abWRKWmptanhiMlFkL3ZiWmJR?=
 =?utf-8?B?ZVlUV29lYWwrUDQrTzJaYjdsKy9NYnV1UWx5UjBpYnVBTmhXMjdNMHhUTi9R?=
 =?utf-8?B?bmp4QWRpdXhMVjVPa0tOc0l1Ui8yK09IWWtVbEFYdFRya2pJUlgwRDVUSC9T?=
 =?utf-8?B?R3hBVkJLRDRUN3dxVDdiczJpd2JOZUV0dUVKMm9sb3NmN1ZSQUZzakZBMXBO?=
 =?utf-8?B?NnFkbUx1T1V0V1l0VFYvM1JvMWdFenlYa2RyNzdEWkpEWW80OG5PaldBVVZa?=
 =?utf-8?B?b3RqRGxhM1p0QkZmYlRwa25haG4yWU9PLzdRK2s0NHFxbkhWS0doWCtNTURl?=
 =?utf-8?B?NDFwbGZ4MWN3ZVZveFhUWHZaYXN5ZjduTGlhZWxZek0vMmVrYlBaaTVwYzZO?=
 =?utf-8?B?YVp0Z0ppTWNEdm9EYWFRc2NkY2N4OTkrSEVJWWRoY2ZJeWhtSkU0V0dFTGtv?=
 =?utf-8?B?SmlRaCtCQ0s5c2F5dnhJK2RDUkcvYzhEMVZ3RElyeDA5ZXlwVUd3Q3FmSnJH?=
 =?utf-8?B?bG92NFlvZW9PbXYrd2QvaTNXcUs5OVpIQ3FlLzlWMnp0aVdQMDY3WWJKOHND?=
 =?utf-8?B?anVpeEloYml1N0o3cHFtTUROejEyQTZ1SXJEaElUYmNIVCtHZTlDSTFadzcy?=
 =?utf-8?B?L0hnOGg3aERRRkt5MWtmaG1EMFFmUURjd2NreXFpeWhzMWZ6dUMzQmlQbDJL?=
 =?utf-8?B?NmcyOTI1U3Fub2NBM25zQmFwNFV6eVNISGFvTFF0Q2lXTm0vaGlQRVJMWVQz?=
 =?utf-8?B?NkFWbEdndmkyTkdUMmxpcmlqWXZVNWR2TVd5VEpUTUlGSkpnVEFySFU0SWVo?=
 =?utf-8?B?YVRnL29WcW9QaEl5Qnk3N3Ayc0pEOGZGY3pNR3FQYTRQVnBHN29FT2ZVNE5B?=
 =?utf-8?B?VTFGMXYrSkZDWGFSTS96ay9qK3ZJTTZSWFZLNVBqSnkvNG5xcEJORWN1K0lZ?=
 =?utf-8?B?WjE3UXFvOTZyY01nRzR0YkVmTzlQU1htTGhXVEtoU2V6aFFJZU1BTlpsNGlj?=
 =?utf-8?B?UVhGdUphMWlNY2ZVQnpVWHBaanF2Z3RsZnlGWWkxd3BGMm5CSEtySzgxbmJh?=
 =?utf-8?B?OCt6VEE2T0xqbkVPZmwrNXQzVXdPNlZTMmVvWHFxSE1qZXgxWk5tTHh0Q0Zm?=
 =?utf-8?B?YjJFb0x2bHV6UVFQRng3dlBwNmZGRGk0NnljZ3krMDA3dTFtOWJxditmMGtz?=
 =?utf-8?B?cDMvdjVBL1JvZm5vK2NIemJjNWdwQ0FkRWM0VStUNExNbU1HcVBqblByWnlt?=
 =?utf-8?B?OVJtblhmQ3hwQ0hDTTM4citaZ3dlTnltZld1RVZJRVBrdmNHQmRwYm84TGxZ?=
 =?utf-8?B?RUtyQ1hweDBzemJXTS9wSEFqdWNhczF5M2VGVXBBY29YbDVMeFNKc2t2QkVN?=
 =?utf-8?B?bXpXQUpOQWgxSlh1Vnp0eFRFb05UdTc4M2pYME9WMzhNYmNOMWE2S3dlNzVq?=
 =?utf-8?B?Nmt6Tjd6OTNLd3hiSHhsWER5TnNxSEdoRkVGSXNmNWUrTytHa21jTTRZc3Zo?=
 =?utf-8?B?MDZQdnhzaGxCTWo2M2UrVDJmV3VFMFNTbGV0UjR1cW1nVEx0YnppbnYyRVQ0?=
 =?utf-8?B?Qi9tRjVHQ3ltdDBuRzdkZll3aEdtZDRCQzVObGhkNTNxNysvamJSdm1Zb253?=
 =?utf-8?B?aVB5ejIrMjRsMVJRMVlOd1RrZ1RVVndDWVB4bnp0TXczN1FTTmhZUkttd1Ft?=
 =?utf-8?B?M0ZiV0ZJeE1nWndud01JZjc5QmE4bnpWZTd4cU9iRDN0VytLMWNkbm92SUtm?=
 =?utf-8?B?WWZPak9MaWxZbm51YTAvNUlwNzgrR0ZFTlQ1ZXl3M2ZpWkdkcjVpeHRBYWZT?=
 =?utf-8?B?WVJzSk9HUE1tbC9UMzV2NWdYa25BVWhHekZMblYyWmMwMEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXR6L0h1SEJEK0I3bTJFbEl6M1VqOUhlQTdRcXd4cWcrOHorRW0wK3Q0L2pV?=
 =?utf-8?B?cnI1VlgwWWEvaXQ5QzlHMGdTMzBrOW90YkhvakswTlBDOFZ3N21XRW1hZUFz?=
 =?utf-8?B?QWljN3hHUmtscjVXWFhrMjlVdGMrTUZheWtvdzN3VWdSQ1dNR29FSUNVY0ZG?=
 =?utf-8?B?aTZkSnc0Ym1Pdlo4VDFBRDhnZ1lqQ3ZTL1JWZlQ4WW5GdEhJUlhqTGgwcWJl?=
 =?utf-8?B?UXdxWHJ6M3J5UHFLbzRabmVoZkI0dDV0bGpTWC9JM2JUQ1RFUzVuaTUwYzhv?=
 =?utf-8?B?NzBISXN3OTM2bkxTbDFSVG9zamkrclBPK09aejhYVHlkZHdOM1VaZFBZWU9v?=
 =?utf-8?B?R2NwNFlhM0dqTXpZNzFWWmFJbVU0T2tyR3ZsUERNckh4dm5MZVdmeE9yaDhK?=
 =?utf-8?B?Z0U5blhMYmVmRUUyaHJ4OFhLRU94YzVzMzFlZFk0Nll2Wk5HOTFTekRrVGsw?=
 =?utf-8?B?UGNJTUg5cnJLTGZ6U2dROHk5cWRzdmxQR2tPNS9vd1dxSnVjWkdudGZPNjAz?=
 =?utf-8?B?d29OVk5JL1FjL1VNV0ljWXp1TXViMm96U0psajk2L2k3STNDZXR2dmFQbU9Z?=
 =?utf-8?B?TlV2cmpaRzJGNlBJLzAzWVVSZ2xJMnprdzhRWm55Q0p1eDJ3N0lXOXR5MmxR?=
 =?utf-8?B?ZGJZWnlVblFDakZoYk5hbWx3OG9jLzZETnhRTHJoeXhuRkNmOXdqTUZVa3E1?=
 =?utf-8?B?c3pYZU5WcGV2QXFDcnNHSlRoU0dTRzNydEVkVVJuclFFbmtyNEN2ZnlDYU02?=
 =?utf-8?B?Qit0SXZjdktyb2VQOEhWWlNGSXlhN2Z0VThJOGJROWhwd1hTck1YUzk0STVh?=
 =?utf-8?B?Z3FEdlY2Tm00ejBoVVAwS0hYZG53alk4N0pvVkJ5WngxSVl6Uy81WEJzbUdw?=
 =?utf-8?B?ampzMU5DUHY3eU1ENEtBTXJra3ZRT3I4QTdNRDdsay9kQ3hTN0tIdGZuQTVN?=
 =?utf-8?B?bGdSTVpGSzdXOFZVc2x1cWJCK2Jod0ZiZlRTeVV1ckRKQVZpRXpXbWExOWIy?=
 =?utf-8?B?V2pCMGY2Z2RmOWFoUTU2UlpYdFdzcW8xNlViNHFwaXRkSFJsZ1FodGJwNkhP?=
 =?utf-8?B?dUNJU0IzeWl6R3Z4QWF5N3Y1Z3ZhSk1PN2JCTnVOWllVekpsaWI5dUZJT2Vt?=
 =?utf-8?B?b1FaZ0JHeDg4MjZ3TGlNbER0UlBTUDljMHh4bVlwTEVoM1RsM1htTWdTZnE1?=
 =?utf-8?B?cExlZ25VekJTYUdrRmJMdzNMazJUdHlxR2VXWXN1S3JFd0tFNk9QNHJlT0hU?=
 =?utf-8?B?M1phYnR0UHQ5NC81VjF2dm1qelpDd0VFemhXdlZkSjlNLzliZE9BZEtad3li?=
 =?utf-8?B?Y1g2VkxFZlhHeGRIa0p1QVJ4YWNiSTRseVkzZ3NaZUk2R3ppKy8xaUszZ3VJ?=
 =?utf-8?B?TXB0SW9VZUVER1ZIZ3NEVXNtczEzZlJlZDFiNnFraUp5clRWZVRaNUE1anE4?=
 =?utf-8?B?aE5ERjJpdzZickdEN2VFT0d4SUZBZWd2Q3RnRVdLSzdqV0dsVmFKbFl6OGtZ?=
 =?utf-8?B?MjZpZ3lOUFhMSnJqS3RnK00zM1I5TXdoNWNQZ2ZKai9CMFBiWlBCamhGQjFW?=
 =?utf-8?B?V2ptSGQwVXB1Mlk0aDBZeFZOM0FJRG5hUGtHQ2xpNE5SR1VqSlpMWW12RnNT?=
 =?utf-8?B?N3c3cndxMllqdW1kNVBlbXpkaUtibEpOQnV1ajhuNjNFOURudmJSalg5b2E4?=
 =?utf-8?B?eGtHcHNSb3R4dDQ2NFl4SmRtbU9ma3ZoWmhDUFppaDVOczM4V01iYS9XYkVk?=
 =?utf-8?B?OVVlNEFEeGNJcWFNSlJCbXJqdGdpYjRzTmEreCtHQjJnREJoUmRxZk1QQ2FJ?=
 =?utf-8?B?amdlT1JOQU1naEs3RFFUa1RJdXY2ajhFVFhaRWVaVzVVZVBhTHpTT0JwYTVW?=
 =?utf-8?B?RUdEMTlaUjM5ckFLZEZlWHFKZWEwa1g1aTdIY3NqSmNmK2ZvbmtsS3lReE1s?=
 =?utf-8?B?c29HMGRLSnZraEdUejBweE12RjFPaSsrdFFqVG1MWHRDVHU2YmZubEl6K2Zm?=
 =?utf-8?B?NTRBZTQwRmV1bWMyNnBsLy9jMitZZWtyZ0t6UHplRlVSTW5qZ3VSelZYVHg2?=
 =?utf-8?B?dEg2bVNCZ3hIUXYyc0UrN3RxOHdYNGozRitxUXo5eUlNckFzK2FaL05hSC9G?=
 =?utf-8?Q?XfrUY+rQwboZqpQi42UNUC4pC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506f92d8-2eca-4b09-72c5-08de07b9e15b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 05:00:06.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMty39xgzp5titbn2g5j6m4slTrRzRKZb2N9NXBYVimV94/O9vA6pmVJ1xU29oAOanKkbPD7P6bN0JZWQFxedw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7467



On 10/10/2025 2:28 AM, Ackerley Tng wrote:
> For future reference, these are the three specific patches:
> 
> [1] https://lore.kernel.org/all/20250827175247.83322-4-shivankg@amd.com/
> [2] https://lore.kernel.org/all/20250827175247.83322-5-shivankg@amd.com/
> [3] https://lore.kernel.org/all/20250827175247.83322-6-shivankg@amd.com/
> 
> Might have missed this, did we discuss how these 3 would get merged? I
> noticed this patch was withdrawn, not sure what that means: [4]
> 

Andrew confirmed he's fine with these MM changes going through the KVM tree.

> [4] https://lore.kernel.org/all/20250625000155.62D08C4CEE3@smtp.kernel.org/

Regarding [4]:
https://lore.kernel.org/linux-mm/aFlHIjLBwn3LQFMC@casper.infradead.org/



