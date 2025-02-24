Return-Path: <kvm+bounces-39039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0416FA42B1C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 467B03B0AA6
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC07265CAE;
	Mon, 24 Feb 2025 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOkw7SwU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37352627E1
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740421266; cv=none; b=RnvdowEJ4ajrcJkME99ZSXXah98EUsqHXlGUmSuaw6walj1yPBeClmRd7xezSYmsay9CgilkSm2a75MUunUA4/tyyk6jB3TEztgd2VAbt01Ip1qOqWfeRx+89kSrDlp49Dud48fW0XhrI4hJmWRSxpjjZMCWV6zLXXXzUhA0y7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740421266; c=relaxed/simple;
	bh=xIvDScXvMEmQdhnemor3X46f4p4XIbBib+VHQFBc4ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LW1+sD2ymze2nfpEvhPqYjwYuMFWyA3JqbvkW2lzuP0nsZ9omMRg1zepKFS5LwTOpN2TPWAEc83DifHodiC4GQpK8Or/H9/tNeUddF5hL7omAk/lhrCgtZI/VMUNc73gt0RKlVVgKdvvYpJRtfy7fwLz7EnNQvqnzBXJqyU0Ejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOkw7SwU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740421261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7xELZHJie6Fl0P2HGMVjkjGrKUGnwvDBmjOpl74Jkg=;
	b=DOkw7SwU2Pu9B/3KCGO8vMJC/HEsnJO9AcZRoRthDbLLwzrmCe7M34rhiL5WZ2lJF1EUcm
	HZTHDJ0kUVMrpWwrKwEq480+FcvHLvX1LMM8k1A4VNm2L91KSu/VkK6U2qNgxlRajpuHQz
	35NH6EPf2AiLTRbceQ0YEc3hNc46PH0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-4BonyNgvNeqslLnfYdOtQA-1; Mon, 24 Feb 2025 13:20:59 -0500
X-MC-Unique: 4BonyNgvNeqslLnfYdOtQA-1
X-Mimecast-MFC-AGG-ID: 4BonyNgvNeqslLnfYdOtQA_1740421258
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38f34b3f9f1so3526262f8f.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:20:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740421258; x=1741026058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7xELZHJie6Fl0P2HGMVjkjGrKUGnwvDBmjOpl74Jkg=;
        b=U3iu2KnQC7WNr/DRAnQoObTj698ColWSuL9hI1q7oV1VFbQvfqcfI2EyqynyyFq4i/
         n9XJ3+ZBTEbERbOy+TwIZc7GDmA1VMT/XItpMtJEhTo9tq2ZJRL3lXTHCbFhM/iONDeq
         PJUjFfXulAyRdrjCKAurrD1eAneATZ3eHBEIPbdq9TxpiIfWvB78dl2x7cwgyKFKH/j0
         F9CIRL6NvJspS+e3lYgemRRJrn2qCzda/W6pfXa1io40H0nGQeB9hhGEBle+WPpI3M16
         m+KRc7OHyN26Ao8IBB2ScF7ulGYkHsS5kKUGNMQ8Os7N1wlqqCrcXT/VTvpaNo6pl9q1
         jzLA==
X-Forwarded-Encrypted: i=1; AJvYcCVbVp3tHvTD17Tcjgdg1OHyGsrRE0Xa3VUsaIyHIZZ1FHaM/P+6j6wniDGyPMbDwao7TT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH1vn6yA0+pQoEYe1JsM36zL0hoQuknHcJzW6Pfhy+X++WhMIS
	jOnpXGxHINM8/kvWuweSmxBsskY5q7SYldq47eFYslN8Da62Ckp7oxQuM9t2ooBeawJBL8b3/0i
	dHTSUthj5AfgRIL462N4DZ4yE35d8Tj5baZQJLxxBll0bOeLBbeKSS8HhN+m9SWbGok6oKLmgeB
	2Vq06a2m3FW6UVElo8XdiBngWM
X-Gm-Gg: ASbGncsfiMopOlkZxfhNEpvwqOY/Sa68wytuOaLWLmfvzWOnVe169iprtujMSaKPH8h
	6VgIMxyurOuMAjuSYWIoGAmkN8bKLDKHWb3nSHT2aKY0TYmybgR8/S0hxTyH53WswY9AdNwiSvw
	==
X-Received: by 2002:a5d:47cb:0:b0:38d:de92:adad with SMTP id ffacd0b85a97d-38f6e95c4aemr9698939f8f.22.1740421258494;
        Mon, 24 Feb 2025 10:20:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdoqcjY6M2ITOtK0J4C8ZZqwTjbsEXxZzmRUh3glHKJRit9eR6FaDOe3JruMVtsoM71Am043xhfFfSHW4WvTE=
X-Received: by 2002:a5d:47cb:0:b0:38d:de92:adad with SMTP id
 ffacd0b85a97d-38f6e95c4aemr9698920f8f.22.1740421258135; Mon, 24 Feb 2025
 10:20:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0Wo4hQ=gnhpJGU-khA4g-0VkfkMECDjnAsq4Fg6xfWjw@mail.gmail.com>
In-Reply-To: <CAAhSdy0Wo4hQ=gnhpJGU-khA4g-0VkfkMECDjnAsq4Fg6xfWjw@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 24 Feb 2025 19:20:46 +0100
X-Gm-Features: AWEUYZmirAbaCLPAASL9k1ey1yRhraHtQYqh2iKwvRPu6z7rtoFlwTs6G6HOStc
Message-ID: <CABgObfbKPQ807vchetgjdFbzFiBgSCXXHCTu-Qq-XgA2dzuDCg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.14 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 6:08=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have a bunch of SBI related fixes and one fix to remove
> a redundant vcpu kick for the 6.14 kernel.
>
> Please pull.
>
> Regards,
> Anup
>
> The following changes since commit 0ad2507d5d93f39619fc42372c347d6006b643=
19:
>
>   Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-fixes-6.14-1
>
> for you to fetch changes up to d252435aca44d647d57b84de5108556f9c97614a:
>
>   riscv: KVM: Remove unnecessary vcpu kick (2025-02-21 17:27:32 +0530)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/riscv fixes for 6.14, take #1
>
> - Fix hart status check in SBI HSM extension
> - Fix hart suspend_type usage in SBI HSM extension
> - Fix error returned by SBI IPI and TIME extensions for
>   unsupported function IDs
> - Fix suspend_type usage in SBI SUSP extension
> - Remove unnecessary vcpu kick after injecting interrupt
>   via IMSIC guest file
>
> ----------------------------------------------------------------
> Andrew Jones (5):
>       riscv: KVM: Fix hart suspend status check
>       riscv: KVM: Fix hart suspend_type use
>       riscv: KVM: Fix SBI IPI error generation
>       riscv: KVM: Fix SBI TIME error generation
>       riscv: KVM: Fix SBI sleep_type use
>
> BillXiang (1):
>       riscv: KVM: Remove unnecessary vcpu kick
>
>  arch/riscv/kvm/aia_imsic.c        |  1 -
>  arch/riscv/kvm/vcpu_sbi_hsm.c     | 11 ++++++-----
>  arch/riscv/kvm/vcpu_sbi_replace.c | 15 ++++++++++++---
>  arch/riscv/kvm/vcpu_sbi_system.c  |  3 ++-
>  4 files changed, 20 insertions(+), 10 deletions(-)
>


