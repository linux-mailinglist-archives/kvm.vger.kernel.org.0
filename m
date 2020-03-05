Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1AB17A70D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCEOBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:01:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36164 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgCEOBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:01:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id j16so7181806wrt.3;
        Thu, 05 Mar 2020 06:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CdRrk1lQ1WyvzaaT5BfrZN2ALBnMZwS8yyu5uJl/AA4=;
        b=Ox1T4ga0WB7Ku57bvtqm3KOlVlLSs3T3aHRhRwVuO4bkD50xpNKMmUemDWy/p0Velq
         xWfL3TicfkNJCATedCX/ABl+lplqb+kIb/Au8twcIpBkMX6/3tdI2Ad0roZf50qBppsp
         oM/bCOg+72O/3mIj7uhdq7HUe85jbr1bDuLqRJHWeF9IsQ2zuYO91POxkXtNxEgWV3iV
         oecG3QoMgh9/tmHk49Iwmp2uZ5WP3aoiU5u1fic1ebGyZlw8IcmurnVlotnMw8HXf7+s
         ia2facMUNUNJXcuWKGoUNwREzs1LbZcxaA9TsvArTYRawNV3t5v6LzxO+Fe63KtsXomO
         hnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CdRrk1lQ1WyvzaaT5BfrZN2ALBnMZwS8yyu5uJl/AA4=;
        b=YMoiFtPa1gBldOdcC3UNh7PQjODGMLh9TBsfT4Eal4r+PKArJuGmB6k9/2idqxxCDR
         AlaAR6TN21kd6dVhwzmeDZOduBujjlJZWfs4caYoghwAiLPrwDjBmoezWXhUnmszL+R7
         STuGQuWhBvzfBTcE3P9QY/0WerO0pPF+mgyKNDHsKyxH2lvDHSCGvHAZuMnJDPGeebdx
         9lqz1hsjzN6tOL3igTSECcJNo350EkWb1RBDla+WKRe0FAXTSQPXH1gdJ28H58ocxqTr
         VF4h1nemtd1sLxYrzwE5ZN4D8Dp0oUtLUI5h1U52l2MAOWNNqJmglXTS5A6KhZM9Yv8a
         M9Ew==
X-Gm-Message-State: ANhLgQ0sNXgTbDvgc1ysa4m1yFKhyKkQQp9h3l6py2En8mahSe2bGsjH
        4cmtKszfBOIu8B8qKzHupEuCiucX
X-Google-Smtp-Source: ADFU+vsuO+xInr/d+F65KwhyjhJxy42YP2wDfLuF+upnK9tRl9EGK/Bi+kEgEax0+k2+jGXa9EhDdg==
X-Received: by 2002:adf:fc81:: with SMTP id g1mr10887859wrr.410.1583416904077;
        Thu, 05 Mar 2020 06:01:44 -0800 (PST)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id c72sm3379824wme.35.2020.03.05.06.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 06:01:43 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v2 4/4] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Thu,  5 Mar 2020 16:01:42 +0200
Message-Id: <20200305140142.413220-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305140142.413220-1-arilou@gmail.com>
References: <20200305140142.413220-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is another mode for the synthetic debugger which uses hypercalls
to send/recv network data instead of the MSR interface.

This interface is much slower and less recommended since you might get
a lot of VMExits while KDVM polling for new packets to recv, rather
than simply checking the pending page to see if there is data avialble
and then request.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  5 +++++
 arch/x86/kvm/hyperv.c              | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 8efdf974c23f..4fa6bf3732a6 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -283,6 +283,8 @@
 #define HV_X64_MSR_SYNDBG_PENDING_BUFFER	0x400000F5
 #define HV_X64_MSR_SYNDBG_OPTIONS		0x400000FF
 
+#define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
+
 /* Hyper-V guest crash notification MSR's */
 #define HV_X64_MSR_CRASH_P0			0x40000100
 #define HV_X64_MSR_CRASH_P1			0x40000101
@@ -392,6 +394,9 @@ struct hv_tsc_emulation_status {
 #define HVCALL_SEND_IPI_EX			0x0015
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
+#define HVCALL_POST_DEBUG_DATA			0x0069
+#define HVCALL_RETRIEVE_DEBUG_DATA		0x006a
+#define HVCALL_RESET_DEBUG_SESSION		0x006b
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index d657a312004a..52517e11e643 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1800,6 +1800,23 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
 		break;
+	case HVCALL_POST_DEBUG_DATA:
+	case HVCALL_RETRIEVE_DEBUG_DATA:
+	case HVCALL_RESET_DEBUG_SESSION: {
+		struct kvm_hv_syndbg *syndbg = vcpu_to_hv_syndbg(vcpu);
+		if (!(syndbg->options & HV_X64_SYNDBG_OPTION_USE_HCALLS)) {
+			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
+			break;
+		}
+		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+		vcpu->run->hyperv.u.hcall.input = param;
+		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
+		vcpu->arch.complete_userspace_io =
+				kvm_hv_hypercall_complete_userspace;
+		return 0;
+	}
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
-- 
2.24.1

