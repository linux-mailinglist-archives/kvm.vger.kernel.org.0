Return-Path: <kvm+bounces-9406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B016B85FDBD
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FB0D1F20FAD
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F78154430;
	Thu, 22 Feb 2024 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FlNgJoj3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934DC153BE4
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618278; cv=none; b=OEthXvucwGz66RMbC9LHUIVIW4VBaD0jTiwysaiWdhF/eED380kJzFEF6bKOizzeGTY3a5Idx1Tz75HfKbqwJ6QPE0WOTmvdzp6XzAXCQ5q0gBdTSdcVeViziphgZTCiBQOltcm4SBM0rrYTzzLWFwzYikR5oLBhhstzHrwrYHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618278; c=relaxed/simple;
	bh=87Gp+Jzp2QxMm4ODcUrxrx7UgutY2NvawjWw5n50K1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tjbwo7bDv153i+yFkW2JnZJ90UJWpMXq8OmqYrb1HETrjxI5Madw8uFDlpyD5KWxSBfyR3jFoYyb7npgcC7cvLO7LL8w2YuMpOBVqvkr5ptgbMv6JC7RxPMlntGkYjXmxi/Jxsvq5Ef7NrOKrqDCxwJ8RaJxbtmqkRE6lb3tKcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FlNgJoj3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4125670e7d1so4898035e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618275; x=1709223075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DTAPsCidsFQm2FQiq7NglRpJEY0jsUEiaTOsAjZvPK8=;
        b=FlNgJoj3axV6Hr4jDhSxkmKUfPT5tK+fl9gzmktxHxGH+gvtsPXOxoBtFEb4Q/g2rR
         KCydjCvfheIH7aSJEVJ3xXbOSIH667x1a1BClT03nVJe4VSBkn6RQ7K/50MJjuixk15g
         0aN7nGv6JrGXJyZWLMpal5pjt4wkM+kYH7T0faciZOmbiTz/VsRxJnqdKteSHjX0FwFI
         5KGNL4mDGztPtH/LDD3ucF8U1IYoOEds9TZJ5yMvbighwIMcWNwzWOi0n8njyroZw+lJ
         I0QXT/7qjhZ643Dsp382QgK8YtRHvBlyUprBFW2qjgE3M13+04u/RSn21eTjV/JLd3Nx
         8oAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618275; x=1709223075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DTAPsCidsFQm2FQiq7NglRpJEY0jsUEiaTOsAjZvPK8=;
        b=mR0iyMnafXC9kUYSmQZvzlk25IYynRAp6eZ6VtauieaARqnFrSgxaz/i878Q59gV7s
         AQKCnztIvxOtxEQxmQX6ez3X3ukEHI6KUw+MI22wb1uG6ExD/Y5U+6a3xJwqYuTwVhFt
         JtSmPgtX/QmWyfqADMNr7MGlNkVRDljHFnGQNbEbkIRfSS1N40nd3xfZtNXnK5926p3g
         /tl9vzNhXJuHP9iNxZhOKMvOWUq3zc1uGUoiJfzWAfqbdNFt29bWHjjZ8iDvjDDPvCAD
         RroIhgVPuSO87f1X/ejMZkoegeC9E3lzppKqRYgzYdPlbQgjRsJhUkFxzTKqdJOFxh4J
         vt6g==
X-Gm-Message-State: AOJu0YzM1eAxujqppjpSuh3B/hVNbdvsASbdY/xCVGh2HL9ATN6zn+Ha
	xyYywI830nP9Th8IEcbzqF6vNzzrXLgBhh+ifiMaX6s9hBO5fmzx1th34eV56oIW+EtB7Zgm+yN
	lYdFbs2MlqSoAlDDQTJByvBS0cH7sa3sH8WToKhj9uW9ezCm180NCQHN3N/0errzi2XUiIkOrQ6
	ZPCmIyK2HvzU6Vc5clEIaZ05s=
X-Google-Smtp-Source: AGHT+IHvNF8y7PWGRXSHAC22nIJTTDdyX/V+eUGWRSqzOZ4Mt5/e5XWmA6cYwSHs0FNnAIiCY0PdlGk9FQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fd2:b0:412:6c73:a647 with SMTP id
 o18-20020a05600c4fd200b004126c73a647mr100415wmq.0.1708618274543; Thu, 22 Feb
 2024 08:11:14 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:31 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-11-tabba@google.com>
Subject: [RFC PATCH v1 10/26] KVM: arm64: Avoid unnecessary unmap walk in
 MEM_RELINQUISH hypercall
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Keir Fraser <keirf@google.com>

If the mapping is determined to be not present in an earlier walk,
attempting the unmap is pointless.

Signed-off-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 405d6e3e17e0..4889f0510c7e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -378,7 +378,7 @@ int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 	ret = kvm_pgtable_walk(&vm->pgt, ipa, PAGE_SIZE, &walker);
 
 	/* Zap the guest stage2 pte. */
-	if (!ret)
+	if (!ret && data.pa)
 		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
 
 	guest_unlock_component(vm);
-- 
2.44.0.rc1.240.g4c46232300-goog


