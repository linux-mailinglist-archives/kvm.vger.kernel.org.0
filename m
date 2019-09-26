Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6403BF775
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfIZRSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 13:18:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36925 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZRSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 13:18:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id i1so3676001wro.4;
        Thu, 26 Sep 2019 10:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=G8ATWpvsPeQhyAU95P46GVmGRpo0pkchWBreGDYzCWE=;
        b=KqkKqLFnIu9dqQ5CM5kJFw3B/WnvfuWZO2qxHridDqPjzx5ATenOPpny39CvD294pE
         THmQ8q0FvnlmLc6fyCoZFF06RK+z9TUIvlDUlEVNzo+9wcFWmiB/m1axYi4otWr/WvW5
         lGhXov7yRw+RTBnT/lnOCmJVEEFrssn7TzLWiV/efE/G42MsHMStGbvQYkFb2hHSqkPM
         tm/MysLFkpLP1YfcNCyzSJFRZM77b01U0KFk63v0Z++nGCr0yfT4Wk05WQKaHuTWiCyu
         Jg3mqVVKb0pX0RlWsVaYTdmjcnFy7ee/wqA0A45X7ODJtHir/gCkdVvVA0q0Hag018OC
         /SPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=G8ATWpvsPeQhyAU95P46GVmGRpo0pkchWBreGDYzCWE=;
        b=F6npoADVEQlMgzAir25gh+XTQ2Kta5HTtYmD2UcA7lIfoy38HzH1pkkqbKOUcLJHMg
         NyTBONeIZ0s0VnCuMNPacuf9c6FMMe6yGe3ltHFESvs/wzW3jz88CJL813n6ZimPOqQe
         hCAawew3anDbqa9tXUiuGvXViLwRvZoTazPCNyrfBd79sk03TVaCv3xPRc6AOo8dmA6S
         hDIdW5FiXw6nyGA2niWwNLVYkunWWOhcDb8yUJkxK+BRfY575RtQcTKlYuIBc13PMWxj
         0qNu1qrmOK+ZDZAeHJw5cojBnIdnWGxn7PUI+6ja18iVUShNk8rcBuWIu6uyL2RTx+TZ
         IVkA==
X-Gm-Message-State: APjAAAXPItwEvKB0hOv9TkZlt0AA0Zk4gfR+I3lWiwBgFTU+AQ5vAAl2
        sC5FtJOFOT3grDZCCZPtIUVFr0Z1
X-Google-Smtp-Source: APXvYqzmD5sjDJT/FzC/PxkKE9HLYAtS9TV5ircrgPv0vUA1Kjo6epfRGl/PyrlV7UFo+q17PiktvQ==
X-Received: by 2002:a5d:6ace:: with SMTP id u14mr4147987wrw.385.1569518309013;
        Thu, 26 Sep 2019 10:18:29 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v4sm4792782wrg.56.2019.09.26.10.18.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:18:28 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 0/3] KVM: MMU: fix nested guest live migration with PML
Date:   Thu, 26 Sep 2019 19:18:23 +0200
Message-Id: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow paging is fundamentally incompatible with the page-modification
log, because the GPAs in the log come from the wrong memory map.
In particular, for the EPT page-modification log, the GPAs in the log come
from L2 rather than L1.  (If there was a non-EPT page-modification log,
we couldn't use it for shadow paging because it would log GVAs rather
than GPAs).

Therefore, we need to rely on write protection to record dirty pages.
This has the side effect of bypassing PML, since writes now result in an
EPT violation vmexit.

This turns out to be a surprisingly small patch---the testcase is what's
guilty of the scary diffstat.  But that is because the KVM MMU code is
absurdly clever, so a very close review is appreciated.

Paolo

Paolo Bonzini (3):
  KVM: x86: assign two bits to track SPTE kinds
  KVM: x86: fix nested guest live migration with PML
  selftests: kvm: add test for dirty logging inside nested guests

 arch/x86/include/asm/kvm_host.h                    |   7 -
 arch/x86/kvm/mmu.c                                 |  58 ++++--
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/include/x86_64/processor.h       |   3 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  14 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   3 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 201 ++++++++++++++++++++-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 156 ++++++++++++++++
 9 files changed, 424 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c

-- 
1.8.3.1

