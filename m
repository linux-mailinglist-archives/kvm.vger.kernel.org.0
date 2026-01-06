Return-Path: <kvm+bounces-67175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F922CFAD25
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 41F733019B59
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 19:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481BD34DCD2;
	Tue,  6 Jan 2026 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="21oS4wAM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE7434DB57
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728891; cv=pass; b=YySah0bFJziCZFpDJBJxWZd7njIu+yz/B7t08HXM7CAVtYgdlmY8E7u6QbcpjbZeNF5suucDFqF5cSSIMiR4/AgXBHtNR4cqyii/5mVYaici7z7C/+RwnhgRpkIqJvlDAkk0zPjN2jPUoU7hHBe78PCZosLjigMgmtH1coTvWxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728891; c=relaxed/simple;
	bh=1YnjR/UJ25pEnbpL/aXyQKLrts/m65bSQntodSlPo/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ON4B9Niy2pLhdTI1vMCZNz31hcKQMyM6K0VDmedCHHcY5BkT3FQMYeKL2FqL9MRS4XS8W6bmlZkyVLaFaj7qwQ8ug/lYe3o5mJ5xfw0Gt3nSp/L6ww0lmaCQYFNdZ7r0uXNDYGbE1kG/yasjJUbartfgQwxkwcKXC7EJiupH/Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=21oS4wAM; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso58971cf.1
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 11:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767728888; cv=none;
        d=google.com; s=arc-20240605;
        b=QBTNYHyiPmzvB052j/3tBa4qdeqlgI2G3bN821CNHysSQfYAQoTWFx/7zBWjQN54E9
         1CbM5R708BWUdj7Y6I7Xka4HzGQsJihIe+7jdxFc5MVDaHndCJ2hAyYqu1jkR24bP3x7
         h24gLe3filq4pmZm0+9p8r3ChWTbhogCsaC9DKBv7FwdGjnWFlUrEbkbvFrbK4ll/SIg
         Er4DrQkFX6q/gq0hASSX4L/Vx52rykDqSkur6t0+BHwMPgx+1FGK9eRC+u7N2T6RWpB0
         YWNT4toX/b2UHr+tM7DmVP1/ISkmrVx3r1qp20UVlkTw0NrE/ydwoWmoUYMm2yVxhPPf
         hjGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wS9AM92Mn02DFNJwpffp+t4vLG7gYdsW/Jw2tqGYH/I=;
        fh=hoB2u8tYUwncZ7Ipz/SvzbAkGqpzX3uzz9WdysyarSc=;
        b=WqbqHx0s5/h11mRpczkkBnAhbUFhWnxe+P9Vc8F/7ayx+vGof/tXXbf89AzEcs/+um
         VBdatEZyL1ni8UgyvJa/3KVWEXz0LRkj7nrEE12DhKec/5XaD3xaLkw35D4WXE/cmWKA
         bvGKAwd++YS2T6lUTN5SSBvTytZHfYYcG2LGy/tWuW/hmtisWIMQxnWRxT1LPtNIf3/P
         z5P6sy7zVBNomHfr9SVuh/3xgJCElfFE+6Z2P/bxsEfeHgnV6PaEPMMOFnFfyjWfykRJ
         FYPmqbN3hu83Yj8E9imeXUCUGArUArAY8w6HoouLEltvMM2UCem1Kv6Fzz6s5zajoM9g
         +YFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767728888; x=1768333688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wS9AM92Mn02DFNJwpffp+t4vLG7gYdsW/Jw2tqGYH/I=;
        b=21oS4wAMfv3a25CIVWJbwiWWGJrpaP5Ib7szEOJFmC/opPLTaWqZuuAyTXLgAiGfFi
         e3KdRrzYgn/5qtQM4OzukTeIIRE9UBiHjKud8Cijy8m+aUS8rhxbyYz/6LYeo5wQtI1x
         tOpaVl5S+0gitifLTxS5QeXHcUU6w18EO4d7IbW5Z3Htd7R+zPlZ0JvOX8QKx0nC34rn
         aD0mcwSSqJJ78kYnGHeYqgDYbVbbHOXvGVRHeLN0RTjb1nrLR/sx3omZ322MybrPAEqG
         498E//Hcr+3ivpkXPgj5wszS0m9Br6l7GN67uCsAwD8PJ109nSUoXcHxrii1TV6Ub8UG
         Ekxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767728888; x=1768333688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wS9AM92Mn02DFNJwpffp+t4vLG7gYdsW/Jw2tqGYH/I=;
        b=YzO4ri5Znpm48mybpXppE++NK3rZpKpCz2WZtRepQ6yAwE909qwgnfWmPpMDetdg+6
         0QuWlhJQ21qKzomgAkxW4AAc8t8XJXfoidVPkXu8iv6nEpmk5giGqmG42hFFnBEUceqm
         OIRxrFf5xrk8GcXaRYuZfkSDVySCneztLgEDiGMyVA3K3C+pVaFgSH+4QZWl8xC/Jksq
         Obd1D5WxpghQFk41ZgnmMt3MITwjkaOsa+PMSi96NwOruS9BsTlI4TTqKybdpKeQ4fzg
         mdLJ5DW2/F8jQi0BkFKi5f18cX+EXgdWwhqOMUJiNOPq0m9mGkE+EY3Hd+YCqR79GDSd
         KIUg==
