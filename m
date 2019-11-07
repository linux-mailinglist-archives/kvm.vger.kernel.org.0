Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF4BF3BB8
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfKGWtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:49:47 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:49481 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfKGWtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:49:47 -0500
Received: by mail-vk1-f202.google.com with SMTP id v71so1814916vkd.16
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vxOPgv/mPR6yTW95RMtFb/2LPtMh4Bc0wQxyROP1lhw=;
        b=KLMYpB5jG51x0jJ9vvJj23UOieG4GTB6YBN75FMHq5vWBjBXP6ZDoFhrdkNUkvmDGq
         zsesIQYcRu7OtqJPH8ViwRTi/3COTJujmnLba2KDnB4Gap2pY4/W7C4fgkd6kGHCZPHh
         T72Bh24kxczMzMQIMi9hu6xvNs6sOXyC9x/TXshIIc5fYM9zbcRZLyOnIp/kXrjFOjGM
         czoIA1dddmtSm+ClvzR/dF5VtMub6wNh5KJhdmV5p9cb8/a0DnG0e0eIUx++w3QJBl05
         XcrPg7TAj6Matx6Zis0Wmky4WDm4mr0mup6H7vggLBf3RR/jTXg4vBEIc2CKYByli5Ql
         2+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vxOPgv/mPR6yTW95RMtFb/2LPtMh4Bc0wQxyROP1lhw=;
        b=VtUu+XEC0qWp46iKDwxIG3OicVu0bbkmCUJvpdptHskMMeNUdoXwUCgXPFcrhrGyVW
         m1NIrwTj4/e4TIt1fcb8FX/Ckv8Xzn6UJB+O0E+1OBNQzuLIvsDTMFQY3eTJb9Qlach0
         RB2kad5btpOyW3KNqjdHuHg6zZ4lwCk4UdwEqEOtV+nCO85LkQPiH04XqoRgDgk2zEfE
         RjFm1H/1DYVNLUMWGbcCkdkvFkO20EINceu0ds4yDKJl9IdXQLfa0ieGrRsL4nEA+NfJ
         TVk434BCmRHeuMCfHORPym/DzyvdiXSw7zBn4LH0g8iscW2lOkmrNGBLlwhrUjfq4T46
         RqQQ==
X-Gm-Message-State: APjAAAXQ2v65nD5rHSooAZJiMkaZteRcMax2ANV7nhvD+xulkOySaWOJ
        gV0tOLRL6cFqB+xLjg7xfs/rEWZE6Q4SkxhwR+XOtR5LN0LOjjKuoS8eDa3i2cZTh7o8v8Tydd7
        WVvp1tOdkf2xIXttaUDshlha7s1tvMyE3X+WSmMLig5ZHQ25vI+bd5gKH6Z1823/ELGfN
X-Google-Smtp-Source: APXvYqxDqz/lc6d/2DSX03DPs9SwuXBgfiS8yVeQNLHrx65cXQvlOUZBcabVe65/YR5ZXfdUGIqkWGFe3agjgiTj
X-Received: by 2002:a05:6122:125:: with SMTP id a5mr4869378vko.79.1573166986093;
 Thu, 07 Nov 2019 14:49:46 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:36 -0800
Message-Id: <20191107224941.60336-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 0/5] Add support for capturing the highest observable L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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

v2 -> v3:
 - Rename NR_MSR_ENTRIES to NR_LOADSAVE_MSRS
 - Pull setup code for preparing the MSR-store area out of the final commit and
   put it in it's own commit (4/5).
 - Export vmx_find_msr_index() in the final commit instead of in commit 3/5 as
   it isn't until the final commit that we actually use it.

v1 -> v2:
 - Rename function nested_vmx_get_msr_value() to
   nested_vmx_get_vmexit_msr_value().
 - Remove unneeded tag 'Change-Id' from commit messages.

Aaron Lewis (5):
  kvm: nested: Introduce read_and_check_msr_entry()
  kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
  kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
  KVM: nVMX: Prepare MSR-store area
  KVM: nVMX: Add support for capturing highest observable L2 TSC

 arch/x86/kvm/vmx/nested.c | 136 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c    |  14 ++--
 arch/x86/kvm/vmx/vmx.h    |   9 ++-
 3 files changed, 131 insertions(+), 28 deletions(-)

-- 
2.24.0.432.g9d3f5f5b63-goog

