Return-Path: <kvm+bounces-39643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48349A48B85
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 001CD16D64B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 22:27:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3870276D97;
	Thu, 27 Feb 2025 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iTs1T47X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C719281377
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 22:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695065; cv=none; b=f6ghrtFR050EIXd0bKuqywwzWjV/zlzGhYxRhtva/RU9WWxcF3oCLXMAvf/6IH5vO+x8P6/r8jNAT8H95QWh008vwOr8oByLDSQXDxx1F5jBMxDI5E0L6RuA41hI9LF8RhAWUmJEX9Pcf+1tJjmggiljp/qWfykYysN+UNSDPg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695065; c=relaxed/simple;
	bh=l1iaY/46ebxN7Pxlf+bVDyGkotDM42snv/jC9ZbuKW8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WvA5tT5KXU0W7ZmH0TckXvnD3SHhAnpLRsm7jD2TbPxPaTX7VS7YnZl6+L7eZdU0fhqOleabVddYYmf+mkS0FvNdieH2X9q+2Do0DMURxVwx/ji2Vj5txqM4YwCcDp73vOoNDVSWrQLqB29H8Go8neIRBwzChuip4mPTBe6GhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iTs1T47X; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc43be27f8so5271073a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740695064; x=1741299864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0qlBu3O+qgW1GVmSpLZOxIdN+UM1bvdDqizmqLkAsDo=;
        b=iTs1T47X2tYRwXd1yfZQAQ56agGwF4G9gaopbB7+ECzCa/slfOTia0fF2n8scE5qoN
         zITmJmlA6c5ZmfMHip2HiUMY+GDJ5B8p2cabEEQ+ayqs2yFw8SDanyME+1PR2lNtibON
         v6yd19RAYYMoTQtZkaa8UJz6Sw5ktGfWh4uY3rPAngPKrWh3Eewlf1/2Ng7KuphCu24l
         8OHX80ADP2J2DUTT0n3846sVyNhNg9VNPPxw6WnGpeH5htuUw5zeU0GfTNJ2UhVX9oZ4
         YtGPX2bSUgAT6Bon4lYYGQSAxkciUwmIq2CdwtPr+1tTEakPgu/oZAQgjOAHvSP8bi7j
         ndQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740695064; x=1741299864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0qlBu3O+qgW1GVmSpLZOxIdN+UM1bvdDqizmqLkAsDo=;
        b=BGBd48OlP/HGuhZWyrk41gkzwqxyYO8RF2Jq2cRxCdm8wFLKJKyl0eUKvvWlR59IBV
         CGva5/LsZeyKln8CSrxYgQgAJtNh8PqmBgaowTX+5kWEOgE6T9zoum4jTx4zghb2Tpr+
         fGFzNFxJ1k3HaoVlRD79GKaEupo8T+ef4nTsu5Hx/8NChbI4kXoVOit9vPh3mXBbKqh6
         m/RknQFGW3iiWW1dPMJX83Jsa9bqeLndYnv1ybBebhb6H4/pGaCrGJnHEgjKFZTipjjp
         DU8nXZGc0wa1GGo0ghIC8dH6NNXY77GiPEUMilIiuuE7imb9iTVjzpvGzsnh59wBs14G
         N2mg==
X-Gm-Message-State: AOJu0YzbU/s7QXAGYBfadCAH+7ock8cyLNMiBksmWal+qqKHQGAps3Fe
	NysHhT+1cg4mnMBzNV5IdERsCUiRGj8tU1Sl9Ez08F3G0MyCOcVOrk2tcL/CRMZBXlHmI4faO31
	njQ==
X-Google-Smtp-Source: AGHT+IEAR4cGG2gi7Xmxt0qd1akR25wwXozuUf+4YWN9m+W0e/uXX0xINJ03FxGe0avbJCicY+EqJQBZUo4=
X-Received: from pjl3.prod.google.com ([2002:a17:90b:2f83:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3845:b0:2ee:c9b6:c267
 with SMTP id 98e67ed59e1d1-2febab403a5mr1668829a91.9.1740695064085; Thu, 27
 Feb 2025 14:24:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 27 Feb 2025 14:24:11 -0800
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227222411.3490595-7-seanjc@google.com>
Subject: [PATCH v3 6/6] KVM: SVM: Treat DEBUGCTL[5:2] as reserved
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ravi Bangoria <ravi.bangoria@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, 
	whanos@sergal.fun
Content-Type: text/plain; charset="UTF-8"

Stop ignoring DEBUGCTL[5:2] on AMD CPUs and instead treat them as reserved.
KVM has never properly virtualized AMD's legacy PBi bits, but did allow
the guest (and host userspace) to set the bits.  To avoid breaking guests
when running on CPUs with BusLockTrap, which redefined bit 2 to BLCKDB and
made bits 5:3 reserved, a previous KVM change ignored bits 5:3, e.g. so
that legacy guest software wouldn't inadvertently enable BusLockTrap or
hit a VMRUN failure due to setting reserved.

To allow for virtualizing BusLockTrap and whatever future features may use
bits 5:3, treat bits 5:2 as reserved (and hope that doing so doesn't break
any existing guests).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 78664f9b45c5..fc9f9a624d93 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3166,17 +3166,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 		}
 
-		/*
-		 * AMD changed the architectural behavior of bits 5:2.  On CPUs
-		 * without BusLockTrap, bits 5:2 control "external pins", but
-		 * on CPUs that support BusLockDetect, bit 2 enables BusLockTrap
-		 * and bits 5:3 are reserved-to-zero.  Sadly, old KVM allowed
-		 * the guest to set bits 5:2 despite not actually virtualizing
-		 * Performance-Monitoring/Breakpoint external pins.  Drop bits
-		 * 5:2 for backwards compatibility.
-		 */
-		data &= ~GENMASK(5, 2);
-
 		/*
 		 * Suppress BTF as KVM doesn't virtualize BTF, but there's no
 		 * way to communicate lack of support to the guest.
-- 
2.48.1.711.g2feabab25a-goog


