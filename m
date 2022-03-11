Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2434D5D49
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiCKIaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCKIaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:30:05 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57EF1B0BE5;
        Fri, 11 Mar 2022 00:29:02 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id n2so7134051plf.4;
        Fri, 11 Mar 2022 00:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=yfQz7z8KZumc1Ycb9CqfcOoNgNnJJq7vzR6ooG1K2JQ=;
        b=pe5wuNZgg6d3LXKiCChXh5TnqXyI1eYgWqE9f2t/h7FMxufbl5ktYUr55uhaGedqA1
         nk/3fDSlLyAAS63VCnYojUXxvECFROYfjZnAdAWYoINV3kqi9Kou3fJNyNZsHen7coVD
         9kopPY3klo+ypfbwBmeKm+uku4nFUP76F/KYfcuIoyMCpy8TBoYhDFWA0myBtcDwFsqQ
         FlP4x0fvouo98vQO/PkSYOWWatishPoufkUvUyWotxKv2AG/Nt/dKyanST/iTrQW0JJo
         ckByBxJz+8QPKlxrsvTPaja4DTgmAVsg73iTYvTtXNgFxNTF447QjI5vxyGpFE4IWzkf
         x10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yfQz7z8KZumc1Ycb9CqfcOoNgNnJJq7vzR6ooG1K2JQ=;
        b=5/8VXtGcyLGvApFatrdCWh9tHqL/cPx64s9NUhp+gTv9E0YqLYcQ+FWxgetK0KdCdU
         wOjr62ISyC82ri6o/3uA4ZP7fNSQg5UjqJsspnxwhfBpu5OTFqxV0qoaDLEKqZRjzUgx
         IW7YEiYiKi41MlRk9gyxnKaQ0awPjewDbItIsjGIZ4bXJ7ix77eWNEB5OVqVb6eUrPNB
         e9B3QJ+qRrBeXFNBQtIOLCwfPMmYKaSe8MADpFpJlMtbzFkBWNuyh8Dvp0gEtPKa/nc+
         PSUNdE9d4XW3U25viCJdV8Sv3GyNcW0r/PGzcorCsc5EspYbGnm3bUaXpN6rdWdK8hCr
         vTwA==
X-Gm-Message-State: AOAM5302QeHMkznh0puQD9y5JM8ewGW5llDRsTIGT+yoOKyf/nccGrEy
        Ibbm/j4cr6Dr8LSyVF26CVn1KFoxioY=
X-Google-Smtp-Source: ABdhPJymbb8g9GfpxZY7Dyp91Z9WiGBqnyp0l7iDDQjn5ozr/TV16SmEk1jJLha+NULL5oSSrzxFKA==
X-Received: by 2002:a17:90a:10d6:b0:1bc:48ad:c8c8 with SMTP id b22-20020a17090a10d600b001bc48adc8c8mr9605292pje.149.1646987342111;
        Fri, 11 Mar 2022 00:29:02 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.115])
        by smtp.googlemail.com with ESMTPSA id y19-20020a056a00181300b004f7203ad991sm9630115pfa.210.2022.03.11.00.28.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:29:01 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/5] KVM: X86: Scaling Guest OS Critical Sections with boosting
Date:   Fri, 11 Mar 2022 00:28:11 -0800
Message-Id: <1646987291-28598-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The missing semantic gap that occurs when a guest OS is preempted 
when executing its own critical section, this leads to degradation 
of application scalability. We try to bridge this semantic gap in 
some ways, by passing guest preempt_count to the host and checking 
guest irq disable state, the hypervisor now knows whether guest 
OSes are running in the critical section, the hypervisor yield-on-spin 
heuristics can be more smart this time to boost the vCPU candidate 
who is in the critical section to mitigate this preemption problem, 
in addition, it is more likely to be a potential lock holder.

Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
one VM running benchmark, the other(none-2) VMs running cpu-bound 
workloads, There is no performance regression for other benchmarks 
like Unixbench etc.

1VM
            vanilla    optimized    improved

hackbench -l 50000
              28         21.45        30.5%
ebizzy -M
             12189       12354        1.4%
dbench
             712 MB/sec  722 MB/sec   1.4%

2VM:
            vanilla    optimized    improved

hackbench -l 10000
              29.4        26          13%
ebizzy -M
             3834        4033          5%
dbench
           42.3 MB/sec  44.1 MB/sec   4.3%

3VM:
            vanilla    optimized    improved

hackbench -l 10000
              47         35.46        33%
ebizzy -M
	     3828        4031         5%
dbench 
           30.5 MB/sec  31.16 MB/sec  2.3%

Wanpeng Li (5):
  KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
  KVM: X86: Add guest interrupt disable state support
  KVM: X86: Boost vCPU which is in the critical section
  x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
  KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest

 Documentation/virt/kvm/cpuid.rst     |  3 ++
 arch/x86/include/asm/kvm_host.h      |  7 ++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kernel/kvm.c                | 10 +++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   | 60 ++++++++++++++++++++++++++++
 include/linux/kvm_host.h             |  1 +
 virt/kvm/kvm_main.c                  |  7 ++++
 8 files changed, 92 insertions(+), 1 deletion(-)

-- 
2.25.1

