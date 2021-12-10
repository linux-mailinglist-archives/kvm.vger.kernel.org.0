Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14296470088
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbhLJMYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 07:24:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31514 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233575AbhLJMYE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 07:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639138827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N26BmA1vYVEuwqLYHjNIdZO/TeOGLhcQdBsl+AM0SLw=;
        b=Fo3N7f0jt1uDfYcf2Y7KbU06eCSB833YTcJgoJgSkVradtIU5pH0kGuFXTXe3goiFvOVns
        7255m0BwqTE3dNYqyIj0llOP+lFJBiV10A+IuCIwi7WZRvmpbv/5A0BvyjQYv5l+mXqauH
        PJT+7QC5WHBKohfcS0upG/uiROiJ5x8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-NCmuOd9LMPmQASw2Ca5UiA-1; Fri, 10 Dec 2021 07:20:22 -0500
X-MC-Unique: NCmuOd9LMPmQASw2Ca5UiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CAF01006AA0;
        Fri, 10 Dec 2021 12:20:20 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C60176B8EE;
        Fri, 10 Dec 2021 12:20:01 +0000 (UTC)
Message-ID: <fbf3e1665357d9517015ad49eee0c9825ed876d4.camel@redhat.com>
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
Date:   Fri, 10 Dec 2021 14:20:00 +0200
In-Reply-To: <636dd644-8160-645a-ce5a-f4eb344f001c@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
         <20211209115440.394441-6-mlevitsk@redhat.com>
         <636dd644-8160-645a-ce5a-f4eb344f001c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-12-10 at 13:07 +0100, Paolo Bonzini wrote:
> On 12/9/21 12:54, Maxim Levitsky wrote:
> > It is possible that during the AVIC incomplete IPI vmexit,
> > its handler will set irr_pending to true,
> > but the target vCPU will still see the IRR bit not set,
> > due to the apparent lack of memory ordering between CPU's vIRR write
> > that is supposed to happen prior to the AVIC incomplete IPI
> > vmexit and the write of the irr_pending in that handler.
> 
> Are you sure about this?  Store-to-store ordering should be 
> guaranteed---if not by the architecture---by existing memory barriers 
> between vmrun returning and avic_incomplete_ipi_interception().  For 
> example, srcu_read_lock implies an smp_mb().
> 
> Even more damning: no matter what internal black magic the processor 
> could be using to write to IRR, the processor needs to order the writes 
> against reads of IsRunning on processors without the erratum.  That 
> would be equivalent to flushing the store buffer, and it would imply 
> that the write of vIRR is ordered before the write to irr_pending.
> 
> Paolo
> 
Yes I almost 100% sure now that this patch is wrong.
the code was just seeing irr_pending true because it is set
to true while APICv/AVIC is use, and was not seeing yet the vIRR bits,
because they didn't arrive yet. This this patch isn't needed.

Thanks again for help!
I am testing your version of fixes to avic inhibition races,
and then I'll send a new version of these patches.

Best regards,
	Maxim Levitsky

