Return-Path: <kvm+bounces-68844-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKjONSCvcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68844-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:01:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6769561DD3
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:01:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 46F9C747948
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6D246AF12;
	Thu, 22 Jan 2026 04:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m6k4mmxB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0CB21FF2A
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057879; cv=none; b=FahnmfkR9Ts4U5wVmaJRX1JUIC1mvefZsq6LDoZJIG1g4ybknHhzGgEzTn30swREUvdHFPK2JZORVsycGVip+9+a21FG/pXHlaLwjpp80BJz3KDGFUOQwty4YnXRFfTAcYqdwZ4RcLOHSI8CqgkzHBRk/xtc3NoEMMRbAUQ3Qbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057879; c=relaxed/simple;
	bh=2zKFfMTMqKvrVgdvqOdg0DtzxLD+I53GcCJU/6t6hqM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Y9X6vqGRbE9sk04A3F6+0SJtY8P5L4PgoPPLq7kZJ8dmrtzWsO5bdds1WYZCWwUfT8Af/Af3EAnKoR2/sHSZCjmqeINw7iWRO4GB5cNLYcJT1Wt+ge1zKN4kOtwDPZs3d7H9wOBmBQPxe7sru4zJXvZOKl/eVX7Mhosfk6ap+ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m6k4mmxB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c7924ebcso565420a91.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057878; x=1769662678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UGrDICrJR5zjmJ8xi9tG6zRY1ROX7Sa4yCNtwk3moDw=;
        b=m6k4mmxByDbAVxTZTqi6yZyQpkAvELMBgooXwDfvU79oMg1TW2kBXpFun9/6uciaX+
         W+gqbygDT2sm2uPVvvO6cxo5amisSgBHy3fYo3vH3cwdF9WCdxyi8GoZ0w15AijuT/3A
         X86KRdg8LzpmmT6j7ycBBX5B8sjVCN7+6vRWRiNCb8eubRDlDiFEX31brbYaJlBRJF6f
         AbFrerv/Pq6blwdocreAidqIaFMDkvfDwATl9SeT6fHekbjCT7/nmY1o8GTg47fcXsWP
         qohEbLTZBahfUVtSXCQbGlyteajH3v19Anp/VgfRMp/1sE2jVAlNa8xqB/N4PDkjSJBK
         cQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057878; x=1769662678;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UGrDICrJR5zjmJ8xi9tG6zRY1ROX7Sa4yCNtwk3moDw=;
        b=rmE3rF2nVxbdmTr2v7gv6Navn1qsDPjx2BKTPnBNAXBpqTBA/mkQhDB3CVvIu02Ykd
         hl9eWb5s7fYz95GShYMtzbvC6OzBfpiWMsVk4qZo7RUUG/rwVjlT2hb4ITKy5gmsi3i6
         DrkA2LeAqeIeMT0cCQzRAB+DiWskS6ZbgNfOTZKx8paLzU2G6NWIWIYc49VykTlwT6dw
         axpndmDYQQr8KvCE2DdnJK5vMxBi3VrBbdY9jx5PgH1/F3M1lbp1ksimTyT/Pvt2EwCb
         unalooUkyMbYCRKF2gctq0AG5dK4mITUPY7N9GydnFD0OkTGH9U7Mfc+/61OlQWkQwI6
         vuQg==
X-Gm-Message-State: AOJu0YyEwVWSX0qMqo98TNmT8ZydFShWlggrbCHuKsYrmMXT87IvbOsj
	fLK8TuP8MGegGQUsbXqC4wL/I/RygCRjFo0xp/u6PHcL47lCGrwXrcQyx+4xXW5OoxDsJ8TOxdV
	wBwoYVU+is+bEuA==
X-Received: from pjvh4.prod.google.com ([2002:a17:90a:db84:b0:352:de3b:3a0f])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3f4c:b0:349:3fe8:e7de with SMTP id 98e67ed59e1d1-3527325d6ecmr14606772a91.28.1769057877602;
 Wed, 21 Jan 2026 20:57:57 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:49 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-1-chengkev@google.com>
Subject: [PATCH V3 0/5] Align SVM with APM defined behaviors
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-68844-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 6769561DD3
X-Rspamd-Action: no action

The APM lists the following behaviors
  - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
    can be used when the EFER.SVME is set to 1; otherwise, these
    instructions generate a #UD exception.
  - If VMMCALL instruction is not intercepted, the instruction raises a
    #UD exception.
  - STGI instruction causes a #UD exception if SVM is not enabled and
    neither SVM Lock nor the device exclusion vector (DEV) are
    supported.

The patches in this series fix current SVM bugs that do not adhere to
the APM listed behaviors.

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

Kevin Cheng (5):
  KVM: SVM: Move STGI and CLGI intercept handling
  KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM Lock and DEV are
    not available
  KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
  KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
  KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted

 arch/x86/kvm/svm/nested.c |  9 +++--
 arch/x86/kvm/svm/svm.c    | 74 +++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h    |  1 +
 3 files changed, 71 insertions(+), 13 deletions(-)

--
2.52.0.457.g6b5491de43-goog


