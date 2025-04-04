Return-Path: <kvm+bounces-42734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0C6A7C4AC
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 888493BDCF1
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5905C23E345;
	Fri,  4 Apr 2025 19:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NCQmVOih"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790123E227
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795672; cv=none; b=RJDbP4ZiZbnqIc31mR9NpYZ4Z4Rl267Qr5ip/sFqwodeP7HrGF/qc7vXqNZ+BpzvxHZg3XQ9D7l/aEi1TF1AkAB2FTvN3BVE1nxc3aRFcfyX7cyrNhIZdb7/wT8I+NYKRi09/SBL0sEYoPdqRotSW5JByugaUmTcp1UcTBqRNyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795672; c=relaxed/simple;
	bh=Jfmk9VzNRAADpmMGwdwa2xyHxXIJHx3CDbGZTsxqH1I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kieJefsDzMA6cOlK3BiPXXgP8YlDKoX9vn4NtgxCYCSWPs7v8pJywdlZhXlMCA6xEGihs+AQttt6ghZ7syRWosPuZ4vvowdvw263Y1zGvd38VD41hA1qDNYnqYyZO9H5MDfq0VoTAUng826AgYj9GyaM/iyzwV2M6/laV30IaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NCQmVOih; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c89461d1so3577802b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795670; x=1744400470; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8P0F5+eRvzI1lxgpOCwvPttxPqLphUaIWfDndZq8iLM=;
        b=NCQmVOih0uFjaC3BZm4oIoGms8lCTgr7CPB7ZBCfkMX/jsgiI54Inp39yCveA01mra
         3XqKGJtIRuDCWOnYfm7j1FUPHA4feu6YJpl++1iZQLSzT3k22Fzp2yQOhn9Xkv4UkA5l
         tlTPhEm/QIPRsgwFcKNlI66rmWUUaqEi/57mr4lvkHT8uHodfexgtdzbn2GrBzynrmTf
         HgZRU4QdkYIDdEuRCKgaIimDTmEpnmdYLCNZXLamD+Ob3KtEWEahgjmEayYzNPxMmOPY
         SmA8SKAHdbc+aBAyWO0m4LZfZsrQaEods+8U/3PTfHUUY51SEDDeu1NKG16Xr4fY0w02
         JdJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795670; x=1744400470;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8P0F5+eRvzI1lxgpOCwvPttxPqLphUaIWfDndZq8iLM=;
        b=FkyAa47LmU01otXFJ5qhL9ymaZdaac8+38rO95NOG/egSaFq6KHDoeFbSb0NdVmkOE
         To8jBpMsgZaA3qs7KCyEA+crGyeqc5+hwmhsbqS2El2411L2ohY3BowCGGLjDytUUSoo
         lshr2wNVOj/DTNmeQwwN0C2u5h2tUPk+d/C8jTBtwE2tzZRkerq6rE8b5fJFJkQ00di/
         QfCwkabj32OpajF7ZVomq0GD0DAtK0KQ6CDr9Kl4BKCk6b46RdmklfLfOPBjkWbxYhg3
         QEhXXODNecrjEXMZSiS2hBDGMSHYG/O8x0xEUgGvKSfrD/eC+9b7fAZU073bO5wLu21t
         C17A==
X-Gm-Message-State: AOJu0YyAMY0zu+MlyFyGY5bMJT8+RBjzSogDUhk4Ey0+e2g8mwUsasD5
	MHZtSX2WbgCvaoMUyA7dNR8xf9PeIMJccKP0xPhevmhSOM431xzwbfDzCl1jC3DECb7KkUbXWsO
	E3A==
X-Google-Smtp-Source: AGHT+IFM3a33R0/JqO8ZtaGkbV0mf76n3eZC+Ea2CS6FZilzIUeDNAaxDWzQnYTCiWaEXSrdeYzp/CG211k=
X-Received: from pfbho2.prod.google.com ([2002:a05:6a00:8802:b0:736:b315:f15e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:8893:0:b0:736:4704:d5da
 with SMTP id d2e1a72fcca58-739e7161560mr4999839b3a.22.1743795669704; Fri, 04
 Apr 2025 12:41:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:03 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-49-seanjc@google.com>
Subject: [PATCH 48/67] KVM: SVM: Don't check for assigned device(s) when
 updating affinity
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother checking if a VM has an assigned device when updating AVIC
vCPU affinity, querying ir_list is just as cheap and nothing prevents
racing with changes in device assignment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 04bc1aa88dcc..fc06bb9cad88 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -857,9 +857,6 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 
 	lockdep_assert_held(&svm->ir_list_lock);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.49.0.504.g3bcea36a83-goog


