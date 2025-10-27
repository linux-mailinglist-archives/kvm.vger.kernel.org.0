Return-Path: <kvm+bounces-61213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7F3C0FDD2
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52E703A4F24
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA4631A808;
	Mon, 27 Oct 2025 18:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HuCGleei"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7983D31960D
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761588654; cv=none; b=Erxm42Jr5ZJ5Ixkb3D555Gv7PaOpRfFF2EsDzVP7OpqAyqZ/WGLsQ18RbwyL149scY8+XOumjFEUqGz2l0Pvh56po6ckRd1PSu5jceNTz3PHiC3wU7Yavk+6PUWirFvCOOxTFHSZ+8CUIR/+D3B/4f3O/qwX3glKuLUsaL5SpVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761588654; c=relaxed/simple;
	bh=qWDqTHSGtqyDCU4AAlHRJ9mq1s1hvPRErQWu8I/AXzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=besXoQUZaBo8GS3xm2VXQhcCfANbS6INj1lQk0ZunNDFX8ODKQOsofRFao5xdz+z18ZozcuyMpC6JknBfkbaeB8vLTh70lgQ5b5/QzNJ/Kngod0z6llQPRqNzkoby3gtnC6jcBe3BzwMxz5SVExPEUxhYrfW+y3+hmjsqYQ0gXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HuCGleei; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33d8970ae47so4450843a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761588652; x=1762193452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO0HNahSQ0zli7kg4xL2kKu/rPaiGOzpKxwGHDcn9b4=;
        b=HuCGleeiQ5Vxy5Vm6iVJmpzhZDeJqlXsJ4ydurVEc9/ZGzkVMS4db2w0kFx5bkp/U8
         3gR7DX2O+HFR0p19vdYCebpHLNlkyGiR4JU01K6YP5KmrV4ULoCZui6X30jTohAs1pR5
         S8y1o315i2d1AHoziPTQ6hNOKr1UWSBVZDUaedQC+XAfG9WiRhHrACSpjtwPAbYpGjod
         rh7auUeEvfA/zOpnenjrJy0niGuH+NNaqewEcSB4YsA4uUOqvI8d9v6LFzMBHXzqXWtb
         8ugXSA423oiRRcjmHFyCZb8qhHiMaEzygqYmtwBbfTI0I9CEYpBbWUCvEKDuQt4wzijK
         9iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761588652; x=1762193452;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bO0HNahSQ0zli7kg4xL2kKu/rPaiGOzpKxwGHDcn9b4=;
        b=uX7FOpMNsjfHI2U1qUx2LzlTXlspR1FhDp80Q0/4/4Yg3W5wiVik2RjnEAgNPCuGm8
         kE2Qv8N6II9FAxfDqQMXxgu3y24IuJo0srRY+eSPeB609wQqHUQOQU+pLoOezvX3lcB9
         53c2w8eSIZ7D7RKXhoNNTki3zfQzlPZwke9/nxQuPo+Pu6qTvocS5TXf2ikDoUnlbzNi
         aKkr3ZcLE9eMVpouxBArSJaQPo4DQOUsnfzg+U3SBYm9v80/yjsShALn+quuVbvHiWyV
         St6Pjb1WCUdGNIrbbUO7RAKOXH4ed0MQwBb569IAlmwCOhNq44SnnvV3qAYavcMi2GMk
         5YZw==
X-Forwarded-Encrypted: i=1; AJvYcCWsmy3rVcHpst3ZEVPsShFFFiol1DxFeFbqhXY4CYYCiWeauxopmaFWGC3JRKUoipFFzo4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu1khu90idWsi/eK9IY4NKFSxOnGBnCyRDuALFD2kBRxHCFVMi
	QU7w46IJa+U9/vzd3HMxRcCprvkNMAeWI3pQ2UbGRAw48gFZ4HcuOSkPKdzxPqVZPnT5N+Q2XUx
	kY3RzXg==
X-Google-Smtp-Source: AGHT+IFYM0pQ56UGeUzsOnJj3+Ow3Uhx6HMXZ6WjKUcRvfRsyB3bsUItowqHfr7m0JixZWoiV89rDaaCMlA=
X-Received: from pjbrs15.prod.google.com ([2002:a17:90b:2b8f:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f81:b0:32e:52aa:3973
 with SMTP id 98e67ed59e1d1-340279e5fc5mr862252a91.8.1761588651707; Mon, 27
 Oct 2025 11:10:51 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:10:50 -0700
In-Reply-To: <77d8a0d9541ce3fc2b2c76b58add50d152b52e39.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-25-seanjc@google.com>
 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com> <aPuv8F8iDp3SLb9q@google.com>
 <aP86sdBZxXm5I17f@yzhao56-desk.sh.intel.com> <77d8a0d9541ce3fc2b2c76b58add50d152b52e39.camel@intel.com>
Message-ID: <aP-1qlTkmFUgTld-@google.com>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"x86@kernel.org" <x86@kernel.org>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Vishal Annapurve <vannapurve@google.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "maz@kernel.org" <maz@kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "anup@brainfault.org" <anup@brainfault.org>, 
	Kai Huang <kai.huang@intel.com>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ira Weiny <ira.weiny@intel.com>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "kas@kernel.org" <kas@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-10-27 at 17:26 +0800, Yan Zhao wrote:
> > > Ugh, I'd rather not?=C2=A0 Refresh me, what's the story with "v1"?=C2=
=A0 Are we now on
> > > v2?
> > No... We are now on v1.
> > As in [1], I found that TDX module changed SEAMCALL TDH_VP_INIT behavio=
r to
> > require exclusive lock on resource TDR when leaf_opcode.version > 0.
> >=20
> > Therefore, we moved KVM_TDX_INIT_VCPU to tdx_vcpu_unlocked_ioctl() in p=
atch
> > 22.
> >=20
> > [1] https://lore.kernel.org/all/aLa34QCJCXGLk%2Ffl@yzhao56-desk.sh.inte=
l.com/
>=20
> Looking at the PDF docs, TDR exclusive locking in version =3D=3D 1 is cal=
led out at
> least back to the oldest ABI docs I have (March 2024). Not sure about the
> assertion that the behavior changed, but if indeed this was documented, i=
t's a
> little bit our bad. We might consider being flexible around calling it a =
TDX ABI
> break?
>=20
> Sean, can you elaborate why taking mmu_lock is objectionable here, though=
?

It's not, I was just hoping we could avoid yet more complexity.

Assuming we do indeed need to take mmu_lock, can you send a patch that appl=
ies
on top?  I'm not planning on sending any of this to stable@, so I don't see=
 any
reason to try and juggle patches around.

> Note, myself (and I think Yan?) determined the locking by examining TDX m=
odule
> source. For myself, it's possible I misread the locking originally.
>=20
> Also, I'm not sure about switching gears at this point, but it makes me w=
onder
> about the previously discussed option of trying to just duplicate the TDX=
 locks
> on the kernel side.

Please no.  At best that will yield a pile of effectively useless code.  At=
 worst,
it will make us lazy and lead to real bugs because we don't propery guard t=
he *KVM*
flows that need exclusivity relative to what is going on in the TDX-Module.

> Or perhaps make some kind of debug time lockdep type thing to document/ch=
eck
> the assumptions in the kernel. Something along the lines of this patch, b=
ut
> to map the TDX locks to KVM locks or something. As we add more things (DP=
AMT,
> etc), it doesn't seem like the TDX locking is getting tamer...

Hmm, I like the idea, but actually getting meaningful coverage could be qui=
te
difficult.

