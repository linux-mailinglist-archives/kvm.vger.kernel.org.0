Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E248BF30
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfHMREm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 13:04:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:52516 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfHMREm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 13:04:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 10:04:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,382,1559545200"; 
   d="scan'208";a="181243702"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 13 Aug 2019 10:04:41 -0700
Date:   Tue, 13 Aug 2019 10:04:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <20190813170440.GC13991@linux.intel.com>
References: <20190205205443.1059-1-sean.j.christopherson@intel.com>
 <20190205210137.1377-11-sean.j.christopherson@intel.com>
 <20190813100458.70b7d82d@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813100458.70b7d82d@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 10:04:58AM -0600, Alex Williamson wrote:
> On Tue,  5 Feb 2019 13:01:21 -0800
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
> > Modify kvm_mmu_invalidate_zap_pages_in_memslot(), a.k.a. the x86 MMU's
> > handler for kvm_arch_flush_shadow_memslot(), to zap only the pages/PTEs
> > that actually belong to the memslot being removed.  This improves
> > performance, especially why the deleted memslot has only a few shadow
> > entries, or even no entries.  E.g. a microbenchmark to access regular
> > memory while concurrently reading PCI ROM to trigger memslot deletion
> > showed a 5% improvement in throughput.
> > 
> > Cc: Xiao Guangrong <guangrong.xiao@gmail.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/mmu.c | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> A number of vfio users are reporting VM instability issues since v5.1,
> some have traced it back to this commit 4e103134b862 ("KVM: x86/mmu: Zap
> only the relevant pages when removing a memslot"), which I've confirmed
> via bisection of the 5.1 merge window KVM pull (636deed6c0bc) and
> re-verified on current 5.3-rc4 using the below patch to toggle the
> broken behavior.
> 
> My reproducer is a Windows 10 VM with assigned GeForce GPU running a
> variety of tests, including FurMark and PassMark Performance Test.
> With the code enabled as exists in upstream currently, PassMark will
> generally introduce graphics glitches or hangs.  Sometimes it's
> necessary to reboot the VM to see these issues.

As in, the issue only shows up when the VM is rebooted?  Just want to
double check that that's not a typo.

> Flipping the 0/1 in the below patch appears to resolve the issue.
> 
> I'd appreciate any insights into further debugging this block of code
> so that we can fix this regression.  Thanks,

If it's not too painful to reproduce, I'd say start by determining whether
it's a problem with the basic logic or if the cond_resched_lock() handling
is wrong.  I.e. comment/ifdef out this chunk:

		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
			flush = false;
			cond_resched_lock(&kvm->mmu_lock);
		}


> 
> Alex
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 24843cf49579..6a77306940f7 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5653,6 +5653,9 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  			struct kvm_memory_slot *slot,
>  			struct kvm_page_track_notifier_node *node)
>  {
> +#if 0
> +	kvm_mmu_zap_all(kvm);
> +#else
>  	struct kvm_mmu_page *sp;
>  	LIST_HEAD(invalid_list);
>  	unsigned long i;
> @@ -5685,6 +5688,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>  
>  out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
> +#endif
>  }
>  
>  void kvm_mmu_init_vm(struct kvm *kvm)
