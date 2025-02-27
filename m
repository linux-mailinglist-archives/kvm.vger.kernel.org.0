Return-Path: <kvm+bounces-39484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 173E6A471B4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250F0166AD6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C72617A58F;
	Thu, 27 Feb 2025 01:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvJxePCS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E06C70814
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620954; cv=none; b=qXh9VlDQWfnr7o+erPTKiwTADodt5qro83bHn9zKKgjRCDzbLP0unKj8XCqp8sY/g/1UBrltl7KUR/JS4SYIskZH9D2vFizXAiQdeU13hS/d6DtIxeweGBq+AsD1sEu8scWyA569m00XLyNTFMT6qNZlAwhAAFMI3hA3EaPpaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620954; c=relaxed/simple;
	bh=LsOPwUOC/QmWTWQha1SKJbGEsKJZ/1O5A6HaXw1KHdw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WrEbI+TpWPo5g1kRxM1buTSgzY66FOnrzUsNXKwgTi6yOcpBdSF7yiP7RbfVDKuiukUoZY+XuoYkst6+fGzdmB+xQYbIn761K53EDEJ5I06bwEalhQMtsyfBQOvZGICrLuR67kM63PKnqhWP0wPLX8IS19C/CnFoAycNmIvJOlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvJxePCS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so1434933a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620953; x=1741225753; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KyfK4MiK7b3lWIMmmLsQdRJWDqYklk35V7aidIjSERg=;
        b=YvJxePCS35AgOVa4nuJ8+zGUC5gFcIIJfrURfQZ0k9Z0zFeVLYJaB7pzIYXA8hFXxe
         UnYhMoRWWxAGvFq0nABlYb2qyN1WpwW6gJXlgdIT/8IbxmchwHIz0ooAY69UDlVpcBCu
         0Fqm86D3+nhmtcak1UZ6ydEDP+rM4qWIhnuN9Fmivb8evCxEQ8zy0m6ZUhgAy/YFuNnv
         pa1OZlBXmuiJHYSQZH+BurzUe9N687M4G45s1i7jI8RfwTVoZV+hxDrk86DBkye7TP8w
         +GLcqmYx9jeptvsvARkObHCMCMTYHlJPk84zbMinjjUM5SdfNcSTTp+eEvj0pIudIff1
         COxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620953; x=1741225753;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KyfK4MiK7b3lWIMmmLsQdRJWDqYklk35V7aidIjSERg=;
        b=pzUU0zoN8dW8at8Ck5seWN+v8YpOpGEZyQILQj9G0U8YnacAUOU1JOCZtr1Z/FHy9C
         1wczUitGNHUYuK2HMYcHY/r/LNd+l+aetzHeU2JLKUnTioLKdr+EDu3PWSA1X36YU/DZ
         pWcpqzzjvNH8L7IR9AnM+8zYE/R1MAAYJnx2x4RKSZChlesneegOnJIaYmRNqjV6wi0/
         iDUn1pnyrrCIqYnV6Rxg5TIDfX0/E7Xav00I7bEB2lmZGO/3VD5dr+af/kiELu8aEn5w
         ua1/jiw/goAyXb8/GHsn3RFaGuqK8LU+XoPSXNmMmwe/Of3JdtnSC0v0tdxAieeFlr1F
         QhWA==
X-Forwarded-Encrypted: i=1; AJvYcCV+r83/XBXEa7LfcxCmepQb7g5rgXo3wddtazbTKzDb6IaAK8MyM4vDoKp9e7c00QB9BZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf+kO3LahnLfzPz9OeTcZ5mtcxanOlInpVaBQjuOOVKN2Q/sZ6
	glKDE2MDh7dSndFjfcI7Eotf+YHN2XKOaRtMCuZDd1cjzjwIUo2IDfPEg3Hoi5FoPpNVSpOl+Ab
	+pg==
X-Google-Smtp-Source: AGHT+IGdAHvvL7FBML86H3kSweA4zXL/bz5qnnfM/P5V/XFs6lad3KvJxC96rYsV0nVGk10l9iswAPaT9cE=
X-Received: from pjbsh9.prod.google.com ([2002:a17:90b:5249:b0:2fa:1fac:269c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268d:b0:2ee:59af:a432
 with SMTP id 98e67ed59e1d1-2fce874088emr34953472a91.31.1740620952821; Wed, 26
 Feb 2025 17:49:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:48:56 -0800
In-Reply-To: <20250227014858.3244505-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227014858.3244505-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227014858.3244505-6-seanjc@google.com>
Subject: [PATCH 5/7] KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kevin Loughlin <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Use wbinvd_on_cpu() to target a single CPU instead of open-coding an
equivalent.  In addition to deduplicating code, this will allow removing
KVM's wbinvd_ipi() once the other usage is gone.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58b82d6fd77c..eab1e64a19a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4983,8 +4983,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (kvm_x86_call(has_wbinvd_exit)())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
-			smp_call_function_single(vcpu->cpu,
-					wbinvd_ipi, NULL, 1);
+			wbinvd_on_cpu(vcpu->cpu);
 	}
 
 	kvm_x86_call(vcpu_load)(vcpu, cpu);
-- 
2.48.1.711.g2feabab25a-goog


