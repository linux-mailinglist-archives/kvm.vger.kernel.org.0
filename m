Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7D3B2182
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFWUEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:04:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20173 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230040AbhFWUEl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624478543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wITQxEls1SBROh7qIbfqzCrqr45KUONEom3x8qAlLc=;
        b=AUzHZmgHugzbyVrguyMVzJ0MK2SyUEn+Tbnf1SyLTLpVecfm7ND/HL+FHB04g4waSIJwVB
        xL18Y6b5/p5iuvDIEtF10l4lS1YKW+lVJ20s1ghVn4cV9k0gQEKv6JGqE/42WxlNQiKaPe
        2emm8H3hX6bR3Tc+LjAW7DPyBJ9yLKk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-I95zkanoNB2bbNdLIr8vUQ-1; Wed, 23 Jun 2021 16:02:14 -0400
X-MC-Unique: I95zkanoNB2bbNdLIr8vUQ-1
Received: by mail-ed1-f71.google.com with SMTP id ee28-20020a056402291cb0290394a9a0bfaeso1934602edb.6
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+wITQxEls1SBROh7qIbfqzCrqr45KUONEom3x8qAlLc=;
        b=P+T36AodA6biInbgrgGvDk95QQQ9/dDGdZWxKSHSqNRd9E6Lz+xkCwofbsasxWGK8u
         2E38SLTIlsZmfOHogR0PwyMmCvkAsaosoCILZyQFyEmW3MC+z+zL04ov8oDShzLXC/K0
         fn8ELZJDxV4uWpUS5ihJTHR46yCRL9vehFJpOej6JgiGXlvUWjy9bMgJUhOfMabITqsE
         VcM0mo7MEBs/rFD1LzemDYhVlnx758nN0PIs+bjxfGXS4vEFcPwlPT3nSzS1R1y23Bp7
         982ulfPTmXBnb1AxTYPSvc5dnJ0ZR8BmJ499XA8tLKrQJttfqa3oO+aJR6m6EW4j5MWa
         omAA==
X-Gm-Message-State: AOAM532X+ZgV7ddqz4g6XhEXx/eI7q9L35wO0zE5jrzjBcDjf1P3vqiH
        E/dLikxrYJlk4McMK4t+d1P7am6Oc2S2j5+qfkRdD5lct1nWazz+/pyB+3N55zeq/EegdlPG7mV
        F0elu+tLPvZ3C
X-Received: by 2002:a17:906:4f14:: with SMTP id t20mr1710310eju.398.1624478532803;
        Wed, 23 Jun 2021 13:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC61FR9h9pqcksmyOBKdVJfV0+wOITLQi948V0/yXZhz/1HFgRKfZp3KQo29MTBit3KtOR6w==
X-Received: by 2002:a17:906:4f14:: with SMTP id t20mr1710293eju.398.1624478532624;
        Wed, 23 Jun 2021 13:02:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id yh11sm296692ejb.16.2021.06.23.13.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:02:12 -0700 (PDT)
Subject: Re: [PATCH 25/54] KVM: x86/mmu: Add helpers to query mmu_role bits
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-26-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1babfd1c-bee1-12e5-a9d9-9507891efdfd@redhat.com>
Date:   Wed, 23 Jun 2021 22:02:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-26-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> +static inline bool is_##reg##_##name(struct kvm_mmu *mmu)	\

What do you think about calling these is_mmu_##name?  The point of 
having these helpers is that the register doesn't count, and they return 
the effective value (e.g. false in most EPT cases).

Paolo

> +{								\
> +	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
> +}
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
> +BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
> +BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
> +BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
> +
>   struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)

