Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8500F17C320
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCFQjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:39:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34619 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgCFQjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:39:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id x3so4636069wmj.1;
        Fri, 06 Mar 2020 08:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JVEI10ZL6I10AE61ccS1TYzMudtcJZiwR/qXS6afkVA=;
        b=oaHDz/SS6qkmeRrpg7/XUY0QO82/Gd5MswlaJf3qA9fKOEuVyy4jpJPkdGui7060pY
         gYAybPcamKs0k2AEAKWF2hr7JcAGFC3p7nDOQbcGFr3dz1ma5mUa2EBxPIDp5KzxgKTQ
         2I7lPnHPIhCzhEXJ9Vg7XKa1aTURnBzB6mITEk0bZ/l29jLzB1HJOBICnfJyweTbrBml
         XXnQ0XQN6NVigywgXPzHlO8HyG+2Cpx+u60Hek5o7WOEJpY9rI8bAE8C0dNw45a2GTqL
         9gQ9X46+cWwq+1uF48AqH+5AGQpDOqyDiwxxaUR0rV8tIH9Rt0IEDBcUA58zhWzzoC9K
         j2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JVEI10ZL6I10AE61ccS1TYzMudtcJZiwR/qXS6afkVA=;
        b=ZXvMpuy99R5yqW3UtrspQ/6kzvpzW2iDyuKNK/mVJG36vqOlPA+wCTVmvtuZzEz75e
         JHBoi0M+vhCe8a7u12/5kMnkqnh1jgdvqfJpieGPJCcmM62VkIdISwbP3CsddVfuvvlo
         iurAl7Sjrg51miEqJDZgn0Fqsqmpk08rw4KH5FQbB0j23nSVoQrWtkIqj3UZomaGitI/
         15te9v3qoJ4x89m3+ygJ3gURhvzu5wZskD710sEm+P2pC9IVhp7+wHctJ0DarNFDQ9EM
         SS2klzSqUXoGmWPOH5LGJG+OvmXEFz3wS6Ytk6XwBjPeLPvxZO3rSnv7W8byAj1CPuek
         VLUg==
X-Gm-Message-State: ANhLgQ3qVnXsE1qYg70NoADfOtXyrdI4FD/4Yqy4EEZ7SAURKQXbIZS0
        CSFR6Q7SkYC/bM8ngwgCkasqY/xF
X-Google-Smtp-Source: ADFU+vv8ex1Set5GXxBjmFYJDEVUP+pOuy7Rh7S3uxB75wOpQbvf/x5K1NbQrZQ6+4MaXjH4jArQPA==
X-Received: by 2002:a1c:3b8a:: with SMTP id i132mr4919560wma.32.1583512753390;
        Fri, 06 Mar 2020 08:39:13 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id n24sm8812760wra.61.2020.03.06.08.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 08:39:12 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v3 4/5] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Fri,  6 Mar 2020 18:39:08 +0200
Message-Id: <20200306163909.1020369-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306163909.1020369-1-arilou@gmail.com>
References: <20200306163909.1020369-1-arilou@gmail.com>
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
index 554e78f961bc..67628796f514 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1638,7 +1638,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
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

