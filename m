Return-Path: <kvm+bounces-11202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FB4874269
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1714A1C22639
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778ED1BC2F;
	Wed,  6 Mar 2024 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bWjVy7uW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E07E14265;
	Wed,  6 Mar 2024 22:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709762832; cv=fail; b=cVKbqsDcAdZgxHMDMJVGvi3lPlR/ZAoytLBBN4cDmrsAbvnQYDlaOzz3SwBpR6i9bbFcxF3MiizeqMZ3dGlBHq8xKGHEl1XQ0P1d8F8gGeHABpCgodwvwrjqqLte/uxVQiSJ5bHa8LfKPQuMC66MEvlAUVUnUD3xUGGzEuG1Unk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709762832; c=relaxed/simple;
	bh=RT7ylnolfh18+j5YiiM5jcWf7C4cJ4SgTC4tlxbkCMY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N2heAqholoyvp4IhtZedmbeHO0hSXeMHGjpGcw4jFHfNJf42VRR5SBZQwBQ0pN9/tR8AanFbHDgDW6bTWw4u5LVOoVoTxs80h+zsI6Xo2P2W8HgaErnE3sfhkL6wchdR1Fb3ZEQuWs/BOwLmrW2m4QdGDh8VYbB7yasC1upyvXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bWjVy7uW; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709762831; x=1741298831;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RT7ylnolfh18+j5YiiM5jcWf7C4cJ4SgTC4tlxbkCMY=;
  b=bWjVy7uWAMgJ87hy0XwC+lHzHXl/cF8xuSWH9qh+n7cPcsrA3QEyEc9T
   YvV+4i9RcYZ3RDGEV5j9Y7s3zSHHE8hjjHA6mFz6BwGvbBhgNB4W1/xHt
   ZXBoewp4Hp6ElJgwIBdzwLf8JSOPohRpnHMA21j1sRlJlzyf5raW9a/PF
   ngrfdpW/x+ADxGa5j5OwseX07bfCgP01A9pJOpmIm5NUNsUPtK7eLbqgn
   UrrAlxMhagHn2SW4LxS2BxrpMZySJTaA+j9zHiOQTQcaDEAAdfsPTZTti
   irI8DKvw3Kg38aWxzwBuEOtLmcfZIsaEVSC/rPdo/v2ghU5Y9tnETOK5I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21857387"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="21857387"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 14:07:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9973733"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 14:07:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:07:10 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 14:07:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 14:07:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 14:07:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRTJhYuSkRYa5SZwPSicpMqnpyO39bwXSGZT4hvzEe7Z8LXXi5uDooZ3HtXlRA0iOP7AmhiaE/FWBxcmhSWffMohO5yaIJK5tPTeDNYmJ9VMk2UL2+xVuATFwQ55/OkYBzh/Yc7630eOj0yiDYmvG9qTPg7/It/5M5Jp2bQyHdQWUS+rnX/sAoslIQsm2WHcPfCnFrWQgZ2dGmgxN/R/hmEsTO5n1s9yQ86JSvicRptjIq6qby95cl5BjTS/S833aPoClErHgurxY7HHar/Ghp2r8RTdmxERHa5snn3ndIgbUDtD4O8sxs0jyGEBnAlZLH31rRbBK49nIZBQOCTj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMZJDXdMZY8gmvMe6JskVn6yBpIGeFnI3folmPEIjKg=;
 b=SAIhGGELVVVdb4bKVZy6c04Ortjr/xd9o+eeh+A0ReG8AGWFprZaZWOMVFP36MrkCgdK7LT/bCgzVSGfZ7EF0HqVnGqBbOycauWHQX+IA5NaP3a1UJsSfKn+J8g329F5mhCsVsHdqwdc4g3yg1OI3SdIiwTU62ZVC9fxwWbHjC9vsxkQ1RQn60wS3BUobSIUNosHVwFkKgLMTiUhe17gp4BR75L/AbSTdpm3hAY+++trrKniSdLhoIM3IPsFLUsvth7pasU+2KXhlQO9PnRax6ZaPRNAXyyFASOVH1vBA1fQASxrDDs2byNX5HiYlHayOYJ4wNBplOICx6Ar+zbBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7444.namprd11.prod.outlook.com (2603:10b6:8:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Wed, 6 Mar
 2024 22:07:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 22:07:06 +0000
Message-ID: <18510419-3030-4af2-89cd-d642b6135046@intel.com>
Date: Thu, 7 Mar 2024 11:06:57 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] KVM: x86/mmu: Move private vs. shared check above
 slot validity checks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>, Yu
 Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-10-seanjc@google.com>
 <adbcdeaa-a780-49cb-823c-3980a4dfea12@intel.com>
 <Zee7IhqAU_UZFToW@google.com>
 <a8dbea9d-cca7-4720-9193-6dbeaa62bb67@intel.com>
 <ZefOnduZJurb9sty@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZefOnduZJurb9sty@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:907:1::33) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7444:EE_
