Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496D95EAB7B
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 17:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbiIZPpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 11:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiIZPpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 11:45:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F21D58504;
        Mon, 26 Sep 2022 07:30:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c7so6688334pgt.11;
        Mon, 26 Sep 2022 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=0hQzcsiO48bIBR+p9nyTncuMHk4slH5QSBcLmzOjpKc=;
        b=A/ZLLxOLG0/471xMe1nqarmAmRCKf/0RKc33iPNNnyF6O9jEUGyRe72j4X/5U9Vbwn
         Amd78Jk4Ht7WpBmU0zFrBK0WBbsTjGhVUJKp8em0fFlQ8FRI8uK+LcWgrasKF9SovpFX
         b12fclk/8Xd+tSbNaA9Q8rimMk94R/Lr5akYSPgOOi1UN8HT1MsPMDv4Ur3CGiBHG8mI
         1B6kjF5wT27A5d92EgZvyQ1dS0Pdrv12nD2fTXlIRjlszMK9ifNwrT+DUPaZHmvLr+sM
         rDR6WoRMTEmnWKPjIvfIpSDq2CLMZe+pdOSj8lJ25t4aGv5UenOxi5idkTcsMRnfusol
         6v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=0hQzcsiO48bIBR+p9nyTncuMHk4slH5QSBcLmzOjpKc=;
        b=OUYKzDezypkrwB6EjpDtYAIgcg1J6fIorfanOTcTp3uaQ6xpqCmaPPfcEybOpT/h+B
         lbNeI/16zxw+wF4brNWUPuUouhIOJ6BJjh5RpgfvkcB65+EuEMbF6OrtB9MOPljpMIdU
         KZoQIWdfmUZyvNtnZHVZicjTqzOUY+/PrERm8HG3rAl/4yO8anmNiNM9+KYgxlsoXagH
         Ua5srvTSNf5IV5UFaX4L9U7ZF2nbMZU34hV/tkM4Kmoprn5zvLRDHZGJO/SRtmUunIBo
         R63wF6vTWKedzqBC1K8sUyHUrDlxxvX9puhzyQEWla2ZOIwqsHpZX6adZNY0nOZ5XFan
         F4fA==
X-Gm-Message-State: ACrzQf3UUwyQu4HmDez51hV8jRvCbCYcXhcuv4wUumvliDTsNQC9xzo/
        A2kk9fUFxLbuopiDu4kNo/k=
X-Google-Smtp-Source: AMsMyM7BL/goIYwvseK+M5hQWeJUVNlMl7GQeptVFW7b7shsVXxv1/tyrC6XHdaqg4IKphDZwgM+Ag==
X-Received: by 2002:a63:455e:0:b0:439:9496:ddd8 with SMTP id u30-20020a63455e000000b004399496ddd8mr20036548pgk.261.1664202600472;
        Mon, 26 Sep 2022 07:30:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00543a098a6ffsm12218733pfk.212.2022.09.26.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 07:30:00 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH RFC 0/3] KVM: x86/pmu: Add Intel Guest Branch Trace Store Support
Date:   Mon, 26 Sep 2022 22:29:35 +0800
Message-Id: <20220926142938.89608-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we have support for guest pebs, debug store support is implicitly
supported (if there are no hardware surprises). The debug store based
guest bts feature will also come sooner or later, in a very small effort.

One of reasons for adding the RFC tag is that there are currently two paths
for perf to inject interrupts into KVM, and if BTS is added, another one
will be added. This may not end if more perf/kvm interactions are added.

In this patch set I merged Intel BTS with Intel PT's interrupt callbacks as
a first step, but better code could perhaps be tried in the future in two ways:

- Merge KVM's intel_pt codebase into the vPMU framework,  as the previous
  merging effort of guest intel pt is not fully discussed. vPMU will support as
  much as possible the time-sharing multiplexing of host and guest for PMU
  resources (including intel_pt) instead of static partion;
- There is one more, PMI interrupts after forcing KVM to exit, re-traveled
  host idt and assigned to the host handler, then called back to kvm, then
  injected to guest, if there is hardware support and KVM clear judgment,
  interrupts from guest can be injected directly into guest without going
  through the perf subsystem, which will save a lot of overhead.

I'm willing to share more to attract more developers, but the opinions
of the key players are probably more important to the future codebase.

Back to this BTS feature, if there are no blocked comments on this patchset,
more document, selftest and kvm-unit-test will follow obviously.

Like Xu (3):
  KVM + perf: Rename *_intel_pt_intr() for generic usage
  KVM + perf: Passing vector into generic perf_handle_guest_intr()
  KVM: x86/pmu: Add Intel Guest Branch Trace Store Support

 arch/x86/events/intel/bts.c     |  3 +++
 arch/x86/events/intel/core.c    |  2 +-
 arch/x86/include/asm/kvm_host.h |  8 +++++-
 arch/x86/kvm/pmu.h              |  3 +++
 arch/x86/kvm/vmx/capabilities.h |  7 ++++++
 arch/x86/kvm/vmx/vmx.c          | 43 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              |  2 +-
 include/linux/kvm_host.h        |  2 +-
 include/linux/perf_event.h      | 12 +++++----
 kernel/events/core.c            |  9 +++----
 virt/kvm/kvm_main.c             |  6 ++---
 11 files changed, 72 insertions(+), 25 deletions(-)

-- 
2.37.3

