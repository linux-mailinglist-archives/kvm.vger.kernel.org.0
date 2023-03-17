Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD0C6BE17E
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 07:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCQGqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 02:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQGqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 02:46:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28969ABAC1;
        Thu, 16 Mar 2023 23:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679035572; x=1710571572;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=M5FqumOfsEIH5gJqt4jI4/kH7tGkjckgXV97Lv5MtUg=;
  b=B3S2nIxZt8pzDFA0ZfVvdYR3yf37Cr05NMNPu9amYi4+EVZ4ud1QX/qR
   Ds7R9o9Lws09OTpCF0zO9pUeZpdB2zwAQxJHt+EVo9VCfTcbING1ZbE0D
   aP31Wqkfe+SDnin2fFEHexCmrZ8qkIkO/VqRd1ywayHO/pevwIxm8JxPR
   9YyopTEXGjuMBDegHmso9XGXnG8a/OtFQ+lNOcf4k85LZb23K6Cq4aOn1
   MhRs8U0m0dWv+mvax4rlR7L8UMoc9QQRgMRv/P8MDHa79tgcmczvh1eZF
   x9Zc/591EUwVT6VwsELqB20Y1m4nDYLWtDs76jSzCRZd+oErzk1diyUYN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339736121"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="339736121"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 23:46:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657453567"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="657453567"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 23:46:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:46:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 23:46:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 23:46:11 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 23:46:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKJRDbtahG+sPFAmA12aq3V8kwdn//fIkJJlktbEUoq7OWh080J/uWJey4FwSdsjJPA10bPmFX7nRoAI3pwfxWsPUOGHmjavS08NGswSf5LyXGkQd2STbCyiIOa18+kXQDlpPK2l+ijZFk4nvY0qIm3OiTZ4MlEeyIjCd9peVgHTIDS4sE0iCB8TmKIW+/pixGECK2KUyEZ1RArfCq6fIqsLJt7sB2ap/YoT/F779uJ11FGSWSsbS4R9nIkKs7vvpyJVgomjGX/qpBPDl/iN0xSwu/jmn+m+vqK/bdY1FRlt4DhBMlNB85ZB9CVWAhFYZNTalJL1euJB/FimUD/9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EUm7/oxaTWRU39gx8LQrFRFEcvJROXynkPVMIJmyHk=;
 b=jG6wBKfW+jOA0i9wRtj1zHg1qfH1vuWMkRTBVIMzbvJbjA9gk68yzjYZgrlEC+dZ9Qqj3Cw/V/zdZIFbD6IfjFAZ+/oNrvsSFZuS4abwF5NKtlURxsB5BVZWaUD8ajg61uLF6t78TTzrdnP9PoKzzCZcoh9N/LqPYHb1EcHxzXHSLJMm3NwGKS+XPGmGrJfaLvZ1RDBHpMnxvlo4FpJdfqoeu0W48M6CcfHJHplkRIgUrFd2FOgDWexSYjdh4mgU4W+ZTToHDGv4/CQfagIv1d0ZrHvd2Y0hZfDNZtuk+UeJSXT9erDvygbJq5xIRc3L3MFRTsDudb6De5pNtINKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8253.namprd11.prod.outlook.com (2603:10b6:806:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 06:46:07 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Fri, 17 Mar 2023
 06:46:07 +0000
Date:   Fri, 17 Mar 2023 14:21:29 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, <kvm@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 10/27] drm/i915/gvt: Protect gfn hash table with
 vgpu_lock
