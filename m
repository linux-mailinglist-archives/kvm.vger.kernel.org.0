Return-Path: <kvm+bounces-12434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D0588629A
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 229481F22F7D
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE4D136676;
	Thu, 21 Mar 2024 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acWoNl38"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE76133402;
	Thu, 21 Mar 2024 21:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711057074; cv=fail; b=p1D6FwkQ1LA0PhLH6d5mmHg0r0rK0mVr384SJHT8TKissw3/v+Y515hwC4yq+cHi4GuFjsz8KuHxchl4RW5HLC/O8Mbi1p2Rfek2B/Xir0hl1b/BG6MgYH3kuXCIvdoYW78Qx57lgsh6AGJezfPjkWoyBJAhO0xXcNV24f/22SY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711057074; c=relaxed/simple;
	bh=W8ncFtsOHkm23Z7DM+hCcY1g/cQbgbmxiFUSCw1tWHA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NQX1wyxD8FIPO7xZBTAQFzdUXojnN/GMnoN8A6EJS0ee0NeJoqZ+0FX4TjbsGUC7es717uqp/XmyX5IBC18FftLKxVsse9jxkiP3Un4VQcQ/UhpLfJrV10/sGqQI7Jbl08czADH+Dwe+B5TozmhiOTbvEu9J8rs4usyxnbWLZbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=acWoNl38; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711057072; x=1742593072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W8ncFtsOHkm23Z7DM+hCcY1g/cQbgbmxiFUSCw1tWHA=;
  b=acWoNl38bE3Gg/NjDTDPimxdjknK0bW2KeyhZWD/7Y3Od0BZ+GIuS48n
   GlG7lElny8sRsZvwJw/CadD/XQf9f+ZC63YEN1vNbAgPtEfmdA6m6d5z/
   jOui7sZSgSSMvB35tybUnyaUNFo4KdvdCiitiQuAjmWn51bANyFbj5F19
   JKlv0s95cst5/du89tyXeqcyk1DSctgqZNMCnO1RDJruHgAD6EDti4KaH
   geJVpJZK5tE34TTk5ErJzMYq5y8lbt4YrRCEprYcYoifS3d9Jb8UHeYsu
   ay2sVqIkXN4F36Kt8PSjohHJ+Gut2QvwVhF38HOtNgCQLB5sSkr8OHtt3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5941142"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5941142"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="15065430"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 14:37:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:37:51 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:37:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 14:37:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 14:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMvrsp8YFgfFMWzWAgNMuzHXx1+CZdAawHulNMC7dclkR+4DTMX1dNmr+C0b/mMnYOeyn61lvn5hBrqc68I/avhhRnEngEaDPMe5NCeO7b/I+SqqK1aazLOk/IQz3AWD7PlcsVH3evtBzI4N+jG4EyhD7rre3iIURNXIXH58loLSNxTvz2ppOH+r2q3RV8zJ/gC3p9+IYKJm7EzB7OzFD48jjWQqdmVqu3XnhMJj5KLHFFhC8jRW5j59QDWNbXb6o+dOgfS25wt5tvKu12cb2TjRzblrcGzvgCGBKcjzEwrFpC9NeWRu0ejxBzlNH00zZL3H7DpFAQi5qTlSLlj5tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOQ3YvTdUrwqejYup+R0lNotpHaHlXvlVXpaa63qpHY=;
 b=YEDFWhdR3U7aWcAc9gJjQ3ykCip1SmUYleqd/DoUriWtEXHjyFCuDTDQNla9dY1VebwxNWCM+aT5EgSgLzh8F0E++jq9X9Rc1pEF+NdpPiBHhNm0aAHdce8a/MTTiH9z6TPMJLStZFL+4phO9hq4iPzjUJIrWzK/kGTYZnT93PwXzqZLZfUrh6eeC5osjSHSA5fxgCcNYyjtOuc/1pTgbuHl0x6HprtQikHGlX9Q5LfCk6qKatvlo38ANlHXUEcus4DB7fL8d04GumGw2jbg2j9VXvvSseIDeJS8Z0AUCDeezv3rxy+qVm4Cj4IvlcbMV3UxZFUblPZt59AFUomp2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 21:37:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 21:37:31 +0000
