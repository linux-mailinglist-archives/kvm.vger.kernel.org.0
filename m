Return-Path: <kvm+bounces-73207-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mOtWDNiAq2mwdgEAu9opvQ
	(envelope-from <kvm+bounces-73207-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:35:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9C3229630
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C38673106B69
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC3F2F068C;
	Sat,  7 Mar 2026 01:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eqzDVQ8R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FCE283FDC;
	Sat,  7 Mar 2026 01:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847223; cv=fail; b=kgXFyjiWEXBYF2lEugvvmKdx3QYi9nzapL0hByIkAGPuf1B6ztKGfVkIwAQ8ccmL/V87bkgvcR84SQcjyxoa/nmcs208i/UUtRV4Rb/sUwWVHFWrCa9p1nM3lOjgdgBS/EPtGQSzI+YEBYgFKWft90QxU/HhCt5Ib0GmqBXaul0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847223; c=relaxed/simple;
	bh=KmxNGb8dfwX48qQprQKbmUalAemjhtycydIQ1aDl1wM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KkQKkqVU5mL2U0xj3e9GJj0n0yjmNwF6/FUJSpkO/CiUW88MqQGQ5KrWleHuoy650itEedoWAcHg3xYMnB263+WK6IJgLYmQYzrCba7Zx92yI382rYcCnLHVcZZkcj95A0me7pvT97QVmAKTvNseqOA260adGgzIRe/siBDKK6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eqzDVQ8R; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772847222; x=1804383222;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KmxNGb8dfwX48qQprQKbmUalAemjhtycydIQ1aDl1wM=;
  b=eqzDVQ8RYozLq+5AacmMhngH6JVjTP7YnlL26Cowto7ie6bBHT+wVxom
   3QDBAD68wQNL8UGjW3JDcdVtOOE5+WLim7IRT8ZPzrBDElMP0dfbdJwcP
   3WpAiiETO9wVk705ncDdLA+bg0lc6kXAnhxzZ60s1qu9GZsSD9DA0gzBW
   Z/y5GdH9np19VI3xcw3s/oYGKGDmrF6CcTQBkrVhddq1IBDviTONzCGcv
   hKCsikb69PsNTLSbSUI43kWm6LrPukm3qz22mFUWoqiPkQxtjF50A0Jpl
   /u/zy0tXl8tT8M236gdrf8bZ9l9xQJEkUGiqbFlUbfEXrGPSMu6zfW73F
   g==;
X-CSE-ConnectionGUID: PFaemgaxT/GSlDhps9Mzig==
X-CSE-MsgGUID: c9/NYjUOR4ai3qhg1wnAIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="91534550"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="91534550"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:33:41 -0800
X-CSE-ConnectionGUID: Mcg5ApWGQUq7Q7TFaCwkAQ==
X-CSE-MsgGUID: GxbTZqFzS+SpYZp0u+/m0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="218397181"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:33:41 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:33:40 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 17:33:40 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.57) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:33:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uDrkCX4GS6A2Q3t67u32S02LMey4YOvejJPLYXlCduOey3WeG8DM9w3bzjmXbA8NqOffiN/1fy/w2HXuPe3k7qOcttLBC/AgqNPOD7xAWPY72i8hqjAmqwasKC+wmSbFhII7127TWO+2xRNtjlINMimgMB8kkunQ8fQ6KWSQQhP2aU+dupXQMQzt8bFTT86da1AxlWxk77onfm/Y2K7qAFPBoTnIuMDtupLrwXrOHuq0Ws469Clvz1R7C6+q23UKRaKHqxFAD5u+D4kk8S21m/CcJVBsyqCNs9+I6zsY9IexI17ere6SHlEG9FQQoND46zZVSBum7gblPEL6zXAX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNw++qUrxWhzUiz5t6j+K4wQwh2Q+wgtaz5xfujxRRc=;
 b=ebVuy+tlyBGnMXGKd956gQ6ufcvqRFGMxAEsaazHS70V3JNlswLRfBp+BpefARayZFcaPub+O9pPPPwwuJbuJ0X+5UqrAOoAATjgB5luaxTnftcdEk9udeoOQXLysGodEIC+KFnzyRW5ONg2CrClfJ/6I8BDLUK69ltDbflfTjvfk5ua49vXhQh9DuN4jXRQ3LXtTzpKI90cUyLdyEX7phXriy679eJCQkyArAv3VuY8ECXpOW5l35RpVK56Fm2/FdJs8qpIPY17oH/WEe4XYAYYnAykEY+dVi6kixdx7Ge1o4rq4rc5vLGzlgvh/7C3e3hAKNlvULu0bD5g1HRWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.5; Sat, 7 Mar 2026 01:33:38 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 01:33:38 +0000
