Return-Path: <kvm+bounces-48041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC00AC851A
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93A54E5BF1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCC22222C4;
	Thu, 29 May 2025 23:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qrt1n8kB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A3125C6F4
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562027; cv=none; b=gR1pAejRalRyh9AkXV19dY+Q7C5Rmpu6iYnkPFZ10kkB9C6crxWKnI4+0HxgbwEdVCXIgMjg4PUUkH0KPsU8aqsPjfLDi4rm0IQT4WMxl8FsAQWeVzbNvoRkCBz476qFFZynAFHNWfn5de4vG8S+x2O3PLq1CnWF7lSnpwS/uHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562027; c=relaxed/simple;
	bh=R9kmG10AvZPVWXlViRQh79Glnff5btnA7FS3RQ7ftyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eOwnWEZgWjVGCTN1zdhszyerrcZp1jHinlp2IzAbo55Ls3sfm9Vsi2/JvP2KDbvmfj+C8o4aAdowHts+LK3WGCSk116gzxQUeIauoFetQyUhCiRrHm+/z8iJWVuDe+LPG2PuFNF2Lw6GlVLBIxfvsX9p5w3BRU01N3zqUr05JRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qrt1n8kB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so2003253a91.3
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562025; x=1749166825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k8a4gJL7fJcV15lMkFBdSF9xzzqc6lN6bgj7noYkucY=;
        b=Qrt1n8kBBl/wivaOQ4RN22O4e3AIHQOHJEHKiYbYW7gw8wUxgrqsdoCtnboaO30Fly
         Z0QD643P4YQmaRhep8Di+DbRWmeWFJIZKDaMpeRB723aXHU2B8UakVPuoGi8RL5++UjH
         Xxsvf5NJNoYwdTvDBVTj/Vt074hANl6hxKLrCZ4taUCweWs9WXNGvQ4ZEnegp0anaKpD
         lKbaaNYIGhtwJPEAlooup9r4sfFEZ0G8R6GX+u2azGS0JVGy8+D8YQYjo++AL4IECO+Z
         dnTzxdHC7OD36Nw4Xo2zuf+UioS1yses/YZG4J6Z7ZbaK2XA661xrbuLKiRL54i5b6li
         i6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562025; x=1749166825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k8a4gJL7fJcV15lMkFBdSF9xzzqc6lN6bgj7noYkucY=;
        b=QlOCjligPIOGI6CK0jjFN88nQreHMuEqV1C9T/wEZnfbbxNzIX5y/aPyT1meBImyn+
         PulY2fqGwvBU9WGu+B+Pwh658BP/73nZLVAWkmX0mCTXs1s4MkDU1CiuaGgUwSop0Nbz
         PcpXFzsuEsG2usXAeWQT8F4cEg1Iry6brHrpR+/H2jChjqI2QR8tBdO2WiHq1Vy9gdcK
         Xsaln+Hu5zKo2Pp4QH7ag9hlQ4Vri8VerO4Yg6emLLkcwAsdto7Tm8CIubJt0K3Ez/EI
         l1gkz9g2yM5S54jN/TtUY3VOUbeghaG+MsPzn0Ckpdo6t88lwK0J7YcZ0lHCpimSn7ot
         u3wA==
X-Gm-Message-State: AOJu0YyX0Aw6TAm4we+IYh+2g84IhCcKnP1R4+pd++oviLmQ9K3GbVBB
	VwJNdUAy6UXcHnoW6zv02PlZtbD1qbQfPvQQQ3yCjUxdFNmQewjTZmkjxiA+pNhdvTqjGbobVjO
	fYEuy+A==
X-Google-Smtp-Source: AGHT+IFj6cpdwvMfiw9kPdC2HGBBg9A8aQ6NLpVwCunBULWlARIElrxcMVdLA9b7L/QecHTLXJCqJ/sf5QA=
X-Received: from pjbsv6.prod.google.com ([2002:a17:90b:5386:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc4:b0:311:afaa:5e25
 with SMTP id 98e67ed59e1d1-31241865ecdmr2041979a91.24.1748562025571; Thu, 29
 May 2025 16:40:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:39:50 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-6-seanjc@google.com>
Subject: [PATCH 05/28] KVM: x86: Use non-atomic bit ops to manipulate "shadow"
 MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Manipulate the MSR bitmaps using non-atomic bit ops APIs (two underscores),
as the bitmaps are per-vCPU and are only ever accessed while vcpu->mutex is
held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5d11cb0c987..b55a60e79a73 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -789,14 +789,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
+		__set_bit(slot, svm->shadow_msr_intercept.read);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+		__clear_bit(slot, svm->shadow_msr_intercept.read);
 
 	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
+		__set_bit(slot, svm->shadow_msr_intercept.write);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+		__clear_bit(slot, svm->shadow_msr_intercept.write);
 }
 
 static bool valid_msr_intercept(u32 index)
@@ -862,8 +862,8 @@ static void set_msr_interception_bitmap(struct kvm_vcpu *vcpu, u32 *msrpm,
 	if (KVM_BUG_ON(offset == MSR_INVALID, vcpu->kvm))
 		return;
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	read  ? __clear_bit(bit_read,  &tmp) : __set_bit(bit_read,  &tmp);
+	write ? __clear_bit(bit_write, &tmp) : __set_bit(bit_write, &tmp);
 
 	msrpm[offset] = tmp;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..8f7fe04a1998 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4029,9 +4029,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			clear_bit(idx, vmx->shadow_msr_intercept.read);
+			__clear_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			clear_bit(idx, vmx->shadow_msr_intercept.write);
+			__clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -4071,9 +4071,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			set_bit(idx, vmx->shadow_msr_intercept.read);
+			__set_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			set_bit(idx, vmx->shadow_msr_intercept.write);
+			__set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
-- 
2.49.0.1204.g71687c7c1d-goog


