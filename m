Return-Path: <kvm+bounces-71082-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sPspDNrPj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71082-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:28:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A42413AA92
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3BAEF308DBB2
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0512C28A1E6;
	Sat, 14 Feb 2026 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AzbM1kmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BAB295DA6
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032432; cv=none; b=KYuQM6n0jSBfJVIfGo0TRCXRMe5EYeAoMgCs6ArUXw6YglGMSV1OgdQy4T4iPmpuvv/wlxFjYg1SAasiu2z9ez8UGGNBlCIRCNNPdAUbNj5XecJgMX0g7uauzycPwoUR8pR/8WRlbOYaMLMXPYk5rpgNJz2pnaYPDHyp4z04898=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032432; c=relaxed/simple;
	bh=uHRBT0xtiTkIZnuHIJP94+r3B3sUuzdcITtjzmdIZxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qHRKIatde2p37LezY0i5MNLxz3YvfItLdbHWnzGUkYz5VP6mdm3C0lN9pQPgtyc25RwsR3WLfwy4MF7zEnBIBX18y2X2+ah4viYAyHgjyk1dYPtFJg0J+50xps8gHwbV7iNqv/jprxOjn3A57jHudhPqAafrzveqtsybiwtxmhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AzbM1kmG; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaeafeadbcso16553095ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032429; x=1771637229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RDtoclkNp4NWg025cIg81rPLzczzFSfFPqIQKO5nW/E=;
        b=AzbM1kmGvfonESNeM5gf/EkKtK14QmUOulaHH/TuYm86IiW+1usGe5/Qujy/9Z9M/a
         8StGD2vquyv9mlQC7jysNKFrluPX+TknqZFGe1Ia2f8yAmNnxqjOeJJwUBz7NQ3udBta
         u8GMB7uPEfjoH4ZSA2Yef2/TRr30VQdF/JJYwNOWUKF4ySU8JHoAsNdg5bXxq/xsugHv
         qEZS/yaLJUaWelLgwGTqgnBr/6QOeMVaDLw3vT9nZLGiAEQSFg3kyjAICWqhmcO9CiMe
         YB9r27WHLcdMkpTg7hLpP4/3WLt9Mv+jI6lVNxu+ZxvBaqyZC5aZhfO1dtMX3Jos/u9N
         rCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032429; x=1771637229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RDtoclkNp4NWg025cIg81rPLzczzFSfFPqIQKO5nW/E=;
        b=FPJn4vtJvSGWkG7NXl5A4hh93ig5V9j6zYxc0NxxxaNGkVdZ/heJq+PHL8c2UKpv6z
         b4qJbaWs/WsJFOYYyHjso4euNjWKNAik29Y9GyIQVJ3gHXPoUUmyLLRM+3Yp7y6eiCHN
         7wdSEen7sT4lf3Z7yh4/1/VFoyyuD31sCl9ibukJRpCm3Izjy7TT1IlYiq5oXOr0y/Um
         g/DXtQMYbLMlWaC4pn4zgD819f0lgOb1sdAtmk9ovHfc5h7VakuY40kTldOnUtBGF76w
         QogPVl+N0JG8hYPsqbO98N45EtgtgHnGz0dTZNQWKRw5QHjrPLReqXn7hpFVcJXjEl3m
         2bNA==
X-Forwarded-Encrypted: i=1; AJvYcCVh0sGN8bEfhpCP861SUCTj7i/ejIucNljI5c2j4jnWhDjPgVHaSXW2C/i6CoEEYLjhvzY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxboM6/cD+s//rZAflB7dGpSE4oXqDHmvF1kip7JVgecQlzJFm0
	kjhHy+39BLOZ4tMOdjeUcKdXJI3Ib9q4uxdx3dVjo7Mfb+XKcNv0jCi2qRXftP9KighRVtzj9Xk
	eqpeLMA==
X-Received: from plil7.prod.google.com ([2002:a17:903:17c7:b0:2a1:10fa:4a4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f609:b0:2ab:230d:2d96
 with SMTP id d9443c01a7336-2ab50521f49mr39916555ad.11.1771032429246; Fri, 13
 Feb 2026 17:27:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:48 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-3-seanjc@google.com>
Subject: [PATCH v3 02/16] KVM: VMX: Move architectural "vmcs" and "vmcs_hdr"
 structures to public vmx.h
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71082-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8A42413AA92
X-Rspamd-Action: no action

Move "struct vmcs" and "struct vmcs_hdr" to asm/vmx.h in anticipation of
moving VMXON/VMXOFF to the core kernel (VMXON requires a "root" VMCS with
the appropriate revision ID in its header).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmcs.h    | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index b92ff87e3560..37080382df54 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,17 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
+struct vmcs {
+	struct vmcs_hdr hdr;
+	u32 abort;
+	char data[];
+};
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 66d747e265b1..1f16ddeae9cb 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -22,17 +22,6 @@
 #define VMCS12_IDX_TO_ENC(idx) ROL16(idx, 10)
 #define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
 
-struct vmcs_hdr {
-	u32 revision_id:31;
-	u32 shadow_vmcs:1;
-};
-
-struct vmcs {
-	struct vmcs_hdr hdr;
-	u32 abort;
-	char data[];
-};
-
 DECLARE_PER_CPU(struct vmcs *, current_vmcs);
 
 /*
-- 
2.53.0.310.g728cabbaf7-goog


