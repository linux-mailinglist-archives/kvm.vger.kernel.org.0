Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1424254E5E6
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377162AbiFPPVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376785AbiFPPVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:21:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EC0137015
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655392892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=06juFOw2FxSYc+BHU/Wl3gl3OUWvf0N50iDPfaEDM38=;
        b=eRM+4m1BeohHaygwysYmP02CCx0qkqxgMdPzJBZPRyevui808amMgGlmOLOHpYOO/7iw+k
        JIuqr3oaNNok7hu/M2/Cn+qMhX+gBY52bHsyW3l82jc/8k+UubDNEc5DwkWkqjQfRh1mTU
        JvMvb832G2O0fHsmKwyadquEyQK+/h4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-nMHD8PwsOSeT7lCBIzMrcA-1; Thu, 16 Jun 2022 11:21:30 -0400
X-MC-Unique: nMHD8PwsOSeT7lCBIzMrcA-1
Received: by mail-ed1-f69.google.com with SMTP id x8-20020a056402414800b0042d8498f50aso1461010eda.23
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 08:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=06juFOw2FxSYc+BHU/Wl3gl3OUWvf0N50iDPfaEDM38=;
        b=0w4PBpWh+Wb1mp4yFYYhUKRI5a1gJMtsm4pt3FSFhBypAZGuG3TETtr+bnk9RIUpCz
         SERZ77kqjNES3X5R/3Mg3f67JIF9/QqNVXxIq3bm/jp0WNHrL0CTj8soqIrsBRWbFHOR
         7fZujTiHJjvSQSVw43Tm+y/xlfUQuxMa9hFU5DXlygBYTgniYKCi5fJnDPQag6icAOEV
         BJ/wpkGud+0+CBeM6syEiB6eZWe8zYObGgnm5lsCelsdCpUyCR5vMQlPB9MW0T5co/LB
         DGnVEc7j/0DJsHg8vZ6ZP/cn6UXcg/ufDWieipLiCDUTglnMe3M9sbaWTaUZdW+VOyNT
         aqVA==
X-Gm-Message-State: AJIora+CLwV8iE1ncShLbqXLNZr2mhOPjBrL5peJPmQZW252Jrv3Qppp
        QKPOSzkfs9c5GAh5FyCxbOEeC6pitTrAfTOhLcW4ZDFB6z3bEnxs1si6cdrnwIrBPhIvfBhZi19
        SrznDhwM2g///
X-Received: by 2002:a17:906:7053:b0:711:b90e:47b7 with SMTP id r19-20020a170906705300b00711b90e47b7mr4876478ejj.652.1655392889372;
        Thu, 16 Jun 2022 08:21:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1scUxIqI2Go1RYSFcOPPILRtIJCYm33+w4HHAK64jTkfDW6I9MnDnvZVmp1Mh1gVt+nVMKYPA==
X-Received: by 2002:a17:906:7053:b0:711:b90e:47b7 with SMTP id r19-20020a170906705300b00711b90e47b7mr4876460ejj.652.1655392889166;
        Thu, 16 Jun 2022 08:21:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id kz24-20020a17090777d800b00715a02874acsm911612ejc.35.2022.06.16.08.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 08:21:28 -0700 (PDT)
Message-ID: <99e7513a-af90-46ef-fb65-a9ffd0f925f9@redhat.com>
Date:   Thu, 16 Jun 2022 17:21:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 00/10] KVM: Clean up 'struct page' / pfn helpers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429010416.2788472-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220429010416.2788472-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 03:04, Sean Christopherson wrote:
> Clean up KVM's struct page / pfn helpers to reduce the number of
> pfn_to_page() and page_to_pfn() conversions.  E.g. kvm_release_pfn_dirty()
> makes 6 (if I counted right) calls to pfn_to_page() when releasing a dirty
> pfn that backed by a vanilla struct page.  That is easily trimmed down to
> a single call.
> 
> And perhaps more importantly, rename and refactor kvm_is_reserved_pfn() to
> try and better reflect what it actually queries, which at this point is
> effectively whether or not the pfn is backed by a refcounted page.
> 
> Sean Christopherson (10):
>    KVM: Do not zero initialize 'pfn' in hva_to_pfn()
>    KVM: Drop bogus "pfn != 0" guard from kvm_release_pfn()
>    KVM: Don't set Accessed/Dirty bits for ZERO_PAGE
>    KVM: Avoid pfn_to_page() and vice versa when releasing pages
>    KVM: nVMX: Use kvm_vcpu_map() to get/pin vmcs12's APIC-access page
>    KVM: Don't WARN if kvm_pfn_to_page() encounters a "reserved" pfn
>    KVM: Remove kvm_vcpu_gfn_to_page() and kvm_vcpu_gpa_to_page()
>    KVM: Take a 'struct page', not a pfn in kvm_is_zone_device_page()
>    KVM: Rename/refactor kvm_is_reserved_pfn() to
>      kvm_pfn_to_refcounted_page()
>    KVM: x86/mmu: Shove refcounted page dependency into
>      host_pfn_mapping_level()
> 
>   arch/x86/kvm/mmu/mmu.c     |  26 +++++--
>   arch/x86/kvm/mmu/tdp_mmu.c |   3 +-
>   arch/x86/kvm/vmx/nested.c  |  39 ++++-------
>   arch/x86/kvm/vmx/vmx.h     |   2 +-
>   include/linux/kvm_host.h   |  12 +---
>   virt/kvm/kvm_main.c        | 140 +++++++++++++++++++++++++------------
>   6 files changed, 131 insertions(+), 91 deletions(-)
> 
> 
> base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3

Queued, thanks.

Paolo

