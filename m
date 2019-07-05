Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6705F60872
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 16:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGEOwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 10:52:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46975 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbfGEOwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 10:52:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so3152502plz.13;
        Fri, 05 Jul 2019 07:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xoxhzo3l05k4IgMr6KE3jnu38RTpgjmGvrGCZA3aEcA=;
        b=LiM+ok+EGFwhkgz82cP/xLLUElt29O345EseznN/MicVHLl/MNWEYKBjpRfYghG8XW
         Wch/ETz/pu7mlwBYV7kuEhZFJmYr2ktXNTk4tak9WlnWJ8cagrTFDXWN8C1xR9Pgb0WY
         2mxOYAVVyLUwqVj+SDdY2NDr14rWlK7F7XX9WLwpc8Ubj9dajW6KPYBKXfR8b9GdVFpu
         cNSxd8tZKYRaNTF/OuLbjRPbkRPJmLdubm9GJp36zbyr4E8zo6gRPc2/d+zobn7TWZTj
         WHKHiH+khH20Mljs8V3ETec/Xxc6fE8NcOt4W+oYrNSIXOotIIWjkilQDWLj5prNPRx5
         l0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xoxhzo3l05k4IgMr6KE3jnu38RTpgjmGvrGCZA3aEcA=;
        b=IUTmY6Ok+ZbPUdMUdUGUtPAX0zfKlZ4UaDgJ2SNClMqEH/LIyDKiBKgMQYqK+NhoOE
         ifY42/vmE0Hb/sbcEoqXya69KMo9f6HCgG5Io5SCp7dt+pxM1fPy+gZtE2MjDjet3IBU
         oLHd7SZmKuZb9op9v0YPtWuBin6O82xiQBuYY8zpUpuA6QAqcRVhY8QLo5NSLswGQIPM
         jCW4AEU15n6AuDwOqfHY2da0T72plHHu7Ur+vrQ4poOo9JoGBK8Ioon4aMtJrapmuBM/
         CqwgDJCfJK7J9Fh4DuUSx9/sdxQm6qRcB4UlojXMHOz2JTxymMXxoxfSVXQ7MTeyF9Uz
         c7Bg==
X-Gm-Message-State: APjAAAUtQsaudLlplOi7EjZZYaaub5zwqhRr+bIs1v6yMywPOjEmygU9
        XF9svnAugY6wpCOVbg/JfNoj5qSB
X-Google-Smtp-Source: APXvYqzElcWjWSfQhJjSDaEtp89wjoYoNl78H4pTfWBIIXo+tGVP/gByEaS8foCoXUJyemmTnmGG/g==
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr6258798plc.78.1562338373216;
        Fri, 05 Jul 2019 07:52:53 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id f17sm7755070pgv.16.2019.07.05.07.52.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 07:52:52 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v6 0/2] KVM: LAPIC: Implement Exitless Timer
Date:   Fri,  5 Jul 2019 22:52:43 +0800
Message-Id: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
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

 arch/x86/kvm/lapic.c            | 60 +++++++++++++++++++++++++++++------------
 arch/x86/kvm/lapic.h            |  3 ++-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 ++--
 arch/x86/kvm/x86.c              | 12 +++++----
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 +++++
 8 files changed, 66 insertions(+), 26 deletions(-)

-- 
1.8.3.1

