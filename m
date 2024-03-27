Return-Path: <kvm+bounces-12743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9015488D38A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 01:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3AA61C25F28
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 00:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF8C1D52B;
	Wed, 27 Mar 2024 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KS3DPnfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467817545;
	Wed, 27 Mar 2024 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711500845; cv=fail; b=nUrXpirWTKNblBepYGNmhAUlLXV8Hbvp5o40/jpJNQXOPVP6HZF/jNwjSdg8uPsAUodtAXtS6gyKWAEA2BTrlcajlG3Ww5YdZezVCMtX7w2pTWGebXaLgfvLCrW+ZJGgUg8Y+TKmck1Y7heooi6nXLfLQpXtEsSFa+u+VQL2Rv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711500845; c=relaxed/simple;
	bh=4Xwe6SBbxYHqWCMISj9BfxQWiGzcXw0I451q8YNdyyU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pFEJV/4qIjSYPQx9tLoysgAEGrvWY2PVOUFqk9T7iht1YHfTJ64Qk3lzJYGWkdyjlKHB0oh5PCwWLY6rk3dEKLiPufPVqc6zQoHTNuShORlIzvutGmhTBkWJXH1DJlqVlOww+Yrl96vxupMcbTVIw95Jk5xNVSYp3qezDIHm9g4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KS3DPnfZ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711500843; x=1743036843;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Xwe6SBbxYHqWCMISj9BfxQWiGzcXw0I451q8YNdyyU=;
  b=KS3DPnfZzGqmYkwHySEPmN/LsCkG1xWjgYwgERErgKmwUTKNZHOqkPdV
   k2FvjBhw5GG9nPmZ7chF5J6LOhdmfy6l1rxmozvRROW3Z9XYVwj6vgMM2
   UW8QgdGI20sy8HuGOyXHfSWzg6xmC3X3kVbLdfZ+6HJdm2vf7VhzAZqHC
   pMDsb37A17/+4WIjpVCZYr9gLE7MbFmC27kpAwSuBzsYwKm/s+eaeIzqK
   J7uUUYv/RtYtYuQ/ragTkxZGQ53APNR499bwiJudHz18NTUvNiRjS6zFd
   DDpWeYo/jkoo03NZd1LSjgmF+jgVffUnDd5ms1/41/rcpwJkLOLpqiFGA
   Q==;
X-CSE-ConnectionGUID: mDJhdC5DSPqxM8M7BMjEUw==
X-CSE-MsgGUID: vwiECpNkQP2F2DNQpWbiRw==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="9544652"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="9544652"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 17:54:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="20847843"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Mar 2024 17:54:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 17:54:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Mar 2024 17:54:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 17:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oY+qLlyuKLc6AahdxBUfY/RQ9AGcrmV15fmMfDVI+Z8+63j3TbdT2MzFPn7HxocLRcaaU2JG2sIBJgJB63eXdiNoR3FhMEyuliR2pIrbwQr3ltQ5E8KyoZlVTTDphyK7OWo7PQKuROXR2p4AzmnFdcXQDPvIwQBl0VOJvYMcCZlZFDakazfdc4fV1syqC3iWJqLZu3ocsxvaWG1ver5IpEAjTifcMMLAXJJWmIA+OwAhEfgzNW0QNScjntkg3eNfWZdGd+E9x2PX/c5ZQh3VvhpoNkm5K2Y1QSxJYQBbb1aeeYH1XKy+Epfz/4Kn5GVbMbMu3PwE4m0N9Kt8qWoPHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8Ph5YsLot87fDkLDo7Bkcb6zwckTTW37k1ULQ4vRrQ=;
 b=guoFK2lfL5TdVbQEFPmBVFqZn41ldsxj2D1/r+3U/hgluwh3pz6d3htGea5fxajtgJjzd+PrwZrDU0b30qzvDjhKh4TEtxX2kaetTnQR0EQsDlAK1KQwjwHTrNSfREdPz0EA6Upjv8doE9ELnOtHo4CJcvQmXnaMJAT5l5vSlj9CfY2vsReTNmr+IDXBhu1xxWWVrKXoheJ5Z/68j+AKEbY8rzmU2BE5hAOebY+4bFhqPDCEDBTpXBtQ5L1L3SK0e3UR0GxiK2kwx7vwC+EN5bSkM7sT3TPt+/b4X5lu6wXCDF7F3vvdNXhJSL42U5nwEu5VEtqSry+NZCIr8/BE9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:53:57 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:53:57 +0000
