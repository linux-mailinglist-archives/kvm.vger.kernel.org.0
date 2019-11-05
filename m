Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44513F05CD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 20:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390851AbfKETTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 14:19:16 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:41126 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390846AbfKETTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 14:19:16 -0500
Received: by mail-qk1-f202.google.com with SMTP id c77so13535871qkb.8
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xfZE4ufavvJ0RzooombkODbK6fViaORENfN+oeuw9Y8=;
        b=Q83ssdA7PtucW8NOFV2LvEqAzAv7xHyjKpg28TyxhEvoAeRTc0S13eCVlam2e7zL3a
         f7HW4eufYRxFPVT66ZQCVhiKpx8bIa0B/BJtuxgtLyuy0WRJChmO5oiYXRCXp4LyucdU
         E6XZO7C8lF3iyA/wBRRoiZCao3RDtyLRsxb44u46rC/agZeLuA7U/+S52q4cikbMXDnu
         BsyMFRQb62Jtv/684iq9VC5/pNCXyhuXcVs5bEVkpzP1MyULSa/LdmWtR8SaeSu9Y95W
         hRKxK0Uj1iBraeXh/TO2gm5gCy175x71w1ZMyMVs0tBjhRAm/prXcDUqMs1t6I/esQrd
         uUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xfZE4ufavvJ0RzooombkODbK6fViaORENfN+oeuw9Y8=;
        b=JILHBpbC/1k+XjbXDwKJMT1WpQXlE4Qa0WAzyBu5yfuIlzP/N8AAjyo8oDYY9iX3U/
         0WF3qDf+/KoUMhsku/qlaSB7juOWPsQagkA6kQHcA8VJJNuB1Y4HRT5Qi5oUKRELMVN9
         w+3bkx/qBNF7v2KuWiAKvHR67y7dTAmY3yqnEm+cxUdSXx4V7NgdFlQugGxyY6hZLsH+
         Y6dIFDpq8SK4yrEE7LdzicFNrDiQJ+ZCMue7OkvPByDSChFl6t1UL051OOJ8FfCT3vwt
         M4G5f5Kvwy5HboDPL2R+BGhv7bESYgrpi8rCMbWSVN3fvHOAYjScBsRUzlWA5/133knT
         b1MA==
X-Gm-Message-State: APjAAAWKee7BA/YSNKr/UVC32fHPo/cj705Hp+wwuzfaKSmi3YCLbM1+
        ymyLRWaulkVsAJSpYKXFMmYXMz5DZ1ZHFHO7FeGKLXiSa3L1KgZ9pXD4BLCY9IppokoIR7dpJ1Z
        Xl7xzUWZnd3LzInLFXK6G7WVZ/PiH28RfGKuyFGw/W9//8A89RuyB4PhgQgxmMdS6V+Wq
X-Google-Smtp-Source: APXvYqxrWrFPYJzAJtXYVIj3X0cUbwWi5qEjLadWj/1xPJ1UEcmkCzu7nEWP5HLIlGBG/GtQA3HEu7Ej5gV9pco2
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr11824280qtk.171.1572981554829;
 Tue, 05 Nov 2019 11:19:14 -0800 (PST)
Date:   Tue,  5 Nov 2019 11:19:06 -0800
Message-Id: <20191105191910.56505-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v2 0/4] Add support for capturing the highest observable L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
TSC value that might have been observed by L2 prior to VM-exit. The
current implementation does not capture a very tight bound on this
value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
during the emulation of an L2->L1 VM-exit, special-case the
IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
VM-exit MSR-store area to derive the value to be stored in the vmcs12
VM-exit MSR-store area.

v1 -> v2:
 - Rename function nested_vmx_get_msr_value() to
   nested_vmx_get_vmexit_msr_value().
 - Remove unneeded tag 'Change-Id' from commit messages.

Aaron Lewis (4):
  kvm: nested: Introduce read_and_check_msr_entry()
  kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
  kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
  KVM: nVMX: Add support for capturing highest observable L2 TSC

 arch/x86/kvm/vmx/nested.c | 127 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c    |  14 ++---
 arch/x86/kvm/vmx/vmx.h    |   9 ++-
 3 files changed, 122 insertions(+), 28 deletions(-)

--
2.24.0.rc1.363.gb1bccd3e3d-goog

