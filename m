Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B39FB3A3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfKMPYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:24:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727614AbfKMPYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573658692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WvkrPFG/BkQlkJSU9ZGd13o6ArqEw2sKNaKwY2NRc/E=;
        b=BNGREXVA2EuxC0yoNTgf2SaQVbOPTdvI+danJoV7wd/8q4FhgjWg3hZ04xwMabwmVPTq34
        fTS7YGnVB7FoIVbx2mkMzHExSOg2i4QbrExY8n36tsanVNPeQKyAiF0oPy1zBOaGlWeLQ8
        nnozo+A7OaIjZ4IAQD36WIhdUBPb1ms=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-0qD74EOKPNK16mAbIUtong-1; Wed, 13 Nov 2019 10:24:50 -0500
Received: by mail-wr1-f70.google.com with SMTP id p4so1769985wrw.15
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 07:24:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HlomJoHlrjM784oArr+x3B0iN591rhHcF/QFBYxsdY=;
        b=hINN3OOE7G1dzAlqGWoqPLNTGVemlWlA+Xgme6sZLu63Rh1dxuCW6PuqoQ4NnlyAt5
         IB87n1qyH+KKzzcwj1zyBEmAJmwbSnSFDvsWlxuhminyh02aArHUfPaLF6WptD2i0p2K
         QiMN2SQpTW/5q82DinWJhr0yZr4xwKfXl3irHIl+Yel8VBLUyQS9MCrqNTl0IANcpB+l
         pJsQnB9E1bC4GtU5LSplJVYbrNOa3R6hSDmvK4tV94JWaI5fcTQTcCo8JHtmkSW5VSl2
         gpteAmpuMV589P251iBZHjHsRu/U3OcCNtJc17NoIEu2Uudp1ZJm//0YYyipB/K+AeGn
         eivA==
X-Gm-Message-State: APjAAAUIa503CaUEfXF8JPAPk+ISQIiMRmzSwTW4V5A4U5jelV9Z2njp
        1Ho2ASupXgQMMdBPx+W40QWXNWwtVhn3FiJETNTY7IcqMTM3TveKF9Pf+Y2akBmtsq9FDaZYm9e
        yDIu5PD0sjOoM
X-Received: by 2002:a7b:c211:: with SMTP id x17mr3130711wmi.71.1573658689300;
        Wed, 13 Nov 2019 07:24:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxJaPVpwliGa4xcU/3Z9Wis8+Tj6Cj3IK8ZUApiTdlvlAEiPQztRwbe7l6MVispSdtrtXnTjg==
X-Received: by 2002:a7b:c211:: with SMTP id x17mr3130688wmi.71.1573658688971;
        Wed, 13 Nov 2019 07:24:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:64a1:540d:6391:74a9? ([2001:b07:6468:f312:64a1:540d:6391:74a9])
        by smtp.gmail.com with ESMTPSA id t29sm3597982wrb.53.2019.11.13.07.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 07:24:48 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Consume pending LAPIC INIT event when exit on
 INIT_SIGNAL
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, nadav.amit@gmail.com,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20191111121605.92972-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <31ed4dc6-edf0-f489-726c-c57c9790b861@redhat.com>
Date:   Wed, 13 Nov 2019 16:24:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111121605.92972-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: 0qD74EOKPNK16mAbIUtong-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:16, Liran Alon wrote:
> Intel SDM section 25.2 OTHER CAUSES OF VM EXITS specifies the following
> on INIT signals: "Such exits do not modify register state or clear pendin=
g
> events as they would outside of VMX operation."
>=20
> When commit 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various =
CPU states")
> was applied, I interepted above Intel SDM statement such that
> INIT_SIGNAL exit don=E2=80=99t consume the LAPIC INIT pending event.
>=20
> However, when Nadav Amit run matching kvm-unit-test on a bare-metal
> machine, it turned out my interpetation was wrong. i.e. INIT_SIGNAL
> exit does consume the LAPIC INIT pending event.
> (See: https://www.spinics.net/lists/kvm/msg196757.html)
>=20
> Therefore, fix KVM code to behave as observed on bare-metal.
>=20
> Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU s=
tates")
> Reported-by: Nadav Amit <nadav.amit@gmail.com>
> Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0e7c9301fe86..2c4336ac7576 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3461,6 +3461,7 @@ static int vmx_check_nested_events(struct kvm_vcpu =
*vcpu, bool external_intr)
>  =09=09test_bit(KVM_APIC_INIT, &apic->pending_events)) {
>  =09=09if (block_nested_events)
>  =09=09=09return -EBUSY;
> +=09=09clear_bit(KVM_APIC_INIT, &apic->pending_events);
>  =09=09nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
>  =09=09return 0;
>  =09}
>=20

Queued, thanks.

Paolo

