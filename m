Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D269676B365
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 13:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjHALhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 07:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbjHALho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 07:37:44 -0400
Received: from mgamail.intel.com (unknown [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A152B10FA;
        Tue,  1 Aug 2023 04:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690889863; x=1722425863;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C8/QqTlgq+5Vf/KVxNYO1R4/pdYMwlbhJP1N9WpR/HA=;
  b=LENjccUfDx8KqluwefoOMbxoNug7/oMuBuyzWgEvN4ZC0Pk/nVQziCiM
   kPjYGGTYNTzjPdU1NzBt+X6pd2lOYA4PtnNEjjCRb6U5cHYKhT9n3SgKJ
   quj2JWoOsT70ghDG0TTGDdPzBYB63EZ+kUnfBn1yd09EIoLKAODYuqpbt
   dhpFJr5mFLTSeziXefG0IsqP6c8Z5easODznrZzrjQwa9BojUdSiAIxpv
   Yydj7y0gt4ybonupPdBDWqIroVwxchHnFaW6F+0R40LfpLtf85eCiMKqh
   tyix6/Z8ZyVjJ/5G6WZ7sFfZweRssICfyOgcaPmS4KtLWrEKyA2ihbTPb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="372903035"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="372903035"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 04:37:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="728657233"
X-IronPort-AV: E=Sophos;i="6.01,246,1684825200"; 
   d="scan'208";a="728657233"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 01 Aug 2023 04:37:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:37:42 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 04:37:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 04:37:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 04:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SX4GjmCC7XTK2wQit1bcww0tb4B+6fkQzl33vy/CTFqIfoe5sKlgPoLGTBBsLvXVfB/2jlW3IyZlaNCEmgMqqE3GFyKvsyuOxccMnWu3hHg/YUUABpFDVo6tmb4i+q8zaY2o+ITpSz+JO45Naug/pbRuDnGl70EUFuPRVDTEmXYL7yfQag5Rn89tnJSsucqPbjFK3K99+m65PjLSlPvD9fj0t36isrN/cR/TRq6JhO8wFHAAMsC6PwnDs4BpLl8TVcX62de9zuZnenYIkElhs6/DGySfA1ZLi7WSThP2qjdtbR0YsBAfQRuxChehAxAa4IL9VU1/2aWSJzb4A467+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqzJK0OXehPZrws+2G8EjVjgAcWiq9IyikFBBvtpcF4=;
 b=fKhn4vgYuOX9bApiAuzs750LC3EQCoNfYA/vDvQPzj754VRDcSFnc2f12/ErDD82T7zKhNpDE0VLvS9OIL0hTfjlmCrUp3MJ5ow2x7EQ6NBln4PF4c34vuBJ5z6G0svO7yWZpBYV4HpuUmspWDAZOmdKjXuHAzjVZxr9L0gR1WzOCaP6G6eisX4qQCeJDw2tEbIASZsNARJWMPNtLLySWC3Beujd9K3jzj3+XCkw5H4uOgKDzOnjKQWRvaN0xRBpV938KKb7u47xHPROKcjjKot1Ypk+ub7CjAQEw4gNCkIoReelKFy3d0Fkq+F/WlkT3mVq0B8oPf3cnHIhh7jnqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) by
 IA0PR11MB7379.namprd11.prod.outlook.com (2603:10b6:208:431::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.44; Tue, 1 Aug 2023 11:37:39 +0000
Received: from DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e]) by DM4PR11MB5549.namprd11.prod.outlook.com
 ([fe80::fa3f:a88:b8dd:5c8e%2]) with mapi id 15.20.6631.043; Tue, 1 Aug 2023
 11:37:39 +0000
Message-ID: <54fb226b-a4b6-92e5-92a8-e3e3f68e0d42@intel.com>
Date:   Tue, 1 Aug 2023 14:37:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 17/29] drm/i915/gvt: Don't bother removing
 write-protection on to-be-deleted slot
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>, <kvm@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>,
        <intel-gvt-dev@lists.freedesktop.org>
References: <20230729013535.1070024-1-seanjc@google.com>
 <20230729013535.1070024-18-seanjc@google.com>
