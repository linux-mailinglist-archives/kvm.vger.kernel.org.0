Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F24194E91
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 02:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgC0BkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 21:40:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:1473 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbgC0BkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 21:40:22 -0400
IronPort-SDR: 91zBWRiJwZWukXvnuH4CP1Ie7sbpYBdQRMqbEUIW8PIYYvkXybo8jcoh5HJ+NiZXMGS/11hE1D
 SnXQ44Lb4GAg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 18:40:21 -0700
IronPort-SDR: bf1BJd4KJfUJwgO3KWmqtGh6DRr51Lcqg+KjI9SebvlaaxaldJrWXvYaHmDDxakUR3gaSzXeQx
 uZwUl1vdU+ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,310,1580803200"; 
   d="scan'208";a="266061464"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 26 Mar 2020 18:40:21 -0700
Date:   Thu, 26 Mar 2020 18:40:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     Joerg Roedel <jroedel@suse.de>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm:queue 276/278] arch/x86/kvm/svm/nested.c:88:49: error:
 invalid type argument of '->' (have 'struct kvm_x86_ops')
Message-ID: <20200327014021.GD28014@linux.intel.com>
References: <202003270843.uYmVPJ2b%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003270843.uYmVPJ2b%lkp@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 27, 2020 at 08:29:47AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
>    arch/x86/kvm/svm/nested.c: In function 'nested_svm_init_mmu_context':
> >> arch/x86/kvm/svm/nested.c:88:49: error: invalid type argument of '->' (have 'struct kvm_x86_ops')
>      vcpu->arch.mmu->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
>                                                     ^~
> 
> vim +88 arch/x86/kvm/svm/nested.c
> 
>     78	
>     79	static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>     80	{
>     81		WARN_ON(mmu_is_nested(vcpu));
>     82	
>     83		vcpu->arch.mmu = &vcpu->arch.guest_mmu;
>     84		kvm_init_shadow_mmu(vcpu);
>     85		vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
>     86		vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
>     87		vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
>   > 88		vcpu->arch.mmu->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);

Tip of the iceberg.  kvm.git/queue is totally busted, the last two commits
remove code from svm.c but don't create the new files.

  $ git-tree kvm/queue
  arch/x86/kvm/Makefile
  arch/x86/kvm/svm/svm.c
  arch/x86/kvm/svm/svm.h

  $ gwo kvm/queue
  a7740c8860d7 ("KVM: SVM: Move SEV code to separate file")

>     89		reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
>     90		vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
>     91	}
>     92	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


