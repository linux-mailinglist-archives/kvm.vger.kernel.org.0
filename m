Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CDC1FDE9
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 05:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfEPDGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 23:06:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38543 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfEPDGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 23:06:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so1027850pfb.5;
        Wed, 15 May 2019 20:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wj3VoxcHtEUUOCOJDV3/IkQEZy74zBF0y5Hje4ka4G0=;
        b=o2PFzX5XXTjHM7Is7ILyMiWkuD+EuU09jqrXKRM5ZMsgU5dg5Sby0LXSS0fAKAJ02B
         lX2fbQ1Gv8woSTm3HM/00/uobcptBPElLH1c0cC3yQ1QUNVpgbaYJ//SRL3p39PLVKA0
         G6KY01qkqMr9owywjOOzhhYULon6xMbO2lXTenA61161xnQ45wnu2IAekXKn6RuvKv6O
         xx29PAyr7OIFf4BHvldC4qat4lMUGkBKwr40klc2ndnaM4gEE32FEWZvqNoMs4ADwYhd
         xljcSPol0Bin+u08yNHly9b2n01jr7RKCwLNptDp4TyR14sISxXWH4G1WR3Taia3WQXZ
         7Q1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wj3VoxcHtEUUOCOJDV3/IkQEZy74zBF0y5Hje4ka4G0=;
        b=alhNZfAFUM6ceBVqIBxAFFHtxorbDEB4BF3vQxCzbiz4Wn109zZd7Dloi3n8MhmoQ8
         l6pTCBfdv5sb2H9WAFkbpk6qYfleB6c5e2MG9SEt7Z2YnfpB1DxG7sLCUTfI6/SX6wbz
         gcGzJs4YYnxz5wZ7AsnCJD4nNiEDwM8VTcXSle/CFn/0h2li9Ibt6zDN33t4/UX09PJU
         RAzFQpsHbJz6aY00+bEolSuNH/ERJYWX/vt81GkMpIqTxUmKUZ9zTZvLXYUli3ZZFRRV
         Y5056QUaFLka3tByyni1v3uZNRLXkv8GsVRY8QL2km5ZN00idKTYTnaPJOSrntn+OlQ6
         pYZA==
X-Gm-Message-State: APjAAAXzV2gxC1sWjqtKvRGSebhrdbrCRlJebE2k1r4M/l+AhRZ6dHLL
        UoKkU58tWzMzrop4MMUDNHAfzA3v
X-Google-Smtp-Source: APXvYqz0Ut+9EPMBpzXQyAadeV2zjf3d0jisgusL3n1EUlv85YhgFaoiro/1b7+r8p1tvKtwfcEqgw==
X-Received: by 2002:a65:56c5:: with SMTP id w5mr48170360pgs.434.1557975992125;
        Wed, 15 May 2019 20:06:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 204sm4247614pgh.50.2019.05.15.20.06.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 May 2019 20:06:31 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 3/5] KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
Date:   Thu, 16 May 2019 11:06:18 +0800
Message-Id: <1557975980-9875-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Expose per-vCPU timer_advance_ns to userspace, so it is able to 
query the auto-adjusted value.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index c19c7ed..a6f1f93 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -9,12 +9,22 @@
  */
 #include <linux/kvm_host.h>
 #include <linux/debugfs.h>
+#include "lapic.h"
 
 bool kvm_arch_has_vcpu_debugfs(void)
 {
 	return true;
 }
 
+static int vcpu_get_timer_advance_ns(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+	*val = vcpu->arch.apic->lapic_timer.timer_advance_ns;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
+
 static int vcpu_get_tsc_offset(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
@@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	if (!ret)
 		return -ENOMEM;
 
+	ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
+							vcpu->debugfs_dentry,
+							vcpu, &vcpu_timer_advance_ns_fops);
+	if (!ret)
+		return -ENOMEM;
+
 	if (kvm_has_tsc_control) {
 		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
 							vcpu->debugfs_dentry,
-- 
2.7.4

