Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56ABE36BA3
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 07:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfFFFbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 01:31:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39404 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfFFFbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 01:31:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so669509pgc.6;
        Wed, 05 Jun 2019 22:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KfZrwgIDaqBuX8IJizb1+AcI1AFU6VOtdglxmDzVgSE=;
        b=MQYvZbyLDVyY6CJoZZMgZDaRVGPiaS3QbI/cec0BsjLUG7enV0s1mT1YNa0nLJbovj
         CKmd0zRFVdswMvqiSLPco2/ORmH+cO/K3ZLQ69ZrqmphuxLimlIGTAKojaPQu3i92G/7
         kbhYCcx63jZp+17oxvDua5uwYq+t0et0FFeOSWWTbT1zd+fjU6doO/wokup42KZp4Ngy
         Goxjdej0BlbCcaBM36MQevVSvwND/ecwAA8MFN0FqJMEdmUP32UAzu/eQVcM6Z+JOLkx
         82jFarXbVcHZkBZ0s7NEMw6pQgG1UBrSiNoyqqnYdMJ2dsI4gBKkcZvh0BKlShNaNArh
         dlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KfZrwgIDaqBuX8IJizb1+AcI1AFU6VOtdglxmDzVgSE=;
        b=tmSe0rDHgzomuge3Ifl5+kj50E0vI3bg1QpH763bPw36/7cvAt5Z0Dyp5ph1zpQCq+
         /WJrnwSqXlkwZ7ZyK88z1LpBC/MUvGzpzVohrvN5y4DtmoC8kgK4arAbjR4iXjSLgdKF
         We/z822U9xRBnymd6h2zRyTgNTRro60E1t0wu74AkF4dHKZpBrH+9CDz4cukfbTSOtT3
         eP7Ec4v68BCOF52EmiojYTbmFvtAi+wy0yO5+72XlldajRmBgPWOWxVybVHgCcUkW1jD
         XMPM0X3OY8Y+TfQuSlC6wZEJgz1a4B42uoFPRM+mgLuMEtzjXHgGWr6NAxyfQmryTGmW
         UGIA==
X-Gm-Message-State: APjAAAXamdyGjLSp4yLs4i7O3lpO3e/OH/bPoInk7jARSeqbzjZy+qmE
        Fr/CygZRhdGsXxZKbn9w/tbCTTwe
X-Google-Smtp-Source: APXvYqya5AvHx54xkJPbOQphNF6Kwy4EUSVFKcguQ1TyDa/rIMiRUcKM3NULilszbOByaXz+L6SPEg==
X-Received: by 2002:a63:6848:: with SMTP id d69mr1720684pgc.0.1559799092578;
        Wed, 05 Jun 2019 22:31:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f11sm721547pjg.1.2019.06.05.22.31.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 22:31:32 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/3] KVM: LAPIC: Implement Exitless Timer
Date:   Thu,  6 Jun 2019 13:31:23 +0800
Message-Id: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
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
3%~5% redis performance benefit can be observed on Skylake server.

v1 -> v2:
 * check vcpu_halt_in_guest
 * move module parameter from kvm-intel to kvm
 * add housekeeping_enabled
 * rename apic_timer_expired_pi to kvm_apic_inject_pending_timer_irqs

Wanpeng Li (3):
  KVM: LAPIC: Make lapic timer unpinned when timer is injected by
    posted-interrupt
  KVM: LAPIC: lapic timer interrupt is injected by posted interrupt
  KVM: LAPIC: Ignore timer migration when lapic timer is injected by
    posted-interrupt

 arch/x86/kvm/lapic.c            | 55 ++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/x86.c              |  5 ++++
 arch/x86/kvm/x86.h              |  7 ++++++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 +++++
 5 files changed, 63 insertions(+), 12 deletions(-)

-- 
2.7.4

