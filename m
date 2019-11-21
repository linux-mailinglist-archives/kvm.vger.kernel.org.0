Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A066104EA9
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfKUJDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:03:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39230 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726132AbfKUJDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 04:03:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574327018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=GBIaBQHFs1fiGIE5/y3vxoQw0HXkBfoYYmiDCM+x7ig=;
        b=OOxV4AilLsBrQl5bk6X128VCKHM8MGRntXBmSwf5I9sN1pql8+clBfowVltZombRcQ1RXx
        5z8bWHWOaSceU05RzJ8hZaKCStYgVjbdvo7LfkGK3QJbKInr/kyz88jXLy1s3q37Z3/oPf
        cBN7KrAefOsWvkRLoAw0qw+VcMEPYtU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-4YR5VqsvNvWcARPP7lfq6g-1; Thu, 21 Nov 2019 04:03:37 -0500
Received: by mail-wm1-f72.google.com with SMTP id g14so1448595wmk.9
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 01:03:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qIuSDJDhsfD0XvLeZODfYkO9Tu/6swXpn3P8j6me/sk=;
        b=Q5k175JbhjZ77Ph0MtpSiNzJp7u/VJspX6iJo2x3ICBOxwUMl3Ak/cg+xUm+YfrgLv
         tG20z3Xlq0+xiaZOMbDxn4IAp7VPiZAYr6xd+JlzrhyG8r1eARzgh4BlQPl4sqjkUb69
         KFqcvjksikQSgYLUBfGjQT0Jj33JewK7W2dR8JkV+mfpKim6+xFf5nUDAXxVaPFouRZE
         9clMhTDoCm3jyVN0FX7rYp8jCKUa1lcjXFkvvsuUz6340xmPWb6qWhddIl7/ncc4F03W
         jw5RLc7zy7kKZvxqIKrxRWOdlF3SHEG05ZyvfXSOvPmmNiuMOlptlkq+CRAjhFaVaWOv
         +ovQ==
X-Gm-Message-State: APjAAAX2z5pV1eYuys0tpWeuyDZOhnbIHoFopfQ8xarVWhw2lNrqHZni
        P41dfSc2pZIVIvn+9OxV1IX7XBi+Qt1EY5VTvNIshjx7gOFUA+7kel+v91zRunljeb7JjVIJkkK
        h/k1Sa2A55xUq
X-Received: by 2002:a1c:2e8f:: with SMTP id u137mr8615438wmu.105.1574327016210;
        Thu, 21 Nov 2019 01:03:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyfs6TJadRA0qi4DYgPEndkpJUVyuo752h7GKpF0I776uVzU5dIvXxrM6yxXyygxfo+dau0Q==
X-Received: by 2002:a1c:2e8f:: with SMTP id u137mr8615400wmu.105.1574327015861;
        Thu, 21 Nov 2019 01:03:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id o81sm2217838wmb.38.2019.11.21.01.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 01:03:35 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Do not mark vmcs02->apic_access_page as dirty
 when unpinning
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20191120223147.63358-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c5c80aed-d4de-7d42-693d-f1ebcf900fe0@redhat.com>
Date:   Thu, 21 Nov 2019 10:03:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120223147.63358-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: 4YR5VqsvNvWcARPP7lfq6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 23:31, Liran Alon wrote:
> vmcs->apic_access_page is simply a token that the hypervisor puts into
> the PFN of a 4KB EPTE (or PTE if using shadow-paging) that triggers
> APIC-access VMExit or APIC virtualization logic whenever a CPU running
> in VMX non-root mode read/write from/to this PFN.
>=20
> As every write either triggers an APIC-access VMExit or write is
> performed on vmcs->virtual_apic_page, the PFN pointed to by
> vmcs->apic_access_page should never actually be touched by CPU.
>=20
> Therefore, there is no need to mark vmcs02->apic_access_page as dirty
> after unpin it on L2->L1 emulated VMExit or when L1 exit VMX operation.
>=20
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 20692e442d13..2506f431d51e 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -257,7 +257,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  =09vmx->nested.cached_shadow_vmcs12 =3D NULL;
>  =09/* Unpin physical memory we referred to in the vmcs02 */
>  =09if (vmx->nested.apic_access_page) {
> -=09=09kvm_release_page_dirty(vmx->nested.apic_access_page);
> +=09=09kvm_release_page_clean(vmx->nested.apic_access_page);
>  =09=09vmx->nested.apic_access_page =3D NULL;
>  =09}
>  =09kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
> @@ -2933,7 +2933,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu=
 *vcpu)
>  =09=09 * to it so we can release it later.
>  =09=09 */
>  =09=09if (vmx->nested.apic_access_page) { /* shouldn't happen */
> -=09=09=09kvm_release_page_dirty(vmx->nested.apic_access_page);
> +=09=09=09kvm_release_page_clean(vmx->nested.apic_access_page);
>  =09=09=09vmx->nested.apic_access_page =3D NULL;
>  =09=09}
>  =09=09page =3D kvm_vcpu_gpa_to_page(vcpu, vmcs12->apic_access_addr);
> @@ -4126,7 +4126,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 e=
xit_reason,
> =20
>  =09/* Unpin physical memory we referred to in vmcs02 */
>  =09if (vmx->nested.apic_access_page) {
> -=09=09kvm_release_page_dirty(vmx->nested.apic_access_page);
> +=09=09kvm_release_page_clean(vmx->nested.apic_access_page);
>  =09=09vmx->nested.apic_access_page =3D NULL;
>  =09}
>  =09kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
>=20

Queued, thanks.

Paolo

