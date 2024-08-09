Return-Path: <kvm+bounces-23761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD69294D6DF
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47E2CB221B0
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641CC15FCEB;
	Fri,  9 Aug 2024 19:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mc72H+Sb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F07D1991B1
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230227; cv=none; b=OCTyiC+BSsB54rOEqMKDciKpxY7awHZRG2Pyji13+ntBQgc0m5XbJwe3eytMQ//Tfw2wkh3ODppmMnbWpHbripvUP2RZE7X7+4oXgNvU0Yt3Ap1Ijy00d4yr5Oo+8CBnkiTXDsS5I+700HNvtwK2fs2SASaNNd99g/WYIPxUrp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230227; c=relaxed/simple;
	bh=6moPdz+KiBY3JiE58UG/PhJfbn2rfK0CZx0lw/tb5cc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PqdAhBew9+ytztfln0g74XUKhsmyys7sOu5/wTpyFJaRGKM8mPReIlIN4G7oHo5nkkXrRhgVR/e5n3jgZvR83+cr/ZF6ugYQDykOPWosaGknrTTAfHuODPuzVM+Z7nSgVXjPvuHH+jlr6smkjpjpedYe148seBrpdaXzIkX5Q90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mc72H+Sb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb6b642c49so3294368a91.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230225; x=1723835025; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eOJjh+TwQWkp+dpnChOXrZQKD3CV6Wrx85zDT1JyEBg=;
        b=Mc72H+SbMQzX9cnM+JRa9cIRvf0mFv1s+COBI5BZgY03MI4Jhsxpx+8pKCHNPP0zUN
         VHph1yw44WYvjMvW5kirUIPxWMYLdobl42EeaKsubujRo23t0pBrSsALB176KwF8yINf
         KcAgUrUq88E1fVKDH/M/YeYlDQmCicWlH/KDrWAbgSVtiOxRSdaf5ZtJGZHK/ybuIM9o
         BvH62zoBUni2PLRZsX0lqNNsetsleWWtOWO+tUhJPQjgP3CBVd2+8pwbNA0ei0B49xZG
         dkNfaCzJBJEljyhIeaFV3Rbt6wdscnK57edS01pVokVwrnIX+bHCZbKQPLGPbtetW1JP
         Wcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230225; x=1723835025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOJjh+TwQWkp+dpnChOXrZQKD3CV6Wrx85zDT1JyEBg=;
        b=khxRMTtnjXzQl37lxLlsazLdIK8+lbvG/wUKd/vV6FNxGLDrnakEqh+wftZr+I89u9
         LFSn/jkiULDg7Q1v5n60VMNgkMCL7ax6TGJZ1TXTCKlIngucUSJOZvjGvpm5OKOCJPsv
         cqz/1rV5QGI/QyWQmpoedoLcqbGxDljwp+DfgMw4uvV3pFoQbVYK/8tG7+8hn3jMkb60
         A+d+mrf3UZkE0lqrtkOLSU6rSTCI9W4x9LIm04AiY9XB1OxacPRuPnR+sMnSPnTHjl2D
         8zj5lHlywY8gRbCHp7dVgc20HvDPM9KCvx9xNa76zarJeMQIHyKNoLo0wBK4B+kdGdkx
         FIYA==
X-Gm-Message-State: AOJu0YxudUwxspu9zWSPLpnLu++6Q56IgrIJmsw9gTX2LHZ+lfBQUmxV
	qZVlk+ogvALENyVncO2RxDeQR2Jn3L0PspmXPmLC+M+MQl6EG34F48iRcO6dJ/sG4OkF2dX5wtL
	GBQ==
X-Google-Smtp-Source: AGHT+IG1vcqcE4+XQ17AvIfAnOAspsC8HmWjhE4Wu1r1FCI+qECCKznOMFlKFBRxe0lpfAErcb1t+i41zVM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c0d:b0:2cf:93dc:112d with SMTP id
 98e67ed59e1d1-2d1e801daadmr66093a91.4.1723230225408; Fri, 09 Aug 2024
 12:03:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:07 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-11-seanjc@google.com>
Subject: [PATCH 10/22] KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a
 more descriptive helper
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the globally visible PFERR_NESTED_GUEST_PAGE and replace it with a
more appropriately named is_write_to_guest_page_table().  The macro name
is misleading, because while all nNPT walks match PAGE|WRITE|PRESENT, the
reverse is not true.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ----
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10b47c310ff9..25a3d84ca5e2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -280,10 +280,6 @@ enum x86_intercept_stage;
 #define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
 #define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
 
-#define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
-				 PFERR_WRITE_MASK |		\
-				 PFERR_PRESENT_MASK)
-
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 358294889baa..065bb6180988 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5980,6 +5980,13 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
 
+static bool is_write_to_guest_page_table(u64 error_code)
+{
+	const u64 mask = PFERR_GUEST_PAGE_MASK | PFERR_WRITE_MASK | PFERR_PRESENT_MASK;
+
+	return (error_code & mask) == mask;
+}
+
 static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				       u64 error_code, int *emulation_type)
 {
@@ -6026,8 +6033,7 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * write-fault is due to something else entirely, i.e. KVM needs to
 	 * emulate, as resuming the guest will put it into an infinite loop.
 	 */
-	if (direct &&
-	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
+	if (direct && (is_write_to_guest_page_table(error_code)) &&
 	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
 		return RET_PF_FIXED;
 
-- 
2.46.0.76.ge559c4bf1a-goog


