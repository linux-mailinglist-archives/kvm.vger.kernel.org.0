Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E014A31DD29
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhBQQUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:20:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234015AbhBQQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 11:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613578715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSopKRjxSoVocCtQC39gpXrfRXN9hZVDEXQjfMG00wI=;
        b=PhMa8IyxVXCoomgz46TVwu+/UZGXncXqHHBNJHGGScve1x2lMysGN0FkJhKQWizk4LY5/v
        DMM7l5dqEAdUECzQOlsZasjvrlcMJ52gmUJv0eKjaIku6aY41fv8xEKudB8xn7qREnGfuE
        ISEsd5V55sVgqBcyRBscsjDKOXHTjWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-tDoSXVT9P9WbUFO6cZN0-w-1; Wed, 17 Feb 2021 11:18:33 -0500
X-MC-Unique: tDoSXVT9P9WbUFO6cZN0-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 323E5107ACE8;
        Wed, 17 Feb 2021 16:18:30 +0000 (UTC)
Received: from starship (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7982C60C6E;
        Wed, 17 Feb 2021 16:18:25 +0000 (UTC)
Message-ID: <666eb754189a380899b82e0a9798eb2560ae6972.camel@redhat.com>
Subject: Re: [PATCH 1/7] KVM: VMX: read idt_vectoring_info a bit earlier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 17 Feb 2021 18:18:24 +0200
In-Reply-To: <09de977a-0275-0f4f-cf75-f45e4b5d9ca5@redhat.com>
References: <20210217145718.1217358-1-mlevitsk@redhat.com>
         <20210217145718.1217358-2-mlevitsk@redhat.com>
         <09de977a-0275-0f4f-cf75-f45e4b5d9ca5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-02-17 at 17:06 +0100, Paolo Bonzini wrote:
> On 17/02/21 15:57, Maxim Levitsky wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b3e36dc3f164..e428d69e21c0 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6921,13 +6921,15 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
> >  		kvm_machine_check();
> >  
> > +	if (likely(!vmx->exit_reason.failed_vmentry))
> > +		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> > +
> 
> Any reason for the if?

Sean Christopherson asked me to do this to avoid updating idt_vectoring_info on failed
VM entry, to keep things as they were logically before this patch.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