Message-ID: <ac83eef2-e019-44d1-8ac1-078bbe7a4fd3@intel.com>
Date: Fri, 6 Mar 2026 17:33:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/16] KVM: VMX: Introduce unified instruction info
 structure
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-5-chang.seok.bae@intel.com>
 <aakEsXJgO-3m2xca@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aakEsXJgO-3m2xca@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::22) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 281f0336-3275-4157-73f9-08de7be98e4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: rkMHnNaGlHVvJLYz5P/Lh5b/p0ZpRamR3NxvHufU2eIYMsAxlGmSUmkimBXrdGjigaIRuRMIWxXf2FNDU6dl9dlsCQk+GikfgcfiJlwzUuqA9l5DWr2ERRbUfW6WSZi79TrN437o2CyVz9JTNhc/+SPQbjjxF2FU74JO6kOd54dMQJE2bLdjvY1RCjblZ7WNdTQQhNuKF0Ttjs22pZKgEomrqbarYyR/alPZkG7lYsI+m7PhND+vEyco0t+B3eP7j0sX5no710L8LoytN/JZHO66wOqZ8m6HJQeMmZagAkkZzhZKkfaZB8EtTccAE/1RlokPUH+cujAkM5lG/Qf9iec5FK6r+TvmJmP44JBh7BKi6XjnDFq6ZCww0L0a3/7SKdB0aJxpGqLhbk+nbc7hCdOE4dcRwwASHJXJ+stEgGHMAi2ZjyEEnUtQBRyjUxXJMo3La8Eu+i+Awa6HJ3JtopXzMc8NiP4eMyvHqPxaT4bZmoncyOc6zvwu4pqVwWvSlUyFQvlKiIYeGe5Q1TsxB8+CmLbhuiB/+hzXNDzCkyndKAa5tU06sUaq9FO2Xi4xhlnoB03gsaKgiMjnSiElDdoXJosXZFs3+6xIn0u+ZVIQ+TkQolbbOWoRi1WL9eg26DBrKHKKh3yrVOpYD+RV01wE0sCJhfa4cQHAi1pHkZwfkRncbJzYr+5B2fPXFpzahIs5FDmC+u6VqUMU3E4EFivo5y8HO6/MR7e0VAeiiZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3oxaEdLMXgyTkFnTFcrVVBORGtDMFZKaVRFVm94U1plUWkwQzRWSTJGU0ZQ?=
 =?utf-8?B?WHlaclFzSDZ6ZDFxQ2w1Z1pCY3FmR3NpT3ZUQURuZW1SZEJmQzBESFR3K3RR?=
 =?utf-8?B?TjdUOEp0SUUvVlJNSEd1aHZrMDdlZ01TczQ0ZjduVDNTUEZZSVNPN0xBK2Fp?=
 =?utf-8?B?ajVrM0NGY1NHY1BiS3BpRWhTZW5HTEhnNU5WdXY5cXIzVlduZWdVLzZzVzdR?=
 =?utf-8?B?a1VwV0VVTnl5cGZrWnFHK0IvR2NPVDBER1d4QUpXaGpDcUdIaWgvSVk3aHB1?=
 =?utf-8?B?KzFhS1BhbUhZaVVodHhQeEpNcklSQlBydStqbmNIYndQYlNYV1JvMEx5a0Z2?=
 =?utf-8?B?WTBFYWVlUUZocE1DVXVaMytmdjF5ZjgvQ21iWkpWMGNnSjdDenVQcWZFcHlX?=
 =?utf-8?B?amhXSnplRkx3MzNvdzZKWHllVVM3emJTQ3FHMCtkd1ZKWTYvelU5M1dURmFY?=
 =?utf-8?B?ZDhlTjVEYTc3VkQxTnM2UlJ1VDU0RHdtTk5jbjFRcWVLVVFFY3Y4bG1RUzIx?=
 =?utf-8?B?MUVaVWI3MVVVcUsrYk0xSHJTLzFyMTBiK2lDZW5SNDJmSEZNUFRRWWg3RnpX?=
 =?utf-8?B?dERHclNUKyt0OXZiRU16NTIxMCtHOGF5YUl2WmZMZ0ZGVHZYejBiSU1JeXBz?=
 =?utf-8?B?NTZwQ295ZTVJV1dhb2xPS1dxOTd2bUt2YzNOMWpiV0N3OGJUQXoyT0lSaWFk?=
 =?utf-8?B?ZEgyWldzRGVKclIvcitKcjBEVlAzVmVUUzRFK0tKV2Evbk50MVE5anFqVHd2?=
 =?utf-8?B?N0c5VWVuV09sY2tOM1RPMVBmUldPQlJzblR3NENiOWVIcThZTDI2VkNaSG1J?=
 =?utf-8?B?RWsycFFHYzdzQmQyVS96Qzh0Z0lrRGZWTGNORENna3ZPODl0K2o0dGR2ODB3?=
 =?utf-8?B?SHkyWEdtTnJZaSthTlN2aklSSEdtMHZNOTJLc2pmNHdrZG8vTXZlNjlLYm0z?=
 =?utf-8?B?NDdSNzJkNzhHaVNPeWdSdE8zRENMMEZOR2J3d2hsd1A2eEd6elViVlpqNzZQ?=
 =?utf-8?B?QU1LaE1OOFB3YkpsSWhtdjlzaTlpQUt6aXR4MGliTW5XMmlPbndKWGNIeWsy?=
 =?utf-8?B?cW1EMTJBSkxNTXFFSkdFaTgrcGFLVXhib3d4ZUJITlRsNk1yVDNxL0IyRngy?=
 =?utf-8?B?aE5vaVZHN2Q4bDZRZTJ6aW84TTZSK1ptSEtndDRaeXhIV2pOVnByVjRBTW5y?=
 =?utf-8?B?cTV2S1l2T1VKUDNOUDQzYVYyaDA1ckpKanRYdjVYYVBLdW04eDJJUUtSQXM3?=
 =?utf-8?B?cFUrekJBUkxiVnlSdENJb0VWMEh3Wkt3WkZsaVhSKzBzbkNPdngxVWtyUVIr?=
 =?utf-8?B?L3ZPcG8zY1RhS2pLdjdDUStOZHBpcVZRR3RxcFlVZUlPaWVLbXEybzYxcndv?=
 =?utf-8?B?bStxQ1Y1U2lzTVY2VFd2MEdweXpDSXBCWWdyUkZEcFh5Ni8yWHo4ZkRrN1Jz?=
 =?utf-8?B?Mktvd2R1YWQ2TXBrUDFwUkNHZUtqVlF5UTJFZkw0TXRCcHI2YkQ4M3Rqd2Iw?=
 =?utf-8?B?UnQ2VTJKZm13bVl1UjhEVHI0b2VyTEh1QWZpcld3MENERHhrMnZIdE4yZXpy?=
 =?utf-8?B?cFQyWHdiZFR4L1lZUGx3RWZWL05ZekVWUFN1TlI1SVdjRkR1ZFB4ZjBVb0FV?=
 =?utf-8?B?NVJQWHdTSmdFR3JwdUhzdzNTZ1RLN3lOWkR5OUUzTDlLczljVUpORXNEYnIy?=
 =?utf-8?B?OXFNWEoybUIwV250RkRlUzV5dmxGbW9aZmE2QWFtdWhYMi9XZHpVTHgvaGNT?=
 =?utf-8?B?emtzNWllTGJicVpnR3JiOWEyQlBrRnJVaVd5NFlzSks3MDc4QWdTTkx4cFhU?=
 =?utf-8?B?SEhnUk9CNkhReVhoVnZKRFl0TWN4UkdxRHFVRG85QXRuaWZZOFF6b2NVWlQw?=
 =?utf-8?B?aDFNZ3RQUnA4eGxmcEtjN0ZkVkNrcktRZGJjbnpoT2xZdGJjVTY1VVlTSEJB?=
 =?utf-8?B?N1hxTDJJNmVnT3gxbnVGTXJJMzFwQWdPSGtsV3dJWURtWjRUV0cxaFRvcENR?=
 =?utf-8?B?eU9YL1hwdXF2ZjdYU2xTYU9kdWs3NlR3WlJGcmV2WStxS0hpR01ObGFLS1Za?=
 =?utf-8?B?WW9JaC9xTHN0L3VCTnptWFVMWC8ydGc3NzRkRFp2alhLYnpWbUp6THJvNjd3?=
 =?utf-8?B?YUE5c3N1aW9sZWU0cGpqNUNBb1hCVzRueVJXQmhvZ2tXQ04rZEl3WlpQak9P?=
 =?utf-8?B?Z0h5TWVtMDR1a2pqYzFBWmtRbURhOFp3ZmxSWTNzakIwUS9XNGJ1MFZNc1FL?=
 =?utf-8?B?Q1Y0SGN2SlhKNGszckZVcnpKRDBwdXc1ekJkcjFGRlBrcXA1ZG90Wmt4c2g4?=
 =?utf-8?B?UThqVE1XM0hpSGlaV0tmY1pzaHFGcVNEZEVnZTh2Rk5ZQTJ1ZlE0Zz09?=
