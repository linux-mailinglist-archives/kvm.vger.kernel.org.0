Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBCC1E75A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfEOEL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:11:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37642 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfEOEL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:11:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id e6so660225pgc.4;
        Tue, 14 May 2019 21:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p98OlGu9SV+BFYem5XMwnXe15at0yFGCsMrG4alRIQ4=;
        b=JiRmYewA2vI4C1WSGbBqh8MIr2fCCVFgzCmdpqoOLknC7+ElLjvlGoCl1vu5ihnCOX
         bvbHjE2GPfv3f57X3HZBc6rKvrb41wdHlrEt7oI3eNyLXLesmkNt7oC4ScoMspEIFAGS
         KybQau4WYnMy3aRHWBHWPlAbbo7PEjivEL/E2bNc19gKTWQhwEkZndPh6NjRwopTxyMe
         uH7Hg3yvAkQjWGd7quVATOaTmYEAGZ9ZcmtbvkV4Fy9IwQytPSxwNDb9TWA01TIX10JG
         Iyu96UUoCN5sDHibWi3AarYpfktxzgaCRGSArnD7bxc3eZ5XjVeQGoODNkVHdPb42oLj
         Kwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p98OlGu9SV+BFYem5XMwnXe15at0yFGCsMrG4alRIQ4=;
        b=osDN5g42aEwKFSuot3FX98dbBEecgvAKfRgGYohCyMY7LMygCXfT1nV3Fq3ZHqAuBc
         jcHkNX9e6uvm4U2RmRvcQPtUh56S+3TNdpYgR1AGYP5ZAGnjk6NGj/vvDdYFB88KuIlY
         Oy886Usztmzn6Ll4ThuWZXuHdGcvlEfSG8TMsqs5svSfluVU4v1K9Y24XCGNfO+IZsPe
         nPQ+2PspcC1Is+CMFik+txgs4RC7rzDXaqXQ+xsUDElpfZozavL00OrEZIR53WCtDuW7
         jfYLZs+fnu0JiglRq4wkGgya0BCz16k8tUnssL8avhb4vnI+nr4tJNFaZCkXlvPU4/EZ
         WLSw==
X-Gm-Message-State: APjAAAV037bP5crVOLrO4n5giXHRbA3P9sJeXhgTq0zlyyxOMLtieu5f
        1Wc4wvNeuzaeukVvmc4iceGL8dN6
X-Google-Smtp-Source: APXvYqy8Fucb9Ju9Qr+JIuSy6U8+YA0eVo3xBPVFwwOyo0zPIkzPqxRR+3pE3nBx1d02nLZRMePj8g==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr41741608pgv.308.1557893518626;
        Tue, 14 May 2019 21:11:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z187sm886788pfb.132.2019.05.14.21.11.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:11:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/4] KVM: LAPIC: Optimize timer latency further
Date:   Wed, 15 May 2019 12:11:50 +0800
Message-Id: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
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

