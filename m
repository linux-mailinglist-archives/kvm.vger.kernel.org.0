Return-Path: <kvm+bounces-66305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 48483CCE97B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 06:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3CB6305059E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 05:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5932D59FA;
	Fri, 19 Dec 2025 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KFyMpuoW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+USFP21"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C98248B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 05:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766123564; cv=none; b=lEql+13VSYww0JayBBHnhR3x3NLfpbEGJwr1ydP0fxp/aInLL63HtjEDer0lIP1V8PdhHeD/Bb2B0r6Ua7ntG9p53A8iUa8g07VN+xOiMM1toyoXP5Tp+u2+cKS2i7v7lt6xAv1deU6m5T7PQuHr9uRBAt+prZb0pijArY+i+hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766123564; c=relaxed/simple;
	bh=AUkqKJ5ikZDziocownrr2W3KYs2wtKw3HmYOy3htBQ4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nRoG66I5+wxPC22g5fHpGEl5itoQ1PSqovp8ualuNRL6MPRB7cvn7Siy4dEfO93a3ZAZ89RDTuqre9UPHaxlFeTriRZ9Hsm6W8kJ26SVxeqiwrMcLONT0QRYKTvulmHve0Is3gOH9QcaumF8cAhxlUf7G6DWIyHU0A3TqUiSyxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KFyMpuoW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+USFP21; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766123561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJVwqGdURiRGJsYInZDpCrCMlBUPnbvc668rjGArdHA=;
	b=KFyMpuoW4plc7coBgbUqLALdHop3pU1dVbHaH0lkVP3kgkTcGNOrlM527RHFss7c2Adfho
	Lz8XTDTUZXQZ5/Unm061MxUp93cFySVj8ur4fb7uBzBD2DL+qRA46gt6xEgeUC383dMT6Z
	3HfvKH7e0XJ0sepc3teVGWTyRQEKh5s=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-I_wLythMO4yz1vRWuRuP3Q-1; Fri, 19 Dec 2025 00:52:39 -0500
X-MC-Unique: I_wLythMO4yz1vRWuRuP3Q-1
X-Mimecast-MFC-AGG-ID: I_wLythMO4yz1vRWuRuP3Q_1766123558
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7b80de683efso2535275b3a.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 21:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766123558; x=1766728358; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJVwqGdURiRGJsYInZDpCrCMlBUPnbvc668rjGArdHA=;
        b=S+USFP21ntA80AXw1mth/I4VZLtTVeuAH9QZCbSjcndn9TGqYmc1ufM0hkSSY6Rimz
         mMRIyUjV0whSB7pILf78D97/MvsYXyf+3FPDHlnD2XgX+8ycXxSLANJr4JlfyhWXkHM2
         T7eB+b5+YWglCKd0fHZRT6ImC7Nu3RJorvhP5WDiTwJ5Rr9Imbw2fCuNeoH1K2s5zcTm
         p9kLiZPpVfpw1/M6P8p79uSl9vQ0hr1mg+qRgChUz34LssNjRBUzboOdwt1S0EC/rWfK
         Z2hfhJX5ezcCE+tAzS+jClV6J2cnSRDY7bv6gxbYuLc72rxpRRVB4T9XnziPyH4u7sDU
         t8rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766123558; x=1766728358;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JJVwqGdURiRGJsYInZDpCrCMlBUPnbvc668rjGArdHA=;
        b=uha3EaaXixf9IlV/FVaLDiG4p7oR/1D+BkKDXB2KOvry22Lo02PyFkXJXwo9/2tYTU
         5pKRbWIOd+0jCaxRJcGWpM/cEQJcQaOyZqVBt58C9iUCXargku1i/KX6S7IZlN+124tp
         hfmbKY5vKKhLEzn3l1mQp7/ZGMUBP+k/nJe6+al+C6N0yKpqiE6e/SSonXRA3/RKMzY+
         JNkuv+M9R4FMHCmlB82SlKNdisgY+986bN2oNzc0lR4Ot+mOTP2ZZiEvvHv82LGvx8f0
         Gym0B9o7MLucVJZ2S4xM2JFVpyUZluh5e2IB6UDLkSWTtlPj2W39w/tPsWkaAbuB69Dl
         i51g==
