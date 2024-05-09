Return-Path: <kvm+bounces-17136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E5E8C1984
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 00:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67B50282449
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 22:41:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A7812D209;
	Thu,  9 May 2024 22:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOcMPI7M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3068E770E0;
	Thu,  9 May 2024 22:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715294474; cv=fail; b=pxY7+bILbXd3Uho5EW+Hs6Q0N/Vvnxt9A+FrxsHEZ/ok9mf2RjCcR5hpo+veGa6cTbbFuT/JRGHa04Vlt1PzTj2VBT3QP5i0G46RlreUWgkIedq+j3u4dlYs09sDXNCGGceZjqkW6BXxkEdawg53VbTPwzThH5h41PwEm29xxTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715294474; c=relaxed/simple;
	bh=uKvFJdPBwERe2ODuT9EnFsQClH3GG8YibVsmHmn5AdM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BFG3JU6RPZkhjoo6RZKbuO+lyE/sdQ9gxffRJG1jNhySYfwl9rL3NY5o6IrUtEYPU+yPQvjuLi88ULICO6i9SpTtJz5EhSDApRd9kqT6b1mRArU6alRkg9YmJllM/o+J+xbnUbUG2FUOXpDng2YOvGYtAqMMOEfyLAxznQw1RzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOcMPI7M; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715294472; x=1746830472;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uKvFJdPBwERe2ODuT9EnFsQClH3GG8YibVsmHmn5AdM=;
  b=YOcMPI7Mt70RiYInZWsIiTpTi5ryAk26TFZuSjylI7rRKFS3bcpJmoEt
   oh0opY9pFb7xqmvCo70yoXGXpFfzad3+ZYGwbCLcHYTg2F2TAi1sO4lLc
   7RPNPWoM1f59pHiC5ppcSgjCBxx+pUxn/ssOaR2TxZDQgP52yxnEVQoOe
   9CQ2JnZYTOLlICEBiD/ouMeY0JQrWsE6kVMaQubkeJf/JcbyVheYkZN0l
   1pCu0N9JgS1bcR1xaq0/rEIuykQBt+F4JSjnFpAXKewOGYLmeJsCVd6e2
   Z3B5Kom1b6/XKlLHylUCjx++vVgQ5lhGg9YGyok1ONv02l6wFzRmhvjid
   w==;
