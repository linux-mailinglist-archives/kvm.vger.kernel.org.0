Return-Path: <kvm+bounces-19085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F4D900B39
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D7CB288BD4
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAAC19E7DA;
	Fri,  7 Jun 2024 17:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gVhJSPCi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9877019DF5A
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781185; cv=none; b=rwoMNMwGVZ7UPBw82dMe5xdowLEyOYyk84qs6RkZ6e2e42g3m53J2uhjhk82G3MPsPG2PfM117Va3pkwyW1ZLRy29y5Dm+K3eUHGfUCZW/MYJ/zP0wrqbkU5joVszKZd3h9BlPbwaGdmv/2v30K7isvANQ0/Ka5mDY4wTDPU6Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781185; c=relaxed/simple;
	bh=k3uT5XlI3ypHnkmLELkYUkwKaO/W0Vb6n7fa+JWmkAI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HcvbHMDXGmS5jmpllb49BOXq0nvB0Jf9MHpN0G+SrlY0gtfblXMCXSGY4OuV6phlcLfsNb9p6IYWNkXuZ1pOfunC1cPZUS/5kIbtWaVk08S+dyfplpV3xQMf77Z8EbALULhvg2SL4aMlv/SrSpqLzpp7fASiw0CdMT3xOxCS/Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gVhJSPCi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c2d8af4eb3so4947a91.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 10:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717781184; x=1718385984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=imi/dSYgg4r8Xm2pV7Tc7IPLLCcd51djYuqB8UoSynw=;
        b=gVhJSPCiy/xmMy+io9LvM3vlstRFcRXZ818xvTziOsyK6QYvglbT0rDny7t3DrIyEA
         A6QL7eAA2FLpDiUyOV4XSoyljaTYSQLi6VRrWmMzLFO7LZjHhky4w5rJbRdGA9EQn/XC
         Omb29/5HVAUEQbIA4b+fIRErJ8avBy+vJaJfh5G6t/cHJqhUchwVWvOzqTzl/E3MNLhD
         70RGYEW8w0HQoNGver9ikXbephNn0SWmvIwiCzqNXsEgtoVPc+zh38w0ykLfmrUMwrrT
         zdzs7JtRSqEy8+h+ykSu97LEmLTaO+TBh+/Xs2TjKL2FbUBk7BsOpnKt2+c/5O2CjtT2
         Cnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717781184; x=1718385984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imi/dSYgg4r8Xm2pV7Tc7IPLLCcd51djYuqB8UoSynw=;
        b=XejKpEY0pctwZXOmx2fgDgj0j1kD+fenu96q8vlMiLZXn0TmpTscEWj+bP4BUiUqr7
         tucSASeD1ZOOFQRRBZ7YfrQ89sH/G51jFfeCMNnlKLzjMHlaNV3C+TINi/J++CTYdy48
         Y+IlxD+QgENFVj+yRdUQ9Ej3NSX9Eq5Yyq3ddyvo3HhvdMRm78RZqEXrGRvxZ9f/rEBo
         P3m3DwBgP5H2dh++Myh1vE/BlEqSwLbtVG/yqu7M3HMdGm3e1Tr2AuMpGAPaw90tDUIe
         h0BpZOIOqExh47Fi7L2LjnSHEl1otKJjRvGM/8C5Rtv/qCZL/QTElyIgYmkE6uOGlw34
         Y6OA==
X-Gm-Message-State: AOJu0YxHKoTN/2tTQPySEV9w6QRMp6b02QTmw/FPbr1xanUHQttLRnUd
	O7OSNZlwI2DqlxS288+WGC6/RDjQYoYXuXPlWV7MYJq3pWnehrcwpas90QklW2CDncm2GPZ6+V1
	R3Q==
X-Google-Smtp-Source: AGHT+IG6nFvgtkoQJtWh/SJojCthYFNtSi07s94PAk8NWpUcvQDU80zrybcyumoWHUKops6ND1JkBsWVY/Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2752:b0:2bd:f679:24ac with SMTP id
 98e67ed59e1d1-2c2bc790091mr8377a91.0.1717781183524; Fri, 07 Jun 2024 10:26:23
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 10:26:09 -0700
In-Reply-To: <20240607172609.3205077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607172609.3205077-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607172609.3205077-7-seanjc@google.com>
Subject: [PATCH 6/6] KVM: x86: WARN if a vCPU gets a valid wakeup that KVM
 can't yet inject
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

WARN if a blocking vCPU is awaked by a valid wake event that KVM can't
inject, e.g. because KVM needs to completed a nested VM-enter, or needs to
re-inject an exception.  For the nested VM-Enter case, KVM is supposed to
clear "nested_run_pending" if L1 puts L2 into HLT, i.e. entering HLT
"completes" the nested VM-Enter.  And for already-injected exceptions, it
should be impossible for the vCPU to be in a blocking state if a VM-Exit
occurred while an exception was being vectored.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82442960b499..f6ace2bd7124 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11233,7 +11233,10 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	 * causes a spurious wakeup from HLT).
 	 */
 	if (is_guest_mode(vcpu)) {
-		if (kvm_check_nested_events(vcpu) < 0)
+		int r = kvm_check_nested_events(vcpu);
+
+		WARN_ON_ONCE(r == -EBUSY);
+		if (r < 0)
 			return 0;
 	}
 
-- 
2.45.2.505.gda0bf45e8d-goog


