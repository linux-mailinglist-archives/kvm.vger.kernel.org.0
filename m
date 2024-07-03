Return-Path: <kvm+bounces-20913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 94A19926965
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 22:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 333B3288C45
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 20:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763DF18F2DF;
	Wed,  3 Jul 2024 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ioMIXvqT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC43213DBB1;
	Wed,  3 Jul 2024 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720037664; cv=fail; b=X8BIStgTAcfzgwHIansqdVhfrui6R3tY4cvaYuq/Mnb3sQ03eOCexVXVvKdFthtanYp5p4Qib6+JYh3ed63+eHcBthuwzZVN3fqjbC07D59UdXmrmAGPSrsIu41JG42kxhe30gb9fzYHvoJ4v7JgdbizMYuI+8+h8lJpiF384Co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720037664; c=relaxed/simple;
	bh=DpjJ6raGIvDlOU0uWvPrR4ObdoCEH4JcYPB/RVMjSWA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UOnlziL6AyqbUUWgkcVrzP1Hwg/eGrezTvqWrjIron7dMv29vdvjWdOmyhBkQYbmmLy3peFpTiK8RuXh0eQgqXgdv33FQk8D4sXDcmTytXJlKk2yRJBs9J5fB+y+d9R5StmxnewZ795qqarK2wc4qxWI0BS7ym3C4SIu0CYBXZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ioMIXvqT; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720037663; x=1751573663;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DpjJ6raGIvDlOU0uWvPrR4ObdoCEH4JcYPB/RVMjSWA=;
  b=ioMIXvqTjodZ+GJEty5rBl0zYIdEWW+LdA9rcHuTnhpCA7J4xHi329OY
   fhG1d2BhnI/tJs4h4B6J4PrNnMzXFnN52tL9Vh9CSb1Y2CvJj6KSjvukQ
   ub9B6Ot00bjS+4Bth09OLrTDBauKjR+jAFRd1QgZFJyXSzshOgr1Nv8EF
   hffdtv3SZL2cYrdbVfyJiv6zKqoMeina7S9FadayiKMAmh/EVHnzZIycH
   etN01WTcWjneVpj4d3G0Z19TGhmk4qoi7FL738PqE3hFS5pVGLxArN+LY
   MP4rL/SDlptgkNLpX2DRMiIwGWp7KOMpVgrT0mjUNFaX/LTW2wsA0yu0y
   A==;
