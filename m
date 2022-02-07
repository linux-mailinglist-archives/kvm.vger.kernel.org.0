Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9C14ACBC1
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiBGWD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242008AbiBGWD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:03:57 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD2C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:03:57 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so14461740pfe.4
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UPy7lygPxr90ipECLkuZI1hGfjCl5QQ8FuHy0YowhSc=;
        b=RCgXhswVoMfKJgmEInLACfKtrGVLqOCKWZNQ41sxN5QDiS7VwL/G07y2oU0WB8ztNR
         Y0S/kH1ShxVpYYabvAnlMUsDkJFODoyyY5dzhb1Fd7mnBLqXM9Rec01w4aj7PGNdeL5n
         RWuK3IpF25Z9D8lhRsyEZAKgCsMiGAZNHpKo086hki4ByVDihSrUinUl2fJl0XC9tujL
         PNBkTL6RuaWSjX1S5vLoYvoof4pfeRaDyEpdC+mVVVIu7XPHvEn4en4/Y4pIL4hV6rr1
         Cdy78LZyRztbpdzjvMGH8T8h9AbVd0QzBozwz2j0qazz4F8EmAc5xBhZNFYgkPpM1Tn/
         gMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UPy7lygPxr90ipECLkuZI1hGfjCl5QQ8FuHy0YowhSc=;
        b=6H1usTj2zFk0SFDvNeTGFUdAK+W+Mz9aDaU1QrgTcbC0rdTwY3KGiRhlvgPngOiewF
         BVBQTsWZzkeJoJm6/EaeIsBCPjTzLDHm1qOZoIziE5wbm2prtLBO3aJYDuhNb/DpSR9G
         PRHURj+w3vD0+S8d3NWAUrHZF6We5QH2mSe1c9VLsQLZHy8HS07Ht+SlRdsbzU2XeDqI
         o6omnP++Y2Hf8OTmBLYYbHfraLkQUdC4Ow7c3dxWZv9CkdKNK3bXTnJ4xIRtqPM5ae0E
         dF6l24c/ovYCGOEBr0XJl+9t98DlTsXRzKnmStI9RZhnt2VgAIRPpPhXzbqqn6cSxPYM
         Sbxg==
X-Gm-Message-State: AOAM530XS4fyaJs+LNMvXOHFwx843a53tz7XB+3kiUm0isI1oDmeVH7C
        RIuXxSloz1xh87RhngkfBdI5ew==
X-Google-Smtp-Source: ABdhPJzbBC9XPXZx1a7sY7aumuFcnEQRXSeGjArZY3492Wqxxm+qGn6UVim4VyXN7pLekEvoM53jAg==
X-Received: by 2002:a63:2c83:: with SMTP id s125mr1103589pgs.265.1644271436434;
        Mon, 07 Feb 2022 14:03:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q2sm13779245pfj.94.2022.02.07.14.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:03:55 -0800 (PST)
Date:   Mon, 7 Feb 2022 22:03:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 04/10] x86/sev: Cache AP Jump Table Address
Message-ID: <YgGXSKAsi4aLxFMg@google.com>
References: <20220127101044.13803-1-joro@8bytes.org>
 <20220127101044.13803-5-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127101044.13803-5-joro@8bytes.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 27, 2022, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Store the physical address of the AP jump table in kernel memory so
> that it does not need to be fetched from the Hypervisor again.

This doesn't explain why the kernel would retrieve the jump table more than once,
e.g. at this point in the series, this can only ever be called once.

> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 8a4317fa699a..969ef9855bb5 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -43,6 +43,9 @@ static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>   */
>  static struct ghcb __initdata *boot_ghcb;
>  
> +/* Cached AP jump table Address */
> +static phys_addr_t jump_table_pa;
> +
>  /* #VC handler runtime per-CPU data */
>  struct sev_es_runtime_data {
>  	struct ghcb ghcb_page;
> @@ -523,12 +526,14 @@ void noinstr __sev_es_nmi_complete(void)
>  	__sev_put_ghcb(&state);
>  }
>  
> -static u64 get_jump_table_addr(void)
> +static phys_addr_t get_jump_table_addr(void)

Not new, but I believe this can be tagged __init.

>  {
>  	struct ghcb_state state;
>  	unsigned long flags;
>  	struct ghcb *ghcb;
> -	u64 ret = 0;
> +
> +	if (jump_table_pa)
> +		return jump_table_pa;
>  
>  	local_irq_save(flags);
>  
> @@ -544,39 +549,36 @@ static u64 get_jump_table_addr(void)
>  
>  	if (ghcb_sw_exit_info_1_is_valid(ghcb) &&
>  	    ghcb_sw_exit_info_2_is_valid(ghcb))
> -		ret = ghcb->save.sw_exit_info_2;
> +		jump_table_pa = (phys_addr_t)ghcb->save.sw_exit_info_2;
>  
>  	__sev_put_ghcb(&state);
>  
>  	local_irq_restore(flags);
>  
> -	return ret;
> +	return jump_table_pa;
>  }
>  
>  int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)

__init here too.

>  {
>  	u16 startup_cs, startup_ip;
> -	phys_addr_t jump_table_pa;
> -	u64 jump_table_addr;
>  	u16 __iomem *jump_table;
> +	phys_addr_t pa;
>  
> -	jump_table_addr = get_jump_table_addr();
> +	pa = get_jump_table_addr();
>  
>  	/* On UP guests there is no jump table so this is not a failure */

Does anything actually check that the jump table is valid for SMP guests?

> -	if (!jump_table_addr)
> +	if (!pa)

Using '0' for "not valid" is funky because '0' isn't technically an illegal GPA,
and because it means the address (or lack thereof) isn't cached on a single-vCPU
guest.
