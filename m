Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4907DE5129
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505713AbfJYQ0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 12:26:51 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51640 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502714AbfJYQ0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 12:26:51 -0400
Received: from zn.tnic (p200300EC2F0D3C00114ACBE854FF623C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:3c00:114a:cbe8:54ff:623c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EC34C1EC0CE8;
        Fri, 25 Oct 2019 18:26:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572020810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QNBNQdarg0dpZLohqWeIybHPr4TLX6P1ivjz+W78+CM=;
        b=DnmXcTuGaBym1zEMBVWHXgE82fqZaXQ3+jXVHt8wA7J3TFThBKwlXqp5QfH0DkMQ32PwR9
        wvjPkZ58XyV07bBK9xoacO4x3OmtjgZ1J2GKH9abz7nBwjVWw7258/GObXS9Ow4+uuZKJ7
        c9I7hqwW0CGComP0MCM7YTa+cLO6qlY=
Date:   Fri, 25 Oct 2019 18:26:45 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/16] KVM: VMX: Drop initialization of
 IA32_FEATURE_CONTROL MSR
Message-ID: <20191025162645.GE6483@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191022000820.1854-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191022000820.1854-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:08:20PM -0700, Sean Christopherson wrote:
> +	if (WARN_ON_ONCE(!(msr & FEATURE_CONTROL_LOCKED)))
> +		return 1;
> +
> +	/* launched w/ TXT and VMX disabled */
> +	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
> +	    tboot_enabled())
> +		return 1;
> +	/* launched w/o TXT and VMX only enabled w/ TXT */
> +	if (!(msr & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX) &&
> +	    (msr & FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX) &&
> +	    !tboot_enabled()) {
> +		pr_warn("kvm: disable TXT in the BIOS or "
> +			"activate TXT before enabling KVM\n");
> +		return 1;

Might as well fix that with a cleanup patch ontop:

WARNING: quoted string split across lines
#69: FILE: arch/x86/kvm/vmx/vmx.c:2208:
+               pr_warn("kvm: disable TXT in the BIOS or "
+                       "activate TXT before enabling KVM\n");


Also in that same cleanup patch, if the order of those tests doesn't
matter, you can simplify them a bit:

	if (tboot_enabled()) {
		/* msr flag test here */

	/* tboot disabled */
	} else {
		/* other two tests here */
	}

Should make it a bit easier to parse.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
