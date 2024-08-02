Return-Path: <kvm+bounces-23088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C77EA9462EB
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 888731F21D85
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E88165F1D;
	Fri,  2 Aug 2024 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hiqnT3b/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A6015C128
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622782; cv=none; b=Edr7fz0aX5841GzmGzcJIZ05cLuvanckawoEJqUcOzF0gd1oVC3YkDO3h8dhSxKt+lLZhM31KHwEzv7hFAWlDXItwHqw6/vbM4Twlxxznd2xnuwT9EaF5XiCRWuKm7JZswiuaO9YsePeYp7CbaFwspStAyA+Zlxq6j9qS597VBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622782; c=relaxed/simple;
	bh=PqAkbeX46Q/uqruzqqUfbvSnJ64882JvtNzQyytCBAs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/hdSN9cw05brZM5ev9aNnkrGjC+HgscOk+4YvIewLa7Ss7tJ/PqBU5rVstmnNMJOsvIqJiyHaGuYNc4wB7XCyMbGqx/ORNCNtc8YsQK3RzBtjUOOxhCDR8wh/+XXZBh8GtSRdNSXNNoH1KOI8L8PcHt49046htXsV2iXZs99lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hiqnT3b/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb685d5987so10451462a91.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622780; x=1723227580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jQvD2XFUOoXKh/qvHzE0oWtyWzaKX7emTzrWlGmUYVU=;
        b=hiqnT3b//4qEz60ZslEs2FYz1j2vX05lU6bI4eOSCbB608l5M2wq9W9cY1Ggi9Nexl
         2B6XQvhIEgfF7Mq86iWVM2zNmfhvHUF4b6D2C7cViz4tRFuLm/d6/Zo928TXsCztE0ol
         b2Hc5T6XGaXKbr/lVb9TDca8tpq3v6pIWuKawRmdPsLl5WUlvscmPuFjjKDAF2XNAYJl
         MTJjUe1Hqd2X+SepUWGtuSCg1PhDvH0VzDBKRYeGYxpACX8apFYIbKmt2j/pr3N7nNiH
         naFJeCeriNxNg8DedqBgx/x7jSiA7EqZDYQffQAnAankoNhUl/zlb0NPiCvot9H6x0mS
         wy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622780; x=1723227580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQvD2XFUOoXKh/qvHzE0oWtyWzaKX7emTzrWlGmUYVU=;
        b=Ny2yb/PSEIs3sk/6CQMZRpXqgUBvZxw9NoluiEiIk7K4+dLf2x5pnwbdhlJm379GUq
         VEUYoZhVzXtc0X4NnCbELJg4GsqgvmUn/jsWuFTfMokKiD9TQjCJ3sphARTWFCRCDaYN
         LTxw07+YOcpdorhmp/hJ1hk5Mk3+mlx202nUWTqYfzHumjCiFoe+xyqxIYde7H5L3lpR
         rpuIBcXrSEJiPyb2khyNUgrou5GF6B/IT+jPx+GXi0qnt2RmgGdh4hc9NN35T4Cy/3lg
         nyLv3TREruDXvbNpUsWpp40baYpcW1Lq2h64R4hOeDX0Q3kX+Cdsv793GWrPkJ7d4s4p
         Solw==
X-Gm-Message-State: AOJu0YyIh1d+DVyIRfDyQqfjAvot+h78CZuzoYidYeuBFm7g1yz9bQoa
	UMlBjXyCvGv8wva2WPGxsFfkci66Z+n/2oEzoNAZ30nfmfvPZFF7sFOsyq+C40RvTT1CN8dTkc/
	zTw==
X-Google-Smtp-Source: AGHT+IG6uu1lx5JAUSYw/bNj45a08OL8ZJ97prbP8I5rSjynR6V2S9qofwrzh1JA+MVBjXVGnS3x1i7++1I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2354:b0:2c9:7fb8:ef1d with SMTP id
 98e67ed59e1d1-2cff952b45fmr67521a91.6.1722622780012; Fri, 02 Aug 2024
 11:19:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:26 -0700
In-Reply-To: <20240802181935.292540-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802181935.292540-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-2-seanjc@google.com>
Subject: [PATCH v2 01/10] KVM: SVM: Disallow guest from changing userspace's
 MSR_AMD64_DE_CFG value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Inject a #GP if the guest attempts to change MSR_AMD64_DE_CFG from its
*current* value, not if the guest attempts to write a value other than
KVM's set of supported bits.  As per the comment and the changelog of the
original code, the intent is to effectively make MSR_AMD64_DE_CFG read-
only for the guest.

Opportunistically use a more conventional equality check instead of an
exclusive-OR check to detect attempts to change bits.

Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..550ead197543 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3189,8 +3189,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & ~msr_entry.data)
 			return 1;
 
-		/* Don't allow the guest to change a bit, #GP */
-		if (!msr->host_initiated && (data ^ msr_entry.data))
+		/*
+		 * Don't let the guest change the host-programmed value.  The
+		 * MSR is very model specific, i.e. contains multiple bits that
+		 * are completely unknown to KVM, and the one bit known to KVM
+		 * is simply a reflection of hardware capatibilies.
+		 */
+		if (!msr->host_initiated && data != svm->msr_decfg)
 			return 1;
 
 		svm->msr_decfg = data;
-- 
2.46.0.rc2.264.g509ed76dc8-goog


