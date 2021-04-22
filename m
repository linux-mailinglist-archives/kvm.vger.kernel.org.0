Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F74236779D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhDVCz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhDVCz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:55:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082D3C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:54:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 137-20020a250d8f0000b02904e7bf943359so18330178ybn.23
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Jb1cdGutYwWw/givKmt3Bb+yg+wB2IwgsnaOdWfXOpU=;
        b=R0hKlBwz3cwKsOW3FhtoV33AWD+Lvy6eSAr8VoSJy6Q1fhJ1Ey9lBIOZ6oHDX45ABk
         8JzXU+ptDc1rkaJuxHoZAkxm6AP2Ivz7aLtMAyOnaUrwtR+gXRpYDdyjSe24htGbkR5Q
         Nlxi1MBB2joyB7x8PNjNg/2Wyi5K6XnEDJhJiXpNR8W4KJQ/jaIgy6xm9x20CUTPzpVz
         OpTgDH3nvblR6YDTv3+fk5oG+PsKRSSmdMzi5tAjLc2HmZlt6gt9unpNnHCQkdmDzg8M
         QMeO0dWMpLkVFcxapYJ7QqJZ7SDcgUfUaLHZhzvDKfw5NxBzIKpkNbiCQl1TFT01P352
         yEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Jb1cdGutYwWw/givKmt3Bb+yg+wB2IwgsnaOdWfXOpU=;
        b=FalrZ6rVIEeMgxsQSFf5B8euVdYIjwbfv3SFqsLMG15iSuytpzhb9ApqJ0NtC9qou9
         7KDMFci+4DNKxRTvv5oTaVXz2vuJHJZFa0CuAVdNFaBCsMF/8GjlS0wNd9fEYT6It+F+
         Kop40oQF/1uZlVV1ID1562wJQiUwPPYHkJtyTLvk1MNriqPY8ePsJdvLzklKG8N6GE54
         WHTrfCrWU5tDmRhntLTbVXBbkw5rmKL+HqO+Y/s/g3lQKDAA07hewRUciGufhYB2cBV9
         o/g1ZOFsMXMyqflfabvWAQdL8cQXB8fSmbveTCAF35pOkU2D+qTQKwvg4Iz0dwy4W0dA
         eupw==
X-Gm-Message-State: AOAM530BW4SaNOfVzoCgQGmKdqZkAoyXhNIRITpRtHe9BCLDbR6AKUR6
        KvFZIXTFmfY4q+UnuwbHHxczjC+h1iU=
X-Google-Smtp-Source: ABdhPJyThF/SMzswqaoyFI93YazXMDM/f91OEVBFWE803D202/HmOLSY1sZiW5WAAffRRinqQFGx7nHCJwc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:aba9:: with SMTP id v38mr1680904ybi.67.1619060091313;
 Wed, 21 Apr 2021 19:54:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:54:48 -0700
Message-Id: <20210422025448.3475200-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [kvm-unit-tests PATCH] x86: svm: Skip NPT-only part of guest CR3
 tests when NPT is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the sub-tests for guest CR3 that rely on NPT, unsurprisingly they
fail when running with NPT disabled.  Alternatively, the test could be
modified to poke into the legacy page tables, but obviously no one
actually cares that much about shadow paging.

Fixes: 6d0ecbf ("nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 29a0b59..353ab6b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2237,6 +2237,9 @@ static void test_cr3(void)
 
 	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
 
+	if (!npt_supported())
+		goto skip_npt_only;
+
 	/* Clear P (Present) bit in NPT in order to trigger #NPF */
 	pdpe[0] &= ~1ULL;
 
@@ -2255,6 +2258,8 @@ static void test_cr3(void)
 	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
 
 	pdpe[0] |= 1ULL;
+
+skip_npt_only:
 	vmcb->save.cr3 = cr3_saved;
 	vmcb->save.cr4 = cr4_saved;
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

