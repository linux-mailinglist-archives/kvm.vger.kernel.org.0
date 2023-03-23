Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C097D6C60AC
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjCWH1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjCWH1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F12A175;
        Thu, 23 Mar 2023 00:27:35 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so1095492pjb.4;
        Thu, 23 Mar 2023 00:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JeEaKj3RnlCsOSDCKAm5SvUFqtjjJOWX+vjkiEHpKPU=;
        b=cTuemhkuASkwQu7n122Mzhdxg9NLJUQs5ovPlC/wwoeiNvdgOGLKqJe/LrOS6oFZd+
         wELzuhQEDg0jSm6OONhWE8Sl4D5zpOMONdeq/w3bKUWzIR67akAVpL0x7C8er+J/qkYa
         Hw4s8EPClW8MzsWcTNkx7AbBa5TmA3lfnWv27Hg8qztgfc+xVMIv0YJOy4qX5Vxd9sh/
         OVQ5r8Xf7SrOaMoAOB7z5xrn7X7lTxTREGGgOPNuZ6WrTzQGSyDvgTSzcEjsts7t9yxN
         OkU4BI+hRqpOLZrR3FnK4wKsOUs+ZlFnHvv9dlEbmY0s2OI8ebi5SVOBwR8J7cyCv0FS
         zLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JeEaKj3RnlCsOSDCKAm5SvUFqtjjJOWX+vjkiEHpKPU=;
        b=SCG7PZZxYjfDjgw4EDWHeATx4ySU60DTZgx2G928l9szCRdiYW4H8FwIW61FU/jKVM
         nHUkXqwjW8mxQhyThz3TkLJXEGphjh9KBBA3tBZoEZeq2X0xpFOAl1XTK4pA6WhRFrj8
         wk8hYdlLFV1EmjCHZfEfn3UhWftP6W369JqEemXXYOvTf5Tg0BEp/JwhU+0YPifk5Ff2
         W5Uok2rT9Og/yDSfFM9JRdgonoqn/02CfLgUoWkBA+AVFpnfzElSBikR9t6+MqbKDEXd
         0hadIc2MvK0lFhfDalEzOx8IOyeVgaTpjRDwR2uZHKaw1cvxR4DwnW6Nf5AtPZKgAmQ+
         7UmA==
X-Gm-Message-State: AO0yUKXW+IKMM6uLe4tuuyALpafnR3TWctk9w3xZsZdpUYrR9sq4St99
        cM6KRqJDTbjoOH1J463VbIi1XnOsYrXraSab
X-Google-Smtp-Source: AK7set/B0dfZu3JgvKhkxVT5+d/Mv2QL4dByTgcfGSDQ+OLrMLaAvePjm2L5uyB8ejLJWP1dkRPxWQ==
X-Received: by 2002:a17:902:e80c:b0:1a1:a531:460e with SMTP id u12-20020a170902e80c00b001a1a531460emr6582099plg.63.1679556454590;
        Thu, 23 Mar 2023 00:27:34 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:34 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/7] KVM: selftests: Test the consistency of the PMU's CPUID and its features
Date:   Thu, 23 Mar 2023 15:27:07 +0800
Message-Id: <20230323072714.82289-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The KVM selfstests shows advantages over the KUT in terms of finding
defects through flexible and varied guest settings form KVM user space.

This patch set tests whether Intel vPMU works properly with different
Intel CPUID.0xA configurations, in which three issues were identified.
It also provides test scaffolding and a sufficient number of pmu test cases
to subsequently provide adequate code coverage of AMD vPMU or Intel
complex features such as LBR or PEBS in selftests.

Please feel free to add more tests or share valuable comments.

Related bugs:
KVM: x86/pmu: Fix emulation on Intel counters' bit width
(https://lore.kernel.org/kvm/20230322093117.48335-1-likexu@tencent.com/)
KVM: x86/pmu: Add Intel PMU supported fixed counters bit mask
(https://lore.kernel.org/kvm/20230321112742.25255-1-likexu@tencent.com/)
KVM: x86/pmu: Prevent the PMU from counting disallowed events
(https://lore.kernel.org/kvm/20230307141400.1486314-2-aaronlewis@google.com/)

Prerequisite:
KVM: selftests: Report enable_pmu module value when test is skipped
KVM: selftests: Add a helper to read kvm boolean module parameters
(https://lore.kernel.org/kvm/20230313085311.25327-1-likexu@tencent.com/)

Jinrong Liang (3):
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of Fixed counters
  KVM: selftests: Test consistency of PMU MSRs with Intel PMU version

Like Xu (4):
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test consistency of CPUID with num of GP counters
  KVM: selftests: Test Intel supported fixed counters bit mask
  KVM: selftests: Test Intel counters' bit width emulation

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 626 ++++++++++++++++++
 2 files changed, 627 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c

base-commit: 94db7c022e10c76ac8ac27878822c3deed80aae1
-- 
2.40.0

