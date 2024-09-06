Return-Path: <kvm+bounces-25988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DB196E8B6
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65F371C21127
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492C714A4C6;
	Fri,  6 Sep 2024 04:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hpcYi11N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1CC1474CE
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597273; cv=none; b=d+3TXMP90yNsckKtmF6LocnCJtFPWX+6B4WJkrP8JqDE7Kvn9yhz/trfHE6A/MMnWSnFxSdEj7i/vpYirA2x+uTJPWsruFBiKI3St67U+5TwMFWphblGpff2SON4dxaAhWwegDYGqoELVd7ccYQx8+dnWn6qdybAC7GIflaGIfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597273; c=relaxed/simple;
	bh=fYasJcFsQHDkQBLbQydtD9whZiU5icAeuGX4p36bSTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZ+o1PvHBcV3flbOuncTCeLAHCyFRK0b4r0JKgxHlqYDSEHkxRgZw8IXalV+7PMVfUdux7N2Zl9hZavEYKQRG3HjK9dwLG2BVIbCsPVUgLjZc2XL/QutZS7p2LFozv8BZzb/cxqua07nG44WxI3r3HnxZh702/bdgAtS/765eMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hpcYi11N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7179469744dso1665707b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597271; x=1726202071; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ng8EbVRlXMuE/cCrzi7LkSpAYLCcIcl00WaW0vWSlZE=;
        b=hpcYi11NChzmDdeZ61nRL10CYvSRl2C3aC8Kol16DE/XWomxj0t+jAFKPJk/ogslXr
         7CZeP41WeT24ZxcdmkfLspenSsVfxtXJ4zYCP0+y4Efc9/UnizDWKM4/K5bl3Pg+6AnC
         KUHPOrz639zxsrdnBX5EMwVd991w9OfnflSr62cq+W7RaH6rIhtePYWBBhzC7GYbl1yF
         Wj05Pxjq7L3T5pcTPDUdIxlsV2MnMYJSKQGoZHtmETH47n6+PJvKh9/gPzoArG2mjgxH
         NjDdM6VzK5VfUlQHu7ZDu3LKZSrPBpTN37qe+YC240msPJKnHF9TIOt2jPkzp/sZtKyB
         L7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597271; x=1726202071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ng8EbVRlXMuE/cCrzi7LkSpAYLCcIcl00WaW0vWSlZE=;
        b=SHj0jblmWVFR2aS5nOV64ZYM0mN/Zuz0lD10IrAqGBDzovP7TYptEuKh6P2zc6WPYI
         OqwsqdS0boUxxKkHOnub11GydLe44Za1q/QZ2CzHzAaoPll/yxmYlBKibKt7DFJuUtbF
         IxtOH/XD1e8L2nHfGmikZ4s+ZBZ/KIpQPqMcPnfziM0PIpZ8uPH9UH9cEyxontajQDxu
         HyY1xkWuLYDAkBvX1xeSQsE3ZV/tbfbFzIXXjxOKKEsZAP8J7NSqkYtGQjBvb/2+OfYt
         DUTgXC2yi/OqOoFgpXM+xZqvtPYXn8yunBE8mu487QZXXv191IbxQRposvjzITZwlrj4
         hDTg==
X-Gm-Message-State: AOJu0Ywb6SoQzeGxUJ62O6OfRRUu/c3YdwIq+SiSSs3o0IoJea5YQPLP
	kL+AusfO3xJeUEgCQXU7A8ZcBP7VvCY5hvSG6MIS0hsCOJETdL0x70R1FKm1lK00idA9UaHXPqb
	CLA==
X-Google-Smtp-Source: AGHT+IGnip38uUNcVH5/E6tvK0YEJByz8PD5gVFdSt7Dd8HEI5fzxeWwOi6izTL6TuI+wk0frCtzr+Zv8jU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8d96:0:b0:717:92f2:d50b with SMTP id
 d2e1a72fcca58-718d5c30082mr3607b3a.0.1725597271485; Thu, 05 Sep 2024 21:34:31
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:13 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-8-seanjc@google.com>
Subject: [PATCH v2 7/7] KVM: nVMX: Assert that vcpu->mutex is held when
 accessing secondary VMCSes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add lockdep assertions in get_vmcs12() and get_shadow_vmcs12() to verify
the vCPU's mutex is held, as the returned VMCS objects are dynamically
allocated/freed when nested VMX is turned on/off, i.e. accessing vmcs12
structures without holding vcpu->mutex is susceptible to use-after-free.

Waive the assertion if the VM is being destroyed, as KVM currently forces
a nested VM-Exit when freeing the vCPU.  If/when that wart is fixed, the
assertion can/should be converted to an unqualified lockdep assertion.
See also https://lore.kernel.org/all/Zsd0TqCeY3B5Sb5b@google.com.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..668b6c83a373 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -39,11 +39,17 @@ bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
+	lockdep_assert_once(lockdep_is_held(&vcpu->mutex) ||
+			    !refcount_read(&vcpu->kvm->users_count));
+
 	return to_vmx(vcpu)->nested.cached_vmcs12;
 }
 
 static inline struct vmcs12 *get_shadow_vmcs12(struct kvm_vcpu *vcpu)
 {
+	lockdep_assert_once(lockdep_is_held(&vcpu->mutex) ||
+			    !refcount_read(&vcpu->kvm->users_count));
+
 	return to_vmx(vcpu)->nested.cached_shadow_vmcs12;
 }
 
-- 
2.46.0.469.g59c65b2a67-goog


