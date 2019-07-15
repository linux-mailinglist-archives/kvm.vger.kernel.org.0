Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39601698F9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 18:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbfGOQW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 12:22:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46535 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729533AbfGOQW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 12:22:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so17740278wru.13
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 09:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5LZndm0byar24V/OfLLhBmoj+udxWCfCEOiQP7L2vXI=;
        b=jB7RgJgUOMtzsj7iwLUm79yJxsWpBywsaL57eCKaWBwtZOGgpkGmzE0k/uIigFBgiC
         rtYM/IK4rlIOeNvCKqBj3kQThC5t3oKVrlQPwDdhkAaHYhc1ZFYbkhCdoqpyi0m1Yd6H
         N71oXJKuDfRaDfaKd92EaX7JJvUKV9hIGruybpF9Qw3avRWaO6m2cwjxEvvr4UaOgnnx
         RXXsKRzCridzGZso468wuWJT8LMWhc8ST/ENk/a0WzvuIZZugqyD4FXK1wHuxj5EkrbY
         t7qps3SEj9X3GFco3VW1mJu1VgikjLG/8ZSdOP/7j3/3D8v6lgsxklMIRsc+mlHsHNkB
         E8Wg==
X-Gm-Message-State: APjAAAXAGb1Je1MNUWa5AVTO1RsrtSMwg5girNuD8H43uSeryP/n6Txd
        /vmQ6VLsOGi5iH5veiEqhvZ9ESFjmvU=
X-Google-Smtp-Source: APXvYqxKYi12fvj8/sdkVuLYP12AeIXroeZyKeWXb4CWbQRHheifomsi7yCKcG42bA0s/I7riiUO/Q==
X-Received: by 2002:adf:e504:: with SMTP id j4mr29228841wrm.222.1563207773744;
        Mon, 15 Jul 2019 09:22:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g131sm12374183wmf.37.2019.07.15.09.22.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 09:22:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     max@m00nbsd.net, Joao Martins <joao.m.martins@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS
In-Reply-To: <20190715154744.36134-1-liran.alon@oracle.com>
References: <20190715154744.36134-1-liran.alon@oracle.com>
Date:   Mon, 15 Jul 2019 18:22:52 +0200
Message-ID: <87r26rw9lv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

> As reported by Maxime at
> https://bugzilla.kernel.org/show_bug.cgi?id=204175:
>
> In vmx/nested.c::get_vmx_mem_address(), when the guest runs in long mode,
> the base address of the memory operand is computed with a simple:
>     *ret = s.base + off;
>
> This is incorrect, the base applies only to FS and GS, not to the others.
> Because of that, if the guest uses a VMX instruction based on DS and has
> a DS.base that is non-zero, KVM wrongfully adds the base to the
> resulting address.
>
> Reported-by: Maxime Villard <max@m00nbsd.net>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 18efb338ed8a..e01e1b6b8167 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4068,6 +4068,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  		 * mode, e.g. a 32-bit address size can yield a 64-bit virtual
>  		 * address when using FS/GS with a non-zero base.
>  		 */
> +		if ((seg_reg != VCPU_SREG_FS) && (seg_reg != VCPU_SREG_GS))
> +			s.base = 0;

(personal preference)
 
 I'd rather write this as

    /* In long mode only FS and GS bases are considered */
    if (seg_reg == VCPU_SREG_FS || seg_reg == VCPU_SREG_GS)
       *ret = s.base + off;
    else 
       *ret = off;

>  		*ret = s.base + off;
>  
>  		/* Long mode: #GP(0)/#SS(0) if the memory address is in a

As-is or rewritten with my suggestion,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
