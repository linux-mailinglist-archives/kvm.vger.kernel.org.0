Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712206B1F48
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 10:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjCIJFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 04:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjCIJEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 04:04:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90238EA5;
        Thu,  9 Mar 2023 01:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678352616; x=1709888616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vBvIq4/ekVeGynCWmOzqF/cn2MkaE3HgH1Kt7jXtXfg=;
  b=b8PXZcGZ2kUY07oSYlZ8oIrAHAKAIpyadxGfyyN/SfA04emqmz/0+A2g
   tOybp683eIEqhm2EqQ4R0Efad79AD6fWqowSbHY71fMKegBdHRvSHpcY9
   obCuNPrFUGnsiI1KzdXXyliDOGmXhNVbIHumOxW15OnC2xGrT7zGwYEtV
   hg/NuNmNhhNr+sI/WzSHzOWT57UgN+4L8y6MNi8ocA92rcG3s7JE7bnIe
   ms9t2zmGs46JdokgromIx/1C61+X8+eA79jeg/NtuAogllynotIb2cOxl
   A9z4QJsi9KUTlX2QzwTZCHCXd2ArpFFDZslUni9te5hPy60SnBbtMb2ZB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="316788897"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="316788897"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 01:03:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="787484215"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="787484215"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 09 Mar 2023 01:03:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 01:03:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 01:03:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 01:03:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 01:03:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1Z20ddkSEBXO6DIQGSHokCpncAGwNx9zKk7sRLkea9uEuOUZSDWWn+y6OokYUBLWuwthD2uuxzr2F0m3c39KRen6yZRtzVCK5R82Vy/7VomXkS6WqseSMrgBS24jD999CgXCNUndKDTAO+v6A/fONDvFg9qzpdgQBmr4jJ3SGQo5GDwAY5hP+eRS3x+f0uF8jBamu1ZQhO5oZ9h3RgvCB7EpwC2IBosgICYl2YIfvoQKVT0CL54Y6l9Im7c3M3P4oIiRl6ZNhIgK9Bii/DyICGH2x/aTQ4EvGsAj1Sfoz7Rzq/yemRx9Uj5SOkAvMAEu3AUQECN5A6LzQeVdPsDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+kMIadu9oNx2wD95ieywuB5i5xg8azc7c4uoqLcx2Oc=;
 b=W7Y+xhrfat/7deORi9/2FgwJQ0XSeKC/vCegkyJ8zQJswL/XCoBP9NTFECBOh7711aVoc5zNUo1FYUgXmkufLQyQdLRnJvWbdswkC2vCiuZOBtu2vzbcSXUVWqAWdUMkgIyzfsmo0B91Oty3I95xthdtLJ2Js7uJmefMCuRmRwwEJeWUidh1i4E5lxGeg96sJ0sivhEUpdYPNl32UVlAlzwydLTjD1+ETPP/zlpWMkk3DoLsgV9UYrPSTK4PEbXNGfFUDw2j9vmqAoKa2mGf5lwt7fn58EIfthoYuH3Tm3wh5MijxxkgRnPNhFjb4cmvpl3gs7UB9MZouYT3qq0YpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by SA0PR11MB4669.namprd11.prod.outlook.com (2603:10b6:806:99::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 09:03:24 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::7a21:ecaa:7ff4:2756]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::7a21:ecaa:7ff4:2756%9]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 09:03:24 +0000
