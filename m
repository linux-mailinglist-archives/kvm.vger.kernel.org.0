Return-Path: <kvm+bounces-39065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C18A43167
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A6618881FC
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C459A210F65;
	Mon, 24 Feb 2025 23:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1DMQFpqB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7220E71B
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 23:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441354; cv=none; b=DczQZAlfd0LNqiHy8SnXGL/40nVCUxOodOxgIFhZf9KMNsaIdjssyewhPx3srYh77V8pObGh6JQpogG2XWaxTQ4dckyg4pJ6x8TXdSSZFKGWppvPZhSHUzlLOEo5r4wDvb5axtLtb/UNEBx5zytZ82m98ewB+dFVd5zav0K/PYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441354; c=relaxed/simple;
	bh=xi1QaJ351EOkGaXqg6ZlisugvTQJp9S68DQPIs/E4wk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VW7RnAk0Myp6ic4DEAshxmiH6t3FLqPo3xtQaS3E+RFtx7LwXA1O09uCTqb4gf9v2tdQL6/Kf0DXCedjMPEXN1NcRrojHH9kP6/ugHqn6+rbbmq05MmiE436LOswZXiKklpVMrlw5LXDuKawErwhHmTDtcdkhb49fa24V5SN+Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1DMQFpqB; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a4c14d4so10382484a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441352; x=1741046152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3T0ArXtBue+4jQS8m14aDT4hO1iQN7UONJOY2Dznj0I=;
        b=1DMQFpqBG6+U6bFaViWV59mGoO/T1F5bADrX92rXup/dNZ5FnwnpYRTnOQ9Kt3QWHI
         WghfYrXbECVztjWYsw2BufD5uPzs821sDyrD37zc3jeI5io4qx8WcrsGWvOSqr1IUydO
         LAbuFBwlG39OQbo/8KwnzWDimNYAKCt1YMI53WsFAgmLloNqfuY5net+7M64JpfZBXT0
         2ZbmLK7cUsccZpRowg8/XAEJlji67Pka1i0opb8UPyhvfNMaiRmTytqnFtWnUjh2AxzD
         HytdXfCj4/mVKoFe/Q/dXAdsqn0kcbCkDSRZGcpYts4UTTUipP9+AMDSfJyGCUWV1qOt
         pz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441352; x=1741046152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3T0ArXtBue+4jQS8m14aDT4hO1iQN7UONJOY2Dznj0I=;
        b=COyH+yWHM9+o4YGYRk8D41EfX8WCKoK0j7qknz0VO5g56amprwwEVJmgZxU30jzPcA
         xkFTv0wHYda44gadrp5Lw0JBdxJPHlMs34+ims9jxA3jzPGmaXFHQ5qA8QLcj6t1kVv9
         WYR3QaKPFH1nPx5P0pBUUPWFws3nRqPEag86uAfAahrg+4Hw1i1/hAQHqhTov9d55zIH
         v/VBziBs9/5FJMFnmKvL+ZguLkJWmxbsLIs1QzOHkdeJ8fGbHag1zzHT5CijxbAh80Ao
         uRSZeEkXF0MkWxKfirnOKQWJvbpmEOW7pa6jwFoibZY0cbSt80F2epZK9Std5cCiPEa0
         dT8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2pghwuaecN+SNoMkv1OGua3KoO3/vQ28mqEZbMkDQvahbntm+7Z6O1Vx6kX4t0okQJ7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQFrwxYLFnTxDK+ADi00sZoJdD87bLHwwV4376NECG3OePe0O1
	kr/f+WHwFvMQvmtWLyEnEU2OH6VdzbWvwSIJ9gg2BD08BNthNHI7h1PUB2e4Lsp/9iAyqg5eSL8
	4fA==
X-Google-Smtp-Source: AGHT+IGLhJjtwIM7JWkK50LEGpVa5IYsMEMrJLtXcv45TfVI0Bcew2BvOmcJCUf4CWX8wuCtTe3G30kBi3Q=
X-Received: from pfbhd3.prod.google.com ([2002:a05:6a00:6583:b0:734:cc8:a107])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:695:b0:1ee:bb7f:9b39
 with SMTP id adf61e73a8af0-1f0fbff6aebmr1778237637.1.1740441352385; Mon, 24
 Feb 2025 15:55:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:39 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: x86: Don't load/put vCPU when unloading its MMU
 during teardown
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't load (and then put) a vCPU when unloading its MMU during VM
destruction, as nothing in kvm_mmu_unload() accesses vCPU state beyond the
root page/address of each MMU, i.e. can't possible need to run with the
vCPU loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 045c61cc7e54..9978ed4c0917 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12767,13 +12767,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
-{
-	vcpu_load(vcpu);
-	kvm_mmu_unload(vcpu);
-	vcpu_put(vcpu);
-}
-
 static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 {
 	unsigned long i;
@@ -12781,7 +12774,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_unload_vcpu_mmu(vcpu);
+		kvm_mmu_unload(vcpu);
 	}
 }
 
-- 
2.48.1.658.g4767266eb4-goog


