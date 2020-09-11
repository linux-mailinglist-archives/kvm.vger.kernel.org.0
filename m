Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76302665B7
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgIKRL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:11:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726348AbgIKRLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599844266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCrmqBxuZus33kxx8YL4Vlut+6tBeCTGNVK1vsj5srM=;
        b=ZEl9D8cLvt4UbfE0zb3b9i5gn7om9G+2QL6Q/hMzopB5Oi9BMi11JJLabpclkO3h5TA+wE
        qa2zi+MzgaEy0dMXnol/wYu5PojTnxOcg2CnTWLRD05PwapFXj2c53Et7M/NoLK74Wwwl8
        o0m/cSnarZCYFUsalBRA1klUxjQh+Fg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-BwAhOzBSNIGrHmDEyFxLFA-1; Fri, 11 Sep 2020 13:11:04 -0400
X-MC-Unique: BwAhOzBSNIGrHmDEyFxLFA-1
Received: by mail-wm1-f71.google.com with SMTP id x81so1167125wmg.8
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCrmqBxuZus33kxx8YL4Vlut+6tBeCTGNVK1vsj5srM=;
        b=b3m80L3nRbKIkT0ATRpVzxFNTB39BZixHtvZZLK4UF+S7U0Dp8HXP51wsn6HidFfij
         4+w8YrmFzdxHUf1/w0DlX5f4UOmrHo6R7fID76nkiKoMO/QGK5VIKQ4ymQJGMKLP9Rez
         a8dp2Kfs+ByoFktCU77J0aJBuSSkrhgQgdYvrJ3TT6lNS3R5Ln1WJxpQxOvGSg9TtYEx
         FZBaFFsTKgw5rXo+w/ndcc361JT9TFX7h1AwRbSPrR948Btz2y6CH9Xb1VYhHk/3jaku
         +EqD9IPAioHhxzdtYGyLRWvUuHM7yETOXEeyqt261sWtrTu+48v7cz/3Sda8Uhaf3yHw
         WDyg==
X-Gm-Message-State: AOAM530zxI7cmy15cGdZR1a6+HyV2dxTTYoR688eWPcFBXzihWQnr/O8
        mpOHW9ED9PULzXf0zocgN2yZksyPrZVXPYzX3HISdRIhSUAZLQmcmCJ20ORJCDrpX1PgdEjIy2u
        oqSW2bo1cj4sR
X-Received: by 2002:a1c:bb88:: with SMTP id l130mr3190579wmf.143.1599844263585;
        Fri, 11 Sep 2020 10:11:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvUUX2l3Kv2FNmVs54pq+VBq7jW8bPIJ3amyhahMsZdt1JqrCR3uD7SW9gyccRbS7G7MRVaA==
X-Received: by 2002:a1c:bb88:: with SMTP id l130mr3190558wmf.143.1599844263262;
        Fri, 11 Sep 2020 10:11:03 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id n14sm5443386wmi.33.2020.09.11.10.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:11:02 -0700 (PDT)
Subject: Re: [PATCH 0/5] Fix nested VMX controls MSRs
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49f9a692-4218-33cf-2d29-0283cac2f1ac@redhat.com>
Date:   Fri, 11 Sep 2020 19:11:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/20 10:56, Chenyi Qiang wrote:
> The first three patches fix a issue for the nested VMX controls MSRs. The
> issue happens when I use QEMU to run nested VM. The VM_{ENTRY,
> EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL and VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS
> in L1 MSR_IA32_VMX_TRUE_{ENTRY, EXIT}_CTLS MSR are always cleared
> regardless of whether it supports in L1. This is because QEMU gets the
> nested VMX MSRs from vmcs_config.nested_vmx_msrs which doesn't expose
> these two fields. Then, when QEMU initializes the features MSRs after
> SET_CPUID, it will override the nested VMX MSR values which has been
> updated according to guest CPUID during SET_CPUID. This patch series
> just expose the missing fields in nested VMX {ENTRY, EXIT} controls
> MSR and adds the support to update nested VMX MSRs after set_vmx_msrs.
> 
> The last two patches are a minor fix and cleanup.
> 
> Chenyi Qiang (5):
>   KVM: nVMX: Fix VMX controls MSRs setup when nested VMX enabled
>   KVM: nVMX: Verify the VMX controls MSRs with the global capability
>     when setting VMX MSRs
>   KVM: nVMX: Update VMX controls MSR according to guest CPUID after
>     setting VMX MSRs
>   KVM: nVMX: Fix the update value of nested load IA32_PERF_GLOBAL_CTRL
>     control
>   KVM: nVMX: Simplify the initialization of nested_vmx_msrs
> 
>  arch/x86/kvm/vmx/nested.c | 79 +++++++++++++++++++++++++++------------
>  arch/x86/kvm/vmx/vmx.c    |  9 +++--
>  2 files changed, 62 insertions(+), 26 deletions(-)
> 

Queued patch 1/4/5, thanks.

Paolo

