Return-Path: <kvm+bounces-52364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 823CAB04A7E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBC974A2555
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 22:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777EC28A713;
	Mon, 14 Jul 2025 22:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iRPQsn+D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C61288C9C
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752531573; cv=none; b=hK6M5fqFlnGRK9JskyfuXGfh3v5mpOnPSRG8YXfpPteUHk4L/1gX+2LSO7ru32ueyN2F6gu/WMpEuQl/6z4VNC++/ZsxTskIAA5b7qiKXZpKJTys8DQbrk8raEolXJHkUIXP16roEod2mrJcETDQc2eFAjUoMVKz1iEwRLnmEc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752531573; c=relaxed/simple;
	bh=7GCyGeK3GJDgLipc7uVxfySEqNMPPzTr1TVIlH2zcOc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YAgFma4a2TB9VS14V7ZiVr+H1mkT9sf2tO5C08UQ8OgCkJro6lgjpEq9WCzC5qhKT4ZcvIedz4dKKILLNzVyJsbOkEuehprP4RvmGSRpfx2YPUUn1t9++lodXRvHpAk8shkJ4MDc4IsNIiUwyQMb3an9i1Vx6EWEmzzgKBztosw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iRPQsn+D; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c36951518so5341071a12.2
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752531571; x=1753136371; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xbfz/7ZzL2ochzv5MAXsTSnnCzN5mMDlC6CQLEZ6rTU=;
        b=iRPQsn+DcsJvrf4zJZytn6sRFdMMm0NazNgGoxPjdYfnzowqZTnWew6/PJEtq10PCg
         +u1fFgrF/ScWPjOj3IlSS0B/toIojqLvpimoo5j2IR/5Yw40zH6yf+v0c028r1j8FMaM
         GhS8mntCtKwCChf98WlWTa54lnNZDnTdND/Mx7qhnhS0n8FRIPKUS1fBW00nZpfRn7Wp
         jfUTyJQBKD7c8bPSBpgtGPmeI9iitqDlHmuzVKa5hSJTDW/NAqy8oFLzaos396lcj5AD
         YKmPYOumvOYAh1sTyaC+FSm896LazudveayLLjfMVeSYJFhjHYPx6/Yvj2+8w7kXfy49
         BhAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752531571; x=1753136371;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xbfz/7ZzL2ochzv5MAXsTSnnCzN5mMDlC6CQLEZ6rTU=;
        b=UsHMm7V60dYOUcsuXXT3DL/zn0hARsy+bCtQm2JO54PTI4cm2H6zFwmoc/YfVBwLeJ
         o+Xe/zOeoR68erZ5PGwY3ECDVAZ1z3GIye6AXfugVlcVQ2rATREBNbpoLoT/65CU8kiG
         fyLA4LX6lcbO9eZEkquUA7/UMfkiB4kX0WjQYWez5En3icSo/P+IUiACakhHSrFEc8PH
         Ng0zRwHVy2+0IVOakcAzfbKdJZdT5YSdMjM2ApjrnyeY/HihUHRfWofVOEmMcJJcFLFF
         yWAuGr78g+hgUTEoLQQY4fAXOzKPwStmqewyFFCayNg4fbgOb0LTOINugIvTjBR1o9yU
         G1wA==
X-Gm-Message-State: AOJu0YynO5W33wkcEQ0pXvZ8tTkKDouyaKFc7fRoVXIcRB7RR07LPuq/
	ICqauUcSbHjau4w3C67lHB12LNExIRLgvwatqya4AM8mQ7OfSc3dYuR4gSYHcbhmjTM9Aj0uYZe
	epiW1Ig==
X-Google-Smtp-Source: AGHT+IGrnZQIUXQcRKwMqGgyJysUChPuwSMcdh+Eo6WAbpJZQGLn53tAPD7JZ5S1/nUxxebqZqmTSFSdmnE=
X-Received: from pjbge18.prod.google.com ([2002:a17:90b:e12:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e54a:b0:234:8a16:d62b
 with SMTP id d9443c01a7336-23dede38615mr221123565ad.12.1752531571602; Mon, 14
 Jul 2025 15:19:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 14 Jul 2025 15:19:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714221928.1788095-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Ensure unused kvm_tdx_capabilities fields are
 zeroed out
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

Zero-allocate the kernel's kvm_tdx_capabilities structure and copy only
the number of CPUID entries from the userspace structure.  As is, KVM
doesn't ensure kernel_tdvmcallinfo_1_{r11,r12} and user_tdvmcallinfo_1_r12
are zeroed, i.e. KVM will reflect whatever happens to be in the userspace
structure back at usersepace, and thus may report garbage to userspace.

Zeroing the entire kernel structure also provides better semantics for the
reserved field.  E.g. if KVM extends kvm_tdx_capabilities to enumerate new
information by repurposing bytes from the reserved field, userspace would
be required to zero the new field in order to get useful information back
(because older KVMs without support for the repurposed field would report
garbage, a la the aforementioned tdvmcallinfo bugs).

Fixes: 61bb28279623 ("KVM: TDX: Get system-wide info about TDX module on initialization")
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
Closes: https://lore.kernel.org/all/3ef581f1-1ff1-4b99-b216-b316f6415318@intel.com
Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f31ccdeb905b..40d8c349c0e0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2271,25 +2271,26 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
 	struct kvm_tdx_capabilities __user *user_caps;
 	struct kvm_tdx_capabilities *caps = NULL;
+	u32 nr_user_entries;
 	int ret = 0;
 
 	/* flags is reserved for future use */
 	if (cmd->flags)
 		return -EINVAL;
 
-	caps = kmalloc(sizeof(*caps) +
+	caps = kzalloc(sizeof(*caps) +
 		       sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid_config,
 		       GFP_KERNEL);
 	if (!caps)
 		return -ENOMEM;
 
 	user_caps = u64_to_user_ptr(cmd->data);
-	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
+	if (get_user(nr_user_entries, &user_caps->cpuid.nent)) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	if (caps->cpuid.nent < td_conf->num_cpuid_config) {
+	if (nr_user_entries < td_conf->num_cpuid_config) {
 		ret = -E2BIG;
 		goto out;
 	}

base-commit: 4578a747f3c7950be3feb93c2db32eb597a3e55b
-- 
2.50.0.727.gbf7dc18ff4-goog


