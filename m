Return-Path: <kvm+bounces-64267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6242C7BE0E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67C703A8C20
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 22:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A4D2D6E6D;
	Fri, 21 Nov 2025 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXLZFeaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EB2FFDDB
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763764502; cv=none; b=hC6crb2FElP3o5GwnfIyAaTEsZhLya4bF7DajcDkKjrddjwjfVBxYGYl6d8LBmoJbt4j8sNyC2w2FkLf4k4nLowHpcZnavC2Sis5MOoWwS/GQ/DiaSYppZxOut6+Fkmcf9gIv1KV+LLywzFIcBt3W8bX9BU4gqMWgit4VeCKLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763764502; c=relaxed/simple;
	bh=lsT+viZWqqRjn+PYwPpLEA611TTfzuqAF66ioLEfSpQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jry4zedCPjKrH/fFmbxHIz0hXFAYTonHRpDtPaavco/PgztqtLBi1vQOdNT3h2pXGGBoapxVnu2HHAevqMdD/GjQbNbKvBOEAYtOZvu/ZkweaWYtidots9hbmiojoA38heRnXQMEZjaVnwOmo7pApRRGJ5p7b3xEyPNMkHIPVa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXLZFeaV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343e17d7ed5so4721984a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 14:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763764495; x=1764369295; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FYb4mnjND8uyAYDZTY5jZv6bxtxo+QaDoqsrMNdwfeo=;
        b=NXLZFeaVw62Dmfs8/WSI3J/igoV5XcFIhPp4d4/2q84vBWoCdcVhT+x3ZGBcPkflii
         lqKoXDRQcTsZD9+m3Yq2qdOFitiX0vN2Fk0gqCCzYvMLtrzBHNYbSdpKFsrBHEVOtaKH
         Qj4cBAKWq8sUsPOPNc3bH8HbI2JtqcUqKIgMl8/JN3vsgEpSnQkDiyb/AILlwM/5PTXj
         bIwJFJpsE3VNA8VageyLf+u+C+UJw76x18Bq4D1x6kWe1zudSWyssMLH6B2RLaMglJqe
         U1EvsqlnKakJYkT20FErvHl9SP6gWqtaaa8CkucpwR8Z0CvDEe2PWlX+jO+8kM0V5bcq
         Yjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763764495; x=1764369295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYb4mnjND8uyAYDZTY5jZv6bxtxo+QaDoqsrMNdwfeo=;
        b=vASICYbjdA5RdqR7sTqAyqGqxu34bcnoHNT4hYD/nPGJ4XyKmjHl3W6baX6RNoSS/T
         M0JE0btECw56NWwbSJEnlOuX/y40bjCxhzdL1RLH7NFUdIkgsrSS63z6pr6wGO7hWxVr
         8OAAvntIA+6bJK1g/4XvHzD6gP5z8ymhKqDtIFGCPzZTAlH83JAytNBroyy53ogfhrZ2
         xn2eGeOn1RdJPS7r0edJNWbydGWnNXdrxVZoVwGXEuD1BVVI6FcuBdzl4a+tQbh9YVuO
         kG+CsrJ2bSkVkFvMDQmLV6tSlYRhE0r4VODl0GdICxq8LOpAhe5W51b8xdCyMviIgZnG
         qfgA==
X-Gm-Message-State: AOJu0YzIIIpqof4SbhEhGwF13Xc9hdzy5YMC3lEYp2bbuL8r9HcqlDFZ
	vWzvK+pPSgTUb+wdUAWuwOeQPlNv8tRtM0+kWBtaf57oY0yXRsiO0cVqlQqgvLHBMdHC8U2TpI5
	BcRf14g==
X-Google-Smtp-Source: AGHT+IEQYvT+Zfk13DHjigZ5Eleetu/W6Uzwhp2vloqyzZ4LXM/6l8ZEnBMwrRp+I5s+uD9g9xfA2IZUjhc=
X-Received: from pjbsk6.prod.google.com ([2002:a17:90b:2dc6:b0:341:7640:eb1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384f:b0:340:ac7c:6387
 with SMTP id 98e67ed59e1d1-34733e2d4a5mr5255149a91.7.1763764495318; Fri, 21
 Nov 2025 14:34:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 14:34:44 -0800
In-Reply-To: <20251121223444.355422-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121223444.355422-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121223444.355422-6-seanjc@google.com>
Subject: [PATCH v3 5/5] KVM: nVMX: Mark APIC access page dirty when syncing
 vmcs12 pages
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

From: Fred Griffoul <fgriffo@amazon.co.uk>

For consistency with commit 7afe79f5734a ("KVM: nVMX: Mark vmcs12's APIC
access page dirty when unmapping"), which marks the page dirty during
unmap operations, also mark it dirty during vmcs12 page synchronization.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
[sean: use kvm_vcpu_map_mark_dirty()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cc38d08935e8..72ac42fdf3b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6382,10 +6382,7 @@ static void nested_vmx_mark_all_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	/*
-	 * Don't need to mark the APIC access page dirty; it is never
-	 * written to by the CPU during APIC virtualization.
-	 */
+	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.apic_access_page_map);
 	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
 	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
 }
-- 
2.52.0.rc2.455.g230fcf2819-goog


