Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BE36BE1BA
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 08:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjCQHDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 03:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCQHD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 03:03:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BFF227A2;
        Fri, 17 Mar 2023 00:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679036608; x=1710572608;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6skkYOUoGq7rHwChOfztMWaLP2DEbEFed+UC5dMEg0Y=;
  b=Ol3k/neJ/CgHjt0unkrNLfADEO2/OXRWXTwlWEElvBABmDkVk7TsbVSQ
   SLOvhhGdl+stqbgaNG/rsP+ElSCSNHLbQZBiX7oZoT4VuGAuYyteF3ElK
   yWLjPduvPiTFUNMNDdMgEF+XZuceEp4GLHtiFMYSZCH/Lvq75jehpPcFV
   fegJh6SIcHo2OGTGgHQRTpgEunsktTyDHKR/cpXW44A3yx2D8V7BGQOiI
   uc4c+LdvcJD8xh9xeAIohusEnFQ3Pco7Z80ihuWRIcfozhjQQ6azdBqhO
   /rwEx1NQPpBKJCr6JjRi2WWwAPnraZXCJTxNqOHGtArY98dynWjofNbkh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="365897212"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="365897212"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 00:03:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="1009530806"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="1009530806"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 17 Mar 2023 00:03:12 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 00:03:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 00:02:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 00:02:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 00:02:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCKH17GYq7IHcyBXraW/QHIdjjctr1qRtV3Xo/cZGv1YJXjA4d9V6/iddBxGw7lNlRBg/5o1rqaxhmMPaaZsAw8FWURLqL5D+xkOZnK73SZ7W9ZBbSiECmsFSV9b45RHfLGPEWa4NEv0sRPPoxiz07wGwPkCzcXK9xju6BZYBRk+dkVhzXJ8LwP/5JLsUF/aAFhXGpHc2ow8NPzWZoi5kHpwYGg/zYVwm651TPJAkHHwD14b4CwtnpN9tSGM+Qf9T3IvM96m92J7e1ZXlhFy8Dy2V1b5JAb5dk0S1I77UEDvXLtsBBvO2dcsZiTST2mG+U5VG/RbIStzB8erXYp7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSk9s6uyc94CkvOFzS2REGur1H4KFapmReK2eEJ2JcM=;
 b=SGWE9jTyVu9h67H9etqcKpNyOrETrILUOQRYe5AKtb2Wlj6Ik9LhlDbFc4GwFYC3lohdJjYzNmK9sg1grroeulKMkXhxnKYCq/vsHvT6fV6kRBC5INwhYWjZihYXdQwkNuBn4ZXh9ESXx7/nxhAGGINjtlgMDnfOXpTdLd4zIPq/9jFQsuWt4se2JhMWwNuA56aDY+zGRv37gqNc+4eovdoxlyLyl5qVVP3ru7rBWtOCbh6vFEuSbuKfo5Z7H+991mhu2s2M1Y83E1V2kPmTKAc0oB9D/rozvlXzGwdZr/WkFoeGTiSx2oanomBegFk2m7pS3AUDdNQlm8gEgRzDyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 07:02:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 07:02:09 +0000
Date:   Fri, 17 Mar 2023 14:37:30 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 12/27] KVM: x86/mmu: Don't bounce through page-track
 mechanism for guest PTEs