X-MS-Office365-Filtering-Correlation-Id: a98744d6-048e-4c81-50b5-08dc3e29c2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lb441CWvbKocGF3xfW9dUIkAGpUeK1JCnQq2eZAuzOYwVxMi+Aq0QRgbShO+O8dpE1cWKZlfHDRi3O6lPtm8Zhb+gbhtsD35FXFjLgP8KyBcLxDOeqxtPMJunJoKTd19CTIPwL7OKihbwQU7cZmlettglXwmaWfwz83OC9XYdWuxLRiWmd5RRSSLh3SlD3iOyIzck9ApYSm8qZ2LGIYWaU7tgYjyljtwJSXQPIIBPcCMC4veVtRZZLDHojD2g2kRaBmAPsVwdafBBdAWcE6+fj7JWsKU1jhbqhUuXisGgdj+ZoTe1Txz2eiNMTVcK6i3P6G6z/X5/ngWOikFsjSCqlNlksGG0rwl1TAvS8FygDwP4kmPZcVkMrMrxoFmDVDFgPYOpbRt7elmjt97/bgnOM5jNvPfQVQcG1d0iQaDPO4btWdFO+AYrrHm0qDiJIX2VcvnXis45GuySfBcAab6HhvzShWki1mZgPKniAw8V2fWl/9+JQbyVN5J1m5W+p8WRCe4TR5HQVYQZbkyrxlGqd8KgbMG6q/4vWqA47Nd/RfSj1OEMf0egWlVK+x3FHWgRHrsp6qwjmNkIanFMoW+AfNEQtrvo+mCdE+U197AFqg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djkzYktzVjVKRkVQWFl2R2drRzliQzhsdmJXMStuQ3hRYVFTT3Q3Vi9hU1hL?=
 =?utf-8?B?dTh2WitJREQ4aEt3WnlEdDZmeUFoYXZVcTVkWTZkOGQxVzlXaVgzY0poL1ZR?=
 =?utf-8?B?VWpUZ3pGRDlORXFkemV3MGJQUm9jVDRZWE1ZSmtKQ1REd1pmTFY4ejdkRjRT?=
 =?utf-8?B?anRVUDUzclBHNVppRkR6SVdKdUpQdElJcjVSaE1ZejVrcU8yRGQ5Y2VBQVYx?=
 =?utf-8?B?bENvWitleE8xTDBuMFdRUUNPVXVNa242TzlrN2pIQ3JvR080TG9OVTZvOHYw?=
 =?utf-8?B?MmkyWFZUVVl1SlN4MUJ1Zy94d3U4dFlHdEE3R0FJLyt3dU9ZYnRvNXRtWHdY?=
 =?utf-8?B?Sk0rbjYyUkVFYWEvMVc1OEU3VkRoTUFHK0UrSUt1QnVzVjVxN2o3di9zNkVV?=
 =?utf-8?B?d0JtRXpURWxVN0RBWEIwaEFrck12UHZBYWozUysxUW1WWVhYaU1GcXcrV0xE?=
 =?utf-8?B?N1I1bVluUVVHNE5nWWRLSnJNLzBTNUZYbWk2WVFqRWNIWDBGOThPMWdZTysv?=
 =?utf-8?B?T1dkM1l3UzlzaDNmQ1RGQUtwNEZVSWI1UzFQSko3eDVvWkVVcVg2empyQ3JV?=
 =?utf-8?B?TTRPRFRKWXRyRnVwYWVqR1NlVnZaTkJaZGMrYkdzMVY0L08ycU8vWlRwYmdr?=
 =?utf-8?B?cVRpRFlrYWNCb3ZQWXhtN2hrNE5KOUVmbG9Lc2tVQ2FYYnVRY2tzVC9XWDAy?=
 =?utf-8?B?dkMwTFhkWVlMY1dLd0RyU1RCU2lxdEtUdUpYeEtOcWF4SEVpb0RlQjVqcWFs?=
 =?utf-8?B?MTlMbGlBQ0hXUEhBQUM4UEdrM005M3liOEVmVTJMM2xkRit3MEpJUHVTZEVs?=
 =?utf-8?B?UVNPdFIzYkUwc3BuWi9wcFAzeStyMmtsazM0SDFQbUQ1dU1VOW5tNnhvd2J3?=
 =?utf-8?B?WStnZlFhRFJFZEJZZ053b25hRWZXU3dWcWJmNXZNelUwNTdxRGUra3lPMmg4?=
 =?utf-8?B?UUpFWUdSZjM4eFdXMXZMVWhQN3RPT28wc1NEOFZpTGxrVHhwOUVHaGkycGJ2?=
 =?utf-8?B?MTZscWtqY3F5OUNFQStONzVab2JDMUtDd0preWNWSjh5T25nWDFCOVNUVm10?=
 =?utf-8?B?bTRiUHZJOEhSYU1kOWtLMzZDQTYwMUgzSWRGZnFqR1lTcDNPM1EzNGJvNjJW?=
 =?utf-8?B?OHhXM1NtYjNvVXBNYVlhVzJXYkgvYk0xM0luZ3FTRktocXUzNGV2NGcrdEk1?=
 =?utf-8?B?WmNsVkpxUkh1U3NiM0p0S1NHbXdqK2RWSWRYUWplK2YrdEUxRjQ2SU1JTTAv?=
 =?utf-8?B?dzc5UFJpdmFoa0RCV0pydTAvTU9RZG1ZNENZVW9DRm1QWVI4aW5pZDljZVNQ?=
 =?utf-8?B?NEptTWU0bUJoTGx4M0tvQ2xjQk51SzlJRHlFL3RsZ3lRbXpUelZuTlNEN0tW?=
 =?utf-8?B?dUVlUGFXRFdFU3VRVFE5TDZYV3IvZ1FTbVFOWmdzNlA4NnlFZ1Ywa1lRbDFZ?=
 =?utf-8?B?cUxJWWNQZUh0eUdreEttK0FSMGcyMHFYUkcxOVlWOERUck84M3RDZlNVYjFS?=
 =?utf-8?B?aU9YdVFnMm9IZDBZVzlpWDJSaTVBV0kyeTR6STBjUHIxSU0rS04vSWROckxw?=
 =?utf-8?B?MVFLNGNycWZIVkJlb1JzWjBXMVpRSzdtRzgwSmM3RjZHS1pobFFEK1UrNzRp?=
 =?utf-8?B?aUIvSWNQaHo2cVhPQVFEeDdJbk52L0REdW9PaFA3ZmNiL20xajFORnA1WHYx?=
 =?utf-8?B?QVgvemdmclZRY1h5R3BxKzF3Q2tucnNwMGZMWkNGbHpDSUpDbFIwNTFwdmtJ?=
 =?utf-8?B?Ukh3WE1UU2ExNU9LNTlIVXUxM0tIK0xpMHlUM2x3ZFFtR2kvSjJPdUJwNnh3?=
 =?utf-8?B?V2k5YnJ3SUR4QjJLRDlXRkl5aTZkSDlTbS9Ra04xVzUrTmduOWYxZGF4b1R6?=
 =?utf-8?B?aUFLLzV1S3Jhd1VwZEZRdGxDRVNLM0laV1RYd1JxcHB3bytobzJCYmhRampY?=
 =?utf-8?B?YjFldy91S203WE1TQ2hyVzVZaG9aNEJWcDVtbGtIYjM4cFUwOTNnZjY2bXVZ?=
 =?utf-8?B?b3hVWi9qa2x3a3Y4WGh5NzhsTU93WlFHNzJjaU1Ncjg4dDVNS2VhbnlOSXBx?=
 =?utf-8?B?SW93blNUZGhmTG1qRzljcTBZM3BTTkU4S3I0Z1VlTW52Q1lVS2lWTG5SeWpr?=
 =?utf-8?Q?yCxWKiRcZkHtI0bD5/dBuqOZl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a98744d6-048e-4c81-50b5-08dc3e29c2d4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 22:07:06.4905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0tjDDPSaPZ45LM9Hn9ZUnq7q8gwx4c4LpvlgzRdnjaVxaDk6jJ9Nv470NI+qsUIQwo5jhTMmoEYSHje6Q//ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7444
