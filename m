Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82F8155B3B
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgBGP4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:56:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726936AbgBGP4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581090994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmOUMNOe+ha2CV99jLyY9keQ7RrGgOD5w7R2KXxGhFU=;
        b=K/JRbB+csQ2K9kADD7sqKgMcypGEblFVSfATM6A0mJzEu3T/L3o8lBXjIzNrFQx63cI2K8
        Ohdx2iZyzrx8N1DgPABp1lUIgH0AYlJ1Ss0yGxrSKhwHxl7TGcOMWkKy46ZnQiWWAqzhoQ
        D3JzE10nr5hV4GwMPqWn0BAmqvYBdko=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-Q3YCCPHDOyWsqGgZth4vPw-1; Fri, 07 Feb 2020 10:56:32 -0500
X-MC-Unique: Q3YCCPHDOyWsqGgZth4vPw-1
Received: by mail-wr1-f69.google.com with SMTP id c6so1449137wrm.18
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 07:56:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qmOUMNOe+ha2CV99jLyY9keQ7RrGgOD5w7R2KXxGhFU=;
        b=WJgyKlfjiwNhKdAt8+ilQ2sQGImZPVwrp2EJ6bf2qDQ1pN0qggVECfgfEg+NwtB8Oo
         tKJPbrSq4ICfwU89j05X1HGBVAFlQpEVZ63E0s6UUbVt+aBWvwhO6hKVogAB8TalOuyw
         9DdOSQCGHiq0PRpxARkpwNt/Iyz+pRKTYMbs0q5yi7vR8X/Wz9eRZA/Kk87ClaJARrAb
         Qq7vFhujB3iDObR7CNU1fnp4IuVdc8EEd9DWUBoUC8yt/GDWFCyg9v/z6hVk5105fnpH
         61YpyVtln1Sxd8RYaWfNHCT+gNo+ouFFydLRztPiVZvfykCQutabtYspawL9GV79uIFk
         VrUQ==
X-Gm-Message-State: APjAAAWcaQ5DX7evvXLIVuE6f88ZWBP8ivXB4u63+9JT7/mvOYQLBZZB
        DjZfXrzxKFqZgTz9mdy7yXKV0YJaZUyK5p9aMazpUAvhrpMDfVdm36Y4v/4zpzKCdjU3vNzdrXv
        yD+3UsZws6tOw
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr5678666wrt.229.1581090991475;
        Fri, 07 Feb 2020 07:56:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1rGthp3Ae94Af5kH6GGn1xzAMy3oVIL5FslhKcZp1NzeM9VWWfxT91/XIOBJNpbWv7uFiJQ==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr5678644wrt.229.1581090991179;
        Fri, 07 Feb 2020 07:56:31 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h13sm4350600wrw.54.2020.02.07.07.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:56:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 09/61] KVM: x86: Refactor CPUID 0xD.N sub-leaf entry creation
In-Reply-To: <20200201185218.24473-10-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-10-sean.j.christopherson@intel.com>
Date:   Fri, 07 Feb 2020 16:56:30 +0100
Message-ID: <878sleqtld.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Increment the number of CPUID entries immediately after do_host_cpuid()
> in preparation for moving the logic into do_host_cpuid().  Handle the
> rare/impossible case of encountering a bogus sub-leaf by decrementing
> the number entries on failure.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 424dde41cb5d..6e1685a16cca 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -677,6 +677,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  				goto out;
>  
>  			do_host_cpuid(&entry[i], function, idx);
> +			++*nent;
>  
>  			/*
>  			 * The @supported check above should have filtered out
> @@ -685,12 +686,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  			 * reach this point, and they should have a non-zero
>  			 * save state size.
>  			 */
> -			if (WARN_ON_ONCE(!entry[i].eax || (entry[i].ecx & 1)))
> +			if (WARN_ON_ONCE(!entry[i].eax || (entry[i].ecx & 1))) {
> +				--*nent;
>  				continue;
> +			}
>  
>  			entry[i].ecx = 0;
>  			entry[i].edx = 0;
> -			++*nent;
>  			++i;
>  		}
>  		break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

