Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7826E22F412
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbgG0Pq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 11:46:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:33366 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgG0Pqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 11:46:55 -0400
IronPort-SDR: ijYCwLN+uF2fKAdRqy7GWUg2qeY5F000UrK8mmx8U1fCSoVbRwpuVJgTrLLBtM3Vj4+7nnJzIl
 E2wKSb/PJTpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="130593839"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="130593839"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 08:46:55 -0700
IronPort-SDR: ih74wHAEYTgG09ISPxHpa0sZYUGRI/PD0HgCEATM0+pBVOUSwgyikQi0/0Q2DOSW/3f5JerjGz
 ZIhxFi+nRlFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="273290556"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 27 Jul 2020 08:46:54 -0700
Date:   Mon, 27 Jul 2020 08:46:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
Message-ID: <20200727154654.GA8675@linux.intel.com>
References: <20200713082824.1728868-1-vkuznets@redhat.com>
 <20200713151750.GA29901@linux.intel.com>
 <878sfntnoz.fsf@vitty.brq.redhat.com>
 <85fd54ff-01f5-0f1f-1bb7-922c740a37c1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85fd54ff-01f5-0f1f-1bb7-922c740a37c1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 01:43:34PM +0200, Paolo Bonzini wrote:
> On 13/07/20 17:54, Vitaly Kuznetsov wrote:
> > Which means that userspace built for the old kernel will potentially send in
> > garbage for the new 'flags' field due to it being uninitialized stack data,
> > even with the layout after this patch.
> 
> It might as well send it now if the code didn't attempt to zero the
> struct before filling it in (this is another good reason to use a
> "flags" field to say what's been filled in).

The issue is that flags itself could hold garbage.

https://lkml.kernel.org/r/20200713151750.GA29901@linux.intel.com

>  I don't think special
> casing padding is particularly useful; C11 for example requires
> designated initializers to fill padding with zero bits[1] and even
> before it's always been considered good behavior to use memset.
> 
> Paolo
> 
> [1]  It says: "If an object that has static or thread storage duration
> is not initialized explicitly, then [...] any padding is initialized to
> zero bits" 

static and per-thread storage is unlikely to be relevant, 

> and even for non-static objects, "If there are fewer
> initializers in a brace-enclosed list than there are elements or members
> of an aggregate [...] the remainder of the aggregate shall be
> initialized implicitly the same as objects that have static storage
> duration".

That's specifically talking about members, not usused/padded space, e.g.
smm.flags (in the hold struct) must be zeroed with this, but it doesn't
say anything about initializing padding.

  struct kvm_vmx_nested_state_hdr hdr = {
      .vmxon_pa = root,
      .vmcs12_pa = vmcs12,
  };

QEMU won't see issues because it zero allocates the entire nested state.

All the above being said, after looking at the whole picture I think padding
the header is a moot point.  The header is padded out to 120 bytes[*] when
including in the full nested state, and KVM only ever consumes the header in
the context of the full nested state.  I.e. if there's garbage at offset 6,
odds are there's going to be garbage at offset 18, so internally padding the
header does nothing.

KVM should be checking that the unused bytes of (sizeof(pad) - sizeof(vmx/svm))
is zero if we want to expand into the padding in the future.  Right now we're
relying on userspace to zero allocate the struct without enforcing it.

[*] Amusing side note, the comment in the header is wrong.  It states "pad
    the header to 128 bytes", but only pads it to 120 bytes, because union.

/* for KVM_CAP_NESTED_STATE */
struct kvm_nested_state {
	__u16 flags;
	__u16 format;
	__u32 size;

	union {
		struct kvm_vmx_nested_state_hdr vmx;
		struct kvm_svm_nested_state_hdr svm;

		/* Pad the header to 128 bytes.  */
		__u8 pad[120];
	} hdr;

	/*
	 * Define data region as 0 bytes to preserve backwards-compatability
	 * to old definition of kvm_nested_state in order to avoid changing
	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
	 */
	union {
		struct kvm_vmx_nested_state_data vmx[0];
		struct kvm_svm_nested_state_data svm[0];
	} data;
};


Odds are no real VMM will have issue given the dynamic size of struct
kvm_nested_state, but 
