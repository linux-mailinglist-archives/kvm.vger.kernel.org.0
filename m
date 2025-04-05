Return-Path: <kvm+bounces-42779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B18BDA7C7ED
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 09:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5705D17962F
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 07:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C7181C7004;
	Sat,  5 Apr 2025 07:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3p/DIWVS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12967E110
	for <kvm@vger.kernel.org>; Sat,  5 Apr 2025 07:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743837910; cv=none; b=BRTxzIiMYCyoTjPnFEJqW1946PLTUZbsuPaF8Mlu7g0VLyX7/epQqBMbWc7U5n/2Dk1J+eiDTtVP9coEMOFCeDtP5138ETaYCL1ETFx46Y60oQZLad0EI4lWZqPL/RvsPcAkTkLv5zMIS7AxRTo3p7Rc8WzRgCI7E34VCs8cS6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743837910; c=relaxed/simple;
	bh=n4MZYYisUTv91SMu059CZDcK16d3itbrI26o+eVIrbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqWjkNAvjHO+Xh7OsmWMRLOko2VvL001lYS9/FMbNi414h+mV1u57KP/kSNsAEKsuCNOnTWbWAd/4ZuM0VX0KQrT6KYZxdLSHYv81sclj0ogYdMK+DorDdy/uwBmYH2ZW0M0Tj2YiWrFCugVNEREly35kylKUjUCGEtvkyqetTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3p/DIWVS; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6eeb7589db4so29056016d6.1
        for <kvm@vger.kernel.org>; Sat, 05 Apr 2025 00:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743837907; x=1744442707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XX7bM7smVAeMPEyjLjvRTNRXt7yjh/9WIZIsi5RXZB8=;
        b=3p/DIWVSKzSstTBoadH41eLMH8TCT03PcXZwSEOpl6iznwTC+L0tPlke44Zy3BkjrY
         Fxte6j6ks4ySNYSZwJqJBuN1tSEPpYYqmcOaTiWAe8OFB1fxkEd5HbSAXlQBSK8Fg4O7
         F+t+B1UoQSwKODzI3BUotr6Vo/0yf2ZgVdaklsbytHfehkyxBOzSpLE2z+CbZ44gJVZD
         nJBSPzxNmiQtci0ue41Wq0nSq2xHoN67BqwGrz5TChO1M2+J9Vv0sLyuCh3ai3LP9Jey
         etxt9NBfbGSfQKI7WvkcycxBO0P2csnJJeMa613ktkkbIgoN3xC3U67R//QhP4RJ16UE
         3oWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743837907; x=1744442707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XX7bM7smVAeMPEyjLjvRTNRXt7yjh/9WIZIsi5RXZB8=;
        b=MRvnnqOWSmGgPkWlvhYHhH8Gush31tHbmm77ew7MMAUN0OLmCHQ1NQBa34OkvqV1PB
         t/xDrMJgjAVojxUNeWfu4wWtnuQ3hjq+xiSWE0v0REdzsW2syxtY+AmqAA5Hzj+dkadP
         euXM6aC7Ntuw4/UdlJn1R/RDNFSmAE3s+Kn8g85h9wLWadhNhOb3TL+1W1WYwaIwt2Fw
         1xB/t/4XIG2qL6Lva3PJHcS2Km9/PnextAZQPQvAGbmrsWjqK4utxCDqwX6DCuRacPiV
         ZD1y68etnuFg87Hz9G8iK8Z0HVu/F9rnToGK1t8K1RJrRO0cEnlXYSRlBoi3VQLiUxDQ
         LbeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBw6ipA7TSLMdhrmIzuqVvbXDCOsz7vewEITPaxP7UIUmo5fXc6e14AsFm+gQ0oRwSMwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhRLwyFsvX/nktvyUMeb3CkYVMJN8mlFO1tfFn+rfQEr0WbTBU
	Bb0LBQxUDHUQ20cuajVzHVxyD+iEb01njS/9WQnkbnoivM+H2wokKLdMyUfAZp1fGZTDA7dPW1D
	1F4RBLtnDjYc/4UGdn8evw8WcRFdGORDtJE94
X-Gm-Gg: ASbGncs1TQSOlUHRaZfFsybmk04/2vavLrHDkGhpDrhabYtwrnszQiSN8mspOqDHuAe
	6Dm4RzKxgqeUsL3i2CfqAaeRVn+Y/9v9x4BB56mp+R3AlvjxbbDepNmjzdiMeGTM5n4vXzZzWSI
	Z9ikxpfEHEAYlEmTy3OUlUMhsqsFoV
