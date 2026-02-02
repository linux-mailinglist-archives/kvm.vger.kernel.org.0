Return-Path: <kvm+bounces-69938-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MHcXCt0ogWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69938-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FD6D265B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5B1DA30A1387
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10011393DF2;
	Mon,  2 Feb 2026 22:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PErSnl9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F813939DA
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071462; cv=none; b=Nl8sxKIizG8T6LNKDbsqqpNpLuDjF4oDz/2hG7r5k5ksODOl+37lGdRhfIa22goPCxiSdPNfeA13v70aei0jXNDWl6ZH80ncXUvJqvXiFY1tnQWSLmk218+DADOzueNvxcw6Nq7vO+uMEj4KtWVkCPf3gcpU6RbSjE5JPyyOsRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071462; c=relaxed/simple;
	bh=gQoVKJ/MXjshP6WlZwkjatf0oU9CaCzLX3p+TMTGhTI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OQZheOAN8mo0bqMA+0Ta+Dw8PcVKQDueKt/8j3BcfFP5SL61ZzxLFc/OD7bzeZRD76AzwoRITCh0Fb+y3dlGURvvyLtyW3BhEYs2iLU5hXZmey+/GZKXK61BVjX4KK3CK+P9nBDQJeOUmDNlJP8nqzYfgLyMbCTOLq62a3zu4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PErSnl9X; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34cc88eca7eso5024924a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071460; x=1770676260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3QpJpjNtiQqUFaZF1GHJzrZ8wOPh8GbrrWjKTVRiEHc=;
        b=PErSnl9XM9V7+Pz/pSRBK+D22+69iQNN74AwmW3ns+PgTp56VbZ4U3jnqECYPIWtPh
         8WFYMna02mrI/0RRmiK+r0sxG7gYemjtj9SnR9+2wLk3HwEvAe8FhJHqUed6O1Fef+jt
         g1WfUmuisZDyNzIfx7boa7x1xGAwE1LSrKIXtbPDLc7d3CHMRejRMKP+kaqm3AnyeUEs
         1qOaeC5KM1UgBLv6bwsI/mcggdcTmnSuLSKcdpRmjziM8K6vmh/SIsriJrBwR7YiWfnU
         rloZqZ4Grmk3+QEuBu5g+QZQF1ZGYZ2SoEQA+dYY4quMOmSC3XyYoVnPdyKLAjvLSU3k
         jCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071460; x=1770676260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3QpJpjNtiQqUFaZF1GHJzrZ8wOPh8GbrrWjKTVRiEHc=;
        b=ds3kwKICr4XJESHUXQbX56EzmCEWBckAGLcy+Mhl2OykHjyHf77ncgW6BiG+t7131P
         aJGQg+v3GlsxR+fn9GjdSCO3XlT8vQCkhBe9+3hRvKljqEecOp+OGX+a9eVJvWdNcc94
         0r8pFpAp9EPfdj3luDxQUt8YXMOUsVjRKZjxhGIcpToqt+0xiS9vDuawo0VLXybdPRGC
         z1Pi+hnee0jahvdc0ALYrM7QU+htlFLqR/Iq1YyRQQDu2iIASX8nh6wV3TaBeQZLoQeB
         ie/7FN8jnVlFtnl2yLooChVuNoCAqzrHjUt8D5CAIlr/syZWxsQY8XnTf/EeDdqUf6cq
         Zd0A==
X-Gm-Message-State: AOJu0YySX/6w3ygr9jXoA3tTO7ja2xTE6slGLPfzbZuhdLAYvWhh3SoT
	lMVIzOY27phSO+g3aXWpKFIoz/wDVHBm2Xv4z87Nf0r8n7PjCg7A0N1aDA0dhRWqkCZJ75e5HSu
	fbccm3E9yWzO/gKv0v80v+NSAcTmru/m1whRD9+KDLyaKFnIPKUPFRr20F9C00zBc1hn/GRCqao
	6648qk2J1nc+g2WUg5zO5ORCfnJZg9XignN5aZrMrXA+g1PmJtuukOz4CAINE=
X-Received: from pjzh18.prod.google.com ([2002:a17:90a:ea92:b0:352:ba50:2819])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c4b:b0:343:e461:9022 with SMTP id 98e67ed59e1d1-3543b3d6577mr13985758a91.24.1770071459728;
 Mon, 02 Feb 2026 14:30:59 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:01 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <8d37226a3827787d685315dfe730f099ec8b18dd.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 23/37] KVM: selftests: Test conversion before allocation
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69938-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55FD6D265B
X-Rspamd-Action: no action

Add two test cases to the guest_memfd conversions selftest to cover
the scenario where a conversion is requested before any memory has been
allocated in the guest_memfd region.

The KVM_MEMORY_CONVERT_GUEST ioctl can be called on a memory region at any
time. If the guest has not yet faulted in any pages for that region, the
kernel must record the conversion request and apply the requested state
when the pages are eventually allocated.

The new tests cover both conversion directions.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 8044581d5e5e..b48aa5d9f8cd 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -255,6 +255,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 	}
 }
 
+/*
+ * Test that even if there are no folios yet, conversion requests are recorded
+ * in guest_memfd.
+ */
+GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation_shared)
+{
+	test_convert_to_private(t, 0, 0, 'A');
+}
+
+GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
+{
+	test_convert_to_shared(t, 0, 0, 'A', 'B');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.53.0.rc1.225.gd81095ad13-goog


