Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C716F0C9
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 22:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgBYVBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 16:01:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:44473 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgBYVBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 16:01:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 13:01:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="438193201"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 25 Feb 2020 13:01:50 -0800
Date:   Tue, 25 Feb 2020 13:01:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/61] KVM: x86/mmu: Configure max page level during
 hardware setup
Message-ID: <20200225210149.GH9245@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-59-sean.j.christopherson@intel.com>
 <87blpmlobr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blpmlobr.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 03:43:36PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Configure the max page level during hardware setup to avoid a retpoline
> > in the page fault handler.  Drop ->get_lpage_level() as the page fault
> > handler was the last user.
> > @@ -6064,11 +6064,6 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
> >  	}
> >  }
> >  
> > -static int svm_get_lpage_level(void)
> > -{
> > -	return PT_PDPE_LEVEL;
> > -}
> 
> I've probably missed something but before the change, get_lpage_level()
> on AMD was always returning PT_PDPE_LEVEL, but after the change and when
> NPT is disabled, we set max_page_level to either PT_PDPE_LEVEL (when
> boot_cpu_has(X86_FEATURE_GBPAGES)) or PT_DIRECTORY_LEVEL
> (otherwise). This sounds like a change) unless we think that
> boot_cpu_has(X86_FEATURE_GBPAGES) is always true on AMD.

It looks like a functional change, but isn't.  kvm_mmu_hugepage_adjust()
caps the page size used by KVM's MMU at the minimum of ->get_lpage_level()
and the host's mapping level.  Barring an egregious bug in the kernel MMU,
the host page tables will max out at PT_DIRECTORY_LEVEL (2mb) unless
boot_cpu_has(X86_FEATURE_GBPAGES) is true.

In other words, this is effectively a "documentation" change.  I'll figure
out a way to explain this in the changelog...

        max_level = min(max_level, kvm_x86_ops->get_lpage_level());
        for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
                linfo = lpage_info_slot(gfn, slot, max_level);
                if (!linfo->disallow_lpage)
                        break;
        }

        if (max_level == PT_PAGE_TABLE_LEVEL)
                return PT_PAGE_TABLE_LEVEL;

        level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
        if (level == PT_PAGE_TABLE_LEVEL)
                return level;

        level = min(level, max_level); <---------
