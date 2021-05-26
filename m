Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34D73918FC
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhEZNjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 09:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbhEZNjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 09:39:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A303AC061574;
        Wed, 26 May 2021 06:37:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mp9-20020a17090b1909b029015fd1e3ad5aso338177pjb.3;
        Wed, 26 May 2021 06:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XRw6evUMRkDPFtBLSDQYm1FhxVTA8kZErmdOWBIKxY=;
        b=Q8gE0Ob56chIydGjlMJg5ByE4pbgEtnd9VfgD8L5wbvJOQ+HhM679uwkOxIF9KZdO/
         3vAY+Bb/S0gJg1SwpFM5M7RFRpodr/9lZsMcb0kAm1iFZulCrTpXeF8EM5DdbAaaKhVJ
         st+KOlcsS6UapoaffBtoWtiiqoAuRM6FJ9bSOf/i4G+JLYCZmgSKeZnLDeoERZxCYjxy
         Fq9EgmJwZEJEqm9Qq3c02HqU/2UaWfzjRrypBG8HzKgP47t4iEk3qCOgqxqXEEvE0PhK
         +QxZZvVXuIBzOaidbjxm/xMIiA/Uia+etIRGoIDg43IIQXPhMejfByWwvbZNZnzPHatY
         lS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XRw6evUMRkDPFtBLSDQYm1FhxVTA8kZErmdOWBIKxY=;
        b=XAIuhE6F0k6KWfI4MqZFliaOqVORAXEVdtjO8bQIBZdZnhpZDu5it011+PRqpinOtX
         isAgr4OZSSq6hFKNx7yEizeFzmhl86LKFxm8MPDQn0mK3wZd3O/NYpAQQGoBiq1O0Ic1
         q9t93QkrWGUYIBqA72KnO0dfbz2ZjmYMvKq4ru+tjdGtCQgZ1TWlOZnv2XnVfO+m3FRS
         Ky/7u3nppK94ty1b9si8xkBymXDyoB/HMeDGpwkq0pVUeXPkQfRwM3VNmjJdId1Og/gN
         VYeKRxdl/d1BYQ9AIk7+G+aDkUCWuPz8SRJMzKtucu77IIZdmuhD40PXdDxk+r1BNCFb
         JFZg==
X-Gm-Message-State: AOAM532FLMxSYljSHREBZzBEoXqNWZk9zIx7WIjFs+3X+f1L/LCAYHqe
        n2Cu/UVAxEK2BwaNB/Fh2vQ=
X-Google-Smtp-Source: ABdhPJyS0/iAkGPj/yjO8tNvnYufGoHBuzrqFXWfH3uP4wri+VT5zMRSEJPXKGuIFJewPIzNe7vrOA==
X-Received: by 2002:a17:90a:542:: with SMTP id h2mr3909367pjf.82.1622036254083;
        Wed, 26 May 2021 06:37:34 -0700 (PDT)
Received: from localhost ([133.11.45.40])
        by smtp.gmail.com with ESMTPSA id q196sm16428336pfc.208.2021.05.26.06.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 06:37:33 -0700 (PDT)
From:   Masanori Misono <m.misono760@gmail.com>
To:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rohit Jain <rohit.k.jain@oracle.com>
Cc:     Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Masanori Misono <m.misono760@gmail.com>
Subject: [PATCH RFC 0/1] Make vCPUs that are HLT state candidates for load balancing
Date:   Wed, 26 May 2021 22:37:26 +0900
Message-Id: <20210526133727.42339-1-m.misono760@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I observed performance degradation when running some parallel programs on a
VM that has (1) KVM_FEATURE_PV_UNHALT, (2) KVM_FEATURE_STEAL_TIME, and (3)
multi-core architecture. The benchmark results are shown at the bottom. An
example of libvirt XML for creating such VM is

```
[...]
  <vcpu placement='static'>8</vcpu>
  <cpu mode='host-model'>
    <topology sockets='1' cores='8' threads='1'/>
  </cpu>
  <qemu:commandline>
    <qemu:arg value='-cpu'/>
    <qemu:arg value='host,l3-cache=on,+kvm-pv-unhalt,+kvm-steal-time'/>
  </qemu:commandline>
[...]
```

I investigate the cause and found that the problem occurs in the following
ways:

- vCPU1 schedules thread A, and vCPU2 schedules thread B. vCPU1 and vCPU2
  share LLC.
- Thread A tries to acquire a lock but fails, resulting in a sleep state
  (via futex.)
- vCPU1 becomes idle because there are no runnable threads and does HLT,
  which leads to HLT VMEXIT (if idle=halt, and KVM doesn't disable HLT
  VMEXIT using KVM_CAP_X86_DISABLE_EXITS).
- KVM sets vCPU1's st->preempted as 1 in kvm_steal_time_set_preempted().
- Thread C wakes on vCPU2. vCPU2 tries to do load balancing in
  select_idle_core(). Although vCPU1 is idle, vCPU1 is not a candidate for
  load balancing because is_vcpu_preempted(vCPU1) is true, hence
  available_idle_cpu(vPCU1) is false.
- As a result, both thread B and thread C stay in the vCPU2's runqueue, and
  vCPU1 is not utilized.

The patch changes kvm_arch_cpu_put() so that it does not set st->preempted
as 1 when a vCPU does HLT VMEXIT. As a result, is_vcpu_preempted(vCPU)
becomes 0, and the vCPU becomes a candidate for CFS load balancing.

The followings are parts of benchmark results of NPB-OMP
(https://www.nas.nasa.gov/publications/npb.html), which contains several
parallel computing programs. My machine has two nodes, and each CPU has 24
cores (Intel Xeon Platinum 8160, hyper-threading disabled.) I created a VM
with 48 vCPU, and each vCPU is pinned to the corresponding pCPU. I also
created virtual NUMA so that the guest environment became as close as the
host. Values in the tables are execution time (seconds; lower is better).

| environmnent \ benchmark name | lu.C   | mg.C  | bt.C  | cg.C  |
|-------------------------------+--------+-------+-------+-------|
| host (Linux v5.13-rc3)        | 50.67  | 14.67 | 54.77 | 20.08 |
| VM (sockets=48, cores=1)      | 51.37  | 14.88 | 55.99 | 20.05 |
| VM (sockets=2, cores=24)      | 170.12 | 23.86 | 75.95 | 40.15 |
|   w/ this patch               | 48.92  | 14.95 | 55.23 | 20.09 |


is_vcpu_preempted() is also used in PV spinlock implementations to mitigate
lock holder preemption problems, etc. A vCPU holding a lock does not do
HLT, so I think this patch doesn't affect them. However, pCPU may be
running the host's thread that has higher priority than a vCPU thread, and
in that case, is_vcpu_preempted() should return 0 ideally. I guess
its implementation would be a bit complicated, so I wonder if this patch
approach is acceptable.

Thanks,

Masanori Misono (1):
  KVM: x86: Don't set preempted when vCPU does HLT VMEXIT

 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)


base-commit: c4681547bcce777daf576925a966ffa824edd09d
-- 
2.31.1

