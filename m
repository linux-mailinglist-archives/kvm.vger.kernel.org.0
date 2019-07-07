Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D99A60E6A
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 03:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfGFB04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 21:26:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42154 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGFB04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 21:26:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so4952177pgb.9;
        Fri, 05 Jul 2019 18:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVB/qxc195E6rDp2lOgsfW+eYTkI+LAWzMzryJMzQSk=;
        b=KXZCa+EzNBZp5Yw+K4V0TF/G0VGUntbrmM8kAUtUebgKWQXBQr8tWPm41bMJY6aJAI
         U8CazoMogtMjlTqIULdBkeNx6P5I6sxDuDkeogav9g4N0CHOppud2BHSfwZMPDXRd9aq
         9Ucnb5OSDu6yw1WmVNhtJQTzE3Mgdcpkiqo7bCWD+jK2CNNeNa6Dg1MVzn5DdQzDZLnN
         tyQ6U3kTWj3hrwAqlAyH8kVrMXzjitBR1Vo5IintqGgIpiBByxwTeQwQ/fen40cfcqmB
         YSq8pzKIU9prd9j+zZn09uTyu3KaMZieNtWh2iM9UwP9Oy62Adfr6j7KzYJg01LThGGN
         zwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XVB/qxc195E6rDp2lOgsfW+eYTkI+LAWzMzryJMzQSk=;
        b=S2wQbfB86Y69jGUqTcarxBggN52uJlLTY1CnZT4kdEUpBmVp8x3wLv2gdm1KUvxrL2
         E3RQYhb1I4v7o+MT+PaN68bMMQP/6TYTt016fPVhKkQXkuvP0Q1/5R324zAtoSefVXf8
         JeHOQFJwZCKn3FCYG2atrJdO55e4jCV8XzmMf7CXXWWJiM+QCbZ5nGqffNibhr3DkTAk
         vspk8MatRWlPdq+sHoxnGEN8i9A8gjrO04ZqcqcCO+9z0Hp7ldMbBmbvXVVw8NbKvTIi
         VCObuXWQTQFe3DmCZ2YlsRnQBfzRxU1A75e/y+TOK857lgomekmdoAfNRbUKgSn5wjXj
         YnhQ==
X-Gm-Message-State: APjAAAWAkHU8z6ijShYbe1LomQebLvawPrOT0BICpZ1GyaSCjcONuXMU
        dYYvMVZ0GKj1OSO3ZyofCGmxj0VhHXI=
X-Google-Smtp-Source: APXvYqwBI0IE3A//wbtIIbFn4B3zfmeIVg7QHrQhbtjdtVITsZx2Yp1Oz/8MgBn6t1ivdu4I97Gzuw==
X-Received: by 2002:a63:755e:: with SMTP id f30mr8580435pgn.246.1562376415631;
        Fri, 05 Jul 2019 18:26:55 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id h6sm10826144pfb.20.2019.07.05.18.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 18:26:55 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v7 0/2] KVM: LAPIC: Implement Exitless Timer
Date:   Sat,  6 Jul 2019 09:26:49 +0800
Message-Id: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dedicated instances are currently disturbed by unnecessary jitter due 
to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
There is no hardware virtual timer on Intel for guest like ARM. Both 
programming timer in guest and the emulated timer fires incur vmexits.
This patchset tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the unpinned 
timer will be moved to the nearest busy housekeepers after commit
9642d18eee2cd (nohz: Affine unpinned timers to housekeepers) and commit 
444969223c8 ("sched/nohz: Fix affine unpinned timers mess"). However, 
KVM always makes lapic timer pinned to the pCPU which vCPU residents, the 
reason is explained by commit 61abdbe0 (kvm: x86: make lapic hrtimer 
pinned). Actually, these emulated timers can be offload to the housekeeping 
cpus since APICv is really common in recent years. The guest timer interrupt 
is injected by posted-interrupt which is delivered by housekeeping cpu 
once the emulated timer fires. 

The host admin should fine tuned, e.g. dedicated instances scenario w/ 
nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root  
mode, ~3% redis performance benefit can be observed on Skylake server.

w/o patchset:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time

EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )

w/ patchset:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time

EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>

v6 -> v7:
 * remove bool argument

v5 -> v6:
 * don't overwrites whatever the user specified
 * introduce kvm_can_post_timer_interrupt and kvm_use_posted_timer_interrupt
 * remove kvm_hlt_in_guest() condition
 * squash all of 2/3/4 together

v4 -> v5:
 * update patch description in patch 1/4
 * feed latest apic->lapic_timer.expired_tscdeadline to kvm_wait_lapic_expire()
 * squash advance timer handling to patch 2/4

v3 -> v4:
 * drop the HRTIMER_MODE_ABS_PINNED, add kick after set pending timer
 * don't posted inject already-expired timer

v2 -> v3:
 * disarming the vmx preemption timer when posted_interrupt_inject_timer_enabled()
 * check kvm_hlt_in_guest instead

v1 -> v2:
 * check vcpu_halt_in_guest
 * move module parameter from kvm-intel to kvm
 * add housekeeping_enabled
 * rename apic_timer_expired_pi to kvm_apic_inject_pending_timer_irqs


Wanpeng Li (2):
  KVM: LAPIC: Make lapic timer unpinned
  KVM: LAPIC: Inject timer interrupt via posted interrupt

 arch/x86/kvm/lapic.c            | 109 ++++++++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h            |   1 +
 arch/x86/kvm/vmx/vmx.c          |   3 +-
 arch/x86/kvm/x86.c              |  12 +++--
 arch/x86/kvm/x86.h              |   2 +
 include/linux/sched/isolation.h |   2 +
 kernel/sched/isolation.c        |   6 +++
 7 files changed, 90 insertions(+), 45 deletions(-)

-- 
1.8.3.1

