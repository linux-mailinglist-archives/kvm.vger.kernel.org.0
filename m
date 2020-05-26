Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABB71B24E7
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgDULUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgDULUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:20:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F2C061A0F;
        Tue, 21 Apr 2020 04:20:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so6615978pgc.10;
        Tue, 21 Apr 2020 04:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5INuHDo8RkxBQI1c6D+UV2G0d783U8nnilEvfGe2hU0=;
        b=CfWmPsExRg8TFieNHdsCul6CDg7KQXi/925bXG18wBDsPfbylGrKs3CqHnCJ9Qcf9/
         Rvff0UYzO3ndeb8H9FyA1PzZywww/9/xujQc3HvsMj+UexNj27db/Thn41aIlXas386Q
         VEvSDzx/pdf+vKkOZzNOX7+UHb/zQa73Z/a2STyvXatMTDBIO8hyAV0F92jqZnpIYaLl
         af9aPGoBqS/39UJZnFXjqHbQKN3+MDO89fry8qdV0PShnrH49zamFChLdvmymTATRJS/
         QqaiZT0G0Oel9hvi5BHGXJBKIjhSd5q5vKmUbVPKWFw+AQkB9Glx2Ra8TgiqJBWs1Ail
         gcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5INuHDo8RkxBQI1c6D+UV2G0d783U8nnilEvfGe2hU0=;
        b=AAAQDinV0laZSidiq/88VlZVEqC5ooV5w9jUJKDFOD/Km5rwfOj/Ogf7Vp9Tuw8BaK
         q4pc61x6YDdHH5wX1rBuy8Pz3wA095RtSq5d0ro4eFhvBcZixDFW1wuq5iFtFE8ada2i
         FRlAHiRt++DNsgfSJsWbs57n7bwMbIA2RDtMISOmF2D0SkXFNON5or6Qxb6g50/jVEle
         gJidKLk3Mh5h88rxs7fd4pxIUsOMkDc9CuSffW8Angj3dcG6QAxXqmd6DGNt1ymYrXwO
         hyju1R4Es8Vd4jyrzEdbYIx5w5ApCJjSDJVQI46hNEAGNV4RYs21+geiYqpiWX8pO21Q
         vhAg==
X-Gm-Message-State: AGi0Pua10nWuh8WiZQWoGSMRv5TrWUGlaqp9WR51pYxim2xJi3FmzTdL
        B1D1maTUVO16IxRISJHeZLQbvjtv
X-Google-Smtp-Source: APiQypI/2oekz+UfVOVdGkdIhyx1xtrd01Pv3bmvUrf59arfqv4RQYs+6JXxh8y6C4lQx7kAZiyJ1g==
X-Received: by 2002:a63:2e44:: with SMTP id u65mr1855828pgu.142.1587468036204;
        Tue, 21 Apr 2020 04:20:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f74sm8643176pje.3.2020.04.21.04.20.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 04:20:35 -0700 (PDT)
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
Subject: [PATCH 0/2] KVM: VMX: Tscdeadline timer emulation fastpath
Date:   Tue, 21 Apr 2020 19:20:24 +0800
Message-Id: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IPI and Timer cause the main vmexits in cloud environment observation, 
after single target IPI fastpath, let's optimize tscdeadline timer 
latency by introducing tscdeadline timer emulation fastpath , it will 
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
tscdeadline:       4663.75 -> 4626.5     1%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>

Wanpeng Li (2):
  KVM: X86: TSCDEADLINE MSR emulation fastpath
  KVM: VMX: Handle preemption timer fastpath

 arch/x86/include/asm/kvm_host.h |   3 ++
 arch/x86/kvm/lapic.c            |  20 ++------
 arch/x86/kvm/lapic.h            |  16 +++++++
 arch/x86/kvm/vmx/vmx.c          | 101 ++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  55 +++++++++++++++++++---
 5 files changed, 167 insertions(+), 28 deletions(-)

-- 
2.7.4

