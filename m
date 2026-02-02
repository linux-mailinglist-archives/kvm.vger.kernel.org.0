Return-Path: <kvm+bounces-69941-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKhfDsIngWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69941-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:40:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A901D24E6
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E4A95307AC22
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FCC395264;
	Mon,  2 Feb 2026 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BeW3VYxw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86564394493
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071466; cv=none; b=glv9Mf4hESS3DGvBcZNSfreHCyfzeDgYaIKDnLwetiWszFvzYlfVXMUnD9f9yv/9FWmjKgLh1tpjeRsd5JlCUJ9xvs8njxJpLFfR1TCsS5kBKngtGKiFz2+DMI1X1oqs+fl4+UCHNNOl0l4XOgVBVI7OX24cZwNxGon/JtXDAeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071466; c=relaxed/simple;
	bh=YW/ZX6oX9F/B06dsEmLuK0DlJojfZDG1otvK+cZAPoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JM3nx00SCft5qL0ppY4MDHOCjln2RdbAN8uAQUej5kt13XdNEiKFd1TkMzqleMb+yRH9O1gvdrlzLVRS75w9LqEbv/GwHA8pM4TzVETyT5Fp6YF/t0CGNUVU5PHq1lBLW7dZV9uNWye4+E9vkRXBOcw14p0PrwjHls1neTtGNWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BeW3VYxw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso13344377a91.1
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071465; x=1770676265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S2cGRIaWfh5RlpYxSCDgx+6kRt86Pq+95068IJlPr+g=;
        b=BeW3VYxwbBoar6c3JGxhZ2lmBTdDGGFKktwnhEM0x1MGdjVgZ7lTYRQ5I0NkQa6NjY
         IfYdIpsO4Xoa7uKc376NcbWpijNyWlpltGnhAH4hpK5p23yUAUAvNLsAFaiIA+hCgxyU
         /9kV5+qoTYOEuyZ/ysCMJqBauAieyPK+WbiqmMG6eMTgbDwx2vbHZGmsVHohApkgoXk1
         R6sDD2tGMm61vJrSZFEgY4a+74y7//Bbc2Wy8ypMmZ3eqyUpf9WYDoOf9QzqYyhf3Ca/
         cX3553bqFd0f9SxB3vvaranzCpU2/Em7Of4eamDMNb2GIX4wlgayzqyUOT4wkcvTeWx9
         8unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071465; x=1770676265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2cGRIaWfh5RlpYxSCDgx+6kRt86Pq+95068IJlPr+g=;
        b=uuUNWL0T9RxfcAPVoYrrJeIJuvxVrsN4eTy4iH57sAanw1axZopO0PPudZh4wzm1sk
         Fusxbz+PFZFlkaGdMkw2vv+E6XVq75d2lsrITuFnmcKJ5RCu5seg7rbzkc5ZkhObtiO0
         JHFtaaP3iamVn/r3gmtBW5AkDRucYqF7PNNWqh9qZJwhO/OYavzJp6JeqNc0zlpRL+47
         aBjd81dRRYi9x8JxHqFd/8aYaypAkI4/ydSVC+83FeumZ/P8d78N5Sms8fTa3gekri3q
         e9Hy3DPciDriA8gQhqegDvaTkKvpWuSWfk+r8Nhkg89racsOacQQmnLztSZV4QS6DKC7
         QXZg==
X-Gm-Message-State: AOJu0Yw9sc8CHGLSXo4ucMXn+ReWlsPCxQ3mA46e2FzrVYarYDluzvd0
	cKor4mI+1P7svw/LBuX//qLxQlTS+cC1YuZ8cq0P58FMJgx5zb/fA5CqeaatBkuh/MTwyz5plI0
	Vgps7yy4A/mGIYVD9dEqJGgofUF7f+X2xKziPxpK6IDz1HiqkelEjBepItXKUTAJlePJWcgqb6G
	BJizHljd9mu9wc0rh9fDohy0tqvGv87KJc/IYEMN622MP1Z4lhuPCTppaUtH0=
X-Received: from pjbqb9.prod.google.com ([2002:a17:90b:2809:b0:352:ca2d:ce63])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1fc4:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-3543b2dfddbmr15186557a91.6.1770071464619;
 Mon, 02 Feb 2026 14:31:04 -0800 (PST)
Date: Mon,  2 Feb 2026 14:30:04 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <d6810fc2047f047d7e297082042bc5a242f108b3.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 26/37] KVM: selftests: Test that truncation does not
 change shared/private status
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69941-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1A901D24E6
X-Rspamd-Action: no action

Add a test to verify that deallocating a page in a guest memfd region via
fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
status of the corresponding memory range.

When a page backing a guest memfd mapping is deallocated, e.g., by punching
a hole or truncating the file, and then subsequently faulted back in, the
new page must inherit the correct shared/private status tracked by
guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index b109f078bc6b..89881a71902e 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -308,6 +309,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
 		test_convert_to_shared(t, i, 'B', 'C', 'D');
 }
 
+/* Truncation should not affect shared/private status. */
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.53.0.rc1.225.gd81095ad13-goog


