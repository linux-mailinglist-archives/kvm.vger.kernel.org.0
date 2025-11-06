Return-Path: <kvm+bounces-62239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F47C3D5A4
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 21:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B7FF3B2738
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 20:28:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080462FBE0E;
	Thu,  6 Nov 2025 20:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhSRhCqA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CE42FB62C
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762460902; cv=none; b=KQH45pREB0eFvyTpSbAZf7ZzQAqlQmFpCoXEhoCUdXn58vw9UDQuILGS6oqOe9mkKF2SWcZNob9/ioHGSvYdb4OA1hQZ0e2VfumcP8kLnhKap16abWqIbsWFgxAj/bu8108hDEov6mxqf+CtrtFXd9K5Vou2lhmlvU1USz/k4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762460902; c=relaxed/simple;
	bh=s7JjaxVRGzDmcHhI8AEluXZzJ9B2Oblzutc30b370MQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jUfcsuHNUgdQwCoENs8pZTMpzHVfTpfVFlb1Aq0lv+J9mQzdIvk0u+96bSMojErYl5NrHTbJR33zWU8nekGsSivoQ5/nmf6ICcK2N+e9VFD+03/slfDOHuID/xIbsTuAi+BfaDg2rPKLH9DbG6KVvdWU7dH/WsCJ1Hc7drTDAQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhSRhCqA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-295592eb5dbso520505ad.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 12:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762460900; x=1763065700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZxRs1KoaK6oa9YoLLml5ndaynCe6AptiJDUeJAShw+Q=;
        b=QhSRhCqAQybhfb84d+D/iYde7Xd4pBTWC8/pqhaxQ5MeIIeAnsvbFkr8vKS/Ivoh8u
         17s495a3t+0osgQUOn6CCaDQ4Y7T8kzJJo8QbE9Jz/YrdH+DHB9CqVrk5HsKHrsRMDEF
         +j98xGq4LgpJdAEGYUD3/YSS8o3vQtSeHGB6WbzJeG1cO1GTLnAUmIKGYauaze5G5Emu
         xvDy3f95dQzpdDMiGVYTLm11juYrm+VFytnYH4ZQTbp0JvsicQc3+R4Merkp9hVoS4cH
         b6VFYiJpG53qCIEMxlqrNDHxYMI5mYjiIEKP3TQi+Pl6+he2nVIB5hmAQl+Wx9kbzoGp
         NCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762460900; x=1763065700;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxRs1KoaK6oa9YoLLml5ndaynCe6AptiJDUeJAShw+Q=;
        b=dKFM/YgQcw1ovMN6baAGoXTS2ixMdMxap/uKiEIQ+8Ul70LfTgapoPBorgV8x4qwuq
         ueLYgxQI1QDez6PcMj02P6yQnvwMinawi6/PIyBaqOKHbFQytK8Lm9ybEnIoA3lThqNj
         C+DDgCS2/ar/xwcqgvZ+DCwP7V4SOROLf8jE7/rzxnrOcwhaGGc1BuHHEwXzToOaWgYy
         aGu3aXZYhuj9qMDY29URt+O7diEpNzvOmwhy4EWCBc8yUPmkI6Lqk39ZdnMguWaO2M/U
         dEWZ7GcaxNLFKwvfmxoYcSm43FBzkcoF5+A/OaZmAQjoszXOmWQQFoDkFUW01xJrBlsL
         p42g==
X-Gm-Message-State: AOJu0YwntHp3j96RG3wkDjQ6S+zNPCIfOA8lY73A01z9oVFB0ltNuRk/
	fOlEHNu9PNJhdyAQhv0zpv+x8WUUYOiR4iXjsWKE18NzOV/HKvHg6ZGzgXF4V0J71Gn5w92ARbh
	iyiEbMA==
X-Google-Smtp-Source: AGHT+IHqjGQP8UTZTtMj2QcFhyHlRrBeBJkjlHeG4vrwg6qhQSWRJzq8rRdwN0zz5xgPPNrid06QN7Ln1Go=
X-Received: from plcr13.prod.google.com ([2002:a17:903:14d:b0:295:16a7:a285])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5cd:b0:248:ff5a:b768
 with SMTP id d9443c01a7336-297c03ab6c0mr9484105ad.10.1762460899942; Thu, 06
 Nov 2025 12:28:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Nov 2025 12:28:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106202811.211002-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a (gnarly) inline "script" in the Makefile to fail the build if there
is EXPORT_SYMBOL_GPL or EXPORT_SYMBOL usage in virt/kvm or arch/x86/kvm
beyond the known-good/expected exports for other modules.  Remembering to
use EXPORT_SYMBOL_FOR_KVM_INTERNAL is surprisingly difficult, and hoping
to detect "bad" exports via code review is not a robust long-term strategy.

Jump through a pile of hoops to coerce make into printing a human-friendly
error message, with the offending files+lines cleanly separated.

