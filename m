Return-Path: <kvm+bounces-49166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A8EAD6325
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 724D03ACA74
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD12D543E;
	Wed, 11 Jun 2025 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wP9PFWVb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F7A2D4B5F
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682052; cv=none; b=Lni2lUcs3KfnJpSglieygFZYQsz8lqx7iP8PKZe4YXTQU7DefgHdUoTQpvRPZx2pILtz8NMGo3VOY8vLYKDktxj5TGZ4a0HaErRCXqUs1n6/6TRjc1ZwkmORDhXmmVf51SFV4B5uBuxEL7xWTllFjGKhI8lyE3C4y7vd/HQezqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682052; c=relaxed/simple;
	bh=hFP3peTM4c0R7Joyj2jqYQfH1PZW6FXsWdmWLA4bm3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R58U6+isEQQLuTAELO7lAKF69JBvA8EIF8oNa05RCX5E9q1pXTJL3Jaf0LdOcB7gj3W2y/SQq2AtwXFe/TQYKe6IujAYI4lcbX1Xwq2x64R43dZW5djJs/fOx+EOjUPQRMk5UVdMfQWR0RX/DERMWqhOnw67z7Wn7cCV7U1rEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wP9PFWVb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2363bb41664so1968225ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682050; x=1750286850; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c8wf3RrDwwapSfuoerOV8MPC7AS9NZOZvn4WILk0Yi4=;
        b=wP9PFWVbb6TwOLPm+nVfTfD8pnSARmXSTOVmc/7cx2yT1svovqh/3PAQrrmcyLmhtk
         DXJdyGUw1mZnlXsAvSnyvbAqBtvDbXOHtwhh9dsq6/x6E8sUb+FwQ3Wyt4B+iONkTB3U
         VbevYpuYHLujtzjbbJ2PI7Dh+LRktn+bEELWYDju7t8ZFnKa3ZKFN70ePXvntUH1chFW
         LEDp0Lcrgks/+wXJf6gsaOYKxqGpnV9xo2CycNsLuM0Zh7/NhLNg7bJc1J2bC6PF/+xT
         8C9fmVBSC//Isp71ChSCrmJhMj347+h/F6hOYgyE7UQgRzoznSHEPGCKf87stVRFLlqD
         djFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682050; x=1750286850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c8wf3RrDwwapSfuoerOV8MPC7AS9NZOZvn4WILk0Yi4=;
        b=PdZV//q47QfYbcFSboTBMqtMz6Yl2YmML52Ya6cw8jMwQ0aG93z52cwXOXzmEOOCZV
         ocXXyq778NNloxvvNpAvthEWf1w0fKfoCwHbX/pyRtkDu7hZPTlvgPXQyl6DaBuE9KnI
         RLbe14vovC8uxNVD6hf8SDUqfP0HqjNWwSjgw0NOVzazPWOTYb3z+R5eX/ol3seFN3Lm
         C8Vpe6PuahDeVA1cRtaMBKw7m6AuzsiaIRsHjRKxSs5H9cckTI8UG304Xvh+aNzgPHmx
         inOMcLer7Y79vFuRTxrpA0FpNpOoNtlm4583mFnbbjaIU5oMJIARqMEzkOvU3a4ozsOK
         MyQg==
X-Forwarded-Encrypted: i=1; AJvYcCWTPhIJmj3rczuCQS3CLjxHXW887oDpvippQzueKNzVu62pnj2+78AKtnjJw6jDK2iaIGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqT5wu1lqjOBtZyDby+4O5/tqyz/2YZQk26ZQfyV87ZaGcD3wx
	g+CxQ8mHsxySLYeC1HfCR/chS4RHtsBCNi86IBDiCbOncJWjozQ8E2zZa5faUJOFtm7ZFnW+LPY
	27cHP6w==
X-Google-Smtp-Source: AGHT+IGJNCuXT10P6Ldic0CILM5/98q+VXrxvc0wPM5pd5dn7xv2Zsl8s09cXT8aND58IoPHTgLj9jyuzCc=
X-Received: from plk17.prod.google.com ([2002:a17:902:e9d1:b0:220:d81a:8975])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54d:b0:236:10b1:50cb
 with SMTP id d9443c01a7336-2364cf689c9mr14160455ad.26.1749682050046; Wed, 11
 Jun 2025 15:47:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:23 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-22-seanjc@google.com>
Subject: [PATCH v3 20/62] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.50.0.rc1.591.g9c95f17f64-goog


