Return-Path: <kvm+bounces-35174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53910A09FAF
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CAAB3A80DF
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8700DD299;
	Sat, 11 Jan 2025 00:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOeOfTcf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F8634
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556653; cv=none; b=ogHg1PPmH9YWvbO/3CvBZFMg/Ub8cUjtdrOLoWZFvxz5MMtTQMO0wPwBTQrf8GAuYyF68h7e2wfAhwhQ3MTny+zfu4cxWUFVIa5b5bV3DnHtlPvz2Sm333pn4Z49WW/exc/Ii+V0ZXFkAxDeaH8ZevHH7KAvAnaIKL8d0tK8ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556653; c=relaxed/simple;
	bh=kul+Fw4DW6osdE/Z2GoPabxZf5HTWm/6V8saFNmXeC0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H3gOaPL4koE8w+gty01TgEMyqeGVqk8sQ1hnIfvDH7gEYPw3IwofBEQ/UUvOsG5UN1EQqdcDK/PH1v44eNfGMOwE0ObZ6pyx61PV+sYbHAXq0Y2M0XQgqse/DyteTjssIh/mbL2pEJ6RrDg4fzV5fgBApkf3XC5rl4YCSInGqMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOeOfTcf; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efa0eb9dacso4827637a91.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556652; x=1737161452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xron+KThU7T77R5VL2QV4m0fAH5NzD4XXNwhcBHEXQ=;
        b=zOeOfTcfKH+ZQfrz7ABQmoiuYih5lDbKsFY6HCUkRlmttJF2Phaovqeo7pa+ulHEVo
         i3A+k7IEno1pKfxygSo4V2sFFZgnCBjCE469E+gFiXTHuJg8qi0jFDqQGgBfqV7EZ+ZY
         Pu47VyxcqvlnJ9AA6Q/b+4xCAK6N1/oM0lKAdmqvwO+L/aL/eFfwIwaF6JOmf04sU2lu
         4ypCzMtzkGMeHs3ez0qrEsF7nD7EElApVRp1Q0HM8CafMW6wSPIC/Gy2aoWFQhAReD0x
         9i50xMmssa/YkKp/20YT8kKCKHfXUy6Xif96j+O5CUzEQSOaFXrHifZzHsQlppI3vABY
         XWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556652; x=1737161452;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xron+KThU7T77R5VL2QV4m0fAH5NzD4XXNwhcBHEXQ=;
        b=H2oSkIXoLHpuIQxs6hL3HPT4ACEeU8RAQ2NfmqOf+FCJRch7xraEebqzKD4Zi+c6eV
         BdWQrKKET7k2lfoZbr2Vq6clG4A10yvhIo/wXVmHNwP3AWp9VIyp01VNwNLqpjXMoV+i
         spEUxg337lF4242K7WnWTsSWjBcX4wUR+wxisJmIbN6tyqJEpkmxjY0DN/yxkqbTpsPi
         yv/P68gR6wUNWOtTZwGnujYo/9P3K2vm6ckOcNjLWc3dIL8oE33mxt1wF5KQumebm5yy
         3exlZDJCb4kbFU5ddWWe/Oo2xRZ7DlxG0emwwHBsr5rroE9DpCJLMn98CDaKqnqDfWlG
         GETg==
X-Forwarded-Encrypted: i=1; AJvYcCWls/SSqQQiC0jMJXRSRvbNlTnPDuBQEmXEMVpi0VuvxiKfYZmnHdior5A6p60D25n/c5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMAR6xrCgTISeoMtJgy7CjGcBOLA6PGP2745Ep0HuJ1PuMYkil
	uYBQ4jtyh/aR9dv3edqbJoU+W6T2jq19LBEefON4ZaExKsewieaHZdFwX28av4tH5+8uJiR7kNS
	5BQ==
X-Google-Smtp-Source: AGHT+IFGHtmLK/IYHq0Rf1GMc11fdZBgGQoU3n0wFrQS04Q/FED/wp6nrTmZr2LCO3EYVe3us4g7I58uwQQ=
X-Received: from pjbqi13.prod.google.com ([2002:a17:90b:274d:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a44:b0:2ea:61de:38f7
 with SMTP id 98e67ed59e1d1-2f548f1d420mr19019162a91.29.1736556651751; Fri, 10
 Jan 2025 16:50:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-1-seanjc@google.com>
Subject: [PATCH v2 0/9] KVM: selftests: Binary stats fixes and infra updates
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

Fix a handful of bugs in the binary stats infrastructure, expand support
to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
getting a stat that actually exists.

Most of the bugs are benign, and AFAICT, none actually cause problems in
the current code base.  The worst of the bugs is lack of validation that
the requested stat actually exists, which is quite annoying if someone
fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.

As called out multiple times in v1, I'm on the fence regarding the last
patch (compile-time assertions).  My plan is to apply everything except the
last patch fairly quickly, so that the vCPU stats stuff in particular can be
used in x86 tests, and hold off on the compile-time assertion goo until
someone comes along with a strong opinion one way or the other.

v2:
 - Update rlimit number of files for all "standard" VMs.
 - Account for the vCPU stats fd when updating rlimits.

v1: https://lore.kernel.org/all/20241220013906.3518334-1-seanjc@google.com

Sean Christopherson (9):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Adjust number of files rlimit for all "standard" VMs
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

 .../kvm/include/arm64/kvm_util_arch.h         |  12 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  51 ++++++--
 .../selftests/kvm/include/kvm_util_types.h    |   6 +
 .../kvm/include/riscv/kvm_util_arch.h         |  14 +++
 .../kvm/include/s390/kvm_util_arch.h          | 113 +++++++++++++++++
 .../selftests/kvm/include/x86/kvm_util_arch.h |  52 ++++++++
 .../selftests/kvm/kvm_create_max_vcpus.c      |  28 +----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 114 ++++++++++++------
 .../kvm/x86/dirty_log_page_splitting_test.c   |   6 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   2 +
 11 files changed, 324 insertions(+), 78 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog


