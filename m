Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8971ECCFF
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFCJyf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 05:54:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33114 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCJyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 05:54:33 -0400
Received: from zn.tnic (p200300ec2f0b2300d541c55e36baf562.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2300:d541:c55e:36ba:f562])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 66CAB1EC02CF;
        Wed,  3 Jun 2020 11:54:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591178071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bSC5v9pq6HGi+3XtTAaeKewohWX8QeHbDID0hOwG0pY=;
        b=pUCWTJtRDBixL1/rL2J71p2JHm64P1CBHO/NNH00XF5+OWmSZlJj9GLIdiFdwhbHnX2pZo
        bXBLABD3QW9lvT9++tK9YYmUj+a23sMwG/rk+KEtxVIZE6lh+Eg+hw94jVOfh1CpdIWyzO
        9QBaI53KU5J74sP9JTJoBhekViVGObE=
Date:   Wed, 3 Jun 2020 11:54:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 73/75] x86/sev-es: Support CPU offline/online
Message-ID: <20200603095426.GA19711@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-74-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-74-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:23PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Add a play_dead handler when running under SEV-ES. This is needed
> because the hypervisor can't deliver an SIPI request to restart the AP.
> Instead the kernel has to issue a VMGEXIT to halt the VCPU. When the
> hypervisor would deliver and SIPI is wakes up the VCPU instead.

That last sentence needs fixing.

Also, that explanation belongs as comment over sev_es_ap_hlt_loop()
because commit messages are not that easy to find.

> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/uapi/asm/svm.h |  1 +
>  arch/x86/kernel/sev-es.c        | 58 +++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index a19ce9681ec2..20a05839dd9a 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -84,6 +84,7 @@
>  /* SEV-ES software-defined VMGEXIT events */
>  #define SVM_VMGEXIT_MMIO_READ			0x80000001
>  #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
> +#define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>  #define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
>  #define		SVM_VMGEXIT_GET_AP_JUMP_TABLE			1
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 28725c38e6fb..00a5d0483730 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -32,6 +32,8 @@
>  #include <asm/processor.h>
>  #include <asm/traps.h>
>  #include <asm/svm.h>
> +#include <asm/smp.h>
> +#include <asm/cpu.h>
>  
>  #define DR7_RESET_VALUE        0x400
>  
> @@ -448,6 +450,60 @@ static bool __init sev_es_setup_ghcb(void)
>  	return true;
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static void sev_es_ap_hlt_loop(void)
> +{
> +	struct ghcb_state state;
> +	struct ghcb *ghcb;
> +
> +	ghcb = sev_es_get_ghcb(&state);
> +
> +	while (true) {
> +		vc_ghcb_invalidate(ghcb);
> +		ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_HLT_LOOP);
> +		ghcb_set_sw_exit_info_1(ghcb, 0);
> +		ghcb_set_sw_exit_info_2(ghcb, 0);
> +
> +		sev_es_wr_ghcb_msr(__pa(ghcb));
> +		VMGEXIT();
> +
> +		/* Wakup Signal? */

		  "Wakeup"

> +		if (ghcb_is_valid_sw_exit_info_2(ghcb) &&
> +		    ghcb->save.sw_exit_info_2 != 0)

No need for the "!= 0".

> +			break;
> +	}
> +
> +	sev_es_put_ghcb(&state);
> +}

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
