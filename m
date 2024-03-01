Return-Path: <kvm+bounces-10672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 465B886E819
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED5B528AF7C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49B73B29A;
	Fri,  1 Mar 2024 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RoWvtFU5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E49F25622;
	Fri,  1 Mar 2024 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709317043; cv=fail; b=BvADTYa6TIkplbCbfVBEwINmZ+h3B7t6Zclfddts6Ir0PLDqHuS5Rau/QgQlOIWgA77Kdb6M37cld7nw4fbFFuZhzXzTuPUPdVGMW/D5KVSU+zITHjXbYnaJM+LR3FiRcMBrFoe+wFESFa6i5WbnXOXxNBcxWSN1JAWh4SXxJCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709317043; c=relaxed/simple;
	bh=ngkg4YS4miiLyQXchZn35d4wfaRc0c1wpwYgxlTI038=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eVrKdEuSQDVeTK+gIejuJ2pkf3a2HaDIETQm2J9OlKnV5lPAZYJ7xoNWxFdYD7KQ3w0EjZ7SE2SitbH5rLjxQ54YGKpcN38u8ST3prVOKhhVo7clch1sJkmlucTT53nWt7scSKlfcJMOJgheDgf+Yfc1avD8UOm26JiNmmt3QGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RoWvtFU5; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709317041; x=1740853041;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ngkg4YS4miiLyQXchZn35d4wfaRc0c1wpwYgxlTI038=;
  b=RoWvtFU5dv2ME3rcU/XpvjYbvQPrs0d4dhlWJi0DYPROYJY4wEivVGC4
   2GYcZTwtnL35qfCrk0RLX5c/7f+oe90YKmBtebpJG5F+9s/dpVpn8+i4m
   Ff53cQDpNGc6Uvs3bN7AIPqKCKpyRTNmYiDjXOoQKh3Y2nycGusaBMU3Z
   eSFqtYlBpvfNPAYiBNixfXbnJHVuSAYV2mtXJbyxikIip1Sok55gACBz+
   ldyU5XuKkgpeQHdFKyERKi/2vAowLFtSk35LqUv9+BU3RG/RVhX4Lvcz4
   efkBdnJ1bjjBRJwwYvmHsswae0BPMtrRQ8wq0T6SHYn8/xUxKXha7MZYz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11000"; a="3720353"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="3720353"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 10:17:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="8176804"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Mar 2024 10:17:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 1 Mar 2024 10:17:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 1 Mar 2024 10:17:12 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 1 Mar 2024 10:17:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMpyeOBemPy/lLlb/ye4GZXpU4sH4nTxAM2oNLAfYQ3K9OEzp/zerlyZbP3ZVfQdABzCHBOpXev6eFYIEV077IRFWOWmkcaUfATlruAHEN2xngSIOtsdQM4+lGMn1szubM87PSYQy48us0Rdoa7sO68CMV86fgZvZVwzs30a8Bq+F4A53BIaRpyp+ovASrJFh18Hme8aFWbouiuAOg4cTCXyPGRFe2tmhrGmSenChVoxxvCowD29VL5A/k6ydElV1d9D9o4TFZbl+273dcypdAqiorY2bAuWFheTggfDPOs8Fh7dYAL5bm/kYW05fRou6mkVUzWz+WnEhLdka/ow/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipozm0tFpDxdvIqeoOX1ifAJ0PJ2ks78jrzXodSzcMw=;
 b=ZlmdxV6hUdZRYihlEXr+nEYdxEqsiRiwrGIiDBUNX3ADvy67GaNWG8I4/eCtjr8er8NbmSmo6t98F4Cs4E3EzkJhjHCiQstMyW6vx5AHbpsCVu5BTwmPutqegI3KmJVHbRerpEUN4xGI/+OGHJa3MAWQCKXytLZ5YR/PWOTTcvI5+IRjns2wyWFr+Dc77oMix1BeKzWwRiVaTfPzEvDAOoRDGlQM5rbG9Ozj1xkWVKI3YjKd7deqOeJG4Dnspvi/VMofXfsKNGLJh0UPWsouPkEVd3RKmGYxie/Q2LNPUGQ/TEyw1L8r6jIGRH1pG+M1bJmKcCZkp7j7LxUFoZsJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6139.namprd11.prod.outlook.com (2603:10b6:930:29::17)
 by PH7PR11MB6523.namprd11.prod.outlook.com (2603:10b6:510:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.32; Fri, 1 Mar
 2024 18:17:04 +0000
Received: from CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::e9dd:320:976f:e257]) by CY5PR11MB6139.namprd11.prod.outlook.com
 ([fe80::e9dd:320:976f:e257%4]) with mapi id 15.20.7362.017; Fri, 1 Mar 2024
 18:17:04 +0000
