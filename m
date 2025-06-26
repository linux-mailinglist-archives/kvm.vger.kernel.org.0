Return-Path: <kvm+bounces-50790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF6EAE95A4
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 08:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E7624A2A8B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 06:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4438B21FF44;
	Thu, 26 Jun 2025 06:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NS15PeG6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577E1A0BF1
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 06:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750918088; cv=fail; b=PbaLeYOE8IR9XAm4eiVXHTwzCRyLMHZSb+j0xfzydElABzYVBKGYyGA/p5Xg84JZadD/LFPVSasNOWrCBxzus6zZmR1POb+IALrxWDAT+ZDh1VqJDdqIQKH/H+okRoPYXtCYw15XM/gwWnvcdwtQNQiMP4fGRxubtLc8mZcd8fI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750918088; c=relaxed/simple;
	bh=D9G+FDluq1SiPWxAOlZ/gMGDDUCm/SQ+R12W3VOzF4s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SqVYjpZHDGQhLL1sKxJTy7S1ptRYi1mDDaEOHHmnqoBINY4L5zmuAvnCASmh8ObmnlXnLw9YC5nY+B0lZEUrLX31Unup3F1/jEWfSfi4FD89vqOyJpkFaeT28nEnu7OpQGK/3NtP5uu3a9NRAZLPDzaWATWtxkiMhaOUrJo9y80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NS15PeG6; arc=fail smtp.client-ip=40.107.92.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afS05jXtE65skhEYg166HRCSOSZYt7N0piUGSI0cCRECPFQDcR5XTB3Ypasf6KqQwAH3oxqqWV92ONO1GT0TIaFDiciN5L0PkhbE/3AlRTuAbjEvmOYdldh2SJDzcEZ4D8yGBFxpPF8UnB1o0Q20mrYCLChhvHwnPnNPd2vluSGVcJGVvl+9R+fWneucY2i9ZMXBQgAk7ckycTHg3zfyl7WwggDFr3kVKo/9pZjnLDMrAdYA8da6fJ2gS2hQD4Mi2oZWDGzrpr72znwn6J5QB9kt4cPqmftdayDGiQFdcDQrdxdC93Z15O8XLKhrKLRLxh5ZABekOA3S/VKUa8J0gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scy9s1jdYjocHHtlBdMTQGDFIF41vNlswj8/9KwEhWI=;
 b=GW70szSIWJ+YsgKL3ZnbgxwAxtRT4IBQ9i+oM45Zh60+zeNrylaPoJlJRzHaJaKAyEFWP7WRX0SdCg634oSzk7t2oLY58ikCsqQEFmqC7IOlibwdR11jyMhn61a8zxDqGeVlpC+kwFiljQEUTl9v9RfDbAJqauepTkvavyBeW+6S3fLJuIza4tK526rOsCgiGRmaEKH5WpK9Y9puqFD/bsCWDpd9JshU1lOuBHbc6fCIQ2qx34BpBVJrB9bA+2de597cgxOLwpOVEypFAJZblH9Nnp16vRiAHwih/1Z0lE1tmdHLy9Kt6HKmVt4ShPhi0jxEcu3RU9nJ6qlYSzYytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scy9s1jdYjocHHtlBdMTQGDFIF41vNlswj8/9KwEhWI=;
 b=NS15PeG60+dlg4t1lNgEUxH2BpCGZEbQJJgF+LiZ9PbUJBw9yTPpz8hl2BebagjJaMXrnlX6KNZs9dz2h54LaqKD+De2kn5lmECiyY5MN/MFbTYy3G+/4gfZ11ALGSqKLvftbkUqUFdMtZzlj4c2+bzJSRa+rRMb7a4IULLACZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4SPRMB0045.namprd12.prod.outlook.com (2603:10b6:8:6e::21) by
 DS0PR12MB6390.namprd12.prod.outlook.com (2603:10b6:8:ce::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.29; Thu, 26 Jun 2025 06:08:02 +0000
Received: from DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78]) by DM4SPRMB0045.namprd12.prod.outlook.com
 ([fe80::3a05:d1fd:969c:4a78%4]) with mapi id 15.20.8857.019; Thu, 26 Jun 2025
 06:08:02 +0000
Message-ID: <54abb703-977e-46c8-80d9-d5c5b95aba64@amd.com>
Date: Thu, 26 Jun 2025 11:37:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC
 enabled guests
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com,
 vaishali.thakkar@suse.com
