Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373FD1FDE4
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEPDG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46432 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEPDG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so772859pgb.13;
        Wed, 15 May 2019 20:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Bwt9+qz+AnhkB+QO4srVFst1BFDSja84fRaOKcsTYE4=;
        b=kj8kBK0AL+RYTn0MLfGFC8FFs5Den6GOBZDA/4pR6sWLI9djQMLKvlzAjlqybWm1w4
         BlmXOC5OvnEWOmM2zcpF+epEtbAujLLzrWxX+limr/K6vA3h3wGAhBQzqiG3AwayPnpB
         WWqZQ9No+P+y9bqLjS0hQndh/1ed4jKWS8GxX/EiQbyNdsZoCSAmQcYqaT/Ea+PoBfa6
         hztg0UGchcPKbyHyrku1sNifWPheTAl25B8hk00OiECH0sDWiMWlSojq3R5Jl6mU8N5y
         r/pHpiK0yl/OBjlaPhB8jVL4xdWpY9otI5cKsdpJFkTEt9WQgr0hchjfzp3+VluGAH96
         yQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Bwt9+qz+AnhkB+QO4srVFst1BFDSja84fRaOKcsTYE4=;
        b=gZX2WlD9w2H6blhSKJ/uNPZnoFsEu4fzSu6S1PVeX+73r0jNTTLXcV2Pv4nFtV6o7Z
         DDaKPt/qcWol2j+mwpV13YAA3EvpS2/cRA6rZ0Dg6oeLc2JSvBtAALE/gZfzHV8BSNjm
         Xg+JqieqJh6gbXlXPOTYO86A1zd84BEunGlH1opz6PV6BjuW2c0lqT8r/Vq9Jf+LJKDw
         eX1GzOXAGKoE3eYPPfJ7x+N01qWolyh/eXHqiWgTVHH2QHmoPZF9f17esyin9hUYtsf1
         zos6d81bLDhH4OZ+YInP+lhLiG89ju072Vn7CupW5n9MX4DNYtdOf51JsKd6eX03FYIc
         5umA==
X-Gm-Message-State: APjAAAXGkL5wMYboM4MKnVJvDU/0lP9rho5c9e2wAXKSm8I2PSocYAjl
        rR0LGI1Nr2iSpceFFkUyrxz6cH0K
X-Google-Smtp-Source: APXvYqwy3pzxXgeq/dgeALCruPuUzqBvVs48pIKSJwbCNzlEvPGErq4sZOQ05ku5u3QoThulOJkyFQ==
X-Received: by 2002:aa7:99c7:: with SMTP id v7mr51766060pfi.103.1557975985134;
        Wed, 15 May 2019 20:06:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:24 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 0/5] KVM: LAPIC: Optimize timer latency further
Date:   Thu, 16 May 2019 11:06:15 +0800
Message-Id: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
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

