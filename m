Return-Path: <kvm+bounces-34898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0216DA07185
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37D523A68D0
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 980832153C9;
	Thu,  9 Jan 2025 09:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b1057PRI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F221506D
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 09:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736415173; cv=fail; b=u0F7hgRgdc/yPfhqs5n5C2tcjSZcOWHmckf4kgr19YSXFOLEN54DAfllSH9/CJPM/W4Le0mDqthFJtmQV7x4H9eS6Zlk+eC+Nn75UAnzGGsidx7fMTcns6vAzeb+8r4EPRu+lIDEWy4GOrfqKUY2x+gxwzPR1fiIxWtHSWwreXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736415173; c=relaxed/simple;
	bh=oQkd4lQJiKnuzKVz+VlbtBTRD5vzbngUJforXjRsEH0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cBaY+0iel0XhLbeqW+jCthMhNKGyT+CaTO8w+raDTX1ckWgTBj+Ei5JFfcqcZuQ+UulFNq4jKk31GgtWJqR1M6pADLfdrU5s7oZvbEbUJ/9ZwJF/krYHFBCK9ux16qkmXjQu2LTUfOP8YCGXMZ1QP8dlqZh+GdFAi7ZXTHyZXkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b1057PRI; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3AI3WWaPGuyt8pLcamBxP8fLWI4YXwE5zXizIh79T+4a8AxnaFB+1h+iESNVPbaEi83Jc8oSyzrYNJESDdUBHe4LAhxrt6y2+H9Zaeo7xvdhZd7AU3Zbexok4PHnutOeRBCakTKn6tfQ/AuTIqvMxbuffW66HfkGIZFynsk4gUCEZd0GwH6MC27tVLwelMtf2H5EkL5Yb/HgDtW0nI+nQwTCoN7QWfafr561tpLRVp9n7NRLlnMDbPjTPm3SWP30U7Lo0HppyZk/zPzEvRMH9AxfFKhaBLitGwrLyR5VIhXh7kF0fh28NHln3G5ueLRouZvaNvJqad3sMDSMvGWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7w14/hIupo7sJ6YqIfugmYNnu7xb4I+a3wuGu+fvWy0=;
 b=DR4NMFyQb5LR5hPUVmoOHEeenRarEiPH3MMPVxCJT41q065xmD8NCHfqJ/6yrmG+AUAozLT3mxDo8rM5EwwwP6Yw0XDQG1LgKhAxP9N1xH6QbBIufOn1W11XDTQW/3m9/vgRabbZLLiydjt6FOrKNGVe3GUg/vsdFYAb45QrHGcaZ5So2UKv1DR6XYsDmoFF8jZIIZ2OnWny0seM0x/xHr2Kms9z3ChnZIfQFRW/cpBIvdqme1D55XhbfETgD5U/dmJhtQZLqw4h5cChtwXzSj4Prl0YgI805XbS02tMluI0MzCQGrlhpfAKPX1IIilRlBVZsTjy2hAZKOCYDpAgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7w14/hIupo7sJ6YqIfugmYNnu7xb4I+a3wuGu+fvWy0=;
 b=b1057PRIY7o9Qbeg4/kHxEl4DNZkHegtnyi71+6Rw0w4stY3mrWbGFuAxuv3+yanXqT5DTnOBw1fi0InJY1hR5KCbhNeHCLeiVPkyxutQwlSg6FthWIO7pSWoL1YZ1ezl11UfDuM/ihWrz+m1pW4xeMMwQ+AKktJxPGPMtwCeAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH0PR12MB8508.namprd12.prod.outlook.com (2603:10b6:610:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 09:32:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 09:32:49 +0000
Message-ID: <09b82b7f-7dec-4dd9-bfc0-707f4af23161@amd.com>
Date: Thu, 9 Jan 2025 20:32:40 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
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
 <20241213070852.106092-6-chenyi.qiang@intel.com>
 <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
 <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <5c999e10-772b-4ece-9eed-4d082712b570@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEAPR01CA0099.ausprd01.prod.outlook.com
 (2603:10c6:220:60::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH0PR12MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3b2e78-4442-47eb-e9b6-08dd30909500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGdiVmNTVlRqQ0IxaHMvRkJZQ1oxS2o3QW1Oa3FwRVVKMGFScjNlTzZBQk1H?=
 =?utf-8?B?THJTdWQ1eEJnR0dobjFVOFdlN29udktBOHZEOFNzS2xGcHprVXBSQ2hJZ0RR?=
 =?utf-8?B?d2tGMGdmcFFmMmxkVWR4ZkR1NEV6UEN2UzFuelgvK3gybU1jSTFBOTBYVHZr?=
 =?utf-8?B?Y0tmWXVYY2JpWGRCaDVkWmFTVWs1YUpPM0JocnFMVGY3cGxkazIyNDdmSFE2?=
 =?utf-8?B?SU1kOGpKM0JRRSsrMFd3WnZtdldrSThwdVMxWDAvUERxclBxQ2RXcHZPY1NY?=
 =?utf-8?B?MGpWRmIrUUd6NkZxWUx6VmJ4RlovSlNhYmVDa1NXb0s0RkZlRUVGb2JISVVh?=
 =?utf-8?B?Y3hCRk1rdi9FNG5qellwUlhkcWs4VllRVUp1NnhIY2NMNUQ3Z2V4T1h1UW5C?=
 =?utf-8?B?WDFrQVFLL0JLUnA2aUlZTXF2VStUanpvVGxRckc0eTZlNUp1Zk9LQXNtbGdM?=
 =?utf-8?B?S3RXc3VGOU14YWZVTWMzOG5haEhQbGI4TCs0bzR0VElUU1NXYWFVdy8rSVVx?=
 =?utf-8?B?UlJUUTJkSnhEWWMvVUNFVStwazBRdGg3YTVzWktnSzU5TmVnNHFVWkZBa1RU?=
 =?utf-8?B?N3hqZ2RVNnZSa2M2SjdQNTZZSHRMaTMwQ3dJYU1NbmRjMnREZEFINHlZWldM?=
 =?utf-8?B?VlliaVYrTE9Fa1NBSmE5Y3puV1pCQmo0Mmg2Zi95RVhuSHFTZjlUby9tNDZz?=
 =?utf-8?B?UFB1dXFCSzcyTjRvcFBoTENQeDhHUVBJMmMvK2ZkdWlmWXpmUnF3dDFsUGdZ?=
 =?utf-8?B?UVQ2NG5iV1UwV2c4bGFRcTFuUEpMMjQ4WWNydFVERXdERFJnc1FyaHFOeFdV?=
 =?utf-8?B?SDl1OFRCVzIzWnpJYTdBeXJxb1JFVEpVUldCdDlRem9OTzFEeUZVMU9oVjhl?=
 =?utf-8?B?VUZwbW9mdzlUNDArYWJJQXk0eG5oa1NWTVJTaXY4d3FQemovc3ZTVUZWcFlr?=
 =?utf-8?B?RXpoT21EWXMrWEl2b0tQZzNWQ1VwUkZJTVl5dHlBNWpNL1RVazlsM0NINWZ1?=
 =?utf-8?B?YlFzTjVsTlg0SnlBNjRWYVliaFBVaWxTMUtwSEN2NmFLOElxZnkxd0pXTGlW?=
 =?utf-8?B?RXhYc2VlV2pUSHhrVXllKzZvM2Q1cngrbm4wT2NvODQwc2tGdzg4RTdhS3dC?=
 =?utf-8?B?S0k4WlI0a3FPZGFiM1F6Wkc2QmQreUlldGd0Y08ybTJFSDQzcjFtQ1ZJVkpY?=
 =?utf-8?B?aFpOWXNhQTEwdHIrNjBlNTNLcnl1OFNSeG5TaFlwN1Bha3Qvd21oMUdxWER1?=
 =?utf-8?B?Z0M0M2o3T1Y3MFQ2SVgxeUQzaUtKLzhZOFRGbnV1YWx0NU9yWFZxZFRrU3ZZ?=
 =?utf-8?B?WU51OWFXNm9RZmsxc09hOWpMeDZob1N0dXoxc0VQSkU3UnA2dHZkUWl0d3E5?=
 =?utf-8?B?TzFFSEhxeDNsNjNwNzJvc3dOZnZIbHNteEVpS0dib21ocXQ2RHl5VXlPdGJ2?=
 =?utf-8?B?VzBFcUVqTW9Ed1YxOEhhRldmOVNWWG5QWHFRelpmeGFicDZCZFJzb0pjNkhB?=
 =?utf-8?B?UXpGUEVmNnVVSVZPTGpiREpWOXFPVkJSS3U3d3hiNkFVTnQ3RnFVenlTYVhC?=
 =?utf-8?B?VzB2Z3BjUjc3Y2JWaWpwUGNjTy9FMGNYSUo0NWc5Q0FGeHIzcS9OblFQNlVM?=
 =?utf-8?B?MnAvVGtWVS9TakdjeU8xN2YvU0czaWd3RGpEOWo5M1A4ZlYxN0NQN0xTeVV0?=
 =?utf-8?B?ajloZ0FhcWxwLzhwZDdxVzBYNVc3V3ZrNGtEclpYNXErT2ExOUdoZG1nSHR4?=
 =?utf-8?B?MDkzTFhPUk92QkVaZ0l2enM2SjlXdmlGbGo2WlQxZHNTWGhKWUdhYnBVOWlK?=
 =?utf-8?B?a1NjY0pSVytKN0VBbmo2YjVpbmJzT1h0OGJMeVM1Skwzd0xIWUlYc1NkMkMr?=
 =?utf-8?Q?q83lrm2pMz4Tz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3BCSExrb2VPYzhYckpBeFM4bWVKM2RIOUVGMDNQekdFZy9uQUE4VDBrVWI2?=
 =?utf-8?B?T1UrMi9ETGwybC9OYTlQK20vY1dTSVFhRmtvWjNtY1lWeUJNdThjSUlIK3l0?=
 =?utf-8?B?V3B3dm1HbVh0YnV3Nm9ZTWg2MDZSYTJEdWx0TUJVZUZqa2k3L0g1cnEwa2li?=
 =?utf-8?B?djVIOS9HU0dWcjdjcVNFTUF4RGNQR1NPYXVvaGl2SDdpVDJTdHlEVVd0WldI?=
 =?utf-8?B?cTZlNThjMGUrcTBRYkdTZktZOXlVdm1TUFlJNmdlLzRSZnhkYzZBZUY4a0Mw?=
 =?utf-8?B?Q2MrajVyU2tiVUVtWXFNcmZHN000azlKa3BlakpNT0lGTWRrUTlVazVIckNJ?=
 =?utf-8?B?cU9DMDZETi9sdE1LT2xIbDVqSEdyZUEzTEpkLzI1dEU4eEpiSUtCMWJrN3pD?=
 =?utf-8?B?QlE3QWtsOGdhVWRNN0JaMm9pWFpFWDk4ZVhxcnJDY2VhcnJrYUM3aUptc1dH?=
 =?utf-8?B?ZlNlVmdEMVdVeGdLQkxYYjN1MmEyWC93VnZiVDNRdmtIZUVyMzIxQ0ZqZm5V?=
 =?utf-8?B?RVphWWtvdHBTTDlFbGNtSmZWWUJpT2ppRWw1QWhnM3dtNE5ZSmNnTGVkemRW?=
 =?utf-8?B?UUxwSWltZ3FFa21qVVVMb0FMME5LQWJ2WHZ1Vnh0SElVK1k2eTNaV2pyWGhK?=
 =?utf-8?B?RFBWN3FMMTd5QlEwRHphRjFPZEpuditITmVkcVc0SXR3eGNOdFBoandEejZW?=
 =?utf-8?B?NjI1ejlRRWNTN0xjc0Y5WEI1aW1OMUx3ZXpMdlI2NWVQcE9PaTRteEh1T2JM?=
 =?utf-8?B?aCsvOFVTY1Q2ZWZEMndlb3hDS0N4dDd4MnJibGQxN2sxcDA1TXRmb2V5aWhq?=
 =?utf-8?B?a0w1c3RoUUpOeTBnSHZNQjFWeW5MdjU2NTN3ZkRnbytrTVVxdkRob0ZvT0lG?=
 =?utf-8?B?a2NMbEZ2RTBmbVV6WGxmSW1rUUVocjBOdTQwU0kzdEJnNldxZVJieTRna3FI?=
 =?utf-8?B?Y1VpdGdidWdGU3l4L29SU284VWdSUmdlL0hXN2VxWThHYmdPY2sxL0srV2py?=
 =?utf-8?B?S1FkZHlJRFowYTRReU9NamZraUl4VzVMcUZNY1dxYUZhSjRaUzVhQzRZUHdI?=
 =?utf-8?B?RHFLdVQvZFI2TVI5V0NpVm5YRjFodmtkUjlVd3VFMlFQbUkvclZ2VDRvNTU4?=
 =?utf-8?B?RW5XZjdiaUJtN0RTT2hNS215cVR3SHFpd3B0UlJJMmt3b2drV29tcmRMT1BT?=
 =?utf-8?B?ZktuUkx3RmxVUG9yaU5CM1hYenozUk1GMGM5UndFaGw5TjlFcXpXTkczNzVL?=
 =?utf-8?B?MytNc1VyVzJZSVJwQ2ltUk1ZUXY0TG5GZWNSL3owZFFydlN1dFhJeDhDQ0xt?=
 =?utf-8?B?dGZFWlhWV3pHbCtETW1vV0hwcU5mdU1Fb29naXFiZUVsOWVPOVp0dzZWR0tt?=
 =?utf-8?B?RzEzalkrUE9JcjlRT0pxSmZJVThhYVE4Uk5QVlhyTG40SElGLzJOZlc3Z1Zi?=
 =?utf-8?B?czR5VlN5QmVteEZtWlRTcE1qUEs1cUg1SWdxL3ZWeHliUVdIRDIxWWhjQ1RR?=
 =?utf-8?B?N0R3S0xSUkpmTzZGTU5Fdi9QUEFiUFVQeVdEVW8rd3pEVWRqbkFaaTFFUFdV?=
 =?utf-8?B?bjRVbHI0UzZ5bmdoQzE1NVRqd1UxSmprbWhqc0JjNkkySCt6WXV6NWM5SXBS?=
 =?utf-8?B?VHlQVnQrZnBtZ2NnK2JvcllGQWI0WTJHMmVDYlpLc0dKTFNoYndUZGs4b1gx?=
 =?utf-8?B?am1nZGtVUFpkeFZoTzFCY1FrMVArc3Y3bFV0d2RFT1h6azVLLzFpeG9FeVN0?=
 =?utf-8?B?MU1lWXVtRFIvWEtSV2oxR1pnMmxqZjc4Tk9aQ3dKL2JoUGFURHF0OERVcndq?=
 =?utf-8?B?cGhPeVlsN2R4bVhJcDdzL1lWWWVYMGhiMU4wTk8weEp3cmZ2TkowYjVVSnBk?=
 =?utf-8?B?WXBOcGE1NG1WOWlnUXU3RlBGcWtnZ3dpcVQweHZzbUVCS2M3OFgyVmVTZUo4?=
 =?utf-8?B?Y2Z2K0psRGoxYmJUcVdsblpSaUF6K3NkUVlvcFkzbzIvVy9Pa3hrbHc1eHNx?=
 =?utf-8?B?K0pyMlZ3NnZwNGdVYkp1Z0M3U2tzcElKbjkwekVMUlVQQ0JoT1lvamcwQnJn?=
 =?utf-8?B?dDBvNnF5UlpRSVUvalV6S2ZtaGlsb2hmdFR0MHJFNjdsTDJCMkpLUERtRUZD?=
 =?utf-8?Q?yey3IzRlySCXmikqXLDzkam8R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3b2e78-4442-47eb-e9b6-08dd30909500
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 09:32:49.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGRk1Z3idn9rbntT5doAmQhEAasNFKBvB4x4A6sbmJuzXtPXyFkABqgMMj8tGyb+0FCtDBxqXohNg8Wj86KE+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8508



On 9/1/25 16:34, Chenyi Qiang wrote:
> 
> 
> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>> Introduce the realize()/unrealize() callbacks to initialize/uninitialize
>>> the new guest_memfd_manager object and register/unregister it in the
>>> target MemoryRegion.
>>>
>>> Guest_memfd was initially set to shared until the commit bd3bcf6962
>>> ("kvm/memory: Make memory type private by default if it has guest memfd
>>> backend"). To align with this change, the default state in
>>> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
>>> Additionally, setting the default to private can also reduce the
>>> overhead of mapping shared pages into IOMMU by VFIO during the bootup
>>> stage.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>>    include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++++++
>>>    system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++++++-
>>>    system/physmem.c                     |  7 +++++++
>>>    3 files changed, 61 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/
>>> guest-memfd-manager.h
>>> index 9dc4e0346d..d1e7f698e8 100644
>>> --- a/include/sysemu/guest-memfd-manager.h
>>> +++ b/include/sysemu/guest-memfd-manager.h
>>> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>>>    struct GuestMemfdManagerClass {
>>>        ObjectClass parent_class;
>>>    +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr,
>>> uint64_t region_size);
>>> +    void (*unrealize)(GuestMemfdManager *gmm);
>>>        int (*state_change)(GuestMemfdManager *gmm, uint64_t offset,
>>> uint64_t size,
>>>                            bool shared_to_private);
>>>    };
>>> @@ -61,4 +63,29 @@ static inline int
>>> guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>>>        return 0;
>>>    }
>>>    +static inline void guest_memfd_manager_realize(GuestMemfdManager *gmm,
>>> +                                              MemoryRegion *mr,
>>> uint64_t region_size)
>>> +{
>>> +    GuestMemfdManagerClass *klass;
>>> +
>>> +    g_assert(gmm);
>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>> +
>>> +    if (klass->realize) {
>>> +        klass->realize(gmm, mr, region_size);
>>
>> Ditch realize() hook and call guest_memfd_manager_realizefn() directly?
>> Not clear why these new hooks are needed.
> 
>>
>>> +    }
>>> +}
>>> +
>>> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager *gmm)
>>> +{
>>> +    GuestMemfdManagerClass *klass;
>>> +
>>> +    g_assert(gmm);
>>> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
>>> +
>>> +    if (klass->unrealize) {
>>> +        klass->unrealize(gmm);
>>> +    }
>>> +}
>>
>> guest_memfd_manager_unrealizefn()?
> 
> Agree. Adding these wrappers seem unnecessary.
> 
>>
>>
>>> +
>>>    #endif
>>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
>>> index 6601df5f3f..b6a32f0bfb 100644
>>> --- a/system/guest-memfd-manager.c
>>> +++ b/system/guest-memfd-manager.c
>>> @@ -366,6 +366,31 @@ static int
>>> guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>>>        return ret;
>>>    }
>>>    +static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm,
>>> MemoryRegion *mr,
>>> +                                          uint64_t region_size)
>>> +{
>>> +    uint64_t bitmap_size;
>>> +
>>> +    gmm->block_size = qemu_real_host_page_size();
>>> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm-
>>>> block_size;
>>
>> imho unaligned region_size should be an assert.
> 
> There's no guarantee the region_size of the MemoryRegion is PAGE_SIZE
> aligned. So the ROUND_UP() is more appropriate.

It is all about DMA so the smallest you can map is PAGE_SIZE so even if 
you round up here, it is likely going to fail to DMA-map later anyway 
(or not?).


>>> +
>>> +    gmm->mr = mr;
>>> +    gmm->bitmap_size = bitmap_size;
>>> +    gmm->bitmap = bitmap_new(bitmap_size);
>>> +
>>> +    memory_region_set_ram_discard_manager(gmm->mr,
>>> RAM_DISCARD_MANAGER(gmm));
>>> +}
>>
>> This belongs to 2/7.
>>
>>> +
>>> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
>>> +{
>>> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
>>> +
>>> +    g_free(gmm->bitmap);
>>> +    gmm->bitmap = NULL;
>>> +    gmm->bitmap_size = 0;
>>> +    gmm->mr = NULL;
>>
>> @gmm is being destroyed here, why bother zeroing?
> 
> OK, will remove it.
> 
>>
>>> +}
>>> +
>>
>> This function belongs to 2/7.
> 
> Will move both realizefn() and unrealizefn().

