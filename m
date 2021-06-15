Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504CA3A7D09
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 13:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFOLZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 07:25:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229909AbhFOLZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 07:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623756206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6zIhA2yJuykBLTAxFpo5bYvmvbrLn/gng5f4bN7IW1A=;
        b=BX06zhZORedZP42ZDuzZIPQ3o42HlTgLfk88W6pyWs1moViIAj32o+3cJjltYtsmaCTOMy
        v7y6sEDtR2TCNlAd1tS7+B04V3pFoUexuJby1yqDuMXdcAekA0rUHzq1l+zFHVOHzn3S9y
        a50HxzcBQFv60ipxPfTUEMqqBeS8Cgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-pXEN-AimNDuyli6m1JxVag-1; Tue, 15 Jun 2021 07:23:25 -0400
X-MC-Unique: pXEN-AimNDuyli6m1JxVag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C0C9107ACF6;
        Tue, 15 Jun 2021 11:23:22 +0000 (UTC)
Received: from work-vm (ovpn-112-179.ams2.redhat.com [10.36.112.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0E301001B2C;
        Tue, 15 Jun 2021 11:23:10 +0000 (UTC)
Date:   Tue, 15 Jun 2021 12:23:08 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH Part2 RFC v3 14/37] crypto:ccp: Provide APIs to issue
 SEV-SNP commands
Message-ID: <YMiNnN99PuAKbplA@work-vm>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
 <20210602141057.27107-15-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602141057.27107-15-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> index b225face37b1..def2996111db 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1014,6 +1014,30 @@ int sev_guest_df_flush(int *error)
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

sev not supporting SEV? Is that actually 'sev does not support SNP'?

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

