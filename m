Return-Path: <kvm+bounces-19612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 463CC907BEE
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60C11F22F09
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F41C15217E;
	Thu, 13 Jun 2024 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYca01sR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E3F14E2F2
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718305268; cv=none; b=eRkx/DWO0V0wl5T5+BiWQpFv58lY9HXvGJNGMINBlMWZ+zUvKAwrMXgZCcx3MptE/5D082BIB2FGL4IsHzmFkjHOtZSNaOq60fu+46DYbTiqzkF7DFdUATm9SlxcrIDx54EzleOX94wUsvaL99zDvVB2TxN3QQE++uvkjdT4+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718305268; c=relaxed/simple;
	bh=EdM3NFAHtqf7iO6j5P+sTJg6E55g7ZvNba3lzMdLcdE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bYHqS4+KcNKUMBRsF94QMHckpacYjQcQmf0HTwfbMFqI2VbItbeLfL1tr1rQdPxnK9ffRon1H2v9Nqqa9En9UDUQ9Ro7tv6tye+dCAAm9wegRvsj9OqD/MenRvSXjOFGDFjHnkxcpK5wJylZxkJIFghsrm6Ke0gQDmYNP+tFX7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYca01sR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62cf0ed7761so26717807b3.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 12:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718305266; x=1718910066; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4scoAI3xWobVP6E+XRq1RKOC326O2un8fjhuaP6CeHI=;
        b=qYca01sRmt9Aj9brAT+UPLIs7l0+oYKqRqCdLIFggseMPqFNIvCGdQKYzu3G6LkuRf
         /6IXUddcTmCvfrhLk+OKM7VPwHlga6pXoBhVev3J9CEn50qyZH9xA/OERr0AIXYu6eIQ
         HmN4mVEDGQ0om0bLFmUIQ+HOtvgfhTZIZXW4sqfy9LGH+TmTT/5zm5gZdAsMFzLFPb5N
         LgD1sRo3jvYXQCoQKfsuerzbTFNBITMNqF1S1cyT6Rec4SVBYlkdWiP1MuowViX/IV3b
         zjWyZzIlgbu0CeJqHuQXKILlTCfXw0sitpV+e2bA+HCL1XqxFyzeMx47UUnk3i2cf/S7
         /XIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718305266; x=1718910066;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4scoAI3xWobVP6E+XRq1RKOC326O2un8fjhuaP6CeHI=;
        b=L52/SUymcEKP94/nBUvET28a838CZyTb1MDkIOV3q29NRJH3ppCwmHt9cZp5fOBAoF
         VfkRQNGbjDJFj9PgLj3qOjOzCH2UN9WgJgSyzuy2pbkYobi7Df92u4N0LTP8CC3iHwUw
         xRfU6MRs1VhcWz0jpPiAW7wYAkt1cSwZX/dB6nzSvO0fspHAN0hzYxZWC5M/w8/SqL96
         Mm3JzOL+owW9DMRJA/v0ZJ+gjNDFRe7/9vYJ2Rs7dHS0/mM4rA9MWtg6Msaqu+DnV5SX
         6onFJcr9d3D+/VAVtJvp6+onplpdmQh/7X4a/VCZ8Mefcjfac42iQ6I9EszxKxHT3/9v
         Vq7Q==
X-Gm-Message-State: AOJu0Yw3w7c1uGvHH9qkivS2TIzPwiKbalAyS3EXqg4KQNGUkim0xo5r
	+xL3WMwWslj8AuNDTpIXXHE7X733BNy/ZGhnlElntkvpP59IWQrvCKtTkJLZuHREXcN+rgzrw/5
	PFw==
X-Google-Smtp-Source: AGHT+IEz/kaKBHJHUJSiWymGtpYz5LODHuIW1raDtRMykoNrYAMEWe+IYh3gOJ/yB9zn1NGxXheewdBDEx8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bfc7:0:b0:dfa:ff74:f262 with SMTP id
 3f1490d57ef6-dfefed12278mr647712276.2.1718305266142; Thu, 13 Jun 2024
 12:01:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Jun 2024 12:01:03 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
Message-ID: <20240613190103.1054877-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Update VMCS12_REVISION comment to state it should
 never change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Rewrite the comment above VMCS12_REVISION to unequivocally state that the
ID must never change.  KVM_{G,S}ET_NESTED_STATE have been officially
supported for some time now, i.e. changing VMCS12_REVISION would break
userspace.

Opportunistically add a blurb to the CHECK_OFFSET() comment to make it
explicitly clear that new fields are allowed, i.e. that the restriction
on the layout is all about backwards compatibility.

No functional change intended.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmcs12.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 01936013428b..56fd150a6f24 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -188,12 +188,13 @@ struct __packed vmcs12 {
 };
 
 /*
- * VMCS12_REVISION is an arbitrary id that should be changed if the content or
- * layout of struct vmcs12 is changed. MSR_IA32_VMX_BASIC returns this id, and
- * VMPTRLD verifies that the VMCS region that L1 is loading contains this id.
+ * VMCS12_REVISION is KVM's arbitrary ID for the layout of struct vmcs12.  KVM
+ * enumerates this value to L1 via MSR_IA32_VMX_BASIC, and checks the revision
+ * ID during nested VMPTRLD to verify that L1 is loading a VMCS that adhere's
+ * to KVM's virtual CPU definition.
  *
- * IMPORTANT: Changing this value will break save/restore compatibility with
- * older kvm releases.
+ * DO NOT change this value, as it will break save/restore compatibility with
+ * older KVM releases.
  */
 #define VMCS12_REVISION 0x11e57ed0
 
@@ -206,7 +207,8 @@ struct __packed vmcs12 {
 #define VMCS12_SIZE		KVM_STATE_NESTED_VMX_VMCS_SIZE
 
 /*
- * For save/restore compatibility, the vmcs12 field offsets must not change.
+ * For save/restore compatibility, the vmcs12 field offsets must not change,
+ * although appending fields and/or filling gaps is obviously allowed.
  */
 #define CHECK_OFFSET(field, loc) \
 	ASSERT_STRUCT_OFFSET(struct vmcs12, field, loc)

base-commit: e4e9e1067138e5620cf0500c3e5f6ebfb9d322c8
-- 
2.45.2.627.g7a2c4fd464-goog


