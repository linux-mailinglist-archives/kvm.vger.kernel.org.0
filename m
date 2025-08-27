Return-Path: <kvm+bounces-55813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B685EB375DF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E00E2A72FF
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD058221543;
	Wed, 27 Aug 2025 00:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aaxzXCw3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E27202F87
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253144; cv=none; b=SBlfWAzCsRJuQrgKePxRKObYhcKtOfN4fIRODkdykIk8pXNyGa3zWlqKm42LR7NV8oVlXzzbYdLYivTTkg6B0S+UzzklKJ+GRIzWuL2E+I4hGTwrGRS6vf8H4/sKMHCFiV4nREsmvnUAajIR6dJS90kYIx9m2jxwEgBi14wMcE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253144; c=relaxed/simple;
	bh=CT8ymioLuOlBWrXD3r8YANXKr/P7e/x1kpJZ/SO1Ra4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDirT08SAlT58SXjsrHS5WfgGMXVlGB0Kjo02n6Lq7/aZW5rWPvGEsQYeZQaz8OtFXizr3bYKn3Zhc/cAQVL3S8/be2w/JYEFZAO37f0X3FYG/uVE3rI7FGxFchWCKnD1MsR1kqSfwlED4z+V0ERTMG4lmea5LhMOExMElgJVl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aaxzXCw3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-771e1451631so5314806b3a.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253142; x=1756857942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LCGUcAyKwwCwfLwULs9m93YuDYGiD02JqCj6uYcQICM=;
        b=aaxzXCw32QhFLdtbWOYvV+yweY0S/cEi6k6yJxMhDzNRQuo4XjsVxh06lwQw1Uherc
         qPe1ChNJeT7d+S5CIOUkyrC3s/JEqvVDWGQMFJpfcFNaHO61KCG8xaDwc1av0i9dTQd5
         VhiJ6gaKebH+o8gd+1LidTgLIgQHeD00joyKjacxLimLpEzIwl86gVKYvO1VmQPObm2M
         GZfccTQT+wLTv9D7ahBTJqW/W3FVdUtVeYLXs7QtV6uE2SGHKa4v9TzXEx6u3DjDwiun
         TaZDY90iAHvWqf9LSY67yAsjTg6xKM4my3MJmexn70WiJwY94a0aNXdMvKcZg2TaEBYd
         k3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253142; x=1756857942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCGUcAyKwwCwfLwULs9m93YuDYGiD02JqCj6uYcQICM=;
        b=wwu8NtNtW0dwVWBfGetuG07/pQ8L2XCDSghdQqfwFU5oWtYASANDzX9dByB6bxBlua
         xnOpLmQPIIAw1lxNpGCT+X3UsYVwboRti0fQAG5R+ITgtgGFFLtu5i5tZBIT1QwuYqCV
         h1Ruvv7e6OwOExeLE+bR6hXdFMkJARfmt8gJN5bz0WZZ/GGCPE8Exgrpg8YO+52uc7Vi
         lEdvROd2Yz6pNhGi2z3m7CricNixBFrIFvpd3d5z+H5ekCjpOiqPk/p1tNbA+i7qKC5f
         ZhfxoC8JkoZssPNWxyjmkSG1hzy9O7JJ2rIfanxJhQv7jpIh4VMum0FkpwXvxqr3m0rR
         kRng==
X-Gm-Message-State: AOJu0Yx/qkUFJGTYnnCvKWOxcjXS1nFouYbCXFrwgX/RcRVWR934kKjg
	hCLNKbpHaV+NEKXt2y5td5vn0hsGJiKaAaYIV/f3y4TdzAi/RHYBgShWOQcHPMGP2FWw8RwrQU2
	8SFXL+w==
X-Google-Smtp-Source: AGHT+IFkv1lpUrhzXX2+Y6v4Rm2dch6Njn/s0k/vZd6wkTZ7k/2PRiGbLK0dgoXhRwsaZtJNVwl1odVbERM=
X-Received: from pfwy21.prod.google.com ([2002:a05:6a00:1c95:b0:771:f6ec:3577])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f83:b0:76e:885a:c1cc
 with SMTP id d2e1a72fcca58-7702fc32896mr18670355b3a.30.1756253141821; Tue, 26
 Aug 2025 17:05:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:20 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-11-seanjc@google.com>
Subject: [RFC PATCH 10/12] KVM: TDX: Assert that slots_lock is held when
 nr_premapped is accessed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Assert that slots_lock is held when the TDX codes accesses the number of
premapped pfns, as KVM relies on calls to tdx_vcpu_init_mem_region() being
serialized to prevent double-population of gmem and false negatives on the
consumption of a "premapped" pfn.  In addition to helping document how the
TDX code works, this will allow converting "nr_premapped" to a non-atomic
variable, as all usage asserts that slots_lock is held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e4b70c0dbda3..27941defb62e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1634,6 +1634,8 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * to prevent running the TD with uninitialized memory.
 	 */
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
+		lockdep_assert_held(&kvm->slots_lock);
+
 		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
 			return -EIO;
 
@@ -1767,6 +1769,8 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		tdx_no_vcpus_enter_stop(kvm);
 	}
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
+		lockdep_assert_held(&kvm->slots_lock);
+
 		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
 			return -EIO;
 
@@ -3132,6 +3136,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	struct page *src_page;
 	int ret, i;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
-- 
2.51.0.268.g9569e192d0-goog


