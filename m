Return-Path: <kvm+bounces-30344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0531C9B97AD
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1A131F22EA9
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB901CF5CE;
	Fri,  1 Nov 2024 18:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iqqvtpmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721E21CEE91
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486161; cv=none; b=u7iYOzmsHwwwne+PLmxuP7yw8ATgDAfewL0ALphRq8/MFvEzG5bGDdyGrq4qDsk3lDPrGSjfkcOvlodKmIZbMrPyRivfmBRuVvg1559Pea1MYa583GQsM7KptzyhsseD5jldj6iIhOGQZTudGotJBgu3GVeqqjgRP6iVhU8WdZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486161; c=relaxed/simple;
	bh=GthnIBzx9iijyVZUANBkchjX+hZXG4UWjfuYUeGfwps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=isecvOaxv+4zb8lvOmyUjgnIADHE7AJ6gg4S+iKlDX/x7xzrfy3fnyd2pXHXaWeazAo5XqhKgBIV+Me1JURIKMh3jsNORWYROaZAnHheidSewusRuFICGoNa8W7eL0jlE4xPj4kSAEj74IhMKyl+pvy3v7pkAOZ9nLagrYfCzX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iqqvtpmi; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso2367431a12.2
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486160; x=1731090960; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qVWIo3tvorcfd9vZ45ZC5Hm+N0sYYOu19bKF2QN63SQ=;
        b=iqqvtpmithxzTSFB0KhCn/cf15yMVYssppD+h4ZQ0s83vUf+3CTvsE2ZYxk7N/uwCm
         vadb4yNcVXb1DYGlUyYybPicrVpoYk8Wz4CErKlr3gZ8aajpR0WpGtUXbhkCEZY4g1HF
         XSJKWOgsK1sWUxdki1ZiAqfPjsbgv9vraHt5HnPSOc3v2vyoOPnODm4Bm3LOj/E8vF4C
         x0lgZOWYWXWuEjcgP/2/xgLEwP2JFTb5ODi+aCqkF1ovwFVM3ASTsxbVMWXdexyWbqgk
         wpayYECA33Qh/OZhqAXX3x4ScMdScRr7SY1FTVGKybIh0ZZcr8qzG04ErtuNRneU+A0B
         n8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486160; x=1731090960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVWIo3tvorcfd9vZ45ZC5Hm+N0sYYOu19bKF2QN63SQ=;
        b=DtEKN+31W7vtuXJQptcSyHl4bHFQpReoBX2hLhEDiYlKCjAy/U4HzoemlGh2R26Aqk
         xVx1v2Zb58td4GFxJoLrT+MpAEncGCgXLC8gIKPisRWmOTauNU5nCitiRof/KrlqBzZM
         5RdqHI3R7A7CVDwPJm00AOr5aQbnZErYvgZ6CCAAZHf2ErayCk6oh61R5d8logqDXRlX
         YH2nA94TOU3duHYrhDsJCmMMN97L0W2WUOr9fMs/RWqkhdYtUCRCKmSpknnmI2jXEUcA
         mpeDm8ZLg7I2stJCw9bweZ3ChptvCHJmNX6epdaI7W0NBYQxusEz2Bo6dR93dz9EKEQE
         tmcQ==
X-Gm-Message-State: AOJu0Yzp9JUuVi8+Xsz0jIBleWqCeFN+GxSHS+HfSFRuYNSdQf41ybqy
	ias7X5dob1hh30PB7SDQ8Nsh3dB4kW8MtSi0r2R/eNdV5JjvVDK+khg8xmot0oTscIGk+sCxJzv
	aZA==
X-Google-Smtp-Source: AGHT+IHktkXZ3RvXifEjmjETa4vTjpVmQp9Hs4/ZkuOBFXaF0+ekg7ATFuDxNEhzDH/TUjSiGZFcgQgAWKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:5556:0:b0:7a1:6633:6a07 with SMTP id
 41be03b00d2f7-7ee4107c403mr8192a12.2.1730486159703; Fri, 01 Nov 2024 11:35:59
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:47 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-2-seanjc@google.com>
Subject: [PATCH v2 1/9] KVM: x86: Short-circuit all kvm_lapic_set_base() if
 MSR value isn't changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Do nothing in kvm_lapic_set_base() if the APIC base MSR value is the same
as the current value.  All flows except the handling of the base address
explicitly take effect if and only if relevant bits are changing.

For the base address, invoking kvm_lapic_set_base() before KVM initializes
the base to APIC_DEFAULT_PHYS_BASE during vCPU RESET would be a KVM bug,
i.e. KVM _must_ initialize apic->base_address before exposing the vCPU (to
userspace or KVM at-large).

Note, the inhibit is intended to be set if the base address is _changed_
from the default, i.e. is also covered by the RESET behavior.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 65412640cfc7..8fe63f719254 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2582,6 +2582,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
+	if (old_value == value)
+		return;
+
 	vcpu->arch.apic_base = value;
 
 	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
-- 
2.47.0.163.g1226f6d8fa-goog


