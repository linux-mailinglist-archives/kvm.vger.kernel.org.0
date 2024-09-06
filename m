Return-Path: <kvm+bounces-25987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D794096E8B5
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 06:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3752DB2392A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 04:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895DD148FF6;
	Fri,  6 Sep 2024 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OwcH8E/j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5126013DB9F
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 04:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725597271; cv=none; b=NWjBZEYDt0z78idf5iB1V0iwVhdtJlPjNuD0EhBfurt09iPIQhx4eIPyJBWsOgZR1YXRm5X1wxxei++ag+J9O8iFtUpmHUb33w0siMCKbiH9v2BIv23j6IDHA5zqqbvDaLiDH1MeCom3YOXia27fWLh6L4c4zCyEbqOhxImFHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725597271; c=relaxed/simple;
	bh=KOuZWdc9JPRpBXVKGqAv89lMSGg+kGyVbTW1GAwZ1wU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T/H7uE8EBcQ9Wn9zuHw+FvcdmTurFQaYbX/WQDdOh1owK1a+p6VirjqtZJcdyJwfxPJxc5PwGpgQZPDHpjLhKPWR+7A1+wCCXYpKh538lmw4+8mETvczN9QpS7FxRJpYz1ihSIBcprU8wpw7t7qxwpmhYBVqXRM86WR6++MmF8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OwcH8E/j; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4fc1a2bb7so2223059a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 21:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725597269; x=1726202069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YYgMGUi3oxiD0kO1ugWhSXeqKUt6BlZh0E2W4sJdCss=;
        b=OwcH8E/jVBgRIUhB739yDghDvswotReeUXNvXUbZ009xWuvcWj8LsFNC09WINLr7xK
         qWI9zyB8lQ7nz5x1jjHecDtqWoNbcSmOPTv2Mh6QvomyvrWiZsRMJyPOTH0me0bfRYVj
         WkYeJg1q3R7KdwthmQxeUyVyY6rCiHgPCySjdI4AyqtO8v0Y5MdEJHoC95sCUNJmo/OC
         YWuruJAZsTp8nZdTfVKgN+OQmSMZsTwus4Wq+LAC1rTfUdKNEBEECIGcuf+iqQUZ8qKF
         FtrYYjWXoUzTQHnNmIJ/LWeS+jpHd+HnYv933F7NK+Y7+lidx7v4yKREWadSIRKRlMyp
         a8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725597269; x=1726202069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYgMGUi3oxiD0kO1ugWhSXeqKUt6BlZh0E2W4sJdCss=;
        b=K9Sn2wCO9j4ym1QgpXipMAZAN18yLIt/fyiwy1FjRTrc1xgpHqEKC706aS5ZuL91Op
         ENIuzxjXD5faT9mO3+pwZ/eRPoLTSBxpvVhgHRFTCr6sq6mldvSp5CoTT+4jvgJHuz+U
         iQFHSWISoTAbYfxdUZdDj4dd/nYh05TXh2v0ND9X4WpHLe+NqtyYNo+CuxV2rYXCM47B
         WSK2eC2SRbA9JRc/Il5Vqc1bMTfhZo2ux9ndn5HRGisAStn+HXRf+4ivdb6wrRB8Y2Tb
         IEog+8uZH+IbCtkUxPzrjL3mOPagSSrabY+3tfvoCu14WeAtqt6ni2tUIwKD/ErW6S9X
         0hyw==
X-Gm-Message-State: AOJu0YxqnpEupHyohJVdUJVrbsW8oApUO2mWC94mLA0DjHNyFwODLWmB
	uYBwkc7p3LIh9WoVVenkDltH3ZZsegB2nKFN0f3Lbx6k1q0B8H8/SG3ybDdoMsHwNTAnGo81PR/
	M/Q==
X-Google-Smtp-Source: AGHT+IGIG/2AqeejW/EiNPsvj7vZAMKQLNqM6dC/eSPaVhlrS/jIejMZxR/29yan4Y6HwPe+cS1JZoSR8O8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea09:b0:205:560d:947d with SMTP id
 d9443c01a7336-206f0603526mr1127025ad.7.1725597269489; Thu, 05 Sep 2024
 21:34:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Sep 2024 21:34:12 -0700
In-Reply-To: <20240906043413.1049633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240906043413.1049633-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240906043413.1049633-7-seanjc@google.com>
Subject: [PATCH v2 6/7] KVM: nVMX: Explicitly invalidate posted_intr_nv if PI
 is disabled at VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Chao Gao <chao.gao@intel.com>, 
	Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly invalidate posted_intr_nv when emulating nested VM-Enter and
posted interrupts are disabled to make it clear that posted_intr_nv is
valid if and only if nested posted interrupts are enabled, and as a cheap
way to harden against KVM bugs.

KVM initializes posted_intr_nv to -1 at vCPU creation and resets it to -1
when unloading vmcs12 and/or leaving nested mode, i.e. this is not a bug
fix (or at least, it's not intended to be a bug fix).

Note, tracking nested.posted_intr_nv as a u16 subtly adds a measure of
safety, as it prevents unintentionally matching KVM's informal "no IRQ"
vector of -1, stored as a signed int.  Because a u16 can be always be
represented as a signed int, the effective "invalid" value of
posted_intr_nv, 65535, will be preserved as-is when comparing against an
int, i.e. will be zero-extended, not sign-extended, and thus won't get a
false positive if KVM is buggy and compares posted_intr_nv against -1.

Opportunistically add a comment in vmx_deliver_nested_posted_interrupt()
to call out that it must check vmx->nested.posted_intr_nv, not the vector
in vmcs12, which is presumably the _entire_ reason nested.posted_intr_nv
exists.  E.g. vmcs12 is a KVM-controlled snapshot, so there are no TOCTOU
races to worry about, the only potential badness is if the vCPU leaves
nested and frees vmcs12 between the sender checking is_guest_mode() and
dereferencing the vmcs12 pointer.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 arch/x86/kvm/vmx/vmx.c    | 7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 238c26155c2a..7e8a646e2851 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2317,10 +2317,12 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 
 	/* Posted interrupts setting is only taken from vmcs12.  */
 	vmx->nested.pi_pending = false;
-	if (nested_cpu_has_posted_intr(vmcs12))
+	if (nested_cpu_has_posted_intr(vmcs12)) {
 		vmx->nested.posted_intr_nv = vmcs12->posted_intr_nv;
-	else
+	} else {
+		vmx->nested.posted_intr_nv = -1;
 		exec_control &= ~PIN_BASED_POSTED_INTR;
+	}
 	pin_controls_set(vmx, exec_control);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..63d656032384 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4219,6 +4219,13 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	/*
+	 * DO NOT query the vCPU's vmcs12, as vmcs12 is dynamically allocated
+	 * and freed, and must not be accessed outside of vcpu->mutex.  The
+	 * vCPU's cached PI NV is valid if and only if posted interrupts
+	 * enabled in its vmcs12, i.e. checking the vector also checks that
+	 * L1 has enabled posted interrupts for L2.
+	 */
 	if (is_guest_mode(vcpu) &&
 	    vector == vmx->nested.posted_intr_nv) {
 		/*
-- 
2.46.0.469.g59c65b2a67-goog


