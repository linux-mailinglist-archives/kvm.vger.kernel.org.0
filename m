Return-Path: <kvm+bounces-50351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 368CCAE43D6
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8901BC039B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DA2253925;
	Mon, 23 Jun 2025 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lzwbfBNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B065230BC2
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685421; cv=none; b=Hv/nUsNkzNqE28U1ckOyWxfbDywAcXYNn26fm1ahbZJLuEfuTITpMtNF14H3WJ2LM4d/R9wqXPhhgoHPWqXajHEEFFSJN4aNFyYB/m5mTAPCbBOCQXJTynSLy65ORsm35Idj289B16+vuHXRFm7GsQx1ncuh2s6YU4GsxvqDvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685421; c=relaxed/simple;
	bh=yXENaxznHI2XmmlyfveMuaijNIpAY+BCUlQPaEn5SX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=soymJDQKJhgd0xp8C/yqL0otVn6MZBz/tPcL3UuRebgX3cUC4GU3g944Drxdmpl1MeuPVxbizlmnC80mwJCbjR2pZr5PNH6ytnrGD+TqxhkaasJxHuYdL9+h+Aud5qQ7H/5Sm0bBoxk/aGZA+f2zLGSpNDkGkf6zFOvQTArCVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lzwbfBNl; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b31d489a76dso3525058a12.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 06:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750685419; x=1751290219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKn166nhd2vRAB+vjvAn9tp9brfNmr3hAAU8p4nKNcM=;
        b=lzwbfBNlaYbeDLvI9UqhHP0hSvyijK+sJkKJpfY+B1jfPxlPJdMFBCLcjcqB8u4zNQ
         EDUkcXtUo594q4zM2o1xM/89HAqT9abcNiy724PsdDdngwBX99Q6wa+uHYSqXC1sFJvX
         ntI8PqxsHxVzbpunudNjj9pGAKCN6N7VNMfiVjMm8JAtF0SA/mg9W4/mxOISqfELg/2M
         Ey8xUtwSODHeMQ/XLMZiihyXOzGBrarpez6ET8PBHdKSSjbhoxfA9X2muPdNTZSqdNmw
         DvlQTolrDQ7YsdnqlT0teqxRkre2YZIOSEpMe+QDi7HeuJeRmiOkcZSGnJWhW0v3oXwF
         8XLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750685419; x=1751290219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKn166nhd2vRAB+vjvAn9tp9brfNmr3hAAU8p4nKNcM=;
        b=deY+2DgOFqt7KBXONApXFBRpG7dLfZcM4BkgxUKZ2CBZEiI/TKWWrDmt9SEs+JRN3S
         nteQG07nLjYLKn8doXvAdMv6CjIoRWH4ztAUhT/Dxa8wLVi75v6HsnUhqfu7M3KDpG6b
         LYVkDmq6j8DZlurvgkM/EaE56XAWLyaMJ1ZMSlF8BwBt87QKAZ4U4wC0xeKy/zBbNoQ+
         2prkhrFj4CTfw2BWbr/Y73UXq04Og1E3iytOiaZ6utwJRSIrVSiR77aouT28CJM077DA
         KqyezPqQRjXjdAvLTAhsCLZThDemAQ2aSCzQefeXYT7E5doxbvUv4dfA5gLzOicWcgV/
         q5ow==
X-Forwarded-Encrypted: i=1; AJvYcCVMeqBjLOew+PWxtooevDy3/VAF/kIc2D/OCyBxMxS6M0G6GDbwc5R5E0kIveJLxJxqLz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHf8mkUjk4bZcZ/Dzer1XXsE4TNOVW47JJ6KPzoV1/vy/GaqhI
	QSPAndojEI2fevbFNmc80chF1Tjgl8FDh8eB0Mjg+kFjQfTbjZdHC90d7Tz9gkUGmNhaMlUoCVX
	9qDDzKGdUeHOia/M6TDJnKBHz42fJCnSvtuXo1mS5xg==
