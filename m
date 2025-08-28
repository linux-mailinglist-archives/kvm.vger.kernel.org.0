Return-Path: <kvm+bounces-56202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB43B3AE7C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 353B7568551
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2152D8789;
	Thu, 28 Aug 2025 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3U4OX3Be"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F09D3FC7
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 23:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756424416; cv=none; b=tNyvxOree1mEJfvWxbeia84KsA8vt4fCVhcnbv1Ykbnm6A8MFc0dobt4RJ4mDMpjsO2gPFz2ECzNWTWQpKLKOPs3k+9m5Wrcfzg1nFHVH7zqUe2GY+3C5agcsCzYj9/SENHMqyw8GV6NJ/DJcK9KvPYztxlPLa/DpT7QEE2+F4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756424416; c=relaxed/simple;
	bh=KsAyKzibOsjor0ReCDD55lr3rxs8WRdOFSK6ndQtHgg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BkZjIdivl+fsMMGlLbA9QDHwIueJETwmEbBSlw2rofQ+Emm0r/twgOEeBJ2yHkCU+UGKlBE2UZxcCkoaTiNb2zPgwECXOgvONSHuPavlMOeOjQYsyctnQPLAclTiuw6Eu3rqcF1VWnoTJfK1u8xOUoKZaHlz9edPvnGzb3fWijM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3U4OX3Be; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77057266d0bso2122177b3a.1
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756424414; x=1757029214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PEeUvBboOkLSk46g+vBgkfY4ImguJzhTUEdxhRNUWyM=;
        b=3U4OX3BeVj28ZD9+u+R0EnMjBpOmz+8yAt7lH+bOe4rL19Go7HmhrB2Ito3fQyJ6i+
         2yG7XPvGkoLvhUQW45tryt5XAWhPikdSJD8ab8eMr+sG/u8Xy8jwIIoI61e0NEEEyRm0
         qIQyCJ9PdRmojlFb6B73/zSAtHtvDHPc06HVLk9vYDkXOtv6KG/w0CVowQUDFXZOUv+e
         WdP/NWBzF7eICgU69Cy3+okFvk6W+urOPRRizIxYtf9RnBAtesI72LdEEUAgabExdOq3
         023Zb7CoQgqF/pbvPnxq5fvzysyGcCQtmT5P3gspJqqIAZYT1CNV9oYStHdAzKVoxk3+
         FMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756424414; x=1757029214;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PEeUvBboOkLSk46g+vBgkfY4ImguJzhTUEdxhRNUWyM=;
        b=dVbgSRDZYijZO1E6E2mmI7cLRDYFAZPxVa2NVrjbcVohmuKV0k9OoSB3tddn1h0rjS
         mA9S74fJ6jXNYGL9RCuRCeOitydquE9xLZO9eaKUY4f5qYBZV61wU3/prMQrT4lwdXRk
         bzaJJFTUhO3Cd0cJbqNVsF7jp4/KscLYKXnmZuHxsh0BPPytcn1OOetr26hpdtIoC+mb
         Y/YnazVNzWl7/Jbu9o/iznKad8FeQu8h7HLybF0doCNzQ1NgX9S5+69KdwNyzjTmf4xK
         VEqa/UCgMriCH66mrW49z4vtCXH01pbYPl7PltzrcYUVIk5Pr20PGleBDGsHKyyeUAAl
         HRrw==
X-Forwarded-Encrypted: i=1; AJvYcCXN1LRkfJYqCWZqWI864Nq/GlRI3FE+VzVNIt7MbWqcaDinfG4Ocd8tH+ayS0piIiuUJ08=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL3efb+q0NB2apsTDWNKNLP7LxEOakmGStKkNDPz+walp8gGsm
	VMa+LNMlFDsBETro2OypYxFxTI+2GmIQYwnYA8DrirnlN5vl4JfkqFKaKrTNfkEoPn3CA18DmDJ
	kU79lBQ==
