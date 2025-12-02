Return-Path: <kvm+bounces-65057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17B76C99D2A
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 03:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6231D3A4D0B
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 02:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E06224B04;
	Tue,  2 Dec 2025 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yv8py3VZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F76B212B31
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 02:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641020; cv=none; b=NY81Wj5Yi1njLLrqRYrH5htit4ujzK+3TUSWoNkQsr/j0myOocX38gfLHjFrgBkQSacPuzXKMqQ0zt9E2/npk7TYuG22gH0v++Wgg3dh2EJlQEmph7vfGw4+TBK3ERGJI1xtoHZLmZ8PawSEkmYX366t2Ie4z/aInOYoK464t3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641020; c=relaxed/simple;
	bh=hg+dKOfYTC+Pd8pCiItqJSzZxpkF+UZ63xbDGe51t14=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nq2el/FUs1nQcEWmj17Jg0T0abwovSqaG/AgYq+EBB1GKYGLD867kNXMYankBgTKmgPqPCeWoeDdQD3mjuKVF13WaVTp8oCitX900/Mvrliy0HLWqf8sEaQ8P0IyOIww3r+5F7KXGzA2YOm4fXT73IKMIi5bSFQCd4BDhoma+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yv8py3VZ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9208e1976so7698943b3a.1
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 18:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764641018; x=1765245818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BPeQZ43Hcfmq7Td8KMLsolI+fW6jW5ccnQO0u+Kn36Y=;
        b=Yv8py3VZxuq+R5vgdZopnoXb7wmj4ue0GoPsIWroWPgSrJeGwMxvldDPEaTqMlghg9
         Av47KpoiNzIV6TXcmF7wf9q489BNwlNGIc1DQ9+fUY0EjH9+cPVNj6OHdwkYVGmDoXRV
         MCYs8T/JPVjutMgPGpEaTjVPmurYvpC8wSwCfeRkr4kBUxbtxKFshtloiYF92PY7VAXp
         t9oKkGIOIFEenB4jyCtOTf+C4ceyRfA8Xk+eSeAuTv92aRLrGyK5Kk575v02qCZpcFtV
         8ftK0HRTKnrDt/UGqrRMQVElkRQClVnL/PGRr99cF7Zi9jZi+2+W5TTJC4x6j7+OwkgA
         bKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641018; x=1765245818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPeQZ43Hcfmq7Td8KMLsolI+fW6jW5ccnQO0u+Kn36Y=;
        b=HCOP/5WpTezqRdYQVIJ2D5ZW/gDRyhk72J4U+n69VBrYzicgao83trQ1YzDTr2TXgE
         w0MYGGBXlBw2P7xRQiD8zJgql/DAVHxJAI2pDPKbMiopVi6ES7nwaPYgezUL5Hx3CuhC
         4/PhfnU3KHeOe2I93WGkXjkWyXxJRYqrJDLW7GtgMzvujDfeYdrFN2Vp3HmGuYz83VKF
         ISxHRamA7bXftJizZeIO3Ia2vuJ0Gv1PxtnpI4CGkwg21naX1MvE9qIpbaJVphJZb/cv
         KpHp84EQuUDO3+abauCnanNHwODcHLFJ0hUvjuoGiiCfXTIohkmVnVvpKREzahVsbXN9
         M2eg==
X-Gm-Message-State: AOJu0YxjPU65uKkjQmN7hIc9Q7dlADkIy596ZcxrGLg0KNkI/pXbZxlr
	kwtK9MKSBFnd4RS5MCtZI67EQjIy01byGGYl921avuOMOsEPl3uF2xe+j9fYhKCazPvJCrGjD9P
	yQarw3w==
X-Google-Smtp-Source: AGHT+IGwxqcF5HGKU98QglmRtnsyeeupEdYEOXFBBsc9Evieq/fD8PzoR2iQw1xACcwNtVEbS81mTrskymo=
X-Received: from pgvz4.prod.google.com ([2002:a65:6644:0:b0:b6c:f6a5:fdbe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3383:b0:35f:aa1b:bbff
 with SMTP id adf61e73a8af0-3614eaf50cbmr41930160637.11.1764641018289; Mon, 01
 Dec 2025 18:03:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  1 Dec 2025 18:03:33 -0800
In-Reply-To: <20251202020334.1171351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202020334.1171351-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202020334.1171351-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Reject attempts to disable KVM_MEM_GUEST_MEMFD on a memslot that was
initially created with a guest_memfd binding, as KVM doesn't support
toggling KVM_MEM_GUEST_MEMFD on existing memslots.  KVM prevents enabling
KVM_MEM_GUEST_MEMFD, but doesn't prevent clearing the flag.

Failure to reject the new memslot results in a use-after-free due to KVM
not unbinding from the guest_memfd instance.  Unbinding on a FLAGS_ONLY
change is easy enough, and can/will be done as a hardening measure (in
anticipation of KVM supporting dirty logging on guest_memfd at some point),
but fixing the use-after-free would only address the immediate symptom.

  ==================================================================
  BUG: KASAN: slab-use-after-free in kvm_gmem_release+0x362/0x400 [kvm]
  Write of size 8 at addr ffff8881111ae908 by task repro/745

  CPU: 7 UID: 1000 PID: 745 Comm: repro Not tainted 6.18.0-rc6-115d5de2eef3-next-kasan #3 NONE
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   <TASK>
   dump_stack_lvl+0x51/0x60
   print_report+0xcb/0x5c0
   kasan_report+0xb4/0xe0
   kvm_gmem_release+0x362/0x400 [kvm]
   __fput+0x2fa/0x9d0
   task_work_run+0x12c/0x200
   do_exit+0x6ae/0x2100
   do_group_exit+0xa8/0x230
   __x64_sys_exit_group+0x3a/0x50
   x64_sys_call+0x737/0x740
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7f581f2eac31
   </TASK>

  Allocated by task 745 on cpu 6 at 9.746971s:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x13/0x50
   __kasan_kmalloc+0x77/0x90
   kvm_set_memory_region.part.0+0x652/0x1110 [kvm]
   kvm_vm_ioctl+0x14b0/0x3290 [kvm]
   __x64_sys_ioctl+0x129/0x1a0
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

  Freed by task 745 on cpu 6 at 9.747467s:
   kasan_save_stack+0x20/0x40
   kasan_save_track+0x13/0x50
   __kasan_save_free_info+0x37/0x50
   __kasan_slab_free+0x3b/0x60
   kfree+0xf5/0x440
   kvm_set_memslot+0x3c2/0x1160 [kvm]
   kvm_set_memory_region.part.0+0x86a/0x1110 [kvm]
   kvm_vm_ioctl+0x14b0/0x3290 [kvm]
   __x64_sys_ioctl+0x129/0x1a0
   do_syscall_64+0x5b/0x900
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Reported-by: Alexander Potapenko <glider@google.com>
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eca084bdcbe..8891df136416 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2085,7 +2085,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
-		    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
+		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
 			return -EINVAL;
 
 		if (base_gfn != old->base_gfn)
-- 
2.52.0.107.ga0afd4fd5b-goog


