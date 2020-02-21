Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13E116807D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgBUOkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:40:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728923AbgBUOkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 09:40:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582296014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7koPtbeBb5w+hzgMwDrOYC28FFGb3sjxwiIasS6oSIA=;
        b=Smr4PbBAGUmG1nXtyOqhCor/qC7HTrwgxYPbNO7HlD3GIs0Oup1vBytOfh5KxuHsIT8YEZ
        Jwm+1Dzym7lKI8exrfAg2bs+laZREYmQKC7P6HEIN4ZLWXk/2SUibtUc7KE/+w85DB0HTn
        12PbzSjRHz1tpoRogwUtiKeQmEgtefw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-QVlq4CigMm2TiYx5f049UQ-1; Fri, 21 Feb 2020 09:40:12 -0500
X-MC-Unique: QVlq4CigMm2TiYx5f049UQ-1
Received: by mail-wm1-f72.google.com with SMTP id f207so656302wme.6
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 06:40:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7koPtbeBb5w+hzgMwDrOYC28FFGb3sjxwiIasS6oSIA=;
        b=AdANqh3yOtpntue644CBEXZVeiJM1bMPooS0VWoMNpCcNk8zEk8VYBlyqoH8Vb9LnI
         MebKqjyB3rFNILcWefeafqo2JmP7m+IqPkwRROf+/ncYREYNDOfhE2sHHwbcBqec5Agn
         6JHQtgUVu/skZY32juJ+8Vi3vcTqhf3xewjeYzsyPq+DhNelTdibKvc6jw2osw1ZOfPr
         Sa63KAK+IcH3qO7PtWsKr/su5gIxV1zfEuc5hunOnYE6SlKaKhmrndazAfVEYeXh85ZY
         ZdQ7W6/5I6PXINctg//wk+GHtDDNtE9sJg7zWKmvgFsA8ZFJDwd60P5FYkDbCfyEYJwW
         vCEg==
X-Gm-Message-State: APjAAAUXNBgCPZ4swdYjju2akYoAAI/DHFQMlgTx5lWqvr48R6uvYhSd
        NUenIDQppCbMLDJO8uoAcEg8fRZVNdGdSiDmhg3L4AvbbAeBCYYKEfs7QrmqabURq3tqtYND5Up
        M3Xqb8rOhKT9L
X-Received: by 2002:a7b:c190:: with SMTP id y16mr4290502wmi.107.1582296010201;
        Fri, 21 Feb 2020 06:40:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTZLZSlB+bzSFgFQD27t5eSQEei+VCnJrgcq94fiIh6QgLci/t90O3aJHrS+r+nYtPI2JPhg==
X-Received: by 2002:a7b:c190:: with SMTP id y16mr4290480wmi.107.1582296009981;
        Fri, 21 Feb 2020 06:40:09 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r5sm4142186wrt.43.2020.02.21.06.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:40:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/61] KVM: x86: Refactor CPUID 0x4 and 0x8000001d handling
In-Reply-To: <20200201185218.24473-16-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-16-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 15:40:08 +0100
Message-ID: <871rqorol3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Refactoring the sub-leaf handling for CPUID 0x4/0x8000001d to eliminate
> a one-off variable and its associated brackets.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5044a595799f..d75d539da759 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -545,20 +545,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		break;
>  	/* functions 4 and 0x8000001d have additional index. */
>  	case 4:
> -	case 0x8000001d: {
> -		int cache_type;
> -
> -		/* read more entries until cache_type is zero */
> -		for (i = 1; ; ++i) {
> -			cache_type = entry[i - 1].eax & 0x1f;
> -			if (!cache_type)
> -				break;
> -
> +	case 0x8000001d:
> +		/*
> +		 * Read entries until the cache type in the previous entry is
> +		 * zero, i.e. indicates an invalid entry.
> +		 */
> +		for (i = 1; entry[i - 1].eax & 0x1f; ++i) {
>  			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
>  				goto out;
>  		}
>  		break;
> -	}
>  	case 6: /* Thermal management */
>  		entry->eax = 0x4; /* allow ARAT */
>  		entry->ebx = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

