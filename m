Return-Path: <kvm+bounces-17472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E88788C6EE0
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90436282911
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E92482E2;
	Wed, 15 May 2024 23:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ASSK6RcH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B683D0D9;
	Wed, 15 May 2024 23:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715814413; cv=fail; b=FpakmsQmdbzc5Ar2eP1YxpDJFTztkBnk14nsqMEKNshLwe01ZhECLFqthDxGYgCd1A8pj0YXKyGNwNvFVtO5mPzrFaxKBH6CLKKhrW4EClocrEVd895NL3m2MTAcJdPPpePWaHLPILpIJBYM/KonBQ/ym3VGvdDJmPYdk6WC/BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715814413; c=relaxed/simple;
	bh=QkLKdkCGVoaDNAoYveMhIQ2uCHmgGqGE4BpWOF/A2IY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e9dRd12QjiM5AgRLJh3ZenzgpO/PU6huEY1qtZtlcpOLcRimkJoFcI2TKI4LcKWYY6k6R1eI3WwrTXI7dTBhe3QIP68h516fveUgeRu4f2vpx38KhKxyLUkD8cdfdpLgNMhf+khlH8TBK2nDJvSO1D6wVyCjf5AlAg0zgOvf81E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ASSK6RcH; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715814412; x=1747350412;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QkLKdkCGVoaDNAoYveMhIQ2uCHmgGqGE4BpWOF/A2IY=;
  b=ASSK6RcHKpP7nGZXlFJckPn+G/kHMY+eyJCVS1XuE2Lhdyz8yweZ8KG2
   FrvkRJBwrbw6J/HyItUXOy4tdpRN8nPVT6E81dP1olwkofii43LteDd0K
   W8aypavAhKFshmINfKtnivqbp/DuzZpdnKWMGS7w1w3uX6jhVgbeObc71
   uvgB4KQsS3ax6P+W8+eAwOuAQpA0bCW3SI4N0IVt66HvO4GW0oor1BZGh
   gt5Vw7JPcRYi8q1BiF/Fn9yq7RljtjZzMKWmqitD99UKHBsgBKiiWGV1h
   RfY4/CEllrBlTRibPao13Hc39RIAA5CWgjR45BOCZobbEIrZZs/breCCN
   g==;
X-CSE-ConnectionGUID: gAaJ/3wPRbWQxWvYuSpzpQ==
X-CSE-MsgGUID: b84XfDzdTSiPQut/SkdISw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29385157"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="29385157"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:06:52 -0700
X-CSE-ConnectionGUID: LKuI9y4iR2OjG5DoKo/K4w==
X-CSE-MsgGUID: r+Uo6CvCSZmOMngHRgm+YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35748538"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:06:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:06:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:06:50 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:06:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM9h4iwlh1loieLsgHHUkKuZO50TJvBXRcKtjTPOvyt4YGaXyPfYyIknFFdkGzdjPSilVI6QnHiPEnq5QYYxDJmD9wFHI5KxkMjZdtD2YODZgx7IR2k4Q1VO1RDbKP5uAihtgAvxiuDg90TZotZQ0GkqRez9UBK4X2vAMilQ6rq9/e6K9GNkZgqsFm6jgHIu5Gw8ALZqY3ookyiG+4yYhRVibEFLwdAfEgDEz8+caxBI4FU4MM7n+wV5XWb7KJ0Tv/NdsOUhHdIHkLFAViE0kdSUe+0rvEL2Gq9pmNOp1VfVZI1I3FBxpaGPlEuvR2uyIm4+QXBLo8z97BMJebW/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xo7xw4KuOjdUXhQWvPu1XH2/5FIhPoA1bOmVrQ+Zpxw=;
 b=AhAObRfZH4094Fwj3vkxWl9igy2DsLcGCmpbWFgOLSErsVJFOHsIzmPgvg2GhhqlfuY+O3w7m/t6okrx3zr8PuRkLgfGGbxDp4j8ACfArTGBxw/46MT6Q6QFcVF1qKhtmyLHqcA1/OehjLrgGHmr2k0PsE9P2DujtfOLWwNtKkbcs5Jyokv/+tvR3Anqk82oEcBSymO4Kuk5xiKGqEjGYcGlUHaRVtahVwb9T3KpCMvHE7qD4nRHPrl4eBlm47SNTB/8xKUXoKQZstWXWTPaVQhOo/ja+KWdf50TdwJOGQBjsR5RPZAc7BJBlYrInsfQfhQ35Bar7E3YqyFs1qghaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:06:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:06:46 +0000