X-OriginatorOrg: intel.com



On 6/03/2024 3:02 pm, Sean Christopherson wrote:
> On Wed, Mar 06, 2024, Kai Huang wrote:
>>
>>
>> On 6/03/2024 1:38 pm, Sean Christopherson wrote:
>>> On Wed, Mar 06, 2024, Kai Huang wrote:
>>>>
>>>>
>>>> On 28/02/2024 3:41 pm, Sean Christopherson wrote:
>>>>> Prioritize private vs. shared gfn attribute checks above slot validity
>>>>> checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
>>>>> userspace if there is no memslot, but emulate accesses to the APIC access
>>>>> page even if the attributes mismatch.
>>>>
>>>> IMHO, it would be helpful to explicitly say that, in the later case (emulate
>>>> APIC access page) we still want to report MEMORY_FAULT error first (so that
>>>> userspace can have chance to fixup, IIUC) instead of emulating directly,
>>>> which will unlikely work.
>>>
>>> Hmm, it's not so much that emulating directly won't work, it's that KVM would be
>>> violating its ABI.  Emulating APIC accesses after userspace converted the APIC
>>> gfn to private would still work (I think), but KVM's ABI is that emulated MMIO
>>> is shared-only.
>>
>> But for (at least) TDX guest I recall we _CAN_ allow guest's MMIO to be
>> mapped as private, right?  The guest is supposed to get a #VE anyway?
> 
> Not really.  KVM can't _map_ emulated MMIO as private memory, because S-EPT
> entries can only point at convertible memory.  

