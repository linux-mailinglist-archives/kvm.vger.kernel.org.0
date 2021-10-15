Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248AF42FE2C
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbhJOWb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 18:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243233AbhJOWb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 18:31:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F83C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 15:29:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ls18so8168359pjb.3
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 15:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uih3YNpsIBHXUU7iwHb6+8LCRvjXiHUHQ124OIxH6BM=;
        b=A8MSefLbIhxC8+iyqHUycVUQFGBoUpwkKOgujuPs9ozwElkSAQrqa66BZy3/fGzXIm
         Qbhv0vDTV4qaj0plPVP7SzTbUvV/YOduqrDiwQASsmqh3pnx7yPYByFsckpr/OIUA8bS
         xCyWJOaRO7gRZLdoMFrZT2KExrOi0I6iX0H71VZQFJvN2SFrKOvZVO005tqUAUega7kT
         /mkdayTJYSbgGALy1BPSIt5JM5CqB+CZxfpWHg5YeilmD7GQvHzjmy9pCZiOif3MxNJ0
         dr3/iEXcoa/a3QUXZ8C4Na51ScaC4LjwHdGyHEEnGzo1oX0EmBY+E2T+GqRfl1LHYR6O
         k9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uih3YNpsIBHXUU7iwHb6+8LCRvjXiHUHQ124OIxH6BM=;
        b=dT8WmtrzLYsUx/Dg0H7PmRvRtaGXapBmDxGP01GTl711iZ7UeeNvGUpoluMK/7aEQG
         ndq3fqAQvBsVLuZA44I186+SigADK+eClRIPs0GHLiduy9+dM40LEsSUPtlck2n+Yz77
         LGkB5rOHrSrknKb5z59TT7ulgY0ocmO6F9kI8LI7xifid5cSNgqSCGaGJOVPa+jAXNTq
         q4w28+M0oKgJ5wQUHF1z3sdUGbkreM1RKe42hljVtXzOx3x6G97/pl3HEHulXFKxxx+9
         7SH1279krLx/SfWfdM3AOGhOYArIFb9OGKeRE4Z2mdGFoBZIkntF16wrM8ZBHpUN97iZ
         jhQQ==
X-Gm-Message-State: AOAM5338+rTR1Yooe7un1b7SIyz5T7JFrnVRtG3kL2CHXn13kiQCDbSG
        1OKDrFmexXxgWx1Vd/XNK9/CUA==
X-Google-Smtp-Source: ABdhPJwnbxNOV8fIXWAeTIr0J7VmZHu4/djon5+pS0Ig1FSUmwDVo0Lfprql6WuH/7mX+D0/h1uzUA==
X-Received: by 2002:a17:90a:c594:: with SMTP id l20mr29906071pjt.223.1634336990662;
        Fri, 15 Oct 2021 15:29:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b11sm5349230pge.57.2021.10.15.15.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 15:29:50 -0700 (PDT)
Date:   Fri, 15 Oct 2021 22:29:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, x86@kernel.org, yang.zhong@intel.com,
        jarkko@kernel.org
Subject: Re: [PATCH v2 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-ID: <YWoA2lBUuFmDf6zu@google.com>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
 <20211012105708.2070480-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012105708.2070480-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021, Paolo Bonzini wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 59cdf3f742ac..81a0a0f22007 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -150,6 +150,46 @@ static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
>  	return 0;
>  }
>  
> +static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
> +{
> +	struct sgx_epc_page *entry;
> +	unsigned long index;
> +	long failures = 0;
> +
> +	xa_for_each(&vepc->page_array, index, entry) {

Might be worth a comment that xa_for_each() is safe to use concurrently with
xa_load/xa_store, i.e. this doesn't need to take vepc->lock.  It does raise the
question of whether or not the kernel is responsible for providing deterministic
results if userspace/guest is accessing previously-unallocated pages.

> +		int ret = sgx_vepc_remove_page(entry);

I don't see anything that prevents userspace from doing SGX_IOC_VEPC_REMOVE_ALL
on multiple threads with the same vEPC.  That means userspace can induce a #GP
due to concurrent access.  Taking vepc->lock would solve that particular problem,
but I think that's a moot point because the EREMOVE locking rules are relative to
the SECS, not the individual page (because of refcounting).  SGX_IOC_VEPC_REMOVE_ALL
on any two arbitrary vEPCs could induce a fault if they have children belonging to
the same enclave, i.e. share an SECS.

Sadly, I think this needs to be:

		if (ret == SGX_CHILD_PRESENT)
			failures++;
		else if (ret)
			return -EBUSY;

> +		switch (ret) {
> +		case 0:
> +			break;
> +
> +		case SGX_CHILD_PRESENT:
> +			failures++;
> +			break;
> +
> +		case SGX_ENCLAVE_ACT:
> +			/*
> +			 * Unlike in sgx_vepc_free_page, userspace could be calling
> +			 * the ioctl while logical processors are running in the
> +			 * enclave; do not warn.
> +			 */
> +			return -EBUSY;
> +
> +		default:
> +			WARN_ONCE(1, EREMOVE_ERROR_MESSAGE, ret, ret);
> +			failures++;
> +			break;
> +		}
> +		cond_resched();
> +	}
> +
> +	/*
> +	 * Return the number of pages that failed to be removed, so
> +	 * userspace knows that there are still SECS pages lying
> +	 * around.
> +	 */
> +	return failures;
> +}
