Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E273B1C38
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFWOTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 10:19:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhFWOTJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 10:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624457811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MdpZu0o7ZaWAk08H/jPUVPtESBvGLrn2fcmv09RwUVI=;
        b=e6VhomLs+0xQ69YqXKbsJPpEHJUuSbb0fSP8Psqq0zvhvyq4ev11pxW/Xt/ZW9vuBMOu4g
        IJBHgZ4mZi+Xo+6TUDuJlP7Q+HEqhOEwe+8sdku98F1jbDrXYcSj+3Sem5PDG9L4KP+QqQ
        /1Xehrvko/w3L3OXpdcz0Iyi0VHBFks=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-ZTsHwLb5OEiojBjSsqQzPA-1; Wed, 23 Jun 2021 10:16:50 -0400
X-MC-Unique: ZTsHwLb5OEiojBjSsqQzPA-1
Received: by mail-ed1-f70.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so1405544edv.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 07:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MdpZu0o7ZaWAk08H/jPUVPtESBvGLrn2fcmv09RwUVI=;
        b=H6wdjliUCuu7FoQXzaGuniHiVRMiKD7fkbidTShEJNcI2OrtKllYcvKuNQkVFfenff
         skP+Y9iua7QFW5XzY5K1+grMd964KYDRJbfkdLbUr3iQk94irZwgii3GxHisKgcwKaBq
         qQgZGlzffBiKwG0x6jE+seyPdmk8X1IOdJYp7JV/TMTeYE7G4pWnS2G0eC5SPTcBK9z2
         LRsOttMLH2xjLMPmC7FNjN6oIGOCWWgoM1FyLHKkfVYYF1HnU/f5NMxJvp+j5cfC7zqK
         7c0uxtJBmg80fqdwjjwyjcemVJqVyZXr4WAJP5zV2KcsEB9UIq9kOEqAkpxpZQVn8haA
         AUrg==
X-Gm-Message-State: AOAM531aP0unSm8+sDR/aVOqD2DfafsLEzrxLcbnWIaZBRkD1+lQQH4V
        UbWNaovPTpG/ucB4r+50atj36G9JmsdGXWhJoqnQUbv5laKHLA3V17qmPmYzD0SkOTVvhvfOP3g
        3OizkP62tOlRE
X-Received: by 2002:a17:906:4a55:: with SMTP id a21mr231149ejv.209.1624457808979;
        Wed, 23 Jun 2021 07:16:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9lAMl15cgRez4LOG9KWkUydqqrLbogVo4u/Vl+8budcXaL0bATX7IXkG/cdBkxqpO4ruWKw==
X-Received: by 2002:a17:906:4a55:: with SMTP id a21mr231127ejv.209.1624457808793;
        Wed, 23 Jun 2021 07:16:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d6sm100976edq.37.2021.06.23.07.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 07:16:48 -0700 (PDT)
Subject: Re: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
 after KVM_RUN is broken
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-8-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f031b6bc-c98d-8e46-34ac-79e540674a55@redhat.com>
Date:   Wed, 23 Jun 2021 16:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210622175739.3610207-8-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/21 19:56, Sean Christopherson wrote:
> +	/*
> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> +	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> +	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> +	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
> +	 * sweep the problem under the rug.
> +	 *
> +	 * KVM's horrific CPUID ABI makes the problem all but impossible to
> +	 * solve, as correctly handling multiple vCPU models (with respect to
> +	 * paging and physical address properties) in a single VM would require
> +	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
> +	 * is very undesirable as it would double the memory requirements for
> +	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
> +	 * no sane VMM mucks with the core vCPU model on the fly.
> +	 */
> +	if (vcpu->arch.last_vmentry_cpu != -1)
> +		pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");

Let's make this even stronger and promise to break it in 5.16.

Paolo

