Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91787E4ED7
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392836AbfJYOWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 10:22:55 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54056 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbfJYOWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 10:22:55 -0400
Received: from zn.tnic (p200300EC2F0D3C00E44239D1C9BE3FA7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:3c00:e442:39d1:c9be:3fa7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D0D9F1EC0CD7;
        Fri, 25 Oct 2019 16:22:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1572013374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iLT7/FA+jxa/DCuxDSyuhoJdyith+QPQWFGJS46avAU=;
        b=nPhjqJORT9hY9M4rCp5ditj4nlo+4eHRIuR7edUUE44I9CJLWFxn04vyjHR1iD6I14oiAj
        9bgh4p/sJX89DDRDTTzZZUxS25q3v4uQYIu6K5E6/RMeoFYUQdaNfkGdTtPr67BsIOmoyZ
        1rqrlq5iZui5ZSENyS/8pxGA1KD4Tcc=
Date:   Fri, 25 Oct 2019 16:22:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 02/16] x86/mce: WARN once if IA32_FEATURE_CONTROL MSR
 is left unlocked
Message-ID: <20191025142248.GD6483@zn.tnic>
References: <20191021234632.32363-1-sean.j.christopherson@intel.com>
 <20191021235642.418-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191021235642.418-1-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 04:56:42PM -0700, Sean Christopherson wrote:
> WARN if the IA32_FEATURE_CONTROL MSR is somehow left unlocked now that
> CPU initialization unconditionally locks the MSR.
> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/mce/intel.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
> index 88cd9598fa57..1008f14b803b 100644
> --- a/arch/x86/kernel/cpu/mce/intel.c
> +++ b/arch/x86/kernel/cpu/mce/intel.c
> @@ -117,11 +117,10 @@ static bool lmce_supported(void)
>  	 * generate a #GP fault.
>  	 */
>  	rdmsrl(MSR_IA32_FEATURE_CONTROL, tmp);
> -	if ((tmp & (FEATURE_CONTROL_LOCKED | FEATURE_CONTROL_LMCE)) ==
> -		   (FEATURE_CONTROL_LOCKED | FEATURE_CONTROL_LMCE))
> -		return true;
> +	if (WARN_ON_ONCE(!(tmp & FEATURE_CONTROL_LOCKED)))
> +		return false;
>  
> -	return false;
> +	return tmp & FEATURE_CONTROL_LMCE;
>  }
>  
>  bool mce_intel_cmci_poll(void)
> -- 

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