X-Forwarded-Encrypted: i=1; AJvYcCVuotZmNbUaaDcO6C9ztWCfeifzwHYuwSb24ALLAxlHpgaQFaCEa7+yXrRwyLxLzeMyZwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDir6EUvMOyO0z/9BX7ld0s87ohlO8lgpRNZ+CAsMSB0dfI4hu
	FBczN0Fd8C8n6R4Rt7ciKIKrjiZXBFxwQWHs2nkUM3PzWA652rbPUztvOjVGRxEP7jIBAZ0gkLm
	gsrhfkQ0YlE6oJgwQvb4T4upppD/AaOynMWZK2wOWqQdxnWVlkDySlQ==
X-Gm-Gg: AY/fxX6THb/LVJv7oOH4Vmhav5xbIa2IAZhWqvxMWkSWCNY98mEdJtc9h0zGYgcn7p7
	G0Xm+bwNo823NKdjnYESuT5xbsQBGTGt/nim1m8IqlP643gBsHUCu2e0qms438cYBmbo/8wkh5b
	zI3gtrEJlOOvr1/hQBpuzXkgLI8k6C12BBXEQK8IphyWspZ/672K7Cm818ocroAvLGYDXsag3m3
	sCE93Q1Rk2x0E0cHVlphw/5lgUYeJbQ87Ac2dJAP0BCjj0YLc+MzNwijGF6n5FBKKx9wqNPDkUL
	zK1M+JLqMupx8ehpE58IoBiw0+WJ5CwvQk7yF4knwLtLu357CtXfAHAr39JT0xCopPEauZdbFn1
	lFwyjcq1lc2fQG2hIVHa44DrUB1BgSJiPN53AxOcC6Z+TIrLdHhSRcTbuVQ==
X-Received: by 2002:a05:6a00:e13:b0:7e8:450c:61bc with SMTP id d2e1a72fcca58-7ff6607cfc0mr1791923b3a.44.1766123558528;
        Thu, 18 Dec 2025 21:52:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqF/m7PhYSoU/kq0rN3DwIEZXBg4VgSAObW4lEgr3/k3Akp1nbvuOll/KxGLrqWsCct67vag==
X-Received: by 2002:a05:6a00:e13:b0:7e8:450c:61bc with SMTP id d2e1a72fcca58-7ff6607cfc0mr1791889b3a.44.1766123558070;
        Thu, 18 Dec 2025 21:52:38 -0800 (PST)
Received: from smtpclient.apple ([122.163.94.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7af2b60bsm1134278b3a.15.2025.12.18.21.52.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Dec 2025 21:52:37 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.3\))
Subject: Re: [PATCH v1 04/28] accel/kvm: add changes required to support KVM
 VM file descriptor change
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <20251212150359.548787-5-anisinha@redhat.com>
Date: Fri, 19 Dec 2025 11:22:16 +0530
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>,
 qemu-devel <qemu-devel@nongnu.org>,
 kvm@vger.kernel.org,
 qemu-arm <qemu-arm@nongnu.org>,
 qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org,
 qemu-s390x@nongnu.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6725C685-0245-47D9-8DE3-5E2672B22D1B@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
 <20251212150359.548787-5-anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Song Gao <gaosong@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Aleksandar Rikalo <arikalo@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Chinmay Rath <rathc@linux.ibm.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Weiwei Li <liwei1518@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 David Hildenbrand <david@kernel.org>,
 Thomas Huth <thuth@redhat.com>
X-Mailer: Apple Mail (2.3826.700.81.1.3)



> On 12 Dec 2025, at 8:33=E2=80=AFPM, Ani Sinha <anisinha@redhat.com> =
wrote:
>=20
> This change adds common kvm specific support to handle KVM VM file =
descriptor
> change. KVM VM file descriptor can change as a part of confidential =
guest reset
> mechanism. A new function api kvm_arch_vmfd_change_ops() per
> architecture platform is added in order to implement architecture =
specific
> changes required to support it. A subsequent patch will add x86 =
specific
> implementation for kvm_arch_vmfd_change_ops as currently only x86 =
supports
> confidential guest reset.

Some more fixes on this patch are in order which I will include in the =
next spin up.

<snip>

