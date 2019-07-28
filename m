Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B743378139
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2019 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfG1Tgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Jul 2019 15:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfG1Tgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Jul 2019 15:36:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A07785538;
        Sun, 28 Jul 2019 19:36:44 +0000 (UTC)
Received: from treble (ovpn-120-102.rdu2.redhat.com [10.10.120.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 200465D6A9;
        Sun, 28 Jul 2019 19:36:43 +0000 (UTC)
Date:   Sun, 28 Jul 2019 14:36:41 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] KVM: VMX: Add error handling to VMREAD helper
Message-ID: <20190728193641.mjxrtcc6ps72z3sp@treble>
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
 <20190719204110.18306-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190719204110.18306-4-sean.j.christopherson@intel.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Sun, 28 Jul 2019 19:36:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 19, 2019 at 01:41:08PM -0700, Sean Christopherson wrote:
> @@ -68,8 +67,22 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
>  {
>  	unsigned long value;
>  
> -	asm volatile (__ex_clear("vmread %1, %0", "%k0")
> -		      : "=r"(value) : "r"(field));
> +	asm volatile("1: vmread %2, %1\n\t"
> +		     ".byte 0x3e\n\t" /* branch taken hint */
> +		     "ja 3f\n\t"
> +		     "mov %2, %%" _ASM_ARG1 "\n\t"
> +		     "xor %%" _ASM_ARG2 ", %%" _ASM_ARG2 "\n\t"
> +		     "2: call vmread_error\n\t"
> +		     "xor %k1, %k1\n\t"
> +		     "3:\n\t"
> +
> +		     ".pushsection .fixup, \"ax\"\n\t"
> +		     "4: mov %2, %%" _ASM_ARG1 "\n\t"
> +		     "mov $1, %%" _ASM_ARG2 "\n\t"
> +		     "jmp 2b\n\t"
> +		     ".popsection\n\t"
> +		     _ASM_EXTABLE(1b, 4b)
> +		     : ASM_CALL_CONSTRAINT, "=r"(value) : "r"(field) : "cc");

Was there a reason you didn't do the asm goto thing here like you did
for the previous patch?  That seemed cleaner, and needs less asm.  

I think the branch hints aren't needed -- they're ignored on modern
processors.  Ditto for the previous patch.

Also please use named asm operands whereever you can, like "%[field]"
instead of "%2".  It helps a lot with readability.

-- 
Josh
