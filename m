Return-Path: <kvm+bounces-15691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3883B8AF4AA
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A29AB239AF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E1913DBAC;
	Tue, 23 Apr 2024 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zXi2Kof8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD813D637
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713891214; cv=none; b=D4SMuXGMlgIiJ8BB/AaMnXZbCA1wfmylu2GykijuvtR2VotPA4bZG9WGf+WUQ+vkGbz1FIYBy9CqPDc6ZR8lODYsEdgPyE7DSOtohV6Vb63JvL2J8TMV3mOLKdWuyNVzZh3fGZmfGJryB1wSYBKRUbyE+HrbRsZKqPXPdJnAiu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713891214; c=relaxed/simple;
	bh=IIA0cZD11SCgBB3seks1sD5Tm1ngX7ytjSsIqj8LB4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jP7oFZ8wHXJsHnc7QaHKs/Vq20RupngWm2a8v07xqvlkcu90lkM0cbBN8Qc0gX6lRAO/sZQK18tGXM+Q/ZrEhoO8cT5Ttzm+wlk0IP4vVuk7MwZ002hKXqZuWqzW8iDF80QeP0XnEYUlu0HS1ck8gwIpDecdFd/4Gzqf9G6Z05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zXi2Kof8; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5fff63b4a87so2031740a12.0
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 09:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713891212; x=1714496012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ftFQzTSwFXT1TIp1fPDslrbqn6nx3jYtj/iibVlTl4A=;
        b=zXi2Kof83cYMXmR1e3PcChCblyi65SbjE9NWdj5+XpI9OQZuvJxlWSV7zOdHgvZ/uh
         7vU6o8jgwBk6cDfjUwIhYEVA03W0gfv8CaZpZeaphtVwwTpIbDkPMOBg7ahyiKvdytSh
         fCScGGmzm/4CQmZz1W5YC+lTimbEomsOxzCjH7TpiiLeYo37i+6jZaCrC/u/c5ZtydmK
         4VTNX2Ve1iJuYmi4gchGjUbfspBr+BDJyLb7H8gtCv+dPIXOXyLRMCzNqCX1xXBiaQlc
         0SAUdlGxWQOKjzZzkhmOsMP2jG9OUdrfAJXuh0qpt04eyAHnfHWN206Gh6iemk9ELGhj
         kdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713891212; x=1714496012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ftFQzTSwFXT1TIp1fPDslrbqn6nx3jYtj/iibVlTl4A=;
        b=BsIbDQyaIrNxUl28o54+xJJJ9vVfRV4V6SzMXfS125o6S8WC4PMhAhrRMlLo/T6bSc
         rVucHGA2Cqg0W5SRHcGprW4Srpb5FAbsdSUgwvOJpdSKvXQ+gEteTVrp8dDAD7tHO/rs
         haQ1Qr5H1UMA4u/dC3U1ZWL2duiBPXdDm1eydjU2nPLkM/I0bLn14q4d1LUaByNeagwg
         uswCLrkoaY0+8DoDAhg7KMNgPDKNJTmsf+n2AEAQ4pQi6IiZ590k/6x7X0YaOWbAtFFM
         jjqeZ3M+R/WO0/fQvnT4sCkeverfvH34AAzhEGQIdD7gmZQI6cUgU1qKim1r+VOq/OsB
         KelA==
X-Gm-Message-State: AOJu0YyTpLXgqWslUWXAmkDSJVcKhZzX3SkcVw2GP91szqBmv5uqWayR
	HntAoqNccanqPR4avIcSrpNVHOPGj0m2xhm8Dre0qjFns8bqLoG8fyDth2/4gIGSZ4QwJ9V7BHJ
	7/Q==
X-Google-Smtp-Source: AGHT+IHMKvgcg5vLMtiLvLskSs3bQ87rsfU5twomg9UnoRcDVBw7UM6yzMuwcxiHO8TKCzQ1vo/xo09ouPs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2ccb:0:b0:5dc:eb5:19db with SMTP id
 s194-20020a632ccb000000b005dc0eb519dbmr1690pgs.0.1713891212528; Tue, 23 Apr
 2024 09:53:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 09:53:26 -0700
In-Reply-To: <20240423165328.2853870-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423165328.2853870-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: x86: Fully re-initialize supported_vm_types on
 vendor module load
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Recompute the entire set of supported VM types when a vendor module is
loaded, as preserving supported_vm_types across vendor module unload and
reload can result in VM types being incorrectly treated as supported.

E.g. if a vendor module is loaded with TDP enabled, unloaded, and then
reloaded with TDP disabled, KVM_X86_SW_PROTECTED_VM will be incorrectly
retained.  Ditto for SEV_VM and SEV_ES_VM and their respective module
params in kvm-amd.ko.

Fixes: 2a955c4db1dd ("KVM: x86: Add supported_vm_types to kvm_caps")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d2619d3eee4..a65a1012d878 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -94,7 +94,6 @@
 
 struct kvm_caps kvm_caps __read_mostly = {
 	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
-	.supported_vm_types = BIT(KVM_X86_DEFAULT_VM),
 };
 EXPORT_SYMBOL_GPL(kvm_caps);
 
@@ -9776,6 +9775,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r)
 		goto out_free_percpu;
 
+	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
+
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
-- 
2.44.0.769.g3c40516874-goog


