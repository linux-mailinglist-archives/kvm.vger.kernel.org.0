Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90509154718
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbgBFPKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:10:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbgBFPJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581001798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EZiBMYoM5ngA1SWJXac8F1p5eppKDaYXsn4jaAv3LSk=;
        b=Qe0tIXaafjYFLbssbpemZ+JsrLKFYREbrKAZsuZt68ov3+wc2M3UIQJkYiMg7hz/aQOidj
        abERDG9k5TwYmZfW8v4k8eAu0C4p+qA3iTYVl2KkLJygljrVbEQrtMzPmRTqhWIZH+fi3C
        ZRS8UAwg8wJ1+N+2K/dkZJAwtBFY/AE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-aow8YKnAMHWPBXp4n8nNSw-1; Thu, 06 Feb 2020 10:09:55 -0500
X-MC-Unique: aow8YKnAMHWPBXp4n8nNSw-1
Received: by mail-wr1-f69.google.com with SMTP id d15so3562622wru.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 07:09:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EZiBMYoM5ngA1SWJXac8F1p5eppKDaYXsn4jaAv3LSk=;
        b=nIKBnl/c48OT04Xn/XJD7H5IYE++oI0czhizP6dUmv4afH4l6jQL6RlSzUKDNHNvrp
         NBvKbFIAl8oky8UAaxoVyON/L1sAKNfixy6Uyl/YtdFhqWjVhcFEPM2ZtFtHha2w0AlR
         DxLigMn9QZfT4fBQFjwKtRgB6TAg7HYb4ebdBPegBBkITPdDsAlsGrVnhHTRNHMcmsgT
         0INED8Eeoplx+3ds6Zx5yiRwQq8U8UNkRVGzlA0RxBT9TY2Ih7BBnf/yz5Z85ZEr+LSo
         TkgR3cpQA5Vfqop0rMPrTBwCrGvHVGcNsCMdDYhXpu4s9s9WLYKjcZJoDNkGRqGpw3al
         JWQQ==
X-Gm-Message-State: APjAAAWgVeEwThaNDuPI8BtpS/4tcnVyAjDTLSTZjO3Zd/PlM5NzXa1w
        qKjjibqB0pbgjjmywg+odZcMF+f6jcjXoPEXZYRUhYi9bpbSjPkIBLsATRcs2iwRyLMcmKV3EoH
        PEisxw6hW+mKz
X-Received: by 2002:a1c:151:: with SMTP id 78mr4844273wmb.182.1581001794835;
        Thu, 06 Feb 2020 07:09:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqy7PZM8qvaN6WfZLfowxyRpKK0ElKwo8vzNSQ8xUj7u0xgC7aIvhuRCNLsPUGIuGsyl4qCxbg==
X-Received: by 2002:a1c:151:: with SMTP id 78mr4844246wmb.182.1581001794592;
        Thu, 06 Feb 2020 07:09:54 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q130sm4453532wme.19.2020.02.06.07.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 07:09:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/61] KVM: x86: Clean up error handling in kvm_dev_ioctl_get_cpuid()
In-Reply-To: <20200201185218.24473-5-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-5-sean.j.christopherson@intel.com>
Date:   Thu, 06 Feb 2020 16:09:53 +0100
Message-ID: <87mu9vg3b2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Clean up the error handling in kvm_dev_ioctl_get_cpuid(), which has
> gotten a bit crusty as the function has evolved over the years.
>
> Opportunistically hoist the static @funcs declaration to the top of the
> function to make it more obvious that it's a "static const".
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index de52cbb46171..11d5f311ef10 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -889,45 +889,40 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  			    struct kvm_cpuid_entry2 __user *entries,
>  			    unsigned int type)
>  {
> -	struct kvm_cpuid_entry2 *cpuid_entries;
> -	int nent = 0, r = -E2BIG, i;
> -
>  	static const u32 funcs[] = {
>  		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
>  	};
>  
> +	struct kvm_cpuid_entry2 *cpuid_entries;
> +	int nent = 0, r, i;
> +
>  	if (cpuid->nent < 1)
> -		goto out;
> +		return -E2BIG;
>  	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
>  		cpuid->nent = KVM_MAX_CPUID_ENTRIES;
>  
>  	if (sanity_check_entries(entries, cpuid->nent, type))
>  		return -EINVAL;
>  
> -	r = -ENOMEM;
>  	cpuid_entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
>  					   cpuid->nent));
>  	if (!cpuid_entries)
> -		goto out;
> +		return -ENOMEM;
>  
> -	r = 0;
>  	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
>  		r = get_cpuid_func(cpuid_entries, funcs[i], &nent, cpuid->nent,
>  				   type);
>  		if (r)
>  			goto out_free;
>  	}
> +	cpuid->nent = nent;
>  
> -	r = -EFAULT;
>  	if (copy_to_user(entries, cpuid_entries,
>  			 nent * sizeof(struct kvm_cpuid_entry2)))
> -		goto out_free;
> -	cpuid->nent = nent;
> -	r = 0;
> +		r = -EFAULT;
>  
>  out_free:
>  	vfree(cpuid_entries);
> -out:
>  	return r;
>  }

Please [partially] disregard my comment on PATCH 02

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

