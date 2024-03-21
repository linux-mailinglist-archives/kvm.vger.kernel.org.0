Return-Path: <kvm+bounces-12455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BB88863FD
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 00:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD67C1C213F4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F714A2F;
	Thu, 21 Mar 2024 23:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHVx/INq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FB93FB85;
	Thu, 21 Mar 2024 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711064218; cv=fail; b=WygYxpQstrR/vH05jaxz3MVWUR8r/MVkdnqgdnvJLleMFNFa6VDkE1YZiZ7yFFBMWlecC4l3U+H4xALfBJa6D03WF6tOsnBSf4/ugz6fvTofrkf8kSj4XGwXw9mE6VbFqXJHjYN5aF6B1+7UIpiS+dm9iuNCIqhu6KyfPBbm/6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711064218; c=relaxed/simple;
	bh=mkZJ9lq034bxUA500Q47U58I00qH2+FiwoKwM0kdDbU=;
	h=Message-ID:Date:Subject:References:From:To:CC:In-Reply-To:
	 Content-Type:MIME-Version; b=upLE5aAbJ2WzqKmxOZhSudd7qmAqr0leaaT80mjR6baJnN1umX6GXJJgdGKVkKxLPHpmopGNgbF+ME54wtZtlWN0x/7yw8dwDLv6Pj8YJr58wq4CtK9Gng3wzix1CsymZ7rZivEZhhRecTHfAwMGkBdCHXFtx7IaVm5YiKsvohs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHVx/INq; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711064216; x=1742600216;
  h=message-id:date:subject:references:from:to:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mkZJ9lq034bxUA500Q47U58I00qH2+FiwoKwM0kdDbU=;
  b=LHVx/INqBwgXeF00RWF6NFgept8KHfVzq4Uhri+DbiN6Civw4F6faOAr
   iJ1Avd4s3UB22yr9cmr1Xnu64EbmEr2+qmkJoHM8g0ComYVAkgLmkWEXU
   VqOWE2xrZAO69odf0EdT17Zp6LTIA3lbUmi1rueOUVP8ugIfPBUiLMOvD
   QK+Aic5YFK0nAqDLNZZ+JhFsepYydZv4ebMSDl+5mAp3N7Cl8DlZp3qXY
   llLEXI+Fbbx0afBqD3wToyWU8zhqEtbntsSfLyck44bzMnX5+qdfc3E5H
   eSnLv1QcxQ6xgpuqTrqGKCI+VksK6EbaQ9CwkTeCjckzl9w9s6K+502fT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5989527"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5989527"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 16:36:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14687189"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 16:36:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 16:36:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 16:36:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 16:36:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfT0yvjD39/gxvNLy51y+5DxTrcPfk1oIlpUuQ0QlRPeHP4mFt+By5+Ri7+c+w0QIsIEsUChiEqEsiMK+yRkNTuXUyfLnHAMV079Vy+8w+H04C0SBZgBWqXmuqtgK3Qk5MxPVX1nTMM6mHVp2RAHmN1Lp1Y/kWtUt2Pp16kiuBmx9C8AZ9750zuazhtJjPd2rRg9cFWRnJ3ZFXpCunCz9FMOnRFO8rjz4P7TiJprjllj0mPvtZzSB+nd1/zyInKdZaPRsjI8o23j0CUsFJN+zekM8Q86nNjCaFES1lx9Un4H6ACmn/ghZukIjpmATIon37Gr4KncQXCeAgSgpGPEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hX3/fHM/U3My2TqWib+RJpc8RFpt7/Ees6pzHixYax4=;
 b=LrkUljy5lktAyxqfVeIcW1Ei2TaIrNVUis+r50pth2LkNQ+ULOz83jEweDfiw+Zu/gZGuoSe3s7lvwaSMbcPCJ33r/4sa+dHQUR4MO0tWYnQ2XAY2QCS+wSegHvOb3ozJPAg8lmmq1eyAGOVAfwci9gAWVLFa6axcgf9aAsDePygo0ZcbR2uoAWdhcBwZPNZa2mNa8JIZ1UiVgs7UhxjTD9tQku2/peIXmm3yj/5Dd1jvO4yu9KiSmKs9SsTfIRD6PuqNshccDLjoCcu+CNUZPuwvB9dYtu/uKTHMi8/KlJJWDEYr8mC3uJY7wWTLOiKY7mZz9lbINNHObZ7dwA2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6476.namprd11.prod.outlook.com (2603:10b6:510:1f0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 23:36:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 23:36:50 +0000
Message-ID: <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
Date: Fri, 22 Mar 2024 12:36:40 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>
In-Reply-To: <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:303:8e::29) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e40ead8-7a2a-4e99-0d1d-08dc49ffc837
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLJ85//lMn6g1k4knj4cVdkZLg3RGT8/Lbtw0PAhvd4SqUnn5sCG9KLzGA2OWTxdQbQY2XPQ019c/OyA3SlFA+RsVmCnnu4t+lZOnekVHQZEuc4g/AweaOM3OSYHMEkm6ULiy6fo2Z626sWH7140uHruos9mEPrc+Q6GidhSAVQI3zJ7BWcIPhDluEcFTLXl8Fjt3CMr/BCzLJQgE1zpOumd8QTUrG8aExP0R/ru/LnagYM2h7+RLL1ttB6HV1XUJN+pOTctl7OEdTAiU8mMWWwhTci/PoINrYiSjPyoFbYL8bvaPXR2orsKHe8/VGw/aaQm9h2aeHxu7YPCKlc2DdU/Sn4s9Pqkb5NYLmqsfTVBU15dw27TTpdYR4Gv9oMb6iDX0Hf3iTMJaToywBBSttwjuNe2L925Jti1IV0bLQ/2nuEdYkq9lmA2L/Pi64At6irZ0Our6ZwQpOa/qTkso3PlJ7FcL4PFkRa20eiVK4wDkRXyJWWrOv4AYfI3dNM8MIldD80z/SVLBn4uYU8QqXK0HtbfozMitUHb/hMqH1LvMMo0b7WI0w2syLJFOLXQpemR1a4+I8YwE9UM95ZNboO2A27QcdPTp8SWokzoysCkqEkAlEQpfwCu1u6OxWcIOhRvmy93he+mB4xrqvdEcMiB2fEl9xq9OSbidoBnAu0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTBPWVJubXpyc1R1Yk9FK0lTd2NXakc4QWw2bWJKV01GWDBjQ29WQ0FZVWVL?=
 =?utf-8?B?Y0xVbW5VR0VIREtETU96M0VBMjl0cm9SNXFSYXhDU2pkZHdrUDUrbEdHallp?=
 =?utf-8?B?bnh3NW0rcjlRMWJFRTVLSzZJRTBRYmxDTFRFQXR6a1NWQ3R3YlFaa09KWW40?=
 =?utf-8?B?N3pZQXlaaVhWUEVOaTBQNWRGNnV6S1hwUnpoSHR6b1Z1NVpUT3RjRFB0Zm5M?=
 =?utf-8?B?S0hsdFhLc2pVVVRtVWxrdnByWERoNjBydFdaYjR1NWFZblhCZHdtR1hHazdY?=
 =?utf-8?B?MXBWSks0Y1cyRkJMeUZkWXM3bVF6bmtQT2NSM2FaV2hodmlVWTloQzdaYU81?=
 =?utf-8?B?bHhBMUlqelg3Y1F3WDNQV3NCVDJJODJWbVNVOUd2c0hWaXFqUXYxZFRxZUJG?=
 =?utf-8?B?YWlFL1cxYkpIazYvT3B1ZEFZSVZQOXRkZ3EzWDJzdEdvM3JWRTFCVWhrQ25T?=
 =?utf-8?B?M0ZLOVNzR2I3dmVMV2lTL2lhOHB3TWRHd2tVWnd3NUU0MFBTbjRvMWdEZjAx?=
 =?utf-8?B?VWZyUXNQM3V0U1J4UWZTS2RQMmxLWEZFMklyUkRiQVNrUFJRSmdDUTZqbXFs?=
 =?utf-8?B?UnFHeTg5NEVPMWRKSHpQTHRFWHpoOXUrR2NlQ2lXcnBrM0xwaHg1ZmhMWk9i?=
 =?utf-8?B?dXM0QTB3UXRBcFVkY1VSRzFzL3VMRmJUd2I1NEdFMndBdDBjL0VDbzVYeHhi?=
 =?utf-8?B?VW1tUkJkYk1sZE91ek9UVFBZV3FUZnZRWVlSNGl5M2VLbExzYWFCWmxKWCtt?=
 =?utf-8?B?KzhKRlJGVGlGbEk3eFA4OVZFQTR6Nllia0pyTHJGSDY5anBIWTVjb0x5Q1oz?=
 =?utf-8?B?VVArenhuQUF6ejZaTm56RVY0bmpBb1FKR2NTVWU2RENWcEZZd2l5SHRLbUMr?=
 =?utf-8?B?bjdKUUhJaUIxVkZLMXF0WjEyOVJyckdxN3lycCtSSGNaR2NGSkNEZ1FsZk5C?=
 =?utf-8?B?UEJsTWNjVk5rOWxaKzhYdHYvdDNHY05GUHdWTW4zL0J1M04xT20rdCtBaVNy?=
 =?utf-8?B?czBxNFN2UlNhLzRyRDBDYTRzRkxnUUJsZ3F5eTVDay9WZzJqRXFpYWFYb0FK?=
 =?utf-8?B?dzVIKzNZc2RRU0tKMUtmN2tVaWhVT2FNRTlseEFLTEtGMllFQm9BZTBrY3hL?=
 =?utf-8?B?djNwbHduWDh2Q2xCa1FYRklxZmM1QjE1bjN4OUVxUnUvMWpqTHlEK29pbWJW?=
 =?utf-8?B?aW5PeFlYNmNHaUZUVlBDZE8rU0FSQWtDV1RZZDVGQW9UaXlobjVLd3BwVGFJ?=
 =?utf-8?B?cTYyVHJoWDVoNUhLTGhjOU5VaHZxOGEydXJKQXZhV1dxY2I5S0FNVUV2ajZk?=
 =?utf-8?B?aDBNMlFWYk03eTBuQTdEWlJIcEV3TEErMFd6YjNBUUNTUnZVR09taXFWd0po?=
 =?utf-8?B?K0Zrb3V3dTJwcEwvbEIvMm1XYjU3ZTBHZDh5M3IzM2tXQjdpd0E5SFV1S1Vm?=
 =?utf-8?B?WlRBaWF6d2JiSjQ3OXFaSGZ6M0poclFyTzhxbFQvaW9qTm5mUmFXWmFvclRN?=
 =?utf-8?B?UkVSQTQ3anRiUkZUUWg2VFhRMmtLL09qVzRHQjVoQXZkWnVCbzNjWWI4eS90?=
 =?utf-8?B?dm1weTRlTW8vRXBwN2ZiTEF2U3h6TE5PNC8xQnFsSC8rYVVRbmwrZ0VXUXRM?=
 =?utf-8?B?cjdOS2NERDc4QUJYaThRRmxBd091Qy90VU4rZlNxYmF3eXJQM3FiV1daVU4w?=
 =?utf-8?B?T0dCTWdvS0s5MG9MMXpQNlc2UlNvdjBmSEFGWXVGSW5VcVVEdEd6d0huR2tU?=
 =?utf-8?B?NTF1S2Z6WG9SV2hEOCsvZ2tCL0lPMHlaMktHdFdhVWZTZjA0NEN4V1hvNFdP?=
 =?utf-8?B?Uk9Ta01iL3A5ZHpXSWJnWUJuNWpzaE9KbHRJWHJuS0lMSE4vaWtzUzlMWlFP?=
 =?utf-8?B?cHhpUUFXS3ZObWZWV2cvQWhzS0RJU2k2S3JLYjU0RDQ2V3JvdHVxYkkxK3VT?=
 =?utf-8?B?enJvemFiZ2l4aFFiV2p4Z21wSW1VYm43SzZUbC9LaklGR2d1bkppbVR0c3lI?=
 =?utf-8?B?bVJqMzdUSDNlcEZyN3lEcFA0T3EwZXM4ei84cVd4U3lGbytFZGlnUTgySUVu?=
 =?utf-8?B?eW9vbmUxNnNSbGpLT2tMS09lS01yRmhWN0E0SWFyd3N4Yi9kcG00MmwvYVd2?=
 =?utf-8?Q?zlnPoPN7i53aFRFjAsJY6sp60?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e40ead8-7a2a-4e99-0d1d-08dc49ffc837
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 23:36:50.5580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2f6vhmPx6QR7Dxr9F4If6NKpIYgkiBYsFok7JTKCenvx3YzIxNw8GI0hpyFFeOa1Y8MbbwTmCBQYVC1U7EQtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6476
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, Yamahata, Isaku wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX has its own limitation on the maximum number of vcpus that the guest
> can accommodate.  

