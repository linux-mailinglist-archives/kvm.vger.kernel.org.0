Return-Path: <kvm+bounces-58200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A04B8B5D3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBA221C82053
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F124C2D480D;
	Fri, 19 Sep 2025 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j4Rj4Kjd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44E22D2485
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758317892; cv=none; b=e/69iDALUY590Jzo8gl+xAoy2qeOCnfC+tHhHWMkgffMI1BE1nN6WUTM/TEOQIp6bumEt+mBES/2IDBX2+ruzMBa+twy1bU2vcJHOmMS7Ph6G2Hvxo7jvD0uxh8eWBtk0eStCA3n0fBMNMAcwnS59E53RJ+Z/n6ytoOjNHBnfJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758317892; c=relaxed/simple;
	bh=NyO3OCkrgrNJyiVrALtIf7HEXPoVs1ZzdtlJEqQJGZ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K0BERNpWucfEM+jirr8SWBiRNL+kC3DbvG6Yoi7vLx6a/IYM6qha+u128173mvxXx1ZsTD+UB0kHTkINZKAfpP9m57OXKiK0bQAMj35SOxxMs9/jeRToGqRfNL4RXHyEP3nepdvXTxP2QUNbp+KQCY6WD3RxTy5W1q9vbwa3iTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j4Rj4Kjd; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4f87c691a7so3829654a12.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758317890; x=1758922690; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LCcXeK8XcV62V6MRvysCvORWa4slmpddR0tHqtIttxk=;
        b=j4Rj4KjdCtPh4mF90j3mihDCv9dv5E+2AMeMqq4CcamqlG1dvI57ZS10RX5cuKIsLe
         ru64ijJWu8h7RK5cWwhMzWIpPkRZDRtOk+ZksdYmtaqaBvf0vbdw3XTuNKVLs+IRQtzL
         lmzygd0fwV8QyoGqyJ8tQw0KxyA94v/5HG5rK8oibgq4hdNR9yWODTseAHKAGMSQNMBX
         fnu02qwDDt4nNoB9bqM4B/367luBLJggh48ofeNxK41ovCBQ6DHxi1NUiiOlSS4SIKE2
         +BTEfGblzKuAfWkFjgAzficWPjnW8zNxRgGI3rczpkVMVQIpss8ipLe3sXHSc4FXGQFm
         tGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758317890; x=1758922690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCcXeK8XcV62V6MRvysCvORWa4slmpddR0tHqtIttxk=;
        b=UJU0QvOXW7mV4PvWtrI+tzcY30HzDGboMFvQ2v4gMia5ZnOBvErBSu/Qpay2XCia9M
         bNgtgg71fhJoNmA4Fc3eLI9RGv3PT5p6CUbz2Ua8Rsdk+FAfAdlZvNemtmdbiWLzuRmn
         JVwsSvrekyr6PR0z4w+PPEuuiV2wg9uelC0JlX9F0x6xGnu/GwCwzPeOIrJXk1JfLEKO
         k0HdxHHyGrJv8Fs+4AzYZKTbAYgbU8X1fz+wZibK1TLpBrsiA0cwZmrhrKI6BNOrbh/h
         I1pr4DeY0X+EHsibfB/RynWnODvZPo76mHFF5wJPTFdFGggNJiZNzlL53zHP3D7+Gk9B
         AbSg==
X-Gm-Message-State: AOJu0Yw5Cg/7VXWYs6LtvcfcB9YVFdNgNU6GJxQJnBKUaHUmY8EroCD3
	I7oh4VuLAUToXqW2sXH+NCUquOlQE0NsXbSVCHyCMDTQvWIhYMMM8f+s52LtxNUCd3FCQvNSpJ3
	IMCshEA==
X-Google-Smtp-Source: AGHT+IEmokOFSO/BZLJz9nefMHMY4QoIe0UUWs2Gq+mwIsFKXPU+hnaQYX4XneyvMPqRBMvMZrWMSQMtboI=
X-Received: from pjbnd17.prod.google.com ([2002:a17:90b:4cd1:b0:32e:b34b:92eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:939f:b0:263:bee9:1ac8
 with SMTP id adf61e73a8af0-2927031a2d5mr7191684637.28.1758317889963; Fri, 19
 Sep 2025 14:38:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:38:05 -0700
In-Reply-To: <20250919213806.1582673-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919213806.1582673-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919213806.1582673-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: x86: Add helper to retrieve current value of user
 return MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

In the user return MSR support, the cached value is always the hardware
value of the specific MSR. Therefore, add a helper to retrieve the
cached value, which can replace the need for RDMSR, for example, to
allow SEV-ES guests to restore the correct host hardware value without
using RDMSR.

Cc: stable@vger.kernel.org
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: drop "cache" from the name, make it a one-liner, tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17772513b9cc..14236006266b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2376,6 +2376,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
+u64 kvm_get_user_return_msr(unsigned int slot);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e07936efacd4..801bf6172a21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -675,6 +675,12 @@ void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
 }
 EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
 
+u64 kvm_get_user_return_msr(unsigned int slot)
+{
+	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
+}
+EXPORT_SYMBOL_GPL(kvm_get_user_return_msr);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-- 
2.51.0.470.ga7dc726c21-goog


