Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6AC27F105
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgI3SHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:07:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:34849 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI3SHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:07:05 -0400
IronPort-SDR: n5cbLMJQwbey1Ird093JkM/boNlRpSKjD9RLf6M5cwy5NIl1uBoR5XOp39dmwoQE90bDsiteaL
 YMUgYTWYZyKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="161740366"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="161740366"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:06:22 -0700
IronPort-SDR: D2/UMYLeLJ9lhsTi+X2HkbSHDzIbPtCGLyxXRZWURaksbI1g2Jb8sjQZLAnZZE+7clC57wvKu6
 9qCIQlZgQ04Q==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="498683745"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 11:06:21 -0700
Date:   Wed, 30 Sep 2020 11:06:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 19/22] kvm: mmu: Support write protection for nesting in
 tdp MMU
Message-ID: <20200930180620.GI32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-20-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-20-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:59PM -0700, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 12892fc4f146d..e6f5093ba8f6f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1667,6 +1667,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>  		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
>  	}
>  
> +	if (kvm->arch.tdp_mmu_enabled)
> +		write_protected =
> +			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn) ||
> +			write_protected;

Similar to other comments, this can use |=.

> +
>  	return write_protected;
>  }
