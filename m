Return-Path: <kvm+bounces-71528-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAaENuXKnGlHKQQAu9opvQ
	(envelope-from <kvm+bounces-71528-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:47:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F3917DB84
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEBCC31822B5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B1E3793A0;
	Mon, 23 Feb 2026 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f5Ivq4//"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F3A3793BE
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883030; cv=none; b=IuQKMsWjkHnoaPqiPZ7SOtIiJANYJytfXcpreB+5OS8Jz90CrCVJ33bfe1S2qDS/0OJ8BBLALHCYw9huUcHxXVO4O7l1MQ/V2r+LESNmhHenBF2HhsKc4XnX6yTelSOMr+QChDFGd9Nf0qJFpd31EMuP/7oAkZQY/q7WHv+s8f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883030; c=relaxed/simple;
	bh=kxeW6DG1v1HKEQ+pz2m5v66qJI6E72ZH+f+bezuzOfc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SODaHkgo+W8m3EyaBtMPmBCUIk3l9ptCm5Jkq1phwYnXNFMNV0q8yc72q/10yfT3xI0Ur6Ik0RtLMmu6D0p/9si9Ozo8IyaKw3kt/c8PO6FkpzjnM3c8/tvYv43HbSmFOBRsiuP552Y+5kQboyGYRbD4ESwOtpb99EguWXtPP9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f5Ivq4//; arc=none smtp.client-ip=74.125.82.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12737f276a2so8041307c88.1
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 13:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771883029; x=1772487829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pQoX++6jRv8xueXbzG+0cc+xPst310WvznBVds3LE6o=;
        b=f5Ivq4//JQ3sihZQ5zdw/6AwLadmIFmPMeAMjrWzBY/CaXVTxLBJaVt9BerkSGbMU/
         NNaZBtvC5oBU3eC9yizsXSuZJldRs2wC61G1Oi6FSjFU5XOQLVjrhdDkVbFo0+V5pe3M
         Bsm6Chyq7YNoZ7eul4luqbsCwAoEcH00MirNHxA5wBIohLS4DBI23fbnwSh7swgi1vfG
         gzTZazwNxsIAcaoqOyn1K0myqBvarA48oiIW8au5EqAVNgsd7PNCfwyE7qI+0jsIbrGq
         H5XzscUWL/+ToAHF2s+h7LpQeEjhwEyiDH1L2Bkj8Dp1bzG0KdIWe8c0DO+0JL9aK0ti
         xmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771883029; x=1772487829;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pQoX++6jRv8xueXbzG+0cc+xPst310WvznBVds3LE6o=;
        b=fC69oHBgZu7abQCE3V9Lwuik7k/zNPkrIsIdEZoYnhNfFZU7Ofkaajux6sYpKzCMox
         oYy6YtamxYKLjg8n7IqENZPwl2o85m7meYC3npLztpuLz06V6pcMYfLZAo/rCsd4oH1l
         VZ5wIjNd0zUFhDE/YLZENLH0AM7o+83u8FjOzPxr7J3sWU07qUI3XiH87xP1stifXdHs
         n3LPYuCK0Tc2eGJ+0wRbfmMaGEWaW08WIWZHEg82b7B8+EoR79lkZdvFe+PolOeGqwTW
         HU46Irdln3tajDle+UX6FYrlZ7aUD0lA19SnPbQm9Dv3GcFn+w49ZOvMLEjzSxNOTTmB
         PwyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqxueP/pbCa1pv8qApZndMs6rpJZBQysoFZ162x0N/2dJTE7yzdRREhrY8EPst36DizZ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTplqt0d9RXtFjpFbuu0VvGOR5jhYXV8AyPsFQlcMi/3ZkXIaO
	sqMutFsrp+jxjuDqHFOIteIO+vOqHmtA389vLLRBEANw55kX1zj9QBZ4+kzAEOSP97hk7vAkAl4
	SxDPPxOu7hIetFrxTA+rx3A==
X-Received: from dlbur22-n1.prod.google.com ([2002:a05:7022:ea56:10b0:121:7afb:490])
 (user=changyuanl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:4593:b0:11d:c22e:a131 with SMTP id a92af1059eb24-1276acda401mr4301273c88.3.1771883028380;
 Mon, 23 Feb 2026 13:43:48 -0800 (PST)
Date: Mon, 23 Feb 2026 13:43:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260223214336.722463-1-changyuanl@google.com>
Subject: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
From: Changyuan Lyu <changyuanl@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71528-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changyuanl@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 59F3917DB84
X-Rspamd-Action: no action

Set the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag in the kvm_cpuid_entry2
structures returned by KVM_TDX_CAPABILITIES if the CPUID is indexed.
This ensures consistency with the CPUID entries returned by
KVM_GET_SUPPORTED_CPUID.

Additionally, add a WARN_ON_ONCE() to verify that the TDX module's
reported entries align with KVM's expectations regarding indexed
CPUID functions.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb4..0c524f9a94a6c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -172,9 +172,15 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
 	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
 
-	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
+	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF) {
 		entry->index = 0;
+		entry->flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+	} else {
+		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+	}
 
+	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=
+		     !!(entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
 	/*
 	 * The TDX module doesn't allow configuring the guest phys addr bits
 	 * (EAX[23:16]).  However, KVM uses it as an interface to the userspace
-- 
2.53.0.371.g1d285c8824-goog


