Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588BF62B0A7
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 02:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiKPBlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 20:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiKPBk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 20:40:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FA22A704;
        Tue, 15 Nov 2022 17:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668562854; x=1700098854;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OG3uE8kppiT6eb/RiYENvLbhE4EYDMTDuL4WGP4/i3g=;
  b=Y3nPSr/sPjewmSnRr5YcoMdosT7oJARR+TN36o/qvUJMBsU4btsDF2Bh
   pff8J0LLSZ0r1leJ2MW6jG00sPNbUnDCaEeVsSMPamHWpzqad52lbAKKi
   DEcjvc7xyH6L4LwPaIM8DtVkOLBtUAxHbSb0eUFxoTTTK0AniGKpPSHAX
   MoIGlCShAOwlRSjksIVwGd0yIgiCBmSGFL9ECOsxQ+qC4mY2A5o8p+Cn6
   ibvNIHUScHfpqQQUo5N7OnswJcJbRBmBM9l3FSCJH0ElVt6hvE5+/7qvW
   klJZPz/6YvzHe7NMKnyPorsV137lpxV50j/8zGND9Awtmh/try0yshMg0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="312424753"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="312424753"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 17:40:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="764134362"
X-IronPort-AV: E=Sophos;i="5.96,167,1665471600"; 
   d="scan'208";a="764134362"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 15 Nov 2022 17:40:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 17:40:52 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 17:40:52 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 15 Nov 2022 17:40:52 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 15 Nov 2022 17:40:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FH6EN3WMZ0DWWu9bvqFVRl2m9brNJZcKZgL1jPyf1TIrn0avXjbMKcfR14ylumg8o91IcHLGk/croLQTxYi4dYqdAVMEbxBEUwfdZ8UvzaWLppXanHPq30cZDuxBx1nMOAXhOEWdE75ZD74rJW9+vpr1WE32yrsFlHh5AfEpIRkL8+yyhd6B71nqQFByY//fiy/2Gup/g/fLTNljejC8CJWj3spyRwukiKxhfk3o0xu2OgVVthlDY5w0oyXaAx3urwPGh3Yf5nFHh2L/mGbi6g6p/M1NHLe0PI5I4SNa60S8F1OMyFJYjzrQ8pGwsBO/+o2AL8HgPbKhinunE1suqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRqFuo9J6QgtzfE81jFPck/rUj0/wHbM3PAQmPBeMZ0=;
 b=OqX5wxsroUIzR+dCom4Wr4VBTUeNj/FcBpVhQZBnMKlsUcGFZ4NY92zNxIH5Iw8a+JsFMGnOZbjFmdZSvJULuGUqPidFJnmAUhfl4m0cCnrbqTeZGnpBiKKBVpo77N6kp+/kmG47upK8G0nhC4nY3JMiKAa71KtdQryIZqtg6Cu6NsOuYOOjisJg8+dFBBS7j3FSGRtfAgE3cmkDUzVgyfuhHxaMWiNObjEs9IWU37pdRfbEjZg44XsjFqsCUTp7GHkCTjmgjzIAHNwVmpfIyBif71mFs/HXHFOdy4qLc4eEMizmGiPR/KSRebx3tu4DvSvx+bZVtkeWcXkyQVBByg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by SA2PR11MB5114.namprd11.prod.outlook.com (2603:10b6:806:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 01:40:48 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::d95b:a6f1:ed4d:5327%9]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 01:40:48 +0000
