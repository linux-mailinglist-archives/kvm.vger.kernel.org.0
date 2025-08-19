Return-Path: <kvm+bounces-55019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C19DFB2CAB2
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74FA25A728E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FFA30C35E;
	Tue, 19 Aug 2025 17:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fdN5z0p7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874FB30BF4E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624949; cv=none; b=X5s1JBB5tN8awjm0x953IylyPSpGG6MfwURm/A1sKtT4veWIIOZLQtY8vUkgsgSXdcdsA+ux3qbAqXJt4rvhpsdvx8/gJD8uiMBlsVr8JQH1c7eiLltpEabFKhA59sosB+wnoLR9cVATOIJVjRDrttx+o/cj2nJfPFbx8nk9aWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624949; c=relaxed/simple;
	bh=3lx/6/xRZF2aURKCYXk81xVXA9kIZnoFiaggniSCdKM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=i+1IaAgQwO+SfX00as4S5SXMyRqCCYie/He+iMJ2aaYfJps3fLzhn+WhjvG6UHDorJGgDakFZG9tObq9JteislblWlKRnproafjP1Us8hMUO12zT8AHS2AsBjeenXAhKLpzBf3+Q7ZTiEQSRlqFgTfG9bgHR4MI87t6AWjQCxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fdN5z0p7; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b054b36so1324625e9.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755624946; x=1756229746; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HriY9Mwm+2fMM0vnEvPFFz/UXLfXmL7avJoov+0cHIs=;
        b=fdN5z0p7Ve1LwKx8C8KdIcc6Hk+jxajMirUok34CF8jIAKlY4X/pulTnLgksyDj38R
         ySeTUzGp0hQH6w12RzNAYI5ffKWUJizaWd0DQKgAu4FJLs2haKDPAwOq+kcmUKuO3iuf
         n7h/dxhIQ9A61QQRKfdx2iRQgdao5WQn2kMahwsxxjWD120n/iq9aqPcPF8o0vmV6gKj
         KIX8lZUKgd5K+HRB5fzhmrb0NcqaYkSoRCJlrG7WvtbMrBnXOVlxVrQEMJojkxc10tvS
         aGIHp7NJnd5pzvccaXx4AQ4N9k4wQ0TMDpjQgCW2gGT7CeLYFM67mxU7wXz0irENZec6
         am6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755624946; x=1756229746;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HriY9Mwm+2fMM0vnEvPFFz/UXLfXmL7avJoov+0cHIs=;
        b=WoaE3KxQtVC0bPcMed/Eg6pTnGgeHzEddnS4NcbzOK8CJK3N96H0M0MXdegGPe6061
         P2hN0LOQYRT7JTAmbMPTahwTQ+5d/Cd7GSy9JawtOSeQJ3xQa3tpqnw8wMJ9UdA0RdQ4
         uRBKncX/m2Osr7yZ6hpHYuLegP4gmHfhXpGL5KSsq7WuXqwOxCp20EiyLsUEhDZ3AHIU
         HDbLTJTEfNjqoDzEVlEjOvDDkk+zpGbN0O1411StvAjcQwLlVj/JGR6deUz33bZzRMt0
         taMQDBD0g3JsjAutVWp6mu0rLa8T49Hj29xGuoAaNgemFGIlu/qX2/4ZX+DtHBEcgeWu
         HFsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKX/60LSGG482Z0Qq34DKzmNX7l7o5OE24D8UggAoLrIZt1aUu9NKzyyDBOE6KS5u9x24=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqwhXLUz6lh+6GQ65XJRwmt4ALzTcBrgEPTn4JFVygpdbloIJW
	Ps0bq9i0c5lfO9iQ1heXBcELmXMq7e1Ngjrw5J4Vygnb0swvkoFXfEWkT3pjBkwlVNw=
X-Gm-Gg: ASbGnctAPjJS2iJ0X2y4MZnIzX9eNycIku8ess5t2Wrf2Q13n1FSIpmPe8U0P15mngO
	PVEI2xhv21DNAa0Qya3dFpZCucRuXsfEBta3kgWwmvZN6pVtZlXRHGuPgtu0LEmweOAgDXl0Exe
	yqeevigUWgwAcLYndNW3AVGP6tDJiq010sj5eHAcz99L1QvdKMOxWhuYkZjtNETzIF4fRS78t2G
	3FIrSPGAPmP5oOx8sl4xfUixCSMfyntp1HLcQeomzhcU4GLKH2NViAUUEyrrnfUUtoBqsUGGM6x
	rrg7i4V2m5wfDDqB60hhR9d/y9MDoJFXFwMK9Od6sdC0iLdf0LSJ8NcQADUp/weso+SysGlKYE3
	kriCtbvL115tWT33LHZ9px4UEMiwpCQ==
X-Google-Smtp-Source: AGHT+IHdHc43/qbPeSuFvpTUjrq1NXmEH79kFa8+PuZKM64k2/KwBznp+KjWl/svIF/2Oq3kUoCIug==
X-Received: by 2002:a05:600c:468f:b0:453:7011:fcdb with SMTP id 5b1f17b1804b1-45b46b7681bmr4785225e9.1.1755624945689;
        Tue, 19 Aug 2025 10:35:45 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:e7d6:daad:8c97:a08e])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45a1c6bc85csm221551445e9.5.2025.08.19.10.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 10:35:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 19:35:44 +0200
