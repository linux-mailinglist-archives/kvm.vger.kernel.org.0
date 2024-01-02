Return-Path: <kvm+bounces-5415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7210821982
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 11:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1F8AB211DE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 10:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504B6DF53;
	Tue,  2 Jan 2024 10:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=epfl.ch header.i=@epfl.ch header.b="a+PCrq/a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp5.epfl.ch (smtp5.epfl.ch [128.178.224.8])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CBDDC3
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 10:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epfl.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epfl.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=epfl.ch;
      s=epfl; t=1704190255;
      h=From:To:CC:Subject:Date:Message-ID:Content-Type:Content-Transfer-Encoding:MIME-Version;
      bh=0vBRRTaw8TJVM6uwqGa6xk1bxSBTvOO5gOX7+fgdg4k=;
      b=a+PCrq/aP3wzPa9NNgwZbMyWckRe2TrXRCPTAg2v0PxrRBZfQGMnVZn/Q7hO4+OpY
        aPN8pHPJ/LpbI/Ifg2VkW18cWwExitF5g+JygW0MnjqMVmBQaAQKdm5BMkp3jP2jo
        L82YihQnzT2ZFVN8Fzt5rU8YsMEPi9K8uDGlwHbPI=
Received: (qmail 27904 invoked by uid 107); 2 Jan 2024 10:10:55 -0000
Received: from ax-snat-224-178.epfl.ch (HELO ewa07.intranet.epfl.ch) (192.168.224.178) (TLS, ECDHE-RSA-AES256-GCM-SHA384 (P-256 curve) cipher)
  by mail.epfl.ch (AngelmatoPhylax SMTP proxy) with ESMTPS; Tue, 02 Jan 2024 11:10:55 +0100
X-EPFL-Auth: lLMDuS4YBPRIAv2IS0FdyhlJgtV2JvqmUAltm5curCKEd5XyTmY=
Received: from ewa07.intranet.epfl.ch (128.178.224.178) by
 ewa07.intranet.epfl.ch (128.178.224.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 2 Jan 2024 11:10:51 +0100
Received: from ewa07.intranet.epfl.ch ([fe80::f470:9b62:7382:7f3a]) by
 ewa07.intranet.epfl.ch ([fe80::f470:9b62:7382:7f3a%4]) with mapi id
 15.01.2507.034; Tue, 2 Jan 2024 11:10:51 +0100
From: Tao Lyu <tao.lyu@epfl.ch>
To: Dongli Zhang <dongli.zhang@oracle.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "akalita@cs.stonybrook.edu" <akalita@cs.stonybrook.edu>
Subject: Re: obtain the timestamp counter of physical/host machine inside the
 VMs.
Thread-Topic: obtain the timestamp counter of physical/host machine inside the
 VMs.
Thread-Index: AQHaPTorOSL38nKVnU6vZUzEPKmx8LDGTLnh
Date: Tue, 2 Jan 2024 10:10:51 +0000
Message-ID: <a31d33cb6eb14ddda272b9d291c5ae00@epfl.ch>
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
 <20240101220601.2828996-1-tao.lyu@epfl.ch>,<f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
In-Reply-To: <f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
Accept-Language: en-US, fr-CH
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


Hi=A0Dongli,

> On 1/1/24 14:06, Tao Lyu wrote:
>> Hello Arnabjyoti, Sean, and everyone,
>>=20
>> I'm having a similiar but slightly differnt issue about the rdtsc in KVM=
.
>>=20
>> I want to obtain the timestamp counter of physical/host machine inside t=
he VMs.
>>=20
>> Acccording to the previous threads, I know I need to disable the offsett=
ing, VM exit, and scaling.
>> I specify the correspoding parameters in the qemu arguments.
>> The booting command is listed below:
>>=20
>> qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=3DSOCKSYZ,server=
=3Don,nowait,host=3Dlocalhost,port=3D3258 -mon chardev=3DSOCKSYZ,mode=3Dcon=
trol -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu ho=
st,migratable=3Doff,tsc=3Don,rdtscp=3Don,vmx-tsc-offset=3Doff,vmx-rdtsc-exi=
t=3Doff,tsc-scale=3Doff,tsc-adjust=3Doff,vmx-rdtscp-exit=3Doff  -netdev bri=
dge,id=3Dhn40 -device virtio-net,netdev=3Dhn40,mac=3De6:c8:ff:09:76:38 -hda=
 XXX -kernel XXX -append "root=3D/dev/sda console=3DttyS0"
>>=20
>>=20
>> But the rdtsc still returns the adjusted tsc.
>> The vmxcap script shows the TSC settings as below:
>>=A0=A0=20
>>=A0=A0 Use TSC offsetting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 no
>>=A0=A0 RDTSC exiting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no
>>=A0=A0 Enable RDTSCP=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 no
>>=A0=A0 TSC scaling=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 yes
>>=20
>>=20
>> I would really appreciate it if anyone can tell me whether and how I can=
 get the tsc of physical machine insdie the VM.

> If the objective is to obtain the same tsc at both VM and host side (that=
 is, to
> avoid any offset or scaling), I can obtain quite close tsc at both VM and=
 host
> side with the below linux-6.6 change.

> My env does not use tsc scaling.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 41cce50..b102dcd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
>@@ -2723,7 +2723,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcp=
u, u64
data)
>=A0=A0=A0=A0=A0=A0=A0 bool synchronizing =3D false;
>
>=A0=A0=A0=A0=A0=A0 raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags)=
;
> -=A0=A0=A0=A0=A0=A0 offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
> +=A0=A0=A0=A0=A0=A0 offset =3D 0;
>=A0=A0=A0=A0=A0=A0=A0 ns =3D get_kvmclock_base_ns();
>=A0=A0=A0=A0=A0=A0=A0 elapsed =3D ns - kvm->arch.last_tsc_nsec;
>
> Dongli Zhang


Hi Dongli,

Thank you so much for the explanation and for providing a patch.
It works for me now.

Wish you a happy new year.

Best,
Tao=

