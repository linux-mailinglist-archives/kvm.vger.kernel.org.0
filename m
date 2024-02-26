Return-Path: <kvm+bounces-9994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 672918681AC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 21:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89AEB1C256D4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0CB130AF2;
	Mon, 26 Feb 2024 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="C8uS8MF7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NmBdhqpa"
X-Original-To: kvm@vger.kernel.org
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDC60BA1;
	Mon, 26 Feb 2024 20:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708977801; cv=none; b=cgB20Bz2e9gdQJSmNdt/giJYbJBR+VRwiHRBouP9mNMkhdc0nrO6yuoIFsj2tTx/BvaBG/SKymDhyYV3s8wIRUp6tFbFgGzYVdJkqEBr/OOEZkaX0uPvzoyo/mBErumchS/WavT7XsJFWNX6OR9wm5ifFeDBWhfbiJVYFBd9aSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708977801; c=relaxed/simple;
	bh=j7GyNL9BixSMCVOR6BeYK39RQ90DJ2RrBuK50jivGhA=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=Wl/88hY2+9hI6Fp1zvjFmtsBs5ejoE7AKqzZBDaRt2Zpjw9mHemtPU08T6WvQWFKckBhxN/YieOI1kKgPOED0xBQd5jSzUidUS25qhOUuo+hmAimuY7sLIHd208H8dzUF204qKBdb9P/+3XYmmC1H7csxdqgggrcRSLdqqlxzA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=C8uS8MF7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NmBdhqpa; arc=none smtp.client-ip=64.147.123.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.west.internal (Postfix) with ESMTP id 9534932001AB;
	Mon, 26 Feb 2024 15:03:18 -0500 (EST)
Received: from imap44 ([10.202.2.94])
  by compute3.internal (MEProxy); Mon, 26 Feb 2024 15:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1708977798;
	 x=1709064198; bh=g9pAZobRDWrE7c+bX0j2OBeQT0XuTVgMGwJuGsRmzZI=; b=
	C8uS8MF7yd+iU+umlnG6x86LODXaPM9kOQmBmrFN4xNeUtI1SeitJzHKqX2neSEw
	QWpJA8IzIS9y11mXOsVDIc7o3CG382ZOpXOCelrr5JOhRbOgWlRpg/1bPaGpUx76
	9N9UeBF0sOFCJAHnSFGF4JY4YfHpECmjasJyoxOFzfzj/jo8jyCS+loI2MZFrsq5
	Y0UMotxQ9OfVyDFT9jMky8P3bVjp+pSdwKJZczCX6v1A701Q5B4WG8yVOWRGm34v
	Gs2MGRCSzZFwwgfiiQ274ypysFeO/4tD9LTJYTAI5d1ppcR7rHcrSgAKVPSFWT4x
	wRwUdUcR4wzVStW0Mjjyng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1708977798; x=
	1709064198; bh=g9pAZobRDWrE7c+bX0j2OBeQT0XuTVgMGwJuGsRmzZI=; b=N
	mBdhqpawwP9/fzJaCD/RGNWPcn9sYaJhggIlTDA5ao2qdJ0Orgxn9yItEz7oG2yW
	x7Yj+MsdbQKSaT7FIMJCVZES6s59i2feMqhmIVJ/QW0W0CoG6G9AknHZnN9zOa6Q
	GIj8M1pzYXcHBudFTGwCoUoZObJmuDmgMabXMOMiIUfl2/xaX/i/0CHvyx/sFlzj
	buscU62h27McLoFf36az8xZcA531BAYMz3RrPNDblx7Dhe4zo36SDw1FYmkFUVpF
	t9QbDYXacxBr3CFg1qYOWrvl/YadR54xi5+R+Wxp66MEP7DZLRtt1GKEhVKR/Q/I
	SJDbpiUEbnlxhNp4Kxv3w==
