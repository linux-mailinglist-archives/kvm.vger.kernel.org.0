Return-Path: <kvm+bounces-27423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38096986101
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECBAE28C47D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 14:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E403143C72;
	Wed, 25 Sep 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MawnfV0F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD3213C67C
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727271993; cv=none; b=h0PBkkdIt1CfqsDzziYP9s71Y0ZiRFIWQ7Vlv/AUkqz2WEGeYGPRc2SXC8pQ/CW3LzRvVtL5lz0xad1RPJrSIcAPvusDR7DSYvgZTgXCPSkB1ok8yuxecIUX8fgF65FHg/Eg/B1QTtWn2muohOoUlEojvB4orOWlz16fHi3IlZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727271993; c=relaxed/simple;
	bh=hudYusfjRmnEIUWRxw7RjxqfwF4PVBX6+KtOED8F1go=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NPKKcDjTfpT4Q+k1Epd3oL0E0B/O+AVvfGV5Hc5+itGOOU2+kU9/3S1tJ0/W33k3r/a1JUOMRn5s1JKcVqwxkzWW06fCtGCYtU6878i57qcH5thCKJ07oarZh1D5TSSkrFvCxuWZIicYI5160Y1eCURDtwNorkAqHQpZ4vw3tVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MawnfV0F; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso5205637a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 06:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727271991; x=1727876791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dcHmbbiY36D8TtbPukGGr+479Oa1k5wS1avCfZZSG5g=;
        b=MawnfV0FNm8/gEvu2q4ixR4qctVE9HKPcmcBHwfxLrPR8ta0LsVwtfTQXFiGa83DnW
         ih2BMmd4X3xOMpGu9bPUXj1dTrh2FSjU8hBwOVyX2zvUJbTObvilqUyNOznFv2Cf229n
         R5v2hM8yHJ2sJ+nyJvEY2nXKuZfWfxZSCpG0DjSv8Wo89eol8A1ZwcNDh22kE994cXHH
         4/WzcjB6pK2RenKz+hNEVMH1rSu6gjKC8L/szd4AMRj15BIhxn3lXd4mJDJCXD2Df4cH
         h4LZaGlcOrYi8EVkqZgX/PtIZEO0ChDIDYsVnFceFgLg4ABHUrTTGNM3K4Xw7tHSEaS4
         7E1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727271991; x=1727876791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dcHmbbiY36D8TtbPukGGr+479Oa1k5wS1avCfZZSG5g=;
        b=JB8u1rYe0wexbTmPf9PMrvLtxQ9qt6dITZzPEDEwkZWp0lG7uV1ybS2aIbj5gesPoB
         ZOu8X2kRXOrs13/+6fUP4LSypGF2FhBmbzsqQ7H++AEfOTiCcdaa1W8JMAYTg0eKvXfp
         /BxGP36GkQegowCqdIoxuRXUh2VRt2+T1q9TOKxDiWa47UoToevrcdO+qjpboahxIuTx
         iMLxxuPcUzKQOPFDHsT5/dWnFyk954GQypaoshp69ZfEVIX4b3p/AAQjpX2EqB/hKh9A
         6Fyhy6xUe/MUmsmQhAMB7nGnGtmWMTl+mO4lYlPwr2wrGGGcKn7is5jIyPwdeEXuvU7C
         jqCg==
X-Forwarded-Encrypted: i=1; AJvYcCWteS5+EGdRX8IoeTRt01IYsAd007FTyoGyCLs3+uLBz13hVEJNuDBTvGp7T6emC9PIAsU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQB9Ns9rChRSeWbq/7xIhxyljjUtu5uIOGmr9jaYh5qXDlFCNe
	wTPjD3HH1twRaz2I/r/5YHXh7KzsSy5Svb1ZUZn4q5UveGTSvTFhgmdMasROFl4pec8eJnicyAr
	jMQ==
X-Google-Smtp-Source: AGHT+IGFqXNabD/nL05yVh2o8hKeOKKi4o8pwGGBwVeTpBDypxK9mXs7mBxUh2LEvDRR+7w+1WCv8IANqvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:745e:0:b0:7cd:8b5f:2567 with SMTP id
 41be03b00d2f7-7e6c190e282mr2861a12.4.1727271991305; Wed, 25 Sep 2024 06:46:31
 -0700 (PDT)
Date: Wed, 25 Sep 2024 06:46:29 -0700
In-Reply-To: <ZvPFTMBXAwHhrU1i@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820230431.3850991-1-kbusch@meta.com> <ZvAUIaZiFD3lsDI_@google.com>
 <ZvPFTMBXAwHhrU1i@kbusch-mbp>
Message-ID: <ZvQUNbtlMDXY1bxM@google.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Alex Williamson <alex.williamson@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xu Liu <liuxu@meta.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 25, 2024, Keith Busch wrote:
> On Sun, Sep 22, 2024 at 05:57:05AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 20, 2024, Keith Busch wrote:
> > > To test, I executed the following program against a qemu emulated pci
> > > device resource. Prior to this kernel patch, it would fail with
> > > 
> > >   traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:0 in vmovdq[6b2,400000+1000]
> >  
> > ...
> > 
> > > +static const struct gprefix pfx_avx_0f_6f_0f_7f = {
> > > +	N, I(Avx | Aligned, em_mov), N, I(Avx | Unaligned, em_mov),
> > > +};
> > > +
> > > +static const struct opcode avx_0f_table[256] = {
> > > +	/* 0x00 - 0x5f */
> > > +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> > > +	/* 0x60 - 0x6F */
> > > +	X8(N), X4(N), X2(N), N,
> > > +	GP(SrcMem | DstReg | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> > > +	/* 0x70 - 0x7F */
> > > +	X8(N), X4(N), X2(N), N,
> > > +	GP(SrcReg | DstMem | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> > > +	/* 0x80 - 0xFF */
> > > +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> > > +};
> > 
> > Mostly as an FYI, we're likely going to run into more than just VMOVDQU sooner
> > rather than later.  E.g. gcc-13 with -march=x86-64-v3 (which per Vitaly is now
> > the default gcc behavior for some distros[*]) compiles this chunk from KVM
> > selftests' kvm_fixup_exception():
> > 
> > 	regs->rip = regs->r11;
> > 	regs->r9 = regs->vector;
> > 	regs->r10 = regs->error_code;
> > 
> > intto this monstronsity (which is clever, but oof).
> > 
> >   405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
> >   405318:       48 89 68 08             mov    %rbp,0x8(%rax)
> >   40531c:       48 89 e8                mov    %rbp,%rax
> >   40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
> >   405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
> >   405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)
> > 
> > I wouldn't be surprised if the same packing shenanigans get employed when generating
> > code for a struct overlay of emulated MMIO.
> 
> Thanks for the notice. I'm hoping we can proceed with just the mov
> instructions for now, unless someone already has a real use for these on
> emulated MMIO. Otherwise, we can cross that bridge when we get there.

Oh, yeah, for sure.  The FYI was really for Paolo, e.g. to make sure we don't make
assumptions in the emulator or something and make our future lives harder (I haven't
looked at your patch in any detail, so my fears could be completely unfounded).

> As it is, if just the vmovdq[u,a] are okay, I have a follow on for
> vmovdqu64, though I'm currently having trouble adding AVX-512 registers.
> Simply increasing the size of the struct x86_emulate_ctxt appears to
> break something even without trying to emulate those instructions. But I
> want to wait to see if this first part is okay before spending too much
> time on it.

