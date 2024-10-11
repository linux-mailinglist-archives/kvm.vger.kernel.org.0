Return-Path: <kvm+bounces-28595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B179999A36
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FF1A28541F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A300D1FCC60;
	Fri, 11 Oct 2024 02:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qnyU0Yxy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9F1FCC49
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612694; cv=none; b=sPwTYlJemlzmMTeRHaFMBqNppN+A/fn36gG54RzPrCVKpVY5ej2yYTu4dlWS6UDvzz4gsZFFh5O2hqWomX30yl0C7J+7cfdrI68EVXe6dmNNLdcdD3vFm7/4DDY2xwJqdk8qRZqWUESDQ6Rs4/sXiL8Q/0ZFY6HaRD76bS0bs/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612694; c=relaxed/simple;
	bh=G5j/STg2XewWx6BKeygLMbbBozt/6/sTXHCfTmo3CC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZMomW0ByR6xSSrUC5M69C0JR0kZxS1Lrv34apZj95NyC0v4yjccd6P+sKkZX/hK0yzbsZzJPq65MefvosECXquqzh08XFVZ4NdhWarVWVScuXw9snjsqHtZdwuX5TMMFO7deZni5zuBfUu1Rts2FopzZ2sv2ZWcjIKLd9XH7yJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qnyU0Yxy; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e0600c4f5so2426403b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612693; x=1729217493; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+DbRh+OQxnx8VQK332KGl4utXP+C7MDXmmXDxMg/Z/g=;
        b=qnyU0Yxy4PE13cSwLOBwthB7pVANlNz4yDsOvPN5bdOjr0dCA/rk/d0F1erhWPjw3p
         5SI0bvERbLkPYRJ5H5PGh+3/2s0EeerZjJflaRGA0wEEc+C+Iz3Hvfp+Vjv1fKaDBPBr
         4eNT+CnrFpa66Dl8pCcoCfcKNYix7A4dmi3T5tfh5W5jdV+ypniYWYI8oMI7tYlUeisz
         ZRkRKVZMNmx2O352eSDRys63l+LbZCslREIqmnU+WYQhEC1h6xnTZw12moE8OHYz7cOx
         MknSHaId7d4Sue6OQFMI2cvlln+7cKvJcQcjc/KPpvPA/UxbbfHc1NO7reU5MvhbDz2M
         yh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612693; x=1729217493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DbRh+OQxnx8VQK332KGl4utXP+C7MDXmmXDxMg/Z/g=;
        b=IJyyN71Z1n6nFpVC9BsdiaBQY0tdxyTFchp9KtiKu+HaC5SvNTcUfxRvNmqTWE8ZXY
         il4QmxDRoYL2f/95qmbwzol/NpFFaMmURma8/4R1F3XbzcXo46/FzCYgcQsTqzgZwRsQ
         xnokTSechQWybe69gKJOIUfniSRbTuDj/SmzqwtBqMDmdA14TFDsw4Y7NbRpVJpNa6Zr
         w28oUvTpbOqVEuImJXWOSNm4DyQcSMyVYOiVEPwY6/aGx5SC9zKXXV7FagoUcXbpDXK8
         N8WsyKPQQHzA0sGSzpuYYgQOY591kxqMC3OFxngop0FfIeqiXobiImXAce0QecRdH0ec
         +uog==
X-Gm-Message-State: AOJu0YyodV0CqE8at/2egdMK4hHy8MHz7S1+pCjWS8smLbPCoG4AMunL
	xt4PqqFLkWc8qNFa5QwtE9M+6RvtaN3gxoRhVJNZhb1OApFISMZHTgHspZ133GFFowXaVOeXDpE
	hIg==
X-Google-Smtp-Source: AGHT+IF5NMp0NI1CakamRfDZJw0W0RABI+lWlAVC7+uDMKwFg+XySu7vH0dBZjdw628m27BTqRJ51jdefc8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:6f44:b0:71e:268b:845e with SMTP id
 d2e1a72fcca58-71e26e53c16mr13451b3a.1.1728612692090; Thu, 10 Oct 2024
 19:11:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:50 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-19-seanjc@google.com>
Subject: [PATCH 18/18] KVM: x86: Don't emit TLB flushes when aging SPTEs for mmu_notifiers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Follow x86's primary MMU, which hasn't flushed TLBs when clearing Accessed
bits for 10+ years, and skip all TLB flushes when aging SPTEs in response
to a clear_flush_young() mmu_notifier event.  As documented in x86's
ptep_clear_flush_young(), the probability and impact of "bad" reclaim due
to stale A-bit information is relatively low, whereas the performance cost
of TLB flushes is relatively high.  I.e. the cost of flushing TLBs
outweighs the benefits.

On KVM x86, the cost of TLB flushes is even higher, as KVM doesn't batch
TLB flushes for mmu_notifier events (KVM's mmu_notifier contract with MM
makes it all but impossible), and sending IPIs forces all running vCPUs to
go through a VM-Exit => VM-Enter roundtrip.

Furthermore, MGLRU aging of secondary MMUs is expected to use flush-less
mmu_notifiers, i.e. flushing for the !MGLRU will make even less sense, and
will be actively confusing as it wouldn't be clear why KVM "needs" to
flush TLBs for legacy LRU aging, but not for MGLRU aging.

Cc: James Houghton <jthoughton@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/all/20240926013506.860253-18-jthoughton@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig    | 1 +
 arch/x86/kvm/mmu/spte.h | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6b..1ed1e4f5d51c 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,6 +22,7 @@ config KVM_X86
 	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e90cc401c168..8b09a0d60ea6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -470,9 +470,8 @@ static inline bool is_mmu_writable_spte(u64 spte)
  * needs to flush at the time the SPTEs is modified, before dropping mmu_lock.
  *
  * Don't flush if the Accessed bit is cleared, as access tracking tolerates
- * false negatives, and the one path that does care about TLB flushes,
- * kvm_mmu_notifier_clear_flush_young(), flushes if a young SPTE is found, i.e.
- * doesn't rely on lower helpers to detect the need to flush.
+ * false negatives, e.g. KVM x86 omits TLB flushes even when aging SPTEs for a
+ * mmu_notifier.clear_flush_young() event.
  *
  * Lastly, don't flush if the Dirty bit is cleared, as KVM unconditionally
  * flushes when enabling dirty logging (see kvm_mmu_slot_apply_flags()), and
-- 
2.47.0.rc1.288.g06298d1525-goog