X-ME-Sender: <xms:he7cZeajDlHpwBRhXyk9LM6K741xpZycrVck97Mbb-GBY_MF3niCLw>
    <xme:he7cZRaJen4Q3hKt0XNOHiMW0Dx1Jzp5JguS9FBTiTSny8KFxJ6j8QFuUWJp-3geC
    rCSZgJH48onMYyBges>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrgedvgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdfl
    ihgrgihunhcujggrnhhgfdcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtoh
    hmqeenucggtffrrghtthgvrhhnpedufeegfeetudeghefftdehfefgveffleefgfehhfej
    ueegveethfduuddvieehgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:he7cZY96_lwmnTOPJcCmQ1B6sTS_unpVccuZ22A-VkPwhosBDYVTbQ>
    <xmx:he7cZQoVLn1qBEnEd-fbmUKZMZRDCVuwq3kLyVtv9J8R-e16Bn8C3w>
    <xmx:he7cZZq1AQFKksYiuhj8VIfpzvkbPWQ3HSzKOtyWdYUoSF_NcfSWKg>
    <xmx:hu7cZdKEkGLplWkuNnKP-z0rELH1jqaEcwE3kayYMTj6p2yMuyu_HA>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 5D8E036A0076; Mon, 26 Feb 2024 15:03:17 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-153-g7e3bb84806-fm-20240215.007-g7e3bb848
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
In-Reply-To: <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
Date: Mon, 26 Feb 2024 20:02:57 +0000
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Bibo Mao" <maobibo@loongson.cn>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Tianrui Zhao" <zhaotianrui@loongson.cn>,
 "Juergen Gross" <jgross@suse.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B42=E6=9C=8826=E6=97=A5=E4=BA=8C=E6=9C=88 =E4=B8=8A=E5=
=8D=888:04=EF=BC=8Cmaobibo=E5=86=99=E9=81=93=EF=BC=9A
> On 2024/2/26 =E4=B8=8B=E5=8D=882:12, Huacai Chen wrote:
>> On Mon, Feb 26, 2024 at 10:04=E2=80=AFAM maobibo <maobibo@loongson.cn=
> wrote:
>>>
>>>
>>>
>>> On 2024/2/24 =E4=B8=8B=E5=8D=885:13, Huacai Chen wrote:
>>>> Hi, Bibo,
>>>>
>>>> On Thu, Feb 22, 2024 at 11:28=E2=80=AFAM Bibo Mao <maobibo@loongson=
.cn> wrote:
>>>>>
>>>>> Instruction cpucfg can be used to get processor features. And there
>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>>> for KVM hypervisor to privide PV features, and the area can be ext=
ended
>>>>> for other hypervisors in future. This area will never be used for
>>>>> real HW, it is only used by software.
>>>> After reading and thinking, I find that the hypercall method which =
is
>>>> used in our productive kernel is better than this cpucfg method.
>>>> Because hypercall is more simple and straightforward, plus we don't
>>>> worry about conflicting with the real hardware.
>>> No, I do not think so. cpucfg is simper than hypercall, hypercall can
>>> be in effect when system runs in guest mode. In some scenario like T=
CG
>>> mode, hypercall is illegal intruction, however cpucfg can work.
>> Nearly all architectures use hypercall except x86 for its historical
> Only x86 support multiple hypervisors and there is multiple hypervisor=20
> in x86 only. It is an advantage, not historical reason.

I do believe that all those stuff should not be exposed to guest user sp=
ace
for security reasons.

Also for different implementations of hypervisors they may have differen=
t=20
PV features behavior, using hypcall to perform feature detection
can pass more information to help us cope with hypervisor diversity.
>
>> reasons. If we use CPUCFG, then the hypervisor information is
>> unnecessarily leaked to userspace, and this may be a security issue.
>> Meanwhile, I don't think TCG mode needs PV features.
> Besides PV features, there is other features different with real hw su=
ch=20
> as virtio device, virtual interrupt controller.

Those are *device* level information, they must be passed in firmware
interfaces to keep processor emulation sane.

Thanks

