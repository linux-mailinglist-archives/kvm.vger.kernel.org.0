Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8621D9F3
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 17:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgGMPSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 11:18:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:27119 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGMPSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 11:18:09 -0400
IronPort-SDR: 7t4lzylVkLdbMHlSFjmooUpdyvAbijZ8IpvBUYiwBa8UZvNs7ZRkHU9b+D4eLYrIuWg30C6tCr
 l+BBUPo1tkoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136104685"
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="136104685"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 08:17:50 -0700
IronPort-SDR: k+LArToREmmC7e4v1zUnIxNuRxpCtVuMqz0gR8g4Q8HZELz/BEFpKHVPkyOZ0YXfaARAhLJzoy
 jiIZFE/0qDfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="429420888"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 13 Jul 2020 08:17:50 -0700
Date:   Mon, 13 Jul 2020 08:17:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
Message-ID: <20200713151750.GA29901@linux.intel.com>
References: <20200713082824.1728868-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713082824.1728868-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 10:28:24AM +0200, Vitaly Kuznetsov wrote:
> Holes in structs which are userspace ABI are undesireable.
> 
> Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  | 2 +-
>  arch/x86/include/uapi/asm/kvm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 320788f81a05..7beccda11978 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4345,7 +4345,7 @@ Errors:
>  	struct {
>  		__u16 flags;
>  	} smm;
> -
> +	__u16 pad;

I don't think this is sufficient.  Before 83d31e5271ac, the struct was:

	struct kvm_vmx_nested_state_hdr {
		__u64 vmxon_pa;
		__u64 vmcs12_pa;

		struct {
			__u16 flags;
		} smm;
	};

which most/all compilers will pad out to 24 bytes on a 64-bit system.  And
although smm.flags is padded to 8 bytes, it's initialized as a 2 byte value.

714             struct kvm_vmx_nested_state_hdr boo;
715             u64 val;
716
717             BUILD_BUG_ON(sizeof(boo) != 3*8);
718             boo.smm.flags = 0;
   0xffffffff810148a9 <+41>:    xor    %eax,%eax
   0xffffffff810148ab <+43>:    mov    %ax,0x18(%rsp)

719
720             val = *((volatile u64 *)(&boo.smm.flags));
   0xffffffff810148b0 <+48>:    mov    0x18(%rsp),%rax


Which means that userspace built for the old kernel will potentially send in
garbage for the new 'flags' field due to it being uninitialized stack data,
even with the layout after this patch.

	struct kvm_vmx_nested_state_hdr {
		__u64 vmxon_pa;
		__u64 vmcs12_pa;

		struct {
			__u16 flags;
		} smm;
		__u16 pad;
		__u32 flags;
		__u64 preemption_timer_deadline;
	};

So to be backwards compatible I believe we need to add a __u32 pad as well,
and to not cause internal padding issues, either make the new 'flags' a
__u64 or pad that as well (or add and check a reserved __32).  Making flags
a __64 seems like the least wasteful approach, e.g.

	struct kvm_vmx_nested_state_hdr {
		__u64 vmxon_pa;
		__u64 vmcs12_pa;

		struct {
			__u16 flags;
		} smm;
		__u16 pad16;
		__u32 pad32;
		__u64 flags;
		__u64 preemption_timer_deadline;
	};


>  	__u32 flags;
>  	__u64 preemption_timer_deadline;
>    };
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0780f97c1850..aae3df1cbd01 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -414,7 +414,7 @@ struct kvm_vmx_nested_state_hdr {
>  	struct {
>  		__u16 flags;
>  	} smm;
> -
> +	__u16 pad;
>  	__u32 flags;
>  	__u64 preemption_timer_deadline;
>  };
> -- 
> 2.25.4
> 
