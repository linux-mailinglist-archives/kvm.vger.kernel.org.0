Return-Path: <kvm+bounces-24721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 148D1959B33
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 14:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6AE1C20BC2
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 12:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100CB1531D2;
	Wed, 21 Aug 2024 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCCP1KE7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218161D12EB
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724241875; cv=none; b=M106ga1Tkz8WeKHF4c2HV/iW9uJ+ao9dB0hOoHZNH4EKzE7DECcVdR/Z/cjt2EZxJgK1mUIHWT3KEupqcDL35UFdBOhHkbnlcYmyXE8MpIHi3lRRWMQq0P8oC0HdH3Iyuw5E3d/FYHK7nhM0vKKdAglC6irdz3mtKZRd5x4n0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724241875; c=relaxed/simple;
	bh=zwViz+cDX5Wlmtlmh0etFc3VA4oYXlkcnj36b20isDA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EqXtHCIDyW2dJLY6IsUoYQjktdOT2t1MH719uSYhJCfQRipQ2RN+nvRUxl/IZpVfIUd2ZmlJ1mv24MUzjmDjXF5iXLjnbKd2W54fMLCpjdXfLCu6xIZnvz/mHihddPgAYHCpPCUv1UGIeunSMu2HP2LAB54srXJjBtG+uPDj0Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCCP1KE7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724241870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTYxC5stVAn7RUQffO585gPSW0SmZvsMOm6WShzhmrk=;
	b=NCCP1KE7UrAue16oWBmT4s4X2pQhGNW7Ux/QnRiHAOdchWd+1UaCjfhrtYeFq9g45GLjRp
	P5Qc3h3E4cX5GxVuyiigzYTE3aWFBWPfg5DgRA7vOaXFKGwebDaVTVnvQ3YBjSh8cF2wVu
	YiqxNumEQqo3sMCTCrHzAYWfVRCSoWc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-7_yhHBKLNPepMDttUd0YYA-1; Wed, 21 Aug 2024 08:04:29 -0400
X-MC-Unique: 7_yhHBKLNPepMDttUd0YYA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3718eb22836so3683266f8f.3
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 05:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724241866; x=1724846666;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DTYxC5stVAn7RUQffO585gPSW0SmZvsMOm6WShzhmrk=;
        b=DhBBhK6CjRXOH8kkDKYv714OhO3QEOVzPXzBbnMetzMKGRG+qCdWtvWnQhcYb7BJXz
         AIGgr2f3RsRpgqIRTbGSERvxHh0i8oLsmWxsyFcbr4ZOy/3aPfSNxjj+eNvUWuWT/Re2
         dY9myojL+9lxA0bX8zP3R5DcsfD/1RWrhkn6PJXjLt0uS7hF2a9OwlT34z1531OY2S0x
         hqVU29qqFOI514Cq93fEcc4w1byGqSNulcUygsrbywLWMi6yXYiUO+xff4QYypmyrnSx
         RGvuIWv7bo8D5+o9fP+HUKnstd+qVbJf3FJkPkZS1aBXL8BS/vhv4x2BUZ4KM7vjBlYS
         AAnA==
X-Gm-Message-State: AOJu0Yz4QMPNUYj5csvFSIdGaWkHKC+yHk9V6JRCf9/ZHGzJhWQXhHMo
	1pcxUrrRk2gU9hYR1+qxI+4oeFsge8N6BP1m5RKCv/CH+NGqmCFT92EZjA3lN+Flm+YDH3shMNh
	6Ndn09FEn071xhjrH5oleYumt4WPbjnia62HciSV23edklwRHKw==
X-Received: by 2002:a05:6000:bc8:b0:368:633d:f111 with SMTP id ffacd0b85a97d-372fd70c9e6mr1306229f8f.40.1724241866069;
        Wed, 21 Aug 2024 05:04:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpOlwP6wBW+wwNrrqUXuerWvGK9h0RHBd4PvxaOJN5M5uqqrzWsvoKlK0aaAuFDves3oZ3nQ==
