Return-Path: <kvm+bounces-49939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD9DADFE5D
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C5503A34A6
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 07:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271B324889F;
	Thu, 19 Jun 2025 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="IZYk0F8B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C2242D8C
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 07:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750316710; cv=none; b=sdliAV6GLiM+667MHNsYbzKUKWY0fvDXl9YdGSt6x4mhBBYDtnIERzlaE8tuIt2KV/A1Vl+ZlPF+mR86g6XbUmTj4YPIB2YdmFlll2kSQt5NvDjw25Eve2nyDaW6xZoHxPImRfdCM2++Msh6IrAdLUNe2YXy0d7Zkq4AC+xH7DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750316710; c=relaxed/simple;
	bh=fME0ge1Rwj/DFc67JhLE4Xn0HVSWzZ2jccbWy/WLkv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/+4qNimpfE86pIq5HFiPnodRFdRA7VLpq6taW4Xr5qTRST6/jXhHKq/oWjUUyN7wCN0+RcMHoUVFGgp8GAQ9NioSwRfxxI4u71M7drZsewZ4UmJdff5BfsU4uBdD2hcg/uHu9VkM1iy2/16oWQstFPt0bj3YimVh8P1B8yWwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=IZYk0F8B; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-87404493fd2so40749139f.3
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 00:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1750316708; x=1750921508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GslG2eeDA0pr4FM9S7GNW7fv8EFyfyljbaLO6KBfzyY=;
        b=IZYk0F8BODfjPSpJNjyXhlhiIh3rjT859AtMmLRTTFpPWOqqBiItKcp/XHReqDtaBH
         PUGFAApqneMsD1mGaezg6ZonU+L4Zoa9fPhGv9TrIXf7ZoVyceD0vFsAIquz+KUDvLZa
         CSqbxOnuV+LOg2iBM2gWP0/ErL91AkTMXy76K4Wn+hi+S10Uw3qqsqy+tuZ5r12gyMtJ
         AB3FnwBxvTishzBuuFLRBBW5qaswKwR7DBV4wa5W2De9w8rwZQ9ixMp6+saXzW/By7Hf
         nvrfDW24zEr1X5rUo18X+x57PljMYNoayrujfS/n0TX6Y5PMjpJZVAb+PE0KEi8PMMxK
         m8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750316708; x=1750921508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GslG2eeDA0pr4FM9S7GNW7fv8EFyfyljbaLO6KBfzyY=;
        b=ZxrOdDqbwVfZUblQND32WqFL9EkDJ3TVjlLR26jEgjaqeMeSCwy1esHsjm3y+gLkVd
         czjpLMaG3t3Ihu2mPHrCqHMY2LLKZpT01poUC+KXcHOtQnXTFV0afdcqKtldTbWAHWvA
         M7lRe+Z4NoRtAtEOWATTwsPmaMa0yFmopVHqQJUt/baFi6us0fu3E8OZvUMRuAxCPqRb
         NK4mZv3eS1oYDpNprdBQeIYhg1gL7Fnfc288HCiMV2J3/ZleeH8f4qJNg9ofMCq52zZi
         S8QnJEi95ON5mqcnTR4hiPpKU1r8WdJZ+uhG4k5tH6vGW3YKUWyOLNpqzY9cjuPMp2rP
         Nd8A==
X-Forwarded-Encrypted: i=1; AJvYcCXxhgYlsvVUeNTzcAnSbaeVfRcwav+VhZqCaCuYSh4b/Lke5c3fLhSrnZ+AfTT31Twg914=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMQUgtrURHa00tcoFefFC3U0sVbcFQhp0AIq/obKZWCMIUMc5G
	yGGlCGaXWPW6c0H+ca1Ye4Qb9LW+PdcQu7T4NcT8i7iko2OPmYGhVjillmRfZvzY7fTAsp83JWU
	Svb2iYjr1rzECvaiyE4zO+7ai05dofDjbeuRJycXrTQ==
X-Gm-Gg: ASbGncvmY+6idteB5xcsX4aIbibjz11Z7scxH3lC5QVdVRYrwV9m9xj0SPeSnOTRYcV
	k+CGDadwhfgWkhnaA7GYDU2BvLbibZmMoULmBgyYNupOBCXGof70arMuy6masssiqhlPt68T8AI
	k5nphxK9mqKn2jKmf92ac5Fy+c0yT2sq/KPnVwx4TLOA==