X-CSE-ConnectionGUID: i6RZpJTbTpaiFqf04wOp9A==
X-CSE-MsgGUID: 1jAxfF05Q7+S+cKoFH3hsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="27894364"
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="27894364"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 13:14:21 -0700
X-CSE-ConnectionGUID: AcGQZOR1QH6DAI15LNtjVA==
X-CSE-MsgGUID: J/uvBAErQTWRr7UitVEaOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="50964756"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 13:14:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 13:14:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 13:14:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 13:14:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdGx2RXlbjDt9XHUZ1ApO+Ha2LVWM5agFmCF+rI0BiKl8XhURO/LwqnPEVUgnAoCeS1kdp7JixfMjDjgf+DaZAm8kmHarJMXexkw/H8LsgFfNAmTfXbQ7f+fThrzxrSo3/J2qtxP5LcmOUxQ+qYVGJPTPhBDAjn9iw4rG7ROOMtDxYXTbJSbN5gAfPs/UrnRyJWurSQTo9Xtg2uRLf1BBuR8+EOwaRxaoK4f7pHmAz28WTL+E/aGoeJS0vmU/wHrOigV/OHw6XucbpkKHcoZn511ODwpiA4tXGWDIS0laimH0CpF7VFbfElUGOAqmypzrVzpBNcVtYYG0IXXnJBsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVcpXepw2t3NC8SYpJjpD3NhXMm028IvgWS9A7IVbbM=;
 b=VPhXAPvoyqNXcjgE4HSEzpkdu9xk2dWLAaT1wzY+p7J6vaYjg6GmfAaIZzZoM5o3p3AIV2e+/08LHrXk5fG5YF1nNGcuN/PJpvMU9htrmm+oQcc0blCFOxpBgwg+VkdCTrfLJZwmYp9I0iiYfFc/xF77IWcB4ym/9KR233K/WG2NI/Do9J8rKnmi/8/Ldz2Jpwy47AZhGu+b+Zk11w1BhAeSxHbpCI37YcIhbwkhC9mdEFeEUwjcDf36B8HSz6oELq/9xImlGAAp0VUVZ7qrfjrbVybtyiUskgG/NGWUloyh++vwXt+MnmtjbOwwwOQHyXm1Zs38/xBhgPXy6RYFbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL1PR11MB6001.namprd11.prod.outlook.com (2603:10b6:208:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Wed, 3 Jul
 2024 20:14:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 20:14:12 +0000
Message-ID: <8a34f1d4-9f43-4fa7-9566-144b5eeda4d9@intel.com>
Date: Wed, 3 Jul 2024 13:14:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: VMX Preemption Timer appears to be buggy on SKX, CLX, and ICX
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Hao, Xudong"
	<xudong.hao@intel.com>
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
 <Zn9X0yFxZi_Mrlnt@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <Zn9X0yFxZi_Mrlnt@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:303:6a::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL1PR11MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d75af6-1675-470e-194f-08dc9b9cb44e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2hqd2g4K1RLR2ZSV3R4Sk8xcytJTERpSmMzdDBYNkZRS0xKQll6VXJJNVRV?=
 =?utf-8?B?ODBsdFEzV0cyTVBPd2RId2dpTkFuTjQ2RFVDWHB5RjloL3VYa2owb250TVhU?=
 =?utf-8?B?OVpkWlpYWVZZUDFVbHBHY1VONWJmZWhTRmk3Y1llQktMYlhyQi9mRUszeFpY?=
 =?utf-8?B?Y2N0OU4ySHJqZ2J2WUxRM0lzNlpWclRUSWJLQjBRMjVSMWRad1RuVk9aSlZO?=
 =?utf-8?B?dFpHWTVnNUhIQWxsdzRFWDVOb1g0dkY0ajFERjEvUVcwd0xPd3BqVGVYOUs4?=
 =?utf-8?B?UTFwWVo2UFl1elg1Mk9Nb3ptZGFuNmZuZUs2UUcyM3hodUZCam5aTHJwc3E1?=
 =?utf-8?B?b2QxcGJheTF0bzlEYlg4YjFYY0JERGpHOWVKdFozR3B0eUo3OTd2dm5ZZXFO?=
 =?utf-8?B?SFoxeE1nanh4YnE4bStaS1lwWVQzbVlFaTliT3JxQ0ZPdGJQeWlWdE1WMlhq?=
 =?utf-8?B?OUdVUTlRRjJNMzVVUGxubU1na2kvWmMwYW9EQTFkMUpQSGNyR2g1VGtsbHNh?=
 =?utf-8?B?MDRYTTZEY3JXTngxMW9pSlc2WjJyNHhzaStUSWhjY0dGNlQyandQZGRZazdr?=
 =?utf-8?B?MHkyc1c2bWd4NTlaNENrZmdzK2JzTjZjZW9aNEFMdjdvN3h6ZVVMU0RxelI3?=
 =?utf-8?B?Z2oydmhEUXl4QlZ4SUFhZm5yWFVXV1liVXBhbEM3UmZlN0lBVG0xUWZpdjhI?=
 =?utf-8?B?c0VpSVBLZFdEblYrSXdobi9xN3d4VnVZbGZNKy9lZVlOcUtYZUxldG5DdWFT?=
 =?utf-8?B?UW1WVmx4QXJZcTRkaERtdVZRYy84WjFmQm1SbmJXbzVmSk1pQStSZU5JSXFi?=
 =?utf-8?B?dnl5dFhDN0w1a1BKcUU1S09OV1MxdGRvaVdiL3psVDNRVnVoS2xtd0VoK21n?=
 =?utf-8?B?UVVFUGtHYmErSlVZRDlxWEoxNjdyUTNLQ0ZraWJKR0FvNmJDc3Q1WHhMa1g4?=
 =?utf-8?B?TmYvUEJ3Rkl4TTRjc1JTTCs4WjdvYUxsbXZQZ0ZPZ0dXeFJtRDgreVQrYjVV?=
 =?utf-8?B?aVR1QVNNMTVONUpTK0R0SWdSU0xTYWRHUzU0ZWpid1l1YURsK0cvNkJsMUgy?=
 =?utf-8?B?YVMydnZlcWYybThsY0JMVmRtaWovLzdLcUM2eHF0b0RVRExpa2FMVFREc3Jz?=
 =?utf-8?B?bUdBL1puS09qYnVwVVhtRHhrOVVoWnJTK2VvQ050akdNcFQyd29XSDVMdTlG?=
 =?utf-8?B?Vm9HVEduZm94Vk0zd3NnZUkrL1pKcVF2VlJIUnpKSWRIVm5JU1VMMTUvMlJE?=
 =?utf-8?B?U05HRW11eXhhQ3hhcFl5M09talZIRllSNENHaytVeHA3RlE2YVNvM1Nnak5w?=
 =?utf-8?B?ZVExeE5HV3loNDhWZHZJQnQ4RFhMWnd0a0g4Q3pBVjRXc0tKSHV2ak1IaXFK?=
 =?utf-8?B?Z0hpMGZTZnIwdUNMSUZCS0YyRG00YTJvSUZDalQ1TVZ1MmpTSElFTnhTc283?=
 =?utf-8?B?dU9pRTlhUTZXaGE1dzVSRXNORTlWRk9rcEpFbEpBREtqSWMrc0ttMnJMelZX?=
 =?utf-8?B?K2Y5anZXQUp6Wkt0ODJsL3g4bFdBNVlKbmpCS1Q5RC9DemJHU2dhb1pKSm94?=
 =?utf-8?B?aFNyK1hkRDlkTjg1NzB0TjFHaHo2RTZEa2ROanVjNGtIR2RSSU05YTJlcVhE?=
 =?utf-8?B?dE9pdzZ1bzZ4ZWc0QVlnRjk0aFhxNC9sZEhZb1c4OFNRTnF1T0ViRzlyQ2Va?=
 =?utf-8?B?Q0RFZnVkb2xhY1JlblcvM0g5dVliVFpDMTM0NzdtNFBMWDRqdnZPdWRJTzFw?=
 =?utf-8?B?T3JSQUtCZUwxWGhNSHNzcDlzMExwaXRIUWdnSDhwTjBPTndXaGtQL2h0U3c2?=
 =?utf-8?B?VmREVnBDREVZVmpqWXRxdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V09aQ05Pa2hDeEN1U3ZqS2xCU2E3NzBrYUNleXhka0s5V2VQejl1VlJUcXNo?=
 =?utf-8?B?amlOT1VDZ1hyeTJGTi8wdHRiUUd2ZU5vbGlPbDlidE85citjcWF4RlRhWXVD?=
 =?utf-8?B?dEYvNUhBSHUvMkxheUkwL1d2RTNyV2pESGY0TzFqRWxIVXBIanlRaGJJK1JN?=
 =?utf-8?B?WTBMblk5M2ZqOXozZ3BDNnQyU1JiT25BZDZOdU5xeU1OSmZGUE9zZnd1TzFU?=
 =?utf-8?B?TGVoTFZwcndoV3pBVzdtWGNTbFRvMVkzRkpSd25nUmZsRFdDOTdLTnk0VlAw?=
 =?utf-8?B?MlhzN0hhcWlPYmFrbzM3a20reUlaLzBZQjN5aUdtNE9XY3lmSFJmcGJISjAw?=
 =?utf-8?B?czU5S1JYMHphRmhtck5nS1FnYjVISlNNRmxhZjlvTVY1aFA1NEJtZXZaWUpo?=
 =?utf-8?B?azVyUFBRSExNM0pCQ3dKMmZOckJaWG5GVk5telN0SEdNM3htU3lPbGd0MEZk?=
 =?utf-8?B?UHJiV3VCdnVDSmxGbmd5U0xwd3RmK0c5b2U2QlhWeHNBZklpaXptWXoyKzI1?=
 =?utf-8?B?am40Z0xleXhmSmY5dUZTZ0pVSmNyN0VCYTgyZjJYNytFUFgxZG5aSzJnZTlN?=
 =?utf-8?B?TGx5RERTY2pRbWl4Vi9MbDZYOHU1WjFhTEx6L3RYUTFSQW0zS1JmU0NNRW5L?=
 =?utf-8?B?cjZ2dDFyd1EydlJtbHR0VG1YdE9BbUtqdE9BSVp1VGhKaEI2ajR0NWJUZUNm?=
 =?utf-8?B?SmdSY2JYMlE3Y0U1Y05UbjByMmFKVUx4Ni85Ujdhd1VJaVI4cklyZnJndFBH?=
 =?utf-8?B?NzBzNG1hVFlmN1F0V08rczc4OXBZQ2VNU3lHM21yODVkRFFDZFlyOUZuZ2hQ?=
 =?utf-8?B?SDFiWUZpanVqMVZpOWpuN09jcWJVNmViTS9sUGNSMWJwbjBVTW1ZVWJYMHM2?=
 =?utf-8?B?K2tUdVFxbHRKRUgrT2N4UFpHT2R6SVFJejRVQjFBTzgrbkxYenovaFhGeTB0?=
 =?utf-8?B?S2JGazlLMU5EWm10clNha3BmbEp2eFNxZzBXV1BSTUZaZVltMGlQUjVtTDR3?=
 =?utf-8?B?UWhVYWt6UHBOWGpjTCtBbVpWc1RpajBUNkl4UFBGN05sQ1c5MnoybU53MXJL?=
 =?utf-8?B?WGkvZmJPNTdjcTdpbG5pR2sya2ZDMEtyOWw1blV0Y09IMXB1SUwvakptNkwr?=
 =?utf-8?B?eVR6ekZ5TElWQU9BbzFUclZWYmhQc1BhRVB6cDlwRkdKRWJuZm1ib0VCZ3Bo?=
 =?utf-8?B?MXNhMFg2UllDU0lvakJYSmNET0lCaExxRmpBZm9zaGZKWEFVcUordlkvWWd6?=
 =?utf-8?B?bFZ1RzZySXFCZHNnTXl2UElPdEFEQ2RsVU1LdzZVS3NZNE9hb1NGYzVGaE1T?=
 =?utf-8?B?ZVlOcXB4cSt3L0taamt3ODN0R2gvZGpOb2FZUkNoemliQVpCemlCNkx0QnFJ?=
 =?utf-8?B?VjhqUGFGaE4weGt0UXFMUUI2YVVkU3g0UnFJeEhyYnpTcHVXWUNZZXl5WlVO?=
 =?utf-8?B?eUdFZ2FDOHNtM1IxQjJUKzdXRzlIZ21rTDFrcXRyQ3FZdGtKN0IzOFpwSSt4?=
 =?utf-8?B?ZTdPVWYreVV3UzZYVXl0RHBOT016TEtUZE5BV2RNSTRWcExpamw1QzZjMmY4?=
 =?utf-8?B?WUtQYW1Xa203N3FFOG5SQjJveWJGUVdNZDFnUlB4SGxGZE9ZTFh0Zlk3Y1lp?=
 =?utf-8?B?OW1nUUx6ZEpTMEpZazU4NFhlbkFlejU1OFMvam81L3hBYzIyaXFjUlVubXUw?=
 =?utf-8?B?bGszUlRyTXR1OG0reWdsTHA2VWNoeFI5clNIZFgzeXlMd0NnN05LaVF3MjdQ?=
 =?utf-8?B?alo4UVlKeWZOb1cwSHpMc2tMZE1QcVhWdnNyakVMRUF6Rk1CRVBnQUlPQ29Z?=
 =?utf-8?B?ZGNxV1Z3RmdlcW5waXNROEhiRFg3Mkk0NStFZ0RleDVrd1JFR2tGUko4RFhO?=
 =?utf-8?B?djV2Q0F0ZjV0aXV3bGl3NjRrRTljZGNWSEhZU0FQVVYxVVEyN0crODFjK2to?=
 =?utf-8?B?SWJaU3cvaTJSMHBxa2pjODVqWE5KWUNLeThRa1NORXZiRWo0VlU3L1BKaGhR?=
 =?utf-8?B?Z29pV3JXYlBJMk80aU53VmR4OVZFUmdRZkIxT0h6aUh3bXJ0N2ViQmhnQmFU?=
 =?utf-8?B?djdrY2Y5VGNXdHd6VXh5WTVmL0pDcldRdUdpTkM2V0l4NXplOWVBUFNNVkNP?=
 =?utf-8?B?M2lnMlVJblAvNUpGai9MSlYzTDJKUGFSM1hXTmJTTm9GSUNINXBBMWVtNFkw?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d75af6-1675-470e-194f-08dc9b9cb44e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 20:14:12.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYDYjvyEVOXoKSJEtHEWKdF7gev5Nkc6dop4ScwVInTNzJjcDmnhymg+bLDnJ6JXjIOyO6Ic8wNJEkFKr+julDXuoREJXeDUReghobV7BJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6001
X-OriginatorOrg: intel.com

Hi Sean,

On 6/28/24 5:39 PM, Sean Christopherson wrote:
> Forking this off to try and avoid confusion...
> 
> On Wed, Jun 12, 2024, Reinette Chatre wrote:

...

>> +
>> +		freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
>> +		/* Check if measured frequency is within 1% of configured frequency. */
>> +		GUEST_ASSERT(freq < apic_hz * 101 / 100);
>> +		GUEST_ASSERT(freq > apic_hz * 99 / 100);
>> +	}
> 
> This test fails on our SKX, CLX, and ICX systems due to what appears to be a CPU
> bug.  It looks like something APICv related is clobbering internal VMX timer state?
> Or maybe there's a tearing or truncation issue?

It has been a few days. Just a note to let you know that we are investigating this.
On my side I have not yet been able to reproduce this issue. I tested
kvm-x86-next-2024.06.28 on an ICX and an CLX system by running 100 iterations of
apic_bus_clock_test and they all passed. Since I have lack of experience here there are
some Intel virtualization experts helping out with this investigation and I hope that
they will be some insights from the analysis and testing that you already provided.

Reinette

