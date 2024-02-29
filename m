Return-Path: <kvm+bounces-10565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D0886D793
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 00:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99A041C2147A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D49B74BE2;
	Thu, 29 Feb 2024 23:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYAr9QGJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253BB16FF4D;
	Thu, 29 Feb 2024 23:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709248502; cv=fail; b=lvy1vRX6ijGjSoH4/DEbegfAIHXgDVmw0sDBhjAXaysIjePYclWkRo7IrjhFISPqDUoHeRYzvLOpqqbsXvISnNgA8dXYlMiXA1K8LGkAXUlkjLiSKFBsbg2ULd3vMs0na/zNssoJMh0tRSu57S4tJKe9FKljjSFkNYiDFPosoxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709248502; c=relaxed/simple;
	bh=Md9xZlXo4nrroithU0YeN41AzBVy+7IWbiudSf6pxW4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tQX9DiPuNq5eUz6f+jVliE+4cBci/ohQGmVl2Yqrh3E4cKjt1EBczOWvSD08nObDeHJZ6yBajNvV1q7+mrCoFddSFkdmVwXi1dtzazOb78PXCG/FbA6rMOMyDo3e0+gYu9ZIM952GAa3SzI1AHBzozpyFxBLbFYv5lAsZUsWmRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYAr9QGJ; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709248500; x=1740784500;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Md9xZlXo4nrroithU0YeN41AzBVy+7IWbiudSf6pxW4=;
  b=nYAr9QGJl86qZxt90SJbBchbTJ7YXB6SRRQDkk6S5w5YI1YfH5Eqi8eW
   GHEIfYxffFDmgfY9XzFW+puyvP7hQYpFVk/5KLl1tDdgU428AjjotyE7I
   PqHU3/p2mRPKXHrRtIRUKpvimS9EBFWDjGoTyCS78kfNl6jNNOT69ujzw
   2ZIzofqL1u4jFuAdCNxCXW+q1+2Xy0rPmcY/Z7zHZHOFL4gBdqghOTjPR
   yKfA/evDwyX3eRhlnSIvv3zcLHqDOfJ5Qg9tIojkinBrCDY4PzllVbGn7
   rV/RIJzqUDz7FDs0ySBnkGNPQVVZt905EWPIRhB5oZi4hmrRzUTUs43jv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="15177616"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="15177616"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 15:14:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="39002087"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 15:14:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 15:14:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 15:14:58 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 15:14:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDfLPJYwn8ociU8AIq1+WDs8Z3J4bPTlIXPxbQyZ0Hen5pi838ZJCCIaBYt8BS1W49p8yqqrxYxL6RTLHtPp+BA7x6JZTI0Iikm3Y2h5ZQLyUsQ3w6DgLOYQ0LgRhLBBOIyO0sUj/LhfCOXtS5LUKj64AEmNeWfe/fTJGoyAnMuep6wlJLJUPKff5n6zQAohcRoIOt4IOKN95VayIvlV+Y7XfPGrEAIwQ1zEX/dXkHQGBvwt2VXTkCL8ljw2YKwtxKkLZVnRn7AJwGHahyQ0pSDrrD/BWo7WnMpfi2iT6CP2RW1aVmE8FhXlJJQMukj6UpRUkf2vE+kJoPgAyugFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMC+De5NemF5LxSpDUv7MbdP5GZhhfnPmAsSKfW5+jg=;
 b=DVESKdS6uEdH5+6e0cOOt8I3n5earw7BB9CH/+Wv9ZiZ/7Eoaba+hxlrjKAuof9/eLw0aO2YcYAX3n0OWXGByFnN58KQiZCahmYbGaYoOqgW57pKbGi9Ill700raGyMsIaJAMiWkQFa8OGTCYzFD3OMDSiihJQMNv2eBd7Frn9s7rdYJCDQVR4sIlpaBC1pE+K+4IyY67G4iINGMyQ8m1v8tvDPjECdKbfomAwlDknj5I7EiQpu6GePsyuPvibi4uYpPRDPNdJjWeuxtdY4C9EGRhHW9RaHEZNHca5Tj6lyg9bkLX10ClsY9lSMl0d3URUlgqjI/aJuUMLq30L8sHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5072.namprd11.prod.outlook.com (2603:10b6:a03:2db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Thu, 29 Feb
 2024 23:14:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 23:14:55 +0000
Message-ID: <f345b6d8-0065-4ca8-9526-543a601c3e90@intel.com>
Date: Fri, 1 Mar 2024 12:14:46 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/16] KVM: x86: Move synthetic PFERR_* sanity checks to
 SVM's #NPF handler
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>,
	"Yu Zhang" <yu.c.zhang@linux.intel.com>, Chao Peng
	<chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David Matlack
	<dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-8-seanjc@google.com>
 <d0d5d6b7-218b-4769-9aa7-a393f174410e@intel.com>
 <ZeEKq7L8oOqqfknb@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZeEKq7L8oOqqfknb@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5072:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c4c1952-d56f-467a-d125-08dc397c3de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz+CU8HdPUt5mVV6sLXTFfbvGSwqatlOiHCoB2hX+EUcHZawR5A3geS/+m97xQnvE9p84u/Y3lnywn8+XLbunC/KPnrbWANBgJ5g3dof5clGcTtW/azBa82ON+BBZAIjFiFmrnazOUO/FC0b1mS2u6zG8fMRb5GqSS0vkult9n6ULqQ+mUUon/gi5nsTN2+0I5QuZeEE7P/6vBgMkYZT4+97/HJ1Es3ul7lCdr3lVRWladw3w8t6Z2RFQeBK/U7aDmcolwFooEKIw2DjWyVr9MvNzkhtRrkaveEsBYjygMR0yJYpP7l6tu9ZY820Jd3dIR4shWYeCeOnzIq4nsz/oQ3E48TwffoQ/81JZ5y1h2Z2upZBM84nBBhY1wt6mmuqQIZlr2thgNBAwF3Ojg/aXQWU00P/mEyKyiGumSp6Hw8vxiQpr50EXuxBii87m7ClRqKsum7Gq+m2vpT5Jg8QGpCAoTc0pAa1X2u5PoQJGa3t44+lrGwjUA+5fnH+W7Dcmqn80ZgeaRtekFQOEwv3szy15VYFxizy2ad1uRJFpWiuv8xlwjI0xB31+MdbGlRXuyebv5a1VDRXx1DfRCwb4aqVzMUSUzHxAANfnJM7FHdQAJE7sCVe8zrwVajV6cL3Uqs818jt1okdtGs5b9ewyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVBjZDRCaEN5NW9sUzZ5Z2hENFo1UjlCb0pQdVJweGl6empkMVdwWVdaODRw?=
 =?utf-8?B?bityZ1JOLzBTeWhNa1R1SWJLbGlldExpSW94ZlhMbWVzOTNZdVY5YTZrQ1l1?=
 =?utf-8?B?d3l6SXZIS0NSczZWd05ZSWtnbVlvYlZHYmozMU4xcjAvVmFxVjZGZFVZUG80?=
 =?utf-8?B?SVlYQ0VQOUMxeCsvNVNMc3VOUlBQVzlvRDBrK1oxK3BMZWdmVHZxNHAzQ0lj?=
 =?utf-8?B?RTkwR0twTno1S3BQb2E3dWhSU0diREVHVStzbU1NT0tuQkdCQ2l5YjRiQWEv?=
 =?utf-8?B?UFBXTzJrYzFlMnRsWlRTRXZ4eVNHZTlVbEdwWVZheUhCZ3E3RnovREpPdzZC?=
 =?utf-8?B?M2pnL1R1dmo2d0hWVGhIWThmdkcwVGdHZ0o0ZldTN1EvN3IvRDRzYVZkMCs5?=
 =?utf-8?B?WFEyMTF5ekZ4eVkxYW1LdjlJSzdUQkUzNkI0Y3RkaWdMeXV3TXF1NnMzN3FR?=
 =?utf-8?B?MUpVVlA3eHRGcmRCQkxFcGpXNUNtOXh6Y2l0TzVRbDdYK3orYzNUR1BkOEdB?=
 =?utf-8?B?NnA1RWZWWUhDUTJtY3JGQWRxV3JSSHVOdm55ZExJbEFoSmZJaldHcE1NRnNw?=
 =?utf-8?B?S05kcDgyRXBVTWtoYmo5QjBWNjlkTmcrdlNRVTg4NVdDUU9IR2RnWldxWmNL?=
 =?utf-8?B?QktzQ1ZLRWFsb2tHaE91K3Z3WFR1bDhiellmYkxTeTltK0pMNnpjRVFhMGtZ?=
 =?utf-8?B?ZEtEbjJSZ0dwais0S1ZlZE8yUkZLTkl1M0VZVmpBWDBCWFdnRnB3Z29GOEdP?=
 =?utf-8?B?SVFvclN6UTIwdXl2UkpkY2hsbUcvMU5HdmkzM1B6cHdwblo2Z29LLy9hbkRC?=
 =?utf-8?B?RkNVd3p0ZUdvSWpSdXpQUENZZ3FhU2pmU1ZUTE1BU1loRlBVYk1RSG9qcE9S?=
 =?utf-8?B?SmtEajBnM2tRdmhBbUxhK0o2K3psTnQ2YUF0Lzh2ZjNudGZpM1lEQ2V3Slkv?=
 =?utf-8?B?Vms3bnBVS2s3MWF2R2tWSThLL0IzTjdrSU1zaW9Lb1E5djZiRGg4QXBBZUJs?=
 =?utf-8?B?VFVydDJ0OVpCTzRZa0NuT3JNM0FsejA3U0ZZdVVZbHcvSnJHOFpPdEk2SWd1?=
 =?utf-8?B?OVY0ZXNjMXVQdWkxYzlxZ1crUkFJd3ZZZWdHWEV3NjVEVVQyMGZSajFYZGdm?=
 =?utf-8?B?V0gwa0owMHV2aU9KL3NORmhmbUpLdXhZNWhrRWxVeGhLRXlyejl5ZGJYbHgv?=
 =?utf-8?B?QzNQaWxPS1VNbE1Jd0tNZTcrVmsrQlNmeVgwTlpnVStQem1PdGxLd0VmekxC?=
 =?utf-8?B?S1l4Q3BQN3JZdU1ZTkM2cDBYR3M2K0VtT1gvUktjUTRpcm5ROTl2ajJqZEpu?=
 =?utf-8?B?eU53cDFDdXhUcTZ6c1ZxTDNtdHJnK1ZFOU5QZVNORHR0dGlGbzl0Y2tyM28w?=
 =?utf-8?B?dlc2bmhYQmUrTnQ3a0daQjNtZHhKRzBrRDcyVFY2ZVhvbmZvYkJhZEIwVHZp?=
 =?utf-8?B?Y2I3dnhvTkU1RnljaVFKSEZISTRPSmhwSG1xL1ZPWUhCcjB2OUQ0cmFnd2E4?=
 =?utf-8?B?NzVaeG55K3IwekNSMTJ6V0lRUDNOQTk5REE2SmE1bjAwbXdLNXkrNFpLcDNQ?=
 =?utf-8?B?cHMxaytwUnpzN0RzTDYzRXJQQXdYSEZhR1NSVHVlSHcreVlkQlQzYVN2Mlhw?=
 =?utf-8?B?N1dPTkpXdnhZWURXZHhWditlU2lpcElVamQxTUdIM1BlWnFMclgrN05ZLzdS?=
 =?utf-8?B?RFVUZXBCTDRsZ1FyZEtLN2ZkekZ5clRYMk1XdHFDZ0UraHc4dWxRbWNuUW5z?=
 =?utf-8?B?YnA0WFlZVzhhRWgwS3NHSmVMUjZPNEl5QjUxc2M0WkZmMnE1WjBqMFdJTC9t?=
 =?utf-8?B?VUJmSWxnQ3FVK2xBcG9xMnB3RXhLZHFVYXNuQTBOb0UyVmpoeEpSTnVRR3VX?=
 =?utf-8?B?ejg5SGFHTDBmRWtWOFNOR3Vkb1pvUDI5QnF4VXBKRURlL29XMC9kUkhzcTlN?=
 =?utf-8?B?OCtDZUZ6MzRBSVVIK3pWdkU1T2Z3OXNpRHhMVGM5TXF0ZUw0aDlIeHRVa2Z1?=
 =?utf-8?B?eHZpUHE1Z3doTHR5bFRGeFFGUDFEbTkvdVE4ckhGMjdJOEM0M0Q5akpkVlRN?=
 =?utf-8?B?WWRIcWhGSi9sUUlra203MkduaUEwbys1VEUyQlB5Z2ZDZWZubDJEa2F2Vmc2?=
 =?utf-8?Q?7SSSL9hVrwjwAowgsWpUlCi+e?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4c1952-d56f-467a-d125-08dc397c3de3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 23:14:55.8511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGoOHpGOIjxOTfik2462Q1kmWAc5qyxcyvPNvYTgWUAITbo9McqdjuRL6jbCjefsysO4bo2MC3HLIiNlOc/j7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5072
