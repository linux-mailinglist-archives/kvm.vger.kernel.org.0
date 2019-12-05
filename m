Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F74114017
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 12:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfLEL24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 06:28:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728735AbfLEL24 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 06:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575545334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liZrG3Fn6h7uMjS+YfxewlCVTm5jR/cWippWU216Gkk=;
        b=KFGg4rfg2i5NvMAWHpZEUpJ8yG80DCu7nuEbQEOg568Gr75vT7GMjY1RuI9xakF1JeoR07
        /zMtSk4SZu42qzMhG6rbWYnHx3msOTAC+JHd2IWUq6IGjBVBc5VG+a+O/Na4SYini9VwXX
        vskET+TU92Jrjar+b9QK5cw48JYeZpw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-Vms8zM8BPmqjnSVHkfD0eA-1; Thu, 05 Dec 2019 06:28:51 -0500
Received: by mail-wr1-f69.google.com with SMTP id b2so1411052wrj.9
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 03:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zSnkBwCsQJ7IefvCVUNxVwkOy0ntVxUAJCVEAOGBUtU=;
        b=pGVjgSmWlVoPGL7uvL37h38Pg+U0BnRw9+YeXPL/g0FFkCRhBIyI9s6bNMK9nbDzmA
         iu7dut/1/oLhsAoKd4IuxAsauI9LN5tfc9ZEB0h6gIacPq2/pcafaPpKWt8MDIQ/L56+
         hfwGlVJFJmkUpZ91/Ty4bS7mOm3CAJFh9+ksJ+cCt9lW7ml2HJ6HVbTPV6N8ESuh+GDl
         SBMmDkZDiys63Nu4ayazITKB5C+j62Y4J8e1dm05DFIhN0j9PwLxFr5TRxpqpypFlxxB
         xTmI7aH+ATomlbuA9X2UYa9xnegsbYYmLM3Ktr+H3rOtjze508MU60jDa9FMhcgLbHEA
         AVpQ==
X-Gm-Message-State: APjAAAXNypeZ3Cx3E9JconfWZK6vZk3ahEqScACIHrcROtc4kl/nzaZL
        IL4+HeFvs1+8F2RvbWM0h40r8WP/l3iFAiRE93+pgEwIC7+lJwGpckhr3xB9natEDyuz8QuMWtc
        1dfeAL3xAAI28
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr9314550wrv.144.1575545330262;
        Thu, 05 Dec 2019 03:28:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzxLLTdnvIJnf4LX7EfqXSFi7UbnY72jsv0qrNnOYd7HBdQqdtgxaukvd8wMn2ZmLTXZgccng==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr9314531wrv.144.1575545330048;
        Thu, 05 Dec 2019 03:28:50 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o4sm12042283wrx.25.2019.12.05.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 03:28:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
In-Reply-To: <20191204214027.85958-1-jmattson@google.com>
References: <20191204214027.85958-1-jmattson@google.com>
Date:   Thu, 05 Dec 2019 12:28:48 +0100
Message-ID: <87o8wnroy7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-MC-Unique: Vms8zM8BPmqjnSVHkfD0eA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> According to the SDM, a VMWRITE in VMX non-root operation with an
> invalid VMCS-link pointer results in VMfailInvalid before the validity
> of the VMCS field in the secondary source operand is checked.
>
> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if ru=
nning L2")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..146e1b40c69f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4864,6 +4864,25 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  =09if (vmx->nested.current_vmptr =3D=3D -1ull)
>  =09=09return nested_vmx_failInvalid(vcpu);
> =20
> +=09if (!is_guest_mode(vcpu)) {
> +=09=09vmcs12 =3D get_vmcs12(vcpu);
> +
> +=09=09/*
> +=09=09 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> +=09=09 * vmcs12, else we may crush a field or consume a stale value.
> +=09=09 */
> +=09=09if (!is_shadow_field_rw(field))
> +=09=09=09copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);

But (unless I'm missing some pre-requisite patch) we haven't set 'field'
yet, it happens later when we do

field =3D kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));

> +=09} else {
> +=09=09/*
> +=09=09 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> +=09=09 * to shadowed-field sets the ALU flags for VMfailInvalid.
> +=09=09 */
> +=09=09if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D -1ull)
> +=09=09=09return nested_vmx_failInvalid(vcpu);
> +=09=09vmcs12 =3D get_shadow_vmcs12(vcpu);
> +=09}
> +
>  =09if (vmx_instruction_info & (1u << 10))
>  =09=09field_value =3D kvm_register_readl(vcpu,
>  =09=09=09(((vmx_instruction_info) >> 3) & 0xf));
> @@ -4889,25 +4908,6 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  =09=09return nested_vmx_failValid(vcpu,
>  =09=09=09VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
> =20
> -=09if (!is_guest_mode(vcpu)) {
> -=09=09vmcs12 =3D get_vmcs12(vcpu);
> -
> -=09=09/*
> -=09=09 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> -=09=09 * vmcs12, else we may crush a field or consume a stale value.
> -=09=09 */
> -=09=09if (!is_shadow_field_rw(field))
> -=09=09=09copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> -=09} else {
> -=09=09/*
> -=09=09 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> -=09=09 * to shadowed-field sets the ALU flags for VMfailInvalid.
> -=09=09 */
> -=09=09if (get_vmcs12(vcpu)->vmcs_link_pointer =3D=3D -1ull)
> -=09=09=09return nested_vmx_failInvalid(vcpu);
> -=09=09vmcs12 =3D get_shadow_vmcs12(vcpu);
> -=09}
> -
>  =09offset =3D vmcs_field_to_offset(field);
>  =09if (offset < 0)
>  =09=09return nested_vmx_failValid(vcpu,

--=20
Vitaly

