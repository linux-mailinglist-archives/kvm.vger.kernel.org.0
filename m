Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627331B6E10
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 08:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDXGW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 02:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726078AbgDXGW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 02:22:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A760DC09B045;
        Thu, 23 Apr 2020 23:22:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s18so1490320pgl.12;
        Thu, 23 Apr 2020 23:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b4QeW0VDRqbvEETBZ13QetaInWr2btitEZOC+VxZd+E=;
        b=WCZQnwIuKhUUloQh2c8VR7QuGYr40YhAxbYbxnj9MafTQWfH98agLefwnFk+dwwLBF
         9fqNuPM3rPdotc1tcGf3gXl1rGWH3Cr0/F+hNpopsTyz3JwOFombvtTce/7PW7xHxR0K
         x9xKvc/QOQlFovYUHuamprejDWRPfZHweqsKzRPs/ADFzI2Go4c33+TXAfC6k56NvR+r
         m7uJdzzKttWWeLZDSArEHhGRSf4XEIAP2qh9EwNKW5vZ3z4AoM0W7iO9U3ywmchGXpZ/
         YfwC4hXtwJkAvMS3ax+Z8qgiIvo220y4wtXahG67ff/a2uL7Qpz36YCUVtIKbDdqywWz
         4gkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b4QeW0VDRqbvEETBZ13QetaInWr2btitEZOC+VxZd+E=;
        b=bgGlorhAzxlJwehLCbNH9pFxM7q6GfdAYX7GpS6rNDs2wTAvheIJDCN4XOp4ehjFSk
         5rb7vMP3g6IHwcpXo5Wff66kgZT2c0d7NpG7hd3PYHoSX4t/FOF1x9ZPdVWx/x1rS0Aj
         0LxyeW+aDzU/JL6sa/ke1+ABE2SL7hhZVS8LXVmtK3pUjqrTIfvqVlYbY1LzTp65H3gu
         Lx22ne9MPa5b0aF/VtD2oudMwEPrREJTuxiW1WqnMFHu+4jYWmS4DLseSdKEJt/0FmWx
         ddZdgZ68yLSTDpBVmX5AjgZVjtrPIj5d680P8N5v6UZ/CZAjbY07BfFxvb5DK8wqlMMa
         jCVQ==
X-Gm-Message-State: AGi0PuaqHTssG9V/tsf/jO57rcLbkEKcF7gySZaSAx8QG1a7RyvJWphw
        XBCZ71E6UYoQPyIG4NsEOOC9VzKo
X-Google-Smtp-Source: APiQypLCAowU4naaUsrYWj3L8M20ZXDYtGd/6A8oMccsd8PP/tZvLc1tOnBHQsjPeJzsALADPaxi5w==
X-Received: by 2002:a62:7c51:: with SMTP id x78mr7651501pfc.227.1587709375986;
        Thu, 23 Apr 2020 23:22:55 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l30sm3920674pgu.29.2020.04.23.23.22.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 23:22:54 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v3 0/5] KVM: VMX: Tscdeadline timer emulation fastpath
Date:   Fri, 24 Apr 2020 14:22:39 +0800
Message-Id: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IPI and Timer cause the main vmexits in cloud environment observation, 
after single target IPI fastpath, let's optimize tscdeadline timer 
latency by introducing tscdeadline timer emulation fastpath, it will 
skip various KVM related checks when possible. i.e. after vmexit due 
to tscdeadline timer emulation, handle it and vmentry immediately 
without checking various kvm stuff when possible. 

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5540.5ns -> 4602ns       17%

kvm-unit-test/vmexit.flat:

w/o avanced timer:
tscdeadline_immed: 2885    -> 2431.25  15.7%
tscdeadline:       5668.75 -> 5188.5    8.4%

w/ adaptive advance timer default -1:
tscdeadline_immed: 2965.25 -> 2520     15.0%
tscdeadline:       4663.75 -> 4537      2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>

v2 -> v3:
 * skip interrupt notify and use vmx_sync_pir_to_irr before each cont_run
 * add from_timer_fn argument to apic_timer_expired
 * remove all kinds of duplicate codes

v1 -> v2:
 * move more stuff from vmx.c to lapic.c
 * remove redundant checking
 * check more conditions to bail out CONT_RUN
 * not break AMD
 * not handle LVTT sepecial
 * cleanup codes

Wanpeng Li (5):
  KVM: VMX: Introduce generic fastpath handler
  KVM: X86: Introduce need_cancel_enter_guest helper
  KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
  KVM: X86: TSCDEADLINE MSR emulation fastpath
  KVM: VMX: Handle preemption timer fastpath

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 18 +++++++++-----
 arch/x86/kvm/vmx/vmx.c          | 52 ++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c              | 40 ++++++++++++++++++++++++-------
 arch/x86/kvm/x86.h              |  1 +
 virt/kvm/kvm_main.c             |  1 +
 6 files changed, 91 insertions(+), 22 deletions(-)

-- 
2.7.4

