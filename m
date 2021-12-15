Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126EC475E3F
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 18:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhLORKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhLORKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 12:10:50 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C30DC061574;
        Wed, 15 Dec 2021 09:10:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id i12so17113946wmq.4;
        Wed, 15 Dec 2021 09:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jPrcXIAKUXdgbqYQT7ifhzRiEp+36aXQ43SwBiQ1re4=;
        b=ZeobJ8YaeIKiAKXQzpfjvrUhBjk7tHtuKw1obwva6rIa0lx6YOTZhuhn7y6Xw3x/Y3
         BZ0FV5cOtSPIx/oP8mgRpbTpMuSlSnFxQwDNa0Bj7mQVbJuI3FZFmm9PNhE8zHxo+l+9
         kKBcZxeZR7tVRYY9iOrHfwq5nXDWsFMgh86fPuXvPXuS/sUyAC+EBeLScoztXPUSqspy
         FxTnNloBmJ2x8S3VkB43pZJrQ5iCVzc7o7g9BBwzRT2lAbsdiGbCSEDyhaaihrv2m+MD
         8MMEhoRLuOSGmBD2p8mcxN5nl7170GH4CNSjix+yxYMnaXuqhrrQ99jahjWuj6Z6ePbF
         Li4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jPrcXIAKUXdgbqYQT7ifhzRiEp+36aXQ43SwBiQ1re4=;
        b=a80cp6+KkU4F1PQU97DsyQ/tnkrkk2TD5Q2rByxKu+kNhG6Uop+lXyZLlJNz/yGqhV
         PlI0WxIWFbbMpEyZTYlDVRJFObcp32tPEEylQmXRK0Xmj8MwKn8ypBQhm0ybpNPlCce8
         lmHrIlUv/vnzj5ttaEpAuzCzyuYVJtJfitJsx0DU7dKGKPOwEEnsDWRLSL494GWgQ9ie
         1A97v3wJ+pKF4s3llKa4J3k0K4YzirwB6tz+RdMySQrloncC5EshBAHI7Tw5tGXqyzBk
         ZpthisJxO7RDbR5/T3PJ7JbYTunyZvkBy/tcROMaz/DRq53Ih6cA1SMBESgktnHiy+Xf
         8P8w==
X-Gm-Message-State: AOAM530IWEshWRKOlqqdVsHHDEU3sWw4U+KKlsvuWkzwv0PvWeObeThA
        UoBxCgw/XVH27BuIdD3qS5E=
X-Google-Smtp-Source: ABdhPJy32pSK435CDeOwv7smQJnzWuMfzWfckULNbhGlVwhi02OjBlm5M7IJyrA4ipNBzXWO50nu0A==
X-Received: by 2002:a7b:c76e:: with SMTP id x14mr859608wmk.27.1639588248919;
        Wed, 15 Dec 2021 09:10:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id g16sm2814329wmq.20.2021.12.15.09.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:10:48 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <45f712da-3759-f142-b416-2235ee9f36fe@redhat.com>
Date:   Wed, 15 Dec 2021 18:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the guest
 CR3 is dirty
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-12-jiangshanlai@gmail.com>
 <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
 <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
 <YbobskOcbRWMFmwb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YbobskOcbRWMFmwb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 17:45, Sean Christopherson wrote:
> The better place for this is the path in vmx_set_cr0() that handles EPT + !URG.
> I believe nested_vmx_restore_host_state(), which is used to restore host state if
> hardware detects a VM-Fail that KVM misses on nested VM-Enter, is also missing a
> call to mark CR3 dirty.
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2f6f465e575f..b0c3eb80f5d5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4426,7 +4426,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
> 
>          nested_ept_uninit_mmu_context(vcpu);
>          vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
> -       kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> +       kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
> 
>          /*
>           * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs

Yes, I agree.  Jiangshan, please send all your fixes tomorrow, or tell 
me if you prefer that I push the reverts to kvm/next.

Paolo
