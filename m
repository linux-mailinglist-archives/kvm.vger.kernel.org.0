Return-Path: <kvm+bounces-11946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FBD87D723
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 00:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 977AA1F22D31
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 23:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358495A0F6;
	Fri, 15 Mar 2024 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALNQDpkl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66D95A781
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 23:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710543951; cv=none; b=St7OE/5M/Wxm5YY3tKU7xHur7YAVMpuRUq5A9MAI2HhjkCVHMrx4BuF4qqbpJ9IZWEEnibfVjVxZx6wcWAs7F0z9wrqKwLynO5C5hXlN091mpuvR8mn5fUv6nv6gdM7BYhPvTSN01WDnJcdRqMG+JRV9SxmQHYUV2hp/+na1/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710543951; c=relaxed/simple;
	bh=RgksbGdG7u8AJtswXzk4EgEq/WqMCsdEj8clRIpoDtA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xt/J3m5RJkZCRMpkqMnog+N5ZvKCs92B9dzyb6MplpoYfuk9AM8SI66U/5prQtRGFfEFgZcYrt/7k5Uu67xkltaTgAxZoDaWCWO1pblGq6KHV0FwPlde3rB+8IRxPRTTDdCrajjEkTY/jDtUNOB9qsrruCNQohy+deQPGJX8cdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALNQDpkl; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a2386e932so53434007b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710543949; x=1711148749; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksRJk3x87pZ96f9GyVsWOxdyk8h+nYAhCGhZDsSlgQQ=;
        b=ALNQDpklgpJpHF/4U8wr8y0lUnMSxAMmFFvKXI7RSSgXjdVKxZcJX89TWvKsRsOZ9E
         ndDOnXCt/9cu6hQ4hpP8bGs+lX806AyVCOGUrjDsxJVVf6PYEuXgo165jc9SjJAHQDvj
         oExvxAiLSC0fiALh6fSJKivAp/Dk8uI2/wnAai3dyBIFha4stsGMJD7+f45YhpxELp+3
         ++uo2mn6+2dzq4KqJwQJJNGwRfYJ9brkgygsRndBov7+OBE9FBtAgELIh7UpaIlG/3fb
         RbMJcxjnB4gdpT7Lk/irujrDpWkSI9vnLqzvxg/y02fBiWX2D/qDsNLitqS9Z92whhm6
         JY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710543949; x=1711148749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ksRJk3x87pZ96f9GyVsWOxdyk8h+nYAhCGhZDsSlgQQ=;
        b=jjXVNDnGgSIQpWAfbiDg41d935GB3j+djcsn6E51mUbDK0ZqHJjNHtyPV5PYTBlT2L
         Uk1LiIGcsJ+0kM8Ig1diqqFngiOfqliVa+KgtG8/MN4+8YwFK0RJbemcgiJq2AJisxRq
         D8aYNGglqUd5s7STCRQLUkuUhY5jvPpi5KZxoX7zbM1LtpeinEvU+a/jOyMOQjYqEH1c
         8BXWHJPEX0DZejSY1UMc9m96O1ABsw7GE958QKLP7/Fu62l02kF5wToFJQosgQVhVI8N
         YUnU03Xyoy3gt17B5ja7y6k3trdenj/q8cOZpPQOxURToSLx5AOyguS9GrbMn/iDh5Av
         HzMw==
X-Forwarded-Encrypted: i=1; AJvYcCXzGXYKZl014/GrXL3ixOaqbRkVm7+e+DjLOkN21iLijwEkGYDoM7fn3nN0VGlwPDHkcRapQVo70B6lcY8RhRpf+8UA
X-Gm-Message-State: AOJu0Yw21Ujh8zx7lshgG2RhlkSzRcKjYRPRoGTgruEb4jcwWMq+oC9E
	qmh1dJHb8Rn9u8IEhgrlsjlsiQya47X/lltxSNx5JDKqMu8dh1SkuvaCv9NBWNRYrmdpP5Nbyae
	56f4gLogrXw==
X-Google-Smtp-Source: AGHT+IGzhC4ZdWs3utQUbG6j+VuczjacZXFTDw5ktSfLWXz0VqjwH2I4gLaKvg6uasSzJxOVx2PwcoUfthAaxw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:a15:b0:60c:ca8a:4c10 with SMTP
 id cg21-20020a05690c0a1500b0060cca8a4c10mr1478867ywb.2.1710543949017; Fri, 15
 Mar 2024 16:05:49 -0700 (PDT)
Date: Fri, 15 Mar 2024 16:05:39 -0700
In-Reply-To: <20240315230541.1635322-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240315230541.1635322-3-dmatlack@google.com>
Subject: [PATCH 2/4] KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_range,pt_masked}()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the comments above clear_dirty_gfn_range() and
clear_dirty_pt_masked(), since each is word-for-word identical to the
comment above their parent function.

Leave the comment on the parent functions since they are APIs called by
the KVM/x86 MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c3c1a8f430ef..01192ac760f1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1508,13 +1508,6 @@ static bool tdp_mmu_need_write_protect(struct kvm_mmu_page *sp)
 	return kvm_mmu_page_ad_need_write_protect(sp) || !kvm_ad_enabled();
 }
 
-/*
- * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
- * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
- * If AD bits are not enabled, this will require clearing the writable bit on
- * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
- * be flushed.
- */
 static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			   gfn_t start, gfn_t end)
 {
@@ -1571,13 +1564,6 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-/*
- * Clears the dirty status of all the 4k SPTEs mapping GFNs for which a bit is
- * set in mask, starting at gfn. The given memslot is expected to contain all
- * the GFNs represented by set bits in the mask. If AD bits are enabled,
- * clearing the dirty status will involve clearing the dirty bit on each SPTE
- * or, if AD bits are not enabled, clearing the writable bit on each SPTE.
- */
 static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
-- 
2.44.0.291.gc1ea87d7ee-goog


