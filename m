Return-Path: <kvm+bounces-34890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D2DA06FD7
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:18:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E25AB3A6FBE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD78214A65;
	Thu,  9 Jan 2025 08:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RkCUNXOH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7F51FC11F
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 08:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736410729; cv=fail; b=tMPpRIRlYJk1uG+uaBDMoRKIIV3kEwTKjYy4yNnzpFTjv2t9Lvo1JUD6FabNV1k4jP4LRCIEtolfrejWagZvYjzUzoCf1iZOlLk3YSagzAyh6FA5/0hgAMsSGR4kO1SseQjBowRvKRpk8Q5OuvhqRT6sQSgnuIdGe+z2gyFcCAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736410729; c=relaxed/simple;
	bh=uc/uZB8aRKheN84rjIzo619gvUKoi/MZqu4qWnXW3Hg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VzZEyrByvAW/z7oSVpQJLXzRD6uDELXQmmXxvIgYglU5ZgtopcJ7OCMUcH4OoNeM6kvHAJydsjPYspA0CQ9y7kpUEDR90ZUBOYAp8i4zJXW9q4UIiSRAZ9ZYm32fCuklNsxQT53U7sGlN6m5KW5wJLQ6v+wHSBjDiAyWweTUmKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RkCUNXOH; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=spPc8uAbQoqF3KYEUXC4YAwNuRgE6HLfKQ6NLP/sRGwDJHBoEhilTTXbkRLf4/ObRCnjCpBJy263rl6euxzHaiFjsjB9nsHFkmbp0dQadwt24Tlb3+ZBPE3EeAYuo6nXUx1pEzdUXCS4cTL+ikQHPlNigdEjfhAJuHyIEVZyFCYWTlQHhxMA+AeKk8dJ9lz+2M495HoBD2o/poR7frKYYh5J3Yo4Y6Ntard7tkmAvuXn4P/13U0h0jg7JgrTRo7W9PFNhHb8ds9DiuMYYEwY8lycUz8ey1vuTvzvvFybz+aOBij270WS8kjnBL1oSA3ApHjQYXFRircFwf5qZZreMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vRg2DvYowgPEs13Okt5ks31i9gIXpBUjW4TIymN8nXk=;
 b=gd4iqJyyrDOzazkWm6dtLdn5wtoM6n6EsgnkfbU9/gW2GxNtNydTscQFaVZ26DonADsm/8YEBYb7R2o6CqyrWYI0TvZTOrTsaUGlJfvbKCpd5sT1ppKuI9/o7AOZoiiE4zX0AifsmmwIEv/UPDBr202M6aVrEf7drvTl2klTu/ardGIZEryvBd1caDtOTdxJopY1n9tmfReAOmEpXJkyEakyRLiEg0OjsSFALsAwEhCLhAI6NpiMg1jjItaTx6YVOpI4PnF+PFa4XIPEmIqyR3xaqAciGzf3yRagCeukWqsqs63t2nM5ohxIcw7eV5uGfZdlkhSrNyw+DwQ6NyzleQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRg2DvYowgPEs13Okt5ks31i9gIXpBUjW4TIymN8nXk=;
 b=RkCUNXOHIojf7jZYQQhFhQ5jvPdTd+MkY22DEd1rBfcdYcc0pBek16qTvoxka/0R+G1fB2lEw7mAB2JrpsTJVrrAVXFuS/zqCD5lh6kZwQBSR/WQNO8OBjM9Hs1VICQNTSMnT+zO+ou7o6pmeb8Fim3FjSPM4vS232ib3Hj1Sfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 08:18:45 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 08:18:45 +0000
