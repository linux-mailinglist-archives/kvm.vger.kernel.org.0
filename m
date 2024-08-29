Return-Path: <kvm+bounces-25400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F837964E8F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBC9BB22122
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226F61B9B22;
	Thu, 29 Aug 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TmvSFNb+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37C8335C0
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958861; cv=none; b=Px0TYkExtrrgCVOnUi5N8Pjy9BwO7SGUGRCeOfjW3/92kD+2OUeAJ6im2Nri3oV8q/JEecXwYlZpv6PGtKorXIJIl7Te4WrcxHnS2iS9xh5wcvLsy9MPDIDbRx1MW+I7zKOeQJ5SMYRVv2D4LoaYOBidF5Fs4xxio6m3wATlcIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958861; c=relaxed/simple;
	bh=3ihZFdSEqCkOi17M7s9gPAVnOPUdI1J930mgVMZnkTo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pv6itK1DvCBKmpxyLid3pWjIRrMDMTY0HMDllJw8Zik7TgyDjuyxACLZsr0HG7Mjzonv082u3Vjr2vEbkMAh60mC9VHHJMhCLjk4Ub+X+g/qrFlg5ycQscH0E01DsMozd9Wbkx8xJZhho1zXHczG03qauAZvq2tLNyXfPuwmK1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TmvSFNb+; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so21963907b3.3
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958858; x=1725563658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+yNi/2gUEYwFAHpyM6HNoTobkXRLYT3JYSGmiCYEUg4=;
        b=TmvSFNb+uZDKzA23ymFDCiCuBNCbZ74uF2Myjz42i8JU/yuXbw0rHVECj2Lrjen1f2
         YaM/5jK6OC88DpFe0rB4XSgbZ8pfTIIxcbUT1sB4udLJoVq/Fqe0dtrnnRLl3c4h1hZM
         5ForINhzEGPE6CBMcZlDT5wWQViijd4twkjz4vy63N86idvE0v2f9rdd4tPWl0wrKR96
         c0Gks5QQnCpg4jQYfZMA9SxRkz6Rq5+MbOt6pJ1H5QJBzadH++s/9csPTHxUq/RJUyuo
         zcGTpvfWjBqoL0rMPy8KNTTjKkeLte9yF+Aoh5dcbIrCoiHyAKeZqXn/eKtfOFXSv5Rp
         DrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958858; x=1725563658;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+yNi/2gUEYwFAHpyM6HNoTobkXRLYT3JYSGmiCYEUg4=;
        b=ScYa/UjAC1BezCMLz8nqYuiinsqdIxCCV9MJ2kBLKPMmS+ra3741ieiL3ql+2zuYY6
         ujru0MgrwRNku1MX2WGXQVssCcjv3d8DsUMOqzgZvD1ObOw6NzLMiQBTyTaJl0KIhPv5
         wSaWOe5hTgGXnwSQAUOOfYKy3pikea3gSJdt+wUlwFU4rJ/UDogcrpXd/A2hbFViqdFU
         fA9OM+DXXSyd6gB7RKH79acHllSCrNM+TvWnQgVIOYS+WyPfZt0iT6c5v1nT4geqJgdF
         3SteAWkmaEkMMwrrkZjHQCds2wMNM/+UjrbmyZdvGfors962V27YANIoGJ2Ug5znumtl
         Y89Q==
X-Gm-Message-State: AOJu0Yzy4+H0ut/vjjKaOySO1MJCLaNo6FLjApfUIYNxZXo7CAiKmeX0
	Z+78d+8VMQ2VtXFKGaOZzROTbRjfqOumnkgikcSfesxlzlJiG6US6bc1UiX9aht8hQSjRqUQVOb
	yyw==
X-Google-Smtp-Source: AGHT+IEoko9lM2Cr4EkapVN7aPthtXcg3RKZFe18VO+/tiwZ7C/cx6EgQkkvEX7aeKRoeE0+0oMX+ADqS6c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2d0f:b0:691:41f5:7f3d with SMTP id
 00721157ae682-6d2ef1cfb3cmr81527b3.4.1724958857795; Thu, 29 Aug 2024 12:14:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 12:14:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191413.900740-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Fix a lurking bug in kvm_clear_guest()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zyr_ms@outlook.com, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug in kvm_clear_guest() where it would write beyond the target
page _if_ handed a gpa+len that would span multiple pages.  Luckily, the
bug is unhittable in the current code base as all users ensure the
gpa+len is bound to a single page.

Patch 2 hardens the underlying single page APIs to guard against a bad
offset+len, e.g. so that bugs like the one in kvm_clear_guest() are noisy
and don't escalate to an out-of-bounds access.

Verified and tested by hacking KVM to use kvm_clear_guest() when zeroing
all three pages used for KVM's hidden TSS.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..ce64e490e9c7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3872,14 +3872,17 @@ bool __vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
 static int init_rmode_tss(struct kvm *kvm, void __user *ua)
 {
-       const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
+       // const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
        u16 data;
-       int i;
+       // int i;
 
-       for (i = 0; i < 3; i++) {
-               if (__copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
-                       return -EFAULT;
-       }
+       if (kvm_clear_guest(kvm, to_kvm_vmx(kvm)->tss_addr, PAGE_SIZE * 3))
+               return -EFAULT;
+
+       // for (i = 0; i < 3; i++) {
+       //      if (__copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
+       //              return -EFAULT;
+       // }
 
        data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
        if (__copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))

Sean Christopherson (2):
  KVM: Write the per-page "segment" when clearing (part of) a guest page
  KVM: Harden guest memory APIs against out-of-bounds accesses

 virt/kvm/kvm_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


base-commit: 15e1c3d65975524c5c792fcd59f7d89f00402261
-- 
2.46.0.469.g59c65b2a67-goog


