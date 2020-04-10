Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6831A4839
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 18:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDJQGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 12:06:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:27566 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgDJQGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 12:06:07 -0400
IronPort-SDR: hd27Y7dd2DtFYzy+rFSI1ZJdQrkAwfw4MKR09HmrE05cm1qZ8jedt1VOuRUrxDjJO/XmiEnlhT
 MiHHVuXB+7CA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 09:06:06 -0700
IronPort-SDR: UXgOZj+U3clpDcQU5p6QTyNhf6cHt/ZwzHIo5iFymGE6zkF/k8LClS30Dk01YkWYhdSuoOBJwe
 osPP7YL93gZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,367,1580803200"; 
   d="scan'208";a="252237989"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2020 09:06:04 -0700
Date:   Fri, 10 Apr 2020 09:06:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Marco Elver <elver@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: KCSAN + KVM = host reset
Message-ID: <20200410160603.GA23354@linux.intel.com>
References: <CANpmjNMR4BgfCxL9qXn0sQrJtQJbEPKxJ5_HEa2VXWi6UY4wig@mail.gmail.com>
 <AC8A5393-B817-4868-AA85-B3019A1086F9@lca.pw>
 <CANpmjNPqQHKUjqAzcFym5G8kHX0mjProOpGu8e4rBmuGRykAUg@mail.gmail.com>
 <B798749E-F2F0-4A14-AFE3-F386AB632AEB@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B798749E-F2F0-4A14-AFE3-F386AB632AEB@lca.pw>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 11:50:10AM -0400, Qian Cai wrote:
> 
> This works,
> 
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3278,7 +3278,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
>  
> -static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> +static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> 
> Does anyone has any idea why svm_vcpu_run() would be a problem for
> KCSAN_INTERRUPT_WATCHER=y?
> 
> I can only see there are a bunch of assembly code in __svm_vcpu_run() that
> might be related?

svm_vcpu_run() does all kinds of interrupt toggling, e.g. the sequence is:

  1. EFLAGS.IF == 0, from caller
  2. clgi()
  3. EFLAGS.IF <= 1
  4. __svm_vcpu_run(), i.e. enter guest
  5. EFLAGS == 0, from VM-Exit
  6. EFLAGS.IF <= 1
  7. stgi()