X-Exchange-RoutingPolicyChecked: Bc800OAcDZT3rKsDdNQSU4IqybQnQDW2IeWALJ0qrBQ7w3TiQTJPHbGjGuOuXLK9YEbF2YOPTHdjkDwTuNtzjqCWUIGLR/+vNOHDpr5xkmqkuBqANr3LbKG7EYOz3JvAe+nnR5k+nPHUkv2KsefaTzXEMSvzOwtv8OyzXb6uxQDVTxOmzmYc8jrUQ8jiVjFVfUAY0TPLULf2IaNjvHPqR5ApskEdU48aiaPOIg/rcJtrknV7H/Pg+JM3VpdQoCTl231CQEhMKHlAOWvGY3/VXZlcFnJsyDQ19KVT2OxacKK3ZDRKKIeKI8ROnMqW6X2vuiVMaDDoOSdrBfd3etT9+Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 281f0336-3275-4157-73f9-08de7be98e4e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:33:38.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZQ1+dW6TzKY1dsi4k5awRCLeEaOhMnDnp52bBUaUKH3IoFfLqHmKrR+5ZM1ZcCzaRzBqtzcuJ1HDE1c0V3Dt5P5VJa4vdTqyFW87g3UGMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 8D9C3229630
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73207-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.971];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On 3/4/2026 8:21 PM, Sean Christopherson wrote:
> 
> Absolutely not.  I despise bit fields, as they're extremely difficult to review,
> don't help developers/debuggers understand the expected layout (finding flags and
> whatnot in .h files is almost always faster than searching the SDM), and they
> often generate suboptimal code.

