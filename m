Return-Path: <kvm+bounces-73341-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHthNcgIr2loMAIAu9opvQ
	(envelope-from <kvm+bounces-73341-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:52:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 546D123DFA3
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 239E53017390
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A0C52DB79E;
	Mon,  9 Mar 2026 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="um8qLWSH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEEC2E0925
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078596; cv=none; b=drDfLoEUFA9T3viVDME1MTEiwELl52qxsVkVJARgWjuQK0s59cvgD90x/z7WR7WDRHYIKvjfyL+TohXxPz3e7JdMReEukEJlADHcHVLo09FQCPoCxwBe/4VurwcTHGgf6BMSsS7xgD8gyLNbUPvGv8z9EbpEVVfzUYwKLjaboQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078596; c=relaxed/simple;
	bh=JcX8XZ2Smd0s6hZqk5oHDPtPYApdQEAiR/MbBFVjEkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjaQSlNiB0lJo3O0b93V6b1GUqtDbhlOCjH94GZYJSpyeVnx5+V3HxSxDPXM0BO43gOy61bMfLgX0irX4m6JAl48uzAEYE+NZHTqP0BsGmjIknaUB/NlA74RjyRE8OnLVJYxB7lotd7X87N6z0zkdZRj12OFdUoOYik1YBXsCmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=um8qLWSH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so11942265e9.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 10:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773078592; x=1773683392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfOU74AZsB0BJ+9t5I5qi8V7Be00GDq0IJGiovLZCOM=;
        b=um8qLWSH46RLLoRPo0OBv/LyGJkKVui2eFuqIGnxA7taRm5WQG9+WX4S6vxN0NtOnO
         l6RvcvAK37vfoNRamvnD7chaw0sYFRo2BA50WWuV02QHViAKNxRlHsDpp66IBK9cd36W
         Rw9Dgtok+RQL8Kcv1JayHExOHK6uoOEHoadEuB8BkZ93/6HnhRIpFbnowOnL7JlwW0/W
         XjRroxb+31VPbQWSTtst5j6U4m7ZfcQ1795UDDpeG9p/RD97dvGNCusvEeXyowkbGvT+
         GwUMaBNPByVc94AauKqd1vCOwzQekCZ6kXe1wv0ParHBp0ktmsNux0BrGOw4mgSJDAK5
         f2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773078592; x=1773683392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FfOU74AZsB0BJ+9t5I5qi8V7Be00GDq0IJGiovLZCOM=;
        b=bHdAnf+Kw1dwJmXmZQVTV2GtW/ooXIPNg1uVSFMnwnoPJb9klRbpbYcYcIA7o6ebIW
         jxhvaEYPOshHxgfPLPQCLLtB483Je9SYmqh/JT+uNvGC33wD2pgOQAhjnTwSxxulTi+R
         /uJX1+qQPzTetTKs3osgVf9MYPnoNucG04RaWSy9mfFHNH7MOlkBllZ8pUnPpOn3NTOa
         crjXjr6QIgKC66w+UTk7+G6ONC6V60m6+PtLcT2oa6zpW/5fS/Q4EFSM4Ih9htTUdwdt
         j/0SPyS5NeBgnX8N0G6QtZfzXYu+VfwbmPPxfl7uWbHCdCG8+GiDj2Pr+JpyQWPyyIzT
         1Law==
X-Forwarded-Encrypted: i=1; AJvYcCX6vgtj5PNI33B5ADrqhIT66uQ/C/Wy7o9yRzy4BcIvDqal/mPtIvK/gLWd0JrVBVuXFiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUzoB3TeSUAT54yIz+eq9nNROn7YmS1JNN1ZzYLt+ZUwn5RG67
	+/68xmJh1wGu1VjoK954pVi9D2Oekly1RX1NnO5gOpAqLWSITrhoGO2+2UPZkuQy+a6Uli5KYV2
	IiU8t4/Y=
X-Gm-Gg: ATEYQzyPseaMUo/SrHeCuUEhzC1l51m8ZHqKFexuS8yUkKl3G6eTTpvv/PrzZPpl0Gw
	3m1rFOzpp1znwBoDVVyXREZIwm2INvmF1apYG9Zga1NlyFVoApOium6XCTgBwePicfMSatDqFwq
	ehp5nvEw+zNdeeaKbyb1oMV6LGCgSbJdNOQabobQcqe962TdpyNF1zUtUmVGRSGBWXas+OVWYVB
	My1yizKj7snhic76DjGtUTL2bLw8G4MNb7SqGCsx34K/UVfaMVdF96R/vmQyicCaIC+ARGdOiSK
	eigTQso4/rS4aa/EikkVU1RY4x4VbvrSE8nRn0i1fzbS+kQj/QZa1KjVl6rXGmaFTTcK/yHR/XS
	tp0v1r2bpZ8nRXARfrGOGZ6YAiHhsHECDQ3IoEZOKTq/J7lXyk7P5YnQ2WULxBH3BePS7Qj+zAl
	nG+7Fpf7ghSoWLH7AfmmbRs4zpg9Rl6UMcqahi1xvK9cy4LvZapuOYwh9VJd89r/aAb4QW1qJ7
X-Received: by 2002:a05:600c:8b01:b0:477:5ad9:6df1 with SMTP id 5b1f17b1804b1-4852691989bmr200833445e9.3.1773078592217;
        Mon, 09 Mar 2026 10:49:52 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541a6bbcesm7670835e9.3.2026.03.09.10.49.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Mar 2026 10:49:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 1/2] system/kvm: Make kvm_irqchip*notifier() declaration non target-specific
