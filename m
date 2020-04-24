Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203C61B733F
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgDXLiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgDXLiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1440AC09B049;
        Fri, 24 Apr 2020 04:38:11 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so10412730wrx.4;
        Fri, 24 Apr 2020 04:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=185SwzLVVIfJjlMT/4T4W/sYUIKM9bGfdpVtPDHFNUM=;
        b=WU7T8i2cpxaKJ0kMdSrhB5lMKP1LVya8000lyNygTwbZe2FyR+mO1c57jwU2D7bndr
         pt3z2SEfs+gE9tenAwhIlrqz58+OG4djwOCufTJzXaQA89Mb7+4cER2dd1ong83/CnaL
         P4LjaMk5kf15wRf6bKa/mQ3n8IqxrlIBcX8Gp34Us9Qtlbkc/hWMr1t1L1CP4cE82Rga
         Dk1JRUKkH9f5VWrCBayfY3OI+NfbW3Vm9BTg7kvYTWMU6P54JJyic/RwIiuR4vU1LsGJ
         tZONzMcrKxoM5O44AeGsG3MMNV2UaTk2S4IsaeI57PlB7i7VXDTjPmmTQuo9J/xIn0Gn
         I0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=185SwzLVVIfJjlMT/4T4W/sYUIKM9bGfdpVtPDHFNUM=;
        b=eUYzftm4JqwAnpxEm+k36ZXuJmxe+5PRHbGJ/NAD2clEpVAPwwcDwaq2VWS+IYB7e0
         1+kTjRrSMJaz8VeC2HyamtWY3zbZBQJ+aa1X3x7KObX0UCwjfgtcnJorzBgrZVLXGiMZ
         N6aGJKWjJe3HdmAWeajyYNLQLQ7OpiAbriNDTjoQJtNy/0TeF9Wo+3wr/keYLoDbRQcq
         ZJtv4mDtJUZgdFFrFIMTbl4M5/BupEKUDg5a+3ITevX3DzIQ9JjI08Q8IjezFs7WPU8L
         cqGJyxQqkenZztZ3PwfDTwaAVGWHRGIYifUen4nl20BtMj5FZmnQ95utaxOaYLNEuMIZ
         NYLw==
X-Gm-Message-State: AGi0PuYEkikiuOxM2vpFT+t/eNi2GaMwnfI4OzEu9dbwXnyoVODjKLZL
        z4Hr1ylKpNxi3wir7mm3FJRisznfjHY=
X-Google-Smtp-Source: APiQypLDULS/6aew41IS8CCwS3NKorbTXXOXLyi3VS2TYK1qLaSm2Z416IZp/SMRsglQ+nLurZO/Rw==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr11493982wrq.25.1587728288865;
        Fri, 24 Apr 2020 04:38:08 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:08 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v11 5/7] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
Date:   Fri, 24 Apr 2020 14:37:44 +0300
Message-Id: <20200424113746.3473563-6-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
page and simply identifies the CPU being used (AMD/Intel) and according
to it simply makes hypercalls with the relevant instruction
(vmmcall/vmcall respectively).

The relevant function in kdvm is KdHvConnectHypervisor which first checks
if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
0x1000101010001 which means:
build_number = 0x0001
service_version = 0x01
minor_version = 0x01
major_version = 0x01
os_id = 0x00 (Undefined)
vendor_id = 1 (Microsoft)
os_type = 0 (A value of 0 indicates a proprietary, closed source OS)

and starts issuing the hypercall without setting the hypercall page.

To resolve this issue simply enable hypercalls also if the guest_os_id
is not 0 and the syndbg feature is enabled.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 435516595090..524b5466a515 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1650,7 +1650,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
+	       (hv->hv_syndbg.active && READ_ONCE(hv->hv_guest_os_id) != 0);
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