Right.  I was talking about the MMIO mapping in the guest, which can be 
private I suppose.

KVM _could_ emulate in response
> to a !PRESENT EPT violation, but KVM is not going to do that.
> 
> https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com
> 

Right agreed KVM shouldn't "emulate" !PRESENT fault.

I am talking about this -- for TDX guest, if I recall correctly, for 
guest's MMIO gfn KVM still needs to get the EPT violation for the 
_first_ access, in which KVM can configure the EPT entry to make sure 
"suppress #VE" bit is cleared so the later accesses can trigger #VE 
directly.

I suppose this is still the way we want to implement?

I am afraid for this case, we will still see the MMIO GFN as private, 
while by default I believe the "guest memory attributes" for that MMIO 
GFN should be shared?  AFAICT, it seems the "guest memory attributes" 
code doesn't check whether a GFN is MMIO or truly RAM.

So I agree making KVM only "emulate" shared MMIO makes sense, and we 
need this patch to cover the APIC access page case.

Anyway:

Reviewed-by: Kai Huang <kai.huang@intel.com>

>> Perhaps I am missing something -- I apologize if this has already been
>> discussed.
>>
>>>
>>> FWIW, I doubt there's a legitmate use case for converting the APIC gfn to private,
>>> this is purely to ensure KVM has simple, consistent rules for how private vs.
>>> shared access work.
>>
>> Again I _think_ for TDX APIC gfn can be private?  IIUC virtualizing APIC is
>> done by the TDX module, which injects #VE to guest when emulation is
>> required.
> 
> It's a moot point for TDX, as x2APIC is mandatory.

Right.  My bad to mention.

