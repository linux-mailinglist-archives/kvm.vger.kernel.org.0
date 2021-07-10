Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF143C36C6
	for <lists+kvm@lfdr.de>; Sat, 10 Jul 2021 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhGJUe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jul 2021 16:34:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhGJUe5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Jul 2021 16:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625949131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vK/k+IFVP1J4jdM2NFzS1evc2TAHZuSfCTiZIbMJz6E=;
        b=f+Pz+jdyqAxL9ADnBRnUXyNptH3ET5V51EVxuAYadWohbiCmxEQoITGyIbYEsz8v93dko1
        N+svaWF9z9lYMIUQQnGL/TgY/lRKB7rU3pDJV6Vz+ll2VGFzmODs3dvA1rxvoI4WeyU+RD
        6LZTCmjX82jEiw0rA9WRKtLf08K1nKM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-cyJPlDdmPOqJDu5gV8BEoA-1; Sat, 10 Jul 2021 16:32:10 -0400
X-MC-Unique: cyJPlDdmPOqJDu5gV8BEoA-1
Received: by mail-ed1-f70.google.com with SMTP id x16-20020aa7d6d00000b02903a2e0d2acb7so2437442edr.16
        for <kvm@vger.kernel.org>; Sat, 10 Jul 2021 13:32:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vK/k+IFVP1J4jdM2NFzS1evc2TAHZuSfCTiZIbMJz6E=;
        b=n9Vu9jQdWqamRILDltnNyDSRv+rzE5JZ99G5jWvyWJiQjHK6XWzMKbMU930fDLsqL2
         ZliqmRQ40hBDPdnM0g0LNAKf9gqdKXdAqZSHDjCQtXGxQiB+KZQL12PllNihG67MvNLW
         97wZnPCPNGKxbbJLPRyKAnCE1QbQg5UDlZOszH2CCfI80XPF2Wlg3BITbBt+o5n2Fggm
         fOUD/3ZHtajJ/KpTxPAgGbJ6AvINCc6S+SV6ppQnzJQ5VchBd6GQB5ipA32P42uoCTef
         eVZA506CdeCKjW8Al8fFAECFpqHXg3qHeOrVvP81HyWys+XQnonqc+729vZfmeI7LFwi
         heUA==
X-Gm-Message-State: AOAM531+9pgeF1aaeaDKVQ4+P1qI650LWEdSZL/OoAk3LBwD0YOxz50X
        9674G5Fx2Wm1rS8tfMAyP2s2Hhh6DV1JzxpUzmZq4Bh/ubrsiR9M9MauHB/5bIJgAeD4Mkn4M9G
        dKhzJhGPnEEgI
X-Received: by 2002:a05:6402:510d:: with SMTP id m13mr55138853edd.179.1625949129479;
        Sat, 10 Jul 2021 13:32:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhBwV7xiuVieW6MsUcGkhFQKl8z4jMbj40gGsYJmhV/Gd78VG37WlnmLQf5XiejMjuLtS/tw==
X-Received: by 2002:a05:6402:510d:: with SMTP id m13mr55138839edd.179.1625949129363;
        Sat, 10 Jul 2021 13:32:09 -0700 (PDT)
Received: from redhat.com ([2.55.136.76])
        by smtp.gmail.com with ESMTPSA id jg9sm2390624ejc.6.2021.07.10.13.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 13:32:08 -0700 (PDT)
Date:   Sat, 10 Jul 2021 16:32:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 1/6] linux-header: add the SNP specific command
Message-ID: <20210710163148-mutt-send-email-mst@kernel.org>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-2-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709215550.32496-2-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 04:55:45PM -0500, Brijesh Singh wrote:
> Sync the kvm.h with the kernel to include the SNP specific commands.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Pls specify which kernel version you used for the sync.

> ---
>  linux-headers/linux/kvm.h | 47 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 20d6a263bb..c17ace1ece 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1679,6 +1679,12 @@ enum sev_cmd_id {
>  	/* Guest Migration Extension */
>  	KVM_SEV_SEND_CANCEL,
>  
> +	/* SNP specific commands */
> +	KVM_SEV_SNP_INIT = 256,
> +	KVM_SEV_SNP_LAUNCH_START,
> +	KVM_SEV_SNP_LAUNCH_UPDATE,
> +	KVM_SEV_SNP_LAUNCH_FINISH,
> +
>  	KVM_SEV_NR_MAX,
>  };
>  
> @@ -1775,6 +1781,47 @@ struct kvm_sev_receive_update_data {
>  	__u32 trans_len;
>  };
>  
> +struct kvm_snp_init {
> +	__u64 flags;
> +};
> +
> +struct kvm_sev_snp_launch_start {
> +	__u64 policy;
> +	__u64 ma_uaddr;
> +	__u8 ma_en;
> +	__u8 imi_en;
> +	__u8 gosvw[16];
> +};
> +
> +#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
> +#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
> +#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
> +#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
> +#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
> +#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
> +
> +struct kvm_sev_snp_launch_update {
> +	__u64 uaddr;
> +	__u32 len;
> +	__u8 imi_page;
> +	__u8 page_type;
> +	__u8 vmpl3_perms;
> +	__u8 vmpl2_perms;
> +	__u8 vmpl1_perms;
> +};
> +
> +#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
> +#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
> +#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
> +
> +struct kvm_sev_snp_launch_finish {
> +	__u64 id_block_uaddr;
> +	__u64 id_auth_uaddr;
> +	__u8 id_block_en;
> +	__u8 auth_key_en;
> +	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
> +};
> +
>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
>  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
>  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> -- 
> 2.17.1

