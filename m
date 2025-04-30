Return-Path: <kvm+bounces-44911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13440AA4A51
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AAAD466EF7
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DCD258CCE;
	Wed, 30 Apr 2025 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LctQzrmY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F31E98EA
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746013534; cv=none; b=P7D7REqML5eMvIlFx1KDa8HEUvm3X6szoPZGELczUj65+iS8QG7W6vv7zCHLnu1c2/4qJLK3UtNToGTXn0LL+pGWDkYVnqryMsBsdTPm7OzLYSxAUawEQNGchJw0ISWTyu7vmShcPGhoG4ae23uYZCLl6wOsH/fZqCNajR8Jkuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746013534; c=relaxed/simple;
	bh=CJJauCshp21Gt8IYh7pezCpA++nAGgiCyqfq7wFZA1I=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=XLaf3kus53aFKtQP0qhaG+uKDfhb/v7vSpIUrfJb3UvMMyPulw+ZuF5E2ffBZAkKZbQg5ViqyxzQQCU7VO3W82Dbdx0t+RqnjU3ixzzqt9HkW/wg1PzUKaWW2+XyY6nJjvUIsGuVYXZucDWVCgCs7/RlzpNhR3UovmzovxqrnTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LctQzrmY; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d72b749dcso8145285e9.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 04:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1746013531; x=1746618331; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MwfMy0+KN//YvkfkLkShPPR01KHLLVwze7q8vnuMUqk=;
        b=LctQzrmYVxuoiKEcNFGPoiJMVuDod7iHS+hyKPuTm1tvzI5wa7YDEVAsIATZ5Z5S5/
         AtiXmR91rOSOIHeorlEwEtQrYvSAYlbDuElhGo5+hOEx/en1LwEi4fvftqUdp6GNhm27
         F6tYrV+dLFVFn6j36bEYPMp0iXshfWGlZqrc7uv4iSiIwxpOVMKjCB45+C1f/qwNfxvM
         l8VTgDD8c3rOp7CVwfP/B0sLHzhuFNrw5tD33BY27ks8jh5TOZaJy59VPTA6bOnXsPiA
         W8GfM5/cquuaPX9ewqoizSJhRcdRvOsnmNtK3qcZV8Vr2M3InW8CzYKggGJJ7URZ29X1
         sTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746013531; x=1746618331;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MwfMy0+KN//YvkfkLkShPPR01KHLLVwze7q8vnuMUqk=;
        b=j7gGqMhzzHnMCJBEZ/TOAOuQCuIWxIFMthi462msfGApRP2R1R64bHrJwUS+fMo/DM
         SHxI6NdJZYtrVCS+JbNNfTFs8dCHN4Wcg6im/m2YQ7rCehtqAWsh8neFWHc+ELA8rR7/
         akjCI5v0lJkWjcXQp2tk95aZivzZAXvH4CbwBIl/dMG206N+4BSmqnLSiMGtog7w25C3
         MCfH7J63rAmHtT4y+MmLglkDj8p0Pq9In4pZ316eynohMjjpdqbg0lqK2j1e0Qt/6jG2
         qGEaKZUZqKG/qAL3VCZyWMxJDzQF/3Cdc9YAfK5ay+/BJGGQfLo8Xp2MLwnSptKwzZzZ
         Qipg==
X-Forwarded-Encrypted: i=1; AJvYcCVbp+wsSu7bXktbGkW/M3ilrmN082ChxqZn32oi841LLK8hoDZEHsxMWfFv19sV0iSfIHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YytUCi6NEc7pr0DqFvvkfkbHOmy/q2PebSxD+ey62ekEhnZGmvg
	xmS3RKBnAWJFy10ONGvGZVQx7z/EUSiQIh5EtIop4Wz3OpSgcWIrEfNNuqeHGnE=
X-Gm-Gg: ASbGncv41KRTg+5LW5CNVrp1Kzn4kov9AGZNrVb8iijHfpOfM2TaQ1W9yS/x41wVRIu
	dZRj6UsXnGUF2tpi2j6TDKBpPg4DHicWwldt7AKCGLRJyXRC0Dv5ua6uMYobzSWDlaX/9Z8KxF/
	SboPBuVIKl9rx6D0aWd/Rp4oUG7Y/GXQ5X8jHHiZSAnaTcAPQTo1hwyXQ//OA512ISAMsxGPst+
	R+/godZmSR5HF5SKwmDnimD9amS4D6Idyft7VD+Cl03i8V/5snnzWWnt3bI/Dn7CTDi0qe5j/TD
	v9gUfMHDpHPCyil6kn/Vjxkk0yhVEW64qDpefSpq62x/zMFxrT3fW1nRDZVgslJANPgOmcvzLQE
	NH+e4BcBvCf8=
