Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B283C1978
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhGHS7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 14:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhGHS7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 14:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625770596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1va5nv4AZF0iU5FnZEUJ2+LCm5h8PaUbvUsoxAiHxDY=;
        b=SnoPYTLQ2uxAUwAg0q7Z1p5+m/rGSe+DRm71vbsaEZIaRLOxwPE/ZUcnI/OdCLFmc7xjzB
        LSWieuRvIo58pZkq0aFkM23E3ArKEKZ3e9cVXL8JGp5rhd46LctdvoCaM7Bmf9Ptedcj93
        3A3KiM/FZ25MEndxO/erXVqT/a2tZbQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-zEhBfwJvPKa87DQYN4nfew-1; Thu, 08 Jul 2021 14:56:35 -0400
X-MC-Unique: zEhBfwJvPKa87DQYN4nfew-1
Received: by mail-wm1-f69.google.com with SMTP id p9-20020a7bcc890000b02902190142995dso926529wma.4
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 11:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1va5nv4AZF0iU5FnZEUJ2+LCm5h8PaUbvUsoxAiHxDY=;
        b=iutU4yJfZLVAHLyILgYtJgF42gxpq6gLLOvgRlRweSEKqguNpx6SKPFspdxvznt8gn
         hitDqnk2BTcZITqdyxhSER6C6s7MqqiqXIjFaXHk61If1gKTn4mZyEKSf8IGk/PwGejp
         D/MgRZ5/LBNTkPUHCMfaM9JXPKrNZ72AJgkTJaPnQnCOQvBBzxpejtO0Xo3d3J3m19D4
         Jk10HiWHVTts0dPC97+lcpHXfFnY4yP+3D2U8Fs+lGUB1/ZnakLcR9wf4eRrXvjrhfez
         AkCs6aENXaibd6IyaTphj29C+1kb4vYHT54f4IVUn4NohOwYpeomDCZ3aIJW7cajcijK
         jH3Q==
X-Gm-Message-State: AOAM530te0q2og2aHTJjUSWbrPcGPDPuq7bGXjbUqjvsfW0kY7G4WP+8
        0HL8EHF1gvVJeKohQCniOXcmrTMrFk6TT1qhHK/if1Vl2UJLCc6DQLJFahxHOqyizfpZfnm9VVx
        SNtR6GXcvLphM
X-Received: by 2002:a05:6000:1361:: with SMTP id q1mr35672356wrz.179.1625770594552;
        Thu, 08 Jul 2021 11:56:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhquME75eUWVHFrrZ+V9pwudJ25ehwm0sVcMEMSNcf4tH+Xhq/bHqTeFabCsx2g8CMjSfcTw==
X-Received: by 2002:a05:6000:1361:: with SMTP id q1mr35672310wrz.179.1625770594307;
        Thu, 08 Jul 2021 11:56:34 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id o11sm10760305wmc.2.2021.07.08.11.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 11:56:33 -0700 (PDT)
Date:   Thu, 8 Jul 2021 19:56:31 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 14/40] crypto:ccp: Provide APIs to issue
 SEV-SNP commands
Message-ID: <YOdKX/3cTytIiGYM@work-vm>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-15-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-15-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> Provide the APIs for the hypervisor to manage an SEV-SNP guest. The
> commands for SEV-SNP is defined in the SEV-SNP firmware specification.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 24 ++++++++++++
>  include/linux/psp-sev.h      | 74 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 98 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 84c91bab00bd..ad9a0c8111e0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1017,6 +1017,30 @@ int sev_guest_df_flush(int *error)
>  }
>  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>  
> +int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error)
> +{
> +	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_decommission);
> +
> +int snp_guest_df_flush(int *error)
> +{
> +	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_df_flush);
> +
> +int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
> +{
> +	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
> +
> +int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
> +{
> +	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error);
> +}
> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
> +
>  static void sev_exit(struct kref *ref)
>  {
>  	misc_deregister(&misc_dev->misc);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 1b53e8782250..63ef766cbd7a 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -860,6 +860,65 @@ int sev_guest_df_flush(int *error);
>   */
>  int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>  
> +/**
> + * snp_guest_df_flush - perform SNP DF_FLUSH command
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV

Weird wording.

> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_df_flush(int *error);
> +
> +/**
> + * snp_guest_decommission - perform SNP_DECOMMISSION command
> + *
> + * @decommission: sev_data_decommission structure to be processed
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_decommission(struct sev_data_snp_decommission *data, int *error);
> +
> +/**
> + * snp_guest_page_reclaim - perform SNP_PAGE_RECLAIM command
> + *
> + * @decommission: sev_snp_page_reclaim structure to be processed
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
> +
> +/**
> + * snp_guest_dbg_decrypt - perform SEV SNP_DBG_DECRYPT command
> + *
> + * @sev_ret: sev command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + */
> +int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
> +
> +
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
> @@ -887,6 +946,21 @@ sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int
>  
>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
>  
> +static inline int
> +snp_guest_decommission(struct sev_data_snp_decommission *data, int *error) { return -ENODEV; }
> +
> +static inline int snp_guest_df_flush(int *error) { return -ENODEV; }
> +
> +static inline int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
> +{
> +	return -ENODEV;
> +}
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

