Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EF376B339
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjHAL2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbjHAL2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:28:51 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FDACF;
        Tue,  1 Aug 2023 04:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889329; x=1722425329;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/GB9yzdHt1kcud9bkYe64UnSEFWB8fQq/3u0p5eWrPM=;
  b=jAAnHqVfKL5QUfcOEpckGYp89CU74PMwflQu1SqYsI7FdhNkRavUFVqQ
   EVb2Gt4KaT+cnIY0J942SLTvMjAyB66ado7rzTmVGJb+YkYdPNWuCxeMQ
   gXRFZKBN9rBYpgf0vr9Bt0yHYOcPlLC5p1dm7pAtEz/lt7eysBHBrBHoX
   ML6iknsyMpK5nxBRR0vGnJtYerlnbfMXtwUZhC5hrkm/0Fal7iopZgtK+
   yzwi3zBut7QAf1xMq1Rny0uCATU69pVNC18MkF4/ai782aztywtCJlmhK
   7vetWgBLfvh4fm0YZevDBgm3X/pUEZyp/CaVgEoTzLs507SYtWT+L/2FY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="348865222"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="348865222"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="842700647"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="842700647"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 01 Aug 2023 04:28:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:28:48 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:28:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:28:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPh9NiYPPEtV1R5skWrk53yI1+QieaJjWLJUOolHIFGfd/v81UxasoQwIVgKUNN+n3sdB20er+9JicDpguyKzr1L3UmZp24onjLxegU1UDNsJGtenBhFXaId/A9eugxFJ1nQ46fGanSEwcxb4sfBuhzcMFQ69KsClCw8fJjTwULcuR9oJam4aJAWod206eAHAZbxSluQh4DPlEN0dly1ntHm/9SX3hpEDXFfaMN1WjO+OsxGOqU0HKT+HnAk3RZy1tstEm23vZ3kY2UOTuvkmrc7d/QWcn18K9jfDbUSOAQsFKewV+xKK0cYTUqLtMxwDKHNjA3LIWhF6WhOPa9y4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gp49Q3SC1fm+lKE17Bxgb01qCi5aapyJv2il6tYE4fA=;
 b=VIV+2gh7sFb+tQFLNT8nFNfKxe7TDJ9T6pqi8BMg5kMl796Eu9xJfu4vq1Tg/MZ6/RxiZPmYhTnXw4LnAQdXM3GfAxRhwRuTzUSHx4YwmG1a97Uq2BtubSZtw3tHXeJFnm2N8WHpS+5ZkxgLMF/msyhS89Tdixr5Xug+RSzE8rrOr2LY2W5ufqPY7vt2FxjylJeS3dhjp3nWpsc4mQoMZ/oTWOyPp0mwUOp4pUA/55gMmWMmA500hIzucFvg7XLh+ymob8eaCs3WlVT6RS8gH77mnip7pOFnYjYTskJUX3TttKyVpjEP93GmixkBwoKr5Fy4LHt1nYY+mHA+DYnR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 SJ0PR11MB6695.namprd11.prod.outlook.com (2603:10b6:a03:44e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Tue, 1 Aug 2023 11:28:39 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:28:39 +0000
Message-ID: <d5039b03-2149-6353-2f53-149ec31b6e65@intel.com>
Date:   Tue, 1 Aug 2023 14:28:31 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 08/29] drm/i915/gvt: Don't rely on KVM's gfn_to_pfn()
 to query possible 2M GTT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-9-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::16) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|SJ0PR11MB6695:EE_
