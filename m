Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C31517769F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgCCNEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:04:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34168 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbgCCNEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 08:04:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id z15so4278302wrl.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8xR3t38FXzlVhdbvr87OuefY/3S2ns33WKM8IRdgPo=;
        b=vKKgzJDU9ZIuhu3qJ6JVGkJOYxb3yelu8Qz8cGUtxPIUDvL0vorqc2R/V+PGM84akK
         t8pFYm3Zn/ocnL00+B6IYuQm0NHDABLY3no6dVf4tMIxBbKzzkTxcN+o9UFtf5N2aasr
         Bw9G1p2kCmVDEUANqn/6ElBMo7BhosJBBRHfsIbQUe4w76tkmPUlwVrj5T5GWeg7mGY5
         a0kzNoTu5sBKiGVUKM2t61jXCEUaDbP/S5gXkCIAZI6WviXYB4uFq4sDMW/J4dHaxqcC
         x9DoOgsdHlCJIOOfdTDRsVl0QgucL8j/7YqyZkg80Iws7nqvjbIjcIP/5ySXXLarDLBS
         NTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8xR3t38FXzlVhdbvr87OuefY/3S2ns33WKM8IRdgPo=;
        b=B+7G2B9H6SSzYOvnX1hrlVEjSZJyunNj+B64ZhtsSpSvOYskAxXRguhWfrt6DUTPF2
         p1Ay86i0SPM9igv/3brTmFTMCkS63gan/us1gKHY2AgKKlCKBWp/FvqO62u2YRCqcPkm
         ebKAA7kKsWlBPfXlHeATl3lPYblXieWtdtIiUike8/ZbVLEd+/67nanoJnPT2A4spdzw
         RO5+/JypnR4lzFmPR0/TIQL2qOzhYp0Z4y1JSloHVcBfuILeNViZfosEqdHj2TZkFrFW
         5sSSxsaOyYcVemgpPPV6EgaLxAMyBdQ5hRG38GJyABs9xxnmWubqN58mRs9rKgBKGZfY
         NUpQ==
X-Gm-Message-State: ANhLgQ2oCYQXjaBH5GyDhEBs5UJSW4kSQQhRz1wd/nBvbkXShmvfC944
        NLtpCBOyOgflEZlhXxZOekhQF+2V
X-Google-Smtp-Source: ADFU+vsLRyFOSDd/yizaL7a5jAm78hnFQvxT35NziY1zavfOA4jIgy47QcrVLd0CzGN3a6zmDbkjwg==
X-Received: by 2002:a5d:66c6:: with SMTP id k6mr5502163wrw.343.1583240650788;
        Tue, 03 Mar 2020 05:04:10 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id w17sm2171951wrm.92.2020.03.03.05.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:04:10 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 2/3] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Tue,  3 Mar 2020 15:03:55 +0200
Message-Id: <20200303130356.50405-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303130356.50405-1-arilou@gmail.com>
References: <20200303130356.50405-1-arilou@gmail.com>
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

To resolve this issue simply enable hypercalls if the guest_os_id is
not 0.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 13176ec23496..7ec962d433af 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1615,7 +1615,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

