Return-Path: <kvm+bounces-58884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4CFBA4A23
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D26004A1F14
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F127C299A84;
	Fri, 26 Sep 2025 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tr8rd6E9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9605423506F
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904282; cv=none; b=BBMJdpxYd+eEabFpOkAeIkTKamZxEEH5wPNjS4+ySj17L9jUu9YHjG81SYYtKNnEdS0OqK6bjVHv296qe7RyLzpKRlqc+Ho3JGSzUFEpUIfRaluYEEZsU1IPaVVdlzTtyXRIlAGVLG7zhvtvP0N4F0kQbIryYknz1s5h8LFGwNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904282; c=relaxed/simple;
	bh=7X7DAE+zbBabsCNjfRvfqvg2INWE+j2cApli2zX/d2E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Hv1d/f54iHcUa3cEUpzlrH+CiPXItScuLZrWSL3BF/LX8eG8hhMs0/7wLOAg/OplGNSyI8PnGx+g2G3EOgdl8CR2+O5MzI24JlUq+z/QOv3kkk9Y/XzX7ozkij3MrgFeTmvcxW4VDRqzCmGN8gzbowGEL+H4gI29sJs14vuAiHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tr8rd6E9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so3279024a91.1
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758904280; x=1759509080; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwZ8vbOlyUhKwRHywOdNUWwguAQ2SVVHlBzl21pTQ9U=;
        b=tr8rd6E9n9WVQz5bvqnbQU2ji4jhMg1Ht5nPI0+/RuXSFCJ/Z0qUar7IpGnWLKHiKJ
         Tc/BXpZX8SYht6OyrgG60mIMW4E5Yrn0ukzyrYCIKoFoErs/JugLNn0Yo6fQ9XS1tXF7
         yPhOMRwjgCe66lmBM5s37+AlfmqIzKJgZoMHKJwOmyNqggfoL9eugvuMdrnm05mxx7yw
         3rjN7qLCa+tE8UrHWemJjBtZSpguQ52BnpfA14B3l2ns0o8iCRGPJZTokGdJ7/gn04Q0
         7s6WjPfbc3xzigE7HoHjxSxnsbYVfWYxECMqDHJjhFGXSYA5AQ+oUPWLUdGzPC8s4QES
         41zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904280; x=1759509080;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AwZ8vbOlyUhKwRHywOdNUWwguAQ2SVVHlBzl21pTQ9U=;
        b=DLhJqznlqktnLOerwtIlrDj5xlhPNvl8OvBepIipzv3Sd1+zne0uhAK/bb1+LvWfjp
         on8LQyJCxtLpod1BswolotDqRkjFN6iTjT+tK1AYK8gyf3M52jqwIhSkdCga11L8GUks
         tgavbOsDxu73BGNElg7wJS2jInHWk6fFZQ9i/hZl/06s52vizN6DpvmbSgEoBXtwdM7E
         cMsQ84iAbNd4aAK52e7j6U5rZzfTPMWUoEsFtG8aQjjEPk7IKVqWc34YyoPhNGYwO3/r
         zx2F2+lKLnkcMd2xHAYO6iuchS2j2cwa7QpjbdqXXQmWu9MRJufWTBiWg3pk9hASBYY3
         1rsw==
X-Gm-Message-State: AOJu0YymNra26wSPQT3HMtDL2ZEAU2yETTJkYCYiZiE7DkYgJFvP0jra
	ZGUEfyGLCLZ3H/3neym0tb8xke7Hra2rmcQJnOREONM/z0j0MrgdXLMGfr3ltT8WKHmUD/o6eqU
	CZ/TV4Q==
X-Google-Smtp-Source: AGHT+IFySj9OYn2E4SgNIDe+xEiiRQ+ki7OWkDXB6YQkV7vuARDWepbSyLDRR6oOY3K5Xs8YlexYlJX3xDk=
X-Received: from pjvf7.prod.google.com ([2002:a17:90a:da87:b0:330:49f5:c0a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acc:b0:32e:38b0:15f4
 with SMTP id 98e67ed59e1d1-3342a22bf2emr7709699a91.7.1758904279954; Fri, 26
 Sep 2025 09:31:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 09:31:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926163114.2626257-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: Avoid a lurking guest_memfd ABI mess
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a guest_memfd flag, DEFAULT_SHARED, to let userspace explicitly state
whether the underlying memory should default to private vs. shared.  As-is,
the default state is implicitly derived from the MMAP flag: guest_memfd
without MMAP is private, and with MMAP is shared.  That implicit behavior
is going to create a mess of an ABI once in-place conversion support comes
along.

If the default state is implicit, then x86 CoCo VMs will end up with defaul=
t
state that varies based on whether or not a guest_memfd instance is
configured for mmap() support.  To avoid breaking guest<=3D>host ABI for Co=
Co
VMs when utilizing in-place conversion, i.e. MMAP, userspace would need to
immediately convert all memory from shared=3D>private.

Ackerley's RFC for in-place conversion fudged around this by adding a flag
to let userspace set the default to _private_, but that will result in a
messy and hard to document ABI.  For x86 CoCo VMs, memory would be private
by default, unless MMAP but not INIT_PRIVATE is specified.  For everything
else, memory would be shared by default, sort of?  Because without MMAP,
the memory would be inaccessible, leading to Schr=C3=B6dinger's cat situati=
on.

Since odds are very good we'll end up with a flag of some kind, add one now
(for 6.18) so that the default state is explicit and simple: without
DEFAULT_SHARED =3D=3D private, with DEFAULT_SHARED =3D=3D shared.

As a bonus, this allows for adding test coverage that KVM rejects faults to
private memory.

Ackerley Tng (1):
  KVM: selftests: Add test coverage for guest_memfd without
    GUEST_MEMFD_FLAG_MMAP

Sean Christopherson (5):
  KVM: guest_memfd: Add DEFAULT_SHARED flag, reject user page faults if
    not set
  KVM: selftests: Stash the host page size in a global in the
    guest_memfd test
  KVM: selftests: Create a new guest_memfd for each testcase
  KVM: selftests: Add wrappers for mmap() and munmap() to assert success
  KVM: selftests: Verify that faulting in private guest_memfd memory
    fails

 Documentation/virt/kvm/api.rst                |  10 +-
 include/uapi/linux/kvm.h                      |   3 +-
 .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++-------
 .../testing/selftests/kvm/include/kvm_util.h  |  25 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  44 ++---
 tools/testing/selftests/kvm/mmu_stress_test.c |   5 +-
 .../selftests/kvm/s390/ucontrol_test.c        |  16 +-
 .../selftests/kvm/set_memory_region_test.c    |  17 +-
 virt/kvm/guest_memfd.c                        |   6 +-
 9 files changed, 169 insertions(+), 119 deletions(-)


base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
--=20
2.51.0.536.g15c5d4f767-goog


