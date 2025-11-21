Return-Path: <kvm+bounces-64239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EB5C7B6F0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C41524E4114
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD692E7165;
	Fri, 21 Nov 2025 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1bXoRnRi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F4B2E762E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751919; cv=none; b=MfxpoGzib0PK860Nth3NTidYGsREX2eXkjvJDClx8aCbWmdbYrRhawJEKF2vWJKxTcb47uqMZbPgzLoQeHvndiqM5WxxDJL+w6jIiMu7wbdpHJM5NiM3azipF5/nhW+ji/h62b5vhYIyNnt2Az6BD/m7DXIl4TNDKEk9/RWUb2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751919; c=relaxed/simple;
	bh=+A5XAWcqurage67YRLW9lcwi78TMeJjtRks+7yMeSBk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=D5kCkErs29txgTg6WC546MzxnPI910ZzISxcu0VtsEfMeSHV7gXyCBu58w8Xkk69e4cGPEwOiq0kmYaAZMCd+Er3HO8nIFtuohJ50ujlQYgZDGg39FZKZMws5AzakBTDKr6U5PKQE4zcp3sV9j6y49rWvU6o2MSPiUsxQjj8gUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1bXoRnRi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341aec498fdso3218531a91.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 11:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751917; x=1764356717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRjsKGppBi4C3wyOiFmrR0ynNhYINHO1mDpNFutPc2Q=;
        b=1bXoRnRiFroU7OVcBGxXHSVKvi4/fGOLda8jLwS76fCPmCVRc7MntHe7/5Ca9Hf2P0
         PYxIxVNKcNJYQ1tR5GRnqewMmx/+axyjOX6aSWP2h8m5SlE4s3VQ9XThiYpb9NHNzinV
         nynXCCZ0NH0Hyixyp9wUeOzJ9FUjhEIRinlY/I3+lG0LbKYJCBvuj1wxdkeNgn+gz3s3
         fVmMjJk6D0zHHOZkew1FsXqHEBJqsGw/rt/1cUv6GjJaxGawDjdEVWW973gK0o1hxEok
         LoZ6Ti41xmrru+JczzNNvxaQ+OpnIQcaXvlcJbw/gdHxhe0JkyktgeNIP9PMog0/8a+Q
         kdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751917; x=1764356717;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fRjsKGppBi4C3wyOiFmrR0ynNhYINHO1mDpNFutPc2Q=;
        b=IsHV+FM6KNCloIMsdoquNx1zP5AoDjqsy7HszrxbfKYWDnLDjv/tDLaLirwGeBMAmj
         3kXY9JDqhIikHdnKzfZ7l0SnCC6kwNls+vzPA5DNBt6GHD4jBJJshY8riItB+nyVCziN
         xK270oZ/Q7pv/E82kn68QxaEn90ZnBH68UU8KJnlfuaKMnqwtp8Z+qUlOChG3rARAprj
         AjAbyVIQH4Tihg7qY8w3CzIqJez18vToQQ41sma8XoU3RobN/xVlBrR2MWX6OpFlE3tz
         I1Rdm9Kl4MCXUszBLAUsEraB/RNFhMFXGlDH+emct/73OLhdtK7a3ZwUSzbY8YwA0wqV
         yq0Q==
X-Gm-Message-State: AOJu0Yz1x07dIOQx+2lOffBkvYQs4om+EUdyvvIRjMRSTqYf4bjQ8Vz3
	XZm1vF6G95x9sLCt2NaAVwOLU7WNylndR1BFjOx8wV4EWafCvxVK5JTWcgO/FD/nSxAz7RRn1CE
	fsQPSfA==
X-Google-Smtp-Source: AGHT+IGDT/uu7YptLJcqTP4FDwYBZ3vOFt3VY8dH0ytbU8JAHMp7jkb4plpjOiHjqLVqacIWoHV0FQrkIO8=
X-Received: from pjbms3.prod.google.com ([2002:a17:90b:2343:b0:343:7087:1d21])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f88:b0:341:8c15:959e
 with SMTP id 98e67ed59e1d1-34733f305bfmr4545320a91.17.1763751916833; Fri, 21
 Nov 2025 11:05:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 11:05:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121190514.293385-1-seanjc@google.com>
Subject: [PATCH v2] KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
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

Tested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v2:
 - Use !SEP! instead of AAAA. [Paolo]
 - Drop the local newline. [Paolo]
 - Check nr_kvm_exports against '0'. [Chao]
 - Remove unused exports_advice. [Chao]

v1: https://lore.kernel.org/all/20251106202811.211002-1-seanjc@google.com

 arch/x86/kvm/Makefile | 49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c4b8950c7abe..77337c37324b 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -47,3 +47,52 @@ $(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
 
 targets += kvm-asm-offsets.s
 clean-files += kvm-asm-offsets.h
+
+
+# Fail the build if there is unexpected EXPORT_SYMBOL_GPL (or EXPORT_SYMBOL)
+# usage.  All KVM-internal exports should use EXPORT_SYMBOL_FOR_KVM_INTERNAL.
+# Only a handful of exports intended for other modules (VFIO, KVMGT) should
+# use EXPORT_SYMBOL_GPL, and EXPORT_SYMBOL should never be used.
+ifdef CONFIG_KVM_X86
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
+$(shell grep "$(1)" -C0 $(exports_grep_trailer) | grep "$(1)" -C0 --group-separator="!SEP!")
+endef
+
+define check_kvm_exports
+nr_kvm_exports := $(shell grep "$(1)" $(exports_grep_trailer) | wc -l)
+
+ifneq (0,$$(nr_kvm_exports))
+$$(error ERROR ***\
+$$(newline)found $$(nr_kvm_exports) unwanted occurrences of $(1):\
+$$(newline)  $(subst !SEP!,$$(newline) ,$(call get_kvm_exports,$(1)))\
+$$(newline)in directories:\
+$$(newline)  $(srctree)/arch/x86/kvm\
+$$(newline)  $(srctree)/virt/kvm\
+$$(newline)Use EXPORT_SYMBOL_FOR_KVM_INTERNAL, not $(1))
+endif # nr_kvm_exports != 0
+undefine nr_kvm_exports
+endef # check_kvm_exports
+
+$(eval $(call check_kvm_exports,EXPORT_SYMBOL_GPL))
+$(eval $(call check_kvm_exports,EXPORT_SYMBOL))
+
+undefine check_kvm_exports
+undefine get_kvm_exports
+undefine exports_grep_trailer
+endif # CONFIG_KVM_X86

base-commit: 0c3b67dddd1051015f5504389a551ecd260488a5
-- 
2.52.0.rc2.455.g230fcf2819-goog