X-Forwarded-Encrypted: i=1; AJvYcCVDQPGs8zdYbNCo+8TkIt+OMP9nKJufMDHJPCKWkBeH+D8CYW0isQbRbAMxvT+rmPCCbxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHNUCx2xoQQYeq2XtO4ERgUKTzAaGAraGALIs6TojBG5IvrY3v
	ulaRqVauIB65xTQ14d4FIFL82ppnHE9gS7KqebYtJc5Y2Epr5KJfxjmQZDeKwuSfRMGyu7Yk+Ls
	8vwkl2odmAMore+wYs/q2OhMsKKbrEPuikP3Q4fCu
X-Gm-Gg: AY/fxX7TvDMIEA/uU9kRBGJf9wbbGE4rhCPhE5tjnVPb6MOaAZaPEtY4ojX9pbrcLZa
	7ttTKM2dvB83v8rXKDeOY51hdBhQYhpyETNg8Ym/spzQJlIvvOPMkwP3cRm42cK80yRwAsGrK0U
	rm3tx9hE3p9BBGzd1JGfKiEiSC57j8vFVEB6kxRVVe/9GCydt+wEsyoor0TYDYvnr4GTsjAj24M
	Y2lcv0/5Jcco1Jx6U+AFqZbkhAWXAIlB8PN2ugtaxc0FN7cTXHJt7dLH9U7r4Y9/EQrqmcRhEPF
	5Ig6ANJAfNWq2NE8vbE6DjNOiow=
X-Google-Smtp-Source: AGHT+IF97VK6tDNOBZzvsiPagHn7GUyN7RhOp87+78douastKbgccj1G+jkn3mhW/jYBWjzTxn9oVW+lOpm9CmPfSSI=
X-Received: by 2002:a05:622a:34b:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4ffb3f2370emr1151991cf.9.1767728887404; Tue, 06 Jan 2026
 11:48:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-7-rananta@google.com>
 <aUSNoBzvybi24SUD@google.com>
In-Reply-To: <aUSNoBzvybi24SUD@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 6 Jan 2026 11:47:56 -0800
X-Gm-Features: AQt7F2rAfTk-cbu6zx3OjEoh2OdQyifmOtjD8UmvvrzmBuM80EpWXTesyjQ404M
Message-ID: <CAJHc60zAB8pyc7=ca=eOf+SEEvnZ3JxVEnZoOtgj+mX1GQiALw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+ cc: iommu@lists.linux.dev for the crash

Thank you.
Raghavendra


