Return-Path: <kvm+bounces-8158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C88D884BF6A
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECC3A1C2185C
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7241BDE1;
	Tue,  6 Feb 2024 21:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXt1kS++"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CEF1B977;
	Tue,  6 Feb 2024 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255930; cv=fail; b=hprB1udrxsMTRz8v8VkuxjoVrZ1vJQp/m86hO4Q1smhxla2DMpDiyZqO1XbANXHb9joETYgtQh2AXqm6HzlXtnrhYEkWlTKFjHjoXSMB38k2OJcUVOe32nSw57KQwTWcZoCibeftmn5+fvDvhvBAvcMeYS9Vx+xeHqneY4h/Mlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255930; c=relaxed/simple;
	bh=rWLUTLq4hVw3ULahen8qmGqse9zaDFgrenVXpVxJVe4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XntTy/bbj5FBmCscc5/T20i7BoFp+Ozka1mM15ri0M0AP7Kk7BU9hPXP2SD7H7K+ad5LPuC/IIbmhanQYHF//2OfJ7JMvmGs4PJUqwEBjkNknniTjOHa5TFBDIDebBq9vl0b7rP5V968LjiJj4xvoMZ2/DEkMx8B9xNb1UZDdzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXt1kS++; arc=fail smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707255927; x=1738791927;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rWLUTLq4hVw3ULahen8qmGqse9zaDFgrenVXpVxJVe4=;
  b=HXt1kS++Mzn5JdYO2Dp1oK7FJitsljldI7nmnvHKbtTmfcmI1Rafps+O
   hmfneFTMmD7BoynjLfqtnfy8VJEwb63/FpC+yNrSc4u6kQFCFXVuXEWdt
   1vDWlYblzqDhw1NmQlTueqoC23aOA6uqg6O2q8B6F4SVusKBqhVNRW+gu
   iu055+cKRitM+Y1qFppdcIEH2ch1lEdS6yA87EAs26NiMglg/cQ4iIhTW
   ASvk+aOQOsFc1oJW3v1ARTxxZevTZoxrLO0iwXtc4CQPyUjw0bFwfp4ju
   RZUb++wX8f0wvcS7RY0iMNFSbJzKFuN04S2uIeWgAPMW8WasmfAuJpJ6c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="435987418"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="435987418"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 13:45:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="909769121"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="909769121"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 13:45:26 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:45:26 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 13:45:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 13:45:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 13:45:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4EQWBLPtMg4YPMefM6E0NdzGcBwaUmI5nPuQVpVs/C4fqnpHKCHudDwfEY970dXJcTH33KInTLbULRup1NKCliZ/M1UFmiFNSnh/Hs312aeQogorsHYr1D1zEVDSSKuudy0+Bu84J8MOW7KgpaTGapj40JnXWXwcZ9O0yi0hC3JLMQqDdzrZ5dOsFZNAIAjW+KHn5rRSrMa/xPcnsfcv/56TEYFLX+fjo/Sy7LmmTx+8hDRNhXyJ1H+eie/SzrPRG4OI7m/R2zrAAjwjIlntuGAwYVnai39JGkfULGgzcbdlDRhatKTPfo3mT5IH07nMDegBxkxHQiGhMaPHqHQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwUHwHBP96AOw3aN8Yu/K9+Z9ddYF2RL+cHaryH3i2E=;
 b=j6KiLdpXO4SizH+KmF8fGP+gmp10qzOUwweVC+87DAgirP/lqGFSxPP/EhsXTPucAwzTmlld/gP2BTHyflZHzlYyfLE5pRnrA83M+D8Zg4tGGFidtD7zs4iBgmH9LtwKxHrG/rou6lCCGbZW7gJzSq0B2KY+SI+8Km3m8iiMWqGIg5ip1SRwUGqsOEh0ywxU/vjXchiKqqz3mfOw6eqgy+1RwbKaDfE/YA6YGSpabublzOg+tyNw65poHO0JuJQvG9fho5AkssjikKG953/5prexat+vNte/yIpn0WBwxIqVRLIwg8+woEWSP5WHxKewYQyszczH937SiEeyAe5k3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7367.namprd11.prod.outlook.com (2603:10b6:208:421::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 21:45:23 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 21:45:23 +0000
Message-ID: <6cef4f69-e19d-4741-9cff-a9485dd58d89@intel.com>
Date: Tue, 6 Feb 2024 13:45:22 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/17] vfio/pci: Preserve per-interrupt contexts
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <d6e32e0e7adaf61da39fb6cd2863298b15a2663e.1706849424.git.reinette.chatre@intel.com>
 <20240205153509.333c2c95.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240205153509.333c2c95.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0021.namprd16.prod.outlook.com (2603:10b6:907::34)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c80395-8abf-48f2-b22c-08dc275cec0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zbE7AL40FdxNhj4pgYRUhPbN7qWb0vrgkqhH7Pcl2vcJ74DMZwwaLdrdUCCInTjEtNdImnl7XYP00CkzEWhaKNdKVod4mkxKV9Jt/dO7XG4b7QytF/+Z4xbimODYntmGI+Ff8JEg4Na7mgyHX9DvX9RFkRwKYH4UTJdOsCxZAxemIsrSjosbnsET0dSdVw5Ld6hXJMtMO+kMH8sSgXOT1arW4VEqMH7QwO7eRDUb3+29BbiBBJIn0M/ag/J9vFoRvMg2LUhAraqf5ZSSDssmglbGlEQorzvjc+w1tuOJLDbI6ynmtl2fQj2y/2f/bqSNVv+uuHYMz7UjGWC3k2hHGj27dsMxHpsQpB6/rPIKwYuN8pU3dM43TydRMVXU1K/BpaIDVr6PjDm50EEA+qG7JKyU+gSX6EU+Bc9OCv1mbZ9hJB0jORpapK26EJkBjsb7bkUh675MU1wkHlw8QL/BSOV/QHjXKrusy7+CcbEJv4XoIsuhS1gmjcEMdMf+eIGFQGWE+1OK3jtI4PElctPjanPJC3DHKaE5U52OYixghXC6mDObZVTPlRyvdlUjWLjANNVyvHAVYd/JZrKNYxyWiqVCzjjESVwIMBZKEUL1Shv2hMYp6z25Xcsklt0JxExiAjTKL5vLrS6HW5hb7iiUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(39860400002)(366004)(136003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(36756003)(41300700001)(31686004)(66476007)(4326008)(8676002)(316002)(66556008)(6916009)(66946007)(86362001)(5660300002)(8936002)(478600001)(6486002)(82960400001)(44832011)(6506007)(2906002)(31696002)(83380400001)(53546011)(38100700002)(26005)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlFMbUVBVndvR1B0S3p2YVRTZUJmRm1HZDZCM0I1YlRpZU5GbFdPQVZabGpn?=
 =?utf-8?B?UnlMc3hmek1Cd3Y5VS9sb0JoNHFuV0ZUdDJOOWNMOHJHVkovSjlheVZtRktU?=
 =?utf-8?B?TTFGa3lwY0FrKzFpVlZEUjcyNk5SNGE5S2J1WXkvVmtIUjVxdlBTeVFUT09y?=
 =?utf-8?B?d0JUSXYwRmlZY0Y0K1MzMVFMWUdaZ3NSaVREVWR1VDhvRVRmQ0VtOUhUdnBv?=
 =?utf-8?B?eHZNQjhiemo2dGtJRWcyOUhESE14QVNNcFNKUjZHdTNLdDVBNE5YMEJCWFJZ?=
 =?utf-8?B?UktyV1h3Ynk3Y2w3aWp5L3lTU0VMUWRmZ0k5Z3NDUGdDZDBwa0tnaTZPbE56?=
 =?utf-8?B?NmdqWlgwQWczaUR3UzVLVXJweDhxMERNL08vek53SUpuRkx0MlVHeXZhYVlN?=
 =?utf-8?B?MmxyMnU3aGdaZWJ6ZWJlSDZnRlo2TmhtbEcvTSs3emFXdGNhUFVVb25MRkFq?=
 =?utf-8?B?S05zUFhIVmdURUExdG5QRmljV0tKTVkyMU5KK2NRR2FEdU9PSys5VDliYUNR?=
 =?utf-8?B?d3VXckRHQmhsVXNsREo2OUVzL08xZHgyTlY2Z1FFQnVEY1dMbWFtdmZsTlRs?=
 =?utf-8?B?dHM0clFSbXZKY1Q0dkUxMEVSQ0kzN2VSQTk1SEJlTGFmNXQxdGNOaFdLYzE3?=
 =?utf-8?B?cTlUaSt2Zm9RVkszSFJnOU5BdThRek5lVmZDTE9sZWIxSXJSUXdkTUlFZmJL?=
 =?utf-8?B?WXVDYWhheE40aUVLL3ZkSzBibFVBWEt2Y29HRVR6cGM3aVRrWjRNSm9TVUFB?=
 =?utf-8?B?UHpBZ3dtNG9xdE1oVVByT1EzV0VrZ3VldGRNQkxjSzBKU0tpK1ZQcCtOaGpD?=
 =?utf-8?B?ZjBReW9qWm45OFREV0dTaVduT2hVU3g5a0hJR1NxL2pxZ0pnSlc2eUU3SHp1?=
 =?utf-8?B?MUQ4aGc2bmFxREdEcWZLcUcyejVPQXhxem5icmRBbHhUcERHSVBiVmIrd2ww?=
 =?utf-8?B?clh2S2pPQ09vTlprOThoS0dFMEM2ZUtkdjhLSnVBNk1EZlJkTFFaQVAzU2lY?=
 =?utf-8?B?ZUc5OTgwd1hzL0RXUE5mN1o5d1laSlZvcFozRHhIcEtUUS8wNEhKWG1QblZX?=
 =?utf-8?B?Ym0vYmNkWWZBL3RrTmwzVllTUUV3TmpJazROVkpUVTJXK3dZUDl0WDhHVTdi?=
 =?utf-8?B?KzNKL0YvVDNmU1hKT3JjdENUS2tRZEV2bTdJNVc1MndhVkJ1dWU2eFp0WlRu?=
 =?utf-8?B?Sng2THdOOHIxVDVOTWZhUEw5S053VDJnWkI5UEhyKzhvNXV4QWUydTlReFlq?=
 =?utf-8?B?ekl0VWMxeGR4ZG1vVlFRc01OV09ya3hiQk5ib3RXbFhqeTgrKzZqd20wbXJR?=
 =?utf-8?B?RTh2Snc0Y0tWMERDbnZOYlo3TUNqN1hzOElUR3JlZWEzVUFqS00rUExNWDlE?=
 =?utf-8?B?dTVZN1VIU3lCcDV5MHk0SXZheUlUQkVTZ29BVUdJVmJXZ0gyZWgyT2ZwdlF2?=
 =?utf-8?B?dTBoZU1WQ2xoa0tKL0h5TWtzT05kYTRtSTJIcUU1SG5VQ0J4RjVsU003eS9n?=
 =?utf-8?B?Nm9oVS9hc0EvaGFwR0dqZ0libmFnaUhnN2pOaStCN2ZGbEtnb1htSHRSbk9J?=
 =?utf-8?B?ellRNkJtS0d3OHpQT25Dajc4OW5adTdpbTZUb1hyVUFXMG0zMk85WGRTdElF?=
 =?utf-8?B?b2lhb2pvaUJqTi9aaVpBUUVlcHJkbHdac3BISzV6L2NTcjhLSzNCc2srSE1a?=
 =?utf-8?B?cWtFOUNwQXV0N2ZZQUhGUE0zWG0zb3J2cVgyQm1SVjBKeE1QVENEbDdUVTRT?=
 =?utf-8?B?L2dadm5xRWVXMjJMUm9icWlxRzVvWVQ5M0lSVmFwQjNKN2VFbXB4TlRnOWdh?=
 =?utf-8?B?bE9UUEI4MmhsNnhpOWQxTzhpWVJjaDFnQzE3eEpEY2VuNml5bkZZQTduei8w?=
 =?utf-8?B?YzVCQ09UUkY0bGh6d0lYQVJmei9Ba0U0MHN2dXlJMnMvTXY2Wmt6c2k3cmdm?=
 =?utf-8?B?L3RMcXhIR0pUTkZ3enExV2FjUW1HWVRkQ2JOTTVUdmxHNjYybkx3bDdJMEF3?=
 =?utf-8?B?eGx6SjVKVjd1dmtpdFBvUUhsbWEvV2xMREtkN0ljMjhIT2VXdlhwV0VJK1NX?=
 =?utf-8?B?ZEcxWVJ3clJ3RmZGZllic2M0WDlOTWFFeUJPalQraHZ5ZlVndStEdDZESnF0?=
 =?utf-8?B?N1pRbEx0ZzZNUWg2Qzc3VEJpZ2NqOVMwQmNHMlRMSHpxT0czbENlSWZTVU90?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c80395-8abf-48f2-b22c-08dc275cec0d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 21:45:23.1753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1loLP4r65neqPcaNV99jUDjmV8RWFRvlH/PJVtVNaIHMCeoglXo/rbnkaEncCbuMRC9MyAsUx34hhDIit633TKn1Rcasea+V1gLfoZXmkTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7367
X-OriginatorOrg: intel.com

Hi Alex,

On 2/5/2024 2:35 PM, Alex Williamson wrote:
> On Thu,  1 Feb 2024 20:57:01 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:

...

>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
>> index 31f73c70fcd2..7ca2b983b66e 100644
>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
>> @@ -427,7 +427,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  
>>  	ctx = vfio_irq_ctx_get(vdev, vector);
>>  
>> -	if (ctx) {
>> +	if (ctx && ctx->trigger) {
>>  		irq_bypass_unregister_producer(&ctx->producer);
>>  		irq = pci_irq_vector(pdev, vector);
>>  		cmd = vfio_pci_memory_lock_and_enable(vdev);
>> @@ -435,8 +435,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>>  		/* Interrupt stays allocated, will be freed at MSI-X disable. */
>>  		kfree(ctx->name);
>> +		ctx->name = NULL;
> 
> Setting ctx->name = NULL is not strictly necessary and does not match
> the INTx code that we're claiming to try to emulate.  ctx->name is only
> tested immediately after allocation below, otherwise it can be inferred
> from ctx->trigger.  Thanks,

This all matches my understanding. I added ctx->name = NULL after every kfree(ctx->name)
(see below for confirmation of other instance). You are correct that the flow
infers validity of ctx->name from ctx->trigger. My motivation for
adding ctx->name = NULL is that, since the interrupt context persists, this
change ensures that there will be no pointer that points to freed memory. I
am not comfortable leaving pointers to freed memory around.

>>  		eventfd_ctx_put(ctx->trigger);
>> -		vfio_irq_ctx_free(vdev, ctx, vector);
>> +		ctx->trigger = NULL;
>>  	}
>>  
>>  	if (fd < 0)
>> @@ -449,16 +450,17 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  			return irq;
>>  	}
>>  
>> -	ctx = vfio_irq_ctx_alloc(vdev, vector);
>> -	if (!ctx)
>> -		return -ENOMEM;
>> +	/* Per-interrupt context remain allocated. */
>> +	if (!ctx) {
>> +		ctx = vfio_irq_ctx_alloc(vdev, vector);
>> +		if (!ctx)
>> +			return -ENOMEM;
>> +	}
>>  
>>  	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
>>  			      msix ? "x" : "", vector, pci_name(pdev));
>> -	if (!ctx->name) {
>> -		ret = -ENOMEM;
>> -		goto out_free_ctx;
>> -	}
>> +	if (!ctx->name)
>> +		return -ENOMEM;
>>  
>>  	trigger = eventfd_ctx_fdget(fd);
>>  	if (IS_ERR(trigger)) {
>> @@ -502,8 +504,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>>  	eventfd_ctx_put(trigger);
>>  out_free_name:
>>  	kfree(ctx->name);
>> -out_free_ctx:
>> -	vfio_irq_ctx_free(vdev, ctx, vector);
>> +	ctx->name = NULL;

Here is the other one.

Reinette