>=20
> +static int kvm_reset_vmfd(MachineState *ms)
> +{
> +    KVMState *s;
> +    KVMMemoryListener *kml;
> +    int ret, type;
> +    Error *err =3D NULL;
> +
> +    s =3D KVM_STATE(ms->accelerator);
> +    kml =3D &s->memory_listener;
> +
> +    memory_listener_unregister(&kml->listener);
> +    memory_listener_unregister(&kvm_io_listener);
> +
> +    if (s->vmfd >=3D 0) {
> +        close(s->vmfd);
> +    }
> +
> +    type =3D find_kvm_machine_type(ms);
> +    if (type < 0) {
> +        return -EINVAL;
> +    }
> +
> +    ret =3D do_kvm_create_vm(s, type);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    s->vmfd =3D ret;
> +
> +    kvm_setup_dirty_ring(s);
> +
> +    /* rebind memory to new vm fd */
> +    ret =3D ram_block_rebind(&err);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +    assert(!err);
> +
> +    ret =3D kvm_arch_vmfd_change_ops(ms, s);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (s->kernel_irqchip_allowed) {
> +        do_kvm_irqchip_create(s);
> +    }
> +
> +    /* these can be only called after ram_block_rebind() */
> +    memory_listener_register(&kml->listener, &address_space_memory);
> +    memory_listener_register(&kvm_io_listener, &address_space_io);
> +
> +    /*
> +     * kvm fd has changed. Commit the irq routes to KVM once more.
> +     */
> +    kvm_irqchip_commit_routes(s);
> +
> +    return ret;
> +}
> +
> static int kvm_init(AccelState *as, MachineState *ms)
> {
>     MachineClass *mc =3D MACHINE_GET_CLASS(ms);
> @@ -4014,6 +4077,7 @@ static void kvm_accel_class_init(ObjectClass =
*oc, const void *data)
>     AccelClass *ac =3D ACCEL_CLASS(oc);
>     ac->name =3D "KVM";
>     ac->init_machine =3D kvm_init;
> +    ac->reset_vmfd =3D kvm_reset_vmfd;
>     ac->has_memory =3D kvm_accel_has_memory;
>     ac->allowed =3D &kvm_allowed;
>     ac->gdbstub_supported_sstep_flags =3D kvm_gdbstub_sstep_flags;
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index 8f9eecf044..ade13dd8cc 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -358,6 +358,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s);
> int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
> int kvm_arch_init_vcpu(CPUState *cpu);
> int kvm_arch_destroy_vcpu(CPUState *cpu);
> +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s);

Another API should be added here:
bool kvm_arch_supports_vmfd_change(void)

It should tell kvm_reset_vmfd() whether the underlying architectures =
would support all operations that need to be redone after vm file =
descriptor change. If not, it should bail. Something like:

    /*                                                                   =
                                                                 =20
     * bail if the current architecture does not support VM file         =
                                                                 =20
     * descriptor change.                                                =
                                                                 =20
     */                                                                  =
                                                                 =20
    if (!kvm_arch_supports_vmfd_change()) {                              =
                                                                 =20
        error_report("This target architecture does not support KVM VM " =
                                                                        =20=

                     "file descriptor change.");                         =
                                                                 =20
        return -EOPNOTSUPP;                                              =
                                                                 =20
    }=20

>=20
> #ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
> void kvm_arch_reset_parked_vcpu(unsigned long vcpu_id, int kvm_fd);
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..919bf95ae1 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -1568,6 +1568,11 @@ void kvm_arch_init_irq_routing(KVMState *s)
> {
> }
>=20
> +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
> +{
> +    abort();
> +}
> +
> int kvm_arch_irqchip_create(KVMState *s)
> {
>     if (kvm_kernel_irqchip_split()) {
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 02819de625..cdfcb70f40 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3252,6 +3252,11 @@ static int kvm_vm_enable_energy_msrs(KVMState =
*s)
>     return 0;
> }
>=20
> +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
> +{
> +    abort();
> +}
> +
> int kvm_arch_init(MachineState *ms, KVMState *s)
> {
>     int ret;
> diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
> index 26e40c9bdc..4171781346 100644
> --- a/target/loongarch/kvm/kvm.c
> +++ b/target/loongarch/kvm/kvm.c
> @@ -1312,6 +1312,11 @@ int kvm_arch_irqchip_create(KVMState *s)
>     return kvm_check_extension(s, KVM_CAP_DEVICE_CTRL);
> }
>=20
> +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
> +{
> +    return 0;

These and others should abort() uniformly instead of silently returning =
sucess.

> +}
> +
> void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
> {
> }
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index 912cd5dfa0..28730da06b 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -44,6 +44,11 @@ unsigned long kvm_arch_vcpu_id(CPUState *cs)
>     return cs->cpu_index;
> }
>=20
> +int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
> +{
> +    return 0;
> +}
> +
> int kvm_arch_init(MachineState *ms, KVMState *s)
> {
>     /* MIPS has 128 signals */
> dif


