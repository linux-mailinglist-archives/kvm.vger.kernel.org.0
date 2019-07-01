Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F03CAF6
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfFKMRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:17:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41895 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfFKMRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:17:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id 83so6877407pgg.8;
        Tue, 11 Jun 2019 05:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VstETx0bfm7UURKplBatSb5BNYNyEd5qFU1Sx8kI+P8=;
        b=IA3uBOyzTPBq9pCogzGKvaZOhjtmYw/hCBMQOC3HoqTGKt9x/zMu2vwp8APhrTCqdD
         QjFs0B+8JrRHRKqMiB5P+OWsH+7GOZuj0n5fR1fM6qBcWWxjwelRiiJZOYYtLr5UEeDk
         K/rA/WLlK4txuJ9Ice/Efj1GG/nuJnI6qrAF5fpnQ46gTEK1J0t4pzh3bLBZW0TPiQ3g
         tqo3LjqFEuLz0d+3niWnCP/6OGEuqjE8q38qmoxSd3ZFpthsutrk+phrMWWShtzBZpe9
         zBkOD/bRCYDLiwapO4p+JhBZpstmd9OA/VTxWSyYVsnxPxwfdYjbK0/S07c6fBBnEbZQ
         4p4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VstETx0bfm7UURKplBatSb5BNYNyEd5qFU1Sx8kI+P8=;
        b=Ovh7Gr2sF5ITMaQ7gJzRE1ySnXpsGLjahGKxeuq0HOmLTP86HBPg1sH1Fxy5O65FV+
         aIOyGAC+4F36EJl71ewVx/BZViblElkzjyJlrzk2wzYnXeeIU5skrww+TPqiZx7Yxhh/
         vLu818/u6r5/JipUBLWjUZCtI6KI9KVmqjESz/43sONDMfdJxEcXjmbkm27JLEcELdtE
         +wz7n2xHfTJILnyBt9a3lGrtEp9b7cdQeGtS3D9S0QaLfJXVviuhm0X49FHncw9jO9y4
         39Jh9wNwkVw+LMBD34ACravjb70wQlG74/H6GmyHRWERarLzjTXSIs/J+ZH6Q2SzuW44
         qivA==
X-Gm-Message-State: APjAAAU00w5s7oA6WRN/OVH+YXVrci+7zAn5To/+RYNy/9heStfTKI8h
        54lVPzD9KH9KVSIRb3h3hh/dIpIE
X-Google-Smtp-Source: APXvYqznf4FbDIT4rjVPKKrufi3F7ndvwcmyiiuN8AKVEPO92qX3naFifYMC1DO4mMs/6uA9pzG2Cw==
X-Received: by 2002:aa7:9203:: with SMTP id 3mr81570451pfo.123.1560255439322;
        Tue, 11 Jun 2019 05:17:19 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v4sm19649478pff.45.2019.06.11.05.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:17:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 0/4] KVM: LAPIC: Implement Exitless Timer
Date:   Tue, 11 Jun 2019 20:17:05 +0800
Message-Id: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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
timer will be moved to the nearest busy housekeepers after commit 444969223c8
("sched/nohz: Fix affine unpinned timers mess"). However, KVM always makes 
lapic timer pinned to the pCPU which vCPU residents, the reason is explained 
by commit 61abdbe0 (kvm: x86: make lapic hrtimer pinned). Actually, these 
emulated timers can be offload to the housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected by 
posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

The host admin should fine tuned, e.g. dedicated instances scenario w/ 
nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
for housekeeping, disable mwait/hlt/pause vmexits to occupy the pCPUs, 
fortunately preemption timer is disabled after mwait is exposed to 
guest which makes emulated timer offload can be possible. 
~3% redis performance benefit can be observed on Skylake server.

w/o patchset:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time

EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )

w/ patchset:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time

EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )


v2 -> v3:
 * disarming the vmx preemption timer when posted_interrupt_inject_timer_enabled()
 * check kvm_hlt_in_guest instead

v1 -> v2:
 * check vcpu_halt_in_guest
 * move module parameter from kvm-intel to kvm
 * add housekeeping_enabled
 * rename apic_timer_expired_pi to kvm_apic_inject_pending_timer_irqs


Wanpeng Li (4):
  KVM: LAPIC: Make lapic timer unpinned when timer is injected by pi
  KVM: LAPIC: lapic timer interrupt is injected by posted interrupt
  KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
  KVM: LAPIC: add advance timer support to pi_inject_timer

 arch/x86/kvm/lapic.c            | 61 +++++++++++++++++++++++++++++++----------
 arch/x86/kvm/lapic.h            |  3 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 ++--
 arch/x86/kvm/x86.c              |  5 ++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++
 8 files changed, 68 insertions(+), 18 deletions(-)

-- 
2.7.4

