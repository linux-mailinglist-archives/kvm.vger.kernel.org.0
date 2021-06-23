Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC5C3B21A0
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 22:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFWUPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 16:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhFWUPl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 16:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624479203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zPS5S0IvDFy+C72CmNQKNdIO8Yy6w5eRS/q/XzOp9LU=;
        b=Zo/nNL+Al2J0ISx9ovIsyHBntXQiDxElRBbckF8fqrdSsEcNb1kQ3KHJS8u498nKlQQR/g
        ZhynuQMLa0Vycs1B1xKXsrwZ/W5o3dEY5QS8VnLeJAiNuXsbNtjTDtGd0ABVH+inhvstOd
        wi7mfjdEBjTLUAl9ivV3EitJQnufkq8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-BLRTVRQuNj2Kg8mMO9o6Ug-1; Wed, 23 Jun 2021 16:13:21 -0400
X-MC-Unique: BLRTVRQuNj2Kg8mMO9o6Ug-1
Received: by mail-ej1-f71.google.com with SMTP id l6-20020a1709062a86b029046ec0ceaf5cso1398061eje.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 13:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPS5S0IvDFy+C72CmNQKNdIO8Yy6w5eRS/q/XzOp9LU=;
        b=DEaRk+pEpXRC3Yjzv2+doKHJjkjQJVRW518r9rXLNjViQQR+b0WrohJInNa4Uu5hyg
         w14FeW8USuW39Jzs3nJefsHyBP4qRRhPUgxxYZf2JDSqNqGS0h8QsUJ0zTIQPzfzARPL
         FqMiKoqLl7bcV8tavYTdDgay7UNjMuzbTDmQfdlRwbL0KikIK6N5o+zD3ILwYi68jqkB
         oeauLupp14vPLm5xhAbl7W6jPaK9729/5l/krx27fI/Bosm6d3Gpe02HGUiP5ptJ3sLW
         x0hNt2zVpqhs8E1XEIyqVsRCTpJn1vssgnggKr5q0LYOrGUHBRbL0GWYd/ee65tNpEgU
         YWjA==
X-Gm-Message-State: AOAM5317jjASHjy/72grBhlojh7cEpSx4ZH3WW+z0D9D4Z8oYHsEIVm9
        2ZOg92KLoQ9OZSZhk/OK4c2GCiu/evjUc+CM4ayzuE9XiJcmtXxontQCrVWBoxHcAyAHi7NzXDK
        cQvBrD9vkXOmd
X-Received: by 2002:a17:907:6e9:: with SMTP id yh9mr1853179ejb.86.1624479200511;
        Wed, 23 Jun 2021 13:13:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXz/TF85ocEjS7tKoAxI9Fvz0zQu/S4X4/9uq11pN3P5WQxEpa/XpvRWkiMBf75n30HvN8UA==
X-Received: by 2002:a17:907:6e9:: with SMTP id yh9mr1853165ejb.86.1624479200333;
        Wed, 23 Jun 2021 13:13:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bx11sm292565ejc.122.2021.06.23.13.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 13:13:19 -0700 (PDT)
Subject: Re: [PATCH 47/54] KVM: x86/mmu: Add helpers to do full reserved SPTE
 checks w/ generic MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-48-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d79fe507-44a2-8051-63d3-09469e36bc49@redhat.com>
Date:   Wed, 23 Jun 2021 22:13:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-48-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:57, Sean Christopherson wrote:
> +	/*
> +	 * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
> +	 * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
> +	 * (this is used in hot paths).

Probably s/this is used in hot paths/this is extremely unlikely to be 
short-circuited as true/, since we are at it.

Paolo

> +	 */
> +	return __is_bad_mt_xwr(rsvd_check, spte) |
> +	       __is_rsvd_bits_set(rsvd_check, spte, level);

