Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448DC36B3A2
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhDZM5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 08:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233043AbhDZM5N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 08:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619441791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7WbGpQEfdHQcLE/c3T851i5jSAp/KQCYtdsdEt8dGk=;
        b=OIA9k1orkyt2BhV/Ez0IeIX/a/vLIVOFGk7sJCMtsgwdWYGQjyYNPUifTJJ6qtrDMM7KR3
        Q/2i0b4zbzgJBrLYGAqFViutCWNe6u7iBLfgdUdB0LffmzBEN66rE4bUXLezUzPiYjaUVL
        rMbN99L8V4kVrJJ4zzR03hpanuThn3A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-8QxEabdQO0m-iOpvEz5_gw-1; Mon, 26 Apr 2021 08:56:27 -0400
X-MC-Unique: 8QxEabdQO0m-iOpvEz5_gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F9A0107ACCD;
        Mon, 26 Apr 2021 12:56:24 +0000 (UTC)
Received: from starship (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D08199F64;
        Mon, 26 Apr 2021 12:56:16 +0000 (UTC)
Message-ID: <eeaa6c0f6efef926eb606b354052aba8cfef2c21.camel@redhat.com>
Subject: Re: [PATCH v2 4/6] KVM: x86: Introduce KVM_GET_SREGS2 /
 KVM_SET_SREGS2
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Mon, 26 Apr 2021 15:56:15 +0300
In-Reply-To: <898a9b18-4578-cb9d-ece7-f45ba5b7bb89@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
         <20210426111333.967729-5-mlevitsk@redhat.com>
         <898a9b18-4578-cb9d-ece7-f45ba5b7bb89@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-26 at 14:32 +0200, Paolo Bonzini wrote:
> On 26/04/21 13:13, Maxim Levitsky wrote:
> > +	if (sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID) {
> > +
> > +		if (!is_pae_paging(vcpu))
> > +			return -EINVAL;
> > +
> > +		for (i = 0 ; i < 4 ; i++)
> > +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
> > +
> > +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > +		mmu_reset_needed = 1;
> > +	}
> 
> I think this should also have
> 
> 	else {
> 		if (is_pae_paging(vcpu))
> 			return -EINVAL;
> 	}


What about the case when we migrate from qemu that doesn't use
this ioctl to qemu that does? 

In this case assuming that the new qemu does use SREGS2 ioctls,
the PDPTR data will not be present
in the migration stream and thus qemu will call this ioctl without this flag
set.

I think I should in this case load the pdptrs from memory,
Or I should make qemu not use this ioctl in this.
What do you prefer?

Thanks for pointing this bug out though!
I haven't thought about this case well enough.

Best regards,
	Maxim Levitsky

> 
> but perhaps even better, check it at the beginning:
> 
> 	if ((sregs->cr4 & X86_CR4_PAE) &&
>              !!(sregs->efer & EFER_LMA) == !!(sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID))
> 		return -EINVAL;
> 
> which technically means the flag is redundant, but there is some value in
> having the flag and not allowing the user to shoot itself in the foot.
> 
> Paolo
> 


