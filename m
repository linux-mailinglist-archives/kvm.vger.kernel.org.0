Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3494E7496
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358759AbiCYOA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 10:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352923AbiCYOA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 10:00:58 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1009E5BE6C;
        Fri, 25 Mar 2022 06:59:25 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i11so8121650plr.1;
        Fri, 25 Mar 2022 06:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jcQMlKlbZk0WeA4Y0nsLtLJDKhF/mpBenBl/6Lzr0hM=;
        b=LZQfLbvKrhKeptIUTvqf1+dItqPMKVBKTVxsIcvE7ny0z1T7nmKjgTbkJZwGIHA7x+
         4Loh/9/JPjbQuxKbcWwXFJuSzrkQErdOlXVXxFDxV0GJVGnKYjfimzeSRpSc15KIshZp
         0xyhsqZM4qSqLArH+rxuxqfOhSXAglwpLEB77xPGL/rdGpohq14FovWvfoV3ndzirKG3
         eBDtQ1beZRZdBKE/3NSv7Tus2S3ekh0BdL8w0I4WAFzhIRAjd+w6ZGkUnIx1N4An/kBJ
         V+nMUEqvfM2X5KfrSo8GDWPsrrAJzDAAPXgyDxuMGo7efK3Q7/tV+JHbcB2F8TIOnt1w
         89VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jcQMlKlbZk0WeA4Y0nsLtLJDKhF/mpBenBl/6Lzr0hM=;
        b=4wPk4Yh1/H/32qv2lyLuzXPiWHu1GylIPkM/14QpM0Mh8KDCmVmyXCM4Rpp16x2LEQ
         iteWL03Lpzt0+lfzDsx8ViTDigmyhVmecanRx9so+bIZmg8Ox2ZUCDH8qcHDdHFlxeDv
         +8xt+aj5rt1/shl7EPxIQl6lBX2rN9UCWzZgRt7183EL4/YVcTNiM4+UO+8pygkxcOEX
         El5NSd75yB6yRjkFOoUG/IZfPcVqjHFyeGMxJ8f2sfCQVRtxobKcX6qmXeSF9NqwUaGt
         DneMPUW/Q92/Uce4o4RAhkjjsy8pDPo7iWo1zFH3pD6GipDRwW7yw9qF+xyUSGx6vRL6
         TnCQ==
X-Gm-Message-State: AOAM533Eucbcg74WiUcLu5by4SwZPzI+fKrl39mzoRiI0X6rvRWvo+Aq
        w5gAp2SuV+LUdx7V4SB7t11jLQNjZow=
X-Google-Smtp-Source: ABdhPJyikOE9FrRXjsWYE9pN/MBTVrGtQVNJF+/R5WsuXeR+h3cXh7qvQbgAQid+9MHLNg+zyyxd+g==
X-Received: by 2002:a17:902:e750:b0:154:5672:b918 with SMTP id p16-20020a170902e75000b001545672b918mr11547735plf.43.1648216764393;
        Fri, 25 Mar 2022 06:59:24 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.googlemail.com with ESMTPSA id lw4-20020a17090b180400b001c7327d09c3sm14470875pjb.53.2022.03.25.06.59.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:59:24 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH RESEND 0/5] KVM: X86: Scaling Guest OS Critical Sections with boosting
Date:   Fri, 25 Mar 2022 06:58:24 -0700
Message-Id: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
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
  KVM: X86: Boost vCPU which is in critical section
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

