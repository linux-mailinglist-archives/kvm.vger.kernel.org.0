Return-Path: <kvm+bounces-17817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37EB8CA56E
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4275AB2215E
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190438C13;
	Tue, 21 May 2024 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nKaR5LPS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07CA441F;
	Tue, 21 May 2024 00:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716252182; cv=fail; b=i1TyjPd1LUgvrxWuDhpC8e0zaFyLE6krxsSSQKPVSYCpAHibbQ3sA8HhrmWUPOYFiJx1BCldoIQp2d8DVqIkFG3ncfDLIei3AYhskRRMkbVBE+wfRA1IAHPyRd6KKZUrsnrWDlVHiHUV/0GJPZpbVQj/ZA1CT0nEjk5tuAN5Ls8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716252182; c=relaxed/simple;
	bh=951G3tOwIvNo5S3Nh8P8BAmGAiGigcudwgL+q0btc4M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kiujPT82lFuPvsmbZdchLH125Oen0Rvf+PIj3/1ziOA7ZA73CMbOqJyYfqDHCk0iiaAIS5nvqR81ZSmizjiQQDgpdO5fW9QR86Dds9BGhhIkzzN8a6TR0sbXa+C4+GqAE6yNMNWs8//UP1AM1XnmSXSTJkgu58IUwE9H+Hja5Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nKaR5LPS; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716252180; x=1747788180;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=951G3tOwIvNo5S3Nh8P8BAmGAiGigcudwgL+q0btc4M=;
  b=nKaR5LPSFwPJg0v6AH/MUN5I86SfxR8+bS9DD3B5yPmdHJaJnOILEqCP
   2ZdkhpRJU3WELb/WblqECFiPHT//hXUPfaIJhw8fs9p+3P9UdHdpsA0NI
   NInR8Y1klC0htyLcMUSSZkfyC4eQzgLvsTD4JgkHzV2bWs0VnjV4x3Qlp
   zshqM2fx457P+HHLF1362eqOB8A9lmxPB6Fkbs9oIsFNlwtN1ipKlNv+h
   jcBUYW66si6FelA++VNh+ASkq+Apv7gvyKkYweh+I51ywB6asDdpiyE0W
   q4I8r5obr4bxbMaCW70BEUS/8LF6ArFzEYyXnVk8pRWRcJEYKq5doMcWC
   g==;
X-CSE-ConnectionGUID: D0uO/vT8QMicPCedHDxrjg==
X-CSE-MsgGUID: r4awM1qgQmGfJFHftlWxDA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="16243649"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="16243649"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 17:42:59 -0700
X-CSE-ConnectionGUID: HTh7KKVLSZ+aG3GgCiXjQQ==
X-CSE-MsgGUID: Xsf9s0leTHCdy4Q18xUGxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="55965979"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 17:42:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 17:42:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 17:42:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 17:42:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 17:42:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkDll2UTZbFWPwZQCqq1YOGqzp0yiMYWut0lntunG8ZTI7PU0LWrFdeqwGSKm7nCZlitu6yKVW7H0rhkkvgsC9chJdSuhu1MtX74b3BmgaLlpsQNavHftIMYgYhydplLRyVQFlln8bTJEpFkBBDxfryft7WXdBXklOh63q3nLzEMLfUjfnmb4BtUvfWuLkwjlSX4Bs7Ci+UZezObX91YTuUMTAKm/73vwDrZAEPh2zcuXBkKoOYBoXIPntHEYP3nBuj9CTvcl0R+WFEgXDFm0bhzy3FFRCZMQx4Z3sGqv1cNId7b5BDocXL2AnAU2IOw8Mzuo1N2lOK5DBx5v9JWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aesrAnVuUm1dHXCEqtOq/61SaKXhart7o7GezMQWNs=;
 b=FFjY3lFjg/FjVXvs6nta3JcYDzFdW+QS9dOuVOejuZn3zmD2tB4EaJfgl3tUDtZmqRF6htPIIrWU0//VVTpahs+ESq7EtOtCs41VzDqBm97oR5xKTZJo2m4F48or/FFyKGgBQyTVj+ih7EKKInfnxUWVRiwSzS6HyxFiadjnqWwLHc8672hEpYoHkloG8JHi/vaRJW9Nw4/pMIvIRjEIh5OzgD5V4AzGZKonRXQBres/GB4K1Y0bmvZogsECj5xelchBwU4JCpxESKP1XYOZ5ctZALYkl268fn60+Ggjyhr0uwZVFufQOKl/jxonTes/gmSC/26I921E1sF0eV5B4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7196.namprd11.prod.outlook.com (2603:10b6:930:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 00:42:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Tue, 21 May 2024
 00:42:56 +0000
