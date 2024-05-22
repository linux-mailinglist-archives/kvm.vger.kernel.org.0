Return-Path: <kvm+bounces-17993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4360C8CC921
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637BC1C20EFF
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF2C14901E;
	Wed, 22 May 2024 22:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IapvNX/E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01FF146A8F;
	Wed, 22 May 2024 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417485; cv=fail; b=vAWv3erh14MPfPotUAQK9ePvwzmpInrUZzx0Ww24kOotON9Cfjleq7V2kRAMNIGb+CdcCYAXSIR+hDYilyIGuhNvzri+X5laD/Cna9bC+uBX+wClJzA+Th0bmS7psRf74RuEW33gAaF/sXrTtTltwqeExRcEpcmwrIPLlJHkliI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417485; c=relaxed/simple;
	bh=0WHMpuWaBkjyMHsHVgbH9CYkIhxeyDpSs1ImVEGB+SU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j+w3hroR2NbpoxOJGSx+suCoUCjm+qYDyBELGBFaFLWLQGotkmyrrYIAvmP6ut3yrM9e7wNKKjEqUbB63ggKVaHOmjFmh8+47YlAFKZu3FgkShkUwNdYNOqVpqyHEhROKIAQ3qT1vicZOoADQHYUI6jN/R4SbBYjMbdZrm0Npgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IapvNX/E; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716417483; x=1747953483;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0WHMpuWaBkjyMHsHVgbH9CYkIhxeyDpSs1ImVEGB+SU=;
  b=IapvNX/ElNJYJToy+DfjIuD/2X99bwlhCWy6LjTSB9NAYne7K1sunNFq
   LmfYwVabwTEfxmY6oaKJETlaNotu1K9G7qDuA+jb1WLEzlYast9dQC4Nz
   x1GjOz20fW25XgFqZ9Off0np/stJ9k1tJjFjlOUVHwnInve8km25dCemN
   gsmcthb2a0SCQgx1ed8zewjkYo2C2uiLXEsIfEgf+mPHhQcIG7EqI0qa9
   OmWg30x0ROvd2Pc2XEpI+QFub3jr1Kfc9O+cg4GIlWBUyhiuJ7pqfUjON
   5yNa2Z/ecM/YudQgihegRQVpFnNyvA+7OxrSVqgvyutPg0HKGT0i4YyXy
   g==;
X-CSE-ConnectionGUID: pVLG2lxQSAOTNkwRmDp+fg==
X-CSE-MsgGUID: yB+M2a8IT3amuk7ziLQknQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35212810"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35212810"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:38:00 -0700
X-CSE-ConnectionGUID: NwD7HjLBQKO18bvAiY7rGQ==
X-CSE-MsgGUID: bPZIZS8iSCahQDNQVh9T1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38418269"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 15:38:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:38:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 15:38:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 15:37:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md9nwzSqTks6jTu8EStTqu1gCK5o/+ImRLmWczvyzejA4IKiUo5TiTjzPcLwGQ+ea+4OQwSlBFw2GLxjpPVUM7+yp0S37z/ZKyH1gj8K4Lq2PdOOt8W1nnnLLOtSJfL2K/0jYUg5DQ72aLJeSN6UiRqSDeAD6hIGlC+i6AfZs9iduI19DFn7JR5ai/7dEx1Hz825DNnhqtxE9j+4xdlGBqIPohAulVmJszx6Po83PPIiLcpggitf8v/pqapHEBrXyygb0kZMTdzL9qvJIIcRhk3fdjoYC5Q+BZ60F7tJclwiCiJbJ+1loYNZWMH8i5sBe2WOW5a9xCeA4c0MWH3vLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDAsEm2EADVFxLcmw4b3eVjPwTCqiUYnIsAUwnFqM6c=;
 b=jDYdLccXx0CIbleZxDJ1zckYwbbwgGUautUAOQhC271b/1zuu8r0g9r/3jPNZ2U1YAtbJNb0NadjimhQ+whHj713AMDaYVI8M6MGV7u9qN733w88D38nvJQF9vKhiPbDjI8O+jWpYIBtdrgJza2LzXuFK1Ht6H/wfmIvW0az3Et7wWYkVIWgKCmp7wvNrkxN7dDapg7oxwuvYRMMPboaU4yNe9mrdTcrgCsolgCUghqwu33XB9eobZI4Zh3GkZzA/g+duz0JDaJ78zM3c0h30eYlkvAXJpq5c0qtG7MtnieJ2iGOdP32cbLN2my0AlHpQ7g2m8GqQVpfSyG8uceYLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Wed, 22 May
 2024 22:37:58 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 22:37:57 +0000
