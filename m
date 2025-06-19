Return-Path: <kvm+bounces-49994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA99EAE0E1C
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 21:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA741C23271
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 19:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748A624677B;
	Thu, 19 Jun 2025 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="oQW1PalD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39F424397A
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750362137; cv=none; b=GJ5NqLnSZy+nOz014P9HbLQgKwmKsleM3+Ufi+IyIIvxOFsOMSkdSMgxuoM+sCP6ax+6XAtUzsu4OPA9b1CnA84hygAjN1h2O1F7Bbo29agGXbQ8R0ZBVwzttpRQQF73XGp321uZeQfqaC0xALmNrN+h7RJVIR+ypnX2mHVQb7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750362137; c=relaxed/simple;
	bh=nAC7QCez9UzKesMBsMBghSX0jVOewcPMytQlfsZmW98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lty2svITWjxQRePjOZwH1p8xHq96W1aSNSR0cZWZNNZgUw/RP3WKBjtQXbbp+w3Wq5AnK8nYac8JxBnTDJn/Lj3wqPA8i6tpnAn3fB02M5rLJdchMhsrGsltGueySPr2dbWtKmOOpr/fgGKN326O6l+QPklKSk9AuSU6CVWLRcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=oQW1PalD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450ce671a08so7105315e9.3
        for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 12:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750362133; x=1750966933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=945NnTgSwXk8exH8xblnViWPVG/bcKkjjf88tkCIGhw=;
        b=oQW1PalDkX+gZWVV6UFYZwLbMK01YI8JAU0Ggx89l7xd+QrrWZamFjsR7KK9Ljzwft
         Is66VG7jOc4ATgyD/pfKWCsHFL2hg+eJi3OnEK2phOsZsFqc8+vgcxTKU6iCsvnrbzEW
         WiyAgc4OOF8KB3OdCDI/Kqt7yyuxRdHsVhrttLbZB3M/WbO/wDDPP3Myaif4qd87V5Qf
         BglRdMFTlfk/9CMGoPR0Klj2KPNFcdVwco+1jWaZd2S8e0KsbEq45bkZd5iH+1Qz1T1z
         C0+gc6udegmY5EqzfMTyGjRxSRNRoY8PE/lFQEQu2nNMDgyXxGgdaQau9I7gWwig9u8r
         OI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750362133; x=1750966933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=945NnTgSwXk8exH8xblnViWPVG/bcKkjjf88tkCIGhw=;
        b=Q6/uByvpwtVuzXnsYPRO7leRhcbWCRjQ27rhDayxQk2nbHeG/LTnxijgTTR8OtcAwF
         /35EZSmZCEIf0k2NFelflMpc2Or90w3Qlkr3eQ0xUJgMxdAC1qqpgFY+JP1KETg43ylw
         F/+VTwPgcqOpJvOg6ot2wafe2kEPbIhk4tdPTACaqKK1thMY+ggIFzUPvuVdn9DFAACl
         sIhiV3BE130CYp+Nz+hbD3eQVnev2molrF1YKmDXxtEEDyvO2hIcUgdQLuWCeocR8RTF
         MGP7reDS/43dfDVptZvhXwT8qjOz3RG3x+Dz0RwkN6Io1xldMIe4D+NXmk0mr1qLFmH6
         J+UA==
X-Forwarded-Encrypted: i=1; AJvYcCXVE3Jzi1LfhGy3Ztao3iRDzNC0Zm2Cqv6LfmfAsBvOjOTIZ3kC2tNDNXkWmp8Up42G6/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfebgLgfUtbebo90NK7TutwPEcnPGIoXbzz79myiU8cL7J4pfT
	zAKThJY+4VhpiKQSAAcA+SJAe0KigJBXLRMql9kAQ8Tu713CVcXikikOMaVpZVtnA2g=
X-Gm-Gg: ASbGncsHZnm8UMmnpzG50VjgmFZMCRThZB/KcxyNTLTbPyr4A4boNyiBl73F9rxkvqB
	GeS2x6KOZ3Ttp6H7aLALmogbu/2WE4oUiOZMIb8Ic18A6zCya+cjUjy1RBqV2E7RoacQrMEUQxK
	QhBLG1snRkmO8VsRXo0+tYuFsm4vGEfK1HVDgQCaCNyL5K9WWFxDu49iYkNOkC+7mZzLUhCwZXP
	L2CzlIVS7Qnk+5yruHnldcbMb9Rtj/09r1qyIlleedqjE9m3wUBAD7hW+BcUfHhHZaM8CXMx6dz
	Wuz+Ri8qnqwbVDgdzKxQvleleVs1/3c1vYCxjiwAAn8UjQWCbEjbHV4iuptgRDma1s79sH/r1qr
	Xc1+bry6MDuvpV5A7cODmCNml
X-Google-Smtp-Source: AGHT+IHTAR6ym8+0N/znfKC/8eb8jAIn387bUFaki0aVeXz/KhH5M+vSXjXJITq5Zjx874uSSn9Wag==
X-Received: by 2002:a05:600c:138e:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-453653b02c3mr835865e9.10.1750362132733;
        Thu, 19 Jun 2025 12:42:12 -0700 (PDT)
Received: from bell.fritz.box (pd9ed7163.dip0.t-ipconnect.de. [217.237.113.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45364708297sm3336525e9.35.2025.06.19.12.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:42:12 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH] i386/kvm: Disable hypercall patching quirk by default
Date: Thu, 19 Jun 2025 21:42:04 +0200
Message-Id: <20250619194204.1089048-1-minipli@grsecurity.net>
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
 include/system/kvm_int.h |  1 +
 qemu-options.hx          | 10 ++++++++++
 target/i386/kvm/kvm.c    | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
index 756a3c0a250e..fd7129824429 100644
--- a/include/system/kvm_int.h
+++ b/include/system/kvm_int.h
@@ -159,6 +159,7 @@ struct KVMState
     uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     struct KVMMsrEnergy msr_energy;
+    bool hypercall_patching_enabled;
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
index 56a6b9b6381a..6f5f3b95e553 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3224,6 +3224,19 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
     return 0;
 }
 
+static int kvm_vm_disable_hypercall_patching(KVMState *s)
+{
+    int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
+
+    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
+        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
+                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
+    }
+
+    warn_report("kvm: disabling hypercall patching not supported");
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret;
@@ -3363,6 +3376,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (s->hypercall_patching_enabled == false) {
+        if (kvm_vm_disable_hypercall_patching(s)) {
+            warn_report("kvm: failed to disable hypercall patching quirk");
+        }
+    }
+
     return 0;
 }
 
@@ -6456,6 +6475,19 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
     }
 }
 
+static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    return s->hypercall_patching_enabled;
+}
+
+static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
+                                            Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    s->hypercall_patching_enabled = value;
+}
+
 static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
 {
     KVMState *s = KVM_STATE(obj);
@@ -6589,6 +6621,12 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
 
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


