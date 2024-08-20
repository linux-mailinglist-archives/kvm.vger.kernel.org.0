Return-Path: <kvm+bounces-24568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E59EC957C7C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 06:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A4511F245BF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 04:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF7514B086;
	Tue, 20 Aug 2024 04:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uCCXfjgB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B914A0B3
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 04:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724128702; cv=none; b=nwKDvOos5oilKqPxzGmqAxXMy5q0kxDZ+ssJ3jXLQcT4+qWFdvLRwPjynINRRUDa5EegM8eBqWnloeDszPMTPZEu6pFohQHLW7IiXqXiVdbMicsXGSG6G1TQ+KervmoMCquZIJiBGx09N8BaqV/WX7/utcbarhkIb3lgi8XMIL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724128702; c=relaxed/simple;
	bh=KhyS8lX/LLl+hyGdd5SPZp0IVwMMSQOPguoeq4EtDCE=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=VGqe3ULf6/NTtmPigCc224/ImzP+IJT6ySFzH8YR3/TzePCZZt5vKw6lfBDp80wNQB1VocO8D//E4IpB5FwMw0jY9veecdeKRZEIIGNFU7KWrafGDxMfF1yb8vfCphUkn046fupYeIZZAPQ8+hOSot2MP1SAP9SpPE7L4RAnEvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uCCXfjgB; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1159159528so4143425276.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724128700; x=1724733500; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qNDCnS5K1Pk0TOt/H51ksBrj3Ct5dgsW0PJU7Ovd3Rk=;
        b=uCCXfjgBzVuteMgqdMXJx92VAvJF6+8ibKqLjoU1HwfZwCmM7c9l0df1eTOVXfAvfv
         OYJ5hTuvWQO/Z3+po1SJ3U/lNv4MU3P/xkpzc6ncfAIihGyTD6SHhPlJeOOjUpP0yMph
         Tz6jsg9pOt6S64DfqAL2Nh39fcpBd8zAwphEpr4jcbYyMm+QgtmbhXNdgxstcWhjQX8E
         gTPsuJol+FQFM6QkneM/FQqvquPDjs00qJSuSZAXNd12+C0K9q7IjOjECKjLsX/zkFkt
         DAARrczHqEoxNzIjevqCMQzXK4KT+PzwJJjMNgOeIln2mcWE6ZU/M839sss/tpW3IVi8
         ST8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724128700; x=1724733500;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qNDCnS5K1Pk0TOt/H51ksBrj3Ct5dgsW0PJU7Ovd3Rk=;
        b=EXyBXuodoLlyzdh53x2P4zibI1Qpd4XZVwJ9vBwBhbkJT3D4CSzJo4spXGovQY0xdQ
         gRg0jzHBqNxb7TFY3qwETXcUO8O1OFB25J40uvdpVWVthLcP3IsRFqbFvF2PTD2jI/V2
         MTB7hACYeBQgrHjvyGVCDCYRb/g1Aaaj8cSFZZ9zsb/2aJvTaWVqymD5zgVCJaQwjW1g
         f5rLWOGpqWa+bFyYj6QGZpg+u/E1mn3iSUSW7uIpi5TIMCCL8HJyfgjOt/io5D+n/Oby
         pHFCkaXVdkG4KuFujkTIO+UYb8R8xN7yOKNHCM8dVmDbtuGPiaos82X45D7MlEv+7yNh
         Dbug==
X-Forwarded-Encrypted: i=1; AJvYcCVir811CYcAeLCarc9yeBTDtuglGHb/zHqf7JJ81uKI3MRgbuXwjZ1dwjzPsTs+EfUVPG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdWTbZBVTwBjOdQHHqEQYQ/Zl+nqRTxpsOBDi6g5K39cP9j5y9
	vHvAxgMNGVA4Htlcvm2kH4Q/DaCU8qkZJ2qBmRYOYX0mYbc4wTg+7g6HHNbdrKg++Y7GN4ngQYv
	2xRtTdhaugQ==
X-Google-Smtp-Source: AGHT+IHPhKfnyXpFhVq0R4vg3+eMT/2Vl0KfVD5sy7EldgzlYqzQx5123h4uD0zjvjOy+hF0Z61eezyg0WQfwg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:7c18:89e3:3db:64bf])
 (user=suleiman job=sendgmr) by 2002:a5b:207:0:b0:e0b:acc7:b1fd with SMTP id
 3f1490d57ef6-e164a9cecccmr57101276.4.1724128700014; Mon, 19 Aug 2024 21:38:20
 -0700 (PDT)
Date: Tue, 20 Aug 2024 13:35:43 +0900
In-Reply-To: <20240820043543.837914-1-suleiman@google.com>
Message-Id: <20240820043543.837914-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Subject: [PATCH v2 3/3] KVM: x86: Document host suspend being included in
 steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Steal time now includes the time that the host was suspended.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/virt/kvm/x86/msr.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b43..81c17c2200ca2f 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -294,8 +294,10 @@ data:
 
 	steal:
 		the amount of time in which this vCPU did not run, in
-		nanoseconds. Time during which the vcpu is idle, will not be
-		reported as steal time.
+		nanoseconds. This includes the time during which the host is
+		suspended. However, the case where the host suspends during a
+		VM migration might not be correctly accounted. Time during
+		which the vcpu is idle, will not be reported as steal time.
 
 	preempted:
 		indicate the vCPU who owns this struct is running or
-- 
2.46.0.184.g6999bdac58-goog


