Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E741B579D
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgDWJB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWJB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:01:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E93C03C1AF;
        Thu, 23 Apr 2020 02:01:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a7so2244237pju.2;
        Thu, 23 Apr 2020 02:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lqQCA6uU2hlxAoFKS3Zl8BZd61e4Kf8xSgvVI/JGqC4=;
        b=Nt7Qw0nrmkNGLxtXMTEV5uYLLipfjl9h0i6pjbj/rQ5IrdUvVnE05yKMFte/E8X3gA
         v1ALEt/A9Q3qCfCyONPh2D2n7JlxUthelFPP/npXXozrmg46aM5BCpSXcZ14+D8PYNNR
         ohXxRhnTfXw0rOmY/i2f5QlSPSUFKmNG69HZS9PwS0uE5UeTFpk4VpcEEkHp6bbw/wgM
         32emtYxbXl6ZqkHeHp/U1nHsBtvbjrEd7nJVNWvC+AIB5ZRLew6yut1rqRwSsOqeDjx8
         t2Mdo33+eOkOxS+01/D29GVQhpBosV42glNCcF6dOb6+/Hl02IGJNxmKdT0d1lIFOX3i
         8JfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lqQCA6uU2hlxAoFKS3Zl8BZd61e4Kf8xSgvVI/JGqC4=;
        b=I142TcMwprwhQiG1lFuhbdY6bm9vB5KSwu8j3a+baf5sfANIP4GLBhkmcw+8y4IWws
         Mi2LC+1qf3Jsy0vfd67ht2mm391z14xUIDw+CvTt67hvIH0zOV1tNyFwbQ7MNw66h8Wf
         2BVoJv0rf2PT0wFEP7RgY95BSZHf9JJdy7sXHu6RGV8dTAIo1UUNNRg4Pv8GBn0amHs8
         Ls0LAkh7jBhGMgaiOyXpr8mA40e9YEJuMHEy2KDWn4WtBf8GkmpM1D8B5tKRk4bvlUsN
         eMfre/7AtzXX4E7kkXaqns3+n8F+OTgmCsWMudx9sCSArTKIE968rEvADfvVHzg4R8Tz
         pImA==
X-Gm-Message-State: AGi0PubjSdAmTbkbgneXDR/rPcZmtSFeTj8Rh8SD2A67HMiQMTLAdMCO
        STBymervjSQD0fnb6o96tMGBQApI
X-Google-Smtp-Source: APiQypLV0DFMc3aCMJ+cJGdiGtokrQ/ZJbvaGZyluabiyAKYwRb9+7mcocgS5ufUqx/Tv5wjJUYD5g==
X-Received: by 2002:a17:902:7886:: with SMTP id q6mr2823565pll.237.1587632517257;
        Thu, 23 Apr 2020 02:01:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id w28sm1574204pgc.26.2020.04.23.02.01.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:01:56 -0700 (PDT)
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
Subject: [PATCH v2 0/5] KVM: VMX: Tscdeadline timer emulation fastpath
Date:   Thu, 23 Apr 2020 17:01:42 +0800
Message-Id: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
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

5632.75ns -> 4559.25ns, 19%

kvm-unit-test/vmexit.flat:

w/o APICv, w/o advance timer:
tscdeadline_immed: 4780.75 -> 3851    19.4%
tscdeadline:       7474    -> 6528.5  12.7%

w/o APICv, w/ adaptive advance timer default -1:
tscdeadline_immed: 4845.75 -> 3930.5  18.9%
tscdeadline:       6048    -> 5871.75    3%

w/ APICv, w/o avanced timer:
tscdeadline_immed: 2919    -> 2467.75 15.5%
tscdeadline:       5661.75 -> 5188.25  8.4%

w/ APICv, w/ adaptive advance timer default -1:
tscdeadline_immed: 3018.5  -> 2561    15.2%
tscdeadline:       4663.75 -> 4537     2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>

v1 -> v2:
 * move more stuff from vmx.c to lapic.c
 * remove redundant checking
 * check more conditions to bail out CONT_RUN
 * not break AMD
 * not handle LVTT sepecial
 * cleanup codes

Wanpeng Li (5):
  KVM: LAPIC: Introduce interrupt delivery fastpath
  KVM: X86: Introduce need_cancel_enter_guest helper
  KVM: VMX: Introduce generic fastpath handler
  KVM: X86: TSCDEADLINE MSR emulation fastpath
  KVM: VMX: Handle preemption timer fastpath

 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/kvm/lapic.c            | 98 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h            |  2 +
 arch/x86/kvm/svm/avic.c         |  5 +++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/vmx/vmx.c          | 69 ++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c              | 42 ++++++++++++++----
 arch/x86/kvm/x86.h              |  1 +
 9 files changed, 199 insertions(+), 22 deletions(-)

-- 
2.7.4

