Return-Path: <kvm+bounces-32572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC7C9DABF3
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01F67B20C42
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 16:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027CA200BB4;
	Wed, 27 Nov 2024 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="KSZNZhFv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BF2200BA9
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725859; cv=none; b=rQHsPIiR6/ekLUgcZKiLy9Uegloz9i8bOelQSCj2Wvf69bPl686HdzkGFRBiv8rijKRfzdl6HfHB6K/3ZJ80nBOoWbqim0FWmz5DeBJFYTRX/cNUSv4qt4iUNjAYabwpQg2wi9+gKy6VH6i6wmOZ6zPFDZHk1K0sUCsi0FlnaKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725859; c=relaxed/simple;
	bh=3ZJwblFEszMhWNNASKRYQpRJHf+owon4HnHaInZ2DU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqkcndJDJaNHSzqWTaFUCYMtqa5lDb4Gxo3k8V2O1BlO10CV2LjXVPS+OeVGNTSjTkcvpFri4b/DzK3Qx5t3aN3BTRNYZFBVfAlP5olFh6iChCdyrarXUJzs4pVW/+lrba237sh+XLlQKTD3pgieTQpnBrdIiYmGOBiIAnK3TXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=KSZNZhFv; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-84194e90c0fso179047539f.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 08:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1732725856; x=1733330656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EpuJKb4lN3c6p64SwypSlai/r++vtzKo1Jp0dkw7eE=;
        b=KSZNZhFvjElHjxXPFMwHbqYBox88HFfZ4fl0D0LJxq8S5MSQsc33tPGr+dlz9sdTAU
         CrgHYwqv3Re3pHQJB44/D7207bufchdUSJKV/rtxKPJLTdZrSsEqK5QSxIq/oPhrN1bG
         lpYoxH51gS69AJprt+HE1/WxNKNTUb3Is0wYAQZhK68q5mWX+l/2mArdSEs7jKvOYpv7
         KLr9b0w6gjDOVprxGhZpvxtnrUMFtAWL1IAoPSWJ0j9BLGfqbMgm2stFoKJ6j0efCVcf
         +KdKppZriNmSQwb5CT83k5/An7vPiMbQmpobwzeTquaTvwuIVe2ovkQEg0/sbFuafqAw
         wlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732725856; x=1733330656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6EpuJKb4lN3c6p64SwypSlai/r++vtzKo1Jp0dkw7eE=;
        b=Uh0j5HkdEL3S+1ZCt5YywsQISkCgLxD0EGs+kRKOZVgcfcHNLJLm/Su3cDKzVcYqFl
         1X5fMr33cSPCxj1QCQa1tECqNWRjMndVvMfHVVlrEPmLv6xXA4TnvIQ7RByXpCbCqURM
         JOx1qnqbSFZElK4gxd0RzqnnPnig4iDDjpTpMlxCgQwinJ/OWdxJIgOQJZfoqpXGHbF+
         rF7i+LSAaFtDRbVc4AuveAnU60oKYEYPa82PWOWPC6aeqO4DxYzc2uaH6EgT9rEyfNZB
         sfGZXW4io6TZFsKPOm11jPR6nmplHURC6NTBlm4neExX2NFsIDGB7fNTLK3Sj4reIiBt
         JG8w==
X-Forwarded-Encrypted: i=1; AJvYcCVagF0GpulpdxB/h7bzfRLTCCwmOeJKE/1jUbJ6ncGm/qqCv8CTdW2XJlCsKOlam/AxJ0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK6Ss3KdPpNqykXvlKP47uaWsDJ3PUVN2jWfwmkG77Fa8c65L9
	A/34EkECkyOZ//lE3R1V43TfLUlkVLPLB/O/mLfrNcGm/Hi/b3qoDLY15xW36jyN8ea4/XPdjzE
	DW2iBSmKMzCgtb8C2eCo1AlxaxKsgvZw2tZ1zhoibc5vpCj+XUUk=
