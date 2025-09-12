Return-Path: <kvm+bounces-57473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4877FB55A36
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:32:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58A4F1D63860
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AC42E11B0;
	Fri, 12 Sep 2025 23:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wv8Cefo3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5159F2E0922
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719461; cv=none; b=Fmf7xn9KNIO+u5PlfILgVLVukICkMhlDNwAFQSVoVQdDnxEYLhUdpGW2XGG0eAOiE1GaUAJ9rIxEyI/zp4iDThzq+cJ8ckPR/PVzoJhkS1owTkeYNBOrQDfjqGEmfBvVdosAc6tQHZx4b7jyx0ldcMqrnmI2geL4DQz5Kv9n4N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719461; c=relaxed/simple;
	bh=15o9VZMft2MxcQUSFl+ZPSNTP7kKh/VfLBpA5JRopZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Elr1sSzoZpbK5d14A8hlyI/MiE9xdtgft0n7OkKUw5Nagqa2BYenWDJhsxHtZt5nPSKbwBmMiS7GFFl+0GeAGGNZZrsi/6+0ndRGXLhbk+L5CNRcLjR5fkp/j+aTnGXfHmf2ZSXYAEkb+TWR8JyrmyrQGeIOuzQ6/cxgfGB9OcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wv8Cefo3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32811874948so1949991a91.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719460; x=1758324260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oEM1NzRArGwHRfjs11EJFtjqkFE7gqTIfGb/p5R/iqs=;
        b=wv8Cefo3eFQBjZuDCkq72j4ndqHcwD64wmf/aD5H9jSbZFyNO94focP71m72KFaQtx
         PJQCSQ3OYvqc7t6U1dHwugHccw4on2HEsA3LNevK6t52PPYTcCM5af0nzMai3OMRbvnc
         ZAqskRf9CZoq2c1De+mpQwESr1f1fB+MwzqW28uTCgCnaCc6kkPZsPM2329n+7OViXyT
         KomEcLKxc3U5WaPnindmjfjp6aL3uPThYe4IOH2Z06zgX7BKjf6okI08yRL1qJzG9pOo
         9XQaq+VAK/tXv/1AUkOwx5bmoijNN68W63FgHEUJ+DBzHB95eNAwO+a5nRVYQxdAXQJk
         QYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719460; x=1758324260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oEM1NzRArGwHRfjs11EJFtjqkFE7gqTIfGb/p5R/iqs=;
        b=eJKL8Qjol58Og0Z7NWGaJQL8taCek0YQXRiBEcgVPiICEXC0ch0crf5pnNzZ+oIam/
         aCwJOkddYRslA9LaQtMn918bpIkhACqOiKOn3j0PN8EZouVwPM0qSptsaEkZmsJ28I+h
         VxLIUUiAXPMBycyQCmhlKnna74MVXSAkaJFEi83uI44gw5kaXvKyZdKq2Ty1ajCYc/AP
         REerHQQTMee1Oh0YsGrHfjmaHZ23qXTTx3ROLqSssb4FVFbMUEY3cYaqW81+O38HMZ3R
         6zXBoweztw1xNPLsl90dT2BlYOl2vMmHAK1JyVV2U7CYH7ucUvJjhD8ZAQu8pJdgaBya
         IDeA==
X-Gm-Message-State: AOJu0YwSQ0PDvwbWMDx3jqRUyY+NbqgMzCb726CfrtaWIgAaIfUEVQiu
	CyGcAnNS+0vEzz5DV6oxCvN1YqAMfIb9CntYASWnHlxsrRHO4yz1GktLE3/wWcs56LAF7U5RaOH
	FgrOqNg==
X-Google-Smtp-Source: AGHT+IEI5JovoN5wkH2yZ6fX9zcon0aRMyJn/qFmhwPGnpNLEiLHDGb5/h9oeAOds2uQCKUVhH7aIxxB5Vw=
X-Received: from pjbqi2.prod.google.com ([2002:a17:90b:2742:b0:32d:def7:e60f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2b44:b0:32d:dc09:5e83
 with SMTP id 98e67ed59e1d1-32de4f85901mr4667658a91.18.1757719459656; Fri, 12
 Sep 2025 16:24:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:08 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-31-seanjc@google.com>
Subject: [PATCH v15 30/41] KVM: SVM: Enable shadow stack virtualization for SVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: John Allen <john.allen@amd.com>

Remove the explicit clearing of shadow stack CPU capabilities.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dc4d34e6af33..f2e96cf72938 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5264,10 +5264,7 @@ static __init void svm_set_cpu_caps(void)
 	kvm_set_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
-	kvm_caps.supported_xss = 0;
 
-	/* KVM doesn't yet support CET virtualization for SVM. */
-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 	kvm_cpu_cap_clear(X86_FEATURE_IBT);
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
-- 
2.51.0.384.g4c02a37b29-goog


