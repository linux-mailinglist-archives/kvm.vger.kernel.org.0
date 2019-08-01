Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AAD7D4CD
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 07:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfHAFOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 01:14:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32882 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfHAFOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 01:14:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so2730726wme.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 22:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lQl7edwn+BBaD98menQlIuR4CRzjnAz72gInVhmciPI=;
        b=WpHh9vbR+xCuQ75qR7t2c3/XK10HN1gT8/cGKg3JuUgpxoLxNgDThHYiszDkFnafa3
         fORzuZ/TABDc84Oojriq+nQiOGJdFR/4LlVFXgrkWddk2xQOTwhgdD3oB64hNvLvxlMR
         1RUprqLi9WauMLLCgVLc+ocAyE/xoS+QAZCUyNcHaZQFmnVUue6wPkONwu7wxy79Pvrh
         ySWLbEbnFmzriJnrijDkqtAns7dtgjAwvtQLV2aB2SpikVuh5hyrWU6/JN1WynddEpca
         UOAZAT5aHoTW0r220DtbN+l3iM8nHzw4zbPzsM6zyjENAJAXbFtnZeNcM4cx13YMItoW
         Hb2g==
X-Gm-Message-State: APjAAAVxeIw9Lw+s73Fo31RQnWpWn7/mDuQENwaNCPldVlEGYPHWBThk
        cXRtwQRijDmv4K9XbW0iRzaO7imCzR4=
X-Google-Smtp-Source: APXvYqxFEk5MxsMb9SRS0F9z/AOdjaxGzOmYxgzH33mkkzGt4IVLGLkSCjTMz3xWeerxX8qNq8kB9g==
X-Received: by 2002:a7b:cb51:: with SMTP id v17mr111847194wmj.20.1564636461354;
        Wed, 31 Jul 2019 22:14:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id a2sm73855351wmj.9.2019.07.31.22.14.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 22:14:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 0/5] x86: KVM: svm: get rid of hardcoded instructions lengths
Date:   Thu,  1 Aug 2019 07:14:13 +0200
Message-Id: <20190801051418.15905-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFC (It's been awhile and I apologize for that):
- Dropped ' + 3' from vmrun_interception() as well.
- Added xsetbv's implementation to the emulator [Paolo Bonzini]
- Added Jim's R-b tags to PATCHes 2 and 3. 
- Tested with the newly added 'nrips' svm module parameter.

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
  x86: KVM: svm: clear interrupt shadow on all paths in
    skip_emulated_instruction()
  x86: KVM: add xsetbv to the emulator
  x86: KVM: svm: remove hardcoded instruction length from intercepts

 arch/x86/include/asm/kvm_emulate.h |  3 ++-
 arch/x86/kvm/emulate.c             | 23 ++++++++++++++++++++++-
 arch/x86/kvm/svm.c                 | 23 ++++++++---------------
 arch/x86/kvm/x86.c                 |  6 ++++++
 4 files changed, 38 insertions(+), 17 deletions(-)

-- 
2.20.1

