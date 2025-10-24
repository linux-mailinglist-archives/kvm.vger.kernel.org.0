Return-Path: <kvm+bounces-61029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4D5C06F3F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 403011C2365D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 15:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332533254A4;
	Fri, 24 Oct 2025 15:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="DD7HA96f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E542DF13D
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761319521; cv=none; b=bfbBbZKmxcrRz0rKSToxed71ueWukqQyrnRxCIIUY5nYhSLdYhJzbU9/my32ymA684TPJWEVDWhRK8hRlw53SX3h6Y8RJmmcIYpO3HW/o31HviE9e6cgb0q4rYlV9xc++jvOnB7KrQL/KHPdmvLjIAQoR1Sz7hteMPIP5S51rPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761319521; c=relaxed/simple;
	bh=yd271BqGjeS+iBsD8ybvx85gmJGIuP9wFhL3YHDZT0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+Z322O/xwjh7L1wtTzUfZg/TcbwMrZ+/CU2L/QJeI4IEhQLulQSvHU6NT+BWuCum6Mz4PZa9bZ7K4Dkuq9v4mb+LIf3bf+I/qHFiB6xhTARYfyK3c0mB2an24qGbmQ+zsnO5QkPrj2ZYL7h920VXcMFvwbpWVtxLLrTTFZdewI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=DD7HA96f; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-430cd27de3eso9923205ab.1
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761319519; x=1761924319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yd271BqGjeS+iBsD8ybvx85gmJGIuP9wFhL3YHDZT0o=;
        b=DD7HA96fFpoqDKuEJ/GZweFag/WxtNAhY8VPxTVFkM4SFc6o+quY1hEaqC/uO4dUvN
         WXvIhthZqJzQ4dEm+pm9+s6y4RcGq9iCZk5py76kGBQvLJaeArat065jAC78o0vUifiE
         PnJJ68zyWejlPd+l4U3cLM2nx6i+Yh1tDvhWcpiWE+ohr3UxFfjRG9CPoMQeWoV80joK
         P7lSIVDyUESR21LzHdhTfLcni08lweSYv6dDBpI8zHhuwMfnJ1XdYn1Q3g9bu3v8fLlw
         YJXB8pO6i7K6aKzI4ZU8eCMEr4AjqzvPp6jY6um51nsOpZitusumpvDXKUkZHAGOHmRV
         XeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761319519; x=1761924319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yd271BqGjeS+iBsD8ybvx85gmJGIuP9wFhL3YHDZT0o=;
        b=iRAZET0lBD8FCSjbIajdc87U1a8moQNDgNmbfcy9cY/Tetm8rDME+rVflUd/ZsL/Lb
         gBFF2aYl2P5Zp7Hd0XcnUWDLL8a2x8GyDAwA5xSyLrPwUXGXKE47XS86WuLb8/S9I+2B
         SfQgBN8XUC9RPeZtiFIvShItWSEYBxSIA2cVWTl5BA9Ykt9VA9I/N6RMiXCK/fyxSYsE
         oEUzGxVvQUgpEkHAze3A0LhdAkacP7mc7tuQb3TwD8BlAXOltPZDqAuHgRtdV/N8MDnG
         cRL9c9lX1yKJMJxKtz3wLwMb0wBNHS5beyyWIckdMlTwGDwGnSjT9yhC6bEEYBP09w1u
         EdAw==
X-Forwarded-Encrypted: i=1; AJvYcCUxCdV5THDUZn5QPPdnRr4kbLgqzY58WXYneeCMTfrPE4PHFk5oE4YjZ5VRt9xZQqY3wyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ5kSzyTSP2z4gepi/8n9GR9SH+OOwUro3lfEkkZNGpGlk6Qxc
	YKlR/emWPJm0OAK1hZpuOEVQWnYK4rv1r1cFsUXbu/QZ+210nrT8IWRvmCE12u4Dn57denhtHqv
	nQRvy3CkqzKxIjKYKVtPJ1L/egi/H2wqQ+INaK9QBFA==
X-Gm-Gg: ASbGncsmbOQWZjVUI5nV97+GRVoFUUdfKgl7j/QB9QPArdjobrkPKMhAJ4fu8mXB0jv
	uHrP7HRsxkSOCgJxU1cjnLqULyMk6uTZMpm0PaGDc5XJa5KdHmO60aYxHx7XO55CFYhb7ul+qZt
	tKSS/LTrnGnwW4cXu8zeAMfCm39Hqjr+hGCODOPysflsSwSlxN1HpmT4UqvK88TiVMC/47rD9Gf
	Ueq1VYT2lGZvYtOqumscuoXFhQ+3LRIpo9lBq6317qh3XMbnZKnQqnhHL0zvsq3kBcIgigFnbmQ
	h67+7ZemTnuajXLA6w==
X-Google-Smtp-Source: AGHT+IG1wtHjPkEbu0FQUk92/3c0w05Y3QVim5/4mMrB0XZ9bClwOntryLQ8t33SRrMWa1kUgX8toMC4K2lDPbh1b2U=
X-Received: by 2002:a05:6e02:1fc6:b0:42e:2c30:285f with SMTP id
 e9e14a558f8ab-430c527dc63mr348454435ab.19.1761319518490; Fri, 24 Oct 2025
 08:25:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1fCCdciZLqmoeWDG_QoOHDi9j0_ZZKYkpGJmWrf14Q-g@mail.gmail.com>
 <20251024133116.73803-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251024133116.73803-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 24 Oct 2025 20:55:06 +0530
X-Gm-Features: AWmQ_bnQnnLktl5ci8mf6nQS2KPthEIzOPC5pFpxmUA9i0pi75M3qXGuzrrlyiI
Message-ID: <CAAhSdy3E7-uC=pwU3c93bj3_xykPnLUcDXgKJtJ0KYeL91tijw@mail.gmail.com>
Subject: Re: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: fangyu.yu@linux.alibaba.com
Cc: alex@ghiti.fr, aou@eecs.berkeley.edu, atish.patra@linux.dev, 
	guoren@kernel.org, jiangyifei@huawei.com, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, palmer@dabbelt.com, pbonzini@redhat.com, 
	pjw@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 7:01=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> >> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >>
> >> As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> >> vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> >> regions. Using vma->vm_pgoff to derive the HPA here may therefore
> >> produce incorrect mappings.
> >>
> >> Instead, I/O mappings for such regions can be established on-demand
> >> during g-stage page faults, making the upfront ioremap in this path
> >> is unnecessary.
> >>
> >> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table program=
ming")
> >> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> >LGTM.
> >
> >Queued it as fix for Linux-6.18
> >
> >Reviewed-by: Anup Patel <anup@brainfault.org>
> >
> >Thanks,
> >Anup
> >
>
> Hi Anup:
>
> Thanks for the review.
>
> Please note that this patch has two build warnings, and I have fixed
> on patch V2:
> https://lore.kernel.org/linux-riscv/20251021142131.78796-1-fangyu.yu@linu=
x.alibaba.com/
>

Can you send a separate patch with Fixes tag to this patch?

You can base the patch on riscv_kvm_next branch at:
https://github.com/kvm-riscv/linux.git

Regards,
Anup

