Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB22DA29A
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503519AbgLNVgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733209AbgLNVgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 16:36:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B759C0613D3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=nZHfJwoGP24oRXDdt0rE3l2attpI/obOz/Gzj9OtITc=; b=l0g/fNtGl6s/sr8NEwf+fnX7zB
        ghgATe60Z5NB0Cdmb62L0i+klaNar7C7z+q6hKjeSC+RnHSxGnyEHb4fPGvphUGKM8pkUV0FbLLOn
        ckiaSnCxBZnslRfvwayaeKVpzhWwdsMGkP1H1pZFfjuXp/lqbAZR9AGoIstHYf6TT2KOeOnC1S/IM
        UgFFrqPu9FD+8r+ur5vz/DrvWfp67b40iOexfUeZZQPHtWvfR6tZ3jQ/awd9enrjFlU2ZF5xwSZib
        qoJbWY6E8Ok2V/oekz/XiQ49FYRSwIMkM3VEGHYheOYAX9EVsYuPmD9LKkr0ikevtCvueD/RpKUzr
        r35UETFw==;
Received: from [2001:8b0:10b:1:4d32:84d8:690e:d301]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kovVh-0001Nf-6k; Mon, 14 Dec 2020 21:36:01 +0000
Date:   Mon, 14 Dec 2020 21:35:49 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <87czzcw020.fsf@vitty.brq.redhat.com>
References: <20201214083905.2017260-1-dwmw2@infradead.org> <20201214083905.2017260-3-dwmw2@infradead.org> <87czzcw020.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14 December 2020 21:27:19 GMT, Vitaly Kuznetsov <vkuznets@redhat=2Ecom>=
 wrote:
>David Woodhouse <dwmw2@infradead=2Eorg> writes:
>
>> From: Joao Martins <joao=2Em=2Emartins@oracle=2Ecom>
>>
>> Xen usually places its MSR at 0x40000000 or 0x40000200 depending on
>> whether it is running in viridian mode or not=2E Note that this is not
>> ABI guaranteed, so it is possible for Xen to advertise the MSR some
>> place else=2E
>>
>> Given the way xen_hvm_config() is handled, if the former address is
>> selected, this will conflict with Hyper-V's MSR
>> (HV_X64_MSR_GUEST_OS_ID) which unconditionally uses the same address=2E
>>
>> Given that the MSR location is arbitrary, move the xen_hvm_config()
>> handling to the top of kvm_set_msr_common() before falling through=2E
>>
>
>In case we're making MSR 0x40000000 something different from
>HV_X64_MSR_GUEST_OS_ID we can and probably should disable Hyper-V
>emulation in KVM completely -- or how else is it going to work?
=20
The way Xen itself does this =E2=80=94 and the way we have to do it if we =
want to faithfully emulate Xen and support live migration from it =E2=80=94=
 is to shift the Xen MSRs up to (from memory) 0x40000200 if Hyper-V is enab=
led=2E

I did look at disabling Hyper-V entirely when it isn't enabled, but the on=
ly flag we have for it being enabled is the guest OS ID being set=2E=2E=2E =
which is done through that MSR :)

My minimal version ended up being so close to Joao's original that it was =
not longer worth the bikeshedding and so I gave up on it and stuck with the=
 original=2E


>> @@ -3001,6 +3001,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu,
>struct msr_data *msr_info)
>>  	u32 msr =3D msr_info->index;
>>  	u64 data =3D msr_info->data;
>> =20
>> +	if (msr && (msr =3D=3D vcpu->kvm->arch=2Exen_hvm_config=2Emsr))
>> +		return xen_hvm_config(vcpu, data);
>> +
>
>Can we generalize this maybe? E=2Eg=2E before handling KVM and
>architectural
>MSRs we check that the particular MSR is not overriden by an emulated
>hypervisor,=20
>
>e=2Eg=2E
>	if (kvm_emulating_hyperv(kvm) && kvm_hyperv_msr_overriden(kvm,msr)
>		return kvm_hyperv_handle_msr(kvm, msr);
>	if (kvm_emulating_xen(kvm) && kvm_xen_msr_overriden(kvm,msr)
>		return kvm_xen_handle_msr(kvm, msr);

That smells a bit like overengineering=2E As I said, I did have a play wit=
h "improving" Joao's original patch but nothing I tried actually made more =
sense to me than this once the details were ironed out=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
