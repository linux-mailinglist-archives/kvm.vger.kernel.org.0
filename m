Return-Path: <kvm+bounces-35177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6222A09FB5
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:51:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E79AF3A9B78
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954504689;
	Sat, 11 Jan 2025 00:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3vTU0BZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E354438B
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556658; cv=none; b=tXFN1hgU26R3C/gW2/qwIOTMjw8EuhmrdQSAzk+6Kq45bHz0tOPKm4d6hYEA8AnlkJYdgGLKJaZuJBNvMV/cfZ2Ac0oE0/2jiktp+WT8MR/iUO1FOLmFeguHmH5giMpmJSakuw4o92EuKOdmFX7qvwbGQGH18SnjoK8zuqTMPJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556658; c=relaxed/simple;
	bh=nrdiuySPKeqHKMTcasOrezgYsu9kEOPLrcUW0My/0sA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hvssQ8gqVKQVDmVqAB8K8OxV/2z5SBP78+WYvNpivzoqHh9HDihIVnJG0/fTNIqULKq3Lz9ZYI9BxbpyQrZEopNyeSlnV8Vi104JQ1OVDauYtI/tjwhUkkSrjH5hYS0tcH/qGbAJFCk8Ns2JknKGYFSQdFq4LoygaqaMkIjR8AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3vTU0BZ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so4770375a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556657; x=1737161457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fmZxaHK89gYqxCqQ02UIn+br/dW4oBYWdpIBYGTzQvU=;
        b=c3vTU0BZmiilfNpcDBWixRMyuCSNHR3qGeZoFH82SoCHlrcNA9wck8QcjALikSXMgu
         L4slKuYpfNrnQV0NUwI2R/fASevloq3Twbg7PTHeTdG2u25gcKOwyQ+ofQdNDdtqd8/h
         nc217+FmzA3mJc9W5UUMuQGdAkfC210hsliG21eQqggP+4PhEgF5A9rZC1/mQZi5eaES
         QiifwpNwOdsVkoE3Dhqj10BH9BohWDzKkDihCqQhYne4CQIYoltzXH4sFtk8NOSA3sy/
         8P68hCzKo64A3PF9yV9Lmitom+2N1UYj5f+UhNwDfitmkCiL07Hk4zRaeK/oSmTfTCAr
         /ClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556657; x=1737161457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fmZxaHK89gYqxCqQ02UIn+br/dW4oBYWdpIBYGTzQvU=;
        b=EucOw+HrcAkZOv2Ey02WPt7h4qVwuz6FpGApQrKt63AlchOEUFoVy7ULSGeRuBsVrR
         82jQ546v1ZShboRW79umlMckK8lsr0im4qFLjBOck31CDmdFALsAZShvJNemVebxEA7m
         94ZdSwt+Jh17aE8EKelwCwAM81WhOcV35JSNMa4x9Btm4Tm9Gb3mWs7evAqX9QUnqKXr
         Ny9m7aHWyCJuUNb7kvH1fw4R4EI1PkXyY3oGVMs76K2QQBtp2fAn5qtDwjEDv020KaJv
         SoEMRCxJIJnGHBJRGX9mcL4iYICvds6YPUnU9AxfndJoAgrKF5OgGvnC60FbqigA4M9s
         yU8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUabR9P0/9d88gw+/9KNOm+zyRJ4MZEGqObY/CaMOslvknjQeTxO/04yTmXp7rHMCB/MN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoXv0JvISZ8U4f9DkpB/A+vyq32Pkabv8uiXVR/njBvtyhNjxj
	JT2u9GEBCSh4FP0pUJ+dHXaULSuYArbv8E81l5pDSStd82IHabqKhsuAWMY3nPP/iCNaJG5GsgR
	cxQ==
X-Google-Smtp-Source: AGHT+IEiPYhZFrxECLTpeRyhrniySkHxs86k154WoHT+4SPRvFRx2z0MZkxZdNLfF3LCv7K79vdra9fQLrE=
X-Received: from pjz13.prod.google.com ([2002:a17:90b:56cd:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cc5:b0:2ee:c91a:ad05
 with SMTP id 98e67ed59e1d1-2f548e984abmr17519047a91.3.1736556656714; Fri, 10
 Jan 2025 16:50:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:43 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-4-seanjc@google.com>
Subject: [PATCH v2 3/9] KVM: selftests: Assert that __vm_get_stat() actually
 finds a stat
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fail the test if it attempts to read a stat that doesn't exist, e.g. due
to a typo (hooray, strings), or because the test tried to get a stat for
the wrong scope.  As is, there's no indiciation of failure and @data is
left untouched, e.g. holds '0' or random stack data in most cases.

Fixes: 8448ec5993be ("KVM: selftests: Add NX huge pages test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9138801ecb60..21b5a6261106 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2238,9 +2238,10 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 
 		read_stat_data(vm->stats_fd, &vm->stats_header, desc,
 			       data, max_elements);
-
-		break;
+		return;
 	}
+
+	TEST_FAIL("Unabled to find stat '%s'", stat_name);
 }
 
 __weak void kvm_arch_vm_post_create(struct kvm_vm *vm)
-- 
2.47.1.613.gc27f4b7a9f-goog