X-Gm-Gg: ASbGncuh6LQ/gZWUqRXU8heX7D0iljnkFeqqPLboUFpr56vpoVVJboPGywUAXhfe4z3
	1mokSkSpVMt48JGXMhBADtHEK7mq5DfD6+ZlBXnFkyItRMmHZva05j3uQ8BOKhUFZoItdsNNcke
	dosab3FtvHpgW/cxRbueou88zd+D5RA+f6KoxR0UV355KQZgBLfBoOyzyb
X-Google-Smtp-Source: AGHT+IHF1Hcuk/RAkT+EseXWRNvrv+2qmNTXnsVVg6nxOR87Q4OB77LUweEQu2VwDvVZDZZRDNtkS3pR8bqS8cw2TjI=
X-Received: by 2002:a17:90b:1f8b:b0:311:e8cc:424e with SMTP id
 98e67ed59e1d1-3159d8d685dmr23055733a91.24.1750685418484; Mon, 23 Jun 2025
 06:30:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250620091720.85633-1-luxu.kernel@bytedance.com>
 <DARCHDIZG7IP.2VTEVNMVX8R1E@ventanamicro.com> <1d9ad2a8-6ab5-4f5e-b514-4a902392e074@rivosinc.com>
 <CAPYmKFs7tmMg4VQX=5YFhSzDGxodiBxv+v1SoqwTHvE1Khsr_A@mail.gmail.com> <4f47fae6-f516-4b6f-931e-92ee7c406314@rivosinc.com>
In-Reply-To: <4f47fae6-f516-4b6f-931e-92ee7c406314@rivosinc.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 23 Jun 2025 21:30:07 +0800
X-Gm-Features: AX0GCFuZrApuLifWgQXPn_CdwuukUUywAVgWxIPzad1ai5Q1hxJEOckJdpBbxn8
Message-ID: <CAPYmKFvT6HcFByEq+zkh8UBUCyQS_Rv4drnCUU0o-HQ4eScVdA@mail.gmail.com>
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

Hi Cl=C3=A9ment,

On Mon, Jun 23, 2025 at 8:35=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger@riv=
osinc.com> wrote:
>
>
>
> On 23/06/2025 14:12, Xu Lu wrote:
> > Hi Cl=C3=A9ment,
> >
> > On Mon, Jun 23, 2025 at 4:05=E2=80=AFPM Cl=C3=A9ment L=C3=A9ger <cleger=
@rivosinc.com> wrote:
> >>
> >>
> >>
> >> On 20/06/2025 14:04, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> >>> 2025-06-20T17:17:20+08:00, Xu Lu <luxu.kernel@bytedance.com>:
> >>>> Delegate illegal instruction fault to VS mode in default to avoid su=
ch
> >>>> exceptions being trapped to HS and redirected back to VS.
> >>>>
> >>>> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> >>>> ---
> >>>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/=
asm/kvm_host.h
> >>>> @@ -48,6 +48,7 @@
> >>>> +                                     BIT(EXC_INST_ILLEGAL)    | \
> >>>
> >>> You should also remove the dead code in kvm_riscv_vcpu_exit.
> >>>
> >>> And why not delegate the others as well?
> >>> (EXC_LOAD_MISALIGNED, EXC_STORE_MISALIGNED, EXC_LOAD_ACCESS,
> >>>  EXC_STORE_ACCESS, and EXC_INST_ACCESS.)
> >>
> >> Currently, OpenSBI does not delegate misaligned exception by default a=
nd
> >> handles misaligned access by itself, this is (partially) why we added
> >> the FWFT SBI extension to request such delegation. Since some supervis=
or
> >> software expect that default, they do not have code to handle misalign=
ed
> >> accesses emulation. So they should not be delegated by default.
> >
> > It doesn't matter whether these exceptions are delegated in medeleg.
>
> Not sure to totally understand, but if the exceptions are not delegated
> in medeleg, they won't be delegated to VS-mode even though hedeleg bit
> is set right ? The spec says:
>
> A synchronous trap that has been delegated to HS-mode (using medeleg)
> is further delegated to VS-mode if V=3D1 before the trap and the
> corresponding hedeleg bit is set.