From:   "Wang, Zhi A" <zhi.a.wang@intel.com>
In-Reply-To: <20230729013535.1070024-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0067.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::7) To DM4PR11MB5549.namprd11.prod.outlook.com
 (2603:10b6:5:388::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:EE_|IA0PR11MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f6b1871-fa5c-472e-adb7-08db9283b5e6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n9EU/LiD0ubHDZtIgaSrV2d8SrAgm1uyNVi6DuqSi7h8rgTam5i//0KaPmELjRPiUA4m1tAcDY4vn28vOeNXJD5a7QEfqPatVZ4vehsaikaK1IIASIeUQmOMWv/O4xLOJTa6i5c1LXH3ZrvykYlONXz54sAJlpGVGt8ayCucooaAUec3XfEBqpAbc8OmtoikXtOFvf7wCa1hXQY7PiMtAhUgGonsYIlZ6711TobVwqGoFLmr85fifrXQzdk4ne7/O5dprqyV+5yHXiNIBV2tKh64zElOLXX/PvEzM247h/aUoJCPUutTTQJkpXJkOFd8nEAJTKuOC4yVFn0jw3Tezv+0rIReX3FWAepAxdfYez4KIEjms6YfOSr6o15GrSURrG0wesPRFnO7RvtNWnDjXMaLmQTyplcmuFchNZnUl6lt9mYBjdEpiD9fnM1SZ/XDdSByfEPYExh4aSxGq3P8aiFtTynLGNEKQMof1zQxzRUhi9Tg7qcyoUu6FdDuWd+/f56+4mI/RoT4IhGZPDmnz0vskcDMYxkW7CfvGv2sG8Y96KvlBPONlePJtMDdRJ9ERoA1JlZv7femc3cCmHRG5BKEhUex0eDjoQ3uFZw6J8JJyjfYgD//FObG4Ua/oDq2PjG74gKAiEPOHbFNm2p8TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5549.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(2906002)(4326008)(2616005)(83380400001)(186003)(316002)(38100700002)(31696002)(31686004)(41300700001)(478600001)(86362001)(6512007)(110136005)(54906003)(82960400001)(5660300002)(66946007)(66476007)(66556008)(53546011)(6506007)(26005)(6666004)(8936002)(8676002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1lOaWlFam5pRnZ1TlpPYmFRelNQSGlWcnhPWWc5Qk5YSERzdmtCTmhMYTRE?=
 =?utf-8?B?enM0WlU5dWR2dnFVTUVzUkx6dlJCRWg5enFENVdZQXZwZzdUb1E4Z29yRlZE?=
 =?utf-8?B?Y05DNjVVQlVPbmRIeENDZm8xbCttbHV2bmJMTDBzcGMydmZXRmhDZ3d4UVcx?=
 =?utf-8?B?aGYybTdkT1BUWE5hSXNKdE9PRHFKaEZCbTF3ZWRvYUlDNjZiRjJtcDhQcGY4?=
 =?utf-8?B?Q2pPVldpOXBXN1NEc1dOd1hXeFZwZERXTzFvY2dwUVJ2TzgwMk4xRlJuMlBT?=
 =?utf-8?B?OE9ZM0U5RmdQU0pMQWw1Q29QS0huRXRibGF2REEreis1ZnRFd0JxM0dWNDlJ?=
 =?utf-8?B?M2Y2N3ZHUW9td1FKUUVpS3lqUHVXSWIxRHdtdmMzL3d1djNVVHYyMktjRjVm?=
 =?utf-8?B?REJsWGZDYzVmSHA3T200aTZTWGxYcmp2dW9yUUpPRExtY25FcTUwWHVRdFcx?=
 =?utf-8?B?U2JLdGVHOXNuZk9VNjAwT2tGNkM1VFVUMVV3QUtuU3Y5OHRYeGRBUlFOYWFE?=
 =?utf-8?B?Vi9LRGFUL21WYUNOZmtiMVFlTjJId0VmV2lzL1VENm5CSHMxb252RFYwT0g2?=
 =?utf-8?B?S3ZZTHg4eXgvVE5vZlpEejdxZ2IvU2dGTnllT25nWTE1L2dqditLZzliaXkw?=
 =?utf-8?B?L3IvRlBSWmsvUEorVUdEajR4YVo1TVUyVnBMekFSUStaQm9UcGVqWFl3MDF3?=
 =?utf-8?B?N2NjRWY4Q091dS83Wm83QkFybVJCK1EyYnVhRnduS3dtNlJEanlzVlJrKzFW?=
 =?utf-8?B?RTlHOEtCSXdPVFFGQ3cxcnRlbmh4Q3l0UlcrV3k1endabkRMU1dEYWtNWTlT?=
 =?utf-8?B?eHpTUTJyTE1OeDBNcGN1amd4VHJHTzBVb2t0SDNYT1JIZjRWWmZpeEdxdTBO?=
 =?utf-8?B?ODlxbnA5R2d1STdaazNac2YvREpETW0zbTMrb3JsZWpJaW5jWXJKdlpKMWx4?=
 =?utf-8?B?TlZLVTJRQ2p6MDdBWC9hM1ZXTnYxaEN1WWF5NlhIT3VNbEgwa2xyU3VBU3RB?=
 =?utf-8?B?RnRHL0tKMDU3Y0ZCNzVSNFUzY1U2b1BvaTE0TmJpYmNsUGdmZTFqWGlEeS9W?=
 =?utf-8?B?eGFEbTBUQ3ZhSU1MMFVFM2pHdzRNOHBZMEExWEJXVCtEU0hlUmltSHNMV1Ay?=
 =?utf-8?B?c0ZTMW1ncFNuTjl4UmRaRktCcDd2ckRkRnVIR0JrQWdNdmZOYVRQejdnczhS?=
 =?utf-8?B?Ty8zelN4SGJScFFaVDNHTEVMOWdHRGNscjdMUlhRRmRFdlVvVHRYVXgvNDB2?=
 =?utf-8?B?QnZLR2Z4UW40NFR0aVlxQm52Y1NIZ1FVa2dUdjRlN0pKYzc1VEcvQmk1bER6?=
 =?utf-8?B?ZnF3TVk4U0t0WFd0dnFLc3pYaEFoMlpXWHFXWDJJV3h6ZFg1UEt2ZG5zeWVW?=
 =?utf-8?B?VnFyZmdCQnhEMDQ5SG9pU2xUZVhIWmpsS2R3UzdFc2xGTGdrSURIdHhSRmtJ?=
 =?utf-8?B?aHVBZXc5YXphQXRFZksvbkFUa3doanNHd0o5TjkrSG12WUQvL0hWRXl5S09V?=
 =?utf-8?B?eGRFZS9zTGtPbEE3aXBYQ0RLSGozckNFd3ZrTkdNYlEwdHNjcEhKMWhDK242?=
 =?utf-8?B?QXpmSG5vbVBKdGxrMnEweEZUTUdxdXczeEtHR1FrRS9yVVNNQllhK25WQzIr?=
 =?utf-8?B?MzEzejIrZnNDYTUzNzJPVVNpOXhrb1ZiTE9zSW5IbWo0amFVUFhjb0ZudGli?=
 =?utf-8?B?U2NtMjVpeVhtTzVFWXN6MG5ScndFS20yeCtOMmlDZFlCU0cwVFZQUE9SZk5T?=
 =?utf-8?B?SHMrRzE3TzYxUGluMTY2ek5OUEFoUjdmZ1FDRG0xSmJMckJBcTVRUjNSZmln?=
 =?utf-8?B?T3lrQjluaUtENDJmY3ZlQ2hhSmoyVDY1M0cxd1BmcFA0N3UxN2tCd0VXUjFZ?=
 =?utf-8?B?K21aNWxTYzdpVlRZcHRneHJlS1owNjY3RnFlak42L0RJdnFyNEllbW42V0Vv?=
 =?utf-8?B?cGczNWw2dHp5NXZqb1lpRmp4Y2I1aWlGQlQ0UUxuY3l1ZzFGanFNeGV0VlVz?=
 =?utf-8?B?TUlzOHBUM0JCV05DNlNCVjdFeGJnMkh2d2ZsTTdpcTNnSUxiRzBxUWkwWmI3?=
 =?utf-8?B?UUM4YzZzbVhUbTJ5WEJvaWllazJURlZMS2JBV2NuOVNUOUFXYUhLbGZVNWE0?=
 =?utf-8?Q?3ZIQuLfzNeHfDHB8HrO3OYtv5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6b1871-fa5c-472e-adb7-08db9283b5e6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5549.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2023 11:37:39.5498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gRXB8s9pcvetNcMVmO3ymj+xaaqzyNLJM6hwL2T8RraePC92zOkZDVmiRXZlbppufUX+Gd4jexwkYd7wYEkVQ==
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
> When handling a slot "flush", don't call back into KVM to drop write
> protection for gfns in the slot.  Now that KVM rejects attempts to move
> memory slots while KVMGT is attached, the only time a slot is "flushed"
> is when it's being removed, i.e. the memslot and all its write-tracking
> metadata is about to be deleted.
> 
> Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e9276500435d..3ea3cb9eb599 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1630,14 +1630,8 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>   
>   	for (i = 0; i < slot->npages; i++) {
>   		gfn = slot->base_gfn + i;
> -		if (kvmgt_gfn_is_write_protected(info, gfn)) {
> -			write_lock(&kvm->mmu_lock);
> -			kvm_slot_page_track_remove_page(kvm, slot, gfn,
> -						KVM_PAGE_TRACK_WRITE);
> -			write_unlock(&kvm->mmu_lock);
> -
> +		if (kvmgt_gfn_is_write_protected(info, gfn))
>   			kvmgt_protect_table_del(info, gfn);
> -		}
>   	}
>   	mutex_unlock(&info->vgpu_lock);
>   }
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
