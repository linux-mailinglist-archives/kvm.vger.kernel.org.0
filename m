Return-Path: <kvm+bounces-58102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A096AB878E4
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB8B7E2905
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576B825EFB6;
	Fri, 19 Sep 2025 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z7Malv2d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EC25784C
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243609; cv=none; b=rm1MazSQ8FQANsCqgdyXTcyTZIS/eqTsX1F19G0ctNii/Bw03DxXBb2k9jVhUaVQkpKTTkDLajqfpuV15bzBbm3lKdbulegoLdBrYNpmF7iHVgAbNqXGXMaZUN+u9pcICF/8hLmJIbFZWFZzQkn9ium9Mhn9ru+zNLqtU2MOXjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243609; c=relaxed/simple;
	bh=5TMk5+/OdEv6qy5r28RZbus9hXPlrKPCWHJzfl/drj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F8XaDP17gmjfv3CgqGFNm88EhD7V7DR2PIINNL5oFMpIcZzVVuhfzRjy4KB+KC5CgxM4QyP3iGp/onmbCaKsgvV/axAFDQix5b+2Kh3kuMBH1mz/9SHkCOsbrwkK+oemFO9hgR/xcjT2B46u1wbNnWfB/M7Z8DKGm2l5U7tLsfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z7Malv2d; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5519d1919bso310079a12.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 18:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243607; x=1758848407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EXeqkUK7BZpzEGXbHHASAXnUJ0fsVfhCvA9M9Xum88E=;
        b=Z7Malv2d4Ym2VGBHoEq/BrldxltpTkaHqG2HqCJIHbjYWqgjoggreZMdWeu+qigUGw
         Z1oNbyoh4pNUzRSawZWzY6h5nidc9wao2xkagtcmM/oJpEtDjEkyL2uiSPYiDRefawLQ
         06iWMpLzj1bCJ/VCH+xcc3KdR0YGOPzDTenQsOP5tlA388DmhslIqfFE0o8YubIqf1e4
         N3vlRqnzcXUF2cf5/zeZ3p+9fETtDFiBa18INkdw6UDll9w1VtRp8YC0Mj83q229CgJ6
         WDN3sMuG/QAPqVbn/SPX9A3zNoppXq96HpnfX6aPw798vncNdIqVV9Axb4s1iZ2i5I/S
         F+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243607; x=1758848407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXeqkUK7BZpzEGXbHHASAXnUJ0fsVfhCvA9M9Xum88E=;
        b=VJNLdSdpNSoWZF6529rqjkUSrRB9lLQW4Lv7VikbS4DDnzaNIzmXhaSsp1jbWeNYbX
         QBShcswjdv5siACV5V+GUWGOYqPpAdjO/c3CClZMSqzfwWTs8JiZOek9ueXnDT86xsqE
         X/r9/QuMxx1jCagAoaERnf3wa4UBV1UOtZYDNOpGSpSgB3IynlQ089g8BtbXE53QQGl1
         EzHLHPEdn1fMRBv3HTxH5HENdPOFv5ESi8Y6xh3QPXvKVy7LukZs5EnQG7KqSZTtbrAH
         NhM04cvWcHKlHnpZb2+cqVet7X9FuAU2QgO9owVpDTM9x8/MGRSJqVN6s2N0LEhAS3h/
         FUKg==
X-Gm-Message-State: AOJu0Yxwv5QpcJ11en6yHFoSAneOE4WswQNoTt7y7JUCVNyuysHkc8IH
	T86FLX4C6xwgSAfLGZpbqMARc2zWVVKCGN45imUXCJsPA2KJ/6pSKxwfVa7+OYtUJBWBaQ7TylR
	MhWbiIg==
X-Google-Smtp-Source: AGHT+IFuwdL0e2irjXtVkdjRkTslOZU4HngmhB1oZFxTINPzEJyjeR2iQRAUtSAuEOfNTlToftODDWWwzwY=
X-Received: from pjc6.prod.google.com ([2002:a17:90b:2f46:b0:329:d461:9889])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:329e:b0:24e:84c9:e986
 with SMTP id adf61e73a8af0-2925d0dd333mr2318282637.15.1758243607520; Thu, 18
 Sep 2025 18:00:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:52 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: nVMX: Add consistency check for TSC_MULTIPLIER=0
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a missing consistency check on the TSC Multiplier being '0'.  Per the
SDM:

  If the "use TSC scaling" VM-execution control is 1, the TSC-multiplier
  must not be zero.

Fixes: d041b5ea9335 ("KVM: nVMX: Enable nested TSC scaling")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5ac7ad207ef7..eb838ebeff0f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2906,6 +2906,10 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING) &&
+	    CC(!vmcs12->tsc_multiplier))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.51.0.470.ga7dc726c21-goog


