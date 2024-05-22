Return-Path: <kvm+bounces-17912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7508CB8F4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D41CB21296
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80797BB06;
	Wed, 22 May 2024 02:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1p1pLXDr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B929378C87
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716344921; cv=none; b=OIAciR80SAGWNWYd7/9/ERDvJ4kSR+B0Ca2rjHME5H2tZjiO/ShqqvGR/HNR8KHJcX/jKaMxUhLxE99uwEugfTSt8rs66UE5mLaURj8tw2L32IZKR5jxnCAtiiXRDOEz9WyS+aPBjrSbSjF77m5BHZyQ6nIRGNEThcDwvIiV6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716344921; c=relaxed/simple;
	bh=anPM5N+OHWuLglN6BHbuA0ZyXvZryJxlwQUZs1Mzw2k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6H565hl5W8Pqc90oIOwpVrrfa6V5xPJEedi/Xzv7+oqVXEVTcXQzrIWzvZFgMHM4vH5KZxoFElqY0dIR5gJ2wguZOy2UKQK8cm4bzlllA6yRcwuysuJ3l0w5K2tjAw03HvrLeHTCcwORAnJqiWKZLJ7mnzHv2XdyzvLfnb+skc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1p1pLXDr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b364c4c4b0so13253905a91.1
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716344919; x=1716949719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w+U7wzbNqJl9ii7+XfVEw3LB69135VJ3H5IvnuX0LIo=;
        b=1p1pLXDrHSnLRUSnh0ne5QbMLkP0u/LYjrV6a7iE4z8n6MfMhrKpGkhZYaAgZnhNDd
         Svnqap3lGuq/kMPIEwn2hboW9mjj5WOZyeyeR0/3qB8JXxsuiXJPcwBu2A9IeQsGzoZx
         1MThP9c7hrrJBPx59l01fb34C1M3M+1wh21INVWeaHfpEbgsSG4vPMXQMrDCRowJfX+Q
         4VrJtiHe8kqhzqkrZBxq08EUSTzJKIVHV48tkKajcv+3AvVp5Z+QqHTS+5cwPLTs2/Vg
         qpOkUdnHdiRKBL9RSpyYUFdydPFnFA2HKf2gVxfX0AqLmySa4G4QwhN4zJ4NHPUfZIti
         sn+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716344919; x=1716949719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w+U7wzbNqJl9ii7+XfVEw3LB69135VJ3H5IvnuX0LIo=;
        b=RDvJ54RgxaU0QOfr6oJsjDrGg+wgZXtf+C4ps71RkcuRRRZLutUV9RlKCKpeIOfbI5
         uS8h4cAo0J5D92RixBMyZWRPteawGY/nlJatfpx6NIJVe8toxbbf2X8iGizk6mUEnKjG
         dstdNv/2q/6E1juSu35lcMFALkpZ5qBPOz/gh991jNO0SdpMJ6ZeM+iC4HFuEAGIAm9D
         a01ae9Zp522UzEF571pyyR5yQag5c9wHUzrwCFxIuPKydXlTGOkiyvR49RkadFU5C4sJ
         n39pNQKZ2izZ6KxQIeS3EvtRJZHF62EC7YoBfdcbixu2gnQRHNy0RLgvOEQfTDs44Aj9
         pkRA==
X-Gm-Message-State: AOJu0YynIl5mM/DIcFpQe8UQnebu1wvGjWeTCeizudGRMcGgW3aYLI0I
	3VJB5oZnY7xNM7mlRLtTpUDfge1tuh+y7Nu45mY55NOk8NRMIDB1v38e7KaY9VPPJxlOXQ4fHOL
	maA==
X-Google-Smtp-Source: AGHT+IEHUZ71Ny+Ioure2hruFjw2oRt0QpKd4bMsocwR7aZc6kl7/SQ67avYLUaT2vnq64tKh1daPSDmX5I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a0f:b0:2a5:dd7:1c35 with SMTP id
 98e67ed59e1d1-2bd9f6458d9mr9574a91.8.1716344919071; Tue, 21 May 2024 19:28:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 19:28:26 -0700
In-Reply-To: <20240522022827.1690416-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522022827.1690416-6-seanjc@google.com>
Subject: [PATCH v2 5/6] x86/reboot: Unconditionally define cpu_emergency_virt_cb
 typedef
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Define cpu_emergency_virt_cb even if the kernel is being built without KVM
support so that KVM can reference the typedef in asm/kvm_host.h without
needing yet more #ifdefs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 6536873f8fc0..d0ef2a678d66 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,8 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
-- 
2.45.0.215.g3402c0e53f-goog


