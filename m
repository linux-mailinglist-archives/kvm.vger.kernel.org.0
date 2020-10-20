Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6528DE44
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 12:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgJNKHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 06:07:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgJNKHR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Oct 2020 06:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602670035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D5KqYEUpfycrQPhzEmIDML2TPVxdekkeeWQmKWvWXAo=;
        b=OOeAam359ErtXF3/0bSrVsJmcGvBWcbKijqJqAyBFsfFx8rXW/fBbCQdF1I18aBoLJu9NM
        94r9wCzE/uU0+c5WOL6vQl3l9kw/xGo1g0vxa6XFyiFPo+KiXf8jd/L5kzV88/ceNT6cPd
        Pj6rWoVe34d8APTU1B30L0sj0FBfSbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-wwy8auPNM-WqgPCwHeU1sQ-1; Wed, 14 Oct 2020 06:07:12 -0400
X-MC-Unique: wwy8auPNM-WqgPCwHeU1sQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 033068BAF69;
        Wed, 14 Oct 2020 10:07:05 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA9EF7B7A9;
        Wed, 14 Oct 2020 10:06:59 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: eVMCS: make evmcs_sanitize_exec_ctrls() work again
Date:   Wed, 14 Oct 2020 12:06:58 +0200
Message-Id: <20201014100658.2346024-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was noticed that evmcs_sanitize_exec_ctrls() is not being executed
nowadays despite the code checking 'enable_evmcs' static key looking
correct. Turns out, static key magic doesn't work in '__init' section
(and it is unclear when things changed) but setup_vmcs_config() is called
only once per CPU so we don't really need it to. Switch to checking
'enlightened_vmcs' instead, it is supposed to be in sync with
'enable_evmcs'.

Opportunistically make evmcs_sanitize_exec_ctrls '__init' and drop unneeded
extra newline from it.

Reported-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 3 +--
 arch/x86/kvm/vmx/evmcs.h | 2 +-
 arch/x86/kvm/vmx/vmx.c   | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index e5325bd0f304..f3199bb02f22 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -297,14 +297,13 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] = {
 };
 const unsigned int nr_evmcs_1_fields = ARRAY_SIZE(vmcs_field_to_evmcs_1);
 
-void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
+__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
 {
 	vmcs_conf->pin_based_exec_ctrl &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 	vmcs_conf->cpu_based_2nd_exec_ctrl &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
 
 	vmcs_conf->vmexit_ctrl &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
 	vmcs_conf->vmentry_ctrl &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-
 }
 #endif
 
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index e5f7a7ebf27d..3333326b3702 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -185,7 +185,7 @@ static inline void evmcs_load(u64 phys_addr)
 	vp_ap->enlighten_vmentry = 1;
 }
 
-void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
+__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
 static inline void evmcs_write64(unsigned long field, u64 value) {}
 static inline void evmcs_write32(unsigned long field, u32 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96979c09ebd1..d529349d9b33 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2607,7 +2607,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
 
-	if (static_branch_unlikely(&enable_evmcs))
+	if (enlightened_vmcs)
 		evmcs_sanitize_exec_ctrls(vmcs_conf);
 
 	return 0;
-- 
2.25.4

