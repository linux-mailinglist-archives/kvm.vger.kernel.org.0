Return-Path: <kvm+bounces-23777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA02694D784
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 854F61F22F59
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF2D166312;
	Fri,  9 Aug 2024 19:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LCaId1Mh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0692E15F404
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232623; cv=none; b=fv5WcoiWCdaOh9IJ0XW9v/00M++hjT8jaWnNA23x3sF7Nqyn/Bv5G9sWQsP+aGIw1NMuuwBdmPUlbHI2Q8KqH6iV6lXrvQvM8+6+9vugydbGGAypZ89iiWatjIMpsyaM/wTMshjJ7QHPqzZF7tHW07MZBIvrKz52K+6MpoHta50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232623; c=relaxed/simple;
	bh=UxnvgXHSiR2kQsYdw03waRMGPjo2zH4fYnT3IGJL6c0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eYV2UnWhyePaFlMet3CjGO9TybyukeMMb9fsEkCIZNnGW9FbInnWV32jUZqK9yI2s7SNMI9uOAwy3jouF4HZd6OT2mYe4SNm3OdETdx16IMLZgQ+YRO3WmKnoj05ZdN1ap284gJ/nzTcr8G19Z2CPW/L61UIpiO42QdQB1gek40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LCaId1Mh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc5acc1b96so25144885ad.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232621; x=1723837421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7EQAoYr/rc8nw+x53hvnHC7R0vSXW8+m/U14Qwxr4YU=;
        b=LCaId1Mh/cfaZ1A3flIXbMN83yBaKr3eYyJEIzeWrB9ivmSxDZc+VvMaDztmkpgr+q
         IdtIZrzYDAjomWisZ/GQgXsnJ2RxFlGQp400ic94KFn3V1GkU8cMXITkZFSi1CYETvNO
         eslSjnmvX3Gj8rLGgXN7ugHWhNACs36OiQo2pTzCcg095YFxQQClYPbo9USpdyVBHTmS
         L9b+E2cFQ6RB4w5N+v2/Jln6IXLEsoKEinkMSazH2Kn2OQWqYfiKyLAVrGkpivH1bZQ9
         dIBIQGc3YW+kRLmcI2UXk01/cFwcNdb4N5S+kbP6KKvJsGuWn0OnUhnlunOXCMJ/n7ZR
         uuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232621; x=1723837421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7EQAoYr/rc8nw+x53hvnHC7R0vSXW8+m/U14Qwxr4YU=;
        b=wPXXCzeY0ZiirKnDdEC019d5eDMDQJ0jUb5YzMJuri5TCSDB/rOdfxHo8rrov9Ko0b
         EocOT7uhuM0gznZGmzs3M4ttCtAMv4uVXNZdW4rUDs5Uu0IVmuS830IanAE6GxzkStuU
         zpeakCFviTrwNg+xYrodI3GbpW1IZNjhXa9j8VDuP+Wq9Z3s1kXliQ273TLgUleyhuLL
         jNtMttKeSd4NskS1EqrNUj2bNsyzdiwcI3P0VuLfB6soK4FWlsosqJ2qotKqkW5XYWAN
         N62JJOPH6HE1GLzdBoYAmGGDGjQ81pgY01SoqCOOsCBoqYUSXTiTkAgyxM6CM565pt0Z
         t7ZQ==
X-Gm-Message-State: AOJu0YxcoRoaqa/G7j9AWYjKss8IgNoRrrIAJli7u3A1UZQHSRUyrenz
	r9YnlBKxT/xufr0+YlnvhNmzC6fGOGPg+DWv6YYsKaepWM4MtPt4SZ8OwmGUhSrRKg3YZvdOVZr
	rcg==
X-Google-Smtp-Source: AGHT+IFZbM8cukPN8xrEPWCmEvmIVa0hspDzfqR9/uQbMDXcIueCj/k5JgcFqB326LDruTDoIrGeiyLQyKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2342:b0:1fb:56c8:f273 with SMTP id
 d9443c01a7336-200ae4d640bmr1732425ad.1.1723232621226; Fri, 09 Aug 2024
 12:43:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:13 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-2-seanjc@google.com>
Subject: [PATCH 01/22] KVM: selftests: Check for a potential unhandled
 exception iff KVM_RUN succeeded
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't check for an unhandled exception if KVM_RUN failed, e.g. if it
returned errno=EFAULT, as reporting unhandled exceptions is done via a
ucall, i.e. requires KVM_RUN to exit cleanly.  Theoretically, checking
for a ucall on a failed KVM_RUN could get a false positive, e.g. if there
were stale data in vcpu->run from a previous exit.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56b170b725b3..0e25011d9b51 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1719,7 +1719,8 @@ int _vcpu_run(struct kvm_vcpu *vcpu)
 		rc = __vcpu_run(vcpu);
 	} while (rc == -1 && errno == EINTR);
 
-	assert_on_unhandled_exception(vcpu);
+	if (!rc)
+		assert_on_unhandled_exception(vcpu);
 
 	return rc;
 }
-- 
2.46.0.76.ge559c4bf1a-goog


