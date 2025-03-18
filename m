Return-Path: <kvm+bounces-41432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A921A67BA4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9D9917BC61
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61058212B3D;
	Tue, 18 Mar 2025 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C9/SqLq9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191D212B0C
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742321196; cv=none; b=Aonn57kGoPrJxvwyI//myeHpNJN8P3gpPc/LV/Up4tBsi8Gi3uysjZRTdWc0NJ2zNycJ15iC673jbGYJ68gEgAWh+ewQpIG6dxV/KgMXk50lgdbQY9CZpu+MThobVQU6hErHIP2eVLXa9C0/WQO26EEu2+tr6wVa2dWz/M9es9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742321196; c=relaxed/simple;
	bh=SgeIxsT4lJaCS6YWl9Jg1PXvl4hRl3t8bvPxTdVy9hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIicnOEJuSsWVdzw5H/Sqc97Dvgcy1KWa3Kj8of5FZI8hup2cx1t5jILmh5uEmrcy9/dmIn8ceTdgzc1XQOs9GnD4lfGUE/4enQ3T73Ltuzahr14Et08ynXJLDqgFvZUmWMf4HfLadSoLdbKTL21TZvooA8whSNzboC02oBQt64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C9/SqLq9; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e63504bedd0so4083015276.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742321193; x=1742925993; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIKBRtlhzPsM9FYHmDEFkH3srgSNrGh/z0c4h/04G2w=;
        b=C9/SqLq9hX0gR97g69FaSlJ7N0qfvt7xDKl3bS59Byw4CkXQ0GvFNVJnNUUHERh2HI
         20xD4jd2RPNmwd9K+6Hmf3P62cZc4ORyCUANzUHTp25TlKw9srTsr1OimxPr0TqQ2td1
         HdWYlcxDJEd/zpOsRj/ZY5fbfta3RvhMJ7yvRDooRl8YuHqVA0u8qgdBD7gtab8RE6WQ
         efPBuji85nkUycrDPaVSsBZ+A3CB9beiLqPuedjGBZlb9FoqDg4FWvXiY507E/7pIKFV
         6gluIOyyh1qBNSJ4KS/jPicSWVNBI+UpAGn04HbaO4VGPOIdnMD3A77kPGqFq1sDRxO6
         fq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742321193; x=1742925993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIKBRtlhzPsM9FYHmDEFkH3srgSNrGh/z0c4h/04G2w=;
        b=EpytV8dIewcT45Ul6ayioNTBg/K9km40Z3rVxOjUH/J3XzamuFMzP4hnLtcReAK+Hz
         S85p+4D5Ctn7zC9bI53vSEuGXVVkyVx5EkdGJ8r/mGRBVGQyxaWt31IRUn2c0NHQvgCp
         Xb75qcWKawqVl/krLsiZlad8JL782s0AWkzpE4X7GY9/gjlbcEn3Rdyn0bNjxhjk0Yhn
         JEjTjGjpA9FRDpLBArT6N3vCaA5cYow/J1PdPALTk2DdWSPQe7I/AjKdEJ5zEQ+dkhky
         4tha+Ny056gVE4i8ihEm6Eq2w6lj6iLzsBxU/g1Zeq8zx+PEwcFYxe5egZHHWYEvhVGU
         4gWg==
X-Forwarded-Encrypted: i=1; AJvYcCXyzxo8F5A0ejWsSrVGIoXj31wIx2+VLpLIwc0/Njk5PC1dFiNvipLmfHA5Ztf+8kPqZlo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8fb5OfirNr2sOOWWn4uHKGDfZWmbZNKsttjbaDQ1WoSieAoKh
	ve+Z9VJWrq9RzBrIJ3CGJDS9+pz9YekoxhzGmPsN9iYL4WEoXeRgbv0B5qk0I4U2J1HXe3KHUnE
	csRkCDXFnQDEHAvpHo7u5yWR5DDVgGP6gRkGkSA==
X-Gm-Gg: ASbGnctB9jb5ZGzCo68a5zj3nqtwxkd5xpZR21JQr066uL003/+9rEoRHvwJNuPprLh
	rU1VwH4vFjtZsLB1qdRAFMSr/oIJJo06J2jhMo9DDtdbUoE05aA70Hy9k1pftfmN4uZlEDMJ8Al
	t9eqoI14Hp4jy6prTLuTVieUI2R4A=
X-Google-Smtp-Source: AGHT+IFgxkES2TvRDqY5GNivdNl51kTxz2g9VDNygV9JwUiXyElJy4gopiu2DAfAvXAWyzKjQGh6IUkQZopqxj4Z26Q=
X-Received: by 2002:a05:6902:2405:b0:e5d:d9e4:532e with SMTP id
 3f1490d57ef6-e63f652e146mr20848324276.24.1742321193595; Tue, 18 Mar 2025
 11:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org> <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
 <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com> <a3b61916-2466-4ec8-a4e1-567581be7a2b@linaro.org>
