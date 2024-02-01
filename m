Return-Path: <kvm+bounces-7734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC54845BE6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54EB61F23527
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A2A626B2;
	Thu,  1 Feb 2024 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4tTTjy6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3906862166;
	Thu,  1 Feb 2024 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802183; cv=fail; b=TxBLC0q2tEUIgTmM5apw/48HYrKYv4ucQs1FxK8gzR7PjMcPHe280FSvJ30vgFPyUdT1CH/DM/64wPZAEHu0LYLvXmbTmqbwcV+aVbVGpY4Rs8i92Pf2aRoC6Id+0BAELhDHvpOMOPCCBZ5WLw7LgiRTr3O/3fSBOZJHEdYhkCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802183; c=relaxed/simple;
	bh=pYBXHk4FhzYGoVynTAOlux7FIkrvwDhTNhwvigUtc/M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MFef5RuJgvKzPfApnQqYg2PIYmodd7zUwrQP1QGyPrFtebiJTHyycYHe1Ro/741auMsPQ97nNCa5uGlie02xxVwk+3txL+xlIrP/oVdZkwP6rwp2PEVH7asHwaeMD5XuiqcbrgbUanBlGtBBXDLyJZr5vjMgpduZE5aBrgE04h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4tTTjy6; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802182; x=1738338182;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pYBXHk4FhzYGoVynTAOlux7FIkrvwDhTNhwvigUtc/M=;
  b=F4tTTjy6az1WiTtjudmcc2k9fRoneLyowAKJ78u0dtIwCqa8dZ9cK1I8
   M/PVHnUAqM2OQH3ov8WkAqDSbcrGy7bwr8Sh9DKv7VRzVXxZF+Es8Omo0
   fAP+D7hcWh314iCczSLVwMI4HsZAoPJMaA+f5emwPsG8Y9eH4vnO/LMut
   +tYEZF2E32iJbIPaI4QL/PkHQ8DMEgcnJAXHoqaTXq/fXmE/oiwAaDPFa
   z5DUwOjSLYH+FaBIuZgc6Hyk1YF+iLIj+kyAgr8kvh/GgS/wsbxIU3VJz
   N50Ccd+cVUTpr+6Qj2b2cCOeKSQkLb5Zmepx9RF7kLCzzQxbn2HutyO/y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="10672563"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="10672563"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:43:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="1119977011"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="1119977011"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Feb 2024 07:43:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 1 Feb 2024 07:43:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 1 Feb 2024 07:43:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 1 Feb 2024 07:43:00 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 1 Feb 2024 07:43:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMf5txv553LtjeQza9nTIynIlOVPmy2EsVGZvc2cSan33LGmibJe1+f7dLhS2dCh7vLCmKufIkvJckpRD+yj5Dy+TZFI9TeCGpgC9Kz1RX+QhF5MedLd44lqXabprhiDgZFwQ2wIFbP7YGrhEFMFdWBUV+Uephe0HYdPtmdpzzJWekvR46carPB6r5GjqQW90sui2vqF2HYWlYNwqYsNzdzEiB+op5+8noD4R9ItnMntdXAL706h6Qt3fBqh0vhdro68eatQTZg1/gR+PZr2ZzLTcnZR/sr1RITMC9JEltUz9fKa/VjyzHLjhI7sG8r6LGV/Gg6FwGDhuGjLCSfuXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YHz9RmunLIKKJOH9zNLWCFyVNbiIfHlgtELzWtrasY=;
 b=USE1Qedd+2sAEXNYXRnnn6MVl9XfVEZ/fRDgQQrP5NtlYl4VpW/8kBRGoVRMTyQadgYNv+Y9beVb7lbub4dCxuu23WP3w3F+olHxSllhgeoSjfJ+Dea1kypIBAWMpjgt2oLRiby0Jl/vF4EQ6BY4H6YUHKdjo64RtCB2CdtvWvSGmfnAXmBh5L80YS+I/CPZxXtnFEC88VRlaPAeJUXZl9RXkWObpnol6wqO2REyZoQmmL64n2q0JFy0VYiIO/AtGAq5zeVLeUdhWTfTTIzgdVZcn6ntJqvrrbtAfuzRFCNM7Q4v2Wv57T3oYLCgbs1UrZvZ/PjUBMfbAx9ThRZ4CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Thu, 1 Feb
 2024 15:42:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab%6]) with mapi id 15.20.7249.024; Thu, 1 Feb 2024
 15:42:57 +0000
