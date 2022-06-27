Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF92F55CAB9
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiF0QEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiF0QEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65253B1CF
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=LYkNIEs5Mn24fJrau8L4ZctBwCdXRpyqBWYk8TuQ9zI=;
        b=H8coPp1XQVKZmnpwotZJiKG0e9OQXX2ZbOtc8SmRjNk5XMyFtBsbIUKJWvyy7IcLU00YRd
        PtJ4i2Ur5wUGnCND5qy5r975h4KUIdbkIbq7rdB+2b/KT3IpaWIitJXTkmrXW1NNxEH7S4
        Ji03qf8SopKK3+M3Oqv+0BdL+tZel3o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-4VZnuFsLOpWKkzjSQeBrlg-1; Mon, 27 Jun 2022 12:04:44 -0400
X-MC-Unique: 4VZnuFsLOpWKkzjSQeBrlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A46E680418F;
        Mon, 27 Jun 2022 16:04:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9006C15D40;
        Mon, 27 Jun 2022 16:04:41 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested VMX MSRs
Date:   Mon, 27 Jun 2022 18:04:26 +0200
Message-Id: <20220627160440.31857-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFC:
- "KVM: VMX: Extend VMX controls macro shenanigans" PATCH added and the
  infrastructure is later used in other patches [Sean] PATCHes 1-3 added
  to support the change.
- "KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup" PATCH
  added [Sean].
- Commit messages added.

vmcs_config is a sanitized version of host VMX MSRs where some controls are
filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are 
discovered, some inconsistencies in controls are detected,...) but
nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
in exposing undesired controls to L1. Switch to using vmcs_config instead.

Sean Christopherson (1):
  KVM: VMX: Clear controls obsoleted by EPT at runtime, not setup

Vitaly Kuznetsov (13):
  KVM: VMX: Check VM_ENTRY_IA32E_MODE in setup_vmcs_config()
  KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING in
    setup_vmcs_config()
  KVM: VMX: Tweak the special handling of SECONDARY_EXEC_ENCLS_EXITING
    in setup_vmcs_config()
  KVM: VMX: Extend VMX controls macro shenanigans
  KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
    setup_vmcs_config()
  KVM: VMX: Add missing VMEXIT controls to vmcs_config
  KVM: VMX: Add missing VMENTRY controls to vmcs_config
  KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
  KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
  KVM: VMX: Store required-1 VMX controls in vmcs_config
  KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
  KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
  KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
    nested MSR

 arch/x86/kvm/vmx/capabilities.h |  16 +--
 arch/x86/kvm/vmx/nested.c       |  37 +++---
 arch/x86/kvm/vmx/nested.h       |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 198 ++++++++++++++------------------
 arch/x86/kvm/vmx/vmx.h          | 118 +++++++++++++++++++
 5 files changed, 229 insertions(+), 142 deletions(-)

-- 
2.35.3