In-Reply-To: <a3b61916-2466-4ec8-a4e1-567581be7a2b@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 18 Mar 2025 18:06:22 +0000
X-Gm-Features: AQ5f1JpnElkFWteuW9nidJdWxKahaGJiIURK8S1_MEu9ArX9YDqVQFuSsoQL1Lk
Message-ID: <CAFEAcA9jsFqD-BR+zTzWV1V92fJqpghaOrGq1rDcdidm=R94Pw@mail.gmail.com>
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32 emulation
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	qemu-devel@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	qemu-arm@nongnu.org, alex.bennee@linaro.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Mar 2025 at 17:52, Pierrick Bouvier
<pierrick.bouvier@linaro.org> wrote:
>
> On 3/18/25 10:50, Peter Maydell wrote:
> > On Tue, 18 Mar 2025 at 17:42, Philippe Mathieu-Daud=C3=A9 <philmd@linar=
o.org> wrote:
> >>
> >> On 18/3/25 05:51, Pierrick Bouvier wrote:
> >>> Directly condition associated calls in target/arm/helper.c for now.
> >>>
> >>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> >>> ---
> >>>    target/arm/cpu.h    | 8 --------
> >>>    target/arm/helper.c | 6 ++++++
> >>>    2 files changed, 6 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> >>> index 51b6428cfec..9205cbdec43 100644
> >>> --- a/target/arm/cpu.h
> >>> +++ b/target/arm/cpu.h
> >>> @@ -1222,7 +1222,6 @@ int arm_cpu_write_elf32_note(WriteCoreDumpFunct=
ion f, CPUState *cs,
> >>>     */
> >>>    void arm_emulate_firmware_reset(CPUState *cpustate, int target_el)=
;
> >>>
> >>> -#ifdef TARGET_AARCH64
> >>>    int aarch64_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, =
int reg);
> >>>    int aarch64_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, in=
t reg);
> >>>    void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
> >>> @@ -1254,13 +1253,6 @@ static inline uint64_t *sve_bswap64(uint64_t *=
dst, uint64_t *src, int nr)
> >>>    #endif
> >>>    }
> >>>
> >>> -#else
> >>> -static inline void aarch64_sve_narrow_vq(CPUARMState *env, unsigned =
vq) { }
> >>> -static inline void aarch64_sve_change_el(CPUARMState *env, int o,
> >>> -                                         int n, bool a)
> >>> -{ }
> >>> -#endif
> >>> -
> >>>    void aarch64_sync_32_to_64(CPUARMState *env);
> >>>    void aarch64_sync_64_to_32(CPUARMState *env);
> >>>
> >>> diff --git a/target/arm/helper.c b/target/arm/helper.c
> >>> index b46b2bffcf3..774e1ee0245 100644
> >>> --- a/target/arm/helper.c
> >>> +++ b/target/arm/helper.c
> >>> @@ -6562,7 +6562,9 @@ static void zcr_write(CPUARMState *env, const A=
RMCPRegInfo *ri,
> >>>         */
> >>>        new_len =3D sve_vqm1_for_el(env, cur_el);
> >>>        if (new_len < old_len) {
> >>> +#ifdef TARGET_AARCH64
> >>
> >> What about using runtime check instead?
> >>
> >>    if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) && new_len < old_le=
n) {
> >>
> >
> > That would be a dead check: it is not possible to get here
> > unless ARM_FEATURE_AARCH64 is set.
> >
>
> We can then assert it, to make sure there is no regression around that.

We have a lot of write/read/access fns for AArch64-only sysregs, and
we don't need to assert in all of them that they're called only when
the CPU has AArch64 enabled.

> We now have another conversation and something to decide in another
> file, and that's why I chose to do the minimal change ("ifdef the
> issue") instead of trying to do any change.

I think we can fairly easily avoid ifdeffing the callsite of
aarch64_sve_narrow_vq(). Currently we have:
 * a real version of the function, whose definition is inside
   an ifdef TARGET_AARCH64 in target/arm/helper.c
 * a stub version, inline in the cpu.h header

If we don't want to have the stub version with ifdefs, then we can
move the real implementation of the function to not be inside the
ifdef (matching the fact that the prototype is no longer inside
an ifdef). The function doesn't call any other functions that are
TARGET_AARCH64 only, so it shouldn't be a "now we have to move
50 other things" problem, I hope.

thanks
-- PMM

