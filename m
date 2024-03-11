Return-Path: <kvm+bounces-11496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67DC877A98
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 06:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8871E281207
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4578C107A6;
	Mon, 11 Mar 2024 05:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnpRF6UV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D2101C2;
	Mon, 11 Mar 2024 05:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710135145; cv=fail; b=e4itwd2flVcrUzFHlxhvRH4dJI5I0/41vPww7hrqVtSieD/qwtc9QBPM2NGDV0s+r3W0PiI9iEmmhrd6rJsSIWBhadGcTkJ0DkhoANcWuZmQi63s5pmjc7c/uzCQQHR3ABHrXLjapHXo5AS3i5aSTSfc3mV51hXgAVNdKxcHyiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710135145; c=relaxed/simple;
	bh=XqP0JzWay6L9dU9eDWb3cwMs273sY6y1xbIN6EEGXqc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U4A6xur6hX8qUadss1pfefaJmacQd2P4s2KhhNwPyLzymbAN+vUIQsvNbzSqBnfleuNXtIvDqSdJI4fYYqYCzmdqUsqp2NIAFvXWDSkdxZ6kyxzLzqkx+0GVUB3PbucKDcCrChGFEBACSLpaVUtiFqxRJ3iDTQCH8g7F6iTFD0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnpRF6UV; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710135143; x=1741671143;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XqP0JzWay6L9dU9eDWb3cwMs273sY6y1xbIN6EEGXqc=;
  b=OnpRF6UVBUrbJ3VDdeD77mZ2i6QBIm9wUQtWkv27gdYq9lj3LwsuXaf6
   OUj7oO0YZFfRl7exnarkbalsXaHgikCrJktkqXCrswawinaVa9n2A/BOe
   2WyTSd5uWnRklDdUK/IIUPMff4QzelDZKaGT8ylVS434FzWbRpjk+O1qv
   yEybuWoabASRUA2hYDsX0NcSog08vFJqxEJweQ/4gka7cuOrFDJ7J27WY
   b0POXnY3lLUt2vhYxgEdj2jt5R77hnL9KJaMj7NtBcCCsP0Z4/8OK4jig
   lXLbgS067UG1YZxSAkpqlM5wPyuonIDwod8y5dzfZZgJfuFavt0WGrixg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="4960027"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="4960027"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 22:32:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="48512203"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 22:32:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 22:32:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 22:32:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 22:32:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 22:32:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCNr60i+50S6hFemIYy2aFheoXNH+IhqpewNy6euJHt3vP2Tp9f/T9CJN7Ih6ieMUCx0Fv3MA3v0XnjUlO7K5d0S8LMU6DEuso22AR+uuD4fLkkeaFW2SKISbELw9zKv9FC2hz5gmUjQiOD4zWM48wKFujqo/71YgGyTPXmc+wTPsExxlJ5u2bCjb1npDL1NlysS3aRdUKiWmhnZVAChwHJlNvdCNj5kOWFL1aXXB3Zam9qGlwfjYxi46gKlvGmvPtNG1vLS/NKyVEbdxNHt3TsD2RiIVDotivdw3bv3CFpJ14xhMykuNofyoyLSijpozqpexxyWrv6ERfBgIO41wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVAf2EtI3hNqcBpZBaaxFjT1R1GKdASCsEtd1bn70BY=;
 b=fxl5UP41040MxkGdpm/qSxiNRfk7n3bq/mHTI/n9H48PfU3Kf6bEDxOXfhgm0+Hv4kKbHqjyiUm6itcjs6QYOfyOpaSyAjlty1Tehsu6pPD/u44WzQHu8Bd3XQDR7FjwCyxQzFA9IkFQImhepvWBy1NMYSwHdmkmmQArIGSX3bboRRdWyUqmnwIrX+lzJTo6hbw2QNU6ylk6j4bvzoLiUQd39UWEqs+FD1Xxq+aOxESysEQnssDziQYnHJrwJIk2aBG60bZYrqzE9j17ShWKpTg0brZdFqCZOLGKHlrQYF5ycpbN7jyujFN2j0pBDjoG4DBJc0ousAvz2EwOuYMe7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by PH0PR11MB5208.namprd11.prod.outlook.com (2603:10b6:510:3b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Mon, 11 Mar
 2024 05:32:16 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 05:32:16 +0000
Message-ID: <aa5359e5-46a3-48d0-b4af-3b812b4c93ae@intel.com>
Date: Mon, 11 Mar 2024 13:32:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
From: "Yin, Fengwei" <fengwei.yin@intel.com>
In-Reply-To: <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0159.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::15) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|PH0PR11MB5208:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b72ecde-2922-44f9-7967-08dc418c9cec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXRon6m4M9TtNTJs5xS+oPE7+cdZrjsl9Ce4Ymw35ANjNNh6Ih9mjtdlHfk+ZBT+4WwXJSbFnePM+vakDEmQpkuW7XJ/vBPfLqm+s7N+2TOJ73wzTmmRh3SH9ZoKnlWBEphLLXhVYLLjmGLO+PSz7Py5Yv7L9aTOHW7ThAhoLSMR/8BGVZeWGy3wQ6zs/ZFj0MJTjPBW75nZVoQ8BV1KP36iP4jOGgDLN7maft+ByxGS1bzXxOUp9RWstEtH4Fc4TId9A1O/1rVHFcqkObZ6fLJrPVxSBsvf7PJkgXyeTBQ2DdMmineRwCf2zBEjEGJ+nH2K0/iculCEFWNQPQKF9HdLNPWp4jEtRRnZavLqCxxxMxdf0mif0naQtzK4e7L0vZKdgeFDWqRc/Xm073p/fnVmCaTOz7MV+TT9qxbA31nSFXGSWI1UnZ3pVCrAsUxGdNT0qHj+IztjorcJkrZ7Ql4bIlverGacO+2lZtA0qI/C0RddrXz9PIUfQbEHdzzqtO6x7JxORRYEe94HhexnAs8Ly4HFyW2SwZ5wspRnOkx9k6TbyF5+yV+kdU5cGOsJ+6PTy10nPRzmKmjy6wyQwq2K18jT3KSuDCbeySfVBtsVnBwlopgXFCueTqQAVn6lA//dJPRfCIn2QmoOWui6BGpqqV5cb5JQb6NKKreAlSg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnIya2MyTS9GWlg2Vk5id1N4a1VnbHZQZWlIQnhEbzdZeURaNHJ2RHp2NE9E?=
 =?utf-8?B?czdxckswZnMyc0gvR0dFT2hSRnBZZDJRSGx2NGlvdk5iZG9kQnd1REJmcHRX?=
 =?utf-8?B?cXBudXZwZjkraTBwMExIWGhablc2WjVsaHNSY2JobkcxeERtaHBsTE02Vzdh?=
 =?utf-8?B?RGVwTUlGVkt4aTNVUzNicW5BTGg3cHU1ZUlZbXExYUk5dTBHRmRlL0dUOWhJ?=
 =?utf-8?B?ZW8rNzRkY1FZcUdmRUpQaXlZRHI5OFptaHR5NWZQcU1IcHFLQWw0QzdYQUpk?=
 =?utf-8?B?TzhNR2Vsekwwb2pKL0R0dmRHQjZ0cElsRjN6Y2xqcUZuSEhvRjN2L29XYUg0?=
 =?utf-8?B?K2NWejlXZlVKeVVKZEI0c1N5VE52Zi9uS2hZNi9SdUg0cWMrUHdBTHNnamNr?=
 =?utf-8?B?ZVZZMWd0emZMM2VvcG1mWFV6SzZZMkNkSWthVloxZ1RYOEJLQU11M0MwcW4y?=
 =?utf-8?B?Qm4rcTdpeHliUEhlWC94TUxQQklwNkdZWGlqbERHbGVueFlQdXFPcW44eEhS?=
 =?utf-8?B?ZHU1YWdUQUU1SUtLeTltelI0Sk5TM09ybDNmYnk0enZlTkt4TEp3eHFVcDF2?=
 =?utf-8?B?elFDU083cEp3MUJyUHp0WWh2eDNTWlRuUy9DK3pXV3VTQmxCS3d2RmY5SjNy?=
 =?utf-8?B?S1p1SUt3WDduTVNkUnQrblJKbFloL0ZxK1FiUDdTbElLZ1BESC9IZTNuMVp5?=
 =?utf-8?B?eXl0N3YyamJDU1R1TlJpallrNDFqZmdBOFpuZC9DbUYvaGpIMmViRGlBZnNv?=
 =?utf-8?B?RUhZdnRMbEcxS2ZVbEZCeWcrNXkxVnJ3SFR6Y3RaaWdOc2E1MmxrejBFSG5Y?=
 =?utf-8?B?VUt1TUd1cDloK1NnOEwvdndNRjBiWEFZTzMrS253T3Vya2cvMjduOUNyZjJu?=
 =?utf-8?B?OTJqRGhFcTFyVDk4UGo0RHRyMlRhQXFZWEJVcWx6NlJxaEEycENUbWMzWWxz?=
 =?utf-8?B?SmhldU1nOS82UytMY1Nxa2dISkd1ZXNLSzBvNnBQd01OZERXT2dzRWZOTnhv?=
 =?utf-8?B?Uk1rc3JuUmx1R205OFZ0Tk9Iczlrek9mY0xySUpZNFpzNWdTSmFjVHgvUWR0?=
 =?utf-8?B?cXhhRVBUT1hWZG96N3VXVUtKc3NWUmdEbXU5RHFQbTBubmVhR2xFaTMxd1hl?=
 =?utf-8?B?S2RMQlJsU1I4MlhRRXNETVBFOTlKM1BOWkdtMUxzZWRkVHJzUEhldnhUV05G?=
 =?utf-8?B?Um4rWHZ5LzF6SlZrMHVUMnNzZ3prM0RvMDZvQU9CYUE4eUdyZFlXNDV0TGdh?=
 =?utf-8?B?SzdXWU1YNHV6aTdZOXB5V3dLaTczUWFOeGhGdkx5d2luRDFjdFhFcVgvWTcy?=
 =?utf-8?B?bnExMDEyMlJCM290cDhFY2h6RVZlbjc2NkgzUEllVTM3cnVVMkJsL3ZkdTFQ?=
 =?utf-8?B?dHQ0QXZGZGJpSDR0RnJtU0tOR1VNdHFNQ2ZQNUlaQU0zc256VUFYemRFK0xE?=
 =?utf-8?B?bWNoeHE2aElDbmU5TStBdGtzMGNxTkdqTUZrLzUrQzZmU0JwdzhabkxLaytK?=
 =?utf-8?B?M1Q5Kzk3TGZzdDhCTHhmZnBaTllvYTZiTTJzR2tMM3Q5THBSa0ZkcjZ3MVF3?=
 =?utf-8?B?RE1OWmU4bHVmV2RtMStDUEFtZThXWTlVOHpZeVh6QXNyamg1OUN3SGgrSFBt?=
 =?utf-8?B?VzRtYmpUZFVRbFpPMHRybnZ6eXpxQ0FGSVhqODFMS2diUFlxM2J6QUdxb2tm?=
 =?utf-8?B?KzJpMXpwSkV3WCt4U1Q3M2hKaXNOZ29DY3Ezd2RQMWZrT0FYYTd3ZXBtajRI?=
 =?utf-8?B?UFFuM1hPQkxpMTNtQTVPYTdqM2phRTk4TG1DNVU1NHlOckRYam5vazUrdTV0?=
 =?utf-8?B?N1RUQ1F0QTAvMDlBcWRWVjk5ejJhTlVSR0Y4dU1CbDhBZytpS29YUzd1MkI0?=
 =?utf-8?B?dzNlOGNZWHlpaEhMTnpmTXNCeDNPRHIrY3MwaFNmMlMwaHlLUDlTRTJHaU5D?=
 =?utf-8?B?U2JtdW1EWDN0M3hwZDlMdS9kTzAyZ28zMTlockRZRDQ3WjBWQnFrbG1Id05p?=
 =?utf-8?B?WnNSWCt6UGtLaXNRbzdOcmxvcEUvTW5KL3hHTlB4dkczeEZWUkFnejJudEE2?=
 =?utf-8?B?YXVkWEZKL1dsekFkb29DenNUVlRvcVpoWU9JWnRNYzlDRnF4S2lETUxuZ2sr?=
 =?utf-8?Q?5IymhWlta2GTCAJ2TG9surG66?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b72ecde-2922-44f9-7967-08dc418c9cec
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 05:32:16.6605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7GGvVOov0I0V51XQ6fBABJUprHEZvCLtyZVesKgddNScrgvMJEY9EjIpvW/3L8Yt+KOY0FYAvKSAEL5MV6y6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5208
X-OriginatorOrg: intel.com



