Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C3648089
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfFQLYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:24:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38999 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfFQLYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:24:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id 196so5658735pgc.6;
        Mon, 17 Jun 2019 04:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=On7E7zmLSRgJj9Ttl1gLhH57uyxxO3PDcMqtYU/ZX3A=;
        b=erP9kbch+/6D93JrTKRtB/9WivFEV597MDMtDcNbuA81UdsF/WYopiQgFtZt/DdMeJ
         igUmflkUgVylTtJqDgqo86aOLhTQGCJ7asJo9ZxxpJNyOPfOm1OIL86ZhqEcpYGyxNwn
         RgmP/UFuTIo6+AqSDR71wxFk4anXVEitvA1Ggvre3ObKdVFfbNVXAWJAfXPczB0Zt0r+
         sqI4k3bOulwes5gH7cGUU5Nuw91afJmAXO2mwkgA2bZjSvcYyNCUVEH0g2m1isp2tK5Z
         9bSyYcqbidNKrqcpufW0wwImIVaWzme2sQo4yjWHetsWgyzB6SolI40aNKagtB6l27j/
         ZocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=On7E7zmLSRgJj9Ttl1gLhH57uyxxO3PDcMqtYU/ZX3A=;
        b=fBps6dQCbTfl0wNkHDUHCI5Mg8ivyLWpha5zbIhQSdBEX/0e6askYd2kMrhGheVbFY
         rqooEGEfgNhmsG344mpHeb6BtZy4O/RHhG3q/QCpjVlnyrB2Vma+ZRfWGlL89ebweJpE
         170KFLDvjwX5qvT+E5QFL8odAbBh3ab3eIsnCPfRqheuEEzk7bjieS7rnUOYTOcgCLzl
         2rmwWeXNbqxfpa8E38RKpyssehwRnZzHE9XlV+fyB7gCHYoYFfW/LbxeDdUwD2GbjVC2
         X9AYAFJ0X77qhw7lBZHX+Mvp8v0sAar3Spbch3t4bzeoPLOSiAyqNcBjJYYPsJhMcknu
         7abA==
X-Gm-Message-State: APjAAAU2DegaufORrW1Z2N8ODfFKv4G6a+yVESCF0Xcvncjrp4Uguvne
        utO7OhrFi+4oCChndOaZx6lGM7yb
X-Google-Smtp-Source: APXvYqysEiwTEoKS6WXujqPEY+h+jIj4Y7EPTe8opfIL0Wz6ucLZLbcZCZDZnoYc5R9JgXPTEzT5DA==
X-Received: by 2002:a17:90a:ad93:: with SMTP id s19mr1033613pjq.36.1560770692765;
        Mon, 17 Jun 2019 04:24:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.24.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:24:52 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 0/5] KVM: LAPIC: Implement Exitless Timer
Date:   Mon, 17 Jun 2019 19:24:42 +0800
Message-Id: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
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

Wanpeng Li (5):
  KVM: LAPIC: Make lapic timer unpinned
  KVM: LAPIC: inject lapic timer interrupt by posted interrupt
  KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
  KVM: LAPIC: Don't posted inject already-expired timer
  KVM: LAPIC: add advance timer support to pi_inject_timer

 arch/x86/kvm/lapic.c            | 62 ++++++++++++++++++++++++++++-------------
 arch/x86/kvm/lapic.h            |  3 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 ++--
 arch/x86/kvm/x86.c              | 11 ++++----
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++
 8 files changed, 64 insertions(+), 29 deletions(-)

-- 
2.7.4

