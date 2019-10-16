Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F65D91FE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 15:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405311AbfJPNHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 09:07:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41163 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405306AbfJPNHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 09:07:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so14692453pfh.8
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 06:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wQCJmNzmQsC9KNIjHMU1j2cgYJLfCM+agj01R4DYfjE=;
        b=Oe2or1AEnGi2tuxYEI+dDM6EqbS93wmPnH5+gXDxmvkVXF7KJnYVqfREtqDuHPwtlL
         KrhCNoGau/eOsWVoyWIgQSEtiJgmoJlgYtoltCXwYia7/dCmM7rbKoCes9HsTPyJrpE4
         UOp/N0DqDyEmHKreDXM6Z+B27pUGnsIt744FeHQwu9mDIVqnQoX6t0y0nKRdmLE6ZSj4
         wTSd9iRtTAYZOf0EEwxu/1ZzJozZUzpOFdPy4FPogV1acswssVFeQQq3Piiy0lx0J1zP
         2HnANWPP62uVD0rRtGdzecsjICguXgfIPYag+D0RLBOHv19e1AEuTKSVYd1zwkNja7D4
         q+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wQCJmNzmQsC9KNIjHMU1j2cgYJLfCM+agj01R4DYfjE=;
        b=VctCe98zBAyHY1OWfmap7m5BkYelXZBr0YChMycuY0lJMA2Bg1dCgTOjuDjPV4kDx0
         giJjeWBjDSBlcjcKlNcFcz5nD14R2CX1zkqdGhS0PNgyrdycty5RY2NuzdKInJxebmFi
         Kdn1EhZY60AIz4B2YnnExzq0On1AyTRdbDM+7rkYokY8e9muE+DkeVQFCr+rbOt+l7QJ
         uHHBl8+QQzIsAmH9iMZzh4jL1FE5e64eXrDEDOw3QnT1XRCX+HBX/u0MDGmdaO/7Wval
         hOh3ru/6SD7ai9ThpFuoHOC4XN3dwqj/hjbccTlYAJAJdKNo+M/IsgfIupuqHxxZz1jA
         Yc7A==
X-Gm-Message-State: APjAAAWrGEl+sFdPVbWiayO9KJqwji+WBjCJJcaHhbwahCCYtUxr0v/z
        1rX9w0wixMeguEGYIUnArRmtmbhEQ2U=
X-Google-Smtp-Source: APXvYqz86v6HgU7P7jaCkPhMGAi8X8SUCsEErtJmXv76sPMHpWi5QQGtmQNnOcoKXrKc30+cx6p6Aw==
X-Received: by 2002:aa7:96ba:: with SMTP id g26mr44752072pfk.45.1571231253825;
        Wed, 16 Oct 2019 06:07:33 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.39])
        by smtp.googlemail.com with ESMTPSA id s97sm2792296pjc.4.2019.10.16.06.07.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Oct 2019 06:07:33 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     mst@redhat.com, cohuck@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, mtosatti@redhat.com,
        rkagan@virtuozzo.com, vkuznets@redhat.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: [PATCH V3 0/2] target/i386/kvm: Add Hyper-V direct tlb flush support
Date:   Wed, 16 Oct 2019 21:07:23 +0800
Message-Id: <20191016130725.5045-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

This patchset is to enable Hyper-V direct tlbflush
feature. The feature is to let L0 hypervisor to handle
tlb flush hypercall for L1 hypervisor.

Tianyu Lan (2):
  linux headers: update against Linux 5.4-rc2
  target/i386/kvm: Add Hyper-V direct tlb flush support

 docs/hyperv.txt                              | 10 ++++
 include/standard-headers/asm-x86/bootparam.h |  2 +
 include/standard-headers/asm-x86/kvm_para.h  |  1 +
 include/standard-headers/linux/ethtool.h     | 24 ++++++++++
 include/standard-headers/linux/pci_regs.h    | 19 +++++++-
 include/standard-headers/linux/virtio_ids.h  |  2 +
 include/standard-headers/linux/virtio_pmem.h |  6 +--
 linux-headers/asm-arm/kvm.h                  | 16 ++++++-
 linux-headers/asm-arm/unistd-common.h        |  2 +
 linux-headers/asm-arm64/kvm.h                | 21 +++++++-
 linux-headers/asm-generic/mman-common.h      | 18 ++++---
 linux-headers/asm-generic/mman.h             | 10 ++--
 linux-headers/asm-generic/unistd.h           | 10 +++-
 linux-headers/asm-mips/mman.h                |  3 ++
 linux-headers/asm-mips/unistd_n32.h          |  2 +
 linux-headers/asm-mips/unistd_n64.h          |  2 +
 linux-headers/asm-mips/unistd_o32.h          |  2 +
 linux-headers/asm-powerpc/mman.h             |  6 +--
 linux-headers/asm-powerpc/unistd_32.h        |  2 +
 linux-headers/asm-powerpc/unistd_64.h        |  2 +
 linux-headers/asm-s390/kvm.h                 |  6 +++
 linux-headers/asm-s390/unistd_32.h           |  2 +
 linux-headers/asm-s390/unistd_64.h           |  2 +
 linux-headers/asm-x86/kvm.h                  | 28 ++++++++---
 linux-headers/asm-x86/unistd.h               |  2 +-
 linux-headers/asm-x86/unistd_32.h            |  2 +
 linux-headers/asm-x86/unistd_64.h            |  2 +
 linux-headers/asm-x86/unistd_x32.h           |  2 +
 linux-headers/linux/kvm.h                    | 12 ++++-
 linux-headers/linux/psp-sev.h                |  5 +-
 linux-headers/linux/vfio.h                   | 71 ++++++++++++++++++++--------
 target/i386/cpu.c                            |  2 +
 target/i386/cpu.h                            |  1 +
 target/i386/kvm.c                            | 24 ++++++++++
 34 files changed, 262 insertions(+), 59 deletions(-)

-- 
2.14.5

