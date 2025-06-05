Return-Path: <kvm+bounces-48553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 693BBACF386
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFCBE3A41A4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393A11EA7DF;
	Thu,  5 Jun 2025 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibfa71yi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77451DE3DF
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749139058; cv=none; b=ISnNY4gcJOQnbdZ0IimVKnGq1gZOxJoOnWxxIyIVfUSMuIWJHITsuZVCb+35a9pv6GjX7dqiSTKyaWCb60fe1mV9i72eVekQVwUiIyJ8OAoYvlgl7CdUcowQ7Ln8IbKeJ53p7rvYlpKM+XdbcoOQcwsZj8NDgwHBwlh1TfuJ1O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749139058; c=relaxed/simple;
	bh=wyyQ6BchCIzJA8trTSkXD8vCrsq87Hhly83pzMT6YJc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zsod+s7/hkDBrLYtVJ/Hvryh7VYlmkAFDp0rrmGvHYfppBIla6WztP08v1CCYqymASGz7w3eQl/d202abRxhB6D2Zxz633GEIOD5gt8q+dJ4XaP7se86lZ7Gl8d6n31O7QavMc6Zy80J5CzcOVDlv2G7XiGqBhqgB5ItluBl+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ibfa71yi; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7480c9bcfdbso1138399b3a.0
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749139056; x=1749743856; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGHUSW/Hf0c2afWsobrwusmO9+vYauEiHWfu8hcLqhU=;
        b=ibfa71yiaAUqTEgwXMeJzvO511XCXBudMEXtNpRnEwpF+yC7zu4IaEClU6pV4G6xQd
         4SBIgBcHmhFFR/uIFEr0sXpUa8Hep1KgqDpEcqUtDer9Uvvkza9J/5/dsxe7QIN+s9GW
         FxiL5VK2xU6TInWIUSWpj7ZTTvqDBIMEFTcxoBdKYumC8P+wFD33LfRkKPlziRn5T2i1
         XrZtRSGwaOkf7lvUQKq6trYexitHOlZY9ruDAZy6OhIHEqgNo9uiH6SXBm+kMBSSOvlD
         8/Z5kuibQ+E6CoGlGJ9L7WGoUBu/EJZvSpmVzGjPmsrf9SdziJHUKGwWNuWLlr9sMUa7
         OePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749139056; x=1749743856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGHUSW/Hf0c2afWsobrwusmO9+vYauEiHWfu8hcLqhU=;
        b=cSxTbTx0Bt0Aheb6CF5doN/TviBqLAXG+QZRhebw/3AIMom9c/xSTioSOKheMT9dBf
         51tikTNHadj4hrDZJw4npEjF2kpslugUxVeLicB6h0N6263oePkcTbKDQQhsNCKBvsL+
         cLBU38pWCaqV9BLzb+eJ3Jpa+REBD1kzAiNGAxfKuw3KUVCLAFU/ST8CouzUCTUQq7X6
         ZSxDzpZB2sRS2OvizR0Kp9T2Gs75LDw9XIL8vPdCr5x8Z2aHyNxCRK1yB2HCrij0GH3v
         B8Q+rVlYqjyUl6g+It7tyBhsiCJ+FrZ7gNzCqCmMPTqHsdkGSrfcysiF6epug4BA25h2
         bFgQ==
X-Gm-Message-State: AOJu0YxwVwyVi/Wk/1mlNJrQIYaOnDKXGEPVOGIVs1ngUAgfZ3udnKSm
	vSX0eBSmR+7D1dTvIOkABCljGDVVnLA4D0qharNBn7jJ/eXSpSMJL95/XCr73z/qxmbBGMsj9Bd
	1TEun1Q==
