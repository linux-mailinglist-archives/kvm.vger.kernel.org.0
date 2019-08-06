Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3920E82B5E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbfHFGBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:01:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55111 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731557AbfHFGBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:01:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so76835580wme.4
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tFg6eLE4tRBG84YrEoHYB/BIyFyiiiQYscHt8vqgCkw=;
        b=ey7yL8bszNCY7NqU/pSE1O4b7zpgPF+2x//zsq6JEu9iD87oG0ZyaEDtq2QRNWk0L6
         LhF9q3BPu6Du/hY8DtKP/vSBMknHbmq7enZEEbo0ReU0zQsArtGMqErEqFaXjQXzyWfN
         kVLd/x6PVjADjVAI27eoQsPFLxVodxYC3Kh0kxpuVlXjdFhiLlOBtRg/YrkQEZtOmSB5
         zeHyEbR6y9rJ5W+TL5+CSrbil5uhImpzXjcEJY46b1tUjcrITWk7BYTCFo8baGVscq17
         mVPuLkFemQjNiqA68pLKIWuL2lic2BXKRpnP5Odi06osKP2HazNvyW+x2IsObmFaQ2+v
         yEjQ==
X-Gm-Message-State: APjAAAWtNhLs1zjqKB1eS7gWzUyp+UvQsdA3iBAopU3TRtXjTmxWDqZC
        9gFc1omHGOIh/VZXYG6QG4XGqAXwfoA=
X-Google-Smtp-Source: APXvYqxlQw+IOcJ0mdkOCdR0mvOlyWq1HXZbiweIxKjahx35vXgtU7UvgaElJ9XuPUTtHWGt1w0IJA==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr2198674wmg.159.1565071313085;
        Mon, 05 Aug 2019 23:01:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id r5sm94216756wmh.35.2019.08.05.23.01.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:01:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 0/5] x86: KVM: svm: get rid of hardcoded instructions lengths
Date:   Tue,  6 Aug 2019 08:01:45 +0200
Message-Id: <20190806060150.32360-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since v1:
- Clear interrupt shadow in x86_emulate_instruction() instead of SVM's
  skip_emulated_instruction() to generalize the fix [Sean Christopherson]

Original description:

Jim rightfully complains that hardcoding instuctions lengths is not always
correct: additional (redundant) prefixes can be used. Luckily, the ugliness
is mostly harmless: modern AMD CPUs support NRIP_SAVE feature but I'd like
to clean things up and sacrifice speed in favor of correctness.

Vitaly Kuznetsov (5):
  x86: KVM: svm: don't pretend to advance RIP in case
    wrmsr_interception() results in #GP
  x86: KVM: svm: avoid flooding logs when skip_emulated_instruction()
    fails
  x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
  x86: KVM: add xsetbv to the emulator
  x86: KVM: svm: remove hardcoded instruction length from intercepts

 arch/x86/include/asm/kvm_emulate.h |  3 ++-
 arch/x86/kvm/emulate.c             | 23 ++++++++++++++++++++++-
 arch/x86/kvm/svm.c                 | 19 +++++--------------
 arch/x86/kvm/x86.c                 |  7 +++++++
 4 files changed, 36 insertions(+), 16 deletions(-)

-- 
2.20.1

