Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C5443D8A
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbhKCHF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCHF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 03:05:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0766C061714;
        Wed,  3 Nov 2021 00:03:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gt5so643412pjb.1;
        Wed, 03 Nov 2021 00:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QGc0CAiOAozapI53hKAH/Jnun3Rk9U/5qkQg7Ukw/Oc=;
        b=qzNxbe4D6Ddl5KW1/7n3QfLdXFZq6CP0DBEKrBua4sblu9WvMAgiqVo9qPcbJPYG5W
         bWSdfih3Cz41UpZUgHjD/3eV9JnrRG8fMfH8kCZ9m7IxsZFooYt9uvjgrBTgQsEaxg9b
         DsMMYVszMaCxUFvdZwYxU9JLFGahQUoPHxP7Epo9GuvdEpnVtqiZ5IOCs6Vumvo+bv3R
         EELR31KSVS+JUCua5Xicwq2AyuOH7o1QGezmkamlA6BqLf7WeGtdUbbWUUAZ8JmwNp43
         YVYitGZb41s1azbojl8EO8ZjM15KVabldcrbP6Ea5iiqWgi4FxD4ZxrRZY526Cs6ywt1
         FLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QGc0CAiOAozapI53hKAH/Jnun3Rk9U/5qkQg7Ukw/Oc=;
        b=qTi1PNE0Nu/Dt/4VECj+xpn8Wsn/H2iJ3yqdR1WUKIP+//Mh4twhOFMkTOMjuvvpIL
         BDKGgQkoSbbAEw+SN70kZbdTZVdXHN8J+Q93xpSG058jUDzdTIfuUToaJBifMSCER2MD
         llUZ1yVG7hYgYqm0N2lLiWl8jUzOyIu/iuPTxIWm9dUqs3ktjEwzstYveGsBW2PseseZ
         0S9Xhev2syY4i9lJ7N25BF+jzrdsoLSCfd5Xl6Zx3tBVB096udVSw1UsTdsvP+fW0SdR
         4chP5D/ULmi/3wgE6dZVjZIeJ6b/VJHVuN6nAB9ctz2PCbYVkWqz0oGmp11PE8EeFYcS
         MDJA==
X-Gm-Message-State: AOAM532SSFKuqULeA9NmHxHXoSyhTGrjQJN++nRs0xkarfKjWHd9i67C
        ZoIBrbbc8UigHIv5WCkWzU4=
X-Google-Smtp-Source: ABdhPJxfPzVhfuq391Q83MnxJQ035ZENxbNGLiXJP+SMZM/sgW1LMXBc1R/YEBl1RXkKoBmVuoWkcg==
X-Received: by 2002:a17:90b:1c8f:: with SMTP id oo15mr12391932pjb.169.1635923001245;
        Wed, 03 Nov 2021 00:03:21 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x9sm4242564pjp.50.2021.11.03.00.03.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 00:03:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Use static_call for kvm_pmu_ops
Date:   Wed,  3 Nov 2021 15:03:07 +0800
Message-Id: <20211103070310.43380-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a successor to a previous patch set from Jason Baron. Let's convert
kvm_pmu_ops to use static_call. Shows good performance gains for
a typical perf use case [2] in the guest (results in patch 3/3).

[1] https://lore.kernel.org/lkml/cover.1610680941.git.jbaron@akamai.com/
[2] perf record -e branch-instructions -e branch-misses \
-e cache-misses -e cache-references -e cpu-cycles \
-e instructions ./workload

Thanks,

Like Xu (3):
  KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
  KVM: x86: Introduce definitions to support static calls for
    kvm_pmu_ops
  KVM: x86: Use static calls to reduce kvm_pmu_ops overhead

 arch/x86/include/asm/kvm-x86-pmu-ops.h | 32 ++++++++++++++++++
 arch/x86/kvm/pmu.c                     | 46 +++++++++++++++-----------
 arch/x86/kvm/pmu.h                     | 19 ++++++++++-
 arch/x86/kvm/vmx/nested.c              |  2 +-
 arch/x86/kvm/x86.c                     |  5 +++
 5 files changed, 83 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

-- 
2.33.0

