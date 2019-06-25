Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D7E54FEA
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfFYNLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 09:11:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43294 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfFYNLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 09:11:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so17803845wru.10
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 06:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OM18c2omTGVCYIJZQfdwheTW+cvirakgWnGSrWsVPWY=;
        b=mP7pT7ArE2pr7G+QAexD01JV2CI05QBHVaHrjJUU9aL09pTGcyGKfcC1IdQaJCdU/h
         aF3uSbrWdld7zaa+66S+0b/HF/OJOTD5WayWz7CoRv3Yl0pj8GRDvNSmg2c1p8/GM+Mr
         tvPDoJ6SPH5V/nvjmK+IofOFEO93DOXGERyQR0mVG46WJigDN9WVZTO1eUqzAaES8dTY
         9jaiDw2alv2QScVwViTZowKsehxIXctqkkObObZBp3XpdHnzrUMSe2N2/a7nARJPIrxo
         LLRiM7v7xlpxZ4QmMeB0gR9bNMB1hqvvVM2s0LeUhiViNMIGBoHLMirTE7F2JlgIrfQO
         aVmw==
X-Gm-Message-State: APjAAAU4VjBLlr2LEGMf04yoA7FBZL+F2PQlNNKAt+t6Qb3++o5LMiCo
        ZL0196AUIl/ac+8eT25je+2sdXHhJ34=
X-Google-Smtp-Source: APXvYqypNMh0sK2JH4yCJxEJZTNi+DcI7auYNP0I2mwWo2IkJd4i2Ph4bQzuIX8d9kdLmWYdAcSxcw==
X-Received: by 2002:adf:9003:: with SMTP id h3mr34867491wrh.172.1561468304463;
        Tue, 25 Jun 2019 06:11:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h90sm19381335wrh.15.2019.06.25.06.11.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 06:11:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH] KVM: nVMX: Allow restore nested-state to enable eVMCS when vCPU in SMM
In-Reply-To: <20190625112642.113460-1-liran.alon@oracle.com>
References: <20190625112642.113460-1-liran.alon@oracle.com>
Date:   Tue, 25 Jun 2019 15:11:43 +0200
Message-ID: <878stpern4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> As comment in code specifies, SMM temporarily disables VMX so we cannot
> be in guest mode, nor can VMLAUNCH/VMRESUME be pending.
>
> However, code currently assumes that these are the only flags that can be
> set on kvm_state->flags. This is not true as KVM_STATE_NESTED_EVMCS
> can also be set on this field to signal that eVMCS should be enabled.
>
> Therefore, fix code to check for guest-mode and pending VMLAUNCH/VMRESUME
> explicitly.
>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5c470db311f7..27ff04874f67 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5373,7 +5373,10 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
>  	 * must be zero.
>  	 */
> -	if (is_smm(vcpu) ? kvm_state->flags : kvm_state->hdr.vmx.smm.flags)
> +	if (is_smm(vcpu) ?
> +		(kvm_state->flags &
> +		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
> +		: kvm_state->hdr.vmx.smm.flags)
>  		return -EINVAL;
>  
>  	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
