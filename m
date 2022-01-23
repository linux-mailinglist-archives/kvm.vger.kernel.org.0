Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B54974C9
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiAWSpu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 13:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAWSps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 13:45:48 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B780BC06173B
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:48 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id j9-20020a17090a7e8900b001b58e473d48so613312pjl.5
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P5Qm+G5FGiCdB4fLNFODyMa91rweiiWMeJsiF0yU5Mg=;
        b=K9otBkGqgRDqrO8zUcB0wDR/yt64jhyVjgkIFYEId8VsF4Z5j0iluLyfSBaqXeHBYz
         AJKzCI/hoSJOaJJS1X2ydCR52AiJyx+N4+0LQ3M31GL5xHpPUO/YC9jUqSVaQklaRftZ
         fPHmU7NMA66q3MPJ7FmDXQgvtK4OuiGnCWwEcfau06Ok0bryxaamWSiPr44dbGq6dBQX
         YWLYarAL7X4YiA/RTU14OBru/bY8ljNn+KMlqNgNm5F5w33y07DUfc5481MMuGjOccC2
         JLXo6qVSHGo8AYMT2TTUnR30uWy9SZaib6hnGARBJtyggbUtG/H/hP57GA4/JzlUkUjA
         M5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P5Qm+G5FGiCdB4fLNFODyMa91rweiiWMeJsiF0yU5Mg=;
        b=a7lcnVb7TxD9SNpszHp2e8m6PDxFe9AIUCZ+1FfAXYyEbgEuzaO8Ltz9KOatsGXwf6
         Vtd4nZ4c6sgDHBqxLvarf1WnlUbmZ8AWH4waQ0K+GLlUPqKezBa+SCWwZA2oF/KDHL1E
         FzykFZdBry3PWWT2wde7gleYOA+F+VK5CTK0DtpXhXbWLnVAD4vPquSYjwRKynCY2HDi
         g1EPkhC7NF5hdF/DoBUa469bCbHiEeVluslfg0Hk3xiJc1wLbrlk1Lq17kUcnwIegpwB
         NfzFpUXpcCbGc84fWQI5fwiipMbcT9DLU2lyGIAqk05epl6ZY/nGytOvntmGLCLRQhEW
         DhQA==
X-Gm-Message-State: AOAM532yztkxIizwNJPL5Bdht4TniuEscEWqQrMxlpwaouR0jCu4r+YS
        CSwQ02rzUAcj4wO3uV1QqmXy0RWDMPUnl1o7+Eoc1NZA9kLpRElhU7dQgSL3Gtl8ctFSrvw+g+J
        PIox8L0nLfawmGnMslkJpewaSnYYy/x4jCzP0QGAwnzfNBvlNX95Om/MSkTkBRX0M5A==
X-Google-Smtp-Source: ABdhPJzIejWg6+Jg3GOXFDY81mIbCq6AvOcTwv/VoV5OG3c6P8beQ9V07+E2ti1pBVlEmlwvtwNqn93vvBoRehE=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:90a:1919:: with SMTP id
 25mr9907531pjg.181.1642963548079; Sun, 23 Jan 2022 10:45:48 -0800 (PST)
Date:   Sun, 23 Jan 2022 18:45:38 +0000
Message-Id: <20220123184541.993212-1-daviddunn@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v5 0/3] KVM: x86: Provide per VM capability for disabling PMU virtualization
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v4:
- Remove automatic CPUID adjustment when PMU disabled [Like]
- Update documentation and changelog to reflect above.
- Update documentation to document arg[0] and return values.  [Like].

Original description:

This patch set allows usermode to disable PMU virtualization on
individual x86 VMs.  When disabled, the PMU is not advertised to
or accessible from the guest.

David Dunn (3):
  KVM: x86: Provide per VM capability for disabling PMU virtualization
  KVM: selftests: Allow creation of selftest VM without vcpus
  KVM: selftests: Verify disabling PMU virtualization via
    KVM_CAP_CONFIG_PMU

 Documentation/virt/kvm/api.rst                | 22 +++++++++
 arch/x86/include/asm/kvm_host.h               |  1 +
 arch/x86/kvm/svm/pmu.c                        |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  2 +-
 arch/x86/kvm/x86.c                            | 12 +++++
 include/uapi/linux/kvm.h                      |  4 ++
 tools/include/uapi/linux/kvm.h                |  4 ++
 .../selftests/kvm/include/kvm_util_base.h     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 48 ++++++++++++++-----
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 ++++++++++++++
 10 files changed, 118 insertions(+), 15 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

