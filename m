Return-Path: <kvm+bounces-71051-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHLYLqI3j2n2MgEAu9opvQ
	(envelope-from <kvm+bounces-71051-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:39:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64CE5137226
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 995FD30C1B55
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 14:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AF0361672;
	Fri, 13 Feb 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wd6NN6F2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFC8361DC6
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993507; cv=none; b=qic8lKzbe36RLPqMXZZg+O7PrXIApiYOmEGql4N9QtXL8oCrRni1Yww3NZN0U34LHuN/GkGPdwFVDmNEJWTtQGRy6iz9sy2HCKXnoCaYXpbVP2d/8V/va0MWoS/GHnFhbpK0PdNTBX8A7sl5DY+J3hxvft/Uv43Gg+4aozaAs3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993507; c=relaxed/simple;
	bh=2Yh7aBShA6c8gQ4pY43dXnO0B18sPgc8K/vuxbeNWds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C3xezAi94I6zxTShEJzXKdBvvPtJRBYwSB827KzgxNMb0doIJHh8Pp+1iSA/lay1m6WLBEIH6qCIhhXXJ8QtitOEBFJI4ETPZnHtrqTiNWekopFabE1uCsd85LoDt7v9SblagbhebKk5p1QO02cOMtE6FJZfv2ogtMHS+Nc+poA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wd6NN6F2; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4376e25bb4dso1227495f8f.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 06:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993502; x=1771598302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/UGGDvqnPusZ8w3DOSxM5/L8hUMj6ctAm+38uUc+sw8=;
        b=Wd6NN6F209RSMeO7swfQng9oTXAtCivlOydw5ug7+YXPzPKODQ0dHHi1EB0Uv6oaSw
         9eyhcqKIeiFl/q2uUM7gHfyYAvTNyOJb9SokQhAplYh+NmnlNvI5E8+6Wt7HEdA+1WTJ
         qFyu5A/es/c5X+em8y9ESP3w9urv52SmSP+GlFUI3pDSpxquQRfBGeA8O48MyrhVKmKd
         oSAfIC+GH+J8yN5B2Wh5dmaWvwabh65uXoApWd2pURL5i3f14feKy5oRfUq4kDnOlU78
         R728oS+hpYdoOZpkUMsDmdHls45earbuHfYmJEosYOptTjj/cUgLxYuuFw0HOMvz3GkQ
         0pgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993502; x=1771598302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/UGGDvqnPusZ8w3DOSxM5/L8hUMj6ctAm+38uUc+sw8=;
        b=UQuTzSGiVQN+ocwM4FwedMo7DrscOZk+35mq2HZidPYK5gvVBGNRr4CTQqm0VcM9LE
         xOIMWQ5EX1einuQikBXKmfkvRPciWrp5NgbzHqQtzDNr+1WPhToT3auHHI+TBsKNBmf8
         GMh7jBPXgoXO7NAe3pxcwGbWxresA96LaltO0p9lY/A/dNUiRZg52RNMnLV+rCmlxbiD
         H83utjAhGfq44+EKzn8Qv/3OrmphV8Vhd/TUifrW5ey5zwm9MFJonNt/sPltp2H4w15c
         yxYiqyPsIr8kqyK0/UZ3vxz+U2CglYd6P5PzN2iKeuO4PTS5RccaZLu7syT7MRlPURu9
         0gig==
X-Gm-Message-State: AOJu0YyGAloNgFQeHTGuSDify5wDEriXYqkmQdKcWO44zVjLEgvNodhU
	rp+lTtlKRMdGOpoByZ4pfx8CUJpnzQT7gWnGA1/r2H0VzaGlQhLJfdQ15qXtfwUVMtMWx6cVRzp
	TCezUyVPJIq/Wi0LOYosXgdfEAZcVmC65mVGFLBnfVY5JP/1p9XYq00p2VuKaW8oKB5Ll1rcNHp
	INi661SNlAf3Qqk7MeyBFSF4OhDgQ=
X-Received: from wrqa11.prod.google.com ([2002:adf:f7cb:0:b0:437:72d9:7316])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588d:0:b0:436:369f:39fa
 with SMTP id ffacd0b85a97d-43796af9ed9mr4847850f8f.44.1770993501337; Fri, 13
 Feb 2026 06:38:21 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:15 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-5-tabba@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Remove redundant kern_hyp_va() in unpin_host_sve_state()
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
	TAGGED_FROM(0.00)[bounces-71051-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 64CE5137226
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
index 59a010221818..389fa5f09c3d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -392,7 +392,7 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
 		return;
 
-	sve_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sve_state);
+	sve_state = hyp_vcpu->vcpu.arch.sve_state;
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
-- 
2.53.0.273.g2a3d683680-goog


