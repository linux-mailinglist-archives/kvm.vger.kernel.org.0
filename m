Return-Path: <kvm+bounces-55404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 777EFB3085B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 105CB7A5463
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9B42D63EE;
	Thu, 21 Aug 2025 21:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h9B1gb/R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A32393DD8
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755811857; cv=none; b=ILWzOHuUqLIalAL4hNe6Pnj/q1M+wD7GX4vnRfFakOPHc0DyyQWH7i6ayIZ7CbU0TvznOoGED3/7KjPBed3XYnnff3VREnUf4Twpu/Opsop5rIyRn1g56LmbcaWX+wUIUjKLT+dXYqQPdrCuirTRqCgkesLDBDdDzkKg/Q10Eqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755811857; c=relaxed/simple;
	bh=l7JTVyDBrwzdzqWLgh5q55rpbseIAgVg8/axsZmM+FE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bwhUHwKEXr6AMqPSKUyFiiaNK4cRyZe0FEmAEHdhXmUCsaSvnPeY+1aXrRh5vcUhkdghincKEFLHf4e3cN1pyVAyDeMCLTWexD4WFbJ47JxoFxq0c/ruc+SFEl8GYjV35BEtiPLxcyp6XglXgHbgchAujxNL5sr0L03dcoaEgSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h9B1gb/R; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806b18aso17874465ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755811855; x=1756416655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UshrE7OOl7JjfXKttbRRCQ1Mj74LXDuZR7lXZXts9I=;
        b=h9B1gb/RvusNBKlEwDjwOIvdrbrxs2yA/FSOV3L7NNt7wz0grTETg7aU3o8T/YV4Py
         AbS8H9NaMeIRczk/iF6UbVhZdTlnyq0SRDvNCNIfHZjBCJhpBSmYVPjY4z2A0UU2w8o+
         yvq8LrNb5+4kUbZXvQy6yFEp7J9aGt3JOq1KvQUaToF6VTIgiiu9BvnUY7XmynJNzdTk
         Vb6dSYsExv+D29QHidTZb4Nu7+DS+khgZ047pETipK53xgYlkdkDSIQtufGtzQBbdKnR
         2wMI7xH2W8tezta/HWfJVxPzdiw9dx7oyjVkC1f8m1xqFoFaFhwjPwgS9w7cuPdDqmQo
         yoSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755811855; x=1756416655;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4UshrE7OOl7JjfXKttbRRCQ1Mj74LXDuZR7lXZXts9I=;
        b=uZ5uLuz3lCU6prgV8Speyb3/98t6E0RMYzH/zOfKj2Jovd/zDxsIggVP6zh17T5S5d
         Z3Q0jdupz4ksE2pIRKbnpKVOojnzktq5q9bJ7TYZjEftblJmXshvMTC4RZAsR6o58M+t
         KWAWbKJw/F5I3JZZSwTDvj+eREhtncTUflv/Oygh+PnPx7PYRLRdO1bQ6cl+MShwo8Oq
         wNuuJKFijdcsNZwUWhBxTBhiOKEFhu35MkTSUgafA4ZzaFb9Rp7VAi+R1NaJLVxNNjW1
         e6iOr8HUA99WQPBmGlPEPixQDLPpJ+ZD/W2rqy+/WEhZ70XZBdPuq2vmU8nHnAx90qBe
         UPJA==
X-Gm-Message-State: AOJu0Yy1i04t6pfebjk0/0/SzCq3evGs+q5UPBDLEVVBzQHamhwIR1oJ
	lvjQnjimbHYbZavyvshF7bzBXOKnJphXmr4/Y+C5KhXUKw4DcQbtBwjvPaJMA3LodA88U8NbHw5
	Zz5SKVA==
X-Google-Smtp-Source: AGHT+IH9/+s14JjolRiI8pQgplitlbopysM6BqPdLF/bJGELfeS3x0vhBgc0qhEDQ4A+J2ImucEeDwEN7JU=
X-Received: from plbjy8.prod.google.com ([2002:a17:903:42c8:b0:240:3c5f:99d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d505:b0:242:a4f4:6b7d
 with SMTP id d9443c01a7336-2462ef20675mr9150355ad.28.1755811854925; Thu, 21
 Aug 2025 14:30:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:30:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821213051.3459190-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Two KVM fixes and a selftest fix
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a few small KVM x86 fixes, along with a rather ugly selftest
fix to resolve a collision with linux/overflow.h.  Sadly, my attempt at a
less ugly fix fell flat, as trying to share linux/overflow.h's definition
doesn't work since not all selftests add tools/include to their include path.

Unrelated to this pull request, shameless plug for the guest_memfd mmap()
series[1].  We'd like to get it merged sooner than later as there's a bit of a
logjam of guest_memfd code piling up.  And I've promised others I'll yolo it
into kvm-x86 at the end of next week if necessary :-)

Thanks!

P.S. the guest_memfd mmap() series needs one minor fixup in patch 23[2]:

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index b86bf89a71e0..b3ca6737f304 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -372,7 +372,7 @@ int main(int argc, char *argv[])
         */
        vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
        if (!vm_types)
-               vm_types = VM_TYPE_DEFAULT;
+               vm_types = BIT(VM_TYPE_DEFAULT);
 
        for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
                test_guest_memfd(vm_type);

[1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com
[2] https://lore.kernel.org/all/aIoWosN3UiPe2qQK@google.com


The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.17-rc7

for you to fetch changes up to dce1b33ed7430c7189b8cc1567498f9e6bf12731:

  selftests: harness: Rename is_signed_type() to avoid collision with overflow.h (2025-08-20 08:04:09 -0700)

----------------------------------------------------------------
KVM x86 fixes and a selftest fix for 6.17-rcN

 - Use array_index_nospec() to sanitize the target vCPU ID when handling PV
   IPIs and yields as the ID is guest-controlled.

 - Drop a superfluous cpumask_empty() check when reclaiming SEV memory, as
   the common case, by far, is that at least one CPU will have entered the
   VM, and wbnoinvd_on_cpus_mask() will naturally handle the rare case where
   the set of have_run_cpus is empty.

 - Rename the is_signed_type() macro in kselftest_harness.h to is_signed_var()
   to fix a collision with linux/overflow.h.  The collision generates compiler
   warnings due to the two macros having different implementations.

----------------------------------------------------------------
Sean Christopherson (1):
      selftests: harness: Rename is_signed_type() to avoid collision with overflow.h

Thijs Raymakers (1):
      KVM: x86: use array_index_nospec with indices that come from guest

Yury Norov (1):
      KVM: SEV: don't check have_run_cpus in sev_writeback_caches()

 arch/x86/kvm/lapic.c                        |  2 ++
 arch/x86/kvm/svm/sev.c                      | 10 +++-------
 arch/x86/kvm/x86.c                          |  7 +++++--
 tools/testing/selftests/kselftest_harness.h |  4 ++--
 4 files changed, 12 insertions(+), 11 deletions(-)

