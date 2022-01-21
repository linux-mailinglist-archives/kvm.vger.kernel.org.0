Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE227496716
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiAUVHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 16:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiAUVHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 16:07:20 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C86C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:20 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id a14-20020a170902710e00b0014ad8395c0dso2107218pll.21
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 13:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Wlx7t0bhB5h3Smpslggps27Oc56VnWH6Y0AnqqHthBw=;
        b=e5+4L7ajiDIfj5p2xWddFrtT/UlT1v3d/fSFSfB54xMeCggu9IIT2lIOdofJEkuRVF
         E9ueM/H47Lpfsc2f6W4ZvkzHX8hpsokdrVur1+QYdXi953CxoabmOfaohd7pYTWAn5Uz
         zJ2EPuRPxu84msdP5lW5foB4lHNKzcA6c21hJuQGG8BJPxxupCDdWUOjZ7/AEpfuSrpf
         g1auzxeisf7AhlCA6A6yHLS36r0MaYv2wkZA2OP6XAJh+TDXuC3m/d7iCc6tCYhWg3Fu
         JVanpLKyjYLs3s0Fo+CeeohxdO9SXm4e2r0vYTIZ+LpWr++c7iImLKfC8lbtO1xAuxrG
         dsYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Wlx7t0bhB5h3Smpslggps27Oc56VnWH6Y0AnqqHthBw=;
        b=mVRhCeiLWk4XU2dNR0yIX6uUTeNJ0C/aLV52Kc85Cymc0S4lqkBozsJOkJXKikv/x5
         cjDfvuQiDKFHjF2LMh1FJZuvOgOfxmW7MpXJl2pR0PH8h9loNcq6G+eD6rbzyeSNVWG7
         L/SUaUcTNH1nkHcbslzxoItrb8gl4Ptm+pZ0a1uAp1Tdht6M8Aq0Pk+4ZZwQNsuV2n4W
         jo4Riy+OxDZOkc78kofrBMGvGzbsAos6Onb1T1rXvTcZ/KOZZKltyK+OBIAV3aXoL3xy
         lLAj35zM7nFKn6jW1/WjCWht7tIfvoMNAmyF2H5603PQyibRYZCzKVILpG9NccLoLua3
         FYMg==
X-Gm-Message-State: AOAM5335+lSUN198RjlwRt/qpXRNlb3+tDrRpRXphouoNLMrmbq5wbhU
        4y66nftOaFNeXuYDouEIF+M3avVAB6m0ldXnVTMNkfY3V0mO9UlpzpHT5lmEnI67rDl03MZxUn6
        Fn9sbrnKiaXotmwkqXc+xxLqSBNu5rOAJg5z7NL4pzEHk2HPzkrfaVEQIJEHNSbjg2w==
X-Google-Smtp-Source: ABdhPJx7hMA3izuaRKiJCGGu/hKYY4fswHSxFLs1iESbEOQ8vB8OrTm49HlvqcXv7ssvHsY/+BuXorM5EZFHv1s=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:d2c8:b0:14a:55fb:cfe5 with SMTP
 id n8-20020a170902d2c800b0014a55fbcfe5mr5573323plc.51.1642799240018; Fri, 21
 Jan 2022 13:07:20 -0800 (PST)
Date:   Fri, 21 Jan 2022 21:06:59 +0000
Message-Id: <20220121210702.635477-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v3 0/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set allows usermode to disable PMU virtualization on
individual x86 VMs.  When disabled, the PMU is not advertised to
or accessible from the guest.

Thanks again to Like and Sean for great feedback.  I have incorporated
Like's v2 suggestions in this version.

David Dunn (3):
  KVM: x86: Provide per VM capability for disabling PMU virtualization
  KVM: selftests: Allow creation of selftest VM without vcpus
  KVM: selftests: Verify disabling PMU virtualization via
    KVM_CAP_CONFIG_PMU

 Documentation/virt/kvm/api.rst                | 21 ++++++++
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/cpuid.c                          |  8 ++++
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 12 +++++
 include/uapi/linux/kvm.h                      |  4 ++
 tools/include/uapi/linux/kvm.h                |  4 ++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 48 ++++++++++++++-----
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 ++++++++++++++
 11 files changed, 125 insertions(+), 15 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

