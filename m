Return-Path: <kvm+bounces-20908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E6E926786
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 20:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0E0A2839D0
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 18:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860C1184130;
	Wed,  3 Jul 2024 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CVyBY7pI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB417995
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 18:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720029645; cv=none; b=pgczLhjqHvs1HRDfu3sT67Pf0O84AGY3jk6c8mOWkFVnOVyD8i9miSwDhd8xGMtTO1obEJBEH6RaMLTOnRQBedKVVpKv/yCirw++CuhdWpC6yxhvf62beqf0o+hWYpmqLnz6RDqtlK2p8mNCJ/aVD/OH7LqjB+aQ5RBAChU7nUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720029645; c=relaxed/simple;
	bh=MiwXaHf1OIs9u+UHys9vh7EUU2xsAg5QDlUYlaszxKY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Owuy8HdTWClX82e5H/nYUe427RqC3tXACTF7xm4zSocrFJR0X5n5Jt51oQ2oXAUWvxq1HAQbRZ7SuWvbKEJO/A+ugsqgF7+/r30XjarKic2ihdcv+//5Xd1ViW++ndiSJjOyjwMt8oJGd1kkeF0kf+Sai3Qr2XaVR3HH9FKaP0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CVyBY7pI; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03a7949504so2591265276.2
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2024 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720029643; x=1720634443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ThiwK/nDxZUYa+lmSz2hn0FwYsi6mxuh9ZkgEIMmK7A=;
        b=CVyBY7pIChi1G4bh2a01LUEcHe/+ycrwdla0nXzLh+sFJhhFkh+oFWlvlSgTAA9DXb
         dJr67bzlBIqM4XkRmw6ZKNOW7CqR2nNjvR9s9SmW85yDtHCr+MldgrC9ESXJ4UKipQSU
         deSWAl9hlPCCBf1PQyVp2BCNOQ3OejfB99wPmYxDfGDbeeNtrRMBBED23nlxvxge/jRF
         NU4K9f27QxGQqu6q7nySSDL8E9hT4LUb/qTP7vdm3mtk17y9cn6jzZzp2BfRFlx7DKel
         yyaI9q9Abtaa92y23HgzNC5E8KlUV5BhGWNjWxYx9wSfrB/FyEyxi5Vn5yevrW7v5GMd
         x1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720029643; x=1720634443;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ThiwK/nDxZUYa+lmSz2hn0FwYsi6mxuh9ZkgEIMmK7A=;
        b=doyHfdyPENJZL89vcBP+00tTePHwtssHF/vmJ72hIOwhGiCBScGGKGsztCnyXAAqUP
         dlvY7mD764FNrWEFF2TgiJq1ztWIX7di1TOawWhJ5yiI1qeSjSNyJr6331BsuWBtGout
         rm9G49xDpBVPBsA8JkOzjnXrK76pCirJ2W0lxt3R1R2IP9FDfxO9hZ2Y4yfKGKQm/sH0
         ditRh+2gpTbawbghDg2ih3rp9S517stk5u8yWsaHdKIg6LcO3fX9NISyQWCq24yyRHBF
         aexjeK0JzhdwP5n1tvlJRDiIedFecc3LER9nAoQ6Jf11SvSeRzI4LAV2/GRIw+Ex0CHD
         50ig==
X-Gm-Message-State: AOJu0Ywsw2R/mbRFD4LnCNtVT3ApqTVip/fVBT+GjnpqfIH/SkZ5PwRl
	pnKND12yxQ4M5rqLPBx1F/VTc2rAuu1cH5x7Jj2OrTpEHtwPyDSydiCbc5sPB8+RRg9k5yu8jlB
	W4QoWSBwIAO90g53d6SmakquN5jDURvEv1aOi5HIXzdj4YTbQ0S9jMDG6TJYGUOUw/uMW29QjT0
	j+S/OGIG2z22aJKVmdCnl8qgZ+LrNN8amft9pI/coIQGJ1WwamNA==
X-Google-Smtp-Source: AGHT+IFDjP9eNE0bF4yLec8s8XrUZhyuHA6JR78WaGFXC0TRAwIR1qxqkDqYOCMTB9dhHuCoM4HX5QO+ItZ/pzRN
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:7f50])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:2b84:b0:e03:6556:9fa1 with
 SMTP id 3f1490d57ef6-e036ec44f66mr901837276.8.1720029643161; Wed, 03 Jul 2024
 11:00:43 -0700 (PDT)
Date: Wed,  3 Jul 2024 17:56:19 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <20240703175618.2304869-2-aaronlewis@google.com>
Subject: [PATCH] KVM: x86: Free the MSR filter after destorying VCPUs
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Delay freeing the MSR filter until after the VCPUs are destroyed to
avoid a possible use-after-free when freeing a nested guest.

This callstack is from a 5.15 kernel, but the issue still appears to be
possible upstream.

kvm_msr_allowed+0x4c/0xd0
__kvm_set_msr+0x12d/0x1e0
kvm_set_msr+0x19/0x40
load_vmcs12_host_state+0x2d8/0x6e0 [kvm_intel]
nested_vmx_vmexit+0x715/0xbd0 [kvm_intel]
nested_vmx_free_vcpu+0x33/0x50 [kvm_intel]
vmx_free_vcpu+0x54/0xc0 [kvm_intel]
kvm_arch_vcpu_destroy+0x28/0xf0
kvm_vcpu_destroy+0x12/0x50
kvm_arch_destroy_vm+0x12c/0x1c0
kvm_put_kvm+0x263/0x3c0
kvm_vm_release+0x21/0x30
__fput+0xb9/0x240
____fput+0xe/0x20
task_work_run+0x6f/0xd0
syscall_exit_to_user_mode+0x123/0x300
do_syscall_64+0x72/0xb0
entry_SYSCALL_64_after_hwframe+0x61/0xc6

Fixes: b318e8decf6b ("KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish")

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Suggested-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66c4381460dc..638696efa17e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12711,12 +12711,12 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	}
 	kvm_unload_vcpu_mmus(kvm);
 	static_call_cond(kvm_x86_vm_destroy)(kvm);
-	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_pic_destroy(kvm);
 	kvm_ioapic_destroy(kvm);
 	kvm_destroy_vcpus(kvm);
 	kvfree(rcu_dereference_check(kvm->arch.apic_map, 1));
 	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
+	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
 	kvm_mmu_uninit_vm(kvm);
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
-- 
2.45.2.803.g4e1b14247a-goog


