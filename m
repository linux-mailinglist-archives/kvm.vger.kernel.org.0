Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD6C04DF
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfI0MLb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 08:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfI0MLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 08:11:31 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4134AC05AA52
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 12:11:31 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id o188so2671608wmo.5
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 05:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QXXOvH8ng89IA6N3wSSYOp1Df58vyIL2WGnGFMauaUI=;
        b=bcbbvJ/mqfwbr8U1wyfhRPu8WtYXWjpo28A5bl8+l/hRQ5LeAUc+QHlKf9nCH5VzlA
         p6+BcHE3Ke+WcbLMD+wprW8I78J1F4CkvqGau4CI+LpMa2kTsynjle1hW7jfT5p0FhwJ
         wImch/PAevaQfACUDFDh7V/MPnNTsC9AisSd026xFvHIIRmIlsvwvYJmG/5NO/NFt3+7
         Hr4nUq2oPAf2OrNVw+HQguC0DLka2ZSohiyKQ579JczzyhCyVD8r/wLqXCao6fGtKw4H
         ia9EScEy7Flmpg7bPc9KdA4ZD7f1X6NhJevW6yk2+uMt7d5mMCiDflto04lJgI+c1fjz
         0niQ==
X-Gm-Message-State: APjAAAUl3IaJpc7KnJ8btaJXpnPkojlxX2DLeT1z15XiUS3r/7wFZfwa
        Y24s3meR49/6nwlD9OYZCIA9JD7BJakxuDsG0kYX9giMXxLBJmBhyl/rscNGaXY7BiMWNO0zrcr
        OmxVx/i4NbU7R
X-Received: by 2002:a5d:408c:: with SMTP id o12mr2895353wrp.312.1569586289933;
        Fri, 27 Sep 2019 05:11:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz5ZyaW/h04/JYEn7HO5eYyw8sxSDs1W5SxMRjxONe1MWt8T0HxlpmbELtbQvVz+2LMKI0aHw==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr2895338wrp.312.1569586289720;
        Fri, 27 Sep 2019 05:11:29 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.182])
        by smtp.gmail.com with ESMTPSA id b144sm6822266wmb.3.2019.09.27.05.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 05:11:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>
Subject: Re: [PATCH 2/2] KVM: VMX: Skip GUEST_CR3 VMREAD+VMWRITE if the VMCS is up-to-date
In-Reply-To: <20190926214302.21990-3-sean.j.christopherson@intel.com>
References: <20190926214302.21990-1-sean.j.christopherson@intel.com> <20190926214302.21990-3-sean.j.christopherson@intel.com>
Date:   Fri, 27 Sep 2019 14:11:27 +0200
Message-ID: <87r242547k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Skip the VMWRITE to update GUEST_CR3 if CR3 is not available, i.e. has
> not been read from the VMCS since the last VM-Enter.  If vcpu->arch.cr3
> is stale, kvm_read_cr3(vcpu) will refresh vcpu->arch.cr3 from the VMCS,
> meaning KVM will do a VMREAD and then VMWRITE the value it just pulled
> from the VMCS.
>
> Note, this is a purely theoretical change, no instances of skipping
> the VMREAD+VMWRITE have been observed with this change.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b530950a9c2b..6de09f60edf3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3003,10 +3003,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  
>  		if (is_guest_mode(vcpu))
>  			skip_cr3 = true;
> -		else if (enable_unrestricted_guest || is_paging(vcpu))
> -			guest_cr3 = kvm_read_cr3(vcpu);
> -		else
> +		else if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> +		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))

Nit: with 'test_bit(,(ulong *)&vcpu->arch.regs_avail)' spreading more and
more I'd suggest creating an inline in kvm_cache_regs.h
(e.g. kvm_vcpu_reg_avail()).

> +			guest_cr3 = vcpu->arch.cr3;
> +		else
> +			skip_cr3 = true; /* vmcs01.GUEST_CR3 is up-to-date. */
>  		ept_load_pdptrs(vcpu);
>  	}

-- 
Vitaly
