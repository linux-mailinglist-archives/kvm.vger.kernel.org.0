Return-Path: <kvm+bounces-70931-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oEYhNK2XjWkt5AAAu9opvQ
	(envelope-from <kvm+bounces-70931-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74EA812BB0A
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E5C45315A6E9
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2F32DC781;
	Thu, 12 Feb 2026 09:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BV/JlQFG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195E52DE6FA
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 09:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886979; cv=none; b=uzOW1lL9XqczKBqS8LiCwsnbZG2JTqZieIDsKpqY8gUbvOUM7AUQtaHwq4V9ORAW37S53Iw21ZxEjaBbE1J7VenqpGu8I2yA+thq/goypvoGZPEUmCppootuAk+De6BypzaYpM0HZT1YZon+1Ml8uhlKCTD/MxRLilTAgLUR/gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886979; c=relaxed/simple;
	bh=i9Zhh3N6A4NdcyXc5VJPTx/rNWSpAt0ReEMQ1vjLMdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r16nS1sOyICocjMErM0RH9IHtHv2EkDSoKXySwKjmqeyukBj3J3LdxWyqJubDmcqx413ejAogA9eJZKUo//cW8P2xgOvXKQOnZ0UR7XUOk0KfFFFiep8bX6/QhP7uxKzU1MnIvsl8HKlDjfvkXDk7ljzhj+9eCrWPb59Cqb2yDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BV/JlQFG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48071615686so25099355e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 01:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886976; x=1771491776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cyyYRiwc6FqhQlyFBFLg66ihDNCGyZfWrA54Edi64Eg=;
        b=BV/JlQFGLwbTV2Q64RgI4T6vvV0qUCUMRyWEhZ1kfpojlN8cPE9aWObjegk2083bKd
         lKR5vG+vONLNxyU0D5PjZB50KXoVfc9yH734Jx6/Yk7Tc9qCZwXyThyzcNSUqw08GIFc
         RGgiFPLHwKQXQvMv3DYo12JIZ3bSDv66bC6DzQsarzGtfL+W8o7oUzyyHStDoiGpFsss
         S4bJV2uhK4rpXJhKSy6zedw2KT8QzuHBm7vtG0qCFWKTGxmSAPk8qNHXWy+8n6iZOAcr
         Ao17GM0LmUkesPAESYyz5bQay6oY/UcZt5s5os/USP34JH5E7FYn+zMXiEfUhNTi3XR6
         ZDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886976; x=1771491776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cyyYRiwc6FqhQlyFBFLg66ihDNCGyZfWrA54Edi64Eg=;
        b=lvW3bHgCPmQZUApP54uyJfY6snEEuT457MO/y3LCszkTxv6xffeWmvSwevHAJboEnP
         VSz5v/i5VvupRLMjXgxS9gcVEG95UCV+q48mOpzZOyBFNrj0dKEom+/DAJUlEN72ZVOO
         OX2/QbPTp6kkXgGid/nY059pqwcvafAtVgbL+xqq1wSOFapy3JY4w25trRcE1DHIjTW2
         lDTXAYXk4oyE3fLLP5hqTtb5TFaS7D8PNzEYFTZIgo/v18Lu4Y7BiQHIN8FvKAagVVU7
         9yfytG06wCsKcUSUpd2uP8HkBWAGrJtkrAcizrE2zAKO2gZLHXvD1oM0NYaBPocy80GJ
         NnUA==
X-Gm-Message-State: AOJu0Yyt/0o6LDGCIgmFUF/hoBdefhuOl3c40zKk7tkZuNzeANpV5hqV
	gctaujLF6axtHT45fYsul0n7tKebS0UGo7oQg+e5yOlW6nUTlkhGiGm0qQFhTwIRcfNTnn6wVkv
	wEnCUaYsIYSo7lVM4Lpxg0ooCk4EYgOT1fw39p7SucrCuU8anOa1bEAmCpjMkBxsxpYE2DUkfyY
	8N3If4xlRuwFWBHf6w0xAaL3Woe5w=
X-Received: from wmqu17.prod.google.com ([2002:a05:600c:19d1:b0:483:29f4:26b8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:608b:b0:47d:8479:78d5
 with SMTP id 5b1f17b1804b1-4836710a0afmr20458865e9.7.1770886976534; Thu, 12
 Feb 2026 01:02:56 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:52 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-4-tabba@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-70931-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 74EA812BB0A
X-Rspamd-Action: no action

The `sve_state` pointer in `hyp_vcpu->vcpu.arch` is initialized as a
hypervisor virtual address during vCPU initialization in
`pkvm_vcpu_init_sve()`.

`unpin_host_sve_state()` calls `kern_hyp_va()` on this address. Since
`kern_hyp_va()` is idempotent, it's not a bug. However, it is
unnecessary and potentially confusing. Remove the redundant conversion.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 267854ed29c8..8b9e027ec86a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -393,7 +393,7 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
 		return;
 
-	sve_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sve_state);
+	sve_state = hyp_vcpu->vcpu.arch.sve_state;
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
-- 
2.53.0.239.g8d8fc8a987-goog


