Return-Path: <kvm+bounces-69942-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GGZ1L/MpgWkwEgMAu9opvQ
	(envelope-from <kvm+bounces-69942-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:49:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A689D2752
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FF773150E6F
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C1A38E104;
	Mon,  2 Feb 2026 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uLw8vb7Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240BA244186
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071468; cv=none; b=nHXT3ZlsHvBuJ7bqxs4ZZ1/l7EkgFt4GNZOskd6WOokOz6b/lcPKylOsSvtG2UA1yolAC8Dw4M0o6uDJ9Y0CEFIskOVKXmbP3rQROkblOpeTWbH+PBKP5CXZU+k7AVCKFaYRVACrfxr8TXMUTdlzz540I73FspVflwqwdrvxH0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071468; c=relaxed/simple;
	bh=kvbj1HjLDMT0IwbHSQ9G42dRvbYAGyIjkIvfNrjJUVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mtB8GNH58RMDqiOlA79KWXjt8x+L0gQac8Vgny7gA+ExKd+p4tj3X3iAOQD0Fo+QgH/Sw54gSPqDLvbioYvP0BZNS4pkW6tYi5M7jJXKdYr8LC/ou5uRIiDz57uF06LnFek8zbVEf6RdjdAYlNKUG+zkR6SGYcupmN9RDKDdBd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uLw8vb7Z; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352c7924ebcso5108667a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071466; x=1770676266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WueI9pB0RaGc94DvvPjMzgOVbMHqnAPAFns+gRj5Px8=;
        b=uLw8vb7Z3Sd1n5gD454zT17Jw7tZi13v+CfuEL7N+rJ0nZDcDuXNSFY84RXU5yCnTC
         R82zXES/0mC07JaRbIVxbN34HTRP3qSyUiNIiPKVvN8kqCs6aIngpK9pRfGmWOYTdN7V
         f/O/ZjMnWkVNzjFzS2Otxp2sQuk/8TCIKNEN2buVbjpgTyGH60X2QKvzMRg2mE9gSdrd
         pqv4XDa+LbYOl9YtsaI3PV180tE3qw9WQi5LPZQRKP1B6IaG/sqedD02Lz5Yam2STo4s
         OkPUrBwh3tw5hpDHfSaICXv69todSQjvwRaknS8AQkOthQN2DRA+Yc+FzP/9gscmtUDV
         kA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071466; x=1770676266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WueI9pB0RaGc94DvvPjMzgOVbMHqnAPAFns+gRj5Px8=;
        b=SfO7mclp2YxUBvd7T7PIc4+FlFELWTueCU3zQFdF/k1v+KTb0Mz6VVdkjHD4PhLP6p
         BqnrN785vsWef5Uj5p2M4l73ihIzEgHw5U/farvP+/ZK82DNTL68GF4QmiO8kECEjlow
         IPro0B5MxyaCNcyosU2iDRVCr17pA/uZI96HfwTJtKqvOq6w3K47NMafUNRlOPCHJAG6
         aH5QH4+KJjJr7z2NpKxd8zbWPtFD8wMWgvYODhrlF7LJdvibgCIE/A5D4hU6JLLS5kdQ
         6yXvKLkVK16hTwyfCEPTLxP9wsRdXVj/9A5DehmIivijucqWXNRMJijvwrX11hoNbLTg
         TziA==
X-Gm-Message-State: AOJu0YzJ2dfy+E8PXuEee69lFXuYFbkYByvPYDdNFYm7Xbat4pWI0Zsk
	/T+EDgLEOG6UMBLzvze6BLuEQID9NGHC/TRyR4dgdirz3y6TyG/+Tyrn4tXtkDa6sPDZe6phJtZ
	i/LHxFC5Y21eucMId8Ij4lRqTnI00bEWsvsF10ARrc7CGMgDi+6ai04ZJX3T3krEqr6GWwZxYgA
	Wr+suDvQr4WK3wtIlJ+Ai6S2PJzX/uPk5UzYi4Idbbil8ELqa5BOLY9tGwF9U=
X-Received: from pjbqx5.prod.google.com ([2002:a17:90b:3e45:b0:352:e2af:ed76])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2dc7:b0:340:2a3a:71b7 with SMTP id 98e67ed59e1d1-3543b30027cmr12312576a91.12.1770071466169;
 Mon, 02 Feb 2026 14:31:06 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:05 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <73b986861dedf768d270a95c4fa259976b5f1d42.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 27/37] KVM: selftests: Test that shared/private status
 is consistent across processes
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69942-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6A689D2752
X-Rspamd-Action: no action

From: Sean Christopherson <seanjc@google.com>

Add a test to verify that a guest_memfd's shared/private status is
consistent across processes, and that any shared pages previously mapped in
any process are unmapped from all processes.

The test forks a child process after creating the shared guest_memfd
region so that the second process exists alongside the main process for the
entire test.

The processes then take turns to access memory to check that the
shared/private status is consistent across processes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 89881a71902e..c1a9cc7c9fae 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -322,6 +322,80 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
 	test_private(t, 0, 0, 'A');
 }
 
+/* Test that shared/private memory protections work and are seen from any process. */
+GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
+{
+	/*
+	 * No races are intended in this test, shared memory is only used to
+	 * coordinate between processes.
+	 */
+	static enum {
+		STATE_INIT,
+		STATE_CHECK_SHARED,
+		STATE_DONE_CHECKING_SHARED,
+		STATE_CHECK_PRIVATE,
+		STATE_DONE_CHECKING_PRIVATE,
+	} *test_state;
+	pid_t child_pid;
+
+	test_state = kvm_mmap(sizeof(*test_state), PROT_READ | PROT_WRITE,
+			      MAP_SHARED | MAP_ANONYMOUS, -1);
+
+#define TEST_STATE_AWAIT(__state)						\
+	while (READ_ONCE(*test_state) != __state) {				\
+		if (child_pid != 0) {						\
+			int status;						\
+			pid_t pid;						\
+			do {							\
+				pid = waitpid(child_pid, &status, WNOHANG);	\
+			} while (pid == -1 && errno == EINTR);			\
+			if (pid == -1)						\
+				TEST_FAIL("Couldn't check child status.");	\
+			else if (pid != 0)					\
+				TEST_FAIL("Child exited prematurely.");		\
+		}								\
+	}
+
+#define TEST_STATE_SET(__state) WRITE_ONCE(*test_state, __state)
+
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		const char inconsequential = 0xdd;
+
+		TEST_STATE_AWAIT(STATE_CHECK_SHARED);
+
+		/*
+		 * This maps the pages into the child process as well, and tests
+		 * that the conversion process will unmap the guest_memfd memory
+		 * from all processes.
+		 */
+		host_do_rmw(t->mem, 0, 0xB, 0xC);
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_SHARED);
+		TEST_STATE_AWAIT(STATE_CHECK_PRIVATE);
+
+		TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[0]));
+		TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[0], inconsequential));
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_PRIVATE);
+		exit(0);
+	}
+
+	test_shared(t, 0, 0, 0xA, 0xB);
+
+	TEST_STATE_SET(STATE_CHECK_SHARED);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_SHARED);
+
+	test_convert_to_private(t, 0, 0xC, 0xD);
+
+	TEST_STATE_SET(STATE_CHECK_PRIVATE);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_PRIVATE);
+
+	kvm_munmap(test_state, sizeof(*test_state));
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.53.0.rc1.225.gd81095ad13-goog