Message-ID: <ZBQKqpWToZT2ca2D@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-13-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0214.apcprd06.prod.outlook.com
 (2603:1096:4:68::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d98ce96-f42f-47a8-d391-08db26b586d9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQO9eX3N8oBv9rlHsOmJmDVv/rsI8epJMeils1XScfdRmx6M7Tx0Va+wZvsLBJr45RZ72U6UCPo1QV2Y+oCaUAK62Ox4Z2iK3qp5GM4g3D2AF44eQGkmyxroRW9FD2jMef/1SfiPZtsaqQsdyzXz3yLkVpV0JlW3qqxSuTpft2bEa/jZDndQM9g32OeCMzAXvlWTyKMao4kLnbTgSv6EyWRaoMze9fRx/5f761Q5MD6C285Y0CaZtk28pDsY0TbOpcL4ugy1neEkJ8TEObGYXOXoUaaEJx8Ehlvo2aMfVA/Cz7aIt0U2elA70zwQErp0d3dKwSE+r2bOYMlnME9nt2MFhTXVn9tQDN1IVaL+k+Fp7x0YtJ+fNIsIbS4XkEsBmkx+6RmjlC0SqtsI4vZwvg3UqnOVsI8h/ocWNL/S4IFWv8KRwJXuFTKLxkkYDItbKFISCpud9f1+nCxT2Sp8r78tAcHLcfhYf/hLVQLmkkvo2/fF9iX+yUd84a1V+7+w0NGGMfi6DehfX9rq/uGtfoz6s0ehFqIrID209mSZ40oUojemBloBS5Hmxvesfi7LjcDUWULdEKrcReMLUlV3PX5pUDVUMMcTCid/S7ltzNymFo9Gwgdct4lgIOZjHPB3cr8TMfG/1PPL3cgovZ0+zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199018)(2906002)(3450700001)(41300700001)(86362001)(6916009)(8936002)(5660300002)(4326008)(82960400001)(38100700002)(83380400001)(8676002)(6512007)(6666004)(186003)(26005)(6506007)(54906003)(6486002)(478600001)(316002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3aMuCUOF/31s4opsSiuUb5uGOICY+Ak4m2koIDI6XrlLDxBjTqJBEkXtD4Aa?=
 =?us-ascii?Q?COgHw3+1kcm4rQHRrohg2PGIBT+3ATQttHMSFKtIPOCMyi6jo+jlPCieNuOt?=
 =?us-ascii?Q?2xEg+CsAsInGMsNA/FSNzRQYm33mzbM8OG0NonDsvDHFl1A2QDSq2kw9JCeY?=
 =?us-ascii?Q?/R0m2sc91FPzCL6Vv1KgHzjDT3DTRai68Snj1Ihk31wDvTWNr5okEvcUCFDL?=
 =?us-ascii?Q?voyZVWEPAjjxr6Y1NtXR629p0851dv3VvyF4xIBSq2mEBEQWCKRUbsFkG8+s?=
 =?us-ascii?Q?m0T3Sti6ZX9dNMUra6ks17LyTJ1pMpiXChS3uxe55bBBgcaEZQd3LsaUkJSz?=
 =?us-ascii?Q?0duiSzNrTdV0ihjXZ1JacsUTq2KCXrLDv9pRzEebA3kfPzLNSPKMDeYBbUBJ?=
 =?us-ascii?Q?udc/TdA3mgyq7cy6agTenfggyBjxVXu04xSdu/KWklYYwHVKj8PE8gBQqEmO?=
 =?us-ascii?Q?pjk2sEqDKSXsZ8k5IdLJ8p8j/eTQIN2dDyUHODsS/k98t9I8WoOvkrMlPmD4?=
 =?us-ascii?Q?YREM/mWVxdLx4tpEaOWVp+O+J+4EO1wX5l+medEZdx5BIX3hE7WAODqDXyuC?=
 =?us-ascii?Q?g2oD7ARsZp5XmKWdJecvnqIWdjKnjEI8HC2ks/Y1xuKo8M10GljEFyhQmTXP?=
 =?us-ascii?Q?mC1qjiYhnAbkXpdOrn0TwC51Ho835c4CYKBahfaUO0ahTQ43rHbDGISYXTPW?=
 =?us-ascii?Q?xtA0vgfUOgihluxaFW7VciEb1NjTu/gR3Eh6iXMBr2O6nEl7WfxoEZFT9twF?=
 =?us-ascii?Q?0FcuN+b6SgDBqIE4Iq1kox6yFhwzSu7BSzqvJOraTaYexfdZdcYQzfp2jtZq?=
 =?us-ascii?Q?MjDtI7gUPNsPUdvMcYYjY7YvOH4CETYj+6E+knC7EU2k/HffIf7NniDSI7aJ?=
 =?us-ascii?Q?MyZO22LaWeRdDBmrseponQlxHJgiVWldxQ66hpHYxQJo4bACt2N99PTv+muy?=
 =?us-ascii?Q?ZBm/wFOlCXQFZQN9XPR/6fF1BZnx3iWIwk4vrtZ9vuTV1gfxRhDwXgXIde3I?=
 =?us-ascii?Q?A6JGi1ONuny5wmYjGV9OUrf7xEw4VNuIOuFp2RLD+cIH36+r77B5M5zlXKOe?=
 =?us-ascii?Q?TCQ0TXz1TlcGhsUT8amGJBmUTEr9WD9nJmr06pEUpGxik8TxLGqzK51Yjeco?=
 =?us-ascii?Q?dHkS5pDAsWTgh6JjZ1Nsp7OqdgBtum+wPtdKzxV541jJm6VL+ZYY+nw2rMxJ?=
 =?us-ascii?Q?WKdjjoJX7raarYnu4wd40I54RM1ewUdJvPCSdzB3wLNHerOP5qDPT2iM1ejU?=
 =?us-ascii?Q?9KUX7UUYd7u6ia2TWmpcyk9n4s65Af2O0bgPPtBESayW3v7rwpywAp7QkQqU?=
 =?us-ascii?Q?Cbousm4kstkmRfxbPM1HUPG12SdtL00Yno5jpthKJvAjaq9HsO1mIM5RCmMA?=
 =?us-ascii?Q?3FKA3WcJ2u8AAa0mm7gJo+ZUPLSsDajqSfXGPJ/iTV5SmENHYQHVmNMxEhwx?=
 =?us-ascii?Q?/w8jWIDOf9ta36Luyud8WBeq1XuMS20EoaWL9rqFyw2vHrt+WC4pfTFEv/1a?=
 =?us-ascii?Q?o1fi1/w8WvxFRwnhy0RDE9L569+pMd3mXT9V6mKvaM7ssyCZKJDMeym6ukZN?=
 =?us-ascii?Q?dNQhRrYv0phVy/gGzwvHTuTS7b+0zGScWHXvImBMmGZ6QeKIByRhSFaVO07u?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d98ce96-f42f-47a8-d391-08db26b586d9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 07:02:09.8289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xo9LLsR+7EUhQcjMFcFM74JT+L4odTkl7SUDVklY6bu/Q4P48tTyT4+b9VN4oRA0Zqp/lBtS9HPj+rmkXETT6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Fri, Mar 10, 2023 at 04:22:43PM -0800, Sean Christopherson wrote:
> Don't use the generic page-track mechanism to handle writes to guest PTEs
> in KVM's MMU.  KVM's MMU needs access to information that should not be
> exposed to external page-track users, e.g. KVM needs (for some definitions
> of "need") the vCPU to query the current paging mode, whereas external
> users, i.e. KVMGT, have no ties to the current vCPU and so should never
> need the vCPU.
> 
> Moving away from the page-track mechanism will allow dropping use of the
> page-track mechanism for KVM's own MMU, and will also allow simplifying
> and cleaning up the page-track APIs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu.h              |  2 ++
>  arch/x86/kvm/mmu/mmu.c          | 13 ++-----------
>  arch/x86/kvm/mmu/page_track.c   |  2 ++
>  4 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 17281d6825c9..1a4225237564 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1265,7 +1265,6 @@ struct kvm_arch {
>  	 * create an NX huge page (without hanging the guest).
>  	 */
>  	struct list_head possible_nx_huge_pages;
> -	struct kvm_page_track_notifier_node mmu_sp_tracker;
>  	struct kvm_page_track_notifier_head track_notifier_head;
>  	/*
>  	 * Protects marking pages unsync during page faults, as TDP MMU page
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 168c46fd8dd1..b8bde42f6037 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -119,6 +119,8 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
>  void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
>  void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
> +void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> +			 int bytes);
>  
>  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 409dabec69df..4f2f83d8322e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5603,9 +5603,8 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
>  	return spte;
>  }
>  
> -static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> -			      const u8 *new, int bytes,
> -			      struct kvm_page_track_notifier_node *node)
> +void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> +			 int bytes)
>  {
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	struct kvm_mmu_page *sp;
> @@ -6088,7 +6087,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>  
>  int kvm_mmu_init_vm(struct kvm *kvm)
>  {
> -	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
>  	int r;
>  
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> @@ -6102,9 +6100,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
>  			return r;
>  	}
>  
> -	node->track_write = kvm_mmu_pte_write;
> -	kvm_page_track_register_notifier(kvm, node);
> -
>  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
>  	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
>  
> @@ -6125,10 +6120,6 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
>  
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
>  {
> -	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> -
> -	kvm_page_track_unregister_notifier(kvm, node);
> -
>  	if (tdp_mmu_enabled)
>  		kvm_mmu_uninit_tdp_mmu(kvm);
>  
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index e739dcc3375c..f39f190ad4ae 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -274,6 +274,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  		if (n->track_write)
>  			n->track_write(vcpu, gpa, new, bytes, n);
>  	srcu_read_unlock(&head->track_srcu, idx);
> +
> +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
>  }
>  
>  /*
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
