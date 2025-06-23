Return-Path: <kvm+bounces-50356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 391B6AE4620
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B719016C984
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E54E253359;
	Mon, 23 Jun 2025 14:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="l3s9/f5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D1A130E58
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 14:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750687757; cv=none; b=efGD2Yqw5p78OopHuw9Z7z2pF5bAYaFIY/1ia3NFbQ1TZhKnUoUUdrBg6iF04OdF2p0xysqqcb7ciil2QpKcWquPyfK6ohobVxUqMf9iuFvSwk0CjXYfyoEu51LAVOnrh8ttBMgDnImqNETM1QzW8HF4bNRn11w88dU2s0FC3sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750687757; c=relaxed/simple;
	bh=C2tmbrwmI2DAu6nIk1nri7yiuu1MNBsSZUKZ+x6+5jI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JILa1ryxjAoY2NSrF3dq47JlKuJ5qp54wLQtPOGBOaGeL3EQMTQ7Y/L5Spa9CVdKSrTB4LAYsRq7ORNsIhv4L6ncFkdTxKfU6+0XD8FAwCe08A6+1rXP1WyLArllQZyhMKHbLQlybC8OOhnwqkLQkef1oR0AaCm0Y8PmtYggTrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=l3s9/f5Q; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-311a6236effso2789389a91.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 07:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750687754; x=1751292554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6cYOpmr7ejhSQ4NGHbHR+I2d9wPM35nKHPVPsDXvgEw=;
        b=l3s9/f5QI0rc3xAnoMX36U8qFEZzxjZSPw2uhHv0vcK+WLGKh4gyJUv/H3p3mOUxjS
         1U1cPNECtIg8cOLhzSesUNzhYrPYZNxeIhVulilD6Z2I5lZsJx3DqudPppYcVaTzSZZB
         CZF7pGKDig63COKveSEngbaMmDmX0WodOiMlOZTwYT6NB4abEZNP9d329mqAnZo6Jb/A
         pJol6CDwfUHqDUT0eJTERQTQO3dkUfJx62q1ssCeb4SZ/6GgedAPLeKOtey3k7g8oOg9
         lmmgy2RFC3HLKw6Lojyhn3RzarGJdo3XB+51QqMNKSNZF9zeK4nHume8Bmd3PBDGhQ9T
         eaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750687754; x=1751292554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cYOpmr7ejhSQ4NGHbHR+I2d9wPM35nKHPVPsDXvgEw=;
        b=R3iKjf/ZxbehNgrPnG6jGAUZkQ1ObHqaGVP7qGE5BQT5J/VjYLHfRoP25hJzF04rKg
         5jH+5ZL6LPhd95bUaZcAnPKIIAlNSrnuVn4Ia5HNb/L9hbQCITLruFfdMj2Vg3RL0Ag8
         zcEk/pl1xOeOpI9vPq0BMtqTLofyQcwxDlCHmWce52stZGzchHztRn9/5dLyBooc2TUg
         0+WUl6z4OUFRCiWiIpX0kPrFDvGUZVfA6jvc3DDXyCAFvzPS56t+bL296omhXOQexarl
         2tvtWEEmf0xyANlwGs2qQ08XSnEumnMNrJPxXUXp9gEnefZ6Z/GrPd53RWrIELr8UpDj
         7mtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWE08/9p5XyJaswktilGoI2q0PjBEzoOXDnkYfo0a6kCsmBOU2PfWStQA/V1YiC9AqgB0A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzuD1Rt8uyyoy5dZ6TU1MrHgSXDQ7n7WMyCX1bgFXW9JCH7rXx
	tLFeZSbOgqvYmowI/JxjF01dxp0Qw0bHUlBt6375Ii/DEJ0XEsM76NyHZuHGuYIL8Bo8pDvisXx
	YIhSy3SIMKx2dsN1KMpGeN3pPIF0sjBusqFE8pEuo7w==
X-Gm-Gg: ASbGncuiAzagCQ9ndM4rmfqRiq6yiFvx9OIDhuEGQ4xNRUn8GADE/qLU/3zTE7yhsRX
	spuX2xfIdCKB8Qrejco5DT8MvewGITW3gpaGvaCXMXl9zJLKsCLFjbJtWb4GN1WZ0JgrHea+M/b
	uuNaYsXNgKb18XVMKZybCZn2aF0lfonolLEz0Dvv3jx0oNU+QPRJVFAx4T
