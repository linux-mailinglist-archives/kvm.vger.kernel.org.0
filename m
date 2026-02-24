Return-Path: <kvm+bounces-71586-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJyvIQVRnWkBOgQAu9opvQ
	(envelope-from <kvm+bounces-71586-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E04F182EB0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 893673090FF4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD47B364040;
	Tue, 24 Feb 2026 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GhLZDBPh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ED436403D
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917509; cv=none; b=WiBkybbwjG/CIuq0xTAerd2K2AsG6v04WKcDf0LI5YE1HcOD0wr5zLo8x/3UM/fjmEmmfmDS0IClsll1nfr4J5EI0rHLI8E13gRANK8dfvMf/xj0wvZ+xtPEuSFva1l6Fc+Jns+rd850SSikRk8ATfgoDOt3MwSPACAduUkv26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917509; c=relaxed/simple;
	bh=sqw10a5I4gtYDuskoXi6Kp5gGm44+OFNeBcV1k6G2uw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q7OfKxjq5yhWk2Visv/rXofB6831ZWof1JyBh73NyGXkbMzzp6cK4O9kMJKMk1bhaNQjqe6HcpZyWwQkmHHQyJ+B0cbhuMxQLhxxG/N/YBFcDiP1hoklvY/mcXdVbpxNmovPt0FK8MQvl0NGA2DpMZuzEtUN2toAx9trjdKFEd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GhLZDBPh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so33482955a91.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771917507; x=1772522307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dcHRPFmunbEFZzyxfL0Rua/ObkZPc5hbYi5K4rfoc3o=;
        b=GhLZDBPhVVqVrtrOBq10Pb8+CAHEJNUFrwkyxofdtC8HqS2Y0F+zBICKjVSAio0lia
         lnnKcGdUZ4R4xg9HdQKnPy5hQ/WkYt3y4oeFbY2DJf2l8qxpRYSTn6oantINHv03qt2W
         BVsCJovBb8ftpa2BHkSyGkiBaKeKnjRS4TTQmdgEYx6/3wrbQr2R5yUfuf6KhZVJKsgi
         MAXz/UU7ZW+mCqWhFIjiIiwpBC0z0a6j2amXupzaHapT6n2Lzms6SlIJOpbRgQ3oTneW
         YEB4I3rXjooUOKl8idk9ZUNdr9PrCAecxvmkiP9qTy+03t/rMGQZ7C+OdRgizhvL2yty
         f3Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917507; x=1772522307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dcHRPFmunbEFZzyxfL0Rua/ObkZPc5hbYi5K4rfoc3o=;
        b=W1NGB2MZCfvLELJnDmQ94dchvebqUMLxRhvO4iCjz7f6NE6+fVZePN90zXUniW66OE
         8bYuwtRhPPt+SwCDI72qgi0ffoEM0+i3QIMkROEG9XmWuQpBmhIseJC6iMisUnYLoXXQ
         4FnqxjRXHf6Ur4/4C04t6M1rvkOLHpWbRk2zttM2/Ejk37BTqTEL5w4xAtFHgxVnNCw1
         qhXSUHYaKm/wLTB5Ag7aWp3TPrirNW9KPzvKxVa8GJ1j7zfvhKP0CIsyZJ2uwL2pj2gj
         eDq6Off6zIKaj6mpdTYYGywGNNcdoasdmqjA+AJBlyaKSNl6J3mDIiWT4/Briy5U1Uw2
         zz0A==
X-Gm-Message-State: AOJu0YxJYHUC3imMwnchFXM4egpeYlPHvv6PtIjtbAsNlrc9UOZI+XMi
	682vIZDyHXfiE6+w5Nt3Z7OWI9Yii3T8UKv6+YUj0xgKeD4m8b/MKY/k+nlE/raCKp3V3yPOuTc
	+OOVaKNnT7fMuRw==
X-Received: from pjbbx11.prod.google.com ([2002:a17:90a:f48b:b0:356:2fe0:f5b4])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3147:b0:354:a065:ec3b with SMTP id 98e67ed59e1d1-358ae8d5edbmr10094029a91.27.1771917507178;
 Mon, 23 Feb 2026 23:18:27 -0800 (PST)
Date: Tue, 24 Feb 2026 07:18:19 +0000
In-Reply-To: <20260224071822.369326-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224071822.369326-2-chengkev@google.com>
Subject: [PATCH V2 1/4] KVM: x86: Widen x86_exception's error_code to 64 bits
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71586-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3E04F182EB0
X-Rspamd-Action: no action

Widen the error_code field in struct x86_exception from u16 to u64 to
accommodate AMD's NPF error code, which defines information bits above
bit 31, e.g. PFERR_GUEST_FINAL_MASK (bit 32), and PFERR_GUEST_PAGE_MASK
(bit 33).

Retain the u16 type for the local errcode variable in walk_addr_generic
as the walker synthesizes conventional #PF error codes that are
architecturally limited to bits 15:0.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 arch/x86/kvm/kvm_emulate.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index fb3dab4b5a53e..ff4f9b0a01ff7 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -22,7 +22,7 @@ enum x86_intercept_stage;
 struct x86_exception {
 	u8 vector;
 	bool error_code_valid;
-	u16 error_code;
+	u64 error_code;
 	bool nested_page_fault;
 	u64 address; /* cr2 or nested page fault gpa */
 	u8 async_page_fault;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 901cd2bd40b84..37eba7dafd14f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -317,6 +317,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	const int write_fault = access & PFERR_WRITE_MASK;
 	const int user_fault  = access & PFERR_USER_MASK;
 	const int fetch_fault = access & PFERR_FETCH_MASK;
+	/*
+	 * Note! Track the error_code that's common to legacy shadow paging
+	 * and NPT shadow paging as a u16 to guard against unintentionally
+	 * setting any of bits 63:16.  Architecturally, the #PF error code is
+	 * 32 bits, and Intel CPUs don't support settings bits 31:16.
+	 */
 	u16 errcode = 0;
 	gpa_t real_gpa;
 	gfn_t gfn;
-- 
2.53.0.414.gf7e9f6c205-goog


