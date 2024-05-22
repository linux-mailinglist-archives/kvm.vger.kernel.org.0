Return-Path: <kvm+bounces-17942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 595D28CBD75
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B886EB2102B
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A1F80628;
	Wed, 22 May 2024 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dW2dGYWd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2737D3E0;
	Wed, 22 May 2024 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716368643; cv=fail; b=HmG89Q/HmTEuicZ3fgbXFzQICQ926wXxELm4LXdvV4tK93pJg+Qb9T/kaBuriCV2i+k13IOAXW843XzMGFdLF2+11AAUIHkVpoyjXMsJMCaPHYT1HuIXp+Y6lXBfmkat+dvTF5C1RF7I2fLFMm15FR9Lk+bct/TrP1lXHMtMVP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716368643; c=relaxed/simple;
	bh=LpKKOK7DEdvSE7g8JadbS6lXXZhkX+GugNgYm4IvQHg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bfM+M76Q7CcMnA5vTzUmfLOwztTN1vrXJO9uyRkwuzrPeeAAK8GdcG4kGKcLnH7Bfw9PA2mCK7NIrcciQhbqBOX7u1zzk8Cdq1sT2BOPHNGlKx4hal8zn3TtDw/O3YHLdK/2a0DFxp6bjqTwTrIII6EdmiPIyCdIIFLN380oHBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dW2dGYWd; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716368642; x=1747904642;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LpKKOK7DEdvSE7g8JadbS6lXXZhkX+GugNgYm4IvQHg=;
  b=dW2dGYWdAon+lHq3H8vxbpv8P62dfv7If0hnSFz0xJIHjrK03IaxiA4t
   IUNySuWDhFyECjTrIv4m5XrccULB3aJamp9SpLshWfjSlBY78uSr/awFe
   3d06892Ah48PKQzVQoAl8zIfY+/Y3WqK+DoPmdck5+rx/wYbc2Mo+L/j+
   ln7qEBzb3HbcJkRo39+m/SlXnCfqYRtU4e68hFWdd+LoZVWsZhGdzH4Hk
   5j9Ypa+HLpTj7FcV7mu9AQ97+ECB+Qkj8tXxjuBeeuV7tqMivz0jk4VzX
   NUVGICZJG3HaM+Si1d1ZtlsdGSicecklSnc7NsmLO8kZ8k0URNIjMf9yk
   A==;
