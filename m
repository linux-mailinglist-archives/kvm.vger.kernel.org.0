Return-Path: <kvm+bounces-63127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0957C5AB8E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1FFDB351F39
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28D3218ADD;
	Fri, 14 Nov 2025 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/cJTrvj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27DD1F2BA4
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079185; cv=none; b=fc/LQpMWo60dxNyBnm80FsMgZdylT4CyT961u+ODrvrwbEDWURA6+LoB8zwsg7J8G0Yxghs61S/D5ZM2FFrO+YxjphWFMYBXMskFx9wlo8jQIVDHgdXHw0154seu5ukzIZy9jNJ/QfDmK7+f39odgjYpgxT3kqxvXMxum8Dw0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079185; c=relaxed/simple;
	bh=eIqtDfrQKAY6dEeJvappZJF/0M1GoVAepHzSTWRXcQ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=atls6xmsZrwYoFebJTA+EocoRkOjfQTj9vjN31049V7W8agHBUZ/jyrVeW9Xz6PY8AFSxLHTurhPZdRYaAB86MxOzTHsAuYQc/nCRCTZGw2JQ0oyEIudkccwCvZuJDXxp7rom+xSE7ftZ2l68Jhm6zaK0ZvtUFCGgNTrk3oLarc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/cJTrvj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c07119bfso3695879a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079183; x=1763683983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qgI0XQare4UcKjCJWB+gNnJWx2rnHxdgjcdt6NDVgzU=;
        b=Z/cJTrvjXytoeo/Jb4TkzGhaBnuX9fJ2PDbC57RLSznGFc/7E95Qe4HAQWGsvvEWc/
         JfxRWXIu093Ts8MxZpObLMq5ythuMTOWvXE8bOHMaxKZFKQvCKp3Howm8Ti9w349dQMO
         XvWlrsgCxOzlJXN0Qh0oFs6l5u9IAjaNZ2GYOWBOz6mSh2xAD9nGHES/91tffjT8Rmnv
         rcZxXqeYMz+R4R3iVl7WopLp1g1zpApeKIHVuJO3A8BAEdwA8US0G5C7SUn9HsCOmCvV
         NWJTojfigeF40AmhWttUWq/VvIoAkDsb3jo4aXe3c/JUG/5J+1dPSdoKsHCHDw36162p
         WglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079183; x=1763683983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qgI0XQare4UcKjCJWB+gNnJWx2rnHxdgjcdt6NDVgzU=;
        b=G8kfOJgpclj1Ni7Rq9PINtT2vQKTOuqVsQhh9ngZ5l5NUj2+dA77aMuBfhcgyKZLtD
         A96DDvjGY4wCZzQve1Ie53BHpC92sk0163wSGL/riWWvllRIn4pMo4aI9uJmW+4o8qra
         76KAA7Jf4P1ZjnJhhoz4fUkJfhjq5XsTKw06NjCPxja8snM7SyOZEjl6+0h+y/Rz2fox
         x+abm7MCTPfXdIP7eqVaJGhlqM+FiHyC0krjYcaryenv/o6BoZ0AKPJaNseGVZ9aeW+d
         +ZfK2WsveiEnc1hfS/9P5sH9esG2j/KwGr82exg+WinGFt9WTz400Mi+yu23fIxQPszR
         5Zyw==
X-Gm-Message-State: AOJu0YyDM84RoRGUjbY6CTw3aB4u0JHxIfiFuly43PE5YNag/NLPtOFx
	IGPfl+zPx9ytmitQd+x9iX15jTjtNo0qe4S5PNVmvGav8MOThVna0p6+4g5vNgJQEIRxJnnzDgi
	E7kVKJA==
X-Google-Smtp-Source: AGHT+IFvxsMigfAHVsQHgLCxshbLJ1kUPznkwA1dntfyeNhMAiFkK3vKgBT4G8vaT+hG0jgsRsQIIl62t5A=
X-Received: from pjut22.prod.google.com ([2002:a17:90a:d516:b0:33b:51fe:1a75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f08:b0:335:2eef:4ca8
 with SMTP id 98e67ed59e1d1-343fa769fa1mr1282974a91.33.1763079182955; Thu, 13
 Nov 2025 16:13:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:42 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 01/17] x86/run_in_user: Add an "end branch"
 marker on the user_mode destination
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

Add an endbr64 at the user_mode "entry point" so that run_in_user() can be
used when CET's Indirect Branch Tracking is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/usermode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index c3ec0ad7..f4ba0af4 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -68,6 +68,9 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
 			"iretq\n"
 
 			"user_mode:\n\t"
+#ifdef __x86_64__
+			"endbr64\n\t"
+#endif
 			/* Back up volatile registers before invoking func */
 			"push %%rcx\n\t"
 			"push %%rdx\n\t"
-- 
2.52.0.rc1.455.g30608eb744-goog


