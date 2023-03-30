Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36336CFE5F
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjC3IeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjC3Idl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:33:41 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1220C61AD
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680165217; x=1711701217;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I0cm1NlbYVw3J/AiRe+4hjXwMqntSGu6df2I4DC0ffE=;
  b=E5B+amlU6gD7qT8GTLNfkE/kIQR1Zu/92/hY8N6a3e5QvvskROWb28rd
   iPmPAWZ6hktKOIWf8RfW7ttG1oRijbTfbnbmq2PISatrFNUNfeQ+atUN9
   2P1he2jW04vqs8YuQ8kY735taK+zoxDCeTZCvGpBzBvXr85OeN7C/xsYb
   nz6SWbNhvMHNPjj3Uza3wMGMCItgjYb7zCcidl++uI4CR2kNTzB/UP9Sj
   FCSG7Fl8Nj8aohufP6GegX86dyuWqsDElXDkR7VkgCeCXRN9y7fVbMI7j
   ghsfa1V05z3s5UEG9oq+/i0pCGYWtCAtxnQTle3OrYUiKfoUI3G733+Ol
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="343557186"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="343557186"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 01:33:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="749100378"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="749100378"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 30 Mar 2023 01:33:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 01:33:36 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 01:33:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 01:33:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 01:33:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYMyJN6uxUbwsUlu2Jfwg5hQ1dnnMOyakY2diA/fJpLpYXWY3zQiU9TGgFmdMgftaCJ1Nd34s7rxXyiGGGu9r6N87TioySACbrsPzgVg/4iZwnZtjSv5Mt+1O5M2QYQqKhJpL8vme0DYrJE33uidpHBk/m/M7Lhkszbzi5jHYFPQwYUPZwgecukbiZlc/oU8xawVrije3l5lO0dS+s6Uti2+Ma/gqXOfX1JcqgE08bd0noXlyp3+dyqs48xe3BIR/JBvyysJkxgKzxeeFZzKS17XyxQODHDHRsPPY3r74z7ygVWXMcJO7TseMYfCzyHORnZk1r1fmemEU87y/Gi10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9ytfjg0xuy6KuMgVjUUhSzXHJvrVYfuNwyw6noW8Ho=;
 b=Zux07GX8cBkIwnk/zpw0gIdW1mUFTH1HUfvfZXa8zpmqCePXBoaZ8JOzRZt5TP0BoSO/uElALqv3v6SzlkvcNrP4+R2U3Ypt+HwA9SnHA/ARQtPtd5AzxhDoPdaBgvz2haiGs6WghJY6Y8K3RRsHJyDqT8h4jLNAbFRFUGlt+DikA4hs87red596fU/8dxuOs2Eb0K+6adBHfTBYeXYvYBnrcCVtj6LuHbAuF3Ie7OwTl1XXxL40d59mRzdi4vmOVSLcOLefUhxwAgjVfITl7nmU8byKfEfcNi7LtKxftUUCOyOQMlBGcJH8bwpAG7Qi4WzpTVkUu3S5vXycRHLFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 08:33:33 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada%6]) with mapi id 15.20.6222.034; Thu, 30 Mar 2023
 08:33:33 +0000
