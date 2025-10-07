Return-Path: <kvm+bounces-59613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FBEBC2E3C
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 771303C4AB5
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957DA259CAB;
	Tue,  7 Oct 2025 22:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4NQNsDEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F2E23D281
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759877069; cv=none; b=kEXbJgJ6CJbwMarYuvfep+Qm5EBLmWl943p/OrodKYeBg3JxNfKLaUn1rYkLd9eB3L6dcaSBB1dmG/GcCTi4gB7BiDLZFRTPE80sgSp5tRAMhiz42bCtAgNKMy+M0gtqEEj+6xfalB6EYFaDwSYkdo0bZveano46BF6DX7nXz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759877069; c=relaxed/simple;
	bh=78cJopXpOQG9OAsUEwX6lCCobqh+oH6OfHl5pPo7Ztk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SDypkPdhVe/IZWvCMhhkDw3kzoyqPlswo/sxfmKDi5l3oBv5tSl4aOuHyhMzRvYvzrFeR+4QIKHKrwr+pBpzjSrGEPU1uB78pQgYcbmJ0u028bMcFWkMwsdyR1k45RKo7xcgXO/EL9NqweYxP3qQQfnEeBogweYV+ha8dSc1tP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4NQNsDEZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2711a55da20so42793865ad.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759877068; x=1760481868; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/Rkpq/p6vlS1ftX3Hk8IgbTMJisDfUj8W7AvidCFsY0=;
        b=4NQNsDEZNgslDedNuS9YaH/UJZei4lcYI38XojhVitXe653Xij8s8dph+tu+CCo0Gn
         obBcLwKkuN3LFFl3QQnZ3vppbCngv8xZhNybtqilV/Zq499T0zFZEIqFxxrqRRN2IvXf
         WODbis9u1BPnBpM3j2wD7PRoVBmnOnv7G7CHwssdWxJiEAaic3jXfc0VK0M1SvYC6vJt
         hsRmDHK2MEGFwHlmO53sWyFiLkLY7oHF/GSCywHj128dVG3C4D7eWEGKNmLafmHvZyy0
         xnDJddbc4dOAtqioYUSJSz9o9zebLS25UgKNAeVHFyw7/fbk4qO7dR5BgwEab3He6nNo
         5oBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759877068; x=1760481868;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Rkpq/p6vlS1ftX3Hk8IgbTMJisDfUj8W7AvidCFsY0=;
        b=N/SDCFuKwouzNem9c2xYGGWSeKt3rMxQWc5+3/Krm4C3LqQQkB3pozw6fHpJrKh8OQ
         SzfnII75/OJAPsZ34Tukea84VGXFe82jhOM8oZybRbE0TUkyfs64WhyscZKBQa6xR2zO
         YRQ7ukJ4yfo9o97r8dejlQRkpq+Zml7IeKBhdQNNsFBGGa5EyRzJYNRWLuy/i5ifOj/Q
         ND/OKF9IhmNMDHIW1r38D6eq3vw7sXUh7TgABa8LKHuCaa2cVHz66Si86U5WTUCyWrDF
         CU0/f7e94Be4ldp3MTA385k5BCSleOA19vk6fSXPNggpGEpFLb3ml6w3jv6D/Rv8p0vh
         wc7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLybkR6GNVRBNWQQkdRZBfc94R93zuRQKP5xPtzX6tFGCPgu0Po0dH/PaCdg4nXe/HJOw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRYJmJYDipGqXs7ku0DyrL6zfQcpqeYAkto1D3lRga25WcFSpe
	2b+7qa0jDcoi2LMHDC0u2baVVTDT2dKEEIazNvgVOAaIeFYDrbdabuWqB2W/XAleucs/n2pMeXK
	24ECGmeVGb13KVg==
X-Google-Smtp-Source: AGHT+IH/DPeqBgyKHXxOCo4/E3KmZEcspJS7td8Arw5LBmg4kppGX/eQxm4ue9E3qb2QwOhVlQeaDs/189kaJw==
X-Received: from pjnh3.prod.google.com ([2002:a17:90a:8303:b0:32e:c154:c2f6])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef10:b0:27e:eabd:4b41 with SMTP id d9443c01a7336-29027216505mr14903695ad.7.1759877067692;
 Tue, 07 Oct 2025 15:44:27 -0700 (PDT)
Date: Tue,  7 Oct 2025 15:44:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007224405.1914008-1-jmattson@google.com>
Subject: [PATCH] KVM: SVM: Don't set GIF when clearing EFER.SVME
From: Jim Mattson <jmattson@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Clearing EFER.SVME is not architected to set GIF. Don't set GIF when
emulating a change to EFER that clears EFER.SVME.

This is covered in the discussion at
https://lore.kernel.org/all/5b8787b8-16e9-13dc-7fca-0dc441d673f9@citrix.com/.

Fixes: c513f484c558 ("KVM: nSVM: leave guest mode when clearing EFER.SVME")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3a9fe0a8b78c..5387851a96da 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -223,7 +223,6 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
 			svm_leave_nested(vcpu);
-			svm_set_gif(svm, true);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)
 				clr_exception_intercept(svm, GP_VECTOR);
-- 
2.51.0.710.ga91ca5db03-goog


