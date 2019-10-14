Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F119D698F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 20:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731703AbfJNShY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 14:37:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:35204 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbfJNShY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 14:37:24 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 11:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="201538235"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Oct 2019 11:37:23 -0700
Date:   Mon, 14 Oct 2019 11:37:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: X86: Make fpu allocation a common function
Message-ID: <20191014183723.GE22962@linux.intel.com>
References: <20191014162247.61461-1-xiaoyao.li@intel.com>
 <87y2xn462e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2xn462e.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 06:58:49PM +0200, Vitaly Kuznetsov wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > They are duplicated codes to create vcpu.arch.{user,guest}_fpu in VMX
> > and SVM. Make them common functions.
> >
> > No functional change intended.
> 
> Would it rather make sense to move this code to
> kvm_arch_vcpu_create()/kvm_arch_vcpu_destroy() instead?

Does it make sense?  Yes.  Would it actually work?  No.  Well, not without
other shenanigans.

FPU allocation can't be placed after the call to .create_vcpu() becuase
it's consumed in kvm_arch_vcpu_init().   FPU allocation can't come before
.create_vcpu() because the vCPU struct itself hasn't been allocated.  The
latter could be solved by passed the FPU pointer into .create_vcpu(), but
that's a bit ugly and is not a precedent we want to set.

At a glance, FPU allocation can be moved to kvm_arch_vcpu_init(), maybe
right before the call to fx_init().
