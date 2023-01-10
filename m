Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A7F664CC8
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 20:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjAJTs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 14:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbjAJTs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 14:48:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A4B5CF80;
        Tue, 10 Jan 2023 11:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673380134; x=1704916134;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=FaMWxsiSCtg1+ytIef/isrEbEszKNR5t55HP135BSXg=;
  b=mAnYXWDv3mXS18Eb08cj7mr7xcX8KdoeWn5y96wDm+btlzS5ovx0iBVM
   pnnJEHvm1JyXaiMeYBYwI62UL6dHSLRrd3KYoF2/Yk3+Ws0dTijOZoqFQ
   0szQZ7F7OmZ/wa2RFL7xvlFxpTgDPn16tBSDCy+M6wFL+YTMUf+TxMufM
   z4nIBdn765pGDclYkLCJJYIk0AVeMpuNJXECEKO/Sc+vEB4Q/8jDnB+Fh
   nRayHdorUM0hpotfdPB/6PKyBGqpnSdzBs8wcLY20/K5xdaLmymB05HJ6
   zGf9Chnz+GyZAKa8lYNDdYN3RG6q15o10oyj/wN5TdLiyhNdbYpI40Nqs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="409479570"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="409479570"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 11:48:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="725658284"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="725658284"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 10 Jan 2023 11:48:53 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 11:48:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 11:48:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 11:48:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 11:48:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7GGmxcFRG8vcsO4nfcZ/tdBsDvEA0pAkr9quj1lCJYjdKYK8htY7h0I4HriZIpsWBUUPE/VDQ0CFFewu80OT8xkWTgREW00lzaM74LwQS2gM/xtAKo3ZPs4TO6xcJB6rmAt8k4QXq+mem+4u5PU1fcD80NrxuvwpZmKoLvoCl2yJSwVQaVRjNBQlCSVzbwYJ2AUiWzj4Md3YkWFSJHVWWoUNmIUpHJ7TiyWBGlQtQeztBJEGyxkXQUF53kyl/0s8+Jlnh6f5vqPvq/2GzY7FAm8aeui8oCObFCMLa3EWhwZI37rsma5CveE7NqeULDSfA91Grjz2fIhmDPtGFJhkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6+tGMmN8WJKGtquW/bv2Uj/VqP3de05qL+LDhPa5iM=;
 b=DyDS275Q8YXY0h9bv4/3gYm2FMfn3vMqaCF3hA5+SpDqGUgeo71eW00IapogQFBCttUyRVHYY3EeSs6DadNU9wyLhQv4gCFbC+XOEihbVfVhMLSMdXy6RyPLcLrK7JspQ4Cc5GkgDu6r7E+tbpClNPPkEdWfSkdRFcmSol2jzkCpe6XuFhSHP9KxOdMzFHtOtjnxb9asgmxeGhuqTYOkxkgZ1z+lHCGfk4YJE3TqNWGIuhP/SehE/6Ad7IhJICrXcqtYCR9NxWZ/cfaBCZ890k3pXLYGKTl9WnmMBSh744rnCKJztMz7rqq4liFwRDSHzcXTMbcucXyWdhaA5LVQGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 19:48:43 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::6566:25b5:89ba:e209]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::6566:25b5:89ba:e209%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 19:48:43 +0000
Message-ID: <66857084-fbed-3e9a-ed2c-7167010cbad9@intel.com>
Date:   Tue, 10 Jan 2023 11:48:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/7] Enable LASS (Linear Address space Separation)
Content-Language: en-US
To:     Yian Chen <yian.chen@intel.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ravi Shankar <ravi.v.shankar@intel.com>,
        "Tony Luck" <tony.luck@intel.com>, Paul Lai <paul.c.lai@intel.com>,
        <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-mm@kvack.org>
