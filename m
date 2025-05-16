Return-Path: <kvm+bounces-46865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F80EABA3A5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33A8EA24567
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0AE27FB2F;
	Fri, 16 May 2025 19:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kjBaW/fa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D72820BB
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747423205; cv=none; b=rNpWe0b7zLzwBSa+95vipQNR00ze+Hm/N5ImoeSZ58a8vZuUqDQjfzyJnGTQrWI+QH+mcJrSM2YwOy6f+WH7qpTJrvF0RIjKTEaeVwf7HOVviHBnYcF5E02YVDxrwxnUyqQsdCW4bZNC9AAjgF1cMQwifzJY5GiLnNv6byAa4k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747423205; c=relaxed/simple;
	bh=zI703iJCDbnk2s6d61LSt5o9bFxMF1iFazDfQ6c+5lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jy3wXVwCprB9XloiTXGKhH0X/ZEWyd38tM9e45A6qoesMiwB82DZjMhIWzU/yeBs+3XVAYdRH0l+BhJOCSpbpQTDwbo7G97BL2mBUhpOqMWkUBeQKa/5hwI5gHzqw6YKJsdEMJZrTRbVOZDFB9s7fdhcGW/42ylgnqqS52adBvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kjBaW/fa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e57a372dcso2649586a91.2
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747423203; x=1748028003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xw0kwmlCHmpdsX/DiL844LcPhYI529J79EzDxXuX1+o=;
        b=kjBaW/faJLsmRpkYDLcpuE44pBFxM774oWFWGs/U/exePEWWfWzkgCyILUbXl0VE0m
         RiVmZymxIHz7xgF/RhaBIji8SNXkNa0GspmhXEd7gC4ZmnYJnLM/CQLytwtNuqBmoMb7
         24xrFyevRQ4MrIQDCfndBhBzF2DTo1K8Fx32xGJ6JORBiigVC9oHzC3z6vBm6qRVpejm
         TaQi7QWvqJtemLU56lf9CDA0BzwEMB0SjZ585RksO3a+VZ6Xbp5Wn0FBmPn5wV5o/bvN
         A9lgJH46+n8QXo0A13epSqB9XEO/+Q/bEDCJVkoFfdL4Uygplw6ehIoImmRYsZlQBKWK
         kqzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747423203; x=1748028003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xw0kwmlCHmpdsX/DiL844LcPhYI529J79EzDxXuX1+o=;
        b=wFpFXtrXesW81TgfEMs0X0wbRjH/ms0/Hp6oWQ9Wl8AVmbZTHap4i9ZiGSqJpXfmDN
         gnel06KkY+nNsG452AiB6bqTVowBt3NKIXSvRUguEEjaxn1Sx+cpJTHP2YR2E97bzDS9
         871OebujGOP5pgXnup6WOU1MHJo4H/qRSsAiau8WDqZoS6u8KvLEmOHfWs9kF2jdnvFe
         ykGFBmO7jUl530FJvJKBBX4Td7htcUNMTW0cOzoX5sgGRn6H/JqY8zLJeyNxUcqCaEPp
         80BpNMV+wIhDJ9jR4zzHIvzIImqKSdCYQjhCfNI8mJFDU280GyudWBSMEtMPZlZ+Y7ok
         RuZw==
X-Forwarded-Encrypted: i=1; AJvYcCVlhZKd7X50oJcO6Uq/ufTl4JZ703+Tv8UG2XjmxKHSNKsUC+Dtz3NbXFBOQeEepNtSq/s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9UQVGYe9rQcDfSog6UWq1TTjsxUFL1V9lBYTumTg9MjYmnFsT
	GbDv3Qe0feuwg83itv6FSFs4FbHfYvDUuBC7eODCKzxogyEC//fa1Zs6ynowe+mIpPbAOdDniWz
	fCGDibqqJmx2lsB7qq6WTJoH6UkIgipOz6DjDbE4Aex2LaTO+yWuFjWB6G96SFfk=
X-Google-Smtp-Source: AGHT+IHuWIFRKFYUeYZ/E0Mn4pw8FwJ4Uk8VOlO7RIg7ETTqbymvwLUfY9oGU3oIEt0b7BaEDlNyVDhXpsne
X-Received: from pjb12.prod.google.com ([2002:a17:90b:2f0c:b0:30a:a05c:6e7d])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558e:b0:2ee:8ea0:6b9c
 with SMTP id 98e67ed59e1d1-30e830fb83cmr6780268a91.12.1747423203424; Fri, 16
 May 2025 12:20:03 -0700 (PDT)
Date: Fri, 16 May 2025 19:19:30 +0000
In-Reply-To: <cover.1747368092.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747368092.git.afranji@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <7c51d4ae251323ce8c224aa362a4be616b4cfeba.1747368093.git.afranji@google.com>
Subject: [RFC PATCH v2 10/13] KVM: x86: Let moving encryption context be configurable
From: Ryan Afranji <afranji@google.com>
To: afranji@google.com, ackerleytng@google.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	tabba@google.com
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	shuah@kernel.org, andrew.jones@linux.dev, ricarkol@google.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, yu.c.zhang@linux.intel.com, 
	vannapurve@google.com, erdemaktas@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, sagis@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
X-ccpol: medium

From: Ackerley Tng <ackerleytng@google.com>

SEV-capable VMs may also use the KVM_X86_SW_PROTECTED_VM type, but
they will still need architecture-specific handling to move encryption
context. Hence, we let moving of encryption context be configurable
and store that configuration in a flag.

Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/sev.c          | 2 ++
 arch/x86/kvm/x86.c              | 9 ++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 179618300270..db37ce814611 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1576,6 +1576,7 @@ struct kvm_arch {
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
 
+	bool use_vm_enc_ctxt_op;
 	gfn_t gfn_direct_bits;
 
 	/*
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 689521d9e26f..95083556d321 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -442,6 +442,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_no_asid;
 
+	kvm->arch.use_vm_enc_ctxt_op = true;
+
 	init_args.probe = false;
 	ret = sev_platform_init(&init_args);
 	if (ret)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 637540309456..3a7e05c47aa8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6624,7 +6624,14 @@ static int kvm_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (r)
 		goto out_mark_migration_done;
 
-	r = kvm_x86_call(vm_move_enc_context_from)(kvm, source_kvm);
+	/*
+	 * Different types of VMs will allow userspace to define if moving
+	 * encryption context should be required.
+	 */
+	if (kvm->arch.use_vm_enc_ctxt_op &&
+	    kvm_x86_ops.vm_move_enc_context_from) {
+		r = kvm_x86_call(vm_move_enc_context_from)(kvm, source_kvm);
+	}
 
 	kvm_unlock_two_vms(kvm, source_kvm);
 out_mark_migration_done:
-- 
2.49.0.1101.gccaa498523-goog


