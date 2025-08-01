Return-Path: <kvm+bounces-53835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA39B18231
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:12:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 562A8621CBF
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3055B248F61;
	Fri,  1 Aug 2025 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="uxgiSGhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DDF22069E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 13:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754053959; cv=none; b=QZYPFvOYhkEpzycPwmele8ZzNZ520qXWJzG1jpr1GoF6rXloTkBsqVeEZ5yRWtisKQ5v6/W9LHZRenI/uDCTLHwdzoMZTWP++LpL3hZe0a1mTZ3ufY2bKCdDEt7UdRwSLTvg70U31n9H1zf/DT7GTkoiMDwf3IlfqSntxxoFtuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754053959; c=relaxed/simple;
	bh=TC1rMiVJgWvePH17F3ge3obVFOlkxp5gBEdkzNXbX70=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cGgmHkjct5ogUVFgB9tODqYvwVYDDbKLRpA+gO0QZxibFG/lsq6DtfS66gX7FtsF/pIUORz+rNvkkRmNel9DR1qNoH74jNBgCJmWN1BjnuMdDw5WS+yZQFy9yW4JAxgTgaXlwAhFYfc4aHdiIC/S7KuJLkKDYpp/IZZpyxT6Ir0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=uxgiSGhd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45617887276so5494175e9.2
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 06:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1754053954; x=1754658754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QZFBl3XMjqJs9ITIs0pTTYPqn0HayVowzZGxu1QTQLM=;
        b=uxgiSGhdYXDkZs7QxcHCIYZpxnstyQEZxnGF3VVjMkCn0TLKrFa1/a2KBTuO52Xkb7
         lubkck8gAiiEJA/G+TaKEwMF8GAKSmgLBjPJGkelgrQ2fAR4F9UXlkDyDIzrl/lteuIV
         CBLuI6SxPJmE1TzYP5P6qYkb1yH0xYoG66bZjMeYyG9MMdp72GJ6S3/Ob4l0K263ayQR
         gjkSYlh65o9CJgMuGBoLDixZmXZmY2v+zPSiDWR4U1cavM/qgw82lUo/55SpSf2qFJob
         B2HURqC4TZTQ7JBdZpWyM/QDM3t+AEjlkvtfFWw7ymRzHM4+UN1HpOWXve4s9z38vUin
         wPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754053954; x=1754658754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZFBl3XMjqJs9ITIs0pTTYPqn0HayVowzZGxu1QTQLM=;
        b=Oi2kLxv3kCQhCL6LmKxb2QsYCsMu1DedFaI3MPOaEhftFq/nKm5vCBM0bnQIB53fqP
         U2mcxdSY2THY3zFosLuzFPbeRIVObUtwBCyyz2s58AkXOAOE04f1EanyqryqOxFPgpOk
         hydsXbELb53++4CdEv5dvnOS0JMd9D4wuAYELVQxIFfOyDerHrGufC9dbeXBREEeNDNT
         sB3uaCP55D7ZWFrasP02HrfHTpkJA33Suv1dIEvz31ioNqwNA2mfjm+7nc53x/+sglLA
         Todv+MboUeOTDpVi6NxBTSza2yCT3UdDMde9Bs5VMHU5K4LH0D2V9oYh3X3DwarNS/FR
         H4/g==
X-Forwarded-Encrypted: i=1; AJvYcCUDnKAbCcZEiefo/yMr2dWoo8eNEjhoBhtt8dWJn01w28apSDfkLrBQdOBcSSZvDZJN8ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaKKwmVWtAWRIeLaTk3yGI3avc87nLXBXDcDGZrwZrOs9a3kRz
	P6/CVQgvNA5kCuZQ4PBG1Sbq9T+HXZ8jEF8loPOFvjXOfDiRwUMzIt0X1jm32PTYbl8=
X-Gm-Gg: ASbGncuH5emLWm78c8E/xXhJV0U8IZk6BMsMVCRyPkilgjNhuF5SY20hTyffnHR2UXJ
	jUXJx4pKqJDhzdScpEnT5CC/B04HCRE4tUUqWxRVXBopXKrQFqwF4Uf7K0isYA6ariwW/5RocLM
	92Jae5/hYFU0978190rBZEGFyB94XYJIxtDYhuVPtUSL8+Dv8LTusmtvvNZfb0Vpgs+ScIGk/LD
	fabhgV4NjkjcvJvbNybKMc48ikVi6pPzHz0+NISEzfkYr15R6YsSZOFxmeZEkl9Xu6heMDxoKjO
	7FSXkc0tLMbt5elJbwpgujuEdTOCMaPSc6VxVsV1T/3SY20NY0SH2A8dCxG3arI2KJA6fa57vyV
	DfmTljyzMVz+f4MZcJ4MDe9GjFbvQYAHSAnMVrKqHRXTt4XYiXWHGVDodfJwN2RW9OL4bNur3gN
	wH3Ynu37wU1CneygmNUU/CzczCw/E=