X-CSE-ConnectionGUID: h7k+YVMNTseFTnzI6lR/Cw==
X-CSE-MsgGUID: fEqcCXoiReWPHQLhhrmDQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="14202319"
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="14202319"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 15:41:12 -0700
X-CSE-ConnectionGUID: SyJw6hB0TPu5Iez9eoJsKw==
X-CSE-MsgGUID: uHgYvWKxTqWunYZIuFSXlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,149,1712646000"; 
   d="scan'208";a="29267326"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 May 2024 15:41:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 15:41:10 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 9 May 2024 15:41:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 9 May 2024 15:41:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 15:41:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMF1q2GTDBA6LwVoQNZfBBhQri0rDbk3CBU9aYrx+Slpx/OxuU7qMXJU50PHOnpgTyH0oUcbM0V+5fX3RE4To3LcR80GT27BOrtEhapGlM8qbVZAAM6oKSWMhrSij2/X2YjxHP7kWpLlSoIi/V55MFe3GiuV0iYsJUOybccMG1rILI6vctQqw7SjkR8pIrPuTSAyXAcB4Hzv+9wsQXXUA8ahvEJQJWelK6FWJZ/8fC4zADlSz1nk223uXmRnibPPQdGrGrWjnXNLXur97K2BgnrZKcYpshjbuD3b8FygHV12tbVSf6qKPlFcq2Nm85MuboEgysQXriji02aEEVXU5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfWDVFw32aQ9Xope5VWpIGUDuh6KBFolNfkfPqE0BvM=;
 b=gJaAu22Dpo6l+WGAqmDCgHVd7Gu5/JCKOFVUGA6xoMkFln0OWFXy9z47IVVl5A8++0u7iRzm6buYiLYKbbitGg3N/Z8TTxW0zXyN3vbRBQfL/fp6uwEy9tbJLssKpEFljr6Of1u+/4CfAv+X+xbjVN6xsXRgVxXsXVr/yorvpq/w+kKbGlHBrV3CByhQXFA0h/3WXjEM+4+IEVb7bJomXMO3P5HPA+qOLWtNE9cF5OrN/X+lA6zph8Klm46IIAJbyWgsNH0C9PHRJ8NywfPVSljeflsEV6c3woaMvtESd5DGtBSYfy3q+l2a1fmesjPbIRfsvrGVRyuKISBqgxwZyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7438.namprd11.prod.outlook.com (2603:10b6:806:32b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.38; Thu, 9 May
 2024 22:41:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.048; Thu, 9 May 2024
 22:41:05 +0000
Message-ID: <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
Date: Fri, 10 May 2024 10:40:56 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
To: Sean Christopherson <seanjc@google.com>, <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zjz7bRcIpe8nL0Gs@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0152.namprd04.prod.outlook.com
 (2603:10b6:303:85::7) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SN7PR11MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 6712de31-ea55-4b0b-aa53-08dc70791cb2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWhwbG1wQXZHVUNpYWo1WCtid2lDdElCSENBSnRNZEpRSHZUYzZMeDdUUW9x?=
 =?utf-8?B?bm82WmoydkcrSHNTU1ZGcGFlN1c4aEF4R2xFdFEyWmthVzBVK2F1ZzJJdzIw?=
 =?utf-8?B?bUhqU0MwcEdEY2wzb1loU2ZYUGhKV0RjN2g0dG1FK2NuYllHM1NkTFYzdjJO?=
 =?utf-8?B?OVN2SC9XM2FCREI2QkQyclpUb2t6ZUlvaFB4SUtIRjRzd2dKRUE5dzgza2lD?=
 =?utf-8?B?Y1lhbERUTzl5TWN6WTV1c3RyTldaTm9qS3hoaFNCMnpOaUJnZGMrWFZTdzFw?=
 =?utf-8?B?UE1YMVFVU2ZSQ1pKT200NldxZUZDaDcrUlJ2MEFLSHNiQ2IwUzBRYytaQVRO?=
 =?utf-8?B?WFY3cmNMQXNPS0duNGRIQnBZQnlMay9DaFpEZWttbWJmV20vU2hJWEdhTEF2?=
 =?utf-8?B?M25qR2FtSVRzMmtPeU5vbkpMVnZsb1I3SVExYVlveFo2OFJDYXBVZE5IYjhk?=
 =?utf-8?B?VHQ1dEIyQ1haYkZtSEhSTVdKTjV1MmNneUFnTFVUOVowbEJqR3dhVUlFWDR0?=
 =?utf-8?B?SklPeFBnZUZtMUU1eFFLN1RweFh6blpnYlhURE1ONGtwL2w5UFM0UE1XYUNy?=
 =?utf-8?B?V1JFZGtsL2tLbEdoY3N1RHRzS3BxemphMWxsMml1R01hVkJhbGdkV2o4ejE4?=
 =?utf-8?B?b3YwQnp0aElyWEp5Z0lrVEVIakExT1dnRG9IL1R5L1VJQldBZ2FVbHMyZEtz?=
 =?utf-8?B?eXFnbzNyOVpHVUR5M0hnSmxBb2l1T2dITXArejdrNHdWZW55cU5OWnZJSmtw?=
 =?utf-8?B?d2RhMUdsNDdlN3pGZmFGV0VtRXhJNXJWK2R3NUU0TmR4VjgvTmRBdjJ5UDJR?=
 =?utf-8?B?aHpncTRXVjVxaFlMQi9IbVVGQWpidFZmZGZyWkNRY1hsWTRxbVM1OFE1S3JY?=
 =?utf-8?B?ZmoxMlMzVkRWbStQSUI5TERlK3dVaE1JNEV4YllUY3Y5MHc2eWxRMm51QVV0?=
 =?utf-8?B?YXZQODc1czFybldhZGc1emNldFJwalNqWGl5UE5tNTdmZFA3S0FUTmhLUjBr?=
 =?utf-8?B?WWV2R2FML1dKWE1RMGlVS3NIQ0dKTXduLy9lUXk4RlN4THBxRG5UVGZEU0d5?=
 =?utf-8?B?MHNra3JsaHg0bkljOWdIOHdBS0ZTNnU5M1hLaHlZSFZXckl5c3FKVUo1Tm1R?=
 =?utf-8?B?ZFNKTkdZSlQxS3l5T3B3QmJidTVrUHpYaS9FdnFZcEtXbk01Z21xVFdwc0tz?=
 =?utf-8?B?Y2pndUJnNVhoaEt1eG5pSisyc3N5YVRuUlQ5bTEvSVdVbkYwTU93enJzR3RG?=
 =?utf-8?B?ZUxmN2R6TGl4d3VOaFBGdlBNYkdjUUs1ZW1wblZxQXJqTnFQZmhacFJweEZF?=
 =?utf-8?B?UUtMMzREUzFob0R0TC95VmdmNU9vNnpvSjBkY1d6am9YVzh6d3orSG82MU8x?=
 =?utf-8?B?d1JlNjl2bXJPd2RKV2hROFNaZmhxMjU5ei8wYXU0UjlxRy80K0dSeVNvWS9s?=
 =?utf-8?B?TkY1eDBBQkE4MzRlY0lPcEFXVDVIR2o0M1VBK3ZVL1pVQzFQYzdlbEh6UkFo?=
 =?utf-8?B?alg2RUVxVmRHYm1EYlBoQVMvTXRzVHVMVmQxRzhSR1diRm5oWG9Ca0IxYjdo?=
 =?utf-8?B?S0V6bXVEbGdNYmIrNW02VG9KSFBTTFF5Skttb2o0M3BGOExmTHprT2xLcUwr?=
 =?utf-8?Q?cf2AfTcwanKhEUoY4hXKE8We/IvoZe/VXeUpIao8fxtM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkVmaGE0NndzMXE4azFQZUhUaE41M21tS3RERS9ZL3ZQQlBCLytEWEsrS2Jx?=
 =?utf-8?B?ZW9nWlA2ZGJsOXRjMmZVbkp1dWNVb3JZMndCb2ErWVBTSDN1NHNMNjEyeUNI?=
 =?utf-8?B?NTB3RVMwblFvQlhWeDU2S3VRQnZRbExVTVc2bjFybHF2N2ZZN3BBTTZSZWFN?=
 =?utf-8?B?YUpIYStzUWsrcjg1Rm9EUG5Vd2RocGVRTmI4RElXSXNMQnJGZEJUYXBqRUxK?=
 =?utf-8?B?WkhmckoybGp4WlFEQ3FwWmc2dWRIRXg4elFPa0c2Tkc5WURwbFFnZkJ1WWZn?=
 =?utf-8?B?ZVRnSW1SY1hhRk5ReEtvUkhzS2tKRnR3V0hCaTB6dkM2S09HQjZsdjN1cnB1?=
 =?utf-8?B?c1BLTjFTSm03SHRLYVEzVmFlcy9HVk9rNXJZNG9DUWllVDlyVVR0Q2UrRThu?=
 =?utf-8?B?Nk8yaUtCVjZMcCtYQXBBK3NVRkh3MjBCdjdvN1J3S3l5NDVkQVRHejJUT1Nu?=
 =?utf-8?B?MHZCVDJhTWl6a3ptbDlyZUE5UzBML1RHQXRKNEpxVFhuNUtZd3pEMlJqNGFE?=
 =?utf-8?B?bEZEd3VIUy9QQ0swejRQY0pCcmRrcGFvOXM2Zno2WnRVL00rejNZeUFEbmtV?=
 =?utf-8?B?RkZaakhkQ0xmQkh1OXYwWE9nVVdNb2l0ZHJ1MEZVa3FJb0I5RVBXTHh0RHZZ?=
 =?utf-8?B?UW4xOXdPU0sxMDQ4N2xVVThNcldiRUwxaTdYWnhnMVBLZ2k0UGVjZDhZYjlK?=
 =?utf-8?B?NGc4M2ZaTXJwTzZ0TVJXeEsvQzV4YlB6VGJ4MFJERFB2dHdMYTQyQ0lTdnNq?=
 =?utf-8?B?TGJMdk5tK3U5Z214OXBaNmcxRVRYenE0OUVyNHA0R3NnckVjQkR2RWR5YUVP?=
 =?utf-8?B?a0kvcmNPODFQdFlGeCsybHhzS1QvVmRTTDNIVE5jaDVLWFlDcXF5TEtNN0ts?=
 =?utf-8?B?amt2a3ZlZE1HUUQ2TFBQSEt5TUN2Qlg1V3dLZkt6ZzB5VFU5L21NWndtSktk?=
 =?utf-8?B?ZGtENHZFK0pGcWFLdGZQVm5WKzVzemozMllTMnZxTGZXd3I1MzdoODQ1eTBO?=
 =?utf-8?B?UlZxM2dvbEU2cWNQLzdXRDZhN2Z1K1A5OGc3RnpNeEp6cWlLRFUxRHZua0hj?=
 =?utf-8?B?cnQ5Q0J3aGUxbTFDM2lvNjNFSVpTVUt1RE85VFVsQ1VDY3I1SFF1cjE4Z2ZY?=
 =?utf-8?B?MEd6WjlzRmc2NHUwNmxXOEM5SndhMDdSa016RFh1a1dlSW1iVTNaWlo2ejNF?=
 =?utf-8?B?U1oyUHpEd1hORWdrbklOT3B2SE1iWmh2Zzk0UEY4ejZTY2lrbStwMW8zSkFI?=
 =?utf-8?B?V000NEtCWXhXV2U4RWNaTi96Y01lcEdsZUk4Z1BzZ3R6SWJxOStHdkFhR2hn?=
 =?utf-8?B?TkQ3U09yRlR4bjNLWldPVlE5K0Z1RGd6V1o0OTYzMjNSVEpjK05zK2c1ZDIr?=
 =?utf-8?B?cU1TTVhkbnRFWDRpUldjR2wyTWtPWncyWWdaSDJXU3NIem9RTzd0Qk5qM09J?=
 =?utf-8?B?akUrMUVQNUY4NDlJZjBhVis5a0FlNVRPdmdRWUY2OEE5V1dVNGwvQzdyYmJu?=
 =?utf-8?B?VUdEWmhFaW1tRW1DcDU4akoycmxHMXdIY1crZG50T0c1akZlNk02YjFKZWMx?=
 =?utf-8?B?T2daRlQzcmlkSnlDU3JVQkR3N3puTklqc1g1MTZzdVNjRXJuNCtJWlZvRWpj?=
 =?utf-8?B?WFYwTEdONTVlZXVZNUx2Smh1bUR4anJ0aU43ZGk2eEZhZnBQNmt5VXpzeGxN?=
 =?utf-8?B?Q0hTS1o0alk1Qi9VSFNyOVllVDZ6eFp1OVdLdkdlNXpvRDY2UEJYa0NYam1H?=
 =?utf-8?B?b2IyZkVCOUZxTzd3UHV0NmpWOHFBMFd0VHlDanpMYmtOMFNYT3pLdVhoeGhK?=
 =?utf-8?B?UTdHMjZFdUdNMzZpdkh3SW5wN045TEsxQUE1SmduUCtJaEQzY1N1RnZFUkZz?=
 =?utf-8?B?ekJLQUhka1lCb2Z2V2ZNa09sVHJIK0RmVVA0dE02dk1JamZPSUZCSkZhRHcx?=
 =?utf-8?B?TnI3dkRSSmpwODZpbWNOQ3Z5WVdQV3FFdDRwY0JVU3IxVFcyMC9WZ3RUakdO?=
 =?utf-8?B?dWFpNE1ocjU2clNJcXpBZVpHUUVIZGJQR3ZWdGN3dU5sUVNhNGErcGVDWWtO?=
 =?utf-8?B?Qk9iSnFFK3RJY1JJa205bHZ6R05OZ1BmZko1YWpCNkY2UkdDQWVUU0lDY3J4?=
 =?utf-8?Q?TvjAfsnYgsAs0Mz5qKkMBKkOT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6712de31-ea55-4b0b-aa53-08dc70791cb2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 22:41:05.6633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0FxOrCZcAzNQxInugS6dtK7c+2UeAML1pEWCN8Fq4SvRKpKvO1+CA3jTRm/91/B4ajTSQAenIPDiVsvawwJhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7438
X-OriginatorOrg: intel.com




On 10/05/2024 4:35 am, Sean Christopherson wrote:
> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> TDX has its own limitation on the maximum number of vcpus that the guest
>> can accommodate.  Allow x86 kvm backend to implement its own KVM_ENABLE_CAP
>> handler and implement TDX backend for KVM_CAP_MAX_VCPUS.  user space VMM,
>> e.g. qemu, can specify its value instead of KVM_MAX_VCPUS.
>>
>> When creating TD (TDH.MNG.INIT), the maximum number of vcpu needs to be
>> specified as struct td_params_struct.  and the value is a part of
>> measurement.  The user space has to specify the value somehow.  There are
>> two options for it.
>> option 1. API (Set KVM_CAP_MAX_VCPU) to specify the value (this patch)
> 
> When I suggested adding a capability[*], the intent was for the capability to
> be generic, not buried in TDX code.  I can't think of any reason why this can't
> be supported for all VMs on all architectures.  The only wrinkle is that it'll
> require a separate capability since userspace needs to be able to detect that
> KVM supports restricting the number of vCPUs, but that'll still be _less_ code.
> 
> [*] https://lore.kernel.org/all/YZVsnZ8e7cXls2P2@google.com
> 
>> +static int vt_max_vcpus(struct kvm *kvm)
>> +{
>> +	if (!kvm)
>> +		return KVM_MAX_VCPUS;
>> +
>> +	if (is_td(kvm))
>> +		return min(kvm->max_vcpus, TDX_MAX_VCPUS);
>> +
>> +	return kvm->max_vcpus;
> 
> This is _completely_ orthogonal to allowing userspace to restrict the maximum
> number of vCPUs.  And unless I'm missing something, it's also ridiculous and
> unnecessary at this time.  

Right it's not necessary.  I think it can be reported as:

         case KVM_CAP_MAX_VCPUS:
                 r = KVM_MAX_VCPUS;
+               if (kvm)
+                       r = kvm->max_vcpus;
                 break;


>KVM x86 limits KVM_MAX_VCPUS to 4096:
> 
>    config KVM_MAX_NR_VCPUS
> 	int "Maximum number of vCPUs per KVM guest"
> 	depends on KVM
> 	range 1024 4096
> 	default 4096 if MAXSMP
> 	default 1024
> 	help
> 
> whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
> a 16-bit unsigned value:
> 
>    #define TDX_MAX_VCPUS  (~(u16)0)
> 
> i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
> And _if_ it becomes a problem, we don't necessarily need to have a different
> _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
> being <= 64k.

Actually later versions of TDX module (starting from 1.5 AFAICT), the 
module has a metadata field to report the maximum vCPUs that the module 
can support for all TDX guests.

> 
> So rather than add a bunch of pointless plumbing, just throw in
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 137d08da43c3..018d5b9eb93d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2488,6 +2488,9 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
>                  return -EOPNOTSUPP;
>          }
>   
> +       BUILD_BUG_ON(CONFIG_KVM_MAX_NR_VCPUS <
> +                    sizeof(td_params->max_vcpus) * BITS_PER_BYTE);
> +
>          td_params->max_vcpus = kvm->max_vcpus;
>          td_params->attributes = init_vm->attributes;
>          /* td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD; */
> 

Yeah the above could be helpful, but might not be necessary.

So the logic of updated patch is:

1) During module loading time, we grab the maximum vCPUs that the TDX 
module can support:


	/kvm_vm_ioctl_enable_cap
	 * TDX module may not support MD_FIELD_ID_MAX_VCPUS_PER_TD
	 * depending on its version.
	 */
	tdx_info->max_vcpus_per_td = U16_MAX;
	if (!tdx_sys_metadata_field_read(MD_FIELD_ID_MAX_VCPUS_PER_TD,
					&tmp))
	        tdx_info->max_vcpus_per_td = (u16)tmp;

