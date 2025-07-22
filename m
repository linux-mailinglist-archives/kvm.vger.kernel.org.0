Return-Path: <kvm+bounces-53171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C030CB0E50D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 22:43:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5F30171207
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 20:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2884B2853E3;
	Tue, 22 Jul 2025 20:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="JguQxq4R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE84C92
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753217006; cv=none; b=CmRHg1lxcfmX+5BkpHdxfKWPhh+ZVJsKwy8wJkFmZE0aR5G5GbA+1hcgmiAkppSlSfB19ILrII5DwC3MyKmTbxBOUDNFura8jQ6f1L4SRCIDV//9MpgD/zdfQrk8jlyDh0KXTvw2afjcTyNmaJ3zmfCDtW6iBHp+ioz6xCmiNdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753217006; c=relaxed/simple;
	bh=dR69M6RFmxMNfCf5ff+UGk2gTqDX0J0RNtHqX1ALZeo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ICkktt5FkjekQZwFogHIKPDu0/GEEALv13aYeTR+Y964yZnBgmp1tKqeNSVAimv+mQ4eck0xlctlrkWv71Tvsc0yo8ILmJ6yfu1vq6/4wTEVBH7MusT42bg73GGl1FI/zKU3UEYt7hlO9x9+0YmUBvJfYbbogAhaFjxzHnGOEa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=JguQxq4R; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-75b5be236deso2592655b3a.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 13:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753217004; x=1753821804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qadej4QY2us4blDeUWRkAww3V47laEeGj9PB4dLSeh0=;
        b=JguQxq4RUpsjHHnJ6yu9IDPpZVc04Ac8Gh7ICoEJwyWU1Qn0S9fCUvD3SDXoHr9WVz
         zivXGJJOA5PRyg/LiAsKTxRIw5Gizb6bBFm7OR4tffcaNvNNgJpZPh6sS9iZyTD7IVq9
         OgfvqPunUpEhXvKJKdfN8QLM62S50/LQj0KahZUD7/3UrIOqjd/pjKE/3Qs9KK4DR5mU
         ryRP0ux4gz53EBuns+Cp5Bw8wXwsWHmJC3BVQIK6flRfyIkzQvayTULXZ67joZDna3bn
         P0AUsEPtLY8tLl5UJ4NIh9nLKesv+Ef45alpxAqUFxMpVcigU8ozm+vtPkqxTQgCHVYG
         rThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753217004; x=1753821804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qadej4QY2us4blDeUWRkAww3V47laEeGj9PB4dLSeh0=;
        b=GJ3h8Z3deaJ5dv4HqAuI7ewrS5YP7EeOzsijrD83SY1Y3DhC8JHMeacD/FXq2CuASP
         PRisZwcN0yC7/InrTC0wRGoDhekXzyGGL/RjoCYtiw7fK2Zf45c76Njs0UpLbnytKne/
         BQZjq75lFcUq6fIGwLsVt9Yl9FDA2N1hKCnNI+ntsCmSClzxb+mVit/GRnK33dQSbjD0
         gUtasa4F6v0zS75TQBLqtOnVgk1gywICIGBGVBUXf98THIddhqses4xpSpBhjheiY2BC
         57Fql2AKalvo0B6c/mW1VIoNq6mBL/9GgDL9YqsmeicJaRtieHHymAYXZYCLOu2hXXzI
         xBSw==
X-Forwarded-Encrypted: i=1; AJvYcCXwBtNTlYuJJn0h2N7He1cSnGRGuRPfKIpo/vqSoGwkX3gVedI2hEGdfUoBBFB7U0+5MdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsBfkl4ZUIbWZBoCnP7PCglioA9ckvGliLM1WMMrrT2v4MC6tZ
	ZfiwtzX34cjHZH5vtfqLfPH9BC0m0I3CpOykAE/x328u5bUc4SYLMMfNCyZNwBK8aB8=
X-Gm-Gg: ASbGncvdzmPILpGJ0rJTNd3kJT8knC6q2/TfJhFpC0ym4eharLtkee6dqTQfBRINSV+
	p60KFMuYI/xNnE/o2BhFLuEB8zafFSpNsch9JfvxdJN3TceRxx4Z+eBK0Bem5+LmbjwRLgd5htY
	YvujGd7YeGuSbHafkfoZwtCvmrE+duN/0TMbt++gj/IWzx61IAdnLECXJsRTCn20MajXmj9p6f9
	GQ8YzuZo1ekwhm2GmbPY0FNtcfLge35eHSeoWEwytFjP4ZmvOTg+vo71GZOR66K+rfHFgMll4Hj
	08e3baOrejTwB3SjT9q+kmFd+yg2wjqxa64nvuaKwWHChUelr8oHPEID52snO9MeK/pmngRHamq
	piIWQ7/kFzGar1XYgTqbAB7L4wl3scA8Or1XnggO0U8EkqJPZt89i8NY5LjLlmy3L9HO7GOChnn
	beHs9xZa15x3E0TFW4
