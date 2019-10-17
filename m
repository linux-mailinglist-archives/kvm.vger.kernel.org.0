Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6E9DB20C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 18:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440449AbfJQQMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 12:12:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:49018 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390535AbfJQQMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 12:12:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 09:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="347806672"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 17 Oct 2019 09:12:21 -0700
Date:   Thu, 17 Oct 2019 09:12:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: X86: Refactor kvm_arch_vcpu_create
Message-ID: <20191017161221.GB20903@linux.intel.com>
References: <20191015164033.87276-1-xiaoyao.li@intel.com>
 <20191015164033.87276-4-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015164033.87276-4-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 12:40:32AM +0800, Xiaoyao Li wrote:
> Current x86 arch vcpu creation flow is a little bit messed.
> Specifically, vcpu's data structure allocation and vcpu initialization
> are mixed up, which is unfriendly to read.
> 
> Seperating the vcpu_create and vcpu_init just like what ARM does, that
> it first calls vcpu_create related functions for vcpu's data structure
> allocation and then calls vcpu_init related functions to initialize the
> vcpu.

My vote is to take advantage of the requirement that @vcpu must reside at
offset 0 in vmx_vcpu and svm_vcpu, and allocate the vcpu in x86 code.
That would allow kvm_arch_vcpu_create() to invoke kvm_vcpu_init() directly
instead of bouncing through the vendor code.

And if we're extra lucky and the other architectures can use a similar
pattern, kvm_vm_ioctl_create_vcpu() could be refactored to something like:

	vcpu = kvm_arch_vcpu_alloc(kvm, id);
	if (IS_ERR(vcpu)) {
		r = PTR_ERR(vcpu);
		goto vcpu_decrement;
	}

	r = kvm_arch_vcpu_init(vcpu);
	if (r)
		goto vcpu_destroy;