Message-Id: <DC6L3PG5HP48.2J8TC1JZHMJVO@ventanamicro.com>
Cc: "Atish Patra" <atish.patra@linux.dev>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Andrew Jones"
 <ajones@ventanamicro.com>, "Anup Patel" <anup@brainfault.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Anup Patel" <apatel@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 0/6] ONE_REG interface for SBI FWFT extension
References: <20250814155548.457172-1-apatel@ventanamicro.com>
 <DC5HEJRMZ84K.34OPU922A7XBE@ventanamicro.com>
 <CAK9=C2X8-DBi7qQ87kMA0AiVdiFH0_4L4mzzZzbeCg2eiNm8Qg@mail.gmail.com>
 <DC6DLP13J0LA.XW9J3XFBCM1Y@ventanamicro.com>
 <CAK9=C2VA2jswYm_yxYsCaGKUkJT46rxUH-6OKdsApMZ8nhkrQw@mail.gmail.com>
In-Reply-To: <CAK9=C2VA2jswYm_yxYsCaGKUkJT46rxUH-6OKdsApMZ8nhkrQw@mail.gmail.com>

2025-08-19T21:22:27+05:30, Anup Patel <apatel@ventanamicro.com>:
> On Tue, Aug 19, 2025 at 5:13=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrc=
mar@ventanamicro.com> wrote:
>>
>> 2025-08-19T12:00:43+05:30, Anup Patel <apatel@ventanamicro.com>:
>> > On Mon, Aug 18, 2025 at 3:59=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <r=
krcmar@ventanamicro.com> wrote:
>> >>
>> >> 2025-08-14T21:25:42+05:30, Anup Patel <apatel@ventanamicro.com>:
>> >> > This series adds ONE_REG interface for SBI FWFT extension implement=
ed
>> >> > by KVM RISC-V.
>> >>
>> >> I think it would be better to ONE_REG the CSRs (medeleg/menvcfg), or =
at
>> >> least expose their CSR fields (each sensible medeleg bit, PMM, ...)
>> >> through kvm_riscv_config, than to couple this with SBI/FWFT.
>> >>
>> >> The controlled behavior is defined by the ISA, and userspace might wa=
nt
>> >> to configure the S-mode execution environment even when SBI/FWFT is n=
ot
>> >> present, which is not possible with the current design.
>> >>
>> >> Is there a benefit in expressing the ISA model through SBI/FWFT?
>> >>
>> >
>> > Exposing medeleg/menvcfg is not the right approach because a
>> > Guest/VM does not have M-mode hence it is not appropriate to
>> > expose m<xyz> CSRs via ONE_REG interface. This also aligns
>> > with H-extension architecture which does not virtualize M-mode.
>>
>> We already have mvendorid, marchid, and mipid in kvm_riscv_config.
>
> The mvendorid, marchid, and mipid are accessible via SBI BASE
> extension but not any other M-mode CSRs hence these are special.
>
>>
>> The virtualized M-mode is userspace+KVM.  (KVM doesn't allow userspace
>> to configure most things now, but I think we'll have to change that when
>> getting ready for production.)
>
> The RISC-V architecture is not designed to virtualize M-mode
> and there is no practical use-case for virtualized M-mode hence
> WE WON'T BE SUPPORTING IT IN KVM RISC-V.

Oh, sorry for the misunderstanding, I'll be clearer next time and talk
about implementation of the supervisor execution environment.
KVM+userspace provides SEE to the VS-mode, which is to VS-mode as what
M-mode is to S-mode, hence I called KVM+userspace a virtualized M-mode.

> FYI, the KVM ARM64 does not virtualize EL3 either and it is
> already in production so please stop making random arguments
> for requiring virtualized M-mode for production.

Yeah, I agree that we don't need it, I just had to provide so many
examples in the previous discussion that I went into quite niche cases.

The increased flexibility is similarly useful for more important cases:
we can't avoid "virtualized M-mode"/SEE, but we don't have to completely
implement it in HS-mode.

>> For general virtualization, we want to be able to configure the
>> following behavior for each exception that would go to the virtualized
>> M-mode:
>>   0) delegated to the guest
>>   1) implemented by userspace
>>   2-N) implementations by KVM (ideally zero or one)
>>
>> We can have medeleg, and another method to decide how to handle trapped
>> exceptions, but it probably makes more sense to have a per-exception
>> ONE_REG that sets how each exception behaves.
>>
>
> No pointing in discussing this further since we won't be supporting
> virtualized M-mode.

I understand, back to the current series:

I think we need to provide means with which userspace can control which
FWFT features are enabled, because KVM just exposes everything it know
and hardware supports right now:
 1) Migration between different systems would be hindered
 2) We couldn't add more FWFT features without breaking the SEE

The (2) is similar to how we must set ".default_disabled =3D true" to
current FWFT, because KVM can't be changing the SEE for userspace.

Do you want me to send a patch that inverts the default, to make all
future SBI extension start as disabled, so we can't easily repeat the
mistake in the future?

Thanks.

