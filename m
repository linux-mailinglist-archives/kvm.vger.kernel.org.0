Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C561F9C06
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKLVVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:21:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39793 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLVVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so4507908wmi.4;
        Tue, 12 Nov 2019 13:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=dEhpPGqL2EnHvM+RMKgKzToY3FC78Q0MvKFrMXo/rVg=;
        b=WNXrjKl+NzL/krxGUzhS16CUd+Jmzist2kq/sBXSoMZtW6q7/qk0LYsrJUjp6RaDSF
         wU2j3rZDNhCBT5Hxma+ntzFVX9U/ojQsXSlFObe8jY2aANnAT7V30CUKIi9EC3x8StDO
         Jx6TtutddTKB6mI81DjwmmdqECeKojN7giKo6++9/yUISdjlezNNnzxgviegpvJiCpec
         WCrrFtrxJyoDbERz9Zmrl7kmOml5h30B+D+PDeXzbw2qa75qfKj0QwLMLduL8K4P129O
         x5h+XEQTiV4+US7m+IE6OwiDruA9TGuxPIsVrJf8wqP3licqss6d3+EaR/W99bssTB+L
         ggig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=dEhpPGqL2EnHvM+RMKgKzToY3FC78Q0MvKFrMXo/rVg=;
        b=p+C/kwHDv4lTvlfbT7fhAuZJ2ZtwvclkLHugsuxAbp640Z6sxqO3DncFKxHXWobuab
         1kQxSLhnLZqJV9mcMXBjVXrFkHf/PJ5MU1G9eOgpzc4riHEH6UalEcaAHETRhGhFjEJq
         noycLOJbTRGeLMKkIFmVX2lJZ1WMnSQmRZwzjDJ4iaBzHpJtgORgRsdF9zu/4pDuxbQH
         WiecM0k77ZF68tHBcxKh/cMEy84zRC38+bhp7gMExM5Gcj/rxdNEzntD99BjgPiPYEdJ
         uR8lesy1BVITJde09HfHgi0je2yBA36hxFNVuAYpcY906w1SFCB+665ysoJFhFqcQQ+h
         P+Dg==
X-Gm-Message-State: APjAAAUEmaiP9CHWDBVO4OkFcKHGkfmMu2N39uEMX/LXF+4alm1o4Cdg
        DZdVfJrUcgO5wwZHtq/7TOQwmoNt
X-Google-Smtp-Source: APXvYqyfh0JsBntGXcUehgQXwZOjx5Mf9XThvqTdrcx0A/dP4zfs7gcKSkSjtoN8J+eidPue1VdIDQ==
X-Received: by 2002:a7b:cf35:: with SMTP id m21mr4156466wmg.141.1573593699205;
        Tue, 12 Nov 2019 13:21:39 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:38 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
Date:   Tue, 12 Nov 2019 22:21:30 +0100
Message-Id: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CVE-2018-12207 is a microarchitectural implementation issue
that could allow an unprivileged local attacker to cause system wide
denial-of-service condition.

Privileged software may change the page size (ex. 4KB, 2MB, 1GB) in the
paging structures, without following such paging structure changes with
invalidation of the TLB entries corresponding to the changed pages. In
this case, the attacker could invoke instruction fetch, which will result
in the processor hitting multiple TLB entries, reporting a machine check
error exception, and ultimately hanging the system.

The attached patches mitigate the vulnerability by making huge pages
non-executable. The processor will not be able to execute an instruction
residing in a large page (ie. 2MB, 1GB, etc.) without causing a trap into
the host kernel/hypervisor; KVM will then break the large page into 4KB
pages and gives executable permission to 4KB pages.

Thanks to everyone that was involved in the development of these patches,
especially Junaid Shahid, who provided the first version of the code,
and Thomas Gleixner.

Paolo

Gomez Iglesias, Antonio (1):
  Documentation: Add ITLB_MULTIHIT documentation

Junaid Shahid (2):
  kvm: Add helper function for creating VM worker threads
  kvm: x86: mmu: Recovery of shattered NX large pages

Paolo Bonzini (1):
  kvm: mmu: ITLB_MULTIHIT mitigation

Pawan Gupta (1):
  x86/cpu: Add Tremont to the cpu vulnerability whitelist

Tyler Hicks (1):
  cpu/speculation: Uninline and export CPU mitigations helpers

Vineela Tummalapalli (1):
  x86/bugs: Add ITLB_MULTIHIT bug infrastructure

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 Documentation/admin-guide/hw-vuln/multihit.rst     | 163 +++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |  25 ++
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   6 +
 arch/x86/include/asm/msr-index.h                   |   7 +
 arch/x86/kernel/cpu/bugs.c                         |  24 ++
 arch/x86/kernel/cpu/common.c                       |  67 ++---
 arch/x86/kvm/mmu.c                                 | 270 ++++++++++++++++++++-
 arch/x86/kvm/mmu.h                                 |   4 +
 arch/x86/kvm/paging_tmpl.h                         |  29 ++-
 arch/x86/kvm/x86.c                                 |  20 ++
 drivers/base/cpu.c                                 |   8 +
 include/linux/cpu.h                                |  27 +--
 include/linux/kvm_host.h                           |   6 +
 kernel/cpu.c                                       |  27 ++-
 virt/kvm/kvm_main.c                                | 112 +++++++++
 18 files changed, 732 insertions(+), 66 deletions(-)
 create mode 100644 Documentation/admin-guide/hw-vuln/multihit.rst

-- 
1.8.3.1

