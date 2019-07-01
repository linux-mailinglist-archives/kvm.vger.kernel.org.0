Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDBA4E44B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfFUJkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:40:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46778 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfFUJkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id v9so3076842pgr.13;
        Fri, 21 Jun 2019 02:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bQOe4YC55MjXidhQyekhFCyApqlkjR49EVWhHXYQiyE=;
        b=BDgqvb/XyDsbKkYanM6KgSq03AoObOC4Mzi0/rvdbhtI+xJcz3c02UgaosuWwpgxds
         nSgBy2Bsa5xqOOrVUKs4J5nSoFF5xgzKSTC+Oe+GkilueJ99ouOjcldenHOBkyzNO3Aa
         4zKQDJH/I0FSKcxys3TZSWK3OILRe2cVw28WmbIJYMZM/41gsk59CRB6QQ78r0v+7jRL
         qWDeL7eVvksfSC2o8+XpCsS9o7lFNEFOSdSScYismRlFtn137wC5Q3jotArw/PTu6p2V
         gxSKK3d9TaDFqimtiYkXMUlIj0ZWInTbpcyNH3XF1Ji6niko/oRzrDgUedtyMgawtJLm
         5jrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bQOe4YC55MjXidhQyekhFCyApqlkjR49EVWhHXYQiyE=;
        b=Dw0/UoQW/IKHByzqJPJ1OiZkZMEQYYdfjPKe4r+bi91mMTfP80URqFZy0AZmVhGn/m
         irfUVPXkyCxVMq66KeFCO3N0RAYBINtPQ8Iug6z1ygw98axlHcKg5T5h8z6Z1Ag1ZE/p
         NRmYK+nnHK+T6XAcOD5IwJ6tnc4kV4IAsp6isLTroe0tfXd8FUkDsJAfB+oU/QGmEgW4
         aDWLUQ5n/xhDxmwy4TrYXnF0mQ2tdnM39AKmo02dtVAp7sqRRXfU7Bk+ytNcQJ6rrDJA
         OaDuGGDP+ufcIwpiNQjiGSLZlWsnR/YO9T6TJY5NXQRQW305eFmc8xHt3N3mrIgUIQtk
         9DdQ==
X-Gm-Message-State: APjAAAXr2LDvh8spvULA3/+ejzGMaUk6J1NXEwT/qw1Xi9KAohuYCRaF
        v0myiPYEco/tk7V6kK1g0ip6WuiH
X-Google-Smtp-Source: APXvYqyObj0KET/d7/xGsMB3ZP6ObgrbfDqJzqBiXHQPN7WbduJdareFUM3/qeZO7VsRgzJ5kC+14A==
X-Received: by 2002:a17:90a:8a15:: with SMTP id w21mr5463984pjn.134.1561110012819;
        Fri, 21 Jun 2019 02:40:12 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y14sm1999506pjr.13.2019.06.21.02.40.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 21 Jun 2019 02:40:12 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v5 0/4] KVM: LAPIC: Implement Exitless Timer
Date:   Fri, 21 Jun 2019 17:39:58 +0800
Message-Id: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
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


Wanpeng Li (4):
  KVM: LAPIC: Make lapic timer unpinned
  KVM: LAPIC: Inject timer interrupt via posted interrupt
  KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
  KVM: LAPIC: Don't inject already-expired timer via posted interrupt

 arch/x86/kvm/lapic.c            | 68 +++++++++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h            |  3 +-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 +--
 arch/x86/kvm/x86.c              | 11 ++++---
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++
 8 files changed, 67 insertions(+), 32 deletions(-)

-- 
2.7.4

