Return-Path: <kvm+bounces-44727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6E62AA087E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:25:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 368E316DBAD
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683A92BF3CC;
	Tue, 29 Apr 2025 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="BGEHGN5A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E3219301
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745922339; cv=none; b=qyRZ4Tage4NqC2SDUJkV5XItUs68K5/Vz07lwr4uxQwA24OvK0lAF4VOsemCgH1MZEZTtC79Gs7CWPivdmrlrs4gIDb3Si6CPwyNE+KGRITEM67IaXBiutzYa024eeUU90KTNunPZoKO7cdsqEfRvC8gCSdjWvB2HMT/dJzvrJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745922339; c=relaxed/simple;
	bh=Sz4clg6K/zfuAweaf2ZHVfowXiOQZLM+vN+jJWsg3fI=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=Zaeehtr6ijw47FjpHwdtjmyLowHCfvNjptFJY06/yeamAVCxPohAtJn1X9plCEbaoaeeSPNnfEEffnH7SieutcKQCDLpcWS2iNIXiBaN+cL3PQVNXJX7nDk8JkACdmFx6WZaEQyjbJW3fl94jTz8XR/qNSohUTuLkMpuS9d/6pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=BGEHGN5A; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cee550af2so3401455e9.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745922336; x=1746527136; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TusfjoOZJ9Q4uXowiWjYTIz+Nnd7Ky1WuLL0Fm5qU4=;
        b=BGEHGN5AjpGxWNAEud1yBjmadBdWxab9spx88F+Bkn0zjaeCG1EQ+SNxD0GkrFHnxP
         JzLWPYD7hulwGONnzuxB3My/ZBHhIQqPo8x+6uaVoO7ulw1dYmPii/By8GDDAEvDOh5t
         cALQvz/rSfBcgZsCbgsYznuDUK+cYpOd3p4vT4rDEF8z7UVRdIHbhRllmHq3uV9esyx7
         Pj2SoehES7CXivisNcMb9p1ZBWMDC5NfgIdtV9fZJatq0OUnpfjYoD/Hi+GYnk9SuYvI
         SWZPotKEfrtb+jFUKq7n15JgM3bYTYITokSTEmZRc4s148E+aoVjcZw74Vw33e0BqLcd
         gH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745922336; x=1746527136;
        h=in-reply-to:references:to:cc:subject:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1TusfjoOZJ9Q4uXowiWjYTIz+Nnd7Ky1WuLL0Fm5qU4=;
        b=lFBXAFYxxJCKBWpsPpe/XLykVR8wnPdSEe/RDIO8tXZA4Q4zjrvdiVdEUgVd7SmHhD
         3b3BBEbzIDav1qOlcCZBpKaEOat9HMdEBtvxyuOXG/PaXY4UVy+IMGohbPzzLoNY+BXu
         b+5SYWq5nlrVFdCqk3SBNQBhZJJNCK3I4AoLwopU4sckDKf+/RTT4wEJSBwDp2HTRUMz
         YJIQyyjz03fCSc/Ps68vuVaL6JVlxb4vZdlFJueOjDmszsvRNXEkCYzXsWluf4vc7xRQ
         dJ6iUFGVr98VulObgHjPiHM2vufY65XABYiQOG8u0kaxUmU3fgW96eOJLLJnh0RZ9qDD
         JYpA==
X-Forwarded-Encrypted: i=1; AJvYcCWFF3lw8gP77Fw5sHvJIdU5oElyFXbAx7sdgM+2dda8dgkcusxMUpti69NUhTxF1lhtVJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu2vfBD8H8W82U3pSkqcdPtaVMXk59IHsi6OCkVqp8g1/NNOyj
	BxUKnlZSqBAHVK4vkqthxkk07KR84GOa+m5dn7vyei8lKIXCNmZNrTHatwJf1gk=
X-Gm-Gg: ASbGncsURPRK5FUFYKAtz4cla3+xIJB9o/064N3565CzsCrC6qXBi1a6LVx6cZfraoa
	r31XPZVWoiUV+u/0tJNVBUIkS74ZiIKp0+03sf9lrB7yT+7QRkUJCiG+RbVmW9G28++vJxli13v
	A/nhB4SM2HT/KVCr1oWF21bjcpxgl16lulBwNxUheiD+z+Vh9iyziUGiAsIcW82Xg2r+5piGyq4
	HGZUN7/ZRnSJQRzBzcj5atHemNC7eTbBQFDtdi3GlUUjTWZYngjM7lTmaur7+ikkUL0CKa4vRwG
	VDE6lpsu8W1iGVJqCg+AGG3IEkw1fTONIqhKP+iwTEB27SdN
