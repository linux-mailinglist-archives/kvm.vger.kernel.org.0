Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38601543F77
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiFHWx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiFHWxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:53:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC17D273937;
        Wed,  8 Jun 2022 15:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654728817; x=1686264817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NhmdTiKqiHkpCrV7R4BLyvl3kS04YCUs0RNC4czJGX0=;
  b=Y5bDh7dGo4WwinRAZYk2Vx9geXPI/EzFf8G811w1aefZioxClY3otNc0
   2yc3liOc+uPtyB32+NRFUXVpRWEXDkkLMpcF9CjvdeBTya1qZfqYEnSOk
   LDRP7Uwya9ndnC0QaXvZkxXuZOmca0gD5AuHS+nSpWoIycWHc1qv+jTPC
   Bb5v4reQGCODPLDbowJq4lN6Yv/Nr0vBvlbm9lSMLz+QfG/6oABCpg7ww
   JuMWAYtmYOaw8H5E4F3cz94yphctCnnJtZ9t7KZTb2AyUxL/2FS/Yfu4a
   M3qKAz+QrfDGHNMU/ZYVy/DE4Px9AtSl4Lw5zhxFyW6EKsN4Q7NFU9uSj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="302437116"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="302437116"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 15:53:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="827223830"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 15:53:34 -0700
Date:   Thu, 9 Jun 2022 06:53:33 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yuan Yao <yuan.yao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 1/1] KVM: x86/mmu: Set memory encryption "value", not
 "mask", in shadow PDPTRs
Message-ID: <20220608225333.2dxqh6rfe2nr2jd6@yy-desk-7060>
References: <20220608012015.19566-1-yuan.yao@intel.com>
 <6a9e17c5-c49a-e5c4-b74b-b8a97f7dc675@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9e17c5-c49a-e5c4-b74b-b8a97f7dc675@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022 at 02:37:27PM +0200, Paolo Bonzini wrote:
> On 6/8/22 03:20, Yuan Yao wrote:
> > Assign shadow_me_value, not shadow_me_mask, to PAE root entries,
> > a.k.a. shadow PDPTRs, when host memory encryption is supported.  The
> > "mask" is the set of all possible memory encryption bits, e.g. MKTME
> > KeyIDs, whereas "value" holds the actual value that needs to be
> > stuffed into host page tables.
> >
> > Using shadow_me_mask results in a failed VM-Entry due to setting
> > reserved PA bits in the PDPTRs, and ultimately causes an OOPS due to
> > physical addresses with non-zero MKTME bits sending to_shadow_page()
> > into the weeds:
> >
> > set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> > BUG: unable to handle page fault for address: ffd43f00063049e8
> > PGD 86dfd8067 P4D 0
> > Oops: 0000 [#1] PREEMPT SMP
> > RIP: 0010:mmu_free_root_page+0x3c/0x90 [kvm]
> >   kvm_mmu_free_roots+0xd1/0x200 [kvm]
> >   __kvm_mmu_unload+0x29/0x70 [kvm]
> >   kvm_mmu_unload+0x13/0x20 [kvm]
> >   kvm_arch_destroy_vm+0x8a/0x190 [kvm]
> >   kvm_put_kvm+0x197/0x2d0 [kvm]
> >   kvm_vm_release+0x21/0x30 [kvm]
> >   __fput+0x8e/0x260
> >   ____fput+0xe/0x10
> >   task_work_run+0x6f/0xb0
> >   do_exit+0x327/0xa90
> >   do_group_exit+0x35/0xa0
> >   get_signal+0x911/0x930
> >   arch_do_signal_or_restart+0x37/0x720
> >   exit_to_user_mode_prepare+0xb2/0x140
> >   syscall_exit_to_user_mode+0x16/0x30
> >   do_syscall_64+0x4e/0x90
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Fixes: e54f1ff244ac ("KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask")
> > Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index efe5a3dca1e0..6bd144f1e60c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3411,7 +3411,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >   			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
> >   					      i << 30, PT32_ROOT_LEVEL, true);
> >   			mmu->pae_root[i] = root | PT_PRESENT_MASK |
> > -					   shadow_me_mask;
> > +					   shadow_me_value;
> >   		}
> >   		mmu->root.hpa = __pa(mmu->pae_root);
> >   	} else {
>
> Queued, thanks.
>
> Paolo

Thanks Paolo, and Thanks again to Sean Christopherson
<seanjc@google.com>'s nice help for patch subject/format on this patch
(was [PATCH 1/1] KVM: MMU: Fix VM entry failure and OOPS for shdaow
page table).

>
