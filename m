Return-Path: <kvm+bounces-47468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 284A6AC1930
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5807507932
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217012741B0;
	Fri, 23 May 2025 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p340EsbV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA2A20C031
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962043; cv=none; b=rp9VjIF2irpDJCwyFiQmn1XdWJSq4MqKMTIhOWEg3lXG10k6INqhP5SeG/E4MU2FWJLeADr7wjq/Mr9boMRAaDwe7179PfWRu82gXw4KtiE+t9pycjXC1MADcsvcDkEFAw2Xu+kwVfQK4UuvHfclWpw+1ppty7yBL/xWhY2FJAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962043; c=relaxed/simple;
	bh=qKfn0sKD3VJ10k6Yz/i/tMNieJlz/OEPZhtcbe8s2Bg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CtGnXviB7vjUN71Mh6+9EOp3imK5JgZSumtR3Mhnpu9isc2lphKB9hz2IRQaO9Lb4GjWGl+y96yXHg1gXQgWKe4Q8a7eeTavOJhtsS48dhoBRJDQEjyxAKozJDx/fcUpA4GPQhg3Z86WSIZ+HzsmVXxwmm7k/Dp41os+UlZsf58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p340EsbV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26eec6da92so311758a12.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962041; x=1748566841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2h36XJDcqMOP2O/HIXVaEhk+4kdxNMwCrjoN8g3bZnc=;
        b=p340EsbVAHPp875Kvny4ob2M/aZQLpHieoyaG/EiDRXoTDODpo19VARKAE6SAcDJyS
         fFAmmCFXV8v+JF8NyVRmUTsNi3dsbe1SpkUuBFPIWn3Ux18KEsjXVZYm22q2rbZQ9Cm4
         0S6HC0+TPqzumK+aLymqJF6Ld5QM1CqacPwAl/lbgj6R2kJzTaHW0RFOx3jBxCntx0B7
         tk70yW/2M/FLDbLeuGjDDZhwQoeiYv3mhcMar4TiqOBdBlz3svoNuOP/fNriEcLYLqMV
         Hq+E50PezzSsLjnHO4tkfO+qhZENdUuDyM4E9Ek42Jm0LxZhf488ty5y+KAf9cKqs5Cg
         Hvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962041; x=1748566841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2h36XJDcqMOP2O/HIXVaEhk+4kdxNMwCrjoN8g3bZnc=;
        b=UvRVuLDgllfowxfPnWT02iBGuZ4QgC4CwQIpyYHJoJyUMBMCxMUhkj5NExnBg3qhx9
         3d9YnUqeS15GZ2ye63F0sVHNnIAq+IhngC4fcZnUVRS3zIQNzahMrlebd3TIlZrQiBuJ
         fxuejPeEHamjqMAbbhrPKozko146IGVGruCswKoLv/eqhNmk4FnrfmIi5rNl+RWzlbmu
         cBoCpSBNYGfBpxyOTRLfRhAVufTF8OdGpZEnJGZCOsSm9Qv2Do73QgxSP8MnkbYeDQa3
         x6X3lcxMTh78qPJ3eOaV9Ut9E6j2WTK7bAvoVdrJNwTI/MyZP8EeKavKf0rWo3B4qVIB
         nLRA==
X-Gm-Message-State: AOJu0YxxIQaGCiGKyYbTbKD6mjGJaPbBb0phBdGKPuvcyn5FFIMI2/vJ
	tRy5lcKvh6/Ei2hkHAbxOqNM51+sA6M2bRHfiCft0pTdb3wM8ztEOvH79Z4EF+XkRp4L3nHB4ie
	ELUb8EA==
X-Google-Smtp-Source: AGHT+IEMSIoZYl1TZlKkM0v8bu58XVa9qs8p/xOaWsLXJEUYuTfjToJ8vFZtbUt+y6pO6aPc+iYxsxiZ6fE=
X-Received: from pjbdj5.prod.google.com ([2002:a17:90a:d2c5:b0:310:89bf:401])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1944:b0:302:fc48:4f0a
 with SMTP id 98e67ed59e1d1-310e87b54bemr1697766a91.0.1747962041094; Thu, 22
 May 2025 18:00:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:23 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-19-seanjc@google.com>
Subject: [PATCH v2 18/59] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a comment to explain why KVM clears IsRunning when putting a vCPU,
even though leaving IsRunning=1 would be ok from a functional perspective.
Per Maxim's experiments, a misbehaving VM could spam the AVIC doorbell so
fast as to induce a 50%+ loss in performance.

Link: https://lore.kernel.org/all/8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bf8b59556373..3cf929ac117f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1121,19 +1121,24 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-       /*
-        * Unload the AVIC when the vCPU is about to block, _before_
-        * the vCPU actually blocks.
-        *
-        * Any IRQs that arrive before IsRunning=0 will not cause an
-        * incomplete IPI vmexit on the source, therefore vIRR will also
-        * be checked by kvm_vcpu_check_block() before blocking.  The
-        * memory barrier implicit in set_current_state orders writing
-        * IsRunning=0 before reading the vIRR.  The processor needs a
-        * matching memory barrier on interrupt delivery between writing
-        * IRR and reading IsRunning; the lack of this barrier might be
-        * the cause of errata #1235).
-        */
+	/*
+	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
+	 * actually blocks.
+	 *
+	 * Note, any IRQs that arrive before IsRunning=0 will not cause an
+	 * incomplete IPI vmexit on the source; kvm_vcpu_check_block() handles
+	 * this by checking vIRR one last time before blocking.  The memory
+	 * barrier implicit in set_current_state orders writing IsRunning=0
+	 * before reading the vIRR.  The processor needs a matching memory
+	 * barrier on interrupt delivery between writing IRR and reading
+	 * IsRunning; the lack of this barrier might be the cause of errata #1235).
+	 *
+	 * Clear IsRunning=0 even if guest IRQs are disabled, i.e. even if KVM
+	 * doesn't need to detect events for scheduling purposes.  The doorbell
+	 * used to signal running vCPUs cannot be blocked, i.e. will perturb the
+	 * CPU and cause noisy neighbor problems if the VM is sending interrupts
+	 * to the vCPU while it's scheduled out.
+	 */
 	avic_vcpu_put(vcpu);
 }
 
-- 
2.49.0.1151.ga128411c76-goog


