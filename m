Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E402C17A70C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCEOBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:01:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36259 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgCEOBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:01:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id g83so5866990wme.1;
        Thu, 05 Mar 2020 06:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3xc3TVk3FCy5dUXtdGuNGtN/lcYKGORx6FfduZtUGvw=;
        b=iRpmKZxSa/1jo057hSvdHb+8Dcvp/tQxXQuRgNpubN/aM6wt3ZFTLkULH62cYP4GKV
         ZqCKlrAbr/gXtF6Qg1WmUEqIGVjt7bg9wNODkFubm4pgo1ZqIrWKjF8sQTAEsAJwSuXx
         f4uOXMZce7Le9ic76yoCmGkx5L1/0IKa5pC73l4RBUZoq9W+fKNNvqtAGtizocRXNNXE
         RiWyGcQjS/7WouMRKgcJFquyEn3t0i5i1GwsL0uVI/KLfXmDdQi/odwUP4p4Z81xVb8m
         ajW7Zoi0ig33YpxyJ4aohOfQpvokMq65B6bdlCqs2F7wmqCeHPb4gf+73OHzmiaiLPaq
         n1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3xc3TVk3FCy5dUXtdGuNGtN/lcYKGORx6FfduZtUGvw=;
        b=cuSokpVhOA4jrztG/G3riuKfwy7H4AfLGyG9mpA1lCE1DwAo/xjHx65hZq3P20pI6e
         rfUVPJ/Uu3fp/jHvrp6yidBqMMc9+utexVNXeHdBazZqw0YAE0fN+qV+3Gn9KRWD/fL+
         5r/H9wGdBmo39jw+gNeN4TZQiVoqXErAaIJOe7CTXYw3wyKYU3nt5TCiQl6txhfYxrKX
         gO2EvnQwDDiiQXaAquCmyLS7fDspTvU72dk8f2fiQHTdx3rpdCWjUjs4IiHHuJZWun7R
         mrVayVO3Vc5deBtXO/Wc2AB5Yz39n6W1fSax5dPrqxFVDvbuKI52xh1x1xGgCGlJ7FbR
         lUQA==
X-Gm-Message-State: ANhLgQ140hga+Dwn+ZLgFOKSx++VI1BscrtoAUNM8Uaz+TyS8V58WjdR
        RmGQWtmFvPsHQa+GVbCpZZ82vvM0
X-Google-Smtp-Source: ADFU+vt/cPcpkiYZh8jbDxxL7QeRmW1xhyv6ro1sR5cXdj+ZPW+IkT4JSLqVYUPxpxGod6DXOOQlFQ==
X-Received: by 2002:a1c:6745:: with SMTP id b66mr4157733wmc.30.1583416902395;
        Thu, 05 Mar 2020 06:01:42 -0800 (PST)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id c72sm3379824wme.35.2020.03.05.06.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 06:01:41 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v2 3/4] x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
Date:   Thu,  5 Mar 2020 16:01:41 +0200
Message-Id: <20200305140142.413220-4-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305140142.413220-1-arilou@gmail.com>
References: <20200305140142.413220-1-arilou@gmail.com>
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
index 7cbc4afe9d07..d657a312004a 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1618,7 +1618,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
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

