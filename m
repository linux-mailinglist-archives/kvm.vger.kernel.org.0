Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1F018ACE7
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 07:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgCSGi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 02:38:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32828 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbgCSGiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 02:38:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so1288351wrd.0;
        Wed, 18 Mar 2020 23:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KdZXDTLpUb860qo4ODZxUAfz7dSVNa0vcGW2TPwxYq4=;
        b=Flcen8c1iD52oopUB8qrkBVjlmi+3qZMCeZUMPDtQzmKZdl7stmVknGn8B7xbN01CT
         pK6cz8e1GXbxQkgiGsKOCyj/4oCc1/qKPOpSF9lb94EHUqgJ9JL2GHMhJH9NTC13moCP
         9RJCs19UOPTfwzfvbl+KEtL1kUe+CM5L9X4lcJxXW5sAbbHvS93LqOk7+PTZnXUSAJkI
         wzxku/0gMmmcK8GDc4TXUNi5QPlBIvIwBaqqbXxHNIpRFbMkzLSkxsu1zKIqB5vEe6a0
         P954kZuWjnxQMWPR+Cpvtmque+qmv2CiiO1TW97/GaGMp8TX0ah3tuLjr2xOg9vGJ2bn
         Rk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KdZXDTLpUb860qo4ODZxUAfz7dSVNa0vcGW2TPwxYq4=;
        b=e3IMZ1jvfGlURCdNIVe8qhv7qCYVmhKWGnDxe+2Lij7kmg/k2rQzCxBUwYPdKkGx4Q
         DaKAJ6ScZxW7cO37PuvZwK1pcfhsjYRZHikLNCadBFyXf81Gg9HMML0YNdfG3QNu6DPQ
         ixCalRj7StFFPMnMDyepJoLPEldV0bRtgPCvvvBTjl3cIV4fcJ8G+y1k8aNNMQe0OLZc
         9A1xExeBzuMWO6JBZvhg7yWXaxuIZFPtoAK98FXFKcVpbJ80XT0/t9aRnnUD36jagAw0
         p9lgYJxHr622PX6w27VstuWGJYAYVYMENX43ybJlYrOltaqdeFFp22tNSTBjEUQp7SDL
         fVOA==
X-Gm-Message-State: ANhLgQ2quu70yxYjeKR//1T9Lrwhai04CxqMfrq5M6daWX0TdHGIDaM4
        B17z4P6Lyhy+uzI33PksilfxY7nf8kA=
X-Google-Smtp-Source: ADFU+vvKLD6o1TAETeqHAaNvacElOHPPIUMJ0M8qITYOPY+jPxQPRfVxCvHSVygr4RgGjqg5hbN97w==
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr2215078wrs.39.1584599933394;
        Wed, 18 Mar 2020 23:38:53 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id l13sm1945665wrm.57.2020.03.18.23.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 23:38:53 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v8 4/5] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
Date:   Thu, 19 Mar 2020 08:38:35 +0200
Message-Id: <20200319063836.678562-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319063836.678562-1-arilou@gmail.com>
References: <20200319063836.678562-1-arilou@gmail.com>
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
index b2b50c67badd..64f267f10049 100644
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

