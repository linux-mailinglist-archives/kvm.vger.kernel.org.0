Return-Path: <kvm+bounces-48017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F32AC8406
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE2801670B1
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CC322422E;
	Thu, 29 May 2025 22:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MWmlS5aS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA868220F27
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557189; cv=none; b=WfpfNmeRp7tvb84pNElBFds9lEPm3iIcNaK6qRg0HKTO+pISCKK9hCnXn6k0Y4LwDO4mpJBs4kBSpTnbGjHe8yEpxD8siFiSrMf5gWIWl9/tdP+gdlNC1VZq+p0wjujHVlwaOGgu9iZPxykNtmLVpt2ET8JC2wgCVvi4M6qw9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557189; c=relaxed/simple;
	bh=zVHFDvGYoUXdaacnFc9cbOZNnkV4Sl8Ts12QDaxIW58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nMUpxBLsxWNNLAl9f84mAoE3rkzIw7FSmDQmWYO4DyXXV2wPqwhofu5Jw1G8i6es80pMleK1OcK6FvQyO1rlAZH0BCBMsaM7pZPpKU5bINkvSyIneq4/dnw4Jom+t5NwLKNsV5lDVxw/qIxCYfhuejy847G5an9H9rLEs28d3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MWmlS5aS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso1919219a91.0
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557187; x=1749161987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qpJ3lqvWpdWxqkl3QOJ7dzcCaTBGRsqwoUxsRp/BgHs=;
        b=MWmlS5aSS4MUwkUDoN2wPA+5dWkbydMfydSrBB0ZGJB4eownD2evuZq0ac8EwbZdga
         0CZIRPGHlLdztVpbHNZc4/fqldhD/PsFuF9mlntp4W5gbftPVhIXc27ikyDsYyQNNm1K
         V8jBzQ46dSdJlPzvT/pDOqC6ejxuC565ah6wRJGIM/oxuOfpu2foiko/X09BkcLQ5BZE
         Dwde23OVqosF/1/JcEJAmEWSX53v7IB2hAX4IWDLp7u6Em3VW+Z8ET70P/tAKWluaUNS
         Z3MBuBnIPy6af+ZZBd5tyZ4ptS86fXeNjKBeHb95jC2B+IQk6ld6ueDnsgjwJ2wx24Yr
         MzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557187; x=1749161987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qpJ3lqvWpdWxqkl3QOJ7dzcCaTBGRsqwoUxsRp/BgHs=;
        b=JuugZhocu+tXzUKXreFsdULjvvJLaUb9apuFkgf27uxjNHqGSMSgxtcqjmWUXBfO51
         w/wpDGoQviPuMFLw6lESSWtugovE7T41dMKu/6Kq++rVnr5sR0DIf4YMMOLR1wgEWU8m
         OpAvMZ/9WxLA4drjpfQCMejBSTw7u8lDwzzX6akaPLWTU36m4woSNxG5UbfuNjAoFzQq
         hCxVS/wNX+zCi2wmtdDfhT017nBmhzi49sWQ8Y1DKqlCa9zv/wozLLxaMAb6k4aZOTIw
         sD8Gn6V3s/1wwbqJu4VcZvsX/1p1LdI5cd86W3y+v2EWV2T+dLOsQTaU3lHwj64gdBJV
         gJPg==
X-Forwarded-Encrypted: i=1; AJvYcCXi1iP6UAJG52miNl8RMYzIVrUbjjEPFxoBWdkrRh1VgvMO+ZKKPzyLXj2OKPtMPuJkFmY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl5Z/OGWj9qSX/HSg5/Ypzz4afR9LLm4DJ6dJUvr1uQex3zY5i
	/e6UZp9IGJLAzcQLqbeGCU113n4jzEVONAd5RUFZP57LXQUebAMhRMG2VX9e3g+pgtQ7GBjbm5h
	9X6A4HA==
X-Google-Smtp-Source: AGHT+IFX7xA/wNBD+GkVjlH4FgWC9b0N7YtakX+E8PhKZ0lflUPRAVkfmvb9rXlMNwMUrMjpe+LFsX0XUn4=
X-Received: from pjj12.prod.google.com ([2002:a17:90b:554c:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc6:b0:30e:3737:7c87
 with SMTP id 98e67ed59e1d1-31245dec83emr1180483a91.5.1748557187294; Thu, 29
 May 2025 15:19:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:17 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 04/16] x86: Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical()
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use X86_PROPERTY_MAX_VIRT_ADDR in is_canonical() instead of open coding a
*very* rough equivalent.  Default to a maximum virtual address width of
48 bits instead of 64 bits to better match real x86 CPUs (and Intel and
AMD architectures).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 6b61a38b..8c6f28a3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -1022,9 +1022,14 @@ static inline void write_pkru(u32 pkru)
 
 static inline bool is_canonical(u64 addr)
 {
-	int va_width = (raw_cpuid(0x80000008, 0).a & 0xff00) >> 8;
-	int shift_amt = 64 - va_width;
+	int va_width, shift_amt;
 
+	if (this_cpu_has_p(X86_PROPERTY_MAX_VIRT_ADDR))
+		va_width = this_cpu_property(X86_PROPERTY_MAX_VIRT_ADDR);
+	else
+		va_width = 48;
+
+	shift_amt = 64 - va_width;
 	return (s64)(addr << shift_amt) >> shift_amt == addr;
 }
 
-- 
2.49.0.1204.g71687c7c1d-goog