X-OriginatorOrg: intel.com



On 1/03/2024 11:52 am, Sean Christopherson wrote:
> On Fri, Mar 01, 2024, Kai Huang wrote:
>>
>>
>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>> Move the sanity check that hardware never sets bits that collide with KVM-
>>> define synthetic bits from kvm_mmu_page_fault() to npf_interception(),
>>> i.e. make the sanity check #NPF specific.  The legacy #PF path already
>>> WARNs if _any_ of bits 63:32 are set, and the error code that comes from
>>> VMX's EPT Violatation and Misconfig is 100% synthesized (KVM morphs VMX's
>>> EXIT_QUALIFICATION into error code flags).
>>>
>>> Add a compile-time assert in the legacy #PF handler to make sure that KVM-
>>> define flags are covered by its existing sanity check on the upper bits.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 12 +++---------
>>>    arch/x86/kvm/svm/svm.c |  9 +++++++++
>>>    2 files changed, 12 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index 5d892bd59c97..bd342ebd0809 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4561,6 +4561,9 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>>    	if (WARN_ON_ONCE(error_code >> 32))
>>>    		error_code = lower_32_bits(error_code);
>>> +	/* Ensure the above sanity check also covers KVM-defined flags. */
>>> +	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
>>> +
>>
>> Could you explain why adding this BUILD_BUG_ON() here, but not ...
>>
>>>    	vcpu->arch.l1tf_flush_l1d = true;
>>>    	if (!flags) {
>>>    		trace_kvm_page_fault(vcpu, fault_address, error_code);
>>> @@ -5845,15 +5848,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>>>    	int r, emulation_type = EMULTYPE_PF;
>>>    	bool direct = vcpu->arch.mmu->root_role.direct;
>>> -	/*
>>> -	 * WARN if hardware generates a fault with an error code that collides
>>> -	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
>>> -	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
>>> -	 * flag that KVM doesn't know about.
>>> -	 */
>>> -	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
>>> -		error_code &= ~PFERR_SYNTHETIC_MASK;
>>> -
>>>    	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>>>    		return RET_PF_RETRY;
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index e90b429c84f1..199c4dd8d214 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -2055,6 +2055,15 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>>>    	u64 fault_address = svm->vmcb->control.exit_info_2;
>>>    	u64 error_code = svm->vmcb->control.exit_info_1;
>>> +	/*
>>> +	 * WARN if hardware generates a fault with an error code that collides
>>> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
>>> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
>>> +	 * flag that KVM doesn't know about.
>>> +	 */
>>> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
>>> +		error_code &= ~PFERR_SYNTHETIC_MASK;
>>> +
>>>    	trace_kvm_page_fault(vcpu, fault_address, error_code);
>>>    	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
>>>    			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
>>
>> ...  in npf_interception() or
> 
> The intent of the BUILD_BUG_ON() is to ensure that kvm_handle_page_fault()'s
> sanity check that bits 63:32 also serves as a sanity check that hardware doesn't
> generate an error code that collides with any of KVM's synthetic flags.
> 
> E.g. if we were to add a KVM-defined flag in the lower 32 bits, then the #NPF
> path would Just Work, because it already sanity checks all synthetic bits.  But
> the #PF path would need new code, thus the BUILD_BUG_ON() to scream that new code
> is needed.

Ah, right.  Thanks for explaining :-)

Reviewed-by: Kai Huang <kai.huang@intel.com>