X-Google-Smtp-Source: AGHT+IHeJ88uApWJkJqXMHHSqLFiYmbSu+jf3zcvClugfQxnEbc0FP+VGJbRiLFQM0fXQ2K58Whmq3fXey8=
X-Received: from pfbde5.prod.google.com ([2002:a05:6a00:4685:b0:771:e00d:cee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9291:b0:771:e451:4edf
 with SMTP id d2e1a72fcca58-771e451567dmr20877658b3a.0.1756424414244; Thu, 28
 Aug 2025 16:40:14 -0700 (PDT)
Date: Thu, 28 Aug 2025 16:40:12 -0700
In-Reply-To: <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <aKdIvHOKCQ14JlbM@google.com>
 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
 <aKdzH2b8ShTVeWhx@google.com> <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
 <aKeGBkv6ZjwM6V9T@google.com> <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
 <aK4LamiDBhKb-Nm_@google.com> <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
Message-ID: <aLDo3F3KKW0MzlcH@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025, David Woodhouse wrote:
> On Tue, 2025-08-26 at 12:30 -0700, Sean Christopherson wrote:
> > On Fri, Aug 22, 2025, Colin Percival wrote:
> > > On 8/21/25 14:10, David Woodhouse wrote:
> > > > On Thu, 2025-08-21 at 13:48 -0700, Sean Christopherson wrote:
> > > > > > I think I'm a lot happier with the explicit CPUID leaf exposed =
by the
> > > > > > hypervisor.
> > > > >=20
> > > > > Why?=C2=A0 If the hypervisor is ultimately the one defining the s=
tate, why does it
> > > > > matter which CPUID leaf its in?
> > > > [...]
> > > >=20
> > > > If you tell me that 0x15 is *never* wrong when seen by a KVM guest,=
 and
> > > > that it's OK to extend the hardware CPUID support up to 0x15 even o=
n
> > > > older CPUs and there'll never be any adverse consequences from weir=
d
> > > > assumptions in guest operating systems if we do the latter... well,=
 for
> > > > a start, I won't believe you. And even if I do, I won't think it's
> > > > worth the risk. Just use a hypervisor leaf :)
> >=20
> > But for CoCo VMs (TDX in particular), using a hypervisor leaf is object=
ively worse,
> > because the hypervisor leaf is emulated by the untrusted world, whereas=
 CPUID.0x15
> > is emulated by the trusted world (TDX-Module).
> >=20
> > If the issue is one of trust, what if we carve out a KVM_FEATURE_xxx bi=
t that
> > userspace can set to pinky swear it isn't broken?
> >=20
> > > FreeBSD developer here.=C2=A0 I'm with David on this, we'll consult t=
he 0x15/0x16
> > > CPUID leaves if we don't have anything better, but I'm not going to t=
rust
> > > those nearly as much as the 0x40000010 leaf.
> > >=20
> > > Also, the 0x40000010 leaf provides the lapic frequency, which AFAIK i=
s not
> > > exposed in any other way.
> >=20
> > On Intel CPUs, CPUID.0x15 defines the APIC timer frequency:
> >=20
> > =C2=A0 The APIC timer frequency will be the processor=E2=80=99s bus clo=
ck or core crystal clock
> > =C2=A0 frequency (when TSC/core crystal clock ratio is enumerated in CP=
UID leaf 0x15)
> > =C2=A0 divided by the value specified in the divide configuration regis=
ter.
> >=20
> > Thanks to TDX (again), that is also now KVM's ABI.
>=20
> And AMD's Secure TSC provides it in a GUEST_TSC_FREQ MSR, I believe.
>=20
> For the non-CoCo cases, I do think we'd need at least that 'I pinky
> swear that CPUID 0x15 is telling the truth' bit =E2=80=94 because right n=
ow, on
> today's hypervisors, I believe it might not be correct. So a guest
> can't trust it without that bit.
>=20
> But I'm also concerned about the side-effects of advertising to guests
> that everything up to 0x15 is present, on older and AMD CPUs.=20

Ah, you want to bolt this onto older vCPU models.  That makes sene.

> And I just don't see the point in that 'pinky swear' bit,

Yeah, I can see poorly written guest software freaking out over CPUID.0x15 =
being
unexpectedly valid, e.g. on AMD hardware, in which case pinky swearing it's=
 ok
won't help.

> when there's an *existing* hypervisor leaf which just gives the informati=
on
> directly, which is implemented in QEMU and EC2, as well as various guests=
.

Can we just have the VMM do the work then?  I.e. carve out the bit and the
leaf in KVM's ABI, but leave it to the VMM to fill in?  I'd strongly prefer=
 not
to hook kvm_cpuid(), as I don't like overriding userspace's CPUID entries, =
and
I especially don't like that hooking kvm_cpuid() means the value can change
throughout the lifetime of the VM, at least in theory, but in practice will=
 only
ever be checked by the guest during early boot.

