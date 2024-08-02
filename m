Return-Path: <kvm+bounces-23163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EDC9465EF
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B0A1B221A6
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF22313CA81;
	Fri,  2 Aug 2024 22:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EKyUO5N2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A524613C682
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638467; cv=none; b=YR5JLgSBQhFme5A146UZOTO5abjVUvsOr+054sZh2W/bf+TjM+Td5MxPs/TKvrxCQi1N9ZLg2HDI1QloTXvOI0gxtW9uY/yC16gXLNWK3dUBn+c18olAqs2MRCx1sQp6OovrdYNNw6Q6PhA7E5r+cZQHr2a6ci2O0l6WVo3dO/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638467; c=relaxed/simple;
	bh=2BJP/Gjlhn0CI12zdChPBuMYdNrdF6BpuynLMzCWLmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DEZVz9GGfbn5l962g0u/b4xAXyLRLB15su11KMvEl2Lyq7T1yIjY32cNOKgm+MPLgHZLMF9wK26tA9wVZXpGFbB7lJ5KmN6lynVkF/lfZ8EknR5zpa/9k2CZTkkPhYjYjzXiWqP0S0h6hqyKfkhqehpJtWvXJLaLVJ0gbmlalXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EKyUO5N2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6698f11853aso166291677b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 15:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638464; x=1723243264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mg6abDzvai2Zsgu1qbiWH7RLNmKIJFQcCyuMlSnLw2M=;
        b=EKyUO5N2UV5EjE3FOBeCAVa+sVYFZ/OrHHcdf/np16W3wH5JCbk8daXql8SGBaPyJw
         PAOeVedYTGcJoOA5dL4BKjyVcEA2wD32pqZZKd/syqPqdbLZ4kdanllvd8LXVZvg71Qh
         Y7rMoMszDSXw4bxYOQ1GAREHjpjZtxiW+a0An0JTC5JTlY1fjJsJeHODJ9aSC+v57NFT
         pDGLoa65+YZDr0Mz+rJtSf/6v5mZnUTERVQl/F3buM5WhFpUXowx100vPS8npJbVDqdi
         fIe9H1hdyPlVQs3EQqkD7yO2cw5yOe7Es213gQaeS8RpqMlelvnUBQ1Ahixmdk3I4mYy
         +xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638464; x=1723243264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mg6abDzvai2Zsgu1qbiWH7RLNmKIJFQcCyuMlSnLw2M=;
        b=Ql14KkkEseZD2n46jD3fWxFPh58eW4D/IsFqVbPC59btMOqT7X4meooWaZRJpRbw/a
         zMzH6wkmkomk78i0WkB6Y1Mq01K9xUvWcileWry7l3fxPcOSF5tyZOXnj+m2xxWwpbEk
         BpoT30FNJjQrRD/2S7F3JmZT0LtJWX/2IyNrdDYrh5y1Cz2WzyNhYv2x/DGnZLf1zPRl
         OZKUWWHR/zR2pHxxA4oJrK0mMErqKVgy8C9uQ6NDHWWiCK7cliXJVrV08Jt9lJBTrdlI
         VNHyG1LcFZZSTGU3rKr+wS6LRh4MVx5jO+m0LnBf95w7YvNMZ46QoqWXgghuXRYCt2O+
         GENA==
X-Gm-Message-State: AOJu0Yxpk1zcoQdesfkeoSAmw3qnszL/wAot78+Xqu/ntj3ViXVrVSHT
	hlyf6QzZN7O8s3SedxpDPWfvdEb7nM+oVUPWQJKOEKfgiba2AFPJRXsPsxC/ofvXvRtJuhW0Ddw
	9KUECvecEYg==
X-Google-Smtp-Source: AGHT+IEY5CubreumvsIjMcPe2q5xXNHlPJqiPWsr+2ng5ETcTgVR1+5qyV+F3pi2OrpH5AWrnR9VlKryzgVK+Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:2b0d:b0:dff:1070:84b7 with SMTP
 id 3f1490d57ef6-e0bde21e24dmr9370276.5.1722638464470; Fri, 02 Aug 2024
 15:41:04 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:31 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-4-amoorthy@google.com>
Subject: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2 fault
 handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a memory fault exit
when this happens, which at the very least eases debugging and might
also let userspace decide on/take some specific action other than
crashing the VM.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..52b4f8e648fb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1568,8 +1568,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.46.0.rc2.264.g509ed76dc8-goog


