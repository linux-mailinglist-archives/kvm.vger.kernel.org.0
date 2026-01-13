Return-Path: <kvm+bounces-67873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6680D16014
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 76A0E3045DA1
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00D12773CB;
	Tue, 13 Jan 2026 00:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e26MMq8R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BC25BEF8
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264243; cv=none; b=OcuOMkn8a+IT+H19C6xPLaG9X1c0RRrIyarueWS3/XmbTwvj9t78TOWHOPJwp4UTnQBSmAsbNSHy2MbfpgGcAy4LjeGcDr8AKtGfC3lEuop+FfRBbqxC7e4o1itgbinuztEjZJ5DQqtuZ7TAh8GL1GGhMbuq8ngM9IkVJlxWYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264243; c=relaxed/simple;
	bh=M1xRSFeASAkknaHx2pD7yI5yUmeOGshWsf8idPh4hcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h3o7/98Rx2SJN1hW2Eej7N7PbtaG60E0UyawxQb7uIeFYch464oXUPfEGqsGEkmKin2RALQ99ncuNIjZelVACAktLmsq7mkYUqnaR1B2KZ4pah8iGQ/e2wgJYokwNuFJriIfUsg7F3iZFoCG3sQBeHUwEi8i4iDjWX9wiQ4gDKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e26MMq8R; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso4825220a12.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264240; x=1768869040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZ8nfK2+WZxc9Tarbu87SXdhPaNlwTkuA+n1mGl2Olk=;
        b=e26MMq8RyOvo0TITp3N2aSfZehroBL8PZZS5f67cUKWqU5qBB0RlIhou5ydoTBkJ2P
         PL5R0BF5WfmIyl7YaxSLhYfu2hmQjrXEhjtDkmX8WBuCcAR1KCT7An50NmjE86KDLKqx
         YRZ+Uts37cuXSmt/nVWCeM2aR9g6y1r0/9iJfngHONr5JV48oXr85HYPkua2weGnxSYq
         fZ8bic2B4r6Rbwrenk/LNUQ/2A/10/Zj3P7FmTtwKqQjbzqvraiQts55Ga8VDOuLkBd4
         XLDDDM0h2vFI9WBOohT18W9+MlhJfJMv1GK0pjMLFEJ5IoGJRdn3om2TL7+M9qnGf1ib
         3p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264240; x=1768869040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EZ8nfK2+WZxc9Tarbu87SXdhPaNlwTkuA+n1mGl2Olk=;
        b=wB9hhcLtQ5+QWQdPrBNUDtvaAASTTy6cJvWNShn7c8qnfH2f/TrNWLLf1fH52V2IMV
         BqoSD6u/+xa9D8r9ohNf0MQZlFZU+hViV6CIbEAjHGIY/H0XMlA7vCmNp/lb+VKEIYEk
         gx0HJAknVdNORkKXWf0LdBt50Vr2ne8W68Mk0b9VoqUdgitPXz/m52IL0rzwf9FvO3Fm
         ZP2jT72M/2mXVnQbzJIP0kRfmzJOB5GbnMzIopclc6sT6P0UHJV8XwvIVCyFILNfLTEp
         NEoJmUZM1Oc26HRyN2mVxVOnOFiPTGDyVBTnC0M8czGKn2c/nu91QXOg2mjswgia6BTe
         zbOg==
X-Forwarded-Encrypted: i=1; AJvYcCVFQoFw52lQ9bv1a5TDpHwyzgGOWGln4SjcNsXrSc2HDM/ZbIBOZhv9DYnFrSw2FhL8Eqc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7lbvVLcE6RPT7lBTF9BEaN3/qaAuEchL+CWu62w2CKB3OP4mE
	r+sexALHrzi0HmCRDHx7oFQ4HEPQVjq+gOA6QE995IWXLZMojQB2nIsQwpXy6ZuA3CB1Wb+M/b9
	gqhY8usNzKXyGxQ==
X-Google-Smtp-Source: AGHT+IGBTu0USgs2IgrjWM+0eXyI/OV+JqV+QgDXs3l8iQbP+Lx+Y73w7Vj4jyNs3uvcMuL5HfQ8ZuYHE8KWkg==
X-Received: from plpv8.prod.google.com ([2002:a17:902:9a08:b0:2a3:c667:e0de])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2584:b0:361:3bda:7155 with SMTP id adf61e73a8af0-3898f8481dbmr17008611637.7.1768264240380;
 Mon, 12 Jan 2026 16:30:40 -0800 (PST)
Date: Mon, 12 Jan 2026 16:29:58 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003016.3511895-4-jmattson@google.com>
Subject: [PATCH 03/10] KVM: x86: nSVM: Handle legacy SVM nested state in SET_NESTED_STATE
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, KVM didn't record the vmcb01 G_PAT (i.e. the IA32_PAT MSR)
in the serialized nested state. It didn't have to, because it ignored
the vmcb12 g_pat field entirely. L1 and L2 simply shared the same PAT.

To preserve legacy behavior, copy the current value of the IA32_PAT
MSR to the location of the vmcb01 G_PAT in the serialized nested
state.  (On restore, KVM_SET_MSRS should be called before
KVM_SET_NESTED_STATE, so the value of the shared IA32_PAT MSR should
be available.)

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ed24e08d2d21..c751be470364 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1884,6 +1884,13 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
         if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
 		goto out_free;
 
+	/*
+	 * If kvm_state doesn't have a valid saved L1 g_pat, use the
+	 * PAT MSR instead. This preserves the legacy behavior.
+	 */
+	if (!(kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
+		save->g_pat = vcpu->arch.pat;
+
 	/*
 	 * Validate host state saved from before VMRUN (see
 	 * nested_svm_check_permissions).
-- 
2.52.0.457.g6b5491de43-goog


