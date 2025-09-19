Return-Path: <kvm+bounces-58255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5535B8B82F
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 794451895FAE
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7172FD1B6;
	Fri, 19 Sep 2025 22:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xtJH13b7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115F2D838B
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321235; cv=none; b=BoUe87K3HCgzxY6cIE/j25mT4yd88pBP69ZYrAEoyTVfeJQ0VevppvLvTSFVqw0MXq/gwpnVyvhgM6Nn0QfxTHFX716AHyCLzv3vybql533BQp3AjInf+KGxB2B+JroMFpwJhHTYC7Gj/DCagSsuU2YANxgY1fBVotke5wRBzgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321235; c=relaxed/simple;
	bh=2gM7Uop8vPVEXUGMYiag2AvONubl/l+I+/souHg70aw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EO06LL6S86vQItLW1n3I8g73MGrGbDqeSEF3EdL3tv1TPyiyegXRBHM4CaxfzCbRqt700Yd0kBj680oeG1O2/AHs6Bee0Wm+1FK0SABWup+1c1k8uyS8gljqrDIN1JF6gUUFjmPPST4nbf8A41Gh8mHg91assFx9CNrfWxEvDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xtJH13b7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54df707c1cso1711169a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321233; x=1758926033; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=23qlWqf4oRLqIZNu0WNA2q5Vhl7DiLF7Tw6OyPY4Ueg=;
        b=xtJH13b7xTbSjKYicpoSCk7twmXeU8gZ8/+EEw5wi7IGbEeMb2sZJuFNidq/6kQa93
         X7ULUE5pX4VgF0aa8bcJu8wn7xgHC6ahltko3X/CMpkPVhLFMlwe5cdtz5IxPeenJjv2
         6zS8EoWXjCYzETUJ0qNFe0Ft1263glGWXh1DTDlYIpXAdAKPOrFRMQrpjNIRAXKpL1mU
         dwlDs4juHaj7e8ymfLgraHRb+PUq/JqLHNritCYLrVxGFRcVC+3PFzDcJ1+8tyHsY0b0
         8rlsgK9V4PWjdFz+ChiDTrfMgWG28APedAeIYFc5ftxDcCRri5d3ib+VN5CS+Uuo4bCW
         UtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321233; x=1758926033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=23qlWqf4oRLqIZNu0WNA2q5Vhl7DiLF7Tw6OyPY4Ueg=;
        b=W/sckG4Sfi6zJ3zPtDQUG8ZvVcYUpe+LvpHCQJ6nvr4iSoSE+w1v3/vxMLHToK2UHh
         4oBm2k8KA4mkaDuuIPhO/uo20JB1qCIaFoYcqwNamiIcfqm96RFj5rNFYTRvLIgAWGKw
         4zAZlgFTm5rudSkIZpB/wnEN4MR5sIatIZ1y23z1RNLHwbTj9EsX3uEMJ/iJwClPAoOR
         zDTD84dgP/F4s0Us940VAi5Haot73Y7XCik9hMCfFH7/hlNGXCmzl+jmwbDYmDjT34EP
         hDFepcIVtW3l1dlO2vplFmeNDTm9/XtO0PNpRqfSwHL3MBwFqvtwvyUVDys8pD1QGpWM
         D2hQ==
X-Gm-Message-State: AOJu0YwbgQT9l6yseNBKPWd9HL5MU+H1Ssmc38hRfwF6a5zHeWj3nANr
	8hoCC97ej3OPsIvvl6+qM5BHBo9/6iCJVlOlofwV68l4S6yr1AMoG9neuKSeDChxNl3qTtkSFtr
	NHiBYzg==
X-Google-Smtp-Source: AGHT+IHttAp5meToldAIyK6UP8vRXnlxncg/zpxLk/f31AwWxs8t6p1klk35VhoiSoa10kmYsFy/XIQ3Pjg=
X-Received: from pjbsd13.prod.google.com ([2002:a17:90b:514d:b0:325:a8d:a485])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e083:b0:262:cc1a:abdd
 with SMTP id adf61e73a8af0-2927689e7admr7584917637.60.1758321232887; Fri, 19
 Sep 2025 15:33:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:34 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-28-seanjc@google.com>
Subject: [PATCH v16 27/51] KVM: x86: Disable support for IBT and SHSTK if
 allow_smaller_maxphyaddr is true
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Make IBT and SHSTK virtualization mutually exclusive with "officially"
supporting setups with guest.MAXPHYADDR < host.MAXPHYADDR, i.e. if the
allow_smaller_maxphyaddr module param is set.  Running a guest with a
smaller MAXPHYADDR requires intercepting #PF, and can also trigger
emulation of arbitrary instructions.  Intercepting and reacting to #PFs
doesn't play nice with SHSTK, as KVM's MMU hasn't been taught to handle
Shadow Stack accesses, and emulating arbitrary instructions doesn't play
nice with IBT or SHSTK, as KVM's emulator doesn't handle the various side
effects, e.g. doesn't enforce end-branch markers or model Shadow Stack
updates.

Note, hiding IBT and SHSTK based solely on allow_smaller_maxphyaddr is
overkill, as allow_smaller_maxphyaddr is only problematic if the guest is
actually configured to have a smaller MAXPHYADDR.  However, KVM's ABI
doesn't provide a way to express that IBT and SHSTK may break if enabled
in conjunction with guest.MAXPHYADDR < host.MAXPHYADDR.  I.e. the
alternative is to do nothing in KVM and instead update documentation and
hope KVM users are thorough readers.  Go with the conservative-but-correct
approach; worst case scenario, this restriction can be dropped if there's
a strong use case for enabling CET on hosts with allow_smaller_maxphyaddr.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 499c86bd457e..b5c4cb13630c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -963,6 +963,16 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled)
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 
+	/*
+	 * Disable support for IBT and SHSTK if KVM is configured to emulate
+	 * accesses to reserved GPAs, as KVM's emulator doesn't support IBT or
+	 * SHSTK, nor does KVM handle Shadow Stack #PFs (see above).
+	 */
+	if (allow_smaller_maxphyaddr) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
+
 	kvm_cpu_cap_init(CPUID_7_EDX,
 		F(AVX512_4VNNIW),
 		F(AVX512_4FMAPS),
-- 
2.51.0.470.ga7dc726c21-goog