X-CSE-ConnectionGUID: xC8J10LuTQykNGB22BiciA==
X-CSE-MsgGUID: w6wHiP6TQS2dDNxcTkahSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="11643874"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="11643874"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 02:04:02 -0700
X-CSE-ConnectionGUID: jURMhrfRQs2A+/W190UE6g==
X-CSE-MsgGUID: KxNZ7xbOSI2nFg1QSk602w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33127668"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 02:04:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 02:04:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 02:04:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 02:04:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmqV3xO9tPfNEGm7ITN9BtTkAeqz4dvvagKJarG2i3gXyeqYDMJasxJyrQHklYRVVshUBgzSvp8b4q+g49IMbHSICHCtEQNjSIlNXO4suIoNY+pmsCg4bp5acyn3UnlyhaO5jL4It11QClqcUMFoSJBheqlrhMKlMWFVDb7qHnp9qOMOaHcmbigcoFfFIvwS13khIj3KhFkVqC8QSaT+b33V5Vh1fX79r29JyVm32J/Ha9ZhEjpcWVjc8tuQnJ059Wk2C1wtO/PEeO64hiUVQCgwEEJbrPfapMUHhZJGXTyZisB4mLvYTQWUJlDtFNSgaeKR1OOZcZ9ritMIeGfv1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jGI39Xovb/cDkMsoFhWTwwA4hugV1OAo7/IYJunND0=;
 b=oB5x4R1vyjDQ7xFmHJB/YZS8n2xhrvRpcgu4ay0wNrobiRH0emLOtUM+wUq+NWt8W2SPEWuoLFTY02YsbzYRqX/vc2sWCWuogFNpxcm+xGB8l2MeLvCDzpn9sOmfRcIPb5VL1yJ2J8x4TgS2zrWq5OHxgbDxquDB0v0BNN5tZ0Vyh/9IdNcuy5kSkgRi0i/VMRgoaaD6SDHClMst6w34bqQlpKrEfInLg2XpwYPp9LeAydui8WfRi2f1jWdI8TN9+XdzpRuIVj4Gv53xvKWliCUZyEcpVZMmOPobibdw+tmRkuyD8L8RTpcN0wEOCo/p/hVILJs1bh/r+NqlgCKhiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB5893.namprd11.prod.outlook.com (2603:10b6:a03:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 09:03:59 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 09:03:59 +0000
Message-ID: <12ccd0d3-e9a8-47b6-9564-7146d0a79f3a@intel.com>
Date: Wed, 22 May 2024 17:03:48 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Dave Hansen <dave.hansen@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@linutronix.de>, <rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
 <ZkdpKiSyOwB3NwRD@google.com>
 <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
 <ZkuD1uglu5WFSoxR@google.com>
 <df5fa770-1f9b-4fa7-a20f-57f51b0d345b@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <df5fa770-1f9b-4fa7-a20f-57f51b0d345b@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0136.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a4632e-1c7e-43e8-9bc1-08dc7a3e1dd9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L1ZzN0lVVUR3NDI3Sko4bDlaTkNyYW84bXNSckJBL2JPN042Mko5K24vWENw?=
 =?utf-8?B?Rko3cTdRSVAxbFNwaUVUQnJWZUlXdHAvZGZya1BDclUvSUVPVmpoY0F6Rkta?=
 =?utf-8?B?YXM4eTJrQUFJbWdDU3R5bFoxeDdZYWdjblVGVW9EU1R4R2RHTWQxMmxtQ29h?=
 =?utf-8?B?Ky9UN1RSY0lnQXNkZ2NKV1FiQUhWOExwREgwUHBEU2NnRUU5aDBsdm9kdVox?=
 =?utf-8?B?dm5TaE9iblBmWnREcEtDc0MzeHZXaFVVdi9Rak1pTFJtdWFtMFozVGNDRk51?=
 =?utf-8?B?NHlGUy9hY1JLZlNrTytmcGRTQ3dZZHNVQTZNK3pnaWtzeU9nWmIzVkZuSmFS?=
 =?utf-8?B?NlhIdjdURjVHS0d6RnVCTWNIWVlMam5qeWpzWWhkWlZIVEJuNk9UbFNHdlU0?=
 =?utf-8?B?SElZTjlNSWVqaUhHSHVFSnUxRzVsSlpTT0tMRmVER0tOWW83UTZIanJzVTYx?=
 =?utf-8?B?Z0g3RFE3VEk2citKN2tseHZUQlRxdGxGaFhQMWFLM3Z2YnVMenJNeWVjcE9N?=
 =?utf-8?B?bkQ1ZEV3Ymlid0lzL0N4MWhyRi8xQVE1eHJpSGRWeHBYN0J5eFdMQmtqZGwr?=
 =?utf-8?B?TThGMzNWL3BDaURMVCtHVjFpWG43RkxUeHc3TEZSQWFCYU9zUUVYZDNsSnBC?=
 =?utf-8?B?N3pXWUhXZDRDckxVa2hnZWpNbWd1UTUvajBVMEZoK0t4Y3FKTEZRSVI4bGxC?=
 =?utf-8?B?dmpGOTZ0NTZ6TGNlZUFQTzVSLzk3ZkdFdGMxa1UrTkZkY0pGY3NDa2RGUitM?=
 =?utf-8?B?RnJlZlV6WFZaNVEzN1YxcTMvYktPNVZHMWhqMHRXdlFoRWdXRXdVbms1MUdw?=
 =?utf-8?B?SDF6cUVQSW9wWWRkQnhNeUVxNTZ5a2h5N2UvL2gvSXpBZ1VWdVVuNE4wK3F6?=
 =?utf-8?B?dmMraEQxL3Z2aGo1TTdOSi9pM3FHTWFNbmtreDFJeVpLNGxTSVJKUVZaR09m?=
 =?utf-8?B?VExtTkRTNFJ0dzFEaG13TFlIN0JXWm5pOGdtUEx3Tm1TQXRSSGJtV3RPRXJT?=
 =?utf-8?B?QjAyeTNacHN4WFY0UnJDVUtmY2dJemNhdG01eVNYQlVncnM1ZWMzdE5yQVc4?=
 =?utf-8?B?d0ZGRi9Pc0tKbXNNdVJIdXhYZnpkZ09rVlY3eFdydUo1ZXM5ckNqRjJGbzE5?=
 =?utf-8?B?cG1pdHBSYVdjcjNvMFBodDdHQTNJbDlVczZSd0dWYlBtWFNVL25ORVd1dDNv?=
 =?utf-8?B?S1Q1MS9Da2FwWWJCN2N6QzdyWFplQlNpdXJ3QmUvb2hQSHl4WFpJcCtiMFdK?=
 =?utf-8?B?SjdTd3JHTWZVQ0RDMEg4OUNTNmtnMlo5cUhXTkZEamZqQlp6RnlScVZmREpZ?=
 =?utf-8?B?b09zZllIUU1lc3hYUVJnY3F3WUxwQkQ5c3VWa3NvMzdtNERJRCtmdnpKNkRK?=
 =?utf-8?B?VDlXTC9zU011N3hPbVRyaWsyQXF4L0hGaUJXVHR6VzZZSzJnWHdLb1U3Rjc5?=
 =?utf-8?B?QnNtYTJPYlFoY1ZEcGhvTjQ4M3Fad0JsTEgwbERzMUl1aER5TFVoeHBNSGhR?=
 =?utf-8?B?Q2lxdjNFMUNmbE5PcVJlNWpISWtTQW9mMWdyQnQzQ3l6MXIrREp5N3FLSGxI?=
 =?utf-8?B?Y0dsVUFackRJWVp0R3F6dk5uNWlxRVY0ZW02ZWhhRm45dlhBUEJXRWpWeGhk?=
 =?utf-8?Q?oJnVOoEOtji5fQjuaiwRXvj7E5q0UPj47UmdXt41Am7k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDgyYmNPNHZzeWlzVkVBTTk1ODUycUlhQ1Nxa0RiRTkrc01IYmkvTlh5RkRG?=
 =?utf-8?B?SU9QM1lmK0V3cHVoaksrMExvUkJUTWwrQWNPeHF3c2NzN3BITzRUeDNJZTh6?=
 =?utf-8?B?S3l0Y1c3ZzQ1YXp5UHM3YmVXeUd6Z2I5WFUxRVV2VnVLZ0NkZ1J4cDB3RVc5?=
 =?utf-8?B?R2QxRkdsbUpZbmIyQXdnV0pLTW5xK0Z2dVZpbFkzWjJKVG1zL3dDQW5MajhX?=
 =?utf-8?B?SlFKb05sTGFBWWNLVUhSVTE0bzBOeHpnRlkrVkI5NldsZ2pyNlVrcDdPLzhl?=
 =?utf-8?B?U2E4OHE2WWRoLzRLcWdjVEo5VFQ2WEpMV2tNN1QwQnRaaUR5S0hJdTIyTFRD?=
 =?utf-8?B?Ui9QMmJlR2g3cTdLNzlkalNkb1lyL0NsZmxjNGx5VXlCM1oxUlI2WUxNcnRN?=
 =?utf-8?B?UlQvVWhjbVh5RGtIa3lGTGxYOVhGRmIzQlREQUxuNGFiZk9kQ2FaSlkrTlZR?=
 =?utf-8?B?MXlsOGMwVnBwa1ZqcXFMenVEdGRoWkVGT2hxL3gzdjJ0MTlXYy95T1JIY25r?=
 =?utf-8?B?OHFxNkxYaForUWYycy9PWnpEbFAxcHNoN1hkc1FzWmVQNFIxQ1Nnd29UdnAz?=
 =?utf-8?B?QzArNmFBS3k1RWdmK1c3cjRlMzdmVS90bm5PWmJJbHIzWEQ1WVdFb256aFE2?=
 =?utf-8?B?US9mSGhobTVvYTV3WTdOVmxqeGVRRlFncVNoak02Z0pydkExZlBMaFJudDMr?=
 =?utf-8?B?UExSUE9QRFVuZFFSL0pZRFMrdGNMbVFibWFqNWlSUjNMQ3d1NG5rTUZLVnpt?=
 =?utf-8?B?ZUMvRnVPWjlnVlk3VjRUdHdaTEd0bkVlKytza1hLSS93cDhFL3NVdi9BUHRV?=
 =?utf-8?B?TDFsZEE2anFjdEs1SmN1UkMzZ1VwSG91UW82dGI5QlJ1R3JwRVNsYklKMFJv?=
 =?utf-8?B?amlVRXdSS2hBdUJFVzJKVzZmdXZ6VCsxemtqTW5pbXc1OEd4QytIbE1JQjRC?=
 =?utf-8?B?ZXovbDQrRE5DdVVlR0lKVHQ0UVhmMVlkUUpJeWhjSDhBc1RQTGVtWlR5VmE0?=
 =?utf-8?B?WVhFMEl0WmpUWmZ1RGpNcW9QWTFFZWErdmRQVVVjRWhOdEhURStWbnI1WDVN?=
 =?utf-8?B?YVlLRFVNWDdQZmFLbHFBUEIzWkI3TVRxcHdmOUZqU0JBYmc4d05vN2ZyVEtp?=
 =?utf-8?B?OHFpdm5BSW16ZGx3L0hzY2JUamE4YkhDam44M0ZENGNtUkJBOXlXWXBCS0FF?=
 =?utf-8?B?ZG1MS3czeGhObVZuS3lWcHByajJFQUdXRjk1aEMxeW1rZjYybGhENGVjb3JL?=
 =?utf-8?B?L3UzYmtWREc4U2xVQUdRMXhBRVdoZHNkLytNRnVjOWJkSDUrUWlrcm1DUXJq?=
 =?utf-8?B?ckdCaGVRdnV3amxwSGZrYXpVcVYwNWxJOUZONVhJWnYwWThVTkJqNS9JN3Uz?=
 =?utf-8?B?Q3h6REV1KzJnM3doOFpxbEVYSWtVQm1Rdkw3Z0wra0FuZ2tLb3hVUC96RWNh?=
 =?utf-8?B?UTh3SHJRYS9zY0ttdzNOYXRPZE1zN1ZZR21MOHhDVGNidTNmVCs5VHhGbi83?=
 =?utf-8?B?UXBKdjZodHU0MUZiaCtPZjg0Mk1IK2VHNUJLTjdlQlV5SlBlMUNoc0Q1andT?=
 =?utf-8?B?Y2JPNXg2eEp3MkZiT3lyUDNPN2lVVVFRcS9oRG8vK2V2bVhpWHgzTWhGL01E?=
 =?utf-8?B?UXFHeDR1anBFTkE4VmhHdSs5K3FJWkpibkphNnpZSkdNb3VwQ0gvdUhTYW5i?=
 =?utf-8?B?bDBVQ0p3dXVLcFBEVVBRaUZsaEoraDRTTGhadDZGRlJUZXV6OXpHV0lGZDAz?=
 =?utf-8?B?RzhsdmxHc2haeWZweTY1RE1CRkozd0Rlb0N3b3ZIZDdwRzJ0QlljRzVFM1Jv?=
 =?utf-8?B?RVB3UUN5enZVYTQ5MGw5ODhuMktWLzEyZzFsZVBxazBXWDA3akd6NDh0cEtn?=
 =?utf-8?B?S3lwbStSTWtYZmZBU290ZEFEYjUrRW01UmdiZlNjYUVoV2g0ck5SSzZ3NUJz?=
 =?utf-8?B?RFhLSmhWZ2pWcjlrZDd6R0owTGg4dHk1cUdlUW1MSHVDb2JHdGVSN0pKSkdL?=
 =?utf-8?B?NUxIYUp4RUlWYW1udE16UkQxS3YxMU1xdER5bGlQNXJSblFpL0tCNmxKTEZN?=
 =?utf-8?B?M29MTlpWclo3RDVuRFRNSVhtK2hvbFp2VjhZMzUvTCtvelFzaUhjbm9CaThU?=
 =?utf-8?B?NFJaZTlEN2dnUjlaUTBrNzRmMm9jSzd1M2huNzlKaTVnVzBFT3ZWSmQ4dHRS?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a4632e-1c7e-43e8-9bc1-08dc7a3e1dd9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 09:03:59.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWuUHtdw9LzhPwvh9hGWdqJM+450sxCHu3QequbVLfuYWBjP2M3pTWk1N6B5sQ4LouILnYCwinpWjcTJpgzPzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5893
X-OriginatorOrg: intel.com

On 5/21/2024 1:15 AM, Dave Hansen wrote:
> On 5/20/24 10:09, Sean Christopherson wrote:
>>> IIUC, this series tries to tie IBT to SHSTK feature, i.e., IBT cannot be
>>> exposed as an independent feature to guest without exposing SHSTK at the same
>>> time. If it is, then below patch is not needed anymore:
>>> https://lore.kernel.org/all/20240219074733.122080-3-weijiang.yang@intel.com/
>> That's a question for the x86 maintainers.  Specifically, do they want to allow
>> enabling XFEATURE_CET_USER even if userspace shadow stack support is disabled.
> I like the sound of "below patch is not needed anymore".
>
> Unless removing the patch causes permanent issues or results in
> something that's not functional, I say: jettison it with glee. If it's
> that important, it can be considered on its own merits separately.
I guess the existing dependency there is due to the fact that only user SHSTK is landed and there's
possibly no such kind of odd bare metal platform.

Side topic:  would it be reasonable to enforce IBT dependency on XFEATURE_CET_USER when *user* IBT
enabling patches are landing in kernel? Then guest kernel can play with user IBT alone if VMM
userspace just wants to enable IBT for guest. Or when SHSTK is disabled for whatever reason.




