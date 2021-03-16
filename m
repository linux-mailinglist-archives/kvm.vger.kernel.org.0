Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC733CFEA
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhCPIcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:32:48 -0400
Received: from 8bytes.org ([81.169.241.247]:59264 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhCPIcm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:32:42 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 9DB1B2DA; Tue, 16 Mar 2021 09:32:36 +0100 (CET)
Date:   Tue, 16 Mar 2021 09:32:35 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <YFBtI55sVzIJ15U+@8bytes.org>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315221020.661693-4-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On Tue, Mar 16, 2021 at 12:10:20AM +0200, Maxim Levitsky wrote:
> -static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
> +static int (*svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {

Can you keep this const and always set the necessary handlers? If
exceptions are not intercepted they will not be used.

> @@ -333,7 +334,9 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
>  
>  	WARN_ON_ONCE(bit >= 32);
> -	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
> +
> +	if (!((1 << bit) & debug_intercept_exceptions))
> +		vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);

This will break SEV-ES guests, as those will not cause an intercept but
now start to get #VC exceptions on every other exception that is raised.
SEV-ES guests are not prepared for that and will not even boot, so
please don't enable this feature for them.

