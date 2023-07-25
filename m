Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C2776163B
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 13:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbjGYLha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbjGYLh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 07:37:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E902AF3;
        Tue, 25 Jul 2023 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690285040; x=1721821040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dZGU74ILPhWHx0vgkE1suZN6V2yEUYQuoKi735RBe/k=;
  b=KhhuldPdl5M2iwAcLznC5XwuJccFV7tB0dZPt6mWUvd7q92K3iFIwr5l
   /zVfo0eEIFYpqTmPutH+QNoWtWUNpPs6rJwqMB4P2RhjH8I9ISnmf+Anz
   Ui/SR0y5AZ8g3mlDEPFPldVBw2mP5ITd4IT1jzLEM0jcOWFctp/vtKYO8
   xfTJjM8B/edngC7WI/NeLapryz5PxpWi45YA0wmQ5k3OekrNWfQiCMw2v
   eDsSrM71SkgrWdrhC+meG31WDq2L+RcGf0Wrk82eE7gwswZLz4BQ83cPL
   t6kMwDCtH2gSwRyZir92QBr41vafAXER/m2KBpIzjygpcAKJdv6tQL+Hn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="352593403"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="352593403"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 04:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="899911236"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="899911236"
Received: from hegang-mobl.ccr.corp.intel.com (HELO localhost) ([10.254.212.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 04:36:32 -0700
Date:   Tue, 25 Jul 2023 19:36:29 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Subject: Re: [PATCH 5/5] KVM: x86/mmu: Use dummy root, backed by zero page,
 for !visible guest roots
Message-ID: <20230725113628.z7vzxk5g6zdqlftg@linux.intel.com>
References: <20230722012350.2371049-1-seanjc@google.com>
 <20230722012350.2371049-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722012350.2371049-6-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 122bfc0124d3..e9d4d7b66111 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -646,6 +646,17 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		goto out_gpte_changed;
>  
> +	/*
> +	 * Load a new root and retry the faulting instruction in the extremely
> +	 * unlikely scenario that the guest root gfn became visible between
> +	 * loading a dummy root and handling the resulting page fault, e.g. if
> +	 * userspace create a memslot in the interim.
> +	 */
> +	if (unlikely(kvm_mmu_is_dummy_root(vcpu->arch.mmu->root.hpa))) {
> +		kvm_mmu_unload(vcpu);

Do we really need a kvm_mmu_unload()? Could we just set
vcpu->arch.mmu->root.hpa to INVALID_PAGE here? 

> +		goto out_gpte_changed;
> +	}
> +
>  	for_each_shadow_entry(vcpu, fault->addr, it) {
>  		gfn_t table_gfn;

B.R.
Yu
