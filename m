Return-Path: <kvm+bounces-58878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F12EABA4846
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 17:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A02D3561307
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 15:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E6222D4FF;
	Fri, 26 Sep 2025 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KQGErAcX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61E223DFB
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758902259; cv=none; b=pXHYqAGvbyIqhU0jJLU2xqi4U3bFSC/mlqn6/e6kOMrg5PKtiwzxkaupvPuTAXYgSc9kBm8AVbEct+p9949OSLn5Qg582dPmi4IU6SYV60MqQd294/8nWoEna2ik+Nvbtz+D5BMZciGAUbTg/tqnaJyp8eC9t8pL9DrGRZ8CPH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758902259; c=relaxed/simple;
	bh=ECLlIpH3f0tmfwTuHKFged4MrFHa2zBFDx3QZkLLNT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GPRBDQOJDNKbb6RQpL+9gsNYBa4MmVZ/kP6DPZn7HFgeOhqrfRh31mG8pTdGR0zt/7G0D9LnPjs6p6MUSqmGEktokVmr7StSVcaHBVjUoSh38Y7k9BHNYripCun0tvzOrs1xigJ2dAtBIXOws9u1EpeKVu/lBEZBmfW+QdSNuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KQGErAcX; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b2ef8e00becso480433766b.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 08:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1758902255; x=1759507055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MnCYIxbhfqhLOYxe+K+CHs0locV4mStAOU9WPUq7DAo=;
        b=KQGErAcXS2uX0iiEVaA7r+M1Y94gM4PtQXQtfSe9ouxX0bZXoMoDcSdXfjBY1R61ms
         5LCrxGWHreJAclq7yoCe7kZwIEaI2pl3hM9r75+vdB0uv3uTnZjW8nOhJcjykDWaJjvP
         A5BtRHtR0JKeDdxKWqBrfchYAu4Y5oVuQeL0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758902255; x=1759507055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnCYIxbhfqhLOYxe+K+CHs0locV4mStAOU9WPUq7DAo=;
        b=SnPJq4h9V/jif3Xril8xk/n+iOuHqTmq3VZ4li5UrxUcxLECR+KWSrqgN7kho3c7uM
         p3uT8ktwrskbE+H8OH2AnjSACR6XFjQ6q4m4XK9bqRd13z9zfOac0oC/OUimxeNFirbL
         jcLl2vagLTFR8cHJzTpT3wSs8PHU45HFg2ltPHFF4hI/OX7ncMfMPrsQHO/E14vFDzYO
         axNf9qSK2irde7bRHH3jSF7sV5dzEw2hus8qBAsLeGr2QWZxQTSzW0G2LmXJS8qqc/LN
         tklMUMWo6Ip4c4dYd9ScI4WUgWrxs/sD6MltvrRYTuWMNgopeQiBUSM0W8D5H4I7pDe0
         920w==
X-Gm-Message-State: AOJu0YwP+NlLnHz6tb6Bxhl/S6L6Wq4jaN4BMQAlEpPxPyDUNZgtqYQ/
	bfJvxDphNWlaUdBwv6PvV9Xnu0hmQsUVFcf1n5DqDn82w1yLqzJsIJnDV2BNa6j2EwZPYoIPfCr
	iCyEAdmpJ
X-Gm-Gg: ASbGncsZz6Vn25bWfVVhu5kgmfqKPtYsnOaxbpvaWQX/zpghH/yYxP+xSowNIueKjzt
	eb8iLlGmDl5/i4Ey6qmoQ5AQH9/CJQy6AoagLkLx+b8WFO35l14PF2Tncyqojgvae2dIgJFTwU+
	i9CXp/4Mx/jv6JXXphBCW9jzEiJgeKfJEjXw++Fyw2pVgJ5oJymCXONaYYiaSGzngnivwLWeQ4N
	POa2gxbLs/4mXGCJCXi4deDblAXuCVAF5gQa0s23NMeZEEPdYqMnXfnfUi0uuuP1JXFQk2oalR4
	x9PkQviruk/iX8Zm8rU8obJUWulZdOXLi1/aBqfdAoKWU+3gvdt8Goy7MB0eT2udWdQUdvRWsCZ
	zp6Fp0NOo/kuCJPhyn/uKjw==
X-Google-Smtp-Source: AGHT+IFy3tXeQaesLpF4f5dI7bz/wmKc1Ad6cifwbzws9wXsRPXgAJsfxHkxNMMO+uC8NB7mfu1IgA==
X-Received: by 2002:a17:907:6ea3:b0:b07:d904:4b9c with SMTP id a640c23a62f3a-b34ba147a47mr931736566b.12.1758902254736;
        Fri, 26 Sep 2025 08:57:34 -0700 (PDT)
Received: from dmaluka1.corp.google.com ([2a00:79e0:a:200:f83f:a8ff:c4f3:beb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353f395349sm384242966b.34.2025.09.26.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 08:57:34 -0700 (PDT)
From: Dmytro Maluka <dmaluka@chromium.org>
To: kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Dmytro Maluka <dmaluka@chromium.org>
Subject: [PATCH] KVM: VMX: Remove stale vmx_set_dr6() declaration
Date: Fri, 26 Sep 2025 17:57:24 +0200
Message-ID: <20250926155724.1619716-1-dmaluka@chromium.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove leftover after commit 80c64c7afea1 ("KVM: x86: Drop
kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag") which removed
vmx_set_dr6().

Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
---
 arch/x86/kvm/vmx/x86_ops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b3424f638db..48a888fa71b3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -73,7 +73,6 @@ void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
-void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
 void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
-- 
2.51.0.536.g15c5d4f767-goog


