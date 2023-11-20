Return-Path: <kvm+bounces-2066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F42E7F1343
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C065A1C21235
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 12:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7881A5AF;
	Mon, 20 Nov 2023 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecjwnwOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBE4CF
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:30 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-357cc880bd8so15960975ab.0
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 04:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700483369; x=1701088169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qj9gaId9xEkTbj+GKHFV9m1w8BlvLjGL5meXwVroxI0=;
        b=ecjwnwOBBnFCxGo1rXzGLKjRxbHmf0krg44kCWuD9hEsOER3LWMqXWvG8bKedR0u9D
         GfJoANoIxRtmkv0EqT9oh3gi5Y+3JEs22QkOdqgmwS/f9qKF7dG4NKzTkVfAgNrtVJs1
         moA0tdrxR3mSdmBovUbqNU3eIf+hzR4hKlyYwpvhBHfpO0ecDeEVt21d1VEHcGzQZMOq
         aKzhw048sL8DQuEktTxYRBj+NUjqsTH2UbzLoxEBFChX4/OuE2v2V5OkCg2+1yKVZhTN
         YSX6nR5wpBEkyDfeRvuw2ImahYmO5xLksqtCYTjIcvsUncjpnLZjXxlMzwg8cFDKYSwN
         gStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700483369; x=1701088169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qj9gaId9xEkTbj+GKHFV9m1w8BlvLjGL5meXwVroxI0=;
        b=O7M5899jnpeP8eG1nfPoRkAJXuEZnG42J0qX4sDnitUg7/HvaKZgzXL91/e9OhyBwi
         fudQuERPfPR1A1UcYeqgiXcSy8xrcgqqJSEia307+kvdc++W3pXgHV/P1Yt/OA4AvhRx
         ErbkaER/cVSfIWchM6IA2YJwIDHxC+/A5S88d3DR8sdxlUHFn8UIBWqmBTTO1mvSEmna
         VOHa0uDYT7kWQ4Cr68Zq6WySQd0kRfAOdjzNne9ViG9EoFyHrdKDdr+OWia/vU6z+XgQ
         2ReEY+eL4Ptc47TfMWG2X+d0i8/qtYK0ijEGZA1G5eTIFfTqsAmpyIjfaBdIH4uQSElw
         jaZw==
X-Gm-Message-State: AOJu0YwxKPILTg7nE4Z/fcPZSPgIerc/KEE1cPm/ztI8FHE+Z9yP2MYf
	ov0lsTrwijxl8rUzF28qWysIJlOSuRA=
X-Google-Smtp-Source: AGHT+IHZZsyYedWaWMSYwWWXg7I2MCnNDE3YGQORTYXde6OKJ02OZBJot3h47lsTEMhcR70RVJH+kw==
X-Received: by 2002:a92:c844:0:b0:35b:cca:a55f with SMTP id b4-20020a92c844000000b0035b0ccaa55fmr500989ilq.2.1700483369574;
        Mon, 20 Nov 2023 04:29:29 -0800 (PST)
Received: from wheely.local0.net (203-219-179-16.tpgi.com.au. [203.219.179.16])
        by smtp.gmail.com with ESMTPSA id d13-20020a056a00244d00b00690fe1c928csm6047477pfj.147.2023.11.20.04.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 04:29:28 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	Sean Christopherson <seanjc@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH v4 0/4] KVM: selftests: add powerpc support
Date: Mon, 20 Nov 2023 22:29:16 +1000
Message-ID: <20231120122920.293076-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds initial KVM selftests support for powerpc
(64-bit, BookS, radix MMU).

Since v3:
https://lore.kernel.org/linuxppc-dev/20230608032425.59796-1-npiggin@gmail.com/
- Rebased to upstream (on top of Sean's ucall and guest assert
  rework).
- Drop powerpc specific tests for now, concentrate on base enablement.
- Fix a bunch of bugs and issues including the ones noticed by Joel
  in v3:
- Work around powerpc's max VCPU ID complexity to fix test case failure.
- Use TEST_REQUIRE for radix mode so hash hosts don't assert.
- Pack page table "fragments" in pages (like Linux kernel does), which
  fixes PTE memory consumption estimation and prevents the max memory
  test from failing with no memory for page tables.

Since v2:
- Added a couple of new tests (patch 5,6)
- Make default page size match host page size.
- Check for radix MMU capability.
- Build a few more of the generic tests.

Since v1:
- Update MAINTAINERS KVM PPC entry to include kvm selftests.
- Fixes and cleanups from Sean's review including new patch 1.
- Add 4K guest page support requiring new patch 2.

Thanks,
Nick

Nicholas Piggin (4):
  KVM: selftests: Move pgd_created check into virt_pgd_alloc
  KVM: selftests: Add aligned guest physical page allocator
  KVM: PPC: selftests: add support for powerpc
  KVM: PPC: selftests: powerpc enable kvm_create_max_vcpus test

 MAINTAINERS                                   |   2 +
 tools/testing/selftests/kvm/Makefile          |  20 +
 .../selftests/kvm/include/kvm_util_base.h     |  31 ++
 .../selftests/kvm/include/powerpc/hcall.h     |  17 +
 .../selftests/kvm/include/powerpc/ppc_asm.h   |  32 ++
 .../selftests/kvm/include/powerpc/processor.h |  39 ++
 .../selftests/kvm/include/powerpc/ucall.h     |  21 +
 .../selftests/kvm/kvm_create_max_vcpus.c      |   9 +
 .../selftests/kvm/lib/aarch64/processor.c     |   4 -
 tools/testing/selftests/kvm/lib/guest_modes.c |  27 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  56 ++-
 .../selftests/kvm/lib/powerpc/handlers.S      |  93 ++++
 .../testing/selftests/kvm/lib/powerpc/hcall.c |  45 ++
 .../selftests/kvm/lib/powerpc/processor.c     | 468 ++++++++++++++++++
 .../testing/selftests/kvm/lib/powerpc/ucall.c |  21 +
 .../selftests/kvm/lib/riscv/processor.c       |   4 -
 .../selftests/kvm/lib/s390x/processor.c       |   4 -
 .../selftests/kvm/lib/x86_64/processor.c      |   7 +-
 tools/testing/selftests/kvm/powerpc/helpers.h |  46 ++
 19 files changed, 908 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/hcall.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/ppc_asm.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/processor.h
 create mode 100644 tools/testing/selftests/kvm/include/powerpc/ucall.h
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/handlers.S
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/hcall.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/processor.c
 create mode 100644 tools/testing/selftests/kvm/lib/powerpc/ucall.c
 create mode 100644 tools/testing/selftests/kvm/powerpc/helpers.h

-- 
2.42.0


