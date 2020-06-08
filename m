Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6779D1F1B27
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgFHOjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:39:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:18724 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729948AbgFHOjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 10:39:02 -0400
IronPort-SDR: N3GlEXhnqNMQCejY1ESzxMxGyx1TkspY5lrO6C5ixCJNEn4Ke0NQ6XL0L/wSzrlHwsIYs3mBgX
 I4BA1zZP/RHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 07:39:00 -0700
IronPort-SDR: D0ix12Bs+J8SSR/5T0JAzVazG4EHYXaHaQZdGGJV/fhEXHozxda9QrerepGNKMsiM62mxWyYUq
 S2ymqfWc8sVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="305840070"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2020 07:38:59 -0700
Date:   Mon, 8 Jun 2020 07:38:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        Makarand Sonare <makarandsonare@google.com>,
        Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: selftests: fix vmx_preemption_timer_test build
 with GCC10
Message-ID: <20200608143859.GA8223@linux.intel.com>
References: <20200608112346.593513-1-vkuznets@redhat.com>
 <20200608112346.593513-2-vkuznets@redhat.com>
 <39c73030-49ff-f25c-74de-9a52579eefbe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c73030-49ff-f25c-74de-9a52579eefbe@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 08, 2020 at 01:57:03PM +0200, Paolo Bonzini wrote:
> On 08/06/20 13:23, Vitaly Kuznetsov wrote:
> > GCC10 fails to build vmx_preemption_timer_test:
> > 
> > gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99
> > -fno-stack-protector -fno-PIE -I../../../../tools/include
> >  -I../../../../tools/arch/x86/include -I../../../../usr/include/
> >  -Iinclude -Ix86_64 -Iinclude/x86_64 -I..  -pthread  -no-pie
> >  x86_64/evmcs_test.c ./linux/tools/testing/selftests/kselftest_harness.h
> >  ./linux/tools/testing/selftests/kselftest.h
> >  ./linux/tools/testing/selftests/kvm/libkvm.a
> >  -o ./linux/tools/testing/selftests/kvm/x86_64/evmcs_test
> > /usr/bin/ld: ./linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):
> >  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:603:
> >  multiple definition of `ctrl_exit_rev'; /tmp/ccMQpvNt.o:
> >  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:603:
> >  first defined here
> > /usr/bin/ld: ./linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):
> >  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:602:
> >  multiple definition of `ctrl_pin_rev'; /tmp/ccMQpvNt.o:
> >  ./linux/tools/testing/selftests/kvm/include/x86_64/vmx.h:602:
> >  first defined here
> >  ...
> > 
> > ctrl_exit_rev/ctrl_pin_rev/basic variables are only used in
> > vmx_preemption_timer_test.c, just move them there.
> > 
> > Fixes: 8d7fbf01f9af ("KVM: selftests: VMX preemption timer migration test")
> > Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/include/x86_64/vmx.h              | 4 ----
> >  .../testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c  | 4 ++++
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > index ccff3e6e2704..766af9944294 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> > @@ -598,10 +598,6 @@ union vmx_ctrl_msr {
> >  	};
> >  };
> >  
> > -union vmx_basic basic;
> > -union vmx_ctrl_msr ctrl_pin_rev;
> > -union vmx_ctrl_msr ctrl_exit_rev;
> > -
> >  struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
> >  bool prepare_for_vmx_operation(struct vmx_pages *vmx);
> >  void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
> > diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> > index cc72b6188ca7..a7737af1224f 100644
> > --- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
> > @@ -31,6 +31,10 @@ bool l2_save_restore_done;
> >  static u64 l2_vmx_pt_start;
> >  volatile u64 l2_vmx_pt_finish;
> >  
> > +union vmx_basic basic;
> > +union vmx_ctrl_msr ctrl_pin_rev;
> > +union vmx_ctrl_msr ctrl_exit_rev;
> > +
> >  void l2_guest_code(void)
> >  {
> >  	u64 vmx_pt_delta;
> > 
> 
> Queued both, thanks.

Hmm, someone go awry with your queue a while back?

https://lkml.kernel.org/r/ce6a5284-e09b-2f51-8cb6-baa29b3ac5c3@redhat.com