Message-ID: <ZBQG6SIS2a4WBjNc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-11-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230311002258.852397-11-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0186.apcprd04.prod.outlook.com
 (2603:1096:4:14::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: c179e12f-1b07-4070-3a79-08db26b34906
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZZcuPfT8yh+N5inrHrsFmeKs5RLS9/dCtYpICVn6G7BXHlcTehYhLcmpnw8+1jlelZJB30+UpctA+BiheSVS6ME74aJ2ZOGQqA+1OcmHVUmFKwtG9vXB1IrjdZjuATBKE9NfH0JSQZI4m4MVzChj28o5hQfaiPNcGzrR82Qz1/vP3kHmXvIQ64ONKXpXIGMEK/nSgIEIUaW7r3xs1be4pGziZMi3MDgwMI4L/KQkgb2twYKbr187LpJW3NptCq4GMo1TO4GjduJ2aLel4offFTtrG+MyLmhQW9sZnDlKECTDHDuzRnpLKu7nLVbbhWXrbQaSbaggQzex0LQS51jM4QaKaxQ6RzCuGnaSB+ssWK6HFzJsY9vQvMi4FCvghgNnYV6UiQsQCGFVET93Az54SeIR5VXw3CJa4x4P7vpoQy80cLd2Haid0PuIgQeyZQ4EUxUW6cBvjP0b0f74tErFgSA8DuR6wwdKVfCoE/3CRc0d69fQZytbENOiLQl0uJYd1fWIgJimJhbMc6X4ybRm6v+pAzl0Rxj50TZ8xI8FXhBSkoN8Pq/VhOyw2urxMwa//XqgQRcU/GYyeMh/SiCatbqNYhX9jChiEHXJk0oODn+YTW3KsGwaO8LGBWmPGnB6sfVLtzJOccvDyUubAk387g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199018)(5660300002)(8936002)(2906002)(41300700001)(3450700001)(316002)(8676002)(66476007)(66556008)(54906003)(478600001)(6486002)(6916009)(6666004)(83380400001)(186003)(26005)(6512007)(6506007)(4326008)(66946007)(86362001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pevretJm3gBlix0ZT28P42zZBizUM0TkTninuHuZz4aVHIty3fXt3UsWUnnE?=
 =?us-ascii?Q?1Tqm94D00g1aMKvN2CtEEA619fevEJ0k+NymjbZQY6e/99w5fiSYMP0W3eVa?=
 =?us-ascii?Q?TRPieSnjF2IdM1X88h4ZZVCUSTHZP2eoMu6mRT2fz23PRC+3IfrFAhTos90p?=
 =?us-ascii?Q?hVhFO2mwoUQrx9VTqA2KBaMokalil6EAhrLWn78WnAFHaLlZrwfqhl8pFwFo?=
 =?us-ascii?Q?yVGOVkLUajqy/IxbuLMmJ50FUr0HVAOLoeqsRYj/SZG2mCKgcfSSIEDHXavI?=
 =?us-ascii?Q?RMETBPe68H8wswG9mCjJcMc00OafOPXTYIlVi4dtJRBdLsZqCpXRw/MiAlTY?=
 =?us-ascii?Q?kggdVpLrmTy7U+DceTPJ/ZDDt8sCDVQ4+eBrQaUmouTvClIL6K8yTZbn/OWp?=
 =?us-ascii?Q?4Dac6pgf3GtH9jAxGcFMUxbHjrDsjNMMMqJfCIwqH4X4NaQNdhAqVAQT7Sl5?=
 =?us-ascii?Q?0/hsFXlvBDxea9eMaOAZ2K3j/YTSTQJCgchkVfWdO7P+k8okZH5xoOXwwIB/?=
 =?us-ascii?Q?dtxNUeNjNliJ7C6nSSFnZL94VHTDXNJ9QU127KKhLSv3Ke6E7rA3BMmiSmCT?=
 =?us-ascii?Q?pbaaBrKyPTTDDiXoHdRdCY3V9w+pNqfyUUO4n4/cNOHnulgT7nJ2aTJOXWE7?=
 =?us-ascii?Q?m8LOSqlVFpcdjuqf66gVjo+Kmu9BIuFeMxSzCgcLbFydEkdu88NVHwfJlpzE?=
 =?us-ascii?Q?kC+mqhQgCOtujOKuI0LBXCQLEe4go0cgRweOxzgqXtP/EpNSl/fzrhKg1u2K?=
 =?us-ascii?Q?2qn4y8GOezZw2KcdYPp3LIWfLuF77W9flnKLZCx/EtV7CJ4UcSPMCI2tKVh1?=
 =?us-ascii?Q?o2YhP47JYWMIvR2yf2LuitkVHS/Wlc1DfQr/QvDFHE6b0r703RAj/AsQzA5x?=
 =?us-ascii?Q?jSIhxEIWyvOHnFKV6JhWkuS8/JBsJFPx4+vOXXj23QLF0gPsasnjoG2nrMjX?=
 =?us-ascii?Q?9MsrXv1R5sHQu5pH0bmEfCwhsEh5G1Ub5DcuRBULyCgE6Mbj+BTpKtbbW9E5?=
 =?us-ascii?Q?MVj0cvLaxLGmoNWxL4umrnydxE/5ork+9LjSzFdHdfyhLa7cRBSFLyalGCNi?=
 =?us-ascii?Q?yExRtcfqkRg8z1HrD7zqsVM5LWLUYtGbzqaKASz1pfLp5TAFfvVUs7PNYeBl?=
 =?us-ascii?Q?1J+Iac9m0OPEsLBZTFMssz+JPZ9EgA45YTwxIz437/ZnkorChlZtUvIdw/u2?=
 =?us-ascii?Q?rIYNrhwfp0lKDDGaFe4kq/sYbxQtSMSVrhEy0YRsZ8CPUL+2XdjdMj7Tqiih?=
 =?us-ascii?Q?/97lTKQaqbd4wq8OawkLIbELBEZ1RxJWqi5JC7yVzKsGcxqwm3LHVOK3c8GH?=
 =?us-ascii?Q?xYZ9ZQleJOj0OKJO5KE2meKxY0sJqvi0qz1sGsAsxuvqbEozhQWPsbGsar4U?=
 =?us-ascii?Q?807ATigpM5croJsMZNPkiZw1odtTVjaN+XNV743wx3ki2X+K0rzynY4Ak3B6?=
 =?us-ascii?Q?S7mg5cNxDBjjVdvp4S2nSnRBvk7a1zziK1DgOlSx4xb4JMo4nYNMiB5FJy7b?=
 =?us-ascii?Q?VmDH7E6WQGTKN5w1UVyu354iVCPtMfhjx7H6RHwBo6olVAJfrX9BYo1Hc+sI?=
 =?us-ascii?Q?VXBWkSuzW+EVCkyWbQ0F+0Djtfrfkl64hVvJ9h+4Hm5AANU6HZKOqJzcBfZe?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c179e12f-1b07-4070-3a79-08db26b34906
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 06:46:07.0609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0hCsyxv9ehDoqNDgp0XHuUezXx+/y0aRC2y9VhnE+FJaZTBhx137Utpbe1Ov/ddXhmTDxckwhQ+nnhsiS04Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8253
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

On Fri, Mar 10, 2023 at 04:22:41PM -0800, Sean Christopherson wrote:
> Use vgpu_lock instead of KVM's mmu_lock to protect accesses to the hash
> table used to track which gfns are write-protected when shadowing the
> guest's GTT, and hoist the acquisition of vgpu_lock from
> intel_vgpu_page_track_handler() out to its sole caller,
> kvmgt_page_track_write().
> 
> This fixes a bug where kvmgt_page_track_write(), which doesn't hold
> kvm->mmu_lock, could race with intel_gvt_page_track_remove() and trigger
> a use-after-free.
> 
> Fixing kvmgt_page_track_write() by taking kvm->mmu_lock is not an option
> as mmu_lock is a r/w spinlock, and intel_vgpu_page_track_handler() might
> sleep when acquiring vgpu->cache_lock deep down the callstack:
> 
>   intel_vgpu_page_track_handler()
>   |
>   |->  page_track->handler / ppgtt_write_protection_handler()
>        |
>        |-> ppgtt_handle_guest_write_page_table_bytes()
>            |
>            |->  ppgtt_handle_guest_write_page_table()
>                 |
>                 |-> ppgtt_handle_guest_entry_removal()
>                     |
>                     |-> ppgtt_invalidate_pte()
>                         |
>                         |-> intel_gvt_dma_unmap_guest_page()
>                             |
>                             |-> mutex_lock(&vgpu->cache_lock);
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c      | 55 +++++++++++++++------------
>  drivers/gpu/drm/i915/gvt/page_track.c | 10 +----
>  2 files changed, 33 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 68be66395598..9824d075562e 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -366,6 +366,8 @@ __kvmgt_protect_table_find(struct intel_vgpu *info, gfn_t gfn)
>  {
>  	struct kvmgt_pgfn *p, *res = NULL;
>  
> +	lockdep_assert_held(&info->vgpu_lock);
> +
>  	hash_for_each_possible(info->ptable, p, hnode, gfn) {
>  		if (gfn == p->gfn) {
>  			res = p;
> @@ -1567,6 +1569,9 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>  	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
>  		return -ESRCH;
>  
> +	if (kvmgt_gfn_is_write_protected(info, gfn))
> +		return 0;
> +
>  	idx = srcu_read_lock(&kvm->srcu);
>  	slot = gfn_to_memslot(kvm, gfn);
>  	if (!slot) {
> @@ -1575,16 +1580,12 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
>  	}
>  
>  	write_lock(&kvm->mmu_lock);
> -
> -	if (kvmgt_gfn_is_write_protected(info, gfn))
> -		goto out;
> -
>  	kvm_slot_page_track_add_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
> +	write_unlock(&kvm->mmu_lock);
> +
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
>  	kvmgt_protect_table_add(info, gfn);
> -
> -out:
> -	write_unlock(&kvm->mmu_lock);
> -	srcu_read_unlock(&kvm->srcu, idx);
>  	return 0;
>  }
>  
> @@ -1597,24 +1598,22 @@ int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
>  	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, info->status))
>  		return -ESRCH;
>  
> -	idx = srcu_read_lock(&kvm->srcu);
> -	slot = gfn_to_memslot(kvm, gfn);
> -	if (!slot) {
> -		srcu_read_unlock(&kvm->srcu, idx);
> -		return -EINVAL;
> -	}
> -
> -	write_lock(&kvm->mmu_lock);
> -
>  	if (!kvmgt_gfn_is_write_protected(info, gfn))
> -		goto out;
> +		return 0;
>  
> +	idx = srcu_read_lock(&kvm->srcu);
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot) {
> +		srcu_read_unlock(&kvm->srcu, idx);
> +		return -EINVAL;
> +	}
> +
> +	write_lock(&kvm->mmu_lock);
>  	kvm_slot_page_track_remove_page(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE);
> +	write_unlock(&kvm->mmu_lock);
> +	srcu_read_unlock(&kvm->srcu, idx);
> +
>  	kvmgt_protect_table_del(info, gfn);
> -
> -out:
> -	write_unlock(&kvm->mmu_lock);
> -	srcu_read_unlock(&kvm->srcu, idx);
>  	return 0;
>  }
>  
> @@ -1625,9 +1624,13 @@ static void kvmgt_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	struct intel_vgpu *info =
>  		container_of(node, struct intel_vgpu, track_node);
>  
> +	mutex_lock(&info->vgpu_lock);
> +
>  	if (kvmgt_gfn_is_write_protected(info, gpa_to_gfn(gpa)))
>  		intel_vgpu_page_track_handler(info, gpa,
>  						     (void *)val, len);
> +
> +	mutex_unlock(&info->vgpu_lock);
>  }
>  
>  static void kvmgt_page_track_flush_slot(struct kvm *kvm,
> @@ -1639,16 +1642,20 @@ static void kvmgt_page_track_flush_slot(struct kvm *kvm,
>  	struct intel_vgpu *info =
>  		container_of(node, struct intel_vgpu, track_node);
>  
> -	write_lock(&kvm->mmu_lock);
> +	mutex_lock(&info->vgpu_lock);
> +
>  	for (i = 0; i < slot->npages; i++) {
>  		gfn = slot->base_gfn + i;
>  		if (kvmgt_gfn_is_write_protected(info, gfn)) {
> +			write_lock(&kvm->mmu_lock);
>  			kvm_slot_page_track_remove_page(kvm, slot, gfn,
>  						KVM_PAGE_TRACK_WRITE);
> +			write_unlock(&kvm->mmu_lock);
> +
>  			kvmgt_protect_table_del(info, gfn);
>  		}
>  	}
> -	write_unlock(&kvm->mmu_lock);
> +	mutex_unlock(&info->vgpu_lock);
>  }
>  
>  void intel_vgpu_detach_regions(struct intel_vgpu *vgpu)
> diff --git a/drivers/gpu/drm/i915/gvt/page_track.c b/drivers/gpu/drm/i915/gvt/page_track.c
> index df34e73cba41..60a65435556d 100644
> --- a/drivers/gpu/drm/i915/gvt/page_track.c
> +++ b/drivers/gpu/drm/i915/gvt/page_track.c
> @@ -162,13 +162,9 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
>  	struct intel_vgpu_page_track *page_track;
>  	int ret = 0;
>  
> -	mutex_lock(&vgpu->vgpu_lock);
> -
>  	page_track = intel_vgpu_find_page_track(vgpu, gpa >> PAGE_SHIFT);
> -	if (!page_track) {
> -		ret = -ENXIO;
> -		goto out;
> -	}
> +	if (!page_track)
> +		return -ENXIO;
>  
>  	if (unlikely(vgpu->failsafe)) {
>  		/* Remove write protection to prevent furture traps. */
> @@ -179,7 +175,5 @@ int intel_vgpu_page_track_handler(struct intel_vgpu *vgpu, u64 gpa,
>  			gvt_err("guest page write error, gpa %llx\n", gpa);
>  	}
>  
> -out:
> -	mutex_unlock(&vgpu->vgpu_lock);
>  	return ret;
>  }
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
