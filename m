Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8995B76B373
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbjHALjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbjHALjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:39:46 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF091724;
        Tue,  1 Aug 2023 04:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889984; x=1722425984;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BZakwD031fo9tuSf7QTspRlwq8dyexRTnv3V3DZwqUc=;
  b=di5us0JtwiYtkMkmYmAZrqyaFBXipnmUwHjguFNhPVD7/Z5pHMudgHU2
   WD/ONfEDW7nxw2EDjN1JMZLhexas2bxY+bWmB4lB/exXD+sUVBq+kTEht
   CBz34ofLzFQ6IwNd5duXTym7m34O0q2QPaHhLFe50IFJK8om5etksaw5E
   Y8X2n71BuS0snIWhjQkhgAq/MnZ/+7fc4JSBjQyavR6UxJYJzZbV5mgSN
   JbeCMYmcM8pKxw9fbuvU32YcMb4zCYmJSAUXeSWzbS+KUlCLR4GW1tdIJ
   yqceAvfTbkYdkCL5jIERWqRbo/yMCBiLBT2XAfxKCPVJgLw3YCCTgfaOK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="433110670"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="433110670"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:39:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="798629830"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="798629830"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 01 Aug 2023 04:39:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:39:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:39:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:39:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:39:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfiKVoWuvNjG/K5GGbT6OuMROHbq2cQzRgeS/NXS28UpKm7NZFIUeKPDySoZW5XejhqPfOQwkflDCHotFjvPYMI4pUQxsY68N+pCcHc+ViSWjIlZPA/mB6o6yXiPCo5f75Tk7Tne4NJvmadnHws3KkrbiBiEqCen5PKpJOQxtjNwCRKBszbiYYprtfXsin7oEliqvCtjiC5Rr7jD2FivwnkJqRXejGZln4mtaMxGSOFc0flSdaqZWARArl+QzdirmGHZ+cEB/QTxsGPPCByUYcZRAGYnpsobt+cf1ojZTaH6RP+i6Zo6S2S+VP/UYnAK4mTrgFFU2xKLS/rjeZLkqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6hn10LG2QHMmz+s/sXss15hJ0LfJsrHWpT+UN48B5Y=;
 b=Fslfd2lyNCh3fv5u8qhYkqg7x15lCIwYvv80cEu/DDC3cj4qI7Dkd7BZn8VBiqYe0jCjtAVGKT24qMpSNvAyJTL5fvv1hyq7iXmbz3OrKVGqSE7oGId6+XjzysQuWabIakDbWC0Y9VNXBrsWnf9qNqMj+0lDY/uZZ2ECWjCwhMwDFnJ6I8kr84D3bOfojg0q5q/ru594gDhOIIeGKFKdDM1EUigMiSC7J02VM+mjjQlP2wSk3IElw1Vagr+qOB09k3q3UVmgYt+IcF/1/w85ORX/6NAdTp3i1kGANYFJox/gv5wSE19pvk6YfNoPaQ1Jjs/biag/6BSEHlbw/i1xww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:39:40 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:39:40 +0000
