Return-Path: <kvm+bounces-66847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80DFCCE9EAB
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:20:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 421D33016EDD
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4285B23C4F4;
	Tue, 30 Dec 2025 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3IV8KqEA"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32F15E97;
	Tue, 30 Dec 2025 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767104437; cv=fail; b=q9QxzSm0dSiLf8GkfwcYO5g88MLOAwa89FMeZsC0/l4RGA+hd+OJ61rtdwd3TIIV86v/zDpvTnQziyhg4W0+AgTQHqE73ZYYZUx+1ezBmEJqV4ztw8Lrx3CgSnkvAG10UKpm9JYpgCsuXtv2H/r7SXuvHNPxxdw8a+hO0CK666Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767104437; c=relaxed/simple;
	bh=5OfanNSMqnlN/PpM/xmC+wVOZtKwsbIQRxfer3yQfvk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R3mtVHYAA9y4LRVFjhme/2ciL+9xTwTL6f1e1dSucvu+HOdXKZtn0jX7dUo4ERZrjSgATZLbGKWNKTeuurBq7Y/cApz6GiHfjN2dwCi2v8gFdGxRtnFnTj35MI3KkHgI9q7Fo+8x+0f1TOB371/ATYhbrSk6vUERLN16qT2CFDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3IV8KqEA; arc=fail smtp.client-ip=40.107.208.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIobpyTtnZVBL+H1yAHvmne0/a79uvho/q8MIXiWNi9eiGW+dR+dXdaCaeuI/4tQwyOux713iCzG03z9MPEreAQ6FAZVE4AxNV6opgh0RIzsKniwh3g/5aqcYW/JhVC35ERiwu28ityGvdKKF+YDMlWzcia0JKtK3b7IXek+OX32HXg0jdH6rSr3Cl/JOJd7k2F5TOVXMVb3vXA9fYWMAJkfSxoEAKzEa9q3Pj8pEs3oeDLnHN1Ny/068pXpWLzN6RR1Tsgud8bYCDM43sdZE26cUaNtWKw8fLT8Vuk5308vLATMdj4A6cTrgYEOD1NwoRzVqZef297387iz19tsBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EGvU6NXumvBo05aZdXYFCgp+Q9Vs5ReURAUeoS0GYI=;
 b=KDgBNj3yzeE34g8hVrO07kT0NB9Wja3FN8GWJmVt5dWmT1Tbno/2U9OlQQoY9Z2DCFHyjXYLaxRtdgad3exzcG9F7vP1FCoUx7u9iuv0jdtewzfieBdl09tf2FBCKGbU9WEFcsLBfccGe8b8XaEmA1gO+mwV6N0bf3Buw+7uAUhDbZTtl45IL52nPqmBMpnBv126RoJgiAlwk+XO4pyRnUjI7Na8LeSda6g/GlxQMwgwpvs42KVBMIXGqp1Jt7TP7BsY8DVBZg8ho0gGlC5GX/cOZyTh1LIwLgieL97mjUOB1kjY+kxV+Qe9cZSg0mRd4KgpmoGustbH06hzBfvNHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EGvU6NXumvBo05aZdXYFCgp+Q9Vs5ReURAUeoS0GYI=;
 b=3IV8KqEACGM9agPw+1WWhEEJS5EGsaoS1prSUunx8LvRAb2zSFZlYwBhFKH+b1WtOWK8rFeHkYXS/8YgqGtsW6taSf8/Q1gn9LoKfL03ANqBFmvXRaE7NIXHzlCVxlKGxfJG5ao1QnXenqHGkrTwbA3zK2HsayhfoSBznWgbpN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW4PR12MB7383.namprd12.prod.outlook.com (2603:10b6:303:219::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 14:20:33 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 14:20:33 +0000
Message-ID: <5e47b83b-999a-445d-a296-9157ffd3a9ac@amd.com>
Date: Tue, 30 Dec 2025 15:20:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] KVM: SEV: use mutex guard in snp_handle_guest_req()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org
References: <20251219114238.3797364-1-clopez@suse.de>
 <20251219114238.3797364-6-clopez@suse.de>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251219114238.3797364-6-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::7) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW4PR12MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: a195d834-abb1-43cf-a315-08de47ae97a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUc3NHVxREo1VVBlUEp3bEsrazUrTmRnTUkwdkE3OERpQk55Q0dLUFl2cFZ4?=
 =?utf-8?B?UnQ5SjhFVFJBTlRzSkdGQXIzdi9Kd0pkemJRK1lYQjBtdlp1Z2MxQ05XVy9Y?=
 =?utf-8?B?cUJSaE1sRXY3WVlaK0FyRlZvRHdocTNYR2ZGZ1MrR200ZWRkMDh5M0Y4anZ6?=
 =?utf-8?B?c092QXl0eWx0TVM4VDdOVzlqemt0Vzlsb2hkN0hYbEFUYTE1eHFOTGlsdEVS?=
 =?utf-8?B?MVBQeEJoQitKd1ZOZFczaE4yL0pQSUhpUEtBZnhhajJKQ0tsOVp3ODQzVUtu?=
 =?utf-8?B?Q1RjeWhDYVBrY1ZXYUlBRFZSdHZPYVdQbXMzR1lFMjVpZ3EwdjY3dkhsZmZ2?=
 =?utf-8?B?RGNpd0dvREtBaUdoSUV4ZEhTTDZxOWJzZXFyZnhkaVRZNDRRMS9KZ2tvUUll?=
 =?utf-8?B?Q3Z3eWxtZ3NyTGlpc1drY3pER2lmekMxT1RpNzVORXV6dXdBMno0T29lTDFV?=
 =?utf-8?B?Y1ZnVEFnTWxZWnhmMnNVWjVxSWxHTVBNSFFHWmwySWZ4YUk0dUxaU2dRMDdD?=
 =?utf-8?B?L0VreUVOblVKRjhkdjZsOHNHNVoxTFAwb3ZiL0ZOUS9nWnhtZmFUR1UzNCsr?=
 =?utf-8?B?aHJrclRvcHp3cVNGQmMrTldSYnZqZW5KaDQ3bEtNeEp2S3ZIUUZUTmZKSEZP?=
 =?utf-8?B?N1poR1FkNmlqNHV0aDdYTmZ2bkNDYmFodGJpYjJQNDFRU1R1Q3hCNVF1d0tl?=
 =?utf-8?B?Y3VNK1ZiLzkyanFpNmpKSDZUbms1eUI0ZW0yYzJRNkJEakpNWlg5RmZFTkxn?=
 =?utf-8?B?ZkZTVjlMUTRXVitLTEVzWTJtR3h4aXNpRVh4TERHSDVoMXBZK0o5SkdrNVJq?=
 =?utf-8?B?ZTRwcGFLOUFYUXRtSk5XNDlUNUxrcEN1MkpuZk1veTZSZFlBdFZFWi9Xejhl?=
 =?utf-8?B?eGtRVEFMLzhyL1REVWlQYjVCSEtxd1dKRnJDZkQ4N284d0wxUkFyQ2pydmZ0?=
 =?utf-8?B?TmYrVkRCNkxBRmoybHNPelVObW1LZktIenJGbCtUcktzMWtkd2VjamdzcDJl?=
 =?utf-8?B?amZ1Y2tIb2RHVjRHNnFQRkZNdkVnc09UcmxQcW5BbzJCODVYVUl4WW1PMEpC?=
 =?utf-8?B?dmF6RW9LdEFSQkFMNm40T1EwNGhudnpwTFkzN2tKNEtFWDkwcHh2TjRWNG9z?=
 =?utf-8?B?OHhKVldqLzZZeHdjSFdJZldGL3p5RXJzRFlVZXMzOHlFS3E2UjMrT2FxdTNo?=
 =?utf-8?B?R0lYQzF0S2RwaGdXZ1AzNDFUQWQzRmVUMVFCSWVlYmV3Zy90VkFFdDhMb0dx?=
 =?utf-8?B?bW5haDlPb1lFRnUrZ3h0U2xPU3VWNXc2NExibVlBTDNoYTdCMkx5cVptb0U3?=
 =?utf-8?B?VlMrSjFMRnJveExvaVBITVkvZDU4VHJ0eWpNUUlYeHRQdXgxQ2lWbXBIZnVp?=
 =?utf-8?B?a2trYVg3UzJQRjBDdE11TUQ5dHRGOVhIb0dueVl1TWhhbWNJc0ZNbGpnZjFv?=
 =?utf-8?B?YUJDWWhIZXlkMlplUVY2ME1DM1dhVFJoVVJqejcwSS9Cbm5SRWZTcnBIYlhl?=
 =?utf-8?B?cTFXdVFLZEZmYk8rcDdpR0lvQXZVVTIxdUw3NlpaV3NaNUFpbjc4ODZHVmhH?=
 =?utf-8?B?a1ROdHR2VkpSaENBaGRTaitMOUFPalQvNUNRM1VJM3lnOW04R2dlSzljQXFD?=
 =?utf-8?B?aHlDdlRCc3p1a2oyK0hsS1pndEFzbDJIQ0pPWm91UnRpWUhSdEkrbWo1ZDkv?=
 =?utf-8?B?dkZTL1VLb3Y1M1IxQWhaNFdJVURBM1FnV3lBTUlGM0Y2T2tIMUpOQXVVWHd6?=
 =?utf-8?B?cVVzdzVzd252RHhRUmZ1TUdiUGNaaGFRYnFEbFVUa1NKb0RuVVRjU1JJZG1D?=
 =?utf-8?B?QkdrWXQrY0VwVzF2VGxrRS95cFFmRGxiTnNFVzdiZmhZdjZ3Y1N3U3BrTHZH?=
 =?utf-8?B?QTE2VmtBM3ovQ1d0MDBTS0VIUzdXSEdrOFZZSHlRaGo5OXYzZ3l2RkNnbzM5?=
 =?utf-8?Q?9UfdgdYCCipEWSxR0hniyJ5HjaXQtpHQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WDVCSGMxLzBINUxWaTdHeklSZ1ptb0FBb0NKQ3RESUZQVlBJQnljU1ZjTXE3?=
 =?utf-8?B?Y0dVcXhNOGQ3N1A0N0dEUlg2T0MxWHdjdDZJZ3R6SGFTbTd4MEdDVzREZkhS?=
 =?utf-8?B?U24vTGc2V21HWGlzN096bzFuU0o5VFlQM1hpNlNOUzBwVGowRFZHSmtFcWhh?=
 =?utf-8?B?bGV5cHlEQXl1d08vOCtJcXgvVFhuQjhlTFBTUnFmYVd4UnJrRkZlMXVKdTlZ?=
 =?utf-8?B?U1NqaXpUTDh5UDd3WW5Bbll6L2sxMy8zSWdsNGhyODlDb3Y2M25QSmdiQTY4?=
 =?utf-8?B?clNub2xjd0N1a3lMaTNuaTVWS0dnTnByOElpN0NRZXBhbzBPU1F6bHppRmxK?=
 =?utf-8?B?VVFaUVFXUS92UUJsdHY5UjRTbFE3VUZPd3p1SWpIbVpvRmd1UXVRT2E1aXYy?=
 =?utf-8?B?aytFR00yV2ZrRTBBeURWRjNidGZSVHRuSW5jWXN0d3pFdkNpZDVUZk0xZVNS?=
 =?utf-8?B?azNzMnl6VTVnTEdqcjAvdzE1T2ZIdmNteVJ5VUxoN1daa1JFUWNtSkZZbGM3?=
 =?utf-8?B?V1NmZWZzTjhUNzBqZnNsaU84Q1dMS3FaYmxQRVYvaDhWNTJYTFJ3VjNTTFQw?=
 =?utf-8?B?MnVKRE5XQWZLQzFTeXJGRENRSlBmS2EvZlo0cmEvL0t5QTJOTkJHOS9tRnZQ?=
 =?utf-8?B?NWRSVi9sa2xMcFZYV3JvZTNSMHJNYWp0dndnUXc0amJlZmpITTQ1ZFdoaGlM?=
 =?utf-8?B?aU5hNmVOMmNLZy9MRGJSTXM0T1N1NjBVc29NOHI4VTZtenVVdWJuOGZkaEIz?=
 =?utf-8?B?bWoxNnNvSFZ3Kysza1dKaDlYNXJmTTVPU1prZmlaOVZlUXo3Q3FsK0ZDS0or?=
 =?utf-8?B?eGN3amE2RE1LM1hQd3JuRFZYSW5EMGFCZ3JTMUllV2Uvd0JtZkdJZWJBb1c0?=
 =?utf-8?B?V2IyZUh3N2gwcS8rb2F0c00xWjlubVo2dEoweS9SZE4rd253Um9vLytubStT?=
 =?utf-8?B?NHhyTlZpTFRzY1E4eU9GNzgwYTZYUi8xVmxkSE9SdUh6ajdpU3BISmQ1V0JI?=
 =?utf-8?B?ZjFDM1JoWXlDRDhBUXF1eWVpMTRPKzZOL3BDY2lzRnRUZjdib3RvSm9SbVd4?=
 =?utf-8?B?SnMydUc5dXhIU1YwK2k0aVFtbHlVVGhGS203cjJzMnd2TG5zQXh4NGtINGFo?=
 =?utf-8?B?eG9qME1PeFA1QjZRVFQ1bzZLa0hGRDZuZEFNN2YzdFVmTWk2cEhMbDZhbEhV?=
 =?utf-8?B?bmJaS0Vqd0ZFbnJ6cEUyaW9RNWRSNjN3cDMxbWhNbGtrNTJBb2NHaFNOMEE3?=
 =?utf-8?B?OEhPb2RpUU1UTVVDUDMydEVOeUpzdldLdXdGZXFIZDRDaVJ0MVJZNXBnTmNL?=
 =?utf-8?B?VG1FUHZmbkR5RExPUEh4L05oT01aV0RaUXUzOVJOVHRobExrWkpVaUlXMGRw?=
 =?utf-8?B?Wk5GUXFDSXFBUFp5dWwrTXpIMkJHYVlVdUtIYjRNT2JGMkFCZWZkalB5bm16?=
 =?utf-8?B?OXQ2dTl2dWRuRkNCbUNQVDhjWHBFam1XdmExZWhPT0MvK3FlaHhoWm1SY3Nh?=
 =?utf-8?B?V09laTNPSXlWbkE4THpaTlEwd0ppRGZqUXUvSDlSREViMFpXNVlhanYvSlVG?=
 =?utf-8?B?dTQ4WkFQS01mWXFvbWgxUTBWMEYrZ2dvcWo5cUFKVnVuUngydndDWFoxZENy?=
 =?utf-8?B?TGxHaGVnSUdhS3FXRXZMOEFtalJyUFRSb3lJSGp4Ulc5Z1NqWXFsNDBLMThJ?=
 =?utf-8?B?UVNjZHNWc1dKc25CUXExYmFxcHdEOHBiWWcyZGVFaFdLaUNTVWtkeW15TDlI?=
 =?utf-8?B?V1djamxnNUprVnBRdGdwNjJ1UGY1VW9xUjk1Snc4SGpNMThHd3RGVG1ObWI2?=
 =?utf-8?B?bi81ZGZPY0l5cjQ3c04yWThsc3VhNURtRmVuTjdzUklVR2N3L21IYVRQRHQw?=
 =?utf-8?B?SXZCdFJ2N1F2Z1Y4MjEyNmhlZDlBcnd3M2FGTnphbEYzcHF1Y1AxMFRRSmp6?=
 =?utf-8?B?eGJyNUJSRUdkaEwxV2hTZXB1aEZxblV6eXp6T3dtY2RmYk4vUnMwOWNwSlNR?=
 =?utf-8?B?QW9iaURhaW9idWNTbUViYjNIMDQ2NjVkQ1QxbnNuTFFFS3A4STZuWFQ0aElN?=
 =?utf-8?B?M3FLRU1NcFBPQjVPalhXMjMxSkZtb3Bwc25ZNTZNVXEydGdQTEZuRFB1QVZJ?=
 =?utf-8?B?ZkFreGQ2aWhwYmlhREhDbEhsY3M1V05HMmgyWFdJb080RDlET0xiWHkxa1BI?=
 =?utf-8?B?MEloOTZwL1pQamVXYU5iQVNacElqM1NCK0NBa2YyVDh6VkE2bVN1bEdwOTZz?=
 =?utf-8?B?djRGbzg0Tkh6NDl5UmZmQjBrRnBMQXZ4ZlorbEcxcDVsKzRDeEJsczMyV3Mz?=
 =?utf-8?Q?F73INyyl226eVsMGod?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a195d834-abb1-43cf-a315-08de47ae97a7
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 14:20:33.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39+Z2BjnI1Sx565+7w/CxEVhhEeKRiimYK+eD3SbIR4pZdwybm3wn2n5wt0kFpYCu7K39ljuQDmvtFJS4WqlQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7383


