Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79968680C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbfHHRa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:30:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51572 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404318AbfHHRa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:30:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so3188804wma.1
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZC0jDq9siC882owlOIi/dn8ZAzGWdWlZvUaAcIsKJJ0=;
        b=b0uhcCpHgRNLH2KJYpzxhDDEBwk2l7GQkuP8AWEBVhC0SSRon945L6Fnm/3sCGRPSt
         dC55UUWYNBFsTE1OIrLu99lOL2svUVuTZOaXu2fNyM/LEnN5JAFMHC9zwgzJOA0gNj+K
         r0J92Qr+E4VqMVpP6328mSPlf6NM0menrjs4b5MuDjhhf6JQJGdO6sAHzgBzRmLXYFTx
         Ul5yJuqxHasD5zvsMdeBMb+GyDhw5WGtLPcXt0UCId/pLaVmSSIJc+Bcz4eI7uoEfjXz
         7ufZgMSqwK3sDLGBvpBNvKPcHkbo925VYQxs6qh1crbaZebUuE7X+drnQyCcthAvcntF
         ymtg==
X-Gm-Message-State: APjAAAXpe3IAOPPTEIah4eRhy+eGjo1HAiXaps+QKNd4akQ7SNXD8V5a
        DaW13M6t7XtgaQcjKwmyw3RoMXgeIII=
X-Google-Smtp-Source: APXvYqwVAGL4jlttMY7DPiKgvoXEAX4Gtj+3vXIMWc6nv6zg9eT/yzjB7iWyxDufwMQFCfCn6We9TQ==
X-Received: by 2002:a1c:ca06:: with SMTP id a6mr5701266wmg.48.1565285454628;
        Thu, 08 Aug 2019 10:30:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.30.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:30:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 0/7] x86: KVM: svm: get rid of hardcoded instructions lengths
Date:   Thu,  8 Aug 2019 19:30:44 +0200
Message-Id: <20190808173051.6359-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v2 [Sean Christopherson]:
- Add Reviewed-by tags:
- PATCH2 replaced with the suggested "x86: kvm: svm: propagate errors from
  skip_emulated_instruction()" approach.
- PATCH5 split into three separating vmrun_interception() from others and
  implementing the suggested solution.

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

 arch/x86/include/asm/kvm_emulate.h |  3 +-
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/emulate.c             | 23 ++++++-
 arch/x86/kvm/svm.c                 | 98 +++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c             |  8 ++-
 arch/x86/kvm/x86.c                 | 13 +++-
 6 files changed, 83 insertions(+), 64 deletions(-)

-- 
2.20.1