References: <20230110055204.3227669-1-yian.chen@intel.com>
From:   Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20230110055204.3227669-1-yian.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:217::11) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SN7PR11MB7566:EE_
X-MS-Office365-Filtering-Correlation-Id: c30c53f9-bd1f-4448-d5a5-08daf343addd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SY40N4ZH+O1l3CjurabkqXQ22yatZvdOdzcQdRCztCclowxxI8ZD6EwiwheDzrq2+oMi5Jv1uQdN0htewwx2cRFJCB1xGNIHqnD/bMxG9huYFCwvXTdLQwziqV7+XrCeQMaJlSLs4WinVrXnzkOpENY17tGCtKspDYzlZKh7B2e9XrGrTI4MU+Sap9UP8HhRtChOZACNELZBwwMTXdjc1+ZXt3bzoWGtdjOBT+rIcRzhviddHS63hQ7k1gzZVE1z7MRu8SfudmDNUqDh+stH8r5b5MwnC5lB1O/PRhLBJc84Cc0Ky+0paH08ndgcQ+QM4qe/tgyTVjNX+4iekWV7jrOjrSfx3gdf9hh8PZdpmr3vB6AqfKNry4p/gyJY7a7Pp5eeRdvw2NSzTL7zfxq3zAHgBADLPjzz5FPB8yGAPowf8v0YoGQ7cH8GwNM1kTHdzmtp6FHUhqqNfs03CDdPtNocm2PT+x4TXvN5V55v5fj9rs8hvneIxRyDECgvsDIZe9CjDOKJ6eEE5gaGgfTWpAOWugkju9+EhwIczwS2ls0HDS9kdW9jAuTTd91fskxFs2m4gPjifEn6FLa1MhpnQ72PWqldqOIkgDFEc5/mTj3wLQHuxPk0K57xJNzxHO3O/ARDw+7avz9IlNqKfhErfNt/4QMMBiQHJq3NB1mz/p2GHepKPoF5jRbvDED5NWOPv0kthiNUO/6Pd+FWQoFcTEEFFjCNR1rNqCDgCeqWqr/jzQKYS+13xRyyI47YcNFYnMb5NlN8yUEYlFUMYwXIOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(6512007)(6506007)(186003)(2616005)(82960400001)(110136005)(8676002)(86362001)(66946007)(38100700002)(66476007)(31696002)(5660300002)(66556008)(478600001)(36756003)(44832011)(53546011)(31686004)(2906002)(26005)(316002)(921005)(8936002)(41300700001)(966005)(83380400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ankzV0FuWXJoWGxqa2FVa3ZRTFg2WHhLMER0cDlLb0dmQ0RkVUIyZkVBa2k4?=
 =?utf-8?B?bFNES2xhQjJaYnZBT0tkODBRSXhvWlJIdFVGUk5NeXZ1NjJZUlVSamkwQ3NM?=
 =?utf-8?B?WStjdnk4NTF5TllKNi9SS25jNXIzdjlxcnR5QVFFbXA3dFdIbmkxR1pMenIw?=
 =?utf-8?B?bjVmdFRWVHgzb3hIYWVHUVNTV1N0VGhubU9HMWpNN1RCbmErVFFTRUE0RkJP?=
 =?utf-8?B?UENHTlowcXJOdmxhc2t2TWYvaXBVWE55QmIvdiswN0RLS3hBYk5BeGM5amVa?=
 =?utf-8?B?azBnd3R6KzJEWHlFTmdIUTE1Tk1wa1hmMC9aN2oyT01mNnY4Y1NyYUIzQkdv?=
 =?utf-8?B?bEFpanpTVWo3dEthaU9VU1U2SkNkc3VQMU9PeDZPc3JwL3lNeHpBRmpwMDk4?=
 =?utf-8?B?UXVQUzh5ejJldkk0ZVgxaHY0MHZ0NnpjVzAvd1RSSW1VdHdra3VsTlhZZjZU?=
 =?utf-8?B?YlhHWHlveXJxMEEwQ3hPUWJVaGNQWWcrc3lzMlUxVkhyUWl4Qy9iTE1TTzNh?=
 =?utf-8?B?VEJwSnp6L3JkZnlsMzNHZFBaU01CYmx6NXJVMkg4K0hlcGtsb2o1RWcyZDc0?=
 =?utf-8?B?RmRTS2pUUW1PblhqNEphMkNHam1oWnFSeXRSZDVBaHpneWNxaytBTDhsVlA3?=
 =?utf-8?B?M01EdEhmeGxMampZL3JhYUNkTDdheVJqQXplV0tiWlEweTI4Vk14dGlqME94?=
 =?utf-8?B?MWluVEhOMnVvelhWMU9pVm0xVEpTNjYyT3dlcmoxOG1Vby95cUF0Vk5jL01F?=
 =?utf-8?B?RnRqMEF5V04zaWZwUFpqa1ZxNTBoOU0weFRIWUtvVzFtVnZYRUU5aE12VmRW?=
 =?utf-8?B?dGRmaG5yc3ZxMUNZQkNIdlVvQW1KWjlYRkFTaWgvazRFajY5aEgzWjNpQkMx?=
 =?utf-8?B?M0dkbGZIUHdPTlExWUxNN0NOWFYrcmNmNzNzTE1xUzhqa0Z1VVRHM29sWEJn?=
 =?utf-8?B?dE1yajVMOFJEMUt0WmhlQ1djR21SUXpJZzl3WmdHYkNBZ1h5R2dacWg0enBp?=
 =?utf-8?B?dnlzejlGanZVZlZORVVqZ2VTamZtMjlKSnJHM2l5RVdJL0VEUFdiUWxIVFFT?=
 =?utf-8?B?VUxRZzl6M0ppcTZYaFFOeXd2T1AyZzRkRzFsb1pHM05VcHYyWVJaajBETXRr?=
 =?utf-8?B?aERTT1RRNWw3aHFtNllEU1ZmQ25hanluRlVOOC84elVYc1BHbXVRNkJna1RW?=
 =?utf-8?B?TnNzNGwwSURocUZnNmhCSUt6WHlERG0wYVhWS1RUTUtmRmthYUl4Rlk1TWxr?=
 =?utf-8?B?bkFEcUNFTWdEb3pkUkJ4QXBWZEt1UGgzNmxhVTQxRGhNNFVETnVqaXl3THFR?=
 =?utf-8?B?TExpWWwwUGJqR1NuNWN2UlAwNEJrRXZFeEh0OVJTMko2OHZHT2ZpRXdjbmFR?=
 =?utf-8?B?WUhHdlBpT2tUSUFZOUpla1lBdFp6Y2RvaVBKYmJlYTBWbFRuWFU0MXJkaUs1?=
 =?utf-8?B?VnllLzczOURNRXJmRlJZMnpXMFV5MmZoMDZXVVBEdlViZDVEZnlHU3F0bjVT?=
 =?utf-8?B?WWFlVzkycDRGczZmdFpPclh1MkgzM0xqb1g2eGpua0dSd2dPazcyNUYzaWZj?=
 =?utf-8?B?YkxKc0N0VUZQTERESVRnL2pHK3dNeHNRM3F4TWxjK3kreUNJNGk0eWdoamJ5?=
 =?utf-8?B?KytmVkM5NXRuWnBZUUhIVlBSWmxnbS9Jd1VuUCtuV3JaT0doNEM2SzlOU2M4?=
 =?utf-8?B?K1ZRMHRsc2YvRkNJUDhDRDhlaGRjZHByYVFVUU9uSGN1YURGeE55ejhiYjVk?=
 =?utf-8?B?VUJhQUZsWW5Qb2cxMU9KNGp3ZjBNc3hGUHF6cEFyQkREZXRqbzNqUHFMMHlH?=
 =?utf-8?B?d2l3QmtMVWowNlVoMWFxTzVtV2pLSHhvSkcwL1lEazgwejhPM09ESUZuMjVE?=
 =?utf-8?B?bTJnOE0yaUd6Qmp3L2RWbmk2R3JubWYzRCs0Q0kxM2RUWFExRWNwbEF2alpu?=
 =?utf-8?B?MlRMenpqL3FGMmtKaFRxamJiTWZ4RUFjV2VUVWJzaVpmajdlUGZSNnFhK2Jt?=
 =?utf-8?B?UkZ0Nk1uQkUzVFJ3TldKdzBkdUM1NVpCOHdGMitBTFdac1ZnTCtIeDk4cEdr?=
 =?utf-8?B?Nko3ZytCK1FnbmRwOTJ5cXBqWmNOSys1NTJXZDFraWUrT3pObTE5d2o5NnhU?=
 =?utf-8?Q?kmKwiP55qpxuKtHEYhjvz01BZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c30c53f9-bd1f-4448-d5a5-08daf343addd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 19:48:43.4357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJ/n1ck2JB7ZUYEg/lVUmojXJt6SEYRRd5NHUxx7lGgY58IXFl0M8d/wfi1u1AbaJ1qQt87WJd7cYxgkiBdaDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7566
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yian,

I added a few missing lists pertaining to KVM, MM and documentation 
since these patches impact them.

In future, scripts/get_maintainer.pl can help you with generating the 
relevant maintainers and lists.

On 1/9/2023 9:51 PM, Yian Chen wrote:
> LASS (Linear Address Space Separation) is a security
> extension that prevents speculative address accesses across
> user/kernel mode. The LASS details have been published in
> Chapter 11 in
> https://cdrdv2.intel.com/v1/dl/getContent/671368
> 
> LASS works in 64-bit mode only and partitions the 64-bit
> virtual address space into two halves:
>      1. Lower half (LA[63]=0) --> user space
>      2. Upper half (LA[63]=1) --> kernel space
> When LASS is enabled, a general protection #GP(0) fault will
> be generated if software accesses the address from the half in
> which it resides to another half, e.g., either from user space
> to upper half, or from kernel space to lower half. This
> protection applies to data access, code execution, cache line
> flushing instructions.
> 
> Almost all kernel accesses are to the upper half of the virtual
> address space. However, there are valid reasons for kernel to
> access the lower half. For these cases,  kernel can temporarily
> suspend the enforcement of LASS by disabling SMAP (Supervisor
> Mode Access Prevention).
> 
> Kernel access to copy data to/from user addresses already
> disables SMAP using the stac()/clac() functions. New functions
> low_addr_access_begin()/low_addr_access_end() are added to
> also disable/enable SMAP around other code that legitimately
> needs to access the lower half of the virtual address space.
> 
> User space cannot use any kernel address while LASS is
> enabled. Less fortunately, legacy vsyscall functions used
> by old version of glibc are located in the address range
> 0xffffffffff600000-0xffffffffff601000 and emulated in kernel.
> Therefore, to comply with LASS policy, the legacy vsyscall is
> disabled by default. I am looking for input from Andy and
> others if this approach is acceptable.
> 
> This patch set by default enforces LASS when the platform
> supports it. It can be disabled via the command line parameter
> "clearcpuid" or by setting "vsyscall=emulate/xonly".
> 
> As of now there is no publicly available CPU supporting LASS.
> The first one to support LASS is Sierra Forest line. The Intel
> Simics® Simulator was used as software development and testing
> vehicle for this patch set.
> 
> Paul Lai (1):
>    x86/kvm: Expose LASS feature to VM guest
> 
> Yian Chen (6):
>    x86/cpu: Enumerate LASS CPUID and CR4 bits
>    x86: Add CONFIG option X86_LASS
>    x86/cpu: Disable kernel LASS when patching kernel alternatives
>    x86/vsyscall: Setup vsyscall to compromise LASS protection
>    x86/cpu: Enable LASS (Linear Address Space Separation)
>    x86/cpu: Set LASS as pinning sensitive CR4 bit
> 

It's usually good practice to include a base-commit to make it easier to 
apply these patches.

>   .../admin-guide/kernel-parameters.txt         | 12 +++++++----
>   arch/x86/Kconfig                              | 10 +++++++++
>   arch/x86/entry/vsyscall/vsyscall_64.c         | 14 +++++++++++++
>   arch/x86/include/asm/cpufeatures.h            |  1 +
>   arch/x86/include/asm/disabled-features.h      |  8 ++++++-
>   arch/x86/include/asm/kvm_host.h               |  3 ++-
>   arch/x86/include/asm/smap.h                   | 13 ++++++++++++
>   arch/x86/include/uapi/asm/processor-flags.h   |  2 ++
>   arch/x86/kernel/Makefile                      |  2 ++
>   arch/x86/kernel/alternative.c                 | 21 +++++++++++++++++--
>   arch/x86/kernel/cpu/common.c                  | 20 +++++++++++++++++-
>   arch/x86/kvm/cpuid.c                          |  2 +-
>   tools/arch/x86/include/asm/cpufeatures.h      |  1 +
>   .../arch/x86/include/asm/disabled-features.h  |  8 ++++++-
>   tools/objtool/arch/x86/special.c              |  2 ++
>   15 files changed, 108 insertions(+), 11 deletions(-)
> 