Message-ID: <3e7413b5-482a-4243-be6c-21a0ee232cc4@intel.com>
Date: Tue, 21 May 2024 12:42:49 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240518000430.1118488-1-seanjc@google.com>
 <20240518000430.1118488-3-seanjc@google.com>
 <78b3a0ef-54dc-4f49-863e-fe8288a980a7@intel.com>
 <ZkvbUNGEZwUHgHV9@google.com>
 <b1def408-f6e8-4ab5-ac7a-52f11f490337@intel.com>
 <ZkvpDkOTW8SwrO5g@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkvpDkOTW8SwrO5g@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0093.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::34) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 214a9ae7-de33-43d3-28d4-08dc792ef44f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZEZhM0VURUZVY0xrWVlWVmpnTjEwb0FLZXNEa1RXdGtCMlkyMS9yN2lHU0tk?=
 =?utf-8?B?Q3dUb3FmQWhLU3NLMEJyMWhOU3dsOWNheDZHUHA0VlVzdm5LMVEzVm54RW5O?=
 =?utf-8?B?eE1sd0JxOVYrQ2hNVmFnMFRhSXlrYmdXTlZ6N0haeTMvWlBOeE9tb2I5Z25Q?=
 =?utf-8?B?VG9zdDN0WmFNT2sxaElxWGQ3TlhHL2V6YkEwM0xIZEtkOFNXV0loWnNqeU5M?=
 =?utf-8?B?MHBqdkVNcEdkbUxoMGhVQkxKUVNobmFCWlZSTFVlSmVTeDJ1NWhlQnhQdHI5?=
 =?utf-8?B?V3k0ZjVyaFRaREFqbVh2SHVhVjNMZEF3RVhmaHZ0Y3hIQnUzbW1mSGt1TkRX?=
 =?utf-8?B?SFkyUUkySlFjRlUrQUl0WHErazN0V1dwbWhRMWZBd0lXZ3djRFV5Q3hVeEFo?=
 =?utf-8?B?azJENW9BN0dLKzFTLytOam9ja2pjMVlZeGZIOEg5QjkzNzQ1cS90SHZPeGFG?=
 =?utf-8?B?QnFmNmRFdkdCZThmTTJkK3UwVktwRy8rZnpvbWNGVlQ0eUpjSW9yY0dVSGdo?=
 =?utf-8?B?SHF0TWs5NlRZUXAxcUxnWExHSDJmZEhOOFZwcTI5MTRVc0I4N0U4SkhLUzJR?=
 =?utf-8?B?a0RlRmdQUXZRTGozVExQMnZhUnJqUldJQVNFc3dXb01lK09DWmNTc0RaNVR3?=
 =?utf-8?B?eDNyQy9MVDAzbWhzeW5xZ05BTzhBUmE0ZDgrUE12N2VJK3lGTGFmdXNrN0R5?=
 =?utf-8?B?ckZHRW9Pem5MQWs1UXdMRFZjSC90L2owZ3p0WDFoYmwzMjFIY1l6c1lrZUNX?=
 =?utf-8?B?SmI3UHpxVStEOHplcE9hS0pBY2JyWkxrQjAvd3pFUVdMVis0UCt1VGhYZGNj?=
 =?utf-8?B?eGtRWFBLOWI0ZmJvUEliekhkeC8vbllCU29mNDArRlpaajkvdGhtdWNmeEoz?=
 =?utf-8?B?VE9SUXZjczVvWTlEeVNuOEc5ZGV6cDhqcWJjQlBub0w3Y2NYNVBLY1dVZkFN?=
 =?utf-8?B?ZmJvYWNYQjhwYmsyVkVBWWN1MlFrTzZ2UVVVNFNGQ0JqeTdnR1gzd0owZFFP?=
 =?utf-8?B?dm9oWDZFbVRSaHJ3bmpYMjZIaURqSzcxZzZXY25NdVVpUm5lU0JKUnNHNzFG?=
 =?utf-8?B?bzBaZi9RT0tWOHBOeTAyQUVqUm9ubnk1SlVxMFp3WXAyOGpPM29ydEFlY1hI?=
 =?utf-8?B?NGlFNXgzYjJjb3BKTnZsbVJWa1VyeUZDTFhJck5LbTBjdW0wT0hZR0U2Ykha?=
 =?utf-8?B?NkE4UTBRVUdTZFZWUVg1WExFMXUxRjlkZkhrSVZJaHBrRUNUZTFnZ0N3M3ZB?=
 =?utf-8?B?aE4wd1JvTWpPN1ZBTzI5N09ZNjJ0QWMzMDZTbW52ZEhIODJ5dkJoM1B4eEsr?=
 =?utf-8?B?VUpXa1M5MzJCclNnV3o0a2o4dlpPRndWZzA1bDM5bUhyMzF3Vkc2aTZxZWJS?=
 =?utf-8?B?WlNXVkIycVhkWHZSR3FyZCtRN1E3ZnFDVENYWGpjTWlIWm1qSjNxalFWa2tE?=
 =?utf-8?B?YkdsNEgydmg1RzlFZzhTT1l3SUkrT0pvRkVpWHZnandpanFGSkI4cSthQUxB?=
 =?utf-8?B?K0ltNFEvNXQrcy9NdkFMTTRvK3h6QzhUMmxuTXhwOE9GQ3FpWXJvNlV4ODFz?=
 =?utf-8?B?enpvSUZuNmpVN3VJdlkyWktsWlpzTlVFQUtBT3BSMS9nanBiTU1JSmRqc3dx?=
 =?utf-8?B?SVJOS1BVekNWU1paV1Z3ZWo2akk3NEY0TFpKdGVGdkV3OUh5TFJ1Q1JXL3J1?=
 =?utf-8?B?TDZlVEFsR2dvWDE1eUNNSUQ2MXZEQmRGaUxsSyt4ZXBwZ3gxTUJhaUNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME81YlZxYlc3aFl2cmdQaDA4Ry9NYjR6RmNYT1dyT1NYYWViWkF5TmRKRjZE?=
 =?utf-8?B?Sk1zcFBMK0plY0NDTzN5TVR0QkVQd2MrcEsyR0NUdEgvaEpJTithQnVzenFK?=
 =?utf-8?B?Sk03ZEVjT3l5YmVueFh2Tzhoa3VDU0JJU2crU0Y0ak9TM0Jnd3oxVnlhQVhL?=
 =?utf-8?B?WWJ0VlRta2trYXRnbHBQWElqTW0rN2NBamZTYUhibjFMQ1dJZE52Y3JnR3Ax?=
 =?utf-8?B?dXptcitCTXNvR2UyV21uK3pjWThWR0tqbTl0V1FWYTJITXNHNWFNSFBjZURp?=
 =?utf-8?B?V3dDaVZsejhVRlNGSjdwa2FHSWN4WmpMbzJkeDBvYzFQc3JhaGJDUEdyMmZS?=
 =?utf-8?B?T2hQdm83ZVJqYlI5L3hDUzk5WFB2LzRKOUxZMlRNYjVhQ0FPbEN1R3BuOUFv?=
 =?utf-8?B?bm41b05JRm9Qb1F6TmpnYkNUbzI5OWdCazFUN0FOOUdiYUNXTEhFR1dlM0NL?=
 =?utf-8?B?bkJGcURCUUk4NDRpZ2pEdHVIVHFONVl1MVZVS3lVcTY2cGY1N1lNdUhiSU0x?=
 =?utf-8?B?NEdCK1FCRDJHOTYxU2JSZWt1ejB2aXhGbEcwNmNrQ0dETDlxMlhGRXNTWDRQ?=
 =?utf-8?B?WXJjeVFwVW5jelBMaGtvdVBLRVpjbzNnOW5lSzlhUVdUUFhrQmFra0d4SkZB?=
 =?utf-8?B?RVdXNVY4c2xxamdnRzhmYnlXdUV3SDJjMlpaNmtHbGJiQnpwWFhETXZPRzZl?=
 =?utf-8?B?QzIzUTBPeVRJMlVoSUY1SlB6M3h5alp6bzVleE84ZzNScUprL25taEZzNkVa?=
 =?utf-8?B?YXN1bENPT1dRNXdBYk9JNEhkZkwxdHZTZG1Ia2Rqa2dzK01rblVsV0hIU21Q?=
 =?utf-8?B?WTg1ZFdUS1Z4Uk1tZmdock5UM1BWTk40ZW44ellsSUU5cGRBT0ExMHkwNUk2?=
 =?utf-8?B?YTR0TjUvUHdBTVc2MWlNVnhFNFpqU3RNZlZPOU9LRDBQNW11ZXpsRGoyU1Z5?=
 =?utf-8?B?Vk1rS2Fpd1JBTTRrVXBoNitVL3FDa1ZrRjI4T3JnSjZDK28wVkpQVzFOQ2h5?=
 =?utf-8?B?akZweHMzQTd2T05EdVlzVzlNUm1GSXVKY2JPaXYxQkRRWVZSQXNPRmpKNEoz?=
 =?utf-8?B?MnZRdnl1U29xcDIyM2huOWtUa2RSOW5rZnYrS1ZmQ1RET3FQblhlazhrYUEv?=
 =?utf-8?B?MytvQjlmTERLL2s5T2RXOWdYUUZmS1Nsb1pNVVRpY2pSa3pod2dOSnA5VFVW?=
 =?utf-8?B?YmtVeWU1WlZRK0lDTk9iOTNXbllQREkxczNkenZTTGRTSEFCRnN1YnkxbWI3?=
 =?utf-8?B?N2FPMFE1ak5wR3ZhY0pEZUxDaU5jSnVEVUxjUmZKMEV5WTg5QmIvdXMzQlJk?=
 =?utf-8?B?MHFOR2FUb0lqUlowU3ZjeWd6ODJtbGRuSDBOamVGZE4yeGNZVU5SSTBOVUtH?=
 =?utf-8?B?NmVtMjV5T2d3YVdQc2haSHVmVkdrNVFkZ3hTdWVtRnpKb1R6QVFnell2OHJ2?=
 =?utf-8?B?SnJuajRZNFlPQnBwR0Vkamo2eDRZbmdEOWtKSjhnbUFUcU55K2Fxd2lxNjFS?=
 =?utf-8?B?YjlDUExnaDdvbTZ5UU9FNnZlZXFETll0aHNVc2E5NC9RQ0pzUEQ5dTRBVCs1?=
 =?utf-8?B?aURUVFN1S2JpazBnVWhpUlBXZDJHc2lZdHlCUUpmdkcxWjFBNlBGR3JZQVUw?=
 =?utf-8?B?R0hmVU9xY3FkcXVXVEg3RmV5amJaaVlsdXVmbm1WL3prbkpaVE9kQm5jcXhT?=
 =?utf-8?B?cG56a3lwK2JDNjlSMFhzeDcwU0k0cGQ4VnBxZFpMOWxPRGVnd3UwZCtDNngx?=
 =?utf-8?B?MXdjVlBDQjduMlFtNkhFUUR2cFIxWTBPaGh4T1hzZGxNVWpmSkZZLzVvQSsy?=
 =?utf-8?B?Vlc3ZjFiRWVyekUzaStNc3Q0S0d5VEhoZGRaeFlaa3ZNNE1jMEhBdnM2ZGNG?=
 =?utf-8?B?V0MxUkEyR0NJc0Qrc3ZINmtMSGtjeVZYcG5FamlRczRUM1JHaXlJK3NSbnFJ?=
 =?utf-8?B?TXJXQjZ2MVVJUnRETkNmMmhNdDB3cWx4MVdJYTJ5Nkx1d0orMk9sb1NDWERy?=
 =?utf-8?B?R3NlVHZ4LzlmSjlNTzFRTnJ6eFNoZkNYenFvRW5HTUtEU24yVmtjWW5INThs?=
 =?utf-8?B?N0t3Qjg3b2RWVC94WEU0WldNWXp2MCtMMGtqWlZGVG1DNGlkNDlPakN4SEUw?=
 =?utf-8?Q?RP+pnblYwYgRxPdzuohQYH3vh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 214a9ae7-de33-43d3-28d4-08dc792ef44f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 00:42:55.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JX4QZjxao0+nNGfIQzQngZ7vdTGzG7fPDHf+zxEyOFNoNFclU4fQISHtmm9moJq0khkTg2xJztmo5j2kKI6n7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7196
