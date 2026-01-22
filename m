Return-Path: <kvm+bounces-68848-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBNUIC2wcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68848-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:05:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7C361E4B
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 47F3A4273B0
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A907147A0CB;
	Thu, 22 Jan 2026 04:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cxkn2XIn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B193477982
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 04:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769057886; cv=none; b=Qjlo7Bh9SbjaGNZ1fpPKb7GJuZbr7kTxkLNhsrsh0GiVqiOtnyBO75QUDIqU5faGaJaAgKscyoYgFDZH4f5Xp3mqtohTFs7v9xMe09sCTM5t2rKkoU7m2sEBWSu97A1Zo0azljQqk+Y/NdcKHaYbsTpPQPaO4AMSw0SpXuCixsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769057886; c=relaxed/simple;
	bh=fQr99uM8I060YIwTDdLf//h+zn/VH/xy75rpl5pjh0Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bIu3FFdrIM2rvtRrPIvISBQqnFpwPyatLqqgeBXb/7+oxZwRkpgVbFPDv9zO1W+xPIg0mQgw72Z+v5P32e2yQncQ4vWaT+ACEwwfDT7c6KOdjYhdkJzRKd/EDoC3+F6vm9BnsJWBHKaAlQjRYrs8J91+5vIKT+3ynrxVB3ZYHyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cxkn2XIn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5269fcecdeso293844a12.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 20:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769057882; x=1769662682; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukX4ACJbiwYdjP9Kah8t9CaWJb7aftnI6HG33S8HCmc=;
        b=cxkn2XInHF/kBfBlsP0Y0Fq1quar1/xES0xuTaXbaNK71nYPKB1eVa0eD57fw6bsW+
         /T0Zz6UGQdr/zcziS+QCo4mKcBNjeYKknI9T28B+Sn68yQ2U0Pb6yc25iEtR9BAAVFwt
         h2wmhsoNwAsfH1wKMaPMoKOHQcsNx7XqozwefOIjRymQpQqPtkF32gMs0BbVCLL8pUjW
         mQ2K4EiFfs5e9ipaLWhAKH9JsICtNBduqCR7lfUyNeMfgrCy7hSU5DlVnZuXQ4xG3U55
         G9Vq6rxv08/excgWhollH9zNmHRQC2XbYF+JhMc3qaWqszYiyeXteQsfZQx+DwV7cIky
         XJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769057882; x=1769662682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ukX4ACJbiwYdjP9Kah8t9CaWJb7aftnI6HG33S8HCmc=;
        b=Je1474T7wlwA/r7qZ8stOh0DDcmUwIwr2avohaqT91WevOgpPtGU+YREBwEKXyTs0B
         8o1Y6nHf5ynn/WQiNCzS0yVaW9DmBw3wCTMf9FCm/N/nojVCdeWJmZqQSCcDSditpIuc
         ndtbay4PRhScAb5G4jfYb2JLRwlciHCa2/tztX+D8ReU7rCfVPCRKXeOfW3FHjeTUCQz
         dwzlneNRnY8MoNtpJK/geiLlVzYxk/AcFC6oQCKpUoxmA/gb2XEtLdJ6FcvMT1Xvy8F9
         17uvlaiKsk3rYjLZvTog6BI3+YoUavK2l4Z99qgWi4pVGqZl0Ur+nIkvVYLWIxiZ4AgP
         Oi3A==
X-Gm-Message-State: AOJu0YytIlg2CIdD4suLxwAGwnhwpcqyCStp2i0OJK2LLFMRzoEQaeTv
	5rLdtqybOSHtyN5lt/ZhEbgMy3Pu4AbWUgbB9viFtX+6FS2YQNfdJhl9/XyxYODpwVomIV3g1I8
	H02xd2ERuVRU39w==
X-Received: from pgbdm5.prod.google.com ([2002:a05:6a02:d85:b0:c1d:ec5f:ada2])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3984:b0:38d:eeca:b330 with SMTP id adf61e73a8af0-38e00d1557amr19997302637.40.1769057882138;
 Wed, 21 Jan 2026 20:58:02 -0800 (PST)
Date: Thu, 22 Jan 2026 04:57:52 +0000
In-Reply-To: <20260122045755.205203-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122045755.205203-4-chengkev@google.com>
Subject: [PATCH V3 3/5] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
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
	TAGGED_FROM(0.00)[bounces-68848-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 2B7C361E4B
X-Rspamd-Action: no action

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e6b1f8fa98a20..d3d7daf886b29 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2320,6 +2320,9 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);
 
+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;
-- 
2.52.0.457.g6b5491de43-goog


