Return-Path: <kvm+bounces-65187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B2DC9DE39
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 07:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A88DA34AF44
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 06:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A002857F1;
	Wed,  3 Dec 2025 06:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VbcJCb6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0550231A41
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764742152; cv=none; b=OuUr6bqMVTdpHQWIUdlRe8jOWKhaFgJ/yHqrfWzrCbNnsQFx3If+RuBAFIANyedkT656q602JgQD6vGMxYYw6vzeGKsjoq9JS/TucrvdHMErYg3pXRnB1xUsFEzSHORGuLaPIFbDcmUAgNrBxzc+ajJIN0W7WggHnK0/SS2R0GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764742152; c=relaxed/simple;
	bh=ZYSjCRC/hHI1H3gb+cN7itSUSjyZ/eJu080H8ZPljqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YtZJ1bco4fvVqlj+GC+1Rlf4qY53/RDtIjoawCirlKrrouDczNONXBIPLP2JnA4nPtODQDLIvZ84I4A/snn9FrEKvaSPcxLL+KuchERAM+1688LvXrOIwdJ1P1G6e4PFgg/+FLjR70MzxVbRa06+JfQsTphkFNjsS0TJSQEXabA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=VbcJCb6G; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-65745a436f7so2827909eaf.3
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 22:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1764742149; x=1765346949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYSjCRC/hHI1H3gb+cN7itSUSjyZ/eJu080H8ZPljqA=;
        b=VbcJCb6GwyfnAsIxXxho6msFXc1dSfFTYzu911YkQABYEobASZf7trbZSJ0rSHw6W9
         QhDdatAXP8lBCtrnFxfOt58Hyh8Klf3Pt72FEIIB5nTNz2sUdW0skhd9EG7KSYr8YgPN
         GQnKrO3LXCPY5wz0MlpTwiSprzwkIsaqrozxX2WwO6SX2VGGZuN5nJpQmxg+WVQ6e4Zn
         beKsciFJ3FkkbYLiDDjAg+zw1QcOfrXUKcVuvA1L4Xor8eZp8eXNEv6korFJz2VaJ0Vg
         w+8LObRl2f9gDyzMET+WjNmB80dl7OkiVpD6RV8qLYGg4qrzaZpIl9BGv/9dL6SUIIF+
         SKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764742149; x=1765346949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZYSjCRC/hHI1H3gb+cN7itSUSjyZ/eJu080H8ZPljqA=;
        b=ReV5TVIbDiby4ZaAR0aygPA48eXci2eStK3yFrwR3zd9gjA/bGcT2Agmw8qLOQCvWo
         q7DckAHDZmkMt6IfF3tlBfowZCoR776FVsacVWN4CBAnU2pNX645DCrP524F85AtEQ+Q
         jG1b0HfU8eK55Y/Kzqp0g/8msWjLteA4hxRN1vsQJw6UUDuiM3Ke5Blga2Hq9h8wjvDV
         Q/s3RV/ft2q0hoALy+5yJq4ZyL9ha7sk0iUCJiRdkUtJx1ioMEtMGX+8rG327jBrduRU
         T0+0ADb70jzWH90JF/QWkDoDvajC+EYPF0yf7tK8rtC3tlZDGzZXxfn6YFE/1d9BvTZ7
         xoiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0m6VYeV54zDVMkpj9ZPNlmZG0VnULX0cSwR1LyxTzgUIXten81biPCITw/EqJ6AHJpp8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4K3Dfyxsi4XUZ5gOTJkxmbasTRy4cVtlmN81nI1Tn7mU06gbu
	/28AOyT5c4WMeu5+YtjxC9CT8KCVC4rWGrS6hhQ03mRSmZNCbicdVSVXBXdOCKKB1S7Yk+cwcLF
	UxbeJ+QbVa5TT7X2tByZv8Q+JZ6lch7rmy2bt0O86jiCV+/86wLJCpNk=
X-Gm-Gg: ASbGnctqrmCJS8DLCypa9PxBX07dVC4oM5qlYPaIMnhaROnnx4tmsspcs6au71fhEX4
	V3mD10wvmfhC1zLDBL86iU/o8VUaLZF30eeFjI+QC/5s7jpWVvrpa4U2l3fpKze6O60uzPvCObw
	aZhzAobCSFJxU7CCo6PEl2SRdn4Am+HzYG8pBXAZIZ6bT2KSFRAFuS/9TGM2gHNn09ZkukdH0pu
	hoUTigr2m9lHXXuT+rPjZVS2OPnv4lHFh6riYw5jvjxfczXdLnwV9O1XDnTKAH2rv2jqQ==
