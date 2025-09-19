Return-Path: <kvm+bounces-58238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F176AB8B7CF
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0AB3189EF4B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2A12DF6F7;
	Fri, 19 Sep 2025 22:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FkIrvUcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399E2E11AE
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321202; cv=none; b=MGOkWU60LFW6MvI0xF5ARnumW9dnZb98XMIVJGsBeavuOH0ByYdzrqEsnSzumpDWWgotvCsN+mvtKIaroNdVfQDfe4xyCYDg7PEP+hMTL44AXlBsEBGfA2Mx4KRaDTDlXk/WXLpVPGGd2JTO26BYtTMOHOrtk5xCzlS/0znZnIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321202; c=relaxed/simple;
	bh=ez4a0EvjjtyHc093VLzuQLspYqBK0zm6wW8jLJdW4u0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HkMR8JGd19iUetEkaXhStySuSz9hxtn+RhGUEien7x6XtRbA+oEHgtkgCKJ0xSCUw7/Ww7K9jksBEfM4rr33YGYRjG1J27622KjfMNwQ8vFM2MeY+PmIZngfWJzEWVuYTH2ARgPmi9PXtKedDG7ASsQjruPdG6dpyqMSgqXRSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FkIrvUcM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaa47c7c8so2578602a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321200; x=1758926000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pOmn1hzdWZ666uhIyCKCS3d5Tvi+EBzamfmIdMDGoZg=;
        b=FkIrvUcMMOlDvaHz4TtYYg+OqZ6bGIjIfGA06RdlWDaX3OAwlZVrNCkFTfo/YGPakm
         3617E8eDGx2DJyFdMBZWmi2giukJVytur129LjAjIT1swneau721DWCQ05OLmpkDfJoH
         M/o9SNMuOtMm0eH9fZfAk/HeQZy8EH0D4uPNy0Wv+v8TMHUqA5xNpD/8TofuBHNHPoQW
         BctppUFp7WxOxwZQ2grS8FZmPm6I+4gtXmwVuaAROPLJIuoONJvW6hxmBJqkUIcaDYYk
         xq5FQpPHDnT7d6wSrQoBKStVN5d9+tgB7v7aoPnYfhZ0MlWkPAP8qjD9IGwZExUwy/P6
         XceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321200; x=1758926000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pOmn1hzdWZ666uhIyCKCS3d5Tvi+EBzamfmIdMDGoZg=;
        b=cySMFyB8Uh3fz6hSq8zG6RJlMs8oHS0DetfZ/gfdEEFxrnAkDvajo/1iHK+l2wSK07
         YPmeEGQDsImqMXjYMFRzpHFzVn3AYYI8L8gWT0I7Jc+bSw+7l16nCOP1q4DzFMz9M4Rz
         GM5ATkqnD+E/bWR6OvPGgnu/rRFY2ipZvDTn1j8/ljecN2wdoDc/7YKRUxZNqImpcynq
         MmWU6tjOmXKwThu8BmhBZatjXYogrznlJJYC9V0uctzn34QIe5KhA1rgC1Whs0A8bkp9
         DKvOUdrM7q/aoErLuEFLNkLYLba4vT7jCILBAtmhIE7mPgV3B/tvKL2swSN8I71XMlGo
         /xwg==
X-Gm-Message-State: AOJu0YyVjt6c4mcVYcjW8kP/K3rNDQT7NIk2/zPgQhPonH1kDdMq4XDa
	3In3ndyTx0OoWwCwOLyQJG6vklwRSLjtPojhk9og/z4+9ETI2beirA1EWuyIMkc1wsB8O2YN6U4
	U+cQLeA==
X-Google-Smtp-Source: AGHT+IHPp+EMEqqepgMRLXkmh2NAYmJDXHdpPXFvlA0cxdH2fcNuhXSpiI6o1vBaj4gvOZIsi3vnHYEIRwA=
X-Received: from pjbmf16.prod.google.com ([2002:a17:90b:1850:b0:32b:95bb:dbc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e703:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-3309800134amr5713441a91.9.1758321200242; Fri, 19
 Sep 2025 15:33:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:17 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-11-seanjc@google.com>
Subject: [PATCH v16 10/51] KVM: x86: Add fault checks for guest CR4.CET setting
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ae402463f991..d748b1ce1e81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1176,6 +1176,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1376,6 +1379,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.51.0.470.ga7dc726c21-goog


