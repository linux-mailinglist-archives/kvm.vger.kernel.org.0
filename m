Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8723F38E837
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhEXOCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60252 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232462AbhEXOCe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621864865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwWf1vyRysKqfUVnEXiexxxNd7Eht8UG5rITC/o0zqw=;
        b=HH+1zVeW5Oq9G/HmxMWas0Qf1UxpSzziXcxa6YDW2DDsbUpdjSnZOCmemPREEWD240302x
        nK9yXnQ43IBpjMspq06EroK9IxE0dWn18gm6L5elhxsgDwrCGHJb/LRSxqlnzbifr8NN1J
        BHM1JQH0kean3T3WDlbHyXNn8eZq81g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-BWtbOYvaPOemQnupIjGM9w-1; Mon, 24 May 2021 10:01:03 -0400
X-MC-Unique: BWtbOYvaPOemQnupIjGM9w-1
Received: by mail-ej1-f70.google.com with SMTP id eb10-20020a170907280ab02903d65bd14481so7297598ejc.21
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwWf1vyRysKqfUVnEXiexxxNd7Eht8UG5rITC/o0zqw=;
        b=nsojk9S1SILbKCI+B7VBtOAf7709TTvKE1yoGtPHaoTTPR8Fii3X6kx1kJhmtc5IP9
         cnqK+RPPOB8Z8dj5gC0Uf7hAvqKErkMiAQC2DdzRRjbr8B0x9yFi1js/2qI/opNnq7yh
         xemC4/Jm3aCx0xpMFj9gQvGatorRkY5LcZWvFM0O19T8+EbE1ZKKiS+8KPcE/oDFC6NR
         aVK0pJ2ZiwvyHoPPJZ2NNCQ++WsyzqLVkNOmAMa5Dc79ctSZSNIwFoGggBVG+NII8CoO
         26DCTG5t0xVVE2wVcnUc2DrphslVXVn4fhOY1G4Li8ef6b24sHyTp3AnTEQDZ/Zy9bur
         OIgg==
X-Gm-Message-State: AOAM530Hr76VFe4TzuQniszeA8bZeY6X7B6nRgF1YCXj+PldLFK5jkxC
        tV8nd4F5xdwh3rwqsgjC6t6c5haB3AJT16XGwHlYrCaCdlr5+L5GnLOHh0LDNO5Zy0lMiVfCVHn
        hmrBFPv5Zr8hL
X-Received: by 2002:a17:907:2855:: with SMTP id el21mr23669864ejc.153.1621864862678;
        Mon, 24 May 2021 07:01:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXWrtswKAqeoybWvPotrUZS10KPKWcpDhD0D67f+0mFJAMaPQ94YYvTxfkA5nOMzyUhx55CA==
X-Received: by 2002:a17:907:2855:: with SMTP id el21mr23669841ejc.153.1621864862477;
        Mon, 24 May 2021 07:01:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm7979264ejk.97.2021.05.24.07.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 07:01:01 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210517135054.1914802-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a8be89e-83e4-f9e8-698f-85a7cff76e8d@redhat.com>
Date:   Mon, 24 May 2021 16:01:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517135054.1914802-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/21 15:50, Vitaly Kuznetsov wrote:
> Changes since v1 (Sean):
> - Drop now-unneeded curly braces in nested_sync_vmcs12_to_shadow().
> - Pass 'evmcs->hv_clean_fields' instead of 'bool from_vmentry' to
>    copy_enlightened_to_vmcs12().
> 
> Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
> migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>   + WSL2) was crashing immediately after migration. It was also reported
> that we have more issues to fix as, while the failure rate was lowered
> signifincatly, it was still possible to observe crashes after several
> dozens of migration. Turns out, the issue arises when we manage to issue
> KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
> to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
> the flag itself is not part of saved nested state. A few other less
> significant issues are fixed along the way.
> 
> While there's no proof this series fixes all eVMCS related problems,
> Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
> crashing in testing.
> 
> Patches are based on the current kvm/next tree.
> 
> Vitaly Kuznetsov (7):
>    KVM: nVMX: Introduce nested_evmcs_is_used()
>    KVM: nVMX: Release enlightened VMCS on VMCLEAR
>    KVM: nVMX: Ignore 'hv_clean_fields' data when eVMCS data is copied in
>      vmx_get_nested_state()
>    KVM: nVMX: Force enlightened VMCS sync from nested_vmx_failValid()
>    KVM: nVMX: Reset eVMCS clean fields data from prepare_vmcs02()
>    KVM: nVMX: Request to sync eVMCS from VMCS12 after migration
>    KVM: selftests: evmcs_test: Test that KVM_STATE_NESTED_EVMCS is never
>      lost
> 
>   arch/x86/kvm/vmx/nested.c                     | 110 ++++++++++++------
>   .../testing/selftests/kvm/x86_64/evmcs_test.c |  64 +++++-----
>   2 files changed, 115 insertions(+), 59 deletions(-)
> 

Looks good, I'm possibly expecting a v3 depending on what you think 
about my patch 1 suggestion.

Paolo

