Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8867A727
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbjAXXtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAXXtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:49:15 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3812C271E
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:14 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p19-20020a25d813000000b0080b78270db5so925246ybg.15
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d6FbEmiz72YXUF5K5FVTrlen52BVkfJLOr5PvlROo8A=;
        b=K9XMKyWbz63tF2PqKNK+SOWcmnOAY2M73kFwBL17z7cU+H8wzfp2g/Q23QhwV+oIo3
         3cjND5YSIhGMeSQCr7QNyUOmlaLgfLtBCIVzz9iVC4xT8vQZavyJzu7Ee6ze6mskN+i+
         fBcXBbo5L4hkRUQWRR2rhBWyUWfzHGWfrKzwrqcbsfXZSjnkgEjwstjxxmXaT3B5hFOH
         oQq4/MlnjN79Tb1qvn48D9vK4MBFQx8J1SPqJwhHcAMKEmbFWjUQZHWOj15X5AlLbeHT
         1LCUuixjbarbmjHY+VYRZBah+TGeil+eGE67aY7WE7HZSUhkINVL2FTvpPcja4RXBNXM
         o1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d6FbEmiz72YXUF5K5FVTrlen52BVkfJLOr5PvlROo8A=;
        b=IS48t5QJaLXfW6HFVU+Fxok+5qSEJuYwz0h+7J9JEcu3CInlvbWKEQIKYIGP0G5JeL
         D15zVePsw0x5QAEzAHMNVpzkYm363YT5DWJQALHl40QE8kTLoHkQ5DM3S7P6HW4gyr4G
         0IcE1+BgucDRUtqQShks9IKYD8ZdLGU01aXiYNPluhu2xGU8WQJ30Fu/6wiFTKHosA1i
         NAUI7UpGkceYuep82r9v3OZm17KaDhHELWFeYrmiwntxx09xyNskrzu2q4olya0QnD06
         /ny+wvSDXY/HgVgRcafYZb/LU8wAQ64dAbC+NAVeLhREBlWHl+Kgfk4mV3OQVAx/1R3Y
         WKLA==
X-Gm-Message-State: AFqh2krxw7FyaoK9BZxGQ1GUA15CaHgnocGuwHuxYC8uH43jP/dyuewG
        hjoRnIpICiEa07qH+MAMU/X3SpgJYiE=
X-Google-Smtp-Source: AMrXdXtrW7ji2yKbWWXHqWTemwfV7wE3K02QSQpV0x0k28qvC31WvYN69QLfjHoBnAXGEKcNNIgocaHshTw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4ac1:0:b0:4ec:933c:6c99 with SMTP id
 x184-20020a814ac1000000b004ec933c6c99mr3437689ywa.61.1674604153483; Tue, 24
 Jan 2023 15:49:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Jan 2023 23:48:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230124234905.3774678-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: x86/pmu: Misc PMU MSR fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a handful of minor PMU MSR issues, mostly related to KVM's reporting
and handling of MSRs when the PMU is disabled.  E.g. running the
state_test selftest with enable_pmu=0 fails because KVM tells userspace
to save/restore the fixed counter MSRs, but then rejects attempts to
access said MSRs from userspace.


Aaron and Like,

My plan is to apply this rather quickly, e.g. later this week, as the AMD
PMU v2 series can be simplified by taking a dependency on the
kvm_pmu_cap.num_counters_gp fix (patch 1).  But I'll make sure to place
the patches at the end of the pmu queue so that it'll be easy to unwind
if there's a fatal bug without affecting the hashes of other PMU stuff
destined for 6.3.

In other words, please review/test sometime in the next few weeks, even
if I queue it.

Thanks!

Based on:

  git@github.com:kvm-x86/linux.git pmu

Like Xu (1):
  KVM: x86/pmu: Don't tell userspace to save MSRs for non-existent fixed
    PMCs

Sean Christopherson (5):
  KVM: x86/pmu: Cap kvm_pmu_cap.num_counters_gp at KVM's internal max
  KVM: x86/pmu: Gate all "unimplemented MSR" prints on
    report_ignored_msrs
  KVM: x86/pmu: Use separate array for defining "PMU MSRs to save"
  KVM: x86/pmu: Don't tell userspace to save PMU MSRs if PMU is disabled
  KVM: x86/pmu: Provide "error" semantics for unsupported-but-known PMU
    MSRs

 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/hyperv.c           |  10 +-
 arch/x86/kvm/pmu.h              |   5 +-
 arch/x86/kvm/svm/pmu.c          |   1 +
 arch/x86/kvm/svm/svm.c          |   5 +-
 arch/x86/kvm/vmx/pmu_intel.c    |   1 +
 arch/x86/kvm/vmx/vmx.c          |   4 +-
 arch/x86/kvm/x86.c              | 229 +++++++++++++++++---------------
 arch/x86/kvm/x86.h              |  12 ++
 9 files changed, 149 insertions(+), 119 deletions(-)


base-commit: 647ffac11ebbbd21e04dd11a7125decb99eeee65
-- 
2.39.1.456.gfc5497dd1b-goog

