Return-Path: <kvm+bounces-48888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81261AD4631
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 104BE3A7100
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 22:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313EC29ACC6;
	Tue, 10 Jun 2025 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rTx17Bn5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D8296158
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596270; cv=none; b=NDwonGP8+XZj4CvT2WwTPC+oPXnD+qNNWco5TPqzoztD919NyuV4VjmkyvV5p7xCxo712o8hJU+WelzFxOX4htMAM9WKTZ+IMtGBjsUVF3fBn87jfaqNdCQB3k4VJ+cBQhZc3W5GgJiX2Gx7CbsnVWh0LHWaHhApBNM9oOkrFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596270; c=relaxed/simple;
	bh=h9i+uZd04eChsW+nlNKQ3UAXF59GUvx7ckxUk1JRgd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PNGQJjbqyT1zvLEEMTFBmG4qfppOAVX2ry+5w4mdLyVJBdowu21jpG9wklfKI7xwJleY8MXIusDCo2y6fVTmaWSb2t7ifC9JZjbRtD4x3AgVVSrlOPydNUmyIn0LPV+bzmVEqEy46xWinzW1/QupaNMHhTAL3m6nmXyIJfbtGqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rTx17Bn5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so3229895a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596268; x=1750201068; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SoQUNiBbCP8FPIO1f5Uwyh/idHejyF8GDJKfEhkOQsI=;
        b=rTx17Bn57VyUIawH+WDV368ZGhe/qJCAlvNgITFnGOweL9ibJpIxbSSEubV8kKSP97
         FekRb6+GEuhlWRJIFtMR7WTA6vAmRm5Z/tNlZSBy3aSmODHp8TuCoXo0Rmp8qi4tQmP1
         yY3Vfe0+m5jfkyvGyDsPA1U4yQXXylTTumToO+DTZrGcslRi3HSHS8McNei6hkSnTGDA
         1LriH1qMGrrGdcoMngVm8t2RVgJW33jMj2Eh2Jkh420oDFZwNhWAjSsjOvEj0pLN0VJd
         xXRwgohNPL69gzf5gSlejwH4GOabZsObpVq5Q1tlGim/PjfKltIkJOnL+RFk0F1F6vr+
         HmdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596268; x=1750201068;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SoQUNiBbCP8FPIO1f5Uwyh/idHejyF8GDJKfEhkOQsI=;
        b=uQUwIowL/tG10iZc1RFQOu5c/7f/RhjGQeKry1xoDuemkeemlgHMFxg4y/xmyevres
         tX0NH82L2OcDKwGyZ7uXVdznOMIuNEy/2tGLPDi6FcuMKyZF+tCfHyZfOcdWy6wpNHt4
         OC4BNt3hRGFKkRmL0XeEDtc2x/nEPo26L+Lon9iRPqFkTWMgSQbJk3hZ8iIJoZkJ8B+U
         uJHKXGb01KCZE2Zc2K6lVUfT35vcfpVe85I9ONJUbT8lROtiJ8/G8U0+C4eJaLEbvevT
         i7HUgAw6h7XXfkBhdENbkySVaFmyb15taNQnQXdW4y076g53CH/yq43qQMcI6TnEDhC8
         YxGw==
X-Gm-Message-State: AOJu0YywG60dpVG8rQkfOAlBwZmdJU3KICL4PGcLdDXLae1RMVrzKvIq
	R5awHEqOciEXPXClfxKkpGafYJfFb1mjOivH/gcOFr+R5BPPjd/ehfPPrPQdFNrLkzeLXz35QYI
	z/6/I3Q==
X-Google-Smtp-Source: AGHT+IFXybDfHkTW5ENG82VCoMPz90fwPWH+yLTn1OifXhmiBLrjBHv9sk6PMNKANCsysYSoP522+lIAWmc=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:311:6040:2c7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8f:b0:311:9c1f:8516
 with SMTP id 98e67ed59e1d1-313af13d310mr1609638a91.15.1749596268237; Tue, 10
 Jun 2025 15:57:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:09 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-5-seanjc@google.com>
Subject: [PATCH v2 04/32] KVM: SVM: Tag MSR bitmap initialization helpers with __init
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Tag init_msrpm_offsets() and add_msr_offset() with __init, as they're used
only during hardware setup to map potential passthrough MSRs to offsets in
the bitmap.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f70211780880..0c71efc99208 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -945,7 +945,7 @@ static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int add_msr_offset(u32 offset)
+static __init int add_msr_offset(u32 offset)
 {
 	int i;
 
@@ -968,7 +968,7 @@ static int add_msr_offset(u32 offset)
 	return -ENOSPC;
 }
 
-static int init_msrpm_offsets(void)
+static __init int init_msrpm_offsets(void)
 {
 	int i;
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


