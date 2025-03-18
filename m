Return-Path: <kvm+bounces-41420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C37CA67B5D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E47257A2CED
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBB9212B32;
	Tue, 18 Mar 2025 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UMB5VEtQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14EF20CCF0
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320226; cv=none; b=Hp9DxxywC1yzGU02cUcfTRihh15uqK4tMhhSmCyGuhaJ4sLg9UWSOBFZ3dzan9bhmdz9FQSInHJdknbITYM2IdBYnDG70yY7aHGISkTGQGTRsUzX8izayc9NPuKrCDLbLcv88sfcOYDMY8Wi0k5Qg+32ZAUORT1bEAMupv2EAUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320226; c=relaxed/simple;
	bh=HfnCyJnpqVQfiCB0/RnmqToGYAJOIDIhOFOPIBG07hA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RGQvkqy8pPA+CCZEmvcKr9vvXwlgpfhatIMy8OYk2cWHA6HhoyjrRhobQrvkNQNSasmVnlwoS+wgtyEnfdm6m2DRoh85Y8wZEyIv0+gJb8ttX69+lMk+JIL1khTDtKP5J8pKwUURXWVKaIJzPPgyj2LC5ub/Lkb8+8iVQvNKAjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UMB5VEtQ; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e6412063976so2227790276.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 10:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742320224; x=1742925024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvJ1Chpj2jYmxujQHwHr5y5q3DIlYijmy0IxxUrM06M=;
        b=UMB5VEtQuH9mCAp/2WEgZierv/jVHS1MXOY/kUX43FpZG00FUhuo5VAGI9i4Yi+MIk
         b7FeQPEYxNVuiF44j2cdsHOVJd+m0uKVERg8Vhu70S8mE6UxxrbSb5bj1XnEjMhhWXYn
         v6hG1RxsF28yDZ7b1A/LXm/evW6SB7yWVjnovEdyQ4VcDTcga8clVK/DM7H2iuL7WpXl
         1GUVu0O6ArgUQ1SbzUZibWTpXEC0Vn63Nl2d3Q1k3cVAdW0l2dw06SdI+76DXNv+N5gY
         bc3uwRlTuQ5GIbbICgXU/JanuRqgvIXJDlny4PS8g57wJcgIEM+ZKmjNEQJeSGdjVoMt
         tLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742320224; x=1742925024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvJ1Chpj2jYmxujQHwHr5y5q3DIlYijmy0IxxUrM06M=;
        b=cSY9BPV40wTb7kf/12BqLnxTRv0rvsoKMzDguxKLar1o0rqjDsrCL5cMtL39qMoeT8
         IauCZI9jvtuQnqLCwWaGEwz8I+HT/rB6JcNhov2GhxLG2u8O1/Epv2FEKBfyI8uWoNVf
         7OB2OEpeaScOIMo4Nyw82A7JAuBTFHtseDWt38VELEuWwcCTM3OzUBQI5TOitjnNR2l4
         wpQ6AD5FqqejtIpyForxUmEGVbuWiW1xD+k9/3Kmcp+2h5anOiED//EkSw/dp8VOUJul
         w4GzkGHd46tgN6KyyzNMzhDmeHEk59N92PNeL+R+EXxBQKDRicvXteYlI9vxFd2upDF2
         hXSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYoaTA7jzESD2SWAomD5XbVVfKBiIBm+jL/tFyT5etJQptOMAj1OXYaQ0i5Yc9zU7q5Is=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDFt+7nIBpJzxKM/br65JUoZPpJS75h6y90gp7T8XDJNCrgN53
	u9i7OifycTtpCUBYVcKAPBStumiAoL2MN+ptJVJwli09bvdF1XVMmnZalQHECbpmxVrHnpf5S3S
	QhiuSB1NKaPxf/hj4tLPT9uN9aqSNiskmjtx06Q==