2) When TDX guest is created, the userspace needs to call 
IOCTL(KVM_ENABLE_CAP) to configure the maximum vCPUs of the guest.  A 
new kvm_x86_ops::vm_enable_cap() is added because TDX has it's own 
limitation (metadata field) as mentioned above.

@@ -6827,6 +6829,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
         }
         default:
                 r = -EINVAL;
+               if (kvm_x86_ops.vm_enable_cap)
+                       r = static_call(kvm_x86_vm_enable_cap)(kvm,
+				 cap);

And we only allow the kvm->max_vcpus to be updated if it's a TDX guest 
in the vt_vm_enable_cap().  The reason is we want to avoid unnecessary 
change for normal VMX guests.

And the new kvm->max_vcpus cannot exceed the KVM_MAX_VCPUS and the 
tdx_info->max_vcpus_per_td:


+       case KVM_CAP_MAX_VCPUS: {
+               if (cap->flags || cap->args[0] == 0)
+                       return -EINVAL;
+               if (cap->args[0] > KVM_MAX_VCPUS ||
+                   cap->args[0] > tdx_info->max_vcpus_per_td)
+                       return -E2BIG;
+
+               mutex_lock(&kvm->lock);
+               if (kvm->created_vcpus)
+                       r = -EBUSY;
+               else {
+                       kvm->max_vcpus = cap->args[0];
+                       r = 0;
+               }
+               mutex_unlock(&kvm->lock);
+               break;
+       }