X-Google-Smtp-Source: AGHT+IFkWBL534QSLuTIv4Nb9qWHjfDwAD6Y4PnF27h+JcuE493sdh+DTbAtxHhMxMbFXqdxcs0Nug==
X-Received: by 2002:a05:6a20:3d1d:b0:238:3f64:41a5 with SMTP id adf61e73a8af0-23d491f9161mr393893637.45.1753217003651;
        Tue, 22 Jul 2025 13:43:23 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759cbc680absm8313006b3a.144.2025.07.22.13.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 13:43:23 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] i386/kvm: Disable hypercall patching quirk by default
Date: Tue, 22 Jul 2025 22:43:16 +0200
Message-Id: <20250722204316.1186096-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM has a weird behaviour when a guest executes VMCALL on an AMD system
or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
exception (#UD) as they are just the wrong instruction for the CPU
given. But instead of forwarding the exception to the guest, KVM tries
to patch the guest instruction to match the host's actual hypercall
instruction. That is doomed to fail as read-only code is rather the
standard these days. But, instead of letting go the patching attempt and
falling back to #UD injection, KVM injects the page fault instead.

That's wrong on multiple levels. Not only isn't that a valid exception
to be generated by these instructions, confusing attempts to handle
them. It also destroys guest state by doing so, namely the value of CR2.

Sean attempted to fix that in KVM[1] but the patch was never applied.

Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
conceptually be disabled. Paolo even called out to add this very
functionality to disable the quirk in QEMU[3]. So lets just do it.

A new property 'hypercall-patching=on|off' is added, for the very
unlikely case that there are setups that really need the patching.
However, these would be vulnerable to memory corruption attacks freely
overwriting code as they please. So, my guess is, there are exactly 0
systems out there requiring this quirk.

[1] https://lore.kernel.org/kvm/20211210222903.3417968-1-seanjc@google.com/
[2] https://lore.kernel.org/kvm/20220316005538.2282772-2-oupton@google.com/
[3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com/

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- rename hypercall_patching_enabled to hypercall_patching (Xiaoyao Li)
- make use of error_setg*() (Xiaoyao Li)

 include/system/kvm_int.h |  1 +
 qemu-options.hx          | 10 +++++++++
 target/i386/kvm/kvm.c    | 45 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 756a3c0a250e..c909464c74a2 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -159,6 +159,7 @@ struct KVMState
     uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     struct KVMMsrEnergy msr_energy;
+    bool hypercall_patching;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
     uint32_t xen_version;
diff --git a/qemu-options.hx b/qemu-options.hx
index 1f862b19a676..c2e232649c19 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -231,6 +231,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
+    "                hypercall-patching=on|off (enable KVM's VMCALL/VMMCALL hypercall patching quirk, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n"
     "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
 SRST
@@ -313,6 +314,15 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``hypercall-patching=on|off``
+        KVM tries to recover from the wrong hypercall instruction being used by
+        a guest by attempting to rewrite it to the one supported natively by
+        the host CPU (VMCALL on Intel, VMMCALL for AMD systems). However, this
+        patching may fail if the guest memory is write protected, leading to a
+        page fault getting propagated to the guest instead of an illegal
+        instruction exception. As this may confuse guests, it gets disabled by
+        default (x86 only).
+
     ``device=path``
         Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
         option can be used to pass the KVM device to use via a file descriptor
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 56a6b9b6381a..55f744956970 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3224,6 +3224,26 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+static int kvm_vm_disable_hypercall_patching(KVMState *s, Error **errp)
+{
+    int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
+    int ret = -1;
+
+    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
+                                KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
+        if (ret) {
+            error_setg_errno(errp, -ret, "kvm: failed to disable "
+                             "hypercall patching quirk: %s",
+                             strerror(-ret));
+        }
+    } else {
+        error_setg(errp, "kvm: disabling hypercall patching not supported");
+    }
+
+    return ret;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
@@ -3363,6 +3383,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (s->hypercall_patching == false) {
+        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
+            error_report_err(local_err);
+        }
+    }
+
     return 0;
 }
 
@@ -6456,6 +6482,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
     }
 }
 
+static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    return s->hypercall_patching;
+}
+
+static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
+                                            Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    s->hypercall_patching = value;
+}
+
 static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
 {
     KVMState *s = KVM_STATE(obj);
@@ -6589,6 +6628,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
 
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
+    object_class_property_add_bool(oc, "hypercall-patching",
+                                   kvm_arch_get_hypercall_patching,
+                                   kvm_arch_set_hypercall_patching);
+    object_class_property_set_description(oc, "hypercall-patching",
+                                          "Enable hypercall patching quirk");
+
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
                                    &NotifyVmexitOption_lookup,
                                    kvm_arch_get_notify_vmexit,
-- 
2.30.2


