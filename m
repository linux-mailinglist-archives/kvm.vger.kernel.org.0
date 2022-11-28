Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23A363A8F5
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiK1NKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiK1NJ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:09:57 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E2E1B78B
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 05:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669640995; x=1701176995;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O11pzrWjdikgGbSzogrfb4uJL2wEH7BE1ZV8KHlK83c=;
  b=jkyovlkn1PY6WgLjB0qfD2YEm54dysL73L2lKiCLo4SVK9OzMuEQ/UIM
   uGn0ABFDr9FqbEwifBpQi5wxtyvezzpwjFnOrv6dvhkjYh85DCuPodO8G
   pGRCnRvBG5siC70E1uYpn/yfA330VpBS2EFMUSnxaDb9Mp/PjZ2sOj8wm
   KvHMveZ5AzSkzNYujT2l6vOABAKiDdXC9ST3KzVIJvlqtew/No3DAbK88
   dK2jhl5gSJqRRDdTmNfsjUSUgHUzaQQHnXAViNialCoGTZzE9mizYzGkl
   ZCon8PKAS38C/CmB7B/HajLcFfTqEj7+F7VC7xVTF+0iF7LOyKKdYUtyu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="302404731"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="302404731"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 05:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="676038033"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="676038033"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 28 Nov 2022 05:09:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 05:09:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 05:09:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 05:09:53 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 05:09:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOTmt57gCO+j+MG7RbVxX69bUMblcNz3s0XbCqEW7KDoen9KAzkiCVxuUI4tjXiXX+MYmJhOMRYOx/5P3ZZX2CwWwDAirha7vRaxkp1s/FMDu3OmAR8xM/hBA9gVJdMSV/747VnpS66K1pTlVsry/GZH5T1dsRx9nvfPWeKX4vwxlpeKsfx/jZp/bHjWHFXNJSkR/r+RRyF4ORAqslI8Pj2a7KTI3fs/d1yyobyf+Uqx4tayg8D8goh5EXUjEhv8JLGq19qFPNbaGIyW82lHexMCgMP5t1oA0ALC3x8sETan5fhbXoQKKVKawq+vuKve6oaHN1N8eI4tsdH9eAo/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mHuge3sV2kUtWmF9QCCdDonCcOnrahMJAVHu4mXdlGk=;
 b=i9ghA52PSovLCTM3vOWcl6YEaW9qGNTrppRtXs0lNqZHkcSUGVg65n/UU+iQlKPwOB3qsdFlNnBpCxGeFfKuqDfeBjP3ra3M0ayvTC/CaxnmrR5r21DWFkRd9nhsW5UfQRAtvg9Dj3jLgy4XtEaTUox0onAF0wwt317PLl4aB2L04hvDa91lcz873AB8oPKbyfS/AMnCoyBLDe27dL1Nib36dyjfxqgZG8K1OurOf2EkKAIKBWi46L6n/eGlNUqnZ1eFNfx7qwtndekdxpT+WNePaaJ1MFFvZpouhxDBGk8vKWXIfZm5jEywfjOEZH6ZusIBrjHAwLonamIkumbcWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6886.namprd11.prod.outlook.com (2603:10b6:303:224::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 13:09:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 13:09:49 +0000
Message-ID: <de97235a-8332-aa0c-ecbc-5d153c9271df@intel.com>
Date:   Mon, 28 Nov 2022 21:10:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and
 gvt_cache_init() into init
Content-Language: en-US
To:     "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-2-yi.l.liu@intel.com>
 <9634490f-d100-5a08-013f-439218a4232a@intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <9634490f-d100-5a08-013f-439218a4232a@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MW4PR11MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: f705de22-cf84-47f3-2239-08dad141d460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMkewLTNl28e0C4GKjeKCIW6jxWXMy2A1Nm6H1knnbx1D2rkxk31Zg5qrhmVmSu/ND1Z8BCqSKiWMMUaais8FjWH5XJwtKPCSLf5BvOevO4NyLlLlnUv/oNpX/E6kI3eWRbBhDA6ZOSaqlbYQiTchg7hpAUGovjMZgmQjB1OPcvPx4jIu1oXbZaWvowsSVHO6EgW7OxetCMxFivWNPTph0zTMIbZOVTGy4LcLTTGDLcj7NGz349dxvxoWtqqXPfuAMnLBbJM+0Co8Y4KPsEFLPjpKkusOoAbXJarSi5vgefE469nUc/cbf6680umBjfQbiSAMlNNh3eaRTFdvgCiwti9a7Pu7S1xrtHQcDYP4Tu+B/P6Ll+4deo90DrDm4xrbzF+qLcFkUMGscUd/OZg1hKFuXL3Xfaq0TX4Qc8imyfu7/LbAycmOwYL9qDUKUOUtf8oDN0HgAsiEH+do/Pwt1Ps6hQHeNLARfe+V6jJQtPOaf1VuYbVzoKALPhAlWdPvATlB3yTsyPqq9SganJR5jogEiNWpS+oCzQvS4IN6cP6pBRGJfV4ncPtfPfEuKzTsbjfn57Qbzd6NMoZmtF67pQG5oxY+0pDqVkkvJAnfZTB0TY8v6GveODcHFrAfXqnH440l5exFsknYuJG34ATuhaqCySsJdCXtQnVrQldCV5vPcoCIceedNWFCDHIp5K99Vi6NmY3s2XjOh40IDrXhfyAdXzy4X7RZjsIRLsEbPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(316002)(36756003)(6486002)(83380400001)(54906003)(110136005)(2616005)(186003)(31696002)(2906002)(86362001)(41300700001)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(38100700002)(82960400001)(5660300002)(53546011)(26005)(6666004)(6512007)(6506007)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0d5b1pOUlAzMS83QkhqakxIOFllZ1Jud04rMHYvMytCcHdHVHF3bUJRdTBr?=
 =?utf-8?B?MVlPQk1aQXcvSkxnbFpWZC9DUVNXZjB2SXNzeUpTMXZYSmhWaDBiT0QrbmxC?=
 =?utf-8?B?UkpCcDNBOUMvNm1RZVB4dTByUi9OZXVWeGpPUEhpV0M0TnlZdHc1Q0RveUlZ?=
 =?utf-8?B?WnlUNjc1a1RudFBSWE1jM005SzlCOEVadDZyai9tZlNPUmFMNUFmVTRULzdn?=
 =?utf-8?B?NEZOTFBPK2ZyMUdhb0s5RlJKaCtMdjdQMWMxSnR0THlETHpaaFBWZS95MVFY?=
 =?utf-8?B?UTlGWDlEVWZhVFJxTFZnTUVPSThDK0RSTFdhLzBtZ2JyTHNSUnhEY0doNVc2?=
 =?utf-8?B?K0hrUE5GbW9HTWRlWlNVek4rTDhHWnQ2UjlPcU02TDFOUEFoSzhpRDk1MExB?=
 =?utf-8?B?OVVHZk05SGdmRE5jU3Z1dk9Yb3pQMlZYM2F2OXJOTXZCckJZTHZzWE1RYnAr?=
 =?utf-8?B?Z1ZqQzRSdFJlTXBwcldVakhGWGdnOXBGaEl0U2dhSngyQmhCbXRrczEvdnVT?=
 =?utf-8?B?SEpGdXZmREtqRVRZUTVPNmVPNi9kV2ZZbTNWS3NEdENub2JTejJmVGdTWGQz?=
 =?utf-8?B?dWNuZlAyMU1FWjlWSEdmZ1pJV3BzejZtaHJNb0xZbkdLNDNUemhNOFZ4dlBZ?=
 =?utf-8?B?RzA2cVdscXFaMkNueitaVTJwUUN5UWw4d2YvemFmZDZiSi90VUttWkZnSmNB?=
 =?utf-8?B?VkcraGQwZEFsb0pMbWV0c05RUDVqV1daYWtMK2FLcnBvVlJqK09NclczZjFz?=
 =?utf-8?B?VTh4V2xZY1hjY2VyRWVaSDkxOWpJOWF3ZmhkMVErSnl0VXB2dUJWNCtKUjNs?=
 =?utf-8?B?VEdaMUl0d2ZJUEk4SHdsc1BFa3dJdGlSR0I4cEJyaXltUXJxMDFGelk4R0VF?=
 =?utf-8?B?MDlzM3p5dTZyVGVXa0JQMGpvTEgvekdJaFNMaC9SSm1ualFBZ2E0eFdCODhG?=
 =?utf-8?B?OWlCUW5MVGhjREkycEdlK3FVK21vUzEyODBTWUlCSjh4VXFLZVp1VUV6YWNR?=
 =?utf-8?B?QTc2OTIrNGJIckpYUFJ3U3kxZndQbnQxMU9rNmQ2TWREQTF6Ly9vdTJmcGp0?=
 =?utf-8?B?QTBMUVltUG9EOThpNTdrN05WUzJTeFl3K3ZBdGtOYy94emNqSXM0SHVKem9N?=
 =?utf-8?B?VDBRY2d3R1RXYmZTV2hGeEJFTUZKSk1BOUk1Q1MwWXhreCsrQ0VtR0R1TVp6?=
 =?utf-8?B?cW5hODF1cDZhRFRuN01SNExPZXBiYy9VN011WnhtdngwM0JuS1BFR2JuTTFK?=
 =?utf-8?B?WDRzM05YMWRmT1lwNmFrSU43NS8ydmRVeEh2Qjdtb1lDU2UyTWNSWFU4Mmp6?=
 =?utf-8?B?MHdJdHNUSEN3TFRXVGNNc2FCaDl6NlpXQmlKQ2t3OGRBZ081VkpjL3ZVd2hk?=
 =?utf-8?B?azhEclNMb0J5NmJZNE5KSEM2WmlHM2xKUTlObU1adVpBQi9nNitWbS9nZnZj?=
 =?utf-8?B?d3ZVTFdTSFNXMEpVSFFpTmpsUzFjM3pFZENPSzF0Z1JORzBoZXBJbFFWc3dB?=
 =?utf-8?B?SFVSWndkaGRjc2E3cURaelZFbHVGa0lITEJLZG9wUkN0V3ZLZHVIQURha3Jw?=
 =?utf-8?B?aUt1TGluYnR2OWJkYlRBYS90UzZFNE5ZS2Zwb2lqVVhMYzRxeHpkcGZnWGlw?=
 =?utf-8?B?MTNnWHFxamd5ZGt6dG5yeUxSUFBrQTZkbWZPWC9ySHJ4VENHeDkxK0s1SW1F?=
 =?utf-8?B?NEVLMnFDQ0JTZllXdTdURHFMSWFqZEsxbHRBMlloRzNRR1pqMDVDRW9SNndu?=
 =?utf-8?B?SzBhZEhlTXdjQlh6QlVKVG52Y3Iwc1JrZ0t3TFBBOUloc0ViNFJIVDU5Rno2?=
 =?utf-8?B?eUVBQzJsWWVMNE5CNlB4YVYxclR1YXZTRG1CNGQ0RE9TNWJUL1ZKcGxnT0lU?=
 =?utf-8?B?enU1b2ZUZy9KVWNFaHhhb01EK3JFNE41dFZ2bXpaTHlrWU1Jd1R0U0Jqanhx?=
 =?utf-8?B?TU9BU3pMUGtNdXBYRi95MHJFeG9oOUVTQ0xtNWhVSTRhdldRTGI3Zm5YU0pu?=
 =?utf-8?B?YiswWDBVSndzdWRYeUxYK1V2am01V2tTVllaQTl4dlM3SFpSNHU1KzYwZ0Nw?=
 =?utf-8?B?V25nM3d6NGFRRk96RWdMbFBSMWp1N2tYUHhQcnc2RUZiWGt6bldDSUZ3dFdN?=
 =?utf-8?Q?hFQD1aSgzg2CZw8R7GRa5TWEw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f705de22-cf84-47f3-2239-08dad141d460
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 13:09:49.5464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0chBTUJ+EjqYv9pceJDivUfwZMKG3K9S1sAk/T+mDcBFvSnnslzycbuuNqA2+7WoLnl2GkwhDw5ZAGe/csaogQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6886
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 18:22, Wang, Zhi A wrote:
> On 11/23/22 13:48, Liu, Yi L wrote:
>> vfio_iommufd_bind() creates an access which has an unmap callback, which
>> can be called immediately. So dma_unmap() callback should tolerate the
>> unmaps that come before the emulated device is opened.
> 
> After reading code on Jason's tree, I think it would be nice to document
> 
> the requirements for a vfio driver somewhere, like what they must do and
> 
> must not do in the callbacks of vfio_device_ops. maybe in include/linux/vfio.h?

yes. maybe vfio.rst. Altough I found it is out of date. I've got one fix
and may send out later.

>> To achieve above, move the protect_table_init and gvt_cache_init into the
>> init op which is supposed to be triggered prior to the open_device() op.
>>
>> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
>> Cc: Zhi Wang <zhi.a.wang@intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
>>   drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
>>   drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
>>   3 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
>> index dbf8d7470b2c..a3a7e16078ba 100644
>> --- a/drivers/gpu/drm/i915/gvt/gvt.h
>> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
>> @@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu *vgpu);
>>   void intel_gvt_debugfs_init(struct intel_gvt *gvt);
>>   void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
>>   
>> +void gvt_cache_init(struct intel_vgpu *vgpu);
>> +void kvmgt_protect_table_init(struct intel_vgpu *info);
>>   int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
>>   int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
>>   int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t dma_addr);
>> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> index 579b230a0f58..cb21b1ba4162 100644
>> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
>> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
>> @@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *vgpu)
>>   	}
>>   }
>>   
>> -static void gvt_cache_init(struct intel_vgpu *vgpu)
>> +void gvt_cache_init(struct intel_vgpu *vgpu)
>>   {
>>   	vgpu->gfn_cache = RB_ROOT;
>>   	vgpu->dma_addr_cache = RB_ROOT;
>> @@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgpu)
>>   	mutex_init(&vgpu->cache_lock);
>>   }
>>   
>> -static void kvmgt_protect_table_init(struct intel_vgpu *info)
>> +void kvmgt_protect_table_init(struct intel_vgpu *info)
>>   {
>>   	hash_init(info->ptable);
>>   }
>> @@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>>   
>>   	vgpu->attached = true;
>>   
>> -	kvmgt_protect_table_init(vgpu);
>> -	gvt_cache_init(vgpu);
>> -
>>   	vgpu->track_node.track_write = kvmgt_page_track_write;
>>   	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
>>   	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>> diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
>> index 56c71474008a..036e1a72a26b 100644
>> --- a/drivers/gpu/drm/i915/gvt/vgpu.c
>> +++ b/drivers/gpu/drm/i915/gvt/vgpu.c
>> @@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
>>   
>>   	intel_gvt_update_reg_whitelist(vgpu);
>>   	mutex_unlock(&gvt->lock);
>> +	kvmgt_protect_table_init(vgpu);
>> +	gvt_cache_init(vgpu);
> 
> It would be nice that you can still keep the initialization in the kvmgt.c as they are

ok, so I'll leave the function implementation in kvmgt.c.

> kvmgt related.
> 
> With the changes above: Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>

thanks. :-)

>>   	return 0;
>>   
>>   out_clean_sched_policy:

-- 
Regards,
Yi Liu
