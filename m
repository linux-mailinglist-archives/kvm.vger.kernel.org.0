Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3234F2E6F90
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 11:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgL2KIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 05:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgL2KIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 05:08:43 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92A3C0613D6
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:08:02 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id l11so29766044lfg.0
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykn+or7byzvb1tXcbynmiwse3+d2HHncW3KrbdADuCk=;
        b=IG39YNphU6ylEtHCuLOrXWO3wVMBVmSUjCiBbPD1MMC2S5z9H/LowHVfwrBo4CM8yO
         CsfxACQOWkQ72n82LDBPMrkZfDHu01PB/PDKEZ8hRvqTctUz3LYDK93upoLpFSzVlAcR
         SOaMZTeC7hnacw8W66X/wLoszQ3WgeHBRrQdm183ko3ZYtPbFPJnEBU85TLCpyqJUaax
         xAIvzNBr7th9rm+fEFFIFicxsZWXOP4UTM2YU+laT1D8L/PDll51e+P688gBpPXLsNVr
         poLiY1cT+BMEDagqza7m1D2gM0e7zGuNW1OW6jkmguFD+d75LWxGNOi3X6QwNXkPt+Kn
         64Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ykn+or7byzvb1tXcbynmiwse3+d2HHncW3KrbdADuCk=;
        b=sSKDuk2gKjGpWUwHWk5ZxxSZCttRc4KAVX7eu2aRntveHW3otjPUyt2YS2KDWWc7Bu
         I55rzqQOeE1XIyuFuMDYBHUptAA9fLNE8Yh4+TKjidbk00Ed4uDX0eFDDYg0PcRsVhOn
         G4SyHnVQ6NojivVBc8ZiiWT2j81/BJuumGORWaWaIAs2rwtQswePWCNwCG3raH1r9gO4
         mY+h1a7Ri5WCyupfkXh+XlPGeabtKy6+2Nlnut8Ot7+wOcY4EoIUKwNB4cz5YhC2D2v4
         +eTAcJN+6O9c+qerF6Muolz1xfYc9HtNusv9i82NGcJ5Gd+/HPMPisYSD82UNhJXkY8V
         nGQg==
X-Gm-Message-State: AOAM533SJqWDbFeyT493I4LUAYb2G5nHYmBsTckQ3Jr1NYeRFSRVpIQW
        q+rOMlZO/dRGhMQf4zFzSqIll2Rt4LFK6Spb
X-Google-Smtp-Source: ABdhPJxbKVxnopvA7bSaVz2VWxj7jByJOWI02FaHFMo/fI7D/I7wzCg+GmoJJxrZWfoi8MoLp5gixA==
X-Received: by 2002:a19:b50:: with SMTP id 77mr22076149lfl.446.1609236480995;
        Tue, 29 Dec 2020 02:08:00 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id y13sm5612901lfg.189.2020.12.29.02.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 02:08:00 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC 0/2] Introduce MMIO/PIO dispatch file descriptors (ioregionfd)
Date:   Tue, 29 Dec 2020 13:02:42 +0300
Message-Id: <cover.1609231373.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset introduces a KVM dispatch mechanism which can be used 
for handling MMIO/PIO accesses over file descriptors without returning 
from ioctl(KVM_RUN). This allows device emulation to run in another task 
separate from the vCPU task.

This is achieved through KVM vm ioctl for registering MMIO/PIO regions and 
a wire protocol that KVM uses to communicate with a task handling an 
MMIO/PIO access.

ioregionfd relies on kmemcg in order to limit the amount of kernel memory 
that userspace can consume. Can NR_IOBUS_DEVS hardcoded limit be enforced 
only in case kmemcg is disabled?

Elena Afanasova (2):
  KVM: add initial support for KVM_SET_IOREGION
  KVM: add initial support for ioregionfd blocking read/write operations

 arch/x86/kvm/Kconfig     |   1 +
 arch/x86/kvm/Makefile    |   1 +
 arch/x86/kvm/x86.c       |   1 +
 include/linux/kvm_host.h |  17 ++
 include/uapi/linux/kvm.h |  23 +++
 virt/kvm/Kconfig         |   3 +
 virt/kvm/eventfd.c       |  25 +++
 virt/kvm/eventfd.h       |  14 ++
 virt/kvm/ioregion.c      | 390 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/ioregion.h      |  15 ++
 virt/kvm/kvm_main.c      |  20 +-
 11 files changed, 507 insertions(+), 3 deletions(-)
 create mode 100644 virt/kvm/eventfd.h
 create mode 100644 virt/kvm/ioregion.c
 create mode 100644 virt/kvm/ioregion.h

-- 
2.25.1

