Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D6DF76EB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKKOrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:47:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726887AbfKKOq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573483617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TTG00YjKWUOsl5rhCzwn1XMhrGVfmW5FmkbQYzSqxw0=;
        b=FfrYydfFHoExK37VSKx8D3B+Jck58qhyc3zy8NUjcb4wmfpv+Qok7ui4tLEPGw+yV7ycPx
        MfBoLELLQOt9BSOfpPYBetofsnqWAaQmSJobotKIhqqtVeVnJtqwZOs1lZ/2WuVQJGIuQ5
        7qRym6rxR6smz9UuhgP36+R3bHAy8ac=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-cimhx58dP4ub5VqTwZhc0w-1; Mon, 11 Nov 2019 09:46:56 -0500
Received: by mail-wm1-f69.google.com with SMTP id h191so8272861wme.5
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:46:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jRkkSKwLtbw789qcSoLZDfx7wzSdmL3oq2GXGl90y/M=;
        b=ItRZ1YOmHY79T0PrQMZEKNdzXrgaS+WT9p7gGkJ8J9XQZgpBgl2CEFvhD+G5+cdGD4
         bJpK5NOGSCbJR0ryPBETcBXKLBzlEp/Br1U2BYweuZ0R+ehZ53LGE3BfKStxjJs9XthM
         RFwOAoQMuQEVJanQ8rrMP6iX3Js+NQku5/90YlNxDGmNm99WvawrZ5s5rmureM6432u0
         7O4j5e/EGRwk3otbrDqWyZozSWZGAFmaCA05iB2rb2OQJR7MKXb7LOjC5MOSSEAY1Qjp
         DA+eQuWAlFkYY/CLcfbUnj4aakZBDnZJ1HwEWXvqP+uMmqhFUiitNwdWexnosBofwLGm
         pSKQ==
X-Gm-Message-State: APjAAAVErnejTAz0nLA8oNN5/9rQ3mjrV5NRq2y86Ak+rXSZfm9AkCQ9
        zXdG5iJiIjvYbDgF5jOxdnDzppGnWsZQg8XLxWzVi1nEaFoGEkdP4P5+JtJ95kkylYdsh8LX4Ox
        buEpnGTGNoibW
X-Received: by 2002:adf:9185:: with SMTP id 5mr22369370wri.389.1573483614932;
        Mon, 11 Nov 2019 06:46:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjqc/t6JzGynXh2pZeszWWrEVTnuQ1w9EknjY1/ptxdfimEElgI3QDGqXkPhfkULlRqq2r1Q==
X-Received: by 2002:adf:9185:: with SMTP id 5mr22369347wri.389.1573483614614;
        Mon, 11 Nov 2019 06:46:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id c144sm18931831wmd.1.2019.11.11.06.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:46:54 -0800 (PST)
Subject: Re: [PATCH v1 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU
 has pending interrupts
To:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-2-joao.m.martins@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <67bca655-fea3-4b57-be3c-7dc58026b5d9@redhat.com>
Date:   Mon, 11 Nov 2019 15:46:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106175602.4515-2-joao.m.martins@oracle.com>
Content-Language: en-US
X-MC-Unique: cimhx58dP4ub5VqTwZhc0w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 18:56, Joao Martins wrote:
> Commit 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
> introduced vmx_dy_apicv_has_pending_interrupt() in order to determine
> if a vCPU have a pending posted interrupt. This routine is used by
> kvm_vcpu_on_spin() when searching for a a new runnable vCPU to schedule
> on pCPU instead of a vCPU doing busy loop.
>=20
> vmx_dy_apicv_has_pending_interrupt() determines if a
> vCPU has a pending posted interrupt solely based on PID.ON. However,
> when a vCPU is preempted, vmx_vcpu_pi_put() sets PID.SN which cause
> raised posted interrupts to only set bit in PID.PIR without setting
> PID.ON (and without sending notification vector), as depicted in VT-d
> manual section 5.2.3 "Interrupt-Posting Hardware Operation".
>=20
> Therefore, checking PID.ON is insufficient to determine if a vCPU has
> pending posted interrupts and instead we should also check if there is
> some bit set on PID.PIR.
>=20
> Fixes: 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 31ce6bc2c371..18b0bee662a5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6141,7 +6141,10 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vc=
pu)
> =20
>  static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
>  {
> -=09return pi_test_on(vcpu_to_pi_desc(vcpu));
> +=09struct pi_desc *pi_desc =3D vcpu_to_pi_desc(vcpu);
> +
> +=09return pi_test_on(pi_desc) ||
> +=09=09!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
>  }
> =20
>  static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bi=
tmap)

Should we check the bitmap only if SN is false?  We have a precondition
that if SN is clear then non-empty PIR implies ON=3D1 (modulo the small
window in vmx_vcpu_pi_load of course), so that'd be a bit faster.

Paolo