X-Google-Smtp-Source: AGHT+IEl1T3TohTpq5KxIngvVUlDJR7SLQRNvOOpNO1X72zLaXdZXqVz9cSwOMBrztsM8fp8gM2scP6AocjulndvZzo=
X-Received: by 2002:a17:90b:55c3:b0:312:f2ee:a895 with SMTP id
 98e67ed59e1d1-3159d8ff73bmr14894086a91.31.1750687753793; Mon, 23 Jun 2025
 07:09:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com> <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
 <CAPYmKFs7tmMg4VQX=5YFhSzDGxodiBxv+v1SoqwTHvE1Khsr_A@mail.gmail.com>
 <4f47fae6-f516-4b6f-931e-92ee7c406314@rivosinc.com> <CAPYmKFvT6HcFByEq+zkh8UBUCyQS_Rv4drnCUU0o-HQ4eScVdA@mail.gmail.com>
 <b9203c8d-4c34-4eb3-a94f-5455cfc2eb53@rivosinc.com>
In-Reply-To: <b9203c8d-4c34-4eb3-a94f-5455cfc2eb53@rivosinc.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 23 Jun 2025 22:09:02 +0800
X-Gm-Features: AX0GCFuZxXab4k58liWIS-sy5UXZPZcmAeAg0GwIw73oyms0WAn0rXaWlAM8SU0
Message-ID: <CAPYmKFtCx0qg4fEOVAhthXYvhu-X0MR5zXZLVfSmbCmNMN=ZYg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2025 at 9:42=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
>
>
> On 23/06/2025 15:30, Xu Lu wrote:
> > Hi Cl=C3=A9ment,
> >
> > On Mon, Jun 23, 2025 at 8:35=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger=
@rivosinc.com> wrote:
> >>
> >>
> >>
> >> On 23/06/2025 14:12, Xu Lu wrote:
> >>> Hi Cl=C3=A9ment,
> >>>
> >>> On Mon, Jun 23, 2025 at 4:05=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleg=
er@rivosinc.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 20/06/2025 14:04, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> >>>>> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> >>>>>> Delegate illegal instruction fault to VS mode in default to avoid =
such
> >>>>>> exceptions being trapped to HS and redirected back to VS.
> >>>>>>
> >>>>>> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> >>>>>> ---
> >>>>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/includ=
e/asm/kvm_host.h
> >>>>>> @@ -48,6 +48,7 @@
> >>>>>> +                                     BIT(EXC_INST_ILLEGAL)    | \
> >>>>>
> >>>>> You should also remove the dead code in kvm_riscv_vcpu_exit.
> >>>>>
> >>>>> And why not delegate the others as well?
> >>>>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
> >>>>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
> >>>>
> >>>> Currently, OpenSBI does not delegate misaligned exception by default=
 and
