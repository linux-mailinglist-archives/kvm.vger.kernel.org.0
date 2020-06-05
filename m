Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4821F00B7
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 22:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgFEUGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 16:06:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:55629 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgFEUGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 16:06:52 -0400
IronPort-SDR: qLCGo+iyW5O1JSOnOSsv1dq/jtaV76EGpwu1yhLYo6KzJrHBQs6s73tcFkK7OSWlpGwHSIkg78
 m/Mp3p4AXDUw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 13:06:52 -0700
IronPort-SDR: vuidcrLsSHUvLnHM78ClpxSJeqGc1d3MaeNx3OBTZpmjtVUy5Y5t1NWeE+1lmsl8lGzaGx7iSI
 EjIelMGv2OzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="378839299"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jun 2020 13:06:52 -0700
Date:   Fri, 5 Jun 2020 13:06:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Properly handle
 kvm_read/write_guest_virt*() result
Message-ID: <20200605200651.GC11449@linux.intel.com>
References: <20200605115906.532682-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605115906.532682-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 05, 2020 at 01:59:05PM +0200, Vitaly Kuznetsov wrote:
> Introduce vmx_handle_memory_failure() as an interim solution.

Heh, "interim".  I'll take the over on that :-D.

> Note, nested_vmx_get_vmptr() now has three possible outcomes: OK, PF,
> KVM_EXIT_INTERNAL_ERROR and callers need to know if userspace exit is
> needed (for KVM_EXIT_INTERNAL_ERROR) in case of failure. We don't seem
> to have a good enum describing this tristate, just add "int *ret" to
> nested_vmx_get_vmptr() interface to pass the information.
> 
> Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

...

> +/*
> + * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
> + * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
> + * indicates whether exit to userspace is needed.
> + */
> +int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
> +			      struct x86_exception *e)
> +{
> +	if (r == X86EMUL_PROPAGATE_FAULT) {
> +		kvm_inject_emulated_page_fault(vcpu, e);
> +		return 1;
> +	}
> +
> +	/*
> +	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
> +	 * while handling a VMX instruction KVM could've handled the request

A nit similar to your observation on the shortlog, this isn't limited to VMX
instructions.

> +	 * correctly by exiting to userspace and performing I/O but there
> +	 * doesn't seem to be a real use-case behind such requests, just return
> +	 * KVM_EXIT_INTERNAL_ERROR for now.
> +	 */
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	vcpu->run->internal.ndata = 0;
> +
> +	return 0;
> +}
