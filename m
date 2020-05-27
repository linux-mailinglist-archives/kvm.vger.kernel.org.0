Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886A1E3E7B
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgE0KDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:03:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbgE0KDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 06:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590573799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K5aoZD94Bdt8IQkQiaPPsorrKIIJCA0ECfpK+RBmwjU=;
        b=MhmIJE6ngQ9AZ6JE3zXQ1WEE5vEVC0oOVTCTcv82xvMs7U3vsywld1t8R6gQ4E6VfXay0y
        qg+Tf+/snjA1drgkd/pkhiC24XfcV0hflCutWeWG/dUoUb1H4No7S8AUimSuezh1R9RcQU
        WVdvj1ZiWPSa/MYbTJfUQHYRHgQUp20=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-aB7ESoCzMruuJobUaN5HIw-1; Wed, 27 May 2020 06:03:17 -0400
X-MC-Unique: aB7ESoCzMruuJobUaN5HIw-1
Received: by mail-ej1-f69.google.com with SMTP id m22so1245944ejn.4
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 03:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K5aoZD94Bdt8IQkQiaPPsorrKIIJCA0ECfpK+RBmwjU=;
        b=IVEN4MxjXOxm66WiQUBEMyGyS0iOx3doTYS0UcF2tMfISY0brG4ohaCmRBWbgIyTsR
         /ZEbuqxqL6GD2tNfDRRrTUDXQdLh4T7MIcNkqnVapQhe52djkhVyEa50/1EJL+ZFQM9h
         pZ5EtJBTamEh2ZifzMRA+yA6txR4q748FsNAvJIrt5E3YAQVKp11SbzCKvfvQNT6lEqo
         nLwieoRNpJHKCcwn/sWvqt4zsmwSJE5IlKdVjFXG5BjVkdyBpAsvA4MFM20YTIyQYZST
         rAs76TMXcJLgr1A7ZGFpJViWU4aZr8sMilKry76BhhtFz2Z8E8vNyZEhNX1yfmqdHEcn
         dpLA==
X-Gm-Message-State: AOAM530jsBBRqx+3xw7HkBdf8iboisgUgnfkShxfBagXrX6M8BurrbGh
        MRm2VO2a5/xSTOVGAuty9kvLHdqD3v1Sh+7FQDVnB1Mut86M0zvXwoCupt8buNvuJrV1jo2c3Wn
        bDQfeTf0prxTU
X-Received: by 2002:a17:907:1189:: with SMTP id uz9mr5081149ejb.53.1590573796018;
        Wed, 27 May 2020 03:03:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtGDTVME1kTme3ysc0tvVt/aSxxpA7Dx0TxZxwIBs/4vrOxvgxcS0wsLTR19Vf7/VXoKMP5A==
X-Received: by 2002:a17:907:1189:: with SMTP id uz9mr5081127ejb.53.1590573795772;
        Wed, 27 May 2020 03:03:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m11sm2268523ejq.49.2020.05.27.03.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:03:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
In-Reply-To: <20200527085400.23759-1-sean.j.christopherson@intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
Date:   Wed, 27 May 2020 12:03:13 +0200
Message-ID: <875zch66fy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Initialize vcpu->arch.tdp_level during vCPU creation to avoid consuming
> garbage if userspace calls KVM_RUN without first calling KVM_SET_CPUID.
>
> Fixes: e93fd3b3e89e9 ("KVM: x86/mmu: Capture TDP level when updating CPUID")
> Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b226fb8abe41b..01a6304056197 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9414,6 +9414,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	fx_init(vcpu);
>  
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
>  
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Looking at kvm_update_cpuid() I was thinking if it would make sense to
duplicate the "/* Note, maxphyaddr must be updated before tdp_level. */"
comment here (it seems to be a vmx-only thing btw), drop it from
kvm_update_cpuid() or move cpuid_query_maxphyaddr() to get_tdp_level()
but didn't come to a conclusive answer. 

-- 
Vitaly

