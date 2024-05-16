Return-Path: <kvm+bounces-17517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 872A98C71E6
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 037511F21F85
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184062C6A3;
	Thu, 16 May 2024 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlyLlWbC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BC0C8D1;
	Thu, 16 May 2024 07:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715844035; cv=fail; b=gndbr/htR6GTua47bLmrlnLYhu9PzCdOYQxy1yuZHqsCLkHLtixXGNTmoLZRvRNR6vsdH7FhOuaVc+TYynZxquLsPWJZLlez3rB37qhvT6DE2AEBdNVLSQ9NVnKhbb5v51LKnuPiW6FOr687wuz9qaIjFE9jETmDX+0rxi/Tclk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715844035; c=relaxed/simple;
	bh=NBuu10wr8hvN20auJJBZ9Tj3JATzDwfYXPd8n6+pEWU=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NIjQ0tPSGoA6JJFHOp2bzX0X5NONX3yPh5NSLYyWxGVAsEu+RwWtNTD5Pbu24gc9a4mb1LpSVDRdDoA94v3zNvcRC9kjoFBILp5cGZ+AAEXo0jeAfSf7HXWTkTZ2BJW8nJKJYVdKriIR9zHPp1IB3vD25yl46YyV779irGdoj1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlyLlWbC; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715844034; x=1747380034;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NBuu10wr8hvN20auJJBZ9Tj3JATzDwfYXPd8n6+pEWU=;
  b=QlyLlWbCLZ11GUpim4zkaQkrvXmtzF+GabztsscX8f5i2s8jnUzmxUbr
   E7TZy7iX2ZGEpyd6clIeafFdxayz4yRQ7QbFQFMX6byWgWicjmQisUJXm
   vi2nZP093VFZeRd3mzz8hhAYu/FxczrivdEmle/aV+Kl97Zq7XY0HK1QJ
   LXPOOKBcTeL9qYOPyaQ8gcRPGf9rp2Xj5fenEd2IeKnnQkuLVxhngatFa
   fskBia2nO5OqeD3XKIyaUHJ4M/j4d5g1qcOYk5oZuH+PNWo27PxvPjs83
   7g7zd4VNkh9qS209EYjF82cCu+gJv+g94xwL4E5E501ZbxA7VUfwTwJ7l
   Q==;
X-CSE-ConnectionGUID: gNkPSClgT1aEL8CbOAYTlQ==
X-CSE-MsgGUID: 1myqTodJSG6geQm/i5daSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23338157"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23338157"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 00:20:33 -0700
X-CSE-ConnectionGUID: KnwJPInmTl2t5JQii5Yj1g==
X-CSE-MsgGUID: LrVGqNnxQES52+0Cn02iUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31898767"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 00:20:32 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:20:32 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 00:20:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 00:20:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHHcHSX2pM+I9Pi3QtH/qkkRSHOiQuzBpe2Z8TXpS/MJlpyIf3GTE3/j0ZeFXISUwjt8qCBda6cnbTWt+MpQb6Vp2zyht8U0MxZaCOHY/zBJQgZwz56BA6cJlAis/qPP2mKtzHb97vx5D9Ik3IKqjrbAg+x48efTHT/CHXfsjK7lsmIjft+nNpqRlqd0cSk6l5B0/QJ8zEwC6vauF4irtFGi3ZA9XO8VrfJ2gOK0eYJY8U0IXdjGJ8WFv9HAS6Z+bCI/7E7wuVuX+cMp5sICNrzrS3rRTN8LI/BeMMhAd7Ghd2XARPz04J5ypHB7ArcioooEDGRwNcMJC5u2p5NoUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBuu10wr8hvN20auJJBZ9Tj3JATzDwfYXPd8n6+pEWU=;
 b=ALEz9e47EG9+FrYkKNAEEMFDy86WqX6uZf8cJ1p4jFrbvsl2bNkeHTnSKR2pMjDu+PdK2lrWPqgd8uwuzQnKRyeYa7M9+GksO+51Dmjhy//TPHrjYeiosAAFOJjV/cYzl3uWXSCZ41jqXeQ8grUI+Bt3P5xQ1JCh4K4FIrpjNE4PbMr8UQr/MQ+12SAF2PtMseH0cpHxJoE8l41XO3tmKVp7F9xRnSb5o2JeIqcLH7go/Sgdnd7WUCIxifjSS0Y1EDR4Mg0mJdTewrcgD70ZCxk8dU2aBZiAHwvNFlwKxqCBVZirBV1NvvQDNd+6mDl+xuqHAp0PUwRvW7c2qaSyPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 07:20:30 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 07:20:30 +0000
Message-ID: <f77496b0-ee94-4690-803f-44650706640f@intel.com>
Date: Thu, 16 May 2024 15:20:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: "Yang, Weijiang" <weijiang.yang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLRnisdUgeYgg8i@google.com>
 <83bb5f3f-a374-4b0e-a26d-9a9d88561bbe@intel.com>