X-Gm-Gg: ASbGncvomy4kLIVnpqmshDiO7WZd5IT6m/n7xai2X9y4Lc8Ky3Kc0koVR7fJgpo7r1k
	avS0G3mcI65/ETjIBsnoNy/yLYv2wAubCvg==
X-Google-Smtp-Source: AGHT+IHxUxNUsOs1nl8ukThM+AoCglHgXEuyKz8tFw8cz2YFunPkoBrCjLkUMhkrVVjQy6CRyKtZEdrCya6w1an4yS8=
X-Received: by 2002:a05:6602:160b:b0:83a:97e7:8bcf with SMTP id
 ca18e2360f4ac-843ecfeee7cmr369118839f.11.1732725856324; Wed, 27 Nov 2024
 08:44:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
 <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com>
In-Reply-To: <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 27 Nov 2024 22:14:05 +0530
Message-ID: <CAAhSdy1eYZc__ynDrF8sQCk8Rj+CRj+LBBbGnV+Hc4qHfYiEOA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 10:08=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> On Thu, Nov 21, 2024 at 1:55=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > Hi Paolo,
> >
> > As mentioned in the last PR, here are the remaining KVM RISC-V
> > changes for 6.13 which mainly consists of Svade/Svadu extension
> > support for Host and Guest/VM.
> >
> > Please note that Palmer has not yet sent the RISC-V PR for 6.13
> > so these patches will conflict with the RISC-V tree.
>
> The RISC-V PR has not been merged yet (has it been sent?) and I am not
> sure what's happening here. If these are merged first, presumably
> Linus will bump the arch/riscv/include/asm/hwcap.h constants --
> leaving SVADE/SVADU at 87 and 88 and adjusting the others. Should I do
> that or is it delayed to 6.14 at this point?

Yes, Palmer send-out RISC-V PR one hour ago.
(subject "[GIT PULL] RISC-V Paches for the 6.13 Merge Window, Part 1")
(git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git
tags/riscv-for-linus-6.13-mw1)

We have already skipped Svade & Svadu support in the 6.12 merge
window. If possible please take it in this merge window.

Regards,
Anup

>
> Paolo
>
> > Please pull.
> >
> > Regards,
> > Anup
> >
> > The following changes since commit 332fa4a802b16ccb727199da685294f85f98=
80cb:
> >
> >   riscv: kvm: Fix out-of-bounds array access (2024-11-05 13:27:32 +0530=
)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.13-2
> >
> > for you to fetch changes up to c74bfe4ffe8c1ca94e3d60ec7af06cf679e23583=
:
> >
> >   KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
> > test (2024-11-21 17:40:16 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.13 part #2
> >
> > - Svade and Svadu extension support for Host and Guest/VM
> >
> > ----------------------------------------------------------------
> > Yong-Xuan Wang (4):
> >       RISC-V: Add Svade and Svadu Extensions Support
> >       dt-bindings: riscv: Add Svade and Svadu Entries
> >       RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
> >       KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-l=
ist test
> >
> >  .../devicetree/bindings/riscv/extensions.yaml      | 28 ++++++++++++++=
++++++++
> >  arch/riscv/Kconfig                                 |  1 +
> >  arch/riscv/include/asm/csr.h                       |  1 +
> >  arch/riscv/include/asm/hwcap.h                     |  2 ++
> >  arch/riscv/include/asm/pgtable.h                   | 13 +++++++++-
> >  arch/riscv/include/uapi/asm/kvm.h                  |  2 ++
> >  arch/riscv/kernel/cpufeature.c                     | 12 ++++++++++
> >  arch/riscv/kvm/vcpu.c                              |  4 ++++
> >  arch/riscv/kvm/vcpu_onereg.c                       | 15 ++++++++++++
> >  tools/testing/selftests/kvm/riscv/get-reg-list.c   |  8 +++++++
> >  10 files changed, 85 insertions(+), 1 deletion(-)
> >
>

