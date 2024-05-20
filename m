Return-Path: <kvm+bounces-17784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6308CA1AD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A540B20C07
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAD013A3E2;
	Mon, 20 May 2024 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bbor/lnc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD88E139D1E
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227985; cv=none; b=Zex58sLsnfKjfNaK7blwjTqo8E2q+mBQASvTYT/rNuBtduXf58FBLBnlnlMDBaDfEoHxXpED5f6GF+iy6pqOOz+wf+GVIcnbXbLmMv2k1iB4ovZCdnGzBTDjmbCz0+kPX4VbK4glybzf77F2farBps0FG8gAJrCMFwrP73jFtJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227985; c=relaxed/simple;
	bh=dsZ1olxHZCy7ap644zr9osINKrBnICsQj5AlNr8M9aM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lX4lLMyT5rpKQSZh8vvD5mxhwkRwbyV1j0wGlEqxDSgAHPDo4Zy+aWJwmpGl0gozN7EJo+s2E5N8dvqi2EG2Y2sMUcoVHt+2N1ugAHN+4iAQmTj8oVaxiQFAQgSDNfkIACzaavgIQqY9BdE8aBjLgmzugknBVxZORjeRPMmdlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bbor/lnc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ec43465046so111684675ad.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227983; x=1716832783; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S6SoCzctMcZvdOZSBacyLMY6ZoTmd9JVgesH+2DtUcQ=;
        b=Bbor/lncE6XBvsPTxgS70FkQQ4fdi88URhW3gyugSGSGJxMqXWRrPA/4zlcKZYdunq
         o3zoXX5UoOvGemaXaEgUW0I7OrfTftjsz3U/DBj+elPVISMzjedGbnDgNmY4Jtf9KsdO
         GuuNzXrzifybM/g3j83aRFlCar3Wtx6V7Xowc9SNjszIBhjIwfY3TtAKh9d4plfmbwXU
         eVB87kYxzJBC7YzifJzDwpL0O2dn/pjUrrgq8spQN5GCOKE9TVKYSvAW3e0wCa1LaDMp
         hRZNLdiIKlRqiKLcXTWnk+BfW4nVrOQkb/QC8nNhTg50fkpgZ15w2TmhkBgoKygCTd97
         bctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227983; x=1716832783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6SoCzctMcZvdOZSBacyLMY6ZoTmd9JVgesH+2DtUcQ=;
        b=eK9zZduRotH09tqhwEYkCPwvd22qFjhr20cUHPU3TQ3Jbpu0+FQhn7FCUvwLcHFNt+
         acwi5pmER+AtTHhjaKcgBI+0B8jwg80AsOOC61pTbJmDtSuOWQjsm0dr2IbIY/gbqUof
         5fqW94bdEWWSd7zInNtzFPE1QCN7FdYcjufKQsZaqI9R0kYMIoUljL5JWPhSV+AcXPwM
         KAn82omZPHwTZeHIBIEh/SSyIDpodWa6ERXf8wqmG0bTMkHJla9GdfQTlNAz2HRbiogm
         V+/UUlKxdytx1la6YgUMWxurFG5DcDTWbnTN3hIAQhJvlG77jpZA9vfJJzETAabGm4Ld
         mJ/A==
X-Gm-Message-State: AOJu0Ywng+8to/8y8YdXgMXYWXNUVPqELlYZoXdAdWoeV3bVoUNQ/5Wn
	Le5RkcNcxuFr4lKFEb+IKJPDuMzkQel1+QuNnmvGCjfKgXbQXNeiUzxIdauYRnBVujLheGkj3g1
	BVQ==
X-Google-Smtp-Source: AGHT+IG0LE/6NkmK/TdX7LvNFR6v7PV6lDZkJWCv15sXQzJat7UuYdGSe1szAoXch8lPObvRkDrXKS2jvko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1c9:b0:1f2:ffde:c739 with SMTP id
 d9443c01a7336-1f2ffdecb0cmr97825ad.2.1716227982868; Mon, 20 May 2024 10:59:42
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:21 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-7-seanjc@google.com>
Subject: [PATCH v7 06/10] KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use macros in vmx_restore_vmx_basic() instead of open coding everything
using BIT_ULL() and GENMASK_ULL().  Opportunistically split feature bits
and reserved bits into separate variables, and add a comment explaining
the subset logic (it's not immediately obvious that the set of feature
bits is NOT the set of _supported_ feature bits).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog, drop #defines]
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 804e9240889a..fbfd3c5cb541 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1250,21 +1250,32 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
 
 static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
 {
-	const u64 feature_and_reserved =
-		/* feature (except bit 48; see below) */
-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
-		/* reserved */
-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
+	const u64 feature_bits = VMX_BASIC_DUAL_MONITOR_TREATMENT |
+				 VMX_BASIC_INOUT |
+				 VMX_BASIC_TRUE_CTLS;
+
+	const u64 reserved_bits = GENMASK_ULL(63, 56) |
+				  GENMASK_ULL(47, 45) |
+				  BIT_ULL(31);
+
 	u64 vmx_basic = vmcs_config.nested.basic;
 
-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
+	BUILD_BUG_ON(feature_bits & reserved_bits);
+
+	/*
+	 * Except for 32BIT_PHYS_ADDR_ONLY, which is an anti-feature bit (has
+	 * inverted polarity), the incoming value must not set feature bits or
+	 * reserved bits that aren't allowed/supported by KVM.  Fields, i.e.
+	 * multi-bit values, are explicitly checked below.
+	 */
+	if (!is_bitwise_subset(vmx_basic, data, feature_bits | reserved_bits))
 		return -EINVAL;
 
 	/*
 	 * KVM does not emulate a version of VMX that constrains physical
 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
 	 */
-	if (data & BIT_ULL(48))
+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EINVAL;
 
 	if (vmx_basic_vmcs_revision_id(vmx_basic) !=
-- 
2.45.0.215.g3402c0e53f-goog


