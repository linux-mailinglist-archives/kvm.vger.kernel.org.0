Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A410132E55E
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 10:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEJzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 04:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhCEJyo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 04:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614938083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1z7klFmmHzPLRgES+7HbIKqkMYY/KuZ6OJTH2OpsjrA=;
        b=LzEs2hUjFmAEkxZQyvtCVzg0TrF98nk4x3LG1RntdYrkjz8BVyv1Xs85HTTMg19YQXiDux
        Td8z1qE9CwHnN0NsjpUVOpzKCzAfgMZ78YovrP4CWLDNoJX71LdP4d+3fjeIT8MJFAkAKt
        D2krEwjXk7ET8ZLisZVYSvBAM848CpA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-UKMQ4sJVOEC-Wlub65ZvkQ-1; Fri, 05 Mar 2021 04:54:42 -0500
X-MC-Unique: UKMQ4sJVOEC-Wlub65ZvkQ-1
Received: by mail-ed1-f70.google.com with SMTP id bi17so682103edb.6
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 01:54:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1z7klFmmHzPLRgES+7HbIKqkMYY/KuZ6OJTH2OpsjrA=;
        b=VabkXRz6lJ06VXbocTL40bKKAaCivehLc6+6+Mx7wiOOB6Z+NnZjb6nIUtXiiwKjcO
         vhK5/GZwelBMuNPsKKlcDVlbagz7/B2qfNu2ZCz+HxYRM6UjsM3KFjX3dL0qHPvLFlzo
         nXPz7xc/GUa8+NLIeInhoYEAWlDTn5OnS8NQHSd8CZt5TSJQ7mmdX7KJ7zasiJCiblL0
         1dvnC9PM/KttUg0IbgRmUANlFNRZQsDd3rbWvh29Aw97tf5jHhR5PfU/uedWjxmC5KYB
         9QQcRxoo+sxTJr1zGwbc9LJlSjPPXBsi/rArjppZKIy9Pkwb+OHTelh622BpP55hJkIU
         98wQ==
X-Gm-Message-State: AOAM5338ocGwzX5U0dTukN4NSWe6dyvc1p9NluL/2KeD0dQOJ0B1h62n
        t+LWQ8sgVEY6V9feA4JEo8/Pvq5XQ6CTHdfC2W6BjjBwmtobZbQwUL0xr7t22xuUG/TcY0V20uN
        XY13I//zxshXA
X-Received: by 2002:aa7:c353:: with SMTP id j19mr6204602edr.263.1614938080773;
        Fri, 05 Mar 2021 01:54:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxiSfq13AMhpBD2/+qGr5OlpDwzLfRA+xsimqQ48qctBnseqSfTIIfSt5a0AuS3tcaiSX3zbQ==
X-Received: by 2002:aa7:c353:: with SMTP id j19mr6204591edr.263.1614938080579;
        Fri, 05 Mar 2021 01:54:40 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d19sm1268752edr.45.2021.03.05.01.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:54:40 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Connect 'npt' module param to KVM's internal
 'npt_enabled'
In-Reply-To: <20210305021637.3768573-1-seanjc@google.com>
References: <20210305021637.3768573-1-seanjc@google.com>
Date:   Fri, 05 Mar 2021 10:54:39 +0100
Message-ID: <878s72c4dc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Directly connect the 'npt' param to the 'npt_enabled' variable so that
> runtime adjustments to npt_enabled are reflected in sysfs.  Move the
> !PAE restriction to a runtime check to ensure NPT is forced off if the
> host is using 2-level paging, and add a comment explicitly stating why
> NPT requires a 64-bit kernel or a kernel with PAE enabled.
>
> Opportunistically switch the param to octal permissions.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 54610270f66a..0ee74321461e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -115,13 +115,6 @@ static const struct svm_direct_access_msrs {
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> -/* enable NPT for AMD64 and X86 with PAE */
> -#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
> -bool npt_enabled = true;
> -#else
> -bool npt_enabled;
> -#endif
> -
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * pause_filter_count: On processors that support Pause filtering(indicated
> @@ -170,9 +163,12 @@ module_param(pause_filter_count_shrink, ushort, 0444);
>  static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
>  module_param(pause_filter_count_max, ushort, 0444);
>  
> -/* allow nested paging (virtualized MMU) for all guests */
> -static int npt = true;
> -module_param(npt, int, S_IRUGO);
> +/*
> + * Use nested page tables by default.  Note, NPT may get forced off by
> + * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
> + */
> +bool npt_enabled = true;
> +module_param_named(npt, npt_enabled, bool, 0444);
>  
>  /* allow nested virtualization in KVM/SVM */
>  static int nested = true;
> @@ -988,12 +984,17 @@ static __init int svm_hardware_setup(void)
>  			goto err;
>  	}
>  
> +	/*
> +	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
> +	 * NPT isn't supported if the host is using 2-level paging since host
> +	 * CR4 is unchanged on VMRUN.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
> +		npt_enabled = false;
> +
>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>  		npt_enabled = false;
>  
> -	if (npt_enabled && !npt)
> -		npt_enabled = false;
> -

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>  	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
>  	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");

(unrelated to your patch but) I'd suggest we demote this pr_info() to
pr_debug() or keep it but print the message only when NPT is disabled as
in the overwhelming majority of cases it is enabled. Also, we don't seem
to print EPT status when kvm-intel is loaded.

-- 
Vitaly

