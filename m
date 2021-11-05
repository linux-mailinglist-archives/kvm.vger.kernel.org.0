Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08D4468AC
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 19:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhKES4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 14:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhKES4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 14:56:51 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A02C061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 11:54:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id j9so9120742pgh.1
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 11:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oua1NNuIhEd/8YiB1KXZ/mH31PzjBXbLDfOTANzR5M8=;
        b=qELp/L36fAFzdv/9Ze7KLxzE6CW74d9cTzIT6fuRsfKwGXuNHhAbjvskQCxJ6HS03F
         jbtIiPoIcr+c1CGJ5z4rdpCTLivZwOkN+XGZQd23vXMtZblm2SP2pDN5aRLYS5NquSLC
         9PJnLlvqFjU6SxBQ+VbTuvfsiAWj3f4pTKdoIc7OM6RCToV5uHfXA52Rb5Hyh2W3xzHa
         Yn15cz2xg6LVhE25F2Dn6okak1CmWIPkvVRim1tMb4kDChyCxtpueefnna1KQ1rBQSrU
         Ltku7lgUSS58W44mlUD2gkzeRGGVkVrRKupLRB7+EBv/QiZnYq/+RYiG22NdiThzao9c
         /wPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oua1NNuIhEd/8YiB1KXZ/mH31PzjBXbLDfOTANzR5M8=;
        b=ap6nhvXG/guUygnZ5TvNEovjjfl7jh9JQ7RShZTAu9roIVY5wBB+D2eq4YBvfX2x6x
         l1MG8H8SIrUNqCpzUv0JwwzYIknFofdsb90gb5JLbBxFg0KWR2ALlSq9o6ghvajR1iB3
         m/8Id164Vt9ZOUBMD/1wbS/N9q6H5LW0JPOhNfQe0O8ttRgh0lZeFYkY0tZVIbSBZNvd
         J6SCMljsHP/HqSUG6g0TC4p0V0RfMrlNo60qntpnRqjbiMICTDTFlmSn2Gp0ngdtMDVz
         PKRpfRuqfmnRrxYD4zzFeuYS2nrQvRaMHrc73wMlsuKjA7aECaFqOK+delqxKJMmRKnH
         zo3A==
X-Gm-Message-State: AOAM531KTpv7IE31MK5M17Y63I7wdD4jHN4f8bf8XKrECSUE8SPA1ZAq
        ZpPg6deZgoc5NI74plt3dAvjOQ==
X-Google-Smtp-Source: ABdhPJxNIq75ZyZ+PxmSIHDOEt6UR+p73U4jThsh6EOWNRifoSBXVh+EeAKUBq6aKU1kkvVRk8yKPg==
X-Received: by 2002:a62:8683:0:b0:480:edf9:33c0 with SMTP id x125-20020a628683000000b00480edf933c0mr45720167pfd.11.1636138451139;
        Fri, 05 Nov 2021 11:54:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x2sm5056793pfd.144.2021.11.05.11.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 11:54:10 -0700 (PDT)
Date:   Fri, 5 Nov 2021 18:54:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v1 2/7] x86 UEFI: Refactor set up process
Message-ID: <YYV9ztwl/7Z5LqyT@google.com>
References: <20211031055634.894263-1-zxwang42@gmail.com>
 <20211031055634.894263-3-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211031055634.894263-3-zxwang42@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 30, 2021, Zixuan Wang wrote:
> +efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
> +	efi_status_t status;
> +
> +	status = setup_memory_allocator(efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Failed to set up memory allocator: ");
> +		switch (status) {
> +		case EFI_OUT_OF_RESOURCES:
> +			printf("No free memory region\n");
> +			break;
> +		default:
> +			printf("Unknown error\n");
> +			break;
> +		}
> +		return status;
> +	}
> +	
> +	status = setup_rsdp(efi_bootinfo);
> +	if (status != EFI_SUCCESS) {
> +		printf("Cannot find RSDP in EFI system table\n");
> +		return status;
> +	}
> +
> +	status = setup_amd_sev();
> +	if (status != EFI_SUCCESS) {
> +		switch (status) {
> +		case EFI_UNSUPPORTED:
> +			/* Continue if AMD SEV is not supported */
> +			break;
> +		default:
> +			printf("Set up AMD SEV failed\n");
> +			return status;
> +		}
> +	}

Looks like this is pre-existing behavior, but the switch is quite gratuituous,
and arguably does the wrong thing for EFI_UNSUPPORTED here as attempting to setup
SEV-ES without SEV is guaranteed to fail.  And it'd be really nice if the printf()
actually provided the error (below might be wrong, I don't know the type of
efi_status-t).

	status = setup_amd_sev();

	/* Continue on if AMD SEV isn't supported, but skip SEV-ES setup. */
	if (status == EFI_UNSUPPORTED)
		goto continue_setup;

	if (status != EFI_SUCCESS) {
		printf("AMD SEV setup failed, error = %d\n", status);
		return status;
	}

	/* Same as above, lack of SEV-ES is not a fatal error. */
	status = setup_amd_sev_es();
	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
		printf("AMD SEV-ES setup failed, error = %d\n", status);
		return status;
	}

continue_setup:

> +
> +	status = setup_amd_sev_es();
> +	if (status != EFI_SUCCESS) {
> +		switch (status) {
> +		case EFI_UNSUPPORTED:
> +			/* Continue if AMD SEV-ES is not supported */
> +			break;
> +		default:
> +			printf("Set up AMD SEV-ES failed\n");
> +			return status;
> +		}
> +	}
> +
>  	reset_apic();
>  	setup_gdt_tss();
>  	setup_idt();
> @@ -343,9 +334,9 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	enable_apic();
>  	enable_x2apic();
>  	smp_init();
> -	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
> -	setup_efi_rsdp(efi_bootinfo->rsdp);
>  	setup_page_table();
> +
> +	return EFI_SUCCESS;
>  }
>  
>  #endif /* TARGET_EFI */
> -- 
> 2.33.0
> 
