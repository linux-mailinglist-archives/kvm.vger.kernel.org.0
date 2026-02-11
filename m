Return-Path: <kvm+bounces-70834-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOKaJ9BajGkOlwAAu9opvQ
	(envelope-from <kvm+bounces-70834-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:32:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C6D123642
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 11:32:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74CDC3092473
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 10:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8527F369226;
	Wed, 11 Feb 2026 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkBNbmPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E7367F4A
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 10:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770805779; cv=none; b=iQJQANRDUln69D0gmDipWrFb+LD9P3BD78sp+Z5ySNMA0KQRlX8OFVt239PvlJ1olOGDBJVj5GI5EQdanjU37bfzT8SdgYxjEA2Nm2rfLwdbdP2arUn3h6d3Hbqc8kStBB49ajCeU5B4Ma7laXZoUHQoTv7Fmvt0BhM6WQ+5fs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770805779; c=relaxed/simple;
	bh=0Wc4AB3lI0fSSCvfIfVGJFHg64rgJGr5MMnsZr8E2gY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CEeX+nc0GHE4bL/b7djHAq6tN4WjcOYDLFrcSlL8dKPKsfDBzfTEetd6hB2W+buHy1oP0Loh3mce2TJgXS7+f2BJamgqRH9gz000+iut++7e7OeUX/Sk5AjDj3bhcn4Qex7DeUL5lUYAFQVuqB0QUDRpG99AIKHX1KNX/FaPZvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kkBNbmPF; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47f5c2283b6so15366845e9.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 02:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770805776; x=1771410576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBi0k7VmL2N/a1BKjZT7tKsE7z2ULOdybCxiTuhC99A=;
        b=kkBNbmPFhEWTiLElTEVnSKdzZHddibIwF23H2oyLhbQz27k+ZyJAz2MCXxOh5+tD+x
         LRd/PoZmBu+y7GaHC3Mic8dilUUVRjsWe98R3mLkGA+H7TnNhctSAzOicvRzUBI1Hpor
         IsdcDzyiwz8jGxC26xa0hOWIIkzaDW3suE/jXIZKyjiZzepqixqM6BB35IEkGr5gQ5Ff
         hJtpvmpRaKtXCCIo54X6mkkeGZT42VdklJNI2kHepqoajhU4rBTmEikb5vug9c6R7Doh
         d3d/mjWcufqhqad4s40lpoCJMwod7Symu84wc8VoBh0aGep4ubE/rRJ/ZTHxEBiylNae
         hT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770805776; x=1771410576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBi0k7VmL2N/a1BKjZT7tKsE7z2ULOdybCxiTuhC99A=;
        b=QAIBVRKy7KTlyUqfNkChDWQFkG6nbAbhkjjf54YrYkIaLV32kh8o0gfDFGXZs+2Mpg
         xiqInxRg0kaLgSW8NFmeadLRivr//hbBvbAj0a9CNUV+BRERzOlK1L43oQKoPiCmEFfr
         aWomR3qgZOiosgw0tkV+/0PJ3yBmy+DoDdDCyoghVMMq+tEk/RvFcOpcgUejaN0RW+5u
         FRq3tmOtqDfD4RwH3KZVMtXJLr4FS5e1OW+pKmopZcv0acls3YaZc4kxwMKKyQuEWh2v
         ot1uslDT3QINPO0j5NYYLDnR09YUjD1hpkUZoHO+rsBNYoUvR5i65h1xKkm8OGIi2Zfx
         JTLg==
X-Gm-Message-State: AOJu0YwKMnSJXBN2sAc9k/rtPA7Mrzm/CcrEkFnra8Gz0kPGUCVy637H
	zAxaYjbZ2P3xiQgWdYnymz0LF4yc81tb65XoffAdzbarR4/FUNM6CosMVmLelQaQ
X-Gm-Gg: AZuq6aK48IFc1Pn3Nsa4NhlHRMZG7X3L+VyBfMwPHNueR3M3wsWmfMjKZkArEfaIVJ2
	6dSYync8j7+sLJl9OWScJf2zZmBPHliZkU/+KcueEo2aTjDtGk4mRz24T9Rc/Lsb6q6H9ux3Vpk
	fdPXk8RItGKIPjHeD+wEkGpR0yVi+QFWg3TfP9rJpPO7eA/iodGwyxCBao6izJTgWxbquk/aVNR
	kFAyebUfcORHPW1uZ4I9PN9mJ7WafB2Sj8m5w4Op6bhIDDMSllluqWxiYiimVyyCWAfrP6wc9ky
	GsuxWatbd8owowvybd5/0PVaaFa99PKaMhP/Rt8Rwdw1Aoa3IRmvnDyUEQLUY9aXVGBrVLfIbal
	uB06rMg9AE4qeOuo7IYmmSd00aE8cP/1QYrIkLrazfEU/VAWPG7hiagzx3IT1hIQ8yAd7FSkCn0
	55qM5OIdKjbJlngcMPKvgcxEY8q/NOJlymNTMn4l6x69fDpNsjqahVKbo=
X-Received: by 2002:a05:600c:4f54:b0:47d:403e:9cd5 with SMTP id 5b1f17b1804b1-4832020df4emr218000585e9.11.1770805776141;
        Wed, 11 Feb 2026 02:29:36 -0800 (PST)
Received: from fedora ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d930902sm102500575e9.15.2026.02.11.02.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 02:29:35 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from inline asm
Date: Wed, 11 Feb 2026 11:28:49 +0100
Message-ID: <20260211102928.100944-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,google.com,redhat.com,kernel.org,alien8.de,linux.intel.com,zytor.com];
	TAGGED_FROM(0.00)[bounces-70834-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ubizjak@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 06C6D123642
X-Rspamd-Action: no action

Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
inline assembly sequences.

These prefixes (CS/DS segment overrides used as branch hints on
very old x86 CPUs) have been ignored by modern processors for a
long time. Keeping them provides no measurable benefit and only
enlarges the generated code.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/vmx/vmx_ops.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 96677576c836..1000d37f5b0c 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -119,7 +119,6 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
 #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
 
 	asm volatile("1: vmread %[field], %[output]\n\t"
-		     ".byte 0x3e\n\t" /* branch taken hint */
 		     "ja 3f\n\t"
 
 		     /*
@@ -191,7 +190,6 @@ static __always_inline unsigned long vmcs_readl(unsigned long field)
 #define vmx_asm1(insn, op1, error_args...)				\
 do {									\
 	asm goto("1: " __stringify(insn) " %0\n\t"			\
-			  ".byte 0x2e\n\t" /* branch not taken hint */	\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
 			  : : op1 : "cc" : error, fault);		\
@@ -208,7 +206,6 @@ fault:									\
 #define vmx_asm2(insn, op1, op2, error_args...)				\
 do {									\
 	asm goto("1: "  __stringify(insn) " %1, %0\n\t"			\
-			  ".byte 0x2e\n\t" /* branch not taken hint */	\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
 			  : : op1, op2 : "cc" : error, fault);		\
-- 
2.53.0


