Return-Path: <kvm+bounces-22985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7889452CC
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39315282BAD
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817F114C5A4;
	Thu,  1 Aug 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yg+DOyGW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3CF14B94B
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537307; cv=none; b=h9YFcZsSKSzol0suFTWaw6rN83moOBm3riW6TmKFs0OMuFjn/j8svHAXa9bF+9cPTkAUhtuZtWMyW+iwARa/7nC4eIV0h5+IaS+JQNfE6l20/827N7oSEbdheaTuWmeTw8ep5sPuIYCcHar7NW8DZfBSVlLfSVEpNYaBeKFAxDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537307; c=relaxed/simple;
	bh=+209Dl5mjZfEzPCjJbS6cYtHb+T8VqI2r8B2gBeStTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrWSaFA/OKBeObYVYXbTmR8QFj6twgSfqT0cVgzVPyIc4Zud2X7FUyozZqrhlJUbpGuaDIUj3vBhk3O34VLvHkNYGEPaFE/AfP6ALfqFGeDkV8oreKOjKrvn/QFnuLEKkaqOxiF+bSxw94Gtm68bsyERcPDbWwcLOaS73ODf2sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yg+DOyGW; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-78e323b3752so4784002a12.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537306; x=1723142106; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nLllgIeEL1wMurU3ykZwAR8levnh4hSK0+7xKRqL5Is=;
        b=yg+DOyGW4l4CuPriZwCOwA1CXdeCsL5OHnUHQq4LbhxF81Vjc7HCcYYkvOKz+kvbt2
         ABmdS3dqKolKdl9fGuiZ5n/vTP18iMb3WEWlr6jbjMMEMihkBvMPkV1IZNyV0Yk/3qVm
         DWCXtK1YziHMIcnvFP8g0EgdfDL7jz1GbnNll3EAmTMcACLhmnvSKXZXZmKUHsJqamLZ
         SfFCqFkhiiyFAFAzLAUYQpwBZnC7l3+k0w3LyYltZTlRehAPBMffsQykie7Nr7azDIG/
         WgyN2cMvPQS9V/cV5jhzxCrjtRZ5VvxbD252RIKZDWlqjhMP5pBnPWD8CiipV6q61JMu
         K5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537306; x=1723142106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nLllgIeEL1wMurU3ykZwAR8levnh4hSK0+7xKRqL5Is=;
        b=Khh17TE2ZzglrP3xTRSJ/BFWX2zPOYX5STh5+cKQ2pjTm5KSwSVsY4jTMQawE4IJEt
         BtIgs685DJ9vads7cLZOcb1Ee+XGXteYuOSoN1gxnQICOyBlSC+/wtJVlg1GjKgNsOnV
         DWwrd5Tn0/1jUzU+in5O8yXjakidCz0aQgOqHi4WGqY669cWguJbvU+VR6JFVE93bJxy
         a2f0STtfsWPi1oYIGa+Ezzh5Su2qtcEXM9ERGgfG+RigD7Yx0WO2igeaBmeRZD4NcM3z
         Z/hElpofg/NVos8ac2rCu0xK080AtWpRGIS3beqx2YJvCDt/BHKICPWfWsLJ5dKKVSmg
         M91A==
X-Gm-Message-State: AOJu0YxCxRonm37mbRXTQZMlXMusk3rfOtM+2HK5dkMTVjscgdT1OSli
	n0fJf5Hy824eB+nJ7CDXREGEZXX41DzTUVhyoKb+SPZfvEPcVvQ/Rqec78Ykd74FbgiuLR3bxlN
	2tw==
X-Google-Smtp-Source: AGHT+IGJTez0OFwM+Kmo7Ln7XZmkdAZ4Q1iTleNtDtm577nIAAAdrxOHonp4x5mucOt9Mkl1xYEJT8P1AFM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3f41:0:b0:7a1:2fb5:3ff7 with SMTP id
 41be03b00d2f7-7b7438b1dc8mr1940a12.0.1722537305573; Thu, 01 Aug 2024 11:35:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:49 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-6-seanjc@google.com>
Subject: [RFC PATCH 5/9] KVM: x86/mmu: Free up A/D bits in FROZEN_SPTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Remove all flavors of A/D bits from FROZEN_SPTE so that KVM can keep A/D
bits set in SPTEs that are frozen, without getting false positives.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ba7ff1dfbeb2..d403ecdfcb8e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -216,15 +216,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  * should not modify the SPTE.
  *
  * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
- * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
- * vulnerability.
+ * both AMD and Intel CPUs, doesn't set any A/D bits, and doesn't set PFN bits,
+ * i.e. doesn't create a L1TF vulnerability.
  *
  * Only used by the TDP MMU.
  */
-#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
+#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x498ULL)
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
+static_assert(!(FROZEN_SPTE & (PT_ACCESSED_MASK | VMX_EPT_ACCESS_BIT)));
+static_assert(!(FROZEN_SPTE & (PT_DIRTY_MASK | VMX_EPT_DIRTY_BIT)));
 
 static inline bool is_frozen_spte(u64 spte)
 {
-- 
2.46.0.rc1.232.g9752f9e123-goog


