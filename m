Return-Path: <kvm+bounces-65163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1FCC9C6E9
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 18:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CC513A9BC8
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 17:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3232C15A8;
	Tue,  2 Dec 2025 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XRjtwF2o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUKictSf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7352429AAE3
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764697063; cv=none; b=osR/yu8wEs8zwlk16LxC7bGJiUF0t75xJZ4+kCrUSL71mJq89CrZoBhRzSzGzlphK2NqksUCA8DbaxSenwPTAVQRY9de+SWaR0okjc8bP9fbTR3D50x/7OEA6UkPepBaa0r6kbeM3cRTMfakU23wLD/8+gAm4zG2cgbGdGqkJqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764697063; c=relaxed/simple;
	bh=bjfC37s+qMFkBqOi/nRN424SQFVmVZk6/XtMpyFOibc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dJpbxk7gSZLhYT3P7jiMxiFg8AYfJhkCOa+w3xJThYBAx9hbMKcjIsY0Z4MHo/BFOy6WC3+Jxau2q6ouLU7iyMw9o82q2jTwEh1GVguIw9JzwnxXPas4ufncDc5MB+m82ZKk0QSuJgTIhdcGenquvqsd1kbSR3bWCOJ5kQhamJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XRjtwF2o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUKictSf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764697060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cLOFuH88zk7WanwVYUHW+1Ib5oJXEqE5t/gYDwAYMh0=;
	b=XRjtwF2ox5+6JyHyuNQUr4gfwYyiNxd6OnR/c/JRPL34Ro5/Dq6pAfnD5gGX8eEka7fGtH
	lGTQfHr7RBMfU/5GPCmy2j+wOd9HuOZW9cY9dQ3FnmT9kZlVU1Wv073lejYynYTp345/a3
	e4Ynm6TgcLL74/8pUiC3JQETmorM5Zs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-jOTbzi2kNeWH0ounfK4K2g-1; Tue, 02 Dec 2025 12:37:38 -0500
X-MC-Unique: jOTbzi2kNeWH0ounfK4K2g-1
X-Mimecast-MFC-AGG-ID: jOTbzi2kNeWH0ounfK4K2g_1764697058
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42e2973a812so42242f8f.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 09:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764697058; x=1765301858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLOFuH88zk7WanwVYUHW+1Ib5oJXEqE5t/gYDwAYMh0=;
        b=YUKictSfFqpN6TkygUtcMI1YIi8XsedT798VfKuH+AuepeAVvnpGUG6ECyWWQ+hQ0H
         GQ4yPM1AM6thHhu3C5Ex22sxJT2FiYhTLZxgCln4mYv4EanmOZPUcGKYvKW0Q8WqrhtM
         ecJFO/0gLVpD6WfshrILSxTMiyIHZJJqLOxUjF+F5ypENPJoFF83cAORHCsQapX12zd2
         R88VOmZ48/coiONUNwd8DWbLknZtuD7tNmpRlMpYQBDUNFYWKXWdv9uYM64UeiwsI68t
         DRd03DLzQRMpNE6voDgZmgNowzFteTnwBQqodOTHLirahlPzrQrYlNzqLK2NLNF4DpKo
         ta6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764697058; x=1765301858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cLOFuH88zk7WanwVYUHW+1Ib5oJXEqE5t/gYDwAYMh0=;
        b=RsUXuEMS4qiK5ZWkhyjkpa++fY1B6ILo7Cqveztkkq3cyw5eiFjdfd/wSFIH2XTFlH
         X6RVwTMuIGO+9v33Fb7NQ+h+BwB+74PAyE37bfLIamntpnXIK6QDEJH6jMqVw5Ld/ebm
         8P7+n7vR2xEJFSWtrQMQDkLXMTlEXx7VSJ59cZDYpGkHL4nVBVLYQH9+Hd+y9F9UFPmB
         K6in5+wioFs/7k3fA6VW8+2cvtD3vlkQAYRO1AX04oqWXJ85KR+TI8ZjC17a82kTjceN
         6f9gFlCfFitZAymPdvDnwf5EZoBHeFpv1LGWSNypJR8/Yzq/HGWdR+N5hk7MICATTHvj
         Y1EA==
X-Forwarded-Encrypted: i=1; AJvYcCUoxSKBPVIfw4oD9JNdPePgSwPZUMo9DDKB5s4g57KNkMcuK5Pc9n8jULu5Ta5D0H0fOSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjLCpOYCjLrRSxUj2igJi6ePBl4mlhRoM9O8EKVDEk5gvRn6Az
	s4VUZXaFU3AtO4/NSpesbbKseCoLe4Ht/2TBGeghx+AiEaDHVzCPY3yoWXM3pTigtsMhejWC+Bh
	VTq5w+RGT62shkTggZrSvyC9tgGVAlYiINusJ6tQB+3z6sacwlFXG+7mL1tAdErkJmhyW17NwNX
	3lb50yhdOmQTKcqt2y7YyBbK+pZWdQ
X-Gm-Gg: ASbGncttWDyPtJOIAYki25wySJR+jABj5SFOYkX8NoP/F8MmM8VA5bWBZ3zDJDG7foM
	jDCDNd9USTtB/9vHmqPjC/w1+YoLHpI9V7jwycSqLraH/DWJywgjUhWVayp2V8D9KdGC1Z0VmEO
	5ILx62wMaEre9JFeGwkFCF7JuP+NnyG+oIekKa0vLKE2YO+MyMvMSOg54gNTUJTADxz7hWnIqbZ
	SCnYj+WLqbmb5tPiAKWpRQQXsXHUi5LTGwrus9JhT/CEM7IepZX9/OVV7lYcALRq4GdNwk=
