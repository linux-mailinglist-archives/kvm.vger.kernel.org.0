Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF49E4561E5
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 18:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhKRSAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhKRSAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:00:41 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5A3C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:57:41 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id m15so6063224pgu.11
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 09:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Or/qUh78k4/yPkcoOyeqDCEdS0ydDxGdefv0teEICX4=;
        b=K6K0hJe+2Cr3lTMn+aG9P6bVn6trQMheYQHv23SsZ/IEv9VlI+DMaPTHR3wq+nAiKq
         k1L3UOdtoL1rU3OTlWlzDDlUNHiLADt2gKQSJh3tK/gyWvquYjCdzWrnmdCf8e9w8E26
         82csRg6bLyH6lwogtE4K5Dj62X1rarLouhmBPCdbLH7f1RwmXEz+Jsfd12IVf2ijjOke
         CaPN1SjZqivrrRMQUy4NgTLeP92mSPRpO3siACCT6dC0KhGp7o4FN9jR1bBJeywb4sWP
         0jN/W+jNKNp7wVRiY+6Fp2GEe4ebMHo22gwAoGAXm9g2/S2v2p40Jj4PRtpxB9vTWNH2
         1TsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Or/qUh78k4/yPkcoOyeqDCEdS0ydDxGdefv0teEICX4=;
        b=hIEC+8Y7IuZjSmJNMX7UUcS6oKSHEOfqfacvdxr+68HfLu90nuOoaf/3UTNmxTkNPc
         DoQ73Qa65Dd9on1gFOhxflB71tB9zD7D3r56pfLENdjQq81XD1KJGaGRstdeUgI9r62S
         IU8iMaob5LcD7Zywtufp87VLcnLd9DHy2yWQIpl97tl7XSKWLhgos+JeP/aQs+lolR4X
         X1+mRprKpQcavZhI4Sm8y/uUDovyiJP2vYf4oZhygw3zEGtlxtCVZUIQbA9sWPd7gnei
         hjle8rzl91k0P7uRsDd211qCfkYevDdOE21rF549dmTWJVQy/JDktJc8VHnxOvX5R2zK
         eQhQ==
X-Gm-Message-State: AOAM5314ig6B6W6/7Ess+D1JzJXGE33CR9+PBF0pQYWmg39VtVkC7mLF
        KIC4u6gMFEykuYj2pYu8xz9uUQ==
X-Google-Smtp-Source: ABdhPJxOi+lPVsX+Rv9njxXaFDkOyr6mJlHZzOyiC2PCSBZ9XzmPP4N7mugOkUF5DOjd4hcMwU1Fzg==
X-Received: by 2002:a63:9c02:: with SMTP id f2mr2588796pge.422.1637258260577;
        Thu, 18 Nov 2021 09:57:40 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m184sm233633pga.61.2021.11.18.09.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 09:57:39 -0800 (PST)
Date:   Thu, 18 Nov 2021 17:57:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
Subject: Re: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU
 page faults.
Message-ID: <YZaUENi0ZyQi/9M0@google.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-4-shivam.kumar1@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211114145721.209219-4-shivam.kumar1@nutanix.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 14, 2021, Shivam Kumar wrote:
> +static int kvm_vm_ioctl_enable_dirty_quota_migration(struct kvm *kvm,
> +		bool enabled)
> +{
> +	if (!KVM_DIRTY_LOG_PAGE_OFFSET)

I don't think we should force architectures to opt in.  It would be trivial to
add 

		if (kvm_dirty_quota_is_full(vcpu)) {
			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
			r = 0;
			break;
		}

in the run loops of each architecture.  And we can do that in incremental patches
without #ifdeffery since it's only the exiting aspect that requires arch help.

> +		return -EINVAL;
> +
> +	/*
> +	 * For now, dirty quota migration works with dirty bitmap so don't
> +	 * enable it if dirty ring interface is enabled. In future, dirty
> +	 * quota migration may work with dirty ring interface was well.
> +	 */

Why does KVM care?  This is a very simple concept.  QEMU not using it for the
dirty ring doesn't mean KVM can't support it.

> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
> +	/* Return if no change */
> +	if (kvm->dirty_quota_migration_enabled == enabled)

Needs to be check under lock.

> +		return -EINVAL;

Probably more idiomatic to return 0 if the desired value is the current value.

> +	mutex_lock(&kvm->lock);
> +	kvm->dirty_quota_migration_enabled = enabled;

Needs to check vCPU creation.

> +	mutex_unlock(&kvm->lock);
> +
> +	return 0;
> +}
> +
>  int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  						  struct kvm_enable_cap *cap)
>  {
> @@ -4305,6 +4339,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  	}
>  	case KVM_CAP_DIRTY_LOG_RING:
>  		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +	case KVM_CAP_DIRTY_QUOTA_MIGRATION:
> +		return kvm_vm_ioctl_enable_dirty_quota_migration(kvm,
> +				cap->args[0]);
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> -- 
> 2.22.3
> 
