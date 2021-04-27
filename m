Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CE636C558
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhD0Lja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235705AbhD0Lja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 07:39:30 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036D6C061574;
        Tue, 27 Apr 2021 04:38:47 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c5e008a7c4c8941e22261.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:5e00:8a7c:4c89:41e2:2261])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A0041EC047E;
        Tue, 27 Apr 2021 13:38:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619523525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IAUQH8ckRL8RHgSocw7BeJrBQn+eUtnbT2dDn+igxMs=;
        b=JVTU+70sWvRTU+SopM0YlyyGOmgJ6g6s0pfWanKmCpWILaUWfjQC0nNpvbpkUqfQ2RRum2
        FEuSSKX1W3ssLIne23n7/XG++M6Vrmnc4wwpffOGYr4mLk1KAEn2IFh+WRvL4uHH763Ts1
        j21Ra3QsjV66hv690SzIZHGqkUij9BY=
Date:   Tue, 27 Apr 2021 13:38:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 8/9] KVM: x86: add force_intercept_exceptions_mask
Message-ID: <YIf3wM1+enU1U/gn@zn.tnic>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
 <20210401135451.1004564-9-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210401135451.1004564-9-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021 at 04:54:50PM +0300, Maxim Levitsky wrote:
> This parameter will be used by VMX and SVM code to force
> interception of a set of exceptions, given by a bitmask
> for guest debug and/or kvm debug.
> 
> This option is not intended for production.
> 
> This is based on an idea first shown here:
> https://patchwork.kernel.org/project/kvm/patch/20160301192822.GD22677@pd.tnic/
> 
> CC: Borislav Petkov <bp@suse.de>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  arch/x86/kvm/x86.h | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3627ce8fe5bb..1a51031d64d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -176,6 +176,9 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +uint force_intercept_exceptions_mask;
> +module_param(force_intercept_exceptions_mask, uint, S_IRUGO | S_IWUSR);
> +EXPORT_SYMBOL_GPL(force_intercept_exceptions_mask);

That's nice.

I could use some text explaning the usage though, i.e. that thing takes
a bitfield of exception vectors, so that I don't have to look at the
code each time. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
