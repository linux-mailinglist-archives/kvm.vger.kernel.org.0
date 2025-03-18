Return-Path: <kvm+bounces-41365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DADFDA66A9D
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:36:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76BF63B8EC0
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5851E7C20;
	Tue, 18 Mar 2025 06:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XjlwoK34"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545911DE880;
	Tue, 18 Mar 2025 06:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279754; cv=none; b=AkXXf4lWVG86uwJ1n7uUXhpAH4UYHkDToP2LS63ir+i3uEB3Nko0DHS2SjHE3tQfAwPFhM63O/bbvlsIj6rZyVr/o0Cvjqipb8AbAq2rxuFYBy3bszffwvB5yCLz3+k19m91iw8MFBQ/I//MHbL/xWPxnpIsBxD2uZ6b9FqKcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279754; c=relaxed/simple;
	bh=A/NnriKwL9epi1Pnix+4iNtlhu8hsdfsabDWrlRJ6YI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qYFD2Kb4W7QrII6szja53QOjk2jE/moXfzZApXREwYYMHRpVvxtk0Qu/7Du7n3XTT8hEgKW1k++nDgpyaOStT86zGCp31bBj0d7N65aHgaWaAcLCr8sO2qEthLgvoKfRU8Rf1ECq39F5ho49XUBmNwLoVwaMZH1CxjiFIM+cdiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XjlwoK34; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742279753; x=1773815753;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=A/NnriKwL9epi1Pnix+4iNtlhu8hsdfsabDWrlRJ6YI=;
  b=XjlwoK34C6ilRSlNj0kepBVNoipZwvYpioByqdzGInQtVbNsWYyHtZDX
   42e082cH9POHg5/y+HwBSpCu9PM/RK6bmAv0qA8YePmNraO8Hk0clULO7
   vud7zznXFDe7dZNmarLx6YZVBMJ9G9R9vV/JeUhCt8elSq6r+D7PQKOXR
   88iu9J/hKTg8cCQFLHmp57lzdh1wh4I9tuESeuo4bAn9+CGa9H2QHndDb
   DeaTcDdBtbSCXgGlWVB7fs/KweKYpDTnfMO7twRvINwcc7QZ9RBYCKvip
   28y/RORMLNQvV+noSO4rAz6hVNcUeVr+ihdMBm0FfyVVKN0OsUDA/4LeL
   w==;
X-CSE-ConnectionGUID: NjfbSMTzRJ+t7+aUpgjsXQ==
X-CSE-MsgGUID: gIA7bIJOSECrvhzHXYbpww==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53613416"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53613416"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:50 -0700
X-CSE-ConnectionGUID: FyornG8AQAGT4/SQUKPyYg==
X-CSE-MsgGUID: s9wF1hSIQHi9+L1/0nam0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="153147543"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.109.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:49 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 18 Mar 2025 00:35:08 -0600
Subject: [PATCH v2 3/4] KVM: VMX: Make naming consistent for
 kvm_complete_insn_gp via define
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250318-vverma7-cleanup_x86_ops-v2-3-701e82d6b779@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Binbin Wu <binbin.wu@linxu.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=A/NnriKwL9epi1Pnix+4iNtlhu8hsdfsabDWrlRJ6YI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOk3RZz5OQTjEtmP/lvSGbSm8oO/QL3anJRsZtFrnCsff
 FM1D/DsKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwEQuyTMyTGFe+Ty+9PirmHjF
 p1szny778CNN8+TmY0ZTlxjbmq2a/pThf5ormx1vrwuHO0euVrPAB75Ty+W1+W08mo88jw2sYG5
 nAwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In preparation for defining x86_ops using macros, make the naming of
kvm_complete_insn_gp() in the non TDX case more consistent with other
vmx_ops - i.e. use a #define to allow it to be referred as
vmx_complete_emulated_msr().

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kvm/vmx/x86_ops.h | 1 +
 arch/x86/kvm/vmx/main.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 19f770b0fc81..97fcbcb0a503 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -58,6 +58,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 int vmx_get_feature_msr(u32 msr, u64 *data);
 int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+#define vmx_complete_emulated_msr kvm_complete_insn_gp
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9d201ddb794a..a1388adffa1e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -240,7 +240,7 @@ static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 	if (is_td_vcpu(vcpu))
 		return tdx_complete_emulated_msr(vcpu, err);
 
-	return kvm_complete_insn_gp(vcpu, err);
+	return vmx_complete_emulated_msr(vcpu, err);
 }
 
 #ifdef CONFIG_KVM_SMM

-- 
2.48.1