X-OriginatorOrg: intel.com



On 21/05/2024 12:21 pm, Sean Christopherson wrote:
> On Tue, May 21, 2024, Kai Huang wrote:
>> On 21/05/2024 11:22 am, Sean Christopherson wrote:
>>> On Tue, May 21, 2024, Kai Huang wrote:
>>>> On 18/05/2024 12:04 pm, Sean Christopherson wrote:
>>>>> Point vmcs02.VE_INFORMATION_ADDRESS at the vCPU's #VE info page when
>>>>> initializing vmcs02, otherwise KVM will run L2 with EPT Violation #VE
>>>>> enabled and a VE info address pointing at pfn 0.
>>>>
>>>> How about we just clear EPT_VIOLATION_VE bit in 2nd_exec_control
>>>> unconditionally for vmcs02?
>>>
>>> Because then KVM wouldn't get any EPT Violation #VE coverage for L2, and as
>>> evidence by the KVM-Unit-Test failure, running L2 with EPT Violation #VEs enabled
>>> provides unique coverage.  Doing so definitely provides coverage beyond what is
>>> strictly needed for TDX, but it's just as easy to set the VE info page in vmcs02
>>> as it is so clear EPT_VIOLATION_VE, so why not.
>>>
>>>> Your next patch says:
>>>>
>>>> "
>>>> Always handle #VEs, e.g. due to prove EPT Violation #VE failures, in L0,
>>>> as KVM does not expose any #VE capabilities to L1, i.e. any and all #VEs
>>>> are KVM's responsibility.
>>>> "
>>>
>>> I don't see how that's relevant to whether or not KVM enables EPT Violation #VEs
>>> while L2 is running.  That patch simply routes all #VEs to L0, it doesn't affect
>>> whether or not it's safe to enable EPT Violation #VEs for L2.
>>
>> My logic is, if #VE exit cannot possibly happen for L2, then we don't need
>> to deal whether to route #VE exits to L1. :-)
>>
>> Well, actually I think conceptually, it kinda makes sense to route #VE exits
>> to L1:
>>
>> L1 should never enable #VE related bits so L1 is certainly not expecting to
> 
> Not "should never", "can never".  If L1 attempts to enable EPT_VIOLATION_VE, then
> VM-Enter will VM-Fail.
> 
>> see #VE from L2.  But how to act should be depending on L1's logic? E.g., it
>> can choose to ignore, or just kill the L2 etc?
> 
> No.  Architecturally, from L1's perspective, a #VE VM-Exit _cannot_ occur in L2.
> L1 can inject a #VE into L2, but a #VE cannot be generated by the CPU and thus
> cannot cause a VM-Exit.

