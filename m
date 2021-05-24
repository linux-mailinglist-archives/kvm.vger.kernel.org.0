Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B388138E699
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhEXMbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 08:31:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232503AbhEXMbF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 08:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621859377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MF/OZbyChnf7NefLWpOKRbGY5MjAOqZmWg+o3M3i8A8=;
        b=NyL+kfzGEYY3RZlyh+X3mZlmstSpSnOVZbzRCYyFo5un3Rl9M/ZNdoWVq2CPKIFNa0DDgo
        avF58E5GpAeJRgmOWXXafdv5RKKUS6IJNrUj4pdPNzZaCsdLHqb/oOjQD8hGOXzV+BCQUq
        cIXnAa5Zul+us2Nh+uUs68fEW2fWj48=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-H_9l4njvMlqLFGIAu_P3NA-1; Mon, 24 May 2021 08:29:35 -0400
X-MC-Unique: H_9l4njvMlqLFGIAu_P3NA-1
Received: by mail-ej1-f69.google.com with SMTP id m18-20020a1709062352b02903d2d831f9baso7476312eja.20
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 05:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MF/OZbyChnf7NefLWpOKRbGY5MjAOqZmWg+o3M3i8A8=;
        b=KJMn9vRr2ljQg9gL44JvebWw/jzlvJyENmluOCOafPDywERj/iY0e3ga06UDjX6LPo
         aomD5uAKtk2z0GEVDUXpuDRPx3ynh72e12Ho07hCdBkKKQQVDWsiH0FB5fB595oCM4ek
         Ug58SiI+mCcZ0Wa/fxZtT7lqtNn1tL2nAMuFAaBvvKZ7JOU3g4LN/WddAAHDkIhWN+3Z
         ckDO1AlreHRAwLEp40InqXnRqErUF3a/t8CWXOE7nSQJZJcCPKfTAYn5vx4Fh9gs/+oD
         W4MmxB2Yr80Dq0U/1qAXg063qn7GxsH5Jk+rwB8N6em7K0uwyHJjhzdYkFtftp8TBswG
         JdQQ==
X-Gm-Message-State: AOAM532qIDZmZ+G91Ouhef91aEY+q4FyDeN1qXqY5cNdebr90n6h5YBY
        BNudYzVqNO5z1lTVqoEQ7kkLRoUklLmTiAj/A6xTSBCXLK8A1HspV65KWNNlPIZKe+hEscKapUW
        x5/05zEMysMt9
X-Received: by 2002:a17:906:a0a:: with SMTP id w10mr23066248ejf.416.1621859374594;
        Mon, 24 May 2021 05:29:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycsnShuJqQ9FXZ6dWkQDbxNdD9tWWnao+pMnZmWDe96PE9gC/dNyHSgTXXNr/kd9G8JHMUKA==
X-Received: by 2002:a17:906:a0a:: with SMTP id w10mr23066229ejf.416.1621859374440;
        Mon, 24 May 2021 05:29:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t23sm9432789edq.74.2021.05.24.05.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 05:29:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <98671460-e0db-3f04-ce4f-157f133c82a0@redhat.com>
Date:   Mon, 24 May 2021 14:29:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/05/21 18:43, Tom Lendacky wrote:
> When processing a hypercall for a guest with protected state, currently
> SEV-ES guests, the guest CS segment register can't be checked to
> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
> expected that communication between the guest and the hypervisor is
> performed to shared memory using the GHCB. In order to use the GHCB, the
> guest must have been in long mode, otherwise writes by the guest to the
> GHCB would be encrypted and not be able to be comprehended by the
> hypervisor. Given that, assume that the guest is in 64-bit mode when
> processing a hypercall from a guest with protected state.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/kvm/x86.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..e715c69bb882 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
> -	op_64_bit = is_64_bit_mode(vcpu);
> +	/*
> +	 * If running with protected guest state, the CS register is not
> +	 * accessible. The hypercall register values will have had to been
> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
> +	 */
> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>   	if (!op_64_bit) {
>   		nr &= 0xFFFFFFFF;
>   		a0 &= 0xFFFFFFFF;
> 

Queued, thanks.

Paolo