X-Google-Smtp-Source: AGHT+IFesrnCeqwqKIL68SxUVLD3mgj0qtgD/fpzVKFlJEEMOp1WCDEd2Y5QAaT59CMI7JPaPJsZyFfBy+1dxA4BYlo=
X-Received: by 2002:a05:6e02:1486:b0:3d9:668c:a702 with SMTP id
 e9e14a558f8ab-3de07c55d0amr214853945ab.9.1750316707660; Thu, 19 Jun 2025
 00:05:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <50989f0a02790f9d7dc804c2ade6387c4e7fbdbc.1749634392.git.zhouquan@iscas.ac.cn>
 <20250611-352bef23df9a4ec55fe5cb68@orel> <aEmsIOuz3bLwjBW_@google.com>
 <20250612-70c2e573983d05c4fbc41102@orel> <aEymPwNM59fafP04@google.com>
 <CAK9=C2WFA+SDt4MCLj0reQnkkA2kxUmfWhT8HZxjT_DdW8W_rQ@mail.gmail.com> <aFF9ZqbvZZtbUnGt@google.com>
In-Reply-To: <aFF9ZqbvZZtbUnGt@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 Jun 2025 12:34:54 +0530
X-Gm-Features: AX0GCFswxnEUivmEVLx0LQAT3Sm2nYe0XKx0hCNHOivGswdHqLkLlXYjQJo09L4
Message-ID: <CAAhSdy26LC0xWisbxx+10mTe=D6cXcePtH8t6=TkzMYso7+jUQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <apatel@ventanamicro.com>, Andrew Jones <ajones@ventanamicro.com>, 
	zhouquan@iscas.ac.cn, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Sun, Jun 15, 2025, Anup Patel wrote:
> > On Sat, Jun 14, 2025 at 3:59=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Jun 12, 2025, Andrew Jones wrote:
> > > > On Wed, Jun 11, 2025 at 09:17:36AM -0700, Sean Christopherson wrote=
:
> > > > > Looks like y'all also have a bug where an -EEXIST will be returne=
d to userspace,
> > > > > and will generate what's probably a spurious kvm_err() message.
> > > >
> > > > On 32-bit riscv, due to losing the upper bits of the physical addre=
ss? Or
> > > > is there yet another thing to fix?
> > >
> > > Another bug, I think.  gstage_set_pte() returns -EEXIST if a PTE exis=
ts, and I
> > > _assume_ that's supposed to be benign?  But this code returns it blin=
dly:
> >
> > gstage_set_pte() returns -EEXIST only when it was expecting a non-leaf
> > PTE at a particular level but got a leaf PTE
>
> Right, but isn't returning -EEXIST all the way to userspace undesirable b=
ehavior?
>
> E.g. in this sequence, KVM will return -EEXIST and incorrectly terminate =
the VM
> (assuming the VMM doesn't miraculously recover somehow):
>
>  1. Back the VM with HugeTLBFS
>  2. Fault-in memory, i.e. create hugepage mappings
>  3. Enable KVM_MEM_LOG_DIRTY_PAGES
>  4. Write-protection fault, kvm_riscv_gstage_map() tries to create a writ=
able
>     non-huge mapping.
>  5. gstage_set_pte() encounters the huge leaf PTE before reaching the tar=
get
>     level, and returns -EEXIST.

The gstage_set_pte() does not fail in any of the above cases because the
desired page table "level" of the PTE is passed to gstage_set_pte() as
parameter. The -EEXIST failure is only when gstage_set_pte() sees an
existing leaf PTE at a level above the desired page table level which can
only occur if there is some BUG in KVM g-stage programming.

>
> AFAICT, gstage_wp_memory_region() doesn't split/shatter/demote hugepages,=
 it
> simply clears _PAGE_WRITE.
>
> It's entirely possible I'm missing something that makes the above scenari=
o
> impossible in practice, but at this point I'm genuinely curious :-)

The -EEXIST failure in gstage_set_pte() is very unlikely to happen but I se=
e
your point about unnecessarily exiting to user space since user space has
nothing to do with this failure.

I think it's better to WARN() and return 0 instead of returning -EEXIST.

Regards,
Anup

