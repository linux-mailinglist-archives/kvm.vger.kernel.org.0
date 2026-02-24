Return-Path: <kvm+bounces-71557-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMPxCPP2nGlkMQQAu9opvQ
	(envelope-from <kvm+bounces-71557-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A2018053E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:55:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BD9A5305466E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF7C23ABBF;
	Tue, 24 Feb 2026 00:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E+DgHxW0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A1223DE7
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894510; cv=none; b=gjz4NjgSB7HwFx/KptTYY9uSvmOHJdeMTkCp3iCEhEY9EEWRLUI2rTFy50L8jiD3IhHVnW2E6NAVmgPuy8AuS97Unqe4HVYiYWevtmZLZjoZXxmDm1ue7UgaA/gBUfwLXNZOdeYhhs9C8GYVcJpI7CAiYG0yYbCEmQfSMr5Mma4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894510; c=relaxed/simple;
	bh=yzHGZZ2ewLti5LjEpsu8YoWspgLFHukV4Dkns5nW6fo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Xp6LMhvSIVIPi2oeOlj/A8fPvs1gapBI7ahVT1EhF396j9JfsPUND42BKOM9ZVg7a2cFrT6/7lgtJx8EOe1bagi6YHYEWyS3OPu1zeE11V7zDtTDB7gvgw2PC2fsi++2wWZ2j3f0OHN3FzMyG8YWjMDMP9xjSoC+LQ89TXJSRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E+DgHxW0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35842aa350fso27996555a91.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771894507; x=1772499307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qk5qzRrV4XbbKnkQ2PaR5i8agEGx80lRKWSK1C2rXwg=;
        b=E+DgHxW0xZK41VGQCxO7ThCjjwz1GcT8Zi1sO1UWgIb5p+svhhFir4NB/jeqb+RmVE
         YcfBEcHITD/fZ0Gaotk6k/XPN7yyji6tC8zQ7QjI7PYwRx6avBbjnWHTxy34xTkG7VFi
         eQQFUQ7XyCGMMDK/Xta32BoPZRYoYw6ePpgLVEHrVGTPSXQcN9Vd/+/IyJhW6GmPSqAV
         sQXJoi36EUoH83CSQRIB44gvT8kSXtCERvWdMegUTg9bjKQhq7LZAnPsqKee7X/MD2nQ
         h8T0yP0qxUcgRiVknBg+CB4odT3HljEOrf6bCGFW+uaoGlq7lzOCX7gNkwnEZPro8qvQ
         55VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771894507; x=1772499307;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qk5qzRrV4XbbKnkQ2PaR5i8agEGx80lRKWSK1C2rXwg=;
        b=da5E7k7L9qPQIrbeb5ECBSBcfo66XWPzp1MurDjRBoHbiWDxDPw8ZiZmEwYsJbOEqK
         TYKe2Gpb4l0XVlmGeO0hSn0qKUQU90vyu5WPUUt6aMpGdlr51je9oShjiGyIp9BKcL2Z
         gb80W1YqtdTlbryaMzvyI7b2n7LjEXHKAcbZhyr1fWC+5GePukFFls8oOMVOFezokQwp
         dSW1S9S134llPc/JnSU7bO7xc8nbpyWIgTk65LKrIBrfHrdMsyhGtw0MbcYMyjQc30pK
         t2meVbqrppQo0hd40/BqaBU8RlKK5SXKsr83WlHkVq1r64cititdUnEfz+1pnXNB4PXc
         PgWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6mlYC+BWfVQ1kHacOLxdZBMibmFtLtHOCrxWzRKwYPxC+lSrXZSDvW4/v6nR2+g+mcjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkCOB2fymerwvu4b6TXWEVryx7f0rrBnM3EDAs87H0mzby8hEA
	84g0csFF8gm/7sSEwbYlkb6LModS9dTJpikKAGXpGJ0h3K0UaxpxckMq9iLXo0C5cww5mQjFZaY
	WliEizB2cxPtj0A==
X-Received: from pjbsz4.prod.google.com ([2002:a17:90b:2d44:b0:354:aa76:8270])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:548d:b0:353:e91:9b38 with SMTP id 98e67ed59e1d1-358aea06d44mr7524548a91.34.1771894507380;
 Mon, 23 Feb 2026 16:55:07 -0800 (PST)
Date: Mon, 23 Feb 2026 16:54:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224005500.1471972-1-jmattson@google.com>
Subject: [PATCH v5 00/10] KVM: x86: nSVM: Improve PAT virtualization
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71557-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 91A2018053E
X-Rspamd-Action: no action

Currently, KVM's implementation of nested SVM treats the PAT MSR the same
way whether or not nested NPT is enabled: L1 and L2 share a single
PAT. However, the APM specifies that when nested NPT is enabled, the host
(L1) and the guest (L2) should have independent PATs: hPAT for L1 and gPAT
for L2. This patch series implements the architectural specification in
KVM.

Use the existing PAT MSR (vcpu->arch.pat) for hPAT. Add a new field,
svm->nested.gpat, for gPAT. With nested NPT enabled, redirect guest
accesses to the IA32_PAT MSR to gPAT. All other accesses, including
userspace accesses via KVM_{GET,SET}_MSRS, continue to reference hPAT.  The
special handling of userspace accesses ensures save/restore forward
compatibility (i.e. resuming a new checkpoint on an older kernel). When an
old kernel restores a checkpoint from a new kernel, the gPAT will be lost,
and L2 will simply use L1's PAT, which is the existing behavior of the old
kernel anyway.

v1: https://lore.kernel.org/kvm/20260113003016.3511895-1-jmattson@google.com/
v2: https://lore.kernel.org/kvm/20260115232154.3021475-1-jmattson@google.com/
v3: https://lore.kernel.org/kvm/20260205214326.1029278-1-jmattson@google.com/
v4: https://lore.kernel.org/kvm/20260212155905.3448571-1-jmattson@google.com/

  v4 -> v5:
  * Separate commit to remove vmcb_is_dirty() from first v4 commit [Yosry, Sean]
  * Introduce svm_get_pat and svm_set_pat to keep all hPAT vs gPAT logic
    together in one place.
  * Remove the no longer common logic for get/set IA32_PAT. [Sean]
  * Make vmcb02's g_pat authoritative for gPAT.
  * Clear legacy_gpat_semantics when forcing the vCPU out of guest mode and
    when processing a second KVM_SET_NESTED_STATE that doesn't have legacy
    semantics. [Sean]

Note that this series should be applied after Yosry's v5 "Nested SVM fixes,
cleanups, and hardening."

Jim Mattson (10):
  KVM: SVM: Remove vmcb_is_dirty()
  KVM: x86: nSVM: Clear VMCB_NPT clean bit when updating hPAT from guest
    mode
  KVM: x86: nSVM: Cache and validate vmcb12 g_pat
  KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
  KVM: x86: nSVM: Redirect IA32_PAT accesses to either hPAT or gPAT
  KVM: x86: Remove common handling of MSR_IA32_CR_PAT
  KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
  KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
  KVM: x86: nSVM: Handle restore of legacy nested state
  KVM: selftests: nSVM: Add svm_nested_pat test

 arch/x86/include/uapi/asm/kvm.h               |   5 +
 arch/x86/kvm/svm/nested.c                     |  63 +++-
 arch/x86/kvm/svm/svm.c                        |  57 +++-
 arch/x86/kvm/svm/svm.h                        |  20 +-
 arch/x86/kvm/vmx/vmx.c                        |   9 +-
 arch/x86/kvm/x86.c                            |   9 -
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_pat_test.c   | 298 ++++++++++++++++++
 8 files changed, 422 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_pat_test.c

-- 
2.53.0.371.g1d285c8824-goog


