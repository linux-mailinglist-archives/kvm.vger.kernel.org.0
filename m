Return-Path: <kvm+bounces-34972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF36A0843A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 01:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 803067A1A6B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 00:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D222E62B;
	Fri, 10 Jan 2025 00:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m7Rrjz8N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F011773A
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736470746; cv=fail; b=rF+srYQhVuS9qmJef99xjca5rfEyQr/RGUzllwuEuGgYTVo97bKdROAznfKUXs6IFD0Cw+06Vm2cB4HDTjtxIqBNYTowx7yoTgUHMkPefYccoHS4cGGEV8k30vz3uQq4hV4LeGvhckHSef8uxsYamZZP3UTAupgft3SnofZ79sE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736470746; c=relaxed/simple;
	bh=BUSXOsGa6GL4fhVGZuoqRKvT6/o6ghAiZijgEvOTo88=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mnIAC97++ZK0shuAsxxnQWlTkQcJ2LwpRsGFstW5RrpJ6vSCLEMHwquaWIO/wjcWSxB5gOYwyxWyA0U146cTH1wNr5m+TE6mLSZkL6NNMRdWEXZDK0A0Z59voTPko329q+gmEGWCKSXQ460P41620nZIlBc4yajIsCML/nPp2EY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m7Rrjz8N; arc=fail smtp.client-ip=40.107.220.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UsGntTog6jFeFjVKhRMuwBEXmc1M4D+s3wXJ1T/YsfTiwDWFMiTnErM3605uQ3xm5+osSo9iBdc8I0HrNq9A+lCiaqT14ZTt+of9DXyZ9eX5SWBH3FiRyrL8E/c67ZLcIDCEKGl8+LeuzRob3eFJlZWrjsrxNdfI3JM+X240OjLuMOhBL48UUAm3I42dLilNOjVU3w/Rr+sssgROjzZWUWLUun/Wm/+BLXKDFslHh6LT2GggSl6nUs5rz5mYB/MLcqL9HYITeT0qzhFQp5LKpydejKhBuP5CTAVsFqunFVq3o/twGE8Oct7NtdefaE/fTfPG+HjMXkkyszcmlDXlyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BTVcCXeu9E9aikZP4elRi5oS26lje2pLUPYGkv3e+jU=;
 b=vOiO6OE8slnwgKNBK5kJKNr6zrje94iqBJTdVcYDaaQmvxGKvoS6w4VdvxX9ree+AKSLxsjvuXC1RCuAdLB7Xzjb5BTjJ9erMN5iyC1At7pJOtTMyXqECVGtbJk53be11z2IbITlqYwYwfwqlWaAzao2AvUCCgYKtqE3ImdLVbr/KPZML2kmcglpaN3qDVQEMPrYI6EmD9EpVE1dfa/5hlMzcgj4F2inoIwGmYnIbi8r04gduaM8Azok6axve+jI2RSp9qzA5nEOJ3t0oDDcrU/M4d/q1pdl520Xh/p++7H6G+t7f+ALBTU2jT1NBPCRcVu6IjwbqCiHGaAQmgC8cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTVcCXeu9E9aikZP4elRi5oS26lje2pLUPYGkv3e+jU=;
 b=m7Rrjz8NfuOyMYfekmIHKL/wqSnPcvr5QNQoDKW+lM30r0Vr07QELNi5/FhNnEXO/s/Vt/5ctNDI4Bgt4Z7cwHR7Rx85zrTzxvdQ3aXzc3HElJbGTPqo4jSbJbHwQ69N6Z5jNQkeV324YUfZJxH/mURGUIp5eYF+r40zeNgGWbU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA3PR12MB9159.namprd12.prod.outlook.com (2603:10b6:806:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Fri, 10 Jan
 2025 00:59:01 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 00:59:01 +0000
Message-ID: <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
Date: Fri, 10 Jan 2025 11:58:53 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME0P300CA0016.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20f::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA3PR12MB9159:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fbb117c-aa39-4426-b5c1-08dd3111f8a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elE3L2dIUzQ3K0w1ZG1OaFFRajhHZ1UxVGRlTDNNcjlyNG5VT1hYSGdIbFFu?=
 =?utf-8?B?ekpIYVJGYnQ2enVjTnBQS2g2d0F3STgwdGhVQytOcTRQQ25LbWRScFVBQUMy?=
 =?utf-8?B?Z2Jvb3NGVStTcXJ6andtcVRrc3NXNm5RemhnQ3dMK0RLZkMrM3pDcE9uTkN1?=
 =?utf-8?B?MlBNNjRQKytFa1BGZjVGdHpmaTQvb3hSRGQ1d0d0L0lKV0EzTWJuQVhBVWxz?=
 =?utf-8?B?Y1ZXY0F5NkUrRW94RUZXNWMxSFZoS1BPMCtaNlR6N2JJdEE2ZndTeDBVYzZw?=
 =?utf-8?B?T0ZwTm12cjRlb1RqUUV1Qkc0cms0YU42VWZrL3pJNVBDL0xrZ3YwbWI3WmlQ?=
 =?utf-8?B?bFZ1K3JHM3Z1b29NekcyNGxyWDZFZWVacEE0V21GWE1TVlJrVndEL0J0RVcz?=
 =?utf-8?B?Nnppc010YlhtSnpJZ1pSS0puQkNIdVdjUU93dmpNVlA3M3NjVnVPa3QwbWNW?=
 =?utf-8?B?WXNpUGJPWlNGZmd3SVpuSUczMktwUlVnc3pTRVZhcCt6Nk84ZjIxMlNpRUZQ?=
 =?utf-8?B?MnZoSmpaWklGUHVnTW9JZzFYQTB0cUZiVFN0RmRTSEtsZUIyRXI3bjVnVWdQ?=
 =?utf-8?B?emc3SXVXK2lhZldYcG8rc3ZUVnBNM0N5ZUJ3bVRTcGJSeVVIYk1Wd20zektQ?=
 =?utf-8?B?Z2pRNHNLYWdDNm5icXBkUVE3dnhaVUovbU9tVElWb01kSlUxaWZOeEpvVy9y?=
 =?utf-8?B?S1I3Qk52eGFsMmdtVS9vZ2lKUTd1N2NJSTdLNEhBMlBRWC96ZEllTmVPOGF0?=
 =?utf-8?B?VjdWMUd4ZUxaZTVnSG51NGRFemNnZFZHRFNOYW8yaWNSM0tMZEhxMFNEcHgx?=
 =?utf-8?B?N2hrcFlqSy9xQXVuU3ZGNm5VckZ3bE5KR1hlYzBlNS9vK1o4Tktia2c5VDZs?=
 =?utf-8?B?aERNRHBxU2oxdWVWYmgrdFpPRDgwUFhIT2lXWFNSWGRBSWIwYUtlOWQrd2M5?=
 =?utf-8?B?R2xhT05IOVo0YUZNc2hVVUVXTXVBeGIva2NyUVlWR2hCLy9JbGVPMC81eTMy?=
 =?utf-8?B?bDA0UnIxZ0w2aTJrVTcrOGRvR0ZhWmVnL2dyVmJCTWZ6VU8vVWR1ODJPMjJR?=
 =?utf-8?B?KytrQWhEZlgyVFBkV3BFQWRYNFJvQ3RDK21XMm9kaEFxc3g3N2FDUk5ydExk?=
 =?utf-8?B?eXNNMEs5M0dRSE9rVGJncmJyZlJQNUdSZFFIZ1o3dGdqc0hiSjZLZ2J1KzRJ?=
 =?utf-8?B?cWNUN29ocEVRQWRKYmY5YW9oL1pGelhhN2libmp1LzhIOUg2emVsSGdueW04?=
 =?utf-8?B?aDQrZFRGaXFLR0ExeVhUeElqQVdndVFRSUF0M1NPNmFmaWJvZmpxeWFFLzRp?=
 =?utf-8?B?UmRhNWpFOWltZVBhajNnV2ZweGVUYWo3dkVwYlEvdGxpalNaMlBtdThKN3B2?=
 =?utf-8?B?TEpUaVJOK2ZwWGc1bWdHNHk5SHRKTUVhVmZnRlFobVFQMGJMdFhpbkMvYnRk?=
 =?utf-8?B?V1d6elpCbVhDaFRQeWNlNTZIMFgvTnFDaFVWdjlQUlpQbXRZczRlaUhQYzYz?=
 =?utf-8?B?TXhoaWJoMlo3cWNKejY4SEg0bzdZVmpmRWV4WmJ1RWhUY2xQbWdkYXFRTUE5?=
 =?utf-8?B?Qml3TnYwSTliQ21iVGFPMWFRWU1ZaHgxeVpRSGI5QWdMd01lQUY3VnQ0U1pS?=
 =?utf-8?B?VVhMR2ROZHVidENtSVRHNjE0NHQveE5tUFNGbTdiTjFxOHVUMHFnUlM0aXBr?=
 =?utf-8?B?N2pLMzNjTHFhUFUzOGRSMlFpWlBMZ1oxV2xzNGVSNjd0ZmRxZ3RVbHB3WXpK?=
 =?utf-8?B?Yjl0MnB4YnVIcSsxM1RZc1k2KytNeDRTZFByWERxZXNkcHJscW95MVdVUnpq?=
 =?utf-8?B?emFNSURRMzBmVEZYWi8yQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWN0cTJXLzlNK21rMTBIV3FxaVduQTBkSUVrZjZMVmZ6dEYxYXdBRit1ckxD?=
 =?utf-8?B?NzFVc3hBbHBreStOY01LWmVZMlh5QkJXNkcrbitXQ2ZnM0U3ZENQbW84dC9s?=
 =?utf-8?B?TldZNWNmOEwxNy9vSzFTdzZFblV4Rk5WRmNZazJKRGhSeTFkaFVuS256ZG5J?=
 =?utf-8?B?N2xueUdTMkRCUWhXVVplOCtoODNxTE9YemRVbVFQOEVNVW13UUNUQmJMeWlX?=
 =?utf-8?B?SDRBZ2Z4VFJ1SjVpcllORUhFc1hMb0xRczZDcmxjeU9wVTlsUHFpMElueW5a?=
 =?utf-8?B?TndObTlMOTE3U3BLTnB3dldqdWxMbXdsVVVnRWVqQjgzaUVweldRT0FJT0hk?=
 =?utf-8?B?ZTZycnFFYkNWVUkyNHMvejZ6ZHJjSENGSFdTcTBpYU5jaEpySnp1NkkyK1hZ?=
 =?utf-8?B?RUUrV0lPL3VnUGxXODFSS0JJbmlQVEgweXVsNEJ2SFhYVkJOZzc0MGVmUW1z?=
 =?utf-8?B?czJOWEE1UGVCTktQVVp4cFJuaEIrbGMzK0pBN1ZLaXlTTWtsTnBpekhVbk9r?=
 =?utf-8?B?VmFESE1XbDIyMHQrMHlyeUROYmFCUEJ0cGpGdzQrL3lVc1RjM0k0dlQreHJG?=
 =?utf-8?B?bitBQmdWMVZML2ltcGh4NGoybzZ2L3ZzY1pvQ2swb2hvcmFTVTQzZ3RaMW5t?=
 =?utf-8?B?TjhBM092Q3J5V3dpNDFXNzhzcXVEeEdFOUVpSzh5N1NMUERxNDF2UVNqV0xx?=
 =?utf-8?B?Q0wycU9yK2EyUDY4OVRVRlZVM0RTYW1zejFWY1dDMnR0V3laWjZINnJpQnJp?=
 =?utf-8?B?ejczb0xqYlNxWXJBeHk3ZVh4Z3N3QmNpbDdqVDk1SHFhVGpqazE2dXpmNzlp?=
 =?utf-8?B?MkJVSk1lRnVFbCs5bGtNMnZxaGlXSHlwb3hnWGNXdXVvYmt1ckFFU2xCV01u?=
 =?utf-8?B?R016MENwdGxBdk5uc05heGZUWUxnRzJab1hNa2JXeWtYR0xZdHRyY3p4RGVE?=
 =?utf-8?B?YzkxSkFDVFRLdTlwazNLUHkwUHpyYkhtVGNONVBXclozcXlud2tkdzYzVGxR?=
 =?utf-8?B?blpRRnhnOXFiVGcxKzVQTFVHRlpBR0cxeE5lVkRyaHpmR2hpd05Va3lMNTFH?=
 =?utf-8?B?WlFhdi9vUllTL2V5N3hwM2F2VWNmV3hGZUdrVnRyWk1GcUpzbkhtWTBmOUs4?=
 =?utf-8?B?d3hqVGZlQzFMdDA4cnh3N3Z1czJwS3N3RWxYbE1DczRuWjRuSDI5NjIzNmVo?=
 =?utf-8?B?b2oyTXFadU9rME1WcVEvcnJYSFNjYnYvVzRRU0JkcHpEQ1dXc2lraUFzTEQz?=
 =?utf-8?B?OVVxYUZ5MjNIMExVMDVENUpvc1VLbDh4ME5iMGlJTGs0Qkl3QmhOZW93MnZi?=
 =?utf-8?B?S042UlRmV0g5d1hmQmhZN1RVT2NVTTRWVkhGNVFpZW1JMjc4Sm1VbStmOCt5?=
 =?utf-8?B?cjlBeGZzaksxQVRmV0pxNU5xVjB3UE1rZlVmbzBLUEVQZStyYkVnanh2MDJN?=
 =?utf-8?B?bXFNRHQvZ2oxVFR4ZGw4QkN1VDM5REw3Q0FHcEVmcnVLVC9RQVE3OXkrbUtw?=
 =?utf-8?B?czAyN2pWNVFYVE5lSFFzRUNxcXlpeHZEWEZYSUFzVUZjUkRFM1JTYXpOemsv?=
 =?utf-8?B?SkQzZUxPdHZHNmNQLzNnRnBsdldJYlBQT1FZNE8rUWZ5QXNDblBHNjlmL2pZ?=
 =?utf-8?B?SDlvSWt4SndQY00zUkF5M0IwVE1rSXVTZEw4YWs2U0dCSXRwSjFMdUhFZTNa?=
 =?utf-8?B?eHdmVkJSL2loVmhHdFFVN2lPS1FaWkRxa0x6c25VQ1ppM1E0ZUZ0L291MFk2?=
 =?utf-8?B?cTRGSjJnNm56c1hrMHpOL3E0RjRHcGFSTmZKZXpKaXIxTllrYTFEV1pNazJX?=
 =?utf-8?B?SjlHS0FuNERWdFRaZmd1MUtrNVhpQ0h3dndJTS9Nbmd4bENJYWRuTm01OWFG?=
 =?utf-8?B?c2R4anZxcjdnRFNDWHhtL3BLZWlYSTBIM242aWxudkd5NmFVb1VNeGF3eDI5?=
 =?utf-8?B?elYranlWZ29DOXdnMjJTKzNsWkFFMWlKZUFudElwbG5jRS9jK2pwWUZmSklq?=
 =?utf-8?B?TnZtZGRLVTZ1enpvNit6VHI4QmtCSktJRnAxQy9TZGRBbVhzQzhIVTJpNFZR?=
 =?utf-8?B?cXlwNDZERDVnSGRpeVpUV0ZGdmFEVWdUU3o2VmRld2pIdUZiSHhTYXZiZW9V?=
 =?utf-8?Q?40n7SUCpy/R6fhBhhs1lI0Xt5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbb117c-aa39-4426-b5c1-08dd3111f8a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 00:59:01.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IrHilCa8h23rYnEsZRXGiISAm4lVegpzG7IioSc72pqXfgdJccTJbK0FCI3Q8HQsYjYEMmp/ccmyg9n5nOSZMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9159



On 9/1/25 15:29, Chenyi Qiang wrote:
> 
> 
> On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/1/25 13:11, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>>>> operation to perform page conversion between private and shared
>>>>>>> memory.
>>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>>>> could cause guests to consume twice the memory with VFIO, which is
>>>>>>> not
>>>>>>> acceptable in some cases. An alternative solution is to convey other
>>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>>
>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>> adjust
>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>> adding it
>>>>>>> back in the other, so the similar work that needs to happen in
>>>>>>> response
>>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>>
>>>>>>> However, guest_memfd is not an object so it cannot directly implement
>>>>>>> the RamDiscardManager interface.
>>>>>>>
>>>>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>>>>
>>>>>> This sounds about right.

btw I am using this for ages:

https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46

but I am not sure if this ever saw the light of the day, did not it? 
(ironically I am using it as a base for encrypted DMA :) )