Message-ID: <1728fa16-64ef-e960-c8c7-9935f27ddc83@intel.com>
Date:   Tue, 1 Aug 2023 14:39:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 19/29] drm/i915/gvt: switch from ->track_flush_slot()
 to ->track_remove_region()
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
 <20230729013535.1070024-20-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-20-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::10) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|IA0PR11MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: f4165cf0-e84b-4853-9ebb-08db9283fdbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wq3hV32aRMgsYHxuhFgNP4mYYrQ54XNueUrqqoSJIW8ICwyAaxzDcOTxtqe+GFJwhW7axJFqG79G/QZOufUYQD0ae5KcvBsYnz7cAWxsjC4jVp7W1NUOBXOBk1i4yysTmtqDpMdjjbuvEWfxhvPJALxEfqXvVabQIVfh/Wjf5GKHmNEV5zQXGJt6LavOFyHKUp9MMn0LQOx8s86/gPEBaxCKAFkXYwlNYTn4bKqRuoz78FUExH8rSZlgudWanFOQmwWfrbHmL7vHGJ0nrMSXQwuJyppLAzAgHNWIBMIv3RrRsvXYalvFI9xqkKSHyBzj/puVtOVmydGFhCCK7G1QovwMeFzKOctzCJM2su+ZQzlw0bV1THig1qpTeKgn/ZU4D33i+GRoIAfMnEydYXEoVjPXIl1SyAD0XOoNRSuRybNMYdaFoYbcIMHufjLGghIYY7lH8kpdeDVj1AqeP6nO1ZrLfg6nVcwz4u1YVpaG8ga0JZOTZdZn71yM14QXfg5sEtOVYvt3Its5EKSaRCxPvESC9fTkIcKjbM+Ch+2D1m150/cUyfK/9foNORXT7gv0AiZm3JpUwifJ/7FLvEzCM4BEO6XMqRNYOdX6AFVUQzS/Tdr5w5mjcFOdDeohwemOZ3zZEWxJqWQR3/LHp3rYyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(2906002)(4326008)(2616005)(83380400001)(186003)(316002)(38100700002)(31696002)(31686004)(41300700001)(478600001)(86362001)(6512007)(110136005)(54906003)(82960400001)(5660300002)(66946007)(66476007)(66556008)(53546011)(6506007)(26005)(6666004)(8936002)(8676002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3RCcWp3MytYQ2RyK0ltSTBQeUdBSVUxczRkUkVDUHJ6KzhaOHFwcnJvYW9x?=
 =?utf-8?B?OFMwZGtLSHJDUkw2UzJkZExyWFoxcmllVC9Gbm41dmxZcHQrL0RPaUsycCtk?=
 =?utf-8?B?Wk1rdmdyY2ZTcWhkcGptYytzMlkrL1ZRWmFHcmJEeThEYmdQL1BxVEhtay96?=
 =?utf-8?B?emp2bHB2UlpnTXA4WGVPWmVFWEw4amJBSzB1TEE3b0ExaWpZMlp3UjhhWUcy?=
 =?utf-8?B?ZHV0YmdIVTlFZ1BGNHphQlVrZ3NJcnd4ZXhWaVVoQkExeDlqM0REaVQxaTZM?=
 =?utf-8?B?c29YV3JoOWQ5c21VekxDdFcvUk5Ga244R3NYajNvaXY2UnVCVjU5Vy93VDAz?=
 =?utf-8?B?ZFB2U0YxUTZ4RUwzU3U1ZjlCbk9VZFRLZWVGZzNDZFRUbUhpRDI3Rk1qUXpP?=
 =?utf-8?B?Z0NEc2lSMG84N3p2TzFWakxrMVlXOFBKT1ZVY0tyblhtT0J3ZElZL2R1Sm16?=
 =?utf-8?B?YlNZZmRhbXJic3RNTElZMWpxbVFGekxCMzQvVkUvVVJPTmxtanFkbVFjR2Ux?=
 =?utf-8?B?VmlZbEpvYVorSStxTGJ6M05rNFp2dEkyMWNsR0JxUGRGbDU0SzJkUUo3UkJr?=
 =?utf-8?B?L3NhaDFveXlSWE5ESy9oZ1orVFA2bW53QSt5VWtWbHB2cVhmMnJLTDZlamRQ?=
 =?utf-8?B?NHhQUy9XdTA4c2dKVXd2R3p0T2UwdTd1KzNKWnp5RnhPM0ppS1JNMGNJYVpu?=
 =?utf-8?B?dTlRVFFmcTBUWXVnbklVV2FaS0laS1FNUTFPTE1WRkl2TEdJZGt2ellYVXVG?=
 =?utf-8?B?MnpxdVdPUmtQSExhSDBkTlBPUzZLc3JGSllVbFZ5MGZOQm03MjQ0VUZCdWsx?=
 =?utf-8?B?bHVzRDhFY0M4QnU1WUFXQ2NBR3pHUk5kQURUZDBlREFXZ1NwYkU1emdERURn?=
 =?utf-8?B?U0d6S2wxbE1nTHlJUmdNelcxNXZpNENielljS2xsY1h3ZnEwTEFXVHdPUTZK?=
 =?utf-8?B?bldRZitUYWxpcTNGSnQ0U1lYbll4cVlpZzE5dU8xY0VRYVJXY3BHSmF5em90?=
 =?utf-8?B?Y2lJMFZZL05ZT0tRdU0wWW04ZnVML0wzZFRyUjhNa3VudThIQkJ5bTNMQmla?=
 =?utf-8?B?KzAySmFaMWNLUVZUS0l4UXVmZmp6OFgrT3d1MmwvYU9qaVBzc3d6bFB0UEhO?=
 =?utf-8?B?eDVueCtwUkR4YnN2azg2WlkyU1JGVEJnSmk2d25EK1FReGc5YlQvb1VWRmV0?=
 =?utf-8?B?YXdONGlCbHFrU1QzcC9NRmM1RUVTb1FTZ3hXNms4Z1Q5TGtVOFpSbGZjUVlz?=
 =?utf-8?B?Z0tNS3RBY3J2c05zNlNYd1oxUHVQajFsMktYYm5pcnVveERrZFNCaDJ3ZUtF?=
 =?utf-8?B?bWJNWmU5M0NHdkQvVUVtN3diSlA2YzlQVE9JeTc3cytRdWszaysvOTRXYlNC?=
 =?utf-8?B?SzhqQTBMdjlLQ1AyUXRKaGc1Q01ZRmlKeWtTUUN6d0JEem43SmtPUmVTdlQ3?=
 =?utf-8?B?WEtGaHFkQWd0WWQ4QUJrVTV2UHY5dlQ2aWZOcUl5SDlrSnJCd3UzamdkMUww?=
 =?utf-8?B?UVVOV2cvbkFqKzU4akhtVTY2VGM0bXFXait2YVNXSnJwRWQvVEtpUWZpTEZq?=
 =?utf-8?B?VGNmeWZoWTVRdkdrMWxFdGVSdXpsWEZtb3lCeTZYY25XenorTjEydkVWaWJR?=
 =?utf-8?B?U3hNSTk4QXd6amlSWGMwY3phYmxxVk9xdlRXYklQY2xnRVEvb3dNcks5NnVp?=
 =?utf-8?B?QWtXN3hEZU01cDFLbk11dkdsRzlzWnBDaEl5V2wxdlBYd05pYndzRG1yVHpG?=
 =?utf-8?B?eG9vUisxR1dqTlBhb0J4VHlkSy9iS0ZJcEVTSEd1aGg0c2prWVhSZ3ZwU05O?=
 =?utf-8?B?SDQvNXlrWEZVa2hsWmc3TTZYSE02REdTZVN2VnBrMmlaY0Y5UjNXTWdqMHlE?=
 =?utf-8?B?SnRtcFQ2bFhoVGN1TmRwREoyNlJKaEMxWjFHaTJ1MWJwQUVjYzZKY1JOSHBl?=
 =?utf-8?B?OEZmK0o0WS92Tm11UWNTR291bGIvbnZoK0NiNHBSVFB6TnYxWkdCT0xLK0tv?=
 =?utf-8?B?c1NZZENDZE41dWhXK0lpblQ2TWUrQWhzZDhHZVlPZXZBVmZKSW1uTVZ2ZTh5?=
 =?utf-8?B?bkJBTU5TU29pNVFSVVV5K2pWU0s4OTdWNzFlUTVWWXVqMm9VbmZpMVRkUTky?=
 =?utf-8?Q?I2njXLUF3mkl9MlVkVGYmmSiF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4165cf0-e84b-4853-9ebb-08db9283fdbf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:39:40.0886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjoLWNf8zO4LPsnbovE9Evry+0RU43j4NXVim1VvnuJMIX/dql/QXyMBiIUAcUht+yTK/44TXA1akihyw0XorQ==
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
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Switch from the poorly named and flawed ->track_flush_slot() to the newly
> introduced ->track_remove_region().  From KVMGT's perspective, the two
> hooks are functionally equivalent, the only difference being that
> ->track_remove_region() is called only when KVM is 100% certain the
> memory region will be removed, i.e. is invoked slightly later in KVM's
> memslot modification flow.
> 
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: handle name change, massage changelog, rebase]
> Tested-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 3ea3cb9eb599..3f2327455d85 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -108,9 +108,8 @@ struct gvt_dma {
>   
>   static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>   				   struct kvm_page_track_notifier_node *node);
> -static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> -		struct kvm_memory_slot *slot,
> -		struct kvm_page_track_notifier_node *node);
> +static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
> +					   struct kvm_page_track_notifier_node *node);
>   
>   static ssize_t intel_vgpu_show_description(struct mdev_type *mtype, char *buf)
>   {
> @@ -666,7 +665,7 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
>   		return -EEXIST;
>   
>   	vgpu->track_node.track_write = kvmgt_page_track_write;
> -	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
> +	vgpu->track_node.track_remove_region = kvmgt_page_track_remove_region;
>   	kvm_get_kvm(vgpu->vfio_device.kvm);
>   	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
>   					 &vgpu->track_node);
> @@ -1617,22 +1616,20 @@ static void kvmgt_page_track_write(gpa_t gpa, const u8 *val, int len,
>   	mutex_unlock(&info->vgpu_lock);
>   }
>   
> -static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> -		struct kvm_memory_slot *slot,
> -		struct kvm_page_track_notifier_node *node)
> +static void kvmgt_page_track_remove_region(gfn_t gfn, unsigned long nr_pages,
> +					   struct kvm_page_track_notifier_node *node)
>   {
>   	unsigned long i;
> -	gfn_t gfn;
>   	struct intel_vgpu *info =
>   		container_of(node, struct intel_vgpu, track_node);
>   
>   	mutex_lock(&info->vgpu_lock);
>   
> -	for (i = 0; i < slot->npages; i++) {
> -		gfn = slot->base_gfn + i;
> -		if (kvmgt_gfn_is_write_protected(info, gfn))
> -			kvmgt_protect_table_del(info, gfn);
> +	for (i = 0; i < nr_pages; i++) {
> +		if (kvmgt_gfn_is_write_protected(info, gfn + i))
> +			kvmgt_protect_table_del(info, gfn + i);
>   	}
> +
>   	mutex_unlock(&info->vgpu_lock);
>   }
>   
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
