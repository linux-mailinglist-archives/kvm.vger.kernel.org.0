Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F07C03E4
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 13:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfI0LPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 07:15:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54672 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0LPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 07:15:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so6150225wmp.4;
        Fri, 27 Sep 2019 04:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=KM5/fL2Yt0ZifkcygAo4LHNxxbfupXEym28ra8qTLbk=;
        b=J1It2fckNyXTHriDkvoPhArrNWQ61s/q+CcHPM86GDjlu3yV/E30GGKi06M5gZcTUJ
         5Weme2PW+RFADwyGaVDgf+o1HyXScwzisYSrqzqlkaG92KV4s/IfPfHxGQeCqwNy9YZr
         fyK0Qv+U1PlZ8A75KLv13rIFgMF62pDHMPhi4CaARRsuFBzziali0yDpdC0cD80EAxhi
         ETza7tpuWouCNJTynMhq1UM4FTcr8eaSlqrfSD88BuahkZRYrrFI5LS3yVaxCexemLCs
         4YnocKfMigCdOm7ulq4Kpi603M4DV4jlZRx2Uuhp6CHmEuuycQiXFCOcnYhdtElwxAYV
         5ieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=KM5/fL2Yt0ZifkcygAo4LHNxxbfupXEym28ra8qTLbk=;
        b=LGwDq0/FiHw0dbQFGJBXydnOfVrUj+ByHpiMRfwQb+1A/MkFnKaprOrgJK2B9hoTP8
         Fj+j6Bz3ay+Wv3AZ39K7Zdv0qFfgq53emo/zwwkV3ts5CtkGBgwzHtw/k9jnB2Wqn7j6
         O5bM0jIWDgFSvJDXy0JgSLboSvLX4ClNUV5MOsPUzI45vwgGBiCE2yNlqORvsQAO/w3V
         OaNPRtB+J6htOezYhJgxNimUju61Oggsqga9GqWIIjg3UGn1CHlKDTr2EQpuYS1NJNQw
         RLFgGwEk7SlJYKWHfiTapOsSiKHHOQ7NBQAI0HvmZOFOYJzlGxwaLYfUYPETtoF6qPzJ
         An+g==
X-Gm-Message-State: APjAAAUiyPOVt96gblXV1r5feMqlI27AvBF/TvQy0GLAtqFjIN9AdQuF
        XH4aed+kZnQSPBdpFRk/yfaLnBsu
X-Google-Smtp-Source: APXvYqze5BcvyPMMQhinLxNxJJjbNrKHXTnEhYvRSJiYH2P41iv6PpSAah/uL9xk67roqKzZRCpsuw==
X-Received: by 2002:a05:600c:290c:: with SMTP id i12mr7014897wmd.77.1569582946521;
        Fri, 27 Sep 2019 04:15:46 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r28sm2913848wrr.94.2019.09.27.04.15.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 04:15:45 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 0/3] KVM: MMU: fix nested guest live migration with PML
Date:   Fri, 27 Sep 2019 13:15:40 +0200
Message-Id: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
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

v1->v2: don't place the new code in spte_clear_dirty [Junaid]

Paolo Bonzini (3):
  KVM: x86: assign two bits to track SPTE kinds
  KVM: x86: fix nested guest live migration with PML
  selftests: kvm: add test for dirty logging inside nested guests

 arch/x86/include/asm/kvm_host.h                    |   7 -
 arch/x86/kvm/mmu.c                                 |  65 +++++--
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/include/x86_64/processor.h       |   3 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  14 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   3 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 201 ++++++++++++++++++++-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 156 ++++++++++++++++
 9 files changed, 426 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c

-- 
1.8.3.1

