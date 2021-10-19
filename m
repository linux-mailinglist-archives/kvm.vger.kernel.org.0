Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E7433E2F
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 20:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhJSSNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 14:13:24 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44296 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234612AbhJSSNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 14:13:23 -0400
Received: from zn.tnic (p200300ec2f12f6007cf8d292d882f8b4.dip0.t-ipconnect.de [IPv6:2003:ec:2f12:f600:7cf8:d292:d882:f8b4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A58C1EC0390;
        Tue, 19 Oct 2021 20:11:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634667069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=VeYFXiKRU6zthsEyjtHIaMuVBQK6HWDRXfjT6cSuONM=;
        b=aQq2YBYG+KONTERCsktBz7RUzw2uZT74OEpi8RKTwCrDVlGBDcq92vx7T9pwFRjUCj0uIJ
        zqisG/wqb7OgaCLHPDsB8uy/XiLGPiTHI+OLm7a7AbpUFH9UroS8Xd3qr25l8IEr6Ncgvl
        EIVboy3zNnxhG3SKdxxcynAUdlTh2EE=
Date:   Tue, 19 Oct 2021 20:11:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [patch V2 23/30] x86/fpu: Move fpregs_restore_userregs() to core
Message-ID: <YW8KO9sfDeB72yUd@zn.tnic>
References: <20211015011411.304289784@linutronix.de>
 <20211015011539.686806639@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211015011539.686806639@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 03:16:30AM +0200, Thomas Gleixner wrote:
> +static inline void fpregs_deactivate(struct fpu *fpu)
> +{
> +	__this_cpu_write(fpu_fpregs_owner_ctx, NULL);
> +	trace_x86_fpu_regs_deactivated(fpu);
> +}
> +
> +static inline void fpregs_activate(struct fpu *fpu)
> +{
> +	__this_cpu_write(fpu_fpregs_owner_ctx, fpu);
> +	trace_x86_fpu_regs_activated(fpu);

You're silently changing here the percpu writes to the __ variants and
AFAICT, there's no difference on x86:

# arch/x86/kernel/fpu/context.h:50: 	this_cpu_write(fpu_fpregs_owner_ctx, fpu);
#APP
# 50 "arch/x86/kernel/fpu/context.h" 1
	movq %rsi, %gs:fpu_fpregs_owner_ctx(%rip)	# fpu, fpu_fpregs_owner_ctx
# 0 "" 2

VS

# arch/x86/kernel/fpu/context.h:50: 	__this_cpu_write(fpu_fpregs_owner_ctx, fpu);
#APP
# 50 "arch/x86/kernel/fpu/context.h" 1
	movq %rsi, %gs:fpu_fpregs_owner_ctx(%rip)	# fpu, fpu_fpregs_owner_ctx
# 0 "" 2

except maybe the __ variant doesn't use the "volatile" inline asm
qualifier in the lower-level raw_cpu_write_8() vs this_cpu_write_8().
And there's the preemption check, ofc.

Or maybe this could have something to do with RT...?

Commit message could mention this change, though.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
