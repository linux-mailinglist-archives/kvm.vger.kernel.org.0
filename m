Return-Path: <kvm+bounces-35180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68F0A09FBB
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA7F93A1ED5
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD25158DD9;
	Sat, 11 Jan 2025 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H8cNZlc6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAF915098A
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556663; cv=none; b=TWcZHVbgO3UgTtJ8z0wHsWZVdj3oz3mqmqEFmWPP+N7IUqX3keDRuWJhdnQTSZCBRAz0jBPFKDxhzC2kuy1xUcvMf+ZwZTMPkuxQkPbu3JsNBy+BZ/oRGWKzGnCEVcS2gAXlisaAwD4Wfg113Bi45CjYcLymBKJcomODMXj2YAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556663; c=relaxed/simple;
	bh=9wCSd3rSLA4oI57Um3yrK2ezfr59o98xEdgio1tOA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=En1c3yrz/hVAhKrvR6n0skmEIVvD6pniDqD1Rwreg28VhqNcbKyOdup9bzeehcAT2WdilpuJefBCiFG+K3GYJkIckqGM3cI+py5199cH1pYvjbTIm3+vl2CGFLgT4CkPMfbkfTM4rVtwXkzGdT9/Jh0BbnwN6ZcPcHH5vmbNhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H8cNZlc6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efa74481fdso4777877a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556662; x=1737161462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=H8cNZlc6tDTrxCDUjw05dZs8eqIrZRwhHA7BCspiemMfAw56X3j8rskLOJVHIcONCP
         iKqGyFYQeLBsWDQgIfcc1chpB8rGX3iXOfc0VvFSzCfHQf/Zz2Ow6f0vyTcVPKD4J4ID
         +QHYR8e1o9K0crzSFF5kZG6X+IcoHOSHNSWM0S7NWDNi6lg7zyBhwMdVKGcLLslMcgsy
         h5EeTm6tNtyuUHF3oTR7YRC5htZKJjNqydix3bipSTZeDc0ws8olZJM/dw6/WF4BMzHR
         sIWGw3mH3qANH+bLechbhGpQ05EX453F87iMvvtcMKIxpTzcyUDbIfF6bDgQCfpBl9Cp
         Mesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556662; x=1737161462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=YKXGlAuJXMgRCmBvKxC+1mkpXkUvcHN0aPJg0SPS9kW4/XtCQXS8fWUbwhZ/asKw7r
         5LchoOXC0QiKEzY01Q/Y2izgWV4nO3/orxJg6xe7h9bcy1nWEpJ1VqZk3cyN8GMvr+1k
         Ue7xJTe0LJxVyRyubCPN86XANBW6LKI4rdvRgnM67n37CTr/FXwKCPjegGXpoov5RHHY
         VtjqTxGW0ZfKxtry5WItOGSFG7rurxUgItxHoH7sFfmD7qJGMO5JGg2ScL1OBO/mWroY
         4A3omqzK2JwvsqDoSPLsz9E+jPxhjn+YxbcteizRbpFKM0225rR4iytgg5CXpeG3yJVu
         9SnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsgpyEYkIZyKcLMZrxrUazbFpulfr919UB+zs0drXBzGaH+7TkSUMSNgg0kWslqvTJjxI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkvxoRB7k7JpnkgbsKTnn4nkgsRG1tR7A+WQ4TlsaIvRRc1Itf
	Q5o5u5K/RlpqQTgJD66doQDhERVJbbs0XUq0mdGXWTpEQK3/RLnzWCBBywG7nTHAzguz3k2dn7R
	6jw==
X-Google-Smtp-Source: AGHT+IGlLX0aEPqXGbQsPjSqI3Z9q/GgP2EA9enACEq8PUpXduEFLRvRbXw1OHEj1+uEtI1vezl+E8v1zzM=
X-Received: from pjbnw2.prod.google.com ([2002:a17:90b:2542:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c5:b0:2f4:423a:8fb2
 with SMTP id 98e67ed59e1d1-2f548eca27emr18806754a91.20.1736556661971; Fri, 10
 Jan 2025 16:51:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:46 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-7-seanjc@google.com>
Subject: [PATCH v2 6/9] KVM: selftests: Get VM's binary stats FD when opening VM
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

Get and cache a VM's binary stats FD when the VM is opened, as opposed to
waiting until the stats are first used.  Opening the stats FD outside of
__vm_get_stat() will allow converting it to a scope-agnostic helper.

Note, this doesn't interfere with kvm_binary_stats_test's testcase that
verifies a stats FD can be used after its own VM's FD is closed, as the
cached FD is also closed during kvm_vm_free().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c88f5e7871f7..16ee03e76d66 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -196,6 +196,11 @@ static void vm_open(struct kvm_vm *vm)
 
 	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
 	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
+
+	if (kvm_has_cap(KVM_CAP_BINARY_STATS_FD))
+		vm->stats.fd = vm_get_stats_fd(vm);
+	else
+		vm->stats.fd = -1;
 }
 
 const char *vm_guest_mode_string(uint32_t i)
@@ -661,14 +666,17 @@ static void kvm_stats_release(struct kvm_binary_stats *stats)
 {
 	int ret;
 
-	if (!stats->desc)
+	if (stats->fd < 0)
 		return;
 
-	free(stats->desc);
-	stats->desc = NULL;
+	if (stats->desc) {
+		free(stats->desc);
+		stats->desc = NULL;
+	}
 
 	ret = close(stats->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	stats->fd = -1;
 }
 
 __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
@@ -2231,7 +2239,6 @@ void __vm_get_stat(struct kvm_vm *vm, const char *name, uint64_t *data,
 	int i;
 
 	if (!stats->desc) {
-		stats->fd = vm_get_stats_fd(vm);
 		read_stats_header(stats->fd, &stats->header);
 		stats->desc = read_stats_descriptors(stats->fd, &stats->header);
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog


