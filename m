Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF59FE0561
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 15:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbfJVNnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 09:43:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38972 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731159AbfJVNnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 09:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571751829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=MdIeP9IuSNsVFzUCf4DNuPIfbS2mDjhTYEIgXMSiNMs=;
        b=Q0rYMjr/efwCxJslz89cWyqDMKkeL3LTB6kl35dv9naYRIyxYzTQH56PG0pAiSe4Ibd4qD
        wCpjPm+9/uL7PwazcKsYVZooeHgFEQS+XmtsVW9gJoWYKEgItlTwhrmYuEWJpZzYbEiARK
        U0ZHv1Jj1weFAf89CDKZwzaTcbWyn/4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-3inB7AU6M1yypS8nvDeDKg-1; Tue, 22 Oct 2019 09:43:48 -0400
Received: by mail-wr1-f69.google.com with SMTP id k10so165097wrl.22
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vT/ksjCq33tMgRtUuxY/AwKVcsJUZyBBUQ6LWDa4TTs=;
        b=D63Skt6LOGIDzqRGF6iywEeBnpUq8RKHjY2DvZROdEnrmk0jVi5BbEs+B7o+aLT7w1
         ljFZEBmAIJ8ejB/pB1F3o/OdJtbnja83mX5aiocUWWn4Z/hsuJni34Z0c6bOhBD7oWd7
         qk6HYo4Ug0RktGX1vDYZDpJhT+amLdHqPow3LWwVzUx8B1wof26NkloW/b+AtaCl/F2G
         ubYqQnFcaSZbFVANTeqxs0UY8Y6wIE+LdvNXxD+S1piRdtX7gJaDpsezivV0TmLVN54x
         mst2AzO5tMhLl79KU/KNcj3QSOJO2DxK7gsjal5Gyv9G9sSkM/1z5CZ/svrwk/QPbjiC
         A+kw==
X-Gm-Message-State: APjAAAV7moM7dqS+dAOB5XKETNwuIxWTkhUp0q+DgQL7pFsFBS6mSh5w
        iUS8QX6ldYNrUI8anNEe7GdhVHvHFliYZuJRZAl6Uxdjb2gTmrfoOGl54qv0SPo3qEOyANFmLya
        4LJJN7NGgrIDi
X-Received: by 2002:a5d:630f:: with SMTP id i15mr3695864wru.226.1571751827363;
        Tue, 22 Oct 2019 06:43:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz8K63imv6StZQHnuZ1zbN8WNQnY5uGHekiRu7mKBJAfkYS4FFsQlddobTuNpF5bnph2XlRKg==
X-Received: by 2002:a5d:630f:: with SMTP id i15mr3695843wru.226.1571751827042;
        Tue, 22 Oct 2019 06:43:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id r19sm11544786wrr.47.2019.10.22.06.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 06:43:46 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: VMX: Fix conditions for guest IA32_XSS
 support
To:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
References: <20191021233027.21566-1-aaronlewis@google.com>
 <20191021233027.21566-3-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <abc92661-2fce-ff17-b199-fb2773998454@redhat.com>
Date:   Tue, 22 Oct 2019 15:43:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021233027.21566-3-aaronlewis@google.com>
Content-Language: en-US
X-MC-Unique: 3inB7AU6M1yypS8nvDeDKg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 01:30, Aaron Lewis wrote:
> Volume 4 of the SDM says that IA32_XSS is supported
> if CPUID(EAX=3D0DH,ECX=3D1):EAX.XSS[bit 3] is set, so only the
> X86_FEATURE_XSAVES check is necessary (X86_FEATURE_XSAVES is the Linux
> name for CPUID(EAX=3D0DH,ECX=3D1):EAX.XSS[bit 3]).
>=20
> Fixes: 4d763b168e9c5 ("KVM: VMX: check CPUID before allowing read/write o=
f IA32_XSS")
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: I9059b9f2e3595e4b09a4cdcf14b933b22ebad419
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 34525af44353..a9b070001c3e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1821,10 +1821,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>  =09=09return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>  =09=09=09=09       &msr_info->data);
>  =09case MSR_IA32_XSS:
> -=09=09if (!vmx_xsaves_supported() ||
> -=09=09    (!msr_info->host_initiated &&
> -=09=09     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -=09=09       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
> +=09=09if (!msr_info->host_initiated &&
> +=09=09    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>  =09=09=09return 1;
>  =09=09msr_info->data =3D vcpu->arch.ia32_xss;
>  =09=09break;
> @@ -2064,10 +2062,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>  =09=09=09return 1;
>  =09=09return vmx_set_vmx_msr(vcpu, msr_index, data);
>  =09case MSR_IA32_XSS:
> -=09=09if (!vmx_xsaves_supported() ||
> -=09=09    (!msr_info->host_initiated &&
> -=09=09     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -=09=09       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
> +=09=09if (!msr_info->host_initiated &&
> +=09=09    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>  =09=09=09return 1;
>  =09=09/*
>  =09=09 * The only supported bit as of Skylake is bit 8, but
> @@ -2076,11 +2072,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, str=
uct msr_data *msr_info)
>  =09=09if (data !=3D 0)
>  =09=09=09return 1;
>  =09=09vcpu->arch.ia32_xss =3D data;
> -=09=09if (vcpu->arch.ia32_xss !=3D host_xss)
> -=09=09=09add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> -=09=09=09=09vcpu->arch.ia32_xss, host_xss, false);
> -=09=09else
> -=09=09=09clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
> +=09=09if (vcpu->arch.xsaves_enabled) {
> +=09=09=09if (vcpu->arch.ia32_xss !=3D host_xss)
> +=09=09=09=09add_atomic_switch_msr(vmx, MSR_IA32_XSS,
> +=09=09=09=09=09vcpu->arch.ia32_xss, host_xss, false);
> +=09=09=09else
> +=09=09=09=09clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
> +=09=09}
>  =09=09break;
>  =09case MSR_IA32_RTIT_CTL:
>  =09=09if ((pt_mode !=3D PT_MODE_HOST_GUEST) ||
>=20

The last hunk technically doesn't belong in this patch, but okay.

Paolo