3) We just report kvm->max_vcpus when the userspace wants to check the 
KVM_CAP_MAX_VCPUS as shown in the beginning of my reply.

Does this make sense to you?

I am also pasting the new updated patch for your review (there are line 
wrapper issues unfortunately due to the simple copy/paste):

 From 797e439634d106f744517c97c5ea7887e494fc44 Mon Sep 17 00:00:00 2001
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Thu, 16 Feb 2023 17:03:40 -0800
Subject: [PATCH] KVM: TDX: Allow userspace to configure maximum vCPUs 
for TDX guests

TDX has its own mechanism to control the maximum number of vCPUs that
the TDX guest can use.  When creating a TDX guest, the maximum number of
vCPUs of the guest needs to be passed to the TDX module as part of the
measurement of the guest.  Depending on TDX module's version, it may
also report the maximum vCPUs it can support for all TDX guests.

Because the maximum number of vCPUs is part of the measurement, thus
part of attestation, it's better to allow the userspace to be able to
configure it.  E.g. the users may want to precisely control the maximum
number of vCPUs their precious VMs can use.

The actual control itself must be done via the TDH.MNG.INIT SEAMCALL,
where the number of maximum cpus is part of the input to the TDX module,
but KVM needs to support the "per-VM maximum number of vCPUs" and
reflect that in the KVM_CAP_MAX_VCPUS.

