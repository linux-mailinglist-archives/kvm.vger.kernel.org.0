Return-Path: <kvm+bounces-42269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17EDDA7701D
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 23:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41AB73AAC46
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 21:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9A121C189;
	Mon, 31 Mar 2025 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtRIxl4H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868328472
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743456634; cv=none; b=UjCJJEa1jYvRsGICkP+re5Zm788JhhH4L12j9+myfKTw89+egQ9POjnG/hIlaLt+5SVFJdcGpKdG6FU8HVav3yknSg2NrDdgXMttYL5s65rSCbpEoqvFG+gh00UazUuu9WaWN0ocX4TmINrUIE54BGY1xMeELiWc7riKzBhJyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743456634; c=relaxed/simple;
	bh=m+a1512eWC5Aolg7MHTyKu0JSZdfCl5aGM/QIhGmIPU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=oQg2s8OsGmu+uG3RvL6IQeup0bJbC9CpIQbjp65dExFHFc+wAwgY5XzzyF0eF8UKhd3OzDiFAJaITcFnlLHllOfAyOAVMnlTRxIbhA8jOXPgMtm1dpaA3oojIJq5t9dAk9jw9fbaKY+0Jcj3azwhpESVE2dpf5vk1f1jwbuLyE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CtRIxl4H; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-86d8c567446so1336374241.1
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 14:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743456631; x=1744061431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YnBVRG7AqLb7xr89r4O+vGsRgEAXMy8MYL822Tz4er4=;
        b=CtRIxl4HV+leW1rkrZzrwNC4YfTWr6UyN8yBSsUgDXPPOcLGDCTnbO5LIsaKmjDifI
         XbDbAPRSVDG/LfY11OVjCxwS/oHxxTYH6VsxW2+E8n6UvclwSx7x5MIpFTaLh62pc4Qm
         JtGKu80+RX7M3HojudsoIMpBKn8A7Fd2l98IbwbGGMdp5awGl0KpA4c9/haU+VU91tlC
         DRdtNua/ZXy53NprsaHfFl8vdaaRB3AXdk/7QgeFxZ0qUqdBx7Xf4qnCgFnVNSjACVaS
         XSQthcJWToHwk6gVYGdzskj2wmgWD6hFnOt2yoXooO3/LKmaVcgiguA1hxWJdYipldgk
         tkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743456631; x=1744061431;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YnBVRG7AqLb7xr89r4O+vGsRgEAXMy8MYL822Tz4er4=;
        b=RYwNTJQmAcqLrybhMbN3201gqn9NiLNco9rM5nyRdq+x8QoqkaSEOC7pVHyhnl2Tw8
         vOW8KtygVx5gmrsKhe15THc0/CZxyVJpkp6qw6IFzjGV2TcEgpSUcGmiZ2jx/IOBQYFc
         +QyaTbMHdwi7lrOAurCSgFHa+h1We5Ru7fM53+3eQTvhiGUldKRvsFYqnNZ+kKr6kvPn
         s/lbsO5EVVgJHgGmQID/mhccRy+uhPvP7Snr22d6jh134AykKmmyV/DMyBtbtw/OqgOq
         VRAoDA934wT8ibVsUgwyTWTy2DdDJURv4rOWEtOcdkrNgitpcqi6oTXHD/p/Gb2EB9nz
         ChSg==
X-Forwarded-Encrypted: i=1; AJvYcCUFTWuQJGg2rU61B+IT4fDvcfkr5UOJTlvwhdtFTC0PvGa0LfnPgldXgyKvc3qn/pYaC3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIIC3m1d2dP8AEwM9Nj2uYDrH2R+ZvoOmHL+hbLfv+p8tzyScr
	73I0zUwNZ1Bg8fpP9M0JZnxPUmGam/FlQMkaXLxJ6Bjz2S3HbAC4K6GRqMOq/pGKXupnJK7MfDX
	Wwuracp/8dxu8ig9L5g==
X-Google-Smtp-Source: AGHT+IFWVNNFOxiuezsuclw1+KNEMTqJF5KQh/veAmDaG6NDK/j85VNvjpwNcmZuM9lBmMP4/oNT8YmtEmU0cfcq
X-Received: from vsvo20.prod.google.com ([2002:a05:6102:3f94:b0:4bb:c5bf:4524])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3e08:b0:4bb:e511:15a3 with SMTP id ada2fe7eead31-4c6d38685demr7168495137.8.1743456631452;
 Mon, 31 Mar 2025 14:30:31 -0700 (PDT)
Date: Mon, 31 Mar 2025 21:30:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250331213025.3602082-1-jthoughton@google.com>
Subject: [PATCH v2 0/5] KVM: selftests: access_tracking_perf_test fixes for
 NUMA balancing and MGLRU
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

This series fixes some issues with access_tracking_perf_test when MGLRU
or NUMA balancing are in use.

With MGLRU, touching a page doesn't necessarily clear the Idle flag.
This has come up in the past, and the recommendation was to use MGLRU
generation numbers[1], which this series does.

With NUMA balancing, pages are temporarily mapped as PROT_NONE, so the
SPTEs will be zapped, losing the Accessed bits. The fix here is, in the
event we have lost access information to print a warning and continue
with the test, just like what we do if the test is running a nested VM.

A flag is added for the user to specify if they wish for the test to
always enforce or always skip this check.

Based on kvm/next.

Changelog:

v1[2] -> v2:
- Re-add clone3_selftests.h for cgroup selftests (thanks Michal!)
- Some comment fixes, patches 2 and 5 (thanks Maxim!).

[1]: https://lore.kernel.org/all/CAOUHufZeADNp_y=Ng+acmMMgnTR=ZGFZ7z-m6O47O=CmJauWjw@mail.gmail.com/
[2]: https://lore.kernel.org/kvm/20250327012350.1135621-1-jthoughton@google.com/

James Houghton (3):
  cgroup: selftests: Move cgroup_util into its own library
  KVM: selftests: Build and link selftests/cgroup/lib into KVM selftests
  KVM: selftests: access_tracking_perf_test: Use MGLRU for access
    tracking

Maxim Levitsky (1):
  KVM: selftests: access_tracking_perf_test: Add option to skip the
    sanity check

Sean Christopherson (1):
  KVM: selftests: Extract guts of THP accessor to standalone sysfs
    helpers

 tools/testing/selftests/cgroup/Makefile       |  21 +-
 .../selftests/cgroup/{ => lib}/cgroup_util.c  |   2 +-
 .../cgroup/{ => lib/include}/cgroup_util.h    |   4 +-
 .../testing/selftests/cgroup/lib/libcgroup.mk |  14 +
 tools/testing/selftests/kvm/Makefile.kvm      |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c | 263 ++++++++++--
 .../selftests/kvm/include/lru_gen_util.h      |  51 +++
 .../testing/selftests/kvm/include/test_util.h |   1 +
 .../testing/selftests/kvm/lib/lru_gen_util.c  | 383 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/test_util.c   |  42 +-
 10 files changed, 728 insertions(+), 57 deletions(-)
 rename tools/testing/selftests/cgroup/{ => lib}/cgroup_util.c (99%)
 rename tools/testing/selftests/cgroup/{ => lib/include}/cgroup_util.h (99%)
 create mode 100644 tools/testing/selftests/cgroup/lib/libcgroup.mk
 create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.472.ge94155a9ec-goog


