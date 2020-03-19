Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33CD18AC8E
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 06:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCSF7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 01:59:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38982 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgCSF7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 01:59:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id h6so1167086wrs.6;
        Wed, 18 Mar 2020 22:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lnqp5rPGccrlR5PSxxdbXEbVJk1qCq/tIZPYxPoQFaw=;
        b=QkixoLXVD0UcK6cHusQduB2Kr0e+6dj0L1jwQEMYOZOk/5YTs1y+GlcwgVk/BeHWuR
         jkOvl9dW/B5vJVECjDbH6w6vd+IcC6wOM54S3BiSAsuijov7RAtrEgseIaXHxJlR9SRm
         OfY4qCoo1BMtUU7it7+1WCROITD9ZCmI4qmSGdY6Pb08gSzH0IP95aS62u8zvDiOlGdl
         6dkI9yk3C14vrmBRrnW0d8zgMBvwkt0KOrnR3bZFAJsBDCt25OeeveIMP/yhhf3F4jHG
         VvFdfENTwPzioMGAL1+OnlxT9bxtmKsv7uucIzVImi+6879DOenyaIwFojyqr8v0oZ55
         rLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnqp5rPGccrlR5PSxxdbXEbVJk1qCq/tIZPYxPoQFaw=;
        b=NCbmF0+L0UFU73joATvxF5F4tp697p3/yiV20rVJIBYULLF+w3/U7Yyyg2FA11dx0U
         RauVOO71njDdi9KptoZXOj4u6k9KXdeWPNMRfPTznSQRH/dUTMe/ecar+yhK/XXRaNyz
         bDHp2uiB/T0OW7p23/wVui9JWztpbwZFvoBfj4hP1CX5F8TgSzViQHQ9Q3nXKFZ1Zfxv
         Rl0110gNwlcCMs49uR0aD9XrtFn+Z7wqh5a5BgSEyRhGMkkh8OhhSk5xb8EioG7eF1tp
         DFzu9JmQt0R0A1azfc5hwhVbWXvviZA2Z0/QttVzBNruHjkbwn+DKUipMJ38vzfGiZ7e
         loGw==
X-Gm-Message-State: ANhLgQ1kwBIGND/06DIedBbAQA6nvlxqlEpl5zofno5wrU1NgxdLpGHL
        Oet5Q2gnW5k6jI7DRrSxhosDipvFT54=
X-Google-Smtp-Source: ADFU+vt32F//3GDlUndDY8MtW6EXhKuqRpbE9vQr2PjpEmuvsGQ5qEDhgQxefmkCM9LOE+xEVJEIVg==
X-Received: by 2002:adf:f2c9:: with SMTP id d9mr2004786wrp.12.1584597540966;
        Wed, 18 Mar 2020 22:59:00 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id n2sm1884174wro.25.2020.03.18.22.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:59:00 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v7 4/5] x86/kvm/hyper-v: enable hypercalls without hypercall page with syndbg
Date:   Thu, 19 Mar 2020 07:58:41 +0200
Message-Id: <20200319055842.673513-5-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319055842.673513-1-arilou@gmail.com>
References: <20200319055842.673513-1-arilou@gmail.com>
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
index 4c482ef1eaa9..67f9893150c3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1645,7 +1645,10 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
 
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

