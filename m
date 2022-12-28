Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D03657392
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 08:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiL1HT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 02:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1HTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 02:19:25 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC176F016;
        Tue, 27 Dec 2022 23:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672211963; x=1703747963;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2c4gRftQHo51Rky8Mikq7f6PdmIy+Qqw6QaVOD2GJAE=;
  b=DD8YOXrXJ06NxuJbIRuNLIAhugnlALeqdZWQaUBXcxAI/NQuw/R5BcFU
   ntXZyqrcojAtc09CQ7V1kQUyM9sS9oIOycQm9DUo6chp4FlB13usmTP1B
   6DQDBHYytkK2vupugG5gzUMJGMzf0xkGmNMZZoDySEbQJr7kolF+bmUo2
   +SdpeahxqnFvm7UcSwuYIh4X0iTveKtEddqsPs15FnxFBR7+YaeXb7nz9
   I2cSrcpOTo2ZqLP6Jou9Js234J1xCQ0JGi3/ukPgCaH1BECWUlbRVbIF/
   ltbQsten+/xMAXm7mTdgsanKE+rHmBN4GxRPt0LYNLxc4SSKqRppLvQWw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="407087789"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="407087789"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 23:19:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="683841238"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="683841238"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 27 Dec 2022 23:19:22 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 23:19:22 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 23:19:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 27 Dec 2022 23:19:22 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 27 Dec 2022 23:19:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kC97HbzOGtpE/s1wWrclTKB5UtfLTrt/Zx2DrDO/PB00OA+oCd8kjHT+qai3dUBUw8R+Qswcw2imzgW2h+6d3FzvenDgNvoKIpo3owVaqysapatzHTFDNzpf2pAl1ZtfxBO/tTpZ/x2oUYwrHb3bLa8ridLxBAoLoyctyaws5MBLeKvqtl+izK9dc1S1K6pr6/U/D6/UKrpCau+alpkTmevPt1x7doP+8U3TGqBRxkd0IJjLjjFWCxuL6mSqc0fY0HNAx/pFrU2nzf64vPyZThkHDzKttnjf8exUr/xFVAIBp+r9MCVQ1ZT9sO4sKcTJ9T/r5uHdoW2IgE/SBNplRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrzHRTUZCiARhALzFykatyoi2yRN/rxC5JhbfgTsAyA=;
 b=eT9I8uEfS8gvuE9/t5SsYGDPUH5+kbeHaUdSesYLSqSXLWD+OJ0j0VSGUW3WJvrX9l6+L+nTw8ogkfHXs3PNgjHwh0xUiLkyjcHyAiyFhygxj7Hn7xamckvMH92OOCFCIchyIo5Og2UKCp5Ri5e1PaCfgWuSTUKWjxkKTU9Ley0OXG8vMVbhax/ji8yei/j+Hb0WCp2ZimkERjPPIbzVI97WOTqixEqCn3I5rcVlNI201S3Ss/mUFSurpIS+VkvfU5XYOoWIMI4pg/hcum4zzTOBy0oxdNVOpojwfWCpDGe1cJVciGFy8SvDujz/K8Eg7HrCkU5xbstm3w6m3Yj7Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB5396.namprd11.prod.outlook.com (2603:10b6:610:bb::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Wed, 28 Dec 2022 07:19:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::bd50:2cf7:f362:3734%9]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 07:19:18 +0000