Currently, the KVM x86 always reports KVM_MAX_VCPUS for all VMs but
doesn't allow to enable KVM_CAP_MAX_VCPUS to configure the number of
maximum vCPUs on VM-basis.

Add "per-VM maximum number of vCPUs" to KVM x86/TDX to accommodate TDX's
needs.

Specifically, use KVM's existing KVM_ENABLE_CAP IOCTL() to allow the
userspace to configure the maximum vCPUs by making KVM x86 support
enabling the KVM_CAP_MAX_VCPUS cap on VM-basis.

For that, add a new 'kvm_x86_ops::vm_enable_cap()' callback and call
it from kvm_vm_ioctl_enable_cap() as a placeholder to handle the
KVM_CAP_MAX_VCPUS for TDX guests (and other KVM_CAP_xx for TDX and/or
other VMs if needed in the future).

Implement the callback for TDX guest to check whether the maximum vCPUs
passed from usrspace can be supported by TDX, and if it can, override
Accordingly, in the KVM_CHECK_EXTENSION IOCTL(), change to return the
'struct kvm::max_vcpus' for a given VM for the KVM_CAP_MAX_VCPUS.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v20:
- Drop max_vcpu ops to use kvm.max_vcpus
- Remove TDX_MAX_VCPUS (Kai)
- Use type cast (u16) instead of calling memcpy() when reading the
    'max_vcpus_per_td' (Kai)