X-Google-Smtp-Source: AGHT+IEBa0i9vPf6f61GmMvD/z+/H4ytphtU5TfuJkfc666vsFTrSVQNYgEVIEFGNoq5dLW5dX8oZPwKczqMDob6pwE=
X-Received: by 2002:a05:6214:1942:b0:6e6:5efa:4e01 with SMTP id
 6a1803df08f44-6f0584992abmr98688636d6.20.1743837907386; Sat, 05 Apr 2025
 00:25:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250405001042.1470552-1-rananta@google.com> <20250405001042.1470552-3-rananta@google.com>
 <CAL715WKaAHSgUhtMMT3Ztw90mMoHpVLdKUgVM15xx6yoUws9+Q@mail.gmail.com> <Z_CaiKsi42ho8DoK@linux.dev>
In-Reply-To: <Z_CaiKsi42ho8DoK@linux.dev>
From: Mingwei Zhang <mizhang@google.com>
Date: Sat, 5 Apr 2025 00:24:30 -0700
X-Gm-Features: ATxdqUFSBfa7-XbKoczeoC0dul0kdW1Dd_fQ6H4YubDg3n4C0rMG-CxZUVYFoCQ
Message-ID: <CAL715W+v-BgHr5FwgDnct5nQ3RV-FXMkuSaCG7DaDoQVnZeDpg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page
 attrs to Inner-Shareable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Raghavendra Rao Ananta <rananta@google.com>, Marc Zyngier <maz@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2025 at 7:51=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Fri, Apr 04, 2025 at 05:31:49PM -0700, Mingwei Zhang wrote:
> > On Fri, Apr 4, 2025 at 5:10=E2=80=AFPM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > Atomic instructions such as 'ldset' over (global) variables in the gu=
est
> > > is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> > > DEFINED fault (Unsupported Exclusive or Atomic access)). The observat=
ion
> > > was particularly apparent on Neoverse-N3.
> > >
> > > According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
> > > restrictions on using atomic instructions), atomic instructions are
> > > architecturally guaranteed for Inner Shareable and Outer Shareable
> > > attributes. For Non-Shareable attribute, the atomic instructions are
> > > not atomic and issuing such an instruction can lead to the FSC
> > > mentioned in this case (among other things).
> > >
> > > Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
> > > load/store), it is implementation defined that a data abort with the
> > > mentioned FSC is reported for the first stage of translation that
> > > provides an inappropriate memory type. It's likely that Neoverse-N3
> > > chose to implement these two and why we see an FSC of 0x35 in EL1 upo=
n
> > > executing atomic instructions.
>
> Ok, can we please drop this second reference?
>
> This is talking about something else (FEAT_LS64) that happens to share
> the same FSC as an unsupported atomic instruction. I mentioned this to
> you internally as an illustration of how different implementations may
> behave when determining if the attributes support a particular access,
> but it isn't actually relevant to this change.
>
> > nit: It's likely that Neoverse-N3 chose to implement this option (the
> > first option) instead of reporting at the final enabled stage of
> > translation
>
> I would much rather we rely on the language that describes what the
> architecture guarantees rather than speculate as to how Neoverse-N3
> behaves.
>
> Mentioning that the breakage was observed on Neoverse-N3 is still useful
> to add to the changelog.
>
> > I have minor question here: The DDI0487L C3.2.6 (Single-copy atomic
> > 64-byte load/store) mentioned
> >
> > """
> > When the instructions access a memory type that is not one of the
> > following, a data abort for unsupported Exclusive or atomic access is
> > generated:
> >
> > =E2=80=A2 Normal Inner Non-cacheable, Outer Non-cacheable.
> > """
> >
> > So, the above is the "Normal Inner Non-cacheable", but in our case we
> > have "Normal and non-shareable" in stage-1 mapping, right? I know it
> > is very close, but it seems the situation is still only "one bit" away
> > in my understanding...
>
> This citation relates to FEAT_LS64. If you look at B2.2.6 instead, it
> reads:
>
> """
> The memory types for which it is architecturally guaranteed that the
> atomic instructions will be atomic are:
>
>  - Inner Shareable, Inner Write-Back, Outer Write-Back Normal memory
>    with Read allocation hints and Write allocation hints and not
>    transient.
>
>  - Outer Shareable, Inner Write-Back, Outer Write-Back Normal memory
>    with Read allocation hints and Write allocation hints and not
>    transient.
> """

Agree that the above should be the right place to cite. C3.2.6 seems
to discuss atomic instruction with memory attributes bits(which points
to MAIR_EL1 and MAIR_EL2?). In this case, it is more related to
shareability bits instead.


>
> and
>
> """
> If the atomic insturctions are not atomic in regard to other agents that
> access memory, then performing an atomic instruction to such a location
> can have one or more of the following effects:
>
> [...]
>
>  - The instruction generates an IMPLEMENTATION DEFINED fault reported
>    using the Data Abort Fault status code of ESR_ELx.DFSC =3D 110101
> """
>
> The memory type used by KVM selftests is *Non-Shareable*, which is not
> one of the memory types guaranteed by the architecture to work.
>
> Thanks,
> Oliver