X-Received: by 2002:a05:6000:bc8:b0:368:633d:f111 with SMTP id ffacd0b85a97d-372fd70c9e6mr1306213f8f.40.1724241865477;
        Wed, 21 Aug 2024 05:04:25 -0700 (PDT)
Received: from intellaptop.lan ([2a06:c701:77ab:3101:d6e6:2b8f:46b:7344])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3718985a48asm15558013f8f.62.2024.08.21.05.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 05:04:25 -0700 (PDT)
Message-ID: <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Chao Gao
 <chao.gao@intel.com>
Date: Wed, 21 Aug 2024 15:04:23 +0300
In-Reply-To: <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
References: <20240815123349.729017-1-mlevitsk@redhat.com>
	 <20240815123349.729017-2-mlevitsk@redhat.com> <Zr_JX1z8xWNAxHmz@google.com>
	 <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=D0=A3 =D0=B2=D1=82, 2024-08-20 =D1=83 15:13 +0300, mlevitsk@redhat.com =D0=
=BF=D0=B8=D1=88=D0=B5:
> =D0=A3 =D0=BF=D1=82, 2024-08-16 =D1=83 14:49 -0700, Sean Christopherson =
=D0=BF=D0=B8=D1=88=D0=B5:
> > > > > On Thu, Aug 15, 2024, Maxim Levitsky wrote:
> > > > > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > > > > index ce7c00894f32..2e83f7d74591 100644
> > > > > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > > > > @@ -302,6 +302,31 @@ const struct kvm_stats_header kvm_vc=
pu_stats_header =3D {
> > > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 sizeof(kvm_vcpu_stats_desc),
> > > > > > > > > =C2=A0};
> > > > > > > > > =C2=A0
> > > > > > > > > +
> > > > > > > > > +/*
> > > > > > > > > + * Most x86 arch MSR values which contain linear address=
es like
> > > > >=20
> > > > > Is it most, or all?=C2=A0 I'm guessing all?
>=20
> I can't be sure that all of them are like that - there could be some outl=
iers that behave differently.
>=20
> One of the things my work at Intel taught me is that there is nothing con=
sistent
> in x86 spec, anything is possible and nothing can be assumed.
>=20
> I dealt only with those msrs, that KVM checks for canonicality, therefore=
 I use the word=C2=A0
> 'most'. There could be other msrs that are not known to me and/or to KVM.
>=20
> I can write 'some' if you prefer.

Hi,


So I did some more reverse engineering and indeed, 'some' is the right word=
:

I audited all places in KVM which check an linear address for being canonic=
al and this is what I found:

- MSR_IA32_BNDCFGS - since it is not supported on CPUs with 5 level paging,=
 its not possible to know
  what the hardware does.


- MSR_IA32_DS_AREA: - Ignores CR4.LA57 as expected. Tested by booting into =
kernel with 5 level paging
  disabled and then using userspace 'wrmsr' program to set this msr.
  I attached the bash script that I used

- MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: - Exactly the same story=
, but for some reason the
  host doesn't suport (not even read) from MSR_IA32_RTIT_ADDR2_*, MSR_IA32_=
RTIT_ADDR3_*.
  Probably the system is not new enough for these.


- invpcid instruction. It is exposed to the guest without interception (unl=
ess !npt or !ept),
  and yes, it works just fine on 57-canonical address without CR4.LA57 set.=
...


- invvpid - this one belongs to VMX set, so technically its for nesting alt=
hough it is run by L1,
  it is always emulated by KVM, but still executed on the host just with di=
fferent vpid,
  so I booted the host without 5 level paging, and patched KVM to avoid can=
onical check.

  Also 57-canonical adddress worked just fine, and fully non canonical addr=
ess failed.
  and gave a warning in 'invvpid_error'


Should I fix all of these too?


About fixing the emulator this is what see:

	emul_is_noncanonical_address
		__load_segment_descriptor
			load_segment_descriptor
				em_lldt
				em_ltr

		em_lgdt_lidt



While em_lgdt_lidt should be easy to fix because it calls emul_is_noncanoni=
cal_address
directly, the em_lldt, em_ltr will be harder because these use load_segment=
_descriptor
which calls __load_segment_descriptor which in turn is also used for emulat=
ing of far jumps/calls/rets,
for which I do believe that canonical check does respect CR4.LA57, but can'=
t be sure either.

It is possible that far jumps/calls/rets also ignore CR4.LA57, and instead =
set RIP to
non canonical instruction, and then on first fetch, #GP happens.

I'll setup another unit test for this. RIP of the #GP will determine if the=
 instruction
failed or the next fetch.

Best regards,
	Maxim Levitsky


>=20
> > > > >=20
> > > > > > > > > + * segment bases, addresses that are used in instruction=
s (e.g SYSENTER),
> > > > > > > > > + * have static canonicality checks,
> > > > >=20
> > > > > Weird and early line breaks.
> > > > >=20
> > > > > How about this?
> > > > >=20
> > > > > /*
> > > > > =C2=A0* The canonicality checks for MSRs that hold linear address=
es, e.g. segment
> > > > > =C2=A0* bases, SYSENTER targets, etc., are static, in the sense t=
hat they are based
> > > > > =C2=A0* on CPU _support_ for 5-level paging, not the state of CR4=
.LA57.
> > > > >=20
> > > > > > > > > + * size of whose depends only on CPU's support for 5-lev=
el
> > > > > > > > > + * paging, rather than state of CR4.LA57.
> > > > > > > > > + *
> > > > > > > > > + * In addition to that, some of these MSRS are directly =
passed
> > > > > > > > > + * to the guest (e.g MSR_KERNEL_GS_BASE) thus even if th=
e guest
> > > > > > > > > + * doen't have LA57 enabled in its CPUID, for consistenc=
y with
> > > > > > > > > + * CPUs' ucode, it is better to pivot the check around h=
ost
> > > > > > > > > + * support for 5 level paging.
> > > > >=20
> > > > > I think we should elaborate on why it's better.=C2=A0 It only tak=
es another line or
> > > > > two, and that way we don't forget the edge cases that make proper=
ly emulating
> > > > > guest CPUID a bad idea.
>=20
> OK, will do.
>=20
> > > > >=20
> > > > > =C2=A0* This creates a virtualization hole where a guest writes t=
o passthrough MSRs
> > > > > =C2=A0* may incorrectly succeed if the CPU supports LA57, but the=
 vCPU does not
> > > > > =C2=A0* (because hardware has no awareness of guest CPUID).=C2=A0=
 Do not try to plug this
> > > > > =C2=A0* hole, i.e. emulate the behavior for intercepted accesses,=
 as injecting #GP
> > > > > =C2=A0* depending on whether or not KVM happens to emulate a WRMS=
R would result in
> > > > > =C2=A0* non-deterministic behavior, and could even allow L2 to cr=
ash L1, e.g. if L1
> > > > > =C2=A0* passes through an MSR to L2, and then tries to save+resto=
re L2's value.
> > > > > =C2=A0*/
> > > > >=20
> > > > > > > > > +
> > > > > > > > > +static u8=C2=A0 max_host_supported_virt_addr_bits(void)
> > > > >=20
> > > > > Any objection to dropping the "supported", i.e. going with max_ho=
st_virt_addr_bits()?
> > > > > Mostly to shorten the name, but also because "supported" suggests=
 there's software
> > > > > involvement, e.g. the max supported by the kernel/KVM, which isn'=
t the case.
>=20
> Doesn't matter to me.
>=20
> > > > >=20
> > > > > If you're ok with the above, I'll fixup when applying.
> > > > >=20
>=20
> Best regards,
> =C2=A0=C2=A0 Maxim Levitsky


