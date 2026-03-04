Return-Path: <kvm+bounces-72697-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6JYmAJ1iqGmduAAAu9opvQ
	(envelope-from <kvm+bounces-72697-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:49:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7533B204958
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C773B31622DA
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB693659F0;
	Wed,  4 Mar 2026 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fwToivHM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825B53659E1
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 16:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772641350; cv=none; b=HplwPEaBXuaw5u4Lt4uz+QQQxaDhFf2J3hPJvu46qW+cRLh5oTEO6SHKwEUXrXBpch4II0rIHi0n5j5+pac9+qB0Cv3XlWnGKuCvJyXFMe9DNNLOLeiufQkTSCI0hQFNDH+3VJGFxLEbPnAJg0eiUm+fh5uhZ87Wx2FVG6IHOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772641350; c=relaxed/simple;
	bh=/xgapYGhd/TA/B5MXAVB3XXtgz3ZRTvK/g/SPJvQHAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mqq338Ghf/KzBTiRlKe6gwZsblCFRP2N5zfAlzNhPmvuHQVK4cUtRaznthi5OonaHSm/XlqJIxkcyFstUUJAw1FXzAxxdu3CfkWiJTUwGFRo3PL1qQ7iR9oD3d2eyhw/lnqtuimA3OuHfra37FrdDQce39cLwXiKUv9CjMLtQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fwToivHM; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439b699b9a6so2786295f8f.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772641345; x=1773246145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oCJqMFMJBFzo1B9Dat2jPTYOPY6jcDnrEpSARx0ibE=;
        b=fwToivHM2yimpFPdJpsA/vRW5FFvYaaTxGX+/beZrCPMnjlevirwlnJKJ9GSbrqLyb
         gQHf6iy0L0rY5y8tFofRGwvAwWQewELIk2Qn6nrPnBNXXO4Iq6c2fDp/M1tqAtJ8D1CI
         rSJonj7mffaE+60q2RC0JrSKOLiYaS8AA+9hOazEMhSNBLt/GBN9BhXO43J+LqV/oq6v
         hS59efuC9XKP3BXbgwd42eMZmPTyeQkwJ4743iQ+cZRbbV4OpnNqc6v9IJYDW1GXRPrP
         e4GyTEyHMafDrJoy18pyL6W9+oFjIvxv+d+8wS6FgZs33DsMSDSIMX/27iU8GHkt6grc
         gUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641345; x=1773246145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oCJqMFMJBFzo1B9Dat2jPTYOPY6jcDnrEpSARx0ibE=;
        b=ddd0Thwa7gDJHQJoGp2m6E/OJ3K83+k8T9tqBnDlChh+y6RI01J6ouQLbus3YSbETD
         ff834I5dLHbl4ecMjoozZMs3W4Lo9s96gC2IFin52vqHr8qvBYypXjG7MI0+n6O0jICf
         oN56eOa1CslAajZvKwyKZ/d4cePA1eX6zq4chASK9xTGzLfhHoKzyYk4BS4BnYvESG/K
         9E/8y9xJgNiBuMIUrogx5XfQfsfq15vWM3Ugq7eSLrgSjBwp4RDXDffwzeJsP4vHLTmx
         2pKwj3qTubV0y0REc07UUeMyqK7RZmD4ctVHnaeU7FQ58PVY3qDoBFAgumhorErzevPs
         ObEQ==
X-Gm-Message-State: AOJu0YwXDFjFt/DT96cj9hjf0bGsvuvfcwfBLlmV86pSieD3eMs67ZcT
	DKIwg5hXlaDn9uytmpQe/AgFb4KH0zJ+gwywsXEEjJNV7fixKQPz18kPuTgkIWOmbQJ0R6kWMa/
	j7eUazgGnP8xTmdw5Y+GYYwsOKEbtemiqDtGN26ZLJ7x5InqpNv2E+cNJb8A7l7vTXOB4esIpdm
	xNSewD7bJ+k5Sx0W77pzDhbdzMafU=
X-Received: from wrid6.prod.google.com ([2002:a05:6000:1866:b0:439:cc48:d5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1acf:b0:439:b3ff:9ab9
 with SMTP id ffacd0b85a97d-439c7ffcb29mr5321494f8f.48.1772641344607; Wed, 04
 Mar 2026 08:22:24 -0800 (PST)
Date: Wed,  4 Mar 2026 16:22:21 +0000
In-Reply-To: <20260304162222.836152-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260304162222.836152-2-tabba@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: Fix page leak in user_mem_abort() on
 atomic fault
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7533B204958
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72697-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

When a guest performs an atomic/exclusive operation on memory lacking
the required attributes, user_mem_abort() injects a data abort and
returns early. However, it fails to release the reference to the
host page acquired via __kvm_faultin_pfn().

A malicious guest could repeatedly trigger this fault, leaking host
page references and eventually causing host memory exhaustion (OOM).

Fix this by consolidating the early error returns to a new out_put_page
label that correctly calls kvm_release_page_unused().

Fixes: 2937aeec9dc5 ("KVM: arm64: Handle DABT caused by LS64* instructions on unsupported memory")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ec2eee857208..e1d6a4f591a9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1837,10 +1837,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && s2_force_noncacheable)
 		ret = -ENOEXEC;
 
-	if (ret) {
-		kvm_release_page_unused(page);
-		return ret;
-	}
+	if (ret)
+		goto out_put_page;
 
 	/*
 	 * Guest performs atomic/exclusive operations on memory with unsupported
@@ -1850,7 +1848,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
 		kvm_inject_dabt_excl_atomic(vcpu, kvm_vcpu_get_hfar(vcpu));
-		return 1;
+		ret = 1;
+		goto out_put_page;
 	}
 
 	if (nested)
@@ -1936,6 +1935,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
+
+out_put_page:
+	kvm_release_page_unused(page);
+	return ret;
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.53.0.473.g4a7958ca14-goog


