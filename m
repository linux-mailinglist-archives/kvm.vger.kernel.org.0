Return-Path: <kvm+bounces-17669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9796C8C8B6A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3982E1F282C3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99004145326;
	Fri, 17 May 2024 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O0eCM8KV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5991448E3
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967617; cv=none; b=TTrSB487i0Y9e/u2VFD+ECuIAhJGgfLzhiWIqO9bUZjvp+AjtwpRAPgY1eiptWFVT4B5HxL7Y0stzZ6p9PW8EwjW3gIrkXb8QqCcaMP5pO+nlPWErnTJX9zHJD7KoQ0WDKqTTZLYa6CVsSH0JaQ1IEGxF+qbCM0LhHyJUo1giKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967617; c=relaxed/simple;
	bh=CrAZspNK1WyzfzQdMro0gv3zS+R+XJvPdMTGMRibFVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WmXcdufUHrY093YGwonNeMoxd6I0V87nNSCXnrV5rx7V4JO7YISRaugL/PeKqG86JNlCLPmwAIdw3LSYqggtNzeSLpzmxBqWolJN9PWi2lquGYl620L94xH7dv4s7hsrDT/cOhOU3QklREfIub+ILd2NoxI3a1lDMZn862i2fsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O0eCM8KV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61c9e36888bso163284527b3.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967615; x=1716572415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2pz7YgP7vcZ5afCmvotaPNlE5OZ8SYZNDln97glxEfU=;
        b=O0eCM8KVwR3XBMbZ+yXJRvoE+4DcA7e41fl+qXz9Ga4Nk/xt9/QMvfb7snA4EAt5x+
         iAsCjb2dPeRrjUSWzt1Qs0X2UILR+P2kJq884wCchfQ3bx1p3CGljeko+RZjleInuTHD
         /guLBKNFlWzaGoEvB2uRjP3/LoDXAevN4ZCJfdZ8OYKve13BEnbkoYluK471elk5EryH
         HYwVJk9SfGDobxdUNH6myUdB3DnWTpG0pf239oM60eiPX93SxkqJLc4Q/KfILg80tCv2
         CJPbQ9l1aF4Hvlhdfc5yIiEtl9edExeIZPu/gbTc27RRtlYI7Z3yXjpgezIGSCqCl9g5
         ocew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967615; x=1716572415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2pz7YgP7vcZ5afCmvotaPNlE5OZ8SYZNDln97glxEfU=;
        b=OzDChHZvHfJDjYKizGs/AjP08WZem2XMd6AiPDITmj2oXUVDCeQKqOy44i9JBK5mIj
         mtYcsH6nq10OdR3uKwjkayq5P73RZc0JMYLVpCQsI4A9vOfZLu9brtlXYdYlodz8spxn
         WNE2+fP78cqh3yVeVf1ORc+8yWFIBuhMzDMwdXklo31kqUGEUp0w/nN6osv59B+ZW2Fs
         zcYlpB4/40AoI/f+shkaZ5ntJenu9ThTWuaSt9QksVlBo3nQzF3lyAE6fyp+QXnjMwRh
         WhDT8cqNuQRcSV1xzwO9y/m3J4tKPmiBww3bp69NHd78e7vgSGOtIcI9RMIdIifmNbbT
         DqBw==
X-Gm-Message-State: AOJu0YyMF4kjrnVGyVIeddrk7cxLeSFr60iIc34TBdbzfRMDtxhkCY11
	KmRHJ3hKe27WfkGb8qzWcBqLn3ORpb4JS6/zqjEFLJWxjyC2iviKgXyU/kmiCtGWPjh5BZGbv0b
	34w==
X-Google-Smtp-Source: AGHT+IGlXJAyWAakuXQpbosbCs30sIazrsfYtUTXsnWGEiD/GE6CnMOTB9sMMcbJ/UrzL1ENGfQJGk1cltY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6d97:0:b0:627:3c45:4a90 with SMTP id
 00721157ae682-6273c454b1emr16064777b3.4.1715967615528; Fri, 17 May 2024
 10:40:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:54 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-18-seanjc@google.com>
Subject: [PATCH v2 17/49] KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Do the compile-time sanity checks on reverse_cpuid in __feature_leaf() so
that higher level APIs don't need to "manually" perform the sanity checks.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h         | 3 ---
 arch/x86/kvm/reverse_cpuid.h | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7eb3d7318fc4..d68b7d879820 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -198,7 +198,6 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -206,7 +205,6 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
@@ -214,7 +212,6 @@ static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 2f4e155080ba..245f71c16272 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -136,7 +136,10 @@ static __always_inline u32 __feature_translate(int x86_feature)
 
 static __always_inline u32 __feature_leaf(int x86_feature)
 {
-	return __feature_translate(x86_feature) / 32;
+	u32 x86_leaf = __feature_translate(x86_feature) / 32;
+
+	reverse_cpuid_check(x86_leaf);
+	return x86_leaf;
 }
 
 /*
@@ -159,7 +162,6 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
 }
 
-- 
2.45.0.215.g3402c0e53f-goog