Message-ID: <dd389847-6f67-4f5d-8358-5d6b6a493797@intel.com>
Date: Fri, 22 Mar 2024 10:37:20 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 024/130] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <c857863a346e692837b0c35da8a0e03c45311496.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MW3PR11MB4554:EE_
X-MS-Office365-Filtering-Correlation-Id: 11969240-71b1-4ae2-6657-08dc49ef1cc6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYrYsIHIDrpW5u1hhuwfpZKqDkrcYH/iIVLkj77N3SlxvOJ0Gl86jMAsTOx0D/4SqHXJGC6x3IekkShPygM+PhG9AX7NyaZee36ygi4vp2m6pHjDU5IAz1W0SZcjzQ849YWPMOa6u/euOR/d454Qy36aXPu7UT4WGYa9SoZ9mUorfKm/tJrkbR5MqSCupCBqZmkjELrFnLHiIHDLHFo/sfJJLNZ54Fw2kS7BTTSrN8yTpF9/qPlWDxjIpp52pAOdUFfSeGBj3kq34GtDtBytkehfR/2zOiOgk3++D8zjieCdKOr2Vq/vpE7yypePVjCAmx6f5WvmDCa1MEhY71fZGl50Y17ZatbXycrMTPuIj0uvFVgQLIBLPzy2nc+JPB/vPdcRSujDK30h8gon/IdrPTQ+ogg6za6zouszURecpPqSj9Bx5Pak7F44vuRVBu2J4o6RKR+h5RvPjrko5kCQhhcp7GTKSPrMN5beJWky2tOz03bncaw8M5mRqVwVgHv2x59HCBN2q8akyvdcvZMSpYtaV6v1LY/Kyc8+UkE8yv56iMU4deDDEdLUtcemLxtWoO+VgNh+h70dp8Y7IRjySdho1owka2cgWn7mCvJNGJyMAcUutHiraPSUEh/3yy192/EYOVBRxCxWpWb0RrEMXAPXeJqX062cjW6r6Uzndg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGlKWXgwWDVKZldqQmNabUo5bGphckJQMmxVaUhrMDl1WHBSQk4rclloWWcr?=
 =?utf-8?B?Q3NYZllGSm1HL09iTmhiL2xtQjBPZkpOdTZ2RmVmMzlDYS80Q25ybjNiZUdF?=
 =?utf-8?B?YjYxZ1VPYk1kL2RXeW5ucXJyQ2hqWS9yanZwa2RjdjFPZnZJUGJhSkphMEZl?=
 =?utf-8?B?Q3NLZCtXRDF6d092TEdrWW5LemRjRnQzWmFidllpS2l0SHdMNnhiOFVQZHNs?=
 =?utf-8?B?LzNjRXZOSXZFQXBnckRHVDN1eGp6c0FIbFdCWlcvZldnc09RTHZLZkZGRHc3?=
 =?utf-8?B?VHZqT0VvOWN2VFNYTEkwZXY5MWtpS2E4RzlWa01LdlhKeWFLMTYyWXpaMlBR?=
 =?utf-8?B?VTI1TTFyZzlMcFpWanpTUUx2Vmh5d3dBbHlJNmpOMDNSMW0vcC9oVlcxeU5O?=
 =?utf-8?B?dGR3Z2pZbFoxQlhRaFMrYzBGTU1NTVdKVDViOWFueGFKTXVwdFVmWDM0bzMx?=
 =?utf-8?B?aVRrNXhZUG5uRUh6WjNsMjZsUVhlaEdWWTVCdnhYV0FHNk5aSCtyeGJhUUdl?=
 =?utf-8?B?dE1Zbzczei9KeVRUZ1hGS1VpdnZCZW1NenMxVUxHRVFGWVlRTDBjVzlvdnJX?=
 =?utf-8?B?VWlPWFpMb3Q1bER3WHBaYmtzRjFhR2NjY2E4Z0pDUW5BWWJxV3BkNk53bkxW?=
 =?utf-8?B?TUpiZXg2VWx1MW9uWlNrSjROUnhqUy9wVUU4NFJJY0VWeDR3eHdqeWRvbk9U?=
 =?utf-8?B?eDhIOFRQVm10aGdHV3ZwR0NpNGJUN1pYcWxPVkorQ0pSWThwODFFQWZkKzVX?=
 =?utf-8?B?azdVdU5Vd2VVSkp3MjVIR0w4ZVVsMzdtakxWUlQ1Vzd3THNlMDFSUVk3T1Fn?=
 =?utf-8?B?OUJIT3hnNFRPdHpsOTRvMHA2TldjTG5HMHE4Z0RiVndrTU9OcGdLbE5pWkl5?=
 =?utf-8?B?ZkE4OXVlTmRZRFJzSkR6RTFaT04rOUUwVEsvN1hrdGs3ZVlEMzJVOXN4Mjhz?=
 =?utf-8?B?Uy9tRklIY1FJamhYZlYwWlg0YVdZYXpDOVdBVDZHci9vdFhmQnFYaFdvVW9Z?=
 =?utf-8?B?ZkFVOGx4aC9STzd6MXRoSGRMd1ZsUExkc2dKRjRIWi9nTjJxaklIbXRzRURI?=
 =?utf-8?B?bkVNcHpLUVdhZEkrNDJTM2NnQ0g1R1JRS3pqeEJmL3dNSDJBQ1VtdjhtTE9K?=
 =?utf-8?B?d1JVTUd1ckhJc2x3VFEyZUJJMGhDM3Y3QSt2LzhkdERFR21YV0doMlgwRm1z?=
 =?utf-8?B?TmVqRXkwOEp5bW1NVDFnTTBEZTcvYlk3bUxqU3lKTFYrcXRUeHBXc2JZUTVj?=
 =?utf-8?B?aFNmMFloSDFrUjlTRDYzY2d6VjMvNHMrYi9aWkM4TnE0OXdNNmpUdURRUWZj?=
 =?utf-8?B?cyszL0xRT1ZPL3JKU0xDTG9sQjNsRFpJWU90R095bXpNb3NUVnIzRnVEek5p?=
 =?utf-8?B?U0k3YTlXazZETy93ZU9uUkxnUE94c0w5bS9zUmVMaEZvNVQ1YzZ2VjgzNkJG?=
 =?utf-8?B?SVVTMVhHZEZURGJnRWZsRVJjRW5RejhqWjE3ZERzQW1SbTNERS9acWhGQUNl?=
 =?utf-8?B?SmNFbXNDTGhTRXFsTU9HRzZJVmVaK1RPbzhvQXgxM3BkKzNqQ1JITVdyYlho?=
 =?utf-8?B?SWM3YlBPUHJSN2lKcHRIZ3Y3MHhvSUQxNDBvaVA3c3kvb2l1YmF6ckt4cTZD?=
 =?utf-8?B?QlBwVWhxTFg1NFk1ZjY5MDQ4KytWTXlyRHRzVG1GaDBtZjVnVkxUVExFdGxF?=
 =?utf-8?B?MDliaHRKN1VQZzhiTWlxQk8yNTVXR1pyYUd4b01JdmdvTUw1bjUvZUt3RXpv?=
 =?utf-8?B?Uk1sSm1YSW42Wlk1SmcwRzZYcXRXRkxWZHVuSGlQY0lrVjJTSVFpczVCVFRk?=
 =?utf-8?B?c25za3hKVDdVNmtFTkhBQlRieXVleStOK3V1MFZoMEI1VU1janhMbGdyZUlo?=
 =?utf-8?B?dm1BTlRWYnFuQnE5ekRuMVpQRzFGUXJJRkxBSHZNRlp2Z1Fic1BKSERMbGtU?=
 =?utf-8?B?RTBPSHd3MGxKN3h1WE1SdmRKTCs3THFBbDFNZG12NnBtb1RWdkU1bWdlZGpI?=
 =?utf-8?B?Z09GeW15aGR2UFlTcndxY25CWGNmNHVEcTd6L2hCcTdjOXZSY2VkUU9CT2Ry?=
 =?utf-8?B?NEhiNWRKOGtmU3VrWXBpTkxwWWVsL2pCUTUxNm9KZlNsQUkxSWtEQ1F0UTZy?=
 =?utf-8?Q?8znDAGsMGa6w7EAwqmnhhe/PG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11969240-71b1-4ae2-6657-08dc49ef1cc6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 21:37:31.0078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kD8SSde3t+FZl/WwbUSsFIXLTxKP2Ju7Ofs6VE1a/7QuEPCBlcfJpSrBO0JE5fhZ7X15W/1JcmJ/rIkVe+HQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4554
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add placeholders TDX VM/vcpu structure that overlays with VMX VM/vcpu
> structures.  Initialize VM structure size and vcpu size/align so that x86
> KVM common code knows those size irrespective of VMX or TDX.  Those
> structures will be populated as guest creation logic develops.
> 
> Add helper functions to check if the VM is guest TD and add conversion
> functions between KVM VM/VCPU and TDX VM/VCPU.

