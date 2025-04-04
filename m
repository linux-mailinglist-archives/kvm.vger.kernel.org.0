Return-Path: <kvm+bounces-42737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17802A7C409
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9C0617AEAA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF23C241CB7;
	Fri,  4 Apr 2025 19:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkrHZhfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC68523F427
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795678; cv=none; b=muDtfdx9S3pXcjXwykJN2At3yFwY/fg1rkwCjP/1M8ffkv0May4cSiOvtqEisiVDuaP/1WypU631ERX7W7TefwNVqjNBEX2gzEoyPHj3SdsFv2T4YpfyF3DI+IBJdsrXJG8L8TJkPP0VjKpOm1Q92d267uv9dN5JbCIqIlBmFuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795678; c=relaxed/simple;
	bh=bysiSM9qAdo7w3jTZoibNt/lKzOp1jzLwij4XBANYyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DNn6TN2OUHOkc1E3u8/zqpSQXG3c2YV3q/K8rAUZx9UUqVVezQNK6gqxi6SGgIgXumIcbWa6OjbOlL7BZpa9MgPI45ovATopeQexZnzBNC0ChgNx2L6UJDBgqAm23BF7CWRrywIZpmVYFwctznEnaC79hzELCN9mjWlxIF1hW1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WkrHZhfY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af2387f48c3so1631767a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795675; x=1744400475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PxawxOY/h734lZVFn8ksHoL6g5gCibnUodY00H7f/TU=;
        b=WkrHZhfYe1iUaHMHjDItttTvLzKSkVsJJUSGRvxNkgSWZIl3o6p/KnSb8TDip3Km5J
         WGnwufhyvRwOu6lKJKihS6Otwe3GSyIjHV8KGgfxFJiGBEpOXiGqh278KHE7j9jWreFc
         GYrcys/j7DadpbZX80V04iZLI1ZTFJ/LRPDjvzZN2zPKxsBMphn3EIXUInsi59BQ/WLU
         1QA+AgtErReP3H+/WpbR4D48Anxdghp50PMnfYeVUydNA8huN8kzp4lavDM6JFA793mt
         inRPEDqvOXBZ8VAoWYtcM4QHiq8X5QVFSa6DWpaquHViIy8m8hiDiVUaKCrodGNTJsqr
         zUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795675; x=1744400475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PxawxOY/h734lZVFn8ksHoL6g5gCibnUodY00H7f/TU=;
        b=T0zU/rcZiJbWDPdpyLgEqZwg85Ux6hOEIJ/DSAsRpfetTVChJjZHw9elWb33IzC2E5
         mf0E1NRBZSdL14Lj1F3uRX0oFtD4W8HZJgufwc1tStoNsRy6jLwK1OI/XVYwUZGSrlw9
         gRyJJn3PyB1mi9Z0cuXNYEas+Pdd1E8lb15+vAVrtxb+qs29NZvmRRiarmL9kdmGQK6b
         sK5TwWq6r1rtruNvt7kd55U8FD4fA6mvH/qzoEemh06CvaoaHtSekhwk3Diu3PkFE2/b
         QuJXiQiex+zMe+YPtTSglCzdSmHy5Y8EdXCDhetFD5tz7psgg59UgXfdWaYccR7a2l3v
         EOsQ==
X-Gm-Message-State: AOJu0YwgailtDSqytvgIUhhrH5dQVP1l7tAJJzAGUpIus0JKFwSwjqBc
	ERab5z5sWJL1G9r1HA16uCEL/flMP96uuOAErg4VlAeGJu1CuID2Np6Qv/JrrvWEehIavJZMU0I
	3xg==
X-Google-Smtp-Source: AGHT+IF0dzvMV/vshjJPGocWxq0fkVPPJN838E/ImYVh1WQmz0SFa2CAc3x62alWuXzKlUZkk5y4MEI9SnQ=
X-Received: from pfbgs17.prod.google.com ([2002:a05:6a00:4d91:b0:736:56a2:99ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c66:b0:224:191d:8a87
 with SMTP id d9443c01a7336-22a8a8739e2mr55191535ad.26.1743795675258; Fri, 04
 Apr 2025 12:41:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:06 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-52-seanjc@google.com>
Subject: [PATCH 51/67] KVM: SVM: Process all IRTEs on affinity change even if
 one update fails
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

When updating IRTE GA fields, keep processing all other IRTEs if an update
fails, as not updating later entries risks making a bad situation worse.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5f5022d12b1b..5544e8e88926 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -857,12 +857,10 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 	if (list_empty(&svm->ir_list))
 		return 0;
 
-	list_for_each_entry(ir, &svm->ir_list, node) {
+	list_for_each_entry(ir, &svm->ir_list, node)
 		ret = amd_iommu_update_ga(cpu, ir->data);
-		if (ret)
-			return ret;
-	}
-	return 0;
+
+	return ret;
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-- 
2.49.0.504.g3bcea36a83-goog


