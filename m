Return-Path: <kvm+bounces-34200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 675C99F89A2
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A77918891DD
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4595D19D06A;
	Fri, 20 Dec 2024 01:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="erNjRo9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03EB17BEBF
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658762; cv=none; b=Nw6KbtKiePVTRtKTDj89ltJC70ybyarhAvQT8k6gs2+nL72txoGhyssS9tEw0tIj1UIqZ2CaXIBYY6p5DE2QWyGhtw3RL3RrUjKLiPKzoSLZxm9REa4cIIpWUpVOyUj3kIYtNZvil4jfulNnG6FwW9nVs7n6OfGjr4QdWpWwVZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658762; c=relaxed/simple;
	bh=9wCSd3rSLA4oI57Um3yrK2ezfr59o98xEdgio1tOA1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QCobldvoJLns7WZNFz3my9RI9hsaiuGDn2peHp3TgCk9BXLFNxU3cbUtX1eDtfUsdU+idInC6GaHHoYWr9dguQ1qbBGi/9Ckxs9eQ6snL3dc5CwSQFUhGKa6SKVNvuikd53drdlpFXOrD8jSy6lUmCsQIG4a6Er6EwOb4sk2p4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=erNjRo9o; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-726047a4bd1so2076179b3a.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658759; x=1735263559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=erNjRo9o5pMkDoGgzTfCqC3ihalDYxXLpQQu7fK50HkzRzUy6HV8VejFh8pZD+R/o3
         O+LZQa5rHCxMQkwIJolmjFqyBusck02/RccF329IvONeNV2/FIxjMe+M5F+Hv2z9kIgz
         Ejh31getAyQ7CFIF80pkcWhxpa7xidrAMOqsH9l4muf3dwtQZGq0FxT0klsodL8JV3Oc
         +FNd8VhqZiDLoovRMsDN1WtwyXlQXLd3LOVQ2okjE4d87Z8wCJrO7NIZPMmiEvtBfSmi
         O3pxfJ0RYt2miyMNbAOgvP1ZTeq07MvnX6Xu361af83an/prpLCSIF3Q+1jRj029nkKi
         YlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658759; x=1735263559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9d0sb2aXj7DAHSi3NyOXr17347erebt+0rHoY2hViJM=;
        b=objCpuAoBM80kurTf0AK+74CBWX9TOr2PXSFnane7ONsuQXhMcO+R3+tKjzc3hZUf6
         JJpPmdruAqEyja8ic+/XRZnoLdM5ouR3VKgo6zaQ01ilnPq+jn1tW6Yr0Q/lKTBjfWeM
         EnTPYt9EclPHczNvyWGqwR/lH46qinef2Cj+V6XiT7uel1+0Y1yKPqrof4rFg1fcINfu
         40teYiCAK6WDcfJRJcejH50hlgu9oRO/BH3YB97JW221eisUWbXnoGYBVbcdG/7BibBX
         WcZXv9kGIzo4WcgYtvK+13Q+a30NFl8M2WjKwW1KuZhf/cmsDqQIxxXhxzai2mMGLIdx
         U4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0HYRRjLnvUK1TgReQtlf0lsrNwf9G2tbWDw3yp8XTybEZz3oo+n7/seF5xeEDDyhAOAc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvFvwS2cb7mMwOJ6/OergjmjwN9WPnIR5etQ+BR8dKvyTYAQKy
	T4w/Pl/JI8vcDSd2JLQ1avbkxfuwZVS65n/WGP+41C20/N8l33GNieZohy/ADpNPaMEi2gvwRtE
	QDQ==
X-Google-Smtp-Source: AGHT+IFCVSOEBNw3Lv/7iuAoV97N3pDi0VWzw4l+AQLpoLja8FzKhTyc8mSa5fPmEkzN6L6pcIM/EKjTQ3o=
X-Received: from pfbby5.prod.google.com ([2002:a05:6a00:4005:b0:725:e39e:1055])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3cc2:b0:71e:4cff:2654
 with SMTP id d2e1a72fcca58-72abdd6eb8cmr1219933b3a.6.1734658759224; Thu, 19
 Dec 2024 17:39:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:04 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: selftests: Get VM's binary stats FD when opening VM
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


