Return-Path: <kvm+bounces-69034-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sK9ALZIsdGkV2wAAu9opvQ
	(envelope-from <kvm+bounces-69034-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 03:21:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E057C35C
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 03:21:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ADB53022977
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 02:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837BB21C16A;
	Sat, 24 Jan 2026 02:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCw5aOd4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8173D9443
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769221255; cv=none; b=su3ggbDWWuSsDt3zNmusMLO36fiiCq4gXDe2vjCDIvjZGwOOh2iupNcD8gk7FxeCiUpZMDUpLHlots/HwJPPEjz3Cu4oOqJY+vD88Fub1hy5rVFltJQWAyFlsnCYQw2YMqVPVc8SqK84avgae5oSeEYSjkqwZw38weUiWlHec9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769221255; c=relaxed/simple;
	bh=9oYgGuPPTlkjkxoArV9D46eocnrUl3z1VuBba5FrjPk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dhrxWEeWkBGZj368BoBZTXSBCaZUgxPeLUOhr95rzFy9j8CnJEpupKeE4RMuXnAN5v2Q1eNA2yp9kaLv2C5pq/9PxltO6qMzyMTcC1AHajpf0KkqmwUHiY8ktEg3+pKOUrwLKpwSQFoToH+xjaktUPYLcOvqZ84bHSJlUZWoNcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCw5aOd4; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a75a4a140eso14438475ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 18:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769221254; x=1769826054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p8kRNbAvCBcU6i7e683KXYAQzk2DTUU7+Egyrm6jhp8=;
        b=KCw5aOd42eyZuitg5eyc1n8XHDKNO6WmUs024ECCYIAuqLTqrSn213HGGkXhMeNslN
         B5CZ6R52fBGNYjfHFzidOCZR8fKWgY2/P5zw2/hMbouejJAxM6ekXifIobZSEUddAd7Z
         Ucuoyzx/1nEvo75Ruh/Vy0Eeu6LykP8fqYoEZqlQdUzSpKTIJe2/M1zHOocTxK7Wi/ej
         mHY6mu2PDf0fValdDbyZuYaen8cytcvje3tUcEohDAD87QdkWC0dSRo36LMpAVwscc+P
         Ysfx2twGmsEsL4m7qO1W3iJFeCjzdLTDXanj/QO9zhKYgeFmzWJhmX8w8Mh+7NEgOCqS
         1ZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769221254; x=1769826054;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8kRNbAvCBcU6i7e683KXYAQzk2DTUU7+Egyrm6jhp8=;
        b=hBn4clZyxBVcz6r9NL4DpxDygKJolOvfcjAljynOru7D9yvHGxsEgQJtAHMGOYkW04
         2RiZhlvYcGjHuYqLJlOuCPaVXgA9LqDJpC26JetYC4sg/S49kAh6MAN+y5c5qP6Jzu6j
         nd8+WufxRFcyZuKYKLyKacxFcyNj1YoO5e+X6jaNXYx1zogHDcTZLgtia5YIfRyKvwrb
         8mbHXa6YbdRlQKlzWUCg5p1eLQenmXS0jqJgErcK9NWeZBhiMA9z6Rn6BCNuIWV50j+K
         hxuJFi7WpqqYyNMFbG+qNtSnV9TeTmpSXQGFGfbaqT4voAtwSfSGH97ITqz8T2tuwfMZ
         UWVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV/QRbTY/kzDiVsmbZRUlgAL9+ycXKQlimfVHZFs33dI5lTUbOwdXM6Wos+Kv4DqqV9yI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2pYkQ+1gMEVUpH55q1fJnPa4mOuoYfXxbQEMRL8uAUcDkyqEh
	H6SmnpS8qWrl4HVjg4VMUUFD5BEJn02NgvmhKvpwZnJONn9wooHklKUsnvwHBlRI
X-Gm-Gg: AZuq6aJsPqFWEHKvJWbGO4q/0YjOA42ZO5JoGbiDCjqYQTD3KX2gYW+kt4FufLlJ/Iy
	DdX5erIoWCBwoSe6YTD1skMZ/C1o2GGk9vacSds3Q9bZYOwHomhehsn0yXYrxcW/bowiF8YxIhu
	qlatEWEKuH4Joe3BNjwJ4GmVWvzcXB+IvBamX64uSauaM6L4HtDal4fBm1azel5OPuStQBYthsh
	Tg1cSyWZf2zMNUr4DvaGmHJ/y4oEM+ikY0tB6rnIgvR+sHMbtGxizRtQ3IyCe9zgS5+48EXuokp
	EFTWaYCzFtRpWojCCurRYOGWg9iPw3kQJ563YsJoFWEyzhykrrM50edPwj9sZMAkl+95AbMlcif
	ny1BxRYiB9ixQv0yp4jAlyGHJgtZ6jrtHtKsU203CL9ORILV99imHeXAmD9UQKrniVCMHtPBBTt
	O3o6jGzBBCOdzT0jY4Qs9yNag5AOcCW6TWk9IzxWAI
X-Received: by 2002:a17:903:98d:b0:2a0:d05c:7dde with SMTP id d9443c01a7336-2a7fe73fac6mr41209565ad.44.1769221253788;
        Fri, 23 Jan 2026 18:20:53 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802dcd781sm30926135ad.24.2026.01.23.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 18:20:53 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH] RISC-V: KVM: Validate SBI STA shmem alignment in kvm_sbi_ext_sta_set_reg
