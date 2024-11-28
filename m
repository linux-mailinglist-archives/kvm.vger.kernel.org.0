Return-Path: <kvm+bounces-32669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A86F99DB0E9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04780165465
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3171991A5;
	Thu, 28 Nov 2024 01:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LPGsfbfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E13719884B
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757705; cv=none; b=nwc8ZtdL7iLZUmTU6IXrg1LfhBDFwHP2+216KI54kVZZ+oz8j41DgFuAsnu97X6Zc+BteQER3YBxF2yx7wdJ7Fn7uVhwUXZO9zsKZCy7gWz7bP0lhVhw45oRsBuzwywZFNOitU9KMykjw7zlRkfKINl3+E1i13I+3UPtwyqNmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757705; c=relaxed/simple;
	bh=21B9ts389TeEE9vha5UXItt4ArqBvD8PoHd8CLYe9JY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=INzkTBuR96SRIwapFImLMrUHUbxdbhyEhmg5ze5a34D7n0eMCfsky7/C/wn+sFDqRvmxy8CAavB/9gi8a3ZdGyZpjRlHTO7UcRI+qWvNZ+5zp1jACa9rnSvXlLbLmnm6uOtrk7aBwfyGW035N1tNx+AIK2nAg6QBiB9/HpkSOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LPGsfbfb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea50590a43so516820a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757703; x=1733362503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=a/9iAaldSIYNoaw8wlfvun5f6TVnKjV0yuck5Iu36H8=;
        b=LPGsfbfb5OX9lxevSNgFhBRQlUA3kV+qGbQ2VZGUVD3MozmTHLNLb1C8YqRtyEs27P
         knlVWeE4ypEWI41DZh/X42tWzHhNHNcQwABjhJYAqq38CsD8UZaPffp2mudi/FS/Jrg4
         K+OETWdYacj9O9WbC9UC1St76sMhqHtyfRW2WLees8nrDU3qotbbxrfmiwAsTPVLjHRV
         iH2MpflAtRuLs1oNSSR5l0tDNTjwxYYtH3Vee1UuRLlKkpuhwqWex4zH1MIcELc4HaGN
         vluH60TxF2ssi3MW0A4SfGHnMdQ1CXaW/Z7PmsN80tBtCkpb/Tc5/ENgWli43nnPNFP+
         6aVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757703; x=1733362503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/9iAaldSIYNoaw8wlfvun5f6TVnKjV0yuck5Iu36H8=;
        b=fo5vTE0i96zz0NWIi7mCZyKcGBX+Roo/qGH9yVO80Okla/SjFMeTASTnrHK3cm/aat
         Q8P0bHSCaJOrJzFdXhofuIAxRl1QmXUmSYP89rK6H52pV2tBLez7SOV8hFKMIs/I7nGg
         zXtWV5cl6ovPU+fNL38hOc7wUPGLkH8eju2cyot4EE+j5eEZaNjy3LlzWShR8AArVA4K
         C5SEqdjySfe7sPbyl54NnXGd212EaVKtvu2Wk9Mdzq1zeQSR3aGjNhqEXEMU+bpesdMT
         sl497BA04ZGSPgJXeUdrcE7o4G3fAkDPPP47siMbIpJr19fQgq7LAgnrB1sHADvMhE6i
         qw8w==
X-Gm-Message-State: AOJu0YzyQINA+WW7E2YKizqj7P2VTER4kLcyCKrBmwEPlrDZnsDrDHcZ
	40BCIu7SsfEUSxXDwzBKhU/A5/pdni0wXHoF5+SyRRjExH3jKyfbLa+i6NoaAz0bHg7HhbP4fux
	b7g==
X-Google-Smtp-Source: AGHT+IEEgaZtWbIrOrUz2mxSm9EPBvK+IDwvuT3hAKykt6QoSkNbBU7y039G0akcnYFaBbsuxXcjj7GaWGw=
X-Received: from pjbsp6.prod.google.com ([2002:a17:90b:52c6:b0:2ea:5dea:eafa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2690:b0:2ea:7755:a0fa
 with SMTP id 98e67ed59e1d1-2ee08e9d433mr7018289a91.7.1732757703634; Wed, 27
 Nov 2024 17:35:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:45 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-19-seanjc@google.com>
Subject: [PATCH v3 18/57] KVM: x86: Zero out PV features cache when the CPUID
 leaf is not present
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Clear KVM's PV feature cache prior when processing a new guest CPUID so
that KVM doesn't keep a stale cache entry if userspace does KVM_SET_CPUID2
multiple times, once with a PV features entry, and a second time without.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 27919c8f438b..a94234637e09 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -251,6 +251,8 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
+	vcpu->arch.pv_cpuid.features = 0;
+
 	/*
 	 * save the feature bitmap to avoid cpuid lookup for every PV
 	 * operation
-- 
2.47.0.338.g60cca15819-goog


