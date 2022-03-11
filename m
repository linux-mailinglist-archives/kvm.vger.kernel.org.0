Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976FE4D5D4C
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiCKIbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiCKIbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:08 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21811B8FF7;
        Fri, 11 Mar 2022 00:30:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w4so7090313ply.13;
        Fri, 11 Mar 2022 00:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=yfQz7z8KZumc1Ycb9CqfcOoNgNnJJq7vzR6ooG1K2JQ=;
        b=ldHCrnrXhaXX+MtCrr3gxbmnYzrzEHkplill0d51oZPsPlVFXHnK+hSJ0xKnvKt8h8
         Pc2vgW2ziEhFq3epmeXGRsHo/uR44xNeqrNWWq7YSQ+VIGuS4TAG7KSzk8w/u4Tb1OI8
         2bQkwDj+oCqRIIklg8L+d7bLXrnXGUJ9aKVK3bxR6ofBNZpwuPVO6hyofAjI6nPfLXI2
         H8zZE0QxZXKn6mZ/Smgfbql2LwnrI7Sn2ytlqO6+Yr4QL0x6NH7GDBBp4PfWI/28uEJV
         0VK11mOJU9sZWd8f1w7uvDY1wafz7ahyl5F13iFo2IuMN6hTfKYCZr8SxiwT7MvTQ04s
         3Wuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yfQz7z8KZumc1Ycb9CqfcOoNgNnJJq7vzR6ooG1K2JQ=;
        b=xsRvVhfgep7CKHjwcuSQAPdSgjyF2iDDpu1tnv4cPxE5ynvKuEGpvkgm+YKi5aSmS6
         e9Qm1a3qf1shaAI4HpIrtCpyU5E9fl+ESyfweBNdlHTYiVZSisRDy8pLoMAjls3B0o+S
         uPquZm8swOUTms8N3UVGIPdHbms+LRmnu25LyoEkTbkkyM+Hgb5t7WFQa+ZF59BYwj/n
         5sL68sizJJw9syi08wrQacB15sSZxAtk55F93B/YhOcctVfzIu9sCQE6TmJ3fBtawK4v
         ZgCLb0jz00Q4w1uCOWQov0AWYzsVlVk1LHwfgPVcjnGiOfC5m4/5bOJFz4eEl+LfHq9a
         EfSw==
X-Gm-Message-State: AOAM5311/2etF4srf3N47uBylj3TxusKARWCitzyyobCfPncgQc7GnU0
        7aMUciQAZPbzGvIEcecXCKsBOzUM/RI=
X-Google-Smtp-Source: ABdhPJzTWsHNgzXdxR3tzyhqTHcZKFOA6DUO/KiJKNpRHP47QPNgD1czpsq9x9BDPdAUcAyiLySpUQ==
X-Received: by 2002:a17:902:eb85:b0:153:1405:9c85 with SMTP id q5-20020a170902eb8500b0015314059c85mr9175604plg.118.1646987404411;
        Fri, 11 Mar 2022 00:30:04 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:04 -0800 (PST)
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
Date:   Fri, 11 Mar 2022 00:29:09 -0800
Message-Id: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
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