>
> Regards
> Bibo Mao
>
>>=20
>> I consulted with Jiaxun before, and maybe he can give some more comme=
nts.
>>=20
>>>
>>> Extioi virtualization extension will be added later, cpucfg can be u=
sed
>>> to get extioi features. It is unlikely that extioi driver depends on
>>> PARA_VIRT macro if hypercall is used to get features.
>> CPUCFG is per-core information, if we really need something about
>> extioi, it should be in iocsr (LOONGARCH_IOCSR_FEATURES).
>>=20
>>=20
>> Huacai
>>=20
>>>
>>> Regards
>>> Bibo Mao
>>>
>>>>
>>>> Huacai
>>>>
>>>>>
>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>> ---
>>>>>    arch/loongarch/include/asm/inst.h      |  1 +
>>>>>    arch/loongarch/include/asm/loongarch.h | 10 ++++++
>>>>>    arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++--=
-------
>>>>>    3 files changed, 41 insertions(+), 16 deletions(-)
>>>>>
>>>>> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/in=
clude/asm/inst.h
>>>>> index d8f637f9e400..ad120f924905 100644
>>>>> --- a/arch/loongarch/include/asm/inst.h
>>>>> +++ b/arch/loongarch/include/asm/inst.h
>>>>> @@ -67,6 +67,7 @@ enum reg2_op {
>>>>>           revhd_op        =3D 0x11,
>>>>>           extwh_op        =3D 0x16,
>>>>>           extwb_op        =3D 0x17,
>>>>> +       cpucfg_op       =3D 0x1b,
>>>>>           iocsrrdb_op     =3D 0x19200,
>>>>>           iocsrrdh_op     =3D 0x19201,
>>>>>           iocsrrdw_op     =3D 0x19202,
>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongar=
ch/include/asm/loongarch.h
>>>>> index 46366e783c84..a1d22e8b6f94 100644
>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>> @@ -158,6 +158,16 @@
>>>>>    #define  CPUCFG48_VFPU_CG              BIT(2)
>>>>>    #define  CPUCFG48_RAM_CG               BIT(3)
>>>>>
>>>>> +/*
>>>>> + * cpucfg index area: 0x40000000 -- 0x400000ff
>>>>> + * SW emulation for KVM hypervirsor
>>>>> + */
>>>>> +#define CPUCFG_KVM_BASE                        0x40000000UL
>>>>> +#define CPUCFG_KVM_SIZE                        0x100
>>>>> +#define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
>>>>> +#define  KVM_SIGNATURE                 "KVM\0"
>>>>> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>>>> +
>>>>>    #ifndef __ASSEMBLY__
>>>>>
>>>>>    /* CSR */
>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>>> index 923bbca9bd22..6a38fd59d86d 100644
>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>> @@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>>>>>           return EMULATE_DONE;
>>>>>    }
>>>>>
>>>>> -static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>> +static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>>>>    {
>>>>>           int rd, rj;
>>>>>           unsigned int index;
>>>>> +
>>>>> +       rd =3D inst.reg2_format.rd;
>>>>> +       rj =3D inst.reg2_format.rj;
>>>>> +       ++vcpu->stat.cpucfg_exits;
>>>>> +       index =3D vcpu->arch.gprs[rj];
>>>>> +
>>>>> +       /*
>>>>> +        * By LoongArch Reference Manual 2.2.10.5
>>>>> +        * Return value is 0 for undefined cpucfg index
>>>>> +        */
>>>>> +       switch (index) {
>>>>> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
>>>>> +               vcpu->arch.gprs[rd] =3D vcpu->arch.cpucfg[index];
>>>>> +               break;
>>>>> +       case CPUCFG_KVM_SIG:
>>>>> +               vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNA=
TURE;
>>>>> +               break;
>>>>> +       default:
>>>>> +               vcpu->arch.gprs[rd] =3D 0;
>>>>> +               break;
>>>>> +       }
>>>>> +
>>>>> +       return EMULATE_DONE;
>>>>> +}
>>>>> +
>>>>> +static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>>           unsigned long curr_pc;
>>>>>           larch_inst inst;
>>>>>           enum emulation_result er =3D EMULATE_DONE;
>>>>> @@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_vc=
pu *vcpu)
>>>>>           er =3D EMULATE_FAIL;
>>>>>           switch (((inst.word >> 24) & 0xff)) {
>>>>>           case 0x0: /* CPUCFG GSPR */
>>>>> -               if (inst.reg2_format.opcode =3D=3D 0x1B) {
>>>>> -                       rd =3D inst.reg2_format.rd;
>>>>> -                       rj =3D inst.reg2_format.rj;
>>>>> -                       ++vcpu->stat.cpucfg_exits;
>>>>> -                       index =3D vcpu->arch.gprs[rj];
>>>>> -                       er =3D EMULATE_DONE;
>>>>> -                       /*
>>>>> -                        * By LoongArch Reference Manual 2.2.10.5
>>>>> -                        * return value is 0 for undefined cpucfg =
index
>>>>> -                        */
>>>>> -                       if (index < KVM_MAX_CPUCFG_REGS)
>>>>> -                               vcpu->arch.gprs[rd] =3D vcpu->arch=
.cpucfg[index];
>>>>> -                       else
>>>>> -                               vcpu->arch.gprs[rd] =3D 0;
>>>>> -               }
>>>>> +               if (inst.reg2_format.opcode =3D=3D cpucfg_op)
>>>>> +                       er =3D kvm_emu_cpucfg(vcpu, inst);
>>>>>                   break;
>>>>>           case 0x4: /* CSR{RD,WR,XCHG} GSPR */
>>>>>                   er =3D kvm_handle_csr(vcpu, inst);
>>>>> --
>>>>> 2.39.3
>>>>>
>>>
>>>

--=20
- Jiaxun

