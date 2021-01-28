Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54B93071A2
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhA1Ihm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:37:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231509AbhA1Ihk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611822974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nf0jnBmR9S7kgQakgFuMWWnzgzSE4QHvRdW36PL6dL8=;
        b=A2RrV93+HpUtkrWHL/7JqR1MXmF7QS01lfgek5Dcy7SAPJfLxXE7zD5fog83HqwVN9PVlm
        oCNC9Qpj2WT6YIgXSBctW1tdrhtHEfUuU7e//CvI8uHf1GKkotEcpZrNU3ONJSFapCAye8
        Ni2fu4jV9gZbNSLL8+gXiooJth09UJ4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-daZz-jgeNqyjabXb2w9XLA-1; Thu, 28 Jan 2021 03:36:12 -0500
X-MC-Unique: daZz-jgeNqyjabXb2w9XLA-1
Received: by mail-ed1-f72.google.com with SMTP id n8so2832527edo.19
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Nf0jnBmR9S7kgQakgFuMWWnzgzSE4QHvRdW36PL6dL8=;
        b=P893Hhd1m8DvxgYuYf09hLSIkssBBBvvdnv3Nmvm9v2OT4tP7/zGDzBbHTUR61iBod
         oufCMsGWCUPkVMo44eVf8A7w/UI0JwTToELsT1Km7s/9cSXGDAdVgjI19ELq21hvz3TZ
         TIBd5LJppCy6O7uz6S5yJPZk6HO+QfwgCq2B0QTv0MhDxV+s7WPsnnZHWCnA13j6WQGJ
         wywpdTaQKFUTMFyMJvjVrAARhfXPDqZTckXYkxDBo2fdJ2uJikPEb2aqgoVvLXc7ncJM
         JF79WaXMEpmXek7SAVzwV4j7rBnvI1VsZqzCnvHEexYOHF+8uJETJBzOUh99Qabhj0Td
         i3kQ==
X-Gm-Message-State: AOAM531FyrB6enMDLumpQZmobHA1QtfJ5PR85uRcA3OUQM3Qh20eiZq1
        7K6V5dFIH7woEcr/sl45WRIYefDQ5Crg9SnF3Mdrj0Vs7EOmZNVvj29E9XgQMx3wgETm6fqigV2
        KgbU5v8vIw7LK
X-Received: by 2002:a05:6402:32c:: with SMTP id q12mr12910432edw.145.1611822971045;
        Thu, 28 Jan 2021 00:36:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWIui6+vrd5seJH5yGW9okKQwFC1Coh5JWb1vPz0BXTa+I+8gBtJNVZkGffRelSALyWXX+kw==
X-Received: by 2002:a05:6402:32c:: with SMTP id q12mr12910413edw.145.1611822970812;
        Thu, 28 Jan 2021 00:36:10 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m5sm1933153eja.11.2021.01.28.00.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 00:36:10 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com.com>
Subject: Re: [PATCH] KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2
 ioctl
In-Reply-To: <20210128024451.1816770-1-michael.roth@amd.com>
References: <20210128024451.1816770-1-michael.roth@amd.com>
Date:   Thu, 28 Jan 2021 09:36:09 +0100
Message-ID: <87a6st31c6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Roth <michael.roth@amd.com> writes:

> Recent commit 255cbecfe0 modified struct kvm_vcpu_arch to make
> 'cpuid_entries' a pointer to an array of kvm_cpuid_entry2 entries
> rather than embedding the array in the struct. KVM_SET_CPUID and
> KVM_SET_CPUID2 were updated accordingly, but KVM_GET_CPUID2 was missed.
>
> As a result, KVM_GET_CPUID2 currently returns random fields from struct
> kvm_vcpu_arch to userspace rather than the expected CPUID values. Fix
> this by treating 'cpuid_entries' as a pointer when copying its
> contents to userspace buffer.
>
> Fixes: 255cbecfe0c9 ("KVM: x86: allocate vcpu->arch.cpuid_entries dynamically")
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 13036cf0b912..38172ca627d3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -321,7 +321,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	if (cpuid->nent < vcpu->arch.cpuid_nent)
>  		goto out;
>  	r = -EFAULT;
> -	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
> +	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
>  			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
>  		goto out;
>  	return 0;

This is embarrassing but I have a (possible) excuse: copy_to_user's
argument is 'void *' so no warning was produced. Surprisingly, no test
caught the breakage. Thanks for debugging and fixing!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

