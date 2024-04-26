Return-Path: <kvm+bounces-16088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2638B42BF
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 902B21C219E8
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FC53BBF7;
	Fri, 26 Apr 2024 23:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f3TkF8V0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290113BBCA;
	Fri, 26 Apr 2024 23:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714174002; cv=fail; b=HPtgBOdyIF2zddAPUbLz73HXFgjW5aenS5PCdvrSRJviFXlN5VI2ej0qdjR2LFjjzwpZ55UlKUUpjlRZE1eobHeERkejKrplJ58TUhbOwxwq+aR7aqHsljNALnZ1OBN2KTNcXW3yfR99DPwayyzUfqD6ab1O91kF4M9LmVQexvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714174002; c=relaxed/simple;
	bh=oj9VppidYKTEMXWldgtl7N1XjiIieUwuL0Qu9Mk4Fo0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lAi5M7EZFdzLTlTvlfNuYFe+EpbAbnKi2yF979SxRYlS+H+fRO2Ga2ckwPa9G4iR40UXigcoLhXcxBBA6XoIk+nnFL6Beij9QXlBHzF0tn70ZYwqo9/YLOVji7W94iXVvvttfEYIhyKpFx52kEtQypgBVaMMjT5zVnOkD27qwsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f3TkF8V0; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714174001; x=1745710001;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oj9VppidYKTEMXWldgtl7N1XjiIieUwuL0Qu9Mk4Fo0=;
  b=f3TkF8V0V22iUIc9jSIRw8Esi8CSYfAiyc6Ya/RueZKh1xwJCPn63Rhv
   aCbFBMcF1Ygrb+s8xYRjXwLuIxSJWSHF/m/nEDEauahW7Z4mb4GAt8Z27
   PEzXErOEhctHTSF6hMPNZdiWgljUPDc2I03k9rxajMJ9GxsMfCzjJ5FfC
   yObc0uEEb2OF8WtMchWHI90HrmN00qI8+M470mdA+tS+RgkZFETVU7WRN
   6tnvoAgazpgZjl28F3Z4jS+mpr7Q+Lv8nviLvBzdmxcfXH8JhAsoV4zyF
   bWK6H8FU480qnSZRT4XnkgOQlOjqUehtZqsRabOsGGd+QRZ9a6exHNpru
   Q==;
