Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F19939FC8B
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhFHQ3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:29:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232874AbhFHQ3d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 12:29:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623169660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=asiVDrcr3C9UCU4OkZBTmAXK+wgy0ErQseo2MDm6t8Q=;
        b=LJmg5I+36bsmCDS2GTPLkczCQXBgPmnSsJSlPZw2ZnbQy/yp5aNUnU7rvHP+r5PAT35BtY
        JbLHYYNlV522qoFq2mVFYrFzgFqxIncRVYkMaYoeOZKSMzyAzBes7qfLTvYusdjeta4OZr
        S/YefF0vlxe0+hYSxUVVFlobgJ5AV0c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-ynH7cl6TOa6BTaXE11e2xw-1; Tue, 08 Jun 2021 12:27:39 -0400
X-MC-Unique: ynH7cl6TOa6BTaXE11e2xw-1
Received: by mail-wr1-f71.google.com with SMTP id v15-20020a5d4a4f0000b0290118dc518878so9693420wrs.6
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 09:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=asiVDrcr3C9UCU4OkZBTmAXK+wgy0ErQseo2MDm6t8Q=;
        b=KPkMOMW9xfKtsmmMPYiZ/TkaYQprillR6JyThoHVTj8m9ORvGM6zN9ba2CNgbxSAlr
         fnwuSw0dYn4PMtb8EhYFzIWLaa9y3UhEGZCWGVnCSBEltD7ebugrKeN0K5Ihh1TdYEqE
         jENdLL0FE5PNzZGLcVK3aDejmRaO+dbFFPdzQeZ4jNDQ5QOWifNkVuQ5Zdfo3awrTTjx
         rW+MdcEv/YWf8rEb0ljAIM7hcHJc9KdFhJ3DCD3Ayq7niPlIqFhRSyJNDpkk5BjWZYh0
         87OGFefDbay5Tqu65/UOWMkn/glXMDIzicV4jr/S3265e5Efu4nu7dBEjLPqiXRDkXVZ
         mIxQ==
X-Gm-Message-State: AOAM532PVU0rbuDQKHfIOUVZSHn1K0VDEg/rj7tfX9r3/epZeu7byb4f
        /fMyXKVecMlbGmWxG9Oh2VLvFzrCecRaMGmRs1GAmUxFvSbimQOyKSLxbLo7mpl194j3R6kT9Pd
        ZoNjUXNksblEX
X-Received: by 2002:a1c:6a09:: with SMTP id f9mr5106791wmc.91.1623169657866;
        Tue, 08 Jun 2021 09:27:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx224q959eBxyvmX7Lh/dIzHMfwSAHno7UOD8fFKKC0gSqJA6B+xZpK+RKOzj/QWplseMAhfw==
X-Received: by 2002:a1c:6a09:: with SMTP id f9mr5106777wmc.91.1623169657651;
        Tue, 08 Jun 2021 09:27:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z11sm19581679wrs.7.2021.06.08.09.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 09:27:37 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: X86: Let's harden the ipi fastpath condition
 edge-trigger mode
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <24c86369-4308-9480-4f7f-7d4131fc9bab@redhat.com>
Date:   Tue, 8 Jun 2021 18:27:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 09:19, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Let's harden the ipi fastpath condition edge-trigger mode.

This is not a good commit message...  And if it's a bug, it needs a 
kvm-unit-tests testcase.

Paolo

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b594275..dbd3e9d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1922,6 +1922,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
>   		return 1;
>   
>   	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
> +		((data & APIC_INT_LEVELTRIG) == 0) &&
>   		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
>   		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
>   		((u32)(data >> 32) != X2APIC_BROADCAST)) {
> 

