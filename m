Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F29F772D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKO5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:57:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726877AbfKKO5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573484252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=BLpwzH8+WcLgtdoYeAorpjztbuY3IORxo6pwtce0vQA=;
        b=hHCY2gNluGR1hCZUKzLNVLmACIs8c/P8vMnfUutfqs6B0Il4Zh+n3r2x6HzOIfKBiHLMtq
        wjCxb+8IeFaXcvMx0+h2eDX7g5U8i6nZveSxqFl89fDA2FkQSfObAJfMogzIyS6JePq0jS
        V0ave/2cSksakOkqYiZHn/1EwZokNaQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-tw0f5H5tOxy9sK3qKbWKsA-1; Mon, 11 Nov 2019 09:57:31 -0500
Received: by mail-wm1-f70.google.com with SMTP id m68so8500729wme.7
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:57:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2EfLaWoPaWlo6vJ6vEY3QwXC2Upg3FXtJp5P1eq+smg=;
        b=IDpSzs6AwU0QFuGvu/1NICZgCn/1Hn8Bp67r+hzSv6UjI19AZx0KXFdebVctMPe9A6
         s/F4FnlEncOnl7+a85vt2I+lCHWr+oTktjA2rIfnhgABvyn/Viq5vg5Hb/YslJeKXTYP
         krp22+/uySuoWN27c/1yxVluXQDbEOqB5tZKzHbfHfhq0Zn4/nDTX5V/DuOSNAFV6tPY
         b7Ji3q/rGNQpN2XyH6kD10F8vZIcD1cUJWYR8yHCGRfwmQbOdXFwi0a6SJRTvIeT4pz7
         5n4ywS+ohfwjUrAhml8ND/QxA9MpKPqLEqUfOAOGvT7FsZSR2MZ+ii/U1CjBSYlx2vvz
         TCxw==
X-Gm-Message-State: APjAAAUyPiLOP9RfmNacS0LWUlRvsQs8+O5ce1KdG4smfkhZvGd0Jw+7
        6shjA9GbAHK3spTPOyt9kAlznkEyn3omeKipocVhtSxVx699EsGrgDVn6kDhHqk/kx1W08z0/GW
        GuQJbWSmyhVPC
X-Received: by 2002:adf:e346:: with SMTP id n6mr20159684wrj.234.1573484249671;
        Mon, 11 Nov 2019 06:57:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJ5T5rr037qypP8JwzRi+kY3SVK7B8iMILIpQbkwn5YoFEqn1V2gHI7sW4207p3PPdyIZuXA==
X-Received: by 2002:adf:e346:: with SMTP id n6mr20159661wrj.234.1573484249300;
        Mon, 11 Nov 2019 06:57:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id m1sm1062207wrv.37.2019.11.11.06.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:57:28 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: VMX: Refactor update_cr8_intercept()
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-2-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <de93a7b8-d0b6-33b2-2039-ad836fcfab1e@redhat.com>
Date:   Mon, 11 Nov 2019 15:57:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111123055.93270-2-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: tw0f5H5tOxy9sK3qKbWKsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:30, Liran Alon wrote:
> No functional changes.
>=20
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f53b0c74f7c8..d5742378d031 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6013,17 +6013,14 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr=
)
>  {
>  =09struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> +=09int tpr_threshold;
> =20
>  =09if (is_guest_mode(vcpu) &&
>  =09=09nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>  =09=09return;
> =20
> -=09if (irr =3D=3D -1 || tpr < irr) {
> -=09=09vmcs_write32(TPR_THRESHOLD, 0);
> -=09=09return;
> -=09}
> -
> -=09vmcs_write32(TPR_THRESHOLD, irr);
> +=09tpr_threshold =3D ((irr =3D=3D -1) || (tpr < irr)) ? 0 : irr;

Pascal parentheses? :)

Paolo

> +=09vmcs_write32(TPR_THRESHOLD, tpr_threshold);
>  }
> =20
>  void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>=20

