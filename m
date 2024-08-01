Return-Path: <kvm+bounces-22982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2ACF9452C6
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1052D1C20942
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8292A14A602;
	Thu,  1 Aug 2024 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tvaSzOsE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFDF1494DD
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537302; cv=none; b=OFAdOUQFWCAXUOPMGI7Q0oHFnrixtVGsl0ifaI13V/PZZTar1174/bCIao2AlYAgO7T+vbxEme21SQslzLSRhUYgZTeafZV2jOAxywDprpEztnHk1pZ0Gk0te1AA9lmcEbCsUyJn2ksGw0y/eiRxnQ0Xw15o83gx7K7+ENWhM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537302; c=relaxed/simple;
	bh=sQ3534Fng9t06Zq2te+F41BHRISWvOlzZzrXklcUmXg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=il5ZAnggOIVgO2lSLMAPNJzXECmKyy6SSqR5HGwkMwMR3xHFY7/6JLvkaiNNazNKvx4TIHGj6tsCwVyhnt+Nvo92mU5Kv+okB4QYUwTWfagQgWiXu6VuenzpDt32+bnoAEIttWCmROzrmwcejjthFzBF1De5TTQIZIzhEErtXIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tvaSzOsE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fd8a1a75e7so59656485ad.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537300; x=1723142100; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ilp3BRqf5qrS1kR3cVkw+ddXUmTszI9WBxmraRZDLeQ=;
        b=tvaSzOsEsshFYilc3fDBpqCUBHqDrRvBz6odHOx50TtaGq/Za95Wbv5wL4QIyiQtOX
         iG7AKKyG3M1VhD/2Sa/xeqa2y+V3h6B/mnxuWOuyaRBcNO3Y1k3bE8BAYEg4KoQtnxL8
         PMzlp/v0XkprRy3667xUllopOZlvAm4TFjEHxFINhUqu1kVA5ZGeaRv6pGF/SbcBEwXR
         aeld0XGNIYow9oTDQHsh2RO7G4Cw9TfGgjPIDhotcPQRb9h9UIJ4qRpqBNK2gbZJeqCI
         AVuMZ27rkbD+oNNf1BYWJUbm38weJaCF+P3S+S0ewYlY5t+VZlgoyGva6L1Fwi1DXVS/
         IJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537300; x=1723142100;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ilp3BRqf5qrS1kR3cVkw+ddXUmTszI9WBxmraRZDLeQ=;
        b=WC9W6X/fbwJpb7Y0AjTRtuKMVbCv1ESobcI1NwvN7t811SoqgGajO/dDL2M22ghC2N
         k2H7Mw03ixE8wa9xSChmDg42dPhfAIS5ITaFRNSD1zu5nIs53qqzzUMao2nnM431OF1k
         oDjrnbYONfiDuJt/9/AzauQ+sJEg9iUVhOtREqrX+mBYBXAnaFFffrjRBLZaFeFBLvA5
         saTHwDk8zjlOdb8dbZoganDj+v18DHJy+walnoTRnsnFcJzN49GcWdy3mLKgESKfKnjN
         rM+pZd7sttSpzoVmFrzKPqGG5Y/tzrtcFhri1rxxxOcv++hAiFVlFMlybNAfYEiMe38w
         T5tQ==
X-Gm-Message-State: AOJu0YysqtfAF9PuEuyyvzsASa+vm3TC1Kgy/tYX0Sphc8UlP/ZRA6Mr
	N8qQ6ZbeeaPXFthZgLAUeFR3/UKZ3MDMcw0flhuJ8lUhFZ58Aj9Xt9sRj5x8HwL9Z9newbLHEVG
	Wmg==
X-Google-Smtp-Source: AGHT+IFVeWW3z3HLbr3aiIANRVn0Pzn9JWDp1pBfkw1NJGvfolLz0JIjag5F+BCKoOgA8ow9J6dxgy2bag4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d2:b0:1fc:6faf:671f with SMTP id
 d9443c01a7336-1ff57262fc9mr25895ad.6.1722537300275; Thu, 01 Aug 2024 11:35:00
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:46 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-3-seanjc@google.com>
Subject: [RFC PATCH 2/9] KVM: x86/mmu: Set shadow_accessed_mask for EPT even
 if A/D bits disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that KVM doesn't use shadow_accessed_mask to detect if hardware A/D
bits are enabled, set shadow_accessed_mask for EPT even when A/D bits
are disabled in hardware.  This will allow using shadow_accessed_mask for
software purposes, e.g. to preserve accessed status in a non-present SPTE.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b713a6542eeb..cae45825617c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -440,7 +440,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	kvm_ad_enabled		= has_ad_bits;
 
 	shadow_user_mask	= VMX_EPT_READABLE_MASK;
-	shadow_accessed_mask	= has_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
+	shadow_accessed_mask	= VMX_EPT_ACCESS_BIT;
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-- 
2.46.0.rc1.232.g9752f9e123-goog


