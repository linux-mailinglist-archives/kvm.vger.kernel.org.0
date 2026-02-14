Return-Path: <kvm+bounces-71099-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mE+ZGi3HkGmqcwEAu9opvQ
	(envelope-from <kvm+bounces-71099-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:04:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 939C813CFD2
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:04:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 99683300441B
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 19:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30422FBDFD;
	Sat, 14 Feb 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8zUdN/K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3BD21638D
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771095845; cv=none; b=kAlDoN+gd+Il8qHAA4jb6FJGiZCAl6dcOIlf0q/ApZkB/nhSOIaf1K1AGqFzHiVDhT7vki4+ZYKoDG7ZWZxiwQbBBlw92pXAVtenF9A8fU7p7iHaKq3r7+uCfi/XCCYaQlKa1fgz3oRwiUNOZVZnTTYZnYsJAiTfKjZg/DO56W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771095845; c=relaxed/simple;
	bh=puAYeLBI+QJ4JHUJ6aMZV2UekL8ssA/k4WkKYffhbOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U3DXekjTOkHsldMH7O8Uzko123oKm9TbwxB9G59eFsQxJeFFwT+n5YwZ27E/z6T7Xn2SoujKFUdzm/oKLtQKMiKAcgXMmdDbwyeGj9mdl1wPjBhabCU17tT+BH/cKI0F2GmX+4NE4gjcr+5tzg5HFm9Kx3f2dut/dv93n93JGbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B8zUdN/K; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d1890f7ee4so1194367a34.0
        for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 11:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771095843; x=1771700643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYWEyjpYVY2l7pzkthPd8PINyDJVvlVJRdS43y6R8B0=;
        b=B8zUdN/KPT5ZVmP5hBVkXs7E8QZxmUWl52UdfOqzV9RFNt4mgPbZM0LTB2rUTOCvNy
         4bw9Bt5Zpz/oo17McA/pmKmk5ejEDbj5B6d7V4UpzOsjLwt/A+Lt9gcNIPb33kf5Id04
         VUDsmXl1cZaV91ScTS+R4EJTltw3Rzv6O1BIH5cZzmwszvu7iGorAk9Kioz5v6gWi+ZA
         l+G2/OuQVsfRU1mNWbXT8YujlpB10qgYL6bKmvXZmTBjnohXk9nz6FxNbA+zpBrOiC60
         g6SMwGWNHBG10fw+PVDin2cYE28GURutl5wlYAttBE3d/tikHZEWemp0jGinrED3h8Ev
         9O8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771095843; x=1771700643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYWEyjpYVY2l7pzkthPd8PINyDJVvlVJRdS43y6R8B0=;
        b=WO4wkhgLm0cpz5RrXnz0sINB9MjJEerypM2hOEAbc4YslYU5XdEU1ZFEzPd3b/4v6P
         ptL9ir7cdg0ePx+mZJNNB1UoYMa1UhzOp8PgBWPuTrUfkzjB4omf2ael3KuL1J8MkExd
         OwFtwqLLrLRSU8s92kELAksN1cVnnkdaHNZczA376xhVymSpQJvxK1pnvChmgdI/l5Xb
         jfbCXS2fV7OyLj5yzdH9pMn9/mXs5tignNfnlQ2E/apUXM2+k/dJQaY84eCAXCoke/Pr
         mrf2JOHceIqdLdfuakMnt4XofCmO2rXtNoQRfOrku1qafts5YDWjxhRsHn8dape8hKWl
         tucw==
X-Forwarded-Encrypted: i=1; AJvYcCUJE8JbeeP8fhE/j0SXnP+LpkI1RFEr25gKAAkSOx9dWVMx+c5cqvElMBodUFv3alxMkts=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg5XH3Ob63OK5zW5cpVuIXRQN3rRreLCa99+AgxJjEBSQ2xc3l
	vFILDvA2uWqZNf69q+SFp74tAp8lRW3rxcvWj8uYokhSbz6NN4lDet7O
X-Gm-Gg: AZuq6aLQbSt2FIfqndTsUkv/msrEHkDrazy+cPFGPMyb+AMGlB3T5zUW11Dozf6zWaH
	qvcEIZL+YznZbJ+Wbicy1kvu22yH1i1pU0HDQQGezCqS0EAOyAZc8V5Oscb64vhffYrz6IujMNV
	vYUjRvmHm4qBSPlz+Ob2s/T3qf+ELC5M2yMZtivLoH73L9xsgdgRDC5Lne7/fqJjOfXnBkuatx4
	sWdb6O2zYWD5vWg9JxwDgn9ND6Jh/DOfc1q2wCTQrQGMoRoqoBAwL4FyOfD5kMVFMIP0227e2Fb
	UdFqqqx3cwNlpjRCClEjX80luaWhAGkSceUa8ZlBSsmb/lC9qPU3sxgFlfhkwRqXakNfh4I0Qs9
	C5u3eeG4caZgZm78aqs71ED3RnDtHtWKUiFkMwQmcUE2Q7X3Aw4gIllCbP2zFSTDTRWn+V0aD5B
	t8vuB7g5C98zNc1B5mLID9T/S7d2cyqfbzDDTk64w=
X-Received: by 2002:a05:6830:240a:b0:7d1:569d:ce7b with SMTP id 46e09a7af769-7d4c31cc549mr3704142a34.29.1771095842831;
        Sat, 14 Feb 2026 11:04:02 -0800 (PST)
Received: from localhost.localdomain ([47.227.2.18])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a76e1e59sm8853025a34.17.2026.02.14.11.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 11:04:02 -0800 (PST)
From: ChaseKnowlden <haroldknowlden@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	ChaseKnowlden <haroldknowlden@gmail.com>,
	GitHub Copilot <copilot@github.com>,
	Copilot <223556219+Copilot@users.noreply.github.com>
Subject: [PATCH] target/i386/kvm: Reset PMU state in kvm_init_pmu_info
Date: Sat, 14 Feb 2026 14:03:53 -0500
Message-ID: <20260214190353.29337-1-haroldknowlden@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,vger.kernel.org,gmail.com,github.com,users.noreply.github.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71099-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[haroldknowlden@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm,Copilot];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 939C813CFD2
X-Rspamd-Action: no action

The static variables pmu_version, num_pmu_gp_counters, and
num_pmu_fixed_counters persist across different VCPU initializations.
When kvm_init_pmu_info() returns early (e.g., when PMU is disabled or
there's a vendor mismatch), these variables retain stale values from
previous initializations.

This causes crashes during guest reboots, particularly with Windows XP,
when kvm_put_msrs() attempts to write PMU MSRs based on the stale
pmu_version value for a CPU that doesn't actually support PMU.

Fix this by resetting the PMU state variables to 0 at the start of
kvm_init_pmu_info() to ensure clean initialization for each VCPU.

Fixes: 4c7f05232c ("target/i386/kvm: reset AMD PMU registers during VM reset")
Signed-off-by: GitHub Copilot <copilot@github.com>

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
---
 target/i386/kvm/kvm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9f1a4d4cbb..c636f1f487 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2193,6 +2193,14 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
 
+    /*
+     * Reset PMU state to avoid stale values from previous VCPU
+     * initializations affecting subsequent ones.
+     */
+    pmu_version = 0;
+    num_pmu_gp_counters = 0;
+    num_pmu_fixed_counters = 0;
+
     /*
      * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
      * disable the AMD PMU virtualization.
-- 
2.53.0


