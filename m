Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B2546E770
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhLILVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbhLILVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:21:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA756C061746;
        Thu,  9 Dec 2021 03:17:59 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y13so18279029edd.13;
        Thu, 09 Dec 2021 03:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fo8xWj9D41FfrtS+dBIsbHWboaee5HFZE+LrwQkoquk=;
        b=JANOOX9PXQg9MyLSpE5MXz6+UYgiTld9Px9vmqpvG35e5np+hl8Zt2lcjJlMjImIq1
         kt2W5eL92vLnoz+j73wq7zOX4nKLAwdI0jyMc3DFM4ZhRZpN3msIJ8/UanTCdS8vHRpG
         LvJDVal/jeFawsZyGZOmYO+X9gfZ0YQE33B3TOxdk0vgVARQ9W0K0RqHvjVcuy4/iPSI
         iDvpnh3GI5/M1PRfCufpCL53+8BZt5aXjAsSbihqUA3fKjejqCy1uJAaRh0ivUrZPaV2
         u6eliG+ypU8adf4sHR7df/HeLhqjDVEG4dkXPc7xOma66I2t/yYSQhMOS/dCbWtgUFif
         fkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fo8xWj9D41FfrtS+dBIsbHWboaee5HFZE+LrwQkoquk=;
        b=kheVyVUTZzUFUVeHtJBq1miq1NtCZMfwb1ZADSZSp0RXzbXmUxwA8ai9jD/pKj+MvE
         wWv4N+iIfbvi9fAbwLmvJ5yx8jpXFLO+unPg31AO1NeSudkZh6XYDixfOcmIsKT6ulrP
         CSphXHaKzskxHbtaKk/LK/LI4JolpXuRRTv/PeUGDto1KJ4DjVZaKQd2x/Mltx11zgfH
         5znGxnxaUUV3DzzfkViH+Y0ho1UZLY6OOfeKiKrLKOz5ijG1lnGiLiDLOSsK7u4dUAD6
         ymT+bjaPRQdf5XhaUixy+rSC3HIPw+/LdcSS3fZlZjxH6J03f8byXkmo4M5ALEDisLS7
         hErw==
X-Gm-Message-State: AOAM533lZL1890nYSbmK6UPkCnRbWZTkaspXj0AHaJgxemgHkrVrl14c
        DnyoLUHKAOUz566JGKAHtOf/blOhB7A=
X-Google-Smtp-Source: ABdhPJz2dx4N0511IdZHPLodnRrhg3tWUhYzsom0v3rrLBbF6uvreVwRAdtozgqezbtP/0p1e25+Hw==
X-Received: by 2002:a50:e608:: with SMTP id y8mr28025782edm.39.1639048675798;
        Thu, 09 Dec 2021 03:17:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id ga37sm2685922ejc.65.2021.12.09.03.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:17:55 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5b12fc46-bffb-49dd-8cc7-83ba4e841843@redhat.com>
Date:   Thu, 9 Dec 2021 12:17:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: Wait for IPIs to be delivered when handling
 Hyper-V TLB flush hypercall
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20211209102937.584397-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211209102937.584397-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 11:29, Vitaly Kuznetsov wrote:
> Prior to commit 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use
> tlb_flush_guest()"), kvm_hv_flush_tlb() was using 'KVM_REQ_TLB_FLUSH |
> KVM_REQUEST_NO_WAKEUP' when making a request to flush TLBs on other vCPUs
> and KVM_REQ_TLB_FLUSH is/was defined as:
> 
>   (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> 
> so KVM_REQUEST_WAIT was lost. Hyper-V TLFS, however, requires that
> "This call guarantees that by the time control returns back to the
> caller, the observable effects of all flushes on the specified virtual
> processors have occurred." and without KVM_REQUEST_WAIT there's a small
> chance that the vCPU making the TLB flush will resume running before
> all IPIs get delivered to other vCPUs and a stale mapping can get read
> there.
> 
> Fix the issue by adding KVM_REQUEST_WAIT flag to KVM_REQ_TLB_FLUSH_GUEST:
> kvm_hv_flush_tlb() is the sole caller which uses it for
> kvm_make_all_cpus_request()/kvm_make_vcpus_request_mask() where
> KVM_REQUEST_WAIT makes a difference.
> 
> Cc: stable@kernel.org
> Fixes: 0baedd792713 ("KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - Note, the issue was found by code inspection. Sporadic crashes of
> big Windows guests using Hyper-V TLB flush enlightenment were reported
> but I have no proof that these crashes are anyhow related.
> ---
>   arch/x86/include/asm/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e41ad1ead721..8afb21c8a64f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -97,7 +97,7 @@
>   	KVM_ARCH_REQ_FLAGS(25, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_TLB_FLUSH_CURRENT	KVM_ARCH_REQ(26)
>   #define KVM_REQ_TLB_FLUSH_GUEST \
> -	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
> +	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
>   #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
>   #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
> 

Queued, thanks.

Paolo