>>>>>>
>>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>>> target
>>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>>> where a
>>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>>> e.g.
>>>>>>> the virtual BIOS MemoryRegion.
>>>>>>
>>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>>
>>>>> virtual BIOS shows in a separate region:
>>>>>
>>>>>     Root memory region: system
>>>>>      0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>>      ...
>>>>>      00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>>
>>>> Looks like a normal MR which can be backed by guest_memfd.
>>>
>>> Yes, virtual BIOS memory region is initialized by
>>> memory_region_init_ram_guest_memfd() which will be backed by a
>>> guest_memfd.
>>>
>>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the virtual
>>> BIOS image will be loaded and then copied to private region.
>>> After that,
>>> the loaded image will be discarded and this region become useless.
>>
>> I'd think it is loaded as "struct Rom" and then copied to the MR-
>> ram_guest_memfd() which does not leave MR useless - we still see
>> "pc.bios" in the list so it is not discarded. What piece of code are you
>> referring to exactly?
> 
> Sorry for confusion, maybe it is different between TDX and SEV-SNP for
> the vBIOS handling.
> 
> In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and loads
> the vBIOS image to the shared part of the guest_memfd MR.
> For TDX, it
> will copy the image to private region (not the vBIOS guest_memfd MR
> private part) and discard the shared part. So, although the memory
> region still exists, it seems useless.
> It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
> vBIOS guest_memfd private memory?