"limitation" -> "control".

"the guest" -> "a guest".

Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
> handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  

I am not sure we normally say "x86 KVM backend".  Just say "Allow KVM 
x86 ...".

user space VMM,
> e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.

Grammar check.

> 
> When creating TD (TDH.MNG.INIT), the maximum number of vcpu needs to be
> specified as struct td_params_struct.  

'struct td_params_struct'??

Anyway, I don't think you need to mention such details.

and the value is a part of
> measurement.  The user space has to specify the value somehow.  

"and" -> "And" (grammar check please).

And add an empty line to start below as a new paragraph.

There are
> two options for it.
> option 1. API (Set KVM_CAP_MAX_VCPU) to specify the value (this patch)
> option 2. Add max_vcpu as a parameter to initialize the guest.
>            (TDG.MNG.INIT)

First of all, it seems to me that the two are not conflicting.

Based on the uapi/kvm.h:

   #define KVM_CAP_MAX_VCPUS 66       /* returns max vcpus per vm */

Currently KVM x86 doesn't allow to configure MAX_VCPU on VM-basis, but 
always reports KVM_MAX_VCPUS for _ALL_ VMs.  I.e., it doesn't support 
userspace to explicitly enable KVM_CAP_MAX_VCPUS for a given VM.

Now, if we allow the userspace to configure the MAX_VCPU for TDX guest 
(this could be a separate discussion in fact) due to attestation 
whatever, we need to support allowing userspace to configure MAX_VCPUS 
on VM-basis.

