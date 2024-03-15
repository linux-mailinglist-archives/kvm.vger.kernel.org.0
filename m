Return-Path: <kvm+bounces-11931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BE087D34E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:08:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F194C1F241E5
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B9850A60;
	Fri, 15 Mar 2024 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xes9C2sK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BC4EB3F
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710526077; cv=none; b=f0lDzRNSRbhMUE4k6clG5MHDBpS5IuD/Z3sDixFiE93XlgM+ZE6wRkL7qbc9icyBuuJrxXV3fx8WFCwlhgROBHsoFNEmpNo5PNgxOmLIznFhglRfxHAWHTTRHFzZdF/5Q0fFEEK6APld0dvvT8XopUP9CLHENGBTlFbb2FeETDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710526077; c=relaxed/simple;
	bh=Ig5e3Uo4Kt6VkXUFZYwYIev6o2L4kkKcvCSrIKfFMiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ac1XCNnkNTvgtxxg73LFa3Tw45uZSna4Yvb8sXQOI6g4J3xiC+yzzeRTjrmksqEG6R4jp48NwASLxXeNZwqL82CkAooRGU4Egp/0tW2Pqq8W5CTarzWnTuXAtzFU4GB7buQVDCjnnNxzOSyj/TN/cdgbkEn0weZ7wENczS+32iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xes9C2sK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-413fffc0a4dso6898765e9.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 11:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710526072; x=1711130872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/uFlk2C9GRLTlRVUjXmHsG5FS0j/ZDm8S03vQkEIVE=;
        b=xes9C2sKv6nAzgSSvS79CDOxKRuly7kPIq7/6k15weTwgIAEZVSRZpzgEmdIod7O4p
         k024rijIRGxPJSmPyLt93vYM0Ay8uY0pOznXE4CFgwtk1Gp9cKpCwwoyYbeCUz5fToYN
         NTq22HHWz13xINuABOele/HzaaX88G8skfReTxVu7ydRLER0oS5KH/2e5auOAqrfHT30
         ASaM6REpsZdrZf6rsc8xDvtX1AKaaVfJ+ZKFHWHUOkAJGzdWDYon2paEnxAviwqpVWIi
         zMTV5SBYKVSMBOZYYG8BlArBQHHLlGXdzuUsliyytDMw2O+K1CzwoaOsBIZzrRzCNztM
         Ro2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710526072; x=1711130872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/uFlk2C9GRLTlRVUjXmHsG5FS0j/ZDm8S03vQkEIVE=;
        b=NSE5isSFnSDCxfICX2zvoLSUzW/1uTXgvHdfM7ZvrukIdvnfyqZtwTKkKZjK+Hjuyz
         l2NGm8cT3QzSc8KpSUKnOQFJlZSNUo+vjtd7GSjq8uHtCTPat0GcD8CpRHN7LrD0lvvX
         yutzr3ESiDt/24LMxyf0KL/5Gw3uNfQzUfCQ5SGpsDm6kbVsm9I4qWlCECjbXfkV0Day
         25XswoGpirXD82mO1h6L3R7MyPx4WC2i92tGfhxaXlkXrKv/bvVydhcCIiriqc1u2EvB
         0HoevFbEJdb6CyEnIV6iyqzbRGdeRaUuVbzDqxjBujk3HtGCGSUwAER/UJMABMIKo0UI
         GOxw==
X-Forwarded-Encrypted: i=1; AJvYcCW3uAgHzgg3LHgs3xI7tIN4AFkxaMo3964OoA3e2yMCHgbV9ZWd+SLNrtzRS1SFBmgPbssKX0mD4nd0tZ2WR7MF8A0n
X-Gm-Message-State: AOJu0Yzs4viBlEMtRcLUCvH8K8/w3qnKNw8mr40bDPKyIhjzuf3mjgUq
	fLmpR9Dez2hCE+Lp5wgtJPgs1GxB0DtqlsBIX4e/dHB96QZAj1Spl5qN8DvXd/8/CscIz3XFbXa
	aqwHVx6ExkPTG2Lb8JPbUsRYgGvxj7hCNxnUP
X-Google-Smtp-Source: AGHT+IGu6nVIelPinwKh8fg6JNaOh4MQswSKQ5MDu0Jozj6hakVDTRHEIHR55aeCL8Ju3fxhF1bLe+V+Qudn+IrgWEs=
X-Received: by 2002:a05:600c:4e16:b0:413:feb5:96f6 with SMTP id
 b22-20020a05600c4e1600b00413feb596f6mr2425881wmq.21.1710526072329; Fri, 15
 Mar 2024 11:07:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000c6526f06137f18cc@google.com>
In-Reply-To: <000000000000c6526f06137f18cc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 15 Mar 2024 11:07:24 -0700
Message-ID: <CALzav=euH_n9WXG29CFd10urh85O4Mw2L=StEizVmh27CYzrtQ@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] WARNING in clear_dirty_gfn_range
To: syzbot <syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024 at 4:34=E2=80=AFPM syzbot
<syzbot+900d58a45dcaab9e4821@syzkaller.appspotmail.com> wrote:
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5165 at arch/x86/kvm/mmu/tdp_mmu.c:1526 clear_dirty_=
gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:1526
> Modules linked in:
> CPU: 1 PID: 5165 Comm: syz-executor417 Not tainted 6.8.0-syzkaller-01185-=
g855684c7d938 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:clear_dirty_gfn_range+0x3d6/0x540 arch/x86/kvm/mmu/tdp_mmu.c:15=
26
> Call Trace:
>  <TASK>
>  kvm_tdp_mmu_clear_dirty_slot+0x24f/0x2e0 arch/x86/kvm/mmu/tdp_mmu.c:1557
>  kvm_mmu_slot_leaf_clear_dirty+0x38b/0x490 arch/x86/kvm/mmu/mmu.c:6783
>  kvm_mmu_slot_apply_flags arch/x86/kvm/x86.c:12962 [inline]
>  kvm_arch_commit_memory_region+0x299/0x490 arch/x86/kvm/x86.c:13031
>  kvm_commit_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1751 =
[inline]
>  kvm_set_memslot+0x4d3/0x13e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1=
994
>  __kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2129 [=
inline]
>  __kvm_set_memory_region+0xdbc/0x1520 arch/x86/kvm/../../../virt/kvm/kvm_=
main.c:2020
>  kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:2150 [in=
line]
>  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c=
:2162 [inline]
>  kvm_vm_ioctl+0x151c/0x3e20 arch/x86/kvm/../../../virt/kvm/kvm_main.c:515=
2

The reproducer uses nested virtualization to launch an L2 with EPT
disabled. This creates a TDP MMU root with role.guest_mode=3D1, which
triggers the WARN_ON() in kvm_tdp_mmu_clear_dirty_slot() because
kvm_mmu_page_ad_need_write_protect() returns false whenever PML is
enabled and the shadow page role.guest_mode=3D1.

If I'm reading prepare_vmcs02_constant_state() correctly, we always
disable PML when running in L2. So when enable_pml=3D1 and L2 runs with
EPT disabled we are blind to dirty tracking L2 accesses.

