Return-Path: <kvm+bounces-61542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AFB6C222EA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D4AB54F032B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBCD384B84;
	Thu, 30 Oct 2025 20:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MD6FtfjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B435383366
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855034; cv=none; b=H668fQbUvnrIqxS5RCyvbzQgw4NWsr2NnOJIyPiztr15JRzutTJPk1GwtibcaY2G+aGxbBRI2Rq/opRr2dbF+vOF7aNs6WlflxZGL9VyY3pkjycROeW0Fwr71qgVewvrCH/YhKI4OQ3vUuiK7gSLuEm1KW0WO1LVeYf2qFgXKBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855034; c=relaxed/simple;
	bh=XFfT8gaTPEkUKYTdX1NH6w/tGb+C9eg2daMfkI8gFLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qnYgtcYDex/usYiqhmcbpDR/tOYP0zGiOTQF9n5AvXzIpmb7L40iqMQD15fCe4rU8gdHPzYUkzH+4wszF1s8OepZLC45Fh+JIObjcRYJk/e8EY9CyNSbtwddQSyQKmpDDuoYGS8UjtMKckvyX9vETMvGuQafVX9p8qC0lV9/vMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MD6FtfjT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3407734d9a2so522362a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855031; x=1762459831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=meKFn4T9FN95UHKOhoydSdUPWQIDJ02hjx7Eu38ytY8=;
        b=MD6FtfjTp9+yNMcS9CBvurnWUdRAFUDcW0CRCwNqk+MSPAXRR8H8yZYvNz/pLRMAfB
         DaI8SltrdDLg0FlhaN+//+KEPwvMDog6e2sjyPRt5GiAjGg6pKkjfaJEdEJJ5ajWJ9Ku
         yaDtrNkOncp1LDSkD6nOLyTBovbgX/SIqAEkdFQEwhSy8m//7E7QHUovbBfUhTbN6x41
         OJCkHi75yzC5NGofyi2WLqWSMawQ2YQ4594ucoMnkQPZBjcBLVHwY+AiEsg5RYrk36jE
         SGwPAIYPVN/+RxG5Jxjm0dyQ3GFQTEnWNr7Cx0jKI5K2DBhJ5kz0U3aaNqDGG0QePtCr
         Hdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855031; x=1762459831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=meKFn4T9FN95UHKOhoydSdUPWQIDJ02hjx7Eu38ytY8=;
        b=mVx8JoE0zSJ729i3JOvw2KBOBS4IasAAVEHic8snwmiWMcrHQw96kD5NgXbMKalea9
         /URPIqfogCokjWsd+WYS1TOk8FtdstQwYB/89TUJj9ab6nCVAbTsvcev3ze6WuWWLm0b
         QQVTmu3FzyGgEMl0RlZtF+PtF1keJLMXymgVOQ9qFBXR8YqBnbnaxEeVxmpRldN6OTqE
         cvAMXq6uZY2xeL7oFomogD/a7l2AUxcZhtW2eIqIgqogX0sPsjjR9p44OKsfxIDV23uU
         HvPntayCDmaIhzTN1nYAGHC9w/xUWUufqgR9nglRTeWM7c6mggUBDiUhnjWherpzueAp
         w0bA==
X-Forwarded-Encrypted: i=1; AJvYcCVlBsEWHxY3j1sU295KuYxa5rnfARbkwzIScCCRL3WLv7jIGuO0NBCqwuUkPY55zJle84g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIUlXnRwxXyImM1ac8g1C1rArMwSIV1E98l3V3hcYYlC/7jco7
	D538CCI7qQPq45WDk0luZnO3PpxtDovYxdyczHu8vhp+dPqw5K+XXUdkqc9CGBhFWRiXvs0NwLd
	UeYtN2Q==
X-Google-Smtp-Source: AGHT+IFHot6p8Ozw6sPTCEifBtpuZu56mTW8C+szZfak/MuPqOINRZqkxHegGZo0IYVURE2JpMgMqwrtO2U=
X-Received: from pjvl22.prod.google.com ([2002:a17:90a:dd96:b0:340:6aca:917f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d92:b0:340:5c38:3a56
 with SMTP id 98e67ed59e1d1-340830a3a7cmr1392650a91.37.1761855030672; Thu, 30
 Oct 2025 13:10:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:36 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-14-seanjc@google.com>
Subject: [PATCH v4 13/28] KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
isn't also triggered.  Isolating the check from the "is premap error"
if-statement will also allow adding a lockdep assertion that premap errors
are encountered if and only if slots_lock is held.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 658e0407eb21..db64a9e8c6a5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1725,8 +1725,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
-	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
+		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+			return -EIO;
+
 		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
-- 
2.51.1.930.gacf6e81ea2-goog