Date:   Wed, 28 Dec 2022 14:56:00 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
Message-ID: <Y6vogAvkktOPLwK9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221223005739.1295925-20-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0102.apcprd02.prod.outlook.com
 (2603:1096:4:92::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB5396:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f4ff804-c746-4c99-1a5b-08dae8a3d58c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: diuyOuWOkOKt4U9c2uEpwhmO9nTuc258rtp0SB5xHm/lJrIYpYqdM7JiHgfMFnoSDBe3teHVVxAjaz9LIP9FNnEjaB1cx/vXxwVp8eK6HZbOC3LlNq0SU7E63SNtCMVyE2eNe/RTA8O7NhFtD75/7Ll2RoOoQNiMOyeeUj8J5LDvW4iHPUEgQyCNw6xcjg4kiGjfveH3EJy84lvrqg3d6vos8G0j+rqOicGEXjD2tBhjEaNjn7AcbALHzFcBtAcPa4s84DLicp39ObY8AL+G0b0BBgf/aLY5otfSWtTd8V6Jbq/Ur4NxIUapqQb8BsEEBO2b0LH1PpB//J8HiaZyOJqmMY0JTbZim6yBsHyz2JPSoQYE3gzHkOii5W8do4sT3Nwht8D7qw0MbTJ2PPYp8FnMUW2oASbheX3d1ppKrDoY6tec0fY4KRSPRb6ulX5vOmqk1V4mfXvjE6DuguiwxAvFSyrQxoNrqVUGDJysQiJ/BaNL2U3x1GD2rNUMq7I1R8lPf3XirNGO21+xe9Y2n6NhzZnNtpcqsRoa+iK6tjDdEDt+Q/YPJ7MUMsDg7z3cipX0AJPCac5i9VPDoxWM/q0Evec4K/oN4I2gVkzmthgDMw9U/tLOby3iDy+rji1c7Dn8nNTso70X0CAn9XAW5KVLfJiZ1zSvUekxleUUH3y4LAPN0xd3oIOCObGf9wBz4FBozRSXxnapA02rXIO1e7JZnjc26douPx9NLURym4bAxkpVL8n2lUnCNFTkrSIS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(86362001)(26005)(6486002)(186003)(478600001)(6512007)(41300700001)(6666004)(6506007)(66556008)(66476007)(66946007)(8676002)(5660300002)(4326008)(6916009)(3450700001)(2906002)(8936002)(316002)(54906003)(38100700002)(82960400001)(83380400001)(26730200005)(19860200003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P8tORmEbRvzf2u/rnyuqXViwI5idKCQyGICMcY/t5U67KyILBu7Zls1JNqG/?=
 =?us-ascii?Q?tByfg0vSMWpwINK4SQJ2IFVrtPoqLB22G9HMh9lzxPXO6LJuJ9tx2U3tbDIe?=
 =?us-ascii?Q?8wimUKGjmBvgqtzUEluu7j1VhyaNts/uCc8JZRF/a0PF7rHHRXRwQqbKaTrv?=
 =?us-ascii?Q?QSNkkIM+55t15ViheFnT7ZNkENhjBVueN++gEXHbvzONMS8CLSpVckvVY6bn?=
 =?us-ascii?Q?M1TeHBz4r+h4/W0tEyQb/CsfwKmFuSuAL7vnMb4Wk+hwyyAFlIYTASlNSuWV?=
 =?us-ascii?Q?d28rLY0KdtTCvZ0NhFVMqm8V6JDCS9nCAneeByzrIFhB2hASYmtKYdBlaNvZ?=
 =?us-ascii?Q?h8ge8z5w7JmwysFW7t5bE46pbs2HqREcw+6GsZgBkOUwcnDBkqNjpaee8B/9?=
 =?us-ascii?Q?QmpBR0Epciulh3YMvg/JVOH0qa+Zu92a68x9bBZ9sIsEq1u/XfhE+5wUG8Kf?=
 =?us-ascii?Q?y5jTEbIlHyOtHBXZc2HMheAzi26ID3q8Ybymq4eHGfcmjSdH6xNYPpTGs07D?=
 =?us-ascii?Q?4wnn1xIeAbg4/jgbrsiitFzsCel9Zz+ENbXH9an3Q4NDtz/oTSnC6BbKbxKn?=
 =?us-ascii?Q?aKy/0pamXogE6/QuRuYFUlBfUfv9QpyEL5ibtnYCF9WxISIkI6cmwq4yKy2Q?=
 =?us-ascii?Q?wxBxFgo+K/ScFWIKX/CjTAbRTgLh2Fuzke/TdTVs/BA8QrZIk57FALVgbXXu?=
 =?us-ascii?Q?GKqnorSlfX7KmT0GQitkZ0gfuJ81zUdZrUX0syBAyOZYWmdGn036UAyri5xi?=
 =?us-ascii?Q?Ft0OmLCLF/KCPcc/zr/6GjcmsE/D+QSR33vTZrjzIlV3xLS9YshhZS/npfaJ?=
 =?us-ascii?Q?7sX4mZG6PGcvDEEaCVk5yRs50nM9hwVleCYQdENAXJ89moUZ05IKB9xWk9Zo?=
 =?us-ascii?Q?1/YXmQlOr/VDeKHJxnvq+jYeEuPMiJ9NVO8xxA6ornZ+NeRDCkOVsW11rCFe?=
 =?us-ascii?Q?FD1Xl4Ap+6f9wtLzlk4z+lJhnWbo8jVyr/IjWpfQQ0uVcgjFkqEwiZAdB72q?=
 =?us-ascii?Q?PL9+sNfv5dTk3fOEb3D880jnVs7vt5RTjjlyclhi/mAo4HUOtKI/iqk6tN0N?=
 =?us-ascii?Q?xD9obWoHrol31eOHEeuw3z5RIowqtRI6UetmUE6WS/EYqcGGItYZ7QpuTFzJ?=
 =?us-ascii?Q?cvBO6emspE/7++msAG/OVKTK+iP8xcb/X18TZK20RdJTYRRfsYQQ21oWJo0M?=
 =?us-ascii?Q?wLU0k7H7dPOH0BPpxG0K+/Cn2MqsRn79WH6L7UPMvF4Pug0peMvCguBr0oE5?=
 =?us-ascii?Q?kxG/QB9kjeofhRm1o8XLv7FmySAL8LYdvVQsu8FayvD6GZhbzU7WOSmTPRJH?=
 =?us-ascii?Q?3qm7EbOKWx7FF3PPigNkz7bfwOrXvo6GAhF9RQEHCzwPVHZK7gtlQTYbbREx?=
 =?us-ascii?Q?8HvrFgPDx8oEiuhGHKErqArAUSmG9ZsrwC06qBW5/WA2kHk6EJGH1nj7ToM/?=
 =?us-ascii?Q?9kfvgz6coswNE2/F1rlJVZfemz25bZjs4K4MbPt8lICt6fxEoHTnxaVx3LkN?=
 =?us-ascii?Q?OmhvLd5jFX6mlUFduP2oSiX7R9OIusYTO3bCdIt5TgEGUg7b+RnW74UhPxDM?=
 =?us-ascii?Q?1rONQZnzz3pa54T10QhchAPUWuf1afP55YIqSe3Q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4ff804-c746-4c99-1a5b-08dae8a3d58c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2022 07:19:18.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0kavYM/8BvSvb+I4R6HXXjnB+x0v4FtnMqcgccnj0vRONfXMznr4sgC+3n59WRlMV1GirFaWEoX896e7U6WkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 23, 2022 at 12:57:31AM +0000, Sean Christopherson wrote:
> Disable the page-track notifier code at compile time if there are no
> external users, i.e. if CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n.  KVM itself
> now hooks emulated writes directly instead of relying on the page-track
> mechanism.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h       |  2 ++
>  arch/x86/include/asm/kvm_page_track.h |  2 ++
>  arch/x86/kvm/mmu/page_track.c         |  9 ++++----
>  arch/x86/kvm/mmu/page_track.h         | 30 +++++++++++++++++++++++----
>  4 files changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index eec424fac0ba..e8f8e1bd96c7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1223,7 +1223,9 @@ struct kvm_arch {
>  	 * create an NX huge page (without hanging the guest).
>  	 */
>  	struct list_head possible_nx_huge_pages;
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  	struct kvm_page_track_notifier_head track_notifier_head;
> +#endif
>  	/*
>  	 * Protects marking pages unsync during page faults, as TDP MMU page
>  	 * faults only take mmu_lock for read.  For simplicity, the unsync
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index deece45936a5..53c2adb25a07 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -55,6 +55,7 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
>  				     struct kvm_memory_slot *slot, gfn_t gfn,
>  				     enum kvm_page_track_mode mode);
>  
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
>  					       enum pg_level max_level);
>  
> @@ -64,5 +65,6 @@ kvm_page_track_register_notifier(struct kvm *kvm,
>  void
>  kvm_page_track_unregister_notifier(struct kvm *kvm,
>  				   struct kvm_page_track_notifier_node *n);
> +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
>  
>  #endif
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 2b302fd2c5dd..f932909aa9b5 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -193,6 +193,7 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
>  	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
>  }
>  
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
>  void kvm_page_track_cleanup(struct kvm *kvm)
>  {
>  	struct kvm_page_track_notifier_head *head;
> @@ -208,6 +209,7 @@ int kvm_page_track_init(struct kvm *kvm)
>  	head = &kvm->arch.track_notifier_head;
>  	INIT_HLIST_HEAD(&head->track_notifier_list);
>  	return init_srcu_struct(&head->track_srcu);
> +	return 0;
Double "return"s.


>  }
>  
>  /*
> @@ -254,8 +256,8 @@ EXPORT_SYMBOL_GPL(kvm_page_track_unregister_notifier);
>   * The node should figure out if the written page is the one that node is
>   * interested in by itself.
>   */
> -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			  int bytes)
> +void __kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> +			    int bytes)
>  {
>  	struct kvm_page_track_notifier_head *head;
>  	struct kvm_page_track_notifier_node *n;
> @@ -272,8 +274,6 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  		if (n->track_write)
>  			n->track_write(gpa, new, bytes, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
> -
> -	kvm_mmu_track_write(vcpu, gpa, new, bytes);
>  }
>  
>  /*
> @@ -316,3 +316,4 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
>  	return max_level;
>  }
>  EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
> +#endif
> diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
> index 89712f123ad3..1b363784aa4a 100644
> --- a/arch/x86/kvm/mmu/page_track.h
> +++ b/arch/x86/kvm/mmu/page_track.h
> @@ -6,8 +6,6 @@
>  
>  #include <asm/kvm_page_track.h>
>  
> -int kvm_page_track_init(struct kvm *kvm);
> -void kvm_page_track_cleanup(struct kvm *kvm);
>  
>  bool kvm_page_track_write_tracking_enabled(struct kvm *kvm);
>  int kvm_page_track_write_tracking_alloc(struct kvm_memory_slot *slot);
> @@ -21,13 +19,37 @@ bool kvm_slot_page_track_is_active(struct kvm *kvm,
>  				   const struct kvm_memory_slot *slot,
>  				   gfn_t gfn, enum kvm_page_track_mode mode);
>  
> -void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			  int bytes);
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> +int kvm_page_track_init(struct kvm *kvm);
> +void kvm_page_track_cleanup(struct kvm *kvm);
> +
> +void __kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> +			    int bytes);
>  void kvm_page_track_delete_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
>  
>  static inline bool kvm_page_track_has_external_user(struct kvm *kvm)
>  {
>  	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
>  }
> +#else
> +static inline int kvm_page_track_init(struct kvm *kvm) { return 0; }
> +static inline void kvm_page_track_cleanup(struct kvm *kvm) { }
> +
> +static inline void __kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					  const u8 *new, int bytes) { }
> +static inline void kvm_page_track_delete_slot(struct kvm *kvm,
> +					      struct kvm_memory_slot *slot) { }
> +
> +static inline bool kvm_page_track_has_external_user(struct kvm *kvm) { return false; }
> +
> +#endif /* CONFIG_KVM_EXTERNAL_WRITE_TRACKING */
> +
> +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					const u8 *new, int bytes)
> +{
> +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> +
Why not convert "vcpu" to "kvm" in __kvm_page_track_write() ?
i.e.
void __kvm_page_track_write(struct kvm *kvm, gpa_t gpa, const u8 *new, int bytes);


Thanks
Yan

> +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> +}
>  
>  #endif /* __KVM_X86_PAGE_TRACK_H */
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 