Message-ID: <8f7735aa-517f-4bb3-8e33-d58a27c2a822@intel.com>
Date: Wed, 27 Mar 2024 08:53:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] KVM TDX: TDP MMU: large page support
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>
References: <cover.1708933624.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Yin, Fengwei" <fengwei.yin@intel.com>
In-Reply-To: <cover.1708933624.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|SJ0PR11MB5133:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wccxGr4ahYcK8fUSlLfcdABoBvrLDWj1XSJN+dC1EYWB9gjN1aSLlyqQ8dJRXcUFh92bCXFh5Y/NG2JZWAO+qAJ7xgjh/fMpleOq8AGrHwYk3g13L7o7LVQbvQsQt0AaXG9wq+hJDASg/Gdoz3JKMLjAqoanl4qTT6iCb7b0zw7rRzWSfJ1xZedjchenMIToVusFp5SEOHwEUUrtPlYovtSpzxqkXengbvBC+8Hd7Btx2fm6ktxU7grPzRQE73u/eTh8s9cijxC+TDAiAEKPB1gthsHD8tSw1xOTqfYIXue7NenhoL5ITGfDnPcLOakS79VIxkxQOqqc6V6ubGKcNg9S+gzzeP2iNq8XedKcOsKB9tfMSy9LbH+yERydU5gHxSCekxo27OPPHafo+WVMuWmezV/faM6dbpxrcVuluZyIn0fuuf8iGZntC/+aDBVNSoSdDasgVy4UldNoIvW2gDCjK6h+TBE/5aOS4yG1Ureh7u24Zm9i1YteROdEstQoCokxpYzw6YOvEwDnCivoS7edk64i8HzOkul0QKPGjJLI8Jln+HW/iFwtZO0/8JhT1ri9lay1pb6u9cMcRSttbDtixXRhYxkijVu8yBeCHf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlNjOElFRW5lMHRBS0QrMmh3V1NjM2NaUEswWlczMk9MRjJNaE04eXNVaXFT?=
 =?utf-8?B?Q1d5cDNoam1CU0RPUFkyQ21pVHZ2SFk4aXZkbmlKRjRFbHd5Lzd3T2NOaGFS?=
 =?utf-8?B?YytXcUM5SFNIQXlLV2R1aU9tSjBoVDB6bmFCb0JITFgxT0RBMjJzOXpNU2lS?=
 =?utf-8?B?K2lQMEpyWHpmeU96eHl2eHIrSks2NGFNSzVIYWZiNGNINSt4em9aSjNMV1Bk?=
 =?utf-8?B?amt1a1dFeHhZa1NyL1FxZHJjNWhVNXFDYmc3VTNRMGJrdlhXemEwK21zVWRF?=
 =?utf-8?B?alFPRC9Rb2tpN0lJUklua2QvZm40UndLbWZ2NjB0cG5qSk5XMDdSVnBkVnJl?=
 =?utf-8?B?Mkx6bFBxQTRhSTFlVndzVkF6eFkzTytNbjI3V2V1TmRBLzBSbStOQk5KTWNM?=
 =?utf-8?B?WEFOQTFHT29TRVVzMVc3NFdkVnc3TVdnbVNTY0ZUbEt6eDZmaTQva25PSzB3?=
 =?utf-8?B?WnBpcE5ac3Q5QjJCRmU0MlZONkdXRGVMWElyM2VRRFdHR3oxcU1pckMvOXps?=
 =?utf-8?B?SUQ5dUNPaFgrcHNTVnJ0YXloZ2VhaFZYZnpRSjRHdHl5bDFwNUtwSEk2a3J1?=
 =?utf-8?B?QVdhclRoU2hQR1JNT2F0QjhKUjZReGozcGlXVjBucnd5RjVlTldMbzAza0tO?=
 =?utf-8?B?QTRzZ1k1MnFreWh0a0pwaEg0MElJbDd6UDd2N1JTdE5Xd2xMTHdjeGZDZzdr?=
 =?utf-8?B?ZmFnL1A3MHdYMi9Qa1JheWx2S0ZLeTFGY2hRdHlRMFlLMFBzMDBFSHBTT0F2?=
 =?utf-8?B?QmRNMnh0bVJaWHNPcnJpQ1FCQVZ2Qkx3Ni9pRzl0QUtSeTJ4eW0xOWFSMkhO?=
 =?utf-8?B?d1pRdVliNGkwV2tlek1Zc2NPbG4xcWpQYmxmY09hdHlWd1Bya1QxUk9rcVIx?=
 =?utf-8?B?NTNub3NHeDB4d3Y1NzFjNmtTNEUzM1VhTThOZk9DQ1l3VVIxWFZGZW0vWWty?=
 =?utf-8?B?Zk1pWUVGNUZMengrZXdxc0ZCVHFhQzZEVmdZcXc4QUpsOWUwL0Z2dWFudUc4?=
 =?utf-8?B?M2hzR2N3QWVDQnFCanBkSjNLRTRqNGlXOGlmeG90bHpsMjJCZmM3N2pzNGs5?=
 =?utf-8?B?TEJucWxwOUtBekRvb1lMa1ZLbnB0YjgvbndQMWQ4N011RVdCb3RuM1hTTllu?=
 =?utf-8?B?eHEwQXh3dWZYOTlBQ1lMaXlKSlNtV1lFWVA5QnJTaUpiSFVsTGp4OTZ3N2Z1?=
 =?utf-8?B?NStieVNnYS9ncVhKY1kzaTdmZS9oUUFWbVVGNmJRcTBlN2ZxOVJYWnQrREdS?=
 =?utf-8?B?MGZnQkJxRTIwYlliRlZ4Q2t4MklwRFIwZnBLRzlxNVEwdk9HTFR4VGxDSWJw?=
 =?utf-8?B?bDZMWTFvdm0rZDAzY3ZGSDNQNlFMWTFWUnYrc1JubnROVy9HSW1FZXhTbHBZ?=
 =?utf-8?B?aEpCWTBqK0syZXVkNG1rRGNLZzg0NExCdHp5dzF6UXBGZUJBSFdsSDFxNnlt?=
 =?utf-8?B?SHdTZy9QUnprYXZxNzZVRVQycW1oY3RYb0FVRk0wWXBablJtLzVWOU1VUWp1?=
 =?utf-8?B?Y1FlNXU1STJJVFZvMitUUGJxUmRhSDdVcUlpWmd3UVZiK0pqZXYzTHhtS3hR?=
 =?utf-8?B?aUNaODEwdGZFa1ladGI1WXRzZSs1Rlo2Qk9xcDlDMlVndUx2ZURaaUJXZUJB?=
 =?utf-8?B?V2dWeXE4cGdOTjZyeWxzT21hY2Urcm9pc2FlekMyV0tjNEJaeTcrNVVvVWNm?=
 =?utf-8?B?eUtYMFpnaXlUaUd1d0dlaWIwU0JMZ0t1SzEzSDl6WkJ2c3VCQW51QUY2SXRl?=
 =?utf-8?B?cnRHaW1lTUJQdk9QT3hncnZGYU10WmFibU1RTE9Hc3ZWQUttUTNEUWNZWEtD?=
 =?utf-8?B?K3ljUlNOVE1nQnJSemlvb2VEV2tLRmlXRWx0K0taYkFmWWJOYkJqYVpkZWRP?=
 =?utf-8?B?bDZBdUNaRkRKL2IwY055OGE2azJjQlFKM3BUbURiT3FhdURIemlNOThqMUNN?=
 =?utf-8?B?Skk5NjcyREI0SzRCdEp3ZkwvL3ZpVjkvc0M2L0hNYml6ZkdOMFBkSUozWC9z?=
 =?utf-8?B?VmdJYjVTUFhDUDRzZ2xxTEFyWSthVWcwbnMrTjF0WWtuelZQL2k5Z2ZPZnNv?=
 =?utf-8?B?c0d0TkpJTW1FWnM5SlErbEZhTStyRlFMNlNpZW1FbzhFUUtzUW5YbGRRMUdt?=
 =?utf-8?Q?RS4fdVDrideg/9Ojqx2v2baio?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b597c825-b101-4e22-6564-08dc4df86236
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:53:57.7687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92O5C9cKe6ouneRTHXclpfaPjWfC4INg99nF19bOVOFix9BEv25H/z6Bjjs5ajFv2PdVb3x5aF6W+1haZWpkNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com

