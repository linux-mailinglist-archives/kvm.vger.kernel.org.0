Return-Path: <kvm+bounces-17665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5698C8B63
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A68E8B24001
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C00D142E92;
	Fri, 17 May 2024 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yByUNarD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF4F14290C
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967610; cv=none; b=Vb1/gANFd6KuVbNFG0JVFiWN+l2AgUaTzSljs67U1CCHP3ENWU4uDCZ67mX6nOlot9+srCKiNrAsRboYh9lhTSPXcCC6PYTAojcr20RfYOEpw+/i1jL8YJ/99mJgJRKYZoaEfX0IW6ikp/69uZDB/2dpzgHfvEBgorCwksaD5Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967610; c=relaxed/simple;
	bh=TVKVVi0oIpGa13TzRgGYboUCGoW+63IrN5ddQ5TrpyM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D7Ch6i3fNnId6B5XBJTkwUyK6DRapD/YIcBNirNt+r84fqDGSbYZafIk5zkh1SiV34jl0oY20a18XsaTMybTWEyERQBwpEoXt0Aaq2BNyR0AY4+eYW2hnTY9W57GkeOPBOAS3RM3DN6eTX4b8p0ekTadcLAulUuirlfzHOLZX6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yByUNarD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ba1dd99b05so2122073a91.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967608; x=1716572408; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AZXlcs6m+xDR6nZIttE3zXhan9k7Tdu7nptno26X7+k=;
        b=yByUNarDPdNKa8DN44EyTanH/T5pIALgKsakDDUbV7SkpOVEANhizu5ny0TOmrLwkH
         YGejx602ykp/Wo7HAcG8nb+LgOZ1qyjJEdop3HDVt+aHhGZsuwM2dW2DXAu6PfEbciZ6
         d4Z94IAhKXDwdZ0VkAeudLzRmZ+jx9cza+Kw1hRF4gMp16lwhB5XsGE30obI55zXEy/c
         ojcCB5CZIMeuIIar+OFkxpPU4doe1cM08FQCj/ueN6rMiQQgBa8qWkHlGURO2rAe9iU+
         Y8rHKLOpNxQdNue826FHPD9tP/752VnL+t24mE+5zAN/TnYksLaFLtiazSI5n5vJlmjQ
         cXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967608; x=1716572408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZXlcs6m+xDR6nZIttE3zXhan9k7Tdu7nptno26X7+k=;
        b=qCS1+jfUXwoDazA6FhnNKhimm1OOPovslVID2+issAf0scIZKFolrykRExsTLajZrD
         6uwpZkGsk7eiDO4EfMk1l9WRMoK/W1BdHiudJTA9BNLds9IPXePVi2TzX9Lwuy9Syz+T
         c36KNFVNdUiXe2ozMqKkXMEd1H1V78lvpLalaK5m0n4uOCF78QQ6lG0UszoLRPSVGZHW
         7D7qnqeaG25gkaT4vkp1wcKaik2RYXOE0icDhYBUWOEdLhw65jHzVaETdIhsUdllaTrl
         NmhhLPgT60Whm2X+EqJLUgdON7v5kpIm+KmQjKV9yGLMLHY0+ive3BwCYzrSoJpuEfJN
         ofrA==
X-Gm-Message-State: AOJu0YwkiznKDNWbxbJwdEE4tgrZ2xvLxTyxTdvlpziSS0Vcuyy+N4pp
	C52QrFKE25oKQaKeoZR3QrGuiSaYepumU8Paq+RcjEDUCHvTgHZXSiKki4tzkOZSfJKJxhjVGYz
	iuw==
X-Google-Smtp-Source: AGHT+IEzO4PqG3xwlXRScQcw9DHhF4lica0c9USq/yQJd3oRJJCaWc1Gu1zAj1WCzLyOT0Ep7CjzX6xWz7Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fd08:b0:2b6:2069:ba20 with SMTP id
 98e67ed59e1d1-2b6cd1f0549mr58876a91.8.1715967608522; Fri, 17 May 2024
 10:40:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:50 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-14-seanjc@google.com>
Subject: [PATCH v2 13/49] KVM: selftests: Fix a bad TEST_REQUIRE() in x86's
 KVM PV test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Actually check for KVM support for disabling HLT-exiting instead of
effectively checking that KVM_CAP_X86_DISABLE_EXITS is #defined to a
non-zero value, and convert the TEST_REQUIRE() to a simple return so
that only the sub-test is skipped if HLT-exiting is mandatory.

The goof has likely gone unnoticed because all x86 CPUs support disabling
HLT-exiting, only systems with the opt-in mitigate_smt_rsb KVM module
param disallow HLT-exiting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 78878b3a2725..2aee93108a54 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -140,10 +140,11 @@ static void test_pv_unhalt(void)
 	struct kvm_cpuid_entry2 *ent;
 	u32 kvm_sig_old;
 
+	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
+		return;
+
 	pr_info("testing KVM_FEATURE_PV_UNHALT\n");
 
-	TEST_REQUIRE(KVM_CAP_X86_DISABLE_EXITS);
-
 	/* KVM_PV_UNHALT test */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
-- 
2.45.0.215.g3402c0e53f-goog


