Return-Path: <kvm+bounces-30846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 373699BDDB7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 04:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DADB41F24607
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59AB190662;
	Wed,  6 Nov 2024 03:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="osFozrZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB2190477
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 03:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730864443; cv=none; b=DYToByLUv/V7jIDtXFk8VJFyKsSerYZSJOUJrEeF8c3c+QD2or/DF3DHYctiQ66wxxXS+k6OdFoR9jeOmpvUTV7xvva+JskV8ce7Ilg4MnzuSHvfZf5Yh6GGgzdHLczkkCzKJWIexea1M2LnXKbN9/1c9lzp+MyFyVdtf2DfC0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730864443; c=relaxed/simple;
	bh=CMQ76uKI1FEpDkwvFQyA0kPM9eXSHdq8hIlxtAz4vQA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KWqOqFgt0GD/EM77EsFZ3fn3YbQB5Dcpj4n0Jpkdqf8VLEz1VVi/+WRzl3yA8dhlcW/53eHIWMqyDGlL59Sex1I/BMCM8d1Paz6VBaQBaMqGj5OklTHir+BkkTFqurMdrxeBgBQnDhxJM9gHA2Xn/7EQJyb+qyOlwM19nHUhcvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jsperbeck.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=osFozrZ4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jsperbeck.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e376aa4586so118426177b3.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 19:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730864441; x=1731469241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LplVTGJVvGJFvhtTV6mcwx8iPQDI2scKmqd+ot8fMsw=;
        b=osFozrZ4fRRdbnpx21dSCPnFkfbAyJQBT5sS9E9BHyQLY1lhn+iHBdu3R2h99tlUva
         zQzeBN6MOf1M48V+4MqlkOQh8naoZaW/cioPiDnSkNSnI4mjYGKC9GBodMHiOQgsIIMK
         aFUiGb572Av1HqXsjuPhXU8EWtpLV3MIiJTA27gdfWsDP/UZnJEoYoxyDyOAgUitfxV2
         fqTKoOF2se6ApRH/+qoLLltX0oKhSPiYy+7dSmi2q/uNnobUEo11UzrgotMdb4dNaGmr
         KvtxaT8IyqJQ4F60W4ghIcAM/2ffin85slLbqVQDiwUkY0nKhngb1UT13Nah/S9a3KjH
         YuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730864441; x=1731469241;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LplVTGJVvGJFvhtTV6mcwx8iPQDI2scKmqd+ot8fMsw=;
        b=f80Pi8QTtkCZYrzC8atkmJCoR1K/g0AvK/rFwG9Qm+TsfSGc39+KcYi0A2sgeMKxDt
         4da7TjD7NdzTNAgk64f64rggeQ2IAsc5JjSJLkE8YisLiduN7nHrp0u9SvEQYCzzoGi4
         hja0ZF6wor6sRmPTJwHlZhRv/LkaBbJ9dFSvLoqwWCFv0ySi+6o+9/yNywRuFtdecEOt
         mk1kCMLv1ldszlTN5eBQbU5tZEQCZda4xZTBo+dDAth5JiZWCkx+cKvgWWTbFu7LMFLl
         uDtAQLQYYpmgS1JEaHYz3HicyKz61+HuNgBLYfgbcq8xYzWtcdVlhxh89HvznjPkxOnu
         P4rQ==
X-Gm-Message-State: AOJu0YyVFk9Pd74+FaUOq65hWLOx3jplv/UXODrzNWidftb1u9sm8tk0
	Cgl4PkaPhbLAwhNGTi86gv253jxbmMF936uVLSS3UUznuYRuaQzpGSmN/bPrYrg50ocQhB1LQb8
	Cu6CNqAZ04vUNoQ==
X-Google-Smtp-Source: AGHT+IGzB+ojrRUXG2iLAlNNLqDQ7VKHBuH5SLcr3K23iMUurWN3UCPuphjmVaHR+inkaEx7vzmb8A5IqZO0L4g=
X-Received: from jsperbeck7.c.googlers.com ([fda3:e722:ac3:cc00:59:977b:ac1c:3a1d])
 (user=jsperbeck job=sendgmr) by 2002:a05:690c:4c09:b0:6e7:e493:2db6 with SMTP
 id 00721157ae682-6ea3b951361mr2818897b3.3.1730864440817; Tue, 05 Nov 2024
 19:40:40 -0800 (PST)
Date: Tue,  5 Nov 2024 19:40:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106034031.503291-1-jsperbeck@google.com>
Subject: [PATCH] KVM: selftests: use X86_MEMTYPE_WB instead of VMX_BASIC_MEM_TYPE_WB
From: John Sperbeck <jsperbeck@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	John Sperbeck <jsperbeck@google.com>
Content-Type: text/plain; charset="UTF-8"

In 08a7d2525511 ("tools arch x86: Sync the msr-index.h copy with the
kernel sources"), VMX_BASIC_MEM_TYPE_WB was removed.  Use X86_MEMTYPE_WB
instead.

Fixes: 08a7d2525511 ("tools arch x86: Sync the msr-index.h copy with the
kernel sources")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 089b8925b6b2..d7ac122820bf 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -200,7 +200,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 	if (vmx->eptp_gpa) {
 		uint64_t ept_paddr;
 		struct eptPageTablePointer eptp = {
-			.memory_type = VMX_BASIC_MEM_TYPE_WB,
+			.memory_type = X86_MEMTYPE_WB,
 			.page_walk_length = 3, /* + 1 */
 			.ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
 			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
-- 
2.47.0.277.g8800431eea-goog


