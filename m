Return-Path: <kvm+bounces-7626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9182844D79
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C9741C22B2B
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1AE3CF45;
	Wed, 31 Jan 2024 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdSWPBrH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832CD3B197
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745376; cv=none; b=bmPwlf2Z+HPBdlREXK4r48UkAMU3RCJnlsU3rpkXiyFQxek+hG6mO5VTuSPufhqX7ZcG02BEpLSmAoAW9WFZzg0OLLVE7hLrcdtQ3OdNYpLH3kFH5uh1Ef6K7OYI22CLoESiviI7TsjCLWv1+60enkGCFfxjZI8A8HeGwQunZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745376; c=relaxed/simple;
	bh=C2Mp5wDF+w5HYei1nLihykDqJ+peIrgUvLAyytBwPBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=shkvWmUSeqtHwMaAEJjkeyd8+7h0HENR8YdQIbEuf26g/MkLBYViD697QP//3ym4hWa46VhN9DbQxwZ/8FzHe7/gsALBs8/McWltMD/pvXXsyfLKp5az+vZsbVZyF9nwD62GBypvyDrS7wcwYrDmg00O67uBl5qofud4zRexzMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdSWPBrH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6040ffa60ddso6723587b3.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706745373; x=1707350173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CQD8xVAMwqMOWi6PTJB0HJDtmdm31D4WNpxMiUSqPiQ=;
        b=QdSWPBrHomk20lzUGbh0sGV4DlQIZgWvcIOlSeU+SvoGq4ZqXlm3BAeLhfaA8+1lv8
         mMJ2JM9bYLHtBdN4+utWr47sJlauQ8DZjxoadFqKfIv/SGjfd53gidHQU1itQuBygbYq
         21AC1wKE/mv0pxC4S1u8z521kI9bg8UJFljJdyzhCr6OJ6Si2ZSAtklEO28JduH8XJOc
         6F+bljjU5K7OqwB+N+IFWxZAFqI9+FpEHv/9YJiEFDjw73kU07ADdG5AR77DAU2//z5l
         tdPPHsaa/KdYvbLrzWufCdkIdk8Q8ODIUU9HBsFWn6NYu341dvpFT7LTTvOS76FUzErK
         epzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745373; x=1707350173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQD8xVAMwqMOWi6PTJB0HJDtmdm31D4WNpxMiUSqPiQ=;
        b=l6Au9OXFAO0zFQLCV5NKuez5ZIu+s7rQNk2qzp9erPwwYldEv9PYIbhtdSmRqjVkUX
         jHsVmYQYt3CUjIxlhcBPUFo/Wo0Yg02m8wx9ShYl9xFiLMl8SGMFG6e6jnnwMTHm+46I
         LbuThSDSMiwl5JMzpXfDYlXUpj5rKQkwAWzE1CURM0tJJFJ8uTt8mX26K4TpYPJCy935
         l0DmXKjAlJpCHHHwMEPz6vQ5d+CIylUk5lFDF/nVNNEQZEpx6IUFcXLtPJcV6Eb+A91Y
         LXGkEnL34UHR9NsCPwVtrRpAe5DqwvYGmSMn4knckFsP5NIW6pSYlLeTiOe3eGEAhxTy
         IlLg==
X-Gm-Message-State: AOJu0Yx9eIFSMV+U6zFrvJV8aujkrULhl+fuVqlGWpDGzkBafPXPcAa3
	KJtq9nJDeydUTds2yzXU1QplaNuOwA6FFftIXI1vJclzFHJqgHs8KJ5cO4mIxcURSSuYdf//l6V
	VzA==
X-Google-Smtp-Source: AGHT+IFEng8Bm/KBVwygkVXasRuf80ylGucwfbCrR5PDNSdg9SWzRiLInuFRXQK/bBefwUgzcl0fGDldrs0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1385:b0:dc2:3441:897f with SMTP id
 x5-20020a056902138500b00dc23441897fmr859913ybu.6.1706745373557; Wed, 31 Jan
 2024 15:56:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 15:56:06 -0800
In-Reply-To: <20240131235609.4161407-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131235609.4161407-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131235609.4161407-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: SVM: Set sev->asid in sev_asid_new() instead of
 overloading the return
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly set sev->asid in sev_asid_new() when a new ASID is successfully
allocated, and return '0' to indicate success instead of overloading the
return value to multiplex the ASID with error codes.  There is exactly one
caller of sev_asid_new(), and sev_asid_free() already consumes sev->asid,
i.e. returning the ASID isn't necessary for flexibility, nor does it
provide symmetry between related APIs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f760106c31f8..7c000088bca6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -179,7 +179,8 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_unlock(&sev_bitmap_lock);
 
-	return asid;
+	sev->asid = asid;
+	return 0;
 e_uncharge:
 	sev_misc_cg_uncharge(sev);
 	put_misc_cg(sev->misc_cg);
@@ -246,7 +247,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	int asid, ret;
+	int ret;
 
 	if (kvm->created_vcpus)
 		return -EINVAL;
@@ -257,10 +258,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev->active = true;
 	sev->es_active = argp->id == KVM_SEV_ES_INIT;
-	asid = sev_asid_new(sev);
-	if (asid < 0)
+	ret = sev_asid_new(sev);
+	if (ret)
 		goto e_no_asid;
-	sev->asid = asid;
 
 	ret = sev_platform_init(&argp->error);
 	if (ret)
-- 
2.43.0.429.g432eaa2c6b-goog