X-MS-Office365-Filtering-Correlation-Id: bde1a23e-1c6d-421c-3cb5-08db928273c5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJbvRNzt4Fgywq2nShHDjm1gbKU4zbPYn/1YEaxJWgkR9L+6BCntDusd1lADWrnsQvFPaH2TKXieM5MOr96vZDinVAhgQ7WdZCftgttGHF5D2d/8JwgQhM+nfDrp2hwLFcdoB7tXMKi9z9HGbxk80Li0Gmmcjjfw77IzUdBgT3VBYG5IeRBpr2fzB38uUPVwNe1c/b+XJwoZYGWvsTXZqOla5AreA+d+zCokNGEddCeZFelIVFBFW+8pBxjS3xdADVpfPF+VS3C8jzZe85E+SsF9zdHfZ3Nz/24t05dINolzNG2vwGbqkmOpOjRUprxrJGZC36G+6iebMutz37+ABX8l0YvWoqMYPz1fPMv0Ce0wZzXsSYFIG3sfsFC3mCN51/DeY1IefGMujwsXToBxPwnlPnxJ9oSJ5c/3lzdnhlk2oO/I5XAeRXWijUiV1CyiOtvzQdi3qST6XjC+bfd8HGykt58186VatpU9bCLPrtFJI2XmhgZc7PGJzDfs0Y81X8LTLCBPgyAvCP8QBXXgFM09NkLxrSdaFEo1C7RmPTO2aqhC8IyaoJTwitODawox/0ceDadFGKVfb6cs9xkEwvn5V2etGjf3fL16FQLM3cnTkK6Doh+v+x+Tml8UtdUwYLfr8dk6dtvOC6/JxXL6Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(38100700002)(82960400001)(31696002)(86362001)(36756003)(6512007)(478600001)(6666004)(6486002)(2616005)(186003)(26005)(53546011)(8676002)(8936002)(6506007)(5660300002)(66946007)(66556008)(66476007)(110136005)(31686004)(54906003)(4326008)(316002)(41300700001)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXBReFZ1KzZGK0JuT0dCWGNyN3NKTTRVdFM2YzNyb3dKUXdudDJzSW1qL2dZ?=
 =?utf-8?B?MzJHSWlURXBoVHdySys0d05yTkxUTzlqb0MzRXgvcCsxQk5JQXpBZFJRNk9Y?=
 =?utf-8?B?VVViNVVSUVV2Njd3LzFNZEJpbk9yM1gxUmtHbCtNQndhMFpFZFFtekZUYXha?=
 =?utf-8?B?V3BxKzNXYTJ3VHFPQ2pxb2ZqdE0va2xLVWkxT0xTeXBieDZuM0dHTXd6a1F6?=
 =?utf-8?B?ay8zSFJhUVFEV1YxNzErUWk2Y0FCZzFobDlJeDV1bjl1b211SytuMFpzUk9n?=
 =?utf-8?B?S0FHRmN3N20xYXZIZFRIcWcwWlFFVjUvalZGUEg2a0VEcTJjZWEzcGVKcHl4?=
 =?utf-8?B?SXFrTG5WK3Q0L1h2M3V0bEJuY1BvNjBtQVVpTzdzUjUrdWYvRHdjTlNrT3JG?=
 =?utf-8?B?cVlHSW5lQ2ZMODByazdvTkpWRm1NU3ZSYXRlOXovZXZ4YWZjRlYrTmpjSUgx?=
 =?utf-8?B?cVBBRW5Xdi9TL3F4Y01FQ0VpQXE4T3JiSzI5MzRhc213b1lrVkdOSG5kek80?=
 =?utf-8?B?bXd6U2lDcGw4WUdtaGltdjM5U3BVWjhodU85d09KZndMWThsa21KVkpxMVBk?=
 =?utf-8?B?Rkkvam00L3h1Skk4ZFE5Q0ZPcVpkRzgrdFIwdmJCNzBZc0RXTkd2cFpFSkxO?=
 =?utf-8?B?Q0VyR2cyU3BtaFEwblcwaGh1dWtaS2U3NFhLWERtck90YWhleHRZSVJlL3Bv?=
 =?utf-8?B?ZGY2THZnaHFURi9JdXB4Vk9pT04ycXptdTF2QlVXQjduejFsZXZlSzdkU0lS?=
 =?utf-8?B?RjVBbWcwL0dpS0lQY2ozVDRyZFVMVW9KRHpYR0Y3YnR3QUI5dy9BakE4Mkxy?=
 =?utf-8?B?ODRlK3V1bjJ5dXVyTjFmcU9rN1JicVdIWEI1WWRBb3pGRmxhbmIyKzl1akx0?=
 =?utf-8?B?UjdtRzFGQ01xRkljbEI5dlA2MUk5TlRUejU0c2N3VWgzUmFMaDJoVUJSMndj?=
 =?utf-8?B?UWVxaDNPRUVYTFVaZHNyOFpOUG8walZTN0ZKU0pnTVVnQ2ZZZnF0TmZ3ZVhI?=
 =?utf-8?B?aVZrZ2ZwZTRQaWJGZFcrNnA2UlhYYnN4SFo3ZExkVlJtNkF2WTN3TEpuaVMz?=
 =?utf-8?B?N3oySGFkbjYyZndwSFhQK3U1c2FJR1cveTA4YWIvMXZ6cHJMYlNkMlpVd01Y?=
 =?utf-8?B?WlhNQ1dSRFI4eGVtdnZuVm1lTVpmYjBlNWVqbFVwQldJck5IS3QvM3RjbmtR?=
 =?utf-8?B?SWdIUktoV1JNdWEwYWxqemd5NDJaREtiaTdZcXhuLy95eDF3bGRxS2VXK0d6?=
 =?utf-8?B?Q2kyWjBLTEZLTk0yR1lhVlVsMVNjemo0SExGdnBud0cydUo2OERaL3BBSnA2?=
 =?utf-8?B?WDVob0s1OUFISVpLMVdzREZ6VHlocmtwS2ppVzdOemFqU2tST3VsM0dkSy9k?=
 =?utf-8?B?UlJUOTF6R01kWDdwTUtJN2tPaE05YU1kOW13WmlIaUZQZGZOWEMzVkxUUEV0?=
 =?utf-8?B?eWpLY2lBTlZvY0Rva1NpZTJBN1M1Q0U5R0wrS3BKRFVyNHJvSGg0Y0lFaWhH?=
 =?utf-8?B?RWJCOWJwa3F1UWZKWURidytYeEIvQ29vNjczYjJ3ZG9LNXh1cDZGNWx2eUlz?=
 =?utf-8?B?QWxwZTcvS3M5V2d1UmxtSitkREJ3S09pUEFzL1dmUGc3Tzdzck1IUHNhMkRm?=
 =?utf-8?B?QlJRS2xFb1IrRUd6RTlLVFZiaXo4WVV0UW9hUzdxYzhmUVFMSk1nR1dBenV2?=
 =?utf-8?B?VjlpOElPMmdFWDh2TE1lSFMrWnpiZjJVRDY2UlhyTFVreGJkS2RjT1ZCRnBH?=
 =?utf-8?B?WXhxb0U3YjVadkZWdW1LZm5JUzU4d05ob2V6cklORWdMZmtDbno4TWlHLzdy?=
 =?utf-8?B?ZWhTNnBjUXc4aVFTbk1vaGl2VlVoOHQ0M2dmTGIyN0xGaWFJZCtlaHc4UW1j?=
 =?utf-8?B?YXRKREJKUFpaRGkvZnQxYlp0dkFrbzZQc3d0MnRSNUlCN2xPWjZ1NkdOcFB5?=
 =?utf-8?B?ZmdwWXhIQmllUWFwYWxFNnJ1c1E0Vy92NzY3eHhBdnpMZVRWdjFlMkRTdVhC?=
 =?utf-8?B?RTBYSVRTcGs5dk9JbXNMeVppc1c2NUJOaXZHMkRGVEQ2c3dHTzUrK2RudUs0?=
 =?utf-8?B?K0pkeWM2djRwQSszSzdidWUwcWlwRHVGbXlsY2xWZlFCdGxrY2hlZkhvejZj?=
 =?utf-8?Q?NHHCT7XpC9vsfgiE/nhlVGpIy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bde1a23e-1c6d-421c-3cb5-08db928273c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:28:39.1061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hg5NrkoOkBTbsC8tET4fl/Msr9ju15WYFXrW8nvUPGnsbQiiQr8j8geSUENbZpm9P+MbJUer23Gj/bsBc3zJrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6695
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/29/2023 4:35 AM, Sean Christopherson wrote:
> Now that gvt_pin_guest_page() explicitly verifies the pinned PFN is a
> transparent hugepage page, don't use KVM's gfn_to_pfn() to pre-check if a
> 2MiB GTT entry is possible and instead just try to map the GFN with a 2MiB
> entry.  Using KVM to query pfn that is ultimately managed through VFIO is
> odd, and KVM's gfn_to_pfn() is not intended for non-KVM consumption; it's
> exported only because of KVM vendor modules (x86 and PPC).
>
> Open code the check on 2MiB support instead of keeping
> is_2MB_gtt_possible() around for a single line of code.
>
> Move the call to intel_gvt_dma_map_guest_page() for a 4KiB entry into its
> case statement, i.e. fork the common path into the 4KiB and 2MiB "direct"
> shadow paths.  Keeping the call in the "common" path is arguably more in
> the spirit of "one change per patch", but retaining the local "page_size"
> variable is silly, i.e. the call site will be changed either way, and
> jumping around the no-longer-common code is more subtle and rather odd,
> i.e. would just need to be immediately cleaned up.
>
> Drop the error message from gvt_pin_guest_page() when KVMGT attempts to
> shadow a 2MiB guest page that isn't backed by a compatible hugepage in the
> host.  Dropping the pre-check on a THP makes it much more likely that the
> "error" will be encountered in normal operation.
>
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/gtt.c   | 49 ++++++--------------------------
>   drivers/gpu/drm/i915/gvt/kvmgt.c |  1 -
>   2 files changed, 8 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> index 61e38acee2d5..f505be9e647a 100644
> --- a/drivers/gpu/drm/i915/gvt/gtt.c
> +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> @@ -1145,36 +1145,6 @@ static inline void ppgtt_generate_shadow_entry(struct intel_gvt_gtt_entry *se,
>   	ops->set_pfn(se, s->shadow_page.mfn);
>   }
>   
> -/*
> - * Check if can do 2M page
> - * @vgpu: target vgpu
> - * @entry: target pfn's gtt entry
> - *
> - * Return 1 if 2MB huge gtt shadowing is possible, 0 if miscondition,
> - * negative if found err.
> - */
> -static int is_2MB_gtt_possible(struct intel_vgpu *vgpu,
> -	struct intel_gvt_gtt_entry *entry)
> -{
> -	const struct intel_gvt_gtt_pte_ops *ops = vgpu->gvt->gtt.pte_ops;
> -	kvm_pfn_t pfn;
> -	int ret;
> -
> -	if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M))
> -		return 0;
> -
> -	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
> -	if (is_error_noslot_pfn(pfn))
> -		return -EINVAL;
> -
> -	if (!pfn_valid(pfn))
> -		return -EINVAL;
> -
> -	ret = PageTransHuge(pfn_to_page(pfn));
> -	kvm_release_pfn_clean(pfn);
> -	return ret;
> -}
> -
>   static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
>   	struct intel_vgpu_ppgtt_spt *spt, unsigned long index,
>   	struct intel_gvt_gtt_entry *se)
> @@ -1268,7 +1238,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>   {
>   	const struct intel_gvt_gtt_pte_ops *pte_ops = vgpu->gvt->gtt.pte_ops;
>   	struct intel_gvt_gtt_entry se = *ge;
> -	unsigned long gfn, page_size = PAGE_SIZE;
> +	unsigned long gfn;
>   	dma_addr_t dma_addr;
>   	int ret;
>   
> @@ -1283,6 +1253,9 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>   	switch (ge->type) {
>   	case GTT_TYPE_PPGTT_PTE_4K_ENTRY:
>   		gvt_vdbg_mm("shadow 4K gtt entry\n");
> +		ret = intel_gvt_dma_map_guest_page(vgpu, gfn, PAGE_SIZE, &dma_addr);
> +		if (ret)
> +			return -ENXIO;
>   		break;
>   	case GTT_TYPE_PPGTT_PTE_64K_ENTRY:
>   		gvt_vdbg_mm("shadow 64K gtt entry\n");
> @@ -1294,12 +1267,10 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>   		return split_64KB_gtt_entry(vgpu, spt, index, &se);
>   	case GTT_TYPE_PPGTT_PTE_2M_ENTRY:
>   		gvt_vdbg_mm("shadow 2M gtt entry\n");
> -		ret = is_2MB_gtt_possible(vgpu, ge);
> -		if (ret == 0)
> +		if (!HAS_PAGE_SIZES(vgpu->gvt->gt->i915, I915_GTT_PAGE_SIZE_2M) ||
> +		    intel_gvt_dma_map_guest_page(vgpu, gfn,
> +						 I915_GTT_PAGE_SIZE_2M, &dma_addr))
>   			return split_2MB_gtt_entry(vgpu, spt, index, &se);
> -		else if (ret < 0)
> -			return ret;
> -		page_size = I915_GTT_PAGE_SIZE_2M;
>   		break;
>   	case GTT_TYPE_PPGTT_PTE_1G_ENTRY:
>   		gvt_vgpu_err("GVT doesn't support 1GB entry\n");
> @@ -1309,11 +1280,7 @@ static int ppgtt_populate_shadow_entry(struct intel_vgpu *vgpu,
>   		return -EINVAL;
>   	}
>   
> -	/* direct shadow */
> -	ret = intel_gvt_dma_map_guest_page(vgpu, gfn, page_size, &dma_addr);
> -	if (ret)
> -		return -ENXIO;
> -
> +	/* Successfully shadowed a 4K or 2M page (without splitting). */
>   	pte_ops->set_pfn(&se, dma_addr >> PAGE_SHIFT);
>   	ppgtt_set_shadow_entry(spt, &se, index);
>   	return 0;
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 0366a699baf5..97c6d3c53710 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -162,7 +162,6 @@ static int gvt_pin_guest_page(struct intel_vgpu *vgpu, unsigned long gfn,
>   		if (npage == 0)
>   			base_page = cur_page;
>   		else if (page_to_pfn(base_page) + npage != page_to_pfn(cur_page)) {
> -			gvt_vgpu_err("The pages are not continuous\n");
>   			ret = -EINVAL;
>   			npage++;
>   			goto err;

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>