Content-Language: en-US
In-Reply-To: <83bb5f3f-a374-4b0e-a26d-9a9d88561bbe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0130.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b7bae0e-f1fb-4aed-c093-08dc7578aaa0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnZaakVpYndtVXhOVyt1elNXY2FKckxpYlM4anhMUkpaQ3VyWnYrdC8vMEVl?=
 =?utf-8?B?Z2xMSkU3Z2laSzA3T083bXZGMzJLOWdaKzVqVXZkd3lZUWlYOEVBZSt4RVdm?=
 =?utf-8?B?Vmx6TVZxd1FUQm1jRWhsTXZHQTViNmhyNEpDZU1GT0hOOUQ4N0N2dXNSOWVC?=
 =?utf-8?B?VTNJUE4wUE1nVnBFRHJTOHg0anVTcHRHc1NmQXBRbjU0QmM0UmtiRkV5aVUw?=
 =?utf-8?B?WDBYSVgrU2FCaG44a3QxZXhqc3RnNVRNOWVXRnZTbkxkYXNBV2xJOEJqOHBZ?=
 =?utf-8?B?cG5WaGllN2c2bEZyenVVYWhicTQ2MjhZMkR3TmY4ZjVUSVRPZGxTNGR3MUJr?=
 =?utf-8?B?RS9YS1ZKUlExdmVPK1JJcWFDYkJyU0JYenNhLzNkeDNwcjJsajFvWWxvR1l1?=
 =?utf-8?B?eVpRVCtiRy9UYm5Ubmg5d21kc3BTa3JuaHpUQjhwcjdIaWlESDVSVGZzVVlR?=
 =?utf-8?B?SDFFL3p3YTlXMDltLzJnZW1TWk1TL3Y0RWZoSFlCR3AwSTNkdS9BbDNxSW92?=
 =?utf-8?B?dkdHM2RJcUVmOFV2amxNQnlvT05DMXNtTWJTbXpVMmpFelFEb1Z6TFJBMzV5?=
 =?utf-8?B?N3MzUFZ2Tmcyai9KcndPaENVa1lpTTVlcXA2UTdSRDVuSGJmTEl4VHVGUi94?=
 =?utf-8?B?bHFVTW5POGNoNS9UbHdUK3JxSnV6bnU2SzROUXVDc1hxZEpQdGdrUWdZUCtD?=
 =?utf-8?B?TFhwVHJEbU9kckhxQ0l6OUd1c0xONEJHQlA2d3NXT01ZS09mMEJpR3IzTGp4?=
 =?utf-8?B?U0lFaUkrdkd5cFpWS3AzcUZtS21YZnNNdXBJYXZnd1RyajNlQk95NDB0NVZv?=
 =?utf-8?B?WVUwTThaQitVd2RodkllYjlSekcvTmRPMVVZQnFubktjek95QWNYTnFtcG9Z?=
 =?utf-8?B?eEkzdDZEb0F4WVh1NEtqcUc1ZFQ2VFFxYU95SFlrQWd6ZlZiTVFCY1oyczZa?=
 =?utf-8?B?bCtQb2xCejFSb1NBNVNHSFlYUnE5QjYwbXJvTFpZbmFNTWowMkJJb3dadDVP?=
 =?utf-8?B?eFl1VXE1Vms2OENIS24rdEp3MmZVRjI1V2kxTk5CVlV0U1FPWE9QOFNGdTdK?=
 =?utf-8?B?MU04eFNkSTdiUFpKUno4YjRRdG5CTHJnNDd3UmZEcjQvVnNqT1dlTDRMcEJZ?=
 =?utf-8?B?VUFWK1QrVSs5cGl2N3AyUUlpcGcxalR4YndnTUhNdjFQSnZwei9tSUZMY0Nx?=
 =?utf-8?B?TmhHSXBIbjEzWXU0OHpzbnZKbW0zcXAvMUVmWEowU2VxaW1lUkZhNzIzUGho?=
 =?utf-8?B?OWhjRkd2SEU1cVp2RUlnZlBMVmJ3UVBLK04wd3A5c0t4YnYwQ3FzL01XdVJ0?=
 =?utf-8?B?aWhzQmtEM3VvNm9EUmdaQTFNSFlOWlV1VTgyc1NyTmJ1UllyT0RiT2NHdU1w?=
 =?utf-8?B?dUlvQ0RFcDJ3SHVRRFpGMmdUaGlJTG1FQ1FKaWFtS1JhUmhHM0RZZGRrQ3Ri?=
 =?utf-8?B?YjlzaytaRHAzL0laTDFSTUtwQUcrK25KYWpQaGZqWFZtak5UNkJvVmtjNk92?=
 =?utf-8?B?S2RxcVhneWViSHpuRElxVzRFM3VwQlFJZllYRE85T1BLbXk0aUppVkFwb0N1?=
 =?utf-8?B?TEh5cDV2QkJYVU9jem80dkdNVmNUMnYrOXRXenVGaFJ3T3EyQjNsQ3pwY2w4?=
 =?utf-8?B?T2I0U0xDakRjampYQ00vSXV6eUJCV3huSUFkRVBiZTMxTE11blg1ZzhmazFI?=
 =?utf-8?B?a1l4WFMyNGxLZVJZamZVcjBBWXdlS082c2VsSVRGcURJejg3UTJLdUtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0Y1TG93YlljNlFuaUorVG44OFNVS0l5TjFtTkVRUDFUdEdTOEE5MVVJTy84?=
 =?utf-8?B?VGRLa2g0NW84L1dEdmJpQld0Mk5RR3BHQlJERHB5WmxGTkVwN1NmNjdWRGdL?=
 =?utf-8?B?eDFyWlowTEdBUW5DRys1dUpaaDRJOU1iQ2FVajZSY0FENnovcVRaTnNBczE2?=
 =?utf-8?B?M3VtUDh1VW1pbWtndW5jYzcxWlNEMkMycTZRSjU4MHowNnUvak83ZlovbGVM?=
 =?utf-8?B?UzErTGQ4RXJKNCtka04xMFcrNGRiZEVWZWR3dmx4ODd4M3RBR0N4WEtYTVFK?=
 =?utf-8?B?Z2h4ck9pcjFFdk4rb3d0WlRsM2lpU2FYbmxid2p3L1RpYWdTZWNkMG9FdDFi?=
 =?utf-8?B?NGkxMU9yR01jSnlwanNOQVl5TkxnWXBlY0o5TEVSSkl0UnNWVnBObUxSZ3VU?=
 =?utf-8?B?KzVWSE50MjdBTzhRcWRadmhqUHRFRmxkazg0bmtCNm1WMWUvOVRrVm03STY0?=
 =?utf-8?B?R0VxeUFHcjkxR1luNCtkZ2JObXhJTGloa25KSHN4M2Z2d3VOdEJQRlJxUUhk?=
 =?utf-8?B?SklVQlZLYmlHU0l5QlY3UW9qUXE1c1BSN2ZqL1JvZHhCTG1ha2QxdG1VdnlC?=
 =?utf-8?B?ekQwZmhtajJaYXVkQzlQakxlV1hPcFBwL1pVdWdhUW1weVJ1b3o4cUtrek5v?=
 =?utf-8?B?Z0x6NjcrNXFoV2R4RGRhUkZFV2pKTkpyTHBLYm9sNGdDOUhvdmZ1YzVadWFx?=
 =?utf-8?B?Rm5FUkJyZTFnekRLWlVEWWMwNkdicmFic2VOd0ptV2ZRbW91ZlF6U282RzNv?=
 =?utf-8?B?ZTBEUW5wSmk2cHJRQ2taNEZLWUFzZmRvOHlNeFV6MUh5enFDak9RSkRsS0Mx?=
 =?utf-8?B?UW5sZlpyTTE0bTBPS3grN1QxYU82UzJ4MERTY2UrN2JwWTdJaTRRRVJJZW41?=
 =?utf-8?B?dVFXR0hmMFNOM29QWmNGYXUvNXJpNlpYVjQ3MGdLdWdZODNyd2drTWVTK01o?=
 =?utf-8?B?MktkdUk4b0s5d3FhTkdpS1hrTUQ1WHdZbHhCNThzdGx2OEhYMzJYVlIwMnFj?=
 =?utf-8?B?cGNrZ25FMldwUnBmbUcyZnBFRVgyeHlpS3JFbTh1RnpobC9rQjV0Y2FVQjI2?=
 =?utf-8?B?TytSVVNKU25vdkY5cHF6VmU3MFJBRkNKU2VFL2lvQ2dBRngxT1pLUzBDUEYw?=
 =?utf-8?B?dFI5OWxrMVFPYi9EejhGRXNUOEVtU0tCUTVnTVNubmFodGRKa2o4d21GL2wv?=
 =?utf-8?B?eVh5L0UxOUpqZHBrbHFjUzZIN2EvbHhSdGRnTDIyYTVSeFpsVHBHdkJvYUZE?=
 =?utf-8?B?TGtNWWRKdFl5R3N1VjFpcWFvcnNmdkFBTGtwVHNXUFpLZFRXYUx0MzRKQUFy?=
 =?utf-8?B?bUV2Szd0QTF2aUNrUUdvcDJ3RCt0cGV1OHU1anZqR1VwK1FzTXlUeTBzdTJN?=
 =?utf-8?B?bDYxNEJiMmJNSVhTRlpCY3p6aVY1WktRakpCUUNhRlJFa2hMU29wNDA2LzRH?=
 =?utf-8?B?UmQ4dmluVER6QXJmT09hMGdjNHlPWDRZTkYrVXVUV2FsREpXaTV3R0V1eWpT?=
 =?utf-8?B?NFRTT2JDdFRmUDFoZzExZTBkd2FOZUVkSGxnN1hrbEtnRS9zSWppS0VIZUF5?=
 =?utf-8?B?ZkxRdjdFck94RVhzQ1dvNlRTOWZTK3czcjl5dXZ2Vmp0emkzNmIxN0tVQkxq?=
 =?utf-8?B?UFFKUkJKMkkwaEZRNDMrM0lmem5PWE5jbWxOWkRwc01vY3kwdnNLNUJKSFRS?=
 =?utf-8?B?TTZscG94OTBSallrMzNycW5Xd2QvUnRvMXQvL1BXTWJSalVuQUdwMng3cUo5?=
 =?utf-8?B?amFUMlpBYkV5Qk1Dblc1ZzZCWCt3RnA0NGhjK0N1SlJVT0w2TCtkZC9VNS9Y?=
 =?utf-8?B?RXgzMEtwQUdJMDZ6QWw0MTAzd0xvOU1qazJodlNTSCtiK3J5Y1hOR0FsTVQ1?=
 =?utf-8?B?N2syMytFcngvMmFPZjVBLytQaldUYTF4NXBKRjQ1VHdkVitKV0RpeGVtQUVD?=
 =?utf-8?B?ZWtjTG5Qa3BTL0l2SlFWNnNMSHBPelN0YlVTd3dSQTBGbDl6Y2U3RzFLendW?=
 =?utf-8?B?ZFBTR2J4ZHdoYnozVnlEQXNVYW40VFQxaWVBK2tZWEorN1MwaWVZdVhXWHpG?=
 =?utf-8?B?YnBQYmZDcGRjczViQjJYdVJtTzQrNml2QnN3cTRnc2MzZytDalRXRjI2M2xl?=
 =?utf-8?B?MzNoZ1JTT1FuYXd1MWJoclZYZzJ4bS84MXNqWEd3THVJQnZ0UXo3Y1hZVkVY?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7bae0e-f1fb-4aed-c093-08dc7578aaa0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 07:20:30.1880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHp9QTqCak5GuQb4qmnyDDSDRoTd0NJzyz8/UAGMBQk3BFzC10T/7km8tNoCZf+YYUks6UOMi4k+YV/yVO91nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com

