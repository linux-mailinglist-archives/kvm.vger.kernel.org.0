Return-Path: <kvm+bounces-20504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAEE991744A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 00:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 695FB287160
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 22:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C93A17E905;
	Tue, 25 Jun 2024 22:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c+xHHygr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346C149C6E
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719354902; cv=none; b=Ngj3lSw/Z9OgEOabRMlMwvLQ1A8Ga1KDcrag0i9n/74ye4pr9Jb4nqNKVHOfoIFHdLYkzuOWegZAdzGTCLA1viBvFdOXgfheOwFPDaF2GLInaaja3pWhqnitC11QkT/E46Fr5rwP/o0fpHXZsykx2FmRqvYSrxCMGCiGyhC6/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719354902; c=relaxed/simple;
	bh=91Z7ox9LiBjORVtCWaAzB8GD58RrfZz+zWI0Wxs5FyY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kXidyBR8NmWjEWM4ir9dcoU5zZUxxiZDnOEI4vinUgTmULCoeTmn2lF9R3It3jsttm4rO90SifMzPvEDnDDXkw4dSan78HPVAD4v5/ZJN3l60hkKiQW/VwEvqVCDwgSTHXIb0xKQL8tCQ03DkruE0FDnBMm5A2y3PDiH2Y1vHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c+xHHygr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7065ba27265so6979307b3a.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 15:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719354900; x=1719959700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KACPm6o1sF6MfYdPebomXscoE9qCB1ha0g1j4OaH67g=;
        b=c+xHHygrtnx3ar0uqm0QnBauxwQRcQHGDB4+KqRa+qVZ6AP2sBSOHc2t4rAP+4xtc/
         jNZmyp0ZC7AD0QDzcMj5AeCn44eDwFQ+UJLGbapw0AMRut/OCLT/mzf7pIDvDdNb2Ufe
         OkknPhAsq+vcMblteP5T+SPFpGFKmz5gBuaDxzR2LSEV1dHxuBCRhvOBFoRqsofR4uat
         u7CqKcu3egVHcX5uGPl9xuv/4J8aMuF3xW+e6aWnqZ9/+x3BMOgIAkT8y54BdYAunfVY
         zpLSpfcBsZs+AVN45RRvjXvCqus4saGtRXR74luxea9WwS0pX8nd1ka+QQQJX/8QvRTp
         mAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719354900; x=1719959700;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KACPm6o1sF6MfYdPebomXscoE9qCB1ha0g1j4OaH67g=;
        b=N55yMdYk0LYheOeXpYhqDqujoQS/VHrWqMNE6tpQqA6Hwl/j4hilLvOdOO0MlYQK5k
         pxZhTb1ULgeI39hNuAMxQhdZhnQDoMhzg9ceGGXnaqEsGhURTFYNXgZ3sOScszGqcrUO
         8pH6Cb+uNCr5VtUI/IBGf2asGmP7QfasvDbJIgQDMe8nwU6fv3TeHM/igodATB0S7eSH
         ERllz2dxTWviJqFMEsU60rbrv12jOwpRVlsYm+hzKtvJU24cYI0mMn8UWW7poAX+yYQ1
         JrRaQ6TcE55OCxWOrqdlkxiQ6YRieFGrhZIBHV95TsoJNfxjnd3SUSPEbPzsGNAbmW1p
         Oh1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcW+zRrKIo+L0zvujnvLc49huu9vzbIjr+TrfP3SYfSsFvCTp1CFMX6PaWAIpKQ1iFk9pbDNVzMYhYRlV0FhclbQlw
X-Gm-Message-State: AOJu0Yxlx4VQoS/s8SPe1eMmpOuVzUMHD0VMPVxAC5m0MiEL8f/o7aEY
	hzaqO66OBwUCFaLptHuB1yS3bMlsmezdFXY7MpkXL/XMqHbG6zHHMknw2WiedA4Xw2xDs0ybrm8
	NkA==
X-Google-Smtp-Source: AGHT+IFpOX5CcrzFldMsRz/JodHWPPYjtr1mfNvHUywvuU1/bJCVZhZ6TnspYz+fdShAF0CdfuxKj2ZiUg4=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6a00:3698:b0:706:3f17:ca6 with SMTP id
 d2e1a72fcca58-706746c2606mr330723b3a.3.1719354899705; Tue, 25 Jun 2024
 15:34:59 -0700 (PDT)
