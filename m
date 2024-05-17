Return-Path: <kvm+bounces-17694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5808C8BA3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82525286992
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DD5158A10;
	Fri, 17 May 2024 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BYdfVY/M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C815885C
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967666; cv=none; b=mUtAIc059LDCxP2sGXLiIAw8Mbxj1oh8AAcGZRST3rbqDOUojJvA9stiUDLovC2yBoc1JV5A2q6vapro5b3E83Dm9DZpP9fWEPatXhEAJOtqVKXweUZi+oUnqt8fk9aHsDYuJVzJcvP8NJPHMQ+YVtSLCOMCv8G7im22YBJnWac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967666; c=relaxed/simple;
	bh=Pyxmn/hLqxlhDGyDfXFPGC0l79mx96nG13APkFcZDms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=auDM/e/Y1bTjE6QZE59ESJzqMy35+NeoYRK4FL6oMLEeQjgv947/bd3qgUbxgWO5ouOhj2TIo00zk5b87GAHhelSyRVJ0dNujwkVpi5PElY1GrmR2xYoasJo7wMIvq/WJMMrtxfhSfNx0qQ7yXpUf5bHsyBPB6KpTlTXeJPiARE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BYdfVY/M; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b2738ce656so8107588a91.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967663; x=1716572463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AwwL9FWRmXo2naByXgzSbdIqVHMYablwKObp8DFQ5ks=;
        b=BYdfVY/M7WGu8WjuZdumhzU77shgWy1TxEHlkeQ4xqe+ZkH6PIN9xvfU3FskfXkWRr
         HG/c932TNJtgkwirpebhTVl9CDYFnbpY50TbMkByqH0zHKFt5MTzSy0zyCsjz5FOJM6j
         6ym0rg3kC4bemU1pk5dn/fnKWfXSzL/9575R6krA3sfyXJHADa1xiv0jOEdHYyY/LRLa
         VfmGSCP2DqaBWYguKzwPaRcwjmtPrdrZpdfL916l+H2nig3+PFCVFzWtbPc2IgQpZkdW
         dZbBQDupedCuIPrq5L/bnfDJwJIxwGMGVHTulnyzN+EwQSkQb6/InJPrIt7DS9xpVe14
         hxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967663; x=1716572463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwwL9FWRmXo2naByXgzSbdIqVHMYablwKObp8DFQ5ks=;
        b=T6R1bbbOyjCYSCgzXpoHrN64h8gNTq9V9nOtMiM1INNwCe5KMJq+bRZEasqVPlXJmn
         MV6F+hCyuxQJGGeWcE/Whc6NyV4ePGp1hrR+POEwP9fIDsok4JmwpgOVGOQ8RTJNrcp9
         l9L5jF+ep7bXh9HFSlX+fQas3+NHODz+uguFKPGKwK96f10nedDqumbwp03ThJLXnbQj
         fM//cTvEnO4t/RWUN23wD+4+47EvKOP2t26ktpdgVZhQVYIZ2nVwhDkPwv5KLjd8I877
         IfOJhJBgg1xcofDabGZk1OJ86ce55+sHm/2AmL9x8XSRfKCbLfuI049FodZ8bVmIRaGL
         vPRg==
X-Gm-Message-State: AOJu0YxVJk9m5335nj44YBpAXOH/PY7e5tcjCYlkAn5S9QDkWwmQilki
	UG2qy/hXQjO+xmJbo2WxKTj4lpU497KrNt2fXulFLjhs1hubFxtCVMeTKHXzdloRMQEtpvdAWan
	+RA==
X-Google-Smtp-Source: AGHT+IH3iv4H05a8SLZPVYBpYK75/A99SyLmuT0NMhMtOyMTHRzxTnApE6uqfjZ4bjLYrbV2sV/rMsu5umw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f2d2:b0:2b0:e2cf:1187 with SMTP id
 98e67ed59e1d1-2b6ccc73af7mr62788a91.4.1715967662931; Fri, 17 May 2024
 10:41:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:39:19 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-43-seanjc@google.com>
Subject: [PATCH v2 42/49] KVM: x86: Drop unnecessary check that
 cpuid_entry2_find() returns right leaf
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop an unnecessary check that kvm_find_cpuid_entry_index(), i.e.
cpuid_entry2_find(), returns the correct leaf when getting CPUID.0x7.0x0
to update X86_FEATURE_OSPKE.  cpuid_entry2_find() never returns an entry
for the wrong function.  And not that it matters, but cpuid_entry2_find()
will always return a precise match for CPUID.0x7.0x0 since the index is
significant.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 258c5fce87fc..8256fc657c6b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -351,7 +351,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
+	if (best && boot_cpu_has(X86_FEATURE_PKU))
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-- 
2.45.0.215.g3402c0e53f-goog


