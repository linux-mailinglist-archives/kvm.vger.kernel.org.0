Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769BA107E0C
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2019 11:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKWK34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Nov 2019 05:29:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726368AbfKWK34 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 23 Nov 2019 05:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574504994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=b0nGYW2Evu1Vo0GnMnluFE/WqpJeDuxhq9+fUV8fdR0=;
        b=htTa4oh8axnOkHyttxspYC7QfJA2SVFTlhmiVjII9/S24pDfaLoW4ap9PiHaDXTr0K7Bes
        iPbX/4vcRQkla1wBJJNY+idq5bD1d6p0+YDqk8TVrxx0AlCmQllpNDBxGL+WFDWnM3Euyj
        phbeVtFhixJbaCbV6dRzCV9ONG1ba9I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-g_2lP2DFPC62l85ZrOFxSg-1; Sat, 23 Nov 2019 05:29:53 -0500
Received: by mail-wr1-f70.google.com with SMTP id j12so5265197wrw.15
        for <kvm@vger.kernel.org>; Sat, 23 Nov 2019 02:29:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uatzGgKPx8lrJYeybqBiyYHtN3+XnYuv6IHQKW9rOoU=;
        b=bBEACPwtImDRKb5uoGxtVzzYbnJZt4aUjqjh7qtH7x6qGWz2C96nfPDH21AY2dF/Jd
         ajN/cvH94UX4ai61JK+Pn53JDD9kNFnP+2zZDES0TCl05WxaKFDWgO7Z8+798tC6x9hl
         KPWGw+4c6iY09PduETuQQGPBWQCnmCvs8Nd1s/5T/arJqgXvGqw2100NG8yw3saC96Zt
         OwRp2CuOylX2ZUrwm0RDDNy8yE3CS+A8oFJPNI96C5P0J6F743Y+nF6XRWf6m0JBTg7Z
         Zsun1ii6d49CP9wzGmBKIlvDBOCPBAhjuVu7rnK4z6bYYHoBWOOzImUHzywigW97I/wp
         wtjA==
X-Gm-Message-State: APjAAAV1/NRxyNfmwOc3WwfaQl9bGkEO+lGT/zS1mk5nw/gypZmD9aOW
        smgj2eWY5VYMuy557PzfP4UaBnnsn5LGtvIMZ9hOgvy4K4dS0TbqYnHL4+dCRRb5h3fyejWq6ji
        IsGMMKR8U1XJz
X-Received: by 2002:adf:9e92:: with SMTP id a18mr21907548wrf.34.1574504992002;
        Sat, 23 Nov 2019 02:29:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqx+4o6q2BbPnhDhJn1tGwzLvr3ecTKLY+jm2sk7KVnT27GBJ6mTTIvSgxETvX2M0dih9qBbcg==
X-Received: by 2002:adf:9e92:: with SMTP id a18mr21907527wrf.34.1574504991741;
        Sat, 23 Nov 2019 02:29:51 -0800 (PST)
Received: from [192.168.42.104] (mob-109-112-4-118.net.vodafone.it. [109.112.4.118])
        by smtp.gmail.com with ESMTPSA id f140sm1460892wme.21.2019.11.23.02.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 02:29:51 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Open code shared_msr_update() in its only
 caller
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191122200450.26239-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9e0038a3-dd57-353f-f176-edea48491174@redhat.com>
Date:   Sat, 23 Nov 2019 11:29:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191122200450.26239-1-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: g_2lP2DFPC62l85ZrOFxSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/11/19 21:04, Sean Christopherson wrote:
> Fold shared_msr_update() into its sole user to eliminate its pointless
> bounds check, its godawful printk, its misleading comment (it's called
> under a global lock), and its woefully inaccurate name.
>=20
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a256e09f321a..35b571c769bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -262,23 +262,6 @@ static void kvm_on_user_return(struct user_return_no=
tifier *urn)
>  =09}
>  }
> =20
> -static void shared_msr_update(unsigned slot, u32 msr)
> -{
> -=09u64 value;
> -=09unsigned int cpu =3D smp_processor_id();
> -=09struct kvm_shared_msrs *smsr =3D per_cpu_ptr(shared_msrs, cpu);
> -
> -=09/* only read, and nobody should modify it at this time,
> -=09 * so don't need lock */
> -=09if (slot >=3D shared_msrs_global.nr) {
> -=09=09printk(KERN_ERR "kvm: invalid MSR slot!");
> -=09=09return;
> -=09}
> -=09rdmsrl_safe(msr, &value);
> -=09smsr->values[slot].host =3D value;
> -=09smsr->values[slot].curr =3D value;
> -}
> -
>  void kvm_define_shared_msr(unsigned slot, u32 msr)
>  {
>  =09BUG_ON(slot >=3D KVM_NR_SHARED_MSRS);
> @@ -290,10 +273,16 @@ EXPORT_SYMBOL_GPL(kvm_define_shared_msr);
> =20
>  static void kvm_shared_msr_cpu_online(void)
>  {
> -=09unsigned i;
> +=09unsigned int cpu =3D smp_processor_id();
> +=09struct kvm_shared_msrs *smsr =3D per_cpu_ptr(shared_msrs, cpu);
> +=09u64 value;
> +=09int i;
> =20
> -=09for (i =3D 0; i < shared_msrs_global.nr; ++i)
> -=09=09shared_msr_update(i, shared_msrs_global.msrs[i]);
> +=09for (i =3D 0; i < shared_msrs_global.nr; ++i) {
> +=09=09rdmsrl_safe(shared_msrs_global.msrs[i], &value);
> +=09=09smsr->values[i].host =3D value;
> +=09=09smsr->values[i].curr =3D value;
> +=09}
>  }
> =20
>  int kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
>=20

Queued, thanks.

Paolo