OK.  The point is not to argue about L1 how to handle, but whether we 
should inject to L1 -- L1 can do whatever it believes legal/sane.

But I understand the purpose is to test/validate, so it's fine for L0 to 
handle, and by handle it eventually means we want to just dump that #VE 
exit.

But now L0 always handles #VE exits from L2, and AFAICT L0 will just 
kill the L1, until the patch:

	KVM: VMX: Don't kill the VM on an unexpected #VE

lands.

So looks that patch at least should be done first.  Otherwise it doesn't 
make a lot sense to kill L1 for #VE exits from L2.

> 
>> Unconditionally disable #VE in vmcs02 can avoid such issue because it's just
>> not possible for L2 to have the #VE exit.
> 
> Sure, but by that argument we could just avoid all nested VMX issues by never
> enabling anything for L2.
> 
> If there's an argument to be made for disabling EPT_VIOLATION_VE in vmcs02, it's
> that the potential maintenance cost of keeping nEPT, nVMX, and the shadow MMU
> healthy outweighs the benefits.  I.e. we don't have a use case for enabling
> EPT_VIOLATION_VE while L2 is running, so why validate it?

Yeah.  I am not sure the purpose of validating #VE exits from L2.

> 
> If whatever bug the KUT EPT found ends up being a KVM bug that specifically only
> affects nVMX, then it'd be worth revisiting whether or not it's worth enabling
> EPT_VIOLATION_VE in vmcs02.  But that's a rather big "if" at this point.

OK.

