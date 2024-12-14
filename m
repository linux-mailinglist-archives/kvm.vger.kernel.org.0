Return-Path: <kvm+bounces-33811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C09229F1BD1
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 02:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CDD6188E875
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DAEA1B87FE;
	Sat, 14 Dec 2024 01:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fA110riY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D091B4F09
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734138478; cv=none; b=EkjdSqdaqB4X0KnQhOyYFc3Xdrk9D04zICO0VKhd1lhFVdsg+HIGl8Itq0OoH1vfQZnxuE3GoCOHwugmPrMKzdSMouR9hMdExJkTFP7vfpjddbFz1j69yYltPo6/TgYPeXgXhmZRh79JkKrwUCHN7LMbF4yQZ8zZBtDNWlTOBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734138478; c=relaxed/simple;
	bh=pDZnzwMtFKKjkZf545bumaOuduTyj6ts49mWaHJuc48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GwGLPoJ5HQNriZmkYDOPVNROlaMpXMnhH8ypEx2IKs4LbmtVqogBrIXDOfms2t2h4Xjgne6k31CaLWPGWuJFpwcWgdGz9IhpIHdUxo6eU8HrMTbE5J3w0B92hdyEYedTOXweYcTm7mrIFS/l8V8yPUNzBMr7sxj+gt8mUCHho9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fA110riY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef6ef9ba3fso2154732a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 17:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734138476; x=1734743276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kyzGkI3IvXN3TGddEZhxOSkoRVtkhVr6EY69RLW1Hj0=;
        b=fA110riYQ7mzw5tmwiKZ7tpYjPzOM3B4uHCvbg2DixVyaIjotu8vlpuSs+47OdJnTy
         +NQZLKomqM1VYMF8G67Kh2Lja1Vs6Pvsiu/MalWrhIr2Z/SjVaDRqE/fP9mwr5334lJe
         mbgBvZkDjGj85v5OEz2x22X+ONEGjHZivdiaRz23qyCG/Dc6shJdtldXtbVx4sJp3PIx
         YmFaXA1oQfoJJtpiqUsKbsVQxDjotxqpBuGxBzhS/+Mupnw2coVI9y1adnnvcE2h/Lnc
         shRLm4CVi1oB+yYDNx2PJ6+tkY5kbjTlaayOHSe8vSHyMYghyjKs/FJdseSeHTIQHJnE
         wpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734138476; x=1734743276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyzGkI3IvXN3TGddEZhxOSkoRVtkhVr6EY69RLW1Hj0=;
        b=U3xn1Bu7OnsfUdXFvEFEkAM6SiXHwgfS3Vz2LaBjdQUcUCuZ68Fo7agBjIru/tcjfB
         TOSXlOy0zhEuY2+ZDruSuyDqVKoRRo6ZgeBNzb+/rYui0WONmgQnI5q2+k2+0GmbqOop
         utzGAA9hu7qic+giFQxm8rzLMLbRbtZeHdHTAgOZlsgLidME0LD6HGR4MNMY0yTpeaYW
         Awilh96BpWw6ZWB8vnjGBcsbc/hKGRb3OF4XHPA8HJr+w5CNGMmQL4EP2bVZ9qtTeKbB
         bNoOJR8N3BlBlzFbP/kVwTdxy4tQ+KaMWhIKbSJg4pfJyPB7FnpugeqAu6Snp2xVMn17
         6Xjw==
X-Gm-Message-State: AOJu0Yx3xsSHOTIiqjqAni9URUNbqbB41XEyhLZLH4gCyIO9DDdSEBbo
	is+6fwNz/6BoeDpbYReGK/BvbG+jRbTe0U4+1rbT23pqLXcKbb7vhVzWKdQIFZTsTEvviVEB2iw
	S2w==
X-Google-Smtp-Source: AGHT+IHq855LEa56OvCOBHncsQaNtJqisSGX9xNUcKPK+XU9hXvCIFgOs5mq84Ykeo76A1ifl8AZTDtOY18=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6cc:b0:2ee:a76a:830
 with SMTP id 98e67ed59e1d1-2f290d9876bmr7822126a91.24.1734138476607; Fri, 13
 Dec 2024 17:07:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 17:07:20 -0800
In-Reply-To: <20241214010721.2356923-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241214010721.2356923-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241214010721.2356923-20-seanjc@google.com>
Subject: [PATCH 19/20] KVM: selftests: Fix an off-by-one in the number of
 dirty_log_test iterations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Actually run all requested iterations, instead of iterations-1 (the count
starts at '1' due to the need to avoid '0' as an in-memory value for a
dirty page).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index f156459bf1ae..ccc5d9800bbf 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -695,7 +695,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
-	for (iteration = 1; iteration < p->iterations; iteration++) {
+	for (iteration = 1; iteration <= p->iterations; iteration++) {
 		unsigned long i;
 
 		sync_global_to_guest(vm, iteration);
-- 
2.47.1.613.gc27f4b7a9f-goog


