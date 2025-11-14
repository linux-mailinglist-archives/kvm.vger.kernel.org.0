Return-Path: <kvm+bounces-63271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6702C5F4BB
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7702352154
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC3834AB1D;
	Fri, 14 Nov 2025 20:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8SNSrBg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4434A771
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 20:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763153493; cv=none; b=jyVVUmucXa8wzxswCOKW1pL9nnn6Pt6r9bOYen/JCyicoZCtIdwa5sldabp4a+2w0ZW/0SZTEr6DHradsW83I9IiaFJD0Zh4zGGm4covTlF8tXNpP/UbesLA3kUEYnY8t1uFNGTIZrSqLwwg6BYwdr1BfZWDUpub6pVwUJyt9Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763153493; c=relaxed/simple;
	bh=SqXckPDJ+o3A3t4AlReWdHvXi90OaikHWVd68EnUYSc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=prt78+eYpyFdk7wNJQHo1xndTp4G7KqLVSLwPXTPf28J/0kmLSD1ATw51b3Czj3qqPQxyAY9vWmi8c5140CY9a6b94RLogH8WurttYaQ1mEn/GzQmPIbzPla0AHTHPwX9za6g/cjI2767aHMHRKDOar2SQeNvLXhmsUcQaDqVeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8SNSrBg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3416dc5752aso7167015a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 12:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763153492; x=1763758292; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HHjSaAzGp9KUls8hr74vtuNXV9xH2tcbQrAl2zegDzQ=;
        b=p8SNSrBgGE5MCThdb3muqILX9zqiEaFKxjgqUU3J6Cw+f8Gk5p440eB7SNjKZAhgBD
         D3vDAi+g9E2PnAVcH7KOuPB9kXM9NKzZXSv5bwc7xPEtS/wHresxVXwPltC8x76xUd7i
         sJgzzSHR6NyKQ5FjlNmqDJ4v03XKdlcsx9oS+3YnVnNPwJmzdsiX9WIT0vqExUExtx68
         4LibuugXt+KMFaKPa00AiooVZ+UiTEG9FkwPGmhkJ/bhkcqcbGej5vyBjpJ5QzHq1Oio
         SucWu6h1QNzOjMeCzBB4Epne/+m9Wyif42vs1mcPhHMtirNm9x9hH70KTErXtQtWllRy
         s5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763153492; x=1763758292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HHjSaAzGp9KUls8hr74vtuNXV9xH2tcbQrAl2zegDzQ=;
        b=bMsgbiTf5PIiwjQTUMgWiN8jkgyWjjtVLDzCrRaSoDoiGBLppu2Ct5545XMUcYU/H+
         jxzXp7HEgxCyBhQWHPJ2uxLMmnhZSiGKj7QncfSsvNziMssemQMhfuH9Kb3YLMPj+7mC
         ntLLOWRxR0nO+1SiupMyPTbg+zk7bO6TzdrdpEzrHMQ5oi3Xm3s1PZR/c/jl5iUnFj4G
         lgmIv9HPgAvbAaf1BeqvQEkKv5eDWxsbVzcidJ3HPe/aO+ISSE+PLMdFR/Gh/zMsGBB7
         skfFoxR2fIvSex7Xhv0kn4kXEPfOJa9pHX/1LHfaEg8TemaWUce73P7ntMOjbhfjLznK
         8/FA==
X-Gm-Message-State: AOJu0YzBC8xFqmngdF08wvc3hoKyS98DYlD5bCq15Pgo+spmYqz/94NY
	zeaaaaJeHNB5o86Artc9BrkkrcQwzDMv1ttrHuheEWA8XZeCkIGEFC0z0euAykQASYBlIeScF42
	aeUzliw==
X-Google-Smtp-Source: AGHT+IGH7q24bC1Hy9h5YpR1plATto1/32K5xbzrZl2nG/aDwczkxmxwIYF2Oevq1JckXb6jNZFrRT2gmz8=
X-Received: from pjis1.prod.google.com ([2002:a17:90a:5d01:b0:340:ad90:c946])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5746:b0:340:cb18:922
 with SMTP id 98e67ed59e1d1-343f9ea60d2mr4979521a91.14.1763153491815; Fri, 14
 Nov 2025 12:51:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Nov 2025 12:50:57 -0800
In-Reply-To: <20251114205100.1873640-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114205100.1873640-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114205100.1873640-16-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 15/18] x86: cet: Drop the "intel_" prefix
 from the CET testcase
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the CET test supports both Intel and AMD, drop the "intel" prefix.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ff537d3f..522318d3 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -510,7 +510,7 @@ file = tsx-ctrl.flat
 qemu_params = -cpu max
 groups = tsx-ctrl
 
-[intel_cet]
+[cet]
 file = cet.flat
 arch = x86_64
 smp = 2
-- 
2.52.0.rc1.455.g30608eb744-goog


