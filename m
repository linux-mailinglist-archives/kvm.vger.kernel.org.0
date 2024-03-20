Return-Path: <kvm+bounces-12193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DE388085D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:03:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C24E61F234CC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66827EC;
	Wed, 20 Mar 2024 00:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZE39qRGD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8656618E;
	Wed, 20 Mar 2024 00:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893023; cv=fail; b=Nu2VEam5uHpGl4thVxkPD0JzyU07K9KiSxdMcRN9LlgvzEsYbSUfeVuvVi9MbG+hAHAVo/6poZeUT/uIIkyUBzXHBWuWBXZrR2/6LhLum2QEwH9mfF+oG6Xq9GiYsqxcQQDbnGerkmyctddIueUjuozOlFNrH8C4D90Bqmx5Hto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893023; c=relaxed/simple;
	bh=cyvjDMxYAyCsKr398Sr2ZZZHWROrJ9lo1UqERhYG6/s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jB4czydxrk2dlp33dherIWQyqSEAhNgWyQsiHLDgKRjcKfj3oyAtvdO8ipczy88ZewUQZik2AlEyKUNtMPM7Y40yAjeIrprG5KeJU9fqSUehPY8Ke/aNNRMKRYi/rzmv+7CtP7ZW/a6tEMLSDLEmnCghipHRU31U8OEUW2Z9q/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZE39qRGD; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710893021; x=1742429021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cyvjDMxYAyCsKr398Sr2ZZZHWROrJ9lo1UqERhYG6/s=;
  b=ZE39qRGDJkXQESJnmxFc3JkxS6ZE8e0vYxln++sl6yEASOHcU3xn2Z78
   GGT+baIDV4ON/NqipaSM8M7CljqampHXR1aHSJZKexk2W/Gb1vu+ORPuE
   Fg2eJiYGKQ53/NcTR1mUCald7jU1gDZQIVmpZyhRyBf5lXJVAuFPSgFFM
   1CoP92XS8cJEGfJZHcWP1Ghg85XIvecOYw8L+nEa0z37Gpmfgg4xhE+zb
   DpkhFn68dn7lVo6wUB0YXmuI3hS2lqHyO+3sLZRNsrdyFKnkE/ae9HMmX
   BC+iSCEA9IMuTwQRPWmMojXlEPThN5ax9hkQsf0XbYHlv80aiYIE+NkBd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="17200942"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="17200942"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 17:03:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="18434090"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 17:03:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:03:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 17:03:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 17:03:37 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 17:03:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKim69+xFgD0rGI5AdDpYH4UhK75nhOWtTiNbRAaNnDUHwh9gWAa2WNenjSdVE/lXenCwfaTKREDeeFMKR9GVqXVnxXAMNXokit6jfqSnyGTUztIwrhh7IPmMlzJwuTmUbth7qOKRdb2Uznv5DqL8Y1OlXsewg3eW8WkxOy3Flo0942kEOP8MM4DDR2Mwk3m40ExJ6XJmNq0L24e6YWOO6HpzkU9VRR3ysvV153T8BTADsb4ExouoBHAe3FNhGgPRkCyzQexj+C/tKuZQzCWEVc4JODNcbhhfkIBO2LnZqXf9ncBz+NHThygEyMTW8FBOu1KQel8zO60wRMzf3l6Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfrpbKtLlMskwfzk8KEoEhvSrToZ1hkayv0z2gWF3iY=;
 b=Zoyo4JO/8WXQ5vlcKnfpYXg5qdOTGC24AHzR2QDQuI8uw5W65LHuJvFyEtAc4ipsfh3apFY5wDrriEUFMhUipEeUAtf9t8hCIN6w8QyakQNK/1uxTYDbbCK8Nima2iUnpODAHbAWwv8amHpg4OrxskpGADve/l34wX0smSXKfHHKS+1HBhIBJ4Jm5nR8qeHWFGaKZ5Fsf6NryMZHlqQ6Qvh4zSDvuQ4ijXdJVqErvaoPlvTDwFMrk6ug8wNduJulH3qh2blNcU2Z0SqTN6AOBq+LFESYXs+P9b9QGfHZClkZ5dTvXX+V9vOCc+VzNHeTlfaQqSm6pvK9IQ6g6Yb88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4863.namprd11.prod.outlook.com (2603:10b6:a03:2ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 00:03:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 00:03:33 +0000
Message-ID: <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
Date: Wed, 20 Mar 2024 13:03:21 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Content-Language: en-US
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:303:6b::17) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ae6409-6c36-4a6d-076f-08dc48712ed5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwHw5ks1wioxPdgnFK3m7PkhnjVHF6c2yLDhnS9NI4NXu4ao68w2/oHTMxWuzUtwlCOP2qFvDhDWgeAcI/uFGC7M7l9xKIW6XJHUuL5XDiWdAACoaSiCovtmd1TNguIaw6f0n2HPTT9WJQT7j3WUSzuPAMC++2WZUU153XMNcJ1gFMUiab81q8smd3gbhUob9FL2KeJBSUmYFkC+A75Ri6kwVbDsR5Btsa2TGTs7eVVGSRiofRePcoJ2Z0xXPhG8Z4ij4jwjJz0BUicqc58ofFMVCkHLnxvVNdizo28gdtDrvgqe2TCzWI6ANShayl/ftEAs8WIOW4KVwgmG+XNNIBVWrVFZ1evdMmI9dI0Ve6so+Be+xAsbUwhe28wdzKSpLTop6Ch1jcqQuvrkBdpB0LOG+cRiPekTWj2U+lDeT9395eyqO1Pr3HIgcI1TTH+MJ2eCzd+ziJWsHbuBn1DVPa2jI+14RZIgyFxmKRSfNef6knTkeZN5yFgRKXPh4CsQMScMXHb4i4Fod24IH8BphOxjay+BoMfdxDV3ol+aMyAs3QUuG8XSsfXgJj3Ik1F3X68VHFjVIlnW247MK1xVWDTd5kGMkNj2gglWuZw6SWU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2hkR3FsemFnNUlxdE9KRndGc2hkaWFBL2Y2ZUdmWlRNc05sUGhuZEkzaFpC?=
 =?utf-8?B?NDVCamlIbFMyT1BXSTliYVZNa25oZUdmczlUbUlyMlFCS2NiVWVDVlRCQ0h0?=
 =?utf-8?B?OW5YUnM0WXhsMSsrU080UzdvY1c1Q1JrYlphenRFTi9wZEtSdjdqQlJFR1VO?=
 =?utf-8?B?SkdKLzBHbllOLzRPbytvd2xTUFBHMUF3dEV5WHZ1TUhwdVQwUzhrWENtbWpW?=
 =?utf-8?B?R2ZDeFpBencybEttWDBFc1ZDcWd3Qk1BM3QyVU5tNzJ5bGFJa28vd0FxWUxz?=
 =?utf-8?B?YXNZVmM3SXVJV0hpd0thUEFLM3haSW15TTBzR2NLZkhwTnNHczVkcG1vVTMw?=
 =?utf-8?B?VExqZDRHajBMVGxRNTNWUk9NZy9oVFcydmZqZlFFdzdTWlp4dS9oSFZZeGRi?=
 =?utf-8?B?RXc2aFI5dlBjZEtzQ2tDeS9jbFdWTllpOHZMYVlzRE42U0lqM0toNk1aTUFa?=
 =?utf-8?B?RzExbXRuSTd0eHdRQ2JQQ25nQVJzQ0RWVnlYSCthNVVteW9rUmp0Yk9mRnZv?=
 =?utf-8?B?OENNTjZBdzRqMVdYaHpxdk5QUENlZkhKdzdBUGVKQUV1VzBvVjZwWW1BVXVi?=
 =?utf-8?B?ZW5oYnpPWlFjVXFubVNYWkZ4eDhYRXcwcWQyTFBqWEJTN1p4QTBzYkFVa3c2?=
 =?utf-8?B?cVlKeUlUSy9CN1lNOFpFSUMxa2luVnBKQ3hxWm5yM2FGeWlQanQ4QS9YT0xK?=
 =?utf-8?B?UWFXOWZtNjF2Z0VmbnlNMDBNcE44MlQza3JKOU5RN1ZHUXNqNEl1bWZ6NXVG?=
 =?utf-8?B?eFlqVHF0UmNWczUrWHRFWjRXRFNhNmwxazc2cGNTZmdnT0xDRE9haEVPVDg0?=
 =?utf-8?B?cXdxY21VUE5NbFJFbi91aTdpUDYxSVBvaGJORXlTWkE1OHBTR2oxckNqSUNq?=
 =?utf-8?B?Rit6dDNCUmxwb0RuZU5BZ1M3UGJFY0ZQNzNHTjBRUzE0UVdRdVJ2cGYvcjJz?=
 =?utf-8?B?RXBBcjh1anVMWk0yVEp0dFNGZExzTkh4eEFuNmhnZU9CZk9tY1Mwd29Pa3hZ?=
 =?utf-8?B?cDlOd0N2OVFSWmhhNVE1R0YxQllBTUp2dVhiK0VUUVpFMVo3cmVWdU9pa3B6?=
 =?utf-8?B?NEJZc2lFQkpiWHJaNmVDSVBxYUtRb29vZTYzU1ZheWtQb1p6VFFqNllGcWE5?=
 =?utf-8?B?SklRZUtGQmdadU9pTGdQTXpVaFlQN01OeWtnRklrK0lSSklkaUY2TkJCSEJh?=
 =?utf-8?B?TjlncHcyQzN4d2lqUGFWZUNUeXk2SGsrMzhYNXFLZnZNUEMzdmdJK1NSL0hR?=
 =?utf-8?B?Rjl6S05EWTBHQkN1Rkl4bE1KS0lSVWI2bjJRa1BTc0JsVVYweEgzN0R0UmxE?=
 =?utf-8?B?YVpvK2FhdXJQaUN1dTFZTE1SM0Y3bHliYTZLUUZicWs5UUVpYUJmSVBPekJ0?=
 =?utf-8?B?RWRDUm9MT2FhNkM1SGRxR0gvbUYyV25jSzZReC8xT3plV2dIRlhpcGc4a2ZY?=
 =?utf-8?B?dDRySWVuQnV2Uzl4aWUyd3BmM1VrYTYraUtNTDYzNVRTeHRYRU5Mb2c0RGhj?=
 =?utf-8?B?R1lNNXpML1IzQ1hDMHFRaHl2ckRwa0s1TzYyWnZHQUJkb1VCbFAyZUpPUktu?=
 =?utf-8?B?S2UrUmZ2U0Y5UUpBZGIxK3dRdjVBOVlBd01la3B1QVdwTjZUNmV3cXB1bmZo?=
 =?utf-8?B?ejFQeHRUVlM3M1BXbTg5d05rMW9BQ09LYmdhbGJ1U0F0SzcxRVRtWHJLb2pZ?=
 =?utf-8?B?c2FCWHU5M0FacnpqNjlYNEZXSVNuSW5NN1kzUUtlckJBblFqallyOHBlRXlk?=
 =?utf-8?B?aTFJRVh1MTBnNTFoWlZFN0VYUnJoMGVtSUpNYjVuYkVFZ0tzaDBEakI4L2Z3?=
 =?utf-8?B?d3llbkF0UDJXWjlxR2tObmhLSHI5VVg2RUVsdTJ0NDlzMjU0YS8xSDM1Mk8w?=
 =?utf-8?B?dUR2amc5eGFWazdWU0liWEdwaDFLbWR4QVBxbWcrVkpWWTVlNzQvVUJuMzlz?=
 =?utf-8?B?aTlJQmhuRGlxY05yL0pZSThiZ3ZnWnhVYjl6QjEvMnhkT05jWWpUY21iYzFY?=
 =?utf-8?B?TjFYQjg5OWVERXRPaEl2enRwWWxUd1oxeEhGdTN1T1VGd29nU2RIbUxFQXZz?=
 =?utf-8?B?M1B0TXBMRCtNbldNQWJuZk1pS2VuYU16a0MxeWtTOUpEZGtPOVRpZWNCVUgr?=
 =?utf-8?Q?+GAk4WMQxSRpusj3SMa3/TbzG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ae6409-6c36-4a6d-076f-08dc48712ed5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 00:03:33.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/Rb59rkFNIQJ3qUMCk27uomuwgqVR1uw/lSxt4/t05W9fRjiWI0WvVv57Y9Qxaf8lae/TDx++tq7qbNpg5g9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4863
