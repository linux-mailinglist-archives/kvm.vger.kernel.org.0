Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E740846EA8C
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbhLIPHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:07:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239135AbhLIPHh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639062243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SVG9ZuQN3oM9T8PEcqFpCVIPxpnKX10T1W9r1ZDvJg=;
        b=ixyOzw+EQRGkYcOzJ8DZXyO6LSN7aOC4JqNUTvr8SXhLfqdxkM8f6zTs7YA5XZxi/qa1Qh
        n04qTJoB25lD2rbd4vdTnFovWbWS6yL7DLq82TX7R75LTYrpbsLG0+/J91Gl2WvPASsgvH
        EiNdvOIelDemU0vIvr0K1sHBZEVnhqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-429-yOzjxFo4Pumpfs4QagQqRw-1; Thu, 09 Dec 2021 10:04:00 -0500
X-MC-Unique: yOzjxFo4Pumpfs4QagQqRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D40EB1B18BD3;
        Thu,  9 Dec 2021 15:03:55 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46EA71ABE5;
        Thu,  9 Dec 2021 15:03:49 +0000 (UTC)
Message-ID: <be325dd1fbbf9023fb6ce3ceebf0418f631d43c1.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: x86: never clear irr_pending in
 kvm_apic_update_apicv
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 09 Dec 2021 17:03:48 +0200
In-Reply-To: <350532d2-b01b-1d7c-fff3-c3cb171996e8@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
         <20211209115440.394441-6-mlevitsk@redhat.com>
         <350532d2-b01b-1d7c-fff3-c3cb171996e8@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 15:12 +0100, Paolo Bonzini wrote:
> On 12/9/21 12:54, Maxim Levitsky wrote:
> > Also reorder call to kvm_apic_update_apicv to be after
> > .refresh_apicv_exec_ctrl, although that doesn't guarantee
> > that it will see up to date IRR bits.
> 
> Can you spell out why do that?


Here is what I seen happening during kvm_vcpu_update_apicv when we about to disable AVIC:

1. we call kvm_apic_update_apicv which sets irr_pending == false,
because there is nothing in IRR yet.

2. we call kvm_x86_refresh_apicv_exec_ctrl which disables AVIC

If IPI arrives in between 1 and 2, the IRR bits are set, and legit there
is no VMexit happening so no chance of irr_pending to be set to true.


This is why I reordered those calls and added a memory barrier between them
(but I didn't post it in the series)

However I then found out that even with incomplete IPI handler setting irr_pending,
I can here observe irr_pending = true but no bits in IRR so the kvm_apic_update_apicv
would reset it. I expected VM exit to be write barrier but it seems that it isn't.

However I ended up fixing the incomplete IPI handler to just always 
	- set irr_pending
	- raise KVM_REQ_EVENT
	- kick the vcpu

Because kicking a sleeping vCPU is just waking it up,
and otherwise vcpu kick only sends IPI when the target vCPU
is in guest mode anyway.

That I think ensures for good that interrupt will be processed by
this vCPU regardless of order of these calls, and barrier between them.

The only thing I kept is that make kvm_apic_update_apicv never clear
irr_pending to make sure it doesn't reset it if it sees the writes out of order.

Later the KVM_REQ_EVENT should see writes in order because kvm_make_request
includes a write barrier, and the kick should ensure that the vCPU will
process that request.

So in summary this reorder is not needed anymore but it seems more logical
to scan IRR after we disable AVIC.
Or on the second though I think we should drop the IRR scan from here at all,
now that the callers do vcpu kicks.

Best regards,
	Maxim Levitsky





> 
> Paolo
> 


