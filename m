Return-Path: <kvm+bounces-35176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4B6A09FB6
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BAF97A4615
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1C37E76D;
	Sat, 11 Jan 2025 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3k1/kE34"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE0917C68
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556657; cv=none; b=SLQiPc8bqJQWkxCUhp2naelreNrbvJqq2ZncswCN2nXapDlvnQ+v7wr+Qj6DOGBdToznae4YCWOzX9esNGPE34yinfiP5VaAE6deklgFyzcsNdwZJ5qjC0MVAoE6KUh6Gdk1mRlMkINpHFulMIDnw/Ds8ELJo/m1wY9T3Vsruvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556657; c=relaxed/simple;
	bh=x+G/SKe65zYqmcjfUDWiwO99pE05MNdhz6X9PomzPYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DtpOpG8JAdAiLnNoDotGeXHzRK6UHtkhDSvKOeefwgMzbgMrzaBmIqL8SFNDkdvP865SJBN14s21WSRzzStfPwjUv6STlnrwXc0a9vVi15l5Lo+Ursla03yhEG7BqN9j7Q5vrSNvGgmxAlvYQe4IPa4T1HWoUroMk79cTiZqKNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3k1/kE34; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so6741439a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556655; x=1737161455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=3k1/kE34fc+PrW5E4NTe8JafA8gN6Vse0DJzI2TKOsBcrE/9J90BLF2zet+cczTUbJ
         yVJdGC/sHkjDlx5kOX4VMPgDHTPcoFF8LBjWir6avgwe9Bdy2qWZdkePQ8Tblm6b4Qgq
         w74ERK+HkrbU8tzjaJgSkY/gBDtD5xdkwM4urfQHUKKYo/QPfnXJJ2jiFyluZhub8ohN
         0/by6JyfIktB4s39spATY2bD4d7pgyaahgpNJJ1S1cj6uTDc9tPWJxD1GBu99AJh31UQ
         3Jz0XPRCyB6J4HmLijsO69xefnklH9BsijwAGFJq1Ekvuy9SGHIecWR/2HvPotxVt9d4
         eO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556655; x=1737161455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=uQY0gKe32hQ5h7O44UtwfHcgfmZiWd2RlkuCX1JB2W2F5XBh18XZGvVmP+CynM2EDP
         mWBXYzUOdfGN5HD96J+MdccMYLe39Od9MdpYULwL5bogItYG+hu5Szmri/HQ8gnwnwn2
         5dUdx8ZZxy8Otnt6D11j54eH0MeqSRipXpgFo6YnG3Bvi6ndEqRMqFvryLoh/J8B3045
         XECHZbfX1G/qlPZZXL6l7ckIXbn6Yx8P8j+q0J9DUEOrzVRRZym0IADG6bUv/uYAg/Jc
         BG3ygEkyfHDh53qI30aJ/nXJVV1PiUa1OCAMN5DZeyMriD12iJlXV3m8ztirOPzOh5t5
         Bz5w==
X-Forwarded-Encrypted: i=1; AJvYcCXZWVOdWEvqq0Bqsa3nWeqIR3EzNQJbSOy+KK0TkoDEVXUwKr+cAiOfLOjW11J9xVqxtkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxptelhwINrYl75fzJqhONtxwLxsI/UNxsmrNGYe/3QYrk4CdOt
	70QQF7sKrRjIAGexZkC8IjXJAG8doXN532i7NoBiNpoQBtZwGdXJUAkNZJ5cDplONA69gq4eikc
	+fQ==
X-Google-Smtp-Source: AGHT+IFaIgnmyMwcv0JpFmACh/zvowyMAMYrlakJCH8pPaULUTBzt/qI/JqGqmGqNNZlkEWD/D5dHaJ9LLc=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:2f4:47fc:7f17])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c83:b0:2ee:fa0c:cebc
 with SMTP id 98e67ed59e1d1-2f548ececc3mr18761170a91.20.1736556655284; Fri, 10
 Jan 2025 16:50:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:42 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-3-seanjc@google.com>
Subject: [PATCH v2 2/9] KVM: selftests: Close VM's binary stats FD when
 releasing VM
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

Close/free a VM's binary stats cache when the VM is released, not when the
VM is fully freed.  When a VM is re-created, e.g. for state save/restore
tests, the stats FD and descriptor points at the old, defunct VM.  The FD
is still valid, in that the underlying stats file won't be freed until the
FD is closed, but reading stats will always pull information from the old
VM.

Note, this is a benign bug in the current code base as none of the tests
that recreate VMs use binary stats.

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 91d295ef5d02..9138801ecb60 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -709,6 +709,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
 
 	ret = close(vmp->kvm_fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+
+	/* Free cached stats metadata and close FD */
+	if (vmp->stats_desc) {
+		free(vmp->stats_desc);
+		vmp->stats_desc = NULL;
+
+		ret = close(vmp->stats_fd);
+		TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	}
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -748,12 +757,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	if (vmp == NULL)
 		return;
 
-	/* Free cached stats metadata and close FD */
-	if (vmp->stats_desc) {
-		free(vmp->stats_desc);
-		close(vmp->stats_fd);
-	}
-
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
 		__vm_mem_region_delete(vmp, region);
-- 
2.47.1.613.gc27f4b7a9f-goog


