Return-Path: <kvm+bounces-60192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1FFBE4DC7
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 164084F6848
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C67342C82;
	Thu, 16 Oct 2025 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEbtd3Zz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01FD3321BC
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635828; cv=none; b=shmSpy+p7pqFeybDqFGjazjkby9p1wk3NkHZP64HjWHHTscyLKBJrT1An7YEPPRy79EI4OzXf7gg23prS2GawIwDGop0LbyKyX2wVzmZFmVVHo2syzQzTq8pOR7ucEgsqd2eUHwoUL7P4j8nwp0oPsg4rpjX1BThivCOR56N2/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635828; c=relaxed/simple;
	bh=zAGO8GGKnG833AeVLmHSCE0KZKwUxrVP8lLpUQ5jXwI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhOrbqa69ehGf2iRFTSalI2RQUDYEsC29wv8MegeRRrrHCx+JxW5cHZjGkxofk2YY7chSofFN/wpX5O/RFgFg1LYghrJMxuNydKb/yO+ocU8aXxXSCCeHMRxJTB4w2RwuAmu8hyz5Kyu/d+7Ni9W3rajD5tF7yrHd3VP7YecTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEbtd3Zz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bb4d11f5eso807659a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635826; x=1761240626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MjfqQK1ImtipxRLIgz8KiAh5ZIfb00cJavU+9G1+jb0=;
        b=fEbtd3ZzOowLdKVTWaGjBBY7DvA9kyNhFwKNkDnoNmwedwhX6/QUyv6ldtr1m3nM1u
         Dhk/HWSKuudQNr5nd4BtZUeAFy397atggn4uDKLMoIy0250RVdv1ekp9GMVUfKUjuhSw
         I5G13unvidNT3tcEodTi7wJ9ka64d2Xi2iQnr3D2iLO9Mi2hKYXBLd6wMP/HIb8BCnCQ
         bv86fe7hdAHDE8PLJKkGbHvFkdr9Oy4v6uBg8sEP9yR0S3Q9TO2FSABV9jb84RkcUtM/
         Vz02Hc3MfEGI4ksGppQGQ7FgGOzWmiybzgYZwSmbg/vODjBcOVuojVgTomrGGjaOdb6p
         3Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635826; x=1761240626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjfqQK1ImtipxRLIgz8KiAh5ZIfb00cJavU+9G1+jb0=;
        b=Glg4vxhhyT8Bvts1W0vlcWzwVg/0TIU5ENA1sZ2a2zhfIrJtIBCAwXM4u+H2drgZMB
         F6MkT5aOkxLYKKyzulMLY16W6N+oNsEOtXv6PMr3l+EjNJG5Dw9YtLkwkIMAAFI4LKXF
         0voqwldvqVEGMcLg8WG+FL/FIbgYj6Dm4TsOTxp21y0BHVuhvn3XspuOLHn/KY7GZ982
         ml2KBF+P8yRrnqaWDbtLASUp90SNXP3dfQTJxTEGC23qU1Xlrcxj3BSoDWGE7lqxqKo+
         eMOlJ2Ro1Bt8nwig/h3cC2gXsQXAToZPHrl9KRyLn6nPGRhrognTDjrhdjnLH+BtaNuV
         274g==
X-Forwarded-Encrypted: i=1; AJvYcCVvf2tlqHrxWtQEzGk4DIWQ61HZ/NVDtdnaxu5B0+4cIfACF+Ok6rQRsOC9JWNYlNBTpLo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ZkaUpW8fxIvNBilyFlSTWdjk+6RroA8/s+FOVkLy/ppmijb1
	rwQtD5RSbslFM25subNjHRCSFRbLkLDd2MOB3vhJTmrMgGQ0dHqmcJMJUoDNivwlW1UOjG0K0rm
	R6zcwdQ==
X-Google-Smtp-Source: AGHT+IFL+8SBcvf3jgd/Fu0Ax5ddowRDHeGJ6uBAQjp5iYeeHHRFS26oOh+ndsfJVw9WwZQocpqdf8pR2R0=
X-Received: from pjbhh14.prod.google.com ([2002:a17:90b:418e:b0:32e:cc38:a694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cce:b0:335:2b15:7f46
 with SMTP id 98e67ed59e1d1-33bcf8f75b2mr642670a91.21.1760635826197; Thu, 16
 Oct 2025 10:30:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:51 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-11-seanjc@google.com>
Subject: [PATCH v13 10/12] KVM: selftests: Add helpers to probe for NUMA
 support, and multi-node systems
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add NUMA helpers to probe for support/availability and to check if the
test is running on a multi-node system.  The APIs will be used to verify
guest_memfd NUMA support.

Signed-off-by: Shivank Garg <shivankg@amd.com>
[sean: land helpers in numaif.h, add comments, tweak names]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/numaif.h | 52 ++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index 1554003c40a1..29572a6d789c 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -4,6 +4,8 @@
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
 
+#include <dirent.h>
+
 #include <linux/mempolicy.h>
 
 #include "kvm_syscalls.h"
@@ -28,4 +30,54 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
 		   const unsigned long *, nodemask, unsigned long, maxnode,
 		   unsigned int, flags);
 
+static inline int get_max_numa_node(void)
+{
+	struct dirent *de;
+	int max_node = 0;
+	DIR *d;
+
+	/*
+	 * Assume there's a single node if the kernel doesn't support NUMA,
+	 * or if no nodes are found.
+	 */
+	d = opendir("/sys/devices/system/node");
+	if (!d)
+		return 0;
+
+	while ((de = readdir(d)) != NULL) {
+		int node_id;
+		char *endptr;
+
+		if (strncmp(de->d_name, "node", 4) != 0)
+			continue;
+
+		node_id = strtol(de->d_name + 4, &endptr, 10);
+		if (*endptr != '\0')
+			continue;
+
+		if (node_id > max_node)
+			max_node = node_id;
+	}
+	closedir(d);
+
+	return max_node;
+}
+
+static bool is_numa_available(void)
+{
+	/*
+	 * Probe for NUMA by doing a dummy get_mempolicy().  If the syscall
+	 * fails with ENOSYS, then the kernel was built without NUMA support.
+	 * if the syscall fails with EPERM, then the process/user lacks the
+	 * necessary capabilities (CAP_SYS_NICE).
+	 */
+	return !get_mempolicy(NULL, NULL, 0, NULL, 0) ||
+		(errno != ENOSYS && errno != EPERM);
+}
+
+static inline bool is_multi_numa_node_system(void)
+{
+	return is_numa_available() && get_max_numa_node() >= 1;
+}
+
 #endif /* SELFTEST_KVM_NUMAIF_H */
-- 
2.51.0.858.gf9c4a03a3a-goog


