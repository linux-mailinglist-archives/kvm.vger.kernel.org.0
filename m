Return-Path: <kvm+bounces-5763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F878267B6
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 06:10:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C513FB2118F
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 05:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F51979C2;
	Mon,  8 Jan 2024 05:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZOS4/32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BE5522D;
	Mon,  8 Jan 2024 05:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704690614; x=1736226614;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=aLdcT2COVtiEIS/6Kvb+02p057yocVIuhX5dT60xI6w=;
  b=lZOS4/32uUvRuaDH3ocYApb8+qBbaQvrxp/EdVL9bJlie16VNhEqeT6f
   /cKw0EYDZLKQIiSz3Vqpwz9+23xtFU+B8u3f10LDrjhlEbQcWxEBmldYT
   C4CxQZmV7RPuTeMHeyOdmLkzYK5p1y8Jii6XYfYwW8y4YW0NTe9XmiHMZ
   a3g/XMPT6ioph4qdeAwGdvG0nu6Cm9CUq38dEEel0cYckxmyxy9DAwKTY
   eA5PdF3V8nNd0D7c0VF+X9Aian2nmd0lwXnO1Xpk9BIAomh+XsR6uwEqk
   Qiop0N+eymgJnxUJqQ/htvnUHo0QFmwJnBoe3V0wGN1wwMmDtyUP0BcFt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="4554422"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="4554422"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2024 21:10:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10946"; a="954529514"
