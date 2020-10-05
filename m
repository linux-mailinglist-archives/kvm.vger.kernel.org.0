Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E11283B46
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgJEPkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgJEP3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFECC0613B1;
        Mon,  5 Oct 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fMb2jRZcwl6ZMvzoHQut4iOi+P6VzDgyIwZGzGlY6Xo=; b=jGBK+e7j5L+l5Xt1xkW003nw4w
        3XfroHAZv7KJqHkPMT4F8qtpsfgMbXqc58WmCt11q+95DDI/cFkwZtItBgdqmzWdjXL+94VkGpkvP
        7L2LzKTrSEQppLeMT+zwBH0ky9ZTbZUQ8V3PbkJj2atrSjWlqDfBAqpkQk+0d5avSYbA4xSxWqz3K
        EVwXW6Hj+5sdAORxUlBOB6XWRaO0nUAxVKBYrlO3XmIpnPmzdI1sydiVRRpbniE2LWYfuixOUEHfg
        tcZRW5smbBRp160xtOAhRmGC5gjZuGr+5qLdbafK6Ag1HexuyqnISiYZx4XkRRXODCZOe6PRbxkoV
        MGegVXuw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ5-0001mQ-1H; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045R9-Gz; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 13/13] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
Date:   Mon,  5 Oct 2020 16:28:56 +0100
Message-Id: <20201005152856.974112-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This allows the host to indicate that IOAPIC and MSI emulation supports
15-bit destination IDs, allowing up to 32Ki CPUs without remapping.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/cpuid.rst     | 4 ++++
 arch/x86/include/uapi/asm/kvm_para.h | 1 +
 arch/x86/kernel/kvm.c                | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..1726b5925d2b 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -92,6 +92,10 @@ KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
                                               async pf acknowledgment msr
                                               0x4b564d07.
 
+KVM_FEATURE_MSI_EXT_DEST_ID       15          guest checks this feature bit
+                                              before using extended destination
+                                              ID bits in MSI address bits 11-5.
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 812e9b4c1114..950afebfba88 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -32,6 +32,7 @@
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MSI_EXT_DEST_ID	15
 
 #define KVM_HINTS_REALTIME      0
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1b51b727b140..4986b4399aef 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -743,12 +743,18 @@ static void __init kvm_init_platform(void)
 	x86_platform.apic_post_init = kvm_apic_init;
 }
 
+static bool __init kvm_msi_ext_dest_id(void)
+{
+	return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
+}
+
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
 	.name			= "KVM",
 	.detect			= kvm_detect,
 	.type			= X86_HYPER_KVM,
 	.init.guest_late_init	= kvm_guest_init,
 	.init.x2apic_available	= kvm_para_available,
+	.init.msi_ext_dest_id	= kvm_msi_ext_dest_id,
 	.init.init_platform	= kvm_init_platform,
 };
 
-- 
2.26.2

