Return-Path: <kvm+bounces-23931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BCD94FC81
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 653111F22BE2
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 04:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074541CD23;
	Tue, 13 Aug 2024 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cx71XHCJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D629A5
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521869; cv=none; b=pnmpxALrsLIDfeYYdHqqvHhTovZH36R8dwvUPcce5nFRRSFIrTQ5RnX6lrQrujVEwPbIes0GapfC17uvIrGXnHU+sdlK1JKhR9Udj73Gwj0xZCKT1vnNoPJjqXPviu+K/MJCBr3ccL2M+hhNPUs3MwyG8lUUH7c9qHw6++5Xqtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521869; c=relaxed/simple;
	bh=RBLuOpa6/6KuZb5ZUiFSN5p9kDO6fr0QcfXEYDrzFlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s/J3WWxPW8pwyssjlqllMlA5B1pwfnnvlCnGnHCn238dbLFj1vZAHpcM7/C/+X7aP/IALSZtVtk+97FteIyMsOl+jyLYluTxHLXBjyWoz8PxO7B1k5XhD1YkoLMxh/bKhtDHQewby7oyYStE8dvhvJVMu935061ulTR8TEcG+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cx71XHCJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6ac9a4aaso53250645ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 21:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723521866; x=1724126666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xr7C32v6c2xit879iiq1ZVSHFKFJKtQ1IiBykzo7yK0=;
        b=Cx71XHCJRnpgif2r0Lkuqu8QgLe6fvYg4Kodi+lROB2tj3YBk5grbuDgBLDof4OkVm
         0auB+p7U/cWcmJ53VBv4hstNZPE8Utxn0GDhmA4c8QyrZhU5q/ecYvWuwgU5ZcPwwu45
         rkS+8PN4oX2WUA0XRO+oZfoXPsBiLyOu6pkQcHO+dIANxauzW9zD9cKYxRmEB/X14BZf
         hhOfyDInD0V8w7wemgsmHC02Sj5t2vf6gk+yKlOFtcsT3TR0Pr5uncvyEfqbJdsuFqgM
         k3Km2rzgC0DwT8s4pzsYg9v3TnhPZ2OUnudKhSTMIZu5wGXLNI72J9/PSyxXeakgL0W+
         msig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521866; x=1724126666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xr7C32v6c2xit879iiq1ZVSHFKFJKtQ1IiBykzo7yK0=;
        b=J5L+oxBinr0fhmFEzXT/hu0C4EMNGibUBoqF+f0EhHQGY7CVSfSf8Au/a3g/3tdJtI
         HYzh1KJqw43q1UCnc258h1RJ+txmqGRVXLrXeCAdhQcLYPGYiKI/hX/w57j2QQfqUmYp
         XiIsl+2C4sw9M5xDy06sqfwoYtULPBnBlj99xHgGBmSdS1kJPudo4ufsAahEvJw7CPSt
         98Pjcj5EEEnh49rDmCk7KV35Y2a8n4UFojQDSfzo4axRvJQNCgSdahsaEZamuEGOq+jY
         PxO7cBZZgLl26z563XiJSA48exvxbiC/Dr4m/ops1snsRYS5/iZ4cAGy5db/b2aTwmF2
         hLqA==
X-Forwarded-Encrypted: i=1; AJvYcCWoQYcXNqQbNMvVd5cHFoVhJtFqHiZC8KCpFYEtRlLo0Fv5GbEkJfLY/nVRVmABM81wRfTXAYQuympKSmjtUSyy5QEX
X-Gm-Message-State: AOJu0YwFM7kjem/N00/hOEGFViI35SLhi11Fpapa7AlyRiWmzU6ifPzi
	6C/BZX56F5XTRZK/YydnarHCgFeTQT2mp+5OyrxTXYaZjI2DZgsEdNZc6pmW5W+I3mkExRj+6On
	7Rw==
X-Google-Smtp-Source: AGHT+IE0Ey9nvTvCCBhSwJ3Y5zSB2eUuiv0MOxdgaSuEN1zHD4D5H59HYPhmPXB6LWhWDDa9QhdhzhYYnUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2311:b0:1fd:8e8d:8695 with SMTP id
 d9443c01a7336-201ca1ecf6bmr102765ad.12.1723521865969; Mon, 12 Aug 2024
 21:04:25 -0700 (PDT)
Date: Mon, 12 Aug 2024 21:04:24 -0700
In-Reply-To: <20240612115040.2423290-4-dan.carpenter@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612115040.2423290-2-dan.carpenter@linaro.org> <20240612115040.2423290-4-dan.carpenter@linaro.org>
Message-ID: <ZrrbSFVpVs0eX1ZQ@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Fix an error code in sev_gmem_post_populate()
From: Sean Christopherson <seanjc@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: error27@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Dan Carpenter wrote:
> The copy_from_user() function returns the number of bytes which it
> was not able to copy.  Return -EFAULT instead.

Unless I'm misreading the code and forgetting how all this works, this is
intentional.  The direct caller treats any non-zero value as a error:

		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);

		put_page(pfn_to_page(pfn));
		if (ret)
			break;
	}

	filemap_invalidate_unlock(file->f_mapping);

	fput(file);
	return ret && !i ? ret : i;

and the indirect caller specifically handles a non-zero count:

	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
				  sev_gmem_post_populate, &sev_populate_args);
	if (count < 0) {
		argp->error = sev_populate_args.fw_error;
		pr_debug("%s: kvm_gmem_populate failed, ret %ld (fw_error %d)\n",
			 __func__, count, argp->error);
		ret = -EIO;
	} else {
		params.gfn_start += count;
		params.len -= count * PAGE_SIZE;
		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
			params.uaddr += count * PAGE_SIZE;

		ret = 0;
		if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
			ret = -EFAULT;
	}

and KVM's docs even call out that success doesn't mean "done".

  Upon success, this command is not guaranteed to have processed the entire
  range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
  ``struct kvm_sev_snp_launch_update`` will be updated to correspond to the
  remaining range that has yet to be processed. The caller should continue
  calling this command until those fields indicate the entire range has been
  processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
  range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
  buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
  ``uaddr`` will be ignored completely.

> 
> Fixes: dee5a47cc7a4 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  arch/x86/kvm/svm/sev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 70d8d213d401..14bb52ebd65a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2220,9 +2220,10 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>  		if (src) {
>  			void *vaddr = kmap_local_pfn(pfn + i);
>  
> -			ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
> -			if (ret)
> +			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> +				ret = -EFAULT;
>  				goto err;
> +			}
>  			kunmap_local(vaddr);
>  		}
>  
> -- 
> 2.43.0
> 

