Return-Path: <kvm+bounces-24570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F7B957CD2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 07:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9681D1F22A3D
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 05:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A3A148FF7;
	Tue, 20 Aug 2024 05:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="gFVG8xrE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCB11465AB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 05:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724132412; cv=none; b=WKA6IScu3N0vDDgD/D/JN8Sr4ucR01cnvFSxeWwEXqflCCeJ0oXqiCkecNvb/SKL7SHvKMQe7+j5erkLjxZRWdndhY6tNFaFkJ93e2++qOkHG6eKSCoUSE09V5e8BG9mPBoad4CWrfYNq5wVQ+VUHD03PurpUaO3uGMdj4gftBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724132412; c=relaxed/simple;
	bh=TmqSlHuNCG5BV6PO8p+ZMn3NpnE2nRZLHMMy9H1K7fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UFAcYBXsxfBoe7yu+Gx8JqWuLsaZORsNRXaN+gLqg+hYiBY/BF/GMqTxsCwEGlxGbb8I0fAeCSWXtl2yVj11ScUBJnx9RJrq2jqhMnk5kfhGxtvtBMdJaYOG0/gjYXxRsP+R8Hvps0OkILyqZkkJXaLhpoRGogkagoEf/rwABgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=gFVG8xrE; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-39d22965434so13436465ab.0
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1724132409; x=1724737209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHUnwVKAbv6cDNfDJWpm3qE8ItdHvxgE8FlI7r00tew=;
        b=gFVG8xrEjeQCmRMtF/Q2cYebg48eFQHCSYbVK2kFYGJ3hEq7kL7EnB+bCZDUcO08Dz
         0hzn3LhBRq0lRDdMfrQeBS71GGSuoVJSCMnI3W1E7OjkRi0qeldtENZt6M+zPhRcPnev
         jh/foYWKw2LLyS0L+Bx6RE87P2RTl1BzgqIcPF12R3VZZndIkURHMwPz7i72ir6CTWVW
         LY4MGlBp9gNQC6Zdn7Ar2L8UhKqiTBALbl7pTux4mNd/nij17qXV+OWsvk2PYdUsSYoE
         /nfzUtAE8qYMdjJzqXndAlLj6nSQxMPWpvmc5wkRnVgcpypUul2lCJ/RzAb8XCr54drH
         F49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724132409; x=1724737209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHUnwVKAbv6cDNfDJWpm3qE8ItdHvxgE8FlI7r00tew=;
        b=L5BGq8xpl+YnAEeotEdzXMemLAA9KXZv0kwksmrFTkZp7UWvI51itd0seT9SN+4sbE
         UReJjoY8XTlhE9BFA9pDRaktSrfGgVZS1X0PPfhbATC89YLt2MNp3Gf6Yk3sRVYIM0I5
         Ihk34lKBZ3mKO+Dxj0tzxrJFDVEsBWIpCptaZtiVzssE9HNHSG/qhn626BcMrzARiIhP
         7ymh9eJlO+i9bjQQBA07qud2Yu6rT9cQ7pG6BKqPqhpZlz1Vq8tj8wYjRdrNVS5MToo9
         h7r2aZxJr1q3L4L0mahFhWnZlz0pfEGlh1GbEihFJm1Xc1zZLoRhJPi2kMw7uSA33Nqt
         PTZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNkAVVYu/Tdii8HWD2SaJmJto8MyaL0C7UCC0VZhnGYXGzLuvNYSkGRM4aRWNXXWmrs5piluzGtQWq22ZhunYa/V8O
X-Gm-Message-State: AOJu0YxNbSMRGPNOOCyy7jR6m8REDWsS7fbLSykgxMgYni2IhE+JbbfD
	tX7kjqocjZDGNICjuw2mUdqZRY1AnnWHBmLJ1um5n36mRZUb5TOlfItro5YJAUmuo3kGW9rxF4H
	W+Kbg94CDX6jorXhEwfyjBiqth9TjIOtXiXxg6A==
X-Google-Smtp-Source: AGHT+IE40VLUA+0xzyRlFpDTLoBgS8NtqsfjjIDibE9AsUZhr1cOV4VV1OW1QVjrbj6XPgBas9HhL/Y6bqd46Rnlx14=
X-Received: by 2002:a05:6e02:19c9:b0:39b:3724:6038 with SMTP id
 e9e14a558f8ab-39d56f87e9emr18824685ab.14.1724132408705; Mon, 19 Aug 2024
 22:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240815170907.2792229-1-apatel@ventanamicro.com>