Message-ID: <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
Date: Thu, 16 May 2024 11:06:35 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, "Erdem
 Aktas" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com>
 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com>
 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkU7dl3BDXpwYwza@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB8718:EE_
X-MS-Office365-Filtering-Correlation-Id: 94af8e4d-d428-4779-b10e-08dc7533b0fd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dFIvNGNkdnUyYmRwVG9IWDlSVTVkQk9IVzJrU1BBVmxTbnp2VWlSazlYbWF3?=
 =?utf-8?B?b3BLcGNadG1BamJpd1hkZllNN3BMeXpHQ1BpdjAvYmROcWdvYnZwc3R5QVN1?=
 =?utf-8?B?SEV3S0ZYc2o2VkVxanZ5Q2xkc29Wc2hiMWZCSGw2MjJXdDYyZjgrTGpJVFBq?=
 =?utf-8?B?VWxSSDMyTG1SS2dib2xhUUttZEhidXpwZTJrZjZwY0NWeGkvTkpVcFIyUDJw?=
 =?utf-8?B?NUlPUVNRQ2YrS2ZRMVJlVUJEc1JqbHUyY3JFQ1lHZk9RaFA3QWV4eTBENnVl?=
 =?utf-8?B?aWh2OTdJRVNzcGo2T1owaXdoek9BSnBFSkF5RWs3dzJXdXF4YjhlU1dHVkxV?=
 =?utf-8?B?UXo2c0kxTVpBaUVMMjdBU3grdlFFZFFCY0Q3M3NHc1BtNVcwUFphbWxVeitE?=
 =?utf-8?B?bkhwNkhFSUowa2YvWHdEZVpleEFkR05wYWNsZ29hYXdmWmEvdU55T2J2Y0tL?=
 =?utf-8?B?WHZoUFdNRkllMDZLUWNxajcycTJrZVcrWWRMRmVXczBnYlllRTJmdkxvMHVs?=
 =?utf-8?B?VFFUcnhSZG5RQU9ua1U3elQ4OFcxNlcyK2F3dkI5S2xZVHRVMHhpRnczVUFD?=
 =?utf-8?B?YW02Y3AwSkN4UE0zb1hZRTg5YVZxalIwSUc1b2YyOU1zelRRL0ZxNDRVeTF3?=
 =?utf-8?B?aWZzVm1ORWF6ZlF6eGRzWjJsZHk1Q1JZNHFpeDVNYWcwWnpMbU4wWnRLVFlX?=
 =?utf-8?B?OEZZUkRld1ByeHYwUGFYOTcxcVBRMFBvQmxSNm9Pa0hBejFoSkdnZ3dTZnEv?=
 =?utf-8?B?Vk4wNmwrcWZ3OC9XK0U5R2FNNGlYZHljSU9pTGtQN0RMbUZhT01lalJkejRk?=
 =?utf-8?B?alFoSG8zWFMxZGx3N3QyR25ZTHBwUkdLaUFLZE5Ed3JKa2hsbm1GYmdtT2RP?=
 =?utf-8?B?RkZDbU5ib2QxNTBrckk5b0VPSi9QTU03TEV6cnpJS1VvYnBsVDY5bG1QQUwy?=
 =?utf-8?B?T0dwdFN4YmlrU3FjY0JSVlJibjJFOFR6bXpOTEUxK0xwYnhkaStiNkZFTFkr?=
 =?utf-8?B?TVpUZFpMMncxZGlMck4rNW15NUZKeUVidVVMU1dxS3pyZ1plVnFtMmw1aW16?=
 =?utf-8?B?b0xMOFlVMlU3TG5YR2JZVWt6UC83NHlJM3RPTUNqYitvRTdXM3ZQU0hMUXRB?=
 =?utf-8?B?SWRqMGxYT1ZtSzNuTVRzN0JVVG9kWlh2K1FkcklmdlZMZnh3ZGhvM3B1Qk5a?=
 =?utf-8?B?SEtaRndJWmsyWmFqR1hwOVBCMDdqbkFlYjZUQ2daYU9QL1A5d2JEN1BGU29L?=
 =?utf-8?B?RGtNTFNlMTFkKzl6Qi92SlA2WENNRkU4Q0ZkZnF4eENNM0hPbmRjTkhZOWgz?=
 =?utf-8?B?YTI1VHYzaHI2ckk0YzViOG1XdW5HaFk5ZHVxeE9MUUNRcmNLRHJZbHcrVWdZ?=
 =?utf-8?B?cWJRQnRQY0VVeGlhcXNZNlgrNjAyNFR0S3prK0htbVc3Y1o4aHk2T2x6aDJM?=
 =?utf-8?B?ZGNTM2JxZ3FNRWI5N3hwTzdPNThJNlArN2hoUEJlbW1vTUJhb0JNcnZSRHJL?=
 =?utf-8?B?ejJUK3ZMLzNjbkh4bEcrN0w0RU9oVi9kUjdCMGZFeHphaktjN09VNVlwOWNu?=
 =?utf-8?B?TzA0eCtFUGZpUkdDTDZiNmY4YlZxZWhrMWJJS3FFNU03Y3JkTlVFMUtldWJZ?=
 =?utf-8?B?eXN4Z3d0SCtWdEZvUS9ZcHRrY2xaZ0xYV3dFL3JCaXBJL05ORW9RcDQzd2JI?=
 =?utf-8?B?ZDN3Wmphdmxqay9peHhBMWk1T0FBTDlsSkE1TmY1eDFCeVVHcWhUcTNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1RuNWxQTmZ4QnlraUdsckZ3SkcrS1V4OGlBaVNycWhkelNMQ2NaTkRmbm1s?=
 =?utf-8?B?MXZFS25Wbm5iNTM2dElFWlZyNnIyaXBxbFZOVUp2bFRxQ0QzaWtRejF2Q3pZ?=
 =?utf-8?B?cjl5bUQ0TE5wdDlwTTdnSHFOVVI1R3ZqU0ord3ZIL3RSM0hML2hMeWhlTnFx?=
 =?utf-8?B?bU9FR2djVjk3NnI3ZXBETE1KcHI4ZS94d0JkU0doSzJwNHowbk9RVDh0RldL?=
 =?utf-8?B?WUNacEk4UXJ1eUJuOU9URXFwZkd1N0Q1RGtiSTdLTTVpQytpdkVqcGUzMEkv?=
 =?utf-8?B?bEV1QnUxWStoN0VaT20za1BRWTZKZ3VibUtnM1lHS1pHRHFYT05VV01rbzlK?=
 =?utf-8?B?WmNja2pUQ2kvYXQ0Tm1zc3VqelEvV2syR1I5YnRGSm13UXRDYWM1Yk96SDBI?=
 =?utf-8?B?cGRKTlcxTnErSS9TUjRKNjZpUGFnOTBPWGdWdS9XRXkvVnI1NVdITVhsUEhW?=
 =?utf-8?B?SjFZOFhwUnc4aHNmcWpnOXZVQWRHcml6SWRLRzV3aWNmanpMdXRYRlFXdXo1?=
 =?utf-8?B?djg5N2Jwek1MY2IyOHhPdEpnQ01SczlMdjV3dDU2NXBLK21rWU1qQU12MGVn?=
 =?utf-8?B?TkVTc1NMaFdncjEvNmNBUHpVTVFqVmk2czg0bzI1T0NQZ2tMMkN0SjdDbUUr?=
 =?utf-8?B?RS9YRUNXS3IyWGsvaGVlNTB3R2htNytscXFTSTRTQXNteU1NQWdYdFR3UUUw?=
 =?utf-8?B?QXlHc3RmanBkZ1FZQUV1bE1HOFVxVTNzckxVcVc1MGFyNUhyQW5ya0pEMnJ0?=
 =?utf-8?B?cUFBcXVuZUxOc3BwMDN1UExPSmRZYzExWHlQemVQcHZKQU1WWWs0MW44OG1s?=
 =?utf-8?B?NFVRQm5ONG1TV3dCandPWk5NMi9pMjlZY3hJZ2F1RHNMWmhlYUlzUDJ4eXpW?=
 =?utf-8?B?K3lnY1MrYWlVcCtpUDlaVGVDd1VObXRaZVBhaUNIOXl3OUE5d0d3OVdJR2Ny?=
 =?utf-8?B?d1NWdFRiTGNpUk85UVVDd2JsczhTVDJqRWxxSnZ5RXhpUHFzQ3ovNVJBUGpR?=
 =?utf-8?B?aFprY3Y3YVhpTHR4RjZLTmhDazNCWndoc29XMUxPUzdoRzNLbXRONTh6M2Vr?=
 =?utf-8?B?dmRoNDRWdnFhTE40SWdtOWNmRCtvZHVTRWhLcjZpU21ISjF5NVpDVXl5WWRi?=
 =?utf-8?B?YzBaSmRQcU95MUtKclNYWFVLY01xbFZLWVpQZDZPNkw2NjV5aDZVdWVzK05Q?=
 =?utf-8?B?bHJIM3EvQ2VVem1SQ0ZlQys2QUN2NlhFMEN3NG5DSjI2OTRuZHVVcGNvQ09D?=
 =?utf-8?B?dlprbk9XakN1OUN3Y1dJZmt1ZnlNczlVNlUwYjdGOFllSzBFWHJnbldDek55?=
 =?utf-8?B?TjZRbjNUUkg5Z2ZlaXdXT1ErMEdOSWN4b1JsRzcvaTdSN2REZ2tKcS9CVXc0?=
 =?utf-8?B?aDh2aVZzMU5TTm5odlhabnordmp4NERqblJkaXZaaGh5T3RYT2JldmtqVHFE?=
 =?utf-8?B?SWViaEw1VmJQN2UrVEJ2b092WG5oRE1GRll0S3huMUpMYWgrUFZDaE9Wd0tN?=
 =?utf-8?B?RE12UmUwT3RMRGFFT2hCaHgveWgrYmJoMWlwdmpwTnltV21xc2Y4UGZGenRh?=
 =?utf-8?B?cC95QmY5TUo1clZBT1docEpzMWNoR2Y0RjdvakdLQ2RIK0FnMVBDMzlRMTQx?=
 =?utf-8?B?dTJSdmNNdkpjN0Z5a05iVWpyOXl4bkpSaER4SnFKdkRjNU5Pa2lNM01mZTIz?=
 =?utf-8?B?ckV0c0xUeDFEUmR1STJpU0lPQytmRGIrWFFhYmk1aitLZ3RSeDlrOFRka1Y1?=
 =?utf-8?B?TTB5SllSbVg5Tit1eFhSQ3poY3lJOGdQRUY5SDN5YTcyT0ZVcXhIK2ZaTTB3?=
 =?utf-8?B?eXJ4YjBlSTBMTU1MRTV2bkNrOXN4NUhDSGZWU2daTHVWM2lSenhwSmZHaTg5?=
 =?utf-8?B?N0gveE5scWZxWk9saEd6SDFJY3pWVllkbEZDVkM1amUreW9ac0ltU2REbG9n?=
 =?utf-8?B?dWY1amFoYm5TeVdFMzdUT2dZdUJkWERRS2ZnNVhEWWlCeVlLWmdxdnRSdWNT?=
 =?utf-8?B?Uk84REJvQWZSZHFtR1JDNGhxcmRkNytTUzl1NnpVNFQvZmFjOFBzaWNBR3Bs?=
 =?utf-8?B?dmNYSHlTYnVkN1lwZXVTOFZGcENud2V3QUh6VHk2M3kvNjdQMzJoZmxTYmhO?=
 =?utf-8?Q?okN7fO8w3u8Wt7HLaj2/YENjo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94af8e4d-d428-4779-b10e-08dc7533b0fd
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:06:45.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtMd+b6ISj4JwFq9+OyBKa/wGlwIUBiJNeZ1bxFjhWBZ8ml/Qq2CKvYNzC4ul/10H93xDjdWag7Ud/XKRPoDyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8718
X-OriginatorOrg: intel.com


>>
>> You had said up the thread, why not opt all non-normal VMs into the new
>> behavior. It will work great for TDX. But why do SEV and others want this
>> automatically?
> 
> Because I want flexibility in KVM, i.e. I want to take the opportunity to try and
> break away from KVM's godawful ABI.  It might be a pipe dream, as keying off the
> VM type obviously has similar risks to giving userspace a memslot flag.  The one
> sliver of hope is that the VM types really are quite new (though less so for SEV
> and SEV-ES), whereas a memslot flag would be easily applied to existing VMs.

Btw, does the "zap-leaf-only" approach always have better performance, 
assuming we have to hold MMU write lock for that?

Consider a huge memslot being deleted/moved.

If we can always have a better performance for "zap-leaf-only", then 
instead of letting userspace to opt-in this feature, we perhaps can do 
the opposite:

We always do the "zap-leaf-only" in KVM, but add a quirk for the VMs 
that userspace know can have such bug and apply this quirk.

But again, I think it's just too overkill for TDX.  We can just set the 
ZAP_LEAF_ONLY flag for the slot when it is created in KVM.

