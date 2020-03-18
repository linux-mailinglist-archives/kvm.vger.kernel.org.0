Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59918949D
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 04:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCRDvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 23:51:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:57668 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgCRDvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 23:51:11 -0400
IronPort-SDR: JiYt3whZZc5rWcXYQjE9lZ0QWtm+Lx4F1ybZGVxtr7O+lvkYsIwK7Mr5yLmjyIXlkER81tSf3q
 a4C7MRwCGRLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 20:51:11 -0700
IronPort-SDR: 9bUF4H9QQNe3a8MQitbBFyw8f9tSiDyCfhjvRRegxTcaEa61P4rY7aAkTgy9i/WeNGTaHtWTYI
 3rVfHzAzi7vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,566,1574150400"; 
   d="scan'208";a="268215257"
Received: from icx-2s.bj.intel.com ([10.240.192.138])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2020 20:51:09 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Date:   Wed, 18 Mar 2020 11:48:18 +0800
Message-Id: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the logical processor is operating with Intel PT enabled (
IA32_RTIT_CTL.TraceEn = 1) at the time of VM entry, the “load
IA32_RTIT_CTL” VM-entry control must be 0(SDM 26.2.1.1).

The first disabled the host Intel PT(Clear TraceEn) will make all the
buffered packets are flushed out of the processor and it may cause
an Intel PT PMI. The host Intel PT will be re-enabled in the host Intel
PT PMI handler.

handle_pmi_common()
    -> intel_pt_interrupt()
            -> pt_config_start()

This patch will disable the Intel PT twice to make sure the Intel PT
is disabled before VM-Entry.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26f8f31..d936a91 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1095,6 +1095,8 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
 
 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
+	u64 rtit_ctl;
+
 	if (pt_mode == PT_MODE_SYSTEM)
 		return;
 
@@ -1103,8 +1105,14 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	 * Save host state before VM entry.
 	 */
 	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
-	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
+	if (vmx->pt_desc.host.ctl & RTIT_CTL_TRACEEN) {
 		wrmsrl(MSR_IA32_RTIT_CTL, 0);
+		rdmsrl(MSR_IA32_RTIT_CTL, rtit_ctl);
+		if (rtit_ctl)
+			wrmsrl(MSR_IA32_RTIT_CTL, 0);
+	}
+
+	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
 		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.addr_range);
 		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.addr_range);
 	}
-- 
1.8.3.1