Message-ID: <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
Date: Thu, 9 Jan 2025 19:18:37 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 0/7] Enable shared device assignment
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
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME3PR01CA0060.ausprd01.prod.outlook.com
 (2603:10c6:220:1c2::17) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: b24687ef-6768-4b8e-b0d5-08dd30863c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3UxSVU5RW9vZlcxZS9wNUNKMUhESzBWN3lnWWFDV3VhNWQwektjSWpsM1o4?=
 =?utf-8?B?SDg4ZXdabXliTjlVVTM4MkprTnNaZkFZV3lCV0Z6dWo3N055TTFNS0k2bGhZ?=
 =?utf-8?B?VXFlNHRMRVRpOWVFZ2dlcllXRGNqRWowMlR6cytaTUoyajJpUXRVL1JNUU5a?=
 =?utf-8?B?SFQ5bVhjbmlZM3BpTy9Jd3M5TkZpbXJOMmFDZ3N6WHJ1ckVHd3Jpemh4OE5h?=
 =?utf-8?B?dGV3RHhDbUhCTU9kT29UZ2tLM3R5ZFhuN1ExUENPNDZZTXpzWC94WGpwK2FM?=
 =?utf-8?B?OWxvb2c3YVZIcFRURUdsTnFxOXFUcjZ3UU53akdnSngzcWdqc3o2YjRWazBv?=
 =?utf-8?B?alZkcmNsMm1ZUTdTajRtVC9UU3pFaVJWQXdqWkk2NHplOHFpUnB4cTZZajEr?=
 =?utf-8?B?VkRsUm1HcnZwaXc2bW5QaFdQTWN5VGhSQm11STBaYVpmTjlleGNKdmFQbUtU?=
 =?utf-8?B?L1djTldZbDByUjB5K096b3pHNGRYWVBjQ1N5RkdmNFhxVXJ4Qys1bkVFRndp?=
 =?utf-8?B?WW5WN3BqWk83Zkc5SzJEYVVXblMyV2Z1NWFjYmpkRmxCMTVBaG9iMzFUbmRh?=
 =?utf-8?B?S3h5OWpsdFJiTUw3dFhvVjg1ZjRUMGk4alFQZzBOUllyM3ZINFBma1N1cFNB?=
 =?utf-8?B?RFVJR0hsZnVnVmdMYVprdlpUampDOWkvTW44QWpLUFJNcGlDTTc4RjlwejBH?=
 =?utf-8?B?N0NqN1RTMmtDb245cUh3Rms1OTFVUUhnaTcxNUNEdU5LUG1DZStKejBGQVBW?=
 =?utf-8?B?bnBJYzNPazFQZXlENXo4enJSZWNCQjg5ZXN5T0h3WXJFSU45NXpoUGJ2NFRl?=
 =?utf-8?B?Qld6dmNMM004eEl0RjJzQUZEUXJadHhwZEFQdUFSclJjK1VwUmFYbGdYbHM3?=
 =?utf-8?B?SVpoLy9Fbzh4VlVDeTZmVmlBL2N6S09udk15K0duNWxJWWJBVlpQN0dIbENt?=
 =?utf-8?B?eGxVbXpOaDZxUDFYdDVBT1V1QUlnT1RuNjI0MVJYSXU0cTJRdGUzSkpJNlFx?=
 =?utf-8?B?Q0RzVE15d1pHMlFZbjRaZ2M4YWRVRzJIWjBJcEVWcnVGbFB3Y3ZYYU1nRDV4?=
 =?utf-8?B?bkk0RG55M2tCZ2xDaFZ1STN1ekprNi91a3pVdXBGa09LSW1BNjFSLzd1aUJX?=
 =?utf-8?B?cmY1VzRTWlhENEdhSXpWYzR6V2ZQN1g3MWxucWl6L243Zy9ycDQvSURqSnd3?=
 =?utf-8?B?QVpudXdkeVgzeDZ2RXdsVjc0SWhxazZ3WlU3cVRiZXBYV1dJZEFyaXF4RWtE?=
 =?utf-8?B?eDJPTEcwZU1tbk0xdmpXSmxUU3I5WFZWSFU1Z0J4RTJtazlJc3FFTkZ4cFhx?=
 =?utf-8?B?QUZOamkrMmVhWDdMcTN4Wm5tUkZvV1R4QWtyYWsyaDE4dGhZS0VJcmhFQmo3?=
 =?utf-8?B?WDJRNTBmZ1RpWnpqalgvMU1qTHBTOUE0dUdGSEFLZjBWMjhVMU1rU1BoZ0pN?=
 =?utf-8?B?QTRrSXhsMXZLWjdKNGZLL2pmbStad1cvNFRPZnJXWCtFR3hmR2JlV2N0KzlV?=
 =?utf-8?B?dFd2WFVnQjVmb09mcVdzUXJYMGM1YS9SL2RqYTRzLzNSenJQWDVtUnNCVlNt?=
 =?utf-8?B?Vm91NXhKT1dCbUUzL3haQVRHUDQ5R1Vxd3Jhci9Vc3d0YVJ6SUpaZGNNN2Y4?=
 =?utf-8?B?SVBGOWVSaW5mUmJKaGd1emF2UEhRSzZ0ZDdTWlZNNWo3aGpRRDVxQktHNTF5?=
 =?utf-8?B?TGJIU1ZzYkZMVnVmdmZHVXliMFRvZVR3bDRWbjRjRGF6YjQxY3ViSUtBS3Zl?=
 =?utf-8?B?b3FmckFjaDdxZ242YXUrYlp2SkE3ZEw4RTdDdzlxdTRjeERtZUhmNmEyK3Qw?=
 =?utf-8?B?R2xqc2Rwd3FvdllidkNKUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWNWSmhUQmowdVkybkNyS0ZjWEZPdmpRZFg0YzBRTmNMQzZHdTN3L0NtYVNJ?=
 =?utf-8?B?THBQbUJieDVFbTBFYmkrOVlrWExmNGdkNFRZN3NvQUVTR2RWTi9ZamJmbjB3?=
 =?utf-8?B?eGtBUTI0Q3ZhQTA3a3YrY0luNkhWTDE0SkFrekJ1SWtuNks2VDlyWjJ3TjhP?=
 =?utf-8?B?Z2VBSU1vM0hOa25vTlZZQ0FTNHdQR2VVTmIxdkJjb2d2VDErWlUvTGV1cUl0?=
 =?utf-8?B?SnZWcURNL2pSYXplTXlUZmFIR0hxRTFLcllsaUQ4UzNNVk5pRW5VYkcyalRy?=
 =?utf-8?B?ZXdnZ1RSL2JJc3lNdkxZL29YUUIydXozYjJOTmttdWxQT0tDZTZDc1RVaVp3?=
 =?utf-8?B?aWhTTFRralgrcDZiVGI1SlVtS3hYUkpuSU9LL29QVEl2UnFHR09vTFFWRzYy?=
 =?utf-8?B?NlVsT3J0eVNzYnFmaHpJam01NFBQYjdoRDJwcFdyMGEreENiTlFwMlFHN1BZ?=
 =?utf-8?B?TkJzdy9KckpxNC9aM0lwMi9IeGpIOWcvWEdid0hSZnA3aEl0N0JWUTRKVFFa?=
 =?utf-8?B?djIyWXEwUVN2RS9WZUNnVFl4dEFBSzZXakM0NGxyVEQzWHRERWhqQyt3alpD?=
 =?utf-8?B?eklMRkxSVCtValpLYlZIZkRmRjdKNm5ISjlhaDBQN0lucTdXeHhNc0VsUThq?=
 =?utf-8?B?d2tjUDFkMEZrcDFnU1BoRDYvNElId0pmQ0RDWm42R3FwZ0ZIc3FqdG1oU1RT?=
 =?utf-8?B?c2J6b3hTa1QzU2IxOXBZUmJGREczN0RkNWlrSE5Gb1ZsMWZxellwSVJ1V0FU?=
 =?utf-8?B?MDdoZ0pIRnVkaDVrZitxV3ZtR2tzcndxcTZWSmtBQnhXaC9xK0Y2bFdmS0xv?=
 =?utf-8?B?UUtnT0FOSEJ2dzR2UVV4T1lLV0oxRndRRk1sSUpKejZJaWtaVU5jcVROcjVx?=
 =?utf-8?B?MnBFODRkUDVMdDZxUEw2UTZFQlJvZHQvTHZvOTRscHUwLy9LZTUvc0RuY1Nw?=
 =?utf-8?B?c1VreFkrRkVISTNiM3pEa1F0c3U4MDNnSlJtT1NkZVFsbktZTDlNR1pCTjhu?=
 =?utf-8?B?akI5VnZVd0Q5UHpzM3BLNVJMRFlQb0pFaVZ1RlpCaDJrTEZnUmViOEFLM01u?=
 =?utf-8?B?ZTlUYUFQSktlOFhXOHZFaXRmbXRwUWZXOU1WL2VWL1BwTkVyVGduVVBZU1hq?=
 =?utf-8?B?ZnV6ZmxOQnU0OGlKMXJKeEF0cEkzcW4rY2NuSGV4MktDZFhDZStSNjNaN0V4?=
 =?utf-8?B?Z1lPNkNoSVYrR0N4cm5WUnRXOEhlZ0krSTczYlQxS3hYM2NYWms5ZFErSDNy?=
 =?utf-8?B?aWo4M2lGMlVmSllGTnFyckJCM1RmYUxmdzlyanVxWEU2QXFUUkE1c0xLQVds?=
 =?utf-8?B?SjJjVklNSFgySjBUaktJSEw1SWhmdm5KaDNKMnRqaVRWelowNU1CL0VRaFFh?=
 =?utf-8?B?ZkNqaHN6eGRYN2pnV0dUSHlnc2U3ZmpTdThDY29jOTl3ODJJWEhwQnN2MzY5?=
 =?utf-8?B?VFc2WGIrTHRWaDBhSTdReGlpc1lsbnNMbFFwQ2YyZjF1NVVRcW5BaXl5NEw1?=
 =?utf-8?B?OWtXUmRqSmR3VmZDeS9TS0RVbmhkTml5OUpib3RobnFsaklkZEJUWXJ6TXBH?=
 =?utf-8?B?TjZjUDZ4dmFnSUdNenpNMUNFY0kxR2U3Zk1iRHNWc2l3a2lva3Rlcmh3MGZ3?=
 =?utf-8?B?NVU5N1hIc2VhSlhjb1I2aFlVaDl4cjAwaEc4c2Rzek56YkhDY3J0U1hWVEtM?=
 =?utf-8?B?NkE4c1AzKzU3dFo2bXRPd1Q5MEFrall0eHJYck5YOUN2bjNES1dpZ2txUkNM?=
 =?utf-8?B?ZTBOVXovSHJPaFpJSk5MaXl4T2t3Y1B5TTZjTHY4bm1PMzYxYVRqR0I5bjY0?=
 =?utf-8?B?ajdmaVNRTXlndUR5a2JwT0xTTUpiV2ZEUzZ1dXBZRzYwcytEUkJpc0FUUHd2?=
 =?utf-8?B?Tm1wVzZhLzFaR2dzd2pSem1yWjRlWWg4NHgrV2VXVHlFT3F0Y0w5MFhLaFZI?=
 =?utf-8?B?MmQ1VWxlTkdsdHpvd2huejVzYUl2a21mNXMvSVJsZHFYTllHdWN6cmVxcVpJ?=
 =?utf-8?B?SEFJak4yVWd6N2lDMjRja1JCT1BYM0lCYlJZSUV0S2ErMkI2ZVVycVEzV0dn?=
 =?utf-8?B?S0t0OTZBWGRWK2lCMjJVVEFPQWxZSDNpNStjZk1OT1dELzdRMUpKbmpmNHA3?=
 =?utf-8?Q?8CZP0RlC6/qVwCUT0FfLnfgCC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24687ef-6768-4b8e-b0d5-08dd30863c08
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 08:18:44.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JRvrkvA0SOurYxm5OahgIkEjIv+LOBHNSG1P5cSlopEd99WRUppTVZx/C36RRAnG/UTl9OSV7qR1qYRzrUcxsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572



