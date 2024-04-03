Return-Path: <kvm+bounces-13502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B128897B79
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB7C91C2171C
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5251E156980;
	Wed,  3 Apr 2024 22:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GskWkww0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D2E138494;
	Wed,  3 Apr 2024 22:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712182456; cv=fail; b=RiYO0sA7CdbtOnabo3VqEo3N9LDR9Gss4gisffrKwWtATGP3PYcyliQQo3zqlIkAV6z0FqAvpNF8MwrBRVIgI9s4PuXZKvvx2pi2D9p4H/MlDYy56di/XVNRPP/aU3QQPGAPML4ihVvuLu7KmkMFpDyUBVunkkuSrLrUOdzO5i8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712182456; c=relaxed/simple;
	bh=4PptmEEC3fqNyEDP95exuAe76otIbiE5os4iiWeiZ+k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MKs+lRpZ5ALnlqHy+bFDVmz/PZiOGhD7+5A+bz15Dv9vT1+wsyM4MvghUVT+K1imBQAK6PNgZ9LarshGuRpXNKX6HWEjgtN0rrijFOFAiKg4awu1zZpwAbf+H5xOGgMWWKvN6p6QB6omCRSV1RPPfAHLUDAu+hMShuKcqSuetiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GskWkww0; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712182454; x=1743718454;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4PptmEEC3fqNyEDP95exuAe76otIbiE5os4iiWeiZ+k=;
  b=GskWkww0k1l+oQU/cQ6Gj5q5C8nBfKpIPgiu6d+ku1/xMBKI6dsYNIWH
   vPJ5iRXIn1zFCjBsXVNbm4ujW7mu9EvZJu9Gx3WodNNMJS23uv2NXLdET
   0LJUav0C4giYf0aRfBx1iY7yz9xUojQiJH8xcizwhRCw/vQblUvSrRrNB
   rBFjMCcRg/qMhamz2EGQDw1jbM1YhGvMcd54d/kzn/COrHSPrFhSlW++K
   Qy0XUHQCb3oh5ryDhx2O+wxVljCkFBFqd02yBMkA8M7j6QGPh4FDV0ycQ
   qOiOrIEybi9BCYE8LK6cl2iL+lQr3FafYxftiQxAOs+u64WpM2+oSBHvE
   A==;
X-CSE-ConnectionGUID: e7B3jJWoShaWkl9PkNIEhQ==
X-CSE-MsgGUID: AeusjRAWTsKOHsqTV+ugTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="11219389"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="11219389"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:14:04 -0700
X-CSE-ConnectionGUID: AR8gwBOOSku3BLcCIsmu4Q==
X-CSE-MsgGUID: mJsUfPb8RqW48MrPMjopVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="49528015"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 15:14:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 15:14:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 15:14:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 15:14:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZhd5vAMutVlStpY5SeZHGUjN9mfEMoLq0++TWp+asj5qbmjvknP3P+ZsbsU0GW4a0juaTUXDC0nN1wnJizqGD2kQNk21izg0AuGi+yGlX7Wo4UZM03eYPBirL31Acw+PvEgudK9JPe0uOlw0gTC1csNnVqH9KsyR6x2f3Debjdrsij9YLwl/E0ybYyvBtHsKraRhm9sOzChrMPHB+vHS5M0AaMXeFgZV9SicC9rVlDv0m68IUut+J/MXMzVhov5TdfdxPQ6pNcMddYaQAzDaTDsJB2/jefvVMZaSXVQxAhCNoxQHykD5VeMd8SWABCT2LF9Oi8/SSd6Jc2ClJCKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyM5fxdLGdqNADANVF/tNeyt9/9quA05HUL5azsHG8U=;
 b=c4wGyhxS2vQJyuiUU/77JIFuHCnvlV8irIMvWNmGmEILvMHb5CRYgGqVQGyYyE1JN4Gbi3VTfBr8ZCHGJ00VTMobjDjPmQhrmt1D8N2OgAvEdfgdLSCACKjNAwc44EYX4NJ34+825M0oCBLxb4ZWUdz1S0bq8WfuAuQfLb47tNWkAzRKybbsOrUXgo0ZKhMWgg103BFhn5/mhzKo8P6rv+V9LXIIiSrnl5+kOFOHKqj5AkRmAz6jxmK+fNCOde2mpb/+yIesltemIpjIcHzI46jDsqf2/T4ibCXNl/vj08b6Qws/z3DBq//gyhBEP1Dbsf25aF06efI0UahZ2IZhuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5254.namprd11.prod.outlook.com (2603:10b6:208:313::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 3 Apr
 2024 22:14:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 3 Apr 2024
 22:14:00 +0000
