Return-Path: <kvm+bounces-35175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 361F2A09FB2
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13C45188F388
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E7520322;
	Sat, 11 Jan 2025 00:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UIiFzzAn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8C98F5B
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556655; cv=none; b=rdzRY4pW79tz7yPzZXEWlHIc4k8bGNh3VGbJVcXhEYABOlSShCLq5kvMtWCipqzqb4wfixa3nBwp7L1aLraHpb8QbLZGbUyZ9AGtSU5RBJyrGGoGxi9NneFfoZ/abILeq2U1Se4uSEZ21CZcyI8ZDys9vxhHCn57IjJbksRCUQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556655; c=relaxed/simple;
	bh=vUAkr3IX2LE4GH/mlPkbcxzVyqeoUOtvVrlhcSINMSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhJkAMTMsgcnpSZ5KZqDOx0UCmLTfhILxU/fyIhq7Vphc3cZ4EIE9lP4Ms+e3fg05+EAgBaYrd+4K2wZ1pVRiOMt9C+pGSx/ZIfXcW/8AOv0dV9BhSl6j7/rD8OamPXR97ii09zgYMmVyrfwaZh9F4YJ3nncizMyP1PvXshmHpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UIiFzzAn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee5668e09bso4754423a91.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556653; x=1737161453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=UIiFzzAnCLF8pwfdsKDOa9+RSh4J7REE14bMqZgBrTey+t8lAiB3w2/nxkSCyuPKkB
         aGelRZy74X3UyNNcOfYshpOZItYeA3YrG6dGaNzYp74UEhbO6ohR5K97DPnCwyMvHDDB
         Yhz1rO2/RAMLdPIbRCxWeVQyaQpIYNcqXIw3q/lQRrizTYTcNvk46vooHxVMlI3cOsoV
         XkeVBxB0PglxuKAu3Jf+bkT6EGX7YtTj6QVN/4C/WKwJkzsN0HD8iyEkac//7R++li+7
         q45qU8LvNJRVeIczRfeojYouvaEqRBTDHiWlNK3GaJqAFtjqW+l0CiGgwnPux4E9B0Gc
         mlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556653; x=1737161453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYKvlAfMuP2ktBfEDhDytfcvSdR/S4IqDZKQdTsYjuw=;
        b=YeQrZ6OLiOcNml5HZK6olAFh2TQV+Np3UBUFGlu5JgLs4q8IC6IWDOo12x7rJN/Nnp
         VoeXAWOQ+NDGECMUKeE7lrYoaBlz2jSevuqeKZputxk/E6pr+i0pU4fTEIYqH8NdHFK8
         sX9Vn79wejyMnhWrTgn+yFS/jce70z1HVF4J1+qOTK+OVXjU/Q096xLVplehAPZ4Qrq2
         VbAHHsu0A4z8WUGsgtaLjnKYetvL31POjvQaAhpXDJP0e+Pcmb9ywYcoxr4t7rAj25v5
         6S13jLsffE3ORvpD0du89v7+GxTBOSQMHVn6OlRcrg/CbJkU8aTM5o3Ll8ERqdeFfBaO
         7bFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN7t0mlimQbHPxBsXUlOUIJf1x2OBxF6oAZc24ddkqec7J4IJ1xMd4BY3V53kTBXYE2iI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEMaxasdf6f5I+ppeqbWOvpnqP67dIT1J9+JfVeZm9sUNlqUVh
	wYsDJC5ejiI8r9mNY+JL73CH1DHL72CiQ2dYEnIaob4qS5hxUzOAX35uGNaBhJqrbYJbTLC18VN
	o7w==
X-Google-Smtp-Source: AGHT+IHC7L4dio3zRElUKJK6ZXLcnIeUcETaJFiIoDB9K4Jc3JVwsDgdf+5YQVS28IyDhPWQi08akvDOKi0=
X-Received: from pjbqi14.prod.google.com ([2002:a17:90b:274e:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0e:b0:2f4:49d8:e718
 with SMTP id 98e67ed59e1d1-2f548eac0bfmr19303629a91.9.1736556653508; Fri, 10
 Jan 2025 16:50:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:41 -0800
In-Reply-To: <20250111005049.1247555-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111005049.1247555-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-2-seanjc@google.com>
Subject: [PATCH v2 1/9] KVM: selftests: Fix mostly theoretical leak of VM's
 binary stats FD
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

When allocating and freeing a VM's cached binary stats info, check for a
NULL descriptor, not a '0' file descriptor, as '0' is a legal FD.  E.g. in
the unlikely scenario the kernel installs the stats FD at entry '0',
selftests would reallocate on the next __vm_get_stat() and/or fail to free
the stats in kvm_vm_free().

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 33fefeb3ca44..91d295ef5d02 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -749,7 +749,7 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		return;
 
 	/* Free cached stats metadata and close FD */
-	if (vmp->stats_fd) {
+	if (vmp->stats_desc) {
 		free(vmp->stats_desc);
 		close(vmp->stats_fd);
 	}
@@ -2218,7 +2218,7 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	size_t size_desc;
 	int i;
 
-	if (!vm->stats_fd) {
+	if (!vm->stats_desc) {
 		vm->stats_fd = vm_get_stats_fd(vm);
 		read_stats_header(vm->stats_fd, &vm->stats_header);
 		vm->stats_desc = read_stats_descriptors(vm->stats_fd,
-- 
2.47.1.613.gc27f4b7a9f-goog


