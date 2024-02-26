Return-Path: <kvm+bounces-9922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C284867940
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 322BA295116
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3F7E148FEB;
	Mon, 26 Feb 2024 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuyAH+HW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779E12F386;
	Mon, 26 Feb 2024 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958315; cv=none; b=A8xUPNp6Gw3RcQd2vcnxbneM2Sav0Qu8uQ9L4d2YSBukZVthBzIUWJfxt9xE+NE8EHZmeRGm5fZZ9TeO88XsUteTSMkGQhy1NnPTpQxQF4DZ/V5TMCxn7GPVpNQlQeNX2L51baBau6/sjfqjXF9ef1DxOEwEo0RqiLPjMZI8ZYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958315; c=relaxed/simple;
	bh=f3SxkjdDBsEA/7OShaAvc2oYo2+utzf+LAhffkTk31g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEmzPMARa9SLdBsqEQ34mS0rknNHU5XsCCH8ff0Bi5Dpejc0KnFDhSmv9kQTUlGMdKGSlqS8+JIU7kcosjv0Vlbe35TvRRHzdI4t1HxhJlMOfVXZjazfLzpfb+9di8MMVv/hsbrVI+xGglB/dKIZDO3E57pZDX7wYhQBgiumCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fuyAH+HW; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dc0d11d1b7so23381665ad.2;
        Mon, 26 Feb 2024 06:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958313; x=1709563113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eg6g7/q1WqY94yjHZb1HQwZnqsOWQYMcwxgHt4yt/Ww=;
        b=fuyAH+HWtp7wu2CQSInR70lp3dFidiDVa1X8iA26Z6d/cdgJE02sanUG8qDrS9E1Ox
         K3RQvpaCTAWrVJ7Rdc+ZwyBDos/ev4JAKzuwCiM5KMSByopqpt3Ei6NMQyIb8iFyvj8j
         plvEYeqP7UqKsEOJdUZ+1MDD9NWP3qyza8oQO07RchgBTEZMXWlV1lSS8WuRr35GDgeE
         Ao95+RACnQOHLDbnWEcux6JWyapzJ1UVhp+GhTEEtX8ZtzHFE+eZZuyUAUhDDZIdTTEc
         6+BcCkhX72viu6+9PzkiuxPdfXjv3S2fr+nkVZPRSgbNzi0ydNS4mq/1gDC2VTuaQzdk
         2E1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958313; x=1709563113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eg6g7/q1WqY94yjHZb1HQwZnqsOWQYMcwxgHt4yt/Ww=;
        b=mMSxFq7q3zuNKmD6gJZGwyn4eRR4ueh/hijoa787pPCVQ8T6iqp6U8fk/bsxFVSxa3
         h6wxFdCsgzqFpLmCW6pIDby6JOzW6wv7kj9VCGMdVEfs93EDjG8RJrVM3JDD0p6bE9oa
         JsoInYqITugyFcp2MdPl9k/vxVkqRKcGqn8hx71ISds0TFHWtAN43t5gclUuDhbGXtH6
         hZFX/DtRrIBpB2E7O4mDa8Lk3yTAiut63z8ERdTAnhwEfiYV8MQyJrfFYrfo8Nzhlj+d
         WqD+AT2RhBencl3/EVkOup9FIZI4wymxEpq9dWzWzwCx9xMzPT96kWtIq+MEDoxaLAcG
         n4MA==
X-Forwarded-Encrypted: i=1; AJvYcCXUaIhGbUlzTBwyzqXibnuQyi9pGTwT9OjEDTYzbCRhD8AsRK+m7xDMfLBJK834zAtKFKrZxW58hXiQ4BxHwjUvWK1o
X-Gm-Message-State: AOJu0YwchWc4ZpbeqkD6U1fBwY7XbN7ZDYPVFw6MGKi/5XqNZKousWP8
	1ZtukFy1FQ0xJiORRTzphl3R0S835uVeQ46mkrTN3AXahopvXXHyzQZVJxF2
X-Google-Smtp-Source: AGHT+IESs4IqMOf+bMbVqFmjKod4bE6Q3FmhBANJYEYxQVumFhX4wlNGB2w/aW8KteFd5/EKzLullw==
X-Received: by 2002:a17:902:ccc4:b0:1dc:b16c:63fa with SMTP id z4-20020a170902ccc400b001dcb16c63famr999109ple.4.1708958312979;
        Mon, 26 Feb 2024 06:38:32 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902dcc500b001dc6b99af70sm4013399pll.108.2024.02.26.06.38.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:32 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: [RFC PATCH 59/73] x86/pti: Force enabling KPTI for PVM guest
Date: Mon, 26 Feb 2024 22:36:16 +0800
Message-Id: <20240226143630.33643-60-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

For PVM, it needs the guest to provides two different
page tables directly to prevent usermode access to the kernel
address space. So force enabling KPTI for PVM guest.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/Kconfig  | 1 +
 arch/x86/mm/pti.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded687cc23ad..32a2ab49752b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -854,6 +854,7 @@ config KVM_GUEST
 config PVM_GUEST
 	bool "PVM Guest support"
 	depends on X86_64 && KVM_GUEST && X86_PIE && !KASAN
+	select PAGE_TABLE_ISOLATION
 	select RANDOMIZE_MEMORY
 	select RELOCATABLE_UNCOMPRESSED_KERNEL
 	default n
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index 5dd733944629..3b06faeca569 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -84,6 +84,13 @@ void __init pti_check_boottime_disable(void)
 		return;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_KVM_PVM_GUEST)) {
+		pti_mode = PTI_FORCE_ON;
+		pti_print_if_insecure("force enabled on kvm pvm guest.");
+		setup_force_cpu_cap(X86_FEATURE_PTI);
+		return;
+	}
+
 	if (cpu_mitigations_off())
 		pti_mode = PTI_FORCE_OFF;
 	if (pti_mode == PTI_FORCE_OFF) {
-- 
2.19.1.6.gb485710b


