Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92707402100
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 23:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhIFVIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 17:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231256AbhIFVIs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 17:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630962463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DI3KYd3Cj467udFY79GhjR176LpQbVCepUvXZINXOg=;
        b=fzeRz6fCLHrSPxd0TBz6i/onVdBxjzLVIDLwrAIZG07aa303POTovtkU3ckXg/7CHQQ2YM
        VwnCVosO4GWBp6VDFZtCJ/bwhUVtAN5rifo2jLPo2hCStdO4ePfpuNK2OKpYHZH34z86uI
        jY3AsHBNfZsmlvozXlswZdWJ9iQBfVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-6nX3R8uCMCKfx3f4Yaty5w-1; Mon, 06 Sep 2021 17:07:42 -0400
X-MC-Unique: 6nX3R8uCMCKfx3f4Yaty5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5924D8145E6;
        Mon,  6 Sep 2021 21:07:40 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E212369A;
        Mon,  6 Sep 2021 21:07:36 +0000 (UTC)
Message-ID: <e3e84acd383d4f5716745c2e513d442782b6b786.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: VMX: avoid running vmx_handle_exit_irqoff in
 case of emulation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Date:   Tue, 07 Sep 2021 00:07:35 +0300
In-Reply-To: <a642cc28-272b-9a1f-51bb-657416e588d0@redhat.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
         <20210826095750.1650467-2-mlevitsk@redhat.com>
         <YSe6wphK9b8KSkXW@google.com>
         <a642cc28-272b-9a1f-51bb-657416e588d0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-06 at 12:09 +0200, Paolo Bonzini wrote:
> On 26/08/21 18:01, Sean Christopherson wrote:
> > > +	if (vmx->emulation_required)
> > > +		return;
> > Rather than play whack-a-mole with flows consuming stale state, I'd much prefer
> > to synthesize a VM-Exit(INVALID_GUEST_STATE).  Alternatively, just skip ->run()
> > entirely by adding hooks in vcpu_enter_guest(), but that's a much larger change
> > and probably not worth the risk at this juncture.
> 
> I'm going with Maxim's patch for now (and for stable kernels especially)
> but I like the
> 
> 
> +       if (unlikely(static_call(kvm_x86_emulation_required)(vcpu)))
> +               return static_call(kvm_x86_emulate_invalid_guest_state)(vcpu);
> +
> 
> idea.  I'll put a Fixes for 95b5a48c4f2b ("KVM: VMX: Handle NMIs, #MCs and
> async #PFs in common irqs-disabled fn", Linux 5.3).
> 
> Paolo
> 
Note that I posted V2 of this patch series ([PATCH v2 0/6] KVM: few more SMM fixes)

There I addressed the review feedback from this patch series,
and for this particular case, I synthesized invalid VM exit as was suggested.

Best regards,
	Maxim Levitsky

