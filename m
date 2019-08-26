Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B49D6C7
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 21:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfHZTan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 15:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729201AbfHZTan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 15:30:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C22B8D5B99;
        Mon, 26 Aug 2019 19:30:43 +0000 (UTC)
Received: from llong.com (dhcp-17-160.bos.redhat.com [10.18.17.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45EE0600C8;
        Mon, 26 Aug 2019 19:30:39 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <longman@redhat.com>
Subject: [PATCH] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if !X86_BUG_L1TF
Date:   Mon, 26 Aug 2019 15:30:23 -0400
Message-Id: <20190826193023.23293-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 26 Aug 2019 19:30:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The l1tf_vmx_mitigation is only set to VMENTER_L1D_FLUSH_NOT_REQUIRED
when the ARCH_CAPABILITIES MSR indicates that L1D flush is not required.
However, if the CPU is not affected by L1TF, l1tf_vmx_mitigation will
still be set to VMENTER_L1D_FLUSH_AUTO. This is certainly not the best
option for a !X86_BUG_L1TF CPU.

So force l1tf_vmx_mitigation to VMENTER_L1D_FLUSH_NOT_REQUIRED to make it
more explicit in case users are checking the vmentry_l1d_flush parameter.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3faa6af8..a00ce3d6bbfd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7896,6 +7896,8 @@ static int __init vmx_init(void)
 			vmx_exit();
 			return r;
 		}
+	} else {
+		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
 	}
 
 #ifdef CONFIG_KEXEC_CORE
-- 
2.18.1