The changelog is essentially only saying "doing what" w/o "why".

Please at least explain why you invented the 'struct kvm_tdx' and 
'struct vcpu_tdx', and why they are invented in this way.

E.g., can we extend 'struct kvm_vmx' for TDX?

struct kvm_tdx {
	struct kvm_vmx vmx;
	...
};

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> ---
> v19:
> - correctly update ops.vm_size, vcpu_size and, vcpu_align by Xiaoyao
> 
> v14 -> v15:
> - use KVM_X86_TDX_VM
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c | 14 ++++++++++++
>   arch/x86/kvm/vmx/tdx.c  |  1 +
>   arch/x86/kvm/vmx/tdx.h  | 50 +++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 65 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/tdx.h
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 18aef6e23aab..e11edbd19e7c 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -5,6 +5,7 @@
>   #include "vmx.h"
>   #include "nested.h"
>   #include "pmu.h"
> +#include "tdx.h"
>   
>   static bool enable_tdx __ro_after_init;
>   module_param_named(tdx, enable_tdx, bool, 0444);
> @@ -18,6 +19,9 @@ static __init int vt_hardware_setup(void)
>   		return ret;
>   
>   	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> +	if (enable_tdx)
> +		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
> +					   sizeof(struct kvm_tdx));
>   

Now I see why you included 'struct kvm_x86_ops' as function parameter.

Please move it to this patch.

>   	return 0;
>   }
> @@ -215,8 +219,18 @@ static int __init vt_init(void)
>   	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
>   	 * exposed to userspace!
>   	 */
> +	/*
> +	 * kvm_x86_ops is updated with vt_x86_ops.  vt_x86_ops.vm_size must
> +	 * be set before kvm_x86_vendor_init().
> +	 */
>   	vcpu_size = sizeof(struct vcpu_vmx);
>   	vcpu_align = __alignof__(struct vcpu_vmx);
> +	if (enable_tdx) {
> +		vcpu_size = max_t(unsigned int, vcpu_size,
> +				  sizeof(struct vcpu_tdx));
> +		vcpu_align = max_t(unsigned int, vcpu_align,
> +				   __alignof__(struct vcpu_tdx));
> +	}

Since you are updating vm_size in vt_hardware_setup(), I am wondering 
whether we can do similar thing for vcpu_size and vcpu_align.

That is, we put them both to 'struct kvm_x86_ops', and you update them 
in vt_hardware_setup().

kvm_init() can then just access them directly in this way both 
'vcpu_size' and 'vcpu_align' function parameters can be removed.


>   	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
>   	if (r)
>   		goto err_kvm_init;

