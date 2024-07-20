Return-Path: <kvm+bounces-21997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2F2937E55
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 02:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2694EB21375
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 00:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE4B208A1;
	Sat, 20 Jul 2024 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GE042bsv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD85EAE4
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 00:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433706; cv=none; b=dRnS+gPyPQBoU0kozUVw3avJ0F1GtLGagA8cgNDq6MvQ+DNNqfjfHUaWagnNwyDSew50HYDerx80WiYeqNMgPvbk2yClIYaiwla9iJpeDG8c0m+DQVWVRzyReNoPu7gmQKIz6uRoHQtEjEuYNHTahW5Mi1Ji6ekUgJkrWgxy/Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433706; c=relaxed/simple;
	bh=VqsKa1WimS9ikW1CNPjNpZC2DpEQUsoALSiC9PZV/cI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MNsR/flEDu6vHnCEIvq5SQMrGNcJKnEmIULBINCY5xHbopNRl7q7jUMV6wUrz8xaumaglYuzGL68USUDZkn4IclsQ8Gynruu17dGagvlVWiEZE3s7H9D78qg2wsngCZYer92UD7CvNrD2AgOoXJYbYFG9aCp5SMKc/webN9d99c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GE042bsv; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-79f7e1f0998so424213a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433704; x=1722038504; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jWQXbwGgjnrhFwaWDlRF7dDcL0Y0IybdDbZ77h8k7+Y=;
        b=GE042bsv/+MtJiT69c2GFBQCUj8Tsl8RqJ2I9hQVKUD+PAWSKONttQYX0n6JK5T8B9
         kqnHMbYhniuE9CBzNPGv2nI6qn7jqnZcAdu0n5wHt7+I9vYvOrk9QIi58IXSaCIAqPFc
         pjM+IFawk7iod2hprLHjAPEd4JWa9qXKFbZ3Q2cokEvXl4CDPVOpi9ojgx1Ph6SSbpD/
         sDUVtXVgw5l5WwMoRVuimqoPoA2gVIyDr4tJETxmzknsizvc10YeVoP5rUVbEFvTK3op
         +sERmk+warH749iA21OhMV1rmRtlTw5JSM9ek86OS5VV77YlUDLOzivZBIoiP30GWdyz
         kCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433704; x=1722038504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWQXbwGgjnrhFwaWDlRF7dDcL0Y0IybdDbZ77h8k7+Y=;
        b=JDUC3XiNr8RKM0pzo3F0JDk/0HxP/naBtnMAuTBzgxsjlMBWydI41EXosEfRJsRvJY
         c8CqG4NN1Kd9REkBDTVywHVz2HeB2kvfSDEZJBLE2xngCPqlgc/oITek5GOhQ7gsmBhl
         B/IfUJOVtXnhwLhs+9vYrXCLDj6WRL4qClKzEi63Eu+juPHS30DE790btPMyDuvXcXPl
         u7+bcrpp+3kyIX1TSZUtFk3hva+Wp/PKXnUqPhM11XBgRHcPrvtC7yFkOGUDy7y6gCIa
         EJpuXoIr/vNcsHvF1IYxyLKlrRxhgbLxvjEul6eoJ0xPzszajevaAF8/5M0l8o4CydPq
         zznA==
X-Gm-Message-State: AOJu0YwYKKFzs3txOVkGZh+Zy8g6DBSvQNw36yjetRrBRAeUMigmGCCv
	BN1GMQaWKXCn2y1EBZgv2TLmDHxT/ZGbxUSVc9EAnuCvluM4+CLuszDX5/Zt48dZ9vXrlrHRdUY
	3bQ==
X-Google-Smtp-Source: AGHT+IEkou7ZoQZ8BydHFuZQ3Ir14Iu8av9pw1BHJhZUiJGG7HtjDw3rdyBfFsiTuXQxxaZKzQPUQy09EHk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4d0c:0:b0:71a:2fc8:7fe1 with SMTP id
 41be03b00d2f7-79fa2222dbdmr2695a12.10.1721433704096; Fri, 19 Jul 2024
 17:01:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 17:01:34 -0700
In-Reply-To: <20240720000138.3027780-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240720000138.3027780-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: nVMX: Suppress external interrupt VM-Exit injection
 if there's no IRQ
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

In the should-be-impossible scenario that kvm_cpu_get_interrupt() doesn't
return a valid vector after checking kvm_cpu_has_interrupt(), skip VM-Exit
injection to reduce the probability of crashing/confusing L1.  Now that
KVM gets the IRQ _before_ calling nested_vmx_vmexit(), squashing the
VM-Exit injection is trivial since there are no actions that need to be
undone.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b3e17635f7e3..b042b70560f2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4295,7 +4295,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 			int irq;
 
 			irq = kvm_cpu_get_interrupt(vcpu);
-			WARN_ON_ONCE(irq < 0);
+			if (WARN_ON_ONCE(irq < 0))
+				goto no_vmexit;
 
 			exit_intr_info = INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR | irq;
 		} else {
-- 
2.45.2.1089.g2a221341d9-goog


