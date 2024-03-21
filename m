Return-Path: <kvm+bounces-12435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 153968862A0
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46DDD1C21C26
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:40:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558F8136651;
	Thu, 21 Mar 2024 21:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lpsurr0j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89475288AE;
	Thu, 21 Mar 2024 21:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711057237; cv=fail; b=UtFpUjJTBBBSJn/Mt0I8gH4IWyFNUXTRraR2rAUK6vVzbzVpQZrke4ImZUogGle6AWrJdtTDV45tbefn5omwHO6RWUn5qiLTkHMhOdhykDwyCsHJCd2Y91StGWe40Wb9k5QfByr5MEXlNeeQPv7iUsIgUqZD4a8LXNVC71SIJ/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711057237; c=relaxed/simple;
	bh=k0pbCA6SPFrblVgHEihFQ1aRcEZ96kYKHqZWBNHKe5Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ap1wgtPumfGscbXrTBWyso5K0X8NuICQfwMle+o+cOVR/nbLeJsq553sVSvr6a+5RsPxVNnp5epcaicEaidp3FvNEnYF6eTqv6w1atn/4HcUbPSVCyAnQ+wDOXuWyRXJTdOzpQkhiwvcauFEfl+4RyLrZVjLLDCm6L8SMLbzxc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lpsurr0j; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711057236; x=1742593236;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k0pbCA6SPFrblVgHEihFQ1aRcEZ96kYKHqZWBNHKe5Y=;
  b=Lpsurr0jO4rmt6Tcg4XiiGfcZYjL9peF7jrHaEdTwyy3rhA7O8h4c6t0
   Qi/6Oh+eCpUXUkcZ83t4RXdbkwUO8R8O+p+3RjUvC+2kj4/MzHVecQaXf
   CLnPQRg57ZIU5b7pa6g7T/UziIspb6QuSN+IVnsdWhCsaRjIk88pPrFUN
   /8sEeM1JwFBa7vCvZPa+DeEUL6kwxyAGp02rVhuv/Vhz23oSny1dPoYZ0
   CGMe2Bb1IoQdqjPqgmCA1mrAX1FeZwS7VDvjr5McoM+R9BicrcFxIRDx+
   l+DKB1eNJsB/804A1f2vExXXrrnocMhqLcaEf5wmqA9JaZfy/FeLScDf7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5947998"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5947998"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:40:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="19229438"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 14:40:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:40:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:40:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 14:40:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 14:40:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvBHziPfvc6GUB3/4zvpRJh4ZNR+7I4O2e15PbmYETTbKcoyKAt1lLxzyrRa9PrF2amtLXeJbMuhZkQRls1Cz+/u3jC+LN0/oOxWSP2R13mM5DQc/odykrklT+3mMT9Nn3C0+unkcVF7mX0C94eTjCL7AFQ7EEA3v/U+ALiVh1DwRfT69XdCy452Lc9J5Yodx3ke6g+eWFuwJ7+ZJHtvex1an88g6RjQOC/+OoZMhBCfkmlbFfcjizYchGZN2+Xm3QpNBdbfDvnOdRjgbkUSS1kfm5CdY1zgpaqvvL89eLXhrf040JCJp6qyFD8lq0iGqYDS0iIi2CPaPk5n1FAqoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjzCucdyw5ljvZUA0bHlM/qRG8ZVoEq3wjbCWMKmzeE=;
 b=MhnueGW+/JCv/DkxxlYS4lQQmFficj/h1skHw8sNpvKJ55PFeErq641M1yFr748IE2TwkSgqglT99p5tATHU+T1fvkjqjYKt6XNRa8THaAstBoDLYRckBCy7DEFSpin7uvHquokLh3Ex8HQeDOVnOFd3ZVcCdBCKflUKSISlLryrfnqMBrbBPw3VZ3ZGb8eRFTNSA1XWY2pcjGeJrir24fxMKzyqK0CA1gzi3iZwxSi3WghXwMSJdOfHcQyAx3JD1AO3wV8vyjKmcwCXoOsHfbkQuFoCgXsiAvdrQYlky2gA81iNo9+mtA9jkPDwVsQFopkt1A4eWf5tvmkTvG4how==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4627.namprd11.prod.outlook.com (2603:10b6:5:2a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.23; Thu, 21 Mar
 2024 21:40:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 21:40:31 +0000
Message-ID: <de9358c7-4ec4-4966-a5e9-16e38b0b9500@intel.com>
Date: Fri, 22 Mar 2024 10:40:20 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 025/130] KVM: TDX: Make TDX VM type supported
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5159c2b6a23560e9d8252c1311dd91d328e58871.1708933498.git.isaku.yamahata@intel.com>
 <f4961c6d-aa67-4427-bcc7-17942b5f1a9b@linux.intel.com>
 <20240315213638.GJ1258280@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240315213638.GJ1258280@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0358.namprd03.prod.outlook.com
 (2603:10b6:303:dc::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM6PR11MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: fbff84c5-e640-4a5b-5bba-08dc49ef888f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76gzG/IF67mN/PY7poOmDFqV4r7chU+a6OZwOPM/l4J54XL3zOxpzlrnNoKlWeKL15P/diIMda9CQRYwCHPaChEoRtfqxQrbwlOahHrbn0XKpnXm3gdROIxE2kF+HCuortY+KccU3+xbHliv0w1kOYtNpmZEfIZkH19ThTN/GjALJ4tA0J6qu3bN9hNXJOjYB6foVI1ZgkwNr5wRr0pu7ynxgP71j6wXWw2qoyvmbZvWrYOGg1IjmCRyDbFPIBq1J21/Yp6C/E8gaiVfFSZ5vaohWAsO+GCWMwvh/SlFCbGSphf6x+LHznLkP8CWW6m417VN8wv+WfpFWPM9mek5UIRHpz3Yki36boD6PtngnZgTDHl0hG1xAt4tLu0gujtqhsigM4ofYuBfSd2Go99lU2zhZqS3atkCToG9/9vHV4x9GzSO6E8aW0X2MPt9x/4wYN/l0fPm1Oob4SAGO2FFt4SWpWGUp6KxFn8QdzzTpkEnUpK6DQP2I5txaWMZ/eW/xGiL0WGnCj92KEMSlAHuqis8jxv+Z8hVEubm5JMNnyg/Zoww3XkiKS0Lyzk2BCEy1dMiihG39AmPO4VRB5lmZVAUN3L+Yb4gOsikotPoyMwoQj9yFbR6Dat2WEDm6AhkFKJk5JluYsg2jM3esRtbOW8VxqGQhfAuZBz81An0VUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WERaR3Y4MmZyK0duMnB4UG5rWTVXeVdaWmdETGtPUEJ4M2c5WTFlWkFDTTh4?=
 =?utf-8?B?V3Rib1huZjAvbStnWHFTbXh1UENRMFkreXdvZWFTU2NCbVd1Qk9xZVBReHFa?=
 =?utf-8?B?aHBKTUdPUTJwS0xwaEdJT3VuT1FWQnczWlV3UjhxektEamliVEtKQzlRajRU?=
 =?utf-8?B?THhLRDUvMkk2bnpid3hSN2J1ZUt1cmVDeFU2UitlQ2t3aTAwM1JTdFVPMzVN?=
 =?utf-8?B?dUZveWVaYk1aemtEVDVoRS9yL0NNVVkwSS8vTDdYOGJTTkU1VTN4SEJOdGZH?=
 =?utf-8?B?YzBUQXdlZWYrVlJWMC91VXFtTmpnemlYNlNCN25CV1g0Mzl2YjBURC9jUEtu?=
 =?utf-8?B?R0JNNXdsZUlWUzZBRG55aWI0RkJjMmt5VDlST05MNnlmMTRjTzF2d0FEcFZP?=
 =?utf-8?B?VEhLZU1ZMTF3VmVEWVg5Z0RZWll5MUZ1RzB6bkJoOGRvbU5Edm1naEpiS29z?=
 =?utf-8?B?cDF3OERtSjJtVUxtQWt2NkdVaFhLb3JlTlJGQ21nVk5IbzMrdGEvaFVJNXAz?=
 =?utf-8?B?Qk1xNUR6dTVCV3Z4T2pYWU94a0cvRU9SMGpNb0RnYlBibGdTOGlTbkdTa2M4?=
 =?utf-8?B?RFI4M0czQkZHcmtZRFFEN3BZSjZKM3hxTExOMU9GeHRoeUVtZlBWR3p2c0hi?=
 =?utf-8?B?T2M5RXRVdlZyKzlhRFZmN1FUY2VNV2tsRy9xRktmL3RVOVREQUZWaUNVNklL?=
 =?utf-8?B?QWFmRCt3VjR2THRxUkdmenliZ29jVVJOWmhxUmhWQTZxTDJCaFA0TEJtSGxU?=
 =?utf-8?B?Mzh5d1FmNTAwL080MjE1QVJpZnZzOWdFMVpYQWtheW1MVFZ4ZnN1cGs1dXJr?=
 =?utf-8?B?cndDOC9Qd2VISjhUanJyU215MTFTa3hiVkdaUmxhM2JhMWtFeWFlVUpCSjVu?=
 =?utf-8?B?ZkJJL2pvTCtDdUNoOUxNaGppL3lMN2M4UnpCc1lrejJSMjQyaFhadXZwSitC?=
 =?utf-8?B?ZzVJWEFCd0xxNVhJNHA4L29FdVBTcHlCZ2RISU85Q3RDa1R2a3M2VEtWVUhy?=
 =?utf-8?B?OUk3c0VYMDg4RVZhTEd4M2Jtb2xDTUxKeU1peDZueERpWElZZEc0NkVHdU11?=
 =?utf-8?B?SG1LTEMzcXo5U21aU05VWDUrTUFhTGhQbC9CUmM2K2NLb1gzdk9yRTY3RTBE?=
 =?utf-8?B?QndmS3dXZTVwK2EvOG5DajVDUW9xT3VJUm91V0ZEZjdnZUdlVUliMFkzNzI2?=
 =?utf-8?B?UnIzdG5KRTN6WTBLUlpobi9lVlpkNkY5TGx6aVJCZXlkcXpLOFl3VkJ2Rkhu?=
 =?utf-8?B?Mmg0TkI3Y0o2eG5lOTE1UmN0VmdEQzZ2akVQQ2Y1eElNSkhsVm9LMExRVUJT?=
 =?utf-8?B?Uzk0VG94Vy82RFphRHlpRmo2aUZWN3p4ek53ckJCK2RVMUh5Tm9nRGJJZEN1?=
 =?utf-8?B?MWdiMGdiY0xUVktQWGZnVVlYRzFhUEtJTWZjR3FKM3RUd3NDeko0ZWI3Q0Y1?=
 =?utf-8?B?UVNTcnVmdzBuQzNpMEJNSmhYdW0wK1lYalpZUExYWXlIWUpRTXdweXordk54?=
 =?utf-8?B?WlV3czA5Ny9VMmJZNk0ycnBqZUxJTVBuY0VqTzVCbGRNcWgvT001SHlTcmU5?=
 =?utf-8?B?VjdCczA3N01sS1EwZHdDL1RFajRVUWZWb09YNUplRGRWT0JZM2tSUlltQ0l1?=
 =?utf-8?B?ZFdQUnBPcm5UNHRSVG9ncVNsaGhKenMybXkrRzllUmQxbkgwRnJsY3Vid1FL?=
 =?utf-8?B?L0dEb2R2cHZrMERQM2I4TWdDRjlmL1MvdmUzN3c1RmhGbU1oeTBmbzc1Tm0v?=
 =?utf-8?B?bUc4M3R6TjQrY3VmOXdRVE1LUEVYSjdYdW9wTmZ6V2Zmd1dOYVk4VXhXNmRZ?=
 =?utf-8?B?dmdoMWRGbUVvY29vVXlKb25UYk1DckE2K3gxaGFIWE5way90ckVZTVM3U1h5?=
 =?utf-8?B?Tkp2UDBFNGxyOFlQUTczYnovcWpsODFOUVQwemR3NXBSMEQ4emdscUNjY3ZW?=
 =?utf-8?B?dE43b1piWnJFY3p5WGpucjlQNHlnSzNydEc2NjZoVWVUcHF5aVhxYmt0VHJt?=
 =?utf-8?B?QUkxWFVhdEtsblR4cHdJb3FIT1hKbTJXWUFJVURoM25NRU4rWDNqcGR1OFZp?=
 =?utf-8?B?dkt3MHhRNStjcUNJN1ZaVGxwRysrdFR6ZVB0bkFlNE0xZHN0MFNoc3psV01X?=
 =?utf-8?Q?AumYcnLBpwkxto2NFsmVZTdfP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbff84c5-e640-4a5b-5bba-08dc49ef888f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 21:40:31.7866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVS2Blwcdc8WOB2agh0/WASceK2bca7j3GsZ0Ofc2AtXox6vJVqCaB2GOHN3iWV+RLS7b+iCUCZhhM8DQU3XqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4627
X-OriginatorOrg: intel.com



On 16/03/2024 10:36 am, Yamahata, Isaku wrote:
> On Thu, Mar 14, 2024 at 02:29:07PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
> 
>>
>>
>> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> NOTE: This patch is in position of the patch series for developers to be
>>> able to test codes during the middle of the patch series although this
>>> patch series doesn't provide functional features until the all the patches
>>> of this patch series.  When merging this patch series, this patch can be
>>> moved to the end.
>>
>> Maybe at this point of time, you can consider to move this patch to the end?
> 
> Given I don't have to do step-by-step debug recently, I think it's safe to move
> it.

Even if you have to, I don't think it's a valid reason for "official" 
patches.

I agree we should move this to the end after all build blocks of running 
TDX guest is ready.