Yes.


>>
>>>    static void guest_memfd_manager_init(Object *obj)
>>>    {
>>>        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
>>> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>>>      static void guest_memfd_manager_finalize(Object *obj)
>>>    {
>>> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>>>    }
>>>      static void guest_memfd_manager_class_init(ObjectClass *oc, void
>>> *data)
>>> @@ -384,6 +408,8 @@ static void
>>> guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>>>        RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>          gmmc->state_change = guest_memfd_state_change;
>>> +    gmmc->realize = guest_memfd_manager_realizefn;
>>> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>>>          rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>>>        rdmc->register_listener = guest_memfd_rdm_register_listener;
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index dc1db3a384..532182a6dd 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -53,6 +53,7 @@
>>>    #include "sysemu/hostmem.h"
>>>    #include "sysemu/hw_accel.h"
>>>    #include "sysemu/xen-mapcache.h"
>>> +#include "sysemu/guest-memfd-manager.h"
>>>    #include "trace.h"
>>>      #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
>>> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block,
>>> Error **errp)
>>>                qemu_mutex_unlock_ramlist();
>>>                goto out_free;
>>>            }
>>> +
>>> +        GuestMemfdManager *gmm =
>>> GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
>>> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block-
>>>> mr->size);
>>
>> Wow. Quite invasive.
> 
> Yeah... It creates a manager object no matter whether the user wants to
> us	e shared passthru or not. We assume some fields like private/shared
> bitmap may also be helpful in other scenario for future usage, and if no
> passthru device, the listener would just return, so it is acceptable.

Explain these other scenarios in the commit log please as otherwise 
making this an interface of HostMemoryBackendMemfd looks way cleaner. 
Thanks,

>>
>>>        }
>>>          ram_size = (new_block->offset + new_block->max_length) >>
>>> TARGET_PAGE_BITS;
>>> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>>>          if (block->guest_memfd >= 0) {
>>>            close(block->guest_memfd);
>>> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
>>> +        guest_memfd_manager_unrealize(gmm);
>>> +        object_unref(OBJECT(gmm));
>>
>> Likely don't matter but I'd do the cleanup before close() or do block-
>>> guest_memfd=-1 before the cleanup. Thanks,
>>
>>
>>>            ram_block_discard_require(false);
>>>        }
>>>    
>>
> 

-- 
Alexey


