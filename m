Return-Path: <kvm+bounces-27879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E7598FADD
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9FFD2823C1
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9771D1E93;
	Thu,  3 Oct 2024 23:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PmgE+5dL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9BD1D14EF
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999030; cv=none; b=NEpmMyuxPi5YqZ+gJ9q0Oub7r8ZSCKKA7NdjhxKc/XT7lxb8RdgKXZG6ZFE1ELLBU8rWhozm4Xt6dbh2vcBxCkxH2JxYhz5osVRTImoDBullq8H5GoDnp646jnllJO3PqD5Jo5cr3eZo1hpnoghzQljbpvD8NZwbwQ+z8/3CIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999030; c=relaxed/simple;
	bh=PtrRlu6468I2zXi5sMQUl9RRClXhgN/bYQ8V5FPjqhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iJugVAeiqF5d86FeFgocS7JU/kl2TwGGXm8LUOF3EDCv14MPYq47lQfZko94EsAiaUQRMGQ0XxGb5ktt+zH+nTi6e5eaqr3cxm2A30VnfrTf3VUid218WuiWPFKqsdcMgba2N8h2NBUmad6FasTGT5SzXS/xMx5lFh7Lpgsafj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PmgE+5dL; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e230808455so19636997b3.0
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999026; x=1728603826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=49GBsflx4kJ26M5BBQeAer4waxjgInZgGBve4oDuDFo=;
        b=PmgE+5dL+VQF7FqUAKqT9hxg3bWfje1imoD5wJGLHHCBM01er+cXfzy4k9mNcAsyrD
         GTjN0fqlcz+Y2CwSbSlTL/zL63Q6GVq027QfBQImcE9sCYPd8o4OvXOXhsZg+Rsoex8M
         a7pRtaBMJWw7z924qPGrjI/P9YeRl+xUZTC7yrdsCmHbbfZsn0Km99crSJXys3yRp2Hz
         KADohJPwd16DLHtVldDG2RXVhX6dc939RE+okFSNl/QqtxvEuidLmptRCRR2Y+3MA6o8
         9ABpu5hx22Q+8MJIP3LZv+CErjc8RunTOIw3v5VTsKNz4WrBKOOOqzmnWd6+U5/bjf4H
         GlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999026; x=1728603826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49GBsflx4kJ26M5BBQeAer4waxjgInZgGBve4oDuDFo=;
        b=V4uemwoYyHpPvXb+9SvKao494OWzWpC5OgDtILoMhDER7hD9TDlBuWYh/TCmV4BwTI
         biOqqFbyoQTasmIejbIbPGF3HFaNT1qy+MXB0m2blrmqEdlzd6t5A1ixK0PNGNNuwb6c
         4Pi89O01WQCaWxX1OeePrNeJg3Ro7JB0+mD12Jt/+HXurK02ESJuKZHqHft9YqkzmdGh
         wcmIhqORYN60XQ3CTkcHK5bzETDJsbJiPs5M/cW0XM3yTer6A62ff3p/2U45hFwdICbV
         hHMwGlzgW15oDZGv4mWSlg4GzyI719MEpgl7NjNf9z7Lcr34h87VNeN0AkMY3D0kJ0fL
         3Aow==
X-Gm-Message-State: AOJu0YwFWZ5AcYzZig+n2adCyzrn02PJrTVYLbhHEaHQ2E4Gxci07JjX
	wbFLS7gbNRKfLsBKz4CqcBj+CuxHJu5DZxGWftiihmWUXRUYwVSelnrtBAIY/BSPOEkhctnlTGs
	ZvQ==
X-Google-Smtp-Source: AGHT+IHXH8suqly6HdzHCQ+5EeC4WB/t3O9O2a59kE4ofo5bIvTb741Hm2G2KACsRGD7rnXfUY27G4xAUaE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:938a:0:b0:e0b:d729:ff8d with SMTP id
 3f1490d57ef6-e28936e8489mr1022276.5.1727999026390; Thu, 03 Oct 2024 16:43:46
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:29 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-4-seanjc@google.com>
Subject: [PATCH 03/11] KVM: selftests: Mask off OSPKE and OSXSAVE when
 comparing CPUID entries
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Mask off OSPKE and OSXSAVE, which are toggled based on corresponding CR4
enabling bits, when comparing vCPU CPUID against KVM's supported CPUID.
This will allow setting OSXSAVE by default when creating vCPUs, without
causing test failures (KVM doesn't enumerate OSXSAVE=1).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/cpuid_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index f7fdcef5fa59..7b3fda6842bc 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -62,6 +62,12 @@ static struct cpuid_mask get_const_cpuid_mask(const struct kvm_cpuid_entry2 *ent
 	memset(&mask, 0xff, sizeof(mask));
 
 	switch (entry->function) {
+	case 0x1:
+		mask.regs[X86_FEATURE_OSXSAVE.reg] &= ~BIT(X86_FEATURE_OSXSAVE.bit);
+		break;
+	case 0x7:
+		mask.regs[X86_FEATURE_OSPKE.reg] &= ~BIT(X86_FEATURE_OSPKE.bit);
+		break;
 	case 0xd:
 		/*
 		 * CPUID.0xD.{0,1}.EBX enumerate XSAVE size based on the current
-- 
2.47.0.rc0.187.ge670bccf7e-goog