Message-ID: <02b38016-f8b3-724a-cf8d-36b343ebb9b6@intel.com>
Date:   Thu, 9 Mar 2023 17:03:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v12 050/106] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
To:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
 <93ef8e57cb80e8e0268c91758968a1950de4b5f0.1677484918.git.isaku.yamahata@intel.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <93ef8e57cb80e8e0268c91758968a1950de4b5f0.1677484918.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0166.apcprd04.prod.outlook.com (2603:1096:4::28)
 To SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|SA0PR11MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: 53214d48-beed-46fe-b920-08db207d2376
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTKL4rtITbUO1F6+WulFvpMmFxTvFB7XzrcTFoOl5UsJpl25ONFxJ/2wpcgb/adweonreUuROhPkUmJYFG9LJCuTj8bK5Q08r5yoKl7xgmnFe5j7kHTklNHLw9wGxHHZt9aQMLVg7+o0nx2PckWM//t70m52feKUKRcz5w8TPiZEojez1+KovpogK6PCiPDIUjN74J+YGRx3uNRe9ZlPLpJSujV2gFSE5psnXdC72APBkINdAgIZbfCAtLe3jFTLToWkxjmern8vp3tz6Ku94VA/SJgx5y4fiyXlG0EaVFYdIAQUmB4eKqOBmdIGvG4AoY/TB+L64qchOXEdNax6xanH0YrP+Rqb8wvN2y2W89UXn9s/vXjodNPHRbmWfujP2pc5BrteqQK1/NpAQRcfyioFp8uuX9fRbovQGvhUCwJobYHC5rFp9wZogNTRfOC7Uavs+YAg6ODZXS0R+3aDgrRpv0hO/T7quDUV+QFLDa1djMEoe6E60mTY1nmi2bheErR9lawzVwe2cJPFsDeOsV5VLWF7zLw2kSzK5obIkhygDldfOsA/hVXHDB//0mjHLpqcGTAFDvcN0rG9BgX0Rau+wRMAFwoXJ7wneLIu81ndr4Fai0V89vRyFoO2kI53waXhMSJbV+XOS4v98Ox8cC2tHFRQwx3tdQ6WgU3ynVkt7zhkITAMrVyGzRlO9kK/40iqmJFf63FuXJaKiO1rebbnZjjYtY/1Fy5577MDwbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(2906002)(31686004)(66946007)(4326008)(44832011)(5660300002)(26005)(36756003)(8936002)(41300700001)(54906003)(8676002)(66476007)(86362001)(316002)(478600001)(31696002)(6486002)(66556008)(82960400001)(6666004)(38100700002)(6512007)(53546011)(6506007)(2616005)(186003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SllzaDBQSG93SWw2OUR3QlBBYVZJNEZVNlNyQWlHZlpIL2doTXdHd3NPRnkv?=
 =?utf-8?B?WVA4a2UvRkZqZzNPem1udmNTZXZEOC9SaWxON0lBbW9YclhoSWZTNzZSN1do?=
 =?utf-8?B?RVVXQkhoSVRNa0FxVnpTTCszUjJ4T2hKaFhHYU9LcXZjV3JCdU1IOFJ1cWJn?=
 =?utf-8?B?ZlQ3VG55S2dMVlZTSEE4T2g1ZjRZUnNwdlJEbGxmMXhJZVpwclYraHU1V0l4?=
 =?utf-8?B?QUpvS1kwMklCUjBuUDRKem0yeUIvQVdSNW1CUzB3dTdOZ2I2ZTZ6eDlna3I3?=
 =?utf-8?B?RUEvM2x4VE5FcmZodE1HZTNnaHMrYXVaNVR6azZYYXBuOU9kSXFHNnlnV2g2?=
 =?utf-8?B?eTZNUytoWDIrQ3VjdEdmblRISEcrT3J4c0xRU1ZzRm5WRE5WUzc1Um5NTUdM?=
 =?utf-8?B?M0tRbXFPSHlwcHlRYm1vYXBkb2tUa0FkbllKNmJLK2tSSnp2UVJKaTkvaVdU?=
 =?utf-8?B?SHRYRzVHLzBkcG0zWjBXbUJjZitJYXdQSm5qYzBtTng1SUNrcWZhWjVRN09n?=
 =?utf-8?B?VmVtMHlZekFDcVNYUkNLWFA1MDdKdDVCbnFMK2FrSnhtN2QzcEpKbEhjdHEx?=
 =?utf-8?B?bWF4a1EwUjg0VEJyRURnWEx3NTQxanZWVzhSQjErQklaNHlib09XMEpNakxl?=
 =?utf-8?B?U1VJTE1jQWxwTExzcDhqSXc2dHE3dVExUjNyRlgvMUIrN04zVmE0V2hvd0dU?=
 =?utf-8?B?UitTNkxOc2pEYWM4WENzR3M5bERPMlpxbzdjbzkwbExWNVpNK2sxTkE3enZs?=
 =?utf-8?B?M0owUHdJZ0lQT3BjOFNpTnkrTXdRQ2NlaUVkNjRZbjlIRmYxa0tCelVobzZN?=
 =?utf-8?B?L3UyRHhmQWV5WW9yUlE4YUo0TDhLVzFDSSszZ0JXZWFndEZmOWF5Q3R1cnJI?=
 =?utf-8?B?bWNJT2kwNlRDUnJqcWMzNzQxTk1DQW81WnlFbEVQVTJFL3ZpZXBrODVSNHdH?=
 =?utf-8?B?MlVkcEpDUWRCZnV5a1JKeVR6bzN0cXd5ODdIY0FVTW9TMjZ1V0dXN1gvRkVp?=
 =?utf-8?B?U3lFcUYxakUzK3lUZ0NMQ1Q2OThZK1ZjQ1RXY1c2TitUWjZxK1lvNkJ5WHRp?=
 =?utf-8?B?bUJRN1lJN1F5MFdQRWtOL3NyUWhVbC9NK0NQSEthV2xsTDNDUVF4UW41WWs3?=
 =?utf-8?B?c0tGVmxPcHFxZHZRSU1LT2RwS1BhVXV0VzFKZE1QUHhEQ0hJSmU2ZlZOeUVv?=
 =?utf-8?B?MFZ4K3hEMWFUY1VLVDRFdFNwcldTcnd3bWNWQ21Dc2VSd1pGcUl4UTVBa0Fp?=
 =?utf-8?B?dWJ0cE8wVTJpNlZHc1Q5SzhRbHhienpaRTNtVzVXaVQzYzZLQXltcENQTHNa?=
 =?utf-8?B?WUxVY2ZtQmNETGpzZDBEdit4RHVKUUtBWXd3RkJ0dHZjLzdROEx6bFJxVVBa?=
 =?utf-8?B?c3lESTZSK3FmMko3SnpCT3d0RXJqUklVeVdwQ2pqQ3EvUDZvUGNpVkpuZGtS?=
 =?utf-8?B?WmU4UGljQzVtRnNmcEVYdzNuWmlhSEl4S095VFhveTVkbHpCT2N0VGg3eGxY?=
 =?utf-8?B?K0pHdzkvT00zdW8xQUxKRzdadlJ6WnMwcGZUaDlUWmxJRkMyY2hKTFRXa2VU?=
 =?utf-8?B?aDFqQllkU2pzM1hmdS9YbHU3UXA3NDVaZi9XeXk0YmpwWFNzZWVBaEdvOGU1?=
 =?utf-8?B?LytRR0ZXZ0p1WlZwcjJTUGhHTnB1SnFtL2hKbnB3cW1lcDQyZ0tlTEM0aVNP?=
 =?utf-8?B?N0g1dFdLaDBNcENNR0xGUzJNaUU0UVdmNkZxUGVaQ2VaOG0rQVl1ejREaDBW?=
 =?utf-8?B?ektmbThJNkJtRi9yRWlzT2cwUGdQU2ZnektKdm1tUTZlNm9HTlRRaCtudk9x?=
 =?utf-8?B?L21UL243dTB5RWRqbWNiS1N4YnU1UW9jb1BBQ3ozRWt3aEU4ck1wNGJXa1o0?=
 =?utf-8?B?UnZZV3Z4U2k1RFk1Y0EzOHkxZW9pTVdYSE1aZEgwSUdpWHRxT2tsSHd4S0h3?=
 =?utf-8?B?MVYyUW5oNmJ1dFVxM3dFNFVjNG11SHVBUHE0UXNIcVlCL1ROMUZVZUFDUEJR?=
 =?utf-8?B?MWZJWnhic014ZEN3UnFQY01WQ05lckNTb3BiNWYza0YxOXM2b1FPczJQbkIz?=
 =?utf-8?B?a01SU2UrYUFub3RISEd6MkdpR25CbWo2TUY0ZG84aTlPUU1SS25yV2s1YjJt?=
 =?utf-8?B?dzlmdkEvNHVxdFRWTVo3cjMwUyttSnhDZ0ZBWkhkV3FpVHlCMzJORDM2MEd3?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53214d48-beed-46fe-b920-08db207d2376
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 09:03:24.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1crdnoAxbb6kvhsPkxSHkBpLvH63EsyDIb7c4jIZIBpJmb6TLRXd5g15M8VNVHg6aDfcD4kJh4wc736+5Ge8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4669
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



