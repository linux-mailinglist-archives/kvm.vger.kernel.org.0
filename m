Return-Path: <kvm+bounces-32596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E31889DAE77
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93C6416702A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073EA2036ED;
	Wed, 27 Nov 2024 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNn14hiI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D328C2036E7
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738806; cv=none; b=Oy4BpkuO4UqS7VNjvHaLAfVC7UFJMlIdy6e5Y9RKkmtNKnrd/emIoRBJsrLx5iZbJx4Sk1D6CyN1JYMjyxG4a/7v//Z3/Vkgj9gYddDutnTGymnF4660DE0K8H9zL/uv09cKpkBfb3QPw054KkmpyveP9qSDzGm2tNRYqrl0oyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738806; c=relaxed/simple;
	bh=a6Y640EiqlGM+gu5ctvPf0mXrN55ztAszHO3hlhnOcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pHoXNJn0VFCpS2yHQHJT/H3vdY+fqmfM8vZqt7aRfeCUzX3iBp4hb0YIN9DdEdZ4/IXlN14Sz1Mcb9182uNsMa23PtF7U/tDaeEYbjLtdhIRaaET3nGcdo6KGtI5kfEIb8tHmZSLpFkdhW24/TOReEh1hPMZkBYV3FCh1DJGUag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jNn14hiI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21267df35a5so803055ad.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738804; x=1733343604; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j7YT08yMb1KEjpOIy5QpMxABflHuEvjlRxoqxNPECDo=;
        b=jNn14hiIjnnPuGZjmoAcuvL3SPJJK6YKi57VVspLraijRMy+3Y5z4+7Sg7kSH8N29C
         N792/g5tOs3Re8nXZaX1RCUQjA8cIXLesUYl51+MQ3J61TIFKfxzBhG6rXLKXxSu2EdG
         aSHsZ7ovEW3CIi1UIRe7c/ml5z3szoJGoauyvB0QufaCRXgoKSCHssscQ649srYqy0oE
         w0on/SeGPecOaBMNXtOtAYq/+qDwR1n1UGL93gLfOdjviWeTJQ/8SkezrGf/SF6jlXxr
         6R1xSfpgdnvzCdAXouEf6U6SrP7aXmlsHsEhEmxAlHrykrdvf044jZqKTsUvMozePKVp
         EvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738804; x=1733343604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7YT08yMb1KEjpOIy5QpMxABflHuEvjlRxoqxNPECDo=;
        b=YmfFC3z5c3IyzMZZ6X6Z/t04m4IYq95otwgJqDI5M0wgZIQE0tyMQGXq+ee/3QCT6g
         goMPg2lzEorJ96hWD068Ob9YUap2Y8ZcqgIAkbwjT+6lhA9lUCWIZmUYzRb3D3SbaScp
         EFRRfnS8PnMiqBtKfzaEXMTBrxK/R60rYZT8Te0p5x+OwKVQUqP/ieI+/f/HdDHYKb4J
         Ob1oU16kwTNGyCMP+ogscrRSBJ0xxV81lJWycZv6bTedN522x+e2mEwq58FFx8YRMxLw
         KLPvNm5cz1bmq5jVXVJWFz+WI8O8gSNyhx1tBBA7LLkI6c6Dm/ZR2GmWPx/wxCqeMZWn
         6IEA==
X-Gm-Message-State: AOJu0YzeBrc/0Z75L2JmEUbePjY/3XxC728yLWs2BGEcy8h7fJcVWrjg
	k2yN6DYw13yd4PhvlUAssfQuNzJOVWxq8fofKuyN8G5cRSG3HWF7wv+gVbboCfZ2Aj+SfzigaB2
	3Dn1DSqqCezH+PYpxEUOS0SckhCfFYAY5WDeONcmxwdn4f/czKBePayKOTFWTMnhl5VOiA4DuRb
	UNKzghqoODTFdC2L2vL0lOtD4WUC7lffEZCRpovstSl9Z1I8Qdlw==
X-Google-Smtp-Source: AGHT+IFk53l85DXU/wNl2IRSe84ryY6aNfayfG+8hfq9Pk37i2y2PizUu7aOAE+ZyVNMUyFa+mA63HRfuhYKlqJe
X-Received: from pfbct13.prod.google.com ([2002:a05:6a00:f8d:b0:725:22dd:a775])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d50e:b0:212:20c2:5fcd with SMTP id d9443c01a7336-21501385212mr46107605ad.26.1732738804123;
 Wed, 27 Nov 2024 12:20:04 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:24 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-11-aaronlewis@google.com>
Subject: [PATCH 10/15] KVM: SVM: Don't "NULL terminate" the list of possible
 passthrough MSRs
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3813258497e49..4e30efe90c541 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -81,7 +81,7 @@ static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
 #define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
 
-static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
+static const u32 direct_access_msrs[] = {
 	MSR_STAR,
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_EIP,
@@ -139,7 +139,6 @@ static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
 	X2APIC_MSR(APIC_TMICT),
 	X2APIC_MSR(APIC_TMCCT),
 	X2APIC_MSR(APIC_TDCR),
-	MSR_INVALID,
 };
 
 /*
@@ -760,7 +759,7 @@ static int direct_access_msr_slot(u32 msr)
 {
 	u32 i;
 
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		if (direct_access_msrs[i] == msr)
 			return i;
 	}
@@ -934,7 +933,7 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (!x2avic_enabled)
 		return;
 
-	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		int index = direct_access_msrs[i];
 
 		if ((index < APIC_BASE_MSR) ||
@@ -965,7 +964,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	 * refreshed since KVM is going to intercept them regardless of what
 	 * userspace wants.
 	 */
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		u32 msr = direct_access_msrs[i];
 
 		if (!test_bit(i, svm->shadow_msr_intercept.read))
@@ -1009,7 +1008,7 @@ static void init_msrpm_offsets(void)
 
 	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
 
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
+	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
 		u32 offset;
 
 		offset = svm_msrpm_offset(direct_access_msrs[i]);
-- 
2.47.0.338.g60cca15819-goog


