Return-Path: <kvm+bounces-10566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7684C86D7A3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 00:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF0CC1F216DE
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8910F13E7E1;
	Thu, 29 Feb 2024 23:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M8k+Nb1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B974C03;
	Thu, 29 Feb 2024 23:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709248938; cv=fail; b=eyOIhrMIVxZp9fiIlunx3mcH8ZOQEY6zxWW8xncFZ8gSEQd6xj9uAjFBRpRYyTDqVrcFohbtGvB8LCPNitQEMW5T5ZRCxjeefw+yzC+3nuz/NtXxT4Fq7Cu1B6ppr4yHeJHA7VqcK8hNQQ1WBR07xVXkHw5mJZEzdA1ska69KBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709248938; c=relaxed/simple;
	bh=nC+mMRTJFH2QIl70LiwWAZdiczYEiyGYMGVh3NJZ4jY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UhMCpXqo/k+nTUVufwcYL9TTmxtcExOUR3HlFJ6l1K6Fuv+loRLRD9uTy19FkJi9GU3AZdLaM5ujbF8RAqVCqaTR8j0AKJddtUHe8407bnjSqWosIrJFKq4xbDC+MXGjnWEHTX5tm608ErYjLgZEyDCQ8ZT4SnsVPnp/1iFXDTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M8k+Nb1v; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709248937; x=1740784937;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nC+mMRTJFH2QIl70LiwWAZdiczYEiyGYMGVh3NJZ4jY=;
  b=M8k+Nb1vv0zzWq3dJLxO9aHdzbvW7L6PRi2O0eBXnqd/LO3pk1V9HVtM
   dDy+3wcUYVhtITY5roHVbjfAkvh/yPHsHOny6qHgau14fOsneqoW7G0ai
   iiIVahmG/9xCEDG0IyHruzBWmSYrh0Yk8g3yTtGDW1pbLE7nxyzJZ7DCc
   1FvIAE/diMN+JCQp+9BDfxOPadDipJvRd3UqPKaA4FPQsLSCTKvOKuMCh
   YLkqWqPgqfpnuKKbqxxSmly+Bsj7ZQqnE2xa7pKWv+nBYh578MctwjOOF
   lXTxxni0Rn7y4fnq50pXld3QRi7segvrGwA9w6T0cg1I1dhQirvtfEYsw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="29191586"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="29191586"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 15:22:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="38835061"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 15:22:13 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 15:22:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 15:22:10 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 15:22:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrOeP5YKgheQkLFC6HxaQrkvK6RznJpnF8o5YbMIXIi9kryEKfOnn2hwnj26hJ3ei/M4Awk9vsEpKToW3EXRhBa3ArdxATlfISzcNPZdBKDMtLSPjTvAKLyjZb/nhkcsWaR0j7Kb9jkxb4lN05RFiwkPdrH0DjTIvutKYdshhdrIm6o6gLnlImXahJ4ZLKytDr3R/2ri0q+RPlPRshV9OAPeEWkXi1xYQkW6UDAfVb7fbZw0lFOScUEs+YwCX4arIGZcrkIWCdHkupWbdOMIB/x7GrQW81YfMhkYCCjy62bEJ4Ulu0KpMMPz82clt8+MJ+eR3Y0Ha0Z5sPxXTYBiVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fx0/WN6eJXrRkQV6JhafQqSoln9FUs3Swers0we3DOk=;
 b=Eyty51AB53/nKaredkry4R7++tdH7IsOjecdxez1Nu1gECcG9DHZF+whMGcmUyoTU6nDJgXuW/ETboQR1Q42J1giDeOzXUEY/ScI8v6nIp5Ns2zYAraBL51Gzb9TSxFm+QCJcTuSwp+X1ZgsXw7NXsL1KzqqcPrtKxkO0fe+8cJ5sqiBjQ3iz4JLmFKbH1+VqTpdG9tpt0rcPiYzBxgiOFQyPcgOdGISogX8UX0R3j1IooJ60V8CanBaxBBs3d4TKo57yz29miftyKS9RLgeUASVsRL+mTWlt3ghbv/rE9IbueDe7M0tXclbe6wj5qvHpoulHqYfXNaLagb2mO0Fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5783.namprd11.prod.outlook.com (2603:10b6:510:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.24; Thu, 29 Feb
 2024 23:22:08 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 23:22:07 +0000
Message-ID: <05449435-008c-4d51-b21f-03df1fa58e77@intel.com>
Date: Fri, 1 Mar 2024 12:21:59 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>,
	"Yu Zhang" <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David Matlack
	<dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-9-seanjc@google.com>
 <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com>
 <ZeEOC0mo8C4GL708@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZeEOC0mo8C4GL708@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWH0EPF00056D18.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ba20bd-b861-491b-3433-08dc397d3f61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBCbuZvvbzK0Pi4KS1Mf1sM1VhBZvGFT1BvVnrrvrdLG/BwyKMIEeTv1+s38Xl90BhmxOCgBGF+asz+bv5O9fBxERdvEXUmDYSr+sCkB2AsRIdoq+2GFOwaTN+q2XYT++SiC8Xjyh3GXKQLkOZUALG7c2WIDForCyhAW1F0UXDfrDIVk0/JFu7dHnMbqbcwnyHhMZBYoGBFgTUQn5udmawCskCYKbqcJa/an6IfQtJxQ6xRzRbd+lHDkJWu3umabR6/iB5/zvCaxu5jgzemYjVpvxdk3Dx/em+u19xO9PX1yA5yKidouoD/Nz+fs79Ra1V+iTsiv5d0nmF9YEjCSTXHtX27dAjvwQ6ZcDNz69tro8hmfOjFLGToV8q4FFjK5vH0gkhq9yC4SIw0CximIyOoBwhumcLPD2GkfNx1/cJ+/s2iFmrMDYYtD5Y3Am/3xZ5ggmauParyN+kwSnMmzHx8KsvuWShr31gRo9tG0ZiRQaW3NAl0ubei3ZS6XQctShts8+dSU3eQCZcII6OHBDEtzkhppZQ8Tt6B05IdgCgoUZuQcXco9DPZTqKSc8tlCckUsRHCY10Yo7R6H9+/W53Cf0FVdX07rzUEMB85/C2SHcNE4UdEOny7y+iFEQyzs7D9Mr7uYpyLjpE5vo4Y2Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmxLVWhVVHk3dVdQTWV4Ty8yNGNHalNtZS9YZWE2emVycm43UzdpZGhPOTFK?=
 =?utf-8?B?Q3hxNG9qaXRFeGZXLy9WZTV2UGpNUU1FM1lPZ09jdmtXa0h2RVpBL2xPbVpU?=
 =?utf-8?B?VXBwcEF6QXZiYytpTmd0NWI3S0FZSStPVjBZcU8xVDVVcU1mZytzVGx0VWZ2?=
 =?utf-8?B?THVnNHBwdzZmeXhUTkFsR2F6RHVMc0JSaUh4d3JNWEYzNmZ4Z0NwcHFvdjQv?=
 =?utf-8?B?UWo2dzc2ZTY1TDZCMklabjF2L3pCU1N2T2g2ZFVHOXJiUFZQbGs2UjUvVEpm?=
 =?utf-8?B?dlhhcjV1ZG8xTWxNWWxYckVWWHBmSnZiNDZ1SUpmQk90Y0VZZ1JPSTBON2RO?=
 =?utf-8?B?OE9WOTYyalVmUjcxamE3UTNsS3A4emUwcW8vTEVDbExXOVZlckdocVM3dmxr?=
 =?utf-8?B?aXBldDVJLzZYS1NsUmpUcVNLRkFvZU5sZjlKeG9majJPaDNYSStiemF6aHFi?=
 =?utf-8?B?VVlLWmg4M3hvOWdLTjBSYTA1clMyVjFBNEhBbk0yT1o5RG1QZ1ZQcUV4WC9m?=
 =?utf-8?B?QXFqdWRMQ2NZRklPWVd1WjloSm10ekRPT3pCc3JjOVdSZVRaRnl0T05ZcDhv?=
 =?utf-8?B?NGpZaVkvUWdpNnJIdldxZG10WlJ3cy91N1J4ZzBTSkNZdHMvMEpHTmUvSU54?=
 =?utf-8?B?TGIvWGhxSUhtdWlvMlZGYU8xM0E0bmFxRExtY3NtaEJCL0VjZ3BNSlV5WFVp?=
 =?utf-8?B?WlVqTDF3aUk3Q0tlUlM4WmFORG5lU2M1anJWOGtPMnlYY091ZzIzYk95MldX?=
 =?utf-8?B?TG4zWnkxYUVta2FXczQwM3pNcFVwNUd6RTZrdHY3WFd3MmU3Y0d0bUNoZERm?=
 =?utf-8?B?VytqYXpuY213eXRad1ZrSEtLUGpuZ1J0TXFDRVdiSE1uZjlqdVpRMlBuamRZ?=
 =?utf-8?B?N3hXbkZaVG5WemM3TFYyL2grZks4TW84U2ZQc1NxZXNqTm1jK0NFWTBIVUFq?=
 =?utf-8?B?Ty85Yk9BRUc3VHBWZklETW9YWExoVDFBd0twbkwrQVVlaTcyeHNmSEhjZTJT?=
 =?utf-8?B?dnBiRWNSS2t0R1BzdGwxRVVjM2lIQ0xNTWNkdk9QMnVHaDAwMFRTK3U5Y2p1?=
 =?utf-8?B?R1pscnF2cFhvdm9obUZOUzFZOFZyQ3RPK1luTTVDTi9WaldBU2JWWkVsREE1?=
 =?utf-8?B?Zlp3Mnh3NnNlUStJWHVOR1lpZngxR2VMaU5vbllBV3Fsb0ZrRlJhcjNaY0FR?=
 =?utf-8?B?Wk5sRi94cDNZNFVGd1VFcVZSZW9aOFNCU0ZLR0RJdURjb29jWnZpLzcwMXNG?=
 =?utf-8?B?dUhqTS9MVFVkWDFOd3Z3ZDNhMWJ5WUExM1RsRmdIR0krOTlxbDd3MzlZaHJw?=
 =?utf-8?B?NFdqR2c3RHRtblNiQ1ZwME9oVnFKeERxQ0dmMFVRWnFPR0FqaXJxY3dpRU5S?=
 =?utf-8?B?VUMxbU9rU3VTZStUdTBoOWFMVm9ZSXN0UFk0L3Y1T01TeGZNYW1ibXBGVm9D?=
 =?utf-8?B?cCtGVlVYSGhFWGtFUWdZVnNDUy9XR0MzMlF6Rm5Fb09EMGdQcnVIejZ0NTN3?=
 =?utf-8?B?d0Mwc2RkbnFWaWZMRDV1d2QvWE9qVVJBeWtKdVl6cXlJNkVIblBCVmtqQ251?=
 =?utf-8?B?Z2YrbTZVU0NEQldSWE5oaFdaOXJodjhseFZpSUc5dk55Y0VkdFM5M2Fucm4w?=
 =?utf-8?B?c3JFQjdSQy93TWl0SEp2eWlsTlFiaDF2cDBXMUZSUHFUUHFSblgxaEoyaEhE?=
 =?utf-8?B?cjF3ejhjZHNseUtGWC91UW9UV3BhUzVxaWZPSzVmSEswRndFK2tQT2djTmYx?=
 =?utf-8?B?WXlNWWZxZFM0MVFOUktSWmRLOWRFODVQUVpmSmtXYUVCNDBzb295amM3Q0Zk?=
 =?utf-8?B?OHpNbW41Q0hkK0I0aU9MQzVQelUrYXlpbkRxTXFXYzQ5eS9xSEFoUmQrNW0w?=
 =?utf-8?B?S0V1RXBZUlJXeDB0eC8vQzhSR2Ixc1VqSHUzaTZDS2JPUXRPL1ZveHJXcllv?=
 =?utf-8?B?TE9Sd0F6SGhSZ05XRlhYaXNaNkJoYXpLYXhnMW9vMFdSTG5PM09aWFFVOEJn?=
 =?utf-8?B?QUkrUEJyeGJlblorMlA1S3RodU85cmdMTlRNS0NlTnZ5Z2ZkeGhISnNYK001?=
 =?utf-8?B?azkyMXkyTFR4anhmSVJzVjJONmRSQkdWQmozR0F2aGk5Tk84Vk1Lcm5kNTFi?=
 =?utf-8?Q?h5606CkYPOS0yOX2aF2fTATsy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ba20bd-b861-491b-3433-08dc397d3f61
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 23:22:07.8380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQM+oa0zRvK1iIlxxdnvrrWETb6wNgO2eJmwwsGfeIaNZzqZ4xVEF+iIrmzGWcmdkcdZrRTUzPuDii0DPlABmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5783
X-OriginatorOrg: intel.com



On 1/03/2024 12:06 pm, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Kai Huang wrote:
>>
>>
>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>> WARN and skip the emulated MMIO fastpath if a private, reserved page fault
>>> is encountered, as private+reserved should be an impossible combination
>>> (KVM should never create an MMIO SPTE for a private access).
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index bd342ebd0809..9206cfa58feb 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5866,7 +5866,8 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>>>    		error_code |= PFERR_PRIVATE_ACCESS;
>>>    	r = RET_PF_INVALID;
>>> -	if (unlikely(error_code & PFERR_RSVD_MASK)) {
>>> +	if (unlikely((error_code & PFERR_RSVD_MASK) &&
>>> +		     !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
>>>    		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
>>>    		if (r == RET_PF_EMULATE)
>>>    			goto emulate;
>>
>> It seems this will make KVM continue to call kvm_mmu_do_page_fault() when
>> such private+reserve error code actually happens (e.g., due to bug), because
>> @r is still RET_PF_INVALID in such case.
> 
> Yep.
> 
>> Is it better to just return error, e.g., -EINVAL, and give up?
> 
> As long as there is no obvious/immediate danger to the host, no obvious way for
> the "bad" behavior to cause data corruption for the guest, and continuing on has
> a plausible chance of working, then KVM should generally try to continue on and
> not terminate the VM.

Agreed.  But I think sometimes it is hard to tell whether there's any 
dangerous things waiting to happen, because that means we have to sanity 
check a lot of code, and when new patches arrive we need to keep that in 
mind too, which could be a nightmare in terms of maintenance.

> 
> E.g. in this case, KVM will just skip various fast paths because of the RSVD flag,
> and treat the fault like a PRIVATE fault.  Hmm, but page_fault_handle_page_track()
> would skip write tracking, which could theoretically cause data corruption, so I
> guess arguably it would be safer to bail?
> 
> Anyone else have an opinion?  This type of bug should never escape development,
> so I'm a-ok effectively killing the VM.  Unless someone has a good argument for
> continuing on, I'll go with Kai's suggestion and squash this:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cedacb1b89c5..d796a162b2da 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5892,8 +5892,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>                  error_code |= PFERR_PRIVATE_ACCESS;
>   
>          r = RET_PF_INVALID;
> -       if (unlikely((error_code & PFERR_RSVD_MASK) &&
> -                    !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
> +       if (unlikely(error_code & PFERR_RSVD_MASK)) {
> +               if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
> +                       return -EFAULT;

-EFAULT is part of guest_memfd() memory fault ABI.  I didn't think over 
this thoroughly but do you want to return -EFAULT here?