Therefore, option 1 isn't really an option to me, but is the thing that 
we _SHOULD_ do to support TDX.

So this pach should really just add "per-VM max vcpus" support for TDX, 
starting from:

	struct kvm_tdx {	/* or 'struct kvm_arch' ?? */
		...
		int max_vcpus;
	}

And in TDH.MNG.INIT, we need to manually check the MAX_VCPU specified in 
TD_PARAMS structure to make sure it matches to the record that we 
specified via KVM_CAP_MAX_VCPUS.

So how about:

"
TDX has its own mechanism to control the maximum number of VCPUs that 
the TDX guest can use.  When creating a TDX guest, the maximum number of 
vcpus needs to be passed to the TDX module as part of the measurement of 
the guest.

Because the value is part of the measurement, thus part of attestation, 
it better to allow the userspace to be able to configure it.  E.g. the 
users may want to precisely control the maximum number of vcpus their 
precious VMs can use.

The actual control itself must be done via the TDH.MNG.INIT SEAMCALL 
itself, where the number of maximum cpus is an input to the TDX module, 
but KVM needs to support the "per-VM number of maximum vcpus" and 
reflect that in the KVM_CAP_MAX_VCPUS.

Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but 
doesn't allow to enable KVM_CAP_MAX_VCPUS to configure the number of 
maximum vcpus on VM-basis.

Add "per-VM maximum vcpus" to KVM x86/TDX to accommodate TDX's needs.

The userspace-configured value then can be verified when KVM is actually 
creating the TDX guest.
"