X-Google-Smtp-Source: AGHT+IEcOy75SVKzhqsvQgDX25DVxTD0tJpPOKTQLPBYv2km9cUYBIeJ/z3VSk/G5Ocsrz0txeVer6yWZkrnr5El9wQ=
X-Received: by 2002:a05:6808:c3eb:b0:44d:a4d3:b6a6 with SMTP id
 5614622812f47-4536e4f2683mr653938b6e.35.1764742148683; Tue, 02 Dec 2025
 22:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124-4ecf1b6b91b8f0688b762698@orel> <20251125141811.39964-1-fangyu.yu@linux.alibaba.com>
 <DEHZBIAB842A.1AUCJS0OR923@ventanamicro.com> <CAJF2gTTYwsG4Q6n3JWi8S4brOA_mh7OdpquMU-eJYAEHwDeSdw@mail.gmail.com>
In-Reply-To: <CAJF2gTTYwsG4Q6n3JWi8S4brOA_mh7OdpquMU-eJYAEHwDeSdw@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 3 Dec 2025 11:38:57 +0530
X-Gm-Features: AWmQ_bkb6N-7dICbNGOMVSKlH7NSygl6xNkVh8uyiwaa2kv1hzcn9J09Zs9Fkdk
Message-ID: <CAAhSdy0SU86SeAN+NHoYKUubfG8Z3nonge86kzvfdupWWc4-qA@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
To: Guo Ren <guoren@kernel.org>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	fangyu.yu@linux.alibaba.com, ajones@ventanamicro.com, alex@ghiti.fr, 
	aou@eecs.berkeley.edu, atish.patra@linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, palmer@dabbelt.com, pjw@kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2025 at 7:09=E2=80=AFAM Guo Ren <guoren@kernel.org> wrote:
>
>
>
> On Wed, Nov 26, 2025 at 2:16=E2=80=AFAM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>>
>> 2025-11-25T22:18:11+08:00, <fangyu.yu@linux.alibaba.com>:
>> >>> On Sat, Nov 22, 2025 at 3:50=E2=80=AFPM <fangyu.yu@linux.alibaba.com=
> wrote:
>> >>> >
>> >>> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> >>> >
>> >>> > Currently, HGATP mode uses the maximum value detected by the hardw=
are
>> >>> > but often such a wide GPA is unnecessary, just as a host sometimes
>> >>> > doesn't need sv57.
>> >>> > It's likely that no additional parameters (like no5lvl and no4lvl)=
 are
>> >>> > needed, aligning HGATP mode to SATP mode should meet the requireme=
nts
>> >>> > of most scenarios.
>> >>> Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP =
is
>> >>> reasonable.
>> >>
>> >>The documentation should be improved, but I don't think we want to sta=
te
>> >>that these parameters apply to both s- and g-stage. If we need paramet=
ers
>> >>to dictate KVM behavior (g-stage management), then we should add KVM
>> >>module parameters.
>> >
>> > Right, adding new parameters for g-stage management is clear.
>> >
>> > Or we could discuss this topic, from a virtual machine perspective,
>> > it may not be necessary to provide all hardware configuration
>> > combinations. For example, when SATP is configured as sv48,
>> > configuring HGATP as sv57*4 is not very meaningful, Because the
>> > VM cannot actually use more than 48 bits of GPA range.
>>
>> The choice of hgatp mode depends on how users configure guest's memory
>> map, regardless of what satp or vsatp modes are.
>> (All RV64 SvXY modes map XY bit VA to 56 bit PA.)
>>
>> If the machine model maps memory with set bit 55, then KVM needs to
>> configure Sv57x4, and if nothing is mapped above 2 TiB, then KVM is
>> completely fine with Sv39x4.
>>
>> A module parameter works, but I think it would be nicer to set the hgatp
>> mode per-VM, because most VMs could use the efficient Sv39x4, while it's
>> not a good idea to pick it as the default.
>> I think KVM has enough information to do it automatically (and without
>> too much complexity) by starting with Sv39x4, and expanding as needed.
>
> Good point; if only a 128GB GPA memory region is needed, there is no need=
 for Sv57x4, which costs PTW cycles.
>
> So, the detection should start from Sv39x4 to Sv57x4 with the guest memor=
y size.
>

NACK to the approach of detecting backwards.

HGATP mode is a per-VM attribute hence it makes sense
to define a VM-level KVM_CAP_RISC_xyz for this purpose.
The default behaviour should be use highest HGATP mode
unless KVM user-space changes the KVM_CAP_RISC_xyz
setting.

---
Anup

