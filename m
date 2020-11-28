Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0942C744D
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgK1Vtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731555AbgK1SAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 13:00:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3374EC0A3BE5
        for <kvm@vger.kernel.org>; Sat, 28 Nov 2020 09:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=PBguWt1KyeUPUW34Rr0HH272cAkhtdG9whTWh75suP0=; b=HHew8CRf+E//ATy5MJKi4w76kK
        PBuJpLQOjFb80bXw7gkxMKRbdTItceIDjZmCUjNf4DjnauCOB3OSDmA/J2pCDlzM2jf2hBKrOgxwg
        AIUaV05BBs9Ee95+QGpVfAUf2jDqHwmxilPT+7LpcCvLD+QYFmE3qklw6/cHxVR75vbND1WRP5j2C
        vzJFnkO160538zBMcyRwb9x7pmpgO03zcPdqD5Nj6P7W9AtqkvOw1gdCA8WiH8AIHDAO+goRCOSkq
        OUflDUWtywJnxZU+Ueh/HFkODKGWZUtn8goCiaLyPmUDJj83vyGT0yMjxj1w4MXZjVjv6tq/r3kvd
        o3ZbqU5g==;
Received: from host86-187-232-153.range86-187.btcentralplus.com ([86.187.232.153] helo=[10.220.150.73])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kj4Mr-0005rR-Rr; Sat, 28 Nov 2020 17:50:43 +0000
Date:   Sat, 28 Nov 2020 17:50:39 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <13038541-7FA9-4664-93CF-FBB5E820650C@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 November 2020 14:20:58 GMT, David Woodhouse <dwmw2@infradead=2Eorg> =
wrote:
>From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>
>For supporting Xen guests we really want to be able to use
>vmcall/vmmcall
>for hypercalls as Xen itself does=2E Reinstate the KVM_EXIT_HYPERCALL
>support that Anthony ripped out in 2007=2E
>
>Yes, we *could* make it work with KVM_EXIT_IO if we really had to, but
>that makes it guest-visible and makes it distinctly non-trivial to do
>live migration from Xen because we'd have to update the hypercall
>page(s)
>(which are at unknown locations) as well as dealing with any guest RIP
>which happens to be *in* a hypercall page at the time=2E
>
>We also actively want to *prevent* the KVM hypercalls from suddenly
>becoming available to guests which think they are Xen guests, which
>this achieves too=2E
>
>Signed-off-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>---
>Should this test work OK on AMD? I see a separate test which is
>explicitly testing VMCALL on AMD, which makes me suspect it's expected
>to work as well as VMMCALL?
>
>Do we have the test infrastructure for running 32-bit guests easily?

Would have been useful=2E=2E=2E

>+	if (is_long_mode(vcpu)) {
>+		run->hypercall=2Elongmode =3D 1;
>+		run->hypercall=2Enr =3D kvm_rax_read(vcpu);
>+		run->hypercall=2Eargs[0] =3D kvm_rdi_read(vcpu);
>+		run->hypercall=2Eargs[1] =3D kvm_rsi_read(vcpu);
>+		run->hypercall=2Eargs[2] =3D kvm_rdx_read(vcpu);
>+		run->hypercall=2Eargs[3] =3D kvm_r10_read(vcpu);
>+		run->hypercall=2Eargs[4] =3D kvm_r8_read(vcpu);
>+		run->hypercall=2Eargs[5] =3D kvm_r9_read(vcpu);
>+		run->hypercall=2Eret =3D -KVM_ENOSYS;
>+	} else {
>+		run->hypercall=2Elongmode =3D 0;
>+		run->hypercall=2Enr =3D (u32)kvm_rbx_read(vcpu);

That one should be RAX=2E I'll fix it in v2 assuming the rest passes muste=
r=2E=2E=2E


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
