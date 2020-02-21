Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF40B16811A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgBUPFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:05:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23953 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728690AbgBUPFA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 10:05:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582297499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yTmEd9xc6G7csgDjNYZkoTzDRVdt6RCq+o8/c5+8RkI=;
        b=fF0CrdkfGe45lh7JtImRMiDeSAUdTO3dkHOEaS/k7CqmdTWW/tbeXwR7qOsCK7DtwgEUBv
        DpQ0dHL/Tid9JZoaLhrxC3Rx3TrLeMqd3Bq+5J8nTI+MAhVSnAGZTLry9RVLZgXi+BU+Am
        d9XIgC2s/u69+RaTFhxGDhrqTdiCcaE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-MMKuBgmaN3Wpy4E0zEM-sg-1; Fri, 21 Feb 2020 10:04:56 -0500
X-MC-Unique: MMKuBgmaN3Wpy4E0zEM-sg-1
Received: by mail-wm1-f71.google.com with SMTP id p26so720999wmg.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:04:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yTmEd9xc6G7csgDjNYZkoTzDRVdt6RCq+o8/c5+8RkI=;
        b=tADBAuNpkM6FBYIUE3HvwbuUHN9JKQ00XxVdsrJdn5hb8vSzcmbfhRqYuNh82O9cWh
         q7JGmv4ltg6znEHVtTvvIrIWSpMZSeO0DgtS59XCiFqWzpz5UQObVYeMHdRetynSPXA+
         FwErS4qbUnXBL4EzU6BqexEb19B1HYxDE4YKS7UHt6y9Ny6GoNXj7DBlBUmZN+sfE8F0
         tLe/R+h8GTmAB7Ppt++JL53aQH8O/TokMHGR8P2aPUE20W3uE/aaQ3GhCMQ2YyvUCmUI
         ebYxnXDCi1Ru4EGoD5mZegCms5HTmdFG9q0p2DwP3xeQECLdY2hSFG3UNSkD7HPprefL
         ftfA==
X-Gm-Message-State: APjAAAXHV17gzwpQ6ssDZ5c6X8KALb8EGkbtM/vv0KKz7REkL/I1LM9f
        ck7OrHZknRK3heA8b0OX8Phb4hKUJ2WjuxeQIcvT0BaO5MXR/9zoAdvlwgipwSESGs9oUi32V+5
        OFGo4roCRzKV4
X-Received: by 2002:a5d:5647:: with SMTP id j7mr49375696wrw.265.1582297495748;
        Fri, 21 Feb 2020 07:04:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyi44kZL/ZGQMOMG/lXjt2ZRHdP4xnGFQQxWU89Ax6rGaeN+aFAthHOQCoYiqw1R5vHV/3FXA==
X-Received: by 2002:a5d:5647:: with SMTP id j7mr49375673wrw.265.1582297495544;
        Fri, 21 Feb 2020 07:04:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a26sm4147958wmm.18.2020.02.21.07.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:04:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/61] KVM: x86: Use common loop iterator when handling CPUID 0xD.N
In-Reply-To: <20200201185218.24473-19-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-19-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:04:54 +0100
Message-ID: <87sgj4q8vd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use __do_cpuid_func()'s common loop iterator, "i", when enumerating the
> sub-leafs for CPUID 0xD now that the CPUID 0xD loop doesn't need to
> manual maintain separate counts for the entries index and CPUID index.
>
> No functional changed intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6516fec361c1..bfd8304a8437 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -634,7 +634,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		}
>  		break;
>  	case 0xd: {
> -		int idx;
>  		u64 supported = kvm_supported_xcr0();
>  
>  		entry->eax &= supported;
> @@ -658,11 +657,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->ecx = 0;
>  		entry->edx = 0;
>  
> -		for (idx = 2; idx < 64; ++idx) {
> -			if (!(supported & BIT_ULL(idx)))
> +		for (i = 2; i < 64; ++i) {
> +			if (!(supported & BIT_ULL(i)))
>  				continue;
>  
> -			entry = do_host_cpuid(array, function, idx);
> +			entry = do_host_cpuid(array, function, i);
>  			if (!entry)
>  				goto out;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