Hi Isaku,

On 2/26/2024 4:29 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series is based on "v19 KVM TDX: basic feature support".  It
> implements large page support for TDP MMU by allowing populating of the large
> page and splitting it when necessary.
To test the hugepage for TDX guest, we need to apply Qemu patch
from Xiaoyao:
https://lore.kernel.org/qemu-devel/20231115071519.2864957-4-xiaoyao.li@intel.com/

According to Xiaoyao, it's still under discussion. So he didn't
send updated version patch. For folks want to try this series,
it may be better to mention above link in this cover letter?

Test in my side showed several benchmarks got 10+% performance
gain which is really nice. So:
Tested-by: Yin Fengwei <fengwei.yin@intel.com>


Regards
Yin, Fengwei

> 
> No major changes from v7 instead of rebasing.
> 
> Thanks,
> 
> Changes from v7:
> - Rebased to v19 TDX KVM v6.8-rc5 based patch series
> 
> Changes from v6:
> - Rebased to v18 TDX KVM v6.8-rc1 based patch series
> - use struct tdx_module_args
> - minor improve on comment, commit message
> 
> Changes from v5:
> - Switched to TDX module 1.5 base.
> 
> Chnages from v4:
> - Rebased to v16 TDX KVM v6.6-rc2 base
> 
> Changes from v3:
> - Rebased to v15 TDX KVM v6.5-rc1 base
> 
> Changes from v2:
> - implemented page merging path
> - rebased to TDX KVM v11
> 
> Changes from v1:
> - implemented page merging path
> - rebased to UPM v10
> - rebased to TDX KVM v10
> - rebased to kvm.git queue + v6.1-rc8
> 
> Isaku Yamahata (4):
>    KVM: x86/tdp_mmu: Allocate private page table for large page split
>    KVM: x86/tdp_mmu: Try to merge pages into a large page
>    KVM: TDX: Implement merge pages into a large page
>    KVM: x86/mmu: Make kvm fault handler aware of large page of private
>      memslot
> 
> Sean Christopherson (1):
>    KVM: Add transparent hugepage support for dedicated guest memory
> 
> Xiaoyao Li (9):
>    KVM: TDX: Flush cache based on page size before TDX SEAMCALL
>    KVM: TDX: Pass KVM page level to tdh_mem_page_aug()
>    KVM: TDX: Pass size to reclaim_page()
>    KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large
>      page
>    KVM: MMU: Introduce level info in PFERR code
>    KVM: TDX: Pass desired page level in err code for page fault handler
>    KVM: x86/tdp_mmu: Split the large page when zap leaf
>    KVM: x86/tdp_mmu, TDX: Split a large page when 4KB page within it
>      converted to shared
>    KVM: TDX: Allow 2MB large page for TD GUEST
> 
>   Documentation/virt/kvm/api.rst     |   7 +
>   arch/x86/include/asm/kvm-x86-ops.h |   3 +
>   arch/x86/include/asm/kvm_host.h    |  11 ++
>   arch/x86/kvm/mmu/mmu.c             |  38 ++--
>   arch/x86/kvm/mmu/mmu_internal.h    |  30 +++-
>   arch/x86/kvm/mmu/tdp_iter.c        |  37 +++-
>   arch/x86/kvm/mmu/tdp_iter.h        |   2 +
>   arch/x86/kvm/mmu/tdp_mmu.c         | 276 ++++++++++++++++++++++++++---
>   arch/x86/kvm/vmx/common.h          |   6 +-
>   arch/x86/kvm/vmx/tdx.c             | 221 +++++++++++++++++------
>   arch/x86/kvm/vmx/tdx_arch.h        |  21 +++
>   arch/x86/kvm/vmx/tdx_errno.h       |   3 +
>   arch/x86/kvm/vmx/tdx_ops.h         |  56 ++++--
>   arch/x86/kvm/vmx/vmx.c             |   2 +-
>   include/uapi/linux/kvm.h           |   2 +
>   virt/kvm/guest_memfd.c             |  73 +++++++-
>   16 files changed, 672 insertions(+), 116 deletions(-)
> 

