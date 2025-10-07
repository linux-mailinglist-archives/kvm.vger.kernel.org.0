Return-Path: <kvm+bounces-59606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 583EDBC2D71
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5523C1891001
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21842275AF4;
	Tue,  7 Oct 2025 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZ7RNk4l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5283D273803
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875298; cv=none; b=I0S7HOkVG+ADowikCIGqpHSu7m40UziYD7ui/JQjVbvReDx8Stf3gllv2weUrMHwRIgM7iJE571dlLFMzjOXI85XNkos6+0K73V9S+WqHLGCGiCVWPhoGFEOIRMwh5/fpf529SZk7FWL+JttYTktyyKPhpx/QINnzAZ9BdMsKAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875298; c=relaxed/simple;
	bh=pEAhEjGmE/6E3+3IorVbdBNzf37J42NibPq0N4C1YsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nMmIGXAPWFslTaAZVa0vpVBmWz/xwgFVpIl7fZYVY5Gk/y5X9lLpdztS5DiSKfScrmqvk9tQoP5flcHIkjKHfiUzp6iSqRfY+Zxoa7ci3ymxj/CAjXwq2b2FNBZhUhaxOWou/0QspKrrH5wHN00SqdhjqxPUCfXQn68Pr4WuXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZ7RNk4l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269af520712so74211355ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875295; x=1760480095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zTQs0EnNDco2mpUUW8A1kWTJ2V3fPeD2Oux5tvQu97s=;
        b=AZ7RNk4lRemOUJ1AQ+l0/R311etQWhq16/9XadfgFbK/bpEjz5Jd3Wgu32razvWC+H
         S2QDEa9N6GSPZ6qyyGXpnuGeOzxBNsihz/y+Eii5BoY4xWnGC7JY7O7Y8Ybo+wpzcHo+
         lmEgA9mzTkelrKaVzaEf1ixU7Rbi3HMZOU3jnWKWMUUxiT57TewXx1RjB3l6Rpt01F1m
         oqWBqWZ/NkNRm4WpZStxWa4xQjoSSh8CP7hejF3OwxKiU+/TOifRRtw05YkaBg2Ooof3
         T9rkAskaTRHYd+Xm3/b/H3ev2r/vHkOk9lNO+j9R0PA6WOGm1kzBa0K/Ri+P8tMr+T4m
         LHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875295; x=1760480095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zTQs0EnNDco2mpUUW8A1kWTJ2V3fPeD2Oux5tvQu97s=;
        b=jleBehrDzbuHlNoxY8PtYAZ69PsEYnkcAOKl8ZBgql/tOr0A4iCm0+ZABYaJu5HmC8
         3Uf0wEEB9UkZ1x9GBPNYGc6254y/VQ/4AYDeGt2ti/l8VOGXBTAFiTDIsUGizgIvrxJF
         iEHtQ5ww5NsxguoE1pYXijUNNNuevzjVArgo37M7D0p2kyRxyKhT89VRXmdgm9xEGvgI
         LwgNGTz1fV8/qzV9ARg5SpEgfqb9E/2K3WFVNaMg/uy9VXYzqXWshycYbiQaxe3BkQjZ
         XSJW+KNZrnOR9t/9ykQEuMW83Vghe2gc5uee0grTWr298bs22YdHlG6UXISXXUeEwjjl
         3AUg==
X-Forwarded-Encrypted: i=1; AJvYcCUz6BboWdT00CpO4rnMrQod3Pg6fAzZcgwKmXlqkqaTQO3NYlmAbCWHI3DZpfZJoAibMPE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8BG9keJ0oetXyn1F+WLANSiutgd43iMK2sPHyHq67d9fe6nNj
	5wEJnG10ny+0HjQIMZY6Lf6o88VcLpweUiHnjJjuZFV+0CXJf+zIqInpNm6qERrq5wpPvvE53i9
	P6L2Gbg==
X-Google-Smtp-Source: AGHT+IE4iOU9kwHgBlllnocBeU6IrHkDCIzq84NfugFiFee0pXpv+6bFVeJqE6gHwaZr6A6SdSFRTrYPG7c=
X-Received: from plhx16.prod.google.com ([2002:a17:903:2c10:b0:269:8ca7:6998])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e943:b0:269:ba8b:8476
 with SMTP id d9443c01a7336-2902741f0c1mr13607885ad.56.1759875294643; Tue, 07
 Oct 2025 15:14:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:18 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-11-seanjc@google.com>
Subject: [PATCH v12 10/12] KVM: selftests: Add helpers to probe for NUMA
 support, and multi-node systems
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
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
2.51.0.710.ga91ca5db03-goog


