Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0080B453A69
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 20:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbhKPTwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 14:52:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhKPTwO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 14:52:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637092156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3b5knlYZX1AIJ216JlJ+2mMKUoVtkxyIscJTP+T4Ew=;
        b=GiJb5xRcEG16RuuUCuLiccaPeJhQU8sYFD3w0d1ogLg4eSAd5Ih5+5sYw5EiNav45IRQHr
        hbDebUQwVi6GtVzjZPLHhqojsJFUt3nyjlfZqTsScL6HbQo6nnkVYnRl+VjflwjlYKZJ5w
        3GWGdwOipqmVeXAAfKowXsHZx0I/7EM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-N8_baTvXPKWn_z9raQc8Rw-1; Tue, 16 Nov 2021 14:49:13 -0500
X-MC-Unique: N8_baTvXPKWn_z9raQc8Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D498D423B9;
        Tue, 16 Nov 2021 19:49:11 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 466F960BD8;
        Tue, 16 Nov 2021 19:49:09 +0000 (UTC)
Message-ID: <04978d6d-8e1a-404d-b30d-402a7569c1f0@redhat.com>
Date:   Tue, 16 Nov 2021 20:49:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87k0h85m65.ffs@tglx> <YZPWsICdDTZ02UDu@google.com> <87ee7g53rp.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87ee7g53rp.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 19:55, Thomas Gleixner wrote:
> We can do that, but I'm unhappy about this conditional in schedule(). So
> I was asking for doing a simple KVM only solution first:
> 
> vcpu_run()
>          kvm_load_guest_fpu()
>              wrmsrl(XFD, guest_fpstate->xfd);
>              XRSTORS
>            
>          do {
> 
>             local_irq_disable();
> 
>             if (test_thread_flag(TIF_NEED_FPU_LOAD))
> 		switch_fpu_return()
>                    wrmsrl(XFD, guest_fpstate->xfd);
> 
>             do {
>                  vmenter();              // Guest modifies XFD
>             } while (reenter);
> 
>             update_xfd_state();          // Restore consistency
> 
>             local_irq_enable();
> 
> and check how bad that is for KVM in terms of overhead on AMX systems.

I agree, this is how we handle SPEC_CTRL for example and it can be 
extended to XFD.  We should first do that, then switch to the MSR lists. 
  Hacking into schedule() should really be the last resort.

>            local_irq_enable();     <- Problem starts here
> 
>            preempt_enable();	   <- Becomes wider here

It doesn't become that much wider because there's always preempt 
notifiers.  So if it's okay to save XFD in the XSAVES wrapper and in 
kvm_arch_vcpu_put(), that might be already remove the need to do it 
schedule().

Paolo

