Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66421776A0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgCCNER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:04:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52429 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgCCNER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 08:04:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so3089542wmc.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DYMp9/F3gn+zET3GbDn2nKP8tQKIh7/lLsqHxa4IBJ4=;
        b=J6Tvl9tfhaMTAhYcEoDCKi0LqsZvroN07Pyed39ZBq2oW0ETjKJKP12o9hhnrMqKk0
         YhUGyJ03o3RA/V5KOwmfdR0fcPYZNWrVGzDuhrFBLC9ZmFRaKYnLZ0vFvcKPbKm1xsNM
         oVMu9Zhu3pCikUeHpW+apx9pmq3hF1HtfboncapI05X5Cffu612dk8lT1oO3DxCW6WcB
         km/dyHWLB0v4Ig7VGmEeJJMAfIwKFIjX5wOpm6V0mfTGlvnHsz9SgMcst/0nNAGFHwgs
         SY5wxtthnBzh49qRcCtxjYsK4yKhwACM1P2ouoTSg7TUJADzygQdTCxGerrD/lFeRWJu
         qo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DYMp9/F3gn+zET3GbDn2nKP8tQKIh7/lLsqHxa4IBJ4=;
        b=njvaS0THDRN+Or8auWMBZc8KXdbunPOeBqYjCpH4UhtJRqhPD5HZodwDbBXYECyns+
         caBfi+EOscevld7RkyUfX06FxyH2N5WtMdf0OPTgjp9hLtLduMWP24um6W9+XPkouDVM
         8KcuDu2lVYxMTPI01VZQVQf9yGynh0B7vnu7P8kpwm+csWBHQjbCZOZVJ7WahCsYDHvG
         LE7xNQaF/jPQok8rnlIlgXPUU92ZKznHcbDn8hhbsCXpOz6zhgt2YnhwZIEB8iXBPOLW
         0W+LSUUcxV+8lbGhR1ct42HTdbL8008YDlINAwG40qjtGaN7Kw/ZVwHs9l9vjMMhpPmn
         hOeg==
X-Gm-Message-State: ANhLgQ3WGKNOT6XKP3LIGfKFp+dEht9x5lonNWQ2tmtInWe4nPawz5ZT
        zPLCA5NGZzbym+YlykWFWRybygFQ
X-Google-Smtp-Source: ADFU+vu5VtDyqihrB+seL+/Ba+arVB99PSW17S+kPNJMJFU4DT0QDz2RY+ayLIy9ZqnlJaRCaqWwJw==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr4052307wmi.37.1583240655463;
        Tue, 03 Mar 2020 05:04:15 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id w17sm2171951wrm.92.2020.03.03.05.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:04:15 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 3/3] x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls
Date:   Tue,  3 Mar 2020 15:03:56 +0200
Message-Id: <20200303130356.50405-4-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303130356.50405-1-arilou@gmail.com>
References: <20200303130356.50405-1-arilou@gmail.com>
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
 arch/x86/kvm/hyperv.c              | 11 +++++++++++
 2 files changed, 16 insertions(+)

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
index 7ec962d433af..593e0f3f4dba 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1794,6 +1794,17 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		}
 		ret = kvm_hv_send_ipi(vcpu, ingpa, outgpa, true, false);
 		break;
+	case HVCALL_POST_DEBUG_DATA:
+	case HVCALL_RETRIEVE_DEBUG_DATA:
+	case HVCALL_RESET_DEBUG_SESSION:
+		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
+		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
+		vcpu->run->hyperv.u.hcall.input = param;
+		vcpu->run->hyperv.u.hcall.params[0] = ingpa;
+		vcpu->run->hyperv.u.hcall.params[1] = outgpa;
+		vcpu->arch.complete_userspace_io =
+				kvm_hv_hypercall_complete_userspace;
+		return 0;
 	default:
 		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
 		break;
-- 
2.24.1

