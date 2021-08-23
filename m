Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090173F5154
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 21:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhHWTiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 15:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhHWTiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 15:38:06 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF50C061575
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:23 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q13-20020a0ce9cd000000b003608f06491fso13158860qvo.18
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 12:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=A9qASCHnE3CoN+lt64vMYGtlubN7uOyns9qDV0YSdyw=;
        b=OCM/cYL9yWCgeUA4usPKXZ3QyCU0qetwqgQCcnn9eeKQyWyTvHbBKdRV7wroQyth4d
         i25U6rwEpbVIUw99sh1XLUFgd3UzP9KIJ6ingfqQrHCcCRHdzgHBeKiov84D3sVh3iBH
         OvufjGnaT/56jpgALQVEEDkOHjXtALakBzJpHTCMmEWgRnCfV5FkegsPGofJnt6l4O9x
         6i+NzT2X2Y0ASjWcNUQoSyAjJ2phHeefnmJOs1SjMzKXN+ZoI5EAKIcmWl13xu08ontP
         W4ZisBwStkYAbOHNfLkPAaeqay+yPHKcHc/e1i69Ez7bc9ilG6gBQ0Md8e37UmFbiaTX
         n+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=A9qASCHnE3CoN+lt64vMYGtlubN7uOyns9qDV0YSdyw=;
        b=bGvg99MusvWPFdBZEIV8pSPgi5lHQSRBfE6niA1Me2lsKN3wUnexEjqniOlsXYXoC9
         CXwrsXX0HJDzNyfE5Z1QpcfcjI5hB8SzDaXP1EVpmJzcqq8OhPwNDDZHVnewnMTriDIU
         67XGjcImd0mDuECarSwxfh+koR6nCwpxziXBqZqQ5P79uRqf6hsXpgiOL9XEzQEO7lHu
         pJb1LGTygmeEuK1XAzU+dwgSC2QktH3qbgoYWQi0YOY78v01gmpyOJ4fh4IFxGKnaQMS
         8YkWsB2fbaxF6Ox3titmtbHiQjBdN44XImZQnWY0rkP9vR7u51+N4ze+yuoKSg0yPChB
         RM2A==
X-Gm-Message-State: AOAM531xfZ7FuP1yjUxJY2qfo4gCZGnt3aLMRSyGGg1WRJ5L4XfHqWrS
        MsAnH5oSknVIo44mf+6RFbYjYMH5LYY=
X-Google-Smtp-Source: ABdhPJza03bRfv3yplWeM4c1rPxZUsU0bC0mYykhv3ilOJ+8ED1Zt/Prcr/1eTVd3dng7bdlZCT3yGXVTk0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:109c:7eb8:d5ed:2e59])
 (user=seanjc job=sendgmr) by 2002:a05:6214:9d1:: with SMTP id
 dp17mr22187604qvb.44.1629747442951; Mon, 23 Aug 2021 12:37:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Aug 2021 12:37:06 -0700
Message-Id: <20210823193709.55886-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 0/3] perf/x86/intel: KVM: PT intr handler fix and cleanup
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patches 1 and 2 fix a bug where PT PMIs in guest are forwarded to KVM's PT
intr handler even if PT is configured for system mode, i.e. when the host
is the sole owner of PT.

Patch 3 is a related cleanup/optimization.

The PT specific stuff is effectively compile-tested only.

Sean Christopherson (3):
  KVM: x86: Register perf callbacks after calling vendor's
    hardware_setup()
  KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
    guest
  perf/x86/intel: Fold current_vcpu check into KVM's PT intr handler

 arch/x86/events/intel/core.c    |  7 +++----
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.h              |  1 +
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 17 ++++++++++++-----
 include/linux/perf_event.h      |  2 +-
 6 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

