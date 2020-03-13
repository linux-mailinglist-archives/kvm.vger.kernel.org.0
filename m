Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4765C1847ED
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 14:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCMNVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 09:21:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54659 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgCMNVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 09:21:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id n8so9913886wmc.4;
        Fri, 13 Mar 2020 06:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=nHHrjFu/gSgTZzln9IDu/2jTkl6TbrzF5JfCIquPwMuJBT6QHrc4uDrMvaZ2fSkKqg
         j8pRN4dL65lxdapwhVpP3d+f0udcfpI6EnoyJzwN8VxehRt9pqEYZx7As8s+uMNp5kJA
         62KK7HZx9khHnGaiLzmxA0M/Lb2jglqgG/8Tw10KreikNxsalmlqUMEs+mFXYo03RUg2
         iWfnKDhRUrccIMcrnqJNLDHsx4Agrx9yHCCVIGIpc4kjzzDZkeov+aHq8UCXsT8N6EOj
         vbUtkF9aPUVN4pLjb6zWfLlXBOl5wWLBYYakkQrQ+I+rmzMvcZn/uJow6YVTF3NmBplj
         xlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uHjQnX3gyUEuVprG/+YZpKO/PfRLqvF0oJQ7HCGTFS0=;
        b=RRzzDTNWU3HA+WelPWLyNXTUDo06Pku3QVUoMAYb7MUVMGKCU6+UjVb9myF52g93Ai
         nLI9pEHjm7kmzNLhIIccmelPrZ8V8ZBSKsw/aOEETZt8c1fDg9xvkR1HoqBJ8vkBVpUd
         wHMGEp0fQTCP7JyP/DRe1rFpTcSy3aLyyQm7pEZ+GiRMnk/Rvx7SGBQnKHv5x5YWZwem
         HcrE26Y//pKFUdxrjy0aN0jtTsvkvzvSdUU731y4MMAYy0Mj4UmnOkCU468wly/qhDyP
         pR0lgDTsWYFQt3+3esAJ9i1/cVlTYZvpLrB+jOAlhheCr8d64k2Xq+KvG7MmFwRcAT6d
         OBPA==
X-Gm-Message-State: ANhLgQ2f3W3DKsQq5kbhJWloD+3cVq+4CT1BxuclGiirOLT46s57Q3Q9
        sm4GYLPkAMa3jEzdgHdfNxPxE9D32Gc=
X-Google-Smtp-Source: ADFU+vtTUUKV13VCIB0Mm6z8pacvNK/CosrXvTwa/fUNouBBhbd0zW47umFRdON7C/P/oC6TLUDuAQ==
X-Received: by 2002:a05:600c:2188:: with SMTP id e8mr11531683wme.83.1584105660476;
        Fri, 13 Mar 2020 06:21:00 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id v8sm77112121wrw.2.2020.03.13.06.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:21:00 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v5 4/5] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Fri, 13 Mar 2020 15:20:33 +0200
Message-Id: <20200313132034.132315-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313132034.132315-1-arilou@gmail.com>
References: <20200313132034.132315-1-arilou@gmail.com>
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
is not 0.

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b6a97abe2bc9..917b10a637fc 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1639,7 +1639,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	struct kvm_hv *hv = &kvm->arch.hyperv;
+
+	return READ_ONCE(hv->hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE ||
+	       READ_ONCE(hv->hv_guest_os_id) != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

