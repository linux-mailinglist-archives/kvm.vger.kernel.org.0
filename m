Return-Path: <kvm+bounces-7936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D11848649
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 13:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272C31F226BF
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51C55DF01;
	Sat,  3 Feb 2024 12:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Xi5gL22k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377815D903
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 12:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706964362; cv=none; b=GkJI902BqC7l4WnwBQlO70CG/uCAWaPyjZjyaibL4EW3p73zexgJYYVTB0cb0U8hITisrgnXvhxzJshIDdLinbz5lLVGNalCbfMIwQYgOctdMdo/ToD0LV65LBHTrO9/DAT3EbwqV91RZyumBUc6cIG4Uw5n29SV1d33ePbPp5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706964362; c=relaxed/simple;
	bh=XBz/dO19eqCPUEcsTAhFxDMoCs6XkMQB8FUROTqppSA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d48sp2EoFtjgN0oj//pcYZyquEQaIeot8m6qsAp1UOpd527YFHV5QUk6onh0Rm1j4XtOf80p3uf83RBU7vs7m941fmlgT92CPXSUXMcz8SbzFwmfuz0MQtiDcu/36brEOkPDDQc0oC4e1ZkiY6rPg5RKOGpkKZx+O0Wg7aInYVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Xi5gL22k; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a293f2280c7so400385966b.1
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 04:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1706964358; x=1707569158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFcda2O3NqzDf7IyZCYrS8EarLi31HtEhwHagWzWtLU=;
        b=Xi5gL22kClnGsOPfIdWqActeAMoqH7AY9X0DDEv6yvRNjaeKhxqo9OsVaaEJfB/qul
         32woM6bZ8wIbzFoBMEghHOYBAxfmpKilg61ePQLrxV8bYHfmOT8SmZuxmpmoyouy7moE
         70v7dpx+j+FhOb0iQ9SFmZLQBII4Ap/t93iF4rLVRWYV95AoNE3FR/fTrWpOhSex85Ul
         ZHuRX7ZA5SkLyucuIfKfaUruObCYZsSG5KCDQ8EjaK762L/jIuPEloJEt95T20iKD81i
         rRTNwRF9qFnfhCCfZ0u5bOQYSprN9bFfcvBwnTt4WFOYn3LaaSJe+c/JfwTeqmMnceOD
         /btQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706964358; x=1707569158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mFcda2O3NqzDf7IyZCYrS8EarLi31HtEhwHagWzWtLU=;
        b=sTh9i+cEp0B+0GvauV+JZqilMPLWAwc8yGFn1blfBnoc+O+Kq6DhCF7S4JksDVpt7Y
         dn+lJ7Uj4LVEPtDRJ/AA9X1MKhTvyAu0t5s4PSw4Ybni13A66qduKO6zDYCsdNNU74mu
         1rUV6FnDvxLZaVxdd+WClZJPUsy4A0g3W49k6e/NDiHtrDikPDI5vGNc0M2uOEsWA8uE
         sj3FQGyKzlI2mavcVtPfgIKJA08+7XFfmdfpyP7k4Fgw4nsXGSEPK1VscZV/0l8dvWgr
         LjiuhF+jWUbTbcSN/pt8z+CFw/mLsuYrtfsaGPAHyZ3KDEyQrLEIY6heqFgrrAkLEOHo
         WfQQ==
X-Gm-Message-State: AOJu0YyB/aEsOvyTCE09Pw7/cUPBH6K4nzmQxWWRKS07DNUalz03Jubb
	pW6uTELR6esbd78kLLi6uhnVyJuAcqF1CE24ztcmJ3+eWMBjGqbxYxHF9JP/jo0=
X-Google-Smtp-Source: AGHT+IE/8UmxuMROQtSM81U8CGDLixlD/Ih8pjpgLBKAcL3n4tL07qciYMUnYoFwbW2KJz79y0BCsw==
X-Received: by 2002:a17:906:1c59:b0:a37:69d4:b392 with SMTP id l25-20020a1709061c5900b00a3769d4b392mr319322ejg.2.1706964358068;
        Sat, 03 Feb 2024 04:45:58 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUFhtX041ZLvjTS2y/JMOHQU0ODGlyjafr4FPvnTi8+GmW0HE0u0lpy2+mNaEGA7LC+9wfwHO/XPTHf3GjTvUHnltA0Ks492cztJbYzN+B7c5NNB7oXio2ya4HT
Received: from x1.fosdem.net ([2001:67c:1810:f051:d51b:7b6:cc25:3002])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906250b00b00a36c58ba621sm1942015ejb.119.2024.02.03.04.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 04:45:57 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 2/3] KVM: x86: Simplify kvm_vcpu_ioctl_x86_get_debugregs()
Date: Sat,  3 Feb 2024 13:45:21 +0100
Message-Id: <20240203124522.592778-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240203124522.592778-1-minipli@grsecurity.net>
References: <20240203124522.592778-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Take 'dr6' from the arch part directly as already done for 'dr7'.
There's no need to take the clunky route via kvm_get_dr().

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13ec948f3241..0f958dcf8458 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5504,12 +5504,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 					     struct kvm_debugregs *dbgregs)
 {
-	unsigned long val;
-
 	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
-	kvm_get_dr(vcpu, 6, &val);
-	dbgregs->dr6 = val;
+	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 }
 
-- 
2.39.2