Message-ID: <4b39f27c-bfb7-412b-85b7-e05b0d27c320@intel.com>
Date: Thu, 23 May 2024 10:37:51 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] KVM: x86: Register "emergency disable" callbacks
 when virt is enabled
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-7-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240522022827.1690416-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0085.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::26) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|MN2PR11MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: 783a40a0-5258-4a2e-07a0-08dc7aafd3e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RnZjdHA4OXVFK3JjVlprMmtRaDZZeTRVTXRlMDkvSUx1ZTYwK3M1V1FzZ1hu?=
 =?utf-8?B?ejJyUSs2SlpEMGtkZUN2RGFEa2NuUEZqSjY1N2hwR0NmUnl0cXRJQ1RqYUMx?=
 =?utf-8?B?aU44bnVWZFVvaTkxNVl6cC9saEpIbk5GMW91QXh0eDEvSmNKOStHWHY4VStD?=
 =?utf-8?B?MXA2VDNLT3pFbmRZc3N2V3ZkRlh5TWp0Y0hWc0ZmRnFja1RlNkIzUjB4VExZ?=
 =?utf-8?B?RVlxSUJObDFyRGxtT0pFcVVZWnkxVjViK1pXTHNZOWFiVjFyRlBrMnlZbG5x?=
 =?utf-8?B?cm5NM0lSTUxZRk1mYXBKSmdxNDgrNll6M2FkdlQxOGxzcVZnS0ZDeDlWTnYy?=
 =?utf-8?B?ekhURXVBOTlmYXZXYlhKZEY5RTBNd00xQlpBSkkwYkN0MXlkU0N0VStnWmVQ?=
 =?utf-8?B?aVNlSXZPV3JmQnpoWTZneTdSMXJmVG1Za0hUQiswcUtteGNRVlJwVzVLa2hl?=
 =?utf-8?B?SEFsdUR2T0VKNE5rb3JWM2NmNGdWQnRsbU05K1NuUTlhVGF5MUtLNlQ0RkU1?=
 =?utf-8?B?ajV6YWFwT3Q1UXBwbUJlQ0NoZWJ5U0NVbndtZnZRSitndFkyU0RzbGhVSXdW?=
 =?utf-8?B?M3E5U0lsdnhQdVVIMmtUQ2FIaFhMODMyZ09lczNhcDUrSU92U2c3SGNtUTZQ?=
 =?utf-8?B?ZDYzYmpRd1JyWkRrdlI0RXE0OEFUQVk5ME5FcmRxRjF3Q0VIQmFWVUtOeWow?=
 =?utf-8?B?R1ZqMGR0Y1BvNzMweVBvTTJQZmd3UVFuVXNBcGFJN1dZZmxacjIyQllJTTAr?=
 =?utf-8?B?eUdnQWJJMEEyaTlEQVloeGUra0Nod0ZGdFRhMmhNZ01TdW5TRWNJaXc3OXhz?=
 =?utf-8?B?N0NNeUdZWWVPdkpMd04yNWFXbVVpeitqOGFYS2Z1WVF3MmtvTE9oeE9kbjhm?=
 =?utf-8?B?QXl6QUJsRkJXQVVFL0wyQStLbjRuSW8wR1RWYmJoSEkxN2IwQ3RWOFBhczEy?=
 =?utf-8?B?OWxITElzVVp0UThGME01TEdEMmhYTzdIWXZIbzJINkRncHI4RXBxem9pL2R3?=
 =?utf-8?B?eW5Db0JwcnFIc2RlQlpDNGtlcHptdXlmWUxUWTl0ZFpIOWhpOTZpZDc2Qm4z?=
 =?utf-8?B?SVNnclZIb3Z6dzlVY2F3N2VicEFMSVQ5SUFoZnBPWDlKM0YybVQvUnB4UUdz?=
 =?utf-8?B?SGk5b2dJSFl2QXFZRFU2bHgyd0xhc1B0aFl2SEw1Snd5U2htS0xBZ1JHRWRt?=
 =?utf-8?B?SWs1U2tPWXkzQ0szcWJFc09adU9zdW5kL01XRXdxUm0vMGVDTXg2YjlKK25r?=
 =?utf-8?B?aGtGemNGcEs2RFNEM0Nlcm8rdzFDOVMwMlhPUWx3WXhuUjNHVkl1STlVSTRD?=
 =?utf-8?B?NVlhVExzbklmVlI5MWxVN0orYWZGRWF6d0ZFV1FTTWdseVNqM0xnR3hDdUVx?=
 =?utf-8?B?MTlUK0JBdlNEVEtNdzlxczlKK0hBZHNpSTZxdEVKV2F1K2s5NmR4RVd1aHNP?=
 =?utf-8?B?UnBnMGs0RGFNeWVEdTlaNXg5bVJGQjB5WnVCSG1uV3l4d09rK2NObFA2bzJE?=
 =?utf-8?B?R2M0U0U3TVY3MnphREpUR2w5NllzdzBEQ0dQMTVOYm1MdnZjS0J3RnRHRG5s?=
 =?utf-8?B?REcvNi9JRk42bklQVHp5MS95UVZQYWhwcW1xd1lyOTlBWlNPTUtYSGFxTVIv?=
 =?utf-8?B?SnlBQTBNbVJFKy9ERWJoNTJnKytFN1lMKzNXQXV3VThYNzNSMVYyY21aVU95?=
 =?utf-8?B?eHhTSGxXK3ZPbzd3SkRxdUNXRWtDdDNmUHFOaXJob3RreVRRNUJhZHRRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aldEUjRQTTB4cmxLRXBxTS9NVjRIWnBnbTJGcE56eEJESm5uME1OeWpzcmlY?=
 =?utf-8?B?dDVEZzY0TllTeFNGYlhnbzhCUHREQjhJQkU1dnh0VldHN3BtRkhWdTZDcWkw?=
 =?utf-8?B?Y05CdTBrRGVQWE80cVdicTdUZU9iN1VVWTgvam5yL3k2c0xMMGJzZUprWXcw?=
 =?utf-8?B?UXJhaGZCaVA0WTk1K3g1bUJTR2YwSEZGcmxLM3pYUzdBM3g0R3drRDVSY21Z?=
 =?utf-8?B?bGdtbE1XMXlNRW9ydm5WYWYxLzhnQW45cjcvUmNEdFcwalZGOUpWS2o2RUR0?=
 =?utf-8?B?RFhueWo2c3kvc2sxQ0wva3Y4cElHVUJBR3NwSXkzSGl1dk1LUDkvWm51MzU5?=
 =?utf-8?B?U3k1d0ZRMFpRTXVOeDhtNGdBT1N4Y3FxMXg1WFhzSnhtb2pVQWU2ZTBkMUxp?=
 =?utf-8?B?V1dCVmk2WEpkVHllcHlrWDdmdHlsbzhsL01WNHBmTWlLampYd0xlbGw1L2xE?=
 =?utf-8?B?cDB5R0dvbEJqTCt4R1V0bXdtOW5udStZSkMwSzJUNG1MWmZhRTcwT0o0UzdV?=
 =?utf-8?B?SHlvM0tYeTJmNWw2S1c3WEs3SVROdHV3M3QzSXZyU0R6eEE5YnlOMk81amJT?=
 =?utf-8?B?UmpOTTd2UjI1aWVybTV0VWdWMklrcFN1ZGIvak1jSVljUTVCcUVmd0VidVp1?=
 =?utf-8?B?NXVwNjVqNGRXYldQUmtmVmZpUEwvYURaVUNybGJ2TXRDVGlvdElkZnpsekVE?=
 =?utf-8?B?ak1vdU9ENVdsSmpnTEw4RGpqUU95cUZScG10cGxiWVQvblNCZS83MnhpOU13?=
 =?utf-8?B?RjZGK0NxM01DTlFndmtJMmhDdjZtcXFVR0phVWMrSzN4bGJvenZ3ZzNqSEMz?=
 =?utf-8?B?U3FWODhZWHlGUDFQbEt2Y3FSMys3Zm5uc1EzdEdlUGNjSURyYTNFN1RGdFov?=
 =?utf-8?B?eDBaTkg5Tlg5VGNqb1g2N0RjRVNYNDJlc2FrbVhwK2hIYkwrSkhTeExXZmlW?=
 =?utf-8?B?VmRyQTdYbmlqNnZBRTd6Tm9wOEdFVlM3UGV3TE9QakIydnlYd3RhM2tuWFp6?=
 =?utf-8?B?OVRxd2hjbTU4RGpEN01KWGh1RVQrNkczU09MVzIvVlBPdUNyRWlFaERPWnY4?=
 =?utf-8?B?Vmo5eWY0ME1WYldWNHZCUm5vazBkYUtKbDRNTERsbGMyMEY3K3pxTVYxbk5m?=
 =?utf-8?B?T3I5SUZUQldpMCtHMHVDd2hNM1Nma1ZkSkliSldsWjIyRmJDeGswZzRsaFBW?=
 =?utf-8?B?dVBvekJUcEpTYS8rdCtWTm1BOHV3dXpmRlc4S25yMTBUSExUc0h0aEM2OFB0?=
 =?utf-8?B?UCtmV0RnRlZVazZSWnh5ZjNtS2c4cmhoR25sem5mNDNZaUdISW0xS2QzdUt3?=
 =?utf-8?B?dlgyYlpKZGpyU1BmS0c5OUdqMXE5THR0OUI5bmRtQllQMGxDdFUzVHJBV21o?=
 =?utf-8?B?alV6eXI3VThUSE1yRFd6UmRhNGhVdzhiNFhvMjJXRFZnUENyR3lWa1pUSUho?=
 =?utf-8?B?dGh3QVpiNmZrKzVFRG40clI5T1VRRnB0bytwSVpOME1jMlgxUm95TXBPcHJF?=
 =?utf-8?B?RXpwTnZIQmcvemo4c0xGSGhibUM3YVd6bmhoUGF4TEJUN0QvVVVsTjFhUHY0?=
 =?utf-8?B?QW5yTVJsWk5JNlhJaTJ5clE3NmdHNE82cUJkcHdvNUkyUkJ4a0h1U1FrSWVt?=
 =?utf-8?B?dHY5ekl4SmxmemJXaXFWMnFtVXRhM2V4c0lidktkQU05dU5LMk5kZ0FFVnpK?=
 =?utf-8?B?R3dmOGppRFl1Z0RJeHY5SDRsN2U5bHl3Z05XbURKNHlhenhRcVVvTGVGS1h2?=
 =?utf-8?B?UjdhMWE5ZjljNlV5ZzFzN3JxU05wdmdKNDV3TzBrbHBTSHVsOCtQeUg4enQ2?=
 =?utf-8?B?QVhOMXVUSzVHT00xTEgxL3JCcFdkZFd4cjhjc0V0b1BvbGNGNC9Zd0lLYkVa?=
 =?utf-8?B?ZncvL3U2aDdib0kwRWlDelRHQ2t5aUVHb0ErSmV3anRtTUkrbkdrcXdyWFho?=
 =?utf-8?B?clJVT2s3RmJ0Vy9pTjQ0akVZdUkrd1V0YlBHanVWa2doSURmMUtTMXp1QmdZ?=
 =?utf-8?B?WnkxNmdEbDR0M05HakFtcFl6K3YyUmVXZFVVRERaQk9VaEVGYnVETGpMODAv?=
 =?utf-8?B?OTh5NC91SFJ1NHBmclhYY0JaeGhkaUlxa2IrbEVUeUJVLzBwMmtzQjYrYW4z?=
 =?utf-8?Q?gs0F0S9mDwqId60B3Mtlxwq/g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 783a40a0-5258-4a2e-07a0-08dc7aafd3e1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 22:37:57.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEqssyWa2mlMMXhZ3HaQiXhwNUdcPW2YLd64EUIHn9BC2urzMiA9qpA2cpuuDe1FEC0NymvClGxPQH/3ljnIEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: intel.com



On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> Register the "disable virtualization in an emergency" callback just
> before KVM enables virtualization in hardware, as there is no functional
> need to keep the callbacks registered while KVM happens to be loaded, but
> is inactive, i.e. if KVM hasn't enabled virtualization.
> 
> Note, unregistering the callback every time the last VM is destroyed could
> have measurable latency due to the synchronize_rcu() needed to ensure all
> references to the callback are dropped before KVM is unloaded.  But the
> latency should be a small fraction of the total latency of disabling
> virtualization across all CPUs, and userspace can set enable_virt_at_load
> to completely eliminate the runtime overhead.
> 
> Add a pointer in kvm_x86_ops to allow vendor code to provide its callback.
> There is no reason to force vendor code to do the registration, and either
> way KVM would need a new kvm_x86_ops hook.
> 
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Kai Huang <kai.huang@intel.com>