On 5/6/2024 5:41 PM, Yang, Weijiang wrote:
> On 5/2/2024 7:34 AM, Sean Christopherson wrote:
>> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>>> @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
>>>           F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>>>           F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>>>           F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>>> -        F(SGX_LC) | F(BUS_LOCK_DETECT)
>>> +        F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>>>       );
>>>       /* Set LA57 based on hardware capability. */
>>>       if (cpuid_ecx(7) & F(LA57))
>>> @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
>>>           F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>>>           F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>>>           F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>>> -        F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>>> +        F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
>>> +        F(IBT)
>>>       );
>> ...
>>
>>> @@ -7977,6 +7993,18 @@ static __init void vmx_set_cpu_caps(void)
>>>         if (cpu_has_vmx_waitpkg())
>>>           kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>>> +
>>> +    /*
>>> +     * Disable CET if unrestricted_guest is unsupported as KVM doesn't
>>> +     * enforce CET HW behaviors in emulator. On platforms with
>>> +     * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
>>> +     * fails, so disable CET in this case too.
>>> +     */
>>> +    if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>>> +        !cpu_has_vmx_basic_no_hw_errcode()) {
>>> +        kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>>> +        kvm_cpu_cap_clear(X86_FEATURE_IBT);
>>> +    }
>> Oh!  Almost missed it.  This patch should explicitly kvm_cpu_cap_clear()
>> X86_FEATURE_SHSTK and X86_FEATURE_IBT.  We *know* there are upcoming AMD CPUs
>> that support at least SHSTK, so enumerating support for common code would yield
>> a version of KVM that incorrectly advertises support for SHSTK.
>>
>> I hope to land both Intel and AMD virtualization in the same kernel release, but
>> there are no guarantees that will happen.  And explicitly clearing both SHSTK and
>> IBT would guard against IBT showing up in some future AMD CPU in advance of KVM
>> gaining full support.
>
> Let me be clear on this, you want me to disable SHSTK/IBT with kvm_cpu_cap_clear() unconditionally
> for now in this patch, and wait until both AMD's SVM patches and this series are ready for guest CET,
> then remove the disabling code in this patch for final merge, am I right?
Hi, Sean,
I haven't got your reply on above question. Would like to get your confirmation.
Thanks!

>
>


