Return-Path: <kvm+bounces-23161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA19B9465ED
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B5FA2831D2
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5535713C66A;
	Fri,  2 Aug 2024 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0onijI8D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC95D13C3F9
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 22:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638464; cv=none; b=c+FvqaptyotUTg593BfaA9HcZ1vZSyUpeEgqWJZEDoHLbbFr4c09XnEm8vc+jPdqi+exWgYkLuASFpx8G8g77aCSuM2Ui6GcmyAZooz47U60y+Ui03RFLPDV5umQ3/rHXxXWF+eePx92BX+bAaGYlfbIkH0/qcOxnOuZNehDDYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638464; c=relaxed/simple;
	bh=+8PWqUn5v8ELFuwRLcfeynpHGo4ajB+2U+KO7lA8yMI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ILcmlBC6vyWRnIVpNYwTyFEXAeq/fcKIkrrAq8/LF+TDbKXk/ljg4wgEAXm6su0G1ivOoAzMnh3wUARTdNVVLHwoIMBal59KtZJemlsxWvNx9BpsxLWObqSXFQ2gPeao4b/ZC6gs0CmIpQ91CaEm2W/ri/TW12jVR/fpty47wHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0onijI8D; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0872023b7dso13629930276.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 15:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638461; x=1723243261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wQg/YvoMgl7FyNj9U0nitSnR849bmsnUb2Q2PwwvwGA=;
        b=0onijI8DPv0zFSKfF0oUVLZlb74CWn8L+9fqircR2gJGIHSa/0C4XFNk82lYcCqGrS
         meoiyN7usZ3JRbs1xVI+a/za9pgCHr40uFuilf6MWj7KJCo30GQHbGfMGKhw4xCExF7D
         nQvy8H4enAskKXh2zCiFnjrgBg3VqSNnReWcuMBkSVbfKiDtjfx94Feql+xouRzEa4+A
         jzWm3CZC9idBvTSIYzULEB+87kvj3eaYsZHb9hCnRyHpnYWEmj3l+umMbGt/mJfAA1Hf
         3ajreWlx6TeOei5FXSO/Q8A5ypI1GcxC/mBvG8xx6E1uSTYx94+eSsqwMikFmBrxjN0z
         xijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638461; x=1723243261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQg/YvoMgl7FyNj9U0nitSnR849bmsnUb2Q2PwwvwGA=;
        b=TaLGeth6sbXRTEnO9rcBZz1gy0UYFUK2AZp8uqpBWLxRoTsCYE3U6T/f0LTRDgUVGr
         FgXWfNHiU/Vf/zGm/oDptYOaVchWOZ0eOHm14wHAfMHEVfhF91uXad/CPTLOUq1xZNq1
         cwUFuAXUYqAMYnfolJwxtRvkJGh45XL42JtSr9iaeKtsA0dcNVvI/LH4gmJLzCcSRR4C
         hcvFKoyJnBArdA2MKgXDRR231qs1hNsxQjSBw7SxE+nqaxeIbdI2p8swviSyTNKTL3GN
         QSNnoRMdDSYu9VYDbOfuKhlNnt9zSgGKNduEk/L9GXE8463117ok2Fh5mlJhlyi90s+z
         TlCQ==
X-Gm-Message-State: AOJu0YybjpJAIrnSf9b4OZo8CtWynv8R/wsgALBDEU5lRbr7nGiHPS32
	JtlpHqAnIhEkKXXpSf7luXOVLATPaijEaZ7ypppTkiprztKC+K24N4pRl3v3PIOYPJxbcNGkeyv
	lPHhLWWiWDw==
X-Google-Smtp-Source: AGHT+IGtFaFx4zh5naUYBzERvzjQFXAsvrg5mgn76ZrbuxK1hvekubdwutq95TgJoPA0V0wp7mG5L6tjyEmn4g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:100c:b0:e0b:4dd5:3995 with SMTP
 id 3f1490d57ef6-e0bde4abb59mr7845276.7.1722638461690; Fri, 02 Aug 2024
 15:41:01 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:29 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-2-amoorthy@google.com>
Subject: [PATCH 1/3] KVM: x86: Do a KVM_MEMORY_FAULT EXIT when stage-2 fault
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
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..c22c807696ae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3264,6 +3264,7 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		return RET_PF_RETRY;
 	}
 
+	kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 	return -EFAULT;
 }
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