On 9/1/25 18:52, Chenyi Qiang wrote:
> 
> 
> On 1/8/2025 7:38 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 8/1/25 17:28, Chenyi Qiang wrote:
>>> Thanks Alexey for your review!
>>>
>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>>> discard") effectively disables device assignment when using
>>>>> guest_memfd.
>>>>> This poses a significant challenge as guest_memfd is essential for
>>>>> confidential guests, thereby blocking device assignment to these VMs.
>>>>> The initial rationale for disabling device assignment was due to stale
>>>>> IOMMU mappings (see Problem section) and the assumption that TEE I/O
>>>>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-assignment
>>>>> problem for confidential guests [1]. However, this assumption has
>>>>> proven
>>>>> to be incorrect. TEE I/O relies on the ability to operate devices
>>>>> against
>>>>> "shared" or untrusted memory, which is crucial for device
>>>>> initialization
>>>>> and error recovery scenarios. As a result, the current implementation
>>>>> does
>>>>> not adequately support device assignment for confidential guests,
>>>>> necessitating
>>>>> a reevaluation of the approach to ensure compatibility and
>>>>> functionality.
>>>>>
>>>>> This series enables shared device assignment by notifying VFIO of page
>>>>> conversions using an existing framework named RamDiscardListener.
>>>>> Additionally, there is an ongoing patch set [2] that aims to add 1G
>>>>> page
>>>>> support for guest_memfd. This patch set introduces in-place page
>>>>> conversion,
>>>>> where private and shared memory share the same physical pages as the
>>>>> backend.
>>>>> This development may impact our solution.
>>>>>
>>>>> We presented our solution in the guest_memfd meeting to discuss its
>>>>> compatibility with the new changes and potential future directions
>>>>> (see [3]
>>>>> for more details). The conclusion was that, although our solution may
>>>>> not be
>>>>> the most elegant (see the Limitation section), it is sufficient for
>>>>> now and
>>>>> can be easily adapted to future changes.
>>>>>
>>>>> We are re-posting the patch series with some cleanup and have removed
>>>>> the RFC
>>>>> label for the main enabling patches (1-6). The newly-added patch 7 is
>>>>> still
>>>>> marked as RFC as it tries to resolve some extension concerns related to
>>>>> RamDiscardManager for future usage.
>>>>>
>>>>> The overview of the patches:
>>>>> - Patch 1: Export a helper to get intersection of a MemoryRegionSection
>>>>>      with a given range.
>>>>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>>>>      RamDiscardManager, and notify the shared/private state change
>>>>> during
>>>>>      conversion.
>>>>> - Patch 7: Try to resolve a semantics concern related to
>>>>> RamDiscardManager
>>>>>      i.e. RamDiscardManager is used to manage memory plug/unplug state
>>>>>      instead of shared/private state. It would affect future users of
>>>>>      RamDiscardManger in confidential VMs. Attach it behind as a RFC
>>>>> patch[4].
>>>>>
>>>>> Changes since last version:
>>>>> - Add a patch to export some generic helper functions from virtio-mem
>>>>> code.
>>>>> - Change the bitmap in guest_memfd_manager from default shared to
>>>>> default
>>>>>      private. This keeps alignment with virtio-mem that 1-setting in
>>>>> bitmap
>>>>>      represents the populated state and may help to export more generic
>>>>> code
>>>>>      if necessary.
>>>>> - Add the helpers to initialize/uninitialize the guest_memfd_manager
>>>>> instance
>>>>>      to make it more clear.
>>>>> - Add a patch to distinguish between the shared/private state change
>>>>> and
>>>>>      the memory plug/unplug state change in RamDiscardManager.
>>>>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>>>>> chenyi.qiang@intel.com/
>>>>>
>>>>> ---
>>>>>
>>>>> Background
>>>>> ==========
>>>>> Confidential VMs have two classes of memory: shared and private memory.
>>>>> Shared memory is accessible from the host/VMM while private memory is
>>>>> not. Confidential VMs can decide which memory is shared/private and
>>>>> convert memory between shared/private at runtime.
>>>>>
>>>>> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
>>>>> private memory. The key differences between guest_memfd and normal
>>>>> memfd
>>>>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner
>>>>> VM and
>>>>> cannot be mapped, read or written by userspace.
>>>>
>>>> The "cannot be mapped" seems to be not true soon anymore (if not
>>>> already).
>>>>
>>>> https://lore.kernel.org/all/20240801090117.3841080-1-tabba@google.com/T/
>>>
>>> Exactly, allowing guest_memfd to do mmap is the direction. I mentioned
>>> it below with in-place page conversion. Maybe I would move it here to
>>> make it more clear.
>>>
>>>>
>>>>
>>>>>
>>>>> In QEMU's implementation, shared memory is allocated with normal
>>>>> methods
>>>>> (e.g. mmap or fallocate) while private memory is allocated from
>>>>> guest_memfd. When a VM performs memory conversions, QEMU frees pages
>>>>> via
>>>>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>>>>> allocates new pages from the other side.
>>>>>
>>>
>>> [...]
>>>
>>>>>
>>>>> One limitation (also discussed in the guest_memfd meeting) is that VFIO
>>>>> expects the DMA mapping for a specific IOVA to be mapped and unmapped
>>>>> with
>>>>> the same granularity. The guest may perform partial conversions,
>>>>> such as
>>>>> converting a small region within a larger region. To prevent such
>>>>> invalid
>>>>> cases, all operations are performed with 4K granularity. The possible
>>>>> solutions we can think of are either to enable VFIO to support partial
>>>>> unmap
>>
>> btw the old VFIO does not split mappings but iommufd seems to be capable
>> of it - there is iopt_area_split(). What happens if you try unmapping a
>> smaller chunk that does not exactly match any mapped chunk? thanks,
> 
> iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
> iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
> disable_large_page=true. That means the large IOPTE is also disabled in
> IOMMU. So it can do the split easily. See the comment in
> iommufd_vfio_set_iommu().
> 
> iommufd VFIO compatible mode is a transition from legacy VFIO to
> iommufd. For the normal iommufd, it requires the iova/length must be a
> superset of a previously mapped range. If not match, will return error.


This is all true but this also means that "The former requires complex 
changes in VFIO" is not entirely true - some code is already there. Thanks,



-- 
Alexey