References: <20250408093213.57962-1-nikunj@amd.com>
 <20250408093213.57962-4-nikunj@amd.com> <aFwECPca4SbV916d@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aFwECPca4SbV916d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::6) To DM4SPRMB0045.namprd12.prod.outlook.com
 (2603:10b6:8:6e::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4SPRMB0045:EE_|DS0PR12MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 443e20ae-f290-4c18-86b0-08ddb477cebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFROTjkrMHBLSjNHd1Z3cDl6cmd3YkFhcUVlWDlwNllSdTc1dWovM0RhOU9k?=
 =?utf-8?B?dVROd0ZsdnhDN2I5VlEwSkQwV0l1cHJ3RmY3U0prUy8yMDdFOFd1ZWdLd3JS?=
 =?utf-8?B?SjF5V2JpTEFjSUlsZzdmMEVOWFpxMjdoTU45MU1lOHRyeWpkTnlSMURia2d3?=
 =?utf-8?B?L1NWK0lYSFUvYStBQlFaemw0bEtDenFDaUZvaWZFU0NVNGhYTTZHdThjTXJh?=
 =?utf-8?B?bDZ0WTc2YmJidjNrU0N2NVdsQ3VNMlVGS2RvYUh0bDN2N3EzNUo0UStqa0Er?=
 =?utf-8?B?Q0lDdXZpQlUxcjd6WjYrNkxkdVFnYkxBUy9sNjgwVWRnUE0xMGM3RHVJS3Jz?=
 =?utf-8?B?alQ3dFBXTm4vcEFSTkFUNDh0UHBKRlY4ZU9Ra0ovcnNXVXlTSGFlMUg5S1Vh?=
 =?utf-8?B?eGQ5Sm1IcFQyUFlZbDNOMzhiL1R4aFJSUDBFZ0kvbzU4T1dUV2o0UHEzamhT?=
 =?utf-8?B?eFo2U0ZyR0Z3S2kxSGduRnZEYk1YS3ZKMXNxdDlOWlc3ZEZEaUR3bWtoc0Nh?=
 =?utf-8?B?YXo3azB2ekRvdklKb09vSVZuMDRYUWV3SjFvZGQzUFlxY0Z6OVJCZTROQzBF?=
 =?utf-8?B?Y2FCZ0xuOU8zdjhQSXlSbTM0NkR2dTVTSGtWa2tMU2hmblo4VlE5MlZwTmc5?=
 =?utf-8?B?TnVieHFKWHdkWmRtSHF3R1h2NEhEdzlzdFQ5NEZpWXlxNEp0OXpMeGoxNG5W?=
 =?utf-8?B?Y0dYbXQzbHFUaG94L2JScFR6azBqQnpIczFxTmx0b1FPL0w1bjZCM3RRS1RN?=
 =?utf-8?B?SVNYNTBkQXRicnhDengzMUZLVWJFSzd4a1o3RWZlZXE4R2NKb08rRHEvc2Vp?=
 =?utf-8?B?LzUvbkZpSjBHWDNrVUdpd3J2Z1U2UmE0aXloVjRXaEhqUThmVFdoYTNRS2VI?=
 =?utf-8?B?a2VCdDkzY1FuWXJURmdCZUhoRExrVW15MWhvWS9ieHYzSjNHREFZL1pxWFE4?=
 =?utf-8?B?VnIyNkV1Mmlrb0o5cnBvcmNsRG1MZlNpYTBBNlM0ckRLZThFNS96WjBiTU5P?=
 =?utf-8?B?cUs3ejhXVGxNSmdIZkNPL1ZPSk16c1FIWERvT0o1cTZsUGp3ME1PTmlPbHNU?=
 =?utf-8?B?cGdmUzIwS2RnWjFBQk5uVzM2RmE1bmc4cUpHWlk5ZzRkbUlKYkEwaXRLdmkz?=
 =?utf-8?B?R0xGa25EdHNrV2Q4ODRtQTc5T29TQ0VSUzdSMmQ3bk81ZEhqM1ZQdzk4VmJk?=
 =?utf-8?B?K1FadWhNcmFaZnVDbVVYSUVzMXpuMVAwTVN6eXdObDlGeXVwaGlBbTZaZXph?=
 =?utf-8?B?YVdWK0t6bFVjSXJjK28zbGo5RzZBOERDYnc3WHFtRjBmWXhDQUJudXk1Q2hB?=
 =?utf-8?B?M3gvZ3NrTit3TU9MMGVDYTdOWW9tNkgrUms4QnhGelFic3hpWFB3MGU5U1hu?=
 =?utf-8?B?ZktkVFVYa09NOXpGRzN4Zk5XeENBNHBvb2t2cEtua1JKM25pYzVaVHhHSmFl?=
 =?utf-8?B?OTNOM0NERWphTjFKdG16SGkweGxSMnY3WmxiWTRtV3pUNzNNRTN1Zm4vRGpC?=
 =?utf-8?B?Q0JtdVZKVW1zbkM2bmt6QmU4cnU2QWptL2JZaWFhaTFOdmVSNHk4REQ0WHJW?=
 =?utf-8?B?TjRPa21ta1daTm5LZFhlOUs0MFBxQXQrRk1UcXJYNWVQLzZFZEo2MEpDTU0w?=
 =?utf-8?B?N29xVjAvaDgvckljTU16MEVaV0xrSFd3R3JVbHg3Szg3RjRZSTNrL1J5cUxQ?=
 =?utf-8?B?QjRrV2dUZm9nUzJmZXVTN3l3aEdpbFJkNTBibzlNVkFPa24xa2RvQ1pxaDRI?=
 =?utf-8?B?clZwOHJDdmZpNnR2VlgzQXdkNXV0azFXaUlnTEtpUkFsMmQ1MkoweC9oUVQ0?=
 =?utf-8?B?dVY2M3VHczM2YkNNT2ZGa0x5eGsrVElDL3pXR3hmc3hHZXhsQ0loalRKaDBy?=
 =?utf-8?B?QU5DVDVvRmdwNFB5Vm5paGxNdXdmWkJwaXJhY1lOQStFZllGZUVPbi9iTith?=
 =?utf-8?Q?7lT/woF0mfo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4SPRMB0045.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1dvdUgxR2JVNm81OE9TOWp5Ylg2bldWTFJ3Z0Rnb3VNanBITnhITzZ4dDlj?=
 =?utf-8?B?cnBIS1FHdGtYRkYrT1N2OVFzSzZsWlFyUTNzQ2NOalUxUURGQ2FCN28vL3hF?=
 =?utf-8?B?aWxhNGJkdlRkdlB5bXBFVzU0anhzTSt2MDExRlhpTk94VlQ4amZYYjc4OUYx?=
 =?utf-8?B?czEwc0RxbGJVVmlqa2tUdk9uRXNMTmVJbFh0RDVlTTNmanh6NEVTZ05lTEk2?=
 =?utf-8?B?YUN3S0ZLTk9ZSjhxVVNoNGlkM0FHWnVQR2hIQmcwTUhWSGpDcjhNUlN5ajhC?=
 =?utf-8?B?OW4xQjB1ZHNmV2w0NmpmaHVJWGpZZmg2a0tBV05RaVRjTnc3K1lXSXNVMmhU?=
 =?utf-8?B?ekI1NW5adCtCUi9EWVRhMnU1KzZoRzF6VjFPVkFqbDBwditGV0tIKzIxaFVr?=
 =?utf-8?B?SFNLUURwTE03TlRmZExrelM2QXMvNFFqdFN2VHozczYvV0MwMEZYRXBJZ3R2?=
 =?utf-8?B?UVNVU2h6MzlsdCt0UnJZUWdyUjFGVlM4WGQvaGJQam9mR0dsMVVkVTk4UXlh?=
 =?utf-8?B?bXh4UU1nWFN0NmdqR0lxMFMzVXdXWEtrSDRwcEtMQ0RMZzNKeXBsY0Q4Nm5H?=
 =?utf-8?B?R3A4QkZZTWxCK2NmaGdkbHExMEZzUDlYcFAyM0N2NUJTNnQvNGp4eW9YYzEv?=
 =?utf-8?B?RUZ3NzJ1b0xLb2Q3N2lmR2N3aHpJOFYyN3Q5Umt3bWZFdTc5K1p4NC8rZHRL?=
 =?utf-8?B?WEw1dlgydUw3THpzRE5XZnNDT3djU0NqVHh2QUtEQURCZ1YwT2lyMmxBZ1p4?=
 =?utf-8?B?SWFkNkp4U1FVb0JUeGU2eFVvczVsMFV0NEVJRkZxT2NLaDhDSlV1dERrcHhR?=
 =?utf-8?B?K1g1MmtoKzA4TXJBcXpjK3RNaWppZUFlcktPQm1FQXh3ZFJ5T3lxVmpyYlgw?=
 =?utf-8?B?UVBIMXNDbGdxeTFoV01VQ09pTGpIdFBlOElRQXpwMzlRSGFQb2VXL3dESUZN?=
 =?utf-8?B?NklXb3h6dEFjcVRhcGdHcWpuTVF6cUhXUVJHcmdrcEtUZTVDQ09NZnR1VWti?=
 =?utf-8?B?S1lzdTA1aE9EZVk0OFpSbVZKZTByem1jSVM2bjliME1JWU0vVXVHRkIrODNz?=
 =?utf-8?B?Tnc1YTZibmFaNWZHa0s1UUQ5OFZVM1RHT1pVWmpGMXk5N2txOWRMcG95LytP?=
 =?utf-8?B?WERISHpDY1NJVFhFQlJvczRnUjJEaTRCaW80UVlrckxmcTVhUUNQeDZIQmxT?=
 =?utf-8?B?d2xrbkdDUGQzZ1JTcUhPM25UQ2cvenRiMXFXZEY3TGdoZW83MEY5TlRwL01q?=
 =?utf-8?B?bG5QMHA1NU96WWFpZmhhWThlSVhUZi9vR2p4WjUwek5KRzJTOXBQQTZrUjQ2?=
 =?utf-8?B?NVlLWWlOUGZLZGcvZnNha3B5T2hRVlBaVkcraVZWanpOdnRBRTNaaGk5UTNx?=
 =?utf-8?B?Y1BpZzBNUjlIU2pXeU1lWW8zdHhDZzdpM2Qyb2xFOG5iaXpoeTF2K0x2NzZU?=
 =?utf-8?B?M2pwWlN0dlo4ZHpLOUhBbEM1K0w2UXJ2NGM5Q2JGbWRyR3ZnSmFaenozMG1Q?=
 =?utf-8?B?VXNrUWZqcXJXb0gwSEREOFBCdHdseElwMWpWOVFQWlJkem9nL1JvYjZJYmdT?=
 =?utf-8?B?YmxNTXMrUEl2OHR0UnJNaCtPZkplODkwMGk4VzZyR2piWXZPK0Z3ejVreEgv?=
 =?utf-8?B?YWtLdFZPWHU1YkNwdklGK3cxRzZtbStaNVNTWGIwaEhGUXF6QWw4a1BhLzBB?=
 =?utf-8?B?Tm5JelA0QjBTRmZMajh0UTVMZVJhandpS2pVVEZscG5OVm1iclVBbytpdDRF?=
 =?utf-8?B?QmhaK2ZmSEx4WHoyYUxoTkExMndYRzlrUHA3dzY4NGxpamFZbGRLVUxSN0NT?=
 =?utf-8?B?bHFFRURPTHd5UG5MWFJwTHgrQjUrd0k5Z3JlNnZtU1ExN2lIS0MzcW11SjRp?=
 =?utf-8?B?bjJFeHMrLzFMZGFkcENBdXNyZ0xoeGZWODlGUVB2MjRDOXFBYU5Rb09MVkt4?=
 =?utf-8?B?NjJudkFPUE5IRzRKMUlyejhLOVp5YjBpdDVOTzlhK21SVGpiU0lweTJEY1FD?=
 =?utf-8?B?eW5QcXR3MW1rS3VtcFlNRHY0Rmp0UFhsMDNzUUkrL292QnZBOFFYV0M2NVBn?=
 =?utf-8?B?bklLc0pVK0V1TnUyRTVlQjkyUUk1dGJMUzJrTjd3Y0d2aUQyV0hhc212ZS80?=
 =?utf-8?Q?ZoXY/X8pH7RqqVs2xr4P4cCF7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443e20ae-f290-4c18-86b0-08ddb477cebf
X-MS-Exchange-CrossTenant-AuthSource: DM4SPRMB0045.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 06:08:02.3011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtwosPl50Rk5+RWu1x0BENl819ONuQiGaSxJM/G00PqKa5Jrk9Pvu2qsl6jzvdnCfJtEhiw+KmK4aIICh27VZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6390



On 6/25/2025 7:43 PM, Sean Christopherson wrote:
> On Tue, Apr 08, 2025, Nikunj A Dadhania wrote:
>> @@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
>>  	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>>  	       !WARN_ON_ONCE(!sev_es_guest(kvm));
>>  }
>> +
>> +static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
> 
> This is only ever used in sev.c, it has no business living in svm.c.  And there's
> especially no reason to have a stub for CONFIG_KVM_AMD_SEV=n.

Ack, will move this to sev.c and remove the stub as well.

Regards
Nikunj

