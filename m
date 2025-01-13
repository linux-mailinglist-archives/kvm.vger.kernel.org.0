Return-Path: <kvm+bounces-35332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A53A0C4A9
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 23:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5E1E7A358D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 22:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662E51FA14E;
	Mon, 13 Jan 2025 22:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fq58RQRH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263941F9EB3
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 22:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807267; cv=none; b=M6PmrZEDIW38yHrylTqiEueqxkk2iaffLAEgwbpDykiwrF+SmDrJC1isSrKuIb//uEWmO1lKeuxANxenn+RdUFWzcEv1TX+oJS5iOc/p3z6kmfF/tyHEMn11F6lvb4Wy4Q6cmRNRFNwIKKOSVPu9NjFDBtUcf+pYAFdWp+Tmo8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807267; c=relaxed/simple;
	bh=zqLBBXrug8v32oNQce0fAdA/PWXxsTOVhZ1W2PAUujg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hyhe16ZVJzsYHAbuQHWr4A9TtvH5VjHAz1aaRURuAr0npx4m5t1fLhVZfib+m2EoKZMwF5/aoUWH53IMhSO+/5RChbHrA8qEgq+1oemiiXdcB+p91s0Ix3qu1Y0/T4sAF5apKu21fT+47UMo8UKom7eZ8IpOTEniqEriYshGfq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fq58RQRH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso8690112a91.0
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 14:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736807265; x=1737412065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lOOaItQ8XjWrN4V+XnxPKIJp+wwpgWIYOMyymj/eGI4=;
        b=fq58RQRHVE7B25bcyzIUnGkKtG6O8D3+vBcC0+PWEwNE1fBg/cmE48lOcTxLVSysD6
         zS/PeK6zoPkY4WyXcuNqyXva+vlDRHVdHGAw7NzKZrG2o5oAgK5NJESfTJ+rzk2eQcUG
         fhZ+eLw8PYdhfuSq0A/qn4M3nHVzA19Afwm+bY9StQNKtiTJpNQzheQJBPA0ETsuVCLX
         6qS82tiHEN4C2hNqsERJWnQpm0v41ga+V+qFo8Ry8HA5vvV4/jETZayLjODvQGitXrhV
         i1dTTc7pHcYeC00xwL2YevBxtqfdf+IH8dHsqKhHGE37ka7tcDy4aVexMkSmANtHjemQ
         +VGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807265; x=1737412065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lOOaItQ8XjWrN4V+XnxPKIJp+wwpgWIYOMyymj/eGI4=;
        b=mgrG95XowKrMVdwEO4vEhY0G4tnkT4rqka4zYsgv+mT5UXVzXbuh+q3HHdTZOMR8yQ
         n/x3fx0Cz153Efo+VUR/DftSpxtwQpDoGpMId4AB3cwuDJ3hwZVgAnrd4ltKeMXtd0o8
         fHKunt8LAVcypI/SrcoAPYmyGAzfM6dMXRnMIpEQTruzeXNlZCJ4vVt7Tu5Fg3HtXUQn
         pSyeYSAaO5GmwzGQ56Ufh0X0OnKOlrNKyCIk7jj20yh7Wce8MR5IPzDQc7Uja6oOOW85
         Q9v17QqAJcjXaZdSNdAr+USO8gNNYM9cgYyAW8Pp9HTy8rcZQf08vpDbfMOMLQxYpTU+
         OY2A==
X-Gm-Message-State: AOJu0YwQKDafsejJf+nYrzpgUz0r0kfB2djHS8pZ2Vru0vyd2ye09vTQ
	xkQOspvq3PUwR3kc8tDmjVUKSC63DfHLVW7J2+ALQXR8LvRyeFbcEd6397FldckmAp24UUk4oR2
	jgg==
X-Google-Smtp-Source: AGHT+IE4SCIj0eT4MwfhXXuqwjQSQynoe//BaCPOdrBHH5GyAIKrqtS2BvL94oyZ9JQHJxJWpwkBjqq4Xkc=
X-Received: from pfbcz13.prod.google.com ([2002:aa7:930d:0:b0:724:f17d:ebd7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:8cc3:b0:1d9:2b51:3ccd
 with SMTP id adf61e73a8af0-1e88cf7ba29mr37755024637.7.1736807265389; Mon, 13
 Jan 2025 14:27:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 13 Jan 2025 14:27:37 -0800
In-Reply-To: <20250113222740.1481934-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113222740.1481934-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113222740.1481934-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: selftests: Mark test_hv_cpuid_e2big() static in
 Hyper-V CPUID test
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongjie Zou <zoudongjie@huawei.com>, stable@vger.kernel
Content-Type: text/plain; charset="UTF-8"

Make the Hyper-V CPUID test's local helper test_hv_cpuid_e2big() static,
it's not used outside of the test (and isn't intended to be).

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 4f5881d4ef66..9a0fcc713350 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -111,7 +111,7 @@ static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
 	}
 }
 
-void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+static void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 cpuid = {.nent = 0};
 	int ret;
-- 
2.47.1.688.g23fc6f90ad-goog


