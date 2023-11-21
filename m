Return-Path: <kvm+bounces-2177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6307C7F2C30
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 12:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C9CF282856
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 11:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA33D48CFB;
	Tue, 21 Nov 2023 11:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b517btZr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A673612E;
	Tue, 21 Nov 2023 03:55:32 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1cf6373ce31so13277735ad.0;
        Tue, 21 Nov 2023 03:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700567732; x=1701172532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SUS5AAycUPra3QRb1a1l2OTUftQ2VV1hu5zt1uUQBW0=;
        b=b517btZruh6n8FTnOx8hf5CGFi8f+43DZhjblYLvPEkjDoOrrBSI5Eo94IeGXgvVAm
         DgWM2BfpdMbgRK7HyfRWwpEs67d2vxtTuPS8adcNveGJ0k6vpKdFkOWooaiBgp2RElFQ
         +00VslggcQM6IZ9mgqeRKFAvAdN0zir/gEMQvLE5F3afj6qG5Lu4+Y+xVrgij7tjB0wE
         seBiL0ewKEkbmZ7bd5FRf6v1JkTlUVssmUgIE1ymFWJMVvdjvKodirZug9G8/RHELEKW
         NwOT1/+FR3vQ3cmA3PPLvbBGXCY0yUOHyyz14lJxG6vuaYPEC9WbooScVCyiHhL9KmfR
         MXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700567732; x=1701172532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SUS5AAycUPra3QRb1a1l2OTUftQ2VV1hu5zt1uUQBW0=;
        b=ZCxwrvmYak+YG5edyrm/cnGcRCOSFF0moQOOqNyiM8XQXipKZAI1QeB9i5PL+yOtrr
         GV6vp+VRsfC88GzyGvkX22pQB/0AVarkV4vlzhsOkDXnSHln5mrlJdPT/aTZUG1J9NFg
         tPgAopT7Nef03BzukrHa0rKyXAY2phK8ZZh+VHHql5EIs24nT242l2rcxXbC2RQSArTc
         HTUsRptNkugZsiwjqJyfEuxV05ramPmkiCA5ztT7BPAG5ZEsiDU8BN8qktljMe9E8WIF
         wkBir5qjPElB9E8cxGJ1DGkfQA5VnR4b4ymRTsLkKbyRjlukzxA3BaynrCptxom7snn/
         BMuA==
X-Gm-Message-State: AOJu0YwNeoG/lDpy/S7iUqa2rHTL51h0ijGOUDOKPftFyFJ+/II3/1B7
	8+Zw7NXMnORoTEKL2KrD3Do=
X-Google-Smtp-Source: AGHT+IEjX1mBAAiTKr/KwPp1IPlnEypAJpeTZHK8MfhxHZUG5Q8grbkq+YAZIUMkNNWRiGHslBePuw==
X-Received: by 2002:a17:902:d4c6:b0:1cf:5806:564f with SMTP id o6-20020a170902d4c600b001cf5806564fmr3678872plg.10.1700567732047;
        Tue, 21 Nov 2023 03:55:32 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902740a00b001cc1dff5b86sm7685431pll.244.2023.11.21.03.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 03:55:31 -0800 (PST)
From: Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Like Xu <likexu@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Jinrong Liang <ljr.kernel@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Test the consistency of AMD PMU counters and their features
Date: Tue, 21 Nov 2023 19:54:48 +0800
Message-Id: <20231121115457.76269-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series is an addition to below patch set:
KVM: x86/pmu: selftests: Fixes and new tests
https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com/

Add selftests for AMD PMU counters, including tests for basic functionality
of AMD PMU counters, numbers of counters, AMD PMU versions, PerfCtrExtCore
and AMD PerfMonV2 features. Also adds PMI tests for Intel gp and fixed counters.

All patches have been tested on both Intel and AMD machines, with one exception
AMD Guest PerfMonV2 has not been tested on my AMD machine, as does not support
PerfMonV2.

If Sean fixed the issue of not enabling forced emulation to generate #UD when
applying the "KVM: x86/pmu: selftests: Fixes and new tests" patch set, then the
patch "KVM: selftests: Add forced emulation check to fix #UD" can be dropped.

Any feedback or suggestions are greatly appreciated.

Sincerely,

Jinrong

Jinrong Liang (9):
  KVM: selftests: Add forced emulation check to fix #UD
  KVM: selftests: Test gp counters overflow interrupt handling
  KVM: selftests: Test fixed counters overflow interrupt handling
  KVM: selftests: Add x86 feature and properties for AMD PMU in
    processor.h
  KVM: selftests: Test AMD PMU performance counters basic functions
  KVM: selftests: Test consistency of AMD PMU counters num
  KVM: selftests: Test consistency of PMU MSRs with AMD PMU version
  KVM: selftests: Test AMD Guest PerfCtrExtCore
  KVM: selftests: Test AMD Guest PerfMonV2

 .../selftests/kvm/include/x86_64/processor.h  |   3 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 446 ++++++++++++++++--
 2 files changed, 400 insertions(+), 49 deletions(-)


base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4
prerequisite-patch-id: e33e3cd1ff495ffdccfeca5c8247dc8af9996b08
prerequisite-patch-id: a46a885c36e440f09701b553d5b27cb53f6b660f
prerequisite-patch-id: a9ac79bbf777b3824f0c61c45a68f1308574ab79
prerequisite-patch-id: cd7b82618866160b5ac77199b681148dfb96e341
prerequisite-patch-id: df5d1c23dd98d83ba3606e84eb5f0a4cd834f52c
prerequisite-patch-id: e374d7ce66c66650f23c066690ab816f81e6c3e3
prerequisite-patch-id: 11f133be9680787fe69173777ef1ae448b23168c
prerequisite-patch-id: eea75162480ca828fb70395d5c224003ea5ae246
prerequisite-patch-id: 6b7b22b6b56dd28bd80404e1a295abef60ecfa9a
prerequisite-patch-id: 2a078271ce109bb526ded7d6eec12b4adbe26cff
prerequisite-patch-id: e51c5c2f34fc9fe587ce0eea6f11dc84af89a946
prerequisite-patch-id: 8c1c276fc6571a99301d18aa00ad8280d5a29faf
prerequisite-patch-id: 37d2f2895e22bae420401e8620410cd628e4fb39
prerequisite-patch-id: 1abba01ee49d71c38386afa9abf1794130e32a2c
prerequisite-patch-id: a7486fd15be405a864527090d473609d44a99c3b
prerequisite-patch-id: 41993b2eef8d1e2286ec04b3c1aa1a757792bafe
prerequisite-patch-id: 9442b1b4c370b1a68c32eaa6ce3ee4c5d549efd0
prerequisite-patch-id: 89b2e89917a89713d6a63cbd594f6979f4d06578
prerequisite-patch-id: 1e9fe564790f41cfd52ebafc412434608187d8db
prerequisite-patch-id: 7d0b2b4af888fe09eae85ebfe56b4daed71aa08c
prerequisite-patch-id: 4e6910c90ae769b7556f6aec40f5d600285fe4d0
prerequisite-patch-id: 5248bc19b00c94188b803a4f41fa19172701d7b0
prerequisite-patch-id: f9310c716dbdcbe9e3672e29d9e576064845d917
prerequisite-patch-id: 21b2c6b4878d2ce5a315627efa247240335ede1e
prerequisite-patch-id: e01570f8ff40aacba38f86454572803bd68a1d59
prerequisite-patch-id: 65eea4f11ce5e8f9836651c593b7e563b0404459
-- 
2.39.3