X-OriginatorOrg: intel.com



On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> A VMM interacts with the TDX module using a new instruction (SEAMCALL).
> For instance, a TDX VMM does not have full access to the VM control
> structure corresponding to VMX VMCS.  Instead, a VMM induces the TDX module
> to act on behalf via SEAMCALLs.
> 
> Define C wrapper functions for SEAMCALLs for readability.
> 
> Some SEAMCALL APIs donate host pages to TDX module or guest TD, and the
> donated pages are encrypted.  Those require the VMM to flush the cache
> lines to avoid cache line alias.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Not valid anymore.

[...]

> +
> +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> +			       struct tdx_module_args *out)
> +{
> +	u64 ret;
> +
> +	if (out) {
> +		*out = *in;
> +		ret = seamcall_ret(op, out);
> +	} else
> +		ret = seamcall(op, in);

I think it's silly to have the @out argument in this way.

What is the main reason to still have it?

Yeah we used to have the @out in __seamcall() assembly function.  The 
assembly code checks the @out and skips copying registers to @out when 
it is NULL.

But it got removed when we tried to unify the assembly for 
TDCALL/TDVMCALL and SEAMCALL to have a *SINGLE* assembly macro.

https://lore.kernel.org/lkml/cover.1692096753.git.kai.huang@intel.com/

To me that means we should just accept the fact we will always have a 
valid @out.

But there might be some case that you _obviously_ need the @out and I 
missed?


> +
> +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> +		/*
> +		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
> +		 * This can happen when the host gets rebooted or live
> +		 * updated. In this case, the instruction execution is ignored
> +		 * as KVM is shut down, so the error code is suppressed. Other
> +		 * than this, the error is unexpected and the execution can't
> +		 * continue as the TDX features reply on VMX to be on.
> +		 */
> +		kvm_spurious_fault();
> +		return 0;
> +	}
> +	return ret;
> +}
> +
> +static inline u64 tdh_mng_addcx(hpa_t tdr, hpa_t addr)
> +{
> +	struct tdx_module_args in = {
> +		.rcx = addr,
> +		.rdx = tdr,
> +	};
> +
> +	clflush_cache_range(__va(addr), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MNG_ADDCX, &in, NULL);
> +}
> +
> +static inline u64 tdh_mem_page_add(hpa_t tdr, gpa_t gpa, hpa_t hpa, hpa_t source,
> +				   struct tdx_module_args *out)
> +{
> +	struct tdx_module_args in = {
> +		.rcx = gpa,
> +		.rdx = tdr,
> +		.r8 = hpa,
> +		.r9 = source,
> +	};
> +
> +	clflush_cache_range(__va(hpa), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_PAGE_ADD, &in, out);
> +}
> +
> +static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> +				   struct tdx_module_args *out)
> +{
> +	struct tdx_module_args in = {
> +		.rcx = gpa | level,
> +		.rdx = tdr,
> +		.r8 = page,
> +	};
> +
> +	clflush_cache_range(__va(page), PAGE_SIZE);
> +	return tdx_seamcall(TDH_MEM_SEPT_ADD, &in, out);
> +}
> +
> +static inline u64 tdh_mem_sept_rd(hpa_t tdr, gpa_t gpa, int level,
> +				  struct tdx_module_args *out)
> +{
> +	struct tdx_module_args in = {
> +		.rcx = gpa | level,
> +		.rdx = tdr,
> +	};
> +
> +	return tdx_seamcall(TDH_MEM_SEPT_RD, &in, out);
> +}

Not checked the whole series yet, but is this ever used in this series?

[...]

> +
> +static inline u64 tdh_sys_lp_shutdown(void)
> +{
> +	struct tdx_module_args in = {
> +	};
> +
> +	return tdx_seamcall(TDH_SYS_LP_SHUTDOWN, &in, NULL);
> +}

As Sean already pointed out, I am sure it's/should not used in this series.

That being said, I found it's not easy to determine whether one wrapper 
will be used by this series or not.  The other option is we introduce 
the wrapper(s) when they get actally used, but I can see (especially at 
this stage) it's also a apple vs orange question that people may have 
different preference.

Perhaps we can say something like below in changelog ...

"
Note, not all VM-managing related SEAMCALLs have a wrapper here, but 
only provide wrappers that are essential to the run the TDX guest with 
basic feature set.
"

... so that people will at least to pay attention to this during the review?