X-Google-Smtp-Source: AGHT+IFSvfqpgAXd79kfkhiAw4afJN5Oi0WwlrlH7IsWV6fC8ECQn6pF0EjB3PiabWQYmavQwiPMEQ==
X-Received: by 2002:a05:600c:3c86:b0:43d:745a:5a49 with SMTP id 5b1f17b1804b1-441ac890c15mr8097375e9.4.1745922335484;
        Tue, 29 Apr 2025 03:25:35 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:b996:f7e3:35e8:5091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a5369cdasm154999805e9.31.2025.04.29.03.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 03:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Apr 2025 12:25:33 +0200
Message-Id: <D9J1TBKYC8YH.1OPUI289U0O2C@ventanamicro.com>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
Subject: Re: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming
 runnable
Cc: "Anup Patel" <anup@brainfault.org>, <kvm-riscv@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Atish Patra" <atishp@atishpatra.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Andrew Jones" <ajones@ventanamicro.com>, "Mayuresh
 Chitale" <mchitale@ventanamicro.com>
To: "Anup Patel" <apatel@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
 <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
 <CAAhSdy0e3HVN6pX-hcX2N+kpwsupsCf6BqrYq=bvtwtFOuEVhA@mail.gmail.com>
 <D9IGJR9DGFAM.1PVHVOOTVRFZW@ventanamicro.com>
 <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>
In-Reply-To: <CAK9=C2Woc5MtrJeqNtaVkMXWEsGeZPsmUgtFQET=OKLHLwRbPA@mail.gmail.com>

2025-04-29T11:25:35+05:30, Anup Patel <apatel@ventanamicro.com>:
> On Mon, Apr 28, 2025 at 11:15=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkr=
cmar@ventanamicro.com> wrote:
>>
>> 2025-04-28T17:52:25+05:30, Anup Patel <anup@brainfault.org>:
>> > On Thu, Apr 3, 2025 at 5:02=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rk=
rcmar@ventanamicro.com> wrote:
>> >> For a cleaner solution, we should add interfaces to perform the KVM-S=
BI
>> >> reset request on userspace demand.  I think it would also be much bet=
ter
>> >> if userspace was in control of the post-reset state.
>> >
>> > Apart from breaking KVM user-space, this patch is incorrect and
>> > does not align with the:
>> > 1) SBI spec
>> > 2) OS boot protocol.
>> >
>> > The SBI spec only defines the entry state of certain CPU registers
>> > (namely, PC, A0, and A1) when CPU enters S-mode:
>> > 1) Upon SBI HSM start call from some other CPU
>> > 2) Upon resuming from non-retentive SBI HSM suspend or
>> >     SBI system suspend
>> >
>> > The S-mode entry state of the boot CPU is defined by the
>> > OS boot protocol and not by the SBI spec. Due to this, reason
>> > KVM RISC-V expects user-space to set up the S-mode entry
>> > state of the boot CPU upon system reset.
>>
>> We can handle the initial state consistency in other patches.
>> What needs addressing is a way to trigger the KVM reset from userspace,
>> even if only to clear the internal KVM state.
>>
>> I think mp_state is currently the best signalization that KVM should
>> reset, so I added it there.
>>
>> What would be your preferred interface for that?
>>
>
> Instead of creating a new interface, I would prefer that VCPU
> which initiates SBI System Reset should be resetted immediately
> in-kernel space before forwarding the system reset request to
> user space.

The initiating VCPU might not be the boot VCPU.
It would be safer to reset all of them.

You also previously mentioned that we need to preserve the pre-reset
state for userspace, which I completely agree with and it is why the
reset happens later.

>             This way we also force KVM user-space to explicitly
> set the PC, A0, and A1 before running the VCPU again after
> system reset.

We also want to consider reset from emulation outside of KVM.

There is a "simple" solution that covers everything (except speed) --
the userspace can tear down the whole VM and re-create it.
Do we want to do this instead and drop all resets from KVM?

