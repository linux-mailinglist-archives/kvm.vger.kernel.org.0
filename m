Return-Path: <kvm+bounces-28588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C1B999A27
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7E471C235F4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057BD1F9AA6;
	Fri, 11 Oct 2024 02:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eAmLNtWs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972C1EABDD
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 02:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612677; cv=none; b=V2sRYLnkGHVPEn5EO/zosWa3KM2UnlATV07/YamHLuiVtIh0gNmMqFGdGu3BnOjcyd5WvACSxT1feN372AkpwZXEY5fZOWbjFCuz6N7/Wr3K4TH7HjlIsRD2FlY43fPX1Vty442BvokEZgSXlslSP+YCusH5g0wNYyZbY+HvKp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612677; c=relaxed/simple;
	bh=LZMcdQvJWnJLB3/UIdM5EZpK8QPNNstC6KLm9lhBrbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CFRxwfH3+NfpRWvTsSmWBgOBMjgjUViYkvLAj8OruPHajbj+GvuT8nF5SKXdydCdHez0kpXTuGZT0Oc/AuWyssuVBAAtfIcyzcoxvjRkWTa5xzwZ1zbUJLhh21bafSYEVyZLJiUH7VSUqz07Pw+YZGgQv44tzPaXaccZ0QbEcDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eAmLNtWs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4f9974c64so1152190a12.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 19:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728612675; x=1729217475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Hvv35DHJVsIcR1KuBMr5pv5pWI9cGFmfEf+HtUf4zac=;
        b=eAmLNtWsx3FWhdjImXvs4TMA5TAEasf25LSl8DYN/dKIRhoqvyBoIvwZ0LSEywVbob
         sxuXcXD8zoScKKUYERGypKucLm1SCHtUe+vXznvzC8hxh3LYi5+VRUIn+c1ERyiA0PS4
         AyUCYWd9GbygTc1S7g6PmOxfNziPRHJtLa8HLvseMW/K2DHQkNCAq3JNnMLXD3ktkqH+
         hyllqUUHfTPYSMpCDNI968l0K6qi8/4xu5OuBqzcdDxNu2jI57Lo/QyeKk8YZJxsijpP
         iD61TYRrSTy9mqPDqWSEOCCJ0fpTUJwSlJ/nvegfJXUkX00QEaz3W4U6OeSfHE77w+Es
         IP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728612675; x=1729217475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hvv35DHJVsIcR1KuBMr5pv5pWI9cGFmfEf+HtUf4zac=;
        b=Dg4//oYlr8F6Horm0mNZNyz+jwC9LSd3bikfEQfSQq6GTeoSaQ0Pj6pbzsACaY1k/V
         tYcVW1raXGKhTP/MpJHdRzRfNvVKrGUmpc4BXKb02Hkjeafz8nrwfSPT506/q/Wfwmap
         peeKmg3fciwTlNf1eTPVSZBzbOkKiQWntC/YwqqPC5B0Q2EqCHMN/OlvBg/yq1+8MijC
         IfdMqWMrNX7lFIyLeq4/WrpGi6cZSRfbUtowhictIlxe/c/2gr1lSRCKHRHecsodxJUh
         lpGR7h7KoivSjT7McOwb8sE6Zt7ekexACfWWZyIiy5IJT7Y/yn/PdOjqnyYJrwmLtm1+
         OP1A==
X-Gm-Message-State: AOJu0YwDfZgE6R/IZJCBo4/dCSJzEf2+OTlOhZG6DXNHkP5YYmqz7MOO
	l3fBeRFcLVYsG9jh7oIL5QDiyLOmSACqJ7pf0sHIt8ou/wCQt+l4vHACYv969r1v22/muJkr1T/
	Ikw==
X-Google-Smtp-Source: AGHT+IHnF6owo+1pNhj2RLKasExwUgPBpKQO4fPjKU+UOrHlJ7dmNwwiU5RcRn0ke9/PSMdjRWsWWieNTx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:7d57:0:b0:7d5:e48:4286 with SMTP id
 41be03b00d2f7-7ea535a6447mr696a12.7.1728612674757; Thu, 10 Oct 2024 19:11:14
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 19:10:43 -0700
In-Reply-To: <20241011021051.1557902-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241011021051.1557902-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011021051.1557902-12-seanjc@google.com>
Subject: [PATCH 11/18] KVM: x86/mmu: Set shadow_dirty_mask for EPT even if A/D
 bits disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Sagi Shahar <sagis@google.com>, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Set shadow_dirty_mask to the architectural EPT Dirty bit value even if
A/D bits are disabled at the module level, i.e. even if KVM will never
enable A/D bits in hardware.  Doing so provides consistent behavior for
Accessed and Dirty bits, i.e. doesn't leave KVM in a state where it sets
shadow_accessed_mask but not shadow_dirty_mask.

Functionally, this should be one big nop, as consumption of
shadow_dirty_mask is always guarded by a check that hardware A/D bits are
enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e352d1821319..54d8c9b76050 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -420,7 +420,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
 	shadow_accessed_mask	= VMX_EPT_ACCESS_BIT;
-	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
+	shadow_dirty_mask	= VMX_EPT_DIRTY_BIT;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
 	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
-- 
2.47.0.rc1.288.g06298d1525-goog


