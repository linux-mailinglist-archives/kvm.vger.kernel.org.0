Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC86555173
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358345AbiFVQon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353708AbiFVQok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:44:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C650D37A8F
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 09:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655916278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nXInkxXdvpzKoIOUQRdrxKmFesJ62JJWfaKiG5PimjI=;
        b=gf3AVFszlHZP0xbUee0yagUqbxJo3v41eNpihEgHiKW8G/rd7A8ZBEOWfNhRZlGirT4itf
        +bmJ1ZdnKPYxgi6dMaxuajyLCey9GS5binEdjzoYQaHqLTfedy+Ttb4CetBzWkHPpRcC93
        LrnF+7YQSPNOkPjEDpra5tCfbhE+TNI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-QYI5K5ENM2KDmJd9UP0YeQ-1; Wed, 22 Jun 2022 12:44:35 -0400
X-MC-Unique: QYI5K5ENM2KDmJd9UP0YeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8C61384F807;
        Wed, 22 Jun 2022 16:44:34 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F96140CFD0A;
        Wed, 22 Jun 2022 16:44:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 00/10] KVM: nVMX: Use vmcs_config for setting up nested VMX MSRs
Date:   Wed, 22 Jun 2022 18:44:22 +0200
Message-Id: <20220622164432.194640-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmcs_config is a sanitized version of host VMX MSRs where some controls are
filtered out (e.g. when Enlightened VMCS is enabled, some know bugs are 
discovered, some inconsistencies in controls are detected,...) but
nested_vmx_setup_ctls_msrs() uses raw host MSRs instead. This may end up
in exposing undesired controls to L1. Switch to using vmcs_config instead.

RFC part: vmcs_config's sanitization now is a mix of "what can't be enabled"
and "what KVM doesn't want" and we need to separate these as for nested VMX
MSRs only the first category makes sense. This gives vmcs_config a slightly
different meaning "controls which can be (theoretically) used". An alternative
approach would be to store sanitized host MSRs values separately, sanitize
them and and use in nested_vmx_setup_ctls_msrs() but currently I don't see
any benefits. Comments welcome!

Very lightly tested with KVM selftests / kvm-unit-tests.

Vitaly Kuznetsov (10):
  KVM: VMX: Move CPU_BASED_CR8_{LOAD,STORE}_EXITING filtering out of
    setup_vmcs_config()
  KVM: VMX: Add missing CPU based VM execution controls to vmcs_config
  KVM: VMX: Move CPU_BASED_{CR3_LOAD,CR3_STORE,INVLPG}_EXITING filtering
    out of setup_vmcs_config()
  KVM: VMX: Add missing VMEXIT controls to vmcs_config
  KVM: VMX: Add missing VMENTRY controls to vmcs_config
  KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
  KVM: VMX: Store required-1 VMX controls in vmcs_config
  KVM: nVMX: Use sanitized required-1 bits for VMX control MSRs
  KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
  KVM: nVMX: Use cached host MSR_IA32_VMX_MISC value for setting up
    nested MSR

 arch/x86/kvm/vmx/capabilities.h | 16 +++---
 arch/x86/kvm/vmx/nested.c       | 37 +++++---------
 arch/x86/kvm/vmx/nested.h       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 91 +++++++++++++++++++++++++--------
 4 files changed, 94 insertions(+), 52 deletions(-)

-- 
2.35.3

