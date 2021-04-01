Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2937735180E
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhDARnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:43:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234925AbhDARlU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DmKnXvfMsDsqJmp2i9gQ0b8U5NbC/IHrSRuv8yD1DA=;
        b=UXIbfedUiW8NG8J69dB5OxVamVoe0aydhyb5u70Pcs9WTDlb0BsanYDwuZJv6yhVt4zF4J
        cQv6w75qFdGJ4Xs/E/DyL4TVxeznpk8+YMz8P5fuVD4sYUFKa0U67Cdd+N9lvakPH500+Z
        cvZSpjz7YzBNQY/4W93L4IvsawWPW7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-O5uQh4liNO-3fml1QQs6rQ-1; Thu, 01 Apr 2021 13:10:31 -0400
X-MC-Unique: O5uQh4liNO-3fml1QQs6rQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1DF7817469;
        Thu,  1 Apr 2021 17:10:29 +0000 (UTC)
Received: from starship (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2172C59469;
        Thu,  1 Apr 2021 17:10:25 +0000 (UTC)
Message-ID: <0b3a93e3d1ba6a89da327b93be2ecf47f22010d4.camel@redhat.com>
Subject: Re: [PATCH 4/6] KVM: x86: Introduce KVM_GET_SREGS2 / KVM_SET_SREGS2
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Date:   Thu, 01 Apr 2021 20:10:24 +0300
In-Reply-To: <b1a36c94-6dd5-88ef-a503-f6d91eb2d267@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
         <20210401141814.1029036-5-mlevitsk@redhat.com>
         <b1a36c94-6dd5-88ef-a503-f6d91eb2d267@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-01 at 16:44 +0200, Paolo Bonzini wrote:
> Just a quick review on the API:
> 
> On 01/04/21 16:18, Maxim Levitsky wrote:
> > +struct kvm_sregs2 {
> > +	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
> > +	struct kvm_segment cs, ds, es, fs, gs, ss;
> > +	struct kvm_segment tr, ldt;
> > +	struct kvm_dtable gdt, idt;
> > +	__u64 cr0, cr2, cr3, cr4, cr8;
> > +	__u64 efer;
> > +	__u64 apic_base;
> > +	__u64 flags; /* must be zero*/
> 
> I think it would make sense to define a flag bit for the PDPTRs, so that 
> userspace can use KVM_SET_SREGS2 unconditionally (e.g. even when 
> migrating from a source that uses KVM_GET_SREGS and therefore doesn't 
> provide the PDPTRs).
Yes, I didn't think about this case! I'll add this to the next version.
Thanks!

> 
> > +	__u64 pdptrs[4];
> > +	__u64 padding;
> 
> No need to add padding; if we add more fields in the future we can use 
> the flags to determine the length of the userspace data, similar to 
> KVM_GET/SET_NESTED_STATE.
Got it, will fix. I added it just in case.

> 
> 
> > +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +	if (is_pae_paging(vcpu)) {
> > +		for (i = 0 ; i < 4 ; i++)
> > +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
> > +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > +		mmu_reset_needed = 1;
> > +	}
> > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +
> 
> SRCU should not be needed here?

I haven't yet studied in depth the locking that is used in the kvm,
so I put this to be on the safe side.

I looked at it a bit and it looks like the pdptr reading code takes
this lock because it accesses the memslots, which is not done here,
and therefore the lock is indeed not needed here.

I need to study in depth how locking is done in kvm to be 100% sure
about this.


> 
> > +	case KVM_GET_SREGS2: {
> > +		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL_ACCOUNT);
> > +		r = -ENOMEM;
> > +		if (!u.sregs2)
> > +			goto out;
> 
> No need to account, I think it's a little slower and this allocation is 
> very short lived.
Right, I will fix this in the next version.

> 
> >  #define KVM_CAP_PPC_DAWR1 194
> > +#define KVM_CAP_SREGS2 196
> 
> 195, not 196.

I am also planning to add KVM_CAP_SET_GUEST_DEBUG2 for which I
used 195.
Prior to sending I rebased all of my patch series on top of kvm/queue,
but I kept the numbers just in case.

> 
> >  #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
> >  #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
> > +
> > +#define KVM_GET_SREGS2             _IOR(KVMIO,  0xca, struct kvm_sregs2)
> > +#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcb, struct kvm_sregs2)
> > +
> 
> It's not exactly overlapping, but please bump the ioctls to 0xcc/0xcd.
Will do.


Thanks a lot for the review!

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


