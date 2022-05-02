Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58664516EA0
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 13:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiEBLQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 07:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiEBLQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 07:16:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A515A5FFA;
        Mon,  2 May 2022 04:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651489984; x=1683025984;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EC3+2wnZVexq801X0N/krg0yVyBm5vCd1GA2Nj1Q5VM=;
  b=GVsHRlOzTJFpDWz/SJPREFD7ZRgp23pauv5Z6MVovMHu+wyVg0VWw6TC
   NPijD11Ep8FjPA4DQAneO9GdIG2tmgqDn0zpK8hAjv/rMJGLnEZKZreZs
   S2xj64BGNgwFC7tOUKSDpy2slne/botKQfxLc8Ur6Tm66RlvJFqZpNxj4
   ufY8248YXWk73X8SiuxgmDEhwgPFapHTlX8t1LP7FaTi7z49XscEt76Xq
   kwLFDGscjnI5iyTXr58XZQwCZZA/31ESNkNZqLsbTMlrYrvsJMLyh2r0J
   ZJgHbkglPSclEb12oaNbSFZP1pgb2Y44Qmx7b1kXEkso7vXjHtSJ9aRxT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="267339596"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="267339596"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 04:12:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="535801181"
Received: from bwu50-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.2.219])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 04:12:54 -0700
Message-ID: <2d10ff16d3f5fa03886721c24f2db10d79759ed2.camel@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Date:   Mon, 02 May 2022 23:12:52 +1200
In-Reply-To: <20220428233416.2446833-1-seanjc@google.com>
References: <20220428233416.2446833-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 23:34 +0000, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 904f0faff218..c10ae25135e3 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3010,9 +3010,15 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
>  		/*
>  		 * If MMIO caching is disabled, emulate immediately without
>  		 * touching the shadow page tables as attempting to install an
> -		 * MMIO SPTE will just be an expensive nop.
> +		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
> +		 * whose gfn is greater than host.MAXPHYADDR, any guest that
> +		 * generates such gfns is either malicious or in the weeds.
> +		 * Note, it's possible to observe a gfn > host.MAXPHYADDR if
> +		 * and only if host.MAXPHYADDR is inaccurate with respect to
> +		 * hardware behavior, e.g. if KVM itself is running as a VM.
>  		 */
> -		if (unlikely(!enable_mmio_caching)) {
> +		if (unlikely(!enable_mmio_caching) ||
> +		    unlikely(fault->gfn > kvm_mmu_max_gfn_host())) {

Shouldn't we check fault->gfn against cpuid_maxphyaddr(vcpu) instead of
kvm_mmu_max_gfn_host() here?

>  			*ret_val = RET_PF_EMULATE;
>  			return true;
>  		}


-- 
Thanks,
-Kai


