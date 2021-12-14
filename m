Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BE44746A9
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhLNPkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:40:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:42458 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhLNPkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 10:40:32 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639496430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JdRi1fUusSaZFU6+veHQvvEGaN/HvuhGxvZTbNDvuG4=;
        b=MUl++k5kaG2h2LSFDN8+rccLzXeFytcaY2ck/MHlQ5Hbigzt6XheeGiOqo51Vh1Cln7j3m
        PceU/CxC+6+h3sk7CkkIAVR8ay/9d9GF/ajjAmn7/jTd9Z/65XaA4FHL+0spILdCbp7+jK
        krvHNYf5b44B3fnGKrpxYW3Kcsl3+pzkzgOyz3k267iw79Pq0WsVix29YI3VaiQ9//s9X7
        Bu8cYcap1vMQqub2JHWX3ZKzORr4DMCAtEC/Ug5bB6kyDGImD8dJjWkN1RNxUbvYgvYqnF
        egJI3T44rQVMibN9ZfIF5C9xjMxfrQM40hk5ygt3hD1whkazjuAyg8ViWP+NYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639496430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JdRi1fUusSaZFU6+veHQvvEGaN/HvuhGxvZTbNDvuG4=;
        b=sbcSAwtuA+XWQOxtSMqnM/V9jjAfy8ZqBr1ulX39JijhSrSqYHAFiz47RVEMG3soLutEgA
        QyNW7R6a87NBUEBw==
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <854480525e7f4f3baeba09ec6a864b80@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com>
Date:   Tue, 14 Dec 2021 16:40:29 +0100
Message-ID: <87zgp3ry8i.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14 2021 at 15:09, Wei W. Wang wrote:
> On Tuesday, December 14, 2021 10:50 AM, Thomas Gleixner wrote:
>> + * Return: 0 on success, error code otherwise  */ int
>> +__fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0, u64
>> +xfd) {
>
> I think there would be one issue for the "host write on restore" case.
> The current QEMU based host restore uses the following sequence:
> 1) restore xsave
> 2) restore xcr0
> 3) restore XFD MSR

This needs to be fixed. Ordering clearly needs to be:

  XFD, XCR0, XSTATE

> At the time of "1) restore xsave", KVM already needs fpstate expansion
> before restoring the xsave data.

> So the 2 APIs here might not be usable for this usage.
> Our current solution to fpstate expansion at KVM_SET_XSAVE (i.e. step 1) above) is:
>
> kvm_load_guest_fpu(vcpu);
> guest_fpu->realloc_request = realloc_request;
> kvm_put_guest_fpu(vcpu);
>
> "realloc_request" above is generated from the "xstate_header" received from userspace.

That's a horrible hack. Please fix the ordering in QEMU. Trying to
accomodate for nonsensical use cases in the kernel is just wrong.

That's like you expect the following to work:

       u8 *p = mmap(NULL, 4096, ....);

       p[8192] = x;

It rightfully explodes in your face and you can keep the pieces.

Having ordering constraints vs. these 3 involved parts is just sensible.

Thanks,

        tglx
