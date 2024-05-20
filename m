Return-Path: <kvm+bounces-17787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEBA8CA1B3
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:02:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDA3628275F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDC913AA40;
	Mon, 20 May 2024 17:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lizZYj3h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C299F13A884
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227991; cv=none; b=utiL1Ed7x4+lBxswOy4iCj7d+gV/NQ5+SSd337XxB01kaeFsV05p2t42LeVntwMVU4djuHvFbgBbsSD2pjJ7E+BbycV1xqB9jgnAgETMeS+wlKdy5/6CgCGIYnQt4p1oeCDBQE9A0N7uXWMGCCO1dzYDsBnSdzQWt9ybYChQk9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227991; c=relaxed/simple;
	bh=p/1KXF29qRmzSD9NEvhXA1LlVuz4RRzHTNwd3jSuBlQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dg9m7EaEqLhKoPNOBMTtx3x53yuhh858tHGX4PZXuH7HKgUX2/GUecpQSJ3EQdaXgpEnJtQTUDNyYU/oBRaMKeJ/Pec9B2xf7Kx2DmDfIUOMQAhC7FSWsQQNyo1d0smU/xnf0tZsgKXw5Yh/+INB2jjHVHlCZEeYSlYFMHcP/nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lizZYj3h; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62777fe7b86so81264597b3.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227989; x=1716832789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bG6uKWQoK1lIwcStmb0jEZYCvEUZFBOg8hTy6PcqEJY=;
        b=lizZYj3hdQdz9UHg/AuOnVbCsmDeJkPlFzOCKFJ48IVl4zPewpJ0rs3cmnULOGUwSb
         0lkuagytHyRwYXc88XemloM6egLCGUXAQMTXb/9BvnHnFWthiagX3OQjxdrCwjxX9+ih
         JjRb8Me3utpZXvng22m5m4lXINItf+VW4zOqTEXJXDnsu/YoMvZIZepXF2MEnbNNuvoO
         uxJ73bAY9JM2NBLj1URMMnxtKspmG3waSj9P6FKRwJ/b8bqSCduj+S51ZcYR914R2zeZ
         CWPNi8LofWSmzjbQH7n1mzFXCp5lETngKuODioDhI3nlsYBnPip8Zv6e0lywDE8CJ/b2
         x3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227989; x=1716832789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bG6uKWQoK1lIwcStmb0jEZYCvEUZFBOg8hTy6PcqEJY=;
        b=IGOncN16ynYFYH0lsPz/mEUXtF5VX1MxzISnmBaXCqW2U2JeMLZrkTciZRf760VbW8
         QbG/29v+dcbtAt2GnWAGCtvR4OEwk9Kt4DFA1Niu5H0W/aUUH1n5ljajvvlHmJk8q1kK
         PsOQEpm7lrtp3o36D0hpMxvEmtfjWSyAAD9q0eSZfuqNIPf2MF5q9TCFVW2p+b5C3rtt
         /qhzA+7VAalxyIORI8azwkU3A9lOEp7Owsfryn1SW8/UtkS800VXJ2M7SRRz2o1kWmOB
         55tloJjLGsBZoNwjr9xC0HVNiht3P4nR7ygoPtd1sX2++BAXcDSkIGhEdeI7F5JwXutw
         l8tg==
X-Gm-Message-State: AOJu0YwEA6dNxY3HQi9JlZGcaaKMRJlCYFNucHiOQpwAhpsaGmQT+sHB
	KKjexZK+zhpHyEErPSOtZdnugf4CLDIDrkz0LA+maUtAoYYMSAJxD5/H+WCssnuG05PK1pE+dYh
	1NA==
X-Google-Smtp-Source: AGHT+IHxt/K3O1j/RPfVQOLJNl/htsEZRUvTZjd/Vj9EjinrtBjZ53F4JSOMFJ0HGQG4hR3cmoonIRoMQMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3808:b0:61b:e689:7347 with SMTP id
 00721157ae682-622aff75547mr67632387b3.2.1716227988891; Mon, 20 May 2024
 10:59:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:24 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-10-seanjc@google.com>
Subject: [PATCH v7 09/10] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
that the function looks like all the helpers that grab values from
VMX_BASIC and VMX_MISC MSR values.

No functional change intended.

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h | 3 +--
 arch/x86/kvm/vmx/vmx.c     | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 400819ccb42c..f7fd4369b821 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -153,7 +153,6 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
 	return revision | ((u64)size << 32) | ((u64)memtype << 50);
 }
 
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
 #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
 #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
 #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
@@ -167,7 +166,7 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
 
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
-	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+	return vmx_misc & GENMASK_ULL(4, 0);
 }
 
 static inline int vmx_misc_cr3_count(u64 vmx_misc)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 695fd7683ba7..fa1a7f775135 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8546,7 +8546,7 @@ __init int vmx_hardware_setup(void)
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
 		cpu_preemption_timer_multi =
-			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmx_misc_preemption_timer_rate(vmcs_config.misc);
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.45.0.215.g3402c0e53f-goog


