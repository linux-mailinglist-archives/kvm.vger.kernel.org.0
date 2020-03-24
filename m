Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE7C190684
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 08:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbgCXHoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 03:44:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44424 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgCXHoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 03:44:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id m17so11169864wrw.11;
        Tue, 24 Mar 2020 00:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rJ32OMde5wl2b2XfKs0D4joCpnSicOJbQNVmnxhtfh4=;
        b=OCPebiNGa2S04hCAicVtBofst8I9IN1pNfnmpzbpKA9BUQWP78mpaohQrddVHr+GsH
         x31uXeYrq3AZwyDPSPYJLoGVmUkxHlHt2DOEEeIqLZob6JkfEXNt+as2T5hQsaDPCkmK
         O7XQglrTqf4Se8hQ9YKbeK9yq6eKfaKl5UcvH3d+GgrIXcrXvtjiQUmPn5SglvluF2bK
         wJddtqkVIkJ4i5YdjwV2rIObshLyOM7xaYWBkHv0HGM5yG5d2UriawPbar3TqICN/Gav
         KFONSZpf2mAP06/aAVj5iN3JHqABhL+k1hEVAZ9PTX+OaPobJctsj2mC5ouIK+HFD32H
         xjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJ32OMde5wl2b2XfKs0D4joCpnSicOJbQNVmnxhtfh4=;
        b=tFGzukamewqlvRthXrz4T/H/FUSicXUPv+DZ/m7aewqS+nmKnzCYhnwlH0AI/91Wzs
         BIWMi1EIgGqE7aZJEdm3jVHdeY+QxFDpB3fQ3/e7UwAvvBBvaCxChlzjvzfY2HwI8Id1
         TWfPv8YVhhmu/AZg55JAjR2iF+dAyH2FSq2PWqyJRGlvazL0vSN+A65Gty9XW8WlDZ81
         s0OFjQAD/tC4r22yByRP2EUPlOXRObm+Gd5Oug3BFzq0z7hQH3TudVJSBwgcxnvVDegO
         10j3IyfOGz9K4Nru1EtiJBRvNY2C5VahNYaSuTzVACm9ErZdDx/WtGnnE/ZTx8PWGwgS
         ZjLg==
X-Gm-Message-State: ANhLgQ0HF4+5zn08lBl2yIZk0Q4yter6dtLmPox/FK230ZBGOe9Rp33F
        k5KVRrgixl+EG3yvEgZllvRdJgumgnM=
X-Google-Smtp-Source: ADFU+vuucqhAIQhwJ1bVgpuUUP07DXb7YrmEnkNSHsqV1yDc2KcCBMrRA2ffgXg++IAcdGazGRpyUg==
X-Received: by 2002:a05:6000:10d1:: with SMTP id b17mr36182209wrx.360.1585035842657;
        Tue, 24 Mar 2020 00:44:02 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r15sm22066122wra.19.2020.03.24.00.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 00:44:02 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v10 5/7] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
Date:   Tue, 24 Mar 2020 09:43:39 +0200
Message-Id: <20200324074341.1770081-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324074341.1770081-1-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com>
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

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index befe5b3b9e20..59c6eadb7eca 100644
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

