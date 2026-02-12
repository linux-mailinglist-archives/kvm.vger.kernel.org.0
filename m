Return-Path: <kvm+bounces-70990-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MGmzIef4jWnz9wAAu9opvQ
	(envelope-from <kvm+bounces-70990-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:59:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A0512F28F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF9FD3068F25
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D2D3446C7;
	Thu, 12 Feb 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nrvr+tun"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811031E492D
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 15:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770911955; cv=none; b=VMalsFVtQIo6k3Ntu+IN/dIit1CAw5CJpAjZYyjy3zytOkWcx+h7qZPnMa+lZpccDsyOqHYbDY47jPB8b9HR3p4n57yBN5pr7ToBGl4/rfF1fV6jMCD4oYVSeWWp+rRqWhQZPi7vTJUnsLoZmXViMkQBz0N7OEbd+XE3WgafcUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770911955; c=relaxed/simple;
	bh=g47u0imZn9BNpQzucP6/FBTNqKWSGq4IfKInL7XmKFY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PEn9bwkl8GCFApyAgSgKo9NXXLO1A9siUEFo8DX83bKaNCUlwwqNJhHdjMO6wyPZss759r0YF57jhFZVvTNUWMF1+gOioRpMkDDXgNUGHdcwMWkxlx5TGQiIGeabKwTleM6DLKSeTPiTkHWGPnHcF1tWdbsLP6/erTdd3JLxi4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nrvr+tun; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e1e748213so1161604a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 07:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770911953; x=1771516753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ebvdQMfvne+biXGLzUXHdRXQhx8hybcRtFG+HEINLdI=;
        b=Nrvr+tunGKlz/zqv9C5IAvgOkcnCOUijDeeRsyZ81Z5X/Sh8LxvOcAngg/s+O7omso
         kMdvCcnCiDhsw6OdxEVzXrMe+6PFiIyoAVXwf4/0lybShgfG3aeieOVmNxtNraciIi69
         25qBO0LDugIkkUeOyf7en7iJFTkgZaEnry1YCR0TkIHyLSnocsKB8DdpXdi+1YPb9bxa
         azt6iS3srFB5Xz5Wl/ycrAm6FZ88PwTWCTvtgi7iP2kLr4skuc8wzEhe2fU0dD6tbk/+
         VcR2LIVwQNLRrhRO5J3kQv/g8shliId6bZLKPmtCsdmNUuEqImOyHz6/nNKL4XDS/tVF
         etrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911953; x=1771516753;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ebvdQMfvne+biXGLzUXHdRXQhx8hybcRtFG+HEINLdI=;
        b=j2aeumH++xiRzb/SisIZGPByaJKU2Zy0wYw48rQxNNnM9s5XxUG8NJHmiWFy1UCVUy
         /MHgZYKQAdnvD3YZH1kxe67OrGcsVL9uV2WrtmjvcVnIK6lxwg3tqa4ervNonEN2BPEj
         SjRMknRnTzL2lpQ+AtMw7buXot9u/RVo/GUSrmWfTvmgsgCRZqAbYXfTHjKIWnPGT5bB
         QZ7po+8AJ68v0HuhOwB6ss7sWBPfUZOancAtGevbdg99/1zcQl6ZtL5O9sey0Gc0DWyN
         WR/B8ByPHyrA2DctndqlEBUk0ilKSvx615TLWWM8H/2JYKhU5tYaedV7kfV9HdyY5ewN
         yJBA==
X-Forwarded-Encrypted: i=1; AJvYcCUoIHH7Vex8Uoc9ZIWBIe1Wr3beap2Oiwswpq0FSTZr2YNLN4h/sJZhkaCvqXG60DJe5G4=@vger.kernel.org
X-Gm-Message-State: AOJu0YweFoBA9PaKmlT9FgAxyV8YAy+jPYqcoelkVJmSdrCFHHFRMPur
	4HszhPzpT8+8tWW+7ciPh5UkzqE+ctmqEILYEJRIIKFtV5GOCz146CJLGSelBJHmXfiTG6/4Mn3
	0yQm5oWsD6H780g==
X-Received: from pgbdo14.prod.google.com ([2002:a05:6a02:e8e:b0:c62:b045:9c6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a343:b0:35d:d477:a7e9 with SMTP id adf61e73a8af0-3944cedbb53mr2197172637.35.1770911952726;
 Thu, 12 Feb 2026 07:59:12 -0800 (PST)
Date: Thu, 12 Feb 2026 07:58:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212155905.3448571-1-jmattson@google.com>
Subject: [PATCH v4 0/8] KVM: x86: nSVM: Improve PAT virtualization
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_FROM(0.00)[bounces-70990-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 31A0512F28F
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

  v3 -> v4:
   * Rebase on top of Yosry's v5 "Nested SVM fixes, cleanups, and hardening"
   * Rename the svm_set_vmcb_gpat() helper to vmcb_set_gpat() for
     consistency with other VMCB helpers [Yosry].
   * Cache g_pat within struct vmcb_save_area_cached (as
     svm->nested.save.g_pat) instead of using a standalone field in
     svm->nested [Sean].
   * Update nested_vmcb_check_save() to optionally validate the cached
     g_pat, depending on a new boolean argument [Yosry].
   * Reduce indentation in nested_vmcb02_prepare_save() when setting the
     guest PAT [Sean].
    

Jim Mattson (8):
  KVM: x86: nSVM: Clear VMCB_NPT clean bit when updating hPAT from guest
    mode
  KVM: x86: nSVM: Cache and validate vmcb12 g_pat
  KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
  KVM: x86: nSVM: Redirect IA32_PAT accesses to either hPAT or gPAT
  KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
  KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
  KVM: x86: nSVM: Handle restore of legacy nested state
  KVM: selftests: nSVM: Add svm_nested_pat test

 arch/x86/include/uapi/asm/kvm.h               |   5 +
 arch/x86/kvm/svm/nested.c                     |  60 +++-
 arch/x86/kvm/svm/svm.c                        |  40 ++-
 arch/x86/kvm/svm/svm.h                        |  38 ++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_pat_test.c   | 298 ++++++++++++++++++
 6 files changed, 413 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_pat_test.c

-- 
2.53.0.239.g8d8fc8a987-goog


