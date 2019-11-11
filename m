Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE9DF7697
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKKOjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:39:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726903AbfKKOjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:39:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573483149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wirKbU/8Cv2mgoDz4OmhWHmf28SB8MLFquOJWJpWCPc=;
        b=W1w7A/yaDRk0smVz/geLWDktHpsmXPQ8zyLftOaZvE2mFzgbQmOd0n4Wy9X6MP4YxMzAdK
        QW/61SJApHe4Ia7MmBG55Oi5vKZRz+yVcVBoGV9HyQvzxMvd39FDR6CeWK6defqcsA70cD
        VmE9QeYaXtIUK3QIzO6wkN7FebbswX0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-Tw7iJsx_PImG84O0j5AIkA-1; Mon, 11 Nov 2019 09:39:07 -0500
Received: by mail-wr1-f70.google.com with SMTP id m17so9999754wrb.20
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:39:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2vUuMLzRqkGHHf2+2jVwfNEqVzFHxRKuojcVRTT5wvM=;
        b=hxS2m+T/Bn/vJluGFM3vrqDb5MXkQPtIYBowWuEFEYubkfZeXGstzv7g4t5YZrbeNG
         thKTY3x3D6EpTj79tklEj957yAWvvJcdwn5xGtOQubPC6eXdthXcmj39IGa2gSdpXMCp
         FhZbWnLNUvW0hy+Km5VL+3EFCD9tqfSY8KvwgQoWP8ETnBxjtBPyDhj+HqNFf+RzB57F
         AgrQQALj6XzKZQHUJZQmRERMdGY5ob2n0+hx5sIV5j0yEiQbDgHqmPUEH4h5zCSJh950
         M8sh06c046Uiq7mAaoB+3Hr/1bV3jrj0gzvYphSfDHV8aM2707D+utHNIEx1W8GET5Bg
         yXvw==
X-Gm-Message-State: APjAAAUAdfmsbzGqutstLjIVYSGBxE2nSm6TX4h6zbhA5AEFK19/2o6V
        A/6VmSl0EM50udc8M2YKvsI92JS8FkkbKyNFA6w0jn3FJG5Zgzrhv+x0875UfXvmSym5ZOs5Ilm
        RkOfWn5tl9T0b
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr22013152wmj.127.1573483146362;
        Mon, 11 Nov 2019 06:39:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJ8FeEElSu3YUeqierkfd/csj/UTEuloo6RjxvUSLwq82HJNOJS+SokLC3HuL5PAhxFuoEYw==
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr22013123wmj.127.1573483146026;
        Mon, 11 Nov 2019 06:39:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id j63sm22130103wmj.46.2019.11.11.06.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:39:05 -0800 (PST)
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
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
 <20191106175602.4515-3-joao.m.martins@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
Date:   Mon, 11 Nov 2019 15:39:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106175602.4515-3-joao.m.martins@oracle.com>
Content-Language: en-US
X-MC-Unique: Tw7iJsx_PImG84O0j5AIkA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 18:56, Joao Martins wrote:
> When vCPU enters block phase, pi_pre_block() inserts vCPU to a per pCPU
> linked list of all vCPUs that are blocked on this pCPU. Afterwards, it
> changes PID.NV to POSTED_INTR_WAKEUP_VECTOR which its handler
> (wakeup_handler()) is responsible to kick (unblock) any vCPU on that
> linked list that now has pending posted interrupts.
>=20
> While vCPU is blocked (in kvm_vcpu_block()), it may be preempted which
> will cause vmx_vcpu_pi_put() to set PID.SN.  If later the vCPU will be
> scheduled to run on a different pCPU, vmx_vcpu_pi_load() will clear
> PID.SN but will also *overwrite PID.NDST to this different pCPU*.
> Instead of keeping it with original pCPU which vCPU had entered block
> phase on.
>=20
> This results in an issue because when a posted interrupt is delivered,
> the wakeup_handler() will be executed and fail to find blocked vCPU on
> its per pCPU linked list of all vCPUs that are blocked on this pCPU.
> Which is due to the vCPU being placed on a *different* per pCPU
> linked list than the original pCPU that it had entered block phase.
>=20
> The regression is introduced by commit c112b5f50232 ("KVM: x86:
> Recompute PID.ON when clearing PID.SN"). Therefore, partially revert
> it and reintroduce the condition in vmx_vcpu_pi_load() responsible for
> avoiding changing PID.NDST when loading a blocked vCPU.
>=20
> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>

Something wrong in the SoB line?

Otherwise looks good.

Paolo

> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
>  arch/x86/kvm/vmx/vmx.h |  6 ++++++
>  2 files changed, 20 insertions(+)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 18b0bee662a5..75d903455e1c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1274,6 +1274,18 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu=
, int cpu)
>  =09if (!pi_test_sn(pi_desc) && vcpu->cpu =3D=3D cpu)
>  =09=09return;
> =20
> +=09/*
> +=09 * If the 'nv' field is POSTED_INTR_WAKEUP_VECTOR, do not change
> +=09 * PI.NDST: pi_post_block is the one expected to change PID.NDST and =
the
> +=09 * wakeup handler expects the vCPU to be on the blocked_vcpu_list tha=
t
> +=09 * matches PI.NDST. Otherwise, a vcpu may not be able to be woken up
> +=09 * correctly.
> +=09 */
> +=09if (pi_desc->nv =3D=3D POSTED_INTR_WAKEUP_VECTOR || vcpu->cpu =3D=3D =
cpu) {
> +=09=09pi_clear_sn(pi_desc);
> +=09=09goto after_clear_sn;
> +=09}
> +
>  =09/* The full case.  */
>  =09do {
>  =09=09old.control =3D new.control =3D pi_desc->control;
> @@ -1289,6 +1301,8 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu,=
 int cpu)
>  =09} while (cmpxchg64(&pi_desc->control, old.control,
>  =09=09=09   new.control) !=3D old.control);
> =20
> +after_clear_sn:
> +
>  =09/*
>  =09 * Clear SN before reading the bitmap.  The VT-d firmware
>  =09 * writes the bitmap and reads SN atomically (5.2.3 in the
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bee16687dc0b..1e32ab54fc2d 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -373,6 +373,12 @@ static inline void pi_clear_on(struct pi_desc *pi_de=
sc)
>  =09=09(unsigned long *)&pi_desc->control);
>  }
> =20
> +static inline void pi_clear_sn(struct pi_desc *pi_desc)
> +{
> +=09clear_bit(POSTED_INTR_SN,
> +=09=09(unsigned long *)&pi_desc->control);
> +}
> +
>  static inline int pi_test_on(struct pi_desc *pi_desc)
>  {
>  =09return test_bit(POSTED_INTR_ON,
>=20

