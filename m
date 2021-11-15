Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B67452404
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 02:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349549AbhKPBfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 20:35:47 -0500
Received: from mail.skyhub.de ([5.9.137.197]:45462 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242340AbhKOSrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 13:47:20 -0500
Received: from zn.tnic (p200300ec2f0b5600329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:5600:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 786911EC0298;
        Mon, 15 Nov 2021 19:44:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1637001857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dw18rrJWiFMio+f81TkozWlG8A/iKVxyS5zqokyoOIY=;
        b=Dd/Fwrtnl1uGZiaWkMGZr+MuIA+r4cXwdAOsGb4gW5L9WCr54FaUiBJ6ijdhzKVchrkwr7
        H2euF1CH6Z7Kw63ePiaRIve/VdIpKgUibVEL+06FxH1ktfvFsacTnl/2rzuuM9NPWXUv9f
        gHdYxW8TqNvuMpNY3T7pHtvAcVRdXpY=
Date:   Mon, 15 Nov 2021 19:44:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 09/12] x86/sev: Use AP Jump Table blob to stop CPU
Message-ID: <YZKqfsZCxCQCyyeb@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-10-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-10-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 05:56:00PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 134a7c9d91b6..cd14b6e10f12 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,19 @@ static __always_inline void sev_es_nmi_complete(void)
>  		__sev_es_nmi_complete();
>  }
>  extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +void __sev_es_stop_this_cpu(void);
> +static __always_inline void sev_es_stop_this_cpu(void)

What's that for?

IOW, the below seems to build too:

---
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1f16fc907636..398105580862 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -87,12 +87,7 @@ extern enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 					  struct es_em_ctxt *ctxt,
 					  u64 exit_code, u64 exit_info_1,
 					  u64 exit_info_2);
-void __sev_es_stop_this_cpu(void);
-static __always_inline void sev_es_stop_this_cpu(void)
-{
-	if (static_branch_unlikely(&sev_es_enable_key))
-		__sev_es_stop_this_cpu();
-}
+void sev_es_stop_this_cpu(void);
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 39378357dc5a..7a74b3273f1a 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -694,8 +694,11 @@ void __noreturn sev_jumptable_ap_park(void)
 }
 STACK_FRAME_NON_STANDARD(sev_jumptable_ap_park);
 
-void __sev_es_stop_this_cpu(void)
+void sev_es_stop_this_cpu(void)
 {
+	if (!static_branch_unlikely(&sev_es_enable_key))
+		return;
+
 	/* Only park in the AP Jump Table when the code has been installed */
 	if (!sev_ap_jumptable_blob_installed)
 		return;

---

And as previously mentioned s/sev_es/sev/ if those are going to be used
on SNP guests too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
