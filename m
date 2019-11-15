Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D056FD88F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKOJOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:14:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726567AbfKOJOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 04:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573809259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ooQQy5cnr+k7zeJzbDzSVL1DMxONkQMKFjfILLMe/Ng=;
        b=URWbi+BHuS57uEc7aQTnBzIC6bD8Q25l66wR7Jslx3M8Usy6zVImt3fYq0pPlFVYy6qfmo
        ck2NnbpetiFnZpULYpcATUNx/bzybzPe5MK3Oc6ifsT4Pl5tqNparsmrxBc2BUfpASnw2x
        83e3vK/g2PUoMnR1R+qx3l/GxwgLp1w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-ZpWcG-lFPuOeh9Ot4-WrBQ-1; Fri, 15 Nov 2019 04:14:15 -0500
Received: by mail-wm1-f71.google.com with SMTP id z3so5724299wmk.1
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 01:14:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=42MNkkgh0DnP/7zO8WcjvCr1Bhc8mb440glwZzKT5Uk=;
        b=AB/h3lYTYWfIgy0eIVylvs+HJ8x5VBhMHfA2CnNt3FBo+VZizYMxB15cjoMmlpzr9u
         CW1zhcxBKwAvxtw19JaC66PYC1VdRtlnfy0YP68TDUFD8OM6UJEWm+j5dnQ3ycREr7nD
         Dm5bEciEimi5fERkiP8tY8AUG2rKqUmJG3FVjXXyDBaebms83mKOdSsHxftQ4sU0Tm/6
         +uRbxKYeyJSIoAZ/fmMf6WT8W9WDROl2OzHPh4wX/y3jiSN4d1LzmB50X6cue8dpXUQG
         5ikLdKNENKOkOYn3xzhmGcRC/7acg3zgA+POuyYcIsBVyZ24Y0ITsehGmxhbrUy3gyg9
         NHqg==
X-Gm-Message-State: APjAAAWrcKWIE/R+Uch6xaA02DUTbICf3/0Uk3CHmROLvoDZ3Yvp7qe/
        HuglsqFum0nG4ttNrWLFyHPntsYrNmDWl3sY78lyZ3kjtoS9eE5mzjsfTtXwYLbytn59ZPbKPsU
        NhH7PAf2I67zX
X-Received: by 2002:adf:f445:: with SMTP id f5mr14502033wrp.193.1573809254317;
        Fri, 15 Nov 2019 01:14:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4gCYcrMHPvy56LGOE1Um5oYZ+lKYCwtSphiHyxRyRWdSGJnuWqD3wyIrUfgXA87t9QSEOKQ==
X-Received: by 2002:adf:f445:: with SMTP id f5mr14502004wrp.193.1573809253909;
        Fri, 15 Nov 2019 01:14:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id v128sm10540097wmb.14.2019.11.15.01.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 01:14:13 -0800 (PST)
Subject: Re: [PATCH] KVM: Forbid /dev/kvm being opened by a compat task when
 CONFIG_KVM_COMPAT=n
To:     Marc Zyngier <maz@kernel.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20191113160523.16130-1-maz@kernel.org>
 <2b846839-ea81-e40c-5106-90776d964e33@de.ibm.com>
 <CAFEAcA8c3ePLXRa_-G0jPgMVVrFHaN1Qn3qRf-WShPXmNXX6Ug@mail.gmail.com>
 <20191114081550.3c6a7a47@why>
 <5576baca-458e-3206-bdc5-5fb8da00cf6d@de.ibm.com>
 <e781ec19-1a93-c061-9236-46c8a8f698db@redhat.com>
 <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <86751a20-ae3a-2e47-0783-8f35bffdc5ac@redhat.com>
Date:   Fri, 15 Nov 2019 10:14:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4a9380afe118031c77be53112d73d5d4@www.loen.fr>
Content-Language: en-US
X-MC-Unique: ZpWcG-lFPuOeh9Ot4-WrBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 14:22, Marc Zyngier wrote:
>=20
> From 34bfc68752253c3da3e59072b137d1a4a85bc005 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Thu, 14 Nov 2019 13:17:39 +0000
> Subject: [PATCH] KVM: Add a comment describing the /dev/kvm no_compat
> handling
>=20
> Add a comment explaining the rational behind having both
> no_compat open and ioctl callbacks to fend off compat tasks.
>=20
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> =C2=A0virt/kvm/kvm_main.c | 7 +++++++
> =C2=A01 file changed, 7 insertions(+)
>=20
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1243e48dc717..722f2b1d4672 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -120,6 +120,13 @@ static long kvm_vcpu_compat_ioctl(struct file
> *file, unsigned int ioctl,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long arg);
> =C2=A0#define KVM_COMPAT(c)=C2=A0=C2=A0=C2=A0 .compat_ioctl=C2=A0=C2=A0=
=C2=A0 =3D (c)
> =C2=A0#else
> +/*
> + * For architectures that don't implement a compat infrastructure,
> + * adopt a double line of defense:
> + * - Prevent a compat task from opening /dev/kvm
> + * - If the open has been done by a 64bit task, and the KVM fd
> + *=C2=A0=C2=A0 passed to a compat task, let the ioctls fail.
> + */
> =C2=A0static long kvm_no_compat_ioctl(struct file *file, unsigned int ioc=
tl,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long arg) { return -EINVAL; }
>=20
> --=C2=A0
> 2.20.1

Queued, thanks!

Paolo

