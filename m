Return-Path: <kvm+bounces-23130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9819946443
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA669B21DC9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92407535A3;
	Fri,  2 Aug 2024 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0HY8IUiH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805DC33DF
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 20:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722629794; cv=none; b=uAwCD7uv1+Dqi+5JBkU9mqgnvF80pFwKDU9EY33SbzWuw02tx/TXmPtQPZ/u2JeG2PDZcjyaLMRrtRzOvW9GdGfZEVgZiecG4awVhW/kzNgw5wgrIcVAimqggmA/WNAGEoy3XOY91VDP6l2eVihCqAPJ3EYUskftXgrd0xg8bx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722629794; c=relaxed/simple;
	bh=TXvdlxOVU7doVd8ZsCfPhM1Ucj5S0xNZ2Rcj/xvqPgc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U9kxYR1nju1GXF+0bttCZ8Zm9SGGpOk8HB6A1iAp16cDIIIsrHDqNUM+Bncbj/xiWbdOXFGokROyW8M4JSzXr0GSFU4aqj8ymFxidxL0j7Q7klU/evCWTuL6HtfAaGmQkv+kWcEXKaHEfatRgTM/77bW5+GdvjS73Ng21pdvnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0HY8IUiH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1a9bad5dso9164929b3a.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 13:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722629793; x=1723234593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZQFLav+WlDGG6CozZMcdSkYFx1BmtT+dLZeZWTkJks=;
        b=0HY8IUiH+anGj05Z1ZKisCJvw9fuBaiTE09x8iDjrZqXj/ReWC626MsvdJ3gnCkXWx
         +TXRp0cAhlgOnHOHJLXQU32efo104BNZ3OLsaHhADYeUH8UixsOouTuboOZNAqxbR+W8
         T+kenzNTsa6B2z2kXrFAVbsJU57OvdQGt8AFYL4AzpG3xh5FmjHULYu/NCryDvyk0cKm
         C9se5OTzTOCDvny+Kg2bH8BGReGw7iAcUAALcu8I6z4wwi70RQUF1J/iqXnzKEUKVvdi
         Y3RWX0aIeotu5+1+PodLJ+KGETg96z2n4/lXHrJKw1kn4BY5OdvtdoTWPMv92vcjL8M9
         mK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722629793; x=1723234593;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZQFLav+WlDGG6CozZMcdSkYFx1BmtT+dLZeZWTkJks=;
        b=mRqOFvO7FGmIH36MfmicQ3xFDkMLzcRdVkz2bCnmJ/b+wHLfuK/f0UILXQ+KWbXYXr
         UH3b9DhZzln0S2frJSpwyVmOgBkSchju+LfJZMadpS73dN6rAHS8WE2H1x3zZ/IVVrth
         0SnfF1zOY4dK6VhA1zYgYMMj2IRDQS7s7/wUgqOUrbR2StqO3Vvfxl21Y13YsJ2UXtii
         allOimD8pQ/0JTbbyb582Jbxc1gfOrvYldUAj7lMGkiJnxXgFCBBCpk67D3NqNJn4Tdc
         VZbV9puzzFmqaOsRPZZb2K1q8NyQ+xDtZ3dxScBWUvokAtulzxlOkeVxloSCY4CPg5pc
         SyGg==
X-Gm-Message-State: AOJu0Yyz1rYug9jDIOcZm088pyRl73nRztYz0/rCe/HggIqs772d1UUM
	JqEkYEl4CPW8Hcua2FumvGQHFDuHFQ71Le7bC4UU0XJXEAn3dx/AUiQUuf6088Y4IrWYvPLdEPH
	ROQ==
X-Google-Smtp-Source: AGHT+IFb99jmBNeDqQRBYLcydt+zXBMQx4p/CU8oV2WUABtLxdEGZvp3I6qLVp2sa1B93X8GgzfSYMLoBaw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8e9c:0:b0:70b:a46:7dfa with SMTP id
 d2e1a72fcca58-7106d0a4be6mr112403b3a.5.1722629792616; Fri, 02 Aug 2024
 13:16:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:16:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802201630.339306-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Use this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Use this_cpu_ptr() instead of open coding the equivalent in various
user return MSR helpers.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Not entirely sure where this came from, found it in one of my myriad branches
while doing "spring" cleaning.

 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..518baf47ef1c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -427,8 +427,7 @@ static void kvm_user_return_msr_cpu_online(void)
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 	int err;
 
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
@@ -450,8 +449,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 
 	if (msrs->registered)
 		kvm_on_user_return(&msrs->urn);

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


