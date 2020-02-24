Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F716B3DA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgBXWZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:25:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45840 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgBXWZe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 17:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582583133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bot62eJ1QDSkALNx5M99l4TX45t0SfA6NlI29a+aUK0=;
        b=GeIMog+TEgbrhq4oQLzO1j9L4m/pMXiKKSKk1/FhV/kFvAwNlo9YP/sTL9GQgIMFVDm0pq
        EP8zg06oBIdKFFImohc0x6bUXNzfisLAnj69Ar2l5GJPWK29rD5kNpnnDq1UeQZV8bTrIc
        rpxQCEBwOXBkZxVdXGw+SR8OC0BqyiE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-cQ7l9znmMJ6E-V35SgDLTw-1; Mon, 24 Feb 2020 17:25:27 -0500
X-MC-Unique: cQ7l9znmMJ6E-V35SgDLTw-1
Received: by mail-wm1-f69.google.com with SMTP id 7so309715wmf.9
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:25:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Bot62eJ1QDSkALNx5M99l4TX45t0SfA6NlI29a+aUK0=;
        b=FvvMyaUt5T66jf31zXNfTyth0yWMGbqTb3zpfrf1btqoxnQExVNZJYrRg1Cl0DK3I8
         PiyQhtEFhul+m6JBBG0KnSMlGI/jaB2BobY2R/qGFk6PfpaUS09lSZOTEpx9HvxL4xCN
         mBk3tl4ot+2mwUAp9OErQZKuqAwZhrUJpiepIE6KGHDfikMk6vkQ2HCYocxkJRRFBw6s
         4W3JTLdoBnn71ZiKAm5jn3hTLVy5RkUcNRV137D/vGJE/sOTzHvCMKcaB8+cdCbtajzW
         FFvDeoBmmLZBM5NVyrVLrhF7DwVb0wir2tnz94NdbgPsFnp0jdDn9z0ovrqBJfnDcgOt
         GGUg==
X-Gm-Message-State: APjAAAU9uZczHygshWWuJ64VmJKlOfa2gJqPF2tGPypigr9LtQ8UcXMp
        oVT4drTbyuhHmQ1or0OOzrpDSE192vbydwRnYCNGM3BYXdpW59iKGsK56LEkiUYsOJhK8ihn/uE
        UyqcxmqYH07q4
X-Received: by 2002:a5d:6284:: with SMTP id k4mr70626437wru.398.1582583126670;
        Mon, 24 Feb 2020 14:25:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdW0lbkDcKo6cvmGoaTL3byAKPZzz+xGIZ0lou3jF2Nzg4YqBYrlczj+0NSU2EHCBclycImw==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr70626416wru.398.1582583126397;
        Mon, 24 Feb 2020 14:25:26 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b67sm1206714wmc.38.2020.02.24.14.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:25:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 46/61] KVM: x86: Remove the unnecessary loop on CPUID 0x7 sub-leafs
In-Reply-To: <20200201185218.24473-47-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-47-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:25:24 +0100
Message-ID: <87tv3fmxm3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly handle CPUID 0x7 sub-leaf 1.  The kernel is currently aware
> of exactly one feature in CPUID 0x7.1,  which means there is room for
> another 127 features before CPUID 0x7.2 will see the light of day, i.e.
> the looping is likely to be dead code for years to come.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7362e5238799..47f61f4497fb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -533,11 +533,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
>  
> -		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
> -			if (WARN_ON_ONCE(i > 1))
> -				break;
> -
> -			entry = do_host_cpuid(array, function, i);
> +		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
> +		if (entry->eax == 1) {
> +			entry = do_host_cpuid(array, function, 1);
>  			if (!entry)
>  				goto out;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

