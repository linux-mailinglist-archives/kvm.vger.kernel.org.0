Return-Path: <kvm+bounces-53561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F74B13F3D
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 17:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F862164071
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 15:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165BF2727F6;
	Mon, 28 Jul 2025 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VieE1joj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A00B224AFA
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 15:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717962; cv=none; b=B4x0x6LbmXcwq1K4O5h/qdMFRvDsLPOLPhwWHGa4ssyNNHrFhHD64vEeT+izOI0EprpLWunsZIXVGgD8LT1nOkHD6LWmpWNzgan5skDwqmlTEcFplubCamBpAVzZ/lZy1rh6HkftVOUkyuLopDxz29xRNlx7Os8dAtnhIwuVhTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717962; c=relaxed/simple;
	bh=jH3ZtSfR+fLsiFEDWDAXqXlPuwjvJvhCGGUPoc+utuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eOblb3kwEFz4t39wfchU/5QwOaQkMv60+25jH/OgyWarD5NUUYy83BOc5/5nVyVLKop80GKmpSfTgdDDOIDjYz8JqwALXKmlICvUXDTDhoB7RMwtAU+8VYlTAkDhhlwaKtiHYzzMgwL+OcgDuRhoZrKDlAaRxork8Mza+a+Yvv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VieE1joj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753717959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ajKmblQIi5n8fN4LrMcXTNw8c+8khNFBixAeFhjQpQ=;
	b=VieE1jojrFKZ9sab6yuyfqY1hdhilX32+zZDsFHryJQ4dUzOSo0EivnLRndqgYYsQTnWCu
	/lHaGvxIkJbcMGxM3el4N5nOtC4ypgZMWEzh2DlbDg2ydcvja5JygR/4rwf1SOmNTEMcnC
	gUNzDzd1d6Gn0FHSXphieJkvsKjMGfY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-QA6ae1bhMKesu4ZGTlToXg-1; Mon, 28 Jul 2025 11:52:37 -0400
X-MC-Unique: QA6ae1bhMKesu4ZGTlToXg-1
X-Mimecast-MFC-AGG-ID: QA6ae1bhMKesu4ZGTlToXg_1753717956
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso2685280f8f.2
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 08:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753717956; x=1754322756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ajKmblQIi5n8fN4LrMcXTNw8c+8khNFBixAeFhjQpQ=;
        b=eYY9C6mOGOLg9uGMGdll9BJprboI8E0YnFVFo7dH7+V/t/GAV5icH5zrlPnn8/hnyU
         Aq4rmqRXO8kNqwC5uv6Bd8eXji7reEbQgAjY+x7jtROI1VN7Lzs/r6hUkW5GHwOBrhgj
         Q/+NVIZsidozdWUQPMSAtc1ZPC4x/NLyQl/PwpBYanidL8p0+CKmnKdXYLt810NGDNFG
         jt7nuNu9OGaBmRdNFOiRQPNzQMYS2lC7dChtanpbJd+VL8TvXOFn5aDIArQVJjU0lHPZ
         XkZwoNLlv2U4gA/AaqAcZJ7gm/Eb20yWfQDjHa3eoQEwOEMXw4JD39pQUnTf2iuptNtg
         LL3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXevJUOILCAjwbUBzjcYYvRQDD+gUtgtYS9oTr+8VVy6tfzwGxKLyFdhU6ZwBGvSOHORJ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvJCWtWFZCJDXRc1keRakVBTbKJQnQ3fQIGnUQ/1GWpBhwerGJ
	H2I4qEtUxNxXBA3udANJ1stEhowX9sLS0zn+6N0jiIhKgh2q6mFzeGKSSQSLrHRqkna+3l5fu7R
	g8nrK7GZCwQ6XAfE9Hf6wX9jDJ7tija4lIGFso8hgwgAZM9Q69yGffMhPnZ+yJRu/l5WwlrZsMA
	WRPEDFLVZfzzAaY7uQP4Fl7DvpdmYJ
X-Gm-Gg: ASbGncvIyiIo7Uh4oUyWm3LSzZHnwIETs5uDXCceqFC7fx2quEzHeMJiuadFYQMkFLI
	Ft01rjX0hlteSdwgAQkL538yvjO2p9tFrseftjeZBQLjdI3al6jT6M5lxbqMmJbOJmnMzqSjFJr
	cxenin147OxHd9Gnwyy/bvRw==
