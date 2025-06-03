Return-Path: <kvm+bounces-48306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA66ACCA08
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFC9A16298C
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D999823BD14;
	Tue,  3 Jun 2025 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="go3jyXyI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DE222AE65
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748964129; cv=none; b=FCscABlU/9O+uQfyf4wu5xuHygAMv1q2su3aynYChTfrfqCq7d7KUXK42FlkRdfzgGPvBd+602yPaGYGeaoyV3ZJEGlBWRSma2XSRdoCVpGHhiKWi2cOt9b5IvLkKDlKMOfTeBBLOuEYpY3a4HaCUPywoDNeHs6bCFddq/fKl/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748964129; c=relaxed/simple;
	bh=62MqJc+AuJ/zPsbEr/MPLSWzvP5osVI0a+Miwk9w1mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VxEoRao9nCH7nqMBlYQF9Cj68cuvvVhqMNk3BBgCxPT7QOZQp28y0TEvlPag6MjRAM9AAhm0C6TG6HXF/FnXlt+iX5yPw9aXDsYQRBIhfZoeVNVAaF3Wd5sPg6XW8OqPIu8ZWDM73MoM7MQJ1z//oE3/pz9a4Sjd4/aGep6+JrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=go3jyXyI; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-70e447507a0so46619337b3.0
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 08:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748964126; x=1749568926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0icggawenkMTOis/p07uL2XHIGXvkZCT/HJA9z95h6A=;
        b=go3jyXyIIOEeXwPZHHOHb0X+wNnSBDCG+KUQ9qG+9YRE2pd8xr02Z5JetvU/66ut82
         LTImmGS+NT7KMdK7DpO2nMsJjYIOZjGtAkBxI9MwgPITZ1eHEMi4IRSXhGylnVbKE5Jd
         clnQdt66HYVbPLXqGZSjA2GMLJF59gwt1ZwPVw/6QJ60xYPREoH3H4KL9Wd/dw6cn/G7
         tom1mTit6oG39tC6pb1Klk7P6PGns6iBPAX/gd4MNZ6rEjNGJCvroXihShDKEfcHM7Mg
         +iUquvIEEMGSTL5c4kEpdu2R97mxZuSi/czOF82gJvgif6R+usfVjqBVlaIBT1COwM6i
         gzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748964126; x=1749568926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0icggawenkMTOis/p07uL2XHIGXvkZCT/HJA9z95h6A=;
        b=akaX2hH4haXkEOIXYYIrJK3FT0gNvLsOV84eHil64RH4/7iDbZ9EbYMsllNLgOU/C0
         90L+28CIEqyCiCn3pTfIDzzDq9xAffmLK9G7DIeNuw9nzJ3MzDUeF/H+PgD7jJE0Xnul
         0io8GBX0pwBnHVSpmY78f+xLaJBx2teNEy0t3GmjPBK1Zln6yeweHu+nm9tgSIc81PlE
         Km5Iv0PM4JmwSG4Rv0d7+7RKuMM5zRJOs63zkdXtDkzYkgBDC8rxwqDT4AxHCD2w41uZ
         CawD/p9vdxGKXWaRQSzIu+Z2+KKlMrXYbPmwKEMaYuOLF1dOoQWNd57enxMEqJvnV9ey
         6uwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXMU7swu8bYxsagKsZrla8aJxmqEGQvd/WSmnN/Ai6JkjooGGyAjxsGs9GSejrqWt+qbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUD+/op+dNhgwAYk8lZSmuMrDywwa52P+CBZTZ1FfcpYf/Oo+O
	voubGPCWVWRir47SYqv01x9wdYSZ1Ux9FHaA9oqlymrCkTU0IY/DslGhvY0wfnqShvvgXJ2xPAq
	wai0sOMul1AlO0rf00xI190+bnISK3RiIy+0hJoX5
X-Gm-Gg: ASbGnctLvFcsxA3T/Pg69qONAws+bw3GJ4wiOfUPs0VCaIcmmRiME0OYJMpQ7tRof2x
	j06tg9u5uUIuaE3T/pFEiI4uyY9uBOqKjKihYjtBIE9r5jee4/SmNjd1qEPgQ+Jamk1tlw5A8GT
	qj8fbPOYBql6IMs2kaFwJNvoBuWtLfJjdHaJo96wQZnol0nL+gAQBZu9k1MZOR7n7mXPjOjTQvS
	g==
X-Google-Smtp-Source: AGHT+IFPrL0q+O9i9Bs2WyaKSTfKpT62SBwqnp279iViQqar/huUBRXiPF9NJ+eqEJnTboXYPMCeBXJBR2BbYxJqB/M=
X-Received: by 2002:a05:690c:a9a:b0:70f:9fcd:2075 with SMTP id
 00721157ae682-7104f193bf4mr223663067b3.3.1748964125892; Tue, 03 Jun 2025
 08:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602224459.41505-1-seanjc@google.com> <20250602224459.41505-2-seanjc@google.com>
In-Reply-To: <20250602224459.41505-2-seanjc@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 3 Jun 2025 08:21:30 -0700
X-Gm-Features: AX0GCFvnup3hJOrJUkpUyv3dFK_zzF2zrINhArZwMuFAKGveiEoUViQeRVOX5hY
Message-ID: <CADrL8HWvYwxTvRQFzk33aaDLgnSzgBvCaTW_1vP-fBuaC_K4Sw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Reject SEV{-ES} intra host migration if
 vCPU creation is in-flight
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Peter Gonda <pgonda@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 2, 2025 at 3:45=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Reject migration of SEV{-ES} state if either the source or destination VM
> is actively creating a vCPU, i.e. if kvm_vm_ioctl_create_vcpu() is in the
> section between incrementing created_vcpus and online_vcpus.  The bulk of
> vCPU creation runs _outside_ of kvm->lock to allow creating multiple vCPU=
s
> in parallel, and so sev_info.es_active can get toggled from false=3D>true=
 in
