Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74AB36B421
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhDZNcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:32:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233218AbhDZNcC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 09:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619443881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f3iMS4ZD9vcBcKbInQFZuGVgR0cLzV0CMjanYaop2+w=;
        b=MQ0Et86PBAvSIMUmH5juoX+T5lXBdipC62SH6mri2e0JJ9bSblLCY2B63cpG/oyrGgXgA1
        sPxGkid6zi5cJV9tddiqgbQAtC9MrK3tA1AIODDZsi+fKuk+1NBnw6jTr5lgg36aM8hoRZ
        tBNTLhDkQZxB4xqWP2XXKdgVFjCgq1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-rP8L9APNOLuq6qo9zGuhAQ-1; Mon, 26 Apr 2021 09:31:19 -0400
X-MC-Unique: rP8L9APNOLuq6qo9zGuhAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F3D8189C7;
        Mon, 26 Apr 2021 13:31:17 +0000 (UTC)
Received: from starship (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 283BC19704;
        Mon, 26 Apr 2021 13:31:12 +0000 (UTC)
Message-ID: <e887a66ea714cf244958b60e85db6f6f1336887a.camel@redhat.com>
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
Date:   Mon, 26 Apr 2021 16:31:11 +0300
In-Reply-To: <05161b6e-6d85-be14-9e30-e61cb742f6d0@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
         <20210426111333.967729-5-mlevitsk@redhat.com>
         <898a9b18-4578-cb9d-ece7-f45ba5b7bb89@redhat.com>
         <eeaa6c0f6efef926eb606b354052aba8cfef2c21.camel@redhat.com>
         <05161b6e-6d85-be14-9e30-e61cb742f6d0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-26 at 15:28 +0200, Paolo Bonzini wrote:
> On 26/04/21 14:56, Maxim Levitsky wrote:
> > On Mon, 2021-04-26 at 14:32 +0200, Paolo Bonzini wrote:
> > > On 26/04/21 13:13, Maxim Levitsky wrote:
> > > > +	if (sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID) {
> > > > +
> > > > +		if (!is_pae_paging(vcpu))
> > > > +			return -EINVAL;
> > > > +
> > > > +		for (i = 0 ; i < 4 ; i++)
> > > > +			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
> > > > +
> > > > +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
> > > > +		mmu_reset_needed = 1;
> > > > +	}
> > > 
> > > I think this should also have
> > > 
> > > 	else {
> > > 		if (is_pae_paging(vcpu))
> > > 			return -EINVAL;
> > > 	}
> > 
> > What about the case when we migrate from qemu that doesn't use
> > this ioctl to qemu that does?
> 
> Right, that makes sense but then the "else" branch should do the same as 
> KVM_SET_SREGS.  Maybe add a "load_pdptrs" bool to __set_sregs_common?

Yes, I'll do something like that.
Thanks,
	Best regards,
		Maxim Levitsky

> 
> Paolo
> 


