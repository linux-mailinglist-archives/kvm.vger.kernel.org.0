Return-Path: <kvm+bounces-25907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A62B96C8BC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 22:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E95EF1F26C84
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 20:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23112155A26;
	Wed,  4 Sep 2024 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vPaamzDV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24F014901B
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 20:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482550; cv=none; b=ICJOsNfPeZ3LD03oJnRkZOa3kVTaAVlCCplHnmE1AiwUtJ8icQtekkD5Ej+oQVYFjdm850l/fNXe0Og/cEYRGtk5s+1UypKjimAj6Hr7Bq3SAX1O+gf2ciF3owHYH1yu/IZN9bj+2GvmvLNxtJpC9e/AFGY+i/Jb/vK5KYin+xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482550; c=relaxed/simple;
	bh=Bc+G/ABmIxicp+Ktu0Km0LfXC9Azpt75Q+13cZSyLUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=en2md0Gy+YVhMF20xarq+XqQzuiHjMIH6cZRsNpjkg0gWdAngxmXIN7gKC39n9YqCRFEfk7adeHZDzwmOgl4oJAtFyL1sD42z0/wBGWzuOql5jV8KXh3XVz5rSbrvQ4G5a/sMmc7a2j+JOdoz8D/FmZW5YdIljBU85Qi20awxU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vPaamzDV; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-82a22983440so762144039f.1
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725482548; x=1726087348; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=da1VGWoVEM0srL8pak+5iYqVi4U1+WdMmmo+Uby7jLQ=;
        b=vPaamzDVl/FS6cwnaPAcaNjuiNK3fJsynhx3EYdT7rSauKnJ2h4agkmHQKe3r/pJIy
         Evgg1ow/X/JozBF16HwHE6b2qL+kdWSykNQBpUgLew6BIr0K2nOWLC2cenoYkyVs9/SL
         8GaiAHZmsXlOyEh1WkA0Byqqc1ah1zq2MHfrHjbBkVp1IDYlAvdilOPNx5EH0A6l0Rsv
         ruHGnuRdi+9nN+8yPEH6mcGAK82zNGo6W43znVbef9RL+a9G9l9bH9kNwqYtScVR6EH6
         n6i9zYLtlQiuGBLCuLe32Bejp+QogIvUfLme7RmxGkolYUXzRoXr7mSXK1QAHsdZiXqO
         gwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725482548; x=1726087348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=da1VGWoVEM0srL8pak+5iYqVi4U1+WdMmmo+Uby7jLQ=;
        b=QPPllyZvqUldNX4WcVX/RSWfONcWgNmKWn9XWGjBtHf4/XDMvW7XkP1pYKqVAvLl8+
         YGg8/3tDH6qJ6z4m5+iRAqPSg6hmpDYI8CPuxvK1yI/vfCXoDGj5m6Fvx6Xoqmgb9VeM
         vWUNM9ZN/i0RSe4c6js8tIAgsTLHhdhX1URZ712M7nxMAd+8hzjp/Y3aS/JtF5YybtRl
         pmQ2t7KrhrfLdKRywjzQJDlMwErqRxumVJEfPL+9dPUeL8oyuVeQ3+ho1H9zHRbCis5R
         w9LBrQBSVWXVl9VpKeVC3dgmqoVSrvvg+1MtV4jx/Z8USZTflf3d8x/51vXQTj40J7wm
         o48g==
X-Gm-Message-State: AOJu0Yxe/6+t2QbTHw9JPkbULJq5W49BYD/MXkHOs9jUpSjTrH+GNIZP
	x/C3YBqlzjwXng81UaumqZ09oTcfDOwz9ehBFNKG9wbnSwhkzZhNWtSD0OKSAyc1RWx68mpCpKK
	lQnh1wniAYjuJ8PQJVDOaizFjP0Bhy37T5t3MxS+WZhWiJZTSTxr+BYspOWBCm1urJprn3i9cs9
	2dRb7P+G/74Clj+FlBEKKrg//pT3lUbT64NJD68rHm5eQVtmw6v9KCZCY=
X-Google-Smtp-Source: AGHT+IF5VwhfDwFkkz0RNP4hdicHfuNY6pJqQwTSSeUmfbLEP1/IRR0I2ApAClPpKugjZhskT8IDcbh94c8otLZ8KA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:2396:b0:4c0:9a05:44d0 with
 SMTP id 8926c6da1cb9f-4d017d7b001mr570237173.1.1725482547230; Wed, 04 Sep
 2024 13:42:27 -0700 (PDT)
Date: Wed,  4 Sep 2024 20:41:29 +0000
In-Reply-To: <20240904204133.1442132-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904204133.1442132-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240904204133.1442132-2-coltonlewis@google.com>
Subject: [PATCH 1/5] arm: perf: Drop unused functions
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

perf_instruction_pointer() and perf_misc_flags() aren't used anywhere
in this particular perf implementation. Drop them.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/perf_event.h |  7 -------
 arch/arm/kernel/perf_callchain.c  | 17 -----------------
 2 files changed, 24 deletions(-)

diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index bdbc1e590891..c08f16f2e243 100644
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -8,13 +8,6 @@
 #ifndef __ARM_PERF_EVENT_H__
 #define __ARM_PERF_EVENT_H__
 
-#ifdef CONFIG_PERF_EVENTS
-struct pt_regs;
-extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
-extern unsigned long perf_misc_flags(struct pt_regs *regs);
-#define perf_misc_flags(regs)	perf_misc_flags(regs)
-#endif
-
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->ARM_pc = (__ip); \
 	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
index 1d230ac9d0eb..a2601b1ef318 100644
--- a/arch/arm/kernel/perf_callchain.c
+++ b/arch/arm/kernel/perf_callchain.c
@@ -96,20 +96,3 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 	arm_get_current_stackframe(regs, &fr);
 	walk_stackframe(&fr, callchain_trace, entry);
 }
-
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
-{
-	return instruction_pointer(regs);
-}
-
-unsigned long perf_misc_flags(struct pt_regs *regs)
-{
-	int misc = 0;
-
-	if (user_mode(regs))
-		misc |= PERF_RECORD_MISC_USER;
-	else
-		misc |= PERF_RECORD_MISC_KERNEL;
-
-	return misc;
-}
-- 
2.46.0.469.g59c65b2a67-goog


