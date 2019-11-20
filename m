Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080E0103ACF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfKTNP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 08:15:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26519 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727958AbfKTNP6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 08:15:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574255757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=D86vnJ6+ibBpit93Yd6Te1nHYeY8SGEpGdAhZxs9oXo=;
        b=H2A8tZnamNoKeygkFZOp+Fy2pXJnQ5hH0w/r5OTc5TZDob0gDBC94dKXOBUQ4ShqKZVylc
        7FD1hRKhrToV3xtbco0RrF0bxYviPNmMboIIqFUI8uf9M6I2gYjr+5+A1kxvHzG23bo07K
        wuH1z+pWl+SVUcXX68U4vYGRUqGvXJo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-lY_qi7R5MuS4j6GDQ1pQMQ-1; Wed, 20 Nov 2019 08:15:55 -0500
Received: by mail-wm1-f69.google.com with SMTP id m68so5113776wme.7
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 05:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HMROVEfQMF3arNeaJqDM7FycGhf9QXCA1T3ch7ps0pk=;
        b=s/y/BkxcZQbvW7+S2lNi3xX/8i0RMQ2HmKvng7Nyqo72IPaNgejgPOAJB6o+SnAXVN
         /ayIgtQHI3J0gmI+fGOpFa9wdPaFH+BD3xPC0d8YeILrtY441Cd74JSTFTQPUcIyJhys
         F6XoxnfPHO0qWo1J0zz2EYHWduWlPFeqb5LLQaQZVWx1K3+q+qBMtHADcjuKk3EfcMst
         XzoAr+zDZiHlKIy2WioMVDNqMH9TE4gA7kGuXj4memqOIa8Fh2pgb44l8FAsfgP+LSdz
         /L3dXGEhHfgnLUMGDflpr+R4RD0sQjMfzeVZKDh0VVIbirPguUXjEIU5nuLcdaCrRIFB
         0skA==
X-Gm-Message-State: APjAAAUnjohKtZH8Cto05v1HWZQCKJUx4q6v00SM0Oww90g4L7XtdICv
        2QSVWZn4U7u/PuXWeltJH7NnmayqTBvYVMXIXmQO8AiFxGNC0Uoc13GwDz+Nv0UG+/UzOA8NSjE
        qyJktFf1G+kVs
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr3071112wmj.22.1574255754118;
        Wed, 20 Nov 2019 05:15:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqwK1HC0S17tTzSsxzjW75dEu+2cpIod3+1u5gYz7E1JYmPst2wWZ60OPEYzQUmWQJAn53/fkw==
X-Received: by 2002:a7b:c3ce:: with SMTP id t14mr3071084wmj.22.1574255753762;
        Wed, 20 Nov 2019 05:15:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id d202sm6174769wmd.47.2019.11.20.05.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 05:15:53 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Assume TLB entries of L1 and L2 are tagged
 differently if L0 use EPT
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20191120122452.57462-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4730fb7b-bb87-bf68-ccd0-3d1aeaba7568@redhat.com>
Date:   Wed, 20 Nov 2019 14:15:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120122452.57462-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: lY_qi7R5MuS4j6GDQ1pQMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 13:24, Liran Alon wrote:
> Since commit 1313cc2bd8f6 ("kvm: mmu: Add guest_mode to kvm_mmu_page_role=
"),
> guest_mode was added to mmu-role and therefore if L0 use EPT, it will
> always run L1 and L2 with different EPTP. i.e. EPTP01!=3DEPTP02.
>=20
> Because TLB entries are tagged with EP4TA, KVM can assume
> TLB entries populated while running L2 are tagged differently
> than TLB entries populated while running L1.
>=20
> Therefore, update nested_has_guest_tlb_tag() to consider if
> L0 use EPT instead of if L1 use EPT.
>=20
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 229ca7164318..fdcead2d4dd6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1024,7 +1024,9 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcp=
u, unsigned long cr3, bool ne
>   * populated by L2 differently than TLB entries populated
>   * by L1.
>   *
> - * If L1 uses EPT, then TLB entries are tagged with different EPTP.
> + * If L0 uses EPT, L1 and L2 run with different EPTP because
> + * guest_mode is part of kvm_mmu_page_role. Thus, TLB entries
> + * are tagged with different EPTP.
>   *
>   * If L1 uses VPID and we allocated a vpid02, TLB entries are tagged
>   * with different VPID (L1 entries are tagged with vmx->vpid
> @@ -1034,7 +1036,7 @@ static bool nested_has_guest_tlb_tag(struct kvm_vcp=
u *vcpu)
>  {
>  =09struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> =20
> -=09return nested_cpu_has_ept(vmcs12) ||
> +=09return enable_ept ||
>  =09       (nested_cpu_has_vpid(vmcs12) && to_vmx(vcpu)->nested.vpid02);
>  }
> =20
>=20

Queued, thanks.

Paolo

