Return-Path: <kvm+bounces-23802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC2094D83F
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 22:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D22728647A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEBE169382;
	Fri,  9 Aug 2024 20:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vX5O7m+d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7191684AB
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 20:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723236728; cv=none; b=MyTOgd5e7DN9pM3m0TfePSIx3EIMeYmSBi25/t49Y6XEV02cgtnyHcSA10SMLpmuyFa2TFcGR8vO7TXy51kRa4/Ka+TU6d83+J4jPtlPLV9i2NmKuQtPhckSs9QcwpRmnGzGO6BjJfSEAmDiuNHbkzyJIBQeZ4OnyZPFl1Zw8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723236728; c=relaxed/simple;
	bh=UylfwD3oilt2Ap00B9QfJgsS5JbmMx/LZPo5qb2iVKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HJ5vXLO1A5SEx/djcnqxNaUXtVp7YsB+aPh6hlJLiPziEjNItsKuiu22tE5jFC4v2g2PivaPAprfvx7sez+f4nRdjJcgZDItaF3i7mi+deWcVbQWsgOQDaTOy9bcIyCM5QDgW99xgABENnBevVHv0iS0QnJ4j3UGosoMUfCcfZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vX5O7m+d; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08bc29c584so4111789276.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723236726; x=1723841526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=br3FwjgDzPooOiG0lkeIxLVZHvjVaW5LdrLy5p4r3+8=;
        b=vX5O7m+dtJOzrxJTTTYn1W3D9d0czGw2tTlKPe9u+q4z3hqf8VcWOAurd3/SvztwxM
         9NpuMGnkDQMLk4Tz2/BatT3e4KOLEtEPzpW6VHfIJKBGq9+WHmfqHxVeGFGgi7ehY00w
         GB0OoqU/FlpYbU4x7I/+OtSbx0ft4EXNOCN463DWmvmtUYqL7UQ58TMWd9Fo1NLmzNEM
         mOthIFDUrT4TOLvsbnCvcshN6EAeNJ2FEhX9VIBY2p1bDznwAhKl5tpl1Li6JhETHsLR
         yQnvENeZtBRH9/yvx4mRMElwbXyP0pItdDcMzqoCuo0lQAQSU98v+DgOjEfBLB4elPUq
         6Low==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723236726; x=1723841526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=br3FwjgDzPooOiG0lkeIxLVZHvjVaW5LdrLy5p4r3+8=;
        b=d+MYgiWY9lBkVDtoDJYxweF1V5onGcGhkNCn1mUFziNgeTy/K8TEazZP7/zNK3z1C5
         Ul921omaDVhevlB+0q2KAv306lZVsjvtttsnlu2H8k59osDCOA4Kb0MuCFSgh27mxX0P
         MyaOk3zicchkAnLF+OZys5izvu8sGbwADGXNSsdyCtS6FLtLJOI/nRxYSq43dDrYTuFG
         jKmkejRkj0wtatnudjTmmtSdCrVQ5pZHzfwEM0S2Szz3xn5wxYncl8D65nMziUuaX0hO
         ZD0ZN+Rpoetlw083BV5EEe5ot9tQyUUSEg+yRyIhH9M3AXw/ltebeGbu1FTP359LRuo+
         tQYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJEeMy2x8GgmhF3f/mNM1pCMLRz7UYWy5qqG4zXoszXPSudjxivjsu1C7VnShxSTXcI+GS1WJ1Yp4MYTyKHAqNO3yF
X-Gm-Message-State: AOJu0YwN/Gni8iy0HDaERxbyulC5oCm528ke20E3JA7ch5FFcd4AbKlh
	Bzb7G7kOGT5sSc5H6jc1Tnv0LmiWh+4cJaJ8RFKqrTvRcuCbk+1IH4MoP61lHngCzOxi+TzxAGm
	DKKzlQnDIvg==
X-Google-Smtp-Source: AGHT+IEDwdW8UPrl6O8L/dLUe+yB4KqU+io0AFuuQD9m2vE0SJljtoLO2dozJZ1XveNUHCZDlwUWfzVuIHv+5w==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:ac5d:0:b0:e03:3cfa:1aa7 with SMTP id
 3f1490d57ef6-e0eb98c93e5mr4591276.1.1723236726226; Fri, 09 Aug 2024 13:52:06
 -0700 (PDT)
Date: Fri,  9 Aug 2024 20:51:57 +0000
In-Reply-To: <20240809205158.1340255-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809205158.1340255-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809205158.1340255-3-amoorthy@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2
 fault handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: jthoughton@google.com, amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a memory fault exit
when this happens, which at the very least eases debugging and might
also let userspace decide on/take some specific action other than
crashing the VM.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..c22c807696ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3264,6 +3264,7 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 	return -EFAULT;
 }
 
-- 
2.46.0.76.ge559c4bf1a-goog