On 12/19/2025 12:42 PM, Carlos López wrote:
> Simplify the error paths in snp_handle_guest_req() by using a mutex
> guard, allowing early return instead of using gotos.
>
> Signed-off-by: Carlos López <clopez@suse.de>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 47ff5267ab01..5f46b7f073b0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4090,12 +4090,10 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>   	if (!sev_snp_guest(kvm))
>   		return -EINVAL;
>   
> -	mutex_lock(&sev->guest_req_mutex);
> +	guard(mutex)(&sev->guest_req_mutex);
>   
> -	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE)) {
> -		ret = -EIO;
> -		goto out_unlock;
> -	}
> +	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE))
> +		return -EIO;
>   
>   	data.gctx_paddr = __psp_pa(sev->snp_context);
>   	data.req_paddr = __psp_pa(sev->guest_req_buf);
> @@ -4108,21 +4106,16 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
>   	 */
>   	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
>   	if (ret && !fw_err)
> -		goto out_unlock;
> +		return ret;
>   
> -	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE)) {
> -		ret = -EIO;
> -		goto out_unlock;
> -	}
> +	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE))
> +		return -EIO;
>   
>   	/* No action is requested *from KVM* if there was a firmware error. */
>   	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
>   
> -	ret = 1; /* resume guest */
> -
> -out_unlock:
> -	mutex_unlock(&sev->guest_req_mutex);
> -	return ret;
> +	/* resume guest */
> +	return 1;
>   }
>   
>   static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)

