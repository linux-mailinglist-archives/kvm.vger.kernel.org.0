Return-Path: <kvm+bounces-21999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B80EF937E59
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 02:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA99F1C2145C
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 00:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CDA79DF;
	Sat, 20 Jul 2024 00:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ByBG8mQT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2258AA5
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 00:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433710; cv=none; b=TyooJCG5TfZD4zBKC9FlCdvaHlyXMMEp4YaDSs+7DRWAKhRxw1gEkz7N36zT+nVy/Bu8xntvczUlMIH2u0wceZtbIIlykPtIyM9oeUmTXNB5kYg+IXB6lJFlSxGVjneLQz5ymrrjwi1vko1gHsnHHZ+X8EUMjytzWdjHbX9bUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433710; c=relaxed/simple;
	bh=MFLtkL/1x53Q6UUfm7ynJX/aenkLzsfwcLQOqXgYplI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tMCGFN5Icy+gpGQLn1ygw8SoskhUzzQ+xHupS6laVzNOOdUYIAbMaom45XDAGCoELJUIR8YUhnWqA8DxrJjfk3YNx26alaRhKKLjEd/F3ZPFqDEW2yIWkclB1dlzJrdp1eAsQVPRajy1aN3n0+MGLNqtL7tMi4w6WkxxuW+E2nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ByBG8mQT; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e087a57edcaso134415276.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 17:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433708; x=1722038508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=htNTaIxfaR6n9UdbBaZJqnoxR10sdpaYRsT6NfFpXRs=;
        b=ByBG8mQT8CeUfe33B1X+e6VO/47WnVQ8KhIgbsLbvNLvOOYqjN93W4Di/h/6vnRv6u
         T9DJEKtyygfduPlOnXzzL1vHVrnhtmT3hW9da/ptP1+txzrIGov5NwhX8zcQAjgxMIDd
         d2duXEG86TSCNd6BLrJHgWJ25stqIClr+t4Drj7cuKNsoCyBhLAOddKdkhqZZBdwASzu
         W0V15yY+CQ6IxBxkfnjM4IXBTR486Sgy4xs2nF2jAMX4EaNdjh7bH3VhTCCq+DVvyDoA
         he5+0gzYtEJpT2DekUMmBu6WzB8iGoXg6Z+jn5/o4IHWdz4yPYBDuSGciVjpdw7n41Ag
         4YUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433708; x=1722038508;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=htNTaIxfaR6n9UdbBaZJqnoxR10sdpaYRsT6NfFpXRs=;
        b=PKlIKZCh8O7i5KZrW992sUuz4HPXxHE9DkK/B40RhnYm6zq6vTcjUTcMvAxnfwKhfb
         ghRlinJt7k5Z94Pw7IRazSazpGvzF1GzWlcWSk+W8ysgoc6ORWjUTimVyyP3ht9HIL1Z
         VmS2RsmGs3eEJHaQ7+Aqbnk5b0lB25ff0+TDrYjqKOucDrbYiSpWEfNLeh0glarN76ek
         edeR9vhYDId/Lj7jG5StGQK63jGqLtN1VDDaka+sEkgIOwkYn+ZL1qfpuIMEER2acpHB
         PLxGmKCOwNt+JRz7c84bYz5SVaslibsyZ3fSSfP9B13t9T+6g+TXTeRXRY1CI5xlWC0v
         a6cA==
X-Gm-Message-State: AOJu0Yz8velF1nZNw7x37JZbEc7LpuAeLaqFcVUFStx3kvlHn9opfKYg
	9VfaeVkYxdYtCcpNQPjKENlpIi0oB6E/4nggKxPHYEOSPMh/CzcP5z7aI+oXls9nKZFs3/VItsX
	tvg==
X-Google-Smtp-Source: AGHT+IFf5Ki3AK6jumi0dajUtxJd0gFSN1CWjiYodUX6vzIqzLQzbhvgvz6WRixdyl/5GA4Rn4URhEzNpxc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:870e:0:b0:e08:6c33:7334 with SMTP id
 3f1490d57ef6-e087044445emr31630276.8.1721433707785; Fri, 19 Jul 2024 17:01:47
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 17:01:36 -0700
In-Reply-To: <20240720000138.3027780-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240720000138.3027780-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: nVMX: Track nested_vmx.posted_intr_nv as a signed int
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"

Track nested_vmx.posted_intr_nv as a signed 32-bit integer instead of an
unsigned 16-bit integer so that it can be passed to kvm_cpu_get_interrupt()
without relying on sign-extension to do the right thing when the vector is
invalid, i.e. when it's -1.

No true functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 42498fa63abb..dc0921bc4569 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -208,7 +208,7 @@ struct nested_vmx {
 
 	struct pi_desc *pi_desc;
 	bool pi_pending;
-	u16 posted_intr_nv;
+	int posted_intr_nv;
 
 	struct hrtimer preemption_timer;
 	u64 preemption_timer_deadline;
-- 
2.45.2.1089.g2a221341d9-goog


