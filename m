Return-Path: <kvm+bounces-48607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2CAACF864
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F1716AF0F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BCD27FD61;
	Thu,  5 Jun 2025 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wO0pDk8T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D8527FB05
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153032; cv=none; b=MtA4b8La6khll/OFTtEyyHkDtbMPUfmTOymmnbdleYSlBOzA/p6BvqX39gSANwethX/KrPPsFAwGOj31QFrIjVVt5PwwfWaJKvNsaCGyVcr1SOJn8sPb+Tpc98OPsSSVSiRznW+ff8cjVqqbcHnq9i+um1pMhkyhP/++/yT83qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153032; c=relaxed/simple;
	bh=DLH64El6OXN5WMeklaHTszwSOe1DG7x14NJ32u/E2Aw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gQhxOT7HaUpRbSH4DxWMRYvb3JX51O3tTketwISgo+hsbAtfpECLQ5I2dM0i7fGVOCc+sdearI3lbmgPT4VLKDStGvT+2txaU4zNjI16OyMks3pN3NJXJSqWS3bgy7B1r9TfSNUP3iMuSlt5d5P9S+sOuLMrXioA1Ilwp4/0Vb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wO0pDk8T; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311d670ad35so1316377a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749153030; x=1749757830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TadzeiVx8KJvVm3F7EgQlyQo6nVjOUl2f4eK4MtVzDs=;
        b=wO0pDk8TKceRBFpWSm4T8E5cZEShgaAHa0Qm0fNpHB/Vn9Etw2ApfX1fR2klEhoTi8
         zDm5JA/6WRKAb6awbUhcGNujI9+WXiffPHs6bIb2jiw6Zi5/BEp7dXKCB/Xkr5gWv/xE
         QZZ7x9QMD/ELb69QJs+Mzx/M8ZvUGk/ofu3cvx+GwTT56NHkCdQF4kKtFZg7LwLiposh
         62mhAtBwIFE3rihT35kYuPA9Fk6Kl251CSbm1xkVfiZ/CPASMjxVOzy1FwtR/hqf2gTm
         e2Aak4cTZXkBPzGzGDa8PIjfX2R85WACzQJ1cwvfeOSme5R+U4wyPljW9DAXmD+7A9UR
         umSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153030; x=1749757830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TadzeiVx8KJvVm3F7EgQlyQo6nVjOUl2f4eK4MtVzDs=;
        b=Y9JBBBigwzmrql8M3uhyXr9Ktw63oe16G7+pWFOUBi7VJ2lQdclm8kelHLfqW5khsw
         G3EAtS1qwlPFTFKre4i25JiGrkhrSbEwrPiNZEHOztrsKfdvXV7C88KZV3q/DzEB9IOG
         hwWfjA9tyGe0MbwpLQamBLfbiBJYmfN6u8W6N708cirNM2B0BhS2R7pbtl8HdPEjQNsF
         m6To8zhTxiHMUQWsD9u2kRAQQgmwH1bCdACpD0GvOog5Ksc5oL1gwxD/S2Xu0+Fxx7Eb
         mBuxLqJ//4OAx3mnOvRekxv4iRL+cl6UW19YCTvFC6JbFmH9DZg5/Bpci28sy4tE5+Oh
         pXfQ==
X-Gm-Message-State: AOJu0YzySEAt7gM9McFaGb1yOHpf1lD68YoRPk3OsMS/EwGkC524/7V4
	BQFNcPp1ecgT3v8Djro8vm1pnPPzv27KaiEOqv14WKVvonia/99sEstN+wnjhM7ylw39ZI64TWO
	nRdrlow==
X-Google-Smtp-Source: AGHT+IFqrgAXjDGGMOzkv9dbrRl1muhwdNPcu0ofy/G9fG1cymdj30b4P9mWjIJs9OS5z/LFkKNVH2aTo2o=
X-Received: from pjbqo7.prod.google.com ([2002:a17:90b:3dc7:b0:312:e5dd:9248])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e42:b0:312:e731:5a6b
 with SMTP id 98e67ed59e1d1-31347799bd0mr1146466a91.32.1749153029991; Thu, 05
 Jun 2025 12:50:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:50:18 -0700
In-Reply-To: <20250605195018.539901-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605195018.539901-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605195018.539901-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: x86: Refactor handling of SIPI_RECEIVED when setting MP_STATE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Convert the incoming mp_state to INIT_RECIEVED instead of manually calling
kvm_set_mp_state() to make it more obvious that the SIPI_RECEIVED logic is
translating the incoming state to KVM's internal tracking, as opposed to
being some entirely unique flow.

Opportunistically add a comment to explain what the code is doing.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9935307ad41f..47fef0e7f08f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11908,11 +11908,17 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
+	/*
+	 * SIPI_RECEIVED is obsolete and no longer used internally; KVM instead
+	 * leaves the vCPU in INIT_RECIEVED (Wait-For-SIPI) and pends the SIPI.
+	 * Translate SIPI_RECEIVED as appropriate for backwards compatibility.
+	 */
 	if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
-		kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
+		mp_state->mp_state = KVM_MP_STATE_INIT_RECEIVED;
 		set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
-	} else
-		kvm_set_mp_state(vcpu, mp_state->mp_state);
+	}
+
+	kvm_set_mp_state(vcpu, mp_state->mp_state);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