Date: Fri, 1 Mar 2024 12:17:01 -0600
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Oded Gabbay <ogabbay@kernel.org>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, "DRM XE
 List" <intel-xe@lists.freedesktop.org>, KVM <kvm@vger.kernel.org>, "Linux
 Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>
Subject: Re: linux-next: manual merge of the kvm tree with the drm-xe tree
Message-ID: <55pdgbv7ltrwnewhxz7ivugowczzomlm6yvco2nxfanxm4ffco@olkrf4wr65so>
References: <20240222145842.1714b195@canb.auug.org.au>
 <CABgObfaDQMxj9CZBzea+=1fcFQXEemAJoH5Jvc9+tfiC7NAvrQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfaDQMxj9CZBzea+=1fcFQXEemAJoH5Jvc9+tfiC7NAvrQ@mail.gmail.com>
X-ClientProxiedBy: BY3PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:254::12) To CY5PR11MB6139.namprd11.prod.outlook.com
 (2603:10b6:930:29::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6139:EE_|PH7PR11MB6523:EE_
X-MS-Office365-Filtering-Correlation-Id: 3470142f-99ab-40d6-448a-08dc3a1bcc01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4fW9aBtb4QSEr21DPuVrq4DPOPwv5/xc6gl5eMDoveCfN/zxzS22jCH597USxXCq/Akp7LM1MYOEq7zNU968LH+S4pNp3CCVlDgstHQm8Y81/muZZpyo0nhMV6glLbwmjlzNgPRUu23ZtYKxWiRc/BXASi5auxh6+wx2tPnI8n8Ar0/K1TzsuvIqak6Kc7duP8oqSg+f8B/tcqt4mxhs/9DJM5FxMhDo6Qj0TwdyAZYB2oVCBOBe/KT/gC6Wa+gm1g/Fw5K/4CyoMqnoVIsDrqDcz0oFIZkQQbfOsMUWkYQSnaAEEPR4KgVR+YYMvV3uCcxIy8A1K7uf2UpF4oLr5KiIrUBKtWHxL42sJwOzovikn6c6kFJ84sOvURwZHWcukMwz/uPfd230mdFbmXkgEB0Qb5SPnjEkgRgGEUFa83eh+tdTffcFdOXcuc6oPvUOvXNdLKG/KYaPI6QrmIIZQ/Fyy8feo3gwOOJr4GJ9zWhUStA2ICzCwZkFh3J2+JO2mBB/zN+r0/ZqrR9zNLvGDPsXyafU7j0f5nqos7pP8mLcrz7sYadB0hmDvHMwQ39HthBiUYz+9Xw7POqLrO+wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6139.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1lRUzVLaUxSVGdKZU91R0NPVVhTczN4UVZBaUd6dFc1b0U4MzVYb2NQVkJM?=
 =?utf-8?B?YUhlUGgwaUVyMVdoeDgzN1VBVW5EeFBERHFmZS92Z1hQcFV1eklQdlFVSklR?=
 =?utf-8?B?RUt4Yzh3ZzFlVzJ5dFg2RkN5RkllTGJCNFhwWjY4NVlCQ3VieVJpUEpIOVdr?=
 =?utf-8?B?QnlqWkN6c2hqZytFcUx5VkNDd1NzS3FtNnNnNjUwczVocklvRmNaRHNFbisy?=
 =?utf-8?B?WVlJNHIxWXRnajZuaXJzNGhkRHNLYVJ6dUp5MDUxczR2WlZxYWE1cFV3eE1R?=
 =?utf-8?B?OTltKzVNbnRPa3BKSHlOQXF6MmhieDRrY203YWQ5WjJCMjlxRHdkL0NhZEhh?=
 =?utf-8?B?WjRjRlVGaHVLWTg5cWtjRmpIdzB3OFg1bTlVK2lYUS9pOXJrRmdqZUhIOGtV?=
 =?utf-8?B?eG9XY1ZNdTk5OTRWSFpjZDNINForWkNobzhvbzIvZ2pzUmFiOFFsL3VGaDEr?=
 =?utf-8?B?Ulk3cTU1VXpVaHRlZi9iZEVtSzdNVXBEbDc2OEE3SzB6TmZTZGl0c1daZDBP?=
 =?utf-8?B?WGs5QnZsc2FxUllNL0xGeHBZWndPVHhwU0lwY1JDN0ErdHdmR1QzV2cwYWxo?=
 =?utf-8?B?aVdHNktLaGxzSmdyNzJmbjEwYWtVS2lpWng1d20xVFozNG9lVE02ZnJ6TzlB?=
 =?utf-8?B?R0h2SVVWMkRETE9aQlB0MERhQTkwMXN3eTkwOGc1cThGdk01bE5RZ1RjbnZh?=
 =?utf-8?B?RE84OGJGMk45NVRYV2VIVVlmU285Qk45alU5N2NNM0g3NndLeWVJSkZxY1ZU?=
 =?utf-8?B?ZG01aVYrN1NXZ2lFTEdET0gzdzZKWnZ6ajdKVzVmalBXaDNJblFuNy9SNklP?=
 =?utf-8?B?OVBMWVc2SXc3ajBJZjRmeEk4a1NFbE9ZQmdXbnhYMFJXYjRKV2NwUGZnd3Zv?=
 =?utf-8?B?Mk50ZklnY2FIODQrVVZ1MlozUEYvakt0Q2xZSmQ0RE1UZkJjMnNpM1MyTysz?=
 =?utf-8?B?dnJvQktrV1BablJaV0xoZ1VkMGtXRHlNbXVQeVVWUzhIWTAyNmJiaFlmcFAz?=
 =?utf-8?B?RGZ6RzFmSmtQaGkzcnN5THNNd2RYUUlJUitOUW90SDAzQjk3eHRzVHl6N2tz?=
 =?utf-8?B?a0ZmMERvdGVnYzJUVDFvaG5CY0RIdFZJTHF6c1IwUjhSNTY4dXJ6NDRSUzJC?=
 =?utf-8?B?MkRIWHpxMlhUNzF0amJtdEJTY0t3WkN1RVFwczNEL0VJTGlvMnUwOHFUT0Ur?=
 =?utf-8?B?WWIvbmJhMHpCRjZmeGhpMkNvWWQ5VDdjQklRVE9SR2lhR1hpNnU2SXN2R1gx?=
 =?utf-8?B?OENRRmtENlpBN3VwQ0tCb2pZQytjRnh2VjV4ZlJ2TUFXWkhDU3NBenBqZkRU?=
 =?utf-8?B?Z1Znb3ZvVkJFbnU5WS95OFRQVXRJSHYwM3lTaWM3UmRlb1g5dW9PSmVsRlRX?=
 =?utf-8?B?UHNCaitCckxHazFuT2tjWEZSeVJ5YmtTWno4V3haQlpQRFhrMXREVFVVcVZv?=
 =?utf-8?B?ZGdCU0dYYmdGYXJzdUNNeXBUYnFxa1hSWk9ET0ZDUVA4RnlpWW95SUhMdVJr?=
 =?utf-8?B?bHg1VkRnZkxVaUxTeXN3ZXp1aHo1dmd5eFJvUWdqZ0RiOWJmS0pCSUU3MkZT?=
 =?utf-8?B?M25VL2UvVDRLbGZmN2ZQMUtSWUdQUGgvdXhVOFB6ZitZZU85b0RhRWwwaFFn?=
 =?utf-8?B?YzE3U2IvOXNDNDNta3lEYmJmd2Yzbmw1SGU0RHFtaXZKdml5ck80SHJhWjgz?=
 =?utf-8?B?VmRDOWdLaGlvN21HanVXci9VV1ByQ2haeFlLRHJ0bWwxMmlDbStYNitwR0Vn?=
 =?utf-8?B?NEJ1VTVwak5QQ3FNUHVlN2xTcnhuOVNJQ1BrVjZRQmJjakNuNzhuUW1IQmJx?=
 =?utf-8?B?d2ttMitLM3J0ay9VQndMVURkSTg3cjhnbUNiTFZIYzFJZngrcDlOUWJKYVRy?=
 =?utf-8?B?YjRZRmdYbFNnUHVnVFI1U3dnMGVRcTd3TkhsVGhnLzNpQXlsWjBsYUE1TUps?=
 =?utf-8?B?VVpXVG9haXUvK2tHTnVUMzdLZWhOeTZhTnlIYVRmNko2aXJ0RElVelp3QWph?=
 =?utf-8?B?UXUrRHhUYmdqcC9XQzh6bU5ERGlqTmlxMG9HVTJYTG81elNTRGlPSjhDMHhQ?=
 =?utf-8?B?aDBjeE1NVFRSTjlDL1dmNnQwMjVYeVFLVnl5SkZQcXo1Tm5zM1FNekp2U3V2?=
 =?utf-8?B?eEY1Wmp6SHE0V2xTTk9EWVlhdnduT2FobEd4ZEZMTGFtWDRDdytSbktqazNs?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3470142f-99ab-40d6-448a-08dc3a1bcc01
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6139.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 18:17:04.2709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjrPqbrSi5gQBfPMqaY4W1UobTHPXLfRYJqgnd5eJFyEgF2p4X0pBFOLIF9GrUNMHs0aP40gNmW2Gow4n4jeJzbiSnyqhS883wnAxyXjgsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6523
X-OriginatorOrg: intel.com

On Thu, Feb 22, 2024 at 11:42:01AM +0100, Paolo Bonzini wrote:
>On Thu, Feb 22, 2024 at 4:58 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Hi all,
>>
>> Today's linux-next merge of the kvm tree got a conflict in:
>>
>>   include/linux/bits.h
>>
>> between commits:
>>
>>   b77cb9640f1f ("bits: introduce fixed-type genmasks")
>>   34b80df456ca ("bits: Introduce fixed-type BIT")
>>
>> from the drm-xe tree and commit:
>>
>>   3c7a8e190bc5 ("uapi: introduce uapi-friendly macros for GENMASK")
>>
>> from the kvm tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
>
>Lucas, Oded, Thomas,
>
>do you have a topic branch that I can merge?

Yury set up a new tree and the patch we had in drm-xe-next will
(eventually) go through that tree.  We also had some issues with those
patches, so they are currently on the back burner. Current discussion
going on at https://lore.kernel.org/intel-xe/20240208074521.577076-1-lucas.demarchi@intel.com/T/#mc0d83438c5b6164eabea85bb3b5eef7503dade84

I'm surprised to see 3c7a8e190bc5 ("uapi: introduce uapi-friendly macros
for GENMASK") with no acks from maintainer though. Btw, aren't you
missing some includes in include/uapi/linux/bits.h?

thanks
Lucas De Marchi

>
>Paolo
>

