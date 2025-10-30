Return-Path: <kvm+bounces-61525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BFFC21E64
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A58B31882CDA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0710C2FE06D;
	Thu, 30 Oct 2025 19:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q0p8a6bX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6CE2ECE9F
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761851741; cv=none; b=sg7TeTUQMOLLc265vQ8aecKYRXPfLu7A9oR1Ck290KJ8oGvWHLdkHJoLTlM4NIQU16A57Ae/ImYwR4BIxd3fpSIu3gvmaK71JjG1NujymEjGaDbrYKzng6kmZlxhpgshTEla96tQrvjDhzLd+ipOwpnJDmoNOJoQCK15y7wWB2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761851741; c=relaxed/simple;
	bh=njD7vVo3RY8sZ4uT4oO36OjUKcILGJX+/8k/St9xxG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OsMiqnBg/ErQ5/VsRLkE2Ks9tGb1qqBkkHPPpIBPz4/e7mBpGJwJHeQoKEFJOBoGZyvfLJup06Nbd0MDQgqkqmNyodpc53BLJ/iAKz49Y4BW0aV07nleVA7xo7HbYSPtTmegW/h5PLqO/sZkXxHZuyiMAW6HAR19QeAynMYAjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q0p8a6bX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290cd61855eso14947745ad.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761851738; x=1762456538; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FNqfEfJoqSYUvF/W9hXgR/MQkgj3qF/GVzyQVpyWACQ=;
        b=Q0p8a6bX6FhCDfnRiY+kedgbEYtJoMDcd5rTgLIPOUO8GIzgV62l4O/v1YN7HAiNr0
         FjqqLR524t6rCgPBM1uaRYsXo5QGxfMrthq87BcmMklmxPAgORCUCLbwkoNVFkNZEV/7
         S+ME7ugHnm2910Xnt8WCFnyfkyjVPalZASDfxsfNPkj/AWzdXaxNo+OwQklH+X4bohMf
         rbKwGjbatc0vYevb2SspE/+QEwsYmFoY64YO66nWMUuH94C9BZVHnxrQSlnvMOBfHQVj
         WGmuTKgd2q7cL2orj2r7znJ+HnngeO+E5vFs0B777F/plIKTsPd+O5UagXAXLcmCfee/
         qdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761851738; x=1762456538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNqfEfJoqSYUvF/W9hXgR/MQkgj3qF/GVzyQVpyWACQ=;
        b=BSem7c2FO0S7Pmr9fvPk43vBInBVtOsnato0hbRW+g3O8x92NYc+fhreGZilQfRHTv
         vtQgeVhOfTCIcWOFBmgcY90OvTh+65Bc1xqDt1bJLkNI7p0MKUD+qt+FFtxawUOy5Ja3
         YM6JLXITSXvYiMqEJSb86iazqUHyQ+0aDwDJSZovYV0JvIPVmo83QayyiryGRgohmvqC
         5AhaDWyI9JTm5oSgeL/PRQJgewA8tw+oHkWg+e3alP19Mxu/lJDjA6OeXpTGjFIjrzk8
         DnHU2t/eUPFmAMNEmAdmu0Ua0CDkjP3rr3xuUNsGFVO/K0MV7HKiSLTdwKaeAyiJJvTt
         RmwA==
X-Gm-Message-State: AOJu0YzRz0Q0hFcU7Gq10Qm53B+pkojzuIdUlORJD81QB6Bu/o4FR6N0
	IoSV5VtLuKC2SxKJcyThBFbZbkPp+AXQOX7VtdhS3l3ZUg+bQDHhgMxd/JpAMajTUFH6k8W1POd
	VkeK7Qg==
X-Google-Smtp-Source: AGHT+IFBdKayTTHDRLc1XeLTBMS4cU/1mdOhxtVsleqZOp+VTYxxaZOIKtrD0iyEKzZHky8RcgnIOTS6Ng8=
X-Received: from plch11.prod.google.com ([2002:a17:902:f2cb:b0:290:be3d:aff6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3202:b0:294:b758:76b2
 with SMTP id d9443c01a7336-2951a58890cmr12319815ad.43.1761851737922; Thu, 30
 Oct 2025 12:15:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 12:15:27 -0700
In-Reply-To: <20251030191528.3380553-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030191528.3380553-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030191528.3380553-4-seanjc@google.com>
Subject: [PATCH v5 3/4] KVM: x86: Leave user-return notifier registered on reboot/shutdown
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Leave KVM's user-return notifier registered in the unlikely case that the
notifier is registered when disabling virtualization via IPI callback in
response to reboot/shutdown.  On reboot/shutdown, keeping the notifier
registered is ok as far as MSR state is concerned (arguably better then
restoring MSRs at an unknown point in time), as the callback will run
cleanly and restore host MSRs if the CPU manages to return to userspace
before the system goes down.

The only wrinkle is that if kvm.ko module unload manages to race with
reboot/shutdown, then leaving the notifier registered could lead to
use-after-free due to calling into unloaded kvm.ko module code.  But such
a race is only possible on --forced reboot/shutdown, because otherwise
userspace tasks would be frozen before kvm_shutdown() is called, i.e. on a
"normal" reboot/shutdown, it should be impossible for the CPU to return to
userspace after kvm_shutdown().

Furthermore, on a --forced reboot/shutdown, unregistering the user-return
hook from IRQ context doesn't fully guard against use-after-free, because
KVM could immediately re-register the hook, e.g. if the IRQ arrives before
kvm_user_return_register_notifier() is called.

Rather than trying to guard against the IPI in the "normal" user-return
code, which is difficult and noisy, simply leave the user-return notifier
registered on a reboot, and bump the kvm.ko module refcount to defend
against a use-after-free due to kvm.ko unload racing against reboot.

Alternatively, KVM could allow kvm.ko and try to drop the notifiers during
kvm_x86_exit(), but that's also a can of worms as registration is per-CPU,
and so KVM would need to blast an IPI, and doing so while a reboot/shutdown
is in-progress is far risky than preventing userspace from unloading KVM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb7a7515f280..c927326344b1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13086,7 +13086,21 @@ int kvm_arch_enable_virtualization_cpu(void)
 void kvm_arch_disable_virtualization_cpu(void)
 {
 	kvm_x86_call(disable_virtualization_cpu)();
-	drop_user_return_notifiers();
+
+	/*
+	 * Leave the user-return notifiers as-is when disabling virtualization
+	 * for reboot, i.e. when disabling via IPI function call, and instead
+	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
+	 * the *very* unlikely scenario module unload is racing with reboot).
+	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
+	 * could be actively modifying user-return MSR state when the IPI to
+	 * disable virtualization arrives.  Handle the extreme edge case here
+	 * instead of trying to account for it in the normal flows.
+	 */
+	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
+		drop_user_return_notifiers();
+	else
+		__module_get(THIS_MODULE);
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.51.1.930.gacf6e81ea2-goog