X-Google-Smtp-Source: AGHT+IGF6VUXkzxD7jTuxQEPCnB97q/5xT9nU/mIsWmCe9cFXTD3T+xOCGKrQdXxLGO2MM7wP3o9Aw==
X-Received: by 2002:a05:600c:3ba3:b0:456:1abd:fcfc with SMTP id 5b1f17b1804b1-45893943cc5mr81413845e9.25.1754053953969;
        Fri, 01 Aug 2025 06:12:33 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b0a55c92sm6475175e9.4.2025.08.01.06.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:12:33 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3] i386/kvm: Provide knob to disable hypercall patching quirk
Date: Fri,  1 Aug 2025 15:12:26 +0200
Message-Id: <20250801131226.2729893-1-minipli@grsecurity.net>
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
instruction. That is doomed to fail for regular operating systems, as
read-only code is rather the standard these days. But, instead of
letting go the patching attempt and falling back to #UD injection, KVM
propagates its failure and injects the page fault instead.

That's wrong on multiple levels. Not only isn't that a valid exception
to be generated by these instructions, confusing attempts to handle
them. It also destroys guest state by doing so, namely the value of CR2.

Sean attempted to fix that in KVM[1] but the patch was never applied.

Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
conceptually be disabled. Paolo even called out to add this very
functionality to disable the quirk in QEMU[3]. So lets just do it.

Add a new property 'hypercall-patching=on|off' to the KVM accelerator
but keep the default behaviour as-is as there are, unfortunately,
systems out there relying on the patching, e.g. KUT[4,5].

For regular operating systems, however, the patching wouldn't be needed,
nor work at all. If it would, these systrems would be vulnerable to
memory corruption attacks, freely overwriting kernel code as they
please.

[1] https://lore.kernel.org/kvm/20211210222903.3417968-1-seanjc@google.com/
[2] https://lore.kernel.org/kvm/20220316005538.2282772-2-oupton@google.com/
[3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com/
[4] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/f045ea5627a3/x86/apic.c#L644
[5] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/f045ea5627a3/x86/vmexit.c#L36

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
Xiaoyao, I left out your Tested-by and Reviewed-by as I changed the code
(slightly) and it didn't felt right to pick these up. However, as only
the default value changed, the functionality would be the same if you
tested both cases explicitly (-accel kvm,hypercall-patching={on,off}).

v3:
- switch default to 'on' to not change the default behaviour
- reference KUT tests relying on hypercall patching

v2:
- rename hypercall_patching_enabled to hypercall_patching (Xiaoyao Li)
- make use of error_setg*() (Xiaoyao Li)

 accel/kvm/kvm-all.c      |  1 +
 include/system/kvm_int.h |  1 +
 qemu-options.hx          | 10 +++++++++
 target/i386/kvm/kvm.c    | 45 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 890d5ea9f865..a68f779b6c1c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3997,6 +3997,7 @@ static void kvm_accel_instance_init(Object *obj)
     s->kvm_dirty_ring_size = 0;
     s->kvm_dirty_ring_with_bitmap = false;
     s->kvm_eager_split_size = 0;
+    s->hypercall_patching = true;
     s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
     s->notify_window = 0;
     s->xen_version = 0;
diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 9247493b0299..ec891ca8e302 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -160,6 +160,7 @@ struct KVMState
     uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     struct KVMMsrEnergy msr_energy;
+    bool hypercall_patching;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
     uint32_t xen_version;
diff --git a/qemu-options.hx b/qemu-options.hx
index ab23f14d2178..98af1a91e6e6 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -236,6 +236,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
     "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
+    "                hypercall-patching=on|off (disable KVM's VMCALL/VMMCALL hypercall patching quirk, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n"
     "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
 SRST
@@ -318,6 +319,15 @@ SRST
         open up for a specified of time (i.e. notify-window).
         Default: notify-vmexit=run,notify-window=0.
 
+    ``hypercall-patching=on|off``
+        KVM tries to recover from the wrong hypercall instruction being used by
+        a guest by attempting to rewrite it to the one supported natively by
+        the host CPU (VMCALL on Intel, VMMCALL for AMD systems). However, this
+        patching may fail if the guest memory is write protected, leading to a
+        page fault getting propagated to the guest instead of an illegal
+        instruction exception. As this may confuse guests, this option allows
+        disabling it (x86 only, enabled by default).
+
     ``device=path``
         Sets the path to the KVM device node. Defaults to ``/dev/kvm``. This
         option can be used to pass the KVM device to use via a file descriptor
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 369626f8c8d7..a841d53c240f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3228,6 +3228,26 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
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
@@ -3367,6 +3387,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (!s->hypercall_patching) {
+        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
+            error_report_err(local_err);
+        }
+    }
+
     return 0;
 }
 
@@ -6478,6 +6504,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
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
@@ -6611,6 +6650,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
 
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
+    object_class_property_add_bool(oc, "hypercall-patching",
+                                   kvm_arch_get_hypercall_patching,
+                                   kvm_arch_set_hypercall_patching);
+    object_class_property_set_description(oc, "hypercall-patching",
+                                          "Disable hypercall patching quirk");
+
     object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
                                    &NotifyVmexitOption_lookup,
                                    kvm_arch_get_notify_vmexit,
-- 
2.30.2


