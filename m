Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA7AF7750
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKPC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:02:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32154 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726888AbfKKPC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 10:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573484577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=gOBT0A+QD6i9RWIpgXNgwQeBcJgzz3CV7QxtcGlYcXk=;
        b=EsILrqrWTWnpMFGbRSHbYPyIuzQy+5I5D7N/HEtyDLLolfiAY+D1EYCvUk5dhN74R/VwtD
        duWysdlxAwVC1JblqWJA5hCwsvVOlD1fPKBCW3MrFquLZLi31wQHbjHjvfuEvBredXPOOy
        Y8OKDDM9vMCUqujGfxpYXVWB3+qNTJk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-RUdJfHKmPsmcJ92zzEoT6A-1; Mon, 11 Nov 2019 10:02:56 -0500
Received: by mail-wm1-f71.google.com with SMTP id k184so7002483wmk.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 07:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3g67obTkTKfBHjo4N+U8LCBOFdACGehFIJw8r+3+NDA=;
        b=pEgTv0gQq51VxrJbYszB9vxF7mmkluGUyFeMvxyqDxtaNnA1XEW8MogkpXlS/1SAb/
         WKty6EuPegPcetsVk0wMAruFixy68Xor+nVhrKlN3BuXM2GsNZI+Uq4DsJC1IzdG7jbI
         yxcryxgsOVSuYMkYJxZWZUvZCgbaVpcagG3PmopABbfTIDCDZ64+CNeqOJ28IBqK2qHU
         NFsUtAvcpzYPZSm2DESr48ycEffnpIS19hbIIIvxNzBSkkaVgBFoDRG0jS0dtLfBLZm6
         HPTcYx9Nkg6KjZStM0UkA16iZjOs1Gt1OebMLAhScctGem913cBBzgHsAcue8RbWdewU
         L4+Q==
X-Gm-Message-State: APjAAAW2cFS0A4rn9+r7OciufefwI0K+bxGcJJ5cisZuIvb8YNfwSxwe
        i2k0IxSwmQGQaCVZuqgjOjqa2gnMaAwu5T2x34Ou3gRjh11jg6Te49Z6bkpUbAPjXB3VEhV9GbB
        7CQMcubkcc6bS
X-Received: by 2002:a1c:7215:: with SMTP id n21mr17287102wmc.129.1573484575294;
        Mon, 11 Nov 2019 07:02:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqxgKONCTKCWjoXHA6XQMeJqVA5o0IU52wrdWZ/fRQi9Z/BZ22CiPOTcm5SVGdOtYV5ATM6crw==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr17287070wmc.129.1573484575002;
        Mon, 11 Nov 2019 07:02:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id j63sm22213815wmj.46.2019.11.11.07.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 07:02:54 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed
 L1 TPR
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-3-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
Date:   Mon, 11 Nov 2019 16:02:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191111123055.93270-3-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: RUdJfHKmPsmcJ92zzEoT6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 13:30, Liran Alon wrote:
> When L1 don't use TPR-Shadow to run L2, L0 configures vmcs02 without
> TPR-Shadow and install intercepts on CR8 access (load and store).
>=20
> If L1 do not intercept L2 CR8 access, L0 intercepts on those accesses
> will emulate load/store on L1's LAPIC TPR. If in this case L2 lowers
> TPR such that there is now an injectable interrupt to L1,
> apic_update_ppr() will request a KVM_REQ_EVENT which will trigger a call
> to update_cr8_intercept() to update TPR-Threshold to highest pending IRR
> priority.
>=20
> However, this update to TPR-Threshold is done while active vmcs is
> vmcs02 instead of vmcs01. Thus, when later at some point L0 will
> emulate an exit from L2 to L1, L1 will still run with high
> TPR-Threshold. This will result in every VMEntry to L1 to immediately
> exit on TPR_BELOW_THRESHOLD and continue to do so infinitely until
> some condition will cause KVM_REQ_EVENT to be set.
> (Note that TPR_BELOW_THRESHOLD exit handler do not set KVM_REQ_EVENT
> until apic_update_ppr() will notice a new injectable interrupt for PPR)
>=20
> To fix this issue, change update_cr8_intercept() such that if L2 lowers
> L1's TPR in a way that requires to lower L1's TPR-Threshold, save update
> to TPR-Threshold and apply it to vmcs01 when L0 emulates an exit from
> L2 to L1.

Can you explain why the write shouldn't be done to vmcs02 as well?

Paolo

> -=09vmcs_write32(TPR_THRESHOLD, tpr_threshold);
> +
> +=09if (is_guest_mode(vcpu))
> +=09=09to_vmx(vcpu)->nested.l1_tpr_threshold =3D tpr_threshold;
> +=09else
> +=09=09vmcs_write32(TPR_THRESHOLD, tpr_threshold);
>  }
> =20
>  void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index bee16687dc0b..43331dfafffe 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -167,6 +167,9 @@ struct nested_vmx {
>  =09u64 vmcs01_debugctl;
>  =09u64 vmcs01_guest_bndcfgs;
> =20
> +=09/* to migrate it to L1 if L2 writes to L1's CR8 directly */
> +=09int l1_tpr_threshold;
> +
>  =09u16 vpid02;
>  =09u16 last_vpid;
> =20
>=20