X-Received: by 2002:a05:6000:2209:b0:3a5:8cc2:10aa with SMTP id ffacd0b85a97d-3b7766451f7mr9100336f8f.32.1753717956151;
        Mon, 28 Jul 2025 08:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBGFp3+itaFUNpRqfJjDUWaUPScb2LyQwR7RlmJb+Ax1zLGpuUzLHHmfb1XxwBmd1C4N3RQSHmM2SZxD9pqC8=
X-Received: by 2002:a05:6000:2209:b0:3a5:8cc2:10aa with SMTP id
 ffacd0b85a97d-3b7766451f7mr9100313f8f.32.1753717955778; Mon, 28 Jul 2025
 08:52:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
In-Reply-To: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 28 Jul 2025 17:52:24 +0200
X-Gm-Features: Ac12FXxyIBqr6aXH6QdzF7T94hnE0BS5b_WVUACGolEDHfPEEz9xXJvF5CEiaCI
Message-ID: <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Atish Patra <atish.patra@linux.dev>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 2:06=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>       RISC-V: perf/kvm: Add reporting of interrupt events

Something here ate Quan Zhou's Signed-off-by line, which is present at
https://lore.kernel.org/r/9693132df4d0f857b8be3a75750c36b40213fcc0.17262116=
32.git.zhouquan@iscas.ac.cn
but not in your branch.

Paolo

>       RISC-V: KVM: Use find_vma_intersection() to search for intersecting=
 VMAs
>       RISC-V: KVM: Avoid re-acquiring memslot in kvm_riscv_gstage_map()
>
> Samuel Holland (2):
>       RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap
>       RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN
>
> Xu Lu (1):
>       RISC-V: KVM: Delegate illegal instruction fault to VS mode
>
>  Documentation/virt/kvm/api.rst                     |   2 +-
>  arch/riscv/include/asm/kvm_aia.h                   |   2 +-
>  arch/riscv/include/asm/kvm_gstage.h                |  72 +++
>  arch/riscv/include/asm/kvm_host.h                  | 109 +----
>  arch/riscv/include/asm/kvm_mmu.h                   |  21 +
>  arch/riscv/include/asm/kvm_tlb.h                   |  84 ++++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h              |  13 +
>  arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h         |  33 ++
>  arch/riscv/include/asm/kvm_vmid.h                  |  27 ++
>  arch/riscv/include/uapi/asm/kvm.h                  |   2 +
>  arch/riscv/kvm/Kconfig                             |   1 +
>  arch/riscv/kvm/Makefile                            |   2 +
>  arch/riscv/kvm/aia_device.c                        |   6 +-
>  arch/riscv/kvm/aia_imsic.c                         |  12 +-
>  arch/riscv/kvm/gstage.c                            | 338 ++++++++++++++
>  arch/riscv/kvm/main.c                              |   3 +-
>  arch/riscv/kvm/mmu.c                               | 509 +++++----------=
------
>  arch/riscv/kvm/tlb.c                               | 110 ++---
>  arch/riscv/kvm/vcpu.c                              |  48 +-
>  arch/riscv/kvm/vcpu_exit.c                         |  20 +-
>  arch/riscv/kvm/vcpu_onereg.c                       |  84 ++--
>  arch/riscv/kvm/vcpu_sbi.c                          |  53 +++
>  arch/riscv/kvm/vcpu_sbi_fwft.c                     | 338 ++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_replace.c                  |  17 +-
>  arch/riscv/kvm/vcpu_sbi_sta.c                      |   3 +-
>  arch/riscv/kvm/vcpu_sbi_v01.c                      |  25 +-
>  arch/riscv/kvm/vm.c                                |   7 +-
>  arch/riscv/kvm/vmid.c                              |  25 +
>  tools/perf/arch/riscv/util/kvm-stat.c              |   6 +-
>  tools/perf/arch/riscv/util/riscv_exception_types.h |  35 --
>  tools/perf/arch/riscv/util/riscv_trap_types.h      |  57 +++
>  31 files changed, 1382 insertions(+), 682 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_gstage.h
>  create mode 100644 arch/riscv/include/asm/kvm_mmu.h
>  create mode 100644 arch/riscv/include/asm/kvm_tlb.h
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
>  create mode 100644 arch/riscv/include/asm/kvm_vmid.h
>  create mode 100644 arch/riscv/kvm/gstage.c
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c
>  delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
>  create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h
>