This is what it looks like on my SNP VM (which, I suspect, is the same 
as yours as hw/i386/pc.c does not distinguish Intel/AMD for this matter):

  Root memory region: system 

   0000000000000000-00000000000bffff (prio 0, ram): ram1 KVM gmemfd=20 

   00000000000c0000-00000000000dffff (prio 1, ram): pc.rom KVM gmemfd=27 

   00000000000e0000-000000001fffffff (prio 0, ram): ram1 
@00000000000e0000 KVM gmemfd=20
...
   00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM gmemfd=26

So the pc.bios MR exists and in use (hence its appearance in "info mtree 
-f").


I added the gmemfd dumping:

--- a/system/memory.c
+++ b/system/memory.c
@@ -3446,6 +3446,9 @@ static void mtree_print_flatview(gpointer key, 
gpointer value,
                  }
              }
          }
+        if (mr->ram_block && mr->ram_block->guest_memfd >= 0) {
+            qemu_printf(" gmemfd=%d", mr->ram_block->guest_memfd);
+        }


>>
>>
>>> So I
>>> feel like this virtual BIOS should not be backed by guest_memfd?
>>
>>  From the above it sounds like the opposite, i.e. it should :)
>>
>>>>
>>>>>      0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>>>>> @0000000080000000 KVM
>>>>
>>>> Anyway if there is no guest_memfd backing it and
>>>> memory_region_has_ram_discard_manager() returns false, then the MR is
>>>> just going to be mapped for VFIO as usual which seems... alright, right?
>>>
>>> Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
>>> for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.
>>>
>>> If we go with the HostMemoryBackend instead of guest_memfd_manager, this
>>> MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
>>> just ignore it since the MR is useless (but looks not so good).
>>
>> Sorry I am missing necessary details here, let's figure out the above.
>>
>>>
>>>>
>>>>
>>>>> We also consider to implement the interface in HostMemoryBackend, but
>>>>> maybe implement with guest_memfd region is more general. We don't know
>>>>> if any DMAable memory would belong to HostMemoryBackend although at
>>>>> present it is.
>>>>>
>>>>> If it is more appropriate to implement it with HostMemoryBackend, I can
>>>>> change to this way.
>>>>
>>>> Seems cleaner imho.
>>>
>>> I can go this way.
> 
> [...]
> 
>>>>>>> +
>>>>>>> +static int guest_memfd_rdm_replay_populated(const RamDiscardManager
>>>>>>> *rdm,
>>>>>>> +                                            MemoryRegionSection
>>>>>>> *section,
>>>>>>> +                                            ReplayRamPopulate
>>>>>>> replay_fn,
>>>>>>> +                                            void *opaque)
>>>>>>> +{
>>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>>>> opaque };
>>>>>>> +
>>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>>> +    return guest_memfd_for_each_populated_section(gmm, section,
>>>>>>> &data,
>>>>>>> +
>>>>>>> guest_memfd_rdm_replay_populated_cb);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>>>>> *section, void *arg)
>>>>>>> +{
>>>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>>>>> +
>>>>>>> +    replay_fn(section, data->opaque);
>>>>>>
>>>>>>
>>>>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>>>>
>>>>> It follows current definiton of ReplayRamDiscard() and
>>>>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>>>>> replay_populate() returns errors.
>>>>
>>>> A trace would be appropriate imho. Thanks,
>>>
>>> Sorry, can't catch you. What kind of info to be traced? The errors
>>> returned by replay_populate()?
>>
>> Yeah. imho these are useful as we expect this part to work in general
>> too, right? Thanks,
> 
> Something like?
> 
> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
> index 6b3e1ee9d6..4440ac9e59 100644
> --- a/system/guest-memfd-manager.c
> +++ b/system/guest-memfd-manager.c
> @@ -185,8 +185,14 @@ static int
> guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, voi
>   {
>       struct GuestMemfdReplayData *data = arg;
>       ReplayRamPopulate replay_fn = data->fn;
> +    int ret;
> 
> -    return replay_fn(section, data->opaque);
> +    ret = replay_fn(section, data->opaque);
> +    if (ret) {
> +        trace_guest_memfd_rdm_replay_populated_cb(ret);
> +    }
> +
> +    return ret;
>   }
> 
> How about just adding some error output in
> guest_memfd_for_each_populated_section()/guest_memfd_for_each_discarded_section()
> if the cb() (i.e. replay_populate()) returns error?

this will do too, yes. Thanks,


> 
>>
>>>
>>>>
>>>>>>
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void guest_memfd_rdm_replay_discarded(const RamDiscardManager
>>>>>>> *rdm,
>>>>>>> +                                             MemoryRegionSection
>>>>>>> *section,
>>>>>>> +                                             ReplayRamDiscard
>>>>>>> replay_fn,
>>>>>>> +                                             void *opaque)
>>>>>>> +{
>>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>>> +    struct GuestMemfdReplayData data = { .fn = replay_fn, .opaque =
>>>>>>> opaque };
>>>>>>> +
>>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>>> +    guest_memfd_for_each_discarded_section(gmm, section, &data,
>>>>>>> +
>>>>>>> guest_memfd_rdm_replay_discarded_cb);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void guest_memfd_manager_init(Object *obj)
>>>>>>> +{
>>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>>>>>> +
>>>>>>> +    QLIST_INIT(&gmm->rdl_list);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void guest_memfd_manager_finalize(Object *obj)
>>>>>>> +{
>>>>>>> +    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>>>>
>>>>>>
>>>>>> bitmap is not allocated though. And 5/7 removes this anyway. Thanks,
>>>>>
>>>>> Will remove it. Thanks.
>>>>>
>>>>>>
>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>>>>>> *data)
>>>>>>> +{
>>>>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>>>>> +
>>>>>>> +    rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>>>>>> +    rdmc->register_listener = guest_memfd_rdm_register_listener;
>>>>>>> +    rdmc->unregister_listener = guest_memfd_rdm_unregister_listener;
>>>>>>> +    rdmc->is_populated = guest_memfd_rdm_is_populated;
>>>>>>> +    rdmc->replay_populated = guest_memfd_rdm_replay_populated;
>>>>>>> +    rdmc->replay_discarded = guest_memfd_rdm_replay_discarded;
>>>>>>> +}
>>>>>>> diff --git a/system/meson.build b/system/meson.build
>>>>>>> index 4952f4b2c7..ed4e1137bd 100644
>>>>>>> --- a/system/meson.build
>>>>>>> +++ b/system/meson.build
>>>>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>>>>        'dirtylimit.c',
>>>>>>>        'dma-helpers.c',
>>>>>>>        'globals.c',
>>>>>>> +  'guest-memfd-manager.c',
>>>>>>>        'memory_mapping.c',
>>>>>>>        'qdev-monitor.c',
>>>>>>>        'qtest.c',
>>>>>>
>>>>>
>>>>
>>>
>>
> 

-- 
Alexey


