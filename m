Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE68C4807CC
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 10:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhL1J02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 04:26:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhL1J02 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Dec 2021 04:26:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640683587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieouWQmKcK4lsX86c5cvIrP3JO2ETy1mOZd2ZiHvYjA=;
        b=Wd+joaldWLtP+nSqdHmMET2AFJ62+JEFw9rMIhQSzEGBf4nIS21h/l9I2rOOESW972Ayp2
        OfycpjFE13q20TAub5f9UXfvIdE6N0z8t+FxSC4Df4hx2O/Y160uGS5m7vUtu57DjlCOA/
        97uohexkFyDmHiKOeFdCnrY5HhEzGRw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-_A58l0B5PoSkt6InbnZc0g-1; Tue, 28 Dec 2021 04:26:26 -0500
X-MC-Unique: _A58l0B5PoSkt6InbnZc0g-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a50ab0c000000b003efdf5a226fso12743541edc.10
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 01:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ieouWQmKcK4lsX86c5cvIrP3JO2ETy1mOZd2ZiHvYjA=;
        b=CnpZ5Xm/zipHlt3DrbmzKReStK9E5mwhT1LYbwDGB05Xomvd9SiWh+yJiGAZqJMwY9
         QILIl/KbPEL8mRzq+JR3dSP+a6uoJ4iRa+d+Lc9adAriQ8t8p0szuxTk0NxdbsMeZ5e4
         iPwFJV/TOkNUU94RnRIZvOupRk4anNEw+aBA+YUp77ipMmq+rk0G9s9rzXkOsRd7/cHV
         nEQlqEI9Uleh9WnPgvEwRfhnLl069UnquwbDmSJCmb13iycXoOydOkkyqpu4ZY6ZgeCJ
         JGh/VU6RMyeBiM4/V2aREgOZT8cKKPE1+1RUUD2N9zACkfJmhu8lSJdhXHcw0zchBtG3
         WRYQ==
X-Gm-Message-State: AOAM532JfZzlKVs/DHNfkc+ySEeKVBCnAE6ZxYhqETEeOFCxAzwZ5KuG
        lltxocQJQv7c8/+rDpAdsgnohO9XzxZ5TycymMvCEb+CFVRoSQQG7FIG9vRfCNH9qPVuM2iGRBR
        9jNesUd5ZBDYC
X-Received: by 2002:a17:907:6d04:: with SMTP id sa4mr17742295ejc.526.1640683584995;
        Tue, 28 Dec 2021 01:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmlaMBdkRJbLGn5nXSbPpENZRP59VGli32Sc48JzqYm4bDG7UjXAyQtXLu3H1XqrBhKJO6Ew==
X-Received: by 2002:a17:907:6d04:: with SMTP id sa4mr17742283ejc.526.1640683584825;
        Tue, 28 Dec 2021 01:26:24 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id b7sm7153565edj.24.2021.12.28.01.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 01:26:24 -0800 (PST)
Date:   Tue, 28 Dec 2021 10:26:22 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable
 default IPA size
Message-ID: <20211228092622.ffw7xu2j5ow4njxo@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227124809.1335409-3-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 27, 2021 at 12:48:05PM +0000, Marc Zyngier wrote:
> Contrary to popular belief, there is no such thing as a default
> IPA size on arm64. Anything goes, and implementations are the
> usual Wild West.
> 
> The selftest infrastructure default to 40bit IPA, which obviously
> doesn't work for some systems out there.
> 
> Turn VM_MODE_DEFAULT from a constant into a variable, and let
> guest_modes_append_default() populate it, depending on what
> the HW can do. In order to preserve the current behaviour, we
> still pick 40bits IPA as the default if it is available, and
> the largest supported IPA space otherwise.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
>  tools/testing/selftests/kvm/lib/guest_modes.c | 30 +++++++++++++++++--
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2d62edc49d67..7fa0a93d7526 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -53,7 +53,9 @@ enum vm_guest_mode {
>  
>  #if defined(__aarch64__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
> +extern enum vm_guest_mode vm_mode_default;
> +
> +#define VM_MODE_DEFAULT			vm_mode_default
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 8)
>  
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index c330f414ef96..5e3fdbd992fd 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -4,22 +4,46 @@
>   */
>  #include "guest_modes.h"
>  
> +#ifdef __aarch64__
> +enum vm_guest_mode vm_mode_default;
> +#endif
> +
>  struct guest_mode guest_modes[NUM_VM_MODES];
>  
>  void guest_modes_append_default(void)
>  {
> +#ifndef __aarch64__
>  	guest_mode_append(VM_MODE_DEFAULT, true, true);
> -
> -#ifdef __aarch64__
> -	guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +#else
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		int i;
> +
> +		vm_mode_default = NUM_VM_MODES;
> +
>  		if (limit >= 52)
>  			guest_mode_append(VM_MODE_P52V48_64K, true, true);
>  		if (limit >= 48) {
>  			guest_mode_append(VM_MODE_P48V48_4K, true, true);
>  			guest_mode_append(VM_MODE_P48V48_64K, true, true);
>  		}
> +		if (limit >= 40) {
> +			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> +			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +			vm_mode_default = VM_MODE_P40V48_4K;
> +		}
> +
> +		/*
> +		 * Pick the first supported IPA size if the default
> +		 * isn't available.
> +		 */
> +		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
> +			if (guest_modes[i].supported && guest_modes[i].enabled)
> +				vm_mode_default = i;

Since we don't have a 'break' here, this picks the last supported size
(of the guest_modes list), not the first, as the comment implies it should
do.

Thanks,
drew

> +		}
> +
> +		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
> +			    "No supported mode!");
>  	}
>  #endif
>  #ifdef __s390x__
> -- 
> 2.30.2
> 

