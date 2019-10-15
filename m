Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5470D7AF5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbfJOQO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:14:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:51393 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfJOQO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:14:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 09:14:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="201800882"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Oct 2019 09:14:28 -0700
Date:   Tue, 15 Oct 2019 09:14:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
Message-ID: <20191015161427.GC15015@linux.intel.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
 <20191014183723.GE22962@linux.intel.com>
 <87v9sq46vz.fsf@vitty.brq.redhat.com>
 <97255084-7b10-73a5-bfb4-fdc1d5cc0f6e@redhat.com>
 <87lftm3wja.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lftm3wja.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 04:36:57PM +0200, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > On 15/10/19 12:53, Vitaly Kuznetsov wrote:
> >> A very theoretical question: why do we have 'struct vcpu' embedded in
> >> vcpu_vmx/vcpu_svm and not the other way around (e.g. in a union)? That
> >> would've allowed us to allocate memory in common code and then fill in
> >> vendor-specific details in .create_vcpu().

A union would waste a non-trivial amount of memory on SVM.

  SVM: struct size = 14560
  VMX: struct size = 16192

There are ways around that, but...

> >
> > Probably "because it's always been like that" is the most accurate answer.
> >
> 
> OK, so let me make my question a bit less theoretical: would you be in
> favor of changing the status quo? :-)

... we don't need to invert the strut embedding to re-order the create
flow.  'struct kvm_vcpu' must be at offset zero and the size of the vcpu
is vendor defined, so kvm_arch_vcpu_create() can allocate the struct and
directly cast it to a 'struct kvm_vcpu *'.
