Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB48E8BAE0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfHMNxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:53:43 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36156 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfHMNxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so14107205wrt.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8nxRyojZFKf0TQR/T2zEpBjZo8BJRb7OzrEnoVoxiU=;
        b=JuA9ktWEHWzo1/n5l3kAgwIwhcqb7IhBx1jr88d0EoAEP8fEYVfmSV21LG9EH3lHit
         lrwkTTJd7pozg/cZydJovdCAm2fsCPrF5WTlAxldHhxhFr41ViActHjpBt+VESDXK0pB
         6hODIRrsNgjuWs7rMOEHLuP0228e2Rx3tMfDb/N6idLARnDKVBam8rKy48qW2xUK6byQ
         ggQXpVWeA2yBbtGqLMYDbg6lBmOperCsh+Y2cZx0xSTq7jxSCYr/2d/1sXr5r9f/OJPA
         dq1UGXzC0xB8JEA6Poo8P4yYFL3QUJZ1hLdiLt8/NU8nptaePv2kvZzkNPsNNVJm62wJ
         NSZA==
X-Gm-Message-State: APjAAAVxuZqQxyXIKFAixag5srOrDPkbOuFkSqvMvbTu2eSJ3bJI5tKb
        PHYxN4FVDl1KBUy8KPwO6OyJEjvbyTQ=
X-Google-Smtp-Source: APXvYqzp84hbXn1M1ywSERBfRP5HDwuBPewb7ToXruh0JK8BxA57owqY36izXFnklFowj0MWMOVCCw==
X-Received: by 2002:adf:f088:: with SMTP id n8mr46768276wro.58.1565704419849;
        Tue, 13 Aug 2019 06:53:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 0/7] x86: KVM: svm: get rid of hardcoded instructions lengths
Date:   Tue, 13 Aug 2019 15:53:28 +0200
Message-Id: <20190813135335.25197-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v3 [Sean Christopherson]:
- add Reviewed-by tag to PATCH5
- __skip_emulated_instruction()/skip_emulated_instruction() split,
  'unlikely(r != EMULATE_DONE)' in PATCH2
- Make nested_svm_vmrun() return an int in PATCH6 (moved from PATCH7)
- Avoid weird-looking 'if (rc) return ret' in PATCH7

Original description:

Jim rightfully complains that hardcoding instuctions lengths is not always
correct: additional (redundant) prefixes can be used. Luckily, the ugliness
is mostly harmless: modern AMD CPUs support NRIP_SAVE feature but I'd like
to clean things up and sacrifice speed in favor of correctness.

Vitaly Kuznetsov (7):
  x86: KVM: svm: don't pretend to advance RIP in case
    wrmsr_interception() results in #GP
  x86: kvm: svm: propagate errors from skip_emulated_instruction()
  x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
  x86: KVM: add xsetbv to the emulator
  x86: KVM: svm: remove hardcoded instruction length from intercepts
  x86: KVM: svm: eliminate weird goto from vmrun_interception()
  x86: KVM: svm: eliminate hardcoded RIP advancement from
    vmrun_interception()

 arch/x86/include/asm/kvm_emulate.h |   3 +-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/emulate.c             |  23 ++++++-
 arch/x86/kvm/svm.c                 | 100 +++++++++++++----------------
 arch/x86/kvm/vmx/vmx.c             |  16 ++++-
 arch/x86/kvm/x86.c                 |  13 +++-
 6 files changed, 92 insertions(+), 65 deletions(-)

-- 
2.20.1

