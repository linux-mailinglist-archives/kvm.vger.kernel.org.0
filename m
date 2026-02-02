Return-Path: <kvm+bounces-69937-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBq7KqkpgWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69937-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:48:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D71D2711
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:48:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA0B0308BB27
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92284393DD1;
	Mon,  2 Feb 2026 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tzcKLn33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3655D3939B2
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071460; cv=none; b=XBiv3eZhACS79uS3WVnr/UTutTY8kUeETGvBKXpzcrGoscfRJOQw5CPNzCd45HR2PjF5uChx+6qoGb8kmp06AXGmlZKaJoriHvFGx/QFaHZ0OcTI3HdHwI7gAY3yBtN+oS0b1RnSmudRUhYImD0ClTP7fEepCGW3oO3a3fh2BkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071460; c=relaxed/simple;
	bh=MubOPYTNBZjIyz8NadIFdNxBT4WQuyxCtLL8lSiaL90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gzTmxyrzllZmQDox+EbMhHSlt4hA8b5GJghfgsajzDNDYq7R3uH45RQO4vqHbRWUDstMdnr82x/FpvPIpvqRUtGL3brcaGLkh39cjLPQ22Ol479cfS/FMLvG+HHvlPD6uPYV94qeaLVrxZACE46dw9GhCa3pMlMlt7ENLzOxZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tzcKLn33; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3545dbb7f14so1866001a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071458; x=1770676258; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vv5nREZ9NtFZhdpOPr4a9gxWsdTuhK53IZ+Alq6Ji30=;
        b=tzcKLn33e+ekU6ydIFyRjpVxy9Fw5Kgjn3ls4pEA2IQWLs+wljVn0NpucZBC1ZTofa
         jwracZhk3YQkvHtTZZ8kxDyfOVuiaVOF7Wfn9RHCmA1yDb0sBLX+alIBaz5xuuq3cgwI
         siiz+t+nr8E8Fwkl1Fv7QzMNbtwLtwSWIHamyZa1GLS98V1/rhr2Yq0/idKe528zE/Eu
         9+IHFqnp19wFwTmlJP2MSthf8pGDK5ODGu6d14lN8grbzHUtHKi8RNxSJRCT/SzELQBg
         y6Mi4r0xMTg0xr0KdRarzBcJ7Dbg35MXICcaINVjclMHHTZFS/6nHLH7b0KEQyH4XIjY
         AJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071458; x=1770676258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vv5nREZ9NtFZhdpOPr4a9gxWsdTuhK53IZ+Alq6Ji30=;
        b=poL4t8jQ28iHLPRCVLi/wbAx13r2xWKkno0jG1pSl7D5HFS0VkSw79KRAYnGCuZ9tx
         Xf9ioGrzWmnB/t9tU98WOgYq3HHqJP55j6YrD86OSxe88e01h6dqbvEtwaZoKJiShBLH
         DA6NdkHrbmqfy2MMPUzM2g8LoYlLsA19rnoQfPghuund7JO8o7Nzn5Gsl3ApjTOk80/t
         mthVaeG+aXYvL3TW3bmn1V62NQOodE/X6yxys02DAXc3CgjzhZVOAop5wFtUR5VbAhJo
         7cvCdg/YOOFajNdJ0nxTZVG2/zeHc5XJCbEhU4ezDfpp+t22rCciGNuds0xU9M0NyDcG
         zrHg==
X-Gm-Message-State: AOJu0Yzu/+8L98Nkoom/69oDfE1M7Hh0Z5Yu55sbYB3HjKQSYW11M6Ez
	qsGer4O+SDFyRvtgASFQJiIO2gMq4rY7nN+2Ngi/wNIJu6DT9vslrXPXrv1p0UXqjkzjbIoEfhU
	X0SKBeHkNhixXqb0qkXBr9w4I5aiL3IBdlC0mLjmLdtaVJ96TlI2PlxnfF2191j2P1/fLIP1aFS
	qOPxH3b9jDlyvFkxN0QWWqNL4VMHFstiwPgTWJ/VkwKJlZyWtKRvsTq7FxZbA=
X-Received: from pjbov16.prod.google.com ([2002:a17:90b:2590:b0:34c:44c1:db7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d604:b0:352:cdda:7aa7 with SMTP id 98e67ed59e1d1-3543b3ac865mr13338233a91.24.1770071458196;
 Mon, 02 Feb 2026 14:30:58 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:00 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <63ff206feba4970937f9c4211e5948af8f71b301.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 22/37] KVM: selftests: Test indexing in guest_memfd
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69937-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55D71D2711
X-Rspamd-Action: no action

The existing guest_memfd conversion tests only use single-page memory
regions. This provides no coverage for multi-page guest_memfd objects,
specifically whether KVM correctly handles the page index for conversion
operations. An incorrect implementation could, for example, always operate
on the first page regardless of the index provided.

Add a new test case to verify that conversions between private and shared
memory correctly target the specified page within a multi-page guest_memfd.

To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
macro that handles setting up and tearing down the VM for each page
iteration. The teardown logic is adjusted to prevent a double-free in this
new scenario.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 438937980f04..8044581d5e5e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -63,6 +63,9 @@ static void gmem_conversions_do_teardown(test_data_t *t)
 {
 	/* No need to close gmem_fd, it's owned by the VM structure. */
 	kvm_vm_free(t->vcpu->vm);
+
+	/* NULL this out to avoid second free on full teardown in multipage tests. */
+	t->vcpu->vm = NULL;
 }
 
 FIXTURE_TEARDOWN(gmem_conversions)
@@ -101,6 +104,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
 	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
 
+/*
+ * Repeats test over nr_pages in a guest_memfd of size nr_pages, providing each
+ * test iteration with test_page, the index of the page under test in
+ * guest_memfd. test_page takes values 0..(nr_pages - 1) inclusive.
+ */
+#define GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(test, __nr_pages)		\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	const uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
+	int i;									\
+										\
+	for (i = 0; i < __nr_pages; ++i) {					\
+		gmem_conversions_do_setup(self, __nr_pages, flags);		\
+		__gmem_conversions_multipage_##test(self, __nr_pages, i);	\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -199,6 +225,36 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+/*
+ * Test indexing of pages within guest_memfd, using test data that is a multiple
+ * of page index.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/*
+	 * Start with the highest index, to catch any errors when, perhaps, the
+	 * first page is returned even for the last index.
+	 */
+	for (i = nr_pages - 1; i >= 0; --i)
+		test_shared(t, i, 0, i, i * 2);
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_private(t, i, i * 2, i * 4);
+		else
+			test_shared(t, i, i * 2, i * 3, i * 4);
+	}
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_shared(t, i, i * 4, i * 5, i * 6);
+		else
+			test_shared(t, i, i * 4, i * 5, i * 6);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.53.0.rc1.225.gd81095ad13-goog


