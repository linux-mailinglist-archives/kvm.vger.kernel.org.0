Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53111E750
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfEOELh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:11:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34615 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOELg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:11:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id n19so653900pfa.1;
        Tue, 14 May 2019 21:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p98OlGu9SV+BFYem5XMwnXe15at0yFGCsMrG4alRIQ4=;
        b=pIx3SabZFC0lSb9tUT09jqGksi9P3BLToB76wJHDVOisRhsqmEV/xiMeHyns3sFVCE
         XBYXFz/ZylP7at2Pa9TH8ZQsR/swbRfyFrlaEgFDSuQ2Y0gDs5BQw/Rpgx2t9Pp92el3
         8Dnc1QURoR5TWf0cV6su6+loENMwgf1iznkIlQZb168kWKraLSTFz4ael8IruXQaBjnv
         1xFR+O4/2ygV2mqQvD6/BjQkidtyfgvoWTWv7LneCSZ3xiDo7pRcBuU+SQGBZ7Tid1vq
         7jHJEOophbHiKdCXA85NjmRionhnef0D5IzDmGw5XpFWTQj3MTxZaXZ5f/pugQE+WRbI
         KyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p98OlGu9SV+BFYem5XMwnXe15at0yFGCsMrG4alRIQ4=;
        b=jyvcV7U2ekc8I8CEs2QYDzQTGQiJsKAJvCux/GImXCPZEkJZSHmEnuulIRcfJmYoZ0
         IVaW3/ITvvzH1lovIh564eRnNPZ/1xcTuWfNv9HapplcRdMKtlsRhfZ6RpjOaQZzdHQY
         Y8ZYKesw+U+Rml6oo30ZIfGgpV2Q8nI/S7ZrR3tim9YLlMkXMw41LdZuxakqM2NFp6O3
         Q4XHUIl/oLaIOJYut1M+TjbjZ5AwXbYAgHuF6/M0C4Q55nbgDsyT3Hm2KyFI+XiRy8EJ
         X7eSr/rLWGTlH9p6R5gzitszguPCUsL8VoPdMPL7IWiDaIN9svFNV5CTzzwCeaghyHcA
         H4GA==
X-Gm-Message-State: APjAAAXCNyqJCo4jgCAeDHpC/jds9pckKaQXpdb2aMuMe2yopnLznu1k
        JkYVUD4pozJ7FDLeVjKJnZVkfZ7U
X-Google-Smtp-Source: APXvYqzNjIHeV+2C5d2WxNNM5MKUn7P54T4iPAtFq1vaBto7GQfmQfmbL3xO6pvnEFkgPmdJCZ2cTA==
X-Received: by 2002:a62:7513:: with SMTP id q19mr44835622pfc.108.1557893495865;
        Tue, 14 May 2019 21:11:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id i12sm808026pfd.33.2019.05.14.21.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:11:35 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/4] KVM: LAPIC: Optimize timer latency further
Date:   Wed, 15 May 2019 12:11:30 +0800
Message-Id: <1557893490-5715-1-git-send-email-wanpengli@tencent.com>
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
the end of wait_lapic_expire and before world switch on my haswell desktop, 
it will be 2400+ cycles if vmentry_l1d_flush is tuned to always. 

This patchset tries to narrow the last gap(wait_lapic_expire -> world switch), 
it takes the real overhead time between apic_timer_fn/handle_preemption_timer
and before world switch into consideration when adaptively tuning timer 
advancement. The patchset can reduce 40% latency (~1600+ cycles to ~1000+ 
cycles on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when 
testing busy waits.

v1 -> v2:
 * fix indent in patch 1/4
 * remove the wait_lapic_expire() tracepoint and expose by debugfs
 * move the call to wait_lapic_expire() into vmx.c and svm.c

Wanpeng Li (4):
  KVM: LAPIC: Extract adaptive tune timer advancement logic
  KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
  KVM: LAPIC: Expose per-vCPU timer adavance information to userspace
  KVM: LAPIC: Optimize timer latency further

 arch/x86/kvm/debugfs.c | 16 +++++++++++++
 arch/x86/kvm/lapic.c   | 62 +++++++++++++++++++++++++++++---------------------
 arch/x86/kvm/lapic.h   |  3 ++-
 arch/x86/kvm/svm.c     |  4 ++++
 arch/x86/kvm/trace.h   | 20 ----------------
 arch/x86/kvm/vmx/vmx.c |  4 ++++
 arch/x86/kvm/x86.c     |  5 +---
 7 files changed, 63 insertions(+), 51 deletions(-)

-- 
2.7.4

