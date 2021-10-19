Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37B2433A7F
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhJSPek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhJSPef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:35 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F75C061749
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id v20so13908538plo.7
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ffl8pk9RGcstocogN9PvsC6AWGjD4hHoeEIJ6AobA5U=;
        b=XPxzycokZi44IAMRuO5xBojOvHyLirzpE4NVfUceUTJ8o/qB1XFnbvtrB6u4mAPYLQ
         FpZGKmV4hauxrAO8kCIToZDHGyDII/3L9e+rnxJyWr9EpnLbGsGrkK6tcBtg0syNwhFJ
         TqecIRrfv6FXE6rsed7Q4OgHt7czWMuVEqgC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ffl8pk9RGcstocogN9PvsC6AWGjD4hHoeEIJ6AobA5U=;
        b=pBZvuoqDBstOm55Mt6xp+gCgDq8h+pyxbMe5Z9hBtq3C1fbE/tMD7GABc1zoE3MX4p
         ybkviokVEcATAJ6Ha+0ALHosKuHmXKXKRPIBz0iGswTVRNnddq8wUxlZGMJNMW57Olbg
         nlBuBObcedzGOv0/HmNSsKXjF1nfs7cYCEC7OdrbByPRHdtqr5XkbPzyh/Dtegu5rZc5
         lPYeeJ4LsZ+lfrhD4RAFE89baXiy5NUqOHO3r2/6t2bQxTZQe+ibsmCQl0Cc/LjB9Dj4
         vutyZ/t60rtSVgD+MhEOycNKuSUxPkgSY7xItokhdqy5wYyaGKJ/Z+ds9qOAj4E0Zquo
         JWfg==
X-Gm-Message-State: AOAM533FfxpziJV7bJJlYeUhG4SKhsKShHJsNbZv5L4cDFytiqs2LifU
        F9nTk594479KxzfwuBtyxy5xLA==
X-Google-Smtp-Source: ABdhPJzk/QT0m2+16VoGKLZ8sjfJGeEE7JyXvQchG7LL+mVrhD6rB6eudQWAKg6OTwvQ4B0HqmDbJQ==
X-Received: by 2002:a17:902:b691:b029:12d:2b6:d116 with SMTP id c17-20020a170902b691b029012d02b6d116mr33496562pls.71.1634657542422;
        Tue, 19 Oct 2021 08:32:22 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:490f:f89:7449:e615])
        by smtp.gmail.com with ESMTPSA id v8sm3087474pjd.7.2021.10.19.08.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:32:21 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHV2 0/3] kvm: x86: make PTE_PREFETCH_NUM tunable
Date:   Wed, 20 Oct 2021 00:32:11 +0900
Message-Id: <20211019153214.109519-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds new IOCTL which make it possible to tune
PTE_PREFETCH_NUM value on per-VM basis.

v2:
- added ioctl (previously was sysfs param) [David]
- preallocate prefetch buffers [David]
- converted arch/x86/kvm/mmu/paging_tmpl.h [David]

Sergey Senozhatsky (3):
  KVM: x86: introduce kvm_mmu_pte_prefetch structure
  KVM: x86: use mmu_pte_prefetch for guest_walker
  KVM: x86: add KVM_SET_MMU_PREFETCH ioctl

 Documentation/virt/kvm/api.rst  | 21 ++++++++++++
 arch/x86/include/asm/kvm_host.h | 12 +++++++
 arch/x86/kvm/mmu.h              |  4 +++
 arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/paging_tmpl.h  | 39 +++++++++++++++-------
 arch/x86/kvm/x86.c              | 38 +++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  4 +++
 7 files changed, 158 insertions(+), 17 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

