Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA901F46D7
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgFITKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 15:10:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60753 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730378AbgFITKo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 15:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591729842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hBBU/cx0qFeKPnx6mEnm0CnDpJpzp+VAeEZG8eQTZgs=;
        b=Guu4606152iTgkjL9tDcMpA5f/wT3KDYoP9qRa1T4+nh/EftKEvVnRLTB7T+CRdptufWev
        PXdX29C24FGEyZ3U1ziSUveOO7vkbaeOXDCEdGR3aRBR4F6JwYI8yaGTh3F+aENmnT2qsD
        rZ9PNdBl7m1lseNimwe0NBldQnabkEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-Qorq3XnkOrCWUZTPGOjXTg-1; Tue, 09 Jun 2020 15:10:41 -0400
X-MC-Unique: Qorq3XnkOrCWUZTPGOjXTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3008C835B52;
        Tue,  9 Jun 2020 19:10:39 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-136.rdu2.redhat.com [10.10.115.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3A985C1D6;
        Tue,  9 Jun 2020 19:10:35 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 225602205BD; Tue,  9 Jun 2020 15:10:35 -0400 (EDT)
Date:   Tue, 9 Jun 2020 15:10:35 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/10] KVM: x86: interrupt based APF 'page ready'
 event delivery
Message-ID: <20200609191035.GA223235@redhat.com>
References: <20200525144125.143875-1-vkuznets@redhat.com>
 <20200525144125.143875-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525144125.143875-6-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:41:20PM +0200, Vitaly Kuznetsov wrote:
[..]
>  void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  				 struct kvm_async_pf *work)
>  {
> -	struct x86_exception fault;
> +	struct kvm_lapic_irq irq = {
> +		.delivery_mode = APIC_DM_FIXED,
> +		.vector = vcpu->arch.apf.vec
> +	};
>  
>  	if (work->wakeup_all)
>  		work->arch.token = ~0; /* broadcast wakeup */
> @@ -10444,26 +10491,20 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
>  	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>  
> -	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
> -	    !apf_put_user_ready(vcpu, work->arch.token)) {
> -			fault.vector = PF_VECTOR;
> -			fault.error_code_valid = true;
> -			fault.error_code = 0;
> -			fault.nested_page_fault = false;
> -			fault.address = work->arch.token;
> -			fault.async_page_fault = true;
> -			kvm_inject_page_fault(vcpu, &fault);
> -	}
> +	if (kvm_pv_async_pf_enabled(vcpu) &&
> +	    !apf_put_user_ready(vcpu, work->arch.token))
> +		kvm_apic_set_irq(vcpu, &irq, NULL);
> +

Hi Vitaly,

Have a question about page ready events. 

Now we deliver PAGE_NOT_PRESENT page faults only if guest is not in
kernel mode. So say kernel tried to access a page and we halted cpu.
When page is available, we will inject page_ready interrupt. At
that time we don't seem to check whether page_not_present was injected
or not. 

IOW, we seem to deliver page_ready irrespective of the fact whether
PAGE_NOT_PRESENT was delivered or not. And that means we will be
sending page present tokens to guest. Guest will not have a state
associated with that token and think that page_not_present has
not been delivered yet and allocate an element in hash table for
future page_not_present event. And that will lead to memory leak
and token conflict etc.

While setting up async pf, should we keep track whether associated
page_not_present was delivered to guest or not and deliver page_ready
accordingly.

Thanks
Vivek

