Return-Path: <kvm+bounces-67518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71187D071A2
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 05:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1001E3026287
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 04:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711821C8FBA;
	Fri,  9 Jan 2026 04:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VL9nLZoY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EB92D12ED
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 04:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767932149; cv=none; b=ez/+PJ0wT1JwU7c5iE8FP5i9MUapiC8OLo4T2+wK8JKT1911nypiCukaJGEbmmjqmzvqLKUGgXisQyAizf/7mHmk5IRGuXRGmDxkNvjsvfKcXyfBRCuRbC+LaWt9+6gPD0kBX+kQOU7irBLSkSaxICGfAWIwyvMZh0/IBirNuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767932149; c=relaxed/simple;
	bh=kutvPVpGW1qMm04do3HzbiiZ2IvYSjCH0GrT8VkCSqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J3ttPInhATa8qIkK9lRG0T7nFY00YiW4n1VheYkPzTwdsZuYiYj7mGikKA69R4mHJHGX/0+BF1t7/CjrGfVRn0oU70NuDoG4xtHR/rvTC1K3yvSN5O4VteVHQUEzUKHUXcBEtPOtODao6/sS2EmKKxSb9Fn4RH6kDQU5yDmhkRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VL9nLZoY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c552bbd1b03so710869a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 20:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767932129; x=1768536929; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YPXOVSPbX1KMczdihtegDFRKVfMczfCw6F1GzpMT+wo=;
        b=VL9nLZoYee9PN0/ZHs6d3UZmHBK4QOrInGtmiGYW6KqEkdjYd/DHDA8s7SsG+3BPXv
         fbThJt3cVIn4TRBsuSFDCGjxteutNxLDHI7WOJd5aCHo5KYEGIDx/xjgWLOV0HghPjXW
         0IJi19O/3aEru69jXCYfiA+tG8OHXdmkYDQ0gsCKCaTFBNxQFrHT6yUI7rv7BBoAqqR+
         6OOYYfYJLAYJ1+f6liqAnw5bGJGQgj4Fo3OgoYfKb/cvsNqagS739lAclNYBPE0k5fUb
         TPLsUqcPN0AEDnU9WXMJoamIXvim2FQAzxEw2nnf+bb/oAC8RhBt9t+9LNKF1+WCFCTG
         +Pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767932129; x=1768536929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPXOVSPbX1KMczdihtegDFRKVfMczfCw6F1GzpMT+wo=;
        b=PHP7TCLpe5DcwLFkMRqN91KOm7p5cngIQfZPNQLQ19V2fK54fwYks5PB7kCNau9TPI
         g3IptCElyTHNR12KUi/IcxFNLBTVWXUMYR3mHFgFLVQbm+Ol3eKpwkHs8k1/2Qd7h84W
         0DLUEw/ailWLuBuYIA7yuwawMTAII9gXZM9YFrOhgT/6SaaZOxUQsWcnTCExBIUi40yc
         Hbz/30q+U3QAVazpIFR3lYZawGUX4gxQwNR75hjXYBSIoQYZWgqQQbAo1fuMChXa8j0S
         ReJCpV6zAZ/2CL8yTuvrnNLBuON5jVyzKXP8EUS9Rx6g1/Yl2Mbs+CR0YSdX4FJoy3Zt
         r5Vg==
X-Gm-Message-State: AOJu0YzQlSa0FW1nsnlEYH9iGCBCE1698qo+F05oPm+TMR0zo/tZMJAT
	4orgBwlOzsuymOHGo2uFIUbG8rFc72rh1FvyPoLpN6ygDNka1Quhb3PHranmPMzMQSs8SWFWZDN
	a+jMfKA==
X-Google-Smtp-Source: AGHT+IHnin/GN2aGtA/W6NbZpdY5OGBSyLo+1lHdwYvWWp/+UX/8sVL48S7ML4NamcEADhn3bWaWGCYtAnk=
X-Received: from pjsf4.prod.google.com ([2002:a17:90a:6544:b0:34c:e69b:d74f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9184:b0:371:d67d:e56a
 with SMTP id adf61e73a8af0-3898f9bde10mr8453753637.57.1767932129105; Thu, 08
 Jan 2026 20:15:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 20:15:21 -0800
In-Reply-To: <20260109041523.1027323-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109041523.1027323-3-seanjc@google.com>
Subject: [PATCH v3 2/4] KVM: VMX: Add a wrapper around ROL16() to get a vmcs12
 from a field encoding
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a wrapper macro, ENC_TO_VMCS12_IDX(), to get a vmcs12 index given a
field encoding in anticipation of add a macro to get from a vmcs12 index
back to the field encoding.  And because open coding ROL16(n, 6) everywhere
is gross.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/hyperv_evmcs.c | 2 +-
 arch/x86/kvm/vmx/hyperv_evmcs.h | 2 +-
 arch/x86/kvm/vmx/vmcs.h         | 1 +
 arch/x86/kvm/vmx/vmcs12.c       | 4 ++--
 arch/x86/kvm/vmx/vmcs12.h       | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.c b/arch/x86/kvm/vmx/hyperv_evmcs.c
index 904bfcd1519b..cc728c9a3de5 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.c
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.c
@@ -7,7 +7,7 @@
 #include "hyperv_evmcs.h"
 
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
-#define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
+#define EVMCS1_FIELD(number, name, clean_field)[ENC_TO_VMCS12_IDX(number)] = \
 		{EVMCS1_OFFSET(name), clean_field}
 
 const struct evmcs_field vmcs_field_to_evmcs_1[] = {
diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
index 6536290f4274..fc7c4e7bd1bf 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.h
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
@@ -130,7 +130,7 @@ static __always_inline int evmcs_field_offset(unsigned long field,
 					      u16 *clean_field)
 {
 	const struct evmcs_field *evmcs_field;
-	unsigned int index = ROL16(field, 6);
+	unsigned int index = ENC_TO_VMCS12_IDX(field);
 
 	if (unlikely(index >= nr_evmcs_1_fields))
 		return -ENOENT;
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..9aa204c87661 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -12,6 +12,7 @@
 #include "capabilities.h"
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
+#define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
 
 struct vmcs_hdr {
 	u32 revision_id:31;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..c2ac9e1a50b3 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -4,10 +4,10 @@
 #include "vmcs12.h"
 
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
-#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
+#define FIELD(number, name)	[ENC_TO_VMCS12_IDX(number)] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)						\
 	FIELD(number, name),						\
-	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
+	[ENC_TO_VMCS12_IDX(number##_HIGH)] = VMCS12_OFFSET(name) + sizeof(u32)
 
 const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..7a5fdd9b27ba 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -385,7 +385,7 @@ static inline short get_vmcs12_field_offset(unsigned long field)
 	if (field >> 15)
 		return -ENOENT;
 
-	index = ROL16(field, 6);
+	index = ENC_TO_VMCS12_IDX(field);
 	if (index >= nr_vmcs12_fields)
 		return -ENOENT;
 
-- 
2.52.0.457.g6b5491de43-goog


