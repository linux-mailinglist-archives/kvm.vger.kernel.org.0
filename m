Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F2FF3F85
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 06:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfKHFOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 00:14:45 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43641 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfKHFOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 00:14:45 -0500
Received: by mail-pg1-f202.google.com with SMTP id k7so3835099pgq.10
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 21:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PeNBNJQQEkZ4j/LYia2Xdkpd0UJijO32X6NLRJqeS/4=;
        b=NcPYn+50DVjAJuHAM5iGL7Ps1ovokhagbHf7v3yiOJX6+FyXBJVP5CeaJkIzfDsgDA
         D0nWyEAWItI6zKQCRsHpLtlUs9mK+p4kYeK/ge95xxA7WMfo4PXRJBDOVA/dkYdGHw+x
         2xET6jnbxRl/azMIMWDuvWXoRGK+DsVZ1oJ2XgC6hsiMravYHVzLPgr/nzo6zTKQnlwo
         7+Krte4e90Eb5EMP1jmXmH1eRMLi1t5aAvRcerm/AHNEcjpqLwvXQK8xQEkQDxb8dDQF
         hR91KEw77VzOV5erjVpW6zIQ5LgRKuOTdAODSLDvKN0HdeVKvpIUb7a58dV+9Iyfc2x/
         qP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PeNBNJQQEkZ4j/LYia2Xdkpd0UJijO32X6NLRJqeS/4=;
        b=foGCsODZLRAEUQ/OdWprznJuTXhct0FYIRE01iBJ4cbm+XAOP1cC8XxZk93AOJDD4/
         DoHYzHiO9hcXmyi9sF0FnpeWXq6rLIxE5yhoJGNGCK3zrvKJugcRqYCSXUIhNMsQFHYX
         PbQG6pf0hyNSBR+bx3cilNo4KXPNonBBWqpUSKJ5dsZSyVyXM0A/cMLz1feI/xIra0mE
         vcZ0nJFAgpgG/KWZXwb5SO1QJJemoAP4BZfnhxHezQisHFJTHabMxT0D4GizE7/K28FG
         70dcQQhjSiKEbwC++Mpf6cMrzbCBviPRnmz3M9uOAJLorEC0pdZB3qdeQUTjpdCnqOnn
         sq+w==
X-Gm-Message-State: APjAAAXmnuIf1Kc6m73RCjxnUCWTMO+1PVXWyucWpe636YPCT2qq/LR8
        UpGypS8NUyJTQMj54x0WRbO/eQ5wOOZf/zPFhHcrDMPXTbvz/Ruz72AbBhdQFuKt5oY0Ry+AHyO
        r4WWMcfMPTlv+QypvOk9Tr386oouV2qaq41/oFPtkSq2z50QZ76lmowmBz1mH0Com4kfS
X-Google-Smtp-Source: APXvYqwZJ1M5AciQl/CDMp99/qISf61yCzRDs+mLTg8zlpL1wpPvidrNZflgpTvqW2Drud36f9yYLbAEJyOFGHhP
X-Received: by 2002:a63:af13:: with SMTP id w19mr9120437pge.189.1573190084191;
 Thu, 07 Nov 2019 21:14:44 -0800 (PST)
Date:   Thu,  7 Nov 2019 21:14:35 -0800
Message-Id: <20191108051439.185635-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v4 0/4] Add support for capturing the highest observable L2 TSC
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

v3 -> v4:
 - Squash the final commit with the previous one used to prepare the MSR-store
   area.  There is no need for this split after all.

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

Aaron Lewis (4):
  kvm: nested: Introduce read_and_check_msr_entry()
  kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_LOADSTORE_MSRS
  kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
  KVM: nVMX: Add support for capturing highest observable L2 TSC

 arch/x86/kvm/vmx/nested.c | 136 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c    |  14 ++--
 arch/x86/kvm/vmx/vmx.h    |   9 ++-
 3 files changed, 131 insertions(+), 28 deletions(-)

-- 
2.24.0.432.g9d3f5f5b63-goog