In-Reply-To: <20240815170907.2792229-1-apatel@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 20 Aug 2024 11:09:57 +0530
Message-ID: <CAAhSdy0x8X8cuXe+zYKmUousr4cCHUZPb1gL=go28U_6LKK-dg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Don't zero-out PMU snapshot area before
 freeing data
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Atish Patra <atishp@atishpatra.org>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 10:39=E2=80=AFPM Anup Patel <apatel@ventanamicro.co=
m> wrote:
>
> With the latest Linux-6.11-rc3, the below NULL pointer crash is observed
> when SBI PMU snapshot is enabled for the guest and the guest is forcefull=
y
> powered-off.
>
>   Unable to handle kernel NULL pointer dereference at virtual address 000=
0000000000508
>   Oops [#1]
>   Modules linked in: kvm
>   CPU: 0 UID: 0 PID: 61 Comm: term-poll Not tainted 6.11.0-rc3-00018-g44d=
7178dd77a #3
>   Hardware name: riscv-virtio,qemu (DT)
>   epc : __kvm_write_guest_page+0x94/0xa6 [kvm]
>    ra : __kvm_write_guest_page+0x54/0xa6 [kvm]
>   epc : ffffffff01590e98 ra : ffffffff01590e58 sp : ffff8f80001f39b0
>    gp : ffffffff81512a60 tp : ffffaf80024872c0 t0 : ffffaf800247e000
>    t1 : 00000000000007e0 t2 : 0000000000000000 s0 : ffff8f80001f39f0
>    s1 : 00007fff89ac4000 a0 : ffffffff015dd7e8 a1 : 0000000000000086
>    a2 : 0000000000000000 a3 : ffffaf8000000000 a4 : ffffaf80024882c0
>    a5 : 0000000000000000 a6 : ffffaf800328d780 a7 : 00000000000001cc
>    s2 : ffffaf800197bd00 s3 : 00000000000828c4 s4 : ffffaf800248c000
>    s5 : ffffaf800247d000 s6 : 0000000000001000 s7 : 0000000000001000
>    s8 : 0000000000000000 s9 : 00007fff861fd500 s10: 0000000000000001
>    s11: 0000000000800000 t3 : 00000000000004d3 t4 : 00000000000004d3
>    t5 : ffffffff814126e0 t6 : ffffffff81412700
>   status: 0000000200000120 badaddr: 0000000000000508 cause: 0000000000000=
00d
>   [<ffffffff01590e98>] __kvm_write_guest_page+0x94/0xa6 [kvm]
>   [<ffffffff015943a6>] kvm_vcpu_write_guest+0x56/0x90 [kvm]
>   [<ffffffff015a175c>] kvm_pmu_clear_snapshot_area+0x42/0x7e [kvm]
>   [<ffffffff015a1972>] kvm_riscv_vcpu_pmu_deinit.part.0+0xe0/0x14e [kvm]
>   [<ffffffff015a2ad0>] kvm_riscv_vcpu_pmu_deinit+0x1a/0x24 [kvm]
>   [<ffffffff0159b344>] kvm_arch_vcpu_destroy+0x28/0x4c [kvm]
>   [<ffffffff0158e420>] kvm_destroy_vcpus+0x5a/0xda [kvm]
>   [<ffffffff0159930c>] kvm_arch_destroy_vm+0x14/0x28 [kvm]
>   [<ffffffff01593260>] kvm_destroy_vm+0x168/0x2a0 [kvm]
>   [<ffffffff015933d4>] kvm_put_kvm+0x3c/0x58 [kvm]
>   [<ffffffff01593412>] kvm_vm_release+0x22/0x2e [kvm]
>
> Clearly, the kvm_vcpu_write_guest() function is crashing because it is
> being called from kvm_pmu_clear_snapshot_area() upon guest tear down.
>
> To address the above issue, simplify the kvm_pmu_clear_snapshot_area() to
> not zero-out PMU snapshot area from kvm_pmu_clear_snapshot_area() because
> the guest is anyway being tore down.
>
> The kvm_pmu_clear_snapshot_area() is also called when guest changes
> PMU snapshot area of a VCPU but even in this case the previous PMU
> snaphsot area must not be zeroed-out because the guest might have
> reclaimed the pervious PMU snapshot area for some other purpose.
>
> Fixes: c2f41ddbcdd7 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Queued this patch for Linux-6.11 fixes.

Regards,
Anup

> ---
>  arch/riscv/kvm/vcpu_pmu.c | 14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index bcf41d6e0df0..2707a51b082c 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -391,19 +391,9 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcp=
u, unsigned int csr_num,
>  static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_pmu *kvpmu =3D vcpu_to_pmu(vcpu);
> -       int snapshot_area_size =3D sizeof(struct riscv_pmu_snapshot_data)=
;
>
> -       if (kvpmu->sdata) {
> -               if (kvpmu->snapshot_addr !=3D INVALID_GPA) {
> -                       memset(kvpmu->sdata, 0, snapshot_area_size);
> -                       kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
> -                                            kvpmu->sdata, snapshot_area_=
size);
> -               } else {
> -                       pr_warn("snapshot address invalid\n");
> -               }
> -               kfree(kvpmu->sdata);
> -               kvpmu->sdata =3D NULL;
> -       }
> +       kfree(kvpmu->sdata);
> +       kvpmu->sdata =3D NULL;
>         kvpmu->snapshot_addr =3D INVALID_GPA;
>  }
>
> --
> 2.34.1
>