On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Currently, KVM VMX module initialization/exit functions are a single
> function each.  Refactor KVM VMX module initialization functions into KVM
> common part and VMX part so that TDX specific part can be added cleanly.
> Opportunistically refactor module exit function as well.
> 
> The current module initialization flow is,
> 0.) Check if VMX is supported,
> 1.) hyper-v specific initialization,
> 2.) system-wide x86 specific and vendor specific initialization,
> 3.) Final VMX specific system-wide initialization,
> 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> 5.) report those sizes to the KVM common layer and KVM common
>      initialization
> 
> Refactor the KVM VMX module initialization function into functions with a
> wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> among VMX and TDX.  Introduce a wrapper function for vmx_init().
> 
> The KVM architecture common layer allocates struct kvm with reported size
> for architecture-specific code.  The KVM VMX module defines its structure
> as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> TDX specific kvm and vcpu structures.
> 
> The current module exit function is also a single function, a combination
> of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> logic and KVM common logic.  This is just refactoring to keep the VMX
> specific logic in vmx.c from main.c.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> v19:
> - Eliminate the unnecessary churn with vmx_hardware_setup() by Xiaoyao
> 
> v18:
> - Move loaded_vmcss_on_cpu initialization to vt_init() before
>    kvm_x86_vendor_init().
> - added __init to an empty stub fucntion, hv_init_evmcs().
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>

