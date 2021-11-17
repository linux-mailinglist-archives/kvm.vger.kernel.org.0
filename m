Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BDE4547BD
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237592AbhKQNwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKQNwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:50 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5AFC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:51 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id r9-20020a7bc089000000b00332f4abf43fso3855224wmh.0
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TztRgo8Xm1UKJI3iHqEuco042aluvy1BUSaXGcjURmU=;
        b=oPSe04UC0xhFDJCipn3W9amyiFHzDYllIB0AAKhPUWOUt98H3mwkdMRhtiWK/GQI26
         fYEGeOiKSPXK+x4ygl9iKyvhJKBpZSof65a44pHgiOCWrxjEmrNGOYLz5OAo76TR/AHS
         snl6xmqbKWVfgsFJoLChOEvGh94NWffvdMdGZBpfiDd8aFzecYXE1wfQ3JUJ8zLBQRiT
         oNTm2TqRA/0OhIGHj+Wwa1w4osKMRTDqdks5TqWdC9OnbZTCL7UZuUJTnwbSV+2dWpvQ
         HWkjAKWX5UlpuGmGs/So7fI1qPfyuh2lHM5ML8vpQUcPBEpskinUrmdDryPD+zFszei/
         degg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TztRgo8Xm1UKJI3iHqEuco042aluvy1BUSaXGcjURmU=;
        b=ZuAicuW5PoL5aU/vqpD1qtNdW8PYP+mzDicpnk0Ql9uG8dCkhQ65pVsdbzT3eW5WOi
         687wY9e+UimEcESFChi+GwmO0iVMb6yPSwEgegAU8j0R63PGj8wK1wm7Z1jDBxUV9J/X
         Uj95pP6X9i0r8JwBxxsDydL4o3j4dqsf2WHhW8ebmLKS7e5MRbZ2Yv8q9q6GFD92i2ZM
         yMMlfnff5UkhwFsdYQKIA6iKGH82i1WGV5/ymtOXIEDnbUzuI1buQI6kK69ZMpPhiOrN
         hk9KVqKYB4o6VHobq2GgOoFck+McPyBVvdET8IwawVbzU4pWkq2GalZcTZ61P/Qdh621
         j0CA==
X-Gm-Message-State: AOAM530XMN9vPF+VqPI4bRkXk1KwNOYaeLRDQr5KpghWiT7eQTP9K5pJ
        sFMzYYzWLZSiSlQVb07ySISuIurOfYbsxA==
X-Google-Smtp-Source: ABdhPJwPOg/y1xMwg2DQJKH+rF8RTz1aCd4bu8XCykXsbih6S1fLgkksPPVkIESz/k3mZ8ihOm/fTg==
X-Received: by 2002:a05:600c:4f10:: with SMTP id l16mr18191736wmq.47.1637156990144;
        Wed, 17 Nov 2021 05:49:50 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:49 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 00/12] Add #VC exception handling for AMD SEV-ES
Date:   Wed, 17 Nov 2021 14:47:40 +0100
Message-Id: <20211117134752.32662-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds #VC exception processing from Linux to kvm-unit-tests.
The rationale is to not rely on UEFI-provided #VC handler when running
the testcases as SEV-ES guests.

The series is based on the kvm-unit-tests uefi branch.

Tree: https://github.com/varadgautam/kvm-unit-tests/tree/vc-handler-rfc1

Varad Gautam (12):
  x86: AMD SEV-ES Setup #VC exception handler for AMD SEV-ES
  x86: Move svm.h to lib/x86/
  lib: x86: Import insn decoder from Linux
  x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
  x86: AMD SEV-ES: Prepare for #VC processing
  x86: AMD SEV-ES: Handle WBINVD #VC
  lib/x86: Move xsave helpers to lib/
  x86: AMD SEV-ES: Handle CPUID #VC
  x86: AMD SEV-ES: Handle RDTSC/RDTSCP #VC
  x86: AMD SEV-ES: Handle MSR #VC
  x86: AMD SEV-ES: Handle IOIO #VC
  x86: AMD SEV-ES: Handle string IO for IOIO #VC

 lib/x86/amd_sev.c          |    3 +-
 lib/x86/amd_sev.h          |  107 +++
 lib/x86/amd_sev_vc.c       |  504 ++++++++++++
 lib/x86/desc.c             |   17 +
 lib/x86/desc.h             |    1 +
 lib/x86/insn/inat-tables.c | 1566 ++++++++++++++++++++++++++++++++++++
 lib/x86/insn/inat.c        |   86 ++
 lib/x86/insn/inat.h        |  233 ++++++
 lib/x86/insn/inat_types.h  |   18 +
 lib/x86/insn/insn.c        |  778 ++++++++++++++++++
 lib/x86/insn/insn.h        |  280 +++++++
 lib/x86/setup.c            |    8 +
 {x86 => lib/x86}/svm.h     |   37 +
 lib/x86/xsave.c            |   37 +
 lib/x86/xsave.h            |   16 +
 x86/Makefile.common        |    4 +
 x86/Makefile.x86_64        |    1 +
 x86/svm.c                  |    2 +-
 x86/svm_tests.c            |    2 +-
 x86/xsave.c                |   43 +-
 20 files changed, 3698 insertions(+), 45 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c
 create mode 100644 lib/x86/insn/inat-tables.c
 create mode 100644 lib/x86/insn/inat.c
 create mode 100644 lib/x86/insn/inat.h
 create mode 100644 lib/x86/insn/inat_types.h
 create mode 100644 lib/x86/insn/insn.c
 create mode 100644 lib/x86/insn/insn.h
 rename {x86 => lib/x86}/svm.h (93%)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

-- 
2.32.0

