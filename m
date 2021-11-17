Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095114541FA
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhKQHmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:42:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231718AbhKQHme (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 02:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637134776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBqSeQqOmjantMan273qAkC4lAER1ZmY/hfKqgf6Tb8=;
        b=HX/map3BsAcOMXeyzLD9JW7Y7HNr0WSHgvDa3EEFC/fUqU9hQ306G3FiZqzMOxd6dl/D0A
        M9X0POPkbIvgTYUyp6stMf4snUHGeRCDx2+jQE2mJkyOnwv1YZCXLiEHh4uYdxTjO4hFbc
        P6yFO9JNPF9mDTV0+qV+0ewHWd6DZME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-gXmAXYHAOqW-ffmeGtaU1Q-1; Wed, 17 Nov 2021 02:39:32 -0500
X-MC-Unique: gXmAXYHAOqW-ffmeGtaU1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C987580A5C8;
        Wed, 17 Nov 2021 07:39:30 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 569B860D30;
        Wed, 17 Nov 2021 07:39:28 +0000 (UTC)
Message-ID: <9afc4ca6-a326-79ea-cc0b-4ce0808217d2@redhat.com>
Date:   Wed, 17 Nov 2021 08:39:27 +0100
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
 <04978d6d-8e1a-404d-b30d-402a7569c1f0@redhat.com> <87zgq34z4c.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87zgq34z4c.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 21:36, Thomas Gleixner wrote:
>            local_irq_enable();     <- Problem starts here
> 
>            preempt_enable();	   <- Becomes wider here
>
>> It doesn't become that much wider because there's always preempt
>> notifiers.  So if it's okay to save XFD in the XSAVES wrapper and in
>> kvm_arch_vcpu_put(), that might be already remove the need to do it
>> schedule().
>
> Did not think about preemption notifiers. Probably because I hate
> notifiers with a passion since I had to deal with the CPU hotplug
> notifier trainwreck.
> 
> But yes that would work. So the places to do that would be:
> 
> 1) kvm_sched_out() -> kvm_arch_vcpu_put() > 2) kernel_fpu_begin_mask()

... which calls save_fpregs_to_fpstate

> 3) kvm_put_guest_fpu()

... which calls save_fpregs_to_fpstate via fpu_swap_kvm_fpstate

So perhaps it could be done in save_fpregs_to_fpstate (for the sched out 
path, it would be called by switch_fpu_prepare()).  But for now I would 
also start with the trivial version.

> I'd be really surprised if that RDMSR is truly noticeable within all the
> other crud this path is doing.

I agree.

Paolo

