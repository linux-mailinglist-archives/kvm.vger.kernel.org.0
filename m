Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8306C1E1C55
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 09:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731605AbgEZHet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 03:34:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbgEZHes (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 03:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590478413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGp3YMRKFUOtwSIg5Cu6FMpQymGuRv9t/Z4LuF1Cd4U=;
        b=QvtPIv761SRsgk7EbYiNsllXZNaATLUSvzBK4mLvpRexZZpdWKASn09MbduaYJbR1cBHPN
        F99Eo+RsD2GaUwNpPcb1/LGebDIsjKAoeClyVDQJUZz0n2bXpCzzYaXIdmoNjLWPodXQbm
        kJHBsV7InrNYxwdca3drdHZyLo4EMmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-tuSu6kPyOPSJIHvWDa6FqQ-1; Tue, 26 May 2020 03:33:32 -0400
X-MC-Unique: tuSu6kPyOPSJIHvWDa6FqQ-1
Received: by mail-wm1-f70.google.com with SMTP id b65so500898wmb.5
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 00:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YGp3YMRKFUOtwSIg5Cu6FMpQymGuRv9t/Z4LuF1Cd4U=;
        b=HOfiNxlWxU8EtIad013gavGcCwmTEV5dIVy2iBuviE6qDYC6ozvq7O7Sy+z5avzD/T
         t6PhjaZ2aHrphPlIoW6LCwt70R6yE+iILcNFVw1JQv+/9dG+pL4xH5byZin3tVF/yHJl
         GLF/sOrKAfM8pgF1QewmonIz5gJpz1PDJN/wGTZa7R6c3XXcMSmKSsqtoHsA1uNvythC
         Wy3tPzEj7fWMLDX4yYAqFde7ok9q5SpspTxr1p+NPz0vdq7gEE9LIMWgmhavEAe+HCPv
         5D0iLhJNKXue7YgSztuR8BYbNmsZDKWnBcIOsfomSpN/uOjz+OVe/lZjriJrLi5OvPt6
         JMxg==
X-Gm-Message-State: AOAM530PPMnCsVuW+9NX9czMcBkRJ1AxUH4MTui3L7ZJtMh3LNiZN9B7
        DHDIhsmOOS/C9jzyO2oLqk38ejkikVT7qdAACZ9r2L1bsEJCMVIVQV/qXZuuIuOTKdB/riN82Nz
        bU3qzlvb1zbaP
X-Received: by 2002:a5d:6986:: with SMTP id g6mr13344957wru.27.1590478410611;
        Tue, 26 May 2020 00:33:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdQ4IEghrK6U3kHVDLWMkCekgw9MH67kIBkKD/yjzktHHSXF19lE8bi5+QeFcAIEnBoa/xew==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr13344925wru.27.1590478410320;
        Tue, 26 May 2020 00:33:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l17sm6367416wmi.3.2020.05.26.00.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 00:33:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     John Hubbard <jhubbard@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Souptick Joarder <jrdr.linux@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: fix svn_pin_memory()'s use of get_user_pages_fast()
In-Reply-To: <20200526062207.1360225-2-jhubbard@nvidia.com>
References: <20200526062207.1360225-1-jhubbard@nvidia.com> <20200526062207.1360225-2-jhubbard@nvidia.com>
Date:   Tue, 26 May 2020 09:33:27 +0200
Message-ID: <87imgj6th4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

John Hubbard <jhubbard@nvidia.com> writes:

> There are two problems in svn_pin_memory():
>
> 1) The return value of get_user_pages_fast() is stored in an
> unsigned long, although the declared return value is of type int.
> This will not cause any symptoms, but it is misleading.
> Fix this by changing the type of npinned to "int".
>
> 2) The number of pages passed into get_user_pages_fast() is stored
> in an unsigned long, even though get_user_pages_fast() accepts an
> int. This means that it is possible to silently overflow the number
> of pages.
>
> Fix this by adding a WARN_ON_ONCE() and an early error return. The
> npages variable is left as an unsigned long for convenience in
> checking for overflow.
>
> Fixes: 89c505809052 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_UPDATE_DATA command")
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  arch/x86/kvm/svm/sev.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 89f7f3aebd31..9693db1af57c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -313,7 +313,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  				    int write)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -	unsigned long npages, npinned, size;
> +	unsigned long npages, size;
> +	int npinned;
>  	unsigned long locked, lock_limit;
>  	struct page **pages;
>  	unsigned long first, last;
> @@ -333,6 +334,9 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  		return NULL;
>  	}
>  
> +	if (WARN_ON_ONCE(npages > INT_MAX))
> +		return NULL;
> +

I bit unrelated to this patch, but callers of sev_pin_memory() treat
NULL differently:

sev_launch_secret()/svm_register_enc_region() return -ENOMEM
sev_dbg_crypt() returns -EFAULT

Should we switch to ERR_PTR() to preserve the error?

>  	/* Avoid using vmalloc for smaller buffers. */
>  	size = npages * sizeof(struct page *);
>  	if (size > PAGE_SIZE)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

