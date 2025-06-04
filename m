Return-Path: <kvm+bounces-48456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CE8ACE715
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 01:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02ACC16EB53
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 23:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E232701D2;
	Wed,  4 Jun 2025 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZegHfidf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2047.outbound.protection.outlook.com [40.107.96.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC20D26C3A0;
	Wed,  4 Jun 2025 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749078751; cv=fail; b=EIc77dAe12k3O2tA3T0J5fWfHe0T11iEfv9v2ho1TIA9KbeeBZZZHtj+5wj+BR5f+oKjpBBDGXWjFKkxwguD1uJV4p0LrC0jo8IOACuoct4Xj/vLSkeVOQmXUNXrXVPcSJLi8u2rKUlk9/qFyNzVd/XvyhYHyQI2NWu1gFYBwDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749078751; c=relaxed/simple;
	bh=ZtP6ufy5up2Yi6HN3RGsmRXDgOqhvK57McJHydcGIHM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FvW3UGUbPWm2lMmQHS7KnYGi/gaVXK9YVXYydViwxD+9zJiCGxa6YS1GKRXXRABkFTamUxAO7FIk0vZ70A9QwMzgH5gYswtiYswdr0v17ezLl/0Ydf1FP43rWVR7opMyywxqJtID9u5BkHw5cTk45E4JRkr5Dq7KgPyggTatKgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZegHfidf; arc=fail smtp.client-ip=40.107.96.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XFbCye5xLFlzu1Yv+pEqR0FlmclYz33bLVD6ZiIonYgHMk6+DJPlBF+2F9kYWa4Y5TH7MwOx6rCpz6hJPTxQkAiERrwI2X5lmEmDhhA761nYzQfUS6Y+76k5jxKn0h4lzGGrefVc8H86CeLZn5aEF4s5vQ5rlxuhU01GZez5xx/mf1naM5lIY/T8kOZUNfX87IW8FTvlGjcWvQxP892NsUc0jzrpVG+PpOFYbiQ4PXS2n3yRn+w7HtkmmL3G80z4Ro4oXwjXhk+ZLFaZ7E5+vQt/cPoF9ttgH3kHERPwIGEUGHWpgVs0LYpv5BZ36KgCJkU7Niv60D1WlZQnbCYqrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEZJv/fgitPYJZtXiyUAYHPX/Yj+WWnai+POfNJVTYo=;
 b=yMhQ8ogp1d//YPs8ILroSOsYogiA/H72d6wwoe9ja+Pofl/EmpLGG9JX5pDApnehg9FxFGeI93CadYjKFTkRRBa0Svh1zI+ARtSRT2h77XMSfOn57VjdtcOhywlLzWFO6ht6p6kZ/ymqap86HgHgmilfIfhUkZxpmP24tecuJLVaNmuy3shZzYNPXfKMSq6kNW1ky+4ChHmgZbToS9KNaYCoe5l4Bq98WJJdlG8sHtlJfC3sQdM8EJAdYOzoeeyuneD2ajdCkW73vvRA67R6vVmTd8QtCCpTLcNQ+844fmyusz55NpexV5eKPHHJeLOBWS+NfLg7yBJbthvZNbehaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEZJv/fgitPYJZtXiyUAYHPX/Yj+WWnai+POfNJVTYo=;
 b=ZegHfidfgOvdJEUjJaMdiIJeGvtAc/1rMth1R+7zaaf4sJEDgwugCGw5iDCpJ49StvMQaEqX9mrye2UdJ4Zmy4rjdqCKUV/RyzvQ1ErXJJjF3Qh+1rOidSMHwUUvxwBH+30M15TaohwCQw851iItwuGosDnJoO0JvXybJ5OIrb8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB8070.namprd12.prod.outlook.com (2603:10b6:8:dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 23:12:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 23:12:26 +0000
Message-ID: <f4f9a3cb-eb8e-4d7d-8fe1-5cceca5507c6@amd.com>
Date: Wed, 4 Jun 2025 18:12:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] KVM: SEV: Introduce new min,max sev_es and sev_snp
 asid variables
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <0196b4b50a01312097a18bc86014d9f47c22e640.1747696092.git.ashish.kalra@amd.com>
 <1905a57f-3a0b-7106-111a-8231a6ec9380@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <1905a57f-3a0b-7106-111a-8231a6ec9380@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:806:d0::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: d31672d2-a3c4-4ba2-7478-08dda3bd44fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUxiNm93R1hFdVdGWmo2MUN4WDJxcXcxRXVjc09Mb0ZQdzBSaytmYU9NYlUz?=
 =?utf-8?B?TFVCVVhPU0E5R2pFeWNINVM1dnpvRmRyTDBkSDB0cFRnKytZaDIwaXZxMHVm?=
 =?utf-8?B?TGtLb0p2RTFGTFdyQXVwYlVRRUFiblN5c0VsRUp5ZFNxT0ZhNisrT1ZMVkd6?=
 =?utf-8?B?OXNXVFlYTUtZTnR3cncxNTRHRzBoT0c2dUE4VWF2Zi9hdHZ6S21nTVhYK2ox?=
 =?utf-8?B?Y2p5ZVBVWksxQ3lFWm9BdURjTVltNUVJMjhFQWs5NWtaRzlycEVCSGN0aGln?=
 =?utf-8?B?RTJybHIraG5maDhYQ1VWU0JuL2FjWEpvaTRYQlZld2dOQ2taenZTMDZCOVRS?=
 =?utf-8?B?MGtVT0dialdNaVl5RkxqUjNiM2hzbTN2UGEwQXNGZi9WYzh5dEFFbkZ2TGY0?=
 =?utf-8?B?ekdDdk9XVlZtdFZ3S25QVUJocjNhVUlXeS9UeDBIQ0xTbmZMMzF5WTNKVERY?=
 =?utf-8?B?ckFURmVnMVFXS2tVcGMraWQyOVhubGh0YzlzeFRKUkdpMkxiczUrbG5yemRa?=
 =?utf-8?B?R1hMRCtMOWNVZkM2WkRHR3VvdGpjV2F0aWNzWkFRVUxONUcxUFZlWTF2Y2VE?=
 =?utf-8?B?VFpqMlVVV29tMU9ZUVNZRXRCWnk3WW81MGVEZVNTa0tVRkYveWluMXVva1E4?=
 =?utf-8?B?bDBsUEQwOUZ0U1RhdytDbHVXVGVtalNScklCa3BpMzRhdk9udVVJdHFOdUNW?=
 =?utf-8?B?cXlaRklMQmNPMk12Z2M1eFJsL09CK243dzJxSGw1RmR1cWVteGhYRVZ3R0J0?=
 =?utf-8?B?RmpEN3FYMzlMdlVmbGxqd1BMa2pFU3Eybnh4RjRuTXQ5T244UkkyVjFpbEQv?=
 =?utf-8?B?TFpwdndtMVV4b2ljWmI2bU1CbG44WHF1cUVRdkR2L3p3N2RsTnJvSG0vVFNr?=
 =?utf-8?B?NnBhZ3Frbzc4N2ZkN0hDNDRXWW5QWEZyenFCZzBuY2lCOVNyY3p0SjZBeXhC?=
 =?utf-8?B?VGJCbURxVkF4bWw4d3hQZHRMYkFTUVRiNHgzTi9hZHFVR3dMbUZhb1l0TURU?=
 =?utf-8?B?UEpIUjBJeit5S2YvUFJ6bmFNU3JjOWdML2Vsd0FEYk9DbWFiM0RDOFhtNDRq?=
 =?utf-8?B?TndENS9CUmxhYUJxcGtKV2dWMDNySldhZHgxc1RyNUlJY1ErbUdnYlJmZDRE?=
 =?utf-8?B?dktUWldyMHIxeGRvdFRMdnhabVVpT05vY3hPTS9XZ0swcTdqSy9HUXFIUDBG?=
 =?utf-8?B?eFFzTnFFK1dzRlRpU0ljWDRkWEh5S1l0TlRpMi9IMHJaK2QwdVRaakdRRnBw?=
 =?utf-8?B?MDVzckE5MzFBM1RBbjcvMGk0VHNxWEN6d1BJbXdseXJ1RlRWS3ZadmRxekJt?=
 =?utf-8?B?N0l0alo4aGx4TUhNd3BMbCtONlkrQU8xb204Slg4dGRnenZyZ2pUeUp2SzFl?=
 =?utf-8?B?VnBwRE9iRVpGZVZ0eUJhcjJEYUN4d0owckhVV3FDMFc3V0pYQlZ1cElVOW5y?=
 =?utf-8?B?b1VEZ093cE5OeHJUNzBtaytONEFZc0xBcHhBRTdrSlhCdVQ2bFBVNGJtZFpQ?=
 =?utf-8?B?T09XVTNhUmlVNitCd2NVSkRVZjM5TncvbzQ3Yy85S3pkSTE5TWFDS0NGTlUy?=
 =?utf-8?B?V1lncGNsMjZ3VFkrSm9pZGgvZFRjL3F4L3NWSGtTdzBkazJiWHdISXFUMjZo?=
 =?utf-8?B?Q1Y4bkVuZUpjalUzamtYY3BmK0hYZnR1Y0tma215Ri94UkVlTTBDQ2JtUEpp?=
 =?utf-8?B?SnNMaStIWlNrSEpZTURmYzgwenlvWmdSbTVCRFQ3WGpRNm1lei8xejQzSzVj?=
 =?utf-8?B?VjhyOFdFeFBHQm1xcW4rRWVvRkszcHErVWVlMTE0ZXlYSEp3WCs3blptdGxB?=
 =?utf-8?B?Uk1HMzFPaGV4ZjY3UG95c2lydGNRNFZsZ1dNZDF0bVQyYisrNERkSFRTVmpm?=
 =?utf-8?B?U21yeVhWekRXUTgyUWdGblRoSXF4MTg0ZFRHaDBld296eitET1dPd0N3L1Rv?=
 =?utf-8?Q?PPCNiJfeqok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmRTdzVzQlRZc2duMTYxR09jTzVhVk5XRDlGRWJoZjB1YzByUmUraEFibG1r?=
 =?utf-8?B?cFNQd3Qza3h2RDRQL3paZXZ5Z1pWNW95T0NieHdrVWxTYmZHT3pzN25velJB?=
 =?utf-8?B?TTNzU1Z4TE1UMk54L3lDcDZOcEpTbmhEZmJZczhDdzErZlVabnFuRWsrbTNF?=
 =?utf-8?B?cTlkdkhEZmgrTUkvTjFhcDVMZitERExlRHVEU1g4VllFQzArWWoxdkRIV3NU?=
 =?utf-8?B?cTZDWVF1RGQ1N0t5L0Q0TExqSUlRRk9JSjFOMXlJQUF0bFE1VlovRHNEQ1M3?=
 =?utf-8?B?Z0tQWGtxNFAvbDd3eHd0c3NZMXVMdjlUdWwwei9LOFpKTXo3VmMwSWZoK0hT?=
 =?utf-8?B?SkNRTjZtNTlRMkZVU1ZjdncxU2VmYllUN2dYVDFWRXZlWVFkelNGclVVV080?=
 =?utf-8?B?YUUxWTV0UFV3dUs0YVoxRjkyU2Z6UjE4U0t0S1BSM3JaQVlFU3BHL0hPNXV6?=
 =?utf-8?B?ai9OSHdtQ2VodzNkNEl5M2d2WmxiL05iSmFzdG9ycldJYWw2RkZKdURSR2hL?=
 =?utf-8?B?OHQxUGpJS2wrR2xER1FCbndDSU14YVlETFdoQlpPb21jQUNrSnFlVHpFdFJ4?=
 =?utf-8?B?QXJCUzNuUHJxdzNtRFlyNURpTlI4VnNUMUlTVWw0MjVUY0YrLzJvbnBkL1Z5?=
 =?utf-8?B?M016Mlc1U1dlVEx1d2krN2RJaEJVWWNucGZ6N0NmcHhrMHp6VG9wdE41eFY4?=
 =?utf-8?B?UElIcVM2dWhWZEJpVkJkYS9Ic2lWRll1WllWbkFaNFVPTFJTNWUxa0JEY2lm?=
 =?utf-8?B?Yk53RzdHSTNHbU5pclVPVUtrWU1Qc3VpeE9pQm9nbGk1L1g4Q0txV1dnTHgy?=
 =?utf-8?B?TjgveGZyQXFjT3ZwOG9GODBqMllRWlBTWUZWY21nc0w3VWRVd1VBWC83NG9X?=
 =?utf-8?B?T1htdDJKTldhMTJjbno1SHNKczdoUUdnWkxEOTBmSmd6Ym5YSWJLaDJkenJ6?=
 =?utf-8?B?eGxCbS9OazlCY0VoK3lyOTNVVXZ6OGRnWUlucFByaGRmcGt0OE9sc0JyNjFh?=
 =?utf-8?B?a216VGFDSzUxUUZ5MjM3bXhRWmRWWEx3bXgyZFZPVWZnblRpNithb3RSQWgv?=
 =?utf-8?B?ZFVFTnBJVTBFa3h3VGprRXJpa2NkWkVSUDU0MEcwTWlnbXdsWDU5aEFMVCs1?=
 =?utf-8?B?ZEFuTzZsK1U1SmpnZ205dlJGVTUxMi9oYktpd3Z2b1doMVJ2VlJLOG0vRGZ6?=
 =?utf-8?B?bkZnWU5QdmNHUGJkNEk1aFNmL3Y1SS9nc1JkcjlHanY1S3g4MTVZMWIxalFk?=
 =?utf-8?B?c3lkL2ZLbXRYWS9HNUNSYzJPQnRQQnEwMDlVS05TUkVsUzdYNFFtUU5JOVFt?=
 =?utf-8?B?OXI0cWZuNW5talk1YkljMUVTekZwRDZjUmVaMXJ2MWN6eWhiNUJZbVNmMEg5?=
 =?utf-8?B?MzhMUFp2by9NOWpwK2traFJSVXpXc3JUSXVLZHFBZW9qQ3FIRXZ4UFBwcjNN?=
 =?utf-8?B?YnNIZTl4L2hNLzFKSktxdUNwYS9menlld0NiZ1grMjEvc1pLWU9NeTZEUmJF?=
 =?utf-8?B?TGhlR3BucVI5WW5LSHJ4YkNTYkVBa1ovK3ZyTXgxZkp6WVhDeU8ydm5BWU9O?=
 =?utf-8?B?cWp3Unk3TFUrUU80OXdYUGRkcThNSmUwUWRQQmhoYWRaeitVbXJIblFLZC9p?=
 =?utf-8?B?R1pHQ0dnZ0ZVdVVnQTFtbWhuMFE0RVhWS3hyQWVudENHM1R4blRpaHlwWmdW?=
 =?utf-8?B?Y1N0NjZjSXl2UkpTOG9lTEFGZ3N3b3Y1c2dncktZTmdFSTJIY1ZXb2w5NzhD?=
 =?utf-8?B?ZXhZcjdmbmF1TkpZc3dPOTFVYVdiclYyenhtQzNZVEkreE5BV3NDYzdXVlJu?=
 =?utf-8?B?UlNKdnZ2azZnMmgxWjdGRm5ydEExZDFYQlRZRHp1V0NkZnd2bUpmNjgrdEc1?=
 =?utf-8?B?OHJkazFJcFdZVzZqa1BLY1E4R1dNRmNFNzhTVWdCem5ENXlGR1l4dE5VeGFV?=
 =?utf-8?B?bEhKUUs3RlFzb2owTHY2WVZTVXdwWjhRSXB4cTA1TWdFc2VkOTg2U3RSbEh6?=
 =?utf-8?B?TDlPekhFbjBNMlFneW1pTXcrVmpEZGcvMXkwb1dWOVR6dkVYN0hnVGd0dFh3?=
 =?utf-8?B?NFA2aFBZQmpBRitGZ3FCS0U1N0NTYVRWWThUMXJFYW43dithZ0tkaEFLK3U0?=
 =?utf-8?Q?44/hV3agV15X7pL0GdtkxzCyR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31672d2-a3c4-4ba2-7478-08dda3bd44fa
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 23:12:26.0661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82bP7VuZjrhYrUwrUH6mTMN433KhI0PtLP34gHU0bD9JLsX0L4BUkrTR0xsSFYZXSeu1pIylFZQ4RgusdLPrRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8070


On 6/3/2025 10:52 AM, Tom Lendacky wrote:
> On 5/19/25 18:57, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Introduce new min, max sev_es_asid and sev_snp_asid variables.
>>
>> The new {min,max}_{sev_es,snp}_asid variables along with existing
>> {min,max}_sev_asid variable simplifies partitioning of the
>> SEV and SEV-ES+ ASID space.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 37 ++++++++++++++++++++++++++++---------
>>  1 file changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index dea9480b9ff6..383db1da8699 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -85,6 +85,10 @@ static DECLARE_RWSEM(sev_deactivate_lock);
>>  static DEFINE_MUTEX(sev_bitmap_lock);
>>  unsigned int max_sev_asid;
>>  static unsigned int min_sev_asid;
>> +static unsigned int max_sev_es_asid;
>> +static unsigned int min_sev_es_asid;
>> +static unsigned int max_snp_asid;
>> +static unsigned int min_snp_asid;
>>  static unsigned long sev_me_mask;
>>  static unsigned int nr_asids;
>>  static unsigned long *sev_asid_bitmap;
>> @@ -172,20 +176,32 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>>  	misc_cg_uncharge(type, sev->misc_cg, 1);
>>  }
>>  
>> -static int sev_asid_new(struct kvm_sev_info *sev)
>> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>>  {
>>  	/*
>>  	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>>  	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
>> -	 * Note: min ASID can end up larger than the max if basic SEV support is
>> -	 * effectively disabled by disallowing use of ASIDs for SEV guests.
>>  	 */
>> -	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
>> -	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
>> -	unsigned int asid;
>> +	unsigned int min_asid, max_asid, asid;
>>  	bool retry = true;
>>  	int ret;
>>  
>> +	if (vm_type == KVM_X86_SNP_VM) {
>> +		min_asid = min_snp_asid;
>> +		max_asid = max_snp_asid;
>> +	} else if (sev->es_active) {
>> +		min_asid = min_sev_es_asid;
>> +		max_asid = max_sev_es_asid;
>> +	} else {
>> +		min_asid = min_sev_asid;
>> +		max_asid = max_sev_asid;
>> +	}
>> +
>> +	/*
>> +	 * The min ASID can end up larger than the max if basic SEV support is
>> +	 * effectively disabled by disallowing use of ASIDs for SEV guests.
>> +	 */
>> +
> 
> Remove blank line.
> 
>>  	if (min_asid > max_asid)
>>  		return -ENOTTY;
>>  
>> @@ -439,7 +455,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>  	if (vm_type == KVM_X86_SNP_VM)
>>  		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>>  
>> -	ret = sev_asid_new(sev);
>> +	ret = sev_asid_new(sev, vm_type);
>>  	if (ret)
>>  		goto e_no_asid;
>>  
>> @@ -3029,6 +3045,9 @@ void __init sev_hardware_setup(void)
>>  		goto out;
>>  	}
>>  
>> +	min_sev_es_asid = min_snp_asid = 1;
>> +	max_sev_es_asid = max_snp_asid = min_sev_asid - 1;
> 
> Should these be moved to after the min_sev_asid == 1 check ...
> 
>> +
>>  	/* Has the system been allocated ASIDs for SEV-ES? */
>>  	if (min_sev_asid == 1)
>>  		goto out;
>> @@ -3048,11 +3067,11 @@ void __init sev_hardware_setup(void)
>>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>  			str_enabled_disabled(sev_es_supported),
>> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +			min_sev_es_asid, max_sev_es_asid);
> 
> ... so that this becomes 0 and 0 if min_sev_asid == 1 ? (like before)
> 
>>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>>  			str_enabled_disabled(sev_snp_supported),
>> -			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +			min_snp_asid, max_snp_asid);
> 
> Ditto
>

Yes that makes sense.

Thanks,
Ashish

 
> Thanks,
> Tom
> 
>>  >  	sev_enabled = sev_supported;
>>  	sev_es_enabled = sev_es_supported;