X-Google-Smtp-Source: AGHT+IGPsHFo0i2I8e2STgcf8/9L1wSmTK1gIO5CuUV/Z9SjXZXm3h77FFhC8bIycStr7wFr3jgBMA==
X-Received: by 2002:a05:6000:22c3:b0:3a0:678f:8023 with SMTP id ffacd0b85a97d-3a091a624b4mr22754f8f.4.1746013530645;
        Wed, 30 Apr 2025 04:45:30 -0700 (PDT)
Received: from localhost (ip-89-103-73-235.bb.vodafone.cz. [89.103.73.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e460b2sm17013970f8f.70.2025.04.30.04.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 04:45:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Apr 2025 13:45:29 +0200
Message-Id: <D9JY52BJEFX2.2S5XL9NOOGBS7@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: "Anup Patel" <apatel@ventanamicro.com>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andrew Jones" <ajones@ventanamicro.com>, "Mayuresh
 Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <anup@brainfault.org>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
 <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
 <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
 <CAAhSdy01yBBfJwdTn90WeXFR85=1zTxuebFhi4CQJuOujVTHXg@mail.gmail.com>
 <D9J9DW53Q2GD.1PB647ISOCXRX@ventanamicro.com>
 <CAAhSdy0B-pF-jHmTXNYE7NXwdCWJepDtGR__S+P4MhZ1bfUERQ@mail.gmail.com>
 <CAAhSdy20pq3KvbCeST=h+O5PWfs2E4uXpX9BbbzE7GJzn+pzkA@mail.gmail.com>
 <D9JTZ6HH00KY.1B1SKH1Z0UI1S@ventanamicro.com>
 <CAAhSdy0TfpWQ-kC_gUUCU0oC5dR45A1v9q84H2Tj9A8kdO0d1A@mail.gmail.com>
In-Reply-To: <CAAhSdy0TfpWQ-kC_gUUCU0oC5dR45A1v9q84H2Tj9A8kdO0d1A@mail.gmail.com>

2025-04-30T15:47:13+05:30, Anup Patel <anup@brainfault.org>:
> On Wed, Apr 30, 2025 at 1:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>> 2025-04-30T10:56:35+05:30, Anup Patel <anup@brainfault.org>:
>> > On Wed, Apr 30, 2025 at 9:52=E2=80=AFAM Anup Patel <anup@brainfault.or=
g> wrote:
>> >> On Tue, Apr 29, 2025 at 9:51=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <=
rkrcmar@ventanamicro.com> wrote:
>> >> > The point of this patch is to reset the boot VCPU, so we reset the =
VCPU
>> >> > that is made runnable by the KVM_SET_MP_STATE IOCTL.
>> >>
>> >> Like I said before, we don't need to do this. The initiating VCPU
>> >> can be resetted just before exiting to user space for system reset
>> >> event exit.
>>
>> You assume initiating VCPU =3D=3D boot VCPU.
>>
>> We should prevent KVM_SET_MP_STATE IOCTL for all non-initiating VCPUs if
>> we decide to accept the assumption.
>
> There is no such assumption.

You probably haven't intended it:

  1) VCPU 0 is "chilling" in userspace.
  2) VCPU 1 initiates SBI reset.
  3) VCPU 1 makes a reset request to VCPU 0.
  4) VCPU 1 returns to userspace.
  5) Userspace knows it should reset the VM.
  6) VCPU 0 still hasn't entered KVM.
  7) Userspace sets the initial state of VCPU 0 and enters KVM.
  8) VCPU 0 is reset in KVM, because of the pending request.
  9) The initial boot state from userspace is lost.

>> I'd rather choose a different design, though.
>>
>> How about a new userspace interface for IOCTL reset?
>> (Can be capability toggle for KVM_SET_MP_STATE or a straight new IOCTL.)
>>
>> That wouldn't "fix" current userspaces, but would significantly improve
>> the sanity of the KVM interface.
>
> I believe the current implementation needs a few improvements
> that's all. We certainly don't need to introduce any new IOCTL.

I do too.  The whole patch could have been a single line:

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index d3d957a9e5c4..b3e6ad87e1cd 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -511,6 +511,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vc=
pu,
=20
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
+		kvm_riscv_reset_vcpu(vcpu);
 		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:

It is the backward compatibility and trying to fix current userspaces
that's making it ugly.  I already gave up on the latter, so we can have
a decently clean solution with the former.

> Also, keep in mind that so far we have avoided any RISC-V
> specific KVM IOCTLs and we should try to keep it that way
> as long as we can.

We can re-use KVM_SET_MP_STATE and add a KVM capability.
Userspace will opt-in to reset the VCPU through the existing IOCTL.

This design will also allow userspace to trigger a VCPU reset without
tearing down the whole VM.

