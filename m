Return-Path: <kvm+bounces-23127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 758FB946436
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:04:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9895D1C21841
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D77E6F068;
	Fri,  2 Aug 2024 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3AMonfGW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C07249EB
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722629064; cv=none; b=t74d/+oA0bTP6Z77UNtD9+LUwJv2G66qb2kAwF1Eo63y1DpihhooLLIbR5OgfEGV5qfaqVw72JrfIjqCGrjGVWWsu0g//N1vd556it9kEffMGnpvhh7cmXwbLxMwqV3ZQ7+mjU2b2Aig6IAapl/29oFHVTfde7hcrYgiOCnm6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722629064; c=relaxed/simple;
	bh=QKWhYz0UvagZTgqAREtRaLHDQPE2mg4rSmdG2Y/zeNw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FAhgYIxlDeCoW61Nsnrt5qICeKol+LcttHvfGck7GZYB1IlGbH8YLmpVC1CUTGO9KU4vJlSZhmPlLfUEhmCVBjdZauRudIoOOX2x0Q0FGXPs/yaNLoh17BAV19QuCLpeOd+tFCUkq/R+J61IzzbftWFiZ/Dl9vUQ0DblXTQYzAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3AMonfGW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc6db23c74so85445365ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722629062; x=1723233862; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywJidtx+i69imVBTLQoKHViS/i1c8qwbY9qpH2RYPhY=;
        b=3AMonfGWwIC7uQTCcMfO+uMJMurcEVRxd4UQot4+iUGPZygau2jzKSy6e8qp1+AAsq
         GHcHZ3YzhYdmzTSB5u6uSGSmHD0V7Hvo+ZX+Q3N8cSMYOsjEUGMXpR11WjOvP2Wo/73Y
         3GT8cLgXk8n0hD1yBu9whJ8rSC5y70yk6j4F1J4bzPF3JSgDaDD2tNCatLStLRCjy4CN
         YiOSjq4iOxOUUm2gdQLSd1qmXpjg0pBqrRGWzr9ap0nYugbZSr5s6t0Hpfg/KMjZy3vC
         7UxLmq0zSFuFMEjOSDnQfHB3dTaPLGZYNuiWhcVFy2WCA7FXnXxqrI36ktdx9FtbPsVG
         /mOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722629062; x=1723233862;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ywJidtx+i69imVBTLQoKHViS/i1c8qwbY9qpH2RYPhY=;
        b=G/dqm0gh1OEe6wo5lp4eK9lbiZOBqF2g7lqok95Ru8CLcFiOlRQhJfBpDp1mzHlWc1
         R8bi4eApDYScFZBWnbg6W8JKghuCml9fmnTk4JeTxIjaVFUjkuS+/TODRTvASTif34YI
         +jrwj9hAUXzoPHAG6OqeMHiZncekn/UIV//8GsMpxlLM5RmLPUgW+XFTDIeWtuwaAm0B
         prKkQNcCHTqZrgXJgN/06ikJ/HR5ote2Yo6mCQzJF0MZVaLuwAYvlNw3kunIzEe6Bcdk
         mdgew8coZ9G29qo/hmi9+MI/TvdeuoTc/Xo3WQNieaX7S/wWNwvkIVHzOjoLzKye5OiF
         kgWw==
X-Gm-Message-State: AOJu0YwYnzzFQLbJI8CLGwgxnEeoSJPebpIMnt2zKbn4iHKguavrDmAS
	uFagFvfPb87DD/aYW20boLK3e8Sys2+aljQaKq5oGC2+Ad9dXeQfHYH5b46doy+vaJoT+1M2sg/
	XCA==
X-Google-Smtp-Source: AGHT+IE2pF+g3rRa7FDBgrB2Sw37x7RTKPyzV3G2a0NsUAKnKECEoNESeCZwkH8292lIkcUwB4mlfYp6BNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac5:b0:1ff:4a01:43d1 with SMTP id
 d9443c01a7336-1ff574efccemr3340415ad.10.1722629062194; Fri, 02 Aug 2024
 13:04:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:04:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802200420.330769-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Document an erratum in KVM_SET_VCPU_EVENTS on Intel CPUs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Document a flaw in KVM's ABI which lets userspace attempt to inject a
"bad" hardware exception event, and thus induce VM-Fail on Intel CPUs.
Fixing the flaw is a fool's errand, as AMD doesn't sanity check the
validity of the error code, Intel CPUs that support CET relax the check
for Protected Mode, userspace can change the mode after queueing an
exception, KVM ignores the error code when emulating Real Mode exceptions,
and so on and so forth.

The VM-Fail itself doesn't harm KVM or the kernel beyond triggering a
ratelimited pr_warn(), so just document the oddity.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/x86/errata.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 4116045a8744..37c79362a48f 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -33,6 +33,18 @@ Note however that any software (e.g ``WIN87EM.DLL``) expecting these features
 to be present likely predates these CPUID feature bits, and therefore
 doesn't know to check for them anyway.
 
+``KVM_SET_VCPU_EVENTS`` issue
+-----------------------------
+
+Invalid KVM_SET_VCPU_EVENTS input with respect to error codes *may* result in
+failed VM-Entry on Intel CPUs.  Pre-CET Intel CPUs require that exception
+injection through the VMCS correctly set the "error code valid" flag, e.g.
+require the flag be set when injecting a #GP, clear when injecting a #UD,
+clear when injecting a soft exception, etc.  Intel CPUs that enumerate
+IA32_VMX_BASIC[56] as '1' relax VMX's consistency checks, and AMD CPUs have no
+restrictions whatsoever.  KVM_SET_VCPU_EVENTS doesn't sanity check the vector
+versus "has_error_code", i.e. KVM's ABI follows AMD behavior.
+
 Nested virtualization features
 ------------------------------
 

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


