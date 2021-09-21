Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF5A4137BC
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhIUQpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 12:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhIUQpJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 12:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632242621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0XKmgo85CaQ5nPNCDrsDHJYtPXWEiVN3sxXzT0T5OPo=;
        b=bS5g6xDJ21aj4qIcJGcjIlYsftfmNV6JXn6OLdBJB/rwny8EhoaKP1f2JRdWf+iBugy0OB
        h0w9VtI/6iV9LgOVw+CQRoWprW8fTIKAFmXLHq0wp+zaLOiO+G+SZfeW+/gJkfFWbt382Y
        bCIYdYi7HPySHS+2j0unJxOPdzWtvDU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-P-ECCtsFMWqeSvVtkS51Ww-1; Tue, 21 Sep 2021 12:43:39 -0400
X-MC-Unique: P-ECCtsFMWqeSvVtkS51Ww-1
Received: by mail-ed1-f70.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso8346130edx.2
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 09:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0XKmgo85CaQ5nPNCDrsDHJYtPXWEiVN3sxXzT0T5OPo=;
        b=2gKsNf1GIjdXCYWJYCD7MzdC0bFK28cWgESHD4ZcT2sLXLvMw1cYVSbLBmaR+oLFKJ
         7iSFU4CwRsH8QVwuoSaLuW94+Cq0d03nq8MLxbYQ3PHT3Nzb1cBi2C0l5Btkm8UPNgl0
         YbB+1jIS1L055TvMtIvI+G8GnTvwRpOxd9/i/uza2XxqpfK39O7GPxk5iFn+aEK9YUqe
         zyCimXoBRuZCvL0atlqXzCQ9emS8YzEkzsDQWQV3mKIJvfiCbVNWLMvR/sELHsO82ahD
         akjtoe7dIy2ELk6nJPp2Y/gTOOA3SxOEDMFt6D4P/1cb/zxkJqhWd1DTSBGDEg5SlRkK
         Imwg==
X-Gm-Message-State: AOAM5313swPj86rzvusjGehisgEC2X2sWFJw78eH5xbn/fe0RaYwGlC+
        vrax6cBJ1FZ4rNwaxeJBYtqzd5RHhd8aOms44puZjLS1sKrh/dVfqJzrWc+/y29Ik0d0EOpHVHz
        q+hgFPfMzgMBM
X-Received: by 2002:a17:906:a59:: with SMTP id x25mr35077161ejf.33.1632242618554;
        Tue, 21 Sep 2021 09:43:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBRVnWHiFlgZw1G2DT15iAqNLT5JXLJbHxuDrj9odvILb6hh1d0c23/5XKOYoYlyS3hMRgdQ==
X-Received: by 2002:a17:906:a59:: with SMTP id x25mr35077137ejf.33.1632242618351;
        Tue, 21 Sep 2021 09:43:38 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id e28sm8758432edc.93.2021.09.21.09.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:43:37 -0700 (PDT)
Date:   Tue, 21 Sep 2021 18:43:34 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zixuanwang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, marcorr@google.com,
        baekhw@google.com, tmroeder@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 02/17] x86 UEFI: Implement UEFI
 function calls
Message-ID: <20210921164334.zo6bbi77hbh2vdjz@gator.home>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-3-zixuanwang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827031222.2778522-3-zixuanwang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 03:12:07AM +0000, Zixuan Wang wrote:
> From: Varad Gautam <varad.gautam@suse.com>
> 
> This commit implements helper functions that call UEFI services and
> assist the boot up process.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  lib/efi.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 lib/efi.c
> 
> diff --git a/lib/efi.c b/lib/efi.c
> new file mode 100644
> index 0000000..9711354
> --- /dev/null
> +++ b/lib/efi.c
> @@ -0,0 +1,58 @@
> +#include <linux/uefi.h>

Please add at least an SPDX header.

> +
> +unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab);
> +efi_system_table_t *efi_system_table = NULL;
> +
> +static void efi_free_pool(void *ptr)
> +{
> +	efi_bs_call(free_pool, ptr);
> +}
> +
> +static efi_status_t efi_get_memory_map(struct efi_boot_memmap *map)
> +{
> +	efi_memory_desc_t *m = NULL;
> +	efi_status_t status;
> +	unsigned long key = 0, map_size = 0, desc_size = 0;
> +
> +	status = efi_bs_call(get_memory_map, &map_size,
> +			     NULL, &key, &desc_size, NULL);
> +	if (status != EFI_BUFFER_TOO_SMALL || map_size == 0)
> +		goto out;
> +
> +	/* Pad map_size with additional descriptors so we don't need to
> +	 * retry. */

nit: please use Linux comment style

> +	map_size += 4 * desc_size;
> +	*map->buff_size = map_size;
> +	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
> +			     map_size, (void **)&m);
> +	if (status != EFI_SUCCESS)
> +		goto out;
> +
> +	/* Get the map. */
> +	status = efi_bs_call(get_memory_map, &map_size,
> +			     m, &key, &desc_size, NULL);
> +	if (status != EFI_SUCCESS) {
> +		efi_free_pool(m);
> +		goto out;
> +	}
> +
> +	*map->desc_size = desc_size;
> +	*map->map_size = map_size;
> +	*map->key_ptr = key;
> +out:
> +	*map->map = m;
> +	return status;
> +}
> +
> +static efi_status_t efi_exit_boot_services(void *handle,
> +					   struct efi_boot_memmap *map)
> +{
> +	return efi_bs_call(exit_boot_services, handle, *map->key_ptr);
> +}
> +
> +unsigned long __efiapi efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> +{
> +	efi_system_table = sys_tab;
> +
> +	return 0;
> +}
> -- 
> 2.33.0.259.gc128427fd7-goog
>

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

