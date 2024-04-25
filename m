Return-Path: <kvm+bounces-15957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F172B8B27F6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B711F21C13
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0AB152527;
	Thu, 25 Apr 2024 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PruVeND5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D0A14F9F5
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068871; cv=none; b=flJjknymPRKB9QuP6V+hSO/56B49d9DzFCZ0FxLyL7ZD1uyzsumhSHXATsci1tsLUtjN74CAx1x4V0bpxehglE6sG9h1pB5syFrVyQ2PzEZYistixrSfJ/ewmuCrr01fVbM8W2VPFnohIdS/N14YNRByY0NnOOOHisvjDvzrR+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068871; c=relaxed/simple;
	bh=puiewvMq7VQ3MSCBcWLocV/OvKUjYEGDnK6E7gHhlaY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PjgbrHglAoIN3N8dIGBHqH6qQHEGT+k1hFdvRK4CiLDEwdsJnRa2VXgoyzHeKOEg1DKL6zz6DCDrqzubq2aFSuXWHwXs8LktIMTYkUUhw5hSgrUnJ65dAUswkR6uYBjfHsxabW2cd0rc114Lk6U26rdvFFd6oM5KGGcrA+Hs9f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PruVeND5; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcdc3db67f0so3153551276.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 11:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714068868; x=1714673668; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bwEBzadNGVu08MehwcHFWlb8XgA5vulEsBKMYAk18b4=;
        b=PruVeND5+AnfyRifT/iGvcEpJmvsSslyPJ8T9is1pNzWo2RndY2vJzjksAvSEAkqu8
         PTKD1nWhRYPNLUsCN3+0D7cWn7ojHV5SXBNWLnfvC0ikxPJo9mGdQWHpXG/gp8ceO4ZN
         r13wgt/hoUd1AVpqFhVsj7DxzfGVXA0fLXzPRrc3vLyzIbF747bAV8AQ7KmqdwlD9fi+
         dshyoVOrl0lMj/zJ/INlZsatik69rWlOP9WiGiZKMUXd676PDIscIEEmJIXb+O3sPWRu
         yac72LsadvWVBjJmSSKcDySy0knL+BmXZrqzW3c/vTqEeQ/esDGwu5RNz4IG335Gt8O6
         KKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068868; x=1714673668;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bwEBzadNGVu08MehwcHFWlb8XgA5vulEsBKMYAk18b4=;
        b=UJslwflFs7JHzfXmFo8a4Mzb4KITmTK/ypk+0j7Q7uBpSelTsM4IuUflDaSbOQjutE
         F8uIyV4LhxtGFv6ssDOzYSQmuFDTZDuL+sbrkU0HRhHjIBF3js63Fx5TnsAInZGK62tJ
         NlFufkgyMq67r2/efF1F1Q+YDsj6rd6OPKIlxJnu91jdbWiyfXoCk5LPabmSlib64dVY
         Of30F3vgkbiYydPaGHJ3MNYgfMb5BxwVIcZ3qExThuBy1VAbzhA0er8a5LqDcajhbX4V
         oaIfeQUq4pyjYFOF3ZyL54qqnDsuRAhYdOZw/TAFC2v54Uist/jEh7WYUdOxbu7dDCHJ
         m7cA==
X-Gm-Message-State: AOJu0YyNp0cycsGwhuhIA7fEGbRJC0pNXiegPnOELEGEGayCp2GOi97B
	MGle1ZCMLbBwOkOdzQZTNIwbVzq429FgOgQ/uyn6wAeAvL36A6YOxqesIEGrywHykSBt6WaqcwU
	H7g==
X-Google-Smtp-Source: AGHT+IEdr27nAL6TTBgRfhhpiXP0Na4QEfa+A2U/3wduykWma3sUjuk0A0CXUovCOClCtXc5FotAoWMmAq0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b0c:b0:dcc:2267:796e with SMTP id
 eh12-20020a0569021b0c00b00dcc2267796emr892328ybb.2.1714068868004; Thu, 25 Apr
 2024 11:14:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Apr 2024 11:14:13 -0700
In-Reply-To: <20240425181422.3250947-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425181422.3250947-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240425181422.3250947-2-seanjc@google.com>
Subject: [PATCH 01/10] KVM: SVM: Disallow guest from changing userspace's
 MSR_AMD64_DE_CFG value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Inject a #GP if the guest attempts to change MSR_AMD64_DE_CFG from its
*current* value, not if the guest attempts to write a value other than
KVM's set of supported bits.  As per the comment and the changelog of the
original code, the intent is to effectively make MSR_AMD64_DE_CFG read-
only for the guest.

Opportunistically use a more conventional equality check instead of an
exclusive-OR check to detect attempts to change bits.

Fixes: d1d93fa90f1a ("KVM: SVM: Add MSR-based feature support for serializing LFENCE")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a..00f0c0b506d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3142,8 +3142,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & ~msr_entry.data)
 			return 1;
 
-		/* Don't allow the guest to change a bit, #GP */
-		if (!msr->host_initiated && (data ^ msr_entry.data))
+		/*
+		 * Don't let the guest change the host-programmed value.  The
+		 * MSR is very model specific, i.e. contains multiple bits that
+		 * are completely unknown to KVM, and the one bit known to KVM
+		 * is simply a reflection of hardware capatibilies.
+		 */
+		if (!msr->host_initiated && data != svm->msr_decfg)
 			return 1;
 
 		svm->msr_decfg = data;
-- 
2.44.0.769.g3c40516874-goog