X-Gm-Gg: ASbGncu27PkUtSngH8YlHE2D7m1g4UZXFbnTpXsLCL5cZFyvF0SPT0FzF+vHcZO6f0S
	3MgXhPdTJxOF7FAp4y5fGfRnCsDZMm+Iq+tX4xBW93Fuuv21uQ7DUaLCsPcDiaDrrGuLkK1Zqit
	4a7VsD1gkTZ8dEvT728pg8ZnZnf4I=
X-Google-Smtp-Source: AGHT+IGorLR4vpvSPH7Y1YAxXeFqCzaxkKZMA/+kwGP1IAahctRspftJyPmwcr0ynAjnueUx7zlU29wbFehiSxJqtI8=
X-Received: by 2002:a05:6902:4812:b0:e65:c4be:6fb9 with SMTP id
 3f1490d57ef6-e6679026c82mr264264276.25.1742320223682; Tue, 18 Mar 2025
 10:50:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-12-pierrick.bouvier@linaro.org> <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
In-Reply-To: <8a24a29c-9d2a-47c9-a183-c92242c82bd9@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 18 Mar 2025 17:50:11 +0000
X-Gm-Features: AQ5f1Jq64ZMc3wNHD96Q-O52LvCc-sDu2DSilR-8cUO11vSS_VSAPQPzax2vqWI
Message-ID: <CAFEAcA--jw3GmS70NTwviAEhdWeJ1UXE+ucNSkR60BXk6G8B6g@mail.gmail.com>
Subject: Re: [PATCH 11/13] target/arm/cpu: remove inline stubs for aarch32 emulation
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	qemu-arm@nongnu.org, alex.bennee@linaro.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Mar 2025 at 17:42, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> On 18/3/25 05:51, Pierrick Bouvier wrote:
> > Directly condition associated calls in target/arm/helper.c for now.
> >
> > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > ---
> >   target/arm/cpu.h    | 8 --------
> >   target/arm/helper.c | 6 ++++++
> >   2 files changed, 6 insertions(+), 8 deletions(-)
> >
> > diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> > index 51b6428cfec..9205cbdec43 100644
> > --- a/target/arm/cpu.h
> > +++ b/target/arm/cpu.h
> > @@ -1222,7 +1222,6 @@ int arm_cpu_write_elf32_note(WriteCoreDumpFunctio=
n f, CPUState *cs,
> >    */
> >   void arm_emulate_firmware_reset(CPUState *cpustate, int target_el);
> >
> > -#ifdef TARGET_AARCH64
> >   int aarch64_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int=
 reg);
> >   int aarch64_cpu_gdb_write_register(CPUState *cpu, uint8_t *buf, int r=
eg);
> >   void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
> > @@ -1254,13 +1253,6 @@ static inline uint64_t *sve_bswap64(uint64_t *ds=
t, uint64_t *src, int nr)
> >   #endif
> >   }
> >
> > -#else
> > -static inline void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq=
) { }
> > -static inline void aarch64_sve_change_el(CPUARMState *env, int o,
> > -                                         int n, bool a)
> > -{ }
> > -#endif
> > -
> >   void aarch64_sync_32_to_64(CPUARMState *env);
> >   void aarch64_sync_64_to_32(CPUARMState *env);
> >
> > diff --git a/target/arm/helper.c b/target/arm/helper.c
> > index b46b2bffcf3..774e1ee0245 100644
> > --- a/target/arm/helper.c
> > +++ b/target/arm/helper.c
> > @@ -6562,7 +6562,9 @@ static void zcr_write(CPUARMState *env, const ARM=
CPRegInfo *ri,
> >        */
> >       new_len =3D sve_vqm1_for_el(env, cur_el);
> >       if (new_len < old_len) {
> > +#ifdef TARGET_AARCH64
>
> What about using runtime check instead?
>
>   if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) && new_len < old_len) {
>

That would be a dead check: it is not possible to get here
unless ARM_FEATURE_AARCH64 is set.

thanks
-- PMM

