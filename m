Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2349F57C913
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiGUKgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiGUKf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:35:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EB723BD5;
        Thu, 21 Jul 2022 03:35:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ku18so1213284pjb.2;
        Thu, 21 Jul 2022 03:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlKSmqIiaep9xUE+mf7wOdafADvwgWNGf5OHGKH+YIY=;
        b=bqacb7y8dDA6y7o+7uYTEaqhxFF6srCvQYNxkK7wB+goHEurm56G/xpZpof9GMkoTk
         YAKEWC+uWHLnCB2kfOpDD/TGrv8ChZAiveM1grLixXjkFIShHcRXibt8dVeZXZa7z9u6
         JmMPSuGDDy+ofukXe4v2+Zzij4asbTptcAeY/A9fnBkiApbkJLjDAPXljCT3K0buwu7f
         PCIxlslXU1hHs1t03ixfc/8gnezsW2dleropzqoChInrtm93XY0W4I8WPk+QvHqY8t3Y
         kNSdS5ZuA6LRboDrVGCz9ISrd3CPGb8hcXPvIF0KR208GP+VUGKz9vVWFnEtDowD5Uco
         j5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlKSmqIiaep9xUE+mf7wOdafADvwgWNGf5OHGKH+YIY=;
        b=mhGQDEsN95p5OZbhbWewe/NWo74p9AqJvwW6ECTUh9l0YAwe5msFldmggbaTmwhyck
         2Z5Kzfbe6REX7WkJLbdfpwtGS0JjesHefIopV/uSCbPXGaNWcEQfAOSmgaUYYLdo3Aas
         evZLETw3AoxkhE+N7grRPRNWacn/vWKNXtk9Yjf3V+qoFF/5/CsvS6xzJN6w3LMrsGne
         6FL+SBsSfST8DSOyLbVlvdODx1dUwdLD9cl/pI5Hri4jO0QqMgwcL9+M9Gsq29ytncw/
         ZWxCcN9dhYXQK9pzWesJjs4oAEN5Hq+xjm32rUaKafoTVPvpIH6OEpAsYCN+JKExbz/W
         6Giw==
X-Gm-Message-State: AJIora9+SokdttwJidADK7lAe3ti2RxKFYxJjsgY+6CMDzBkqgRVAfD1
        83LI/ELVwtSK+CwMIUWOE3U=
X-Google-Smtp-Source: AGRyM1t5ki0T4OGJUamTPas/YgZFJjNLIDHsMyMf3zEWBafNwPdFpmxu/DJTBmWKnettRzryLxcQWA==
X-Received: by 2002:a17:90a:d195:b0:1ef:8eb2:4f4d with SMTP id fu21-20020a17090ad19500b001ef8eb24f4dmr10376445pjb.104.1658399758026;
        Thu, 21 Jul 2022 03:35:58 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:35:57 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 0/7] KVM: x86/pmu: Fix some corner cases including Intel PEBS
Date:   Thu, 21 Jul 2022 18:35:41 +0800
Message-Id: <20220721103549.49543-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
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

Good well-designed tests can help us find more bugs, especially when
the test steps differ from the Linux kernel behaviour in terms of the
timing of access to virtualized hw resources.

A new guest PEBS kvm-unit-test constructs a number of typical and
corner use cases to demonstrate how fragile the earlier PEBS
enabling patch set is. I prefer to reveal these flaws and fix them
myself before we receive complaints from projects that rely on it.

In this patch series, there is one small optimization (006), one hardware
surprise (002), and most of these fixes have stepped on my little toes.

Please feel free to run tests, add more or share comments.

Previous:
https://lore.kernel.org/kvm/20220713122507.29236-1-likexu@tencent.com/

V1 -> V2 Changelog:
- For 3/7, use "hw_idx > -1" and add comment; (Sean)
- For 4/7, refine commit message and add comment; (Sean)
- For 6/7, inline reprogram_counter() and restrict pmc->current_config;

Like Xu (7):
  perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
  perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
  KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
  KVM: x86/pmu: Don't generate PEBS records for emulated instructions
  KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
  KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
  KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter

 arch/x86/events/intel/core.c    |  4 ++-
 arch/x86/include/asm/kvm_host.h |  6 +++--
 arch/x86/kvm/pmu.c              | 47 +++++++++++++++++++++------------
 arch/x86/kvm/pmu.h              |  6 ++++-
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 30 ++++++++++-----------
 6 files changed, 58 insertions(+), 37 deletions(-)

-- 
2.37.1

