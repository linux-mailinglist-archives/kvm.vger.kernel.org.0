Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4511246BE
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 13:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLRMYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 07:24:08 -0500
Received: from mail.skyhub.de ([5.9.137.197]:35676 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfLRMYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 07:24:08 -0500
Received: from zn.tnic (p200300EC2F0B8B004C237F05E7CC242C.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:8b00:4c23:7f05:e7cc:242c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8ABC21EC09F1;
        Wed, 18 Dec 2019 13:24:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1576671846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UiM+8XumZBdoz0qNl0ALJoBvPFnS5D4pGA0A+utY/Uw=;
        b=acpLNKNbaipKSO7XhMBc5JuHyj6nHt8dOKUivxSqkGVwoBL+kvH0mE3tlN6Sv0xJbtRf22
        gyf8pqnV+xTSS1e94qq2I/JlgDe1QOPkg+E5dpr0imr7oeHJ1YvD82t1zopFMRKTSid6bj
        W8XuEzLC2Lnd1S/IFGUdRzMY1cW8bPs=
Date:   Wed, 18 Dec 2019 13:24:00 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix out-of-bounds write in
 KVM_GET_EMULATED_CPUID (CVE-2019-19332)
Message-ID: <20191218122400.GD24886@zn.tnic>
References: <1575458412-10241-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1575458412-10241-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 12:20:12PM +0100, Paolo Bonzini wrote:
> The bounds check was present in KVM_GET_SUPPORTED_CPUID but not
> KVM_GET_EMULATED_CPUID.
> 
> Reported-by: syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com
> Fixes: 84cffe499b94 ("kvm: Emulate MOVBE", 2013-10-29)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 813a4d2e5c0c..cfafa320a8cf 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -504,7 +504,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	r = -E2BIG;
>  
> -	if (*nent >= maxnent)
> +	if (WARN_ON(*nent >= maxnent))
>  		goto out;
>  
>  	do_host_cpuid(entry, function, 0);
> @@ -815,6 +815,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
>  			 int *nent, int maxnent, unsigned int type)
>  {
> +	if (*nent >= maxnent)
> +		return -E2BIG;
> +
>  	if (type == KVM_GET_EMULATED_CPUID)
>  		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
>  
> -- 

Whoops. ;-\

Thanks for the fix Paolo!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
