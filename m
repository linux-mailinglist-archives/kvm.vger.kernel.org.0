Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843AC2FEDDA
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbhAUPB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:01:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729582AbhAUPBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611241188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWveDnvQfP+PsL4unltCL6r/BDFmk40wyGsyzqSzMPQ=;
        b=CCV4+O9MlTuQUe1mf3BRsmYSXkTVJrwXD28BL5o9jiwF6t3iIpV1y7/zALZWczYkxwuFgD
        RK6tZsrdufBfmUxoULpOfDM9gYLu7RYXHkoIVLlifH6LeB026wvR5Vke2gP+ychj61Jz7E
        h2tza4R+lEwi04XSsH0vqq7QtcT5/r0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-WYUQ2L4xNx-dE-smL_vhBA-1; Thu, 21 Jan 2021 09:59:46 -0500
X-MC-Unique: WYUQ2L4xNx-dE-smL_vhBA-1
Received: by mail-ej1-f69.google.com with SMTP id f26so860660ejy.9
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 06:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VWveDnvQfP+PsL4unltCL6r/BDFmk40wyGsyzqSzMPQ=;
        b=MP5pBpceT2DVXSvDtsD9pkByQXebVLx+dBbjKiTcJvbuI49TqlfbQltf41lV+aGXgQ
         nNsK6Wdi+6yBJMVdJnsfWrl+k8cDIPn7qE3SsTZt8ee7I7VBoZwIKOGiF+wHWdLMNDje
         vVWH0bYWBlsIDlwkkCXKgzhI+S355vt3TtcFgvDDjvRhBmP3dG4r7SFXsikKNO74sU1j
         41NRFWIgSQxP4mEUgf59qazH6bKndfzZ4va9ksY7eF7UCNrN7SBovc+rjlZ0LrmUSXSk
         ScJQSLCRiM5VvE//OWzjT1spWuD40zHwATphsM1hkVMbOdKCERJnUPpUj1zFtL8vNvqh
         fpCg==
X-Gm-Message-State: AOAM532B7Ap9tsI/i6ergUKnGHScHGUA7Ocx6GGrdoz5lFCL1KYgbcO6
        hFhpT3PlqbQSwJgwKR5MvdjHfg7RrHMZpMx63CjWdCanLKeZeKbjbS2a6gIXEcfI4WAXAuQxVP3
        +P3uTvUyoKCDk
X-Received: by 2002:a50:fa86:: with SMTP id w6mr8174047edr.98.1611241184841;
        Thu, 21 Jan 2021 06:59:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzShcRHvjWlak25wOw0kLg65aNYi5H/RRWjjGEc3kLqFCIKI8oid0c0yjtkv6UmnKvGy/pGGg==
X-Received: by 2002:a50:fa86:: with SMTP id w6mr8174036edr.98.1611241184707;
        Thu, 21 Jan 2021 06:59:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id f9sm2905661edm.6.2021.01.21.06.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 06:59:43 -0800 (PST)
Subject: Re: [PATCH v2 1/3] KVM: nVMX: Always call sync_vmcs02_to_vmcs12_rare
 on migration
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
 <20210114205449.8715-2-mlevitsk@redhat.com> <YADarUMsE9uDKxOe@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1aadff70-afed-ba8f-411f-c8aac1518098@redhat.com>
Date:   Thu, 21 Jan 2021 15:59:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YADarUMsE9uDKxOe@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/21 00:58, Sean Christopherson wrote:
> Reviewed-by: Sean Christopherson<seanjc@google.com>  

New commit message:

KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration

Even when we are outside the nested guest, some vmcs02 fields
may not be in sync vs vmcs12.  This is intentional, even across
nested VM-exit, because the sync can be delayed until the nested
hypervisor performs a VMCLEAR or a VMREAD/VMWRITE that affects those
rarely accessed fields.

However, during KVM_GET_NESTED_STATE, the vmcs12 has to be up to date to
be able to restore it.  To fix that, call copy_vmcs02_to_vmcs12_rare()
before the vmcs12 contents are copied to userspace.

Paolo