Message-ID: <58e0cf59-1397-44a3-a6a0-e26b2e51ba7b@intel.com>
Date: Thu, 4 Apr 2024 11:13:49 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240321141709.GK1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0347.namprd04.prod.outlook.com
 (2603:10b6:303:8a::22) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL1PR11MB5254:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HP40nzvzwuzj32q7wHErH/zqO9/bEKcmYlrzue8IvegIsaStTXsnQAoOzK70ajtFBoZ6SpgMb60nph2FjRyBL8JqyIBWuHTQ27NKbNuuWxXUv+8CfP33V3qHCn9twONlvV4G4Q2J7VhHKN8mK1p+5IoptdNQdrruliildc/cMAoeHP0Fe9n8rI1NnjHxG68QGG6Y6uAiweuexx40ZTa/qp4XXtBPzCF7DhecdM/VbCNBVsphq8pjMO6ScFi/EMwzksLQhdnMTUQYggDWSkS2ghQAXGeDLhl1B+oLVB1AhfDMslGvHv4fXlhPlhcKtVfmRzJb6uAayJWfTuaRrnjg/V8iyOkyZqF3NLoKqo4ad1JbZP4L9/cDwo84RPFEDgdEdG+ZHu+or8PaU//Zf+Yv5lmu8/2ZQ+WUXTYEql9HvfwvjUvP2AUK3C7gdwWCoY3TeHsnpS62ti6BJ1emR1m3/qX6rzIwun8sGyGG7If8sNfXp6wrX2glaLqLm3sf3XCYT0CgyHl9MMVdR3TQQIIo1XPf8ttf85gSsQC+tfIPS7ztB3m9QEihwoPJ/ozcyCGZ8fAO8EWab8uYkILcV1mA29InuWloriGud+HzOjxZB7xjgl6aEFh11nh4WqK5787DxDPSLw1JqrcnErwdlZukjETlfLbbFp9WnxwPrcMdHjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFdEUko2OUVnN1B4MjBZMUE0SmZ4aVY0QWp4Y3p0SUU2czRpVTVSdFZuYXRR?=
 =?utf-8?B?Kzk3OW9hQUhrVVNNdklJQjVPUVkxRG03cG1RbzcwZ1crZCtZQTJJT0Y1VUJG?=
 =?utf-8?B?RGFtbWNLMkhxLzZia1FNTGZlOGs4ZVhSekVCSnVzcnhwdlNCak1PZisvejhy?=
 =?utf-8?B?UzRLbzJoa3lzelJnQ2pReWtHUnNad2RFVGtpVG04Yk9HSGNFaURHNU1ZOERE?=
 =?utf-8?B?WlRIZTlGRnlwNWx2M0VOK205NUJrc1pZbDNoWkZDdDQ5cW03VC80VFJvRUUx?=
 =?utf-8?B?S21zTVFGMmpXdGRkOGl6YlE4UGxDcEYvajlwOUtJTWFnZjhYeGNMNDBkaVAx?=
 =?utf-8?B?eFdjclJxREFHaDVrLzZ0aFZuenVxRThXNlZHcUxmUm9qQm1SK2pJU3YxSUxn?=
 =?utf-8?B?MnNaT1Q5WlpMQ0N6ZWdEYW9uUDNQV2ppNVd0MGtKS1lwUHJzYlZnNFhncUZL?=
 =?utf-8?B?dFQ1Q3NFOHRtblJ2RGZPcTVDdHUvQWYwdXBxU2VZRk9yek9qNktWNDlTQzZT?=
 =?utf-8?B?WFk2M0lQeHBnZ2lRUXA2THlXWFgxR0kzMCt6SkUyR3pqc2hUQ1ZnakpBM0FG?=
 =?utf-8?B?WkN1WDNxSDBkVVl6LzEwYkg1VFRld0NxZldRdWErK3J2anRqc1RIZFVzbHAw?=
 =?utf-8?B?Y2lMaU5qOGRyN2Z5NldRMnBpbDh5T3NWdHkrZndFbzZTQnhEeUxsVUxzVkty?=
 =?utf-8?B?aGtITXZVcXd1UXVvZFk0aWVpamJLanZCNGZ1TC9SUFp2dFAxcnQ4NmVwdURz?=
 =?utf-8?B?NnVvSC9ScC9HYnRGYnYxQVlNYmdlNnh3VXNlVEdaSnB3dWZPZXpocE51Mktz?=
 =?utf-8?B?SFpjOUFQOWc4ZHpQM2pIdEw5WGZMWjNsM0hJTForamNOYUVuWTVRbEJHcWFv?=
 =?utf-8?B?MHY4RzhCVHZ4OG5pU1NDc0ErRHFzS1pWL3VIUWF3eXNsV3JCYk1KZmtvcEhO?=
 =?utf-8?B?ZUEvM2NQYmdCRk9NeGxXQzNvbnZjTC9Xek1Mc1o0R2t0ME50RGplblRpM0Rw?=
 =?utf-8?B?dUQraEo5YUhzdnU0b2tmMjZNcTJoRVRERmFkSnA5clFQOTZCWEZ6b3JmRGJU?=
 =?utf-8?B?MlhhUjlRYUx2N2lqbTBPNTNQcGlpQUhreC9EQllkREliVHJ2K0JuRDk1U3VE?=
 =?utf-8?B?MUV2YzFwSE1OT3ArcDkwc0JKM0V1RmgyRVh5U1EyRzI5R00vNnlxQWZGdURp?=
 =?utf-8?B?WE10SmF3bW8zODQ5K1FxUk9ucE9hNUNEWjRzMFJ2Y25EeDBQL3B3MDJqTU1m?=
 =?utf-8?B?aTE2ZWpxdlNOak9HSWFxdmFMM1lSNVRCYzIxMGhuaFVqWFV3YmhUa1U4ekdE?=
 =?utf-8?B?bHJNdG1ZdDFWaGJaUDNabStWUnMvajRQR0E4UGRBMWlwVUhyZk8wOU12UlZs?=
 =?utf-8?B?ZmdjaThzcUN4ZmxEVTllUTVsYkhTSmJwV3lKb2E4NGFXZlhyTFFSR2hlTE9u?=
 =?utf-8?B?QlpsL1BxZzdPeHN6L0NUMkliQ053Z0JNbkxRVUExWlZ2SDI5YVZJZFJqQ2JL?=
 =?utf-8?B?TlpLKzB4VDlNbHNkMkFaNXBoZHFXZllwMTN0RUgyVnlpVmxLcFR2L09VbFlo?=
 =?utf-8?B?T0NNQVlTdkdDVXlyZ0tXdkkwYStuL21GYlg1bnc0RVZBYlpScHM4a0ppNitp?=
 =?utf-8?B?RWNEb1F2c3IwSWl6Um51aGhON255cVRKbVVBL1dLdFNoU2M0eE1RcjZhaEFz?=
 =?utf-8?B?c2VlVWs1aXloUVIwbnZjZnpPc1NMR0JCMmdJaXlDeXF2K0wycUhPRWhFa2ZG?=
 =?utf-8?B?aHRVZVN0N2cxVjlmS244TExtOGxEV0FFZHFONnBFNzR4TzI4S09pdXpMR3BP?=
 =?utf-8?B?S084RHlJMkR1TE02eWs3NmdRY1pkM1BBcmlZaXBDeXVqYjBNZmhaNllzVmJh?=
 =?utf-8?B?R3A1MDJRbkZCR0VkTlo0OUlBeHB4ZytwSkczQ1VoTmJzN0lQd2VNQ0ZXc3E0?=
 =?utf-8?B?UHkzVEdUY3ZjWEFYaWdpY1pJeVkwbkFqdnI3VisrSThZYzJIWXhCMEZldGNX?=
 =?utf-8?B?TXpuRXU3UFJkM1dibm5UYlNDNVlVVG1jZzB4MTZrMzlHV1ZyZWFxendoT3hC?=
 =?utf-8?B?a2hRTy85dWhqQUxzYStMMHZpNG8vZ0hsMWd1V3dISE9OMXRXWjBIMFpDNThS?=
 =?utf-8?Q?Ymf6pFl6QsuuAbvEoXDNEoJT9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 374e9149-9685-471f-3fc3-08dc542b5cd7
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 22:13:59.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0zyqV0/NEfsnmeCr1Ufc7nfPJ/hgM/2JUR1w01YjwFpKrzj8LDk9z94jhaBxyA+9dg51fpBYkoPA2iW84z/8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5254
X-OriginatorOrg: intel.com



On 22/03/2024 3:17 am, Yamahata, Isaku wrote:
>>> +
>>> +	for_each_online_cpu(i) {
>>> +		int pkg = topology_physical_package_id(i);
>>> +
>>> +		if (cpumask_test_and_set_cpu(pkg, packages))
>>> +			continue;
>>> +
>>> +		/*
>>> +		 * Program the memory controller in the package with an
>>> +		 * encryption key associated to a TDX private host key id
>>> +		 * assigned to this TDR.  Concurrent operations on same memory
>>> +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
>>> +		 * mutex.
>>> +		 */
>>> +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
>> the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
>> create TDs, the same set of CPUs (the first online CPU of each package) will be
>> selected to configure the key because of the cpumask_test_and_set_cpu() above.
>> it means, we never have two CPUs in the same socket trying to program the key,
>> i.e., no concurrent calls.
> Makes sense. Will drop the lock.

Hmm.. Skipping in cpumask_test_and_set_cpu() would result in the second 
TDH.MNG.KEY.CONFIG not being done for the second VM.  No?