> the destination VM after (or during) svm_vcpu_create(), resulting in an
> SEV{-ES} VM effectively having a non-SEV{-ES} vCPU.
>
> The issue manifests most visibly as a crash when trying to free a vCPU's
> NULL VMSA page in an SEV-ES VM, but any number of things can go wrong.
>
>   BUG: unable to handle page fault for address: ffffebde00000000
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>   CPU: 227 UID: 0 PID: 64063 Comm: syz.5.60023 Tainted: G     U     O    =
    6.15.0-smp-DEV #2 NONE
>   Tainted: [U]=3DUSER, [O]=3DOOT_MODULE
>   Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.52.0-0=
 10/28/2024
>   RIP: 0010:constant_test_bit arch/x86/include/asm/bitops.h:206 [inline]
>   RIP: 0010:arch_test_bit arch/x86/include/asm/bitops.h:238 [inline]
>   RIP: 0010:_test_bit include/asm-generic/bitops/instrumented-non-atomic.=
h:142 [inline]
>   RIP: 0010:PageHead include/linux/page-flags.h:866 [inline]
>   RIP: 0010:___free_pages+0x3e/0x120 mm/page_alloc.c:5067
>   Code: <49> f7 06 40 00 00 00 75 05 45 31 ff eb 0c 66 90 4c 89 f0 4c 39 =
f0
>   RSP: 0018:ffff8984551978d0 EFLAGS: 00010246
>   RAX: 0000777f80000001 RBX: 0000000000000000 RCX: ffffffff918aeb98
>   RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffebde00000000
>   RBP: 0000000000000000 R08: ffffebde00000007 R09: 1ffffd7bc0000000
>   R10: dffffc0000000000 R11: fffff97bc0000001 R12: dffffc0000000000
>   R13: ffff8983e19751a8 R14: ffffebde00000000 R15: 1ffffd7bc0000000
>   FS:  0000000000000000(0000) GS:ffff89ee661d3000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffffebde00000000 CR3: 000000793ceaa000 CR4: 0000000000350ef0
>   DR0: 0000000000000000 DR1: 0000000000000b5f DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>   Call Trace:
>    <TASK>
>    sev_free_vcpu+0x413/0x630 arch/x86/kvm/svm/sev.c:3169
>    svm_vcpu_free+0x13a/0x2a0 arch/x86/kvm/svm/svm.c:1515
>    kvm_arch_vcpu_destroy+0x6a/0x1d0 arch/x86/kvm/x86.c:12396
>    kvm_vcpu_destroy virt/kvm/kvm_main.c:470 [inline]
>    kvm_destroy_vcpus+0xd1/0x300 virt/kvm/kvm_main.c:490
>    kvm_arch_destroy_vm+0x636/0x820 arch/x86/kvm/x86.c:12895
>    kvm_put_kvm+0xb8e/0xfb0 virt/kvm/kvm_main.c:1310
>    kvm_vm_release+0x48/0x60 virt/kvm/kvm_main.c:1369
>    __fput+0x3e4/0x9e0 fs/file_table.c:465
>    task_work_run+0x1a9/0x220 kernel/task_work.c:227
>    exit_task_work include/linux/task_work.h:40 [inline]
>    do_exit+0x7f0/0x25b0 kernel/exit.c:953
>    do_group_exit+0x203/0x2d0 kernel/exit.c:1102
>    get_signal+0x1357/0x1480 kernel/signal.c:3034
>    arch_do_signal_or_restart+0x40/0x690 arch/x86/kernel/signal.c:337
>    exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>    exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>    syscall_exit_to_user_mode+0x67/0xb0 kernel/entry/common.c:218
>    do_syscall_64+0x7c/0x150 arch/x86/entry/syscall_64.c:100
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   RIP: 0033:0x7f87a898e969
>    </TASK>
>   Modules linked in: gq(O)
>   gsmi: Log Shutdown Reason 0x03
>   CR2: ffffebde00000000
>   ---[ end trace 0000000000000000 ]---
>
> Deliberately don't check for a NULL VMSA when freeing the vCPU, as crashi=
ng
> the host is likely desirable due to the VMSA being consumed by hardware.
> E.g. if KVM manages to allow VMRUN on the vCPU, hardware may read/write a
> bogus VMSA page.  Accessing PFN 0 is "fine"-ish now that it's sequestered
> away thanks to L1TF, but panicking in this scenario is preferable to
> potentially running with corrupted state.
>
> Reported-by: Alexander Potapenko <glider@google.com>
> Tested-by: Alexander Potapenko <glider@google.com>
> Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migrati=
on")
> Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration"=
)
> Cc: stable@vger.kernel.org
> Cc: James Houghton <jthoughton@google.com>
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks Sean! Free free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

> ---
>  arch/x86/kvm/svm/sev.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7a7dc507336..93d899454535 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2032,6 +2032,10 @@ static int sev_check_source_vcpus(struct kvm *dst,=
 struct kvm *src)
>         struct kvm_vcpu *src_vcpu;
>         unsigned long i;
>
> +       if (src->created_vcpus !=3D atomic_read(&src->online_vcpus) ||
> +           dst->created_vcpus !=3D atomic_read(&dst->online_vcpus))
> +               return -EINVAL;

I think -EBUSY (or perhaps -EAGAIN) might be a more proper return code.

> +
>         if (!sev_es_guest(src))
>                 return 0;
>
> --
> 2.49.0.1204.g71687c7c1d-goog
>

