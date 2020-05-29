Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50791E7F1A
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgE2NqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgE2NqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:46:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88E1C08C5C6;
        Fri, 29 May 2020 06:46:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r9so3351901wmh.2;
        Fri, 29 May 2020 06:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MuPhHrgZ0gxXOOVTE6NOopBZIol35VvCnUuGYFB1IB8=;
        b=Ny5DVi8DnNNCd0VKnVKKO7bieJo6XhEwtnx5t11kJrXVvs9zJw7IB6WRggWdCm6lAv
         oLVFQ+AG37U446G5jC70jk9dqjBM3wV3Q0pQHOIRZdsAEIsUUU6ZxaPregLw4BDE6DrE
         pYdzZAPkifGRSqL97L+ffAwbBUceebpT4y0H7UaEsc0m2AmdawBoLAn1jdprU8bVq1Pq
         FLD/lCiLxacXSYHThFXR/M7BTFsD3l+NoY5+ZnclXOFuc4/yF2pYYEOmBiFoebK+dBQC
         ubE9L8KCi4KmU6O/nCXHPzd5wgf40a3u9j/V1TJCk4yqbMysRpReSaFAMqjsV+c/716E
         yQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MuPhHrgZ0gxXOOVTE6NOopBZIol35VvCnUuGYFB1IB8=;
        b=hyTrQlm617B7QgHZlOSPI1eLZV2lKo/BJ2xZFjVityjLk3NZOZLJ9uWMuuyWg1nU7n
         pPqaz0UVmpqKBtnB2tWKxGjrJsHuukeyaD50JTubGNvUe2V37MvUzKLGPP8fKpPlVbFe
         ZmW7c66wUYavHMboIsL2c0TaXjjMChCsnMwc026cflkdCg0OpN/xMNcEHPPJPU6p+o3z
         U52/qR6hNZHbPpZiqVJpDg7iTMlKBIubiHCoEOFzirqZdGFO5tN0fAZ7T4PiZvwA5bpv
         CcjCyX7cObKHHwai794jLvJjvtl/nT5kKHgcDZS7abm7Aklkfi5gO1fP00dL4tn3Psmy
         YzWg==
X-Gm-Message-State: AOAM531Wa6fXfXp4XE4Ybqo5R6iWmgvZZFW2Yms7ldN4uuKtEsOgFl6C
        glT422G3JydBSBbsy1XuRaiyaFle
X-Google-Smtp-Source: ABdhPJx/8ZOnbjxyOvICQllXGuoGsrbsDLvG2n3pFtR/DIsEfVPMSxliR2VYMwEn98EMvJ/QaUpM6g==
X-Received: by 2002:a1c:66d5:: with SMTP id a204mr8472587wmc.134.1590759961503;
        Fri, 29 May 2020 06:46:01 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id y37sm12347263wrd.55.2020.05.29.06.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:46:01 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, rvkagan@yandex-team.ru,
        Jon Doron <arilou@gmail.com>
Subject: [PATCH v12 4/6] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Fri, 29 May 2020 16:45:41 +0300
Message-Id: <20200529134543.1127440-5-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200529134543.1127440-1-arilou@gmail.com>
References: <20200529134543.1127440-1-arilou@gmail.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index dc7dd48621ca..3730c38f4f71 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1657,7 +1657,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
 bool kvm_hv_hypercall_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
+	return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
 }
 
 static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
-- 
2.24.1

