Return-Path: <kvm+bounces-33467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90E7D9EC189
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B03C21883098
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE563BBC5;
	Wed, 11 Dec 2024 01:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IZ6TOzIO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE035176AC5
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880792; cv=none; b=p9/Z+/NEccDEaFr1Fl5LZJDmjgJSNMt0SoaXANAzXgbQ8LdhuG/gB2w0xgr5Pq9W6wP0ANjdL0pcNU1sqFy/Hh0fwymLayJhlZ1nRMpIWsRAKk6/RRGtNGgqeo0JOt+8Pi7RZdasG2Y6ulvNJM2hgorzvD7rTPSRVi9Vh2AJqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880792; c=relaxed/simple;
	bh=MEVW6xDzLLQfv9y9OXgkK6FmeeyEKbPbGZpDIKqPQkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GvKg9MgLDuXe1va62Z7iNRWYnWUSwDJ+5l7ZIgq26PpASzSkAtilH8Y6IcYfrY6Y2EXc8jtgK3WquKjGszwHE3o2qn8aXmxJuCQPeSaQpUmtembko3qqyz6k/8AyInsaWuNIHelyev/exk25w8n3Aqo5uaw2Mesn9z98ahNiURE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IZ6TOzIO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f71e2fc065so4299581a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880790; x=1734485590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cL3NRVkBfZBJU3o2RWiXYFqfXEQDl3zXojuDagzC/0c=;
        b=IZ6TOzIOQvGBH83BDvXv2u1PeruzxdX5qpwBGsgZ9BAJMrIeXaP87bqxWdmLBX4ZC5
         sCB8xBxLpq70sYr5hINj6hdHHoniCDDJ+zEr80ss/WGvsoe7q8lJdlQjQTBO0NTdgdEU
         k+3W32niR8oDMep3bbPPUWesNATE1QKGEpp3IkCWX2Ts3JoKa5Ze6M0snSj8Wt04v1kc
         fgnW37Di+2pihN8lshttc0GKs37kojvd/FSO4w2Tcwln2iNFUM7Ng7nqqlCWyYOdwaoj
         aHupjFYwz8n8aGtzl7lPUPdA8vOCgGwXGsml5ls30UspEq/JV0Egz9uwrinhwjEYPJF0
         5Mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880790; x=1734485590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cL3NRVkBfZBJU3o2RWiXYFqfXEQDl3zXojuDagzC/0c=;
        b=FB2Jns1cLHRON+zN6BMVmZ7cNDEu98VSCm1wfCGN877k6cqXQJZav/4hMsvTvjW7in
         Fxh6QcZ71YKWu5iG4ywLyStzHyPv3QmsdKnsEZ22NpdMuZxGQAukycADSJphHX3vgCWb
         m5wVc3bvZjIOxnXtD3qRg30VMXAywvSEM4HZuWO1eWI0y0EO7sYiUlv/MYI7a01px72i
         22VF6AHY8JrzyNsZvbnmAjh78SS9GwWetjdHmsrav8HXr9rCVHhp3nN+T70+EEgA/jZt
         uJVb+ELACjt51/LNvDy3/lSoBed2mjAEihGqMplZQiWydTuuoPSiLup6JGsK2ZdialqL
         xXvg==
X-Gm-Message-State: AOJu0Yyxfn8+91yPX3eMitORwBUacxq63LJKJLfrzuniLjgh/H93OhkG
	7k3J7YHIjzg6ft8P3Q2bRtS1UiLKHr3BUgGDx5O2HS/Qh14aFZP7QsVR+CMGz7lrSiKaEcx4Qk7
	sxw==
X-Google-Smtp-Source: AGHT+IHE/2gxSbX+S+9LU/gh8HaW14iyj5UQ7k4tSNCWmJQgUFrk9t8D9rOA16e9oYsL7aftQDmDCAMD5+A=
X-Received: from pjbqx8.prod.google.com ([2002:a17:90b:3e48:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e82:b0:2ee:94d1:7a9d
 with SMTP id 98e67ed59e1d1-2f12804a1cdmr1552457a91.32.1733880789942; Tue, 10
 Dec 2024 17:33:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:33:00 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the
 vCPU has RTM or HLE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When emulating CPUID, retrieve MSR_IA32_TSX_CTRL.TSX_CTRL_CPUID_CLEAR if
and only if RTM and/or HLE feature bits need to be cleared.  Getting the
MSR value is unnecessary if neither bit is set, and avoiding the lookup
saves ~80 cycles for vCPUs without RTM or HLE.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f73af4a98c35..7f5fa6665969 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1998,7 +1998,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 		*edx = entry->edx;
 		if (function == 7 && index == 0) {
 			u64 data;
-		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
+			if ((*ebx & (feature_bit(RTM) | feature_bit(HLE))) &&
+			    !__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
 			    (data & TSX_CTRL_CPUID_CLEAR))
 				*ebx &= ~(feature_bit(RTM) | feature_bit(HLE));
 		} else if (function == 0x80000007) {
-- 
2.47.0.338.g60cca15819-goog


