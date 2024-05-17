Return-Path: <kvm+bounces-17686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD058C8B93
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A535E282560
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153C41553A1;
	Fri, 17 May 2024 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YeP9VDvf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58BE155390
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967650; cv=none; b=Xc9lG1j0p5R7aainhDK6SMAFO/hbS/PQsRweSZmFjuWz3kgjMooBPwTxf0BFpF0TUcGIzJt8F0sbgA6te0nFM0UY20medsNVkNhEeo3+5Rc35yZPqFfZL65OWdT/l7kuUFTjhIjfe7Qgy0U+mHQK30gErR+OQ67UEUUOpQbl9Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967650; c=relaxed/simple;
	bh=MOt7a7eVZjErDMDDNmU9MZ31JPtIJ1yFe6IZvXt2XBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJ03mOcLxv76DotaITXW52e4blJt+cx8azsz0EOcHtmOt5JWisyAZ7ljQlVf2vHkuFnWbliiG0cZJkPI/Gz7xbBaKHkvF66PvcEeHn61FbLbHvDIYII0NZbkYc2bDaa4+mPULL3iLMyOZ08zNMr2bNicgibY+1Scf78qzPvA/+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YeP9VDvf; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be621bd84so150821477b3.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967648; x=1716572448; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fU8sq/AkEJ2xM6e1kKBCrj+vGTO6zKbUVxTUOdmW3f0=;
        b=YeP9VDvfIq02/yUcAv0lztPJvC3x0XGxUL69wiwHw/LJ7ZCBHVfgWA9M66Md7WpfuJ
         EtcdQSv2vq9kdNsGMIigY0QvjoxGylkxtXwBuwS1fuz9Q8EXz4gv1G6eP8EHTJkshktt
         fTRcRFAqS9w0jCvUCS1wOlX2nMPMJJVFyYerGfAuU6MCRbmKLXrXwXPx0XT6VHM3XgVx
         0OrDropj1/PQWq83OYEBupDtu1m8uIotS9wTV3IOk9Ww7w+aukmumNFgW/Ck4aqbjWAK
         BI5j8JEgaUGuApM6SrixJ1Q6WdsoLWKUXq3OoMqrGJFfqKXMPXei58ZuiUFef3F5XW2k
         xvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967648; x=1716572448;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fU8sq/AkEJ2xM6e1kKBCrj+vGTO6zKbUVxTUOdmW3f0=;
        b=CVpj1NIwG4ldYn9TlGNJ5XfQhO7UKBmAy3Bv8J5kMzUpiypdG5YhgtVuOLn0PWLuM3
         WWr6RU4xCd65eb0hnKudgs2IY7zAitBCDcYampCarfHBdFwixMv+hu1oRNLT+3ot0JQM
         F0GglmVu0ABSKpHNnKllFQO640zwgSDVOHhxpwf4yseFVaq70gKvCqVqnyJjMpLKz31s
         lhHk8SbB2TSApzOHltm3VtF0VzR4YOUU0mgtXVyz7VvNRcMdEeuCq0jj8xQmWdCJSu6w
         PpxDM4DhMTkFZKWdMTGzqQRRLfVmb5R752eJVcF/35TkZsjmxcGq1rxJfzI1irTQ+fp9
         nowA==
X-Gm-Message-State: AOJu0YydTUWpTDoJ8hyiDhur/TL9LYwyzmlS91VKmNiSqjl3so54+ZAs
	hymP09znn3Fp9ZxnbZMqlDMjjGb+el3fvk7Fdq9uEoW9f0FURk6hDMnfJ0rdBiTv755ROI9mKAH
	ajw==
X-Google-Smtp-Source: AGHT+IGvBB4ynVI/ZC3TlbuQG8qS/BEUmawxsUd8thzmy3BsKmQ5z6aH5Ogto2uOeUGRdD1Ol0+z7FiImJQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3804:b0:61b:1d66:61c4 with SMTP id
 00721157ae682-622b016d66cmr45344297b3.10.1715967647859; Fri, 17 May 2024
 10:40:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:11 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-35-seanjc@google.com>
Subject: [PATCH v2 34/49] KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Unconditionally advertise "support" for the HYPERVISOR feature in CPUID,
as the flag simply communicates to the guest that's it's running under a
hypervisor.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d1f427284ccc..de898d571faa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -681,7 +681,8 @@ void kvm_set_cpu_caps(void)
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
-		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND)
+		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND) |
+		EMUL_F(HYPERVISOR)
 	);
 
 	kvm_cpu_cap_init(CPUID_1_EDX,
-- 
2.45.0.215.g3402c0e53f-goog


