Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71AB4EE997
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 10:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344198AbiDAINR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 04:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344224AbiDAIMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 04:12:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA71200978;
        Fri,  1 Apr 2022 01:11:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id b130so1818246pga.13;
        Fri, 01 Apr 2022 01:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=dn5BxsTQLZIed/ZOGuC5oBdhwVSVIio+Ugi368MSy0E=;
        b=O7dNnxq30pOKB0zq0kMtF8VSatWA+5u6srCmeevs9a5cGy/kwKvFPJ/+gMUWb1cIx+
         qBmPAtNpPyn8pCGOOYQaHFn3Q+wiE0nlUAhg5CLBFvpZOFoShNXj7NziPTL4X7I9lDjP
         C0U6eXN13r1gyc4isoYVXwfKRJFiGYE6x+XQdKeWh9zyaztef/d6KkTootPqhFKYvVpe
         rAfp1yfniRUCHe99y4/Gksm8GW0PCGzxzcdquIj3zP+c0OMCWj/VmvCnivSsa4ZYVlCN
         mASy627diKvoIAn33QU5POn5c0v9TPBVd/K16YM6Q1PlFhYAzm3X7kIniAm/YpCYOLwo
         i9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dn5BxsTQLZIed/ZOGuC5oBdhwVSVIio+Ugi368MSy0E=;
        b=RRI5YVifRsTJwrpOpnt9ZjIG83rDCsczpbzkx9SrP5MbiWDdMqAtPMAumiK88qJMwA
         a9Hhaq7Jgovk+m5WgsF3cfsxyD98whdwQGsSRqaAnNd9kN/H/T7RRj6VLAql+rR35YfI
         scb4zviSkxFlXiKiUwIXM1xYqWcou0xtbqf2z+WaO0oEyGbIhvRZIDxcCBsl7oXTqgw4
         7nwNKQTRlt37tt9aE/sYAeL3CxPGUN3bO2Kzt5Vroqo82Fy0XxHRBKlTRJpCtXsNl9/y
         5Et89AtFbHAnwK7Kcrs05U6hTl4tNcgh+/aOP+8jmv1xhjN6+fXQqOgWLfNOPaqF1XJk
         Ic7Q==
X-Gm-Message-State: AOAM531Ls3W84jXpuL2hB1xOGbTdD97gIB0pGErnWYFx1dU/wFDu+P03
        ZEUHXlhPrhnnVqmAcUQ5O51V97/DL3o=
X-Google-Smtp-Source: ABdhPJyp3vYK6rehdobndZMj66sZcAXLGzFK/ZDO8HBW4Ptg4EZJciXiq1f37a72mot9Cjdkh/FMFw==
X-Received: by 2002:a63:5c5c:0:b0:382:2812:9d9d with SMTP id n28-20020a635c5c000000b0038228129d9dmr14037025pgm.227.1648800660134;
        Fri, 01 Apr 2022 01:11:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id hg5-20020a17090b300500b001c795eedcffsm11634790pjb.13.2022.04.01.01.10.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Apr 2022 01:10:59 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 0/5] KVM: X86: Scaling Guest OS Critical Sections with boosting
Date:   Fri,  1 Apr 2022 01:10:00 -0700
Message-Id: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
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

v1 -> v2:
 * add more comments to irq disable state 
 * renaming irq_disabled to last_guest_irq_disabled
 * renaming, inverting the return, and also return a bool for kvm_vcpu_non_preemptable

Wanpeng Li (5):
  KVM: X86: Add MSR_KVM_PREEMPT_COUNT support
  KVM: X86: Add last guest interrupt disable state support
  KVM: X86: Boost vCPU which is in critical section
  x86/kvm: Add MSR_KVM_PREEMPT_COUNT guest support
  KVM: X86: Expose PREEMT_COUNT CPUID feature bit to guest

 Documentation/virt/kvm/cpuid.rst     |  3 ++
 arch/x86/include/asm/kvm_host.h      |  8 ++++
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kernel/kvm.c                | 10 +++++
 arch/x86/kvm/cpuid.c                 |  3 +-
 arch/x86/kvm/x86.c                   | 60 ++++++++++++++++++++++++++++
 include/linux/kvm_host.h             |  1 +
 virt/kvm/kvm_main.c                  |  7 ++++
 8 files changed, 93 insertions(+), 1 deletion(-)

-- 
2.25.1