Message-ID: <3d73b47f-bce6-4af4-da42-5330aa7fc0e9@intel.com>
Date:   Thu, 30 Mar 2023 16:33:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 4/7] KVM: x86: Virtualize CR3.LAM_{U48,U57}
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <chao.gao@intel.com>, <robert.hu@linux.intel.com>,
        <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-5-binbin.wu@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230319084927.29607-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL3PR11MB6508:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a2f3f7-4e3f-436b-52d6-08db30f9727e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKs9JxeRXeiMKci+RHo+KdLebf0pBzipknwly8yHtmnDLDWN/99jWcSKe2zo5vg7HiA8rlEVHcyxDNIFar1JmtYtdjBBSk3Ap8ySHQQ+sqPMbbNLJe6RQL5bBLp6YzFiiSPT2FEAbZ58mWL89uEIocsSaMa85NQFd9ZdkMjdHc1y7hEi+itat041nzzVC6R/kKwZc+sz5zUQbenVxGggOl5LIPNqiJeLjM/R+Khx45+PLMaTrYv4+k1xNxnAT288M2TU9U3f5VuYqS5TzPucGX53wKmUCsFO0jpnHY04F0Gc2ttuDkon1sJZRyt2oHT1eruayCwH1qcEFaPHj+6Jx+gFzSlrzYWBrne+uEOK3BwixFfyyxml4soX6r5kyMdypkHQumUcwm87mFL+DLDI9o+1CTkHdSCjzdH2zeU4WlWGIeSRkXmknrxqKCbGNKBA9BOyC1KGfqsmSpgL1QJMF59ET4tVynD3SblM1aSMStQ1bjhxqJesleHXDq+LZdYGbWJ1GLTd9QZbvDkOdOBiqs/wHN3jeoXP84dVgZeX2onA+GCFX3fsiv3B5EvxjU4VQcjHtx1CGwf4QrAAh7YNiJpQ+mgnyLJprBP0QP/Rxnk0UMgwDneH469iBKMFsNd1JRVJfbRZ3eXVqlAAsSGiDu8KWjGZ8wm5qpTB1urwTVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199021)(31686004)(31696002)(36756003)(86362001)(2906002)(6486002)(4326008)(6666004)(83380400001)(2616005)(38100700002)(6512007)(53546011)(66556008)(478600001)(66946007)(316002)(66476007)(6506007)(8676002)(6916009)(186003)(5660300002)(26005)(82960400001)(8936002)(41300700001)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTM0ZlJORFYvb0VQSjVxTUR0ZmV6ODc4eHNBTFJWMStQVnJLRjJkMXd3bXRv?=
 =?utf-8?B?TXlZbHFFYzNBbG1TN09BL2xHVm9WUjYzV000eTY5Z0lndHBlZCtoQlBtMmxD?=
 =?utf-8?B?a1o5NlMzcVZMWGRQS0ZMMk1HM3R6Q1hST3BxNkVycy8wWEhyNzJnY3J4QytJ?=
 =?utf-8?B?MUZyTWNCaDVjZTZjM1k4anA5bUF3L0lITjI0RXAvc3FDWDI3MVhiaXo0aVEy?=
 =?utf-8?B?MW9rSHJndE8zTWVIWVp1cXpOZEl6RGpOTTJRV2hVSi9aWjAramFSd25kUUlZ?=
 =?utf-8?B?SHJrZnpkQ200aWltOTlrbjBKeDFyMWxwS3NDdHBHMkhabmVzVWIvWTBVRTZp?=
 =?utf-8?B?d1p1OXNibDJzMTErMC9BMUlnbUN4NGo0eHd6aG8yblBRMHdKT3VYMWNvbjRK?=
 =?utf-8?B?QTZMSU5ZWHBIZUYzN0FPZXNpbDRLOHIwbVFwQjZrSytRT0lSa0pSSm9YQjZR?=
 =?utf-8?B?RHNxWFF2V3cySlEvenIrbTFUZ2V0UGV1NkJFOGFQbDFLNjNtWm52OUh6em5W?=
 =?utf-8?B?M0w2cDQxdGdJc3F2dW56MVd4QnFxQzhBSTQrZHlJbnE0YjdnRzBlUlRLZWhx?=
 =?utf-8?B?VlEvaUlia1lzcWdTWC9Mb3Q4SEdiVjlnMmhpRGt0anNIMVEvL0t0OThJN1ZB?=
 =?utf-8?B?Zy9MbmJVVmRYN0VqT1JlOGxUWGZYRzBqbHk4Yk5RT1VaS1J0enFKUk5xbmJn?=
 =?utf-8?B?K2RVcXkrb2swVGI5ZEhVRHBGcmxZZkkvdXgzV2trWG1VNkpBaUl3dW91c1hx?=
 =?utf-8?B?K0RNTS8zK00ydVNRYWlmaHdjTlA4N0x3azJZdWFqMGRONWZsR0NUeVVoZy81?=
 =?utf-8?B?L3g1aFIyUmE3dVpEeWhMQnRBaG1TSVdoK2JwcUtQbUU3ajVRMktHSE14R0hX?=
 =?utf-8?B?Zk1jNUQ1RWRyUjR3eEI0RlU4N2FQUTNBNEVkN2VMVDRzeUl5MTllZFNTSFNP?=
 =?utf-8?B?aUgrV3lxTFRoQnFlZDdVM0dscW1XRVhCYVBkK3NQTW50R1pSWldOSzhSc2NW?=
 =?utf-8?B?dVhjZGdQSmRJSWQxTDVxZ1hqL01Nb1J1NUZhODNSMmVXRVQzZmZWS2piWUhP?=
 =?utf-8?B?VVJzNjJEdThXRFBSMTVEWDNFVC8xd011UWF5V0l1K09FOENqemZqcUJNL0Jk?=
 =?utf-8?B?OURtNHBxaW01TisyelNKSFdNTGkzSlRYQ1JPc3VXYWtVbzVqdFZ3bWVkZTk0?=
 =?utf-8?B?M1dwVW5uNWlSZzkwcUhXMkF6czNwbnkrZDQzV3FCcUErNWtzbUg1Um9Cc2lH?=
 =?utf-8?B?QWNkMDB6MnV5MDhpUzdiZVpFYzlYSm5lM1JsSHNPLzZ3dzJFc3ZpRWdPTDB6?=
 =?utf-8?B?UkpjQS9nQkMwbXFreEJPV3V1TTdtYVVIYTBVeHAyN2RSckErNVpCZmMvczBH?=
 =?utf-8?B?ZEFUekI3a01SRUgwY2FYK2NxT1ByTVhrSXJ6aDlRYklqVUcrT2ZRZ1h5SE9F?=
 =?utf-8?B?NS9SR1hLYS9XTU8vcTQ1Y1g2dGFXV0JPa043UWNyK1doNDB3NjkyQVdwVjVn?=
 =?utf-8?B?b3IyQmdlUG43RVovaWJFMGdBSDNHT1dIZkZnN1JGK0tmOEgxK3BaZlYrRXB6?=
 =?utf-8?B?QzhHaVVmbytqNStDTnF5ZmVOandKQ0NLSmxMN3NWdjY4LzNNaGF4UXZEWHlm?=
 =?utf-8?B?Znd5SXoxbFRnZHJ5RU55QTY5bnlYalB4ckJJMXd2WGdhTEpoOXlUOVNwYmo4?=
 =?utf-8?B?NStaM3RxRm1EMDg0WGZQTGpGUVBlRVZnZlkyd3c1dHc3bjhTWjVjRmVja3RC?=
 =?utf-8?B?WHM4Tk55RUtMQXRxd1BsSEJ1MmlpclZHZkpnb0d5WThQQlduQWhJQTJSNnFm?=
 =?utf-8?B?THUzeXcwNFZLRWI1UjIrZUw5Q3M0b3c5cGJDaGE4WW1ldnorUmRHSkZPUTNT?=
 =?utf-8?B?WDEwZzc5S0wzcFVRdlk4K3lvL0d0bVhOMlNUa01qNURIdGJaSnNIWXBDdVVj?=
 =?utf-8?B?YTVRdzZtd0oxQ2dTNUFDTXRTYkpWbE5wRzI0NzF5STFtallaUjRSa1FLNml6?=
 =?utf-8?B?aGhLbEN4bEVzTERuamE2Uk9XUTFrMGoyUTh2T2U1QVVsdFZBRU12ZXhFeWNs?=
 =?utf-8?B?ekRqL2Q5NnJoTzVzbmhLYkFreXpyOUttekJQM1RhVVpvWDdkNEE5eXNvNkJq?=
 =?utf-8?B?OGlkUTNlTUNoZFRRWnR4UGVSZU83cjdLVFBhMU9POUxVeEZoODh1UVRTbkdB?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a2f3f7-4e3f-436b-52d6-08db30f9727e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 08:33:33.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeruzROkjrqvkFCSJ9ubviGyuRbc10vEBATdu4FMOB0DfehSv89p3dhxjZPics0siSCUeuOwDSXvxYWzPwbhUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/19/2023 4:49 PM, Binbin Wu wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
