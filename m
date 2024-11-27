Return-Path: <kvm+bounces-32593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E399DAE74
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 346A0B229B3
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47542036E2;
	Wed, 27 Nov 2024 20:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JQXbZd4K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FB2036F7
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738800; cv=none; b=S7h7nEfoiMbAwt5eWxQ/Ij6sNo6sjJN136rs+96TSCd4qOwFCVToy7hNEiT8Bi37zIYYwKd6pQkBcckrUXN6UrMrE96u2kdWfujIHldPM1OQU9xrEPvHI5c4Vqws95ZGEMgcimzz+QEM1NHtbGHduLRzDfl+5cZQDOLe1Xo3QcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738800; c=relaxed/simple;
	bh=y2FN9r7ugbV5qha0nZVbYrWu0Zt8xbdSyx6wL3Pf/V8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DTKiL386EbpnMnZ7hSHb+dInCMI2GAaBOSZB3mAQBnwubbZXvcSD+CQ37j2EBqF6k+spam4Ke3B2wP3dsbB9aP6rLuaFheXBAOnubj2UmXbr9NxI3f8H42LZA7ruFrNOjbb+8Weqrc4y/KFC8/SedBrC1FxvNxSahJCg5si6YoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JQXbZd4K; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea46465ce4so146492a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738798; x=1733343598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ay83d91yLBygZMe29qkA3QWrnm4hDElp535HS+RqI+g=;
        b=JQXbZd4KO9ibvbluLxM1iRSHMuG3EVTY2OV0dpbAm2H/pHftOpREkCIFTAavvF12ED
         zvg0MH2lUyP0FiGbGGWLy7PFMSv76bWoHyYbKfpnYW4yAoQ27a99leIx1iB61diZ8nwo
         5PiMBhrjaZD995dTIFCiqHxOebJR3cYU3CPp/nSHjt+1MPxIGkREm6qEeOKzbVOFz89A
         x4jKPByGW607BS7gNGePoTKqXHCB6PjP2khmtgrrJdsaDAlKS9WSkYhEF1kBjTsC+n4H
         U6V2ic50ivlRddGvmZSDI3W5v3GIlytoj4LHnX8D22DWmd1xljMwr3l9KKMmjn7vfyu2
         yWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738798; x=1733343598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ay83d91yLBygZMe29qkA3QWrnm4hDElp535HS+RqI+g=;
        b=e1XjsychswNYZMiEFv9vEPoSiHmHnzywlEctTF/EYFJ6ErUY1Y3TIKKUq6GG4GyW8G
         lq/b95uyJCqN2RDpEn+GrTxKF6EVEcm+N5nfpFn5L1hVai2gHQPzPpr2RGELDg03SZjW
         1cm3pa+lIg/fFs6bqrr5hA8Q2Rr7nYfbYJsIEPhChSP9gDDM+SsKKuGEf9AU78ns24j2
         uSMCHd5jzr7ON2EtakPSp89YfDhAI0THxTr47pN9TW1Hi5qQvoV4rus0fWs7175c7ROy
         aJ5fA0ROGWi2t9LmzW+I+HHTE7uu4GT5KMHtpGGWIKyTI8FMHWMFoQGuXzF3C44c7FcM
         NOTg==
X-Gm-Message-State: AOJu0Yz5a5ASPjRQ6pQ1Tlj6ZlAV/uC1HGiPNxjX3aL7FU0ozezjvet3
	ZTk97Ktm5M3ROL053bPJ4L4GA3BZqbJIiWHJ2bqmQ0cTbchDBlsyY2iBGdGs1Tq9gNJx1H3gfMk
	rIPjzZbgTfM8EP5ggFulNjZ7cbcoFvLzHk1bzbrkqQfcIMeQMPgzjW2eKezla4F7OI9ntUFWbJG
	+ffGjvwRCp/IO9oTAyO8RFHbgOyMXItu3IfnQAHsm8W/UeK6UTOg==
