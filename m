Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E4076B38F
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjHALnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbjHALmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:42:55 -0400
Received: from mgamail.intel.com (unknown [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E15C7;
        Tue,  1 Aug 2023 04:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690890174; x=1722426174;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FUGCEj/siVfIn4e28iYsWx67klPHrf/XBtaUu4SJ20M=;
  b=dMO+YAr13bHK/NlJ/fxOhFcaHJStvJy0y3nWnK2FmpwFZk9/KAO9rrwv
   d7TT9GHbfKjPs5gYVqOOGGKJHuzlSe6D0P/lN3TF3SQxgjh9RM6ngfROl
   PjMXLByzkpRGZ0+7X47Af6HBR77UVMppGoKw6ROzrA6WyLslzzhIBehop
   YWTnch7VS1fjn6iJbjsPSx5itIrK638hSm4m4Wb0gkJmwXhcaKCLBr4LA
   aBKW4fhstga+FuqwU/v4OZ5Tya1yleyWAPKdCUCYhXLkTzlSMuGX/dkwT
   /H3BUNQ6wgXYWnH5Y/JnU44zntmPKJcsDGBxgkKt6wuYxNhIxFS5fg5vv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="349569735"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="349569735"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:42:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="722456605"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="722456605"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2023 04:42:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:42:52 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:42:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:42:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:42:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUZXepkkdRsFOF445ajXYcspgcd2ChBZdaF7vZ1xqQKmXTroDrC5JXGz0OdzVSmsa8YBLLOPo0OquMp6og84RU8cV1uWQJrbaPvSNn8rSPWuPRDRiq+rOYHITz0Umv+iF4yNJEjLTjncmyPUY5rXESVpvjjG8JseRHBaKDTZatddbBsEIScMvWb/7c++3Lt+RO58wh7Qd2yS3cl/Jag6QnPg6O22L5ThwIuklBzDj/P1RujOAx1dUYZirfyPAx28IXjZ9SYJBz+RxHasXdO7YDHeLPX0VI6bwV4wmAAmSjUXfUQsda/jZwOhLtAIRuvgmJIT7n+HHFjzfK8oqVR+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPXZ5uZiMG0NDjUJopx1b3g4rDv/6moLUD9pNyWDftU=;
 b=QUTeoRsJeVDOK7AI7UtMyH92DDcfsbNqLyAB4yKP1SUGxicCG4uA15yiNtMqjaQI9MtIsJweTd0EgAGYdpfXOGailPVRIqSPKZSll1Vyb3cNtkcebNFKVQ21bGHHVG5DTd7QSXdIPCqtozMNRrtWNV5fMgYhSkBTZl2ysQradL3QWUcR82uhgvqD/ryuqdcxFKjQm5FCJfTRXvgjLHg2jYSyEiEtI2uui1uRyE6Zsk+8kUHK96rRV1VYrFcCZqIrWQTazBirAAEoDPcpFfXJCBXFGWvGdCVD5EkqsXeaa3MWmHObVtrTR5epSfyihq8YGsmiR+FYvWG4sn5HqluxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:42:50 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:42:49 +0000
Message-ID: <34e5cea4-b837-cb1e-15c1-fcbf2dba4f71@intel.com>
Date:   Tue, 1 Aug 2023 14:42:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 29/29] drm/i915/gvt: Drop final dependencies on KVM
 internal details
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
 <20230729013535.1070024-30-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-30-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0153.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::20) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|IA0PR11MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb8b262-0e5c-4844-110c-08db92846ea4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uY8MT47pLWlExPtyyMas4u06J994MBPGRURbvqc+FiPbpM45xnsHAMx4fkybsQCfMxvnRQ65IVEIQzTDYxRHQ2KS6ICB8l9C7cDCJtdYeUXkzYWd8m31kncP9RhQlm3tMiIXNv9pt8B/m+t8M96Nr4h6IPE3LlseThCLoIBkitFfCbkjAKIQPXR2Disx2x8iRsvwM/05O+4UJK2YHT+CAhSjfPfX1ZDf11Ja4KQv0MLIBrs7v4gqh7qcVHBoZ1FiNa1cwRQTUzfpIXbYn7xZ2C1YxmOrahnB4WBErloJrNYTRztIe38/8eHm4dHRNZgkXNrzhCJWv8YT772yZR3nZ2r/4JkTX3DStOe4gXI4lfdHn8RdGMgsUo4W96Uoh6gwk8TW0JV3nb6jgwOVaGdKB/pPgjqh3mtBBtERz29SYgVXmN8M+d8XT92prIqNheDQLT/jC5UVKQgHqoQCwKoIOREIdkmnImP5lgAyLLJLQbY8VpRlASttNDbemU2GxcPEONb3SwUZ1SItVVVC2Fr0i2V6aE/ozt+t57CF8TkqKiHAiwZpKqS5YpGDar1TWtuL8QA8KTOclutcaf6z0ESd7YqhxNN4yvocahk9sYzXP6yNk5tG+upx9/mzIEIFnLCsZ/a24xSwG/G/aELO5pNyqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(2906002)(4326008)(2616005)(83380400001)(186003)(316002)(38100700002)(31696002)(31686004)(41300700001)(478600001)(86362001)(6512007)(110136005)(54906003)(82960400001)(5660300002)(66946007)(66476007)(66556008)(53546011)(6506007)(26005)(6666004)(8936002)(8676002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dit5S2IwZHNlY25IRnp6cVJtS3VhcGZtSmZ0OXlGZzArb1p6SW8rdFNNSkNE?=
 =?utf-8?B?SEgxeURGcnZRY0NIbXNweno4M2lseWd5em9taTc4bEFmenFzSElROGxITnVG?=
 =?utf-8?B?TzlvVGVESXdsYUxGVVhGNWpvWk0vVzhCRVdkRDJWcW41VEJEbzF3ZmNEcWMw?=
 =?utf-8?B?TTFTN2tTZVVUQlFDYUk2L3kxVklMVG5MV3lRdkdrT0Flc041d1R1YUZZSXkz?=
 =?utf-8?B?eTlwRDB3MTlkUVlncDhXUHRKUWRMb0hCMHA5YmlseVpwQithanlPa3VDVERQ?=
 =?utf-8?B?eTVyUGNoaHVhVHNOZGE4cjAvYmZSdGxyMGJTNE4yUXRKYWZaMDYzTnYrK05o?=
 =?utf-8?B?bm4yZUROZHA0N3o5Vlcyc3h4UmZhMkRyVmt6cnpyNmh5S1N0TzIvVnBpUTBP?=
 =?utf-8?B?SzZ1dTNVUld0a29uSDROcTRHN1J4L25CVENBOWduUENOT3dsMjZkbCtqSm5X?=
 =?utf-8?B?cnBQdFpaVmFoMkQ5d0ZXSG9nNkJ3VVpZZ2tNR1ZpT0Q1dVg3OERmYVNvN3FX?=
 =?utf-8?B?VEUzT3NNZG1ZRml0LzVxQ05Fa21GWE8rdG9QRk5ad05tOHh6aGg3RlJyc2d1?=
 =?utf-8?B?cTlKVEduZnA0eDdZZ2tSemp0cVZRUW81MnZCaE9mM0QySk50QXAzOWhXcWFt?=
 =?utf-8?B?dEg0UUgvODh3NFFqcmppeTlENE8vNUdDZXpkT0Z1aXRpUjZZcE5NaXVCWERt?=
 =?utf-8?B?MDNYOGpVMzBVenlKTHB2U0JrdDZQRmptSHM3bng4UUxjeHJZNWdXQXBiZ2hI?=
 =?utf-8?B?VXE0ZjhlMERHbkk3ZjNpN1dsWkVpQUswRzJ1WUxKeVA0NWVzL2k5eFQ5UmdB?=
 =?utf-8?B?bjB4ZEgwcjBYSS82Y0NSUWFIeit6N0lmTVlpcHNWbW10OFJSUE5xc0lIZGo1?=
 =?utf-8?B?Y2VDWWxHbUx2NzZiY1kydGdQbFFOclRKemx5RFE1U05jcEREVmlScDRhM2dS?=
 =?utf-8?B?WVFZTDlBakMrblJsalVlVzlaRFlsR1h3OEtYVE04QUllMGczVEJwYnlYVmND?=
 =?utf-8?B?VUNlbmFlZXZwbU5WRTVDK3pFQWFoeG9DeWtKaS9IN1p6THlmb0JJWmpBclQ0?=
 =?utf-8?B?TGh3NXVEUWhyN3pFbzh1WUtocEw2NHhPdFdVUXdVUE5CVnVMbXVVeUVuaEZE?=
 =?utf-8?B?aU1iYnU3UVI3NG5ZaEhPbkxEYTUxaU9rTDFXckdHZU9wVTgxZlByZE9nUGlk?=
 =?utf-8?B?NEF1TFp4RkR4MDg5RHdEbUk5c2ljdkFueW1zeW9laFZZazEzT3lHU2dHcGow?=
 =?utf-8?B?bzZHTVc3Wi9iNXBOWDBFNW9GY3ppaXQ1UnlxRnhIZmpJTldkZVowS1BTRXd4?=
 =?utf-8?B?b01zUjEvVGNEMGxMU2JoanRWSDg3dGNnazlyNHI5cFZsMldpRVA1c3lSeHJX?=
 =?utf-8?B?SlVTKzhwMVhnVTNIRzkwaU1wR1plK000akREUnB6dmFWTldreXJrd2RNdWtB?=
 =?utf-8?B?TlBJMHBtdzdtUmRaaEQ0a2RzYnZyU3ZzdzdQZDNGL3JmWWp1L05QUHVFQ3RU?=
 =?utf-8?B?Wmc2NzNtQlJEazJLY0Vob2N4RzJYS3gwVk5jYlJuZXpMVjZUOVlkcWVtS0U5?=
 =?utf-8?B?dG52QVA3Q0FyTlJzQjNoZ1BQQmdMMldRWkZ4Rmxwc3pSNGN1anpvQTdERnYv?=
 =?utf-8?B?VmhCUmV2YVJWUnB2RVpLTTQwT05TT0syaXR0MEIrcU1OOUxWa2txc1Mrb2Y5?=
 =?utf-8?B?SmdaTkwrbHgzZGF1bTVJOCtDcnpSK2gvV2Q3YmJ2QnNuci9Qc0UwV0xHSEJY?=
 =?utf-8?B?TGlEc3RjZ0p4a2ZtNkI4clpMVGgza0JmWU0xSXlKYVlyeTdvM1FRMThoK0o1?=
 =?utf-8?B?VWR2TFJPRDNVUjkweXZONnpmdi9QZmNWVVM2dzFOWDdhOXRXeTRxREY3OEF5?=
 =?utf-8?B?KzZlNXA2STUxQmh4Sk5SNXhXNmJWVzNHbXJmMlJtVXdsSzFvUlBoUnBzb05t?=
 =?utf-8?B?aWN2Y0NNTm8wcy8rSkVPVnd6dkswdmZVdjBtSmNKSkx2WXdHYVI0MGRTblZ6?=
 =?utf-8?B?aHdHRHVqZDdYVzlQKzhaQmRrbG0yNmFqenkvUXlkZDd4eGVkUlNYcllrUmJ0?=
 =?utf-8?B?TFRZdSs3Y2NKakM1Mk9rRDNsdkNtY25UYUdtVFhtOW01dytodFhNQ0lsbFpV?=
 =?utf-8?Q?C4/jG354zVhQ0NMuuZA97mF04?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb8b262-0e5c-4844-110c-08db92846ea4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:42:49.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6qgYDaRjaVp0n8ZX9YmS1r7UbupdwlLaAHfrFbOXQsS96v+kjjHPy6IkuLsa9dn/VfZ4M6iVuMWwAv1t3QXhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7379
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
> Open code gpa_to_gfn() in kvmgt_page_track_write() and drop KVMGT's
> dependency on kvm_host.h, i.e. include only kvm_page_track.h.  KVMGT
> assumes "gfn == gpa >> PAGE_SHIFT" all over the place, including a few
> lines below in the same function with the same gpa, i.e. there's no
> reason to use KVM's helper for this one case.
> 
> No functional change intended.
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/gvt.h   | 3 ++-
>   drivers/gpu/drm/i915/gvt/kvmgt.c | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
> index 2d65800d8e93..53a0a42a50db 100644
> --- a/drivers/gpu/drm/i915/gvt/gvt.h
> +++ b/drivers/gpu/drm/i915/gvt/gvt.h
> @@ -34,10 +34,11 @@
>   #define _GVT_H_
>   
>   #include <uapi/linux/pci_regs.h>
> -#include <linux/kvm_host.h>
>   #include <linux/vfio.h>
>   #include <linux/mdev.h>
>   
> +#include <asm/kvm_page_track.h>
> +
>   #include "i915_drv.h"
>   #include "intel_gvt.h"
>   
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index eb50997dd369..aaed3969f204 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1585,7 +1585,7 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>   
>   	mutex_lock(&info->vgpu_lock);
>   
> -	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
> +	if (kvmgt_gfn_is_write_protected(info, gpa >> PAGE_SHIFT))
>   		intel_vgpu_page_track_handler(info, gpa,
>   						     (void *)val, len);
>   
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