X-CSE-ConnectionGUID: VLqNr4GdTs20XBLl+PAcJA==
X-CSE-MsgGUID: q0sVwYImSIqcB/e1ZbDjWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="27378243"
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="27378243"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 16:26:38 -0700
X-CSE-ConnectionGUID: Ai2BulaSR364IXvu6elvEA==
X-CSE-MsgGUID: cSxmr6JWTr6UKX13gkv6Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,234,1708416000"; 
   d="scan'208";a="30362050"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 16:26:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 16:26:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 16:26:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 16:26:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d59u9ilS2sNW/J+YdtMzpaTaDDFENdch7aM2GD0OSYySG3TYkW/XzmHznpYIab2dVOZ9Wp/5x2shhm2TXSuzSy2voJpqMeSqUhLME8l3yNH8gQuO8brrlKTWecdnK3jElgrXdjMLHMH9/idzEFzBLFziIz2xIfOa1AJl74B1e4U6nJ+SPiFEqs1pd2Y3DOGj+4jDG//mWUYaPzyX+6gbmR/LI+VNFfBm+Viyjc0SJ89Cu+pcChK4d3Lrr083JQ9wCZkPC89EB+hy24f5P2y1qHi77KPm2EKN8t4J8SIdC5cT4+oiQXnbTSNoehL3VN5Ho/1gsxMnBcsFrf3gLpU2pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVU3bf7pgLMETDcAZ976DhdHiq6cpe0Jtt6/e5PaP3I=;
 b=EGaSe8unAgC0qOdrkKcKQuB3OY856YlyDbkVlEEbQ7w7aTAYOm4n4GRTYTG9cAujNhJ5iIHBQf/uy5Eg/rFYl9E49GpdG/NtHPS/lSkz7bcPaZEnP2NJ6cZi1mOihxEIGOtBpZKbzdj1yseww6YMF93f+9i00aCMM8JcPTOZLUVhoxxIB9Hn0PiMQvI4E/56NuAOEtLnMQFtzB5MhNSh7P0IT8akYtOzrPv9JY4E9ZS0oV6q3lydvyz4+Hbd7il5DpXcTeI4uT0M6t9GoH3jX7hmLTD6niPcrcBychMl69kpUz29lrWGJ0+G52JGdwvoH4BE1RfeFVHoc9Bbn4hQMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7908.namprd11.prod.outlook.com (2603:10b6:8:ea::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.22; Fri, 26 Apr 2024 23:26:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.023; Fri, 26 Apr 2024
 23:26:26 +0000
Message-ID: <12445519-efd9-42e9-a226-60cfa9d2a880@intel.com>
Date: Fri, 26 Apr 2024 16:26:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: "Chen, Zide" <zide.chen@intel.com>, <isaku.yamahata@intel.com>,
	<pbonzini@redhat.com>, <erdemaktas@google.com>, <vkuznets@redhat.com>,
	<seanjc@google.com>, <vannapurve@google.com>, <jmattson@google.com>,
	<mlevitsk@redhat.com>, <xiaoyao.li@intel.com>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <f5a80896-e1aa-4f23-a739-5835f7430f78@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <f5a80896-e1aa-4f23-a739-5835f7430f78@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0341.namprd04.prod.outlook.com
 (2603:10b6:303:8a::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: f8b5889b-ba5f-41db-2eef-08dc66484b33
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T0FSRENvejdGNDVqZ3M2MGJ0c0M2MzF3Z0llb3RhVERVbWQrWVBhbTEyRHRP?=
 =?utf-8?B?MlQ2T3RCZWs3K1FCd29TeHdEMjBsemtic1lhc2pPSUp2R0YrZENRZk56STRQ?=
 =?utf-8?B?cFNEWXQyb0ppbFhzVjE1NkxYM3ZZRW92YzRSa2N3S1RYWG1NS1F3eXJ1M3Ev?=
 =?utf-8?B?U2pDUlBzZ3B0Rzd4M1I1cXNxN2ppem92eStUNDU5WklkSmR6VkgzRmJOWlFT?=
 =?utf-8?B?Q0o1UUVVZ2FibjN3aWxKSW1DR3M2dW8xaXlaVlZXcWtqRUUzT3RIdXVCVjBx?=
 =?utf-8?B?MkwybkhEVHFtbml4WTdXcXNFYitlKzlJNTVIbldlelYxUVBXSWNnK04vclJT?=
 =?utf-8?B?ckxUZE1ZeWRuWEExcW5LV0VLNjJRbmJUallybDlZNEJrWFBMSy9JRkZOdnFG?=
 =?utf-8?B?OHd1TjFoN2FXYTBWZVJYNVltWThEU0NReWpJVnliNDc0b3pzSy9SdG1zNDF2?=
 =?utf-8?B?c3hHWUVuMkVPSDBKUk1CVjk5V09pWnpraUVncEwvTHNBZTVVOVJzZHNBZ1ZJ?=
 =?utf-8?B?VVlEYml3UldLejB1QldWUmJNNjh4M3hhK28rSGhTSjFNVEhBcE0vQlVkaWhj?=
 =?utf-8?B?N2RxVVA5WGhzbGpia2EyUk5ZZU15NXAzMy8vK1pmMjFia3VIaEIzQytRNmti?=
 =?utf-8?B?TjRYdFdkQWtuUDMwSm9mWFVyQ1VwUFEvQ2xUWXZseTZxaUY0TWZYVE80VDR5?=
 =?utf-8?B?U1RhVzdybWFseFdiYkhweE8zRmcxd2huMUF2UitvRThBaWh4cVV4YUZRTXRR?=
 =?utf-8?B?bWlJeVlUcGViQVV1N091aUtLbzdFYUN2RmJpaUt4Rk82MTR4aXp0eHhUY0Jy?=
 =?utf-8?B?bmp1bC9LVVRyYUZJL1hST1RsaEJQUkJjcUFqMndKeWFqQ0ZrRlpOdnVvK3do?=
 =?utf-8?B?RVluM0J4enNhN2R1UDdPZnN4TnZwZWY0dTk5UXVXQ0liOE1zbFFYeldlSFBl?=
 =?utf-8?B?VFlENEtQVk5rTjVqZlJqWXdVM3QxZVd3TGw5WkphaGk2SU4zY3RwcForb2VW?=
 =?utf-8?B?dGVYdmg5dDVta0V4Q1QwUzVUNytleUtVb2FrbTNBVHBJdGRKbHBmdVhxSWQ2?=
 =?utf-8?B?OEx0dHdUR29jTVkzTW9VQ2dKRzJPaDRhdDF6VW8rdW5pN3NJU3pEeDRRRVE4?=
 =?utf-8?B?cUkyeWhJQllQcmc2bm5PV0E4STExcmRsaUJKU1dydGI4K2k0S2N5enRKdEtR?=
 =?utf-8?B?bmlER1crTzJZS2svdVVxV2hYSDBUQlFqU1E4VVZReHBKSTVSL29xSm04elZK?=
 =?utf-8?B?cVNTWEtYZXR1ZC9tK0ZwRjlKVkx4K3BHb2pTVThoSUdyNHIyNGJuUVlTSHNX?=
 =?utf-8?B?V3lRWmRQeml1cytvaWIzUGRkSEk0a2FhNnRXOHBMZWtQTXZjNXJMU0k2OGdV?=
 =?utf-8?B?ZE40K3NJMVRSaXZtc3ZTampNblFSWkw3OWwxMHVpdnlPVXNtaHp1Tm0ybWs0?=
 =?utf-8?B?RlpFNjg2dnZiaFF2QW5xM2NTcDFqdUg3bzVHSnRDeXVQQ3NKeURvOFllUWN3?=
 =?utf-8?B?b3c3MERobDdZbjBnMThaRUFaSXpVOEREY2VEbmZKOVNHL2l0Y3ZJSTRDU3lk?=
 =?utf-8?B?TGYySEgrNzRSaWUxL1BIYzIrVEVFNmc2OFIyc1l2V1RSVU9JeXBZeDU2UjYw?=
 =?utf-8?B?VzhDK2wxeDgyUWZYeGpIbDA4VEhRdk1yZWNqaWZQUWpuL280QjJaakpZYURt?=
 =?utf-8?B?Mzl6Zml3SDBpcHlQS1NPSm9VYzluUjRoS3FaQkUycWRzVGR2TW9jbk9VbXJ3?=
 =?utf-8?Q?pJ61XcdY1cBK1h/TkzVkyg2XU8N2EYW4X+DX0GU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjVjZHV3aldqYXJtYk43d0wrdFMwOUFrdWtEem80STBEaEJhMU5WMkVNRVVZ?=
 =?utf-8?B?cThFTFB3SC9OcGJyeFp2ZTJjdmRTR3dsNFFkbklJYnQrSU4xTHk1N1FmRjVC?=
 =?utf-8?B?c3Vma0lTbnI3am82YTdmc1VkTW5GRmVhWHhEanc0b0xaYzNlZ1BYZ1docHNE?=
 =?utf-8?B?VG9sRURZOFRkNloybEw1bW5Mc2RKMjh5L3pNbm1xdHMra0hlRGdtU3QyZ0kr?=
 =?utf-8?B?bng3aW9UKzdhYnFra0I2MjFDYTExWTZXMktMS0dCUHBqcW0yelQzcXNDNFZL?=
 =?utf-8?B?VnRrT0M4MFE4N3E0dUJVWWJhT1g4bCtYcC9aSWJUaXlJMHlxODljNUFYaDRU?=
 =?utf-8?B?NTFQZmNEdTVDVVR6TGJlaHdSR1MxWjZSTWQxVXNrNW5LWnBlS3duN1FZbWF6?=
 =?utf-8?B?enI1b0U4YWhoWVk3OTdVRGdXMFZ0d2tXRnBxSGlCQS9Hc0VVYWdBM2hMcTV6?=
 =?utf-8?B?RzkrRG1nazRKU3YvdFNkajI0Mmw1UlIxS1M0SG5EMnQyQzdLYmdnQnBwM1hF?=
 =?utf-8?B?MDN0SWJRNmh6Zm1SeTU1S1lXY0hxVVB2aklGN3k0TFZSL2JRMXIyU2dVaVNR?=
 =?utf-8?B?UlRRSFkzOU1lVGJXcXJicVRRbnhkUjArNkVNYks3RDQvSVRRR3FMemsyZDRZ?=
 =?utf-8?B?Q1BwbHQ1VW1kS1VyUTIyTXdtdFRNeU1qS2E5L1AyTDE2NHR5aFFPL0tjUkdu?=
 =?utf-8?B?TTVybU83eThPcGRxVGJ1L29PaVJFT3JSNjVlNGwzNm9udmxUVlpDcEVzZ3ht?=
 =?utf-8?B?Qll5NVFNNHFXazNXYjMrWTJCY1dKbUpTZ04wRU13Qi85MG9wb2NSQXhXWHdD?=
 =?utf-8?B?SDljaGRQVFIvMmllQld2OUZCRjJ2clpFK2RhZXlWUlVPbmNVY3YvSUM0dC9Y?=
 =?utf-8?B?L2JGYXVWV1FGMCtBWldJQ1FKc1YrZm1uQXlldnpPaXhjTndneVVmdkFDVm5r?=
 =?utf-8?B?eWkxbkMzcG1HaG5LV2xmSDE0S3dEQUMzckt3RU5zcm1vQm5nN1JNanVBSDFL?=
 =?utf-8?B?MnlYWGpOWFlpOXF4TUNaUS83QXUxMjE5NHhaOXJmcExKeFFoUncvcFdmYVg0?=
 =?utf-8?B?L1ZacHpockZ6VW5JY3lOb25rWVhmQ2FRS1NSVXRSV3dhY2pIbmtLWVlua1gx?=
 =?utf-8?B?YUhMNTNtaWZ2WEdEdzVXRUpkZXBkenM2RTFZcXk5NTdKNVcxek9xUWRCRVkv?=
 =?utf-8?B?ekhUL283VkpCSEgwajVnODJCejJTZDcvRTJDRUtuOWJFYUFWejYvMTQ1eXZa?=
 =?utf-8?B?QnE4WXRNT1BTcE0zRFdXV0lFbUlGS1pkTERCMGowcG5kVTBQd2dCWEt4d1JG?=
 =?utf-8?B?V3ovVDBkM1pkWlV0UnAvOHRscVhXVDZHTTFCZ05IQzF0dFZDZ2J6b2dLT28w?=
 =?utf-8?B?ajRORnJ4dm5vQ0tEREdVR2QvQWJtNnE1aFcxUzVka09qSWthWnN1YkVqZUUr?=
 =?utf-8?B?UTJYRE1ZS3lFNXpWUzJNSnVPT0ZQZ2pQTFM0Qlhzc2xNRmxid3pic1VhSWpr?=
 =?utf-8?B?bDI1RUcrRi9ZWDZUSlFSbXpVYVJod1VGMCtDbmU3U1pJZ3huL1FrUWN4TFpS?=
 =?utf-8?B?Z1A4U3N6YTcwWUlzUGlFYytvNWcxdWVMb1kreVdzakR1VWl4YVZOY0RTcUU2?=
 =?utf-8?B?OWd3L0pGd2VTVzhrUXhPZ1NreG44K1hKVlRETm1IVU54K202aEw1Tysza2p3?=
 =?utf-8?B?LzQzRUdOZWw1QmR6ZWZqZ2xHSHBwT0pNbHZJa2IvaC9LN2pvb1A2QzNlSS9I?=
 =?utf-8?B?S25URVdNdW1ua3lmNzNtVnhVb2d0ZDZaVnJJWmFnYytjQWdadUdZUnByWlpS?=
 =?utf-8?B?WWV3MzBuYzhxYnFoT0RjUEROVC8vOTJpcEFwek4xTWd2LzhoNFpSam1EN2N0?=
 =?utf-8?B?dldwTEVHWUVlOUNQNWZ3UXlJcEFkMktlT3J2T0V1TFZoTnFkcXMxRll2dVpu?=
 =?utf-8?B?TE8xU0F2SWhMUFpwMXhNcExLWGRGbHN6MzFYWDJJNzlDWU0zZHRrdmRmTHNt?=
 =?utf-8?B?TWtRWFNrdnNvNUtuWkI2dzJWYWd2UTNjQzFTUWREa2xRUUNVUk1QRGs5TWhD?=
 =?utf-8?B?ZCtMVFNpQm9zNzF4aXpvTDBxNVVwbTZnRW5scGpwaFZEbUhmRmRWUVR6bkRP?=
 =?utf-8?B?bFI4SWJ6dEw2YmFRT1ZqcW9Oc0prSWdCWS9SNDFnSG81WEVOTVNVVCsyUHI2?=
 =?utf-8?B?QXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b5889b-ba5f-41db-2eef-08dc66484b33
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 23:26:26.6324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVKBk5MlM/rSx3pktmbOt8TGHcf/6lGpB/sRci+jv1r8u0Zny7SyXIMWzN/nDbnMH82k5gpf8Mb8GOeLk4IulMiGdjCfoOkq59818SM7RHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7908
X-OriginatorOrg: intel.com

Hi Zide,

On 4/26/2024 4:06 PM, Chen, Zide wrote:
> 
> 
> On 4/25/2024 3:07 PM, Reinette Chatre wrote:
>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> new file mode 100644
>> index 000000000000..5100b28228af
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> @@ -0,0 +1,166 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Test configure of APIC bus frequency.
>> + *
>> + * Copyright (c) 2024 Intel Corporation
>> + *
>> + * To verify if the APIC bus frequency can be configured this test starts
> 
> Nit: some typos here?

Apologies but this is not obvious to me. Could you please help
by pointing out all those typos to me?

> 
>> +int main(int argc, char *argv[])
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;
>> +
>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
>> +
>> +	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);
> 
> Use vm_create() instead?

Sure. This is easier on the eye while generating exactly the same code.

diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
index 5100b28228af..6ed253875971 100644
--- a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
@@ -149,7 +149,7 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_X86_APIC_BUS_CYCLES_NS));
 
-	vm = __vm_create(VM_SHAPE_DEFAULT, 1, 0);
+	vm = vm_create(1);
 	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *)(TSC_HZ / 1000));
 	/*
 	 * KVM_CAP_X86_APIC_BUS_CYCLES_NS expects APIC bus clock rate in


Reinette

