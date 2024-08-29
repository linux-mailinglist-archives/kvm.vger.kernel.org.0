Return-Path: <kvm+bounces-25401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE88964E91
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF1C81C22ACE
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D101B9B40;
	Thu, 29 Aug 2024 19:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BcPzDm0f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD791B5ECC
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724958861; cv=none; b=Q8DfGn1o9UYkduNz4/eAPWmB04VUzoDSAXSPUWFRP2t5pL8VWzQ7B/UkFKW9RUDrgvrCrRJYtJq+kPfu8O0cu5UZhn94LGJnKWjlylLUwey5lSLzBzFqtah2rgNP1Bp8Rbl6Ou/s1D3abVZjwHvFx8k9iXpDPE2sT3ml7l6f7i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724958861; c=relaxed/simple;
	bh=cJHMpC7vgpv1Lwn+ptEjWUCI7ldigKfbsNIq3n90DEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ptNNMe+AbJpyE5JbgitKqrjrbOi0WzXrtKW+ffEdTXZ/NyCPZ7N20W2h8/Jl0JkOxIe3vLWqshASuOnXWohEGD+kHqsTitbmCr7dtPRCmeP7YmQu7RlRfPKOTqqtMA4+HbtzXG/J0oshC8hM3vNkXVwi5tAVnvcak2bqTJl6UvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BcPzDm0f; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-715cdf0a53bso905760b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724958860; x=1725563660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bdd1bqZu2OfsU0H+yc8PooA7Q+uh4HMjeMd4hAZvzq4=;
        b=BcPzDm0fGI3xqgL8F3RvZMpWCivktFPuSTeMPhJRxX6cstQP/vROSY5LrQpf/vNHKp
         JyZW3OuyDi1GRQqcWfNFtJS1qqOL3Vki8DcoRWUF6zCwEPxUiObMnjplf80F75Ou6pD8
         H6dOP82n70OMEMDoAoAJnkFbjWpc+EG0yaFiaO6/EfV4Qq3lSr3U1vzdDU+x3ixTsPpC
         9S6+3o1qkM/iaWtmR3QqQK2rvDY+8Vb7z8KmWoOhueegUZNJheWlNuAohQjyO4eirojZ
         M6z+M/Sz9bbZ5ehRt54G3iHd7wH4y+hUoirv0S3BX/OzxuTR/JQbKEa/0aT/ZfZ+RQFJ
         1e6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724958860; x=1725563660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bdd1bqZu2OfsU0H+yc8PooA7Q+uh4HMjeMd4hAZvzq4=;
        b=UebKZidYHy9y7u5yTQTZ8O7fruTnTQmPHSSTbX68dIgCiI4I5KOz7BZQujIT1HLiH6
         cS0gZ8A+97D7UOnhiKX1hgaIfeUP41umopwiA/QgC87P/eNl346VLgs8F/ZCMQgBbUhf
         DAVipIe7mardWQmkxg9+4iSNxeBzZ6NtM8BTUUcBI4XFRDKmD9/79uh5KXYB1BfVWhoC
         j4u7i/LaFr5poYuyY4OnBPpkAbQnietqC/7Su0D5cawvwtw/1sDFg46sVFje5FG86BLd
         NF9gBC/BjaqlwltmDAXgAtWFLwPbd4kbLxuOOLpIOB/tnphBm6ZtVETvIfrASta86vpq
         Yflw==
X-Gm-Message-State: AOJu0YzlnyOVzclZl5RIkgJ3HeojqHKji0w5YLogdfrXZR3eR5hiO5cx
	pAfqZaZ0Fng/qFbbMXjkVM8ULj9+r4XEFI1gt4XyVYw+ejAHyB3LG5WQmNAoZlpJGh+uqrjA2Uz
	Teg==
X-Google-Smtp-Source: AGHT+IFI5knHr8eDZe+aAWAjZbJUFgdwRoECKFK9pGBCJ6gib+ILUE8raQtt3xxNRmgbuz2VadvCBGfBPsc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:82d2:0:b0:70d:13c2:1d08 with SMTP id
 d2e1a72fcca58-715dfc74100mr8803b3a.3.1724958859860; Thu, 29 Aug 2024 12:14:19
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 12:14:12 -0700
In-Reply-To: <20240829191413.900740-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240829191413.900740-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240829191413.900740-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Write the per-page "segment" when clearing (part of)
 a guest page
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zyr_ms@outlook.com, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass "seg" instead of "len" when writing guest memory in kvm_clear_guest(),
as "seg" holds the number of bytes to write for the current page, while
"len" holds the total bytes remaining.

Luckily, all users of kvm_clear_guest() are guaranteed to not cross a page
boundary, and so the bug is unhittable in the current code base.

Fixes: 2f5414423ef5 ("KVM: remove kvm_clear_guest_page")
Reported-by: zyr_ms@outlook.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219104
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..e036c17c4342 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3582,7 +3582,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 	int ret;
 
 	while ((seg = next_segment(len, offset)) != 0) {
-		ret = kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
+		ret = kvm_write_guest_page(kvm, gfn, zero_page, offset, seg);
 		if (ret < 0)
 			return ret;
 		offset = 0;
-- 
2.46.0.469.g59c65b2a67-goog