On Thu, Dec 18, 2025 at 3:26=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> > Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
> > SR-IOV UAPI, including the following cases, iterating over
> > all the IOMMU modes currently supported:
> >  - Setting correct/incorrect/NULL tokens during device init.
> >  - Close the PF device immediately after setting the token.
> >  - Change/override the PF's token after device init.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> I hit the following kernel NULL pointer dereference after running the
> new test a few times (nice!).
>
> Repro:
>
>   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:16:00.1
>   $ tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test 0000:16:00.1
>   $ tools/testing/selftests/vfio/scripts/cleanup.sh
>   ... repeat ...
>
> The panic:
>
> [  553.245784][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci =
failed with error -22
> [  553.256622][T27601] vfio-pci 0000:1a:00.0: probe with driver vfio-pci =
failed with error -22
> [  574.857650][T27935] BUG: kernel NULL pointer dereference, address: 000=
0000000000008
> [  574.865322][T27935] #PF: supervisor read access in kernel mode
> [  574.871175][T27935] #PF: error_code(0x0000) - not-present page
> [  574.877021][T27935] PGD 4116e63067 P4D 40fb0a3067 PUD 409597f067 PMD 0
> [  574.883654][T27935] Oops: Oops: 0000 [#1] SMP NOPTI
> [  574.888551][T27935] CPU: 100 UID: 0 PID: 27935 Comm: vfio_pci_sriov_ T=
ainted: G S      W           6.18.0-smp-DEV #1 NONE
> [  574.899600][T27935] Tainted: [S]=3DCPU_OUT_OF_SPEC, [W]=3DWARN
> [  574.905104][T27935] Hardware name: Google Izumi-EMR/izumi, BIOS 0.2025=
0801.2-0 08/25/2025
> [  574.913289][T27935] RIP: 0010:rb_insert_color+0x44/0x110
> [  574.918623][T27935] Code: cc cc 48 89 cf 48 83 cf 01 48 89 3a 48 89 38=
 48 8b 01 48 89 cf 48 83 e0 fc 48 89 01 74 d7 48 8b 08 f6 c1 01 0f 85 c1 00=
 00 00 <48> 8b 51 08 48 39 c2 74 0c 48 85 d2 74 4f f6 02 01 74 c5 eb 48 48
> [  574.938080][T27935] RSP: 0018:ff85113dcdd6bb08 EFLAGS: 00010046
> [  574.944013][T27935] RAX: ff3f257594a99e80 RBX: ff3f25758af490c0 RCX: 0=
000000000000000
> [  574.951857][T27935] RDX: 0000000000001a00 RSI: ff3f25360038eb70 RDI: f=
f3f2536658bbee0
> [  574.959702][T27935] RBP: ff3f25360038ea00 R08: 0000000000000002 R09: f=
f85113dcdd6badc
> [  574.967544][T27935] R10: ff3f257590ab8000 R11: ffffffffa78210a0 R12: f=
f3f2536658bbea0
> [  574.975387][T27935] R13: 0000000000000286 R14: ff3f25758af49000 R15: f=
f3f25360038eb78
> [  574.983230][T27935] FS:  00000000223403c0(0000) GS:ff3f25b4d4d83000(00=
00) knlGS:0000000000000000
> [  574.992032][T27935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  574.998488][T27935] CR2: 0000000000000008 CR3: 00000040fa254005 CR4: 0=
000000000f71ef0
> [  575.006332][T27935] PKRU: 55555554
> [  575.009753][T27935] Call Trace:
> [  575.012919][T27935]  <TASK>
> [  575.015730][T27935]  intel_iommu_probe_device+0x4c9/0x7b0
> [  575.021153][T27935]  __iommu_probe_device+0x101/0x4c0
> [  575.026231][T27935]  iommu_bus_notifier+0x37/0x100
> [  575.031046][T27935]  blocking_notifier_call_chain+0x53/0xd0
> [  575.036634][T27935]  bus_notify+0x99/0xc0
> [  575.040666][T27935]  device_add+0x252/0x470
> [  575.044872][T27935]  pci_device_add+0x414/0x5c0
> [  575.049429][T27935]  pci_iov_add_virtfn+0x2f2/0x3e0
> [  575.054326][T27935]  sriov_add_vfs+0x33/0x70
> [  575.058613][T27935]  sriov_enable+0x2fc/0x490
> [  575.062992][T27935]  vfio_pci_core_sriov_configure+0x16c/0x210
> [  575.068843][T27935]  sriov_numvfs_store+0xc4/0x190
> [  575.073652][T27935]  kernfs_fop_write_iter+0xfe/0x180
> [  575.078724][T27935]  vfs_write+0x2d0/0x430
> [  575.082846][T27935]  ksys_write+0x7f/0x100
> [  575.086965][T27935]  do_syscall_64+0x6f/0x940
> [  575.091339][T27935]  ? arch_exit_to_user_mode_prepare+0x9/0xb0
> [  575.097193][T27935]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  575.102952][T27935] RIP: 0033:0x46fcf7
> [  575.106721][T27935] Code: 48 89 fa 4c 89 df e8 88 16 00 00 8b 93 08 03=
 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10=
 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> [  575.126178][T27935] RSP: 002b:00007ffe991aff40 EFLAGS: 00000202 ORIG_R=
AX: 0000000000000001
> [  575.134457][T27935] RAX: ffffffffffffffda RBX: 00000000223403c0 RCX: 0=
00000000046fcf7
> [  575.142301][T27935] RDX: 0000000000000001 RSI: 00007ffe991b1050 RDI: 0=
000000000000003
> [  575.150143][T27935] RBP: 00007ffe991b0ff0 R08: 0000000000000000 R09: 0=
000000000000000
> [  575.157985][T27935] R10: 0000000000000000 R11: 0000000000000202 R12: 0=
0007ffe991b1768
> [  575.165829][T27935] R13: 0000000000000016 R14: 00000000004dd480 R15: 0=
000000000000016
> [  575.173677][T27935]  </TASK>
> [  575.176573][T27935] Modules linked in: vfat fat dummy bridge stp llc i=
ntel_vsec cdc_acm cdc_ncm cdc_eem cdc_ether usbnet mii xhci_pci xhci_hcd eh=
ci_pci ehci_hcd
> [  575.190930][T27935] CR2: 0000000000000008
> [  575.194960][T27935] ---[ end trace 0000000000000000 ]---
> [  575.204004][T27935] RIP: 0010:rb_insert_color+0x44/0x110
> [  575.209336][T27935] Code: cc cc 48 89 cf 48 83 cf 01 48 89 3a 48 89 38=
 48 8b 01 48 89 cf 48 83 e0 fc 48 89 01 74 d7 48 8b 08 f6 c1 01 0f 85 c1 00=
 00 00 <48> 8b 51 08 48 39 c2 74 0c 48 85 d2 74 4f f6 02 01 74 c5 eb 48 48
> [  575.228796][T27935] RSP: 0018:ff85113dcdd6bb08 EFLAGS: 00010046
> [  575.234729][T27935] RAX: ff3f257594a99e80 RBX: ff3f25758af490c0 RCX: 0=
000000000000000
> [  575.242572][T27935] RDX: 0000000000001a00 RSI: ff3f25360038eb70 RDI: f=
f3f2536658bbee0
> [  575.250414][T27935] RBP: ff3f25360038ea00 R08: 0000000000000002 R09: f=
f85113dcdd6badc
> [  575.258263][T27935] R10: ff3f257590ab8000 R11: ffffffffa78210a0 R12: f=
f3f2536658bbea0
> [  575.266105][T27935] R13: 0000000000000286 R14: ff3f25758af49000 R15: f=
f3f25360038eb78
> [  575.273948][T27935] FS:  00000000223403c0(0000) GS:ff3f25b4d4d83000(00=
00) knlGS:0000000000000000
> [  575.282741][T27935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  575.289197][T27935] CR2: 0000000000000008 CR3: 00000040fa254005 CR4: 0=
000000000f71ef0
> [  575.297046][T27935] PKRU: 55555554
> [  575.300466][T27935] Kernel panic - not syncing: Fatal exception
> [  575.345557][T27935] Kernel Offset: 0x25800000 from 0xffffffff81000000 =
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  575.362075][T27935] mtdoops: Cannot write from panic without panic_wri=
te
> [  575.368795][T27935] Rebooting in 10 seconds..
>
> I also have the following diff on top of your series to fix the other
> bug you found.
>
> diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/sel=
ftests/vfio/lib/sysfs.c
> index 5551e8b98107..d94616e8aff4 100644
> --- a/tools/testing/selftests/vfio/lib/sysfs.c
> +++ b/tools/testing/selftests/vfio/lib/sysfs.c
> @@ -40,7 +40,7 @@ static void sysfs_set_val(const char *component, const =
char *name,
>
>  static int sysfs_get_device_val(const char *bdf, const char *file)
>  {
> -       sysfs_get_val("devices", bdf, file);
> +       return sysfs_get_val("devices", bdf, file);
>  }
>
>  static void sysfs_set_device_val(const char *bdf, const char *file, cons=
t char *val)
>
> I'm not sure which exact test case triggered the panic. This is the only
> test output that made it to my ssh window:
>
>   TAP version 13
>   1..45
>   # Starting 45 tests from 15 test cases.
>   #  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.in=
it_token_match ...