Yes, you are right. The illegal insn exception is still trapped in M
mode if it is not delegated in medeleg. But delegating it in hedeleg
is still useful. The opensbi will check CSR_HEDELEG in the function
sbi_trap_redirect. If the exception has been delegated to VS-mode in
CSR_HEDLEG, opensbi can directly return back to VS-mode, without the
overhead of going back to HS-mode and then going back to VS-mode.

>
>
>
> > KVM in HS-mode does not handle illegal instruction or misaligned
> > access and only redirects them back to VS-mode. Delegating such
> > exceptions in hedeleg helps save CPU usage even when they are not
> > delegated in medeleg: opensbi will check whether these exceptions are
> > delegated to VS-mode and redirect them to VS-mode if possible. There
> > seems to be no conflicts with SSE implementation. Please correct me if
> > I missed anything.
>
> AFAIU, this means that since medeleg bit for misaligned accesses were
> not delegated up to the introduction of the FWFT extension, VS-mode
> generated misaligned accesses were handled by OpenSBI right ? Now that
> we are requesting openSBI to delegate misaligned accesses, HS-mode
> handles it's own misaligned accesses through the trap handler. With that
> configuration, if VS-mode generate a misaligned access, it will end up
> being redirected to VS-mode and won't be handle by HS-mode.
>
> To summarize, prior to FWFT, medeleg wasn't delegating misaligned
> accesses to S-mode:
>
> - VS-mode misaligned access -> trap to M-mode -> OpenSBI handle it ->
> Back to VS-mode, misaligned access fixed up by OpenSBI

Yes, this is what I want the procedure of handling illegal insn
exceptions to be. Actually it now behaves as:

VS-mode illegal insn exception -> trap to M-mode -> OpenSBI handles it
-> Back to HS-mode, does nothing -> Back to VS-mode.

I want to avoid going through HS-mode.

>
> Now that Linux uses SBI FWFT to delegates misaligned accesses (without
> hedeleg being set for misaligned delegation, but that doesn't really
> matter, the outcome is the same):
>
> - VS-mode misaligned access -> trap to HS-mode -> redirection to
> VS-mode, needs to handle the misaligned access by itself
>
>
> This means that previously, misaligned access were silently fixed up by
> OpenSBI for VS-mode and now that FWFT is used for delegation, this isn't
> true anymore. So, old kernel or sueprvisor software that  included code
> to handle misaligned accesses will crash. Did I missed something ?

Great! You make it very clear! Thanks for your explanation. But even
when misalign exceptions are delegated to HS-mode, KVM seems to do
nothing but redirect to VS-mode when VM get trapped due to misalign
exceptions. So maybe we can directly delegate the misaligned
exceptions in hedeleg too before running VCPU and retrieve them after
VCPU exists. And then the handling procedure will be:

VS-mode misaligned exception -> trap to VS-mode -> VS handles it ->
Back to VU-mode.

Please correct me if I missed anything.

Best Regards,

Xu Lu

>
> Note: this is not directly related to your series but my introduction of
> FWFT !
>
> Thanks,
>
> Cl=C3=A9ment
>
> >
> > Best Regards,
> > Xu Lu
> >
> >>
> >> Thanks,
> >>
> >> Cl=C3=A9ment
> >>
> >>>
> >>> Thanks.
> >>>
> >>> _______________________________________________
> >>> linux-riscv mailing list
> >>> linux-riscv@lists.infradead.org
> >>> http://lists.infradead.org/mailman/listinfo/linux-riscv
> >>
>

