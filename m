Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3873B3A2F57
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhFJPc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231374AbhFJPc1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623339029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efu0ovz0vZUhixdvJGO/t500e4Gp3r4qJAzIoFIgwe8=;
        b=i0T1XePKgOsp9v4iga3smCNVLyou88YDFH+NB6PfSn+EmticV1pnPkfgclgDFaECe4IOtw
        WxUVcroxa4st3nzJnzW/DjuPz3zep0ypdI/uF5kvJYPUFg6+5GZ4m5pJVrh7ZUE/Qk97nl
        bJ21+jvP2TXsq2AxY3p/XvVhbZlQkco=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-j8v7iLibNVq7_pWHw0vDgw-1; Thu, 10 Jun 2021 11:30:26 -0400
X-MC-Unique: j8v7iLibNVq7_pWHw0vDgw-1
Received: by mail-wr1-f70.google.com with SMTP id g14-20020a5d698e0000b0290117735bd4d3so1030829wru.13
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 08:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=efu0ovz0vZUhixdvJGO/t500e4Gp3r4qJAzIoFIgwe8=;
        b=ONLki9hpc4nIkOYuiehfHsrTg6t3EwShT3tA08BLlJBV+ruEp+oYB6U9FrllBCAYe9
         70VIVkn9sWsli/QZvNDJAdB9tcPqH65xX0SGihOj6YQOLg8XqYdDHUf9ZxXQ1WbRIaEU
         NlcHgB+l40XfcIqC3kZhcmxUEZTBBAeCoaC2zlCBTXpoHbAWoKX991oHjSWKI65sXyjP
         hlbDYrzLayPABLruUA0LbFbMcEFpR6LjGLm19mjX7qzesCRZZhNQpMJfQRKtYd9bvzeP
         TL1LZDSrZnLIJ1CqF0TTcqOcgM1C2tZEPVvaTrfzcpQjDtZLK1a6MIcvc6gM+O6cU88T
         p6Cw==
X-Gm-Message-State: AOAM533IR9G4PyjkWxtX5pHpGENeF1vmyaHEb7fHrBoIfntMT8ngKYht
        5hV0KPRVXyPFj1IL5S2CxcS6BTwiayZrVFDHyqetjLI6BMqUNttfCXMJ8vxi6wZLtSBjDD4/LUi
        tzev2BOxT1ruH
X-Received: by 2002:adf:e4cf:: with SMTP id v15mr6224472wrm.162.1623339025115;
        Thu, 10 Jun 2021 08:30:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyO53B14NKb+dj8B/WC9SPGoBXPPDQsDU3yXMKCASDihm/CZPI6/WCk940iZg5h2xZjOW8ioA==
X-Received: by 2002:adf:e4cf:: with SMTP id v15mr6224441wrm.162.1623339024898;
        Thu, 10 Jun 2021 08:30:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id x18sm3931783wrw.19.2021.06.10.08.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 08:30:23 -0700 (PDT)
Subject: Re: [PATCH v2 00/30] KVM: x86: hyper-v: Fine-grained access check to
 Hyper-V hypercalls and MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
References: <20210521095204.2161214-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71508674-e20f-f133-3aec-455936d35ff4@redhat.com>
Date:   Thu, 10 Jun 2021 17:30:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 11:51, Vitaly Kuznetsov wrote:
> Changes since v1:
> - Rebase to kvm/next.
> 
> Original description:
> 
> Currently, all implemented Hyper-V features (MSRs and hypercalls) are
> available unconditionally to all Hyper-V enabled guests. This is not
> ideal as KVM userspace may decide to provide only a subset of the
> currently implemented features to emulate an older Hyper-V version,
> to reduce attack surface,... Implement checks against guest visible
> CPUIDs for all currently implemented MSRs and hypercalls.
> 
> Vitaly Kuznetsov (30):
>    asm-generic/hyperv: add HV_STATUS_ACCESS_DENIED definition
>    KVM: x86: hyper-v: Introduce KVM_CAP_HYPERV_ENFORCE_CPUID
>    KVM: x86: hyper-v: Cache guest CPUID leaves determining features
>      availability
>    KVM: x86: hyper-v: Prepare to check access to Hyper-V MSRs
>    KVM: x86: hyper-v: Honor HV_MSR_HYPERCALL_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_VP_RUNTIME_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_TIME_REF_COUNT_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_VP_INDEX_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_RESET_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_REFERENCE_TSC_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_SYNIC_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_SYNTIMER_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_MSR_APIC_ACCESS_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Honor HV_ACCESS_FREQUENCY_MSRS privilege bit
>    KVM: x86: hyper-v: Honor HV_ACCESS_REENLIGHTENMENT privilege bit
>    KVM: x86: hyper-v: Honor HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
>      privilege bit
>    KVM: x86: hyper-v: Honor HV_FEATURE_DEBUG_MSRS_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Inverse the default in hv_check_msr_access()
>    KVM: x86: hyper-v: Honor HV_STIMER_DIRECT_MODE_AVAILABLE privilege bit
>    KVM: x86: hyper-v: Prepare to check access to Hyper-V hypercalls
>    KVM: x86: hyper-v: Check access to HVCALL_NOTIFY_LONG_SPIN_WAIT
>      hypercall
>    KVM: x86: hyper-v: Honor HV_POST_MESSAGES privilege bit
>    KVM: x86: hyper-v: Honor HV_SIGNAL_EVENTS privilege bit
>    KVM: x86: hyper-v: Honor HV_DEBUGGING privilege bit
>    KVM: x86: hyper-v: Honor HV_X64_REMOTE_TLB_FLUSH_RECOMMENDED bit
>    KVM: x86: hyper-v: Honor HV_X64_CLUSTER_IPI_RECOMMENDED bit
>    KVM: x86: hyper-v: Honor HV_X64_EX_PROCESSOR_MASKS_RECOMMENDED bit
>    KVM: selftests: move Hyper-V MSR definitions to hyperv.h
>    KVM: selftests: Move evmcs.h to x86_64/
>    KVM: selftests: Introduce hyperv_features test
> 
>   Documentation/virt/kvm/api.rst                |  11 +
>   arch/x86/include/asm/kvm_host.h               |   9 +
>   arch/x86/kvm/hyperv.c                         | 216 +++++-
>   arch/x86/kvm/hyperv.h                         |   1 +
>   arch/x86/kvm/x86.c                            |   4 +
>   include/asm-generic/hyperv-tlfs.h             |   1 +
>   include/uapi/linux/kvm.h                      |   1 +
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../kvm/include/{ => x86_64}/evmcs.h          |   2 +-
>   .../selftests/kvm/include/x86_64/hyperv.h     | 185 +++++
>   .../selftests/kvm/x86_64/hyperv_clock.c       |   8 +-
>   .../selftests/kvm/x86_64/hyperv_features.c    | 649 ++++++++++++++++++
>   13 files changed, 1071 insertions(+), 18 deletions(-)
>   rename tools/testing/selftests/kvm/include/{ => x86_64}/evmcs.h (99%)
>   create mode 100644 tools/testing/selftests/kvm/include/x86_64/hyperv.h
>   create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_features.c
> 

Queued, thanks.

Paolo