Date: Mon,  9 Mar 2026 18:49:40 +0100
Message-ID: <20260309174941.67624-2-philmd@linaro.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309174941.67624-1-philmd@linaro.org>
References: <20260309174941.67624-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 546D123DFA3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73341-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:dkim,linaro.org:email,linaro.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Commit 3607715a308 ("kvm: Introduce KVM irqchip change notifier")
restricted the kvm_irqchip*notifier() declarations to target-specific
files, guarding them under the NEED_CPU_H (later renamed as
COMPILING_PER_TARGET) #ifdef check.

This however prohibit building the kvm-stub.c file once:

  ../accel/stubs/kvm-stub.c:70:6: error: no previous prototype for function 'kvm_irqchip_add_change_notifier' [-Werror,-Wmissing-prototypes]
     70 | void kvm_irqchip_add_change_notifier(Notifier *n)
        |      ^
  ../accel/stubs/kvm-stub.c:74:6: error: no previous prototype for function 'kvm_irqchip_remove_change_notifier' [-Werror,-Wmissing-prototypes]
     74 | void kvm_irqchip_remove_change_notifier(Notifier *n)
        |      ^
  ../accel/stubs/kvm-stub.c:78:6: error: no previous prototype for function 'kvm_irqchip_change_notify' [-Werror,-Wmissing-prototypes]
     78 | void kvm_irqchip_change_notify(void)
        |      ^

Since nothing in these prototype declarations is target specific,
move them around to be generically available, allowing to build
kvm-stub.c once for all targets in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/kvm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 4b0e1b4ab14..5fa33eddda3 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -219,6 +219,10 @@ int kvm_vm_ioctl(KVMState *s, unsigned long type, ...);
 
 void kvm_flush_coalesced_mmio_buffer(void);
 
+void kvm_irqchip_add_change_notifier(Notifier *n);
+void kvm_irqchip_remove_change_notifier(Notifier *n);
+void kvm_irqchip_change_notify(void);
+
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
 
@@ -393,10 +397,6 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
 
 void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
 
-void kvm_irqchip_add_change_notifier(Notifier *n);
-void kvm_irqchip_remove_change_notifier(Notifier *n);
-void kvm_irqchip_change_notify(void);
-
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
-- 
2.53.0


