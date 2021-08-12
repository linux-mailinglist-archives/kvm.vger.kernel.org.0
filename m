Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25603EA86F
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbhHLQTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbhHLQT0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 12:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628785139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1iJGFcSXIo7fsYURfDj1C7ozOF5ZGtHhqDGEjWwqzY=;
        b=DyzBBN0KRcsdAtYKUNBEnu89zR/Js63JjksfZe0BGCIB8h+qgQQVerBwbBbPOmmK8fLw5y
        y1jvDBj8LNhdOy4id80PTQWoV07lggDn0tIE4TkdVo/AJ/EKJjE9Zfo1HfQ8OiUXrKvKQA
        sSfN6BtxyYKsnq4r0HWsd3A7S7c7ue8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-_EPZJlEIP9q--kwnZf557w-1; Thu, 12 Aug 2021 12:18:58 -0400
X-MC-Unique: _EPZJlEIP9q--kwnZf557w-1
Received: by mail-ej1-f69.google.com with SMTP id k22-20020a1709061596b02905a370b2f477so2022549ejd.17
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n1iJGFcSXIo7fsYURfDj1C7ozOF5ZGtHhqDGEjWwqzY=;
        b=mfZISp1bkp5AgHcAlZzrDdrlrLnl+pwdHjYSYmFsPj1HXqp/RNdZzDCiGz18AX0lZ2
         BWmteJzkUJkrHU9slEu9oaafzyOWxdiIFguOI3U3UySk0jS0oB/Xgm+ID3RKl2bIvV1v
         2ymN+iLRvSHAJ9pUHpCRPkfNP4pNt/zf1BwUv96JK+w1JHt2hfUtTaYXX+8Bjgb5M+0a
         azM9S16pN91JyVT1tsPDIEAj2rB3Hbjt2xfFEgrejIksL1g2MDwVqoan3ScqIeyL8bwR
         WFP4cPr1X6iOvQoGFMEbqx5EyEQUP9T8PWN5RSmx7Dn0mC8DUvAXGV5FdRd9YJXwYv4J
         GUhA==
X-Gm-Message-State: AOAM530udGtVXzBrM+tt+dzIJ4Rev3So6Cc2rqdsrFhBbTicuxGdvTQx
        cyPWq3prZpmIKDxp6OnxKs1OXi4o31cE64wzUNxgdvqOPCXSKxcv9CBR0ituPN5hzt6ME4zSSRs
        T84QH7GgDkI+/
X-Received: by 2002:a05:6402:5242:: with SMTP id t2mr6442427edd.200.1628785135832;
        Thu, 12 Aug 2021 09:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7wSgHQpiSDM1hKUEJraz1XmkrJWjqsvLz176filHc+rZRFMOpRji0EZdJLglPkHDEyJpHiQ==
X-Received: by 2002:a05:6402:5242:: with SMTP id t2mr6442402edd.200.1628785135681;
        Thu, 12 Aug 2021 09:18:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c8sm974068ejp.124.2021.08.12.09.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:18:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Use vmx_need_pf_intercept() when deciding if
 L0 wants a #PF
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20210812045615.3167686-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b250262-9ba8-0753-1dd2-0b0d4b5d0186@redhat.com>
Date:   Thu, 12 Aug 2021 18:18:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812045615.3167686-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 06:56, Sean Christopherson wrote:
> Use vmx_need_pf_intercept() when determining if L0 wants to handle a #PF
> in L2 or if the VM-Exit should be forwarded to L1.  The current logic fails
> to account for the case where #PF is intercepted to handle
> guest.MAXPHYADDR < host.MAXPHYADDR and ends up reflecting all #PFs into
> L1.  At best, L1 will complain and inject the #PF back into L2.  At
> worst, L1 will eat the unexpected fault and cause L2 to hang on infinite
> page faults.
> 
> Note, while the bug was technically introduced by the commit that added
> support for the MAXPHYADDR madness, the shame is all on commit
> a0c134347baf ("KVM: VMX: introduce vmx_need_pf_intercept").
> 
> Fixes: 1dbf5d68af6f ("KVM: VMX: Add guest physical address check in EPT violation and misconfig")
> Cc: stable@vger.kernel.org
> Cc: Peter Shier <pshier@google.com>
> Cc: Oliver Upton <oupton@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..8bcbe57b560f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5830,7 +5830,8 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
>   		if (is_nmi(intr_info))
>   			return true;
>   		else if (is_page_fault(intr_info))
> -			return vcpu->arch.apf.host_apf_flags || !enable_ept;
> +			return vcpu->arch.apf.host_apf_flags ||
> +			       vmx_need_pf_intercept(vcpu);
>   		else if (is_debug(intr_info) &&
>   			 vcpu->guest_debug &
>   			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
> 

Queued, thanks.

Paolo

