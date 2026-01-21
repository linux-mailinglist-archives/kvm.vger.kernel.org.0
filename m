Return-Path: <kvm+bounces-68666-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HIgApsicGlRVwAAu9opvQ
	(envelope-from <kvm+bounces-68666-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:49:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2024EB0C
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 60D225489C8
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 00:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB5F2D063E;
	Wed, 21 Jan 2026 00:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y54rM0ox"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD9273D6F
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 00:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768956552; cv=none; b=EEc0n2uAt2iDBliOcwDz2urstgjlHum65C6cVDIZYgHWQskus6D4leTbcnwAfKoPb2/nypC/2TxFCUp09smynLbqN4+D3vOpBw+0ywqst8Un0uYPukTMqKdr7dBgJ+q84Pq8d1wRMta25ztPX1fmHbtWEbDFWSQDk45R+6PHjNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768956552; c=relaxed/simple;
	bh=9j2viwc1zDrFmOD8zGiRuaIRwVAFEMbh/MRAdfXkeGo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=esAYVWv0X7yuhmC+XQmSC0ot+nRz9oayHt8EJg/8j6sZ1/aw6qab67SZ9Syvx7yd7abfbDqdb/NS4kCAYYvHyXWjVTYzHBy/7/PhLsdpny/vX/O6+8gOEEXJ8zZ7dF6LcTC0DZtq/R+CjbfR+BCAb1EgSFPY+Y2sJFfo+ESEuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y54rM0ox; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d43fcb2fso134035395ad.3
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 16:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768956550; x=1769561350; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bqs8q2npJfseM6OyP1kL552rWw1NXKbYV/GgcDPI09A=;
        b=y54rM0oxkVCJ1ZrLjPbgpYqLW8TT1WmFjWsZFy33/9Gly6BB7BWqZbduKEYDdzNuA2
         9bqIz0reNcPgDFDAyIZQ+vL1xvOpcl6h8LJ8FXx5KgiZ44Ow7bZWlZDMqzt8SQp6v/Ih
         cv8t7WqGXrEzUpi2nmy4Es2hyUfTD9gC45TjAp7Wl8AKEXQqIaTvPD9RLp16XqVIlXX+
         too0FO9gd+IAqpmjVV22sl1p4V7sfwEWDJ+Tk+H2BsQ7QzxpPWItIhjx+zSem3koVNBK
         7m8t6hYFk21gMOxNmDBRMp1QDffZN97niAz3azMNtfix9x6YV4FjDyHu0LVdq4ABoYnh
         rELw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768956550; x=1769561350;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bqs8q2npJfseM6OyP1kL552rWw1NXKbYV/GgcDPI09A=;
        b=cRAwDXcVPrshlXNcht1WxsdI1ippA4vMYJnEfRC4rnspFJSTtdeWD/ImumYPxFIw21
         gsQRSdYafrSI3b4regn0E1FtLy/co1gRJQv95+AVjD/EH7LyX1S9293UQtFoofslhY8v
         7CvdoxPracwNUuguGgDZuICDYJStV14NorUFLho3XklIKk1Eo5ZhQLQYoA4RyX5tV8VY
         uGgU8OhVmNRYRqve1pc+Uavf1Dl6lZgLlKtuwC0nQcKAlee+c4iE2PnBWLxtEl4s4cQ+
         oDlGYpxJ5sG1CDoSnyWK3PCPAkb+yRHBBL0edUTERfTLjsXQRq2m5cAHHtlhKqogJzeP
         0WnQ==
X-Gm-Message-State: AOJu0Yy+A2QIdAFjIu5uHodd/FMjFDHmYHfVPN9U/BmDGqcODaBMLVDV
	K4IboKuAye31tmn1f7G0MdAn42AyqbXYtpOSLX8MpZfVjKj8q0NkH9JHQnsKauPJekVEJGbqIk/
	/fcRvatEmRqR37Q==
X-Received: from pjbmp11.prod.google.com ([2002:a17:90b:190b:b0:352:e2af:ed76])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1aab:b0:29e:e925:1abb with SMTP id d9443c01a7336-2a7698f853fmr31175025ad.27.1768956550644;
 Tue, 20 Jan 2026 16:49:10 -0800 (PST)
Date: Wed, 21 Jan 2026 00:49:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121004906.2373989-1-chengkev@google.com>
Subject: [PATCH 0/3] KVM: SVM: Set PFERR_GUEST_{PAGE,FINAL}_MASK for nested
 NPF and add selftest
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68666-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: AB2024EB0C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series fixes the setting of PFERR_GUEST_PAGE_MASK and
PFERR_GUEST_FINAL_MASK when injecting a nested page fault to L1,
and adds a selftest to verify the behavior.

When a nested page fault occurs, L1 needs to know whether the fault
happened during the page table walk (on a PT page) or on the final
data page translation. This information is conveyed through
PFERR_GUEST_PAGE_MASK (bit 33) and PFERR_GUEST_FINAL_MASK (bit 32)
in exit_info_1.

Currently, these bits are not set when an NPF is injected during
instruction emulation where the original exit reason was not NPF
(e.g., during string I/O emulation). This series fixes that and adds
test coverage.

Patch 1 adds the PFERR_GUEST_{PAGE,FINAL}_MASK bits to the fault error
code in paging_tmpl.h when the GPA->HPA translation fails during a
guest page table walk or final page translation.

Patch 2 adds TDP unmap helper functions to the selftest library,
enabling tests to selectively unmap pages from the NPT to trigger
nested page faults.

Patch 3 adds a selftest that exercises the nested NPF injection path
by having L2 execute an OUTS instruction with the source address
unmapped from L1's NPT. The test verifies that the correct
PFERR_GUEST_* bit is set and that exit_info_2 contains the faulting
GPA.

Kevin Cheng (3):
  KVM: SVM: Fix nested NPF injection to set
    PFERR_GUEST_{PAGE,FINAL}_MASK
  KVM: selftests: Add TDP unmap helpers
  KVM: selftests: Add nested NPF injection test for SVM

 arch/x86/kvm/kvm_emulate.h                    |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  22 ++-
 arch/x86/kvm/svm/nested.c                     |  11 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   6 +
 .../testing/selftests/kvm/lib/x86/processor.c |  53 ++++++
 .../selftests/kvm/x86/svm_nested_npf_test.c   | 154 ++++++++++++++++++
 7 files changed, 230 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_npf_test.c


base-commit: 38f626812b20ad22ab6dc9cfe6d811850f2d8244
--
2.52.0.457.g6b5491de43-goog