X-IronPort-AV: E=Sophos;i="6.04,340,1695711600"; 
   d="scan'208";a="954529514"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2024 21:10:12 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 7 Jan 2024 21:10:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 7 Jan 2024 21:10:11 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 7 Jan 2024 21:10:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERO+iAPDCmXaM/axsCuTbgG+sayuO3uqAeeu2qWTrcXxaKiBGu0QBQOf8gzQvZCG2EJpyfOO94d1MF9rBrVZB5S2zIXk/JIBN5Hmr9PjOM8dy4Sc8Wlol2cQ/Ii/b572f0TaKyX/mpJWGmLmhs5ljCQe4jU31c39GmRGZOuOsdJomfMSotL06+6Eogk1M9p/5uEnqJIybRT5kkz/c0XMkXKf3v8T9Y6fF6QfLzl3oBkvkLtSPpR6GRRH3BHZWalgcQkMSNhzpNnNJD04KefbzYG0QNwCJrWMsrHfuVAcNpljpSc149ZJE7GIhiH0nkFIQobi6TwPFsNEPaSipQRwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNnm+vihaIQCrPiDXSMc8uMTgvnX/BhKs9jD/QoH4CM=;
 b=fF4gHWwBJfhTbv1py6jnWSPrDeMh5T1dO7LpP4b5/opsU60TWXHFHrmbOz7wPFVz1qlc9VtbM85rTPi9KOGk7dGYCXvXu7iSF9wqV4suLrOAWxHqTDnkxeqIJazOX80yk85CQ+I/AvgBnmo+KQMH2jh0tb39MdXSW/3FugU+3o7HcLNW8SeXp8sQBPYSGtIzVrFokeyfx9UAGCH2BCSfmOOlqLT1OowgFHuOR1YjLWr/I3sq0jxQhDRiMOb9SIIobtTpaLqVeGjjMX0df4d9+xqTec54Pqz5dKmYFZnyvHEH1/EfI9c3PeXZLQZqP5IhDgsUhn1Ktwj/41rogRrRlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8403.namprd11.prod.outlook.com (2603:10b6:a03:53c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.21; Mon, 8 Jan
 2024 05:10:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 05:10:09 +0000
Date: Mon, 8 Jan 2024 13:09:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sagi Shahar
	<sagis@google.com>, David Matlack <dmatlack@google.com>, Kai Huang
	<kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
	<chen.bo@intel.com>, <hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v17 092/116] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <ZZuDp+Pl0BHKEfPt@chao-email>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <7ca4b7af33646e3f5693472b4394ba0179b550e1.1699368322.git.isaku.yamahata@intel.com>
 <ZZiLKKobVcmvrPmb@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZZiLKKobVcmvrPmb@google.com>
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8403:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f8c1e62-a3d7-4328-684a-08dc100815e5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MUn6BssY+8dPhxex+rlxR2xWES73vZ1mwM/qExrIem/IzGSA7Nv7y+9Ksc8UDKXDgcSLGd6dT0Z4iWNKHYeaxrjvUzWVmEJkV1odZq46XTSaB0a+oGfSzUO7Y/l+spDUqUQImWnbZWT9JCs5A4FhPqlKNMbyJFywXjxuw8eDH59SMxUfIxFT5sVwAjttWEs7mlSe4c0qhrw9tXNWUD0HyoiVbLz+cfGT4KI3F9VZq4LBU3pOJPFj4ABGVBCAjENtj/pQQjTMbTOXiYXW0f9SAydXHLRYQOVOzJH7HuoPvcXxg45ocuM0NtlABPF0YjS4zFCe9krE70TF12uY7gPrb91tE2Jm16UkZ6YVc5zFDe9Qj4AM4tOxUdFteKRtVP6WLTsCIGF4oZBaXb7OHLwR5U/ObRpn1KFQHE28vVYEiYapPvBepp00lZPVlbutf+IK7qAIzWqAvnw3Xdddf/euIRGGOI3qaE79c00HRpIgeEptB1AsA34jAM16Bol/gmcIknj7vOwgQH3QKm9FEsWujh06BCgRMLxcrOU3X8/jsd8hcSwHX+LQHDoiz8XeQWOQbdCHis4TBTq22VbIsSGEwR7LP3nYJxb+61GzJGIkWA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(346002)(366004)(396003)(39860400002)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(66899024)(38100700002)(44832011)(4326008)(5660300002)(2906002)(9686003)(6512007)(478600001)(6666004)(6506007)(966005)(83380400001)(26005)(107886003)(54906003)(316002)(66946007)(66476007)(6916009)(66556008)(8936002)(8676002)(6486002)(33716001)(86362001)(41300700001)(82960400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEIxSlJvaTE5QjhYWVVaeDhCQWQ5VXcrS3RYdG92cjI4QXdYRnZPRUxCQ3dY?=
 =?utf-8?B?b0FQVnZPNHdqcldHbjQ5T1Q5Sjh6WlF5aWlWSFBZbmMwUmc2b3NpQWtSYkx1?=
 =?utf-8?B?VzNwMG9ZQ1BBck5kTXJNZzAweDV5dFBxMmhNWG1XNWF3MDFoZDBnV0V0MzM0?=
 =?utf-8?B?VUp4N1VadWtjQTQybE9YUXJma2NhMTVlUDJrWW5wWG56ZUhUT0Y2NEUxL0pl?=
 =?utf-8?B?V0pKMVlzbldTWWMrWlNvVHNVQUpRdWdPTHhRSURiOWEvSE80b0xqVHVYdVZ0?=
 =?utf-8?B?V0xUeTV3WnUxOWUyQldmcHRUTXVoL3hKTTdUeVVEQ3ppUzZQOE4rY0crYmpk?=
 =?utf-8?B?YXpEMEd1QnE4MnZCRnRTbExvT3Rvc2NzQTU0dldlekVRNjhnbFBZcEJKRnJH?=
 =?utf-8?B?bmJna3JoeEdXWGxJU3JKWHlWQWU5aTJzbjN5NTRIVVFQMUJRM2tBd05RNXJB?=
 =?utf-8?B?bWdFK0Fuc1VIZHhPQk9YRGQ5ZGI5b1RFdGZlTmhsMEZyaHhPZ0VKUVJ1bk1Q?=
 =?utf-8?B?M09YYVVIMW01UG9BSzcxSXp5VDQydUt1TGRGWlRxYUF3YXZmVkdrS3NSMWlo?=
 =?utf-8?B?T0Y0bW1hZzIzekFaV1BrV3VHWHVmay92ZXdWNWRzRHlQbTlPd2FyNUVnVGNp?=
 =?utf-8?B?dVBzK1c1a1B6L29KL3puelZYY1pxREk0Z0xxUFg1WWtkUjdtakJuWjNsQnE5?=
 =?utf-8?B?ZFZ4dG9XTDFSbVBqdTY3TVF1bkNrR0ZrWUovWTFwQzQvSU5sWHNPUDRGd3pM?=
 =?utf-8?B?VTNhTXUrUnV1bU9XZ1JiWkVZZnVwMlJJZVdWWEJwcUgvcEdvVzNtMituNHNo?=
 =?utf-8?B?L0FKdzArejZKd2tHbTFUT2tiaDQvNndjVnUrQTZjTit1ajNiY0NDTjNhSHR3?=
 =?utf-8?B?TFhzU1djbXVYZUhQQ2lPb0RrbW8xaHBOL2tHODMwVDZEUkw5RDA0azlpWlI5?=
 =?utf-8?B?OGFEdnRQazZkZGhNdUVTckZOWVZPRVBlUFZPOEoxUEgyblZ6aTJudmJibzhj?=
 =?utf-8?B?U3MzYytGNGFHVzA2Zk1JTDBMaFN4azJuUWtRWWRxbkVQZzl2YWZWQUY0WWQr?=
 =?utf-8?B?NFNWWFk5d0hEOFZXN2xYOHlUbmMwRkRSSmN3NmJxdHdQakt0aHhDV1pnR0ZI?=
 =?utf-8?B?VHZoRmQyQml2L1JEcFVpSldVUDQ1aFBxS1ErbmJtRjhvaXgzQk1xQUZSWnpZ?=
 =?utf-8?B?YTJ4VTRTeEIwYk1SNC9ncFNseTRSYlZRaG5NUW9nWDFEZ1hCam9aT2dxMlJp?=
 =?utf-8?B?TGovM3pRN0g3TVIwRFc2SEdNNHZzQ0Y1bzI0YTVsVktjaW5nNktFTGY5RFJs?=
 =?utf-8?B?R2JwRE14V2JXT1ZPSWJXWVk5TVdXMnpoaVppMGZVUFA5RmJpTGNIT3cyaTNu?=
 =?utf-8?B?c0FEdGRkUllkSXRNaWZrS1BONFViWDljKzkwVHhZNHdQV1gzVEFrY2lzRXpl?=
 =?utf-8?B?dFlNT3RtRzRlSnc5amU4ZDZtV3hDcXYrNWQ5Y0RtYkJacXpxeTFmM3o4bVBy?=
 =?utf-8?B?UVhWRU9Fd0hIYjhGN1FuTFA2Tm1xWXFjN2pUOFFzNlFpSDFobS84akh6cVVV?=
 =?utf-8?B?cGZzZEJDOEdOcmtCR3pRZW5QWWNpeHVvN0VRZjZESUpoQWppVU11dFp1Y3hS?=
 =?utf-8?B?anNJSnFOQ2hXSmxSK0duSXJoWjVNN2lydVcyeVBxUE5RaGtBazU4UXMvaUhs?=
 =?utf-8?B?SG91alVPZGEzd2lxalFPQlN6TkM2K1NsUFdjbVdGTFpNdFVrb0dySGxicmN5?=
 =?utf-8?B?REQ5MDhUeWwxbXRydElSRnlzaEdzVllWK0JQRHJvTVRKOUVpcFdqZEUxTlBC?=
 =?utf-8?B?bWJwM2Exa285Snp2RjRvSFJEQ0MybHR1bVdyZklYSGpzWm1GMHhLNTd1NTYx?=
 =?utf-8?B?Vm4yLzhsdFpJMElrd3dnTTdCRE9weHpNODdoRjFZR1hPWUV3U1RucHFmWEdZ?=
 =?utf-8?B?SjRyanFCcGtVaFVDalZIUFNHdlg4UDF5YStQY2s3UmxiNHdUK3N4Sm9kUTZs?=
 =?utf-8?B?bnBRVEl0bEIzREFqSWo4dlZjeUhSTXpvNjJvZUJObWFDMGNwOGtnZ1l4WFh6?=
 =?utf-8?B?eFd4dEgvZVVvWm94NWpCQkRJKzZJUzgyQ2gvL0FiblNJeFljNUt3SW9wVThr?=
 =?utf-8?Q?x9gBT8sqRwBWBOZz8JapRzyUg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8c1e62-a3d7-4328-684a-08dc100815e5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 05:10:09.6507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NtgFCLBTlZLeCfhKM+w4qz81IrQaNyND6wMONgsOGkQQb+qg6+40A7Y5o+iyLGZNF7PptntTI8XqshbeV7wEnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8403
X-OriginatorOrg: intel.com

On Fri, Jan 05, 2024 at 03:05:12PM -0800, Sean Christopherson wrote:
>On Tue, Nov 07, 2023, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>> 
>> Wire up TDX PV HLT hypercall to the KVM backend function.
>> 
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> ---
>>  arch/x86/kvm/vmx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>>  arch/x86/kvm/vmx/tdx.h |  3 +++
>>  2 files changed, 44 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 3a1fe74b95c3..4e48989d364f 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -662,7 +662,32 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  
>>  bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
>>  {
>> -	return pi_has_pending_interrupt(vcpu);
>> +	bool ret = pi_has_pending_interrupt(vcpu);
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
>> +		return true;
>> +
>> +	if (tdx->interrupt_disabled_hlt)
>> +		return false;
>> +
>> +	/*
>> +	 * This is for the case where the virtual interrupt is recognized,
>> +	 * i.e. set in vmcs.RVI, between the STI and "HLT".  KVM doesn't have
>> +	 * access to RVI and the interrupt is no longer in the PID (because it
>> +	 * was "recognized".  It doesn't get delivered in the guest because the
>> +	 * TDCALL completes before interrupts are enabled.
>> +	 *
>> +	 * TDX modules sets RVI while in an STI interrupt shadow.
>> +	 * - TDExit(typically TDG.VP.VMCALL<HLT>) from the guest to TDX module.
>> +	 *   The interrupt shadow at this point is gone.
>> +	 * - It knows that there is an interrupt that can be delivered
>> +	 *   (RVI > PPR && EFLAGS.IF=1, the other conditions of 29.2.2 don't
>> +	 *    matter)
>> +	 * - It forwards the TDExit nevertheless, to a clueless hypervisor that
>> +	 *   has no way to glean either RVI or PPR.
>
>WTF.  Seriously, what in the absolute hell is going on.  I reported this internally
>four ***YEARS*** ago.  This is not some obscure theoretical edge case, this is core
>functionality and it's completely broken garbage.
>
>NAK.  Hard NAK.  Fix the TDX module, full stop.
>
>Even worse, TDX 1.5 apparently _already_ has the necessary logic for dealing with
>interrupts that are pending in RVI when handling NESTED VM-Enter.  Really!?!?!
>Y'all went and added nested virtualization support of some kind, but can't find
>the time to get the basics right?

We actually fixed the TDX module. See 11.9.5. Pending Virtual Interrupt
Delivery Indication in TDX module 1.5 spec [1]

  The host VMM can detect whether a virtual interrupt is pending delivery to a
  VCPU in the Virtual APIC page, using TDH.VP.RD to read the VCPU_STATE_DETAILS
  TDVPS field.
  
  The typical use case is when the guest TD VCPU indicates to the host VMM, using
  TDG.VP.VMCALL, that it has no work to do and can be halted. The guest TD is
  expected to pass an “interrupt blocked” flag. The guest TD is expected to set
  this flag to 0 if and only if RFLAGS.IF is 1 or the TDCALL instruction that
  invokes TDG.VP.VMCALL immediately follows an STI instruction. If the “interrupt
  blocked” flag is 0, the host VMM can determine whether to re-schedule the guest
  TD VCPU based on VCPU_STATE_DETAILS.

Isaku, this patch didn't read VCPU_STATE_DETAILS. Maybe you missed something
during rebase? Regarding buggy_hlt_workaround, do you aim to avoid reading
VCPU_STATE_DETAILS as much as possible (because reading it via SEAMCALL is
costly, ~3-4K cycles)? if so, please make it clear in the changelog/comment.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/733575

>

