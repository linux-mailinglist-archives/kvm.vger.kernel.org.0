Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A842101
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437453AbfFLJgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:36:10 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39251 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436605AbfFLJgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:36:10 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so1358776pls.6;
        Wed, 12 Jun 2019 02:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Bwt9+qz+AnhkB+QO4srVFst1BFDSja84fRaOKcsTYE4=;
        b=uzhK1YTH6qMfYVGffxfObguwKqDNEhPS9karLIpaUmWDIkZ9nIv+DkvOPQIx8uJAW6
         gECEXYysk6fgXnKyamjOd5lpPOzsCntynt48dii2dvzOM1KftwP9wQGtVqj6YaGzEZ75
         lYDm1Fc9+nhvdfYmoSSYs0tDTLHSVot3KjWk9QpaJq5CwsUD4lh+bpsmzP1HkEV5ENVg
         QReSXeGw5rqISCxKnfJN/Ifj9XSdxChe4+A9OJ3g30h2zBiagKKok56ANrwKcysyEzju
         UD1Gfx5XUQMWufO//9cjxMe9S7448ww1ayMC8SIcsbqhF1tPB9Srbe7EnKRfxPwerg4X
         kE0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bwt9+qz+AnhkB+QO4srVFst1BFDSja84fRaOKcsTYE4=;
        b=kFhPVRS4Q/18EZ8whd09QlyxvBEyKDzwHfil8Q7aJos9dYa0TVl5DWiZIxfcdkXAMJ
         E277PsIPupadGcVDcjNkQ5KgjNmb39e7v8PEPjT9YjpWe3HUNU3Pa4EAcxGfEOlizgTr
         fXbezk6PLm4qDc632mguNqgWip/EgXoDX9lcO0/KShhlZRiKzppQsz9VQOIna1ieGSAd
         9j8a6b/fpCGaz91tR+akn+1bwtrPPIG8b/aKUhkxXbyTsjG179QkXPqtB4eK95EhjjjB
         QcWnelb53NbLkBr9IRZgDWq9MFmtJFrsuZC1+fm50T3L5z8lOzvZQRkVYmciTBmj5Jeo
         08bg==
X-Gm-Message-State: APjAAAX4pvZEA/iD8YIHmCBG5ij7P59berDysp+RkeO2WgxzBzPhaJ+U
        7iOFFGkhLHMaea83IDKPk2SYJzVh
X-Google-Smtp-Source: APXvYqyMZ7FHMAQ2t58NZIYBHnJDElTJ9nl3eYQiYgEJwaqPRzp5A4dVTKxSuk0AygzBd2TATrnDIw==
X-Received: by 2002:a17:902:4643:: with SMTP id o61mr28332033pld.101.1560332169135;
        Wed, 12 Jun 2019 02:36:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 27sm6148936pgl.82.2019.06.12.02.36.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:36:08 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 0/5] KVM: LAPIC: Optimize timer latency further
Date:   Wed, 12 Jun 2019 17:35:55 +0800
Message-Id: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advance lapic timer tries to hidden the hypervisor overhead between the 
host emulated timer fires and the guest awares the timer is fired. However, 
it just hidden the time between apic_timer_fn/handle_preemption_timer -> 
wait_lapic_expire, instead of the real position of vmentry which is 
mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to 
advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between 
the end of wait_lapic_expire and before world switch on my haswell desktop.

This patchset tries to narrow the last gap(wait_lapic_expire -> world switch), 
it takes the real overhead time between apic_timer_fn/handle_preemption_timer
and before world switch into consideration when adaptively tuning timer 
advancement. The patchset can reduce 40% latency (~1600+ cycles to ~1000+ 
cycles on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when 
testing busy waits.

v2 -> v3:
 * expose 'kvm_timer.timer_advance_ns' to userspace
 * move the tracepoint below guest_exit_irqoff()
 * move wait_lapic_expire() before flushing the L1

v1 -> v2:
 * fix indent in patch 1/4
 * remove the wait_lapic_expire() tracepoint and expose by debugfs
 * move the call to wait_lapic_expire() into vmx.c and svm.c

Wanpeng Li (5):
  KVM: LAPIC: Extract adaptive tune timer advancement logic
  KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
  KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
  KVM: LAPIC: Delay trace advance expire delta
  KVM: LAPIC: Optimize timer latency further

 arch/x86/kvm/debugfs.c | 16 +++++++++++++
 arch/x86/kvm/lapic.c   | 62 +++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/lapic.h   |  3 ++-
 arch/x86/kvm/svm.c     |  4 ++++
 arch/x86/kvm/vmx/vmx.c |  4 ++++
 arch/x86/kvm/x86.c     |  7 +++---
 6 files changed, 65 insertions(+), 31 deletions(-)

-- 
2.7.4

