Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97345D24F
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfGBPEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 11:04:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36328 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfGBPEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 11:04:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id u8so1422442wmm.1;
        Tue, 02 Jul 2019 08:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qX4+tt0pDaQiw1/vCiXNQrZAln54Qf4UHvOvV7lW1a4=;
        b=GNx5m+StDBNK+z+0e4fWD4sLiRwhAKmGH7kkQS55kXOlhSH+sqqWVpivGYrIloeX6p
         rfbb0O38w/df7DVKwi0ySQLC1yHmxJOI57eSEPD4SrmvOMQFBT7z+S8oviZwzIVlqL3F
         crZ4ypGW7jfwLOmTXqXGj3P9CMuouyXrsiiD61wzs4nSdC7kg1HzwjZ+J4ObCfLZ7nT1
         D6F8TKBXJglkhf3n8FymISsDwrBFYXnxxSioeWXsNmm+kPkbthCPRab2sqMlP5wxqDUU
         9eSsD/NumGbgp2L+mCgyXmkZBVyBbysJui6NXHacrtYytSdyDzqHYUTX7MeVVDGqN2xI
         TkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=qX4+tt0pDaQiw1/vCiXNQrZAln54Qf4UHvOvV7lW1a4=;
        b=SMPwu9YndHyHM1W1JwKaXlEgXKMMGFEl89Wi8sdcqQf0WzLinnrSmzBoAjb0UiAgsP
         JGBuBb5eiFNGvnpVcakWBG0qgzd7qsprN4Q43MCCSexaXLg15TXXS1YgwSyVchLA224x
         F4gTArsHuWDwea7MBKhjyPsKhT/NvMHW599eu+vf2yjPNo4sPwijwP1YcwZfqTYNB4Fw
         P+sNLGh/VIpSIeJjeQ2RdisQFQ7Zjrj/+biQCX8z31HIXbJLxD9Vzl2S3a8TlSsJaEe2
         sGWyHdxy5yYxAHtUQ4i4A6n3axa3GyAx2Jq4+DMtpSurvARLfwY7HoApj8foMta0ZGlW
         hNxg==
X-Gm-Message-State: APjAAAUbk/ibJiACRDKZzTCW/iaK/ALg9vknD8unpZCh7HY27P0DZk78
        ekHMzDwVY8q7ac2REQgPRdwum9tbR1M=
X-Google-Smtp-Source: APXvYqwK6E1fV3qd3NM0eMoE80LVFbhqu0bmqdyCHPqY/qri01JijzdWRWX6hFwqnVrA+hwszI/pUA==
X-Received: by 2002:a05:600c:291:: with SMTP id 17mr3702699wmk.32.1562079878935;
        Tue, 02 Jul 2019 08:04:38 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b203sm3494191wmd.41.2019.07.02.08.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:04:38 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 1/3] KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS
Date:   Tue,  2 Jul 2019 17:04:34 +0200
Message-Id: <1562079876-20756-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
References: <1562079876-20756-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some secondary controls are automatically enabled/disabled based on the CPUID
values that are set for the guest.  However, they are still available at a
global level and therefore should be present when KVM_GET_MSRS is sent to
/dev/kvm.

Fixes: 1389309c811 ("KVM: nVMX: expose VMX capabilities for nested hypervisors to userspace", 2018-02-26)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 990e543f4531..c4e29ef0b21e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5750,10 +5750,15 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
 	msrs->secondary_ctls_low = 0;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
+		SECONDARY_EXEC_RDTSCP |
 		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+		SECONDARY_EXEC_WBINVD_EXITING |
 		SECONDARY_EXEC_APIC_REGISTER_VIRT |
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
-		SECONDARY_EXEC_WBINVD_EXITING;
+		SECONDARY_EXEC_RDRAND_EXITING |
+		SECONDARY_EXEC_ENABLE_INVPCID |
+		SECONDARY_EXEC_RDSEED_EXITING |
+		SECONDARY_EXEC_XSAVES;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
1.8.3.1