- Improve change log and change patch title from "KVM: TDX: Make
   KVM_CAP_MAX_VCPUS backend specific" (Kai)
---
  arch/x86/include/asm/kvm-x86-ops.h |  1 +
  arch/x86/include/asm/kvm_host.h    |  1 +
  arch/x86/kvm/vmx/main.c            | 10 ++++++++
  arch/x86/kvm/vmx/tdx.c             | 40 ++++++++++++++++++++++++++++++
  arch/x86/kvm/vmx/x86_ops.h         |  5 ++++
  arch/x86/kvm/x86.c                 |  4 +++
  6 files changed, 61 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h 
b/arch/x86/include/asm/kvm-x86-ops.h
index bcb8302561f2..022b9eace3a5 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
  KVM_X86_OP(hardware_unsetup)
  KVM_X86_OP(has_emulated_msr)
  KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP_OPTIONAL(vm_enable_cap)
  KVM_X86_OP(vm_init)
  KVM_X86_OP_OPTIONAL(vm_destroy)
  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
diff --git a/arch/x86/include/asm/kvm_host.h 
b/arch/x86/include/asm/kvm_host.h
index c461c2e57fcb..1d10e3d29533 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1639,6 +1639,7 @@ struct kvm_x86_ops {
         void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);

         unsigned int vm_size;
