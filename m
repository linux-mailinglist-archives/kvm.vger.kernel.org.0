Return-Path: <kvm+bounces-71585-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNjiI/1QnWkBOgQAu9opvQ
	(envelope-from <kvm+bounces-71585-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D55A182EA2
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36725304B5F7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2251836405C;
	Tue, 24 Feb 2026 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+YXkr8y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D509339853
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917508; cv=none; b=JFO2R80vYvO+RlbZNQGcvy+ZuXM/phRU/gDx14yT2373dLV8/aZMxyPzbkBgm+A/I/+Pg0+4ZPYG5TcmIUdkGby0OrnRYL+CnzKDrndSldlvraoRmLCUQqh6xK/tRR3SU83zSOjDuvqiXLfzBx27l6ORdq873gjToNVfpookSv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917508; c=relaxed/simple;
	bh=AfZLDwqO66H5LJDEaWF/fe/tqVuDFAvBOaQfPOcO+zk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LbFFgnizoCJikC6of2EXrnx9I/oTCnoqqGTMMWNJB7fUWxe/fj4N5keGbCKHII8Ex8RkBVWWv+AoNTzU2Mb335ge2gF5vWgyXBkcOmScsii+1JuhdJBV+Sc3g86mctPl8MqA+wQzvVNL0m6220WPSja5zZBaITg2SaqL7UqE2yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+YXkr8y; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6de06e6c08so3480056a12.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771917506; x=1772522306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d3uAVpWbRTVOFSJsLQhXE4M7XqcyYTVrb22AyF4z+wk=;
        b=X+YXkr8y/sCZnG2X8au2AeJQ5oN5V65IwsiY9LWx5iyQYrn8wbf2zOl85hZiWaneAS
         pA8NRArAK9hHuHU+DZuvsq1ea6EZexUMTS69VC+fms16V97ElED1MEL5p+UP2lXKbqlP
         iR+bgZ2J+buwGEvdlzJmn+zZvbOYj+jeairwiStDFOsDLUmifcneWK2jx6ySgJjKYrSE
         +iwhZLpP8JEuHq47EvxYCYYfKV25dA31zc3u95051m9F53TOycFWCp3nsiiwIsPHffXU
         9HVDMZS3JzKoYO8pgigfYDJJQmCJSVLtEowfE1Zyqr8sgosLZCmQ+VmnVVN6CfHeww4O
         Yh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917506; x=1772522306;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d3uAVpWbRTVOFSJsLQhXE4M7XqcyYTVrb22AyF4z+wk=;
        b=i1vRa2QKiW9ydImHNaww8HxH1C6uYVwCxlPy+Ou4aiESZsmQdGS8HP5TzSjpolnLhI
         QP7KwvgGCtp/pK2rgHDSBurnut6lfxuG9mteb4jTKwc4OwMsC8LxpQM2m+YAVoqwj8Ig
         j3MKD6H2ojeDZyJw7demBkTqVpaZaL6IHOpekxTKyOESb9q8tSKjg1mGS/ZkcTifXLDy
         tm60mCE8LrJBNZDtKXyZDJOIEovKt9+nTdrtfLhaiG5GHNR+KUVvv0ePmm3UXZYCxVBH
         YxCcfX8m1ov6E3xktjzqJkSw/iPbrQ2u+RSqL7mqO+W2YhFuiZ1uGgnks5eQTRDWW1S4
         I59w==
X-Gm-Message-State: AOJu0YwbHnB1EilGC/sFALfruOkFOCol+GET92qMvzZq+I9mPg3ql+2v
	BprHE45CbJX53H2frj22juNwYWTbouh8kE63JQfvjEOO+Csj9VrDHnWQWA3s6BRj5ZnyiZdUEd5
	ME8tjM7SFPYhrXg==
X-Received: from pfwy32.prod.google.com ([2002:a05:6a00:1ca0:b0:824:99df:a87e])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d86:b0:7b9:ef46:ec61 with SMTP id d2e1a72fcca58-826da90790bmr8681984b3a.26.1771917505496;
 Mon, 23 Feb 2026 23:18:25 -0800 (PST)
Date: Tue, 24 Feb 2026 07:18:18 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224071822.369326-1-chengkev@google.com>
Subject: [PATCH V2 0/4] KVM: X86: Correctly populate nested page fault
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71585-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2D55A182EA2
X-Rspamd-Action: no action

This series fixes how KVM populates error information whne injecting
nested page faults (NPF on SVM, EPT violations on VMX) to L1 during
instruction emulation, and adds a selftest to exercise these paths.

When a nested page fault occurs, L1 needs to know whether the fault
happened during the page table walk (on a PT page) or on the final
data page translation. Two issues exist today:

  1. SVM: The page table walker does not set
  PFERR_GUEST_{PAGE,FINAL}_MASK bits in the error code, and
  nested_svm_inject_page_fault() hardcodes the PFERR_GUEST_FINAL_MASK
  error code.

  2. VMX: nested_ept_inject_page_fault() OR's bit 7-8 from the original
  exit qualification, which has no relation to the synthesized EPT
  violation regardless of whether it was originally an EPT violation or
  not.

Patch 1 widens x86_exception.error_code from u16 to u64 so it can carry
the PFERR_GUEST_* bits (bits 32-33).

Patch 2 sets PFERR_GUEST_PAGE_MASK and PFERR_GUEST_FINAL_MASK in the
walker at the kvm_translate_gpa() failure sites, and updates
nested_svm_inject_npf_exit() to use the walker-provided error code.

Patch 3 removes the OR with the hardware exit qualification in
nested_ept_inject_page_fault(), and populates EPT_VIOLATION_GVA_IS_VALID
and EPT_VIOLATION_GVA_TRANSLATED in the walker alongside the NPF bits.

Patch 4 adds a selftest covering both SVM and VMX with three scenarios:
  - Final data page unmapped (final translation fault)
  - Page table page unmapped (page walk fault)
  - Final data page write-protected (protection violation)
  - Page table page write-protected (protection violation)

v1 -> v2:
  - Split out the widening of the x86_exception error code into a
    separate patch as per Sean.
  - Added a WARN if both PFERR_GUEST_* bits are set and force the
    exit_info_1 to PFERR_GUEST_FINAL_MASK if this occurs.
  - Removed the selftest TDP helpers as per Sean
  - Added a patch to populate the EPT violation bits for VMX nested page
    faults as per Sean.
  - Expanded the added selftest to support VMX and also added a test
    case for write protected pages using the INS instruction.

base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49

Kevin Cheng (4):
  KVM: x86: Widen x86_exception's error_code to 64 bits
  KVM: SVM: Fix nested NPF injection to set
    PFERR_GUEST_{PAGE,FINAL}_MASK
  KVM: VMX: Don't consult original exit qualification for nested EPT
    violation injection
  KVM: selftests: Add nested page fault injection test

 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/kvm_emulate.h                    |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  44 ++-
 arch/x86/kvm/svm/nested.c                     |  19 +-
 arch/x86/kvm/vmx/nested.c                     |   3 -
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/nested_npf_test.c       | 374 ++++++++++++++++++
 7 files changed, 422 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_npf_test.c

--
2.53.0.414.gf7e9f6c205-goog