> >>>> handles misaligned access by itself, this is (partially) why we adde=
d
> >>>> the FWFT SBI extension to request such delegation. Since some superv=
isor
> >>>> software expect that default, they do not have code to handle misali=
gned
> >>>> accesses emulation. So they should not be delegated by default.
> >>>
> >>> It doesn't matter whether these exceptions are delegated in medeleg.
> >>
> >> Not sure to totally understand, but if the exceptions are not delegate=
d
> >> in medeleg, they won't be delegated to VS-mode even though hedeleg bit
> >> is set right ? The spec says:
> >>
> >> A synchronous trap that has been delegated to HS-mode (using medeleg)
> >> is further delegated to VS-mode if V=3D1 before the trap and the
> >> corresponding hedeleg bit is set.
> >
> > Yes, you are right. The illegal insn exception is still trapped in M
> > mode if it is not delegated in medeleg. But delegating it in hedeleg
> > is still useful. The opensbi will check CSR_HEDELEG in the function
> > sbi_trap_redirect. If the exception has been delegated to VS-mode in
> > CSR_HEDLEG, opensbi can directly return back to VS-mode, without the
> > overhead of going back to HS-mode and then going back to VS-mode.
> >
> >>
> >>
> >>
> >>> KVM in HS-mode does not handle illegal instruction or misaligned
> >>> access and only redirects them back to VS-mode. Delegating such
> >>> exceptions in hedeleg helps save CPU usage even when they are not
> >>> delegated in medeleg: opensbi will check whether these exceptions are
> >>> delegated to VS-mode and redirect them to VS-mode if possible. There
> >>> seems to be no conflicts with SSE implementation. Please correct me i=
f
> >>> I missed anything.
> >>
> >> AFAIU, this means that since medeleg bit for misaligned accesses were
> >> not delegated up to the introduction of the FWFT extension, VS-mode
> >> generated misaligned accesses were handled by OpenSBI right ? Now that
> >> we are requesting openSBI to delegate misaligned accesses, HS-mode
> >> handles it's own misaligned accesses through the trap handler. With th=
at
> >> configuration, if VS-mode generate a misaligned access, it will end up
> >> being redirected to VS-mode and won't be handle by HS-mode.
> >>
> >> To summarize, prior to FWFT, medeleg wasn't delegating misaligned
> >> accesses to S-mode:
> >>
> >> - VS-mode misaligned access -> trap to M-mode -> OpenSBI handle it ->
> >> Back to VS-mode, misaligned access fixed up by OpenSBI
> >
> > Yes, this is what I want the procedure of handling illegal insn
> > exceptions to be. Actually it now behaves as:
> >
> > VS-mode illegal insn exception -> trap to M-mode -> OpenSBI handles it
> > -> Back to HS-mode, does nothing -> Back to VS-mode.
> >
> > I want to avoid going through HS-mode.
>
> Hi Xu,
>
> Yeah, that make sense as well but that should only happen if the VS-mode
> requested misaligned access delegation via KVM SBI FWFT interface. I
> know that currently KVM does do anything useful from the misaligned
> exception except redirecting it to VS-mode but IMHO, that's a regression
> I introduced with FWFT misaligned requested delegation...
>
> >
> >>
> >> Now that Linux uses SBI FWFT to delegates misaligned accesses (without
> >> hedeleg being set for misaligned delegation, but that doesn't really
> >> matter, the outcome is the same):
> >>
> >> - VS-mode misaligned access -> trap to HS-mode -> redirection to
> >> VS-mode, needs to handle the misaligned access by itself
> >>
> >>
> >> This means that previously, misaligned access were silently fixed up b=
y
> >> OpenSBI for VS-mode and now that FWFT is used for delegation, this isn=
't
> >> true anymore. So, old kernel or sueprvisor software that  included cod=
e
> >> to handle misaligned accesses will crash. Did I missed something ?
> >
> > Great! You make it very clear! Thanks for your explanation. But even
> > when misalign exceptions are delegated to HS-mode, KVM seems to do
> > nothing but redirect to VS-mode when VM get trapped due to misalign
> > exceptions.
>
> Exactly, which is why I said that either setting hedeleg by default or
> not will lead to the same outcome, ie: VS-mode needs to handle access by
> itself (which is a regression introduced by FWFT usage).
>
>
> > So maybe we can directly delegate the misaligned
> > exceptions in hedeleg too before running VCPU and retrieve them after
> > VCPU exists. And then the handling procedure will be:
> >
> > VS-mode misaligned exception -> trap to VS-mode -> VS handles it ->
> > Back to VU-mode.
>
> I'd better want to let the HS-mode handle the misaligned accesses if not
> requested via the KVM SBI FWFT interface by VS-mode to keep HS-mode
> expected behavior. As you pointed out, this is not currently the case
> and the misaligned exceptions are directly redirected to VS-mode, this
> differs from what was actually done previously without FWFT (ie OpenSBI
> handles the misaligned access).
>
> To summarize, I think HS-mode should fixup VS-mode misaligned accesses
> unless requested via KVM SBI FWFT interface, in which case it will
> delegates them (which is done by the FWFT series). This would match the
> HS-mode <-> OpenSBI behavior.

Great! Roger that. Hope it can be fixed in the future.

>
> Thanks,
>
> Cl=C3=A9ment
>
> >
> > Please correct me if I missed anything.
> >
> > Best Regards,
> >
> > Xu Lu
> >
> >>
> >> Note: this is not directly related to your series but my introduction =
of
> >> FWFT !
> >>
> >> Thanks,
> >>
> >> Cl=C3=A9ment
> >>
> >>>
> >>> Best Regards,
> >>> Xu Lu
> >>>
> >>>>
> >>>> Thanks,
> >>>>
> >>>> Cl=C3=A9ment
> >>>>
> >>>>>
> >>>>> Thanks.
> >>>>>
> >>>>> _______________________________________________
> >>>>> linux-riscv mailing list
> >>>>> linux-riscv@lists.infradead.org
> >>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
> >>>>
> >>
>

