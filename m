Return-Path: <kvm+bounces-18839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FAB48FC11B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06A121F23CFE
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D544A29;
	Wed,  5 Jun 2024 01:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Na9tMYLH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ABB2F2B
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 01:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717549927; cv=none; b=VO91GvvVNx8DeoUHE46kFQcKr4z8hei+PmtnyZZymGSBqe/P2HDgXDX6mg4Ijge9hFEdC14l+k2lk16dZ3VAajPWw5EWtMy5IG2hitv9etlFysQ8NtOn0iGnvu2w5wsPxbe1QYhlPB2Vr2ZQFrzJZ9PBzF9MAN4ExmXv0uIYrNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717549927; c=relaxed/simple;
	bh=/LLkHJGovNv0936YVh/pjDq+9ET5Q0SYn+sbn+N236I=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=fFYsqTXr+ihD1w4g15pgAJj7/ZSrtv1gYTepW1hExOFy3KeAgoVqJVM1pze7dZlbX2O4BF4SSlF++UtF6KnY9AFSA4raYS/UkxnlyNtQW9HcVaB/PwaPsvR3IqNcn6CPI98XGk7q/M3fSLRaHtALpj+OTPmUrn4Z6p+eP28ZCNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Na9tMYLH; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6570bd6c3d7so3597122a12.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 18:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717549926; x=1718154726; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mg9icTJf7q/C8B/s7FJ+6DOQWCc9dvuYjx2poaH9V4=;
        b=Na9tMYLH0yFYYy6TUBq298y4qhBGnnqCN3vmp6Xh9WlznGY9woqu8HjBSfdj+2PLda
         IluhcMRv4mOk4AmGPxRZzs7joZhpfioe9JpZkuaCuzkzxjUVIK3LpDBtgxYRzX4UXDdI
         ywXUGQfonY8es2Ny73j8g/M40Db529EE4kqTU3gSij7Zw1tSUE4bYBOhZcoqYMbWN4p4
         vcxJK5kazThxZw5USNVjyEJBaWkSTA1nGqP6blYHhAhZxCISvSKtO6LG/TWD9+u93SAl
         c6mfGr8Kj4/TPaBXR1YO2adxMr6mx0sQT8P6m3xIo24n2D/vVsPr+EYFIvhqBHa5U1ej
         Pbrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717549926; x=1718154726;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7mg9icTJf7q/C8B/s7FJ+6DOQWCc9dvuYjx2poaH9V4=;
        b=Dss+kHGBdPy0xbdLmq0ue6l6nTBhaA3CRZwvwt5A8ZZ61807anAW7i5UUmyAWnfj5z
         bTjHmJMr01i3C6nzE1lej7QfLfrUXNrdaJyPaeeJv6lFQdxjgp53A8mnYtVNbi6dNzSA
         a+I3CcqpQ6dwnQBcnWOmJFOCWl/GF4+uCd21KcZcqFIuq2A8YzfZ1StMihGGblEb357u
         yOW7wUSmklpjha8xPjJ92Pa5O01PP3qRDCu+AC7G+O9gzajhPPdvuprXIur7k5pCks26
         iEbeK6RowSmnk5JWAoA8QorAYOeq8sjdBSHPuOo9evt81213+FnVhgEKP2i6+nt7Ao4d
         9fhw==
X-Forwarded-Encrypted: i=1; AJvYcCXYdaAT1+7h6/g+B5XErbBdom0/YLfodZU3DzNX1PvZtjPQqIf5/XAIKqF8cCKB7QE8HgPw5aJtzrjomtS1T386usaS
X-Gm-Message-State: AOJu0YxN5XMtLvE7kEL2gr5EtaSpx8HHXSYrAhLM5QDY04cYi4L/R7GG
	zZD2+uQ19t4CclrQ9sIZCZG7fu3EHGTgxCuKvbt+QM+m/XdWeSe8
X-Google-Smtp-Source: AGHT+IHAN8yuwT5TYXqQlYO60/AC7Kw3lncIq7ij3rZhP8Jr5X8DuKTGYwfpJ/nIQtI0IrBMNP7RLQ==
X-Received: by 2002:a05:6a20:9708:b0:1af:f64c:b795 with SMTP id adf61e73a8af0-1b2b6fe2645mr1195842637.30.1717549925524;
        Tue, 04 Jun 2024 18:12:05 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f646456fb7sm76143705ad.146.2024.06.04.18.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:12:00 +1000
Message-Id: <D1ROMSW6KNIP.147TMWG5219NK@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 27/31] powerpc: add pmu tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-28-npiggin@gmail.com>
 <c497801d-f043-46f5-bfa2-74eff672ae47@redhat.com>
In-Reply-To: <c497801d-f043-46f5-bfa2-74eff672ae47@redhat.com>

