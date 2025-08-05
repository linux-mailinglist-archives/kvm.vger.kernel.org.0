Return-Path: <kvm+bounces-54047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB27EB1BAB3
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0243A3AAA01
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4E72BEFFE;
	Tue,  5 Aug 2025 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ltajJh7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D8A29ACD7
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420756; cv=none; b=C/WBv2gmn3CAzTzW/SA64igbfxKDzHK4Phe9PB/xmfGK29lFsuuRfmB5RsS9Jna4YRfr1pM7HOg+ZFKG1oiRQO4gBcSki/uqI9u3PBwU+A4t3xtfkQVpDJ5SOqeT0GAfZY6nymHrDLEsQE0idn9h+/4ZQcJ369+KVoBbxmMShMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420756; c=relaxed/simple;
	bh=Uf3LhARRUHUx/5ijEPMCZbQc7umhxBRmBlCRrbgyJB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JyzeCAjjJXBSd9TOBw9QyHlUopwC0jY/EUE9zgNXuHMbdCMNYO0rHFRF3UxXQGl2OUHfNU4wsmospn1AJlDb1PzFKJ0ealVZuxXW+1GMMLxlRO+QTbvgFYkHSfBTcU/z9w9/le++8tJ+ODhkC1/53Ozp2At83dPo/uKzmq0I96I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ltajJh7k; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fc5b1c983so1827495ad.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420754; x=1755025554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m7pIQtdgO1Ly4runtD1BlGYWjUan7Zr3ARLYIITYVLU=;
        b=ltajJh7ka2OJ7IlnELzoncqvpzb1jLBEG//8fpeI4FYeeS6Fl3FkPLzSR9bDckywuv
         Lu83HzthbEMspV8eJMwyR8OU+R6DtExqQ2sGbD8q1KsMHDg9HeSXaetEeeH1UOG/hzi9
         Mixrt31O7ObMqt9rHwO3R2pTjQwYqd2GPjXeNtlEJJt1KMsW+S/Uxe15pOzG2i9uFDwy
         uNclZibmi+0ie03rvSDSJT2miYFHUjlDIskIRcFMijbPAImeZHH5+NmBj/uB9I9eaQO/
         LdTcxkYEXZvigOqb6BZzUUvyEQFUr8wHDVeAJw7fSe5q1i/LUNrpBfQ2+NPIMv2+rdcJ
         DrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420754; x=1755025554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m7pIQtdgO1Ly4runtD1BlGYWjUan7Zr3ARLYIITYVLU=;
        b=o7iNFG9MYxLm5nSvdK2HAhviW/D+mb6Mpug/yHb1hzk7J3zKXE2FlvQ/8H2F9ZfvjU
         6a5SZcdDdupfEf2ybsVnF5h/jf/HLVMGzvUi3p9kDxzbgxPJqn2IZgIq3pxiB2BrvacZ
         5gVoIA/y12ANKAdWixXZUMzc5hg3645f4ZtDM5FA579t6NDJj3j/oQYOIt2Yi70OZJJA
         cjchrH9v7o+xsC/PpwD9VoKhpj/N0ufiHwFFvznP8RB4eaxfpn96sfQYaGWgf1gZG2te
         Ysekemt76CPARL8bxrWJXjI+sksotfFxiZOZbBGsrpyqIZyOaABtukn51FJ+arksrOcT
         w4Sw==
X-Gm-Message-State: AOJu0YyXRD8wSrTEEmU5H6sc7n2RADGtUaHAQPVRI0ocbLX4JI3Gai2Y
	8RO+rOsHpH/YT2iMrsGgbLmcJhfd0lRzrR+adp01AVW3WEGVlQId4HvNZjq5KO+W9wkxLQHpbAN
	L7uBr0w==
X-Google-Smtp-Source: AGHT+IG3+BUJeywCnhbOTBO0gZnJzDqaPsYALbJj+kP15NYqy9TsM5+IMTgOn1X2lnbVEgPLhVTAv8iMyVE=
X-Received: from plblf6.prod.google.com ([2002:a17:902:fb46:b0:240:1be2:19ee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef4e:b0:240:86b2:ae9c
 with SMTP id d9443c01a7336-2429f959d4dmr859115ad.14.1754420754232; Tue, 05
 Aug 2025 12:05:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:22 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-15-seanjc@google.com>
Subject: [PATCH 14/18] KVM: x86/pmu: Drop redundant check on PMC being
 globally enabled for emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

When triggering PMC events in response to emulation, drop the redundant
checks on a PMC being globally and locally enabled, as the passed in bitmap
contains only PMCs that are locally enabled (and counting the right event),
and the local copy of the bitmap has already been masked with global_ctrl.

No true functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a495ab5d0556..bdcd9c6f0ec0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -969,7 +969,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 		return;
 
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
-		if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
+		if (!pmc_is_locally_enabled(pmc) ||
 		    !check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
 			continue;
 
-- 
2.50.1.565.gc32cd1483b-goog


