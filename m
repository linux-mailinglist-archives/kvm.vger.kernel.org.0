Return-Path: <kvm+bounces-40440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C07A57380
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE90817856C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11029257455;
	Fri,  7 Mar 2025 21:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0oVELtF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB3E25A2DC
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382473; cv=none; b=b8tq9guHNOUTwJxwYMUO5Qm81k8U1ngbG7hS6XqomZ0AfBHxZQjdes2+e3Gqgq8mvFJd0H+gYDPZwIOGexW+GKifALtcqKt9iAkYbNrh9Woja6/1Xyv5rYBIIfM6X/Yge+5BkKYQcdGY1QANaL/eu6ImvL7k3rawsRXbRg8Sqtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382473; c=relaxed/simple;
	bh=xj6+i/OrF1BuA79hcbmqLXrQuRRJfX0Kegs9ievKP8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVZ6aCgou6YT3JQl4GMqPPpJ4wgolP3WCkdxd8vGwWR1g9OurFd00FN+A+Qv+mK+jMr2g9aXjmIEt7qRDHxvd/tAX26BlzpcwNWMcm1T+G7M6xuqg7wgRW2ntdSx2wfrizbSMEvE9jY2CcHK6aeFTZWuBOMVfCTZOiSeYl4BNHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0oVELtF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j9OqcsprTU9OZdrwHDqRbuJ0Ng9vg2bC+TfDrK/Vdso=;
	b=S0oVELtFv4H7o2Cw8V93oVwY26h9VZpg8b1BO7SSvPvofCWwg1OFQMFnrMxeC4X1Ufl9X2
	/uBiMAvQprBooSwbEfuiatNWYthRZqMY0i+rXxQ+8LSd4buwX2zzAMVhdBCCbXC2ru0LqS
	T9C8zc+IzpWVHuYyCBH/DLT66hqsXbQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-zqMuIAYAMIuU3hEPqex8SA-1; Fri,
 07 Mar 2025 16:21:09 -0500
X-MC-Unique: zqMuIAYAMIuU3hEPqex8SA-1
X-Mimecast-MFC-AGG-ID: zqMuIAYAMIuU3hEPqex8SA_1741382467
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C12DA1955BC6;
	Fri,  7 Mar 2025 21:21:07 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 774A11956095;
	Fri,  7 Mar 2025 21:21:06 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v3 08/10] KVM: TDX: Disable support for TSX and WAITPKG
Date: Fri,  7 Mar 2025 16:20:50 -0500
Message-ID: <20250307212053.2948340-9-pbonzini@redhat.com>
In-Reply-To: <20250307212053.2948340-1-pbonzini@redhat.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Adrian Hunter <adrian.hunter@intel.com>

Support for restoring IA32_TSX_CTRL MSR and IA32_UMWAIT_CONTROL MSR is not
yet implemented, so disable support for TSX and WAITPKG for now.  Clear the
associated CPUID bits returned by KVM_TDX_CAPABILITIES, and return an error
if those bits are set in KVM_TDX_INIT_VM.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20250129095902.16391-11-adrian.hunter@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5819ed926166..5625b0801ce8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -107,6 +107,44 @@ static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
 	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
 }
 
+#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
+
+static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ebx & TDX_FEATURE_TSX);
+}
+
+static void clear_tsx(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ebx &= ~TDX_FEATURE_TSX;
+}
+
+static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
+{
+	return entry->function == 7 && entry->index == 0 &&
+	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
+}
+
+static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
+{
+	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
+}
+
+static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
+{
+	if (has_tsx(entry))
+		clear_tsx(entry);
+
+	if (has_waitpkg(entry))
+		clear_waitpkg(entry);
+}
+
+static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
+{
+	return has_tsx(entry) || has_waitpkg(entry);
+}
+
 #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
 
 static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
@@ -130,6 +168,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
 	 */
 	if (entry->function == 0x80000008)
 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
+
+	tdx_clear_unsupported_cpuid(entry);
 }
 
 static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
@@ -1239,6 +1279,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 		if (!entry)
 			continue;
 
+		if (tdx_unsupported_cpuid(entry))
+			return -EINVAL;
+
 		copy_cnt++;
 
 		value = &td_params->cpuid_values[i];
-- 
2.43.5



