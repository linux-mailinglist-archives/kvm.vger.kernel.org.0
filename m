Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE96BA4C4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 02:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCOBjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 21:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOBji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 21:39:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092E523A65;
        Tue, 14 Mar 2023 18:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678844378; x=1710380378;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fqeg2rYpVGe6NpEvmIFOCeyIZjVN2xcD2mVqxIzb8uk=;
  b=UXnGGetByxknlUwPIuKmWlhqAaimi0eQwVaiYxpnho/zZVrSygcTY2xp
   qZ7Ltzu3goagUTTmOzUcQFSGCLKIZC+Jz/D70FEXXRv5wjIm3jwV1HUbD
   NDGkVcfWGEgMtV6OehX27OvmfRjOiQjEtNXrOofuq5B9hdHQvET9kXQ+r
   Wp8eeMZY2bw7CgHQvV9Zehh5C/Wm8aUB5C6rRgIn0/SMCqYF5zeB9wWtp
   2JOeooRhTawq0Hg2+beXqIsB2VgY7d/JCxEex/Waqi5RkpARy0Pz33xKJ
   npAk8wH5Y7DPcqSpFq2ruQLqWvlJG3wgAiWM08rJJotzm4QjivccqletE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339948568"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="339948568"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 18:33:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822586936"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="822586936"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 18:33:23 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 18:33:22 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 18:33:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 18:33:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 18:33:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0qFH07mLIsiMRhG4fo/EK5hEdMCx+ed45xBYe1N8ScDBP2GG7J5oiAhdtvnsd1h6ERHUbJovPNtR+MHjoqE+KNFcFXHAwXcWbDYE+e61k91IsWIrztpK4oLHE7TDFfYQZPKVtEXlPB81YLUYnx+FRCi+vrfj0mfRrHU+hBuRj0D/E445ucVPg7d4TYmFtEzAernVfJ47iTDQGqUjOolh1xewzhR8uopii+RyatFeRXqyLauoZpo/yUnm8o8DWRX6/UiLwFllCRwscu720eOcyTZ5FfmtYHRJWsKizPBo4e052lVR6owKAtRBFiEp4SpWKlAyqJqlSpi+BwJMQrp4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXzzYxGMnhdPhs2IVtt0nLfLtg9iICiFsxdS3Su49Bg=;
 b=OdDHT2GWEOwVk806Go3Ppwyq0RNbq0Dg/P3glV/fDXWnZf4PFhZjnO8741sfULI3FsL3+4UM0elTHUXmEbLGxeBLRNERNBusmi7vhEjN22+SyJx0oeXG0mC8dK/UWEiQigQ7HlUSqte742BUlYi4hYaagNlBuKDM01rMhWPfLXSUfoX98QkBzHsnJ0/1EwHb4AUrJihK8nOBxExSKcrY8C1W6oQtmCjBMib1xtTGyAaCTvaQ2oSJrCavKLHWTNbs3shFadH6M1/935groO9mqZGHYNPSpZVoCEem9TcEQXftZQWtD4HkOCI6Njc6dMVJyjGXj0APzkUCRNmqm/jYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 01:33:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 01:33:20 +0000
Date:   Wed, 15 Mar 2023 09:08:45 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Don't rely on page-track
 mechanism to flush on memslot change
