Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9352387713
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 13:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348713AbhERLGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 07:06:42 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59532 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240967AbhERLGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 07:06:41 -0400
Received: from zn.tnic (p200300ec2f0ae20067192df7af4aebb0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:e200:6719:2df7:af4a:ebb0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 81FF21EC01B5;
        Tue, 18 May 2021 13:05:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621335922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gdxGP7/Vk4cUqL8Z/IxAt3+osLGMM4MrqKhV3cFi4s=;
        b=ozzlQ20N+gWKTil6GobhZrYREVJLkrPJZUtsS0XKOt61g1HvQr3xQnPva/niU88bURJn1z
        1z4B2skjmlqkuxijpUwGBexpWeCzNbfzNUPWO+WgaNfYM1omMH3306Dp1q6dGH+jsluI16
        3pzYSfWLy2l2bcg4RT8l0XkjQS03a5E=
Date:   Tue, 18 May 2021 13:05:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 07/20] x86/sev: Define error codes for
 reason set 1.
Message-ID: <YKOfbHdUXKh1lWM6@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-8-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210430121616.2295-8-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:03AM -0500, Brijesh Singh wrote:

> Subject: Re: [PATCH Part1 RFC v2 07/20] x86/sev: Define error codes for reason set 1.

That patch title needs to be more generic, perhaps

"...: Define the Linux-specific guest termination reasons"

> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 07b8612bf182..733fca403ae5 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -128,4 +128,9 @@ struct __packed snp_page_state_change {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/* Linux specific reason codes (used with reason set 1) */
> +#define GHCB_TERM_REGISTER		0	/* GHCB GPA registration failure */
> +#define GHCB_TERM_PSC			1	/* Page State Change faiilure */

"failure"

> +#define GHCB_TERM_PVALIDATE		2	/* Pvalidate failure */
> +
>  #endif
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 874f911837db..3f9b06a04395 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -32,7 +32,7 @@ static bool __init sev_es_check_cpu_features(void)
>  	return true;
>  }
>  
> -static void __noreturn sev_es_terminate(unsigned int reason)
> ++static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
   ^

Do you see the '+' above?

In file included from arch/x86/kernel/sev.c:462:
arch/x86/kernel/sev-shared.c:37:1: error: expected identifier or ‘(’ before ‘+’ token
   37 | +static void __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
      | ^
arch/x86/kernel/sev-shared.c: In function ‘do_vc_no_ghcb’:
arch/x86/kernel/sev-shared.c:245:2: error: implicit declaration of function ‘sev_es_terminate’; did you mean ‘seq_buf_terminate’? [-Werror=implicit-function-declaration]
  245 |  sev_es_terminate(0, GHCB_SEV_ES_REASON_GENERAL_REQUEST);
      |  ^~~~~~~~~~~~~~~~
      |  seq_buf_terminate
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:272: arch/x86/kernel/sev.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:515: arch/x86/kernel] Error 2
make: *** [Makefile:1839: arch/x86] Error 2
make: *** Waiting for unfinished jobs....

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
