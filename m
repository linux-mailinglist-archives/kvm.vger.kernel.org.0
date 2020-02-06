Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4B1547FF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgBFPY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:24:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50478 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727742AbgBFPYz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 10:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581002694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDikhD16Evvn1Sryhm3WQZr7k9nYSi7+3qLuDWiD+FI=;
        b=MXK8N1DprrE3kZJjg9zYnPcprnIFyquLHGkk9w1oN9z76bUOxTGHArE2HSdjjn8YlixEow
        K6VLbADpAP48xy8smru6Cg0EShPfeYlh2koAlCtbOoRr8Z3vWXPYGJw+u0Dvx+npeHcR3n
        PKaeTGASHtq64JbzMVLnZivbQcrTDfo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-jkx7J_TkNWe5YxXddgeE2A-1; Thu, 06 Feb 2020 10:24:51 -0500
X-MC-Unique: jkx7J_TkNWe5YxXddgeE2A-1
Received: by mail-wr1-f71.google.com with SMTP id s13so3559053wru.7
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 07:24:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VDikhD16Evvn1Sryhm3WQZr7k9nYSi7+3qLuDWiD+FI=;
        b=At/M+HcUMT+83RVHZn6zNaEJOrPkTazXI7OdxZXclNA0W7G6sK68oKW01OJoKmUcA8
         Dx6GhxDLSbUQGelrmB9uBzt/yZ0mTXsizPeA06d/ZUE0A8EDDYGTLGuOYVF0PeaNdpzW
         JzkFipEAabFeqp/GE8K0yBa5eFJnKBjqjdr0rEmghgLSPr0VI56QWKJ7cqgaurOTnDRF
         51ke13mkANgpu0ECsKyZLPv/n91lmuicFs1ypaBWytmpUUJEeS14zQGrvgogsF6d3oLH
         UqtR+xQ857Jbz++zfsmx3YZgtLL6bxpy+Bv2Q4XDLO9p6f8JpsHrLp0u8kf5DAWrHFk8
         cqYQ==
X-Gm-Message-State: APjAAAXW455ed93uo2ENE+9cvzeFYwEWqCQR9lPITC2rMXdWpZRHnXb3
        fWC1ubtweQ5F6s3Tx5oayk9ipFI4xoF2NfZ0mhyLqM/GAcFaBHzSOOb4adPR5OF4xfWJMtabXz/
        O8JBLhhAAp8Bn
X-Received: by 2002:a5d:5706:: with SMTP id a6mr4360392wrv.108.1581002690140;
        Thu, 06 Feb 2020 07:24:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDfgeM519VoXEHCNZuvgRVP3rjGryo/TbI5trM9zUhz8/cXUgb/b8aGM99u2lpQAJWzti+PA==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr4360377wrv.108.1581002689876;
        Thu, 06 Feb 2020 07:24:49 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id w7sm3991741wmi.9.2020.02.06.07.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 07:24:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 05/61] KVM: x86: Check userapce CPUID array size after validating sub-leaf
In-Reply-To: <20200201185218.24473-6-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-6-sean.j.christopherson@intel.com>
Date:   Thu, 06 Feb 2020 16:24:48 +0100
Message-ID: <87k14zg2m7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Verify that the next sub-leaf of CPUID 0x4 (or 0x8000001d) is valid
> before rejecting the entire KVM_GET_SUPPORTED_CPUID due to insufficent
> space in the userspace array.
>
> Note, although this is technically a bug, it's not visible to userspace
> as KVM_GET_SUPPORTED_CPUID is guaranteed to fail on KVM_CPUID_SIGNATURE,
> which is hardcoded to be added after the affected leafs.  The real
> motivation for the change is to tightly couple the nent/maxnent and
> do_host_cpuid() sequences in preparation for future cleanup.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 11d5f311ef10..e5cf1e0cf84a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -552,12 +552,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  		/* read more entries until cache_type is zero */
>  		for (i = 1; ; ++i) {
> -			if (*nent >= maxnent)
> -				goto out;
> -
>  			cache_type = entry[i - 1].eax & 0x1f;
>  			if (!cache_type)
>  				break;
> +
> +			if (*nent >= maxnent)
> +				goto out;
>  			do_host_cpuid(&entry[i], function, i);
>  			++*nent;
>  		}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

