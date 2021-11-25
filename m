Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D47D45E202
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 22:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357219AbhKYVQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 16:16:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54874 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357074AbhKYVO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 16:14:57 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637874704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ei6BbjfXmiegGIxn055IaCo1HunjXkDEFUAK/rZBh+s=;
        b=qmRj7ZHqJt9kjsiKoHAU2q7qkuyptXUW9/viq1tuDnZ+OLsMtLYos2M7ykQ+F1F1BvMxsz
        sBxVHNj2Q6GXMnsXvG+M5EmjHTmyHXhJ2HexnNaVejA1HBw2nKsUrU1j8UUHs2FsuO1l5B
        9QqOcRmP0BRZHzlwxHOAhF1kw37y9kWjdrhtebllpV4bWbDMzsMJ/MLPdtrovX6Bky305D
        Bm78L6y3z0/0VfKBoqfCGuk1j6TxSDyd8XPrsxYNgqYO98MDMNCXGyVY3APBhGoK0o7DQK
        t5VuNtoaC1JIyQbq1b5ANQD+9rChs3b8ZtX94zIJW8wa+iOIFI/uasB+Q+t/OA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637874704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ei6BbjfXmiegGIxn055IaCo1HunjXkDEFUAK/rZBh+s=;
        b=+LWDPfJHUUZ+SyomF1JSF094i7WZfugEzLom/j2USfZswmkfp222rQU/Ued8bCkGYAzPOO
        TM2sq8EqRe7fyXDQ==
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 26/59] KVM: x86: Introduce vm_teardown() hook in
 kvm_arch_vm_destroy()
In-Reply-To: <21e8d65c-62bd-b410-1260-1ff4b0e0c251@redhat.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com>
 <87a6hsj9wd.ffs@tglx> <21e8d65c-62bd-b410-1260-1ff4b0e0c251@redhat.com>
Date:   Thu, 25 Nov 2021 22:11:43 +0100
Message-ID: <8735nkhre8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25 2021 at 21:54, Paolo Bonzini wrote:
> On 11/25/21 20:46, Thomas Gleixner wrote:
>> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>>> Add a second kvm_x86_ops hook in kvm_arch_vm_destroy() to support TDX's
>>> destruction path, which needs to first put the VM into a teardown state,
>>> then free per-vCPU resource, and finally free per-VM resources.
>>>
>>> Note, this knowingly creates a discrepancy in nomenclature for SVM as
>>> svm_vm_teardown() invokes avic_vm_destroy() and sev_vm_destroy().
>>> Moving the now-misnamed functions or renaming them is left to a future
>>> patch so as not to introduce a functional change for SVM.
>> That's just the wrong way around. Fixup SVM first and then add the TDX
>> muck on top. Stop this 'left to a future patch' nonsense. I know for
>> sure that those future patches never materialize.
>
> Or just keep vm_destroy for the "early" destruction, and give a new name 
> to the new hook.  It is used to give back the TDCS memory, so perhaps 
> you can call it vm_free?

Up to you, but the current approach is bogus. I rather go for a fully
symmetric interface and let the various incarnations opt in at the right
place. Similar to what cpu hotplug states are implementing.

Thanks,

        tglx