Okay.

> I don't see any reason to do anything more complicated than:
> 
> static inline u64 vmx_get_insn_info(void)
> {
> 	if (vmx_insn_info_extended())
> 		return vmcs_read64(EXTENDED_INSTRUCTION_INFO);
> 
> 	return vmcs_read32(VMX_INSTRUCTION_INFO);
> }
> 
> static inline int vmx_get_insn_info_reg(u64 insn_info)
> {
> 	return vmx_insn_info_extended() ? (insn_info >> ??) & 0x1f :
> 					  (insn_info >> 3) & 0xf;
> }

There is

int get_vmx_mem_address(...)
{
	...

	/*
	 * According to Vol. 3B,...
	 */
	int  scaling = vmx_instruction_info & 3;
	int  addr_size = (vmx_instruction_info >> 7) & 7;
	bool is_reg = vmx_instruction_info & (1u << 10);
	int  seg_reg = (vmx_instruction_info >> 15) & 7;
	int  index_reg = (vmx_instruction_info >> 18) & 0xf;
	bool index_is_valid = !(vmx_instruction_info & (1u << 22));
	int  base_reg       = (vmx_instruction_info >> 23) & 0xf;
	bool base_is_valid  = !(vmx_instruction_info & (1u << 27));

I'd assume wrappers like above for each line there. But to confirm your 
preference: would you rather keep this open-coded, or introduce another 
wrappers for each?

