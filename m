Return-Path: <kvm+bounces-64190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9CBC7B3DF
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:12:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 352D34EEF74
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D152F0C74;
	Fri, 21 Nov 2025 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fnL1TMf4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA6C223DD6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748555; cv=none; b=odEVS3DHUvmT/uCQoTg2ewRjTUkQkK4g3dEz6861XBQhhA09moLOSWbg/OSBzb05nzbXkTbmU3RtrjHPikEt4ty1xLyL3td91M0kDkEpBMXLfZDPVojIjVf4tUX8HdADgmFtwyGAntq9SxXrrdELZNH3A014t5dQBkTCZ/N7upk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748555; c=relaxed/simple;
	bh=G+gi+fEZZQeXHxtEIRq+atDeCesCCCisZ13llVhfMLs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bHoXGZi/aEYRUIxYGjOfv+l8q+HIYQiYprPXUA7DK6zb6zSxho7A156KpAck6n7ACv6w3pzJRWmP/Z1CPoTSvtUr+g44W4bDU/ap+F1uzujj66Jt3n99GTPQVtMpDhNOq3cz/sdVlOGxb8UFV6YlGhekL0oPe4jdoS3gTC/k8Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fnL1TMf4; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so5741278a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748553; x=1764353353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i5SVD+dWBU1kQgJRl6C3p5453CgyaUw/X7daFWn/Czs=;
        b=fnL1TMf4wvanbgw1RhCwvylnTRHGmPWack5ztslGZnUExdno4pjhn49EQiDZV/X5DG
         sLTNwPrspR/QKtq+FMobnOtiMuWcsZhNTKnkDnOTqWxTlQ87jmbGci5DiFOainSpY343
         yuF73zSGofQswLzJKpJvtb79wr0Ltjo/x34Sb9yh4f9YQm1FxnWIFai7R/UAh+N0Pv0x
         TAJnId+s31kpzHtqsoed/E4U/ElvJhRGd5EcV0aVH+n//Aw4MWrMx2MvKZ+9+Bd5xqeZ
         sgxH3EbGrPu/SymGtwNDz8X4tui2Rnw8DkvTld55jrRi8qZi/gkVcsuMGuuaQ3Va/89m
         bXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748553; x=1764353353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5SVD+dWBU1kQgJRl6C3p5453CgyaUw/X7daFWn/Czs=;
        b=uJAKRD13v2YHWwUCFpkexhziJ8oTR5D/R4aBxFhcv/2NAR4Wya8aZRg9ljpAZrtv+p
         gu/nF3DxtGCZJRyAvfh7Mn2vpbNgu5GfvMFljMqBEH6dHyXbP9t05UrNxZvrXcM6Bn10
         FrVSHZmQ1MMgaNxwCmoDBFKl16KiIopUAW5QuKZJW1h/d0uU7KPb0Sw7jyuZADys9z/H
         A2N6WGbui8Zwl9fKVt13b+Vy5LQ/6afm0kUlk2cSoLRhvsntveMItw8Djz5S30QwBWRg
         MoGyqQ84tPqD70FTY/4cOXWesesJfcMtVTX/Tdb5qYZNPFS558xxmrnQhmqb02jgypeO
         gFYw==
X-Gm-Message-State: AOJu0YzK2h43OYk+s3g+go2kFdaQCV+hMX9prABYsVE5OTFi3MiYPkah
	WVMbx1oPX3UKeLZYhJZjP0w6y4Agidiu6MG2LlfdT/UYMDNYdMpOe81ShiAXpxhJgv2wZQmF/Dt
	RPAzbrg==
X-Google-Smtp-Source: AGHT+IHtQNmnx6y2gMn1+a3hREyPeGDsSuIruvneqaa14gwwpgsGQr/sBS3tj3eE0/yvgpsOoWiTjywK6Uc=
X-Received: from pjbnl12.prod.google.com ([2002:a17:90b:384c:b0:342:b238:e0a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0d:b0:340:2a3a:71b7
 with SMTP id 98e67ed59e1d1-34733e4c840mr3636874a91.12.1763748552958; Fri, 21
 Nov 2025 10:09:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:08:52 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 02/11] x86: xsave: Drop unnecessary and
 confusing uint64_t overrides
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the uint64_t #defines from the XSAVE test, as they are unnecessary
(typedef'd by stdint-uintn.h) and confusing (the test is 64-bit only).

Opportunistically use "u64" throughout the test, for brevity and for
consistency (tracking xcr0 as two different types is bizarre).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index f18d66a1..fc18a4b0 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -2,12 +2,6 @@
 #include "desc.h"
 #include "processor.h"
 
-#ifdef __x86_64__
-#define uint64_t unsigned long
-#else
-#define uint64_t unsigned long long
-#endif
-
 #define XCR_XFEATURE_ENABLED_MASK	0x00000000
 #define XCR_XFEATURE_ILLEGAL_MASK	0x00000010
 
@@ -17,10 +11,8 @@
 
 static void test_xsave(void)
 {
+	u64 supported_xcr0, xcr0, test_bits;
 	unsigned long cr4;
-	uint64_t supported_xcr0;
-	uint64_t test_bits;
-	u64 xcr0;
 
 	printf("Legal instruction testing:\n");
 
-- 
2.52.0.rc2.455.g230fcf2819-goog