E.g. where <srctree> is the resolution of $(srctree), i.e. '.' for in-tree
builds, and the absolute path for out-of-tree-builds:

  <srctree>/arch/x86/kvm/Makefile:97: *** ERROR ***
  found 2 unwanted occurrences of EXPORT_SYMBOL_GPL:
    <srctree>/arch/x86/kvm/x86.c:686:EXPORT_SYMBOL_GPL(__kvm_set_user_return_msr);
    <srctree>/arch/x86/kvm/x86.c:703:EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
  in directories:
    <srctree>/arch/x86/kvm
    <srctree>/virt/kvm
  Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not EXPORT_SYMBOL_GPL.  Stop.

and

  <srctree>/arch/x86/kvm/Makefile:98: *** ERROR ***
  found 1 unwanted occurrences of EXPORT_SYMBOL:
    <srctree>/arch/x86/kvm/x86.c:709:EXPORT_SYMBOL(kvm_get_user_return_msr);
  in directories:
    <srctree>/arch/x86/kvm
    <srctree>/virt/kvm
  Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not EXPORT_SYMBOL.  Stop.

Put the enforcement in x86's Makefile even though the rule itself applies
to virt/kvm, as putting the enforcement in virt/kvm/Makefile.kvm would
effectively require exempting every architecture except x86.  PPC is the
only other architecture with sub-modules, and PPC hasn't been switched to
use EXPORT_SYMBOL_FOR_KVM_INTERNAL (and given its nearly-orphaned state,
likely never will).  And for KVM architectures without sub-modules, that
means that, barring truly spurious exports, the exports are intended for
non-KVM usage and thus shouldn't be using EXPORT_SYMBOL_FOR_KVM_INTERNAL.

Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Makefile | 56 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c4b8950c7abe..357138ac5cc6 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -47,3 +47,59 @@ $(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
 
 targets += kvm-asm-offsets.s
 clean-files += kvm-asm-offsets.h
+
+
+# Fail the build if there is unexpected EXPORT_SYMBOL_GPL (or EXPORT_SYMBOL)
+# usage.  All KVM-internal exports should use EXPORT_SYMBOL_FOR_KVM_INTERNAL.
+# Only a handful of exports intended for other modules (VFIO, KVMGT) should
+# use EXPORT_SYMBOL_GPL, and EXPORT_SYMBOL should never be used.
+ifdef CONFIG_KVM_X86
+define newline
+
+
+endef
+
+# Search recursively for whole words and print line numbers.  Filter out the
+# allowed set of exports, i.e. those that are intended for external usage.
+exports_grep_trailer := --include='*.[ch]' -nrw $(srctree)/virt/kvm $(srctree)/arch/x86/kvm | \
+			grep -v -e kvm_page_track_register_notifier \
+				-e kvm_page_track_unregister_notifier \
+				-e kvm_write_track_add_gfn \
+				-e kvm_write_track_remove_gfn \
+				-e kvm_get_kvm \
+				-e kvm_get_kvm_safe \
+				-e kvm_put_kvm
+
+# Force grep to emit a goofy group separator that can in turn be replaced with
+# the above newline macro (newlines in Make are a nightmare).  Note, grep only
+# prints the group separator when N lines of context are requested via -C,
+# a.k.a. --NUM.  Simply request zero lines.  Print the separator only after
+# filtering out expected exports to avoid extra newlines in the error message.
+define get_kvm_exports
+$(shell grep "$(1)" -C0 $(exports_grep_trailer) | grep "$(1)" -C0 --group-separator="AAAA")
+endef
+
+define check_kvm_exports
+nr_kvm_exports := $(shell grep "$(1)" $(exports_grep_trailer) | wc -l)
+
+ifneq (0,$$(nr_kvm_exports))
+$$(error ERROR ***\
+$$(newline)found $$(nr_kvm_exports) unwanted occurrences of $(1):\
+$$(newline)  $(subst AAAA,$$(newline) ,$(call get_kvm_exports,$(1)))\
+$$(newline)in directories:\
+$$(newline)  $(srctree)/arch/x86/kvm\
+$$(newline)  $(srctree)/virt/kvm\
+$$(newline)Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not $(1))
+endif # nr_kvm_exports != expected
+undefine exports_advice
+undefine nr_kvm_exports
+endef # check_kvm_exports
+
+$(eval $(call check_kvm_exports,EXPORT_SYMBOL_GPL))
+$(eval $(call check_kvm_exports,EXPORT_SYMBOL))
+
+undefine check_kvm_exports
+undefine get_kvm_exports
+undefine exports_grep_trailer
+undefine newline
+endif # CONFIG_KVM_X86

base-commit: a996dd2a5e1ec54dcf7d7b93915ea3f97e14e68a
-- 
2.51.2.1041.gc1ab5b90ca-goog


