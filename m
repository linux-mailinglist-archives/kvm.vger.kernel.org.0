Return-Path: <kvm+bounces-25599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9996E966D57
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 586EF283021
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C062C8DF;
	Sat, 31 Aug 2024 00:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XyncVTSp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8488528F
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063374; cv=none; b=GZ8Rrs4Nn5mQVj/peh7frHgTG8yODwKWYfDjeI9IMxnc2/8or+dagWPr6LqT+Yc+g9Fv9tlFV6FmzKynYdIoct7/KHRSOThOXOGFvPepSewo8LVSEuCHKEmTf2jLcoXnhrNbjLqpK+UWA/N1WNfDbfz1j95SiVBDZnQsD1GshQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063374; c=relaxed/simple;
	bh=oLv8xcV7npfhCNOsBP8X1Fn7qxQks0etkV0j5AxfzOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fhTzwT3rucV8NBTCSVjLoLp4k3rfgq3qSwjggvS+8gTYNBQWtCjNbEquwAA4KXIo8wKn/JEqNkzrCBopaDzlGFS/e6/zumTt9JU/PX1Y0lE3ZhJr8/OhNjsA/02+cAPJH5jjDYbG99JPaDiPN5g7wZRf7va2nKqS4gBg7kT0tWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XyncVTSp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6c3982a0c65so43852157b3.1
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063372; x=1725668172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u3jsbE6XP6TTJxd7m+VzZ7IpksW0atkO59oovcuh+cU=;
        b=XyncVTSp9OOQ1hTBku60LBAwfl6MAAxDKr4rDWj8Ap5Tlwj+RvpIgXkjVvVBLjSNQe
         leSkZLfcw1Nz4h7kH/iJGvdOjp5Exa2BcGf+kKvZ+jM2ZVGBXBEiKKMz6/lLr4pe8vh6
         GunlKsH/MWIMUfoJLkZL0U8JupRljNPFK60flwqEJfSK0YSy66O1YY3QfoWanI9/n+aB
         5fKwSZaGxXK72XdmgnfsBdUsj2vcpczy1eGe5yfeJh2Iq0JsAuTaqPle2mqA+v8cHHkO
         AkElyQX+g+43wdOvNyY0wE6eRbUHnQQ0mgnk8dqNGPkHWcNgKVMnvmXcKG7el3uDYou1
         xMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063372; x=1725668172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u3jsbE6XP6TTJxd7m+VzZ7IpksW0atkO59oovcuh+cU=;
        b=qfm4O2OELzySUpXpomkupzh9gNHCBANhM/3ffDAJs0zrU1Ha+763nOaL8kdorLZO2m
         SgKMdA+TQ2RIO2/L1Ov9GhD4lql6ly+tirqQSzT2naV8WKzabIiq4N0yQd5Esmw7WxmJ
         LcSq1VpAO0qj1MRXlhNN98m5wVvXiN2vY8+j/1y3NgJx5ZdhKIBd/n01KD8W3H9qyeWC
         lIgd2PCW5JVhLH1yOmngvaORKh+0cZq+H7wc6fPOHbPaZv42u2rC7zOkQ7Zj8+8AzJro
         +sEn4ULqlUaaSZmoS8Qs/Lp4Nxk3J/xbrwWWwb49dvq0uaWQfyV4/sqCmJukQ7OKOizP
         zFvw==
X-Gm-Message-State: AOJu0Yy0ORNvkFnLiTOaFdxsuXDTAiCQkrUQw/JHipJhUuLMMFaMErlb
	LNt92Zm6DA0pGNb+WpAacIQifKeSZFv/H+Du9dPXA5fjR2o60c3T8WDKwoDySc5U2a8lrr826z8
	ZKw==
X-Google-Smtp-Source: AGHT+IH9ZaBmo0cTRqD8QCtPipkvkJ/y4RHQnHtriu8u41kiihvKrtMLF9S4g7I+ks6ZXYZUgSjRk+7s+Mw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:9c9:0:b0:e16:50d2:3d39 with SMTP id
 3f1490d57ef6-e1a7a1771dbmr6330276.9.1725063371775; Fri, 30 Aug 2024 17:16:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:30 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-16-seanjc@google.com>
Subject: [PATCH v2 15/22] KVM: x86: Remove manual pfn lookup when retrying #PF
 after failed emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual pfn look when retrying an instruction that KVM failed to
emulation in response to a #PF due to a write-protected gfn.  Now that KVM
sets EMULTYPE_ALLOW_RETRY_PF if and only if the page fault hit a write-
protected gfn, i.e. if and only if there's a writable memslot, there's no
need to redo the lookup to avoid retrying an instruction that failed on
emulated MMIO (no slot, or a write to a read-only slot).

I.e. KVM will never attempt to retry an instruction that failed on
emulated MMIO, whereas that was not the case prior to the introduction of
RET_PF_WRITE_PROTECTED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c873a587769a..23be5384d5a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8861,7 +8861,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  int emulation_type)
 {
 	gpa_t gpa = cr2_or_gpa;
-	kvm_pfn_t pfn;
 
 	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
 		return false;
@@ -8881,23 +8880,6 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			return true;
 	}
 
-	/*
-	 * Do not retry the unhandleable instruction if it faults on the
-	 * readonly host memory, otherwise it will goto a infinite loop:
-	 * retry instruction -> write #PF -> emulation fail -> retry
-	 * instruction -> ...
-	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-
-	/*
-	 * If the instruction failed on the error pfn, it can not be fixed,
-	 * report the error to userspace.
-	 */
-	if (is_error_noslot_pfn(pfn))
-		return false;
-
-	kvm_release_pfn_clean(pfn);
-
 	/*
 	 * If emulation may have been triggered by a write to a shadowed page
 	 * table, unprotect the gfn (zap any relevant SPTEs) and re-enter the
-- 
2.46.0.469.g59c65b2a67-goog