+       int (*vm_enable_cap)(struct kvm *kvm, struct kvm_enable_cap *cap);
         int (*vm_init)(struct kvm *kvm);
         void (*vm_destroy)(struct kvm *kvm);

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8e4aa8d15aec..686ca6348993 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
  #include "nested.h"
  #include "pmu.h"
  #include "tdx.h"
+#include "tdx_arch.h"

  static bool enable_tdx __ro_after_init;
  module_param_named(tdx, enable_tdx, bool, 0444);
@@ -33,6 +34,14 @@ static void vt_hardware_unsetup(void)
         vmx_hardware_unsetup();
  }

+static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+       if (is_td(kvm))
+               return tdx_vm_enable_cap(kvm, cap);
+
+       return -EINVAL;
+}
+

  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
  {
         if (!is_td(kvm))
@@ -63,6 +72,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
         .has_emulated_msr = vmx_has_emulated_msr,

         .vm_size = sizeof(struct kvm_vmx),
+       .vm_enable_cap = vt_vm_enable_cap,
         .vm_init = vmx_vm_init,
         .vm_destroy = vmx_vm_destroy,

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c7d849582d44..cdfc95904d6c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -34,6 +34,8 @@ struct tdx_info {
         u64 xfam_fixed0;
         u64 xfam_fixed1;

+       u16 max_vcpus_per_td;
+
         u16 num_cpuid_config;
         /* This must the last member. */
         DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
@@ -42,6 +44,35 @@ struct tdx_info {
  /* Info about the TDX module. */
  static struct tdx_info *tdx_info;

+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
+{
+       int r;
+
+       switch (cap->cap) {
+       case KVM_CAP_MAX_VCPUS: {
+               if (cap->flags || cap->args[0] == 0)
+                       return -EINVAL;
+               if (cap->args[0] > KVM_MAX_VCPUS ||
+                   cap->args[0] > tdx_info->max_vcpus_per_td)
+                       return -E2BIG;
+
+               mutex_lock(&kvm->lock);
+               if (kvm->created_vcpus)
+                       r = -EBUSY;
+               else {
+                       kvm->max_vcpus = cap->args[0];
+                       r = 0;
+               }
+               mutex_unlock(&kvm->lock);
+               break;
+       }
+       default:
+               r = -EINVAL;
+               break;
+       }
+       return r;
+}
+
  static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
  {
         struct kvm_tdx_capabilities __user *user_caps;
@@ -129,6 +160,7 @@ static int __init tdx_module_setup(void)
                 u16 num_cpuid_config;
                 /* More member will come. */
         } st;
+       u64 tmp;
         int ret;
         u32 i;

@@ -167,6 +199,14 @@ static int __init tdx_module_setup(void)
                 return -ENOMEM;
         tdx_info->num_cpuid_config = st.num_cpuid_config;

+       /*
+        * TDX module may not support MD_FIELD_ID_MAX_VCPUS_PER_TD depending
+        * on its version.
+        */
+       tdx_info->max_vcpus_per_td = U16_MAX;
+       if (!tdx_sys_metadata_field_read(MD_FIELD_ID_MAX_VCPUS_PER_TD, 
&tmp))
+               tdx_info->max_vcpus_per_td = (u16)tmp;
+
         ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
         ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
         if (ret)
                 goto error_out;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9bc287a7efac..7c768e360bc6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -139,11 +139,16 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
  void tdx_hardware_unsetup(void);

+int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
  #else
  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { 
return -EOPNOTSUPP; }
  static inline void tdx_hardware_unsetup(void) {}

+static inline int tdx_vm_enable_cap(struct kvm *kvm, struct 
kvm_enable_cap *cap)
+{
+       return -EINVAL;
+};
  static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { 
return -EOPNOTSUPP; }
  #endif

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee8288a46d30..97ed4fe25964 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4776,6 +4776,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
long ext)
                 break;
         case KVM_CAP_MAX_VCPUS:
                 r = KVM_MAX_VCPUS;
+               if (kvm)
+                       r = kvm->max_vcpus;
                 break;
         case KVM_CAP_MAX_VCPU_ID:
                 r = KVM_MAX_VCPU_IDS;
@@ -6827,6 +6829,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
         }
         default:
                 r = -EINVAL;
+               if (kvm_x86_ops.vm_enable_cap)
+                       r = static_call(kvm_x86_vm_enable_cap)(kvm, cap);
                 break;
         }
         return r;
--
2.34.1