On 2/27/2023 4:22 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
> thinks MTRR is supported.  Although TDX supports only WB for private GPA,
> it's desirable to support MTRR for shared GPA.  As guest access to MTRR
> MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
> part is to implement get_mt_mask method for TDX for shared GPA.
> 
> Pass around shared bit from kvm fault handler to get_mt_mask method so that
> it can determine if the gfn is shared or private.  Implement get_mt_mask()
> following vmx case for shared GPA and return WB for private GPA.
> the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
> is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
> include shared bit.
> 
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes from v11 to V12
> - Make common function for VMX and TDX
> - pass around shared bit from KVM fault handler to get_mt_mask method
> - updated commit message
> ---
>  arch/x86/kvm/mmu/mmu.c     |  2 +-
>  arch/x86/kvm/mmu/spte.c    |  5 +++--
>  arch/x86/kvm/mmu/spte.h    |  2 +-
>  arch/x86/kvm/vmx/common.h  |  2 ++
>  arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
>  arch/x86/kvm/vmx/tdx.c     | 17 +++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c     |  5 +++--
>  arch/x86/kvm/vmx/x86_ops.h |  2 ++
>  8 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6421f92e618e..0c852517c0e7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4555,7 +4555,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
>  		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
>  			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> -			gfn_t base = fault->gfn & ~(page_num - 1);
> +			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
>  
>  			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
>  				break;
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 48e17588a127..9c874bca69f6 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -137,13 +137,14 @@ bool spte_has_volatile_bits(u64 spte)
>  
>  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
> -	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> +	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
>  	       bool host_writable, u64 *new_spte)
>  {
>  	int level = sp->role.level;
>  	u64 spte = SPTE_MMU_PRESENT_MASK;
>  	bool wrprot = false;
> +	gfn_t gfn = gfn_including_shared & ~kvm_gfn_shared_mask(vcpu->kvm);
>  
>  	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
>  
> @@ -191,7 +192,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		spte |= PT_PAGE_SIZE_MASK;
>  
>  	if (shadow_memtype_mask)
> -		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
> +		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn_including_shared,
>  							 kvm_is_mmio_pfn(pfn));
>  	if (host_writable)
>  		spte |= shadow_host_writable_mask;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 7046671b08cb..067ea1ae3a13 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -481,7 +481,7 @@ bool spte_has_volatile_bits(u64 spte);
>  
>  bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	       const struct kvm_memory_slot *slot,
> -	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> +	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
>  	       u64 old_spte, bool prefetch, bool can_unsync,
>  	       bool host_writable, u64 *new_spte);
>  u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 235908f3e044..422b24af7fc1 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -6,6 +6,8 @@
>  
>  #include "mmu.h"
>  
> +u8 __vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio, bool check_cr0_cd);
> +
>  static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>  					     unsigned long exit_qualification)
>  {
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index a2ca09f10b6e..f42617c7aeaf 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -3,6 +3,7 @@
>  
>  #include "x86_ops.h"
>  #include "mmu.h"
> +#include "common.h"
>  #include "vmx.h"
>  #include "nested.h"
>  #include "mmu.h"
> @@ -206,6 +207,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>  }
>  
> +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
> +
> +	return __vmx_get_mt_mask(vcpu, gfn, is_mmio, true);
> +}
> +
>  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  {
>  	if (!is_td(kvm))
> @@ -326,7 +335,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  
>  	.set_tss_addr = vmx_set_tss_addr,
>  	.set_identity_map_addr = vmx_set_identity_map_addr,
> -	.get_mt_mask = vmx_get_mt_mask,
> +	.get_mt_mask = vt_get_mt_mask,
>  
>  	.get_exit_info = vmx_get_exit_info,
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8f191177bfe9..f532f5c352f3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -5,6 +5,7 @@
>  
>  #include "capabilities.h"
>  #include "x86_ops.h"
> +#include "common.h"
>  #include "tdx.h"
>  #include "vmx.h"
>  #include "x86.h"
> @@ -345,6 +346,22 @@ int tdx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	/* TDX private GPA is always WB. */
> +	if (kvm_gfn_private(vcpu->kvm, gfn)) {

kvm_gfn_private() only drops shared bit instead of checking if gfn is
private of shared. It should be !(gfn & shared mask) as mentioned in
your v11 series :)

> +		/* MMIO is only for shared GPA. */
> +		WARN_ON_ONCE(is_mmio);
> +		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> +	}
> +
> +	/* Drop shared bit as MTRR doesn't know about shared bit. */
> +	gfn = kvm_gfn_private(vcpu->kvm, gfn);
> +
> +	/* As TDX enforces CR0.CD to 0, pass check_cr0_cd = false. */
> +	return __vmx_get_mt_mask(vcpu, gfn, is_mmio, false);
> +}
> +
>  int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpuid_entry2 *e;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ff3b33fe9af..72da86abf989 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7552,7 +7552,8 @@ int vmx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> -u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +u8 __vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio,
> +		     bool check_cr0_cd)
>  {
>  	u8 cache;
>  
> @@ -7580,7 +7581,7 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
> -	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
> +	if (check_cr0_cd && kvm_read_cr0(vcpu) & X86_CR0_CD) {
>  		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>  			cache = MTRR_TYPE_WRBACK;
>  		else
