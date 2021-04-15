Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA98E360AD8
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhDONoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41546 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhDONoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:21 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id BBEA220B8003;
        Thu, 15 Apr 2021 06:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BBEA220B8003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494237;
        bh=N+TtNg651kLEqW/yUqiR219gdHV+Nj5LUEDricdH7Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6WilJfEIGRytrTncEyk/VXm+BXMAPw8LWpegMFjQOZqH8kDsb/TfoiBPzGbLPF9A
         0+H9UvdDxxfpS2fsxHEkWkE7+nwCV3VBN+MxsDwKsM+HOeqSUiCJwAkYDBlcS0PnyG
         zbrCHpm79Y/hLmsurXiPp93Nm3B1BFaVBpJuzjjo=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 2/7] hyperv: SVM enlightened TLB flush support flag
Date:   Thu, 15 Apr 2021 13:43:37 +0000
Message-Id: <3fd0cdfb9a4164a3fb90351db4dc10f52a7c4819.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
support for enlightened TLB flush. With this enlightenment enabled,
ASID invalidations flushes only gva->hpa entries. To flush TLB entries
derived from NPT, hypercalls should be used
(HvFlushGuestPhysicalAddressSpace or HvFlushGuestPhysicalAddressList)

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 606f5cc579b2..005bf14d0449 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -133,6 +133,15 @@
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
+/*
+ * This is specific to AMD and specifies that enlightened TLB flush is
+ * supported. If guest opts in to this feature, ASID invalidations only
+ * flushes gva -> hpa mapping entries. To flush the TLB entries derived
+ * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace
+ * or HvFlushGuestPhysicalAddressList).
+ */
+#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
+
 /* HYPERV_CPUID_ISOLATION_CONFIG.EAX bits. */
 #define HV_PARAVISOR_PRESENT				BIT(0)
 
-- 
2.25.1