Date: Sat, 24 Jan 2026 02:20:42 +0000
Message-Id: <20260124022042.2168136-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69034-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 27E057C35C
X-Rspamd-Action: no action

The RISC-V SBI Steal-Time Accounting (STA) extension requires the shared
memory physical address to be 64-byte aligned, and the shared memory size
to be at least 64 bytes.

KVM exposes the SBI STA shared memory configuration to userspace via
KVM_SET_ONE_REG. However, the current implementation of
kvm_sbi_ext_sta_set_reg() does not validate the alignment of the configured
shared memory address. As a result, userspace can install a misaligned
shared memory address that violates the SBI specification.

Such an invalid configuration may later reach runtime code paths that
assume a valid and properly aligned shared memory region. In particular,
KVM_RUN can trigger the following WARN_ON in
kvm_riscv_vcpu_record_steal_time():

  WARNING: arch/riscv/kvm/vcpu_sbi_sta.c:49 at
  kvm_riscv_vcpu_record_steal_time

WARN_ON paths are not expected to be reachable during normal runtime
execution, and may result in a kernel panic when panic_on_warn is enabled.

Fix this by validating the shared memory alignment at the
KVM_SET_ONE_REG boundary and rejecting misaligned configurations with
-EINVAL. The validation is performed on a temporary computed address and
only committed to vcpu->arch.sta.shmem once it is known to be valid, 
similar to the existing logic in kvm_sbi_sta_steal_time_set_shmem() and
kvm_sbi_ext_sta_handler().

With this change, invalid userspace state is rejected early and cannot
reach runtime code paths that rely on the SBI specification invariants.

A reproducer triggering the WARN_ON and the complete kernel log are
available at: https://github.com/j1akai/temp/tree/main/20260124

Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 arch/riscv/kvm/vcpu_sbi_sta.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index afa0545c3bcfc..7dfe671c42eaa 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -186,23 +186,25 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 		return -EINVAL;
 	value = *(const unsigned long *)reg_val;
 
+	gpa_t new_shmem = vcpu->arch.sta.shmem;
+
 	switch (reg_num) {
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t hi = upper_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = value;
-			vcpu->arch.sta.shmem |= hi << 32;
+			new_shmem = value;
+			new_shmem |= hi << 32;
 		} else {
-			vcpu->arch.sta.shmem = value;
+			new_shmem = value;
 		}
 		break;
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t lo = lower_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = ((gpa_t)value << 32);
-			vcpu->arch.sta.shmem |= lo;
+			new_shmem = ((gpa_t)value << 32);
+			new_shmem |= lo;
 		} else if (value != 0) {
 			return -EINVAL;
 		}
@@ -210,7 +212,10 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 	default:
 		return -ENOENT;
 	}
+	if (new_shmem && !IS_ALIGNED(new_shmem, 64))
+		return -EINVAL;
 
+	vcpu->arch.sta.shmem = new_shmem;
 	return 0;
 }
 
-- 
2.34.1