Message-ID: <ZBEanQaJTCkjcDOn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-12-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-12-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: f1931852-22df-4d0e-88f7-08db24f541fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wtVf7zM8VjTcxmkxWPBP5GYP+wHhBnl/bNzup96l57Cne6KYt0bHedBBnHcmsRTO/zdPCDr9B9A/+SBdbc94RIGnFDvN6mc5MLsHdHLtK2v4NfnP4ogDPjm1JYlKcgOvIOuKGB+y5FTuF/oIN/KZRYp32tpM+ESw/UC9x7Q2VwkJ5MoLEOFqr2l28Kjyx00QFp5TDXTE7pa5Jdsy/zmC5YvWwv6+rjFYxq48UJaM7B1JF70wubcW37CtWib8k6Tg2s8GoJ0rkrbsRdSyP3lNzlofJ1VZD4b1/etXlvikODOD0Fi+wYQX0NML8Kqkn1SVSVg+PyfVTOzmNjkuPKwta2xzm2TmzQmiTMtqXZ+E6CTmG/9WU7Qv8nMEt0MMSDERDzDEB5qkI5xX8TUOID+T6NbvFkfPmkl2+YawscHfY33EyF8L6yWXw6NHJbB2+Xhb9ucSg0lXyh5bc+Wz9wAwNithelH91/pBKCop8AqMJ0GBXknztT0fKh8HFt0NdUcriprOz/kCuF4FrtLv8kTTHsfpzx77tE/bh8eJGwAPpyJ5KHqhkm0LSftZ2PbkpIght4VCJbu6H0Z9AjS4QqhLmhbjfdjqpqTcyFc76RXi7nYHXKjzJg3sdGqDZ8LpkB6MQcWT0Ji2M2MJnwoNR1NgPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199018)(8936002)(5660300002)(3450700001)(2906002)(38100700002)(82960400001)(86362001)(478600001)(66556008)(6916009)(66476007)(66946007)(6486002)(6666004)(41300700001)(8676002)(4326008)(83380400001)(54906003)(316002)(186003)(26005)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HamfClD6LnauvIgbt1cRfBzHMKGtrF+PqCNo3tQMqfv2koXz5/qeGzOKU8YI?=
 =?us-ascii?Q?zk/1CGNfoK1cBeJfXr9nxQUGTUD5QRXFA7PciR+kA4qrYcKE8EPUi7TQ+QXu?=
 =?us-ascii?Q?NUD37jrRpxffMz/XJhArgRgF0pkBWlV99l1ZwGV3DT4i4Pc39X8/rcRag6Yo?=
 =?us-ascii?Q?OdSgLf4H2clOTnUe63LKhSst6oIpEtkbcYEY856lr4iQrqz9Is0gZoh1qB7e?=
 =?us-ascii?Q?JmTOokRpoiRyfTinPB3l8LMJoZgry7GGm1vkTT8H4M8OHCyj+Rd2ogYkUIXY?=
 =?us-ascii?Q?4il9/BWlj9VIt7Qmv/iPa8bQc63TxiDG+ZyW1Za0i4waN4mGxLgeuEpaoMDV?=
 =?us-ascii?Q?N098uXSemqUL/kjdtFE/X9HrmcX7hrQ49tCAH4i+pB5K5VQSsqywDJIas0mw?=
 =?us-ascii?Q?i0pNVya2Obm3XWCgvdy6nW1JFUjsYYabdv8FJTyVf5VVwgxx1gz3mo2VM/UF?=
 =?us-ascii?Q?/S3xY+Xb3aGhx8yi0ranmGCvLtTN2V7tHxpuZ3+SZBeXdIdt2KDnovF0wDja?=
 =?us-ascii?Q?xl/FZwON8odUxucT54ArOpjdgr3qLVsiryWQg6pn3g3AeqoJolQc+4+2duds?=
 =?us-ascii?Q?spAyZpS4t5aizfAa+aj3V6gN2NigynU0hGac5pxbJDxgC011/NboTOAiYGs8?=
 =?us-ascii?Q?M9kFIAGJ+vq5mFiB6gcUwIwCG9rcSTPiRg7INiWrhqC3SKoMlQT/KJdkJsRq?=
 =?us-ascii?Q?QVd2t24OsN5yCX3pjirtdNwhOBfO475mbbBmLrEdG0M5yabir2UXXsl9d+SD?=
 =?us-ascii?Q?qlH1S9W6yQm6BjhKWaSgNXcmCdCabyTHtKp0yJhuqbnudv5+FUJrxKPAzSVw?=
 =?us-ascii?Q?ayivA1R6VFewiOVPA5I4ff28QnxjF5ij+sl9hDoC4FLb7/MEGT9dK0b3kRIU?=
 =?us-ascii?Q?gLYF98Y/+Bt56Au5abUjd4UuPlfbezTeZBg6y1Ameadf1Fu0lCyBel9aJK5/?=
 =?us-ascii?Q?d8SMdyrQF7/2A2xg/H67MZYGaOyEive7uz8yeRWfMtQz8MzXikyq7b+pYsCF?=
 =?us-ascii?Q?WFe1P0HdGeKQvvNnb1754Nexu2sEEhdGFkgGh7zlpNqtluSzJ2y5mrlPb12g?=
 =?us-ascii?Q?egciG0OTepFytJwitWPyyTANFJx5Oy9neu933M1yLbt7ASunDpECi/gVMZwh?=
 =?us-ascii?Q?z7LE2MUocw2mMibtJtEJ/vAoXEyvo53C/puuOlS0+gl0Qc2p4UVmEU8ws3cC?=
 =?us-ascii?Q?K5hZEqw7RxSU5mg2IaaRbWeSxjxLch00rG9fYI4UvURKlAb7zR9K4EBB45f8?=
 =?us-ascii?Q?TiX+WaN0nUsBuIJlQnE+c4iExH3iiu5sEpD+xDFTG8lzAQa7vKNsrd33jXTc?=
 =?us-ascii?Q?k3d3uOuTpNgDe7P0P4Lywd21K6uYfTE+RbDMxrns5aKVqTz97vPRi9Uu5POG?=
 =?us-ascii?Q?auz+EgaxqwODyyCr/mRVsdrWulrpTJuyXF5WL23ivvdsBq9S4a7XiC4P74Fq?=
 =?us-ascii?Q?eb1FyEbp24JO3MimfwmlpZ0Q2n2vfnJTA9EJ6DbM7nmO5Py3oOyqdtedFZpd?=
 =?us-ascii?Q?3ha3d/SYbcCO39Z6UeSyRhSveV/bMA6URIKU6XuIiEnVFJvjVgSUV2LxwO49?=
 =?us-ascii?Q?Ke/oDn/QpwzDtD++T4Zse2+BFnMeyVfKVOPfCnTqWCepIBMcpKFj8XOna/+G?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1931852-22df-4d0e-88f7-08db24f541fb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 01:33:19.8162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPC/hrda3ZeiYjLhQ7N2aJv6ZCMFENVYRNE5cvXGLNM/Z1SjsJ56qG9hvpBejk+NZD0tE/DK/4pEAATEXkjuwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:42PM -0800, Sean Christopherson wrote:
...
> -static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> -			struct kvm_memory_slot *slot,
> -			struct kvm_page_track_notifier_node *node)
> -{
> -	kvm_mmu_zap_all_fast(kvm);
> -}
> -
>  int kvm_mmu_init_vm(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> @@ -6110,7 +6103,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  	}
>  
>  	node->track_write = kvm_mmu_pte_write;
> -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
>  
>  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f706621c35b8..29dd6c97d145 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12662,6 +12662,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot)
>  {
> +	kvm_mmu_zap_all_fast(kvm);
Could we still call kvm_mmu_invalidate_zap_pages_in_memslot() here?
As I know, for TDX, its version of
kvm_mmu_invalidate_zap_pages_in_memslot() is like

static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
                        struct kvm_memory_slot *slot,
                        struct kvm_page_track_notifier_node *node)
{
        if (kvm_gfn_shared_mask(kvm))
                kvm_mmu_zap_memslot(kvm, slot);
        else
                kvm_mmu_zap_all_fast(kvm);
}

Maybe this kind of judegment is better to be confined in mmu.c?

Thanks
Yan

> +
>  	kvm_page_track_flush_slot(kvm, slot);
>  }
>  