With one minor comment. See below.

> ---
>   arch/x86/kvm/vmx/main.c    | 54 ++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.c     | 60 +++++---------------------------------
>   arch/x86/kvm/vmx/x86_ops.h | 14 +++++++++
>   3 files changed, 75 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index eeb7a43b271d..18cecf12c7c8 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -167,3 +167,57 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
>   	.runtime_ops = &vt_x86_ops,
>   	.pmu_ops = &intel_pmu_ops,
>   };
> +
> +static int __init vt_init(void)
> +{
> +	unsigned int vcpu_size, vcpu_align;
> +	int cpu, r;
> +
> +	if (!kvm_is_vmx_supported())
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> +	 * to unwind if a later step fails.
> +	 */
> +	hv_init_evmcs();
> +
> +	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +
> +	r = kvm_x86_vendor_init(&vt_init_ops);
> +	if (r)
> +		return r;
> +
> +	r = vmx_init();
> +	if (r)
> +		goto err_vmx_init;
> +
> +	/*
> +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> +	 * exposed to userspace!
> +	 */
> +	vcpu_size = sizeof(struct vcpu_vmx);
> +	vcpu_align = __alignof__(struct vcpu_vmx);
> +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> +	if (r)
> +		goto err_kvm_init;
> +
> +	return 0;
> +
> +err_kvm_init:
> +	vmx_exit();
> +err_vmx_init:
> +	kvm_x86_vendor_exit();
> +	return r;
> +}
> +module_init(vt_init);
> +
> +static void vt_exit(void)
> +{
> +	kvm_exit();
> +	kvm_x86_vendor_exit();
> +	vmx_exit();
> +}
> +module_exit(vt_exit);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8af0668e4dca..2fb1cd2e28a2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -477,7 +477,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
>    * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
>    * when a CPU is brought down, and we need to VMCLEAR all VMCSs loaded on it.
>    */
> -static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> +DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
>   
>   static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
>   static DEFINE_SPINLOCK(vmx_vpid_lock);
> @@ -537,7 +537,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> -static __init void hv_init_evmcs(void)
> +__init void hv_init_evmcs(void)
>   {
>   	int cpu;
>   
> @@ -573,7 +573,7 @@ static __init void hv_init_evmcs(void)
>   	}
>   }
>   
> -static void hv_reset_evmcs(void)
> +void hv_reset_evmcs(void)
>   {
>   	struct hv_vp_assist_page *vp_ap;
>   
> @@ -597,10 +597,6 @@ static void hv_reset_evmcs(void)
>   	vp_ap->current_nested_vmcs = 0;
>   	vp_ap->enlighten_vmentry = 0;
>   }
> -
> -#else /* IS_ENABLED(CONFIG_HYPERV) */
> -static void hv_init_evmcs(void) {}
> -static void hv_reset_evmcs(void) {}
>   #endif /* IS_ENABLED(CONFIG_HYPERV) */
>   
>   /*
> @@ -2743,7 +2739,7 @@ static bool __kvm_is_vmx_supported(void)
>   	return true;
>   }
>   
> -static bool kvm_is_vmx_supported(void)
> +bool kvm_is_vmx_supported(void)
>   {
>   	bool supported;
>   
> @@ -8508,7 +8504,7 @@ static void vmx_cleanup_l1d_flush(void)
>   	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
>   }
>   
> -static void __vmx_exit(void)
> +void vmx_exit(void)
>   {
>   	allow_smaller_maxphyaddr = false;
>   
> @@ -8517,36 +8513,10 @@ static void __vmx_exit(void)
>   	vmx_cleanup_l1d_flush();
>   }
>   
> -static void vmx_exit(void)
> -{
> -	kvm_exit();
> -	kvm_x86_vendor_exit();
> -
> -	__vmx_exit();
> -}
> -module_exit(vmx_exit);
> -
> -static int __init vmx_init(void)
> +int __init vmx_init(void)
>   {
>   	int r, cpu;
>   
> -	if (!kvm_is_vmx_supported())
> -		return -EOPNOTSUPP;
> -
> -	/*
> -	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> -	 * to unwind if a later step fails.
> -	 */
> -	hv_init_evmcs();
> -
> -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
> -	for_each_possible_cpu(cpu)
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> -	r = kvm_x86_vendor_init(&vt_init_ops);
> -	if (r)
> -		return r;
> -
>   	/*
>   	 * Must be called after common x86 init so enable_ept is properly set
>   	 * up. Hand the parameter mitigation value in which was stored in
I am wondering whether the first sentence of above comment should be
moved to vt_init()? So vt_init() has whole information about the init
sequence.


Regards
Yin, Fengwei

> @@ -8556,7 +8526,7 @@ static int __init vmx_init(void)
>   	 */
>   	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
>   	if (r)
> -		goto err_l1d_flush;
> +		return r;
>   
>   	for_each_possible_cpu(cpu)
>   		pi_init_cpu(cpu);
> @@ -8573,21 +8543,5 @@ static int __init vmx_init(void)
>   	if (!enable_ept)
>   		allow_smaller_maxphyaddr = true;
>   
> -	/*
> -	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> -	 * exposed to userspace!
> -	 */
> -	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
> -		     THIS_MODULE);
> -	if (r)
> -		goto err_kvm_init;
> -
>   	return 0;
> -
> -err_kvm_init:
> -	__vmx_exit();
> -err_l1d_flush:
> -	kvm_x86_vendor_exit();
> -	return r;
>   }
> -module_init(vmx_init);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 2f8b6c43fe0f..b936388853ab 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -6,6 +6,20 @@
>   
>   #include "x86.h"
>   
> +#if IS_ENABLED(CONFIG_HYPERV)
> +__init void hv_init_evmcs(void);
> +void hv_reset_evmcs(void);
> +#else /* IS_ENABLED(CONFIG_HYPERV) */
> +static inline __init void hv_init_evmcs(void) {}
> +static inline void hv_reset_evmcs(void) {}
> +#endif /* IS_ENABLED(CONFIG_HYPERV) */
> +
> +DECLARE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
> +
> +bool kvm_is_vmx_supported(void);
> +int __init vmx_init(void);
> +void vmx_exit(void);
> +
>   extern struct kvm_x86_ops vt_x86_ops __initdata;
>   extern struct kvm_x86_init_ops vt_init_ops __initdata;
>   

