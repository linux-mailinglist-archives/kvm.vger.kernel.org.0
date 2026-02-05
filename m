Return-Path: <kvm+bounces-70364-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPWZIR8QhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70364-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED854F7E0C
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89DDD308B83D
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD5733291F;
	Thu,  5 Feb 2026 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QiQpQ0Su"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D27332909
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327818; cv=none; b=n7nXqnhtszhJY73sxDN6u54acU8hPfL/ps374AMxbWTbH6ffcF9+JkH0Nu1zD44pFQnDHiSj+3LaUKVEXKlEXtxhluBm/pgPYPV5xQXBb2EuH595fsr4u95LdLKTLmRUpRbcKeXFBer/n0p0rF3fmOiWLZG78R56ef+CAVZhwxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327818; c=relaxed/simple;
	bh=tCblJoq9g/HMbi+utPa6tWkGtYvQHIGZ3smM0wbHPKQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TbZLTLbkP7pGeEzLdTGpADuDrUl9Qrm7H9gUWmH8LWLY3FpPOqUqaCvWfGh/U1yVOQBo3a/9dzHz/GuhXX6w4qVj88v+6hcS58y9+3mcS/cjpruti45j8BjCHgOQZUnyIWW34xB+B5tUv37/2ag2FdOyfjy4AXDFBvCjWhT7mcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QiQpQ0Su; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c56848e6f53so819631a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327818; x=1770932618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NTt3Yt6WZ7YQmoJsNOI79U3marZK5bHkKaL7b6P4x+M=;
        b=QiQpQ0Su/+s8beQk6Qehefqcr245UbugC3o6dfQsP3oW072RdO07kI3f8gvezNN2S5
         SxjzRsl9cvWL4vkUD7iz8gYn7Dm/ILqMzJKDr8vFGtbUen+qsd74Z3rwFKIJboFkBkve
         0aM6h9caeoETQdOnMCSL/zyfrj5INbsWTGweeFshsUnDqcmUOwDR4RadMKUKqEhpxRi2
         BhPVHYluKuxbFt/wn6wo/OWtBJ3UW+jbLem0jhE/uSHWF9D6YUD1gdi78P3fNSZ1dXk5
         PlqN3DFcHuWZtLn5B+zgR56H6oBevqi2bANXOWPEAe5I7CoPsTrEGFj1ZR7OqyfMhZ9r
         r0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327818; x=1770932618;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTt3Yt6WZ7YQmoJsNOI79U3marZK5bHkKaL7b6P4x+M=;
        b=bcvJ3+01nI+bh0GIbU1d2FZhvgD5h6qjl9ZqcxeTtw0CMaZwM/B8jL5Npx9SZRYb6/
         JilEzJttqj0xgQ3LcYIM44LTqQf7JLbnMPxq/URZ4r/93qphrVLH0k91XRf4oH15SISc
         Occ2sdu1bNM3ELqQkciHwPLf5lJbAUc0CNUzx6VnHl3gRtyn6Q7FuizV3rrkWAS4yx7v
         I4pMPgBBPrB2TFtboLrdtxpqO1M5GJEUxJpnGvuu/mOhXs4qMqorz/Ytp0MB8FsU+cHk
         MjIfYDcysIlhKWD9SdFhQpKY2lvq1JTl1qrn+S8SeyH6HfY7khfw47qurCiT+TQb+c0f
         K6Qg==
X-Forwarded-Encrypted: i=1; AJvYcCViP1lgQBGh2oiz7wCv9JjQndcN4sLxrLn1AZnoNTa+awcWVGcTTrq8BaL16CvHIgvh4uU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV7zRQ17oVUwrdBd13S7QzTDckba6seWwEcbXIg/jPZOVLMu/l
	YkgVo/aKW9mlU5/+eB5eQjsCbyMn2WldDLr3p6aPKMnlNEEwSiqSnsl22P4l9uIxZLBBjbUAezP
	PqVQTuAh/8XOvLA==
X-Received: from pge15.prod.google.com ([2002:a05:6a02:2d0f:b0:c61:7e5d:a81])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:151b:b0:342:44f3:d1bc with SMTP id adf61e73a8af0-393aef76be4mr328688637.35.1770327817947;
 Thu, 05 Feb 2026 13:43:37 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:00 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-1-jmattson@google.com>
Subject: [PATCH v3 0/8] KVM: x86: nSVM: Improve PAT virtualization
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70364-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ED854F7E0C
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

v2 -> v3:

* Extract VMCB_NPT clean bit fix as a separate patch [Yosry]
* Squash v2 patches 2 and 3 (cache and validate g_pat) [Yosry]
* Drop redundant npt_enabled check in g_pat validation since existing
  nested_vmcb_check_controls() already rejects NP_ENABLE when !npt_enabled
  [Yosry]
* Fix svm_set_hpat() to propagate to vmcb02 only when !nested_npt_enabled,
  not unconditionally when in guest mode [Jim]
* Warn in svm_{get,set}_msr() if host_initiated and vcpu_wants_to_run when
  accessing IA32_PAT [Sean]
* Use dedicated svm->nested.gpat field instead of vmcb_save_area_cached
* Use dedicated header field (kvm_svm_nested_state_hdr.gpat) for nested
  state save/restore instead of overwriting vmcb01 save area
* Replace restore_gpat_from_pat with legacy_gpat_semantics to correctly
  handle KVM_GET_NESTED_STATE before the first KVM_RUN [Jim]
* Remove nested_vmcb02_compute_g_pat() after removing all callers [Yosry]

Jim Mattson (8):
  KVM: x86: nSVM: Clear VMCB_NPT clean bit when updating g_pat in L2
  KVM: x86: nSVM: Cache and validate vmcb12 g_pat
  KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
  KVM: x86: nSVM: Redirect IA32_PAT accesses to either hPAT or gPAT
  KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
  KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
  KVM: x86: nSVM: Handle restore of legacy nested state
  KVM: selftests: nSVM: Add svm_nested_pat test

 arch/x86/include/uapi/asm/kvm.h               |   5 +
 arch/x86/kvm/svm/nested.c                     |  51 ++-
 arch/x86/kvm/svm/svm.c                        |  37 ++-
 arch/x86/kvm/svm/svm.h                        |  35 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_pat_test.c   | 298 ++++++++++++++++++
 6 files changed, 406 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_pat_test.c


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


