Return-Path: <kvm+bounces-7893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA46847DC0
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 01:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15D9028319F
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 00:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C937883A;
	Sat,  3 Feb 2024 00:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MYQpIBes"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5096FC9
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 00:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706919834; cv=none; b=KiWjIt46STqDfa+Przzk0SPr8uFMoZSsA/XVTA6JHuL7o7wnCJJ33mRXjtOAJ/IQKd/WB5q9Hu5jtk9dy2MDVLw1NWSrLGackcZNvQpDSMqXKXgnQ07TI6TNHMcnafrsYkqZfGCDIATD2r8gPD1PbtGm2a1zcJHAm7WRMtoWi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706919834; c=relaxed/simple;
	bh=WRSYmBjqMlFqc1HY3FJ4/F7rWHbJJwswChlMeIjfn2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GfRN9Z/LWMM1CmIZZycIKeYpyG2bp6tQMViauWtDrVJ3xGd9pTTQkmtsezqf8kbhaGuBkRAcLVhmPMLux5tsBvkT4JbZuQ5x7TTRj47xK52uQr2N2Ms9ZqMMNqhgth8zGVfHw1M3M6noDUbQnD8S7p0GWT/fBytGqPxXCRZxj8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MYQpIBes; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6040ffa60ddso52964057b3.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 16:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706919832; x=1707524632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cwT/GAm9mwG3ErXCbNNgFODtOKZ2Q++g1RjuNuyLwPU=;
        b=MYQpIBesBVEjCYCp6g1CTdewc+ZsdG8kpcQH1gDUz5v/sl5O1droXSteg2xJxuamku
         EdEaFpdIMAp9xoHlOn0bAco/w3f2ubMxaTHbGsTQmwqsFWPiU/FWn79kS2r3G7bE9zMp
         m4WI0zykIV2skMPXkZB+uMyeMUA5hM6ltchfwLA2syzY+V4OPGI91q446RHFnAydkcbl
         vyuixMeU/6247uCJfD2c3cpeiV87jXegttCu+/ahB/0CDo8TVWXSykJEst/EMMkz9u9T
         ZF4Qe8y2gMQWYtIv77G3wkEdf3BH8GSNKWCRrY8he48lnBB5G6q145aR/LuqU4Yb3uKw
         abRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706919832; x=1707524632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cwT/GAm9mwG3ErXCbNNgFODtOKZ2Q++g1RjuNuyLwPU=;
        b=myBbodl3q8VVnWtgbDsdKenadX46kfSsJ1D9nUjMmUBbc0MVMopFkddAgumzxV9PfS
         abQ/PKIAn8zmS/A42ZYZhS1bMu1il5k7//QeabOosWwmptkE1y1kJbc7FwOTK60IBkNP
         2xjax0jPZu9gs22gZOONfqCumUzPklsPGPGsxVHRy7d8JUnaukRnefN6JrMtxVZWmjlW
         s4rcXpy1oe8Qipa49SjfmdieZD1R1IT/zU9vjaeiM+nMQWx0BsJW/9clKZOlqPD1mEBh
         W4lT2Qkm+MDQu6+GE4NKglOpzu2AdNKCoLDvbkqEyuRhBlq4AsZlMbsuAy8GFul7ABmC
         AKgQ==
X-Gm-Message-State: AOJu0YzLqJKlXW2N6OVsfRX/FXZBrwPn2mDwhEpcx7zsIMD9/hlQ58sM
	fKW/ytVqfXVM9dNwmlA86gpXDrtlZnTHy1qTRh0kXSQIN+KZ7uBN3wsHFSvX8CYZ1sWH8WymrU3
	zfQ==
X-Google-Smtp-Source: AGHT+IF7YoTc6bbRQGeDGj5CJ6pUb22TLJNw++X22QdIvPDWhovn32KwmmcnsiuT11YXA4gLI09YpltZzVw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:9:b0:5d3:5a95:2338 with SMTP id
 bc9-20020a05690c000900b005d35a952338mr939298ywb.9.1706919831997; Fri, 02 Feb
 2024 16:23:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:23:42 -0800
In-Reply-To: <20240203002343.383056-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203002343.383056-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203002343.383056-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: x86: Drop superfluous check on direct MMU vs.
 WRITE_PF_TO_SP flag
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove reexecute_instruction()'s final check on the MMU being direct, as
EMULTYPE_WRITE_PF_TO_SP is only ever set if the MMU is indirect, i.e. is a
shadow MMU.  Prior to commit 93c05d3ef252 ("KVM: x86: improve
reexecute_instruction"), the flag simply didn't exist (and KVM actually
returned "true" unconditionally for both types of MMUs).  I.e. the
explicit check for a direct MMU is simply leftover artifact from old code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c502121b7bee..5fe94b2de1dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8804,8 +8804,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * then zap the SPTE to unprotect the gfn, and then do it all over
 	 * again.  Report the error to userspace.
 	 */
-	return vcpu->arch.mmu->root_role.direct ||
-	       !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
+	return !(emulation_type & EMULTYPE_WRITE_PF_TO_SP);
 }
 
 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-- 
2.43.0.594.gd9cf4e227d-goog


