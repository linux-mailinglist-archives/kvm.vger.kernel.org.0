Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60C36D785
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 14:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbhD1Mjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 08:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239283AbhD1Mjs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 08:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619613542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Adfym8klH+5tYEalET56TZJSSzxtb4r5UMa5Cv/WfQY=;
        b=clx8ev1WVcudGfG2+qqURuqBsDiiIAunsleqr+vu+9QEGbZXzEQnPBlE2XQyD/W1swqQWg
        JRGUbowm43Nh95qlGcVwIIOtrR8/CNSnh86/LYEJmBOos3ZeTu2Zt4L3A3eXW3afmY+F/X
        UjhY1JTUW2tFOFhN3EP7YYNxurT4YBY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-L3FN5WqkOhKko_NkdvRTrA-1; Wed, 28 Apr 2021 08:38:59 -0400
X-MC-Unique: L3FN5WqkOhKko_NkdvRTrA-1
Received: by mail-ed1-f71.google.com with SMTP id g19-20020a0564021813b029038811907178so857368edy.14
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 05:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Adfym8klH+5tYEalET56TZJSSzxtb4r5UMa5Cv/WfQY=;
        b=WhJqqS/ZUJn3bm+kmne8Icl05K1pxHaUP4rlKc9O5JLVyElmLy+EOwx2g16Vmumi2V
         cUaVOxJtq9qNIdTsC4ujBPqqjiqqMMKcu3r92sdmVJw6czYE6cEhxzx+BLh24Kk6vouU
         GIJKPE9onmbCwuTHnFECGwwI3zHKlQnp6UhrYgtiogJv3FPoTijdb/n9Jgqw0CwggbXE
         8BKO6231zM67VZ7GWxliTDgYBGRJ24eFA+Wwa+843kNQ8tg9COG5kLcGkbH7yHABtkPH
         d6S6zHMchj4dt1e4YLLvFY+Km4o5VDJOZI+P2fJnlN9tP0RM3RIWrT9gnbkJw+VXCIbL
         KOGA==
X-Gm-Message-State: AOAM533UeXgmz9aJyviPX3EFi71rx2ZpB8F23ocghJ0lxX+MTKz9sVOm
        v+DIL7wNmsXaQnqbn9D7I+2MhvApWQNZ2TLkvi6dcYPv5dr01CpmvgyXHD1TjXTf2LrXCNr50sl
        4ag9Brm1wP/Z0
X-Received: by 2002:a17:906:6a41:: with SMTP id n1mr29126501ejs.401.1619613538769;
        Wed, 28 Apr 2021 05:38:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM7yUm1BKlNC1iK3OfUA70Fr0wQFbfb2WyKUUYOLARDyyEnrh62rWqtS9ykhJkwSv1JTJIIg==
X-Received: by 2002:a17:906:6a41:: with SMTP id n1mr29126479ejs.401.1619613538594;
        Wed, 28 Apr 2021 05:38:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u1sm4785519edv.90.2021.04.28.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:38:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        linux-kernel@vger.kernel.org
Cc:     Denis Lunev <den@openvz.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Like Xu <like.xu@linux.intel.com>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
In-Reply-To: <20210428113655.26282-1-valeriy.vdovin@virtuozzo.com>
References: <20210428113655.26282-1-valeriy.vdovin@virtuozzo.com>
Date:   Wed, 28 Apr 2021 14:38:57 +0200
Message-ID: <871raueg7y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:

> KVM_GET_CPUID2 kvm ioctl is not very well documented, but the way it is
> implemented in function kvm_vcpu_ioctl_get_cpuid2 suggests that even at
> error path it will try to return number of entries to the caller. But
> The dispatcher kvm vcpu ioctl dispatcher code in kvm_arch_vcpu_ioctl
> ignores any output from this function if it sees the error return code.
>
> It's very explicit by the code that it was designed to receive some
> small number of entries to return E2BIG along with the corrected number.
>
> This lost logic in the dispatcher code has been restored by removing the
> lines that check for function return code and skip if error is found.
> Without it, the ioctl caller will see both the number of entries and the
> correct error.
>
> In selftests relevant function vcpu_get_cpuid has also been modified to
> utilize the number of cpuid entries returned along with errno E2BIG.
>
> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> ---
>  arch/x86/kvm/x86.c                            | 10 +++++-----
>  .../selftests/kvm/lib/x86_64/processor.c      | 20 +++++++++++--------
>  2 files changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index efc7a82ab140..df8a3e44e722 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4773,14 +4773,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = -EFAULT;
>  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>  			goto out;
> +
>  		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
>  					      cpuid_arg->entries);
> -		if (r)
> -			goto out;
> -		r = -EFAULT;
> -		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))

It may make sense to check that 'r == -E2BIG' before trying to write
anything back. I don't think it is correct/expected to modify nent in
other cases (e.g. when kvm_vcpu_ioctl_get_cpuid2() returns -EFAULT)

> +
> +		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid))) {
> +			r = -EFAULT;
>  			goto out;
> -		r = 0;
> +		}
>  		break;

How is KVM userspace supposed to know if it can trust the 'nent' value
(KVM is fixed case) or not (KVM is not fixed case)? This can probably be
resolved with adding a new capability (but then I'm not sure the change
is worth it to be honest). Also, if making such a change, API
documentation in virt/kvm/api.rst needs updating.

>  	}
>  	case KVM_GET_MSRS: {
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..a412b39ad791 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -727,17 +727,21 @@ struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
>  
>  	cpuid = allocate_kvm_cpuid2();
>  	max_ent = cpuid->nent;
> +	cpuid->nent = 0;
>  
> -	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
> -		rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
> -		if (!rc)
> -			break;
> +	rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
> +	TEST_ASSERT(rc == -1 && errno == E2BIG,
> +		    "KVM_GET_CPUID2 should return E2BIG: %d %d",
> +		    rc, errno);
>  
> -		TEST_ASSERT(rc == -1 && errno == E2BIG,
> -			    "KVM_GET_CPUID2 should either succeed or give E2BIG: %d %d",
> -			    rc, errno);
> -	}
> +	TEST_ASSERT(cpuid->nent,
> +		    "KVM_GET_CPUID2 failed to set cpuid->nent with E2BIG");
> +
> +	TEST_ASSERT(cpuid->nent < max_ent,
> +		"KVM_GET_CPUID2 has %d entries, expected maximum: %d",
> +		cpuid->nent, max_ent);
>  
> +	rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
>  	TEST_ASSERT(rc == 0, "KVM_GET_CPUID2 failed, rc: %i errno: %i",
>  		    rc, errno);

-- 
Vitaly

