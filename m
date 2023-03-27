Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C986CB0A3
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 23:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjC0V0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 17:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC0V0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 17:26:46 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2538173E
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:44 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id c6-20020a056e020bc600b00325da077351so6651077ilu.11
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 14:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679952404;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xIkkz8MTooGArZoygNuGyO0gX2vy3zBzvZkyddWA8m4=;
        b=AaF8uNw+daee3MxiBDwd0MrEfmAJQwtFHlqwHxOJ7nRSgVAa0JpdT+lvLuaq2/dUte
         KrPveyrw4/3omgAJ6M5Fld+hTLlD9Wi/N3teByTVyk59x8JsG9KKsENlD/5+QbIIl2Ga
         pOhUhRkU7kNseCSkDFWvTUrCiARvL4Tzh9prdeuyK5XnKSK49Lhp2gzAlUV/EW/OU5u5
         tqJws7JbgwGmjerSGnee6Ye8agQ4P2hOKVaTcFrmVi4ew0Xb6cRwSSyWtxjIYPNGR8RF
         hIzQKE86evylKzONZrmRZwtkJuFbnh5qTw17bjdvzT6/Fbce3YJwha2WWAdiDU+R+G/9
         jC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679952404;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xIkkz8MTooGArZoygNuGyO0gX2vy3zBzvZkyddWA8m4=;
        b=6df/S81iLTRyuEIiU8k6uX5eN4XhOwCM5vP2l5yDrdIkkni+P2rGamZ4eNkasZkb5E
         4OmEYsW6NsCnLzK+rNcxfkWHr3oBaCIr5HbZmDewcRc1bf80+lQDhlnqJkifKobQVz2U
         TAimGfVjsGsPl+uaa5PAdCA/oeIF4IcwkkW9axOEAWsu6hC8xswKRF01+lQl1zX5Ubmy
         73/5rJWs5n1+eIpQss+f9yE3tQ3yLpLOW97fXvL79a+J+X9i8PK5x/SCZHIv0BfypEMZ
         Sn68BlC8AERv2S00QWBy/vZCMLkL3XTHztTjYWykXh/zI8YSzuh4sjzPbwNRoutXCUMh
         M/BQ==
X-Gm-Message-State: AO0yUKVPEqfufbm5OGpVM2BhZT+gW8JDA6zCMLGRwdA2RPi0Wx4gfZgr
        wdDngY2jFhlqHNOxlIhD0aJwYtDltDqrdRVHvg==
X-Google-Smtp-Source: AK7set9APm4xdscZUsRBuxy3KiO5AukgunEjZ7Bzefaq7CMNym+TyxVjyUMa4PGLMIfBPqQpfRPFrwqnnZgz6e2p6Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:1603:b0:3ec:46d4:e15 with
 SMTP id x3-20020a056638160300b003ec46d40e15mr12032278jas.3.1679952404249;
 Mon, 27 Mar 2023 14:26:44 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:26:33 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230327212635.1684716-1-coltonlewis@google.com>
Subject: [PATCH v3 0/2] KVM: selftests: Calculate memory latency stats
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sample the latency of memory accesses in dirty_log_perf_test and
report summary stats to give a picture of the latency
distribution. Specifically, focus on the right tail with the 50th,
90th, and 99th percentile reported in ns.

v3:
* Move timing functions to lib/$ARCH/processor.c
* Add memory barriers to prevent reordering measured memory accesses
* Remove floating point from conversion functions
* Change command line flag to -l for latency and provide help summary
* Do not show latency measurements unless -l is given with argument
* Change output formatting to seconds for consistency with other output

v2: https://lore.kernel.org/kvm/20230316222752.1911001-1-coltonlewis@google.com/

v1: https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Provide generic way to read system counter
  KVM: selftests: Print summary stats of memory latency distribution

 .../selftests/kvm/access_tracking_perf_test.c |  3 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 21 +++++-
 .../selftests/kvm/include/aarch64/processor.h | 13 ++++
 .../testing/selftests/kvm/include/memstress.h | 10 ++-
 .../selftests/kvm/include/x86_64/processor.h  | 13 ++++
 .../selftests/kvm/lib/aarch64/processor.c     | 12 ++++
 tools/testing/selftests/kvm/lib/memstress.c   | 68 ++++++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      | 13 ++++
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 .../kvm/system_counter_offset_test.c          | 10 +--
 11 files changed, 143 insertions(+), 24 deletions(-)

--
2.40.0.348.gf938b09366-goog