Date: Tue, 25 Jun 2024 22:34:44 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <20240625223454.1586259-1-edliaw@google.com>
Subject: [PATCH v7 0/1] Centralize _GNU_SOURCE definition into lib.mk
From: Edward Liaw <edliaw@google.com>
To: linux-kselftest@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	"=?UTF-8?q?Andr=C3=A9=20Almeida?=" <andrealmeid@igalia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, usama.anjum@collabora.com, seanjc@google.com, 
	kernel-team@android.com, Edward Liaw <edliaw@google.com>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Centralizes the definition of _GNU_SOURCE into lib.mk and addresses all
resulting macro redefinition warnings.

The initial attempt at this patch was abandoned because it affected
lines in many source files and caused a large amount of churn. However,
from earlier discussions, centralizing _GNU_SOURCE is still desireable.
This attempt limits the changes to 1 source file and 14 Makefiles.

This is condensed into a single commit to avoid redefinition warnings
from partial merges.

v1: https://lore.kernel.org/linux-kselftest/20240430235057.1351993-1-edliaw@google.com/
v2: https://lore.kernel.org/linux-kselftest/20240507214254.2787305-1-edliaw@google.com/
 - Add -D_GNU_SOURCE to KHDR_INCLUDES so that it is in a single
   location.
 - Remove #define _GNU_SOURCE from source code to resolve redefinition
   warnings.
v3: https://lore.kernel.org/linux-kselftest/20240509200022.253089-1-edliaw@google.com/
 - Rebase onto linux-next 20240508.
 - Split patches by directory.
 - Add -D_GNU_SOURCE directly to CFLAGS in lib.mk.
 - Delete additional _GNU_SOURCE definitions from source code in
   linux-next.
 - Delete additional -D_GNU_SOURCE flags from Makefiles.
v4: https://lore.kernel.org/linux-kselftest/20240510000842.410729-1-edliaw@google.com/
 - Rebase onto linux-next 20240509.
 - Remove Fixes tag from patches that drop _GNU_SOURCE definition.
 - Restore space between comment and includes for selftests/damon.
v5: https://lore.kernel.org/linux-kselftest/20240522005913.3540131-1-edliaw@google.com/
 - Rebase onto linux-next 20240521
 - Drop initial patches that modify KHDR_INCLUDES.
 - Incorporate Mark Brown's patch to replace static_assert with warning.
 - Don't drop #define _GNU_SOURCE from nolibc and wireguard.
 - Change Makefiles for x86 and vDSO to append to CFLAGS.
v6: https://lore.kernel.org/linux-kselftest/20240624232718.1154427-1-edliaw@google.com/
 - Rewrite patch to use -D_GNU_SOURCE= form in lib.mk.
 - Reduce the amount of churn significantly by allowing definition to
   coexist with source code macro defines.
v7:
 - Squash patch into a single commit.

Edward Liaw (1):
  selftests: Centralize -D_GNU_SOURCE= to CFLAGS in lib.mk

 tools/testing/selftests/exec/Makefile             | 1 -
 tools/testing/selftests/futex/functional/Makefile | 2 +-
 tools/testing/selftests/intel_pstate/Makefile     | 2 +-
 tools/testing/selftests/iommu/Makefile            | 2 --
 tools/testing/selftests/kvm/Makefile              | 2 +-
 tools/testing/selftests/lib.mk                    | 3 +++
 tools/testing/selftests/mm/thuge-gen.c            | 2 +-
 tools/testing/selftests/net/Makefile              | 2 +-
 tools/testing/selftests/net/tcp_ao/Makefile       | 2 +-
 tools/testing/selftests/proc/Makefile             | 1 -
 tools/testing/selftests/resctrl/Makefile          | 2 +-
 tools/testing/selftests/ring-buffer/Makefile      | 1 -
 tools/testing/selftests/riscv/mm/Makefile         | 2 +-
 tools/testing/selftests/sgx/Makefile              | 2 +-
 tools/testing/selftests/tmpfs/Makefile            | 1 -
 15 files changed, 12 insertions(+), 15 deletions(-)

--
2.45.2.803.g4e1b14247a-goog


