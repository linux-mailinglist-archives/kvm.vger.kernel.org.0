Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2125B83E
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 03:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgICBW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 21:22:28 -0400
Received: from mga12.intel.com ([192.55.52.136]:36153 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICBW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 21:22:28 -0400
IronPort-SDR: Gqt90s+Jo6MUhApI3q7ht14pitqZW/TA76WHUSPGY1JWFI509zcefWNN7uuHSW2cO1QErf3zVb
 n8nQay56Ji4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="137021365"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="137021365"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 18:22:27 -0700
IronPort-SDR: fb6E8nq0cilRzQCk73cJ19JBm1IlpMEVdQP8pS0Z3LXavCslpx/43u8vaB8IBe4/7Gfi7Wp7aF
 iRS8V5zd6+tw==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="302034350"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 18:22:26 -0700
Date:   Wed, 2 Sep 2020 18:22:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH V2] kvm x86/mmu: use KVM_REQ_MMU_SYNC to sync when needed
Message-ID: <20200903012224.GL11695@sjchrist-ice>
References: <87y2ltx6gl.fsf@vitty.brq.redhat.com>
 <20200902135421.31158-1-jiangshanlai@gmail.com>
 <871rjkp8rc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rjkp8rc.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 02, 2020 at 04:12:55PM +0200, Vitaly Kuznetsov wrote:
> Lai Jiangshan <jiangshanlai@gmail.com> writes:
> 
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> >
> > When kvm_mmu_get_page() gets a page with unsynced children, the spt
> > pagetable is unsynchronized with the guest pagetable. But the
> > guest might not issue a "flush" operation on it when the pagetable
> > entry is changed from zero or other cases. The hypervisor has the 
> > responsibility to synchronize the pagetables.
> >
> > The linux kernel behaves as above for many years, But
> > 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)
> 
> Nit: checkpatch.pl complains here with 
> 
> ERROR: Please use git commit description style 'commit <12+ chars of
> sha1> ("<title line>")' - ie: 'commit 8c8560b83390 ("KVM: x86/mmu: Use
> KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes")'
> #118: 
> 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)

Definitely needs a

  Fixes: 8c8560b83390("KVM: x86/mmu: Use KVM_REQ_TLB_FLUSH_CURRENT for MMU specific flushes)

At that point I'd just have the changelog say "a recent commit".

> > inadvertently included a line of code to change it without giving any
> > reason in the changelog. It is clear that the commit's intention was to
> > change KVM_REQ_TLB_FLUSH -> KVM_REQ_TLB_FLUSH_CURRENT, so we don't
> > unneedlesly flush other contexts but one of the hunks changed
> > nearby KVM_REQ_MMU_SYNC instead.
> >
> > The this patch changes it back.
> >
> > Link: https://lore.kernel.org/lkml/20200320212833.3507-26-sean.j.christopherson@intel.com/
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> > Changed from v1:
> > 	update patch description
> >
> >  arch/x86/kvm/mmu/mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 4e03841f053d..9a93de921f2b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2468,7 +2468,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >  		}
> >  
> >  		if (sp->unsync_children)
> > -			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > +			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> >  
> >  		__clear_sp_write_flooding_count(sp);
> 
> FWIW, 
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> but it'd be great to hear from Sean).

I got nothing, AFAICT I was simply overzealous.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
