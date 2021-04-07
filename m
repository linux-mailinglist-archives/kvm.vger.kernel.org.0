Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9C357765
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhDGWLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhDGWKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BBBC061762
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 15:10:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l1so10052188plg.12
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 15:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vtmPVqBl03E5SIcGgKAeJwAUwJyZ79rWnRBhLnJMsWM=;
        b=REHIcr5tSY7IzRzZ29Lv6lbVF/t49AjgA4LLxhGtjCqY4izEe9ZS+M4rA4SSno8J2l
         0Zfgbk9QFTAmRyuAEEbi7xBzvLO4VRiYSRi5rKByVFrhTc1Ad3/ShwwdNml4tPsEj0Zu
         AE+8m82pllPaGdtCGy9TKoC61p1qOIWPKZdjvmMRVCQdctMmhMztpAwzECJozjkCKeyH
         Og8VYWAIt65pgNMY8qC+pdL12R6jfwLqsuABcvFTOzFSJeB/wNOxR/JSx9ygE2Tyxhin
         Hf930uPILvxlwBqitL+5mSoIQFcNaSPj94bBaVKf7Kx55EZ09n0lzxa3W79zv4m4wj4j
         soWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vtmPVqBl03E5SIcGgKAeJwAUwJyZ79rWnRBhLnJMsWM=;
        b=mRd2UYv5tmr4F4IE3JXyW4qdcV7qGtlwSoJGHLcqJf+7o80ciewoX/nMwG/ZzPLbco
         o/sUFlnj3H0YUiTzz3aqbqo9Keg2H5m4Ms1v81nMiKdD0rXE8tSw3RIjTAvApWbaTck1
         BhjzCnAu7R2kT+q4x5kx0FY9jDfFT1hOhZbq73Ti7Qszs7TiEuHJkrcyY0Sx7xNj+n2f
         dCdGGWIj/5BI7W0//R1nkjmvUUR457Im3vVKKLYTuxUACgu1GQ3BQl0lShbC5XrCEWpV
         lR9VOJwyN6Jv7LXbbA3uK2uXoFd6+Hb8faMR0Shf/JG7ec69lDdYLVsUuudlGaGfzUNO
         Sy5g==
X-Gm-Message-State: AOAM5335rosEOUFDKBMZOf86X9eeC5OxvncYYfcGv2I/fV0Ald0IMYfQ
        X1ee+0qMzWiuFA+QuNmKBD/8Xw==
X-Google-Smtp-Source: ABdhPJxjp8pFwWSX0dD8RA9S3rAu7Obx2lqx5k7zw26F4tfjviqc3nFF1lK/zR+04Q+13ebVdckgPA==
X-Received: by 2002:a17:90b:16cd:: with SMTP id iy13mr5492149pjb.46.1617833440715;
        Wed, 07 Apr 2021 15:10:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v1sm5859639pjv.0.2021.04.07.15.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 15:10:40 -0700 (PDT)
Date:   Wed, 7 Apr 2021 22:10:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YG4t3DYYNd4eBeNt@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> +	/*
> +	 * sgx_virt_ecreate() returns:
> +	 *  1) 0:	ECREATE was successful
> +	 *  2) -EFAULT:	ECREATE was run but faulted, and trapnr was set to the
> +	 *  		exception number.
> +	 *  3) -EINVAL:	access_ok() on @secs_hva fails. It's a kernel bug and
> +	 *  		sgx_virt_ecreate() aleady gave a warning.

Eh, I don't love "kernel bug", all we know is that access_ok() failed.  It's
also not all that helpful since it doesn't guide the debugger to any particular
code that would prevent access_ok() from failing.

What if this comment simply states the rules/expectations and lets the debugger
figure out what's wrong?  E.g.

	 *  3) -EINVAL: access_ok() on @secs_hva failed.  This should never
	 *              happen as KVM checks host addresses at memslot creation.
	 *              sgx_virt_create() has already warned in this case.

Same goes for sgx_virt_einit() in the next patch.

> +	 */
> +	ret = sgx_virt_ecreate(pageinfo, (void __user *)secs_hva, &trapnr);
> +	if (!ret)
> +		return kvm_skip_emulated_instruction(vcpu);
> +	if (ret == -EFAULT)
> +		return sgx_inject_fault(vcpu, secs_gva, trapnr);
> +
> +	return ret;
> +}
