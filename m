Return-Path: <kvm+bounces-11843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F57687C51E
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AC491C21183
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FDE76907;
	Thu, 14 Mar 2024 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPQ7aYAF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079851A38EE;
	Thu, 14 Mar 2024 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710455295; cv=fail; b=O6+GKbJu8QUJH4ZdpPpbELWmOkAC4rRdg8e9NFOzfZrokqStFLcEMIxn5ppT6oJypJIVNW1rV3GVxGpMoFIN9V907Oj1t8hS0JbRHftX0vtwKBDQXKmTogZM3Ut33jIdHyLgY+Qslu5JzpbpKfym/x7QCGo9LprFfWG9w+GmAv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710455295; c=relaxed/simple;
	bh=Dd/v8rPR1uU0kDwUW4NvB45cgVfJe4EXa+h+QUx8rDk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YD8Ci3DnoR0y5AiPX2uL9JOY9EB4OqD4dh94iVOozrLwhiRwcOV6rHrkaIbn3+Sap2xZpXTsVTb7YbVBRT97UcVgT5D76qM/XkPtTpHX+dl9lRy2GGhYgngT4Xju6waYya6UNMjJzhRUqZzMWYSfBAnoejKc6DnQb5en+a7dj7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPQ7aYAF; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710455293; x=1741991293;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dd/v8rPR1uU0kDwUW4NvB45cgVfJe4EXa+h+QUx8rDk=;
  b=VPQ7aYAFBrMQGDFNirxDhRQxtqEncWdVG7N6XUX3OQZqLf9LDLG7y2T9
   2WPDrymIMMU8qf7+haXbGOH8RHlO1SopRn82pHR+FJn/995BphgBKzckf
   93/SJ+QpJtUJ5lbunAcavaEb7lDU/zZiAqo08aySOCFriuncE8eTaQKFO
   s5OIPGyk43/ihyCLN7nI7BYLHGuOoO0OEpK705v7HCwP3g4IuJubzzpH9
   FGSJXGXaNDJp4lSNbPWSWq2MBzaPfpqcd7x93V2cQUlshd52dViw4WCOy
   CmjwTvyo15hj434kkB68BIm8XnKuuMX5IvAC4mtJZ6efJmWk9gl14cTdw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5507293"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5507293"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 15:28:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12358276"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 15:28:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 15:28:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 15:28:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 15:28:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 15:28:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAO1SXb3xt3dmcWLarngXCON21CP5/lcpbEaqMrucrlYyRIc65YYP4Nb9OmQyxQCtJcPZ29PAeaXQl/u7+Og2XeM/BR8wPTUIwBSBArrbzawvdVGyE3gNKEQ7N8VIblp1d0A4gNNUgrEVQ6ZZ2AV434zwXvjksFVelXo/A4hMxnGtClukBd748DubetdpYmOPZMy9PjEiFZlIv48ue/6GTsGd1rzUJ4h5kmve35PNRiDWp+m+06ZsyZdwzZBi7JYptmtVsvepzEeCPgy4lbdIGuRzB6wabVPLKrCAX3ZjZfh0YNQ7McfIOvZur2NpUZNK3ZaqY6v7h8yGBqFSZIUqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uysl5hWfdsDZyBPL1Jga3XwEnVUHMXkiPWJxkBWcBRY=;
 b=Pu2qlUQWPtBMGxnscmcTRa9M/4lJiJLK8Z1VVSjEvE5eA469Lw30wnjoP8ATvK25tM5DSNc8haHML/t3LSWbT/N0dptnoQkwj0fQaDEYSEQRzevEJ7Ig38GsFcm8HJ33ePPqsedKm7j1HWB2u1KSBFRHKiEjgpKkVMg4dpBGht+LBDGnjTaJvvlj6LFVo1Sxj77mEuiU80uLSlaDc1dXojFfh/6aLcNy78uqNO6hcRnJxk1Qo9gZCj3eHx1F8RdCbabvKybROXo8uqFFbSfHhdZKNFAKD2XHBtQ2PiFtVtgM+VDm8lHc5f9vBE7zGrt1+WDYQHy8pUtWA7ZBPo21DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6602.namprd11.prod.outlook.com (2603:10b6:806:272::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Thu, 14 Mar
 2024 22:28:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Thu, 14 Mar 2024
 22:28:04 +0000
Message-ID: <075d7013-6f5b-4446-a41c-d9ae754d4bd9@intel.com>
Date: Fri, 15 Mar 2024 11:27:56 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 033/130] KVM: TDX: Add helper function to read TDX
 metadata in array
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <72b528863d14b322df553efa285ef4637ee67581.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:303:b9::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: a1734418-03e9-4042-3fe5-08dc447603f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkM4Ukv3FQry0oRHv1D2R4Ji+3+X+UiWASiy9RWqi3g7elu5cioOIVXPZE5ksn+H/GcIZXSGh2hyWgq5RzdqrMdSgxjBn12G7qKY/Ujetmsu3uwvHHNJ35+0M0CYYejCcUAvz94VYpaBEY7V9EhQtRAPoAefykHIf/Ff7Al5niUeJ+m5A5b4p2PWmrCdHxbKA8vVD27aHp5b4ccAzLHoEzPNn5buzN6agwgn8Ap8bjGIB/Vpp8IMEc8WxmLHHPkBVRVkeaVW2OLE+wg2pkzdyZqhdjJOGbmjYKZ4/U8p7g4MBJkI3B6hRIQgzatth2TCW4qY5jKtGarWNuroedg8ZFyhK2brcfzxIjx98cxlinV9qzQOA7aq8u47u90EyWkMuA1k2yovjvEzxFUW9vZjGPWJLxS4gp7lgdUJDUoOFSNvdtJWK8FTzSpS6ehWdAg1u9suLHUnUtSZu7rsNSgPXlbNdrKKww8mEfxXNVvNJNBV6nVe1IAlJzd93R96PzNbvNoE7W3zuC69LY7oUo6uEzr1b47Fe6aiJZKwfiNBhaRtP90KtCizcJ480NfVfexAzpmJSqUhue4TdhB5mp34jthRZ3+Ig56W9UYiTBPQah2hHLjh0lFFZpsYZ6q1GW88DRP+a1xMAbQjO1MlfXOLaTWeA4p6M1GqaciELQ8/89M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDVjdGc5YWZlYUt0bXNTUkVzVWlSVDFuNFA2bGtNZzBMcVpWbXlES2NrOTFB?=
 =?utf-8?B?aWs5RERWWGZvWmpFVlhEYWxrR01IQjY1MWpzTU93ZXVLU2EzTlRWOGtnWG0y?=
 =?utf-8?B?V2FBb3N2Q0tNd0NQN3pVK2ljRnNKU3BJZXBFQ1FWaU9NNjkxdDl0dWdWTXdO?=
 =?utf-8?B?a0JQRW1oS3JmaGZFb2YvQzlvRUdmZXJqRGVhUzR3QXprc1hkSVJJNExRcXEx?=
 =?utf-8?B?cU1PSGxSRzc1Q3VPWkRQMEVWMDF2c0JrL0pQRDd2NnJSWkRsZ2hHWUNvUVlq?=
 =?utf-8?B?RWFXTHE5NUJRdjl4Mm1HeElKblN2SG1XbjNSbzA3Y2g0OWZDdHNyYlNwVHlM?=
 =?utf-8?B?ZjlmY3NLVkorYk5kdGRSMkNiZ283NDVXN2pmMURjZUNzZUZjMDJuL2RZamxi?=
 =?utf-8?B?ekRpQzhOWkRDN2lQZlBLd3doWHBkcDlsamo3U2JNVWdDQkR0RnFsUTl5S1Ux?=
 =?utf-8?B?M25ZNm9xRFRFSDRWRUc2K09lSmJyaWo5UGYwUVNpQzlnQVo0RkJZUFlVR0xJ?=
 =?utf-8?B?bnFELzBCbGZoOVJOdzkxWmRmY1N3OXJScUZ0bWNlUUpITG52TzUrUmJRUzdu?=
 =?utf-8?B?ODBET20rbWFJVFhtSDFkVFh5L3hueDNuZGVyd2Rwc2Z1ZmdWYk9NclYvbm5J?=
 =?utf-8?B?YkpmdDM1WnUxZmdSKzFrWVk2cU1qRW53UnZTZFUvalltN29tM1FrckZ1U0l6?=
 =?utf-8?B?bEtZYldNRm9vNHhiRU5PRW96dkpsdkhEWjZMUko1TTRXYlVCdzQwNk9DcUky?=
 =?utf-8?B?M3QyN3ZnbFNhUE91QVhwaWFiQVNsSFdBamlwRnhsdGZVMThoc1o1VjJRTmYy?=
 =?utf-8?B?YnB0KzNTUHVTQTN5QWwrMlQ0M0l6SHFKSCtQZzI0OW10cWMrdlZtWkhXQ2d1?=
 =?utf-8?B?TzRXcCtMU0V6eVF0ZHVyK3Y1Yy9hY0krQXpVM3hOUzM5cVJhcWVKYUFieDc5?=
 =?utf-8?B?V21LWGZQQ2tMTWxheTJ1MThXTTdCOTdMYksxcWtDazhEaEZyNVkrdHIvQ3B5?=
 =?utf-8?B?THJtWS9Qb1doSkZtVGFwVjFUQ3NoVTFwc0s1OFJlTlQzVzg2THNiNUU1WjBK?=
 =?utf-8?B?SkxOWUQ4OHE4TENDaWZvZUtQVkNlZzVCNEI1MzRGQWJSTSszaXQxclMyUDBr?=
 =?utf-8?B?aHYzenM1WEZ5MDlObWpneEpsR0pkTjNEc05PYmM4WitrTnZkOFkrMzVITmNk?=
 =?utf-8?B?RUlyZG1HV1l4UEpiK0E3UG9hc001TlYzNU9hQk1GaEFVRUNiTU5zZEdxVlgr?=
 =?utf-8?B?YWNVU2tOcWhqMVR4T3NoVTlYdXc1UytXc2tTTkdkVjFzQTNVeVJpNWpTM3p6?=
 =?utf-8?B?SXRqMXY4cTZLSm9LODFwQkZvT294TVdjUk9BYi96b1JNLzZDbnVjaTkyRmto?=
 =?utf-8?B?R2d3WE1DcHNibU51K3RKcjVMdlNmakd4eTVqNDNDNTVMcmE3U0tybkVQUkx4?=
 =?utf-8?B?b0kzQ3ZCNEpneXVoTHpWR3ZnZXZ2MHR3clNXZU1TbzZ1dHR0RmdoWmxDZ3NV?=
 =?utf-8?B?dVN0cHZyYjlna0NUQ1FIYkxMSlRkNlRtQ0NSNjNkZlhjenVnZ0w5cXg1ejFx?=
 =?utf-8?B?c2toL2ZsL216Ym91OTZNUFdzdmlFU1NnanB3L3hORVVncmhKVldGaXRiWTFC?=
 =?utf-8?B?LzhIcVRGbkVuM1Y2eGtqSXhDNG90VkxGVmsvSjN0KzFrdXUrL285ZHhvOElL?=
 =?utf-8?B?dWdlb1lqTFNkQk1iQzFYT0VyVVZwbVNuWCtyNmxhL0YxRFFWSHp3Ny9WSXNB?=
 =?utf-8?B?WjBXdW9aNVVPN1AzZUt2NGdOZGhMTXV2dzJCeXBIdVFXZ09ZM2d2RmJKVncw?=
 =?utf-8?B?TUkzelZLUXBKSy9mV0hCRndpUDQyUmR1UUVyNUdOcVp5VnFaYmxDNFJnUXF3?=
 =?utf-8?B?dk5ZdXowb3dZbWhYZG5vSjNzQ01ZdlZ5VDNULzNUWG42Y2xZNG8yTmtaTmpw?=
 =?utf-8?B?ZnUrZUl4eVBwczM3cDZkbHhEZUpua1UzeXN6M0VFRk1pbkZCMHZHeWZELzFl?=
 =?utf-8?B?dFdyS3N5b01mRG9MZjgwVGY3Qlp1K3V3dy9FT3JzaHpRRCtCRVcxT0JIL2hY?=
 =?utf-8?B?ZnByNm1hL3QxWXpNZVVKQWJMM2FUaXB2alZNSFVkaTBUbUFpVVFUZ1l2OEMv?=
 =?utf-8?Q?hVXQibJ3jBfs4Pc5YSU3HwGnx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1734418-03e9-4042-3fe5-08dc447603f7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 22:28:04.5181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JrOsbJ0aanigy1JR2UkYTeHfNZaPrNqTD6JtUxDDviJYIpMQ4KWz4hrAYdlROdVux7OXZbiXEXFdtFM8wAi+4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6602
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To read meta data in series, use table.
> Instead of metadata_read(fid0, &data0); metadata_read(...); ...
> table = { {fid0, &data0}, ...}; metadata-read(tables).

