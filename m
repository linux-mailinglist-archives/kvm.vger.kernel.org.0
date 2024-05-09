Return-Path: <kvm+bounces-17105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A29E8C0D07
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 11:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0A11C20F51
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D2614A4DF;
	Thu,  9 May 2024 09:02:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C6212E1C4;
	Thu,  9 May 2024 09:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715245323; cv=none; b=cF5YRBFx1W8HHEcM1JnXkdFrmvhmRhR9OqcyeYO1zyoCWuWR0ONbM/y5HQUdvSBua6ihxCdIscBIqfnrU6GXu0POr8fmGCgzgvXN2ILF3ViSsdM1Ke8wZj5cz4q3odb584T9GEv3RuMkqZPPcpRngQsEgYd9xiM3vLQtwGhfSFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715245323; c=relaxed/simple;
	bh=GZat9LINhFY7HET0Bfu5/n99u2tVBTaKeJXrhTXoj84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RIwg1IgBH1BUTFU4LYBMzVmHS8xwmyJJomgM5XLJLbS0bHS4SNro7m2uSb+6UDAI4sgTYQXTw2/SbnYNOX3MtoqRfgl3Dgg66uD+Gr2aeFFHi7ZdTdA8tD7HK8xe0+POsfEs/jct5jfyD/p5dUfDZNnXuqmjg1x8g6C0LK5o6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59cf0bda27so76319666b.0;
        Thu, 09 May 2024 02:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715245320; x=1715850120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oi3yojxJ4xAGQp2FG233vt0UC3eonUyTb4YkLIyjxjs=;
        b=ft2ydMk5JUysektUjav+vUek8+vIZ5U4V6kZfRS+Xkm+yWsaFWLWib7Gsn7usPK84h
         +xkRCGhOxhTUyyR+XTyUk/NYoiOeaptmsZOQHKXMCJYIecWTr7yZ67g4iaG7bDX2MEQR
         UT3NhX3m9LeZ69zW4Js7BotFJ+I2pkcqWrLgoWseozFUP3CBpE4AXciKClk9yIyVy9cg
         MuKOrMnjzhTP2K2KxnVphv/s3bLAftEdM9a+Ufwe3B+Att4L5PI2Ia18bEPSpit2jRrI
         5GCAvRev40o5jQrTOfW1kJM7YieXxwhe873TgpkaWmA9jf6wpSy60TVvzk8Al7wvS2jU
         oAUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEXeCLUv/kpBxYFXlXBewsWDCaJ52htzcGyBwGtqVTNXP5iiYKSH4uUVInfJYWaOyHJjM/2/qSsr1+c6PRJSKUXRWozgHak7JBcZuBK8aVqIxxSizT9CAz8an2/2Dyj++1
X-Gm-Message-State: AOJu0YzBVFA7vdkTeAl6mr+O+sMAZpNTBAk3B9a4DiyHCe4NgQ8Lu3Vf
	80g5vhy9izC1jYJzp7Y27uaL2GtpLcmcq4UAk2wrF5bv2cjN9e86
X-Google-Smtp-Source: AGHT+IG4oJw3MuRp847dXHlmTNFINDozRfgyJ8e2lLWZZJYAwbdZJ1OY0RijrHZsXTKvJ/WWawo7Ag==
X-Received: by 2002:a50:d58b:0:b0:572:3f41:25aa with SMTP id 4fb4d7f45d1cf-5731d9b5f29mr4693125a12.11.1715245319838;
        Thu, 09 May 2024 02:01:59 -0700 (PDT)
Received: from localhost (fwdproxy-lla-000.fbsv.net. [2a03:2880:30ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733bea6704sm486670a12.3.2024.05.09.02.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 02:01:59 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: rbc@meta.com,
	paulmck@kernel.org,
	kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] KVM: Addressing a possible race in kvm_vcpu_on_spin:
Date: Thu,  9 May 2024 02:01:46 -0700
Message-ID: <20240509090146.146153-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two workflow paths that access the same address
simultaneously, creating a potential data race in kvm_vcpu_on_spin. This
occurs when one workflow reads kvm->last_boosted_vcpu while another
parallel path writes to it.

KCSAN produces the following output when enabled.

	BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]

	write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
	kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
	handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
	vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
	vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
	kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
	kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
	__se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
	__x64_sys_ioctl (fs/ioctl.c:890)
	x64_sys_call (arch/x86/entry/syscall_64.c:33)
	do_syscall_64 (arch/x86/entry/common.c:?)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

	read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
	kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
	handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
	vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:? arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
	vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
	kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
	kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
	__se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
	__x64_sys_ioctl (fs/ioctl.c:890)
	x64_sys_call (arch/x86/entry/syscall_64.c:33)
	do_syscall_64 (arch/x86/entry/common.c:?)
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

	value changed: 0x00000012 -> 0x00000000

Given that both operations occur simultaneously without any locking
mechanisms in place, let's ensure atomicity to prevent possible data
corruption. We'll achieve this by employing READ_ONCE() for the reading
operation and WRITE_ONCE() for the writing operation.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff0a20565f90..9768307d5e6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4066,12 +4066,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	unsigned long i;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 
+	last_boosted_vcpu = READ_ONCE(me->kvm->last_boosted_vcpu);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -4109,7 +4110,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;
-- 
2.43.0