On Tue Jun 4, 2024 at 8:38 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > Add some initial PMU testing.
> >=20
> > - PMC5/6 tests
> > - PMAE / PMI test
> > - BHRB basic tests
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> ...
> > diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
> > index a4ff678ce..8ff4939e2 100644
> > --- a/lib/powerpc/setup.c
> > +++ b/lib/powerpc/setup.c
> > @@ -33,6 +33,7 @@ u32 initrd_size;
> >   u32 cpu_to_hwid[NR_CPUS] =3D { [0 ... NR_CPUS-1] =3D (~0U) };
> >   int nr_cpus_present;
> >   uint64_t tb_hz;
> > +uint64_t cpu_hz;
> >  =20
> >   struct mem_region mem_regions[NR_MEM_REGIONS];
> >   phys_addr_t __physical_start, __physical_end;
> > @@ -42,6 +43,7 @@ struct cpu_set_params {
> >   	unsigned icache_bytes;
> >   	unsigned dcache_bytes;
> >   	uint64_t tb_hz;
> > +	uint64_t cpu_hz;
> >   };
> >  =20
> >   static void cpu_set(int fdtnode, u64 regval, void *info)
> > @@ -95,6 +97,22 @@ static void cpu_set(int fdtnode, u64 regval, void *i=
nfo)
> >   		data =3D (u32 *)prop->data;
> >   		params->tb_hz =3D fdt32_to_cpu(*data);
> >  =20
> > +		prop =3D fdt_get_property(dt_fdt(), fdtnode,
> > +					"ibm,extended-clock-frequency", NULL);
> > +		if (prop) {
> > +			data =3D (u32 *)prop->data;
> > +			params->cpu_hz =3D fdt32_to_cpu(*data);
> > +			params->cpu_hz <<=3D 32;
> > +			data =3D (u32 *)prop->data + 1;
> > +			params->cpu_hz |=3D fdt32_to_cpu(*data);
>
> Why don't you simply cast to (u64 *) and use fdt64_to_cpu() here instead?

Hmm... probably because I copied from somewhere. Good idea though.

>
> ...
> > diff --git a/powerpc/pmu.c b/powerpc/pmu.c
> > new file mode 100644
> > index 000000000..8b13ee4cd
> > --- /dev/null
> > +++ b/powerpc/pmu.c
> > @@ -0,0 +1,403 @@
> ...
> > +static void test_pmc5_with_fault(void)
> > +{
> > +	unsigned long pmc5_1, pmc5_2;
> > +
> > +	handle_exception(0x700, &illegal_handler, NULL);
> > +	handle_exception(0xe40, &illegal_handler, NULL);
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile(".long 0x0" ::: "memory");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	assert(got_interrupt);
> > +	got_interrupt =3D false;
> > +	pmc5_1 =3D mfspr(SPR_PMC5);
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile(".rep 20 ; nop ; .endr ; .long 0x0" ::: "memory");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	assert(got_interrupt);
> > +	got_interrupt =3D false;
> > +	pmc5_2 =3D mfspr(SPR_PMC5);
> > +
> > +	/* TCG and POWER9 do not count instructions around faults correctly *=
/
> > +	report_kfail(true, pmc5_1 + 20 =3D=3D pmc5_2, "PMC5 counts instructio=
ns with fault");
>
> It would be nice to have the TCG detection patch before this patch, so yo=
u=20
> could use the right condition here right from the start.

Yeah, it turned out to be a bit annoying to rebase. We already have
some kfail(true in the tree but I will remove those at least toward
the end of the series.

I might take another look at reordering it after I rebase what you
have merged.

>
> > +	handle_exception(0x700, NULL, NULL);
> > +	handle_exception(0xe40, NULL, NULL);
> > +}
> > +
> > +static void test_pmc5_with_sc(void)
> > +{
> > +	unsigned long pmc5_1, pmc5_2;
> > +
> > +	handle_exception(0xc00, &sc_handler, NULL);
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile("sc 0" ::: "memory");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	assert(got_interrupt);
> > +	got_interrupt =3D false;
> > +	pmc5_1 =3D mfspr(SPR_PMC5);
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> > +	asm volatile(".rep 20 ; nop ; .endr ; sc 0" ::: "memory");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	assert(got_interrupt);
> > +	got_interrupt =3D false;
> > +	pmc5_2 =3D mfspr(SPR_PMC5);
> > +
> > +	/* TCG does not count instructions around syscalls correctly */
> > +	report_kfail(true, pmc5_1 + 20 =3D=3D pmc5_2, "PMC5 counts instructio=
ns with syscall");
>
> dito
>
> > +	handle_exception(0xc00, NULL, NULL);
> > +}
> > +
> > +static void test_pmc56(void)
> > +{
> > +	unsigned long tmp;
> > +
> > +	report_prefix_push("pmc56");
> > +
> > +	reset_mmcr0();
> > +	mtspr(SPR_PMC5, 0);
> > +	mtspr(SPR_PMC6, 0);
> > +	report(mfspr(SPR_PMC5) =3D=3D 0, "PMC5 zeroed");
> > +	report(mfspr(SPR_PMC6) =3D=3D 0, "PMC6 zeroed");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~MMCR0_FC);
> > +	msleep(100);
> > +	report(mfspr(SPR_PMC5) =3D=3D 0, "PMC5 frozen");
> > +	report(mfspr(SPR_PMC6) =3D=3D 0, "PMC6 frozen");
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~MMCR0_FC56);
> > +	mdelay(100);
> > +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> > +	report(mfspr(SPR_PMC5) !=3D 0, "PMC5 counting");
> > +	report(mfspr(SPR_PMC6) !=3D 0, "PMC6 counting");
> > +
> > +	/* Dynamic frequency scaling could cause to be out, so don't fail. */
> > +	tmp =3D mfspr(SPR_PMC6);
> > +	report(true, "PMC6 ratio to reported clock frequency is %ld%%", tmp *=
 1000 / cpu_hz);
>
> report(true, ...) looks weird. Use report_info() instead?

Ah yes that's better. I was going to do a pass/fail threshold but that
gets pretty arbitrary depending on DVFS.. I guess for TCG we could report
a pass/fail.

Thanks,
Nick