Message-ID: <67b782ee-c95c-d6bc-3cca-cdfe75f4bf6a@intel.com>
Date:   Wed, 16 Nov 2022 09:40:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Content-Language: en-US
To:     <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|SA2PR11MB5114:EE_
X-MS-Office365-Filtering-Correlation-Id: 30bfe09f-9ecf-463e-1a56-08dac77395e0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X86GikzYLNdrDNEv1t7FiUnEIi3QmjwfdFOisfbSeAcXEm5+O4GJJ3rrI/KI6KN3YuLNnP9FNINV/gqk6H5WukGK2JfOpFJ7X7g/rekeKPQSaT2V+yxNZMiIEkB58KRyweqcChqY7s94C82kBasasbon5QTbruU7fJxLEPXsd0Zvyi13zz2FFaQfAg4mi/kJQCDR5xu0utVyLUiavFdSEMnUIKNPRAH+RvG7tMc6A7mnLVH5q5nDrtkakrp8DhdvfeIzFpR0WO6MfMlPxVLGmg3we9S+Q+z6t4R9Oc7VoBE3t7aCnz/OZjagHMM5Sckg/JPsrIgrukoVGXS5WyM0GaTZKS3Ta5OK53xBLq41u+r92A6BB5mj4W4s6UU8rEoNJS6hdCheTUwO6hsWsz4GauW2u8mA5QjI2YzhiE96g1rmUVdribLBHLUfZClGZIqYfq8wcA7FKyZ/wiIcdfEzcC9VkGs798e5DIRFobKjWqcAEsr6QNIARNd35zSDyxo5SDpkGUjoGYmeG/QGVqkDXbkqXOVF7j0Wmuv+II7Q8t1XJjSqQfzrzZR9uDJkgZxivKBTCSQAQGQFuBgLmq2Akiz/QhtRR/jE2wRiV0C+pgwxsH+LXbmzU7SDkZ/j8Y6LusZO4QKRsb+surrbxPB2iDzyir5HsvojyTKHGSsRgVWw6ZcKq+kaImysz/AC7lRWBpR/OY1zKh/+tI/mMD4cb3tXHIFtUPO09dk3G6ew4pAwR9vENV3loRi3u1FtGWO9G3zWIW+EEGWJ/iFL2WHDFTOMx4wqAs3K33G/LBO5Gzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(31686004)(478600001)(53546011)(6506007)(6486002)(54906003)(107886003)(6666004)(86362001)(316002)(6512007)(82960400001)(31696002)(26005)(38100700002)(8676002)(4326008)(8936002)(36756003)(66556008)(66946007)(41300700001)(66476007)(44832011)(2616005)(186003)(5660300002)(83380400001)(30864003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzFBa09ZSW1pZGhWU3d0dlg5VzhJSlVDWjNnVVFNRmgyenJlZjYvSUhJR1dk?=
 =?utf-8?B?c3FMbzNjZENaUFVSUWduOTgrWExZcUIzNTk0OXlQUHNzNVZVTFFHME9oSng3?=
 =?utf-8?B?OEJqUk5kdGNYaEhyQzlWanVYUE45c29HbnRDOTdHNWtuUGRBdFJvTVQ3VkVF?=
 =?utf-8?B?TXNLYyszaXM1V0ZsQUJvUWN6YzVRTUwvdXdBa1lxUjY2NGhjSzNmcFFBdU1Q?=
 =?utf-8?B?Q0RlQkN5NkZScUdaVkVLTmpWU08zRHZyWHNYRWlXZSttMWI5NGhxcVhibXdI?=
 =?utf-8?B?Vjl6Q0pLUS9iOEJhZG1seHlUanVyOWZaK3lWZWE4NGNscnpzbVB4bTlHOTFt?=
 =?utf-8?B?YkEyNWIyajNyMXQzbkxXNlZJenUxbEJzSk4yS3preHFMRWJDTWE0SW40Z0lX?=
 =?utf-8?B?aEo3WkY1MGRzcFk3TTJPSHZrazFtWDNWWkpIMlpKYk5icVlDMy90d2x6Si9w?=
 =?utf-8?B?dy9PaEN0KytGd1djc0hyRUZuM3h3T0JyQ1BrUGlwSkhBcVNEaWFkQnQzZWl3?=
 =?utf-8?B?R3pka3o3Vkk4aDk3eFRveGlLYzQvRXc2ZzRQYm1sanpiNi9LQXhCSjlVdzdS?=
 =?utf-8?B?SnhKUHRqeFBrbytSbUhCOXB5andnaGZyaG4vU2xjK2xudWFudjJwQXBBOXdh?=
 =?utf-8?B?dHJ2a3d5NjFxSWxkcld2cFlsaCtQTXlwUFo1ek5NUWZhcE1MeE9MSkhrUlhq?=
 =?utf-8?B?ZTRoQ2tDSmlkclJ2LzhtL1F4NXIwT2NObGZrNCtlMmxNSTNkalVjRlJpeFVm?=
 =?utf-8?B?M08wTTVyV1c4TkRETUpWZUhQSDIveDVaenU4UlNhWWRvZEgyYkZXOHQzSVh1?=
 =?utf-8?B?M1Z5Q1RLRGhqV1B3Mi8zYXRpYlZzNlZRVStHUFRCUGo2WmZDNGV6ejIvZWha?=
 =?utf-8?B?Nk1QQndzSEx5ejZLK25jNHVrNm5INitmUFoxdHlnSzk3V2tTNGNZeFg5Unpj?=
 =?utf-8?B?SWoyZy9yNVpINHNuM01RaVpudSt6dWdHVW9KRkFoWXlOL1hJL3lldFY0TnVj?=
 =?utf-8?B?VTl6a2hsWHRGTHB3emVBRUsxNHc0WWNEZ0FScjlyQ1VGNk5BdnFqU1lUTVJU?=
 =?utf-8?B?TEpmc0xuUDVkT25PaVlOMTZYUTN4eUhlcUNXdnpmM1cyNDhqekZPSnpvWVUw?=
 =?utf-8?B?WUZRMmdkSnMvTFBOZVcvWElLdmwrK3VzZXhxWHUyQ0k2MmsrRFdNbmcvbTdv?=
 =?utf-8?B?SktkY2VkMlJ5RS9DYXNyNHFqMjFkSi80M3NOclRQOVZnZ3REb2Z5OG5QeG91?=
 =?utf-8?B?MVh3UmdsVTJCZnVnelI2cTVQaEl4dTE4L2gyV2tacVdYZ1R3cnNuL0ZoSGlp?=
 =?utf-8?B?dDJlWVFNdnM0blM2UGZaSlRZeVR4aVgrSzZqcFJCUGt0WFp6OXZGZXVQZEFn?=
 =?utf-8?B?U3BSWXJaUnNFVlVzeXhyQkFjRkZlWGJCcURLaVgyeEptL3hZRUxwZG9oejNS?=
 =?utf-8?B?S1N0NTkxRkl4NlF0SlIyU1hvcHZ5RnB5S3Q3ZTlIUlZGdHBuOWFKU1dQbWZD?=
 =?utf-8?B?eklTUEwxRGczSytuL2tmU0xVYzBXckhPQjBmVGh3TThtejZCKzVvb3hmV3JL?=
 =?utf-8?B?NEhzWTQwR1N5QjErRGhMb054eFRsUU1lMHJ4bGNZbnVqT3hqY0ExRUhzQi9S?=
 =?utf-8?B?akkvMjFNQ0czU3prdDVaMlMzeWVaNElQajlHc0N1VWlEZ1dMTXVUWnVicVYx?=
 =?utf-8?B?STJjUGZEcFMrN1NFWXZkWDE5T0dYdkh5NjVTMVh6SDYzQVo5Y0JLbUU3VDRq?=
 =?utf-8?B?OWFJK3V0ekl4WkJjRDZDd3JKQ0s4bmVCNFdKajBuSks1SXdYUXVuQ29ITFA1?=
 =?utf-8?B?ZE56NFBtRk9pWFhFUEROeHF1T2QzTFNCZnNpZmVvYmhqMXhZS2tLTEdrVzNQ?=
 =?utf-8?B?TDVvZzBBOU4wZkZ3bTR0c3JTNERERFJFZGF1WngyTXp3WjJveXBEblp1bHhV?=
 =?utf-8?B?Z25FNi9vQUtSK1VCTUQzNy9jbGRIcnBXQUJBY1lRSUxJcjJmSm5CcWpXcWl6?=
 =?utf-8?B?RW5qQlhBcFU1SzlFSkFYZ3lQd1dFcWZlbDZjY0pIRHpoVkc2bXdzRHhGT3Nw?=
 =?utf-8?B?MjJmOFpCWk4zSDZWenFja0ViWkl0NCtqSis0ejV3TW5QVFRhSktyRWRRT2Rr?=
 =?utf-8?Q?77XeFSL/YFiCBgHrn9suM7MX4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bfe09f-9ecf-463e-1a56-08dac77395e0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 01:40:48.4140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IKKQObpEw0C+pZHmCS4j73VArP6axt158/8m7IXen3GABBJ88BdfB4m4BRPfmXGy2cmY32vthmETafInoXSJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:22 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Allocate protected page table for private page table, and add hooks to
> operate on protected page table.  This patch adds allocation/free of
> protected page tables and hooks.  When calling hooks to update SPTE entry,
> freeze the entry, call hooks and unfree the entry to allow concurrent
> updates on page tables.  Which is the advantage of TDP MMU.  As
> kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
> with this patch.
>
> When the faulting GPA is private, the KVM fault is called private.  When
> resolving private KVM, allocate protected page table and call hooks to
> operate on protected page table. On the change of the private PTE entry,
> invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
> to protected page table. The following depicts the relationship.
>
>    private KVM page fault   |
>        |                    |
>        V                    |
>   private GPA               |     CPU protected EPTP
>        |                    |           |
>        V                    |           V
>   private PT root           |     protected PT root
>        |                    |           |
>        V                    |           V
>     private PT --hook to propagate-->protected PT
>        |                    |           |
>        \--------------------+------\    |
>                             |      |    |
>                             |      V    V
>                             |    private guest page
>                             |
>                             |
>       non-encrypted memory  |    encrypted memory
>                             |
> PT: page table
>
> The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
> the EPT entry, atomically set the entry.  However, it requires TLB
> shootdown to zap SPTE.  To address it, the entry is frozen with the special
> SPTE value that clears the present bit. After the TLB shootdown, the entry
> is set to the eventual value (unfreeze).
>
> For protected page table, hooks are called to update protected page table
> in addition to direct access to the private SPTE. For the zapping case, it
> works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
> For populating the private SPTE entry, there can be a race condition
> without further protection
>
>    vcpu 1: populating 2M private SPTE
>    vcpu 2: populating 4K private SPTE
>    vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
>    vcpu 1: TDX SEAMCALL to update 2M protected SPTE
>
> To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
> of the private entry, freeze the entry, call the hook that update protected
> SPTE, set the entry to the final value.
>
> Support 4K page only at this stage.  2M page support can be done in future
> patches.
>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |   5 +
>   arch/x86/include/asm/kvm_host.h    |  11 ++
>   arch/x86/kvm/mmu/mmu.c             |  15 +-
>   arch/x86/kvm/mmu/mmu_internal.h    |  32 ++++
>   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c         | 244 +++++++++++++++++++++++++----
>   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
>   virt/kvm/kvm_main.c                |   1 +
>   8 files changed, 280 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index f28c9fd72ac4..1b01dc2098b0 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -94,6 +94,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP_OPTIONAL(link_private_spt)
> +KVM_X86_OP_OPTIONAL(free_private_spt)
> +KVM_X86_OP_OPTIONAL(set_private_spte)
> +KVM_X86_OP_OPTIONAL(remove_private_spte)
> +KVM_X86_OP_OPTIONAL(zap_private_spte)
>   KVM_X86_OP(has_wbinvd_exit)
>   KVM_X86_OP(get_l2_tsc_offset)
>   KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 381df2c8136d..5f9634c130d0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -467,6 +467,7 @@ struct kvm_mmu {
>   			 struct kvm_mmu_page *sp);
>   	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
>   	struct kvm_mmu_root_info root;
> +	hpa_t private_root_hpa;
>   	union kvm_cpu_role cpu_role;
>   	union kvm_mmu_page_role root_role;
>   
> @@ -1613,6 +1614,16 @@ struct kvm_x86_ops {
>   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			     int root_level);
>   
> +	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				void *private_spt);
> +	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				void *private_spt);
> +	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				 kvm_pfn_t pfn);
> +	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				    kvm_pfn_t pfn);
> +	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
> +
>   	bool (*has_wbinvd_exit)(void);
>   
>   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0237e143299c..02e7b5cf3231 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3646,7 +3646,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>   		goto out_unlock;
>   
>   	if (is_tdp_mmu_enabled(vcpu->kvm)) {
> -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> +		if (kvm_gfn_shared_mask(vcpu->kvm) &&
> +		    !VALID_PAGE(mmu->private_root_hpa)) {
> +			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> +			mmu->private_root_hpa = root;
> +		}
> +		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
>   		mmu->root.hpa = root;
>   	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>   		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> @@ -4357,7 +4362,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   	unsigned long mmu_seq;
>   	int r;
>   
> -	fault->gfn = fault->addr >> PAGE_SHIFT;
> +	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
>   	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
>   
>   	if (page_fault_handle_page_track(vcpu, fault))
> @@ -5893,6 +5898,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>   
>   	mmu->root.hpa = INVALID_PAGE;
>   	mmu->root.pgd = 0;
> +	mmu->private_root_hpa = INVALID_PAGE;
>   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>   		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
>   
> @@ -6116,7 +6122,7 @@ static void kvm_mmu_zap_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>   		};
>   
>   		/*
> -		 * this handles both private gfn and shared gfn.
> +		 * This handles both private gfn and shared gfn.
>   		 * All private page should be zapped on memslot deletion.
>   		 */
>   		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush, true);
> @@ -6919,6 +6925,9 @@ int kvm_mmu_vendor_module_init(void)
>   void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>   {
>   	kvm_mmu_unload(vcpu);
> +	if (is_tdp_mmu_enabled(vcpu->kvm))
> +		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> +				NULL);
>   	free_mmu_pages(&vcpu->arch.root_mmu);
>   	free_mmu_pages(&vcpu->arch.guest_mmu);
>   	mmu_free_memory_caches(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 4c013124534b..508e8402c07a 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -6,6 +6,8 @@
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_host.h>
>   
> +#include "mmu.h"
> +
>   #undef MMU_DEBUG
>   
>   #ifdef MMU_DEBUG
> @@ -209,11 +211,29 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu,
>   	}
>   }
>   
> +static inline int kvm_alloc_private_spt_for_split(struct kvm_mmu_page *sp, gfp_t gfp)
> +{
> +	gfp &= ~__GFP_ZERO;
> +	sp->private_spt = (void *)__get_free_page(gfp);
> +	if (!sp->private_spt)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
>   static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
>   {
>   	if (sp->private_spt)
>   		free_page((unsigned long)sp->private_spt);
>   }
> +
> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +				     gfn_t gfn)
> +{
> +	if (is_private_sp(root))
> +		return kvm_gfn_private(kvm, gfn);
> +	else
> +		return kvm_gfn_shared(kvm, gfn);
> +}
>   #else
>   static inline void *kvm_mmu_private_spt(struct kvm_mmu_page *sp)
>   {
> @@ -230,9 +250,20 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu,
>   {
>   }
>   
> +static inline int kvm_alloc_private_spt_for_split(struct kvm_mmu_page *sp, gfp_t gfp)
> +{
> +	return -ENOMEM;
> +}
> +
>   static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
>   {
>   }
> +
> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> +				     gfn_t gfn)
> +{
> +	return gfn;
> +}
>   #endif
>   
>   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
> @@ -367,6 +398,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
>   		.nx_huge_page_workaround_enabled =
>   			is_nx_huge_page_enabled(vcpu->kvm),
> +		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
>   
>   		.max_level = vcpu->kvm->arch.tdp_max_page_level,
>   		.req_level = PG_LEVEL_4K,
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index 9e56a5b1024c..eab62baf8549 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -71,7 +71,7 @@ struct tdp_iter {
>   	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
>   	/* A pointer to the current SPTE */
>   	tdp_ptep_t sptep;
> -	/* The lowest GFN mapped by the current SPTE */
> +	/* The lowest GFN (shared bits included) mapped by the current SPTE */
>   	gfn_t gfn;
>   	/* The level of the root page given to the iterator */
>   	int root_level;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bdb50c26849f..0e053b96444a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -285,6 +285,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
>   	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
>   	sp->role = role;
>   
> +	if (kvm_mmu_page_role_is_private(role))
> +		kvm_mmu_alloc_private_spt(vcpu, NULL, sp);
> +
>   	return sp;
>   }
>   
> @@ -305,7 +308,8 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>   	trace_kvm_mmu_get_page(sp, true);
>   }
>   
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
> +						      bool private)
>   {
>   	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
>   	struct kvm *kvm = vcpu->kvm;
> @@ -317,6 +321,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>   	 * Check for an existing root before allocating a new one.  Note, the
>   	 * role check prevents consuming an invalid root.
>   	 */
> +	if (private)
> +		kvm_mmu_page_role_set_private(&role);
>   	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
>   		if (root->role.word == role.word &&
>   		    kvm_tdp_mmu_get_root(root))
> @@ -333,11 +339,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
>   	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>   
>   out:
> -	return __pa(root->spt);
> +	return root;
> +}
> +
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
> +{
> +	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
>   }
>   
>   static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -					    u64 old_spte, u64 new_spte, int level,
> +					    u64 old_spte, u64 new_spte,
> +					    union kvm_mmu_page_role role,
>   					    bool shared);
>   
>   static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
> @@ -364,6 +376,8 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>   
>   	if ((!is_writable_pte(old_spte) || pfn_changed) &&
>   	    is_writable_pte(new_spte)) {
> +		/* For memory slot operations, use GFN without aliasing */
> +		gfn = gfn & ~kvm_gfn_shared_mask(kvm);
>   		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
>   		mark_page_dirty_in_slot(kvm, slot, gfn);
>   	}
> @@ -500,7 +514,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   							  REMOVED_SPTE, level);
>   		}
>   		ret = handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -					  old_spte, REMOVED_SPTE, level, shared);
> +					  old_spte, REMOVED_SPTE, sp->role,
> +					  shared);
>   		/*
>   		 * We are removing page tables.  Because in TDX case we don't
>   		 * zap private page tables except tearing down VM.  It means
> @@ -509,9 +524,81 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>   		WARN_ON_ONCE(ret);
>   	}
>   
> +	if (is_private_sp(sp) &&
> +	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
> +							  kvm_mmu_private_spt(sp)))) {
> +		/*
> +		 * Failed to unlink Secure EPT page and there is nothing to do
> +		 * further.  Intentionally leak the page to prevent the kernel
> +		 * from accessing the encrypted page.
> +		 */
> +		kvm_mmu_init_private_spt(sp, NULL);
> +	}
> +
>   	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>   }
>   
> +static void *get_private_spt(gfn_t gfn, u64 new_spte, int level)
> +{
> +	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
> +		struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(spte_to_pfn(new_spte)));
> +		void *private_spt = kvm_mmu_private_spt(sp);
> +
> +		WARN_ON_ONCE(!private_spt);
> +		WARN_ON_ONCE(sp->role.level + 1 != level);
> +		WARN_ON_ONCE(sp->gfn != gfn);
> +		return private_spt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int __must_check handle_changed_private_spte(struct kvm *kvm, gfn_t gfn,
> +						    u64 old_spte, u64 new_spte,
> +						    int level)
> +{
> +	bool was_present = is_shadow_present_pte(old_spte);
> +	bool is_present = is_shadow_present_pte(new_spte);
> +	bool was_leaf = was_present && is_last_spte(old_spte, level);
> +	bool is_leaf = is_present && is_last_spte(new_spte, level);
> +	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> +	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> +	int ret;

int ret = 0;

> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	if (is_present) {
> +		/* TDP MMU doesn't change present -> present */
> +		KVM_BUG_ON(was_present, kvm);
> +
> +		/*
> +		 * Use different call to either set up middle level
> +		 * private page table, or leaf.
> +		 */
> +		if (is_leaf)
> +			ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
> +		else {
> +			void *private_spt = get_private_spt(gfn, new_spte, level);
> +
> +			KVM_BUG_ON(!private_spt, kvm);
> +			ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
> +		}
> +	} else if (was_leaf) {
> +		/* non-present -> non-present doesn't make sense. */
> +		KVM_BUG_ON(!was_present, kvm);
> +		/*
> +		 * Zap private leaf SPTE.  Zapping private table is done
> +		 * below in handle_removed_tdp_mmu_page().
> +		 */
> +		lockdep_assert_held_write(&kvm->mmu_lock);
> +		ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> +		if (!ret) {
> +			ret = static_call(kvm_x86_remove_private_spte)(kvm, gfn, level, old_pfn);
> +			WARN_ON_ONCE(ret);
> +		}
> +	}

Otherwise, "ret" may be returned without initialization. Then it will 
trigger the WARN_ON_ONCE(ret) after handle_changed_spte() in patch 48.

> +	return ret;
> +}
> +
>   /**
>    * __handle_changed_spte - handle bookkeeping associated with an SPTE change
>    * @kvm: kvm instance
> @@ -519,7 +606,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>    * @gfn: the base GFN that was mapped by the SPTE
>    * @old_spte: The value of the SPTE before the change
>    * @new_spte: The value of the SPTE after the change
> - * @level: the level of the PT the SPTE is part of in the paging structure
> + * @role: the role of the PT the SPTE is part of in the paging structure
>    * @shared: This operation may not be running under the exclusive use of
>    *	    the MMU lock and the operation must synchronize with other
>    *	    threads that might be modifying SPTEs.
> @@ -528,14 +615,18 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>    * This function must be called for all TDP SPTE modifications.
>    */
>   static int __must_check __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -					      u64 old_spte, u64 new_spte, int level,
> -					      bool shared)
> +					      u64 old_spte, u64 new_spte,
> +					      union kvm_mmu_page_role role, bool shared)
>   {
> +	bool is_private = kvm_mmu_page_role_is_private(role);
> +	int level = role.level;
>   	bool was_present = is_shadow_present_pte(old_spte);
>   	bool is_present = is_shadow_present_pte(new_spte);
>   	bool was_leaf = was_present && is_last_spte(old_spte, level);
>   	bool is_leaf = is_present && is_last_spte(new_spte, level);
> -	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
> +	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> +	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> +	bool pfn_changed = old_pfn != new_pfn;
>   
>   	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
>   	WARN_ON(level < PG_LEVEL_4K);
> @@ -602,7 +693,7 @@ static int __must_check __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t
>   
>   	if (was_leaf && is_dirty_spte(old_spte) &&
>   	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		kvm_set_pfn_dirty(old_pfn);
>   
>   	/*
>   	 * Recursively handle child PTs if the change removed a subtree from
> @@ -611,26 +702,42 @@ static int __must_check __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t
>   	 * pages are kernel allocations and should never be migrated.
>   	 */
>   	if (was_present && !was_leaf &&
> -	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> +	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
> +		KVM_BUG_ON(is_private != is_private_sptep(spte_to_child_pt(old_spte, level)),
> +			   kvm);
>   		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> +	}
>   
> +	/*
> +	 * Special handling for the private mapping.  We are either
> +	 * setting up new mapping at middle level page table, or leaf,
> +	 * or tearing down existing mapping.
> +	 *
> +	 * This is after handling lower page table by above
> +	 * handle_remove_tdp_mmu_page().  Secure-EPT requires to remove
> +	 * Secure-EPT tables after removing children.
> +	 */
> +	if (is_private &&
> +	    /* Ignore change of software only bits. e.g. host_writable */
> +	    (was_leaf != is_leaf || was_present != is_present || pfn_changed))
> +		return handle_changed_private_spte(kvm, gfn, old_spte, new_spte, role.level);
>   	return 0;
>   }
>   
>   static int __must_check handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -					    u64 old_spte, u64 new_spte, int level,
> +					    u64 old_spte, u64 new_spte,
> +					    union kvm_mmu_page_role role,
>   					    bool shared)
>   {
>   	int ret;
>   
> -	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> -				    shared);
> +	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, shared);
>   	if (ret)
>   		return ret;
>   
> -	handle_changed_spte_acc_track(old_spte, new_spte, level);
> +	handle_changed_spte_acc_track(old_spte, new_spte, role.level);
>   	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> -				      new_spte, level);
> +				      new_spte, role.level);
>   	return 0;
>   }
>   
> @@ -656,6 +763,24 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
>   						       struct tdp_iter *iter,
>   						       u64 new_spte)
>   {
> +	/*
> +	 * For conventional page table, the update flow is
> +	 * - update STPE with atomic operation
> +	 * - handle changed SPTE. __handle_changed_spte()
> +	 * NOTE: __handle_changed_spte() (and functions) must be safe against
> +	 * concurrent update.  It is an exception to zap SPTE.  See
> +	 * tdp_mmu_zap_spte_atomic().
> +	 *
> +	 * For private page table, callbacks are needed to propagate SPTE
> +	 * change into the protected page table.  In order to atomically update
> +	 * both the SPTE and the protected page tables with callbacks, utilize
> +	 * freezing SPTE.
> +	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
> +	 * - Trigger callbacks for protected page tables. __handle_changed_spte()
> +	 * - Unfreeze the SPTE.  Set the entry to new_spte.
> +	 */
> +	bool freeze_spte = is_private_sptep(iter->sptep) && !is_removed_spte(new_spte);
> +	u64 tmp_spte = freeze_spte ? REMOVED_SPTE : new_spte;
>   	u64 *sptep = rcu_dereference(iter->sptep);
>   	int ret;
>   
> @@ -673,14 +798,24 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
>   	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>   	 * does not hold the mmu_lock.
>   	 */
> -	if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> +	if (!try_cmpxchg64(sptep, &iter->old_spte, tmp_spte))
>   		return -EBUSY;
>   
>   	ret = __handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -				    new_spte, iter->level, true);
> +				    new_spte, sptep_to_sp(sptep)->role, true);
>   	if (!ret)
>   		handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
>   
> +	if (ret) {
> +		/*
> +		 * !freeze_spte means this fault isn't private.  No call to
> +		 * operation on Secure EPT.
> +		 */
> +		WARN_ON_ONCE(!freeze_spte);
> +		__kvm_tdp_mmu_write_spte(sptep, iter->old_spte);
> +	} else if (freeze_spte)
> +		__kvm_tdp_mmu_write_spte(sptep, new_spte);
> +
>   	return ret;
>   }
>   
> @@ -750,6 +885,7 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>   			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
>   			      bool record_acc_track, bool record_dirty_log)
>   {
> +	union kvm_mmu_page_role role;
>   	int ret;
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
> @@ -765,7 +901,9 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>   
>   	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
>   
> -	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
> +	role = sptep_to_sp(sptep)->role;
> +	role.level = level;
> +	ret = __handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
>   	/* Because write spin lock is held, no race.  It should success. */
>   	WARN_ON_ONCE(ret);
>   
> @@ -819,8 +957,11 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>   			continue;					\
>   		else
>   
> -#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
> -	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
> +#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
> +	for_each_tdp_pte(_iter,						\
> +		 to_shadow_page((_private) ? _mmu->private_root_hpa :	\
> +				_mmu->root.hpa),			\
> +		_start, _end)
>   
>   /*
>    * Yield if the MMU lock is contended or this thread needs to return control
> @@ -983,6 +1124,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   	if (!zap_private && is_private_sp(root))
>   		return false;
>   
> +	/*
> +	 * start and end doesn't have GFN shared bit.  This function zaps
> +	 * a region including alias.  Adjust shared bit of [start, end) if the
> +	 * root is shared.
> +	 */
> +	start = kvm_gfn_for_root(kvm, root, start);
> +	end = kvm_gfn_for_root(kvm, root, end);
> +
>   	rcu_read_lock();
>   
>   	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> @@ -1111,10 +1260,19 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   	WARN_ON(sp->role.level != fault->goal_level);
>   	if (unlikely(!fault->slot))
>   		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> -	else
> -		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> -					 fault->map_writable, &new_spte);
> +	else {
> +		unsigned long pte_access = ACC_ALL;
> +		gfn_t gfn_unalias = iter->gfn & ~kvm_gfn_shared_mask(vcpu->kvm);
> +
> +		/* TDX shared GPAs are no executable, enforce this for the SDV. */
> +		if (kvm_gfn_shared_mask(vcpu->kvm) && !fault->is_private)
> +			pte_access &= ~ACC_EXEC_MASK;
> +
> +		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
> +				   gfn_unalias, fault->pfn, iter->old_spte,
> +				   fault->prefetch, true, fault->map_writable,
> +				   &new_spte);
> +	}
>   
>   	if (new_spte == iter->old_spte)
>   		ret = RET_PF_SPURIOUS;
> @@ -1214,6 +1372,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   {
>   	struct kvm_mmu *mmu = vcpu->arch.mmu;
>   	struct tdp_iter iter;
> +	gfn_t raw_gfn;
> +	bool is_private = fault->is_private;
>   	int ret;
>   
>   	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1222,7 +1382,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   
>   	rcu_read_lock();
>   
> -	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> +	raw_gfn = gpa_to_gfn(fault->addr);
> +
> +	if (is_error_noslot_pfn(fault->pfn) ||
> +	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
> +		if (is_private) {
> +			rcu_read_unlock();
> +			return -EFAULT;
> +		}
> +	}
> +
> +	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
>   		if (fault->nx_huge_page_workaround_enabled)
>   			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>   
> @@ -1238,6 +1408,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   		    is_large_pte(iter.old_spte)) {
>   			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>   				break;
> +			/*
> +			 * TODO: large page support.
> +			 * Doesn't support large page for TDX now
> +			 */
> +			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
> +
>   
>   			/*
>   			 * The iter must explicitly re-read the spte here
> @@ -1480,6 +1656,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
>   
>   	sp->role = role;
>   	sp->spt = (void *)__get_free_page(gfp);
> +	if (kvm_mmu_page_role_is_private(role)) {
> +		if (kvm_alloc_private_spt_for_split(sp, gfp)) {
> +			free_page((unsigned long)sp->spt);
> +			sp->spt = NULL;
> +		}
> +	}
>   	if (!sp->spt) {
>   		kmem_cache_free(mmu_page_header_cache, sp);
>   		return NULL;
> @@ -1495,6 +1677,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
>   	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
>   	struct kvm_mmu_page *sp;
>   
> +	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
> +		   is_private_sptep(iter->sptep), kvm);
> +	/* TODO: Large page isn't supported for private SPTE yet. */
> +	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
> +
>   	/*
>   	 * Since we are allocating while under the MMU lock we have to be
>   	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
> @@ -1929,7 +2116,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>   	if (WARN_ON_ONCE(kvm_gfn_shared_mask(vcpu->kvm)))
>   		return leaf;
>   
> -	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> +	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
>   		leaf = iter.level;
>   		sptes[leaf] = iter.old_spte;
>   	}
> @@ -1956,7 +2143,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
>   	gfn_t gfn = addr >> PAGE_SHIFT;
>   	tdp_ptep_t sptep = NULL;
>   
> -	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> +	/* fast page fault for private GPA isn't supported. */
> +	WARN_ON_ONCE(kvm_is_private_gpa(vcpu->kvm, addr));
> +
> +	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
>   		*spte = iter.old_spte;
>   		sptep = iter.sptep;
>   	}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c98c7df449a8..695175c921a5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -5,7 +5,7 @@
>   
>   #include <linux/kvm_host.h>
>   
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
>   
>   __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
>   {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dda2f2ec4faa..8c996f40b544 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -211,6 +211,7 @@ struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn)
>   
>   	return NULL;
>   }
> +EXPORT_SYMBOL_GPL(kvm_pfn_to_refcounted_page);
>   
>   /*
>    * Switches to specified vcpu, until a matching vcpu_put()