X-Google-Smtp-Source: AGHT+IFtRlDulV0vltu4nNvYU/EjvZzV9Huxgq+br6DUuYALoGcXW5/lsXwGyuScv9Xt170kV4+LwwwNX1E7I2vm
X-Received: from pjuj11.prod.google.com ([2002:a17:90a:d00b:b0:2ea:7d73:294e])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d01:b0:2ea:7bb3:ea47 with SMTP id 98e67ed59e1d1-2ee094cb157mr4671706a91.28.1732738797907;
 Wed, 27 Nov 2024 12:19:57 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:21 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-8-aaronlewis@google.com>
Subject: [PATCH 07/15] KVM: SVM: Delete old SVM MSR management code
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Anish Ghulati <aghulati@google.com>

Delete the old SVM code to manage MSR interception. There are no more
calls to these functions:

  set_msr_interception_bitmap()
  set_msr_interception()
  set_shadow_msr_intercept()
  valid_msr_intercept()

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/kvm/svm/svm.c | 70 ------------------------------------------
 arch/x86/kvm/svm/svm.h |  2 --
 2 files changed, 72 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37b8683849ed2..2380059727168 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -770,32 +770,6 @@ static int direct_access_msr_slot(u32 msr)
 	return -ENOENT;
 }
 
-static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
-				     int write)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot = direct_access_msr_slot(msr);
-
-	if (slot == -ENOENT)
-		return;
-
-	/* Set the shadow bitmaps to the desired intercept states */
-	if (read)
-		__clear_bit(slot, svm->shadow_msr_intercept.read);
-	else
-		__set_bit(slot, svm->shadow_msr_intercept.read);
-
-	if (write)
-		__clear_bit(slot, svm->shadow_msr_intercept.write);
-	else
-		__set_bit(slot, svm->shadow_msr_intercept.write);
-}
-
-static bool valid_msr_intercept(u32 index)
-{
-	return direct_access_msr_slot(index) != -ENOENT;
-}
-
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
@@ -824,50 +798,6 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return test_bit(bit_write, &tmp);
 }
 
-static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, unsigned long *msrpm,
-					u32 msr, int read, int write)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u8 bit_read, bit_write;
-	unsigned long tmp;
-	u32 offset;
-
-	/*
-	 * If this warning triggers extend the direct_access_msrs list at the
-	 * beginning of the file
-	 */
-	WARN_ON(!valid_msr_intercept(msr));
-
-	/* Enforce non allowed MSRs to trap */
-	if (read && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ))
-		read = 0;
-
-	if (write && !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
-		write = 0;
-
-	offset    = svm_msrpm_offset(msr);
-	bit_read  = 2 * (msr & 0x0f);
-	bit_write = 2 * (msr & 0x0f) + 1;
-	tmp       = msrpm[offset];
-
-	BUG_ON(offset == MSR_INVALID);
-
-	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
-	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
-
-	msrpm[offset] = tmp;
-
-	svm_hv_vmcb_dirty_nested_enlightenments(vcpu);
-	svm->nested.force_msr_bitmap_recalc = true;
-}
-
-void set_msr_interception(struct kvm_vcpu *vcpu, unsigned long *msrpm, u32 msr,
-			  int read, int write)
-{
-	set_shadow_msr_intercept(vcpu, msr, read, write);
-	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
-}
-
 static void svm_get_msr_bitmap_entries(struct kvm_vcpu *vcpu, u32 msr,
 				       unsigned long **read_map, u8 *read_bit,
 				       unsigned long **write_map, u8 *write_bit)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index b008c190188a2..2513990c5b6e6 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -612,8 +612,6 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu);
 bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
-void set_msr_interception(struct kvm_vcpu *vcpu, unsigned long *msrpm, u32 msr,
-			  int read, int write);
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 				     int trig_mode, int vec);
-- 
2.47.0.338.g60cca15819-goog