>
> LAM uses CR3.LAM_U48 (bit 62) and CR3.LAM_U57 (bit 61) to configure LAM
> masking for user mode pointers.
>
> When EPT is on:
> CR3 is fully under control of guest, guest LAM is thus transparent to KVM.
>
> When EPT is off (shadow paging):
> KVM needs to handle guest CR3.LAM_U48 and CR3.LAM_U57 toggles.
> The two bits don't participate in page table walking. They should be masked
> to get the base address of page table. When shadow paging is used, the two
> bits should be kept as they are in the shadow CR3.
> To be generic, introduce a field 'cr3_ctrl_bits' in kvm_vcpu_arch to record
> the bits used to control supported features related to CR3 (e.g. LAM).
> - Supported control bits are set to cr3_ctrl_bits.
> - Add kvm_vcpu_is_legal_cr3() to validate CR3, allow setting of the control
>    bits for the supported features.
> - cr3_ctrl_bits is used to mask the control bits when calculate the base
>    address of page table from mmu::get_guest_pgd().
> - Add kvm_get_active_cr3_ctrl_bits() to get the active control bits to form
>    a new guest CR3 (in vmx_load_mmu_pgd()).
> - For only control bits toggle cases, it is unnecessary to make new pgd, but
>    just make request of load pgd.
>    Especially, for ONLY-LAM-bits toggle cases, skip TLB flush since hardware
>    is not required to flush TLB when CR3 LAM bits toggled.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  7 +++++++
>   arch/x86/kvm/cpuid.h            |  5 +++++
>   arch/x86/kvm/mmu.h              |  5 +++++
>   arch/x86/kvm/mmu/mmu.c          |  2 +-
>   arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>   arch/x86/kvm/vmx/nested.c       |  6 +++---
>   arch/x86/kvm/vmx/vmx.c          |  6 +++++-
>   arch/x86/kvm/x86.c              | 29 +++++++++++++++++++++++------
>   8 files changed, 50 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 742fd84c7997..2174ad27013b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -730,6 +730,13 @@ struct kvm_vcpu_arch {
>   	unsigned long cr0_guest_owned_bits;
>   	unsigned long cr2;
>   	unsigned long cr3;
> +	/*
> +	 * Bits in CR3 used to enable certain features. These bits don't
> +	 * participate in page table walking. They should be masked to
> +	 * get the base address of page table. When shadow paging is
> +	 * used, these bits should be kept as they are in the shadow CR3.
> +	 */
> +	u64 cr3_ctrl_bits;

The "ctrl_bits" turns out to be LAM bits only, so better to change the 
name as cr3_lam_bits

to make it specific.

>   	unsigned long cr4;
>   	unsigned long cr4_guest_owned_bits;
>   	unsigned long cr4_guest_rsvd_bits;
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..ef8e1b912d7d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -42,6 +42,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>   	return vcpu->arch.maxphyaddr;
>   }
>   
> +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> +{
> +	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctrl_bits);
> +}
> +
>   static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
>   {
>   	return !(gpa & vcpu->arch.reserved_gpa_bits);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 168c46fd8dd1..29985eeb8e12 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>   	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
>   }
>   
> +static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
> +}
Same as above, change the function name to kvm_get_active_cr3_lam_bits().
> +
>   static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>   {
>   	u64 root_hpa = vcpu->arch.mmu->root.hpa;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index aeb240b339f5..e0b86ace7326 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3722,7 +3722,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>   	int quadrant, i, r;
>   	hpa_t root;
>   
> -	root_pgd = mmu->get_guest_pgd(vcpu);
> +	root_pgd = mmu->get_guest_pgd(vcpu) & ~vcpu->arch.cr3_ctrl_bits;
>   	root_gfn = root_pgd >> PAGE_SHIFT;
>   
>   	if (mmu_check_root(vcpu, root_gfn))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index e5662dbd519c..8887615534b0 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -324,7 +324,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	trace_kvm_mmu_pagetable_walk(addr, access);
>   retry_walk:
>   	walker->level = mmu->cpu_role.base.level;
> -	pte           = mmu->get_guest_pgd(vcpu);
> +	pte           = mmu->get_guest_pgd(vcpu) & ~vcpu->arch.cr3_ctrl_bits;
>   	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>   
>   #if PTTYPE == 64
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0f84cc05f57c..2eb258992d63 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1079,7 +1079,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>   			       bool nested_ept, bool reload_pdptrs,
>   			       enum vm_entry_failure_code *entry_failure_code)
>   {
> -	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3))) {
> +	if (CC(!kvm_vcpu_is_legal_cr3(vcpu, cr3))) {
>   		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>   		return -EINVAL;
>   	}
> @@ -1101,7 +1101,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
>   	kvm_init_mmu(vcpu);
>   
>   	if (!nested_ept)
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +		kvm_mmu_new_pgd(vcpu, cr3 & ~vcpu->arch.cr3_ctrl_bits);
>   
>   	return 0;
>   }
> @@ -2907,7 +2907,7 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>   
>   	if (CC(!nested_host_cr0_valid(vcpu, vmcs12->host_cr0)) ||
>   	    CC(!nested_host_cr4_valid(vcpu, vmcs12->host_cr4)) ||
> -	    CC(kvm_vcpu_is_illegal_gpa(vcpu, vmcs12->host_cr3)))
> +	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
>   		return -EINVAL;
>   
>   	if (CC(is_noncanonical_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 66a50224293e..9638a3000256 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3390,7 +3390,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   			update_guest_cr3 = false;
>   		vmx_ept_load_pdptrs(vcpu);
>   	} else {
> -		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
> +		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
> +		            kvm_get_active_cr3_ctrl_bits(vcpu);
>   	}
>   
>   	if (update_guest_cr3)
> @@ -7750,6 +7751,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		vmx->msr_ia32_feature_control_valid_bits &=
>   			~FEAT_CTL_SGX_LC_ENABLED;
>   
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
> +		vcpu->arch.cr3_ctrl_bits |= X86_CR3_LAM_U48 | X86_CR3_LAM_U57;
> +
>   	/* Refresh #PF interception to account for MAXPHYADDR changes. */
>   	vmx_update_exception_bitmap(vcpu);
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 410327e7eb55..e74af72f53ec 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1236,7 +1236,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
>   int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   {
>   	bool skip_tlb_flush = false;
> -	unsigned long pcid = 0;
> +	unsigned long pcid = 0, old_cr3;
>   #ifdef CONFIG_X86_64
>   	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
>   
> @@ -1247,8 +1247,9 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   	}
>   #endif
>   
> +	old_cr3 = kvm_read_cr3(vcpu);
>   	/* PDPTRs are always reloaded for PAE paging. */
> -	if (cr3 == kvm_read_cr3(vcpu) && !is_pae_paging(vcpu))
> +	if (cr3 == old_cr3 && !is_pae_paging(vcpu))
>   		goto handle_tlb_flush;
>   
>   	/*
> @@ -1256,14 +1257,30 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>   	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>   	 * the current vCPU mode is accurate.
>   	 */
> -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
> +	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
>   		return 1;
>   
>   	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
>   		return 1;
>   
> -	if (cr3 != kvm_read_cr3(vcpu))
> -		kvm_mmu_new_pgd(vcpu, cr3);
> +	if (cr3 != old_cr3) {
> +		if ((cr3 ^ old_cr3) & ~vcpu->arch.cr3_ctrl_bits) {
> +			kvm_mmu_new_pgd(vcpu, cr3 & ~vcpu->arch.cr3_ctrl_bits);
> +		} else {
> +			/*
> +			 * Though only control (LAM) bits changed, make the
> +			 * request to force an update on guest CR3 because the
> +			 * control (LAM) bits are stale
> +			 */
> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
> +			/*
> +			 * HW is not required to flush TLB when CR3 LAM bits toggled.
> +			 * Currently only LAM bits in cr3_ctrl_bits, if more bits added in
> +			 * the future, need to check whether to skip TLB flush or not.
> +			 */
> +			skip_tlb_flush = true;
> +		}
> +	}
>   
>   	vcpu->arch.cr3 = cr3;
>   	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> @@ -11305,7 +11322,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>   		 */
>   		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
>   			return false;
> -		if (kvm_vcpu_is_illegal_gpa(vcpu, sregs->cr3))
> +		if (!kvm_vcpu_is_legal_cr3(vcpu, sregs->cr3))
>   			return false;
>   	} else {
>   		/*
