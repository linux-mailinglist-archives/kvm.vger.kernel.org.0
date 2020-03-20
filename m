Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F5118D5CC
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCTR24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:28:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34525 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgCTR24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 13:28:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id 26so3547810wmk.1;
        Fri, 20 Mar 2020 10:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a9SojIPug6UpPzj2b9LnXrL2533L8rpwytZQVw4njJI=;
        b=lE1TzInIw3k/fF8SbD0nsdcllbvXSkAXbaNnt17MZnR2P8LvcPvSdq95J9CpCkEsNE
         +Rybtx5m7eY3h3AtPxjUypwgqrfBHOW7hfD7qhNqE/p07HxUR7IRSepnH284G2WmLAtS
         dRs2N+CB3PGf8sLqXTnsam1zBzzFGOg9NYNkkg95bR6P9xB4Lk93e7UbSaSraboP/8zz
         DlyRZIwm/6b1OeJ0/9ZocCZw7rV3Juf2k/CamP9kK1KyLm/cKaaLlvELL7apYx44xn9w
         Mg/Q3f0IWBoYWn7wbrcHvIeUgt+mi4xEY6qA38zPPq4tlziYEpg2JUeS520OU58WZ2H0
         iuTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a9SojIPug6UpPzj2b9LnXrL2533L8rpwytZQVw4njJI=;
        b=UA92csRIWDJow2CcotUqKyk0/X0yU9pWMRqQhx9ZiQdDcrIcbeELU9XkmQvSBGO/fw
         43xTjdulALAY/LwawH/Ee0lUrYBhQEhA++0BFJDAw3oy3qdgbt26dv4RzYZfk/mBvWXE
         8OcW8FCMUrh3xWBi+bzX6HrxhpGQxEObxQYKH6/FL93qMI5ZfK2j7yIESbzq0kFnxmL7
         F63wIV35wysJFIV8gOM01OF/rp/hrvOOo0CeMloCKR6IfRFspkYMHa47bpQLXkXQa6Na
         EdsfRy4YpwJjCcE4drvTIm97T6nOg6oM2OMGLjj6fGPyQCMPS4L9YC+d2LGngHeFe/vn
         tTSQ==
X-Gm-Message-State: ANhLgQ2cxgunm0d+O9tiXbvwxn/Hr51zsUHuh0tZqLY7iGyHTShgnFRM
        XMhsOsNd8dave6LWwfs2mEh3DjY3DFc=
X-Google-Smtp-Source: ADFU+vs4PVGzF3oaq+vVqgl6GGTRjqXLPSvkECED/U3l9/2opKjxZ1PgF7R8LJIjQcrlJvvrmAer7g==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr7516392wmj.65.1584725333442;
        Fri, 20 Mar 2020 10:28:53 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id q4sm11028333wmj.1.2020.03.20.10.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 10:28:52 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v9 5/6] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
Date:   Fri, 20 Mar 2020 19:28:38 +0200
Message-Id: <20200320172839.1144395-6-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320172839.1144395-1-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com>
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
index cd8d0142a841..c130a386f4c1 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1647,7 +1647,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
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

