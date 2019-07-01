Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC3022E41
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfETISZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41392 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfETISZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id z3so6417137pgp.8;
        Mon, 20 May 2019 01:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aHA0LJTPZeOxFVzbMwsR6eVGKi9IWjeRHfEKxIDCe9Y=;
        b=kmPGW8RDbeSq5Le00m+HuFrtGFRy+t4BO4MqL+ryIEZDiJd1l+AGHLfqzhbp6rnyKX
         HJkHQMXd8W7pMJD4Qjaj+dKjKQsxJwPKpPBzvZggrX8Qw7yPD69lyy6pRK2unePW/K6f
         XDh0gTjOASY05PYWIUD+W3aUbhILf4jnttNXpRMuDaYlRFUkFmWOKFQ2zqvsOF9GGVWV
         9q/u58Syzq0frbUo3DKDDJyvc1JQFV2GCiOeDdnmnSVZDB29FX1Qr8vUemdYwZenwu8o
         w9f5mv4KYCS/yavCSf9v9c/8aKqVqlc/qt+ImuT1P1JbKSmlFVaZAlbLlImHbNWsFVIB
         /WIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aHA0LJTPZeOxFVzbMwsR6eVGKi9IWjeRHfEKxIDCe9Y=;
        b=O72z7qWVuoiNyn6tUpEBBfno/5Bu3qfO1/h4RwRXs2Rf1k2CreAJ9DLU+k/KrbSa8x
         1osc1/plIsgK400O4G8IL6mc3D2ltqbo18F67ZWwHsssE7G+C6Q0+GubjMscx/fnN0da
         QtDJY7XF659RRpEfACAbaECOhmrISDTsq06QOBh6fQgkK45PsCPgCka9br2uPw4XpdvR
         GWaEwfIcqOY4Uz4jP1+2mWqaK9RwNj3GRidm3fp6p/dd6v+KZu4Ndsp0jwjKU4oLNwEN
         nhwCaGMaw6sPGEy9zUBor99lEIEeHIjum6oLxRuZ/kkJttUpO7/S65uxfsRllieo/2HY
         rETA==
X-Gm-Message-State: APjAAAW7XrGtfFa6AW9quUKlt0lSep1pfk/j5z4ZZcSht6Q+rnwT43/M
        nvR1hF0jACjU5ayVv4Lt6HbNBL9J
X-Google-Smtp-Source: APXvYqyKvxzzC6Pp8Q3BGtraUwMgn+/g+tVxApO+d6BDlQhMKWMrXShjUEsQu2cQ8iZ9GdYKIF5L4Q==
X-Received: by 2002:a62:4351:: with SMTP id q78mr77550278pfa.86.1558340303993;
        Mon, 20 May 2019 01:18:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:23 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 0/5] KVM: LAPIC: Optimize timer latency further 
Date:   Mon, 20 May 2019 16:18:04 +0800
Message-Id: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
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

v3 -> v4:
 * create timer_advance_ns debugfs entry iff lapic_in_kernel() 
 * keep if (guest_tsc < tsc_deadline) before the call to __wait_lapic_expire()

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

 arch/x86/kvm/debugfs.c | 18 +++++++++++++++
 arch/x86/kvm/lapic.c   | 60 +++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/lapic.h   |  3 ++-
 arch/x86/kvm/svm.c     |  4 ++++
 arch/x86/kvm/vmx/vmx.c |  4 ++++
 arch/x86/kvm/x86.c     |  9 ++++----
 6 files changed, 68 insertions(+), 30 deletions(-)

-- 
2.7.4