Message-ID: <d2ff1f95-709b-4dbd-b0a0-639193f18c2c@intel.com>
Date: Thu, 1 Feb 2024 23:42:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] x86/cpu/intel: Detect TME keyid bits before
 setting MTRR mask registers
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill
 A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
	<x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <20240131230902.1867092-3-pbonzini@redhat.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240131230902.1867092-3-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL3PR11MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: b665365d-3522-42e2-5f5b-08dc233c766f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6VZsXNhYhxROD+Mvjbe7Qh1O7HAN0NITzW16g96+rZ4H8FIht9cGVXTGg7B7Zj2XeNsIcKp8yh7VjfPiGbbkZSwfeU3OFlFUqVqUfVtNIfszrDZvEpQBqfghTLDYQGUmC1gcWNYS4ldtdu0458voYfrjJd9FLuLNeykvSooZEKtSTJw6s9tnHeN5Ku4porRLBF9FkIlgVN74n/h1prEbbVWTb9vz1sdPBc38GDGVzH+Ta4vclXcPGBZIfRW6NfvZ5DjIZ9LEYaqEFGem81jzheulX99tXsaoPW+2rZK4YMieRyfC0zkN+6mge6OFKcCy0NMNzR23oEaN2H4f+q2FHwu7QuK4az/fWdN2iF3rNCAFSQ/fcWGZPrbvMFv7il07BfEsquNfvw6brVh+frZzYv6Xqmq0Xcxpu3EeWTzmCVWIQY+BpqK7Zv8Tu4IUD4qPXfR7MrNeU4DS7tBBYXXAbnsH3bvbiz7+TymPiiXri+VCHpY8MDn26nLWT1rXff3Mi/R1voRdnKTd1Sm9vlIv4U0ydNpw7THtN3HhmXo4/OV5Yc06rcT30OId2hYG4NcqXdH7EAowNm9aBJX9ootfjq2U7zBUW6H44rs30YWgkcIbu9P3eERyH7JVEdLKN5627ItOpCvQWQ35X3V2UJxMAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(6506007)(6512007)(4326008)(478600001)(5660300002)(7416002)(316002)(8676002)(6666004)(8936002)(2906002)(6486002)(26005)(66946007)(54906003)(38100700002)(66556008)(66476007)(4744005)(83380400001)(82960400001)(31686004)(2616005)(31696002)(86362001)(36756003)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3laRjZ2eFlsMDRiVmlxOHhvNjdPRGN4RTM1enplSFhFcUNra1ljNkNNMHJW?=
 =?utf-8?B?aklHcmM1VHI0WHh6T2ZUTEdvNmwyY1UrRUJENFEwR05rMWlXZ2JZU0hvV0Z3?=
 =?utf-8?B?TWQ2Q0VkcHpDR1I3K3pzLzlkbkowMU1OWDlFMXd6RWt6b1lpaXBPOW5hUk1t?=
 =?utf-8?B?clBoa1h6c1V5bjNDajZVT0RENnFlNFNNYXVKTnZtTzBoeFZnU3NLYndIZXZQ?=
 =?utf-8?B?eDFIZVB3OGFsR2kzY21xMEZ3NkxBdHczNGhJYytqSE0vNUZxTnpkK2ZFdlBo?=
 =?utf-8?B?cjhManIweUg4ZUNXNmhaVkpsWjhtMTRDdk0rOWhiSjlXdHVIM3BNTHB3ZUQv?=
 =?utf-8?B?cjVKaFpMaDMyWTh1WHJTaDdId0w4TVlvSVd0cVBkTmxBTllmSFhRM2czUEds?=
 =?utf-8?B?eHRzaUkwL2R4azRjYnEzbW9SSGFFZGRUeW45VFNtOWNMbkxHdGhzOVU5dVlK?=
 =?utf-8?B?WjVjQmhFNFF2a2djWjVkd3JaVUZkMm5MUjJkVlliSUwwT1ZpMCthdjFwS0Fr?=
 =?utf-8?B?UnBEZmxnMGJFcmEzK1k0TEpyTHpyUDR4MFcvVFNOK3htL2JrM1ovV0JHS3hG?=
 =?utf-8?B?Vk5kUTVHV2ZBRXpyb0pwK3ByQzdvOGhIeDN5MHBjcFU2WlBxZzNYSkR6d1Jo?=
 =?utf-8?B?RUpZenVjcTJvei8zVmVrczYxTGg2ZmlZc1k4ejVpT3dMV1pqVzlOSGdtdUJW?=
 =?utf-8?B?K0NyTFJ6YnJHcWJGSWpQdk80UnFPS2xORy9FemhsZVU2clpyelA2N3RPTElB?=
 =?utf-8?B?YS9FV1VZR2ZwbHAzTWJjaXJSTUd2ZnRVSG44VHh6THBHQzZHYi82TWl6NXdu?=
 =?utf-8?B?UHlxMU9qdTRRRXhNV0Fiem5aTDdNRUFpYUtPa3ZCSFR3VitYTHg3TS8yS2Fx?=
 =?utf-8?B?akNpdWtLZGJYUUQ3Y05KUTAzYnYwNHZ4VnBNRTltS05lNXBab2tPVE9SM05h?=
 =?utf-8?B?U01PRHRwV2R4RllEa25kM24vcTY2SDdpV1ZDY1FHU0FkUEVxK3ltd3FnMkN1?=
 =?utf-8?B?SThmdVkyYmc4YjdrVzFxRWlBandxeXRXRlVDOHJ6ek1WYndnaUk1STNpTFk5?=
 =?utf-8?B?NnEvNmFweVBLZzMxRGJrbzhaNkRsbHlnanE5VlhCVTRJaFkxV3pYNGhUT1RM?=
 =?utf-8?B?c3F6dWo5UTlVbHZNS2hyNEFqRUtYR0hrZkFrVWFwNklCSHFnYXJONGNXSU1m?=
 =?utf-8?B?ZzRaRkZpS0xVelQvakxCMnRCQ3lGTm12VG1oRHFSSDVla1IvdTNCTWFMNkds?=
 =?utf-8?B?V2xIb09hZmIrWFhaZ3VmZldUSE94NCszSnYvT3hwdk4ydmZTTS9LOFBvMU5J?=
 =?utf-8?B?S2F3UVY0ZGVURFg2U0thQ0FnNmhoT0QyS2VSNEVtWlN3R0Z1RytVaFhZM3hW?=
 =?utf-8?B?V2lOcFRUaWliWTdjb1ROYTlKcUJQNzNPSHd3N28xNkV3TTE2WXp1a0NyL0lG?=
 =?utf-8?B?bXBQZzdKa2gzME16UDd5bjh2WEF1am1rTytEVnZRZUs2ajk1a1VMRUpGUDF5?=
 =?utf-8?B?WFJzWTRvN2pZSER3cjdjMXJHYnRzSVkrY0xUekZFVzQwV2hzdUNMdlc4Slp4?=
 =?utf-8?B?MzhncXJIRnVqblVaUWpFb1VBNVl1dndqTFhReXlFQWgveTRDVkJ2V1NzSlp0?=
 =?utf-8?B?aDZmRS9DUHd4eldyTXpKcTJXcHI5K0lObDVaNjNCYklXS1VyK3pnVlhPb1RX?=
 =?utf-8?B?aU0rbVZHNk1TTnZWTE9md1ZxcGVJSkFOckxmc0J4eFNWU2xRUHZBc1drZ0lP?=
 =?utf-8?B?MDJRWU8wUDFiRkoxRjFjVFF0OFloMkxsL1BzNFZGSzJNUC92WFNMNDVwV044?=
 =?utf-8?B?YU9ITDRpWU5VcWxjMmcwQ29XMWYxOFhlY1BxOGEwL09LclF4RFJqd2ZYK3Vi?=
 =?utf-8?B?aEExOGc1U3Y5SVV3ckVTQUVVellQelFCa1dvL3hOK1pQUThpWU1waDAzZ1pm?=
 =?utf-8?B?cDdFejFqc0FEUkdkYU8yNGpiNDFvQ0NwKzZMbFM3M1NON0M4N05xQWV4M2R2?=
 =?utf-8?B?Z3QvRUlWRTBJRnM5ZlR6bWowRStBMFlJN0dXN3FEaWJQdzYvNUVXWHZCdlRk?=
 =?utf-8?B?RWU4U1JnY0lHTTYrZjhzeVdNTzM4b002NGpodms0K1lNZ3JtWnp1RURNejhO?=
 =?utf-8?Q?WX9FBw4F4iMlWbQiV0BDDo1id?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b665365d-3522-42e2-5f5b-08dc233c766f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 15:42:57.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29geP/Ifh+jUOtng0G40QUn7HcEpx6NlFo9Y2exa+YkoIbqJ7SaNKzXmal84sw4YrQ0aHNjAQd4KeJSJeMW68A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com


>   static void early_init_intel(struct cpuinfo_x86 *c)
>   {
>   	u64 misc_enable;
> @@ -322,6 +406,13 @@ static void early_init_intel(struct cpuinfo_x86 *c)
>   	 */
>   	if (detect_extended_topology_early(c) < 0)
>   		detect_ht_early(c);
> +
> +	/*
> +	 * Adjust the number of physical bits early because it affects the
> +	 * valid bits of the MTRR mask registers.
> +	 */
> +	if (cpu_has(c, X86_FEATURE_TME))
> +		detect_tme_early(c);
>   }
>   

early_init_intel() is also called by init_intel(), so IIUC for BSP 
detect_tme_early() will be called twice.

But this is no harm AFAICT, so:

Acked-by: Kai Huang <kai.huang@intel.com>

