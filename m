Return-Path: <kvm+bounces-70462-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WK+7N+0hhmm/JwQAu9opvQ
	(envelope-from <kvm+bounces-70462-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:16:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD63100D67
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 18:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 468A0301D957
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 17:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD74C3EDAA5;
	Fri,  6 Feb 2026 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bK7U06Di"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939833D902B;
	Fri,  6 Feb 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770398132; cv=fail; b=uBZ7DE9/sAt77OZ8ES70wqfm7EnWmsOAZoD8KQCVQ9vZQmVlWnQgY7Xbh121W5BSzi8BDp+292/5gsQjz5QDYjhNj4bwJT531h7ovFnmivqwH8elKc3Vsdmt/4KV5mrWJ9gD8yIUFnWUzaGYmLvav/3S4bsD8qY8nrIcmvE9cKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770398132; c=relaxed/simple;
	bh=FoVEvX5BcgIlDnKch2RiK3l7sB6s3ajQV6kCj3g72o8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OFs+kKKoifCAtjGcAjXw9jjEdpUMsbQHHWTCLjxv4qB0GragaOgg5nCrVaX8etmrDmNDiltypMVdkhHDf9B5hv/mXShO6/n+mSG7yFe2GwHuXUQgZ15usooy+weVlDH3hGSM0qYJ8WDBB2B2pQX/vnM5ZAPSIzNI0nMELT0VK08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bK7U06Di; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770398133; x=1801934133;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FoVEvX5BcgIlDnKch2RiK3l7sB6s3ajQV6kCj3g72o8=;
  b=bK7U06DiEbpvL5VcD+vN7EwH/dv/bcUdkSeTXH1Ogijap9494sZyRFtZ
   Eq9+8uZPo2TTof4rn/pVngCCA7OVr5/MMJCVcwOhEllrg+ikS52B0mkck
   xYo8KQBVkjt9ymW4Hg6pnVL5cnS4GLhzjefucTevofqdzycS1Gq4psfPR
   ooLmlSO2W/fT0fhnlAj773uI+3SEuos7jMAsh5HftigqN5gO9BJ5nDwA2
   RaW25ljOg2OsUE58MP7bD7CaeTaH0Fl/Glc3pzprRycIKP6kIDeswq/8g
   Fw4dwMOFg4Bx51pD9L3gcZHAPbYzMWjaeA6ysrib5jzT7SNoYNWDSCre0
   w==;
X-CSE-ConnectionGUID: gAYLKIg9SVmXYLrcMKFo5w==
X-CSE-MsgGUID: 5q2JBFu2S7+r8SAgwU5gIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="70803409"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="70803409"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 09:15:32 -0800
X-CSE-ConnectionGUID: x0VfnRMIRdyAIro/Gy0pkg==
X-CSE-MsgGUID: azox/WstTByt/I+x2J4r9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="215491087"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 09:15:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 09:15:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 09:15:31 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.34) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 09:15:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgjZEFjpPktilYM4qbTdvdMG9tw+voa+NxXgnud7TGoF3ygmvhYaYxxKb3L+1qz4yTCCzZs74xWT0o6E4KMy0z8S51oNHQoOwFoyb4EPgyZ+A2nhOAKi6d952L+0jvfgG3dmsg/Udb0Jb1Y8D1aKa8QJJfqKoQHjWJpeyaTdPaza4LW/X6So8egfAC4l1sRLpCJYjcxMOAJQszVh7U47uoocZ3bnaIvUd+rp9ZvoDSvObQRKWGm/gDN1OwD+y5fYKA/+a4UPPSuZwSQzRj6C8NCocAm9nj6V2oyiMXsT3jqueONXhCLGaHl1s6RggYXtidpyguGDshxh1g+WArhb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJI3Pt94VgqtrGjqlJW4GEAy6mSSNbIXo6YW2tLkm0s=;
 b=nV9ZT0QWOY7nom4SgAvTp02QRsCSCokK/vgG2pApYvOUAS9121zX2Q2AX9EFfCZe9thVTR1nTwq1Pta4Ypf58pyFsyDBzCraHQ/nRV/T6S6PH3e1H9SxScX+KN+cMCaEVZYvuV5q9qALtcsPhBEyRKuVT1/0bhDYW8OEh0QdSL+ktM+YA8ThYDI9IkebvKx4O8XyaFgRFjEonExqiOgB+XMhB/jX2jUjHacJeCKZiHAwDeNKe+tmcWin3E7WqO9m/RAM7fzNmVbHM0Dt+HaK2T/eWDLbZCEETBBynsU3H/QjZfNN5JLjT4lOF4NGjotgrIi9YsUXrb3AsWmhG5Djrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6138.namprd11.prod.outlook.com (2603:10b6:930:2a::11)
 by SN7PR11MB8284.namprd11.prod.outlook.com (2603:10b6:806:268::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 17:15:28 +0000
Received: from CY5PR11MB6138.namprd11.prod.outlook.com
 ([fe80::70cb:bd99:d04a:afe4]) by CY5PR11MB6138.namprd11.prod.outlook.com
 ([fe80::70cb:bd99:d04a:afe4%3]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 17:15:28 +0000
Message-ID: <bc466a64-e4ee-4088-9b59-33ac98f280b9@intel.com>
Date: Fri, 6 Feb 2026 11:15:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI for
 TDX Module updates
To: Chao Gao <chao.gao@intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>
CC: <reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-11-chao.gao@intel.com>
Content-Language: en-US
From: "Xing, Cedric" <cedric.xing@intel.com>
In-Reply-To: <20260123145645.90444-11-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::9) To CY5PR11MB6138.namprd11.prod.outlook.com
 (2603:10b6:930:2a::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6138:EE_|SN7PR11MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a593278-9740-4f37-eb06-08de65a352e1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aklKa1hQZTdQTDRJVEs5N1RmRithZythaWpaTlJSSTVxSTBOVDBLMTQ0ZGNi?=
 =?utf-8?B?Mm8wNUZUUXZuV1JlRnBLdmhtWkdGdEZPU1ZHUWwwejg1VVVwYm9jSDFYZVdv?=
 =?utf-8?B?TVpXNjNDb2Ird1BSdzhRNFhjNjZQYysrdmR4YjkwQW90T21SbnNMd01NMTgz?=
 =?utf-8?B?ZE5oZHJxRk5NYVdDZHhCUGdUNnpUUUIxaTk5VC90U0h0aGhZazlwZC9hMXFG?=
 =?utf-8?B?d2ZPSHFlenQwNzdKbVQvRjlreG1PTDkvRFJZTmJtQTdJMlJSS2cyQXBRL0VR?=
 =?utf-8?B?UWl5Q21CT1I0ZEJQNDh0TjdWV3JTMGd3cTUvdEZNUHlHeDdZdnpJSUdYWUVz?=
 =?utf-8?B?VFc3TWprOWFTaHVRd0lYZ25ESUJET2R3elBVdC80alB0VzBRK25LWHFOb0NH?=
 =?utf-8?B?QURXTml6b0haUFhMNXNQOGhpdlAwMGs2aDFSOGNnN0VCZ3V2S0tEYVNXR0dt?=
 =?utf-8?B?MGt6UUd6VllYZ1d0TDRiWDE4bkJMNGZaT2xVYVZGUFM3cXZTTEtvb1E2RW5O?=
 =?utf-8?B?K2VPTVhxcE8xbE43bFFmUjA3VUp0ZlZBYndIeDZzWVlaTm4wS1huVzFndWVs?=
 =?utf-8?B?YU0zSTRDY2tMSkpRK3YxUTNiTDc4MFJvdWMxWGhYREJwOU9KRThLbjQ0MXRP?=
 =?utf-8?B?Sk9VMEtUY2szRDEwQXdiUU9qMzc4UmxhaHZCU0RIeDNGZmJ6SkFvV2VRZlZs?=
 =?utf-8?B?WGFXdTBXd24yelFiMkJnK1NLTEdJdzBnTDFZSjI3OVcwbDVqQ2JJSjl3Z3Jw?=
 =?utf-8?B?SkJyMjVzNTZVWndPVUhLdVp0cjlDWndNcnNQSHFyd0lUYUVLMnVsQ005amto?=
 =?utf-8?B?OEtUd2k5NWxVOVZheEZaTW1uR01kU3p2cHprTGVQUXF6Vm9IelE3KzZSa2oz?=
 =?utf-8?B?MW9pc25iTUNIUjYxaURrVXFEcFdyQWV1ZlJUUlp6MEJ3aENKRmhndUg3VDNt?=
 =?utf-8?B?YmdRbWM4Zm9mNU45ck1LZ0hIa29EUGVLREhZQWlONFFWYkJxdDdPQm9zRzRW?=
 =?utf-8?B?MnROcHpySGRrdFl1S0FTMFB3MldrNmhqZkFtWG9RZ1V5dUJORWxyYkFxbW9x?=
 =?utf-8?B?N1FNN3RlSmc1RHJqU2lMZlJOTFJOem1kMU11LzA3VlFSeVNGOWVLYXlFOHVR?=
 =?utf-8?B?Ry8wdVJFSEV2aWx0YmJyRHVrT0tmSWRUUVVDYVZpelNITnk0b1VuT3dDdmVH?=
 =?utf-8?B?NFp3cDQzcGh1VFg5RXcrMzZUNTAwYmtEc2hrRy95K1pibTlKdVhNNzg5dUlw?=
 =?utf-8?B?c3N0ZWxLanVYNzIxYjhPWDc2ZnhJV0t3S1lTNHl6WjZmUXJDd1VkVWkvYjlI?=
 =?utf-8?B?YVpYdTJBS0VqK251QmhINFhyZ1IzM1VDNWhaN0E0RUxzdFhLTkJqZC95VlhP?=
 =?utf-8?B?Zk1vcnlvZStCNkJVd1Y2SjBjcjM0SU8xMHZnMytoK3dicHlFaEV5ZEhzRE1q?=
 =?utf-8?B?QUk1MUc1TnprNnoyNG8zSWlhV0s0K2dISEJZV0szMFFQaDFzY1YxbVdGYnBU?=
 =?utf-8?B?c0xCZ2dkOG1mZlZGdTlYNVMwVFJsbDVwWm1kVm9LemRJNlZub2h2RkFPanJq?=
 =?utf-8?B?aVMrN2hMN3dpQ1lkaUlFMlJ4ODR0NXdYS1BISUZOYXowTnp1VHlYc1dKOUtH?=
 =?utf-8?B?aDBLYUx0QkZibTdWZnU0UDVTanRsTHdFbVlseVJCL0syL3NXMUo2OW5adU5E?=
 =?utf-8?B?cDBTdmJiRzZIb3FFaHl4SnFwdTg5K3I0dGFlY0hNM3pOWWEwQWN1bmJJNDVL?=
 =?utf-8?B?N0szcTZhU1ZhQkRFZVB6VC9zTG9MTG5Ra2FFcEFyNEpmd1pmOWFIMXdxNExY?=
 =?utf-8?B?UGpmbU8rM2xKb21SVDVJSUxDbjd2ZGVqdHZLalBpMmFnSXdOSWR3WTBuVUJs?=
 =?utf-8?B?SlNmYlRueVF0NkU0Q0dZaXQvTFlaTU5WVDBnRVB1QkM2ZGRtN2tzcnhGUnY5?=
 =?utf-8?B?Y0FuS1F5V2ZLeUQ4OEpnTTBtVWJ5RUlzNWtDa1ZQNkxOT0pWWkxTZVV6cGVa?=
 =?utf-8?B?ZWZQakMzZnRxS25vSHpCQ2NCRGZ3Rk5IU3N0OTIwUmd2SS9UNnVoSnFoVDlt?=
 =?utf-8?B?UFR3RjFIR1F3Z01EKys2dEk1R2l1aE4yL1VkMFdRdVpXM1prRjVzb01idFhI?=
 =?utf-8?Q?5Eyk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6138.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUhKeSt2WXY3YlVIaDBReFF3T2V6c25QUEVmbHRiNVZLWkVxRzdFckpLZXNi?=
 =?utf-8?B?UmtvRlJMZjFLUWI2RW1sdDQ1d1RDL2tWRWI2QVNaU09XMXpBNWVLT1RMUDVU?=
 =?utf-8?B?ZFJMeUZGUjZXUFB6SHZUN2RTSVczTkJUVzZxYUJjcDY3UkRodnp1eWRxTSt2?=
 =?utf-8?B?NWl2cUVGMTIzSzlUL3ErdE9kV29EQlA3V3B4Z3lXUkhDeTFKbEM3UU1GeDNU?=
 =?utf-8?B?LzR5OUhGUWJ0eW5Da3hHVmFvZ0plZkZYaWd3Zk9QM3JLSDdTSWh6cWlSeDZU?=
 =?utf-8?B?cnpTNVg5S2M5WXlWaDc4eVBDZll4OVhHOTgvNG41WExqZlJXUDZ5K3JDeTBB?=
 =?utf-8?B?R2duVWZOUTZaRDVGaDhlV1pWa1dSZVB6ZGIwRWRGcVQzaXZHUVhIT1pTOW8v?=
 =?utf-8?B?UlZaYkRZa1VRZDcrZzZIWnNVVk1Kd2tCd3NHRVptS2pDYi9mQVJiajY3NVhN?=
 =?utf-8?B?NWhuSGJER0ltelIvTHZkZStydWFkVG1oZXpLYUYyMFFZSjJXQ1F5TzhpS0xX?=
 =?utf-8?B?MzlPdlRWZU1CWXJUajRFaFhqdUNGRkxOOUp5RDErYWtWMHpONjlqRStKb2Nk?=
 =?utf-8?B?U3RrZVJ5SkhPT0txVmNsREV2UFFGWmtyQ3hub1ZLZU1CNG94aE02OGRsbmV0?=
 =?utf-8?B?QmNpaWRVT214enB5cWI2dTY5TndPZ3hDMjJRUWpRU0hlQVFKY21yN1M4TzlE?=
 =?utf-8?B?OFNCMFVuVkJFa1NOTlgvT0JmTUxNc0hJbDV0MEJWQVh0RFlFODFiOHFyOUta?=
 =?utf-8?B?N0tPeGdoS0NJU3B6c2lYODJCM2tQWWo4ZS81eW1SVWQ1emJTRWJwUncxaXBr?=
 =?utf-8?B?a014UDIybGpNdjRqa25OZGV3MTMrS3F5OWpTa2hoeVY4STkzS3AwMS9kVlYy?=
 =?utf-8?B?dXFhemUwMHFvTExsb3ovOWZBSGJmaC84Z2VFMVcvWW41eVJTU2RKNnhnUE1W?=
 =?utf-8?B?RCtLVVdhdGRzWm54M2ZHV3orMTljeVVNRlBENFYyU3AyZlFvYVhHZUFyRXhW?=
 =?utf-8?B?eEVZakk1aW1BSVI1Zm1pSlFZVGVjejUzZUt1djdPdkNIeHVTYXVVQkIySVJv?=
 =?utf-8?B?U2cycmxtMHViUy9NMVNkZjZvUHJDUllCOHdTTU40ZUtobzhRMEJuMXNhT0ln?=
 =?utf-8?B?WEJFTUFUcVN1bXJFblJIMXFtR29nS0lmdzlLQ2o0TE9DMzVMVCtkQVVEUURt?=
 =?utf-8?B?SDdJMXNLRW9HSFBWL3RobjNJZHhhNW1admxENzNIeGVFVU1LMVB0QTl5cGl2?=
 =?utf-8?B?MXpqZy9NRkxuQlV5a0k0aEl6VUFiblVXZHpmbUt3b0VrR0cxNWl2eFFTSFc2?=
 =?utf-8?B?OVpjWWlyMnk3NXJ5NENpaUJ5WGMxQ3Y2ZUlTdExFSXdxRFZrYW85VVN3VEt2?=
 =?utf-8?B?MGtqT3FMWDN6M1J2NC90cVYzZHo4S3A5YVRIbnVXYW8wb3RZVy9hTnVYd01S?=
 =?utf-8?B?dlZMYXduVGhlcEhvYXM0T1FZdGpaMmhxbS9CZmluSTlyTTFaVjdKSkViYzRD?=
 =?utf-8?B?bTdwL29oT0xpZVkzYis0UjJVcHAxdmFpYXVYMVZwT0VTSmtFckdpQnlZM2N5?=
 =?utf-8?B?RDdnRVNqaHRzdWlwQWk3RHdiMjR0WXdsdUs3VnhWSGR2a3VNVXF0QjlHLy9L?=
 =?utf-8?B?cG82bUNVcFV5MG5MT1Z3RUtPc3NpaldtbzVvWUNCUnNrc20vVDJDUUVUMVlY?=
 =?utf-8?B?VlJlekdsM1JYMjVFbHlWYU5GTUtPMW9CQjlQcVlERlJXQmpYcDdIbTNVbUNH?=
 =?utf-8?B?K3NDdU5KWEtZdXVWV2FlSUNnbkpIektNUG5xMWVqWllQZmw3M0JvWk9ReXNo?=
 =?utf-8?B?L1Q4Q2R6Y1gwNlV6YzE0bkMzbXFpdGtwWVQrTEY0bzNGK2tIcUJFT0R3NlI3?=
 =?utf-8?B?MGZlcFZBZXhjNTlLR1FNZjZVNGJ0Z01nQy9zYy9JMmhaem1UZG9nQ0lUcWh4?=
 =?utf-8?B?elpqbWVXN1Y2UFVNQ0Q1c1RNa25aNVRrT1VseHpONU1uNkZqRS8yc0VwMnZn?=
 =?utf-8?B?VUxzSzgvRUVvYTVjVTFkNzZqOEY4WklERFcwT3gybFEzdjFsSTlqb0JjSDhh?=
 =?utf-8?B?WDJzR21YVGQyTm1VZGlCa2JQOU5MUSs1Mkl5dUlTVVhMWVBqMEo5N05saWps?=
 =?utf-8?B?MWRMaFpMeVNVWlJUa0FrM0F6QTk4czJ0RVE5c3BVM2N6K2NFRC9wYldGL3J1?=
 =?utf-8?B?aDczOXFmdHdzS0ZIOTVyaG1IalNIVVZGYmliNVp2US9rUHg3T2x3UGxpOGZo?=
 =?utf-8?B?Z2lXbkZJbXpoejhibTFwN0NvTEpJd0VkeE0xcDJ1TUs1ekdUekVKT1FQNlJu?=
 =?utf-8?B?Y3V2OEtsV3B1N2xTb1BSVkZ6UzB0YU9DYlkvLzJ3c01CN2JtWVJKZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a593278-9740-4f37-eb06-08de65a352e1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6138.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 17:15:28.0264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JZA13MFbqEN5lmtuT1Y9XMByxQM3Z+lwn+A/sE75Lrz8IM84kAEmyB/ptH5NTh/WxNHfOGnjPaFoWBIi9C1EPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8284
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70462-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cedric.xing@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5CD63100D67
X-Rspamd-Action: no action

On 1/23/2026 8:55 AM, Chao Gao wrote:
[...]
> +
> +static void seamldr_init(struct device *dev)
> +{
> +	const struct tdx_sys_info *tdx_sysinfo = tdx_get_sysinfo();
> +	int ret;
> +
> +	if (WARN_ON_ONCE(!tdx_sysinfo))
> +		return;
> +
> +	if (!IS_ENABLED(CONFIG_INTEL_TDX_MODULE_UPDATE))
> +		return;
> +
> +	if (!tdx_supports_runtime_update(tdx_sysinfo))
> +		pr_info("Current TDX Module cannot be updated. Consider BIOS updates\n");
> +
> +	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "seamldr_upload",
I can't speak for others but the name "seamldr_upload" here doesn't look intuitive to me. Given this 
FW node will show up in /sys/class/firmware/, I'd name it "tdx_module" to indicate to the user 
clearly that this is for updating the TDX module.

-Cedric

