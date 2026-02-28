Return-Path: <kvm+bounces-72264-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKkTNSFiommN2gQAu9opvQ
	(envelope-from <kvm+bounces-72264-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:33:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A241C0206
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DC6C9308873F
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 03:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1526B2D781B;
	Sat, 28 Feb 2026 03:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LGTzl81N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490CE221FCF
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772249614; cv=none; b=vGZI7tpzr7cuOS3EO+rH7lARNXJvjfMwJn4kSCxSVJnZlIVfrU+pHy8KjX3TdGmP6450M3okEzUhQR534p4XjMbbStJneq0R0Eoh+XJP4h+wKjsuy8mFEPfKHWfccdi0hc7xWpLczjgiYx9nKXTT2p5dbLgO9H2MyapValseIfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772249614; c=relaxed/simple;
	bh=+v3nri1DdjIgOGn4RXg7h370aWy1wlIJbf+reNqIh84=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s+8hKmxNZACBIbdmEk1BX/sD6NYowasjZ1dCA2ZlI9RoBOt/tA3YUdM4HcvRn6K9RYCHZn3xfE31kFos/2bSVOylRzQdUfSWbuUDmFBzdSwikdsnPuNrk981tOAwRfPiZnmrhk32sJDmEiOsLgCzmvcD1KUH55sDz2pGdzxdPXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LGTzl81N; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ae3f446ccfso250155ad.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 19:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772249612; x=1772854412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yceO0f6YP14FV+FbBXD5MBGCTsrjqX1uNk/E2eJRM18=;
        b=LGTzl81NfTC5L5Wf+YHpRiQgQ76vxFzHO+C3rJK9dqseW5fLEYh5X/pqOe2vk58J6y
         QWVu886a4Rq41JiiW2ukyhNiqBfntoiJ40Z04BIbzEnlmfckITldHrhP9oRjIkBrH+Du
         KWtiRiMrSp0OjmeB0vIf932F0+MhelaaIgZR4vi/55fcG4U/qsmv1VngZKRWpbsmr7bB
         tvc8yXvso20dSnofdv6ZHCyhzRHvQ1M6a8ZZW+uNArZ4Y2PJTxHqGJuyHNAK93wzKfpw
         0plC97PcceewhrSKRWX2sP/HJAfLnUGQ2Gi2xYxvciy3ycRcsNvmn3xuNxRynr42iY5M
         QTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772249612; x=1772854412;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yceO0f6YP14FV+FbBXD5MBGCTsrjqX1uNk/E2eJRM18=;
        b=nawil7rAKJ8iYSrRNWpvHbAiyMoDmpTCavYflvpKrkjmoixGhlhJtQV50argRbMMO5
         yrUbSvImrVnmBEtisGdwEybGWjRmNVcxdC4N8pougjCEGpFFy1gEli3Y+SgzWlq2IkK5
         BL8HLklaRh6BG+9lpxFyGfhOFMLhunRjLm9AUdDMW+xiMNdZE2U3ylXim1VD8AtPv1b4
         sPigkAD27+Bs5sZu1e408fxge++0BuwKOESPhNp6o6YkNEQA/pgcUt7Z7mLWzqA4bMtk
         8jwCK3n7JYiuq7q1XSUqfa94QSMyx5b1Vu/jq51qUONkiWiJ0WdlWIGN42cb6WLeWMsv
         XRjg==
X-Gm-Message-State: AOJu0Yx5xTVdVNJ6jTNoNv3soO8L1CgHjhBcImgsCqBIP288iUO+YSdR
	5mG8demGtA3TE5ARbhy5TFHr1MgFuX5PTo31BPMRIfjLl7xS1jnpWpexa1PdnwNmN6YIMX4tOht
	RaECJA32cKh04cQ==
X-Received: from plim9.prod.google.com ([2002:a17:903:3b49:b0:2a0:e956:8aed])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1786:b0:2a4:8cd:c3cf with SMTP id d9443c01a7336-2ae2e4d348amr51524705ad.49.1772249611304;
 Fri, 27 Feb 2026 19:33:31 -0800 (PST)
Date: Sat, 28 Feb 2026 03:33:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228033328.2285047-1-chengkev@google.com>
Subject: [PATCH V4 0/4] Align SVM with APM defined behaviors
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry@kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72264-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 71A241C0206
X-Rspamd-Action: no action

The APM lists the following behaviors
  - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
    can be used when the EFER.SVME is set to 1; otherwise, these
    instructions generate a #UD exception.
  - If VMMCALL instruction is not intercepted, the instruction raises a
    #UD exception.

The patches in this series fix current SVM bugs that do not adhere to
the APM listed behaviors.

v3 -> v4:
  - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM Lock
    and DEV are not available" as per Sean
  - Added back STGI and CLGI intercept clearing in init_vmcb to maintain
    previous behavior on intel guests. Previously intel guests always
    had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
    because the clearing of the intercepts was moved from init_vmcb() to
    the !guest_cpuid_is_intel_compatible() case in
    svm_recalc_instruction_intercepts(), the CLGI intercept would be
    indefinitely set on intel guests. I added back the clearing to
    init_vmcb() to retain intel guest behavior before this patch.
  - In "Raise #UD if VMMCALL instruction is not intercepted" patch:
      - Exempt Hyper-V L2 TLB flush hypercalls from the #UD injection,
        as L0 intentionally intercepts these VMMCALLs on behalf of L1
	via the direct hypercall enlightenment.
      - Added nested_svm_is_l2_tlb_flush_hcall() which just returns true
        if the hypercall was a Hyper-V L2 TLB flush hypercall.

v3: https://lore.kernel.org/kvm/20260122045755.205203-1-chengkev@google.com/

v2 -> v3:
  - Elaborated on 'Move STGI and CLGI intercept handling' commit message
    as per Sean
  - Fixed bug due to interaction with svm_enable_nmi_window() and 'Move
    STGI and CLGI intercept handling' as pointed out by Yosry. Code
    changes suggested by Sean/Yosry.
  - Removed open-coded nested_svm_check_permissions() in STGI
    interception function as per Yosry

v2: https://lore.kernel.org/all/20260112174535.3132800-1-chengkev@google.com/

v1 -> v2:
  - Split up the series into smaller more logical changes as suggested
    by Sean
  - Added patch for injecting #UD for STGI under APM defined conditions
    as suggested by Sean
  - Combined EFER.SVME=0 conditional with intel CPU logic in
    svm_recalc_instruction_intercepts

Kevin Cheng (4):
  KVM: SVM: Move STGI and CLGI intercept handling
  KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
  KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
  KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted

 arch/x86/kvm/svm/hyperv.h | 11 ++++++++
 arch/x86/kvm/svm/nested.c |  4 +--
 arch/x86/kvm/svm/svm.c    | 59 +++++++++++++++++++++++++++++++++++----
 3 files changed, 65 insertions(+), 9 deletions(-)

--
2.53.0.473.g4a7958ca14-goog


