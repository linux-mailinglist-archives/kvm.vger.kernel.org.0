Return-Path: <kvm+bounces-66883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4B5CEAD68
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 09F6A302B11D
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5920E32142F;
	Tue, 30 Dec 2025 23:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A7rTKwVw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6902E2DC763
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135736; cv=none; b=iSPUCCvE4LOFihg7+K6PbEUvvHHXqLgWMQw70eeGKNcQZUwaj2Zv8GN1EcqcPg7eyMm4Cjd4jqKj7wIy4j1zAIjYBT2zqhZe1/S/wLMEKLySUiosMksKVBj6dBhjyWXLGh9Du7RgChO8QTI5w2zKjm8RFZR+rdPOR7DHQDiyiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135736; c=relaxed/simple;
	bh=2ZolxtbeL/TfZv1wuBul5eMq3hwecEq8h3mFaMWxBTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=noNsK8YQhygkwcTHwOsJRxyMS18dPhPiz5azx92cEYyh3CkSfdkjKNQjrPmBbn+o117nfLtIS0RK6E2Yxd+Bvdss8mHaQfsdvi/hVftX26mO19PAkZepWhNhSQrmBRRXb6rNAYPntJ1C3lBeaTV2NFwBwcadQi47cRNEgIqqbi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A7rTKwVw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34a9bb41009so16720358a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135733; x=1767740533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aempC3xup8zdxs82u0niExWKRbrEWWiY7rS3u4Pr19E=;
        b=A7rTKwVwsRCeC0uteG3QsCqrQL5vkk7PzZI2Sv1a0R2/DY5MO3fNN84Bm+k1Ga1X87
         sG3MgvdCQ6aFgRopYw4JVEh0ns96otmmF+KyrKtsm4wCtGtWLdEODZoH5tnfP8MSy+EQ
         aCm4NyUDp8wougXheksx4Hhvhr2TomuR97XY1yLbJy+GC/5ibBxDTVACMvlb3hSyZQOE
         uZ7XcT87GUqgTjik4HDORNqwATaJloIEyOEzZKn4ktaoBJHY+SwrywpMT45R9PO8Ap7v
         XInNRUV/JeqfBmCt8oH+KM/0EJHbxyq8AtrxrX58b2FrK/CXoGYqJt6swbbOTyQkDlXg
         n1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135733; x=1767740533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aempC3xup8zdxs82u0niExWKRbrEWWiY7rS3u4Pr19E=;
        b=J3XYMQb5I0e7H/0XJjTCXAbkIvViyCKVAZ75Mm7+mWVA+d8ikZk6tT5wp4jr3ixbZY
         mWopjfH5kccJDQ6Nl7wo8/4aoX58OO6BD9iE5e+/2VAeiMfWieXzSCb1sjpqWs3q81oj
         TM1SYcvzpYgzau8IwO5363TSA1ZJli8g3DGIJI1xG+FzClR0i8I5tE2dO8jneZFKeq8C
         3qFGGkcP35gh+All+ls7khhvyobPMWPkVYIwCA4Ng4DfOtJRVhg37wMJAIhvx7DcSViR
         ondu3fANxzgy1vHxZx1pwYLBm8X8kSLDhkizsoggmZ0k05r3Ama7ob4SfPEvEAyHz+v/
         zEMw==
X-Gm-Message-State: AOJu0Yw1ebZoMxIhy5WMz6U0VP2Ogdu4mab4oSaFeQn8r4OBdbhFCKmV
	VzMOQMstsQzGdV+Z67qeBfQeaawWyn7/3T34Rm/TvlMhIHZRI01tlPjjd94KwIKBxkrjFL32Kuc
	cbfpkbw==
X-Google-Smtp-Source: AGHT+IF1//ZF8YQZFDW338R6CLvvv/Jhm6bfFusPZNwPuigVsAoIaoiYhFuoR4zT4Z2vqbXSCzOrQaND/Kk=
X-Received: from pjbpm1.prod.google.com ([2002:a17:90b:3c41:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52:b0:34c:94f0:fc09
 with SMTP id 98e67ed59e1d1-34e92139d60mr28142377a91.10.1767135733534; Tue, 30
 Dec 2025 15:02:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:41 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-13-seanjc@google.com>
Subject: [PATCH v4 12/21] KVM: selftests: Add a stage-2 MMU instance to kvm_vm
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a stage-2 MMU instance so that architectures that support nested
virtualization (more specifically, nested stage-2 page tables) can create
and track stage-2 page tables for running L2 guests.  Plumb the structure
into common code to avoid cyclical dependencies, and to provide some line
of sight to having common APIs for creating stage-2 mappings.

As a bonus, putting the member in common code justifies using stage2_mmu
instead of tdp_mmu for x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c1497515fa6a..371d55e0366e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -116,7 +116,12 @@ struct kvm_vm {
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
 
+	/*
+	 * "mmu" is the guest's stage-1, with a short name because the vast
+	 * majority of tests only care about the stage-1 MMU.
+	 */
 	struct kvm_mmu mmu;
+	struct kvm_mmu stage2_mmu;
 
 	struct kvm_vm_arch arch;
 
-- 
2.52.0.351.gbe84eed79e-goog


