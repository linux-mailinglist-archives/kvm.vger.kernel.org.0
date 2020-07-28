Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EA9230E9D
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 17:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgG1P7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 11:59:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:30043 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730679AbgG1P7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 11:59:23 -0400
IronPort-SDR: hb9ddBj5c99+NOMi7xoavry0r6zdXsv74jEwqQAwAx8TVZqIKDjZD0IwlAvU/d2/1Eg94AOA8S
 aFHRO70BRCxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="152492565"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="152492565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 08:59:22 -0700
IronPort-SDR: 3+avlv1CfLZM+1dJZ3q9UKyBJRhsBI18RcjkFTL8a/m36xIVEZe9AmnmWnbnm7aeGNQlWYS5cG
 utYz7RovAyIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="490410915"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jul 2020 08:59:21 -0700
Date:   Tue, 28 Jul 2020 08:59:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: properly pad struct kvm_vmx_nested_state_hdr
Message-ID: <20200728155921.GC5300@linux.intel.com>
References: <20200713082824.1728868-1-vkuznets@redhat.com>
 <20200713151750.GA29901@linux.intel.com>
 <878sfntnoz.fsf@vitty.brq.redhat.com>
 <85fd54ff-01f5-0f1f-1bb7-922c740a37c1@redhat.com>
 <20200727154654.GA8675@linux.intel.com>
 <5d50ea1e-f2a2-8aa9-1dd3-4cbca6c6f885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d50ea1e-f2a2-8aa9-1dd3-4cbca6c6f885@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 06:16:56PM +0200, Paolo Bonzini wrote:
> On 27/07/20 17:46, Sean Christopherson wrote:
> > All the above being said, after looking at the whole picture I think padding
> > the header is a moot point.  The header is padded out to 120 bytes[*] when
> > including in the full nested state, and KVM only ever consumes the header in
> > the context of the full nested state.  I.e. if there's garbage at offset 6,
> > odds are there's going to be garbage at offset 18, so internally padding the
> > header does nothing.
> 
> Yes, that was what I was hinting at with "it might as well send it now"
> (i.e., after the patch).
> 
> (All of this is moot for userspace that just uses KVM_GET_NESTED_STATE
> and passes it back to KVM_SET_NESTED_STATE).
> 
> > KVM should be checking that the unused bytes of (sizeof(pad) - sizeof(vmx/svm))
> > is zero if we want to expand into the padding in the future.  Right now we're
> > relying on userspace to zero allocate the struct without enforcing it.
> 
> The alternative, which is almost as good, is to only use these extra
> fields which could be garbage if the flags are not set, and check the
> flags (see the patches I have sent earlier today).
> 
> The chance of the flags passing the check will decrease over time as
> more flags are added; but the chance of having buggy userspace that
> sends down garbage also will.

Ah, I see what you're saying.  Ya, that makes sense.

> > [*] Amusing side note, the comment in the header is wrong.  It states "pad
> >     the header to 128 bytes", but only pads it to 120 bytes, because union.
> > 
> > /* for KVM_CAP_NESTED_STATE */
> > struct kvm_nested_state {
> > 	__u16 flags;
> > 	__u16 format;
> > 	__u32 size;
> > 
> > 	union {
> > 		struct kvm_vmx_nested_state_hdr vmx;
> > 		struct kvm_svm_nested_state_hdr svm;
> > 
> > 		/* Pad the header to 128 bytes.  */
> > 		__u8 pad[120];
> > 	} hdr;
> 
> There are 8 bytes before the union, and it's not a coincidence. :)
> "Header" refers to the stuff before the data region.

Ugh, then 'hdr' probably should be named vendor_header or something. 
