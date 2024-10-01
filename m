Return-Path: <kvm+bounces-27717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8F598B33B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD9C528400B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886A91BC9E9;
	Tue,  1 Oct 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="TH/7/M+R"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C1BA33;
	Tue,  1 Oct 2024 05:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758937; cv=none; b=cen8Lelqy/dCCXngaNmGHcuGfdDhMRclIKCxsMvOWvO4BllUtxNIz7CZYaXZ8CPjSiorjNPtXyftJmtX/CFZWL6YxiInx9WGwU5226mM29sg617pKzE2xQmPfSokRIDYjtwhnB2jxbOCAtQZml/rvVUyE0/VcV4JO7MPqs0JiCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758937; c=relaxed/simple;
	bh=RhauUTszJT38MEGfJXe2bv1mBmYS8SmpwVKY7ixGzZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdKYd0LEmh8f1yA+fVflX+webzpG9ortTfzwgAxidBf7zVejPF94bI3UB6N9DvaTjGUUGgjdBeW244Jdn4Y+XOmTu8R+wAgCeDxAyyaqVbxOexrKLd4g1PdPGhPvO0nwnCQeST6GFQdn0o/1mycBGYk+l4EgIJ0SXtaodxXhEio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=TH/7/M+R; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7X3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:23 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7X3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758884;
	bh=7ekHwX+9vPpzrP/GM9TRol8TuZtm5qS1xrVUy97xcGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TH/7/M+Rt877lJsSxKnUxshJhnChiLUHBtRASBjvHv76Nz3lubuM5nsBxRftKf+4E
	 SC59EDwAJ3nHVoryx1fohLTUo6SQ8wKLJ6F1IDdVZcBozQgpeJKOxZl9svUH44g6/R
	 ShLuHVGR3GILGYDTj13M1wtoMXH7Y+M2xeNz14mwXftVGR8/fEj/oWj/Gxi7BrZ9Xs
	 tE1D9M1jX9K6fp1ipVPOzWWTbd04mRQy3SJTP6+OH7fVWd+T8m6g65mV/e2/YIjcup
	 PSaJ827DCQTtzHaJQP56OzRN/O6sjulBSsO1iTJ+XEijhd7ZXR83KQ/kDoShAeWeIi
	 95CNW3tJXHH1A==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 08/27] KVM: x86: Use KVM-governed feature framework to track "FRED enabled"
Date: Mon, 30 Sep 2024 22:00:51 -0700
Message-ID: <20241001050110.3643764-9-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Track "FRED enabled" via a governed feature flag to avoid the guest
CPUID lookups at runtime.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/vmx/vmx.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index ad463b1ed4e4..507ca73e52e9 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -17,6 +17,7 @@ KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
 KVM_GOVERNED_X86_FEATURE(LAM)
+KVM_GOVERNED_X86_FEATURE(FRED)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fee0df93e07c..9acc9661fdb2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7893,6 +7893,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_FRED);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.46.2