X-Received: by 2002:adf:fed1:0:b0:429:d59e:d097 with SMTP id ffacd0b85a97d-42f6d55b763mr3311185f8f.9.1764697057592;
        Tue, 02 Dec 2025 09:37:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOu7lU4oJsMLifTYK/nBYFoeAg/7lNC7bgBHfCnXxe/HuJXeg9dp2NpOX3PUhDLvhI2i5QxVNIq6XudKgD6Fk=
X-Received: by 2002:adf:fed1:0:b0:429:d59e:d097 with SMTP id
 ffacd0b85a97d-42f6d55b763mr3311151f8f.9.1764697057116; Tue, 02 Dec 2025
 09:37:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy3C7zxovYDZJvzpuCytRmdBrGwgLF2MtOMzP7vFVm4ohQ@mail.gmail.com>
In-Reply-To: <CAAhSdy3C7zxovYDZJvzpuCytRmdBrGwgLF2MtOMzP7vFVm4ohQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Dec 2025 18:37:24 +0100
X-Gm-Features: AWmQ_bnNCtSTvfC0nmMqa6ld46mo5a8Ud-lzxCUbyUs1ZEXdESV50Pa9xDGjzqo
Message-ID: <CABgObfZANH3buY3ORqR-T1ND+AP-gJg604nAw87G11=_Toshpw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.19
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atish.patra@linux.dev>, 
	Atish Patra <atishp@rivosinc.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 12:09=E2=80=AFPM Anup Patel <anup@brainfault.org> w=
rote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.19:
> 1) SBI MPXY support for KVM guest
> 2) New KVM_EXIT_FAIL_ENTRY_NO_VSFILE
> 3) Enable dirty logging gradually in small chunks
> 4) Fix guest page fault within HLV* instructions
> 5) Flush VS-stage TLB after VCPU migration for Andes cores
>
> Please pull.

Pulled, thanks.

Paolo

> Regards,
> Anup
>
> The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb15=
0d:
>
>   Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.19-1
>
> for you to fetch changes up to 3239c52fd21257c80579875e74c9956c2f9cd1f9:
>
>   RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores
> (2025-11-24 09:55:36 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.19
>
> - SBI MPXY support for KVM guest
> - New KVM_EXIT_FAIL_ENTRY_NO_VSFILE for the case when in-kernel
>   AIA virtualization fails to allocate IMSIC VS-file
> - Support enabling dirty log gradually in small chunks
> - Fix guest page fault within HLV* instructions
> - Flush VS-stage TLB after VCPU migration for Andes cores
>
> ----------------------------------------------------------------
> Anup Patel (4):
>       RISC-V: KVM: Convert kvm_riscv_vcpu_sbi_forward() into extension ha=
ndler
>       RISC-V: KVM: Add separate source for forwarded SBI extensions
>       RISC-V: KVM: Add SBI MPXY extension support for Guest
>       KVM: riscv: selftests: Add SBI MPXY extension to get-reg-list
>
> BillXiang (1):
>       RISC-V: KVM: Introduce KVM_EXIT_FAIL_ENTRY_NO_VSFILE
>
> Dong Yang (1):
>       KVM: riscv: Support enabling dirty log gradually in small chunks
>
> Fangyu Yu (1):
>       RISC-V: KVM: Fix guest page fault within HLV* instructions
>
> Hui Min Mina Chou (1):
>       RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes core=
s
>
>  Documentation/virt/kvm/api.rst                   |  2 +-
>  arch/riscv/include/asm/kvm_host.h                |  6 +++++
>  arch/riscv/include/asm/kvm_tlb.h                 |  1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h            |  5 +++-
>  arch/riscv/include/asm/kvm_vmid.h                |  1 -
>  arch/riscv/include/uapi/asm/kvm.h                |  3 +++
>  arch/riscv/kvm/Makefile                          |  1 +
>  arch/riscv/kvm/aia_imsic.c                       |  2 +-
>  arch/riscv/kvm/main.c                            | 14 ++++++++++
>  arch/riscv/kvm/mmu.c                             |  5 +++-
>  arch/riscv/kvm/tlb.c                             | 30 ++++++++++++++++++=
+++
>  arch/riscv/kvm/vcpu.c                            |  2 +-
>  arch/riscv/kvm/vcpu_insn.c                       | 22 +++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c                        | 10 ++++++-
>  arch/riscv/kvm/vcpu_sbi_base.c                   | 28 +-----------------=
-
>  arch/riscv/kvm/vcpu_sbi_forward.c                | 34 ++++++++++++++++++=
++++++
>  arch/riscv/kvm/vcpu_sbi_replace.c                | 32 ------------------=
----
>  arch/riscv/kvm/vcpu_sbi_system.c                 |  4 +--
>  arch/riscv/kvm/vcpu_sbi_v01.c                    |  3 +--
>  arch/riscv/kvm/vmid.c                            | 23 ----------------
>  tools/testing/selftests/kvm/riscv/get-reg-list.c |  4 +++
>  21 files changed, 138 insertions(+), 94 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c
>