X-Google-Smtp-Source: AGHT+IEoCT4d4WzRW3QR+yqLFQv9xBXq19KX34yOeZ05wV5lffxShKXp8K/SyvWzMhHVKzfZxIgqfM3PIV4=
X-Received: from pfbho9.prod.google.com ([2002:a05:6a00:8809:b0:746:1e60:660e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e07:b0:747:cffb:bb37
 with SMTP id d2e1a72fcca58-74827e808a9mr295534b3a.10.1749139056168; Thu, 05
 Jun 2025 08:57:36 -0700 (PDT)
Date: Thu, 5 Jun 2025 08:57:34 -0700
In-Reply-To: <20250605152502.919385-2-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605152502.919385-1-liam.merwick@oracle.com> <20250605152502.919385-2-liam.merwick@oracle.com>
Message-ID: <aEG-bmjRgqlxZAIR@google.com>
Subject: Re: [PATCH 1/3] KVM: Batch setting of per-page memory attributes to
 avoid soft lockup
From: Sean Christopherson <seanjc@google.com>
To: Liam Merwick <liam.merwick@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, tabba@google.com, ackerleytng@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 05, 2025, Liam Merwick wrote:
> When booting an SEV-SNP guest with a sufficiently large amount of memory (1TB+),
> the host can experience CPU soft lockups when running an operation in
> kvm_vm_set_mem_attributes() to set memory attributes on the whole
> range of guest memory.
> 
> watchdog: BUG: soft lockup - CPU#8 stuck for 26s! [qemu-kvm:6372]
> CPU: 8 UID: 0 PID: 6372 Comm: qemu-kvm Kdump: loaded Not tainted 6.15.0-rc7.20250520.el9uek.rc1.x86_64 #1 PREEMPT(voluntary)
> Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB Tray,2U,E4-2c, BIOS 78016600 11/13/2024
> RIP: 0010:xas_create+0x78/0x1f0
> Code: 00 00 00 41 80 fc 01 0f 84 82 00 00 00 ba 06 00 00 00 bd 06 00 00 00 49 8b 45 08 4d 8d 65 08 41 39 d6 73 20 83 ed 06 48 85 c0 <74> 67 48 89 c2 83 e2 03 48 83 fa 02 75 0c 48 3d 00 10 00 00 0f 87
> RSP: 0018:ffffad890a34b940 EFLAGS: 00000286
> RAX: ffff96f30b261daa RBX: ffffad890a34b9c8 RCX: 0000000000000000
> RDX: 000000000000001e RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffad890a356868
> R13: ffffad890a356860 R14: 0000000000000000 R15: ffffad890a356868
> FS:  00007f5578a2a400(0000) GS:ffff97ed317e1000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f015c70fb18 CR3: 00000001109fd006 CR4: 0000000000f70ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  xas_store+0x58/0x630

Trim the '?' lines when including a backtrace in a changelog, they're pure noise.

>  __xa_store+0xa5/0x130
>  xa_store+0x2c/0x50
>  kvm_vm_set_mem_attributes+0x343/0x710 [kvm]
>  kvm_vm_ioctl+0x796/0xab0 [kvm]
>  __x64_sys_ioctl+0xa3/0xd0
>  do_syscall_64+0x8c/0x7a0
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7f5578d031bb
> Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d 4c 0f 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffe0a742b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000004020aed2 RCX: 00007f5578d031bb
> RDX: 00007ffe0a742c80 RSI: 000000004020aed2 RDI: 000000000000000b
> RBP: 0000010000000000 R08: 0000010000000000 R09: 0000017680000000
> R10: 0000000000000080 R11: 0000000000000246 R12: 00005575e5f95120
> R13: 00007ffe0a742c80 R14: 0000000000000008 R15: 00005575e5f961e0
> 
> Limit the range of memory per operation when setting the attributes to
> avoid holding kvm->slots_lock for too long and causing a cpu soft lockup.

Holding slots_lock is totally fine.  Presumably the issue is that the CPU never
reschedules.

E.g. I would expect this to make the problem go away, though it's probably not a
complete fix (I'm guessing kvm_range_has_memory_attributes() can be made to yell
too).

I'd strongly prefer to avoid arbitrary batching, because that raises a bunch of
questions that are difficult to answer, e.g. what guarantees 512GiB is a "good"
batch size on _all_ systems.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b24db92e98f3..28230bad43f4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2513,6 +2513,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
                r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
                if (r)
                        goto out_unlock;
+
+               cond_resched();
        }
 
        kvm_handle_gfn_range(kvm, &pre_set_range);
@@ -2521,6 +2523,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
                r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
                                    GFP_KERNEL_ACCOUNT));
                KVM_BUG_ON(r, kvm);
+               cond_resched();
        }
 
        kvm_handle_gfn_range(kvm, &post_set_range);