This explains nothing why the code introduced in patch 5 cannot be used.

> TODO: Once the TDX host code introduces its framework to read TDX metadata,
> drop this patch and convert the code that uses this.

Seriously, what is this?? Please treat your patches as "official" patches.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v18:
> - newly added
> ---
>   arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cde971122c1e..dce21f675155 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,6 +6,7 @@
>   #include "capabilities.h"
>   #include "x86_ops.h"
>   #include "x86.h"
> +#include "tdx_arch.h"
>   #include "tdx.h"
>   
>   #undef pr_fmt
> @@ -39,6 +40,50 @@ static void __used tdx_guest_keyid_free(int keyid)
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
>   
> +#define TDX_MD_MAP(_fid, _ptr)			\
> +	{ .fid = MD_FIELD_ID_##_fid,		\
> +	  .ptr = (_ptr), }
> +
> +struct tdx_md_map {
> +	u64 fid;
> +	void *ptr;
> +};
> +
> +static size_t tdx_md_element_size(u64 fid)
> +{
> +	switch (TDX_MD_ELEMENT_SIZE_CODE(fid)) {
> +	case TDX_MD_ELEMENT_SIZE_8BITS:
> +		return 1;
> +	case TDX_MD_ELEMENT_SIZE_16BITS:
> +		return 2;
> +	case TDX_MD_ELEMENT_SIZE_32BITS:
> +		return 4;
> +	case TDX_MD_ELEMENT_SIZE_64BITS:
> +		return 8;
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +}
> +
> +static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
> +{
> +	struct tdx_md_map *m;
> +	int ret, i;
> +	u64 tmp;
> +
> +	for (i = 0; i < nr_maps; i++) {
> +		m = &maps[i];
> +		ret = tdx_sys_metadata_field_read(m->fid, &tmp);
> +		if (ret)
> +			return ret;
> +
> +		memcpy(m->ptr, &tmp, tdx_md_element_size(m->fid));
> +	}
> +
> +	return 0;
> +}
> +

It's just insane to have two duplicated mechanism for metadata reading.

This will only confuse people.

If there's anything missing in patch 1-5, we can enhance them.

